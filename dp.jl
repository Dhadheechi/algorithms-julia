### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 186e4970-ff59-11ef-1089-4de3722abb20
begin
	function recfibo(n)
		if n == 0
			return 0
		elseif n==1
			return 1
		else
			return recfibo(n-1) + recfibo(n-2)
		end
	end
end

# ╔═╡ 98a8e9b4-801a-4d04-a1b9-908312e45ca0
@time recfibo(20)

# ╔═╡ 14399424-8851-4ecb-9bda-f003a0106c57
begin
	function iterfibo(n)
		F = zeros(n+1)
		F[1] = 0
		F[2] = 1
		for i in 3:n+1
			F[i] = F[i-1] + F[i-2]
		end
		return F[n+1]
	end
end

# ╔═╡ 35f5346e-f841-4d60-abcd-c5367b88b43b
@time iterfibo(200)

# ╔═╡ c9fd3435-31d0-4ff4-a5c2-30fc4553ded7
begin 
	function iterfibo2(n)
		previous = 1.
		current = 0. # for the base case iterfibo2(0) 
		for i in 1:n
			next = current + previous # F(n-1) + F(n-2)
			previous = current # F(n-1)
			current = next # F(n)
		end
		return current
	end
end

		

# ╔═╡ b844acb9-eed7-462c-9acc-5d4dc675a2cb
@time iterfibo2(200)

# ╔═╡ 925d3d84-0edc-46e7-baba-f25021116139
begin
	function fastrecfibo(n) # returns F(n-1), F(n)
		if n == 1
			return (0.,1.)
		end
		m = div(n,2)
		half_prev, half_curr = fastrecfibo(m)
		prev = half_prev^2 + half_curr^2
		curr = half_curr*(2*half_prev + half_curr)
		next = curr + prev
		if iseven(n)
			return (prev, curr)
		else
			return (curr, next)
		end
	end
end
			

# ╔═╡ b55b7b63-9f93-4bb2-9c96-c25cd65c1c9b
@time fastrecfibo(200)

# ╔═╡ 998fca4c-42fa-4557-a67f-6a1ebc033df6
begin
	function remove_comments(input_file, output_file)
	    open(output_file, "w") do out
	        open(input_file, "r") do file
	            for line in eachline(file)
	                if !startswith(strip(line), "#")  # Ignore commented lines
	                    println(out, line)  # Write non-commented lines to new file
	                end
	            end
	        end
	    end
	end
end

# ╔═╡ fb1dece9-7a39-40a7-91e5-8f8ebdd734f7
remove_comments("wiki-100k.txt", "cleaned_output.txt")

# ╔═╡ b6fabaaf-c453-4926-b910-e7d6c8149b13
begin
	function load_filtered_dictionary(file_path)
	    words = Set{String}()
	    open(file_path, "r") do file
	        for word in eachline(file)
	            word = strip(word)  # Remove extra spaces/newlines
	            
	            # Ignore words that are all uppercase (acronyms, abbreviations)
	            if word == uppercase(word)
	                continue
	            end
	
	            # Ignore words that are capitalized but don't appear in lowercase
	            if isuppercase(first(word)) && lowercase(word) ∉ words
	                continue
	            end
	
	            # Ignore words shorter than 2 characters (single letters)
	            if length(word) < 3
	                continue
	            end
	
	            push!(words, lowercase(word))  # Store words in lowercase
	        end
	    end
	    return words
	end
end

# ╔═╡ a2a1fde3-ea03-469b-ae38-98b9a2c78a8b
begin
str2 = "bluestemunitrobothearthandsaturnspin"
str = "fldsfoogpfjpsdigosiiogeoiasgispgispgiosdosfoisosbgosigbaososdb"
end

# ╔═╡ a7c36021-f5ed-4a5a-93a6-eb35a8152ebc
begin
	dict_path = "cleaned_output.txt"  # Path to dictionary file
	english_words = load_filtered_dictionary(dict_path)
	# Function to check if a word is valid
	function is_valid_word(i, j)
	    word_part = str[i:j]
	    return lowercase(word_part) in english_words
	end
end

# ╔═╡ bdd541ae-7d61-4c2f-96e6-65dff8ff87cf
begin
	n = length(str)
	words = []
	function splittable(i)
	    if i > n
	        return true
	    end
	    for j in i:n
	        if is_valid_word(i,j)
	            if splittable(j+1)
	                push!(words, str[i:j])
	                return true
	            end
	        end
	    end
	    return false
	end
