package main

import "core:fmt"
import "core:net"
import "core:os"
import "core:strings"

main :: proc() {
	socket, sock_err := net.dial_tcp_from_hostname_and_port_string("0.0.0.0:3000")
	if sock_err != nil {
		fmt.println(sock_err)
		os.exit(1)
	}
	for {
		buf: [256]byte

		fmt.print("|> ")
		n, err := os.read(os.stdin, buf[:])
		if err < 0 {
			// Handle error
			fmt.println("connection closed")
			return
		}
		str := string(buf[:n])
		if strings.compare(str, "bye\n") == 0 {
			net.close(socket)
			return
		}
		bytes_written, send_err := net.send_tcp(socket, transmute([]byte)str)
		if send_err != nil {
			fmt.println(send_err)
			return
		}
		read_buf: [2048]byte
		bytes_read, read_err := net.recv_tcp(socket, read_buf[:])
		fmt.print("|# ")
		fmt.println(string(read_buf[:]))
	}
}
