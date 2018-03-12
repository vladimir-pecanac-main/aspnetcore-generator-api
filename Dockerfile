# build stage
FROM microsoft/aspnetcore-build:2 AS build-env

WORKDIR /generator

# restore - consider which goes first
# can be on solution level
COPY api/api.csproj ./api/
RUN dotnet restore api/api.csproj
COPY tests/tests.csproj ./tests/
RUN dotnet restore tests/tests.csproj

# copy src
COPY . .

# test
RUN dotnet test tests/tests.csproj

# publish 
RUN dotnet publish api/api.csproj -o /publish

# runtime stage
FROM microsoft/aspnetcore:2
COPY --from=build-env /publish /publish
WORKDIR /publish
ENTRYPOINT  ["dotnet", "api.dll"]