end

# ╔═╡ 90bb0278-d48c-49c0-a6c8-837cdef2b921
@time splittable(1)

# ╔═╡ a1aef235-7846-433d-a1d3-3343b537b1ec
words

# ╔═╡ 46f3099b-4105-4ef3-9759-ede67b253ea4
begin
	function fastsplittable()
		n = length(str)
		splitTable = fill(false, n+1)
		splitTable[n+1] = true
		for i in n:-1:1
			for j in i:n
				if is_valid_word(i, j) && splitTable[j+1]
					splitTable[i] = true
				end
			end
		end
		return splitTable[1]
	end
end

# ╔═╡ 161341f3-ab83-4cbb-adfa-556fda72eadb
@time fastsplittable() #why is it taking more time?

# ╔═╡ d7bc381d-872f-43ce-89cc-220566bc746c
A = [-1000 3 1 4 1 5 9 2 6 5 3 5 8 9 7 9 3 2 3 8 4 6 2 6 9 2 5 10 8 3 1.2]

# ╔═╡ 8ad003eb-7e4b-4044-9ca2-f7a76b25753c
begin
	subseq = []
	function lisbigger(A, i,j) # find the longest increasing subsequence from A[j] such that every one of them is greater than A[i]
		len = length(A)
	    if j > len
	        return 0
	    elseif A[i]>= A[j]
	        return lisbigger(A, i, j+1)
	    else 
	        skip = lisbigger(A, i,j+1)
	        take = lisbigger(A, j, j+1) + 1
	        # max = maximum([skip, take])
	        if take > skip
	            push!(subseq, A[j])
	        end
	        return maximum([skip, take])
	    end
	end
end

# ╔═╡ 5d853a21-db11-4caa-8fb0-8fc71d4f214f
lisbigger(A, 1,2)

# ╔═╡ d9f04797-1804-4e2e-ae1e-141e5b619267
function lisfirst(A, i)
	len = length(A)
    best = 0
    for j in (i+1):len
        if A[j] > A[i]
            best = maximum([best, lisfirst(A, j)])
        end
    end
    return 1 + best
end

# ╔═╡ 844d7cf4-09d2-4392-b402-8718fda05d9c
lisfirst(A, 1) - 1

# ╔═╡ 5877906e-5bb9-4c33-84d9-f8e63041ea6b
@time lisbigger(A, 1,2)

# ╔═╡ ce58dbb3-5439-4b4a-a464-73745476e132
@time lisfirst(A, 1) - 1 # it takes lesser time if we pass in the array itself, rather than using global variables

# ╔═╡ f7c3a720-69fd-4e2f-b537-ca574e5211f8
function fastlis(A)
	len = length(A)
	lisBigger = zeros(len+1, len+1) # only n^2 possible comparisons, put in array
	for i in 1:len
		lisBigger[i, end] = 0 # base case
	end
	for j in len:-1:1 # for each of the columns
		for i in 1:j-1
			keep = lisBigger[j, j+1] + 1
			skip = lisBigger[i, j+1]

			if A[i] >= A[j] # don't use global variables
				lisBigger[i,j] = skip
			else
				lisBigger[i,j] = maximum([keep, skip])
			end
		end
	end

	return lisBigger[1, 2]
end
		
	
	

# ╔═╡ 61f40446-fd21-43d2-b30d-c6ad64775e77
@time fastlis(A)

# ╔═╡ 13a24018-2b97-44e0-b931-9e0c56682a41
function fastlis2(A) # build an array lisfirst(i) in decreasing index order
	len = length(A)
	lisFirst = zeros(len)
	for i in len:-1:1
		lisFirst[i] = 1 # length of lis starting from A[i]
		for j in i+1:len
			if A[j] > A[i] && 1 + lisFirst[j] > lisFirst[i] # lisFirst[j] is just looked up from the array instead of recursively computing it
				lisFirst[i] = 1 + lisFirst[j]
			end
		end
	end
	return lisFirst[1] - 1
end
	

# ╔═╡ 96dd5fad-3d1e-43aa-b20a-a482cabc0daa
@time fastlis2(A)

