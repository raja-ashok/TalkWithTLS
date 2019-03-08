SRC_DIR=src
BIN_DIR=bin
OBJ_DIR=obj

OPENSSL = openssl
WOLFSSL = wolfssl

# Sample binaries
OPENSSL_SAMPLE_NB_CLNT = openssl_nb_client
OPENSSL_SAMPLE_NB_SERV = openssl_nb_server
OPENSSL_D12_CLNT = openssl_dtls12_client
OPENSSL_D12_SERV = openssl_dtls12_server
OPENSSL_D12_CUSTOM_BIO_CLNT = openssl_dtls12_custom_bio_client
OPENSSL_D12_NB_CLNT = openssl_dtls12_nb_client
OPENSSL_D12_NB_SERV = openssl_dtls12_nb_server
OPENSSL_T12_SERV = openssl_tls12_server
OPENSSL_T12_CLNT = openssl_tls12_client
OPENSSL_T12VERF_CB_CLNT = openssl_tls12_verify_cb_client
OPENSSL_T12VERF_CB_SERV = openssl_tls12_verify_cb_server
OPENSSL_T13CLNT = openssl_tls13_client
OPENSSL_T13SERV = openssl_tls13_server
OPENSSL_T13CLNT_DHE = openssl_tls13_dhe_client
OPENSSL_T13SERV_DHE = openssl_tls13_dhe_server
OPENSSL_T13RESUMPTION_CLNT = openssl_tls13_resumption_client
OPENSSL_T13RESUMPTION_SERV = openssl_tls13_resumption_server
WOLFSSL_T13_SERV_SAMPLE = wolfssl_tls13_server
WOLFSSL_T13_CLNT_SAMPLE = wolfssl_tls13_client

# Test binaries
TEST_OPENSSL = test_openssl

SAMPLE_BIN=$(BIN_DIR)/$(OPENSSL_SAMPLE_NB_CLNT) \
	$(BIN_DIR)/$(OPENSSL_SAMPLE_NB_SERV) \
	$(BIN_DIR)/$(OPENSSL_D12_CLNT) \
	$(BIN_DIR)/$(OPENSSL_D12_SERV) \
	$(BIN_DIR)/$(OPENSSL_D12_CUSTOM_BIO_CLNT) \
	$(BIN_DIR)/$(OPENSSL_D12_NB_CLNT) \
	$(BIN_DIR)/$(OPENSSL_D12_NB_SERV) \
	$(BIN_DIR)/$(OPENSSL_T12_CLNT) \
    $(BIN_DIR)/$(OPENSSL_T12_SERV) \
    $(BIN_DIR)/$(OPENSSL_T13CLNT_DHE) \
    $(BIN_DIR)/$(OPENSSL_T13SERV_DHE) \
    $(BIN_DIR)/$(OPENSSL_T12VERF_CB_CLNT) \
    $(BIN_DIR)/$(OPENSSL_T12VERF_CB_SERV) \
    $(BIN_DIR)/$(OPENSSL_T13CLNT) \
    $(BIN_DIR)/$(OPENSSL_T13SERV) \
    $(BIN_DIR)/$(OPENSSL_T13RESUMPTION_CLNT) \
    $(BIN_DIR)/$(OPENSSL_T13RESUMPTION_SERV) \
	$(BIN_DIR)/$(WOLFSSL_T13_SERV_SAMPLE) \
	$(BIN_DIR)/$(WOLFSSL_T13_CLNT_SAMPLE)

TEST_BIN=$(BIN_DIR)/$(TEST_OPENSSL)

TARGET=$(SAMPLE_BIN) $(TEST_BIN)

COMMON_SRC=$(SRC_DIR)/common
SAMPLE_SRC=$(SRC_DIR)/sample
TEST_OPENSSL_DIR=$(SRC_DIR)/test/openssl

