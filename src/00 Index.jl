### A Pluto.jl notebook ###
# v0.19.42

using Markdown
using InteractiveUtils

# ╔═╡ 97f1e996-f9f6-4737-be43-7f3f25ac1cf5
begin
	materials = map(m -> (chopsuffix(chopprefix(m, r"\d\d "), ".jl"), m), filter!(f -> isfile(f) && startswith(f, r"^\d\d "), readdir(pwd())));

	raw_links = map(((d,l),) -> string("[", d, "]", "(./open?path=$(joinpath(pwd(), l)))"), materials);

	doc = "# Course materials\n"::String;
	for rl in raw_links
		global doc = doc * "- " * rl * "\n";
	end
	Markdown.parse(doc)
end

# ╔═╡ Cell order:
# ╟─97f1e996-f9f6-4737-be43-7f3f25ac1cf5
