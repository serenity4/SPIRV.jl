# To be executed for local deployment.
# Make sure you have LiveServer in your environment.
using LiveServer

servedocs(literate = "", skip_dir = joinpath("docs", "src"))
