#include <unistd.h>
#include <getopt.h>
#include "test_cli_arg.h"
#include "test_init.h"

void usage()
{
    printf("-help\n");
    printf("    - Help\n");
    printf("-tc-automation <tc_automation_port,test_port,instance_id>\n");
    printf("    - Listens for test command on a TCP socket on a default address [0.0.0.0:25100]\n");
    printf("    - Value is mandatory to this option, should contain tc_automation,\n");
    printf("      test port and an instance id.\n");
    printf("    - If -tc-automation is used, then all other option gets ignored and "\
                  "directly listens on TC automation TCP socket\n");
    printf("-serv[=ip:port]\n");
    printf("    - Run as [D]TLS server\n");
    printf("-clnt[=serv_ip:serv_port]\n");
    printf("    - Run as [D]TLS clnt\n");
    printf("    - Value is server port to connect, which is optional\n");
    printf("-cauth\n");
    printf("    - Performs Client Cert Authentication\n");
    printf("-ciph\n");
    printf("    - Configure ciphersuite, currently supports only TLSv1.3\n");
    printf("    - Takes RFC defined cipher string as input\n");
    printf("    - More than one cipher are delimeted by ','\n");
    printf("    - Accepted ciphersuites by this options are:\n");
    printf("    TLSv1.3: TLS_AES_128_GCM_SHA256, TLS_AES_256_GCM_SHA384,\n");
    printf("      TLS_CHACHA20_POLY1305_SHA256, TLS_AES_128_CCM_SHA256,\n");
    printf("      TLS_AES_128_CCM_8_SHA256\n");
    printf("    TLSv1.2: TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,\n");
    printf("      TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,\n");
    printf("      TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,\n");
    printf("      TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,\n");
    printf("      TLS_RSA_WITH_AES_128_GCM_SHA256,\n");
    printf("      TLS_RSA_WITH_AES_256_GCM_SHA384\n");
    //TODO Need to add support for old ciphersuites as well
    printf("-kex <arg>\n");
    printf("    - Key Exchange group for TLS1.3\n");
    printf("    1 - All ECDHE, 2 - All FFDHE\n");
    printf("    3 - All ECDHE set using str API (SSL_set1_group_list)\n");
    printf("-cert <cert_file_name>\n");
    printf("    - By default cert file name is considered as PEM type\n");
    printf("    - If it is of different type specify in '-cert-type' option\n");
    printf("-cert-type <pem or asn>\n");
    printf("    - It takes only two values 'pem' or 'asn'\n");
    printf("-priv-key <priv_key_file>\n");
    printf("    - By default priv key file name is considered as PEM type\n");
    printf("    - If it is of different type specify in '-priv-key-type' option\n");
    printf("-priv-key-type <pem or der>\n");
    printf("    - It takes only two values 'pem' or 'der'\n");
    printf("-trust-certs <cert_file_names>\n");
    printf("    - File names are delimited by ','. And should of PEM type.\n");
    printf("-print-peer-cert\n");
    printf("    - Prints the peer cert\n");
    printf("-nbsock\n");
    printf("    - Enables non blocking on socket\n");
    printf("-res\n");
    printf("    - Performs resumption\n");
    printf("-psk <num> \n");
    printf("    - Enable PSK\n");
    printf("    1 - With PSK ID and Key with default ciphersuite\n");
    printf("    2 - With PSK ID and Key with specific ciphersuite\n");
    printf("        configured using -ciph\n");
    printf("    Here option '2' is only for out-of-band PSK in TLSv1.3.\n");
    printf("    Option '1' is for all versions of [D]TLS\n");
    printf("-earlydata\n");
    printf("    - Performs TLSv1.3 early data transfer\n");
    printf("-ver <num> \n");
    printf("    - [D]TLS Max Version on Server and Client\n");
    printf("    10 - TLS1.0, 11 - TLS1.1, 12 - TLS1.2, 13 - TLS1.3\n");
    printf("    1312 - Server TLS1.3 and Client TLS1.2\n");
    printf("    1213 - Server TLS1.2 and Client TLS1.3\n");
    printf("    910 - DTLS1.0\n");
    printf("    912 - DTLS1.2\n");
    printf("-kupda <num>\n");
    printf("    - Performs TLSv1.3 Key update\n");
    printf("    - 1 - Server initiating Key update request\n");
    printf("-infocb\n");
    printf("    - Enables TLS Info Callback\n");
    printf("-msgcb [<num>] \n");
    printf("    - Enables TLS msg Callback, argument is optional\n");
    printf("    - 1 - Enable detailed print on msg callback\n");
    printf("-memcb\n");
    printf("    - Enables Crypto mem Callback\n");
    printf("-relbuf <num>\n");
    printf("    - Enables Release TLS buffer\n");
    printf("    1 - Enable at SSL context\n");
    printf("    2 - Enable at SSL\n");
}

