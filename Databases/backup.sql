--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: final_choices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.final_choices (
    investment_choices text
);


ALTER TABLE public.final_choices OWNER TO postgres;

--
-- Data for Name: final_choices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.final_choices (investment_choices) FROM stdin;
Applied Materials Inc
Becton Dickinson
Constellation Brands
D. R. Horton
FedEx Corporation
JM Smucker
McKesson Corp.
News Corp. Class A
QUALCOMM Inc.
The Walt Disney Company
\.


--
-- PostgreSQL database dump complete
--

