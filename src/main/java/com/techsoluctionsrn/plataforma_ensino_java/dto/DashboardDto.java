package com.techsoluctionsrn.plataforma_ensino_java.dto;

import java.util.List;

public class DashboardDto {

    public static class AlunoDashboard {
        private String nome;
        private String email;
        private int xpTotal;
        private int posicaoRanking;
        private int streakAtual; // dias consecutivos
        private int totalExerciciosResolvidos;
        private int totalModulosConcluidos;
        private List<RankingItem> ranking;

        public AlunoDashboard() {}

        public String getNome() { return nome; }
        public void setNome(String nome) { this.nome = nome; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public int getXpTotal() { return xpTotal; }
        public void setXpTotal(int xpTotal) { this.xpTotal = xpTotal; }

        public int getPosicaoRanking() { return posicaoRanking; }
        public void setPosicaoRanking(int posicaoRanking) { this.posicaoRanking = posicaoRanking; }

        public int getStreakAtual() { return streakAtual; }
        public void setStreakAtual(int streakAtual) { this.streakAtual = streakAtual; }

        public int getTotalExerciciosResolvidos() { return totalExerciciosResolvidos; }
        public void setTotalExerciciosResolvidos(int totalExerciciosResolvidos) { this.totalExerciciosResolvidos = totalExerciciosResolvidos; }

        public int getTotalModulosConcluidos() { return totalModulosConcluidos; }
        public void setTotalModulosConcluidos(int totalModulosConcluidos) { this.totalModulosConcluidos = totalModulosConcluidos; }

        public List<RankingItem> getRanking() { return ranking; }
        public void setRanking(List<RankingItem> ranking) { this.ranking = ranking; }

        public static AlunoDashboardBuilder builder() { return new AlunoDashboardBuilder(); }

        public static class AlunoDashboardBuilder {
            private String nome;
            private String email;
            private int xpTotal;
            private int posicaoRanking;
            private int streakAtual;
            private int totalExerciciosResolvidos;
            private int totalModulosConcluidos;
            private List<RankingItem> ranking;

            public AlunoDashboardBuilder nome(String nome) { this.nome = nome; return this; }
            public AlunoDashboardBuilder email(String email) { this.email = email; return this; }
            public AlunoDashboardBuilder xpTotal(int xpTotal) { this.xpTotal = xpTotal; return this; }
            public AlunoDashboardBuilder posicaoRanking(int posicaoRanking) { this.posicaoRanking = posicaoRanking; return this; }
            public AlunoDashboardBuilder streakAtual(int streakAtual) { this.streakAtual = streakAtual; return this; }
            public AlunoDashboardBuilder totalExerciciosResolvidos(int totalExerciciosResolvidos) { this.totalExerciciosResolvidos = totalExerciciosResolvidos; return this; }
            public AlunoDashboardBuilder totalModulosConcluidos(int totalModulosConcluidos) { this.totalModulosConcluidos = totalModulosConcluidos; return this; }
            public AlunoDashboardBuilder ranking(List<RankingItem> ranking) { this.ranking = ranking; return this; }

            public AlunoDashboard build() {
                AlunoDashboard d = new AlunoDashboard();
                d.setNome(nome); d.setEmail(email); d.setXpTotal(xpTotal);
                d.setPosicaoRanking(posicaoRanking); d.setStreakAtual(streakAtual);
                d.setTotalExerciciosResolvidos(totalExerciciosResolvidos);
                d.setTotalModulosConcluidos(totalModulosConcluidos);
                d.setRanking(ranking);
                return d;
            }
        }
    }

    public static class RankingItem {
        private int posicao;
        private String nome;
        private int xpTotal;
        private boolean voce;

        public RankingItem() {}
        public RankingItem(int posicao, String nome, int xpTotal, boolean voce) {
            this.posicao = posicao;
            this.nome = nome;
            this.xpTotal = xpTotal;
            this.voce = voce;
        }

        public int getPosicao() { return posicao; }
        public void setPosicao(int posicao) { this.posicao = posicao; }

        public String getNome() { return nome; }
        public void setNome(String nome) { this.nome = nome; }

        public int getXpTotal() { return xpTotal; }
        public void setXpTotal(int xpTotal) { this.xpTotal = xpTotal; }

        public boolean isVoce() { return voce; }
        public void setVoce(boolean voce) { this.voce = voce; }
    }
}