COMM_SRC_FILES=$(wildcard $(COMMON_SRC)/*.c)

# Sample Code Srcs
WOLFSSL_T13_SERV_SAMPLE_SRC=$(SAMPLE_SRC)/$(WOLFSSL_T13_SERV_SAMPLE).c $(COMM_SRC_FILES)
WOLFSSL_T13_CLNT_SAMPLE_SRC=$(SAMPLE_SRC)/$(WOLFSSL_T13_CLNT_SAMPLE).c $(COMM_SRC_FILES)
OPENSSL_SAMPLE_NB_CLNT_SRC=$(SAMPLE_SRC)/$(OPENSSL_SAMPLE_NB_CLNT).c $(COMM_SRC_FILES)
OPENSSL_SAMPLE_NB_SERV_SRC=$(SAMPLE_SRC)/$(OPENSSL_SAMPLE_NB_SERV).c $(COMM_SRC_FILES)
OPENSSL_D12_CLNT_SRC=$(SAMPLE_SRC)/$(OPENSSL_D12_CLNT).c $(COMM_SRC_FILES)
OPENSSL_D12_SERV_SRC=$(SAMPLE_SRC)/$(OPENSSL_D12_SERV).c $(COMM_SRC_FILES)
OPENSSL_D12_CUSTOM_BIO_CLNT_SRC=$(SAMPLE_SRC)/$(OPENSSL_D12_CUSTOM_BIO_CLNT).c $(COMM_SRC_FILES)
OPENSSL_D12_NB_CLNT_SRC=$(SAMPLE_SRC)/$(OPENSSL_D12_NB_CLNT).c $(COMM_SRC_FILES)
OPENSSL_D12_NB_SERV_SRC=$(SAMPLE_SRC)/$(OPENSSL_D12_NB_SERV).c $(COMM_SRC_FILES)
OPENSSL_T12SERV_SRC=$(SAMPLE_SRC)/$(OPENSSL_T12_SERV).c $(COMM_SRC_FILES)
OPENSSL_T12_CLNT_SRC=$(SAMPLE_SRC)/$(OPENSSL_T12_CLNT).c $(COMM_SRC_FILES)
OPENSSL_T12SERV_SRC=$(SAMPLE_SRC)/$(OPENSSL_T12_SERV).c $(COMM_SRC_FILES)
OPENSSL_T12VERF_CB_CLNT_SRC=$(SAMPLE_SRC)/$(OPENSSL_T12VERF_CB_CLNT).c $(COMM_SRC_FILES)
OPENSSL_T12VERF_CB_SERV_SRC=$(SAMPLE_SRC)/$(OPENSSL_T12VERF_CB_SERV).c $(COMM_SRC_FILES)
OPENSSL_T13CLNT_SRC=$(SAMPLE_SRC)/$(OPENSSL_T13CLNT).c $(COMM_SRC_FILES)
OPENSSL_T13SERV_SRC=$(SAMPLE_SRC)/$(OPENSSL_T13SERV).c $(COMM_SRC_FILES)
OPENSSL_T13CLNT_DHE_SRC=$(SAMPLE_SRC)/$(OPENSSL_T13CLNT_DHE).c $(COMM_SRC_FILES)
OPENSSL_T13SERV_DHE_SRC=$(SAMPLE_SRC)/$(OPENSSL_T13SERV_DHE).c $(COMM_SRC_FILES)
OPENSSL_T13RESUMPTION_CLNT_SRC=$(SAMPLE_SRC)/$(OPENSSL_T13RESUMPTION_CLNT).c $(COMM_SRC_FILES)
OPENSSL_T13RESUMPTION_SERV_SRC=$(SAMPLE_SRC)/$(OPENSSL_T13RESUMPTION_SERV).c $(COMM_SRC_FILES)

# Test code Srcs
TEST_OPENSSL_SRC=$(wildcard $(TEST_OPENSSL_DIR)/*.c) $(COMM_SRC_FILES)

# Sample Code Objs
WOLFSSL_T13_SERV_SAMPLE_OBJ=$(addprefix $(OBJ_DIR)/,$(WOLFSSL_T13_SERV_SAMPLE_SRC:.c=.o))
WOLFSSL_T13_CLNT_SAMPLE_OBJ=$(addprefix $(OBJ_DIR)/,$(WOLFSSL_T13_CLNT_SAMPLE_SRC:.c=.o))
OPENSSL_SAMPLE_NB_CLNT_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_SAMPLE_NB_CLNT_SRC:.c=.o))
OPENSSL_SAMPLE_NB_SERV_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_SAMPLE_NB_SERV_SRC:.c=.o))
OPENSSL_D12_CLNT_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_D12_CLNT_SRC:.c=.o))
OPENSSL_D12_SERV_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_D12_SERV_SRC:.c=.o))
OPENSSL_D12_CUSTOM_BIO_CLNT_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_D12_CUSTOM_BIO_CLNT_SRC:.c=.o))
OPENSSL_D12_NB_CLNT_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_D12_NB_CLNT_SRC:.c=.o))
OPENSSL_D12_NB_SERV_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_D12_NB_SERV_SRC:.c=.o))

OPENSSL_T12_CLNT_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_T12_CLNT_SRC:.c=.o))
OPENSSL_T12SERV_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_T12SERV_SRC:.c=.o))
OPENSSL_T12VERF_CB_CLNT_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_T12VERF_CB_CLNT_SRC:.c=.o))
OPENSSL_T12VERF_CB_SERV_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_T12VERF_CB_SERV_SRC:.c=.o))
OPENSSL_T13CLNT_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_T13CLNT_SRC:.c=.o))
OPENSSL_T13SERV_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_T13SERV_SRC:.c=.o))
OPENSSL_T13CLNT_DHE_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_T13CLNT_DHE_SRC:.c=.o))
OPENSSL_T13SERV_DHE_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_T13SERV_DHE_SRC:.c=.o))
OPENSSL_T13RESUMPTION_SERV_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_T13RESUMPTION_SERV_SRC:.c=.o))
OPENSSL_T13RESUMPTION_CLNT_OBJ=$(addprefix $(OBJ_DIR)/,$(OPENSSL_T13RESUMPTION_CLNT_SRC:.c=.o))

# Test code Objs
TEST_OPENSSL_OBJ=$(addprefix $(OBJ_DIR)/,$(TEST_OPENSSL_SRC:.c=.o))

DEPENDENCY_DIR=dependency
OPENSSL_1_1_1=openssl-1.1.1a
OPENSSL_1_1_1_DIR=$(DEPENDENCY_DIR)/$(OPENSSL_1_1_1)
OPENSSL_1_1_1_LIBS=$(OPENSSL_1_1_1_DIR)/libssl.a
WOLFSSL_MASTER=wolfssl-master
WOLFSSL_DIR=$(DEPENDENCY_DIR)/$(WOLFSSL_MASTER)
WOLFSSL_LIBS=$(WOLFSSL_DIR)/src/.libs/libwolfssl.so
DEPENDENCY = $(OPENSSL_1_1_1_LIBS) $(WOLFSSL_LIBS)

# Enable leak sanitizer by default
LEAKSAN=1

ifeq ($(ADDRSAN),1)
	SANFLAGS = -fsanitize=address
endif
ifeq ($(LEAKSAN),1)
	SANFLAGS = -fsanitize=leak
endif
ifeq ($(NOSAN),1)
	SANFLAGS =
endif

CFLAGS = -g -ggdb -Wall -Werror $(SANFLAGS) -I $(COMMON_SRC)
OPENSSL_CFLAGS = $(CFLAGS) -I $(OPENSSL_1_1_1_DIR)/include
WOLFSSL_CFLAGS = $(CFLAGS) -I $(WOLFSSL_DIR)
#TEST_OPENSSL_CFLAGS = -I $(TEST_OPENSSL_DIR)

LDFLAGS = $(OPENSSL_1_1_1_DIR)/libssl.a $(OPENSSL_1_1_1_DIR)/libcrypto.a -lpthread -ldl $(SANFLAGS)
WOLFSSL_LDFLAGS = -L $(BIN_DIR) -lwolfssl $(SANFLAGS)

CC = gcc
CP = cp
RM = rm

#.PHONY all init_task clean

all : init_task $(TARGET)

$(OBJ_DIR)/$(COMMON_SRC)%.o:$(COMMON_SRC)%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/$(SAMPLE_SRC)/$(OPENSSL)%.o:$(SAMPLE_SRC)/$(OPENSSL)%.c
	$(CC) $(OPENSSL_CFLAGS) -c $< -o $@

$(OBJ_DIR)/$(SAMPLE_SRC)/$(WOLFSSL)%.o:$(SAMPLE_SRC)/$(WOLFSSL)%.c
	$(CC) $(WOLFSSL_CFLAGS) -c $< -o $@

$(OBJ_DIR)/$(TEST_OPENSSL_DIR)/%.o:$(TEST_OPENSSL_DIR)/%.c
	$(CC) $(OPENSSL_CFLAGS) $(TEST_OPENSSL_CFLAGS) -c $< -o $@

build_dependency:$(DEPENDENCY)

#TODO Add build for OpenSSL-master
#TODO Generate exes from different openssl version

$(OPENSSL_1_1_1_LIBS): $(OPENSSL_1_1_1_DIR).tar.gz
	@echo "Building $(OPENSSL_1_1_1_DIR)..."
	@cd $(DEPENDENCY_DIR) && tar -zxvf $(OPENSSL_1_1_1).tar.gz > /dev/null
	@cd $(OPENSSL_1_1_1_DIR) && ./config -d > /dev/null
	@cd $(OPENSSL_1_1_1_DIR) && make > /dev/null

WOLFSSL_CONF_ARGS=--enable-tls13 --enable-harden --enable-debug

$(WOLFSSL_LIBS): $(WOLFSSL_DIR)
	@echo "Building $(WOLFSSL_DIR)..."
	@cd $(WOLFSSL_DIR) && autoreconf -i > /dev/null
	@cd $(WOLFSSL_DIR) && ./configure $(WOLFSSL_CONF_ARGS) > /dev/null
	@cd $(WOLFSSL_DIR) && make

init_task: build_dependency
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(OBJ_DIR)/$(COMMON_SRC)
	@mkdir -p $(OBJ_DIR)/$(SAMPLE_SRC)
	@mkdir -p $(OBJ_DIR)/$(TEST_OPENSSL_DIR)
	@cp $(WOLFSSL_LIBS)* $(BIN_DIR)

$(BIN_DIR)/$(OPENSSL_SAMPLE_NB_CLNT):$(OPENSSL_SAMPLE_NB_CLNT_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_SAMPLE_NB_SERV):$(OPENSSL_SAMPLE_NB_SERV_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_D12_CLNT):$(OPENSSL_D12_CLNT_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_D12_NB_SERV):$(OPENSSL_D12_NB_SERV_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_D12_NB_CLNT):$(OPENSSL_D12_NB_CLNT_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_D12_SERV):$(OPENSSL_D12_SERV_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_D12_CUSTOM_BIO_CLNT):$(OPENSSL_D12_CUSTOM_BIO_CLNT_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_T13RESUMPTION_SERV):$(OPENSSL_T13RESUMPTION_SERV_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_T13RESUMPTION_CLNT):$(OPENSSL_T13RESUMPTION_CLNT_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_T13SERV_DHE):$(OPENSSL_T13SERV_DHE_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_T13CLNT_DHE):$(OPENSSL_T13CLNT_DHE_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_T13CLNT):$(OPENSSL_T13CLNT_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_T13SERV):$(OPENSSL_T13SERV_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_T12_CLNT):$(OPENSSL_T12_CLNT_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_T12_SERV):$(OPENSSL_T12SERV_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_T12VERF_CB_CLNT):$(OPENSSL_T12VERF_CB_CLNT_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(OPENSSL_T12VERF_CB_SERV):$(OPENSSL_T12VERF_CB_SERV_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

$(BIN_DIR)/$(WOLFSSL_T13_SERV_SAMPLE):$(WOLFSSL_T13_SERV_SAMPLE_OBJ)
	$(CC) $^ $(WOLFSSL_LDFLAGS) -o $@

$(BIN_DIR)/$(WOLFSSL_T13_CLNT_SAMPLE):$(WOLFSSL_T13_CLNT_SAMPLE_OBJ)
	$(CC) $^ $(WOLFSSL_LDFLAGS) -o $@

$(BIN_DIR)/$(TEST_OPENSSL):$(TEST_OPENSSL_OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

clean:
	@$(RM) -rf *.o *.a
	@$(RM) -rf $(TARGET)
	@$(RM) -rf $(OBJ_DIR) $(BIN_DIR)
