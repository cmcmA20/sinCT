### A Pluto.jl notebook ###
# v0.19.42

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ aea9261b-9800-4d48-b4a8-e68933054d6c
begin
	using .ThMonoid
	
	md"""
	## Example models
	"""
end

# ╔═╡ 632bda3e-d7c6-425d-b7c4-00c84835fe14
begin
	import PlutoUI;
	using GATlab;
	
	PlutoUI.TableOfContents(include_definitions=true);
end

# ╔═╡ ab1bfe0e-d0ec-4c37-bbdc-0c090d006f2b
md"""
# Monoid
Monoid ``M`` consists of a **carrier** set ``X``, a distinguished element ``\varepsilon : X`` and a binary operation ``\_\bullet\_ : X \to X \to X`` subject to a bunch of axioms. The aforementioned element is called **neutral**.

## Math notation
``X : Type \dashv``

``e : X \dashv``

``x \cdot y : X \dashv x,y : X``

``e \cdot x = x \dashv x : X``

``x \cdot e = x \dashv x : X``

``(x \cdot y) \cdot z = x \cdot (y \cdot z) \dashv x, y, z : X``

## GATlab notation
```julia
@theory ThMonoid begin
  Carrier::TYPE ⊣ []

  e::Carrier ⊣ []

  @op ( ⋅ ) := compose
  compose(x, y) :: Carrier ⊣ [(x, y)::Carrier]

  idl := e() · x == x ⊣ [x::Carrier]
  idr := x · e() == x ⊣ [x::Carrier]
  assoc := ((x · y) · z) == (x · (y · z)) ⊣ [(x,y,z)::Carrier]
end

```
"""

# ╔═╡ 289a2602-5918-4758-9251-a68d0e9012e4
md"""
### Symbolic model

Pluto notebook complains, so this is just a snippet, run it in a standalone file.
```julia
import .ThMonoid: Elem
using .ThMonoid

Elem(mod::Module, args...) = Elem(mod.Elem, args...)

@symbolic_model FreeMonoidAssocUnit{GATExpr} ThMonoid begin
  mtimes(x::Elem, y::Elem) = associate_unit(new(x,y), munit)
end

x, y, z = [ Elem(FreeMonoidAssocUnit,sym) for sym in [:x,:y,:z] ]
e = munit(FreeMonoidAssocUnit.Elem)
@test mtimes(mtimes(x,y),z) == mtimes(x,mtimes(y,z))
@test mtimes(e,x) == x && mtimes(x,e) == x
```

"""

# ╔═╡ 5df1fc7d-fccf-4ba1-86bb-83923b19b602
begin
	struct IntPlusMonoid <: Model{Tuple{Int}} end
	@instance ThMonoid{Int} [model::IntPlusMonoid] begin
		e() = 0
		(x::Int · y::Int) = x + y
	end

	md"""
	### `Int` addition
	"""
end

# ╔═╡ 7fd8b871-9033-458e-b699-6b5be8d71830
begin
	struct IntTimesMonoid <: Model{Tuple{Int}} end
	@instance ThMonoid{Int} [model::IntTimesMonoid] begin
		e() = 1
		(x::Int · y::Int) = x * y
	end

	md"""
	### `Int` multiplication
	"""
end

# ╔═╡ 8602f516-e495-42f9-ab61-0f6859b7002f
begin
	struct StringMonoid <: Model{Tuple{String}} end
	@instance ThMonoid{String} [model::StringMonoid] begin
		e() = ""
		(x::String · y::String) = x * y
	end

	md"""
	### `String` concatenation
	"""
end

# ╔═╡ 36e5ef03-5057-4ca5-b269-bbc14259a647
md"""
## Playground
"""

# ╔═╡ 89f469f9-0b21-4c0d-9b0b-084b03ea0272
@bind selected_carrier PlutoUI.Select([Int => "Int", String => "String"])

# ╔═╡ fd8f53e1-c370-4a93-99a2-b6b4fa4d8540
if selected_carrier == Int
	@bind selected_model PlutoUI.Select([IntPlusMonoid => "Addition", IntTimesMonoid => "Multiplication"])
else
	@bind selected_model PlutoUI.Select([StringMonoid => "Concatenation"])
end

# ╔═╡ 249d8fd7-aa8d-4712-bf47-400aab7164e3
@bind raw_expr PlutoUI.TextField(default="2 · 7")

# ╔═╡ 0e8fc1e0-50ba-4ec5-9202-c4bd826ed489
begin
	expr = map(strip, split(raw_expr, "·"))
	if selected_carrier == Int
		expr = map(e -> parse(selected_carrier, e), expr)
	else
		expr = map(e -> string(e), expr)
	end
	
	@withmodel selected_model() (e, ·) begin
		reduce(·, expr, init=e())
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
GATlab = "f0ffcf3b-d13a-433e-917c-cc44ccf5ead2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
GATlab = "~0.1.1"
PlutoUI = "~0.7.59"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.3"
manifest_format = "2.0"
project_hash = "26830dbe8b17ac8d1cd1dbe6a4dd59d609344932"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AlgebraicInterfaces]]
git-tree-sha1 = "bee9efd33fc4401c299d5250cc4f83ced086a9be"
uuid = "23cfdc9f-0504-424a-be1f-4892b28e2f0c"
version = "0.1.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "b1c55339b7c6c350ee89f2c1604299660525b248"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.15.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.GATlab]]
deps = ["AlgebraicInterfaces", "Colors", "Crayons", "DataStructures", "JSON", "MLStyle", "Markdown", "Random", "Reexport", "StructEquality", "UUIDs"]
git-tree-sha1 = "3105f6c6083e12205e6fd533a88d5eca01a43a2d"
uuid = "f0ffcf3b-d13a-433e-917c-cc44ccf5ead2"
version = "0.1.1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MLStyle]]
git-tree-sha1 = "bc38dff0548128765760c79eb7388a4b37fae2c8"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.17"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StructEquality]]
deps = ["Compat"]
git-tree-sha1 = "192a9f1de3cfef80ab1a4ba7b150bb0e11ceedcf"
uuid = "6ec83bb0-ed9f-11e9-3b4c-2b04cb4e219c"
version = "2.1.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─ab1bfe0e-d0ec-4c37-bbdc-0c090d006f2b
# ╟─aea9261b-9800-4d48-b4a8-e68933054d6c
# ╟─289a2602-5918-4758-9251-a68d0e9012e4
# ╠═5df1fc7d-fccf-4ba1-86bb-83923b19b602
# ╠═7fd8b871-9033-458e-b699-6b5be8d71830
# ╠═8602f516-e495-42f9-ab61-0f6859b7002f
# ╟─36e5ef03-5057-4ca5-b269-bbc14259a647
# ╟─89f469f9-0b21-4c0d-9b0b-084b03ea0272
# ╟─fd8f53e1-c370-4a93-99a2-b6b4fa4d8540
# ╟─249d8fd7-aa8d-4712-bf47-400aab7164e3
# ╟─0e8fc1e0-50ba-4ec5-9202-c4bd826ed489
# ╟─632bda3e-d7c6-425d-b7c4-00c84835fe14
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
