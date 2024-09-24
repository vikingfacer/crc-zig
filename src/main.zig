const std = @import("std");
const testing = std.testing;

//static uint16_t compute_checksum(const char *buf, size_t size)
//{
//    /* RFC 1071 - http://tools.ietf.org/html/rfc1071 */
//
//    size_t i;
//    uint64_t sum = 0;
//
//    for (i = 0; i < size; i += 2) {
//        sum += *(uint16_t *)buf;
//        buf += 2;
//    }
//    if (size - i > 0)
//        sum += *(uint8_t *)buf;
//
//    while ((sum >> 16) != 0)
//        sum = (sum & 0xffff) + (sum >> 16);
//
//    return (uint16_t)~sum;
//}
pub fn checksum(buf: []const u8) usize {
    var sum: u64 = 0;
    for (buf) |idx| {
        sum += buf[idx];
    }
    return sum;
}
pub fn compute_checksum(arg_buf: []const u8) u16 {
    var buf = arg_buf;
    var i: usize = 0;
    var sum: u64 = 0;
    if (arg_buf.len >= 2) {
        while (arg_buf.len > i) : (i +%= 2) {
            sum +%= @as(u16, buf[i]);
        }
    }

    if ((arg_buf.len -% i) > 0) {
        sum +%= buf[i];
    }
    while ((sum >> 16) != 0) {
        sum = (sum & 0xFFFF) +% (sum >> 16);
    }
    return @as(u16, @truncate(~sum));
}

test "checksum all zeros" {
    const array = [_]u8{0} ** 1000;
    try testing.expect(0xFFFF == compute_checksum(array[0..]));
}
