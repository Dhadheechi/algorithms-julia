### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ ccdf0c36-01b7-11f0-2b44-a5e3243f21ce
function choosefest(A, i) # choose the days starting from the ith day
	days = []
	len = length(A)
	if i == len
		# push!(days, i)
		return A[i]
	elseif i == len-1
		# push!(days, findmax(A[i], A[i+1])[2])
		return max(A[i], A[i+1])
	else 
		take = A[i] + choosefest(A, i+2) # take i and skip i+1
		skip = choosefest(A, i+1) # don't take i+1 at all; 
		choice = max(take, skip)
		return choice
	end		
end

# ╔═╡ e6a804bc-9c2d-4d3a-9d59-1c66d8413f9c
begin
	A = collect(1:30)
	@time choosefest(A, 1)
end

# ╔═╡ 6f6285ae-ef2e-4a26-ae17-4f1525254f7d
choosefest([1, 100, 1, 1, 100, 1, 1, 100, 1, 1, 100], 1)

# ╔═╡ 1bfae570-90a3-40a6-aee0-91cc322d914f
function fastchoosefest(A)
	len = length(A)
	days = zeros(len)
	for n in len:-1:1
		if n == len
			days[n] = A[n]
		elseif n == len-1
			days[n] = max(A[n], A[n+1])
		else 
			take = A[n] + days[n+2]
			skip = days[n+1]
			days[n] = max(take, skip)
		end
	end
			
	return days[1]
end	
		

# ╔═╡ d195ec0a-b5e8-4e2f-9c3c-fe41c30d8e4f
@time fastchoosefest(collect(1:30))

# ╔═╡ 4be9b3c5-c48b-4d42-92a9-9cbb6f5e5ec9
fastchoosefest([1, 100, 1, 1, 100, 1, 1, 100, 1, 1, 100])

# ╔═╡ 189cf6dc-04f0-496d-9fbc-4504d862d011
begin
   X = "bhuvanchandrakodavatikanti"
   Y = "bhavanamsathvikreddy"
end

# ╔═╡ bc692f08-6d41-40a3-802d-99475daaf74b
function lcs_bt(i,j) # length of lcs of the sequences a_i and b_j
	if i == 0 || j ==0
		return 0
	elseif X[i] == Y[j] # if the last two elements are the same, recurse for the remaining part
		return lcs_bt(i-1, j-1) +1
	else
		return max(lcs_bt(i-1, j), lcs_bt(i, j-1))
	end
end

# ╔═╡ dac8eec2-8fb4-49db-a056-1e51d0f146f3
function lcs_length(a, b)
	m = length(a)
	n = length(b)
	c = zeros(m+1, n+1)
	for j in 1:n+1
		c[1, j] = 0
	end
	for i in 2:m+1
		c[i,1] = 0
		for j in 2:n+1
			if a[i-1] == b[j-1] # c[i,j] corresponds to lcs of X_i-1 and Y_j-1
				c[i,j] = c[i-1, j-1] + 1
			else
				c[i,j] = max(c[i,j-1], c[i-1, j])
			end
		end
	end
	return c[m+1, n+1]
end
		

# ╔═╡ a2592410-954c-4af1-acba-90d9e7d7cc07
@time lcs_length(X,Y)

# ╔═╡ 1f6ccbf1-b550-4865-8659-310c5617e9f9
function lcs(a, b)
	m = length(a)
	n = length(b)
	c = zeros(m+1, n+1)
	d = fill('\\', m, n)
	for j in 1:n+1
		c[1, j] = 0
	end
	for i in 2:m+1
		c[i,1] = 0
		for j in 2:n+1
			if a[i-1] == b[j-1] # c[i,j] corresponds to lcs of X_i-1 and Y_j-1
				c[i,j] = c[i-1, j-1] + 1
				d[i-1,j-1] = '\\' # the recursive subproblem is to the left and above
			elseif c[i,j-1] >= c[i-1,j] # the recursive subproblem is to the left
				c[i,j] = c[i,j-1]
				d[i-1,j-1] = '-' 
			else
				c[i,j] = c[i-1,j]
				d[i-1,j-1] = '|' # to the top
			end
		end
	end
	return c[m+1, n+1], d
end
	

# ╔═╡ 17bb4a83-fcfe-4460-b6b7-00a307e4fb66
@time len, b = lcs(X,Y)

# ╔═╡ eb0b2d2a-6323-4100-8ba4-569e640a5efd
function print_lcs(b, X, i, j) #print the lcs of X_i and Y_j
	if i == 0 || j == 0
		return 
	end
	if b[i,j] == '\\'
		print_lcs(b, X, i-1, j-1)
		print(X[i])
	elseif b[i,j] == '|'
		print_lcs(b, X, i-1, j)
	else
		print_lcs(b, X, i, j-1)
	end
end

# ╔═╡ f1ddfb73-e168-454b-884d-c5fed19e6643
print_lcs(b, X, length(X), length(Y))

# ╔═╡ bb578e9e-3d74-4a06-85e0-4e3ebbdaccb3
function scs_bt(i,j) # length of lcs of the sequences a_i and b_j
	if i == 0 # first string is empty; second string is itself the supersequence
		return j
	elseif j == 0
		return i
	elseif X[i] == Y[j] # if the last two elements are the same, recurse for the remaining part; the last letter must be included in the scs
		return scs_bt(i-1, j-1) +1
	else
		return min(scs_bt(i-1, j), scs_bt(i, j-1)) + 1
	end
