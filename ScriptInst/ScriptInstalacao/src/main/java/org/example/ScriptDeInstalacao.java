package org.example;

import java.io.*;
import java.net.*;
import java.nio.file.*;

public class ScriptDeInstalacao {

    public static void main(String[] args) {
        try {
            // Baixar e instalar MySQL Workbench
            String mysqlWorkbenchUrl = "https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_8.0.34-1ubuntu22.04_amd64.deb";
            Path mysqlWorkbenchDestino = Paths.get("mysql-workbench.deb");
            baixarArquivo(mysqlWorkbenchUrl, mysqlWorkbenchDestino);
            executarArquivo("sudo apt install mysql-server");

            // Clonar repositório Git
            String repositorioUrl = "https://github.com/Grupo05-ADSC/Jar.git";
            Path repositorioDestino = Paths.get(System.getProperty("user.home"), "Desktop", "Jar");
            gitClone(repositorioUrl, repositorioDestino);

            Path jarArquivo = repositorioDestino.resolve("backendApplication.jar");
            if (Files.exists(jarArquivo)) {
                System.out.println("Arquivo JAR encontrado: " + jarArquivo.toString());
            } else {
                System.out.println("Arquivo JAR não encontrado no repositório clonado.");
            }

            System.out.println("Script de instalação concluído!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Função para baixar um arquivo de uma URL
    public static void baixarArquivo(String url, Path destino) throws IOException {
        try (InputStream in = new URL(url).openStream()) {
            Files.copy(in, destino, StandardCopyOption.REPLACE_EXISTING);
        }
    }

    // Função para executar um comando no Linux aguardando conclusão
    public static void executarArquivo(String comando) throws IOException {
        Process processo = Runtime.getRuntime().exec(new String[]{"/bin/bash", "-c", comando});
        try {
            int resultado = processo.waitFor();
            if (resultado != 0) {
                // Capturar a saída de erro
                BufferedReader reader = new BufferedReader(new InputStreamReader(processo.getErrorStream()));
                String linha;
                while ((linha = reader.readLine()) != null) {
                    System.err.println("Erro: " + linha);
                }
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt(); // Restaurar o estado de interrupção
            throw new IOException("O processo foi interrompido", e);
        }
    }

    // Função para clonar um repositório Git
    public static void gitClone(String repositorioUrl, Path destino) throws IOException {
        executarArquivo("git clone " + repositorioUrl + " " + destino.toString());
    }
}
