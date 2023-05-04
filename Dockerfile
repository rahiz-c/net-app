##See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.
#
#FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
#WORKDIR /app
#EXPOSE 80
#EXPOSE 443
#
#FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
#WORKDIR /src
#COPY ["dotnetApp.csproj", "."]
#RUN dotnet restore "./dotnetApp.csproj"
#COPY . .
#WORKDIR "/src/."
#RUN dotnet build "dotnetApp.csproj" -c Release -o /app/build
#
#FROM build AS publish
#RUN dotnet publish "dotnetApp.csproj" -c Release -o /app/publish /p:UseAppHost=false
#
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "dotnetApp.dll"]

FROM mcr.microsoft.com/dotnet/sdk:6.0 as build-env
WORKDIR /src
COPY *.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish -c release -o /publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0 as runtime
WORKDIR /publish
COPY --from=build-env /publish .
EXPOSE 80
EXPOSE 4040
ENV ASPNETCORE_URLS=http://*:4040
ENTRYPOINT ["dotnet","dotnetApp.dll"]