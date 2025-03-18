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
A = [-1000 3 1 4 1 5 9 2 6 5 3 5 8 9 7 9 3 2 3 8 4 6 2 6 9 2 5 10 8 3 12]

# ╔═╡ 8ad003eb-7e4b-4044-9ca2-f7a76b25753c
begin
	len = length(A)
	subseq = []
	function lisbigger(i,j) # find the longest increasing subsequence from A[j] such that every one of them is greater than A[i]
	    if j > len
	        return 0
	    elseif A[i]>= A[j]
	        return lisbigger(i, j+1)
	    else 
	        skip = lisbigger(i,j+1)
	        take = lisbigger(j, j+1) + 1
	        # max = maximum([skip, take])
	        if take > skip
	            push!(subseq, A[j])
	        end
	        return maximum([skip, take])
	    end
	end
end

# ╔═╡ 5d853a21-db11-4caa-8fb0-8fc71d4f214f
lisbigger(1,2)

# ╔═╡ d9f04797-1804-4e2e-ae1e-141e5b619267
function lisfirst(i)
    best = 0
    for j in (i+1):len
        if A[j] > A[i]
            best = maximum([best, lisfirst(j)])
        end
    end
    return 1 + best
end

# ╔═╡ 844d7cf4-09d2-4392-b402-8718fda05d9c
lisfirst(1) - 1

# ╔═╡ 5877906e-5bb9-4c33-84d9-f8e63041ea6b
@time lisbigger(1,2)

# ╔═╡ ce58dbb3-5439-4b4a-a464-73745476e132
@time lisfirst(1) - 1

# ╔═╡ f7c3a720-69fd-4e2f-b537-ca574e5211f8
function fastlis()
	lisBigger = zeros(len+1, len+1) # only n^2 possible comparisons, put in array
	for i in 1:len
		lisBigger[i, end] = 0 # base case
	end
	for j in len:-1:1 # for each of the columns
		for i in 1:j-1
			keep = lisBigger[j, j+1] + 1
			skip = lisBigger[i, j+1]

			if A[i] >= A[j]
				lisBigger[i,j] = skip
			else
				lisBigger[i,j] = maximum([keep, skip])
			end
		end
	end

	return lisBigger[1, 2]
end
		
	
	

# ╔═╡ 61f40446-fd21-43d2-b30d-c6ad64775e77
@time fastlis()

# ╔═╡ 13a24018-2b97-44e0-b931-9e0c56682a41
function fastlis2() # build an array lisfirst(i) in decreasing index order
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
@time fastlis2()

# ╔═╡ d879974e-5abd-45d6-af1a-61406811ff97
begin
	A1 = "bhuvanchandrakodavatikanti"
	A2 = "bhavanamsathvikreddy"
end

# ╔═╡ b484642c-a11a-41af-b02a-4e2479bab866
function edit_dist(i,j)
	if i == 0
		return j
	elseif j == 0
		return i
	else
		insert = edit_dist(i-1,j) + 1
		delete = edit_dist(i,j-1) + 1
		substitute = edit_dist(i-1,j-1) + (A1[i] != A2[j])
		return minimum([insert, delete, substitute])
	end
end

# ╔═╡ 167cb60e-fba7-44d5-986a-ad9483c4268d
function fast_edit_dist()
	m = length(A1)
	n = length(A2)
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
			edit[i,j] = min(insert, delete, substitute)
		end
	end
	return edit[m+1, n+1]
end

# ╔═╡ 165d04a3-7655-4e6d-be31-d530ec634984
@time fast_edit_dist()

# ╔═╡ 451721e0-e240-402e-ba3d-bb73695eaa43
begin
	set = [11, 6, 5, 1, 7, 13, 12, 3, 14, 7, 32]
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

# ╔═╡ ce16e833-7dd4-4a68-855a-36267630b0d8
# function fast_subsetsum(set, T)
# 	n = length(set)
# 	S = fill(false, (n+1, T+1)) # i.e., from t = 0 to t = T
# 	S[n+1, 1] = true # here the index 1 corresponds to t=0
# 	for t in 2:T+1
# 		S[n+1, t] = false
# 	end

# 	for i in n:-1:1
# 		S[i, 1] = true # for t = 0, there always exists the empty set

# 		for t in 2:set[i] 
# 			if set[i] > T
# 				S[i,t] = false
# 			else
# 				S[i, t] = S[i+1, t] # avoiding the case t < X[i]
# 			end
# 		end
# 		for t in set[i]+1:T+1
# 			S[i,t] = S[i+1, t] || S[i+1, t-set[i]]
# 		end
# 	end
# 	return S[1, T+1] # here index T+1 -> value T since index 1 -> 0
# end


# ╔═╡ 97457c00-86d0-48bc-abf5-0319cff991b7
# @time fast_subsetsum(set, 15)

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
@time fast_subsetsum2(set, 15)  # Expected output: false

# ╔═╡ 55e21a8f-646f-4e8f-95de-a9b7804c3979
@time subset_sum(set, length(set), 15)

# ╔═╡ 803718f6-9fc5-4312-8105-e90f002fe35f
atan(0.1)

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
# ╠═ce16e833-7dd4-4a68-855a-36267630b0d8
# ╠═97457c00-86d0-48bc-abf5-0319cff991b7
# ╠═f7a16bbb-0bfd-44ff-b419-6823c64eeb1c
# ╠═6482daef-7130-4035-be7b-1b4a42ddfd4f
# ╠═e0d861c2-ffd6-4f87-9a83-38cbe8f1b071
# ╠═55e21a8f-646f-4e8f-95de-a9b7804c3979
# ╠═803718f6-9fc5-4312-8105-e90f002fe35f