# ╔═╡ d879974e-5abd-45d6-af1a-61406811ff97
begin
	A1 = "bhuvanchandrakodavatikanti"
	A2 = "bhavanamsathvikreddy"
end

# ╔═╡ b484642c-a11a-41af-b02a-4e2479bab866
function edit_dist(A1, A2, i,j)
	if i == 0
		return j
	elseif j == 0
		return i
	else
		insert = edit_dist(A1, A2, i-1,j) + 1
		delete = edit_dist(A1, A2, i,j-1) + 1
		substitute = edit_dist(A1, A2, i-1,j-1) + (A1[i] != A2[j])
		return minimum([insert, delete, substitute])
	end
end

# ╔═╡ 167cb60e-fba7-44d5-986a-ad9483c4268d
function fast_edit_dist(A1, A2)
	m = length(A1)
	n = length(A2)
	# A1_form = repeat("a", max(m,n))
	# A2_form = "a"
	edit = zeros(m+1, n+ 1)

	for j in 1:n+1
		edit[1, j] = j-1 # shift it be one, since we mean j to go from 0 to n
	end

	for i in 2:m+1 # going through the rows (we actually mean 1 to m)
		edit[i, 1] = i-1 # i is meant ot 
		for j in 2:n+1 # (we mean j goes from 1 to n)
			insert = edit[i-1, j] + 1
			delete = edit[i, j-1] + 1
			substitute = edit[i-1, j-1] + (A1[i-1] != A2[j-1])
			mini = min(insert, delete, substitute)
			edit[i,j] = min(insert, delete, substitute)
			# if mini == insert
				
		end
	end
	return edit[m+1, n+1]
end

# ╔═╡ 165d04a3-7655-4e6d-be31-d530ec634984
@time fast_edit_dist(A1, A2)

# ╔═╡ 451721e0-e240-402e-ba3d-bb73695eaa43
begin
	set = [11, 6, 5, 1, 7, 13, 12, 3, 14, 7, 10, 4, 6, 2, 8, 4, 6, 4]
	len_set = length(set)
end

# ╔═╡ 28e116ba-3777-41c7-9876-9b5884244dcb
function subset_sum(set, len, T)
    if T == 0
        return true
    elseif T < 0 || len == 0
        return false
    else
        with = subset_sum(set, len-1, T-set[len])
        without = subset_sum(set, len-1, T)
        return (with || without)
    end
end

# ╔═╡ 364351da-e207-4b18-9dbf-f2500ff25f68
@time subset_sum(set, len_set, 15)

# ╔═╡ 0c287aac-7314-4030-9848-2a2ab8ab36b5
function construct_subset(X, i, T) # constructing a subset for X[1,...,i]
	n = length(X)
	if T == 0
		return [] # an empty set is always a subset that adds to 0
	end
	if T < 0 || i == 0 # we've reached the end 
		return nothing
	end
	Y = construct_subset(X, i-1, T)
	if Y != nothing
		return Y
	end
	Y = construct_subset(X, i-1, T-X[i])
	if Y != nothing
		push!(Y, X[i])
		return Y
	end
	return nothing
end

# ╔═╡ f19beb93-6abd-4c27-a8cb-d9de9d20d7f9
construct_subset(set, length(set), 100)

# ╔═╡ ce16e833-7dd4-4a68-855a-36267630b0d8
function fast_subsetsum(X, T)
	n = length(X)
	S = falses(n+1, T+1) # i.e., from t = 0 to t = T
	S[n+1, 1] = true # here the index 1 corresponds to t=0
	# for t in 1:T
	# 	S[n+1, t+1] = false
	# end

	for i in n:-1:1
		S[i, 1] = true # for t = 0, there always exists the empty set

		for t in 1:X[i]-1
			S[i,t+1] = S[i+1, t+1]
		end
		for t in X[i]:T # corresponds to T[X[i],..,T]
			S[i,t+1] = S[i+1, t+1] || S[i+1, t+1-X[i]]
		end
	end
	return S[1, T+1] # here index T+1 -> value T since index 1 -> 0
end
# assumption: T is bigger than any of the X[i]'s

# ╔═╡ 97457c00-86d0-48bc-abf5-0319cff991b7
@time fast_subsetsum(set, 200)

