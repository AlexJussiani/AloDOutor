#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["/AloDoutor.API/AloDoutor.Api.csproj", "AloDoutor.API/"]
COPY ["/AloDoutor.Core/AloDoutor.Core.csproj", "AloDoutor.Core/"]
COPY ["/AloDoutor.Infra/AloDoutor.Infra.csproj", "AloDoutor.Infra/"]
COPY ["/AloDoutor.Data/AloDoutor.Domain.csproj", "AloDoutor.Data/"]
RUN dotnet restore "AloDoutor.API\AloDoutor.Api.csproj"
COPY . .
WORKDIR "/src/AloDoutor.API"
RUN dotnet build "AloDoutor.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AloDoutor.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AloDoutor.Api.dll"]