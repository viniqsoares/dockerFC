FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["dockerFC.csproj", ""]
RUN dotnet restore "./dockerFC.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dockerFC.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dockerFC.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dockerFC.dll"]