enum cmd_opt_id {
    OPT_HELP = 1,
    OPT_TC_AUTOMATION,
    OPT_SERV,
    OPT_CLNT,
    OPT_CAUTH,
    OPT_CIPH,
    OPT_KEX,
    OPT_CERT,
    OPT_CERT_TYPE,
    OPT_PRIV_KEY,
    OPT_PRIV_KEY_TYPE,
    OPT_TRUST_CERTS,
    OPT_PRINT_PEER_CERT,
    OPT_NBSOCK,
    OPT_RES,
    OPT_PSK,
    OPT_VER,
    OPT_KUPDA,
    OPT_EARLYDATA,
    OPT_INFOCB,
    OPT_MSGCB,
    OPT_MEMCB,
    OPT_RELBUF,
};

struct option lopts[] = {
    {"help", no_argument, NULL, OPT_HELP},
    {"tc-automation", required_argument, NULL, OPT_TC_AUTOMATION},
    {"serv", optional_argument, NULL, OPT_SERV},
    {"clnt", optional_argument, NULL, OPT_CLNT},
    /*TODO Need to take cauth arg to use type of certs */
    {"cauth", optional_argument, NULL, OPT_CAUTH},
    {"ciph", required_argument, NULL, OPT_CIPH},
    {"kex", required_argument, NULL, OPT_KEX},
    {"cert", required_argument, NULL, OPT_CERT},
    {"cert-type", required_argument, NULL, OPT_CERT_TYPE},
    {"priv-key", required_argument, NULL, OPT_PRIV_KEY},
    {"priv-key-type", required_argument, NULL, OPT_PRIV_KEY_TYPE},
    {"trust-certs", required_argument, NULL, OPT_TRUST_CERTS},
    {"print-peer-cert", no_argument, NULL, OPT_PRINT_PEER_CERT},
    {"nbsock", optional_argument, NULL, OPT_NBSOCK},
    {"res", optional_argument, NULL, OPT_RES},
    {"psk", required_argument, NULL, OPT_PSK},
    {"ver", required_argument, NULL, OPT_VER},
    {"kupda", required_argument, NULL, OPT_KUPDA},
    {"earlydata", optional_argument, NULL, OPT_EARLYDATA},
    {"infocb", no_argument, NULL, OPT_INFOCB},
    {"msgcb", optional_argument, NULL, OPT_MSGCB},
    {"memcb", optional_argument, NULL, OPT_MEMCB},
    {"relbuf", required_argument, NULL, OPT_RELBUF},
};

void set_default_cert_type(char *out) {
    if (strlen(out) == 0) {
        strcpy(out, TWT_CLI_CERT_TYPE_PEM);
    }
}

int copy_str(char *out, size_t out_buf_len, const char *in_str,
                                        const char *option_name)
{
    if (strlen(in_str) >= out_buf_len) {
        ERR("Insufficient buffer to copy %s option value of len %ld\n",
                                            option_name, strlen(in_str));
        return TWT_FAILURE;
    }
    strcpy(out, in_str);
    return TWT_SUCCESS;
}

int copy_strs(char *out, size_t out_element_count, size_t out_element_size,
              uint8_t *out_count, const char *in_str, const char *option_name)
{
    char *in, *rest, *token;
    int ret_val = TWT_FAILURE, i = 0;
    if ((in = strdup(in_str)) == NULL) {
        ERR("Duping option value string failed\n");
        return TWT_FAILURE;
    }
    rest = in;

    while ((token = strtok_r(rest, TWT_CLI_ARG_VALUE_DELIMITER, &rest)) != NULL) {
        if (strlen(token) >= out_element_size) {
            ERR("Insufficient buffer to copy %s option value of len %ld\n",
                                                option_name, strlen(token));
            goto err;
        }
        strcpy((out + (i * out_element_size)), token);
        i++;
    }
    *out_count = (uint8_t)i;
    DBG("Processed %d values for option %s\n", i, option_name);
    ret_val = TWT_SUCCESS;
err:
    free(in);
    return ret_val;
}

/* Parses CLI argument and updates values to TC_CONF
 * return : Returns 0 in case of successfully parsing or else -1
 *          Special value of 1 is returned for test automation
 *          And 2 is returned for help */