end

# ╔═╡ 6bed7794-3620-4b56-8fb0-eced82286f81
function scs(a, b)
	m = length(a)
	n = length(b)
	c = zeros(m+1, n+1)
	d = fill('\\', m, n)
	for j in 1:n+1
		c[1, j] = j # lenghth of an empty X and Y which has j characters
	end
	for i in 2:m+1
		c[i,1] = i
		for j in 2:n+1
			if a[i-1] == b[j-1] # c[i,j] corresponds to scs of X_i-1 and Y_j-1
				c[i,j] = c[i-1, j-1] + 1
				d[i-1,j-1] = '\\' # the recursive subproblem is to the left and above
			elseif c[i,j-1] >= c[i-1,j] # the recursive subproblem is to the left
				c[i,j] = c[i-1,j] + 1 # we include X[i] too
				d[i-1,j-1] = '|' 
			else
				c[i,j] = c[i,j-1] + 1 # we include Y[j] in the scs
				d[i-1,j-1] = '-' # to the top
			end
		end
	end
	return c[m+1, n+1], d
end
	

# ╔═╡ 87d3b579-081e-4547-b5b5-99855fa4b41b
function print_scs(b, X, Y, i, j) #print the scs of X_i and Y_j
	if i == 0
		print(Y[1:j])
		return
	elseif j == 0
		print(X[1:i])
		return
	end
	if b[i,j] == '\\'
		print_scs(b, X,Y, i-1, j-1)
		print(X[i])
	elseif b[i,j] == '|'
		print_scs(b, X,Y, i-1, j)
		print(X[i])
	else
		print_scs(b, X,Y, i, j-1)
		print(Y[j])
	end
end

# ╔═╡ 4b5f6744-3d1b-45d3-90fb-bc576d0770ce
@time shortest, paths = scs(X,Y)

# ╔═╡ c56b882b-f235-4912-94fe-fe0bbc1f0570
print_scs(paths, X,Y, length(X), length(Y))

# ╔═╡ 823c045f-5356-479e-993a-c7a7ed2f2744
function cut_rod(p, n)
	if n == 0
		return 0
	end
	q = -1 # current length
	for i in 1:n
		q = max(q, p[i] + cut_rod(p, n-i))
	end
	return q
end

# ╔═╡ 1164e0ed-bede-4453-874b-82a7baa82fe8
begin
	p = [1, 5, 8, 9, 10, 17, 17, 20, 24, 30, 35, 40, 43, 49, 52, 55, 60, 67, 72, 80 ,81, 82, 83, 84, 85]
	@time cut_rod(p, length(p))
end

# ╔═╡ 6e4bbc22-fddd-4620-a708-c7399ccfd47f
length(p)

# ╔═╡ d154b83d-0312-4351-b9d4-75e921a79150
function cut_rod_dp(p, n)
	c = zeros(n+1) # the first element corresponds to a rod of length 0
	c[2] = p[1]
	for i in 3:n+1
		for j in 2:i
			# println(i, j)
			c[i] = max(c[i], p[j-1] + c[i-(j-1)])
		end
	end
	return c[n+1]	
end

# ╔═╡ 07fce232-8fde-415a-b630-2b2adf579fa0
@time cut_rod_dp(p, length(p))

# ╔═╡ Cell order:
# ╠═ccdf0c36-01b7-11f0-2b44-a5e3243f21ce
# ╠═e6a804bc-9c2d-4d3a-9d59-1c66d8413f9c
# ╠═6f6285ae-ef2e-4a26-ae17-4f1525254f7d
# ╠═1bfae570-90a3-40a6-aee0-91cc322d914f
# ╠═d195ec0a-b5e8-4e2f-9c3c-fe41c30d8e4f
# ╠═4be9b3c5-c48b-4d42-92a9-9cbb6f5e5ec9
# ╠═189cf6dc-04f0-496d-9fbc-4504d862d011
# ╠═bc692f08-6d41-40a3-802d-99475daaf74b
# ╠═dac8eec2-8fb4-49db-a056-1e51d0f146f3
# ╠═a2592410-954c-4af1-acba-90d9e7d7cc07
# ╠═1f6ccbf1-b550-4865-8659-310c5617e9f9
# ╠═17bb4a83-fcfe-4460-b6b7-00a307e4fb66
# ╠═eb0b2d2a-6323-4100-8ba4-569e640a5efd
# ╠═f1ddfb73-e168-454b-884d-c5fed19e6643
# ╠═bb578e9e-3d74-4a06-85e0-4e3ebbdaccb3
# ╠═6bed7794-3620-4b56-8fb0-eced82286f81
# ╠═87d3b579-081e-4547-b5b5-99855fa4b41b
# ╠═4b5f6744-3d1b-45d3-90fb-bc576d0770ce
# ╠═c56b882b-f235-4912-94fe-fe0bbc1f0570
# ╠═823c045f-5356-479e-993a-c7a7ed2f2744
# ╠═1164e0ed-bede-4453-874b-82a7baa82fe8
# ╠═6e4bbc22-fddd-4620-a708-c7399ccfd47f
# ╠═d154b83d-0312-4351-b9d4-75e921a79150
# ╠═07fce232-8fde-415a-b630-2b2adf579fa0
