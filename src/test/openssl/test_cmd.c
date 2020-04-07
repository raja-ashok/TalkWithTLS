#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "errno.h"

#include "test_cmd.h"

int receive_tc(TC_AUTOMATION *ta, uint8_t *buf, size_t buf_size)
{
    int ret;
    if (((ret = recv(ta->test_fd, buf, buf_size - 1, 0)) <= 0)
            || (ret >= buf_size)) {
        printf("Test FD receive failed, ret=%d, errno=%d\n", ret, errno);
        return TWT_FAILURE;
    }
    buf[ret] = '\0';
    return TWT_SUCCESS;
}

int send_tc_result(TC_AUTOMATION *ta, uint8_t *buf, size_t buf_size)
{
    int ret;
    if ((ret = send(ta->test_fd, "success", strlen("success"), 0)) <= 0) {
        printf("Send Test result failed, ret=%d, errno=%d\n", ret, errno);
        return TWT_FAILURE;
    }
    return TWT_SUCCESS;
}