int parse_args(int argc, char **argv, TC_CONF *conf)
{
    int opt;
    int count = 0;

    /* optind should be resetted to 0 for repeatitive calls to getoptxxx with
     * different argv list */
    optind = 0;
    while ((opt = getopt_long_only(argc, argv, "", lopts, NULL)) != -1) {
        count++;
        switch (opt) {
            case OPT_HELP:
                usage();
                return TWT_CLI_HELP;
            case OPT_TC_AUTOMATION:
                conf->test_automation = 1;
                test_sock_addr_tc_automation(conf->taddr, optarg);
                return TWT_START_AUTOMATION;
            case OPT_SERV:
                conf->server = 1;
                if (optarg != NULL) {
                    if (test_sock_addr(conf->taddr, optarg) != TWT_SUCCESS) {
                        ERR("Invalid value to option -serv");
                        return TWT_FAILURE;
                    }
                }
                break;
            case OPT_CLNT:
                conf->server = 0;
                if (optarg != NULL) {
                    if (test_sock_addr_port_to_connect(conf->taddr, optarg) !=
                                                                TWT_SUCCESS) {
                        ERR("Invalid value to option -clnt");
                        return TWT_FAILURE;
                    }
                }
                break;
            case OPT_CAUTH:
                conf->auth |= TC_CONF_CLIENT_CERT_AUTH;
                break;
            case OPT_CIPH:
                if (copy_str(conf->ch.ciph, sizeof(conf->ch.ciph), optarg,
                                                "-ciph") != TWT_SUCCESS) {
                    return TWT_FAILURE;
                }
                break;
            case OPT_KEX:
                conf->kexch.kexch_conf = atoi(optarg);
                break;
            case OPT_CERT:
                if (copy_str(conf->cert, sizeof(conf->cert), optarg,
                                                "-cert") != TWT_SUCCESS) {
                    return TWT_FAILURE;
                }
                /* So that even if user not passed cert type but only passed
                 * cert file, we can consider it as by default pem */
                set_default_cert_type(conf->cert_type_str);
                break;
            case OPT_CERT_TYPE:
                if (copy_str(conf->cert_type_str, sizeof(conf->cert_type_str),
                                        optarg, "-cert-type") != TWT_SUCCESS) {
                    return TWT_FAILURE;
                }
                break;
            case OPT_PRIV_KEY:
                if (copy_str(conf->priv_key, sizeof(conf->priv_key), optarg,
                                            "-priv-key") != TWT_SUCCESS) {
                    return TWT_FAILURE;
                }
                set_default_cert_type(conf->priv_key_type_str);
                break;
            case OPT_PRIV_KEY_TYPE:
                if (copy_str(conf->priv_key_type_str,
                                    sizeof(conf->priv_key_type_str),
                                    optarg, "-priv-key-type") != TWT_SUCCESS) {
                    return TWT_FAILURE;
                }
                break;
            case OPT_TRUST_CERTS:
                if (copy_strs((char *)conf->cafiles,
                        sizeof(conf->cafiles)/sizeof(conf->cafiles[0]),
                        sizeof(conf->cafiles[0]), &conf->cafiles_count,
                        optarg, "-trust-certs") != TWT_SUCCESS) {
                    return TWT_FAILURE;
                }
                break;
            case OPT_PRINT_PEER_CERT:
                conf->print_peer_cert = 1;
            case OPT_NBSOCK:
                conf->nb_sock = 1;
                break;
            case OPT_RES:
                conf->res.resumption = 1;
                break;
            case OPT_PSK:
                conf->res.psk = atoi(optarg);
                break;
            case OPT_VER:
                conf->max_version = atoi(optarg);
                break;
            case OPT_KUPDA:
                conf->ku.key_update_test = atoi(optarg);
                break;
            case OPT_EARLYDATA:
                conf->res.early_data = 1;
                break;
            case OPT_INFOCB:
                conf->cb.info_cb = 1;
                break;
            case OPT_MSGCB:
                conf->cb.msg_cb = 1;
                if (optarg != NULL)
                    conf->cb.msg_cb_detailed = 1;
                break;
            case OPT_MEMCB:
                conf->cb.crypto_mem_cb = 1;
                break;
            case OPT_RELBUF:
                conf->ssl_mode.release_buf = (uint8_t)atoi(optarg);
                break;
            default:
                ERR("Unknown options [%d]\n", opt);
                break;
        }
    }

    DBG("Processed %d arguments successfully\n", count);
    return 0;
}