# ╔═╡ f7a16bbb-0bfd-44ff-b419-6823c64eeb1c
function fast_subsetsum2(X, T)
    n = length(X)
    S = falses(n+1, T+1)  # Initialize DP table with false
    S[n+1, 1] = true  # Base case: sum 0 is always achievable

    for i in n:-1:1
        S[i, 1] = true  # Base case: sum 0 is always achievable

        # Only iterate if X[i] ≤ T
        if X[i] ≤ T
            for t in T:-1:X[i]  
                if t - X[i] ≥ 1  # Ensuring index validity
                    S[i, t] = S[i+1, t] || S[i+1, t - X[i]]
                else
                    S[i, t] = S[i+1, t]
                end
            end
        else
            # If X[i] > T, just copy the previous row
            for t in 1:T
                S[i, t] = S[i+1, t]
            end
        end
    end
    return S[1, T]  # Return whether a subset sum of T is possible
end


# ╔═╡ 6482daef-7130-4035-be7b-1b4a42ddfd4f
# Example Worst-Case Test
begin
	X = [11, 24, 37, 50, 63, 76, 89, 102, 115, 128]  # Large numbers
	T = 20  # Impossible to form this sum
end

# ╔═╡ e0d861c2-ffd6-4f87-9a83-38cbe8f1b071
@time fast_subsetsum2(set, 200)  

# ╔═╡ 55e21a8f-646f-4e8f-95de-a9b7804c3979
@time subset_sum(set, length(set), 200)

# ╔═╡ ccf336e2-4e03-4b8b-a61b-9492103ff633
p = [30 35 15 5 10 20 25 20 40 55]

# ╔═╡ 8c2f5169-ae08-466f-a122-f644d7fb4bf0
function matrix_chain_order(i, j)
	if i == j
		return 0
	else
		min = 1e20
		for k in i:j-1 # try splitting at k
			q = matrix_chain_order(i, k) + matrix_chain_order(k+1, j) + p[i]*p[k+1]*p[j+1]
			if q < min
				min = q
			end
		end
	end
	return min
end	

# ╔═╡ a0390288-8f3f-4bc7-8b12-dd06ee465569
@time matrix_chain_order(1, length(p)-1)

# ╔═╡ 803718f6-9fc5-4312-8105-e90f002fe35f
function matrix_chain_order_dp(p, n) # n = length(p) - 1
	m = zeros(n, n) # only upper right triangle and diagonal gets filled
	s = zeros(n, n) # only upper triangle gets filled
	print(n)
	for i in 1:n
		m[i, i] = 0 # chain of length 1 has cost 0
	end
	for l in 2:n # chain length is l
		for i in 1:(n-l+1) # max value of i is _ such that (_,..., n) has length l
			# matrix chain starts at A[i]
			j = i + (l-1) # matrix chain of length l ends at A[j]
			m[i,j] = 1e20
			for k in i:j-1 # try splitting into A[1:k] and A[k+1:j]
				q = m[i,k] + m[k+1, j] + p[i]*p[k+1]*p[j+1] # the recursive calls are memoized; have chain length l-1
				if q < m[i,j]
					m[i,j] = q # remember this cost
					s[i,j] = k
				end
			end
		end
	end
	return m, s
end
		

# ╔═╡ 6ea79537-cad5-4b4f-ae48-49ecfff846c5
md"
p contains one extra number to indicate the first dimension. If there are n matrices, there are n+1 elements in the dimension array p"

# ╔═╡ 3c5a7ddc-6c6f-4f22-b410-c65b2856b33e
@time m, s = matrix_chain_order_dp(p, length(p)-1) 

# ╔═╡ 860b204b-bd96-4544-a55e-05000385c3d9
m[1, length(p)-1]

# ╔═╡ ede4c846-19eb-45a1-9649-988fd94fb1de
function print_optimal_parens(s, i, j)
	if i == j
		print("A$i")
	else 
		print("(")
		print_optimal_parens(s, i, Int(s[i,j]))
		print_optimal_parens(s, Int(s[i,j])+1, j)
		print(")")
	end
end

# ╔═╡ 9c0f3169-17d7-4972-b2f9-d9891d030303
print_optimal_parens(s, 1, length(p)-1)

# ╔═╡ 14d6ce00-1937-4295-9fb5-a484d42022e0
begin
	i = 5
	print("A₍$(i)₎")   # Produces A₍i₎ (i as a subscript)
end

