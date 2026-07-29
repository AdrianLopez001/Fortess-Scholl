package com.techsoluctionsrn.plataforma_ensino_java.dto;

import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.PapelUsuario;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public class AuthDto {

    public static class LoginRequest {
        @NotBlank(message = "O e-mail é obrigatório")
        @Email(message = "E-mail inválido")
        private String email;

        @NotBlank(message = "A senha é obrigatória")
        private String senha;

        public LoginRequest() {}

        public LoginRequest(String email, String senha) {
            this.email = email;
            this.senha = senha;
        }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getSenha() { return senha; }
        public void setSenha(String senha) { this.senha = senha; }
    }

    public static class RegisterRequest {
        @NotBlank(message = "O nome é obrigatório")
        private String nome;

        @NotBlank(message = "O e-mail é obrigatório")
        @Email(message = "E-mail inválido")
        private String email;

        @NotBlank(message = "A senha é obrigatória")
        private String senha;

        private PapelUsuario papel = PapelUsuario.ALUNO;

        public RegisterRequest() {}

        public RegisterRequest(String nome, String email, String senha, PapelUsuario papel) {
            this.nome = nome;
            this.email = email;
            this.senha = senha;
            if (papel != null) this.papel = papel;
        }

        public String getNome() { return nome; }
        public void setNome(String nome) { this.nome = nome; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getSenha() { return senha; }
        public void setSenha(String senha) { this.senha = senha; }

        public PapelUsuario getPapel() { return papel; }
        public void setPapel(PapelUsuario papel) { this.papel = papel; }
    }

    public static class AuthResponse {
        private String token;
        private Long id;
        private String nome;
        private String email;
        private PapelUsuario papel;

        public AuthResponse() {}

        public AuthResponse(String token, Long id, String nome, String email, PapelUsuario papel) {
            this.token = token;
            this.id = id;
            this.nome = nome;
            this.email = email;
            this.papel = papel;
        }

        public String getToken() { return token; }
        public void setToken(String token) { this.token = token; }

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public String getNome() { return nome; }
        public void setNome(String nome) { this.nome = nome; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public PapelUsuario getPapel() { return papel; }
        public void setPapel(PapelUsuario papel) { this.papel = papel; }

        public static AuthResponseBuilder builder() { return new AuthResponseBuilder(); }

        public static class AuthResponseBuilder {
            private String token;
            private Long id;
            private String nome;
            private String email;
            private PapelUsuario papel;

            public AuthResponseBuilder token(String token) { this.token = token; return this; }
            public AuthResponseBuilder id(Long id) { this.id = id; return this; }
            public AuthResponseBuilder nome(String nome) { this.nome = nome; return this; }
            public AuthResponseBuilder email(String email) { this.email = email; return this; }
            public AuthResponseBuilder papel(PapelUsuario papel) { this.papel = papel; return this; }

            public AuthResponse build() {
                return new AuthResponse(token, id, nome, email, papel);
            }
        }
    }

    public static class UserDto {
        private Long id;
        private String nome;
        private String email;
        private PapelUsuario papel;

        public UserDto() {}

        public UserDto(Long id, String nome, String email, PapelUsuario papel) {
            this.id = id;
            this.nome = nome;
            this.email = email;
            this.papel = papel;
        }

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public String getNome() { return nome; }
        public void setNome(String nome) { this.nome = nome; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public PapelUsuario getPapel() { return papel; }
        public void setPapel(PapelUsuario papel) { this.papel = papel; }

        public static UserDtoBuilder builder() { return new UserDtoBuilder(); }

        public static class UserDtoBuilder {
            private Long id;
            private String nome;
            private String email;
            private PapelUsuario papel;

            public UserDtoBuilder id(Long id) { this.id = id; return this; }
            public UserDtoBuilder nome(String nome) { this.nome = nome; return this; }
            public UserDtoBuilder email(String email) { this.email = email; return this; }
            public UserDtoBuilder papel(PapelUsuario papel) { this.papel = papel; return this; }

            public UserDto build() {
                return new UserDto(id, nome, email, papel);
            }
        }
    }
}
