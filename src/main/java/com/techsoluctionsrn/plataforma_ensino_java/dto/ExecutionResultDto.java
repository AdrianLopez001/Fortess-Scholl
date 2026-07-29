package com.techsoluctionsrn.plataforma_ensino_java.dto;

import com.techsoluctionsrn.plataforma_ensino_java.domain.enums.StatusSubmissao;

public class ExecutionResultDto {
    private StatusSubmissao status;
    private String output;
    private String errorMessage;

    public ExecutionResultDto() {}

    public ExecutionResultDto(StatusSubmissao status, String output, String errorMessage) {
        this.status = status;
        this.output = output;
        this.errorMessage = errorMessage;
    }

    public StatusSubmissao getStatus() { return status; }
    public void setStatus(StatusSubmissao status) { this.status = status; }

    public String getOutput() { return output; }
    public void setOutput(String output) { this.output = output; }

    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }

    public static ExecutionResultDtoBuilder builder() { return new ExecutionResultDtoBuilder(); }

    public static class ExecutionResultDtoBuilder {
        private StatusSubmissao status;
        private String output;
        private String errorMessage;

        public ExecutionResultDtoBuilder status(StatusSubmissao status) { this.status = status; return this; }
        public ExecutionResultDtoBuilder output(String output) { this.output = output; return this; }
        public ExecutionResultDtoBuilder errorMessage(String errorMessage) { this.errorMessage = errorMessage; return this; }

        public ExecutionResultDto build() {
            return new ExecutionResultDto(status, output, errorMessage);
        }
    }
}