# ╔═╡ 4bb76cb3-33b0-48e6-acdd-487e5f951451
# lisbigger(i,j) = max(lisbigger(i,j+1), lisbigger(j, j+1) +1) # is this next
# lisbigger(i) = max(lisbigger(j) | j > i and A[j] >A[i]) # what's next

# ╔═╡ 9871ccab-880e-4d66-b5ba-f5eab314316b
md"
Because we do not know if, in array A, the first element gets counted in the longest increasing subsequence for A, we add a very negative number (like -1000) at the start, so that that element *has* to be included in the LIS. We then call LISFIRST(A, 1) and then subtract 1 since the first element doesn't count in the actual LIS
"

# ╔═╡ 9ea54752-3905-4486-b0a4-10b22b0296c0
function fastlis2_print(A) # build an array lisfirst(i) in decreasing index order
	len = length(A)
	lisFirst = zeros(len)
	indices = zeros(len)
	# indices[len] = len
	for i in len:-1:1
		lisFirst[i] = 1 # length of lis starting from A[i]
		for j in i+1:len
			if A[j] > A[i] && 1 + lisFirst[j] > lisFirst[i] # lisFirst[j] is just looked up from the array instead of recursively computing it
				lisFirst[i] = 1 + lisFirst[j]
				indices[i] = j
			end
		end
	end
	return lisFirst[1]-1, Int.(indices)
end
	

# ╔═╡ 13428132-7d07-4ae6-b9d9-181cd87a1321
l, indices = fastlis2_print(A)

# ╔═╡ e14f8411-ceb6-4732-9613-4a63deb5ef3b
function print_lis(A, indices)
	seq = (Int64)[]
	push!(seq, A[1])
	index = indices[1]
	while index != 0
		push!(seq, A[index])
		index = indices[index] # points to a new index
	end	
	return seq[2:end]
end	


# ╔═╡ ad055845-f834-4b57-88cb-cb0d1b8552c0
@time print_lis(A, indices)

# ╔═╡ 3360aa41-1eea-43c3-b200-91351240b614
begin
	acc = [3, 4, 0, 5, 2, 7, 9, 3, -2, 5]
end

# ╔═╡ 0c24044b-39ee-4fd0-9982-efb6e7c534e2
# function lisfirst(A, i, )
# 	len = length(A)
#     best = 0
#     for j in (i+1):len
#         if A[j] > A[i]
#             best = maximum([best, lisfirst(A, j)])
#         end
#     end
#     return 1 + best
# end

# ╔═╡ abdd435f-6f97-4a6d-a0ea-7dcede818fb4
function operations_order(p) 
	nums = zeros(div(length(p), 2) + 1)
	n = length(nums)
	ops = fill("+", n- 1)
	for i in 1:length(nums)
		nums[i] = Int.(p[2*i-1])
	end
	for j in 1:length(ops)
		ops[j] = p[2*j]
	end
	
	maxs = zeros(n, n) # only upper triangle gets filled
	mins = zeros(n,n)
	maxs_p = zeros(n,n)
	mins_p = zeros(n,n)
	print(n)
	for i in 1:n
		maxs[i, i] = nums[i] # chain of length 1 has value nums[i]
		mins[i, i] = nums[i]
	end
	for l in 2:n # chain length is l
		for i in 1:(n-l+1) # max value of i is _ such that (_,..., n) has length l
			# matrix chain starts at A[i]
			j = i + (l-1) # matrix chain of length l ends at A[j]
			mins[i,j] = 1e10
			maxs[i,j] = -1e10
			for k in i:j-1 # try splitting into A[1:k] and A[k+1:j]
				if ops[k] == "-"
					temp_max = maxs[i,k] - mins[k+1, j]
					temp_min = mins[i,k] - maxs[k+1, j]

					if temp_max > maxs[i,j] # will >= be required?
						maxs[i,j] = temp_max
						maxs_p[i,j] = k
					end
					if temp_min < mins[i,j]
						mins[i,j] = temp_min
						mins_p[i,j] = k
					end
				elseif ops[k] == "+"
					temp_max = maxs[i,k] + maxs[k+1, j]
					temp_min = mins[i,k] + mins[k+1, j] # changed the sign here

					if temp_max > maxs[i,j] # will >= be required?
						maxs[i,j] = temp_max
						maxs_p[i,j] = k
					end
					if temp_min < mins[i,j]
						mins[i,j] = temp_min
						mins_p[i,j] = k
					end
				end
			end
		end
	end
	return maxs, mins, maxs_p, mins_p
