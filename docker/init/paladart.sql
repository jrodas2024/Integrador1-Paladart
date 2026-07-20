--
-- PostgreSQL database dump
--

\restrict UWis4TuwpcXczujn1agThEXnuYBeGzzle0QnKBnIscztn0HNSSej5G2BC08hgMv

-- Dumped from database version 17.10
-- Dumped by pg_dump version 17.10

-- Started on 2026-07-19 23:40:49

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16419)
-- Name: comprobantes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comprobantes (
    id_comprobante integer NOT NULL,
    id_venta integer NOT NULL,
    tipo character varying(20) NOT NULL,
    serie character varying(10) NOT NULL,
    numero character varying(20) NOT NULL,
    nombre_cliente character varying(150) NOT NULL,
    documento_cliente character varying(20) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    igv numeric(10,2) NOT NULL,
    total numeric(10,2) NOT NULL,
    fecha_emision timestamp without time zone NOT NULL
);


ALTER TABLE public.comprobantes OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16418)
-- Name: comprobantes_id_comprobante_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comprobantes_id_comprobante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comprobantes_id_comprobante_seq OWNER TO postgres;

--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 221
-- Name: comprobantes_id_comprobante_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comprobantes_id_comprobante_seq OWNED BY public.comprobantes.id_comprobante;


--
-- TOC entry 218 (class 1259 OID 16390)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id_usuario integer NOT NULL,
    nombre character varying(100) NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(100) NOT NULL,
    rol character varying(20) NOT NULL
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16389)
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.usuarios ALTER COLUMN id_usuario ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.usuarios_id_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 16398)
-- Name: ventas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ventas (
    id_venta integer NOT NULL,
    total numeric(10,2) NOT NULL,
    metodo_pago character varying(50) NOT NULL,
    CONSTRAINT ventas_total_check CHECK ((total > (0)::numeric))
);


ALTER TABLE public.ventas OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16397)
-- Name: ventas_id_venta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ventas ALTER COLUMN id_venta ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ventas_id_venta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4752 (class 2604 OID 16422)
-- Name: comprobantes id_comprobante; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comprobantes ALTER COLUMN id_comprobante SET DEFAULT nextval('public.comprobantes_id_comprobante_seq'::regclass);


--
-- TOC entry 4913 (class 0 OID 16419)
-- Dependencies: 222
-- Data for Name: comprobantes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comprobantes (id_comprobante, id_venta, tipo, serie, numero, nombre_cliente, documento_cliente, subtotal, igv, total, fecha_emision) FROM stdin;
1	1	BOLETA	B001	00000001	Julio	44602791	84.75	15.25	100.00	2026-07-19 21:05:58.980053
2	2	FACTURA	F001	00000002	Empresa prueba	12345678911	169.49	30.51	200.00	2026-07-19 21:06:17.403477
3	3	BOLETA	B001	00000003	Julio	44602791	84.75	15.25	100.00	2026-07-19 21:41:47.022571
4	4	FACTURA	F001	00000004	Empresa prueba	10446027919	84.75	15.25	100.00	2026-07-19 21:41:56.601295
5	5	BOLETA	B001	00000005	Julio		16.95	3.05	20.00	2026-07-19 22:02:50.752581
6	6	BOLETA	B001	00000006	Alexander		25.42	4.58	30.00	2026-07-19 22:13:09.704498
7	7	FACTURA	F001	00000007	Empresa prueba 2	12345678911	84.75	15.25	100.00	2026-07-19 22:47:01.076711
8	8	FACTURA	F001	00000008	Empresa prueba 3	12345678910	33.90	6.10	40.00	2026-07-19 22:47:24.142169
9	9	BOLETA	B001	00000009	Alexander	44602791	42.37	7.63	50.00	2026-07-19 22:48:10.810921
10	10	BOLETA	B001	00000010	Miguel	45602632	50.85	9.15	60.00	2026-07-19 23:14:19.819886
11	11	FACTURA	F001	00000011	Empresa prueba 4	12345678333	59.32	10.68	70.00	2026-07-19 23:15:00.283271
12	12	BOLETA	B001	00000012	Gian	74602255	67.80	12.20	80.00	2026-07-19 23:15:29.943716
13	13	FACTURA	F001	00000013	Empresa prueba 5	12345600000	84.75	15.25	100.00	2026-07-19 23:17:35.028512
14	14	BOLETA	B001	00000014	Anthony	77221152	33.90	6.10	40.00	2026-07-19 23:18:01.033644
\.


--
-- TOC entry 4909 (class 0 OID 16390)
-- Dependencies: 218
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id_usuario, nombre, username, password, rol) FROM stdin;
1	Administrador Paladart	admin	admin123	ADMIN
2	Vendedor Paladart	vendedor	vendedor123	VENDEDOR
\.


--
-- TOC entry 4911 (class 0 OID 16398)
-- Dependencies: 220
-- Data for Name: ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ventas (id_venta, total, metodo_pago) FROM stdin;
1	100.00	Efectivo
2	200.00	Yape
3	100.00	Efectivo
4	100.00	Tarjeta
5	20.00	Yape
6	30.00	Plin
7	100.00	Efectivo
8	40.00	Yape
9	50.00	Tarjeta
10	60.00	Efectivo
11	70.00	Tarjeta
12	80.00	Tarjeta
13	100.00	Yape
14	40.00	Tarjeta
\.


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 221
-- Name: comprobantes_id_comprobante_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comprobantes_id_comprobante_seq', 14, true);


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 217
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 2, true);


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 219
-- Name: ventas_id_venta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ventas_id_venta_seq', 14, true);


--
-- TOC entry 4761 (class 2606 OID 16424)
-- Name: comprobantes comprobantes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comprobantes
    ADD CONSTRAINT comprobantes_pkey PRIMARY KEY (id_comprobante);


--
-- TOC entry 4755 (class 2606 OID 16394)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 4757 (class 2606 OID 16396)
-- Name: usuarios usuarios_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


--
-- TOC entry 4759 (class 2606 OID 16403)
-- Name: ventas ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_pkey PRIMARY KEY (id_venta);


--
-- TOC entry 4762 (class 2606 OID 16425)
-- Name: comprobantes fk_comprobante_venta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comprobantes
    ADD CONSTRAINT fk_comprobante_venta FOREIGN KEY (id_venta) REFERENCES public.ventas(id_venta);


-- Completed on 2026-07-19 23:40:49

--
-- PostgreSQL database dump complete
--

\unrestrict UWis4TuwpcXczujn1agThEXnuYBeGzzle0QnKBnIscztn0HNSSej5G2BC08hgMv