end
		

# ╔═╡ 8afe6988-3eee-4292-b72e-68f24edf99cc
function print_ops_parens(A, ops, s, i, j) # print for max first
	if i == j
		print("$(A[i])")
	else 
		print("(")
		print_ops_parens(A, ops, s, i, Int(s[i,j]))
		if ops[Int(s[i,j])] == "+"
			print("+")
		elseif ops[Int(s[i,j])] == "-"
			print("-")
		end
		print_ops_parens(A, ops, s, Int(s[i,j])+1, j)
		print(")")
	end
end

# ╔═╡ b4bb6f90-157b-439c-a334-cd81c8ea8efd
begin
	# begin
	# 	exp = "1+3−2−5+1−6+7"
	# 	result = collect(m.match for m in eachmatch(r"\d+|[+-]", exp))
	# 	# println(result)  # Output: ["1", "+", "2", "-", "13", "+", "4", "-", "5"]
	# 	parsed_tokens = [isdigit(token[1]) ? parse(Int, token) : token for token in result]
	# 	parsed_tokens
	# end
	parsed_tokens = [1, "+", 3, "-", 2, "-", 5, "+", 1, "-", 6, "+", 7]
	nums = [1, 3, 2, 5, 1, 6, 7]
	ops = ["+", "-", "-", "+", "-", "+"]
end

# ╔═╡ 1d1acbe3-206e-4e42-8814-87e101519951
maxs, mins, maxs_p, mins_p = operations_order(parsed_tokens)

# ╔═╡ 5bba52ee-6abc-4cee-addd-8029a28f458b


# ╔═╡ bf39bfea-33c8-443f-908b-0b37365f67fe
maxs[1, 7], mins[1,7]

# ╔═╡ 4d87ef82-131d-4d49-b295-871bed2f8efd
(1+(3-(2-(5+((1-6)+7)))))

# ╔═╡ 9bfe0a67-cc68-4fad-812c-0ecaa31b78ac
maxs

# ╔═╡ 2218574e-3238-4018-8aa2-641945fe3638
function print_ops_parens(s, i, j)
	if i == j
		print("A$i")
	else 
		print("(")
		print_ops_parens(s, i, Int(maxs_p[i,j]))
		print_ops_parens(s, Int(maxs_[i,j])+1, j)
		print(")")
	end
end

# ╔═╡ 57f840bf-0660-4e06-ba70-39eb2da8c6db
print_ops_parens(nums, ops, maxs_p, 1, 7)

# ╔═╡ 0fab8815-3ee5-4169-a1b1-e8ceae34a21a
print_ops_parens(nums, ops, mins_p, 1, 7)

# ╔═╡ Cell order:
# ╠═186e4970-ff59-11ef-1089-4de3722abb20
# ╠═98a8e9b4-801a-4d04-a1b9-908312e45ca0
# ╠═14399424-8851-4ecb-9bda-f003a0106c57
# ╠═35f5346e-f841-4d60-abcd-c5367b88b43b
# ╠═c9fd3435-31d0-4ff4-a5c2-30fc4553ded7
# ╠═b844acb9-eed7-462c-9acc-5d4dc675a2cb
# ╠═925d3d84-0edc-46e7-baba-f25021116139
# ╠═b55b7b63-9f93-4bb2-9c96-c25cd65c1c9b
# ╠═998fca4c-42fa-4557-a67f-6a1ebc033df6
# ╠═fb1dece9-7a39-40a7-91e5-8f8ebdd734f7
# ╠═b6fabaaf-c453-4926-b910-e7d6c8149b13
# ╠═a2a1fde3-ea03-469b-ae38-98b9a2c78a8b
# ╠═a7c36021-f5ed-4a5a-93a6-eb35a8152ebc
# ╠═bdd541ae-7d61-4c2f-96e6-65dff8ff87cf
# ╠═90bb0278-d48c-49c0-a6c8-837cdef2b921
# ╠═a1aef235-7846-433d-a1d3-3343b537b1ec
# ╠═46f3099b-4105-4ef3-9759-ede67b253ea4
# ╠═161341f3-ab83-4cbb-adfa-556fda72eadb
# ╠═d7bc381d-872f-43ce-89cc-220566bc746c
# ╠═8ad003eb-7e4b-4044-9ca2-f7a76b25753c
# ╠═5d853a21-db11-4caa-8fb0-8fc71d4f214f
# ╠═d9f04797-1804-4e2e-ae1e-141e5b619267
# ╠═844d7cf4-09d2-4392-b402-8718fda05d9c
# ╠═5877906e-5bb9-4c33-84d9-f8e63041ea6b
# ╠═ce58dbb3-5439-4b4a-a464-73745476e132
# ╠═f7c3a720-69fd-4e2f-b537-ca574e5211f8
# ╠═61f40446-fd21-43d2-b30d-c6ad64775e77
# ╠═13a24018-2b97-44e0-b931-9e0c56682a41
# ╠═96dd5fad-3d1e-43aa-b20a-a482cabc0daa
# ╠═d879974e-5abd-45d6-af1a-61406811ff97
# ╠═b484642c-a11a-41af-b02a-4e2479bab866
# ╠═167cb60e-fba7-44d5-986a-ad9483c4268d
# ╠═165d04a3-7655-4e6d-be31-d530ec634984
# ╠═451721e0-e240-402e-ba3d-bb73695eaa43
# ╠═28e116ba-3777-41c7-9876-9b5884244dcb
# ╠═364351da-e207-4b18-9dbf-f2500ff25f68
# ╠═0c287aac-7314-4030-9848-2a2ab8ab36b5
# ╠═f19beb93-6abd-4c27-a8cb-d9de9d20d7f9
# ╠═ce16e833-7dd4-4a68-855a-36267630b0d8
# ╠═97457c00-86d0-48bc-abf5-0319cff991b7
# ╠═f7a16bbb-0bfd-44ff-b419-6823c64eeb1c
# ╠═6482daef-7130-4035-be7b-1b4a42ddfd4f
# ╠═e0d861c2-ffd6-4f87-9a83-38cbe8f1b071
# ╠═55e21a8f-646f-4e8f-95de-a9b7804c3979
# ╠═ccf336e2-4e03-4b8b-a61b-9492103ff633
# ╠═8c2f5169-ae08-466f-a122-f644d7fb4bf0
# ╠═a0390288-8f3f-4bc7-8b12-dd06ee465569
# ╠═803718f6-9fc5-4312-8105-e90f002fe35f
# ╟─6ea79537-cad5-4b4f-ae48-49ecfff846c5
# ╠═3c5a7ddc-6c6f-4f22-b410-c65b2856b33e
# ╠═860b204b-bd96-4544-a55e-05000385c3d9
# ╠═ede4c846-19eb-45a1-9649-988fd94fb1de
# ╠═9c0f3169-17d7-4972-b2f9-d9891d030303
# ╠═14d6ce00-1937-4295-9fb5-a484d42022e0
# ╠═4bb76cb3-33b0-48e6-acdd-487e5f951451
# ╟─9871ccab-880e-4d66-b5ba-f5eab314316b
# ╠═9ea54752-3905-4486-b0a4-10b22b0296c0
# ╠═13428132-7d07-4ae6-b9d9-181cd87a1321
# ╠═e14f8411-ceb6-4732-9613-4a63deb5ef3b
# ╠═ad055845-f834-4b57-88cb-cb0d1b8552c0
# ╠═3360aa41-1eea-43c3-b200-91351240b614
# ╠═0c24044b-39ee-4fd0-9982-efb6e7c534e2
# ╠═abdd435f-6f97-4a6d-a0ea-7dcede818fb4
# ╠═8afe6988-3eee-4292-b72e-68f24edf99cc
# ╠═b4bb6f90-157b-439c-a334-cd81c8ea8efd
# ╠═1d1acbe3-206e-4e42-8814-87e101519951
# ╠═5bba52ee-6abc-4cee-addd-8029a28f458b
# ╠═bf39bfea-33c8-443f-908b-0b37365f67fe
# ╠═57f840bf-0660-4e06-ba70-39eb2da8c6db
# ╠═0fab8815-3ee5-4169-a1b1-e8ceae34a21a
# ╠═4d87ef82-131d-4d49-b295-871bed2f8efd
# ╠═9bfe0a67-cc68-4fad-812c-0ecaa31b78ac
# ╠═2218574e-3238-4018-8aa2-641945fe3638
