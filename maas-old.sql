--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.7
-- Dumped by pg_dump version 9.5.7

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: config_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION config_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('config_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.config_create_notify() OWNER TO maas;

--
-- Name: config_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION config_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('config_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.config_delete_notify() OWNER TO maas;

--
-- Name: config_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION config_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('config_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.config_update_notify() OWNER TO maas;

--
-- Name: device_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION device_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  pnode RECORD;
BEGIN
  IF NEW.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = NEW.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_create',CAST(NEW.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.device_create_notify() OWNER TO maas;

--
-- Name: device_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION device_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  pnode RECORD;
BEGIN
  IF OLD.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = OLD.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_delete',CAST(OLD.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.device_delete_notify() OWNER TO maas;

--
-- Name: device_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION device_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  pnode RECORD;
BEGIN
  IF NEW.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = NEW.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(NEW.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.device_update_notify() OWNER TO maas;

--
-- Name: dhcpsnippet_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION dhcpsnippet_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('dhcpsnippet_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.dhcpsnippet_create_notify() OWNER TO maas;

--
-- Name: dhcpsnippet_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION dhcpsnippet_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('dhcpsnippet_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.dhcpsnippet_delete_notify() OWNER TO maas;

--
-- Name: dhcpsnippet_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION dhcpsnippet_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('dhcpsnippet_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.dhcpsnippet_update_notify() OWNER TO maas;

--
-- Name: dnsdata_domain_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION dnsdata_domain_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    dom RECORD;
BEGIN
  SELECT DISTINCT ON (domain_id) domain_id INTO dom
  FROM maasserver_dnsresource AS dnsresource
  WHERE dnsresource.id = OLD.dnsresource_id;
  PERFORM pg_notify('domain_update',CAST(dom.domain_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.dnsdata_domain_delete_notify() OWNER TO maas;

--
-- Name: dnsdata_domain_insert_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION dnsdata_domain_insert_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    dom RECORD;
BEGIN
  SELECT DISTINCT ON (domain_id) domain_id INTO dom
  FROM maasserver_dnsresource AS dnsresource
  WHERE dnsresource.id = NEW.dnsresource_id;
  PERFORM pg_notify('domain_update',CAST(dom.domain_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.dnsdata_domain_insert_notify() OWNER TO maas;

--
-- Name: dnsdata_domain_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION dnsdata_domain_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    dom RECORD;
BEGIN
  SELECT DISTINCT ON (domain_id) domain_id INTO dom
  FROM maasserver_dnsresource AS dnsresource
  WHERE dnsresource.id = OLD.dnsresource_id OR dnsresource.id = NEW.dnsresource_id;
  PERFORM pg_notify('domain_update',CAST(dom.domain_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.dnsdata_domain_update_notify() OWNER TO maas;

--
-- Name: dnsresource_domain_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION dnsresource_domain_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    domain RECORD;
BEGIN
  PERFORM pg_notify('domain_update',CAST(OLD.domain_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.dnsresource_domain_delete_notify() OWNER TO maas;

--
-- Name: dnsresource_domain_insert_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION dnsresource_domain_insert_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    domain RECORD;
BEGIN
  PERFORM pg_notify('domain_update',CAST(NEW.domain_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.dnsresource_domain_insert_notify() OWNER TO maas;

--
-- Name: dnsresource_domain_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION dnsresource_domain_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    domain RECORD;
BEGIN
  PERFORM pg_notify('domain_update',CAST(OLD.domain_id AS text));
  IF OLD.domain_id != NEW.domain_id THEN
    PERFORM pg_notify('domain_update',CAST(NEW.domain_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.dnsresource_domain_update_notify() OWNER TO maas;

--
-- Name: domain_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION domain_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('domain_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.domain_create_notify() OWNER TO maas;

--
-- Name: domain_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION domain_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('domain_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.domain_delete_notify() OWNER TO maas;

--
-- Name: domain_node_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION domain_node_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  IF OLD.name != NEW.name THEN
    FOR node IN (
      SELECT system_id, node_type, parent_id
      FROM maasserver_node
      WHERE maasserver_node.domain_id = NEW.id)
    LOOP
      IF node.system_id IS NOT NULL THEN
        IF node.node_type = 0 THEN
          PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
        ELSIF node.node_type IN (2, 3, 4) THEN
          PERFORM pg_notify(
            'controller_update',CAST(node.system_id AS text));
        ELSIF node.parent_id IS NOT NULL THEN
          SELECT system_id INTO pnode
          FROM maasserver_node
          WHERE id = node.parent_id;
          PERFORM
            pg_notify('machine_update',CAST(pnode.system_id AS text));
        ELSE
          PERFORM pg_notify('device_update',CAST(node.system_id AS text));
        END IF;
      END IF;
    END LOOP;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.domain_node_update_notify() OWNER TO maas;

--
-- Name: domain_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION domain_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('domain_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.domain_update_notify() OWNER TO maas;

--
-- Name: event_create_machine_device_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION event_create_machine_device_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node
  WHERE id = NEW.node_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.event_create_machine_device_notify() OWNER TO maas;

--
-- Name: event_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION event_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('event_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.event_create_notify() OWNER TO maas;

--
-- Name: fabric_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION fabric_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('fabric_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.fabric_create_notify() OWNER TO maas;

--
-- Name: fabric_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION fabric_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('fabric_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.fabric_delete_notify() OWNER TO maas;

--
-- Name: fabric_machine_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION fabric_machine_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    node RECORD;
    pnode RECORD;
BEGIN
  FOR node IN (
    SELECT DISTINCT ON (maasserver_node.id)
      system_id, node_type, parent_id
    FROM
      maasserver_node,
      maasserver_fabric,
      maasserver_interface,
      maasserver_vlan
    WHERE maasserver_fabric.id = NEW.id
    AND maasserver_vlan.fabric_id = maasserver_fabric.id
    AND maasserver_node.id = maasserver_interface.node_id
    AND maasserver_vlan.id = maasserver_interface.vlan_id)
  LOOP
    IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
    ELSIF node.node_type IN (2, 3, 4) THEN
      PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
    ELSIF node.parent_id IS NOT NULL THEN
      SELECT system_id INTO pnode
      FROM maasserver_node
      WHERE id = node.parent_id;
      PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
    ELSE
      PERFORM pg_notify('device_update',CAST(node.system_id AS text));
    END IF;
  END LOOP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.fabric_machine_update_notify() OWNER TO maas;

--
-- Name: fabric_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION fabric_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('fabric_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.fabric_update_notify() OWNER TO maas;

--
-- Name: ipaddress_domain_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION ipaddress_domain_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  dom RECORD;
BEGIN
  FOR dom IN (
    SELECT DISTINCT ON (domain.id)
      domain.id
    FROM maasserver_staticipaddress AS staticipaddress
    LEFT JOIN (
      maasserver_interface_ip_addresses AS iia
      JOIN maasserver_interface AS interface ON
        iia.interface_id = interface.id
      JOIN maasserver_node AS node ON
        node.id = interface.node_id) ON
      iia.staticipaddress_id = staticipaddress.id
    LEFT JOIN (
      maasserver_dnsresource_ip_addresses AS dia
      JOIN maasserver_dnsresource AS dnsresource ON
        dia.dnsresource_id = dnsresource.id) ON
      dia.staticipaddress_id = staticipaddress.id
    JOIN maasserver_domain AS domain ON
      domain.id = node.domain_id OR domain.id = dnsresource.domain_id
    WHERE staticipaddress.id = OLD.id)
  LOOP
    PERFORM pg_notify('domain_update',CAST(dom.id AS text));
  END LOOP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.ipaddress_domain_delete_notify() OWNER TO maas;

--
-- Name: ipaddress_domain_insert_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION ipaddress_domain_insert_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  dom RECORD;
BEGIN
  FOR dom IN (
    SELECT DISTINCT ON (domain.id)
      domain.id
    FROM maasserver_staticipaddress AS staticipaddress
    LEFT JOIN (
      maasserver_interface_ip_addresses AS iia
      JOIN maasserver_interface AS interface ON
        iia.interface_id = interface.id
      JOIN maasserver_node AS node ON
        node.id = interface.node_id) ON
      iia.staticipaddress_id = staticipaddress.id
    LEFT JOIN (
      maasserver_dnsresource_ip_addresses AS dia
      JOIN maasserver_dnsresource AS dnsresource ON
        dia.dnsresource_id = dnsresource.id) ON
      dia.staticipaddress_id = staticipaddress.id
    JOIN maasserver_domain AS domain ON
      domain.id = node.domain_id OR domain.id = dnsresource.domain_id
    WHERE staticipaddress.id = NEW.id)
  LOOP
    PERFORM pg_notify('domain_update',CAST(dom.id AS text));
  END LOOP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.ipaddress_domain_insert_notify() OWNER TO maas;

--
-- Name: ipaddress_domain_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION ipaddress_domain_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  dom RECORD;
BEGIN
  IF ((OLD.ip IS NULL and NEW.ip IS NOT NULL) OR
        (OLD.ip IS NOT NULL and NEW.ip IS NULL) OR
        OLD.ip != NEW.ip) THEN
    FOR dom IN (
      SELECT DISTINCT ON (domain.id)
        domain.id
      FROM maasserver_staticipaddress AS staticipaddress
      LEFT JOIN (
        maasserver_interface_ip_addresses AS iia
        JOIN maasserver_interface AS interface ON
          iia.interface_id = interface.id
        JOIN maasserver_node AS node ON
          node.id = interface.node_id) ON
        iia.staticipaddress_id = staticipaddress.id
      LEFT JOIN (
        maasserver_dnsresource_ip_addresses AS dia
        JOIN maasserver_dnsresource AS dnsresource ON
          dia.dnsresource_id = dnsresource.id) ON
        dia.staticipaddress_id = staticipaddress.id
      JOIN maasserver_domain AS domain ON
        domain.id = node.domain_id OR domain.id = dnsresource.domain_id
      WHERE staticipaddress.id = OLD.id OR staticipaddress.id = NEW.id)
    LOOP
      PERFORM pg_notify('domain_update',CAST(dom.id AS text));
    END LOOP;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.ipaddress_domain_update_notify() OWNER TO maas;

--
-- Name: ipaddress_machine_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION ipaddress_machine_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    node RECORD;
    pnode RECORD;
BEGIN
  FOR node IN (
    SELECT DISTINCT ON (maasserver_node.id)
      system_id, node_type, parent_id
    FROM
      maasserver_node,
      maasserver_interface,
      maasserver_interface_ip_addresses AS ip_link
    WHERE ip_link.staticipaddress_id = NEW.id
    AND ip_link.interface_id = maasserver_interface.id
    AND maasserver_node.id = maasserver_interface.node_id)
  LOOP
    IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
    ELSIF node.node_type IN (2, 3, 4) THEN
      PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
    ELSIF node.parent_id IS NOT NULL THEN
      SELECT system_id INTO pnode
      FROM maasserver_node
      WHERE id = node.parent_id;
      PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
    ELSE
      PERFORM pg_notify('device_update',CAST(node.system_id AS text));
    END IF;
  END LOOP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.ipaddress_machine_update_notify() OWNER TO maas;

--
-- Name: ipaddress_subnet_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION ipaddress_subnet_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.subnet_id != NEW.subnet_id THEN
    IF OLD.subnet_id IS NOT NULL THEN
      PERFORM pg_notify('subnet_update',CAST(OLD.subnet_id AS text));
    END IF;
  END IF;
  IF NEW.subnet_id IS NOT NULL THEN
    PERFORM pg_notify('subnet_update',CAST(NEW.subnet_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.ipaddress_subnet_update_notify() OWNER TO maas;

--
-- Name: iprange_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION iprange_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('iprange_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.iprange_create_notify() OWNER TO maas;

--
-- Name: iprange_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION iprange_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('iprange_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.iprange_delete_notify() OWNER TO maas;

--
-- Name: iprange_subnet_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION iprange_subnet_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.subnet_id IS NOT NULL THEN
    PERFORM pg_notify('subnet_update',CAST(OLD.subnet_id AS text));
  END IF;
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.iprange_subnet_delete_notify() OWNER TO maas;

--
-- Name: iprange_subnet_insert_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION iprange_subnet_insert_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.subnet_id IS NOT NULL THEN
    PERFORM pg_notify('subnet_update',CAST(NEW.subnet_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.iprange_subnet_insert_notify() OWNER TO maas;

--
-- Name: iprange_subnet_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION iprange_subnet_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.subnet_id != NEW.subnet_id THEN
    IF OLD.subnet_id IS NOT NULL THEN
      PERFORM pg_notify('subnet_update',CAST(OLD.subnet_id AS text));
    END IF;
  END IF;
  IF NEW.subnet_id IS NOT NULL THEN
    PERFORM pg_notify('subnet_update',CAST(NEW.subnet_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.iprange_subnet_update_notify() OWNER TO maas;

--
-- Name: iprange_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION iprange_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('iprange_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.iprange_update_notify() OWNER TO maas;

--
-- Name: machine_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION machine_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('machine_create',CAST(NEW.system_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.machine_create_notify() OWNER TO maas;

--
-- Name: machine_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION machine_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('machine_delete',CAST(OLD.system_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.machine_delete_notify() OWNER TO maas;

--
-- Name: machine_device_tag_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION machine_device_tag_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node
  WHERE id = NEW.node_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.machine_device_tag_link_notify() OWNER TO maas;

--
-- Name: machine_device_tag_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION machine_device_tag_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node
  WHERE id = OLD.node_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.machine_device_tag_unlink_notify() OWNER TO maas;

--
-- Name: machine_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION machine_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('machine_update',CAST(NEW.system_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.machine_update_notify() OWNER TO maas;

--
-- Name: nd_blockdevice_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_blockdevice_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node
  WHERE id = NEW.node_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(
      node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_blockdevice_link_notify() OWNER TO maas;

--
-- Name: nd_blockdevice_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_blockdevice_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node
  WHERE id = OLD.node_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(
      node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_blockdevice_unlink_notify() OWNER TO maas;

--
-- Name: nd_blockdevice_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_blockdevice_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node
  WHERE id = NEW.node_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(
      node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_blockdevice_update_notify() OWNER TO maas;

--
-- Name: nd_cacheset_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_cacheset_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node,
       maasserver_blockdevice,
       maasserver_partition,
       maasserver_partitiontable,
       maasserver_filesystem
  WHERE maasserver_node.id = maasserver_blockdevice.node_id
  AND maasserver_blockdevice.id = maasserver_partitiontable.block_device_id
  AND maasserver_partitiontable.id =
      maasserver_partition.partition_table_id
  AND maasserver_partition.id = maasserver_filesystem.partition_id
  AND maasserver_filesystem.cache_set_id = NEW.id;

  IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_cacheset_link_notify() OWNER TO maas;

--
-- Name: nd_cacheset_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_cacheset_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node,
       maasserver_blockdevice,
       maasserver_partition,
       maasserver_partitiontable,
       maasserver_filesystem
  WHERE maasserver_node.id = maasserver_blockdevice.node_id
  AND maasserver_blockdevice.id = maasserver_partitiontable.block_device_id
  AND maasserver_partitiontable.id =
      maasserver_partition.partition_table_id
  AND maasserver_partition.id = maasserver_filesystem.partition_id
  AND maasserver_filesystem.cache_set_id = OLD.id;

  IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_cacheset_unlink_notify() OWNER TO maas;

--
-- Name: nd_cacheset_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_cacheset_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node,
       maasserver_blockdevice,
       maasserver_partition,
       maasserver_partitiontable,
       maasserver_filesystem
  WHERE maasserver_node.id = maasserver_blockdevice.node_id
  AND maasserver_blockdevice.id = maasserver_partitiontable.block_device_id
  AND maasserver_partitiontable.id =
      maasserver_partition.partition_table_id
  AND maasserver_partition.id = maasserver_filesystem.partition_id
  AND maasserver_filesystem.cache_set_id = NEW.id;

  IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_cacheset_update_notify() OWNER TO maas;

--
-- Name: nd_filesystem_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_filesystem_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  IF NEW.block_device_id IS NOT NULL
  THEN
    SELECT system_id, node_type INTO node
      FROM maasserver_node,
           maasserver_blockdevice
     WHERE maasserver_node.id = maasserver_blockdevice.node_id
       AND maasserver_blockdevice.id = NEW.block_device_id;
  ELSIF NEW.partition_id IS NOT NULL
  THEN
    SELECT system_id, node_type INTO node
      FROM maasserver_node,
           maasserver_blockdevice,
           maasserver_partition,
           maasserver_partitiontable
     WHERE maasserver_node.id = maasserver_blockdevice.node_id
       AND maasserver_blockdevice.id =
           maasserver_partitiontable.block_device_id
       AND maasserver_partitiontable.id =
           maasserver_partition.partition_table_id
       AND maasserver_partition.id = NEW.partition_id;
  ELSIF NEW.node_id IS NOT NULL
  THEN
    SELECT system_id, node_type INTO node
      FROM maasserver_node
     WHERE maasserver_node.id = NEW.node_id;
  END IF;

  IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update', CAST(node.system_id AS text));
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_filesystem_link_notify() OWNER TO maas;

--
-- Name: nd_filesystem_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_filesystem_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  IF OLD.block_device_id IS NOT NULL
  THEN
    SELECT system_id, node_type INTO node
      FROM maasserver_node,
           maasserver_blockdevice
     WHERE maasserver_node.id = maasserver_blockdevice.node_id
       AND maasserver_blockdevice.id = OLD.block_device_id;
  ELSIF OLD.partition_id IS NOT NULL
  THEN
    SELECT system_id, node_type INTO node
      FROM maasserver_node,
           maasserver_blockdevice,
           maasserver_partition,
           maasserver_partitiontable
     WHERE maasserver_node.id = maasserver_blockdevice.node_id
       AND maasserver_blockdevice.id =
           maasserver_partitiontable.block_device_id
       AND maasserver_partitiontable.id =
           maasserver_partition.partition_table_id
       AND maasserver_partition.id = OLD.partition_id;
  ELSIF OLD.node_id IS NOT NULL
  THEN
    SELECT system_id, node_type INTO node
      FROM maasserver_node
     WHERE maasserver_node.id = OLD.node_id;
  END IF;

  IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update', CAST(node.system_id AS text));
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_filesystem_unlink_notify() OWNER TO maas;

--
-- Name: nd_filesystem_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_filesystem_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  IF NEW.block_device_id IS NOT NULL
  THEN
    SELECT system_id, node_type INTO node
      FROM maasserver_node,
           maasserver_blockdevice
     WHERE maasserver_node.id = maasserver_blockdevice.node_id
       AND maasserver_blockdevice.id = NEW.block_device_id;
  ELSIF NEW.partition_id IS NOT NULL
  THEN
    SELECT system_id, node_type INTO node
      FROM maasserver_node,
           maasserver_blockdevice,
           maasserver_partition,
           maasserver_partitiontable
     WHERE maasserver_node.id = maasserver_blockdevice.node_id
       AND maasserver_blockdevice.id =
           maasserver_partitiontable.block_device_id
       AND maasserver_partitiontable.id =
           maasserver_partition.partition_table_id
       AND maasserver_partition.id = NEW.partition_id;
  ELSIF NEW.node_id IS NOT NULL
  THEN
    SELECT system_id, node_type INTO node
      FROM maasserver_node
     WHERE maasserver_node.id = NEW.node_id;
  END IF;

  IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update', CAST(node.system_id AS text));
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_filesystem_update_notify() OWNER TO maas;

--
-- Name: nd_filesystemgroup_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_filesystemgroup_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node,
       maasserver_blockdevice,
       maasserver_partition,
       maasserver_partitiontable,
       maasserver_filesystem
  WHERE maasserver_node.id = maasserver_blockdevice.node_id
  AND maasserver_blockdevice.id = maasserver_partitiontable.block_device_id
  AND maasserver_partitiontable.id =
      maasserver_partition.partition_table_id
  AND maasserver_partition.id = maasserver_filesystem.partition_id
  AND (maasserver_filesystem.filesystem_group_id = NEW.id
      OR maasserver_filesystem.cache_set_id = NEW.cache_set_id);

  IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_filesystemgroup_link_notify() OWNER TO maas;

--
-- Name: nd_filesystemgroup_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_filesystemgroup_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node,
       maasserver_blockdevice,
       maasserver_partition,
       maasserver_partitiontable,
       maasserver_filesystem
  WHERE maasserver_node.id = maasserver_blockdevice.node_id
  AND maasserver_blockdevice.id = maasserver_partitiontable.block_device_id
  AND maasserver_partitiontable.id =
      maasserver_partition.partition_table_id
  AND maasserver_partition.id = maasserver_filesystem.partition_id
  AND (maasserver_filesystem.filesystem_group_id = OLD.id
      OR maasserver_filesystem.cache_set_id = OLD.cache_set_id);

  IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_filesystemgroup_unlink_notify() OWNER TO maas;

--
-- Name: nd_filesystemgroup_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_filesystemgroup_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node,
       maasserver_blockdevice,
       maasserver_partition,
       maasserver_partitiontable,
       maasserver_filesystem
  WHERE maasserver_node.id = maasserver_blockdevice.node_id
  AND maasserver_blockdevice.id = maasserver_partitiontable.block_device_id
  AND maasserver_partitiontable.id =
      maasserver_partition.partition_table_id
  AND maasserver_partition.id = maasserver_filesystem.partition_id
  AND (maasserver_filesystem.filesystem_group_id = NEW.id
      OR maasserver_filesystem.cache_set_id = NEW.cache_set_id);

  IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_filesystemgroup_update_notify() OWNER TO maas;

--
-- Name: nd_interface_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_interface_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node
  WHERE id = NEW.node_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(
      node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_interface_link_notify() OWNER TO maas;

--
-- Name: nd_interface_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_interface_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node
  WHERE id = OLD.node_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(
      node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_interface_unlink_notify() OWNER TO maas;

--
-- Name: nd_interface_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_interface_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  IF OLD.node_id != NEW.node_id THEN
    SELECT system_id, node_type, parent_id INTO node
    FROM maasserver_node
    WHERE id = OLD.node_id;

    IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
    ELSIF node.node_type IN (2, 3, 4) THEN
      PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
    ELSIF node.parent_id IS NOT NULL THEN
      SELECT system_id INTO pnode
      FROM maasserver_node
      WHERE id = node.parent_id;
      PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
    ELSE
      PERFORM pg_notify('device_update',CAST(node.system_id AS text));
    END IF;
  END IF;

  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node
  WHERE id = NEW.node_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_interface_update_notify() OWNER TO maas;

--
-- Name: nd_partition_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_partition_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node,
       maasserver_blockdevice,
       maasserver_partitiontable
  WHERE maasserver_node.id = maasserver_blockdevice.node_id
  AND maasserver_blockdevice.id = maasserver_partitiontable.block_device_id
  AND maasserver_partitiontable.id = NEW.partition_table_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_partition_link_notify() OWNER TO maas;

--
-- Name: nd_partition_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_partition_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node,
       maasserver_blockdevice,
       maasserver_partitiontable
  WHERE maasserver_node.id = maasserver_blockdevice.node_id
  AND maasserver_blockdevice.id = maasserver_partitiontable.block_device_id
  AND maasserver_partitiontable.id = OLD.partition_table_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_partition_unlink_notify() OWNER TO maas;

--
-- Name: nd_partition_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_partition_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node,
       maasserver_blockdevice,
       maasserver_partitiontable
  WHERE maasserver_node.id = maasserver_blockdevice.node_id
  AND maasserver_blockdevice.id = maasserver_partitiontable.block_device_id
  AND maasserver_partitiontable.id = NEW.partition_table_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_partition_update_notify() OWNER TO maas;

--
-- Name: nd_partitiontable_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_partitiontable_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node, maasserver_blockdevice
    WHERE maasserver_node.id = maasserver_blockdevice.node_id
    AND maasserver_blockdevice.id = NEW.block_device_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_partitiontable_link_notify() OWNER TO maas;

--
-- Name: nd_partitiontable_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_partitiontable_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node, maasserver_blockdevice
    WHERE maasserver_node.id = maasserver_blockdevice.node_id
    AND maasserver_blockdevice.id = OLD.block_device_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_partitiontable_unlink_notify() OWNER TO maas;

--
-- Name: nd_partitiontable_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_partitiontable_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node, maasserver_blockdevice
    WHERE maasserver_node.id = maasserver_blockdevice.node_id
    AND maasserver_blockdevice.id = NEW.block_device_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_partitiontable_update_notify() OWNER TO maas;

--
-- Name: nd_physblockdevice_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_physblockdevice_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node, maasserver_blockdevice
  WHERE maasserver_node.id = maasserver_blockdevice.node_id
  AND maasserver_blockdevice.id = NEW.blockdevice_ptr_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_physblockdevice_update_notify() OWNER TO maas;

--
-- Name: nd_scriptresult_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_scriptresult_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT
    system_id, node_type INTO node
  FROM
    maasserver_node AS nodet,
    metadataserver_scriptset AS scriptset
  WHERE
    scriptset.id = NEW.script_set_id AND
    scriptset.node_id = nodet.id;
  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify(
      'controller_update',CAST(node.system_id AS text));
  ELSIF node.node_type = 1 THEN
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_scriptresult_link_notify() OWNER TO maas;

--
-- Name: nd_scriptresult_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_scriptresult_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT
    system_id, node_type INTO node
  FROM
    maasserver_node AS nodet,
    metadataserver_scriptset AS scriptset
  WHERE
    scriptset.id = OLD.script_set_id AND
    scriptset.node_id = nodet.id;
  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify(
      'controller_update',CAST(node.system_id AS text));
  ELSIF node.node_type = 1 THEN
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_scriptresult_unlink_notify() OWNER TO maas;

--
-- Name: nd_scriptresult_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_scriptresult_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT
    system_id, node_type INTO node
  FROM
    maasserver_node AS nodet,
    metadataserver_scriptset AS scriptset
  WHERE
    scriptset.id = NEW.script_set_id AND
    scriptset.node_id = nodet.id;
  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify(
      'controller_update',CAST(node.system_id AS text));
  ELSIF node.node_type = 1 THEN
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_scriptresult_update_notify() OWNER TO maas;

--
-- Name: nd_scriptset_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_scriptset_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node
  WHERE id = NEW.node_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(
      node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_scriptset_link_notify() OWNER TO maas;

--
-- Name: nd_scriptset_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_scriptset_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node
  WHERE id = OLD.node_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(
      node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_scriptset_unlink_notify() OWNER TO maas;

--
-- Name: nd_sipaddress_dns_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_sipaddress_dns_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  domain RECORD;
BEGIN
  SELECT maasserver_domain.id INTO domain
  FROM maasserver_node, maasserver_interface, maasserver_domain
  WHERE maasserver_node.id = maasserver_interface.node_id
  AND maasserver_domain.id = maasserver_node.domain_id
  AND maasserver_interface.id = NEW.interface_id;

  IF domain.id IS NOT NULL THEN
    PERFORM pg_notify('domain_update',CAST(domain.id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_sipaddress_dns_link_notify() OWNER TO maas;

--
-- Name: nd_sipaddress_dns_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_sipaddress_dns_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  domain RECORD;
BEGIN
  SELECT maasserver_domain.id INTO domain
  FROM maasserver_node, maasserver_interface, maasserver_domain
  WHERE maasserver_node.id = maasserver_interface.node_id
  AND maasserver_domain.id = maasserver_node.domain_id
  AND maasserver_interface.id = OLD.interface_id;

  IF domain.id IS NOT NULL THEN
    PERFORM pg_notify('domain_update',CAST(domain.id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_sipaddress_dns_unlink_notify() OWNER TO maas;

--
-- Name: nd_sipaddress_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_sipaddress_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node, maasserver_interface
  WHERE maasserver_node.id = maasserver_interface.node_id
  AND maasserver_interface.id = NEW.interface_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_sipaddress_link_notify() OWNER TO maas;

--
-- Name: nd_sipaddress_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_sipaddress_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  SELECT system_id, node_type, parent_id INTO node
  FROM maasserver_node, maasserver_interface
  WHERE maasserver_node.id = maasserver_interface.node_id
  AND maasserver_interface.id = OLD.interface_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  ELSIF node.node_type IN (2, 3, 4) THEN
    PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
  ELSIF node.parent_id IS NOT NULL THEN
    SELECT system_id INTO pnode
    FROM maasserver_node
    WHERE id = node.parent_id;
    PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
  ELSE
    PERFORM pg_notify('device_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_sipaddress_unlink_notify() OWNER TO maas;

--
-- Name: nd_virtblockdevice_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION nd_virtblockdevice_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
BEGIN
  SELECT system_id, node_type INTO node
  FROM maasserver_node, maasserver_blockdevice
  WHERE maasserver_node.id = maasserver_blockdevice.node_id
  AND maasserver_blockdevice.id = NEW.blockdevice_ptr_id;

  IF node.node_type = 0 THEN
    PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.nd_virtblockdevice_update_notify() OWNER TO maas;

--
-- Name: neighbour_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION neighbour_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('neighbour_create',CAST(NEW.ip AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.neighbour_create_notify() OWNER TO maas;

--
-- Name: neighbour_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION neighbour_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('neighbour_delete',CAST(OLD.ip AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.neighbour_delete_notify() OWNER TO maas;

--
-- Name: neighbour_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION neighbour_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('neighbour_update',CAST(NEW.ip AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.neighbour_update_notify() OWNER TO maas;

--
-- Name: node_pod_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION node_pod_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  bmc RECORD;
BEGIN
  IF OLD.bmc_id IS NOT NULL THEN
    SELECT * INTO bmc FROM maasserver_bmc WHERE id = OLD.bmc_id;
    IF bmc.bmc_type = 1 THEN
      PERFORM pg_notify('pod_update',CAST(OLD.bmc_id AS text));
    END IF;
  END IF;
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.node_pod_delete_notify() OWNER TO maas;

--
-- Name: node_pod_insert_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION node_pod_insert_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  bmc RECORD;
BEGIN
  IF NEW.bmc_id IS NOT NULL THEN
    SELECT * INTO bmc FROM maasserver_bmc WHERE id = NEW.bmc_id;
    IF bmc.bmc_type = 1 THEN
      PERFORM pg_notify('pod_update',CAST(NEW.bmc_id AS text));
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.node_pod_insert_notify() OWNER TO maas;

--
-- Name: node_pod_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION node_pod_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  bmc RECORD;
BEGIN
  IF ((OLD.bmc_id IS NULL and NEW.bmc_id IS NOT NULL) OR
      (OLD.bmc_id IS NOT NULL and NEW.bmc_id IS NULL) OR
      OLD.bmc_id != NEW.bmc_id) THEN
    IF OLD.bmc_id IS NOT NULL THEN
      SELECT * INTO bmc FROM maasserver_bmc WHERE id = OLD.bmc_id;
      IF bmc.bmc_type = 1 THEN
        PERFORM pg_notify('pod_update',CAST(OLD.bmc_id AS text));
      END IF;
    END IF;
  END IF;
  IF NEW.bmc_id IS NOT NULL THEN
    SELECT * INTO bmc FROM maasserver_bmc WHERE id = NEW.bmc_id;
    IF bmc.bmc_type = 1 THEN
      PERFORM pg_notify('pod_update',CAST(NEW.bmc_id AS text));
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.node_pod_update_notify() OWNER TO maas;

--
-- Name: node_type_change_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION node_type_change_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF (OLD.node_type != NEW.node_type AND NOT (
      (
        OLD.node_type = 2 OR
        OLD.node_type = 3 OR
        OLD.node_type = 4
      ) AND (
        NEW.node_type = 2 OR
        NEW.node_type = 3 OR
        NEW.node_type = 4
      ))) THEN
    CASE OLD.node_type
      WHEN 0 THEN
        PERFORM pg_notify('machine_delete',CAST(
          OLD.system_id AS TEXT));
      WHEN 1 THEN
        PERFORM pg_notify('device_delete',CAST(
          OLD.system_id AS TEXT));
      WHEN 2 THEN
        PERFORM pg_notify('controller_delete',CAST(
          OLD.system_id AS TEXT));
      WHEN 3 THEN
        PERFORM pg_notify('controller_delete',CAST(
          OLD.system_id AS TEXT));
      WHEN 4 THEN
        PERFORM pg_notify('controller_delete',CAST(
          OLD.system_id AS TEXT));
    END CASE;
    CASE NEW.node_type
      WHEN 0 THEN
        PERFORM pg_notify('machine_create',CAST(
          NEW.system_id AS TEXT));
      WHEN 1 THEN
        PERFORM pg_notify('device_create',CAST(
          NEW.system_id AS TEXT));
      WHEN 2 THEN
        PERFORM pg_notify('controller_create',CAST(
          NEW.system_id AS TEXT));
      WHEN 3 THEN
        PERFORM pg_notify('controller_create',CAST(
          NEW.system_id AS TEXT));
      WHEN 4 THEN
        PERFORM pg_notify('controller_create',CAST(
          NEW.system_id AS TEXT));
    END CASE;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.node_type_change_notify() OWNER TO maas;

--
-- Name: notification_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION notification_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('notification_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notification_create_notify() OWNER TO maas;

--
-- Name: notification_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION notification_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('notification_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notification_delete_notify() OWNER TO maas;

--
-- Name: notification_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION notification_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('notification_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notification_update_notify() OWNER TO maas;

--
-- Name: notificationdismissal_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION notificationdismissal_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify(
      'notificationdismissal_create', CAST(NEW.notification_id AS text) || ':' ||
      CAST(NEW.user_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notificationdismissal_create_notify() OWNER TO maas;

--
-- Name: packagerepository_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION packagerepository_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('packagerepository_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.packagerepository_create_notify() OWNER TO maas;

--
-- Name: packagerepository_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION packagerepository_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('packagerepository_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.packagerepository_delete_notify() OWNER TO maas;

--
-- Name: packagerepository_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION packagerepository_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('packagerepository_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.packagerepository_update_notify() OWNER TO maas;

--
-- Name: pod_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION pod_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.bmc_type = 1 THEN
      PERFORM pg_notify('pod_delete',CAST(OLD.id AS text));
  END IF;
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.pod_delete_notify() OWNER TO maas;

--
-- Name: pod_insert_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION pod_insert_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.bmc_type = 1 THEN
    PERFORM pg_notify('pod_create',CAST(NEW.id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.pod_insert_notify() OWNER TO maas;

--
-- Name: pod_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION pod_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.bmc_type = NEW.bmc_type THEN
    IF OLD.bmc_type = 1 THEN
      PERFORM pg_notify('pod_update',CAST(OLD.id AS text));
    END IF;
  ELSIF OLD.bmc_type = 0 AND NEW.bmc_type = 1 THEN
      PERFORM pg_notify('pod_create',CAST(NEW.id AS text));
  ELSIF OLD.bmc_type = 1 AND NEW.bmc_type = 0 THEN
      PERFORM pg_notify('pod_delete',CAST(OLD.id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.pod_update_notify() OWNER TO maas;

--
-- Name: rack_controller_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION rack_controller_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('controller_create',CAST(NEW.system_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.rack_controller_create_notify() OWNER TO maas;

--
-- Name: rack_controller_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION rack_controller_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('controller_delete',CAST(OLD.system_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.rack_controller_delete_notify() OWNER TO maas;

--
-- Name: rack_controller_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION rack_controller_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('controller_update',CAST(NEW.system_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.rack_controller_update_notify() OWNER TO maas;

--
-- Name: region_and_rack_controller_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION region_and_rack_controller_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('controller_create',CAST(NEW.system_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.region_and_rack_controller_create_notify() OWNER TO maas;

--
-- Name: region_and_rack_controller_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION region_and_rack_controller_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('controller_delete',CAST(OLD.system_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.region_and_rack_controller_delete_notify() OWNER TO maas;

--
-- Name: region_and_rack_controller_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION region_and_rack_controller_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('controller_update',CAST(NEW.system_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.region_and_rack_controller_update_notify() OWNER TO maas;

--
-- Name: region_controller_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION region_controller_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('controller_create',CAST(NEW.system_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.region_controller_create_notify() OWNER TO maas;

--
-- Name: region_controller_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION region_controller_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('controller_delete',CAST(OLD.system_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.region_controller_delete_notify() OWNER TO maas;

--
-- Name: region_controller_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION region_controller_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('controller_update',CAST(NEW.system_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.region_controller_update_notify() OWNER TO maas;

--
-- Name: rrset_sipaddress_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION rrset_sipaddress_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  domain RECORD;
BEGIN
  SELECT maasserver_domain.id INTO domain
  FROM maasserver_dnsresource, maasserver_domain
  WHERE maasserver_domain.id = maasserver_dnsresource.domain_id
  AND maasserver_dnsresource.id = NEW.dnsresource_id;

  IF domain.id IS NOT NULL THEN
    PERFORM pg_notify('domain_update',CAST(domain.id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.rrset_sipaddress_link_notify() OWNER TO maas;

--
-- Name: rrset_sipaddress_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION rrset_sipaddress_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  domain RECORD;
BEGIN
  SELECT maasserver_domain.id INTO domain
  FROM maasserver_dnsresource, maasserver_domain
  WHERE maasserver_domain.id = maasserver_dnsresource.domain_id
  AND maasserver_dnsresource.id = OLD.dnsresource_id;

  IF domain.id IS NOT NULL THEN
    PERFORM pg_notify('domain_update',CAST(domain.id AS text));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.rrset_sipaddress_unlink_notify() OWNER TO maas;

--
-- Name: script_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION script_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('script_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.script_create_notify() OWNER TO maas;

--
-- Name: script_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION script_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('script_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.script_delete_notify() OWNER TO maas;

--
-- Name: script_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION script_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('script_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.script_update_notify() OWNER TO maas;

--
-- Name: service_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION service_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('service_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.service_create_notify() OWNER TO maas;

--
-- Name: service_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION service_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('service_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.service_delete_notify() OWNER TO maas;

--
-- Name: service_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION service_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('service_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.service_update_notify() OWNER TO maas;

--
-- Name: space_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION space_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('space_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.space_create_notify() OWNER TO maas;

--
-- Name: space_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION space_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('space_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.space_delete_notify() OWNER TO maas;

--
-- Name: space_machine_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION space_machine_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    node RECORD;
    pnode RECORD;
BEGIN
  FOR node IN (
    SELECT DISTINCT ON (maasserver_node.id)
      system_id, node_type, parent_id
    FROM
      maasserver_node,
      maasserver_space,
      maasserver_subnet,
      maasserver_vlan,
      maasserver_interface,
      maasserver_interface_ip_addresses AS ip_link,
      maasserver_staticipaddress
    WHERE maasserver_space.id = NEW.id
    AND maasserver_subnet.vlan_id = maasserver_vlan.id
    AND maasserver_vlan.space_id IS NOT DISTINCT FROM maasserver_space.id
    AND maasserver_staticipaddress.subnet_id = maasserver_subnet.id
    AND ip_link.staticipaddress_id = maasserver_staticipaddress.id
    AND ip_link.interface_id = maasserver_interface.id
    AND maasserver_node.id = maasserver_interface.node_id)
  LOOP
    IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
    ELSIF node.node_type IN (2, 3, 4) THEN
      PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
    ELSIF node.parent_id IS NOT NULL THEN
      SELECT system_id INTO pnode
      FROM maasserver_node
      WHERE id = node.parent_id;
      PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
    ELSE
      PERFORM pg_notify('device_update',CAST(node.system_id AS text));
    END IF;
  END LOOP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.space_machine_update_notify() OWNER TO maas;

--
-- Name: space_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION space_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('space_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.space_update_notify() OWNER TO maas;

--
-- Name: sshkey_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sshkey_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('sshkey_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sshkey_create_notify() OWNER TO maas;

--
-- Name: sshkey_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sshkey_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('sshkey_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sshkey_delete_notify() OWNER TO maas;

--
-- Name: sshkey_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sshkey_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('sshkey_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sshkey_update_notify() OWNER TO maas;

--
-- Name: staticroute_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION staticroute_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('staticroute_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.staticroute_create_notify() OWNER TO maas;

--
-- Name: staticroute_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION staticroute_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('staticroute_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.staticroute_delete_notify() OWNER TO maas;

--
-- Name: staticroute_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION staticroute_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('staticroute_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.staticroute_update_notify() OWNER TO maas;

--
-- Name: subnet_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION subnet_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('subnet_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.subnet_create_notify() OWNER TO maas;

--
-- Name: subnet_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION subnet_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('subnet_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.subnet_delete_notify() OWNER TO maas;

--
-- Name: subnet_machine_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION subnet_machine_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    node RECORD;
    pnode RECORD;
BEGIN
  FOR node IN (
    SELECT DISTINCT ON (maasserver_node.id)
      system_id, node_type, parent_id
    FROM
      maasserver_node,
      maasserver_subnet,
      maasserver_interface,
      maasserver_interface_ip_addresses AS ip_link,
      maasserver_staticipaddress
    WHERE maasserver_subnet.id = NEW.id
    AND maasserver_staticipaddress.subnet_id = maasserver_subnet.id
    AND ip_link.staticipaddress_id = maasserver_staticipaddress.id
    AND ip_link.interface_id = maasserver_interface.id
    AND maasserver_node.id = maasserver_interface.node_id)
  LOOP
    IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
    ELSIF node.node_type IN (2, 3, 4) THEN
      PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
    ELSIF node.parent_id IS NOT NULL THEN
      SELECT system_id INTO pnode
      FROM maasserver_node
      WHERE id = node.parent_id;
      PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
    ELSE
      PERFORM pg_notify('device_update',CAST(node.system_id AS text));
    END IF;
  END LOOP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.subnet_machine_update_notify() OWNER TO maas;

--
-- Name: subnet_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION subnet_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('subnet_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.subnet_update_notify() OWNER TO maas;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: maasserver_regioncontrollerprocess; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_regioncontrollerprocess (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    pid integer NOT NULL,
    region_id integer NOT NULL
);


ALTER TABLE maasserver_regioncontrollerprocess OWNER TO maas;

--
-- Name: sys_core_get_managing_count(maasserver_regioncontrollerprocess); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_core_get_managing_count(process maasserver_regioncontrollerprocess) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN (SELECT count(*)
    FROM maasserver_node
    WHERE maasserver_node.managing_process_id = process.id);
END;
$$;


ALTER FUNCTION public.sys_core_get_managing_count(process maasserver_regioncontrollerprocess) OWNER TO maas;

--
-- Name: maasserver_node; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_node (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    system_id character varying(41) NOT NULL,
    hostname character varying(255) NOT NULL,
    status integer NOT NULL,
    bios_boot_method character varying(31),
    osystem character varying(255) NOT NULL,
    distro_series character varying(255) NOT NULL,
    architecture character varying(31),
    min_hwe_kernel character varying(31),
    hwe_kernel character varying(31),
    agent_name character varying(255),
    error_description text NOT NULL,
    cpu_count integer NOT NULL,
    memory integer NOT NULL,
    swap_size bigint,
    instance_power_parameters text NOT NULL,
    power_state character varying(10) NOT NULL,
    power_state_updated timestamp with time zone,
    error character varying(255) NOT NULL,
    netboot boolean NOT NULL,
    license_key character varying(30),
    boot_cluster_ip inet,
    enable_ssh boolean NOT NULL,
    skip_networking boolean NOT NULL,
    skip_storage boolean NOT NULL,
    boot_interface_id integer,
    gateway_link_ipv4_id integer,
    gateway_link_ipv6_id integer,
    owner_id integer,
    parent_id integer,
    token_id integer,
    zone_id integer NOT NULL,
    boot_disk_id integer,
    node_type integer NOT NULL,
    domain_id integer,
    dns_process_id integer,
    bmc_id integer,
    address_ttl integer,
    status_expires timestamp with time zone,
    power_state_queried timestamp with time zone,
    url character varying(255) NOT NULL,
    managing_process_id integer,
    last_image_sync timestamp with time zone,
    previous_status integer NOT NULL,
    default_user character varying(32) NOT NULL,
    cpu_speed integer NOT NULL,
    current_commissioning_script_set_id integer,
    current_installation_script_set_id integer,
    current_testing_script_set_id integer,
    creation_type integer NOT NULL,
    CONSTRAINT maasserver_node_address_ttl_check CHECK ((address_ttl >= 0))
);


ALTER TABLE maasserver_node OWNER TO maas;

--
-- Name: sys_core_get_num_conn(maasserver_node); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_core_get_num_conn(rack maasserver_node) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN (
    SELECT count(*)
    FROM
      maasserver_regionrackrpcconnection AS connection
    WHERE connection.rack_controller_id = rack.id);
END;
$$;


ALTER FUNCTION public.sys_core_get_num_conn(rack maasserver_node) OWNER TO maas;

--
-- Name: sys_core_get_num_processes(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_core_get_num_processes() RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN (
    SELECT count(*) FROM maasserver_regioncontrollerprocess);
END;
$$;


ALTER FUNCTION public.sys_core_get_num_processes() OWNER TO maas;

--
-- Name: sys_core_pick_new_region(maasserver_node); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_core_pick_new_region(rack maasserver_node) RETURNS maasserver_regioncontrollerprocess
    LANGUAGE plpgsql
    AS $$
DECLARE
  selected_managing integer;
  number_managing integer;
  selected_process maasserver_regioncontrollerprocess;
  process maasserver_regioncontrollerprocess;
BEGIN
  -- Get best region controller that can manage this rack controller.
  -- This is identified by picking a region controller process that
  -- at least has a connection to the rack controller and managing the
  -- least number of rack controllers.
  FOR process IN (
    SELECT DISTINCT ON (maasserver_regioncontrollerprocess.id)
      maasserver_regioncontrollerprocess.*
    FROM
      maasserver_regioncontrollerprocess,
      maasserver_regioncontrollerprocessendpoint,
      maasserver_regionrackrpcconnection
    WHERE maasserver_regionrackrpcconnection.rack_controller_id = rack.id
      AND maasserver_regionrackrpcconnection.endpoint_id =
        maasserver_regioncontrollerprocessendpoint.id
      AND maasserver_regioncontrollerprocessendpoint.process_id =
        maasserver_regioncontrollerprocess.id)
  LOOP
    IF selected_process IS NULL THEN
      -- First time through the loop so set the default.
      selected_process = process;
      selected_managing = sys_core_get_managing_count(process);
    ELSE
      -- See if the current process is managing less then the currently
      -- selected process.
      number_managing = sys_core_get_managing_count(process);
      IF number_managing = 0 THEN
        -- This process is managing zero so its the best, so we exit the
        -- loop now to return the selected.
        selected_process = process;
        EXIT;
      ELSIF number_managing < selected_managing THEN
        -- Managing less than the currently selected; select this process
        -- instead.
        selected_process = process;
        selected_managing = number_managing;
      END IF;
    END IF;
  END LOOP;
  RETURN selected_process;
END;
$$;


ALTER FUNCTION public.sys_core_pick_new_region(rack maasserver_node) OWNER TO maas;

--
-- Name: sys_core_rpc_delete(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_core_rpc_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  rack_controller maasserver_node;
  region_process maasserver_regioncontrollerprocess;
BEGIN
  -- Connection from region <-> rack, has been removed. If that region
  -- process was managing that rack controller then a new one needs to
  -- be selected.
  SELECT maasserver_node.* INTO rack_controller
  FROM maasserver_node
  WHERE maasserver_node.id = OLD.rack_controller_id;

  -- Get the region process from the endpoint.
  SELECT
    process.* INTO region_process
  FROM
    maasserver_regioncontrollerprocess AS process,
    maasserver_regioncontrollerprocessendpoint AS endpoint
  WHERE process.id = endpoint.process_id
    AND endpoint.id = OLD.endpoint_id;

  -- Only perform an action if processes equal.
  IF rack_controller.managing_process_id = region_process.id THEN
    -- Region process was managing this rack controller. Tell it to stop
    -- watching the rack controller.
    PERFORM pg_notify(
      CONCAT('sys_core_', region_process.id),
      CONCAT('unwatch_', CAST(rack_controller.id AS text)));

    -- Pick a new region process for this rack controller.
    region_process = sys_core_pick_new_region(rack_controller);

    -- Update the rack controller and inform the new process.
    UPDATE maasserver_node
    SET managing_process_id = region_process.id
    WHERE maasserver_node.id = rack_controller.id;
    IF region_process.id IS NOT NULL THEN
      PERFORM pg_notify(
        CONCAT('sys_core_', region_process.id),
        CONCAT('watch_', CAST(rack_controller.id AS text)));
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_core_rpc_delete() OWNER TO maas;

--
-- Name: sys_core_rpc_insert(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_core_rpc_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  rack_controller maasserver_node;
  region_process maasserver_regioncontrollerprocess;
BEGIN
  -- New connection from region <-> rack, check that the rack controller
  -- has a managing region controller.
  SELECT maasserver_node.* INTO rack_controller
  FROM maasserver_node
  WHERE maasserver_node.id = NEW.rack_controller_id;

  IF rack_controller.managing_process_id IS NULL THEN
    -- No managing region process for this rack controller.
    PERFORM sys_core_set_new_region(rack_controller);
  ELSE
    -- Currently managed check that the managing process is not dead.
    SELECT maasserver_regioncontrollerprocess.* INTO region_process
    FROM maasserver_regioncontrollerprocess
    WHERE maasserver_regioncontrollerprocess.id =
      rack_controller.managing_process_id;
    IF EXTRACT(EPOCH FROM region_process.updated) -
      EXTRACT(EPOCH FROM now()) > 90 THEN
      -- Region controller process is dead. A new region process needs to
      -- be selected for this rack controller.
      UPDATE maasserver_node SET managing_process_id = NULL
      WHERE maasserver_node.id = NEW.rack_controller_id;
      NEW.rack_controller_id = NULL;
      PERFORM sys_core_set_new_region(rack_controller);
    ELSE
      -- Currently being managed but lets see if we can re-balance the
      -- managing processes better. We only do the re-balance once the
      -- rack controller is connected to more than half of the running
      -- processes.
      IF sys_core_get_num_conn(rack_controller) /
        sys_core_get_num_processes() > 0.5 THEN
        -- Pick a new region process for this rack controller. Only update
        -- and perform the notification if the selection is different.
        region_process = sys_core_pick_new_region(rack_controller);
        IF region_process.id != rack_controller.managing_process_id THEN
          -- Alter the old process that its no longer responsable for
          -- this rack controller.
          PERFORM pg_notify(
            CONCAT('sys_core_', rack_controller.managing_process_id),
            CONCAT('unwatch_', CAST(rack_controller.id AS text)));
          -- Update the rack controller and alert the region controller.
          UPDATE maasserver_node
          SET managing_process_id = region_process.id
          WHERE maasserver_node.id = rack_controller.id;
          PERFORM pg_notify(
            CONCAT('sys_core_', region_process.id),
            CONCAT('watch_', CAST(rack_controller.id AS text)));
        END IF;
      END IF;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_core_rpc_insert() OWNER TO maas;

--
-- Name: sys_core_set_new_region(maasserver_node); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_core_set_new_region(rack maasserver_node) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  region_process maasserver_regioncontrollerprocess;
BEGIN
  -- Pick the new region process to manage this rack controller.
  region_process = sys_core_pick_new_region(rack);

  -- Update the rack controller and alert the region controller.
  UPDATE maasserver_node SET managing_process_id = region_process.id
  WHERE maasserver_node.id = rack.id;
  PERFORM pg_notify(
    CONCAT('sys_core_', region_process.id),
    CONCAT('watch_', CAST(rack.id AS text)));
  RETURN;
END;
$$;


ALTER FUNCTION public.sys_core_set_new_region(rack maasserver_node) OWNER TO maas;

--
-- Name: maasserver_vlan; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_vlan (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(256),
    vid integer NOT NULL,
    mtu integer NOT NULL,
    fabric_id integer NOT NULL,
    dhcp_on boolean NOT NULL,
    primary_rack_id integer,
    secondary_rack_id integer,
    external_dhcp inet,
    description text NOT NULL,
    relay_vlan_id integer,
    space_id integer
);


ALTER TABLE maasserver_vlan OWNER TO maas;

--
-- Name: sys_dhcp_alert(maasserver_vlan); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_alert(vlan maasserver_vlan) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  relay_vlan maasserver_vlan;
BEGIN
  IF vlan.dhcp_on THEN
    PERFORM pg_notify(CONCAT('sys_dhcp_', vlan.primary_rack_id), '');
    IF vlan.secondary_rack_id IS NOT NULL THEN
      PERFORM pg_notify(CONCAT('sys_dhcp_', vlan.secondary_rack_id), '');
    END IF;
  END IF;
  IF vlan.relay_vlan_id IS NOT NULL THEN
    SELECT maasserver_vlan.* INTO relay_vlan
    FROM maasserver_vlan
    WHERE maasserver_vlan.id = vlan.relay_vlan_id;
    IF relay_vlan.dhcp_on THEN
      PERFORM pg_notify(CONCAT(
        'sys_dhcp_', relay_vlan.primary_rack_id), '');
      IF relay_vlan.secondary_rack_id IS NOT NULL THEN
        PERFORM pg_notify(CONCAT(
          'sys_dhcp_', relay_vlan.secondary_rack_id), '');
      END IF;
    END IF;
  END IF;
  RETURN;
END;
$$;


ALTER FUNCTION public.sys_dhcp_alert(vlan maasserver_vlan) OWNER TO maas;

--
-- Name: sys_dhcp_config_ntp_servers_delete(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_config_ntp_servers_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.name IN ('ntp_servers', 'ntp_external_only') THEN
    PERFORM sys_dhcp_update_all_vlans();
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_config_ntp_servers_delete() OWNER TO maas;

--
-- Name: sys_dhcp_config_ntp_servers_insert(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_config_ntp_servers_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.name = 'ntp_servers' THEN
    PERFORM sys_dhcp_update_all_vlans();
  ELSIF NEW.name = 'ntp_external_only' THEN
    PERFORM sys_dhcp_update_all_vlans();
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_config_ntp_servers_insert() OWNER TO maas;

--
-- Name: sys_dhcp_config_ntp_servers_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_config_ntp_servers_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.name IN ('ntp_servers', 'ntp_external_only')
  OR NEW.name IN ('ntp_servers', 'ntp_external_only') THEN
    IF OLD.value != NEW.value THEN
      PERFORM sys_dhcp_update_all_vlans();
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_config_ntp_servers_update() OWNER TO maas;

--
-- Name: sys_dhcp_interface_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_interface_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  vlan maasserver_vlan;
BEGIN
  -- Update VLAN if DHCP is enabled and the interface name or MAC
  -- address has changed.
  IF OLD.name != NEW.name OR OLD.mac_address != NEW.mac_address THEN
    FOR vlan IN (
      SELECT DISTINCT ON (maasserver_vlan.id)
        maasserver_vlan.*
      FROM
        maasserver_vlan,
        maasserver_subnet,
        maasserver_staticipaddress,
        maasserver_interface_ip_addresses AS ip_link
      WHERE maasserver_staticipaddress.subnet_id = maasserver_subnet.id
      AND ip_link.staticipaddress_id = maasserver_staticipaddress.id
      AND ip_link.interface_id = NEW.id
      AND maasserver_staticipaddress.alloc_type != 6
      AND maasserver_staticipaddress.ip IS NOT NULL
      AND host(maasserver_staticipaddress.ip) != ''
      AND maasserver_vlan.id = maasserver_subnet.vlan_id)
    LOOP
      PERFORM sys_dhcp_alert(vlan);
    END LOOP;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_interface_update() OWNER TO maas;

--
-- Name: sys_dhcp_iprange_delete(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_iprange_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  vlan maasserver_vlan;
BEGIN
  -- Update VLAN if DHCP is enabled and was dynamic range.
  IF OLD.type = 'dynamic' THEN
    SELECT maasserver_vlan.* INTO vlan
    FROM maasserver_vlan, maasserver_subnet
    WHERE maasserver_subnet.id = OLD.subnet_id AND
      maasserver_subnet.vlan_id = maasserver_vlan.id;
    PERFORM sys_dhcp_alert(vlan);
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_iprange_delete() OWNER TO maas;

--
-- Name: sys_dhcp_iprange_insert(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_iprange_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  vlan maasserver_vlan;
BEGIN
  -- Update VLAN if DHCP is enabled and a dynamic range.
  IF NEW.type = 'dynamic' THEN
    SELECT maasserver_vlan.* INTO vlan
    FROM maasserver_vlan, maasserver_subnet
    WHERE maasserver_subnet.id = NEW.subnet_id AND
      maasserver_subnet.vlan_id = maasserver_vlan.id;
    PERFORM sys_dhcp_alert(vlan);
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_iprange_insert() OWNER TO maas;

--
-- Name: sys_dhcp_iprange_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_iprange_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  vlan maasserver_vlan;
BEGIN
  -- Update VLAN if DHCP is enabled and was or is now a dynamic range.
  IF OLD.type = 'dynamic' OR NEW.type = 'dynamic' THEN
    SELECT maasserver_vlan.* INTO vlan
    FROM maasserver_vlan, maasserver_subnet
    WHERE maasserver_subnet.id = NEW.subnet_id AND
      maasserver_subnet.vlan_id = maasserver_vlan.id;
    PERFORM sys_dhcp_alert(vlan);
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_iprange_update() OWNER TO maas;

--
-- Name: sys_dhcp_node_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_node_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  vlan maasserver_vlan;
BEGIN
  -- Update VLAN if on every interface on the node that is managed when
  -- the node hostname is changed.
  IF OLD.hostname != NEW.hostname THEN
    FOR vlan IN (
      SELECT DISTINCT ON (maasserver_vlan.id)
        maasserver_vlan.*
      FROM
        maasserver_vlan,
        maasserver_staticipaddress,
        maasserver_subnet,
        maasserver_interface,
        maasserver_interface_ip_addresses AS ip_link
      WHERE maasserver_staticipaddress.subnet_id = maasserver_subnet.id
      AND ip_link.staticipaddress_id = maasserver_staticipaddress.id
      AND ip_link.interface_id = maasserver_interface.id
      AND maasserver_interface.node_id = NEW.id
      AND maasserver_staticipaddress.alloc_type != 6
      AND maasserver_staticipaddress.ip IS NOT NULL
      AND host(maasserver_staticipaddress.ip) != ''
      AND maasserver_vlan.id = maasserver_subnet.vlan_id)
    LOOP
      PERFORM sys_dhcp_alert(vlan);
    END LOOP;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_node_update() OWNER TO maas;

--
-- Name: sys_dhcp_snippet_delete(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_snippet_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.enabled THEN
    PERFORM sys_dhcp_snippet_update_value(OLD);
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_snippet_delete() OWNER TO maas;

--
-- Name: sys_dhcp_snippet_insert(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_snippet_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.enabled THEN
    PERFORM sys_dhcp_snippet_update_value(NEW);
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_snippet_insert() OWNER TO maas;

--
-- Name: sys_dhcp_snippet_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_snippet_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.enabled = NEW.enabled AND NEW.enabled IS FALSE THEN
    -- If the DHCP snippet is disabled don't fire any alerts
    RETURN NEW;
  ELSIF ((OLD.value_id != NEW.value_id) OR
      (OLD.enabled != NEW.enabled) OR
      (OLD.description != NEW.description)) THEN
    PERFORM sys_dhcp_snippet_update_value(NEW);
  ELSIF ((OLD.subnet_id IS NULL AND NEW.subnet_id IS NOT NULL) OR
      (OLD.subnet_id IS NOT NULL AND NEW.subnet_id IS NULL) OR
      (OLD.subnet_id != NEW.subnet_id)) THEN
    IF NEW.subnet_id IS NOT NULL THEN
      PERFORM sys_dhcp_snippet_update_subnet(NEW.subnet_id);
    END IF;
    IF OLD.subnet_id IS NOT NULL THEN
      PERFORM sys_dhcp_snippet_update_subnet(OLD.subnet_id);
    END IF;
  ELSIF ((OLD.node_id IS NULL AND NEW.node_id IS NOT NULL) OR
      (OLD.node_id IS NOT NULL AND NEW.node_id IS NULL) OR
      (OLD.node_id != NEW.node_id)) THEN
    IF NEW.node_id IS NOT NULL THEN
      PERFORM sys_dhcp_snippet_update_node(NEW.node_id);
    END IF;
    IF OLD.node_id IS NOT NULL THEN
      PERFORM sys_dhcp_snippet_update_node(OLD.node_id);
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_snippet_update() OWNER TO maas;

--
-- Name: sys_dhcp_snippet_update_node(integer); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_snippet_update_node(_node_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  rack INTEGER;
BEGIN
  FOR rack IN (
    WITH racks AS (
      SELECT primary_rack_id, secondary_rack_id
      FROM maasserver_vlan, maasserver_interface
      WHERE maasserver_interface.node_id = _node_id
        AND maasserver_interface.vlan_id = maasserver_vlan.id
      AND (maasserver_vlan.dhcp_on = true
        OR maasserver_vlan.relay_vlan_id IS NOT NULL))
    SELECT primary_rack_id FROM racks
    WHERE primary_rack_id IS NOT NULL
    UNION
    SELECT secondary_rack_id FROM racks
    WHERE secondary_rack_id IS NOT NULL)
  LOOP
    PERFORM pg_notify(CONCAT('sys_dhcp_', rack), '');
  END LOOP;
  RETURN;
END;
$$;


ALTER FUNCTION public.sys_dhcp_snippet_update_node(_node_id integer) OWNER TO maas;

--
-- Name: sys_dhcp_snippet_update_subnet(integer); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_snippet_update_subnet(_subnet_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  vlan maasserver_vlan;
BEGIN
  FOR vlan IN (
    SELECT
      maasserver_vlan.*
    FROM
      maasserver_vlan,
      maasserver_subnet
    WHERE maasserver_subnet.id = _subnet_id
      AND maasserver_vlan.id = maasserver_subnet.vlan_id
      AND (maasserver_vlan.dhcp_on = true
        OR maasserver_vlan.relay_vlan_id IS NOT NULL))
    LOOP
      PERFORM sys_dhcp_alert(vlan);
    END LOOP;
  RETURN;
END;
$$;


ALTER FUNCTION public.sys_dhcp_snippet_update_subnet(_subnet_id integer) OWNER TO maas;

--
-- Name: maasserver_dhcpsnippet; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_dhcpsnippet (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    enabled boolean NOT NULL,
    node_id integer,
    subnet_id integer,
    value_id integer NOT NULL
);


ALTER TABLE maasserver_dhcpsnippet OWNER TO maas;

--
-- Name: sys_dhcp_snippet_update_value(maasserver_dhcpsnippet); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_snippet_update_value(_dhcp_snippet maasserver_dhcpsnippet) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF _dhcp_snippet.subnet_id IS NOT NULL THEN
    PERFORM sys_dhcp_snippet_update_subnet(_dhcp_snippet.subnet_id);
  ELSIF _dhcp_snippet.node_id is NOT NULL THEN
    PERFORM sys_dhcp_snippet_update_node(_dhcp_snippet.node_id);
  ELSE
    -- This is a global snippet, everyone has to update. This should only
    -- be triggered when neither subnet_id or node_id are set. We verify
    -- that only subnet_id xor node_id are set in DHCPSnippet.clean()
    PERFORM sys_dhcp_update_all_vlans();
  END IF;
  RETURN;
END;
$$;


ALTER FUNCTION public.sys_dhcp_snippet_update_value(_dhcp_snippet maasserver_dhcpsnippet) OWNER TO maas;

--
-- Name: sys_dhcp_staticipaddress_delete(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_staticipaddress_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  vlan maasserver_vlan;
BEGIN
  -- Update VLAN if DHCP is enabled and has an IP address.
  IF host(OLD.ip) != '' THEN
    SELECT maasserver_vlan.* INTO vlan
    FROM maasserver_vlan, maasserver_subnet
    WHERE maasserver_subnet.id = OLD.subnet_id AND
      maasserver_subnet.vlan_id = maasserver_vlan.id;
    PERFORM sys_dhcp_alert(vlan);
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_staticipaddress_delete() OWNER TO maas;

--
-- Name: sys_dhcp_staticipaddress_insert(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_staticipaddress_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  vlan maasserver_vlan;
BEGIN
  -- Update VLAN if DHCP is enabled, IP is set and not DISCOVERED.
  IF NEW.alloc_type != 6 AND NEW.ip IS NOT NULL AND host(NEW.ip) != '' THEN
    SELECT maasserver_vlan.* INTO vlan
    FROM maasserver_vlan, maasserver_subnet
    WHERE maasserver_subnet.id = NEW.subnet_id AND
      maasserver_subnet.vlan_id = maasserver_vlan.id;
    PERFORM sys_dhcp_alert(vlan);
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_staticipaddress_insert() OWNER TO maas;

--
-- Name: sys_dhcp_staticipaddress_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_staticipaddress_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  old_vlan maasserver_vlan;
  new_vlan maasserver_vlan;
BEGIN
  -- Ignore DISCOVERED IP addresses.
  IF NEW.alloc_type != 6 THEN
    IF OLD.subnet_id != NEW.subnet_id THEN
      -- Subnet has changed; update each VLAN if different.
      SELECT maasserver_vlan.* INTO old_vlan
      FROM maasserver_vlan, maasserver_subnet
      WHERE maasserver_subnet.id = OLD.subnet_id AND
        maasserver_subnet.vlan_id = maasserver_vlan.id;
      SELECT maasserver_vlan.* INTO new_vlan
      FROM maasserver_vlan, maasserver_subnet
      WHERE maasserver_subnet.id = NEW.subnet_id AND
        maasserver_subnet.vlan_id = maasserver_vlan.id;
      IF old_vlan.id != new_vlan.id THEN
        -- Different VLAN's; update each if DHCP enabled.
        PERFORM sys_dhcp_alert(old_vlan);
        PERFORM sys_dhcp_alert(new_vlan);
      ELSE
        -- Same VLAN so only need to update once.
        PERFORM sys_dhcp_alert(new_vlan);
      END IF;
    ELSIF (OLD.ip IS NULL AND NEW.ip IS NOT NULL) OR
      (OLD.ip IS NOT NULL and NEW.ip IS NULL) OR
      (host(OLD.ip) != host(NEW.ip)) THEN
      -- Assigned IP address has changed.
      SELECT maasserver_vlan.* INTO new_vlan
      FROM maasserver_vlan, maasserver_subnet
      WHERE maasserver_subnet.id = NEW.subnet_id AND
        maasserver_subnet.vlan_id = maasserver_vlan.id;
      PERFORM sys_dhcp_alert(new_vlan);
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_staticipaddress_update() OWNER TO maas;

--
-- Name: sys_dhcp_subnet_delete(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_subnet_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  vlan maasserver_vlan;
BEGIN
  -- Update VLAN if DHCP is enabled.
  SELECT * INTO vlan
  FROM maasserver_vlan WHERE id = OLD.vlan_id;
  PERFORM sys_dhcp_alert(vlan);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_subnet_delete() OWNER TO maas;

--
-- Name: sys_dhcp_subnet_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_subnet_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  vlan maasserver_vlan;
BEGIN
  -- Subnet was moved to a new VLAN.
  IF OLD.vlan_id != NEW.vlan_id THEN
    -- Update old VLAN if DHCP is enabled.
    SELECT * INTO vlan
    FROM maasserver_vlan WHERE id = OLD.vlan_id;
    PERFORM sys_dhcp_alert(vlan);
    -- Update the new VLAN if DHCP is enabled.
    SELECT * INTO vlan
    FROM maasserver_vlan WHERE id = NEW.vlan_id;
    PERFORM sys_dhcp_alert(vlan);
  -- Related fields of subnet where changed.
  ELSIF OLD.cidr != NEW.cidr OR
    (OLD.gateway_ip IS NULL AND NEW.gateway_ip IS NOT NULL) OR
    (OLD.gateway_ip IS NOT NULL AND NEW.gateway_ip IS NULL) OR
    host(OLD.gateway_ip) != host(NEW.gateway_ip) OR
    OLD.dns_servers != NEW.dns_servers THEN
    -- Network has changed update alert DHCP if enabled.
    SELECT * INTO vlan
    FROM maasserver_vlan WHERE id = NEW.vlan_id;
    PERFORM sys_dhcp_alert(vlan);
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_subnet_update() OWNER TO maas;

--
-- Name: sys_dhcp_update_all_vlans(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_update_all_vlans() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  rack INTEGER;
BEGIN
  FOR rack IN (
    WITH racks AS (
      SELECT primary_rack_id, secondary_rack_id FROM maasserver_vlan
      WHERE maasserver_vlan.dhcp_on = true
    )
    SELECT primary_rack_id FROM racks
    WHERE primary_rack_id IS NOT NULL
    UNION
    SELECT secondary_rack_id FROM racks
    WHERE secondary_rack_id IS NOT NULL)
  LOOP
    PERFORM pg_notify(CONCAT('sys_dhcp_', rack), '');
  END LOOP;
  RETURN;
END;
$$;


ALTER FUNCTION public.sys_dhcp_update_all_vlans() OWNER TO maas;

--
-- Name: sys_dhcp_vlan_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dhcp_vlan_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  relay_vlan maasserver_vlan;
BEGIN
  -- DHCP was turned off.
  IF OLD.dhcp_on AND NOT NEW.dhcp_on THEN
    PERFORM pg_notify(CONCAT('sys_dhcp_', OLD.primary_rack_id), '');
    IF OLD.secondary_rack_id IS NOT NULL THEN
      PERFORM pg_notify(CONCAT('sys_dhcp_', OLD.secondary_rack_id), '');
    END IF;
  -- DHCP was turned on.
  ELSIF NOT OLD.dhcp_on AND NEW.dhcp_on THEN
    PERFORM pg_notify(CONCAT('sys_dhcp_', NEW.primary_rack_id), '');
    IF NEW.secondary_rack_id IS NOT NULL THEN
      PERFORM pg_notify(CONCAT('sys_dhcp_', NEW.secondary_rack_id), '');
    END IF;
  -- DHCP state was not changed but the rack controllers might have been.
  ELSIF NEW.dhcp_on AND (
     OLD.primary_rack_id != NEW.primary_rack_id OR (
       OLD.secondary_rack_id IS NULL AND
       NEW.secondary_rack_id IS NOT NULL) OR (
       OLD.secondary_rack_id IS NOT NULL AND
       NEW.secondary_rack_id IS NULL) OR
     OLD.secondary_rack_id != NEW.secondary_rack_id) THEN
    -- Send the message to the old primary if no longer the primary.
    IF OLD.primary_rack_id != NEW.primary_rack_id THEN
      PERFORM pg_notify(CONCAT('sys_dhcp_', OLD.primary_rack_id), '');
    END IF;
    -- Always send the message to the primary as it has to be set.
    PERFORM pg_notify(CONCAT('sys_dhcp_', NEW.primary_rack_id), '');
    -- Send message to both old and new secondary rack controller if set.
    IF OLD.secondary_rack_id IS NOT NULL THEN
      PERFORM pg_notify(CONCAT('sys_dhcp_', OLD.secondary_rack_id), '');
    END IF;
    IF NEW.secondary_rack_id IS NOT NULL THEN
      PERFORM pg_notify(CONCAT('sys_dhcp_', NEW.secondary_rack_id), '');
    END IF;
  END IF;

  -- Relay VLAN was set when it was previously unset.
  IF OLD.relay_vlan_id IS NULL AND NEW.relay_vlan_id IS NOT NULL THEN
    SELECT maasserver_vlan.* INTO relay_vlan
    FROM maasserver_vlan
    WHERE maasserver_vlan.id = NEW.relay_vlan_id;
    IF relay_vlan.primary_rack_id IS NOT NULL THEN
      PERFORM pg_notify(
        CONCAT('sys_dhcp_', relay_vlan.primary_rack_id), '');
      IF relay_vlan.secondary_rack_id IS NOT NULL THEN
        PERFORM pg_notify(
          CONCAT('sys_dhcp_', relay_vlan.secondary_rack_id), '');
      END IF;
    END IF;
  -- Relay VLAN was unset when it was previously set.
  ELSIF OLD.relay_vlan_id IS NOT NULL AND NEW.relay_vlan_id IS NULL THEN
    SELECT maasserver_vlan.* INTO relay_vlan
    FROM maasserver_vlan
    WHERE maasserver_vlan.id = OLD.relay_vlan_id;
    IF relay_vlan.primary_rack_id IS NOT NULL THEN
      PERFORM pg_notify(
        CONCAT('sys_dhcp_', relay_vlan.primary_rack_id), '');
      IF relay_vlan.secondary_rack_id IS NOT NULL THEN
        PERFORM pg_notify(
          CONCAT('sys_dhcp_', relay_vlan.secondary_rack_id), '');
      END IF;
    END IF;
  -- Relay VLAN has changed on the VLAN.
  ELSIF OLD.relay_vlan_id != NEW.relay_vlan_id THEN
    -- Alert old VLAN if required.
    SELECT maasserver_vlan.* INTO relay_vlan
    FROM maasserver_vlan
    WHERE maasserver_vlan.id = OLD.relay_vlan_id;
    IF relay_vlan.primary_rack_id IS NOT NULL THEN
      PERFORM pg_notify(
        CONCAT('sys_dhcp_', relay_vlan.primary_rack_id), '');
      IF relay_vlan.secondary_rack_id IS NOT NULL THEN
        PERFORM pg_notify(
          CONCAT('sys_dhcp_', relay_vlan.secondary_rack_id), '');
      END IF;
    END IF;
    -- Alert new VLAN if required.
    SELECT maasserver_vlan.* INTO relay_vlan
    FROM maasserver_vlan
    WHERE maasserver_vlan.id = NEW.relay_vlan_id;
    IF relay_vlan.primary_rack_id IS NOT NULL THEN
      PERFORM pg_notify(
        CONCAT('sys_dhcp_', relay_vlan.primary_rack_id), '');
      IF relay_vlan.secondary_rack_id IS NOT NULL THEN
        PERFORM pg_notify(
          CONCAT('sys_dhcp_', relay_vlan.secondary_rack_id), '');
      END IF;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dhcp_vlan_update() OWNER TO maas;

--
-- Name: sys_dns_config_insert(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_config_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only care about the
  IF (NEW.name = 'upstream_dns' OR
      NEW.name = 'dnssec_validation' OR
      NEW.name = 'default_dns_ttl' OR
      NEW.name = 'windows_kms_host')
  THEN
    INSERT INTO maasserver_dnspublication
      (serial, created, source)
    VALUES
      (nextval('maasserver_zone_serial_seq'), now(), substring(
        ('Configuration ' || NEW.name || ' set to ' ||
         COALESCE(NEW.value, 'NULL'))
        FOR 255));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_config_insert() OWNER TO maas;

--
-- Name: sys_dns_config_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_config_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only care about the upstream_dns, default_dns_ttl, and
  -- windows_kms_host.
  IF (OLD.value != NEW.value AND (
      NEW.name = 'upstream_dns' OR
      NEW.name = 'dnssec_validation' OR
      NEW.name = 'default_dns_ttl' OR
      NEW.name = 'windows_kms_host'))
  THEN
    INSERT INTO maasserver_dnspublication
      (serial, created, source)
    VALUES
      (nextval('maasserver_zone_serial_seq'), now(), substring(
        ('Configuration ' || NEW.name || ' changed from ' ||
         OLD.value || ' to ' || NEW.value)
        FOR 255));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_config_update() OWNER TO maas;

--
-- Name: sys_dns_dnsdata_delete(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_dnsdata_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_dnsdata_delete' FOR 255));
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.sys_dns_dnsdata_delete() OWNER TO maas;

--
-- Name: sys_dns_dnsdata_insert(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_dnsdata_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_dnsdata_insert' FOR 255));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_dnsdata_insert() OWNER TO maas;

--
-- Name: sys_dns_dnsdata_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_dnsdata_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_dnsdata_update' FOR 255));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_dnsdata_update() OWNER TO maas;

--
-- Name: sys_dns_dnsresource_delete(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_dnsresource_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_dnsresource_delete' FOR 255));
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.sys_dns_dnsresource_delete() OWNER TO maas;

--
-- Name: sys_dns_dnsresource_insert(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_dnsresource_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_dnsresource_insert' FOR 255));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_dnsresource_insert() OWNER TO maas;

--
-- Name: sys_dns_dnsresource_ip_link(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_dnsresource_ip_link() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_dnsresource_ip_link' FOR 255));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_dnsresource_ip_link() OWNER TO maas;

--
-- Name: sys_dns_dnsresource_ip_unlink(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_dnsresource_ip_unlink() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_dnsresource_ip_unlink' FOR 255));
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.sys_dns_dnsresource_ip_unlink() OWNER TO maas;

--
-- Name: sys_dns_dnsresource_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_dnsresource_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_dnsresource_update' FOR 255));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_dnsresource_update() OWNER TO maas;

--
-- Name: sys_dns_domain_delete(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_domain_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_domain_delete' FOR 255));
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.sys_dns_domain_delete() OWNER TO maas;

--
-- Name: sys_dns_domain_insert(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_domain_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_domain_insert' FOR 255));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_domain_insert() OWNER TO maas;

--
-- Name: sys_dns_domain_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_domain_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_domain_update' FOR 255));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_domain_update() OWNER TO maas;

--
-- Name: sys_dns_interface_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_interface_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  changes text[];
BEGIN
  IF OLD.name != NEW.name THEN
    changes := changes || (
      'renamed from ' || OLD.name || ' to ' || NEW.name);
  END IF;
  IF OLD.node_id IS NULL AND NEW.node_id IS NOT NULL THEN
    changes := changes || 'node set'::text;
  ELSIF OLD.node_id IS NOT NULL AND NEW.node_id IS NULL THEN
    changes := changes || 'node unset'::text;
  ELSIF OLD.node_id != NEW.node_id THEN
    changes := changes || 'node changed'::text;
  END IF;
  IF array_length(changes, 1) != 0 THEN
    INSERT INTO maasserver_dnspublication
      (serial, created, source)
    VALUES
      (nextval('maasserver_zone_serial_seq'), now(),
       substring(
         ('Interface ' || NEW.name || ': ' ||
          array_to_string(changes, ', '))
         FOR 255));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_interface_update() OWNER TO maas;

--
-- Name: sys_dns_nic_ip_link(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_nic_ip_link() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_nic_ip_link' FOR 255));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_nic_ip_link() OWNER TO maas;

--
-- Name: sys_dns_nic_ip_unlink(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_nic_ip_unlink() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_nic_ip_unlink' FOR 255));
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.sys_dns_nic_ip_unlink() OWNER TO maas;

--
-- Name: sys_dns_node_delete(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_node_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_node_delete' FOR 255));
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.sys_dns_node_delete() OWNER TO maas;

--
-- Name: sys_dns_node_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_node_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  changes text[];
BEGIN
  IF OLD.hostname != NEW.hostname THEN
    changes := changes || (
      'hostname changed from ' || OLD.hostname || ' to ' || NEW.hostname);
  END IF;
  IF OLD.domain_id != NEW.domain_id THEN
    changes := changes || 'domain changed'::text;
  END IF;
  IF array_length(changes, 1) != 0 THEN
    INSERT INTO maasserver_dnspublication
      (serial, created, source)
    VALUES
      (nextval('maasserver_zone_serial_seq'), now(),
       substring(
         ('Node ' || NEW.system_id || ': ' ||
          array_to_string(changes, ', '))
         FOR 255));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_node_update() OWNER TO maas;

--
-- Name: sys_dns_publish(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_publish() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM pg_notify('sys_dns', '');
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_publish() OWNER TO maas;

--
-- Name: sys_dns_staticipaddress_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_staticipaddress_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_staticipaddress_update' FOR 255));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_staticipaddress_update() OWNER TO maas;

--
-- Name: sys_dns_subnet_delete(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_subnet_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_subnet_delete' FOR 255));
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.sys_dns_subnet_delete() OWNER TO maas;

--
-- Name: sys_dns_subnet_insert(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_subnet_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO maasserver_dnspublication
    (serial, created, source)
  VALUES
    (nextval('maasserver_zone_serial_seq'), now(),
     substring('Call to sys_dns_subnet_insert' FOR 255));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_subnet_insert() OWNER TO maas;

--
-- Name: sys_dns_subnet_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_dns_subnet_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  changes text[];
BEGIN
  IF OLD.cidr != NEW.cidr THEN
    changes := changes || (
      'CIDR changed from ' || OLD.cidr || ' to ' || NEW.cidr);
  END IF;
  IF OLD.rdns_mode != NEW.rdns_mode THEN
    changes := changes || (
      'RDNS mode changed from ' || OLD.rdns_mode || ' to ' ||
      NEW.rdns_mode);
  END IF;
  IF array_length(changes, 1) != 0 THEN
    INSERT INTO maasserver_dnspublication
      (serial, created, source)
    VALUES
      (nextval('maasserver_zone_serial_seq'), now(),
       substring(
         ('Subnet ' || NEW.name || ': ' || array_to_string(changes, ', '))
         FOR 255));
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_dns_subnet_update() OWNER TO maas;

--
-- Name: sys_proxy_subnet_delete(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_proxy_subnet_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM pg_notify('sys_proxy', '');
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.sys_proxy_subnet_delete() OWNER TO maas;

--
-- Name: sys_proxy_subnet_insert(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_proxy_subnet_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM pg_notify('sys_proxy', '');
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_proxy_subnet_insert() OWNER TO maas;

--
-- Name: sys_proxy_subnet_update(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION sys_proxy_subnet_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.cidr != NEW.cidr OR OLD.allow_proxy != NEW.allow_proxy THEN
    PERFORM pg_notify('sys_proxy', '');
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sys_proxy_subnet_update() OWNER TO maas;

--
-- Name: tag_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION tag_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('tag_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.tag_create_notify() OWNER TO maas;

--
-- Name: tag_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION tag_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('tag_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.tag_delete_notify() OWNER TO maas;

--
-- Name: tag_update_machine_device_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION tag_update_machine_device_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  node RECORD;
  pnode RECORD;
BEGIN
  FOR node IN (
    SELECT
      maasserver_node.system_id,
      maasserver_node.node_type,
      maasserver_node.parent_id
    FROM maasserver_node_tags, maasserver_node
    WHERE maasserver_node_tags.tag_id = NEW.id
    AND maasserver_node_tags.node_id = maasserver_node.id)
  LOOP
    IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
    ELSIF node.node_type IN (2, 3, 4) THEN
      PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
    ELSIF node.parent_id IS NOT NULL THEN
      SELECT system_id INTO pnode
      FROM maasserver_node
      WHERE id = node.parent_id;
      PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
    ELSE
      PERFORM pg_notify('device_update',CAST(node.system_id AS text));
    END IF;
  END LOOP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.tag_update_machine_device_notify() OWNER TO maas;

--
-- Name: tag_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION tag_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('tag_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.tag_update_notify() OWNER TO maas;

--
-- Name: user_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION user_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('user_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.user_create_notify() OWNER TO maas;

--
-- Name: user_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION user_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('user_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.user_delete_notify() OWNER TO maas;

--
-- Name: user_sshkey_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION user_sshkey_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('user_update',CAST(NEW.user_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.user_sshkey_link_notify() OWNER TO maas;

--
-- Name: user_sshkey_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION user_sshkey_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('user_update',CAST(OLD.user_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.user_sshkey_unlink_notify() OWNER TO maas;

--
-- Name: user_sslkey_link_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION user_sslkey_link_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('user_update',CAST(NEW.user_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.user_sslkey_link_notify() OWNER TO maas;

--
-- Name: user_sslkey_unlink_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION user_sslkey_unlink_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('user_update',CAST(OLD.user_id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.user_sslkey_unlink_notify() OWNER TO maas;

--
-- Name: user_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION user_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('user_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.user_update_notify() OWNER TO maas;

--
-- Name: vlan_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION vlan_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('vlan_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.vlan_create_notify() OWNER TO maas;

--
-- Name: vlan_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION vlan_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('vlan_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.vlan_delete_notify() OWNER TO maas;

--
-- Name: vlan_machine_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION vlan_machine_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    node RECORD;
    pnode RECORD;
BEGIN
  FOR node IN (
    SELECT DISTINCT ON (maasserver_node.id)
      system_id, node_type, parent_id
    FROM maasserver_node, maasserver_interface, maasserver_vlan
    WHERE maasserver_vlan.id = NEW.id
    AND maasserver_node.id = maasserver_interface.node_id
    AND maasserver_vlan.id = maasserver_interface.vlan_id)
  LOOP
    IF node.node_type = 0 THEN
      PERFORM pg_notify('machine_update',CAST(node.system_id AS text));
    ELSIF node.node_type IN (2, 3, 4) THEN
      PERFORM pg_notify('controller_update',CAST(node.system_id AS text));
    ELSIF node.parent_id IS NOT NULL THEN
      SELECT system_id INTO pnode
      FROM maasserver_node
      WHERE id = node.parent_id;
      PERFORM pg_notify('machine_update',CAST(pnode.system_id AS text));
    ELSE
      PERFORM pg_notify('device_update',CAST(node.system_id AS text));
    END IF;
  END LOOP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.vlan_machine_update_notify() OWNER TO maas;

--
-- Name: vlan_subnet_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION vlan_subnet_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    subnet RECORD;
BEGIN
  FOR subnet IN (
    SELECT DISTINCT maasserver_subnet.id AS id
    FROM maasserver_subnet, maasserver_vlan
    WHERE maasserver_vlan.id = NEW.id)
  LOOP
    PERFORM pg_notify('subnet_update',CAST(subnet.id AS text));
  END LOOP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.vlan_subnet_update_notify() OWNER TO maas;

--
-- Name: vlan_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION vlan_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('vlan_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.vlan_update_notify() OWNER TO maas;

--
-- Name: zone_create_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION zone_create_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('zone_create',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.zone_create_notify() OWNER TO maas;

--
-- Name: zone_delete_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION zone_delete_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('zone_delete',CAST(OLD.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.zone_delete_notify() OWNER TO maas;

--
-- Name: zone_update_notify(); Type: FUNCTION; Schema: public; Owner: maas
--

CREATE FUNCTION zone_update_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  PERFORM pg_notify('zone_update',CAST(NEW.id AS text));
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.zone_update_notify() OWNER TO maas;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE auth_group OWNER TO maas;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_group_id_seq OWNER TO maas;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE auth_group_permissions OWNER TO maas;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_group_permissions_id_seq OWNER TO maas;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE auth_permission OWNER TO maas;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_permission_id_seq OWNER TO maas;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE auth_user OWNER TO maas;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE auth_user_groups OWNER TO maas;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_groups_id_seq OWNER TO maas;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_id_seq OWNER TO maas;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE auth_user_user_permissions OWNER TO maas;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_user_permissions_id_seq OWNER TO maas;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE django_content_type OWNER TO maas;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_content_type_id_seq OWNER TO maas;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE django_migrations OWNER TO maas;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_migrations_id_seq OWNER TO maas;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE django_migrations_id_seq OWNED BY django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE django_session OWNER TO maas;

--
-- Name: django_site; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE django_site OWNER TO maas;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_site_id_seq OWNER TO maas;

--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE django_site_id_seq OWNED BY django_site.id;


--
-- Name: maasserver_bootsource; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_bootsource (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    url character varying(200) NOT NULL,
    keyring_filename character varying(4096) NOT NULL,
    keyring_data bytea NOT NULL
);


ALTER TABLE maasserver_bootsource OWNER TO maas;

--
-- Name: maasserver_bootsourcecache; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_bootsourcecache (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    os character varying(32) NOT NULL,
    arch character varying(32) NOT NULL,
    subarch character varying(32) NOT NULL,
    release character varying(32) NOT NULL,
    label character varying(32) NOT NULL,
    boot_source_id integer NOT NULL,
    release_codename character varying(255),
    release_title character varying(255),
    support_eol date,
    kflavor character varying(32),
    bootloader_type character varying(32),
    extra text NOT NULL
);


ALTER TABLE maasserver_bootsourcecache OWNER TO maas;

--
-- Name: maas_support__boot_source_cache; Type: VIEW; Schema: public; Owner: maas
--

CREATE VIEW maas_support__boot_source_cache AS
 SELECT bs.url,
    bsc.label,
    bsc.os,
    bsc.release,
    bsc.arch,
    bsc.subarch
   FROM (maasserver_bootsource bs
     LEFT JOIN maasserver_bootsourcecache bsc ON ((bsc.boot_source_id = bs.id)))
  ORDER BY bs.url, bsc.label, bsc.os, bsc.release, bsc.arch, bsc.subarch;


ALTER TABLE maas_support__boot_source_cache OWNER TO maas;

--
-- Name: maasserver_bootsourceselection; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_bootsourceselection (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    os character varying(20) NOT NULL,
    release character varying(20) NOT NULL,
    arches text[],
    subarches text[],
    labels text[],
    boot_source_id integer NOT NULL
);


ALTER TABLE maasserver_bootsourceselection OWNER TO maas;

--
-- Name: maas_support__boot_source_selections; Type: VIEW; Schema: public; Owner: maas
--

CREATE VIEW maas_support__boot_source_selections AS
 SELECT bs.url,
    bss.release,
    bss.arches,
    bss.subarches,
    bss.labels,
    bss.os
   FROM (maasserver_bootsource bs
     LEFT JOIN maasserver_bootsourceselection bss ON ((bss.boot_source_id = bs.id)));


ALTER TABLE maas_support__boot_source_selections OWNER TO maas;

--
-- Name: maasserver_config; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_config (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE maasserver_config OWNER TO maas;

--
-- Name: maas_support__configuration__excluding_rpc_shared_secret; Type: VIEW; Schema: public; Owner: maas
--

CREATE VIEW maas_support__configuration__excluding_rpc_shared_secret AS
 SELECT maasserver_config.name,
    maasserver_config.value
   FROM maasserver_config
  WHERE ((maasserver_config.name)::text <> 'rpc_shared_secret'::text);


ALTER TABLE maas_support__configuration__excluding_rpc_shared_secret OWNER TO maas;

--
-- Name: maas_support__device_overview; Type: VIEW; Schema: public; Owner: maas
--

CREATE VIEW maas_support__device_overview AS
 SELECT node.hostname,
    node.system_id,
    parent.hostname AS parent
   FROM (maasserver_node node
     LEFT JOIN maasserver_node parent ON ((node.parent_id = parent.id)))
  WHERE (node.node_type = 1)
  ORDER BY node.hostname;


ALTER TABLE maas_support__device_overview OWNER TO maas;

--
-- Name: maasserver_bmc; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_bmc (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    power_type character varying(10) NOT NULL,
    power_parameters text NOT NULL,
    ip_address_id integer,
    architectures text[],
    bmc_type integer NOT NULL,
    capabilities text[],
    cores integer NOT NULL,
    cpu_speed integer NOT NULL,
    local_disks integer NOT NULL,
    local_storage bigint NOT NULL,
    memory integer NOT NULL,
    name character varying(255) NOT NULL,
    iscsi_storage bigint NOT NULL
);


ALTER TABLE maasserver_bmc OWNER TO maas;

--
-- Name: maasserver_interface; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_interface (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(20) NOT NULL,
    mac_address macaddr,
    ipv4_params text NOT NULL,
    ipv6_params text NOT NULL,
    params text NOT NULL,
    tags text[],
    enabled boolean NOT NULL,
    node_id integer,
    vlan_id integer,
    acquired boolean NOT NULL,
    mdns_discovery_state boolean NOT NULL,
    neighbour_discovery_state boolean NOT NULL
);


ALTER TABLE maasserver_interface OWNER TO maas;

--
-- Name: maasserver_interface_ip_addresses; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_interface_ip_addresses (
    id integer NOT NULL,
    interface_id integer NOT NULL,
    staticipaddress_id integer NOT NULL
);


ALTER TABLE maasserver_interface_ip_addresses OWNER TO maas;

--
-- Name: maasserver_staticipaddress; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_staticipaddress (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    ip inet,
    alloc_type integer NOT NULL,
    subnet_id integer,
    user_id integer,
    lease_time integer NOT NULL
);


ALTER TABLE maasserver_staticipaddress OWNER TO maas;

--
-- Name: maasserver_subnet; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_subnet (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    cidr cidr NOT NULL,
    gateway_ip inet,
    dns_servers text[],
    vlan_id integer NOT NULL,
    rdns_mode integer NOT NULL,
    allow_proxy boolean NOT NULL,
    description text NOT NULL,
    active_discovery boolean NOT NULL,
    managed boolean NOT NULL
);


ALTER TABLE maasserver_subnet OWNER TO maas;

--
-- Name: maas_support__ip_allocation; Type: VIEW; Schema: public; Owner: maas
--

CREATE VIEW maas_support__ip_allocation AS
 SELECT sip.ip,
        CASE
            WHEN (sip.alloc_type = 0) THEN 'AUTO'::bpchar
            WHEN (sip.alloc_type = 1) THEN 'STICKY'::bpchar
            WHEN (sip.alloc_type = 4) THEN 'USER_RESERVED'::bpchar
            WHEN (sip.alloc_type = 5) THEN 'DHCP'::bpchar
            WHEN (sip.alloc_type = 6) THEN 'DISCOVERED'::bpchar
            ELSE (sip.alloc_type)::character(1)
        END AS alloc_type,
    subnet.cidr,
    node.hostname,
    iface.id AS ifid,
    iface.name AS ifname,
    iface.type AS iftype,
    iface.mac_address,
    bmc.power_type
   FROM (((((maasserver_staticipaddress sip
     LEFT JOIN maasserver_subnet subnet ON ((subnet.id = sip.subnet_id)))
     LEFT JOIN maasserver_interface_ip_addresses ifip ON ((sip.id = ifip.staticipaddress_id)))
     LEFT JOIN maasserver_interface iface ON ((iface.id = ifip.interface_id)))
     LEFT JOIN maasserver_node node ON ((iface.node_id = node.id)))
     LEFT JOIN maasserver_bmc bmc ON ((bmc.ip_address_id = sip.id)))
  ORDER BY sip.ip;


ALTER TABLE maas_support__ip_allocation OWNER TO maas;

--
-- Name: maasserver_licensekey; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_licensekey (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    osystem character varying(255) NOT NULL,
    distro_series character varying(255) NOT NULL,
    license_key character varying(255) NOT NULL
);


ALTER TABLE maasserver_licensekey OWNER TO maas;

--
-- Name: maas_support__license_keys_present__excluding_key_material; Type: VIEW; Schema: public; Owner: maas
--

CREATE VIEW maas_support__license_keys_present__excluding_key_material AS
 SELECT maasserver_licensekey.osystem,
    maasserver_licensekey.distro_series
   FROM maasserver_licensekey;


ALTER TABLE maas_support__license_keys_present__excluding_key_material OWNER TO maas;

--
-- Name: maasserver_fabric; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_fabric (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(256),
    class_type character varying(256),
    description text NOT NULL
);


ALTER TABLE maasserver_fabric OWNER TO maas;

--
-- Name: maas_support__node_networking; Type: VIEW; Schema: public; Owner: maas
--

CREATE VIEW maas_support__node_networking AS
 SELECT node.hostname,
    iface.id AS ifid,
    iface.name,
    iface.type,
    iface.mac_address,
    sip.ip,
        CASE
            WHEN (sip.alloc_type = 0) THEN 'AUTO'::bpchar
            WHEN (sip.alloc_type = 1) THEN 'STICKY'::bpchar
            WHEN (sip.alloc_type = 4) THEN 'USER_RESERVED'::bpchar
            WHEN (sip.alloc_type = 5) THEN 'DHCP'::bpchar
            WHEN (sip.alloc_type = 6) THEN 'DISCOVERED'::bpchar
            ELSE (sip.alloc_type)::character(1)
        END AS alloc_type,
    subnet.cidr,
    vlan.vid,
    fabric.name AS fabric
   FROM ((((((maasserver_interface iface
     LEFT JOIN maasserver_interface_ip_addresses ifip ON ((ifip.interface_id = iface.id)))
     LEFT JOIN maasserver_staticipaddress sip ON ((ifip.staticipaddress_id = sip.id)))
     LEFT JOIN maasserver_subnet subnet ON ((sip.subnet_id = subnet.id)))
     LEFT JOIN maasserver_node node ON ((node.id = iface.node_id)))
     LEFT JOIN maasserver_vlan vlan ON ((vlan.id = subnet.vlan_id)))
     LEFT JOIN maasserver_fabric fabric ON ((fabric.id = vlan.fabric_id)))
  ORDER BY node.hostname, iface.name, sip.alloc_type;


ALTER TABLE maas_support__node_networking OWNER TO maas;

--
-- Name: maas_support__node_overview; Type: VIEW; Schema: public; Owner: maas
--

CREATE VIEW maas_support__node_overview AS
 SELECT maasserver_node.hostname,
    maasserver_node.system_id,
    maasserver_node.cpu_count AS cpu,
    maasserver_node.memory
   FROM maasserver_node
  WHERE (maasserver_node.node_type = 0)
  ORDER BY maasserver_node.hostname;


ALTER TABLE maas_support__node_overview OWNER TO maas;

--
-- Name: maasserver_sshkey; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_sshkey (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    key text NOT NULL,
    user_id integer NOT NULL,
    keysource_id integer
);


ALTER TABLE maasserver_sshkey OWNER TO maas;

--
-- Name: maas_support__ssh_keys__by_user; Type: VIEW; Schema: public; Owner: maas
--

CREATE VIEW maas_support__ssh_keys__by_user AS
 SELECT u.username,
    sshkey.key
   FROM (auth_user u
     LEFT JOIN maasserver_sshkey sshkey ON ((u.id = sshkey.user_id)))
  ORDER BY u.username, sshkey.key;


ALTER TABLE maas_support__ssh_keys__by_user OWNER TO maas;

--
-- Name: maasserver_blockdevice; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_blockdevice (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    id_path character varying(4096),
    size bigint NOT NULL,
    block_size integer NOT NULL,
    tags text[],
    node_id integer NOT NULL
);


ALTER TABLE maasserver_blockdevice OWNER TO maas;

--
-- Name: maasserver_blockdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_blockdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_blockdevice_id_seq OWNER TO maas;

--
-- Name: maasserver_blockdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_blockdevice_id_seq OWNED BY maasserver_blockdevice.id;


--
-- Name: maasserver_bmc_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_bmc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_bmc_id_seq OWNER TO maas;

--
-- Name: maasserver_bmc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_bmc_id_seq OWNED BY maasserver_bmc.id;


--
-- Name: maasserver_bmcroutablerackcontrollerrelationship; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_bmcroutablerackcontrollerrelationship (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    routable boolean NOT NULL,
    bmc_id integer NOT NULL,
    rack_controller_id integer NOT NULL
);


ALTER TABLE maasserver_bmcroutablerackcontrollerrelationship OWNER TO maas;

--
-- Name: maasserver_bmcroutablerackcontrollerrelationship_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_bmcroutablerackcontrollerrelationship_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_bmcroutablerackcontrollerrelationship_id_seq OWNER TO maas;

--
-- Name: maasserver_bmcroutablerackcontrollerrelationship_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_bmcroutablerackcontrollerrelationship_id_seq OWNED BY maasserver_bmcroutablerackcontrollerrelationship.id;


--
-- Name: maasserver_bootresource; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_bootresource (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    rtype integer NOT NULL,
    name character varying(255) NOT NULL,
    architecture character varying(255) NOT NULL,
    extra text NOT NULL,
    kflavor character varying(32),
    bootloader_type character varying(32),
    rolling boolean NOT NULL
);


ALTER TABLE maasserver_bootresource OWNER TO maas;

--
-- Name: maasserver_bootresource_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_bootresource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_bootresource_id_seq OWNER TO maas;

--
-- Name: maasserver_bootresource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_bootresource_id_seq OWNED BY maasserver_bootresource.id;


--
-- Name: maasserver_bootresourcefile; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_bootresourcefile (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    filename character varying(255) NOT NULL,
    filetype character varying(20) NOT NULL,
    extra text NOT NULL,
    largefile_id integer NOT NULL,
    resource_set_id integer NOT NULL
);


ALTER TABLE maasserver_bootresourcefile OWNER TO maas;

--
-- Name: maasserver_bootresourcefile_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_bootresourcefile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_bootresourcefile_id_seq OWNER TO maas;

--
-- Name: maasserver_bootresourcefile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_bootresourcefile_id_seq OWNED BY maasserver_bootresourcefile.id;


--
-- Name: maasserver_bootresourceset; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_bootresourceset (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    version character varying(255) NOT NULL,
    label character varying(255) NOT NULL,
    resource_id integer NOT NULL
);


ALTER TABLE maasserver_bootresourceset OWNER TO maas;

--
-- Name: maasserver_bootresourceset_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_bootresourceset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_bootresourceset_id_seq OWNER TO maas;

--
-- Name: maasserver_bootresourceset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_bootresourceset_id_seq OWNED BY maasserver_bootresourceset.id;


--
-- Name: maasserver_bootsource_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_bootsource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_bootsource_id_seq OWNER TO maas;

--
-- Name: maasserver_bootsource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_bootsource_id_seq OWNED BY maasserver_bootsource.id;


--
-- Name: maasserver_bootsourcecache_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_bootsourcecache_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_bootsourcecache_id_seq OWNER TO maas;

--
-- Name: maasserver_bootsourcecache_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_bootsourcecache_id_seq OWNED BY maasserver_bootsourcecache.id;


--
-- Name: maasserver_bootsourceselection_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_bootsourceselection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_bootsourceselection_id_seq OWNER TO maas;

--
-- Name: maasserver_bootsourceselection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_bootsourceselection_id_seq OWNED BY maasserver_bootsourceselection.id;


--
-- Name: maasserver_cacheset; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_cacheset (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL
);


ALTER TABLE maasserver_cacheset OWNER TO maas;

--
-- Name: maasserver_cacheset_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_cacheset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_cacheset_id_seq OWNER TO maas;

--
-- Name: maasserver_cacheset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_cacheset_id_seq OWNED BY maasserver_cacheset.id;


--
-- Name: maasserver_config_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_config_id_seq OWNER TO maas;

--
-- Name: maasserver_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_config_id_seq OWNED BY maasserver_config.id;


--
-- Name: maasserver_dhcpsnippet_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_dhcpsnippet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_dhcpsnippet_id_seq OWNER TO maas;

--
-- Name: maasserver_dhcpsnippet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_dhcpsnippet_id_seq OWNED BY maasserver_dhcpsnippet.id;


--
-- Name: maasserver_mdns; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_mdns (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    ip inet,
    hostname character varying(256),
    count integer NOT NULL,
    interface_id integer NOT NULL
);


ALTER TABLE maasserver_mdns OWNER TO maas;

--
-- Name: maasserver_neighbour; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_neighbour (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    ip inet,
    "time" integer NOT NULL,
    vid integer,
    count integer NOT NULL,
    mac_address macaddr,
    interface_id integer NOT NULL
);


ALTER TABLE maasserver_neighbour OWNER TO maas;

--
-- Name: maasserver_rdns; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_rdns (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    ip inet NOT NULL,
    hostname character varying(256),
    hostnames text NOT NULL,
    observer_id integer NOT NULL
);


ALTER TABLE maasserver_rdns OWNER TO maas;

--
-- Name: maasserver_discovery; Type: VIEW; Schema: public; Owner: maas
--

CREATE VIEW maasserver_discovery AS
 SELECT DISTINCT ON (neigh.mac_address, neigh.ip) neigh.id,
    replace(encode((((rtrim((neigh.ip)::text, '/32'::text) || ','::text) || (neigh.mac_address)::text))::bytea, 'base64'::text), chr(10), ''::text) AS discovery_id,
    neigh.id AS neighbour_id,
    neigh.ip,
    neigh.mac_address,
    neigh.vid,
    neigh.created AS first_seen,
    GREATEST(neigh.updated, mdns.updated) AS last_seen,
    mdns.id AS mdns_id,
    COALESCE(rdns.hostname, mdns.hostname) AS hostname,
    node.id AS observer_id,
    node.system_id AS observer_system_id,
    node.hostname AS observer_hostname,
    iface.id AS observer_interface_id,
    iface.name AS observer_interface_name,
    fabric.id AS fabric_id,
    fabric.name AS fabric_name,
    vlan.id AS vlan_id,
        CASE
            WHEN (neigh.ip = vlan.external_dhcp) THEN true
            ELSE false
        END AS is_external_dhcp,
    subnet.id AS subnet_id,
    subnet.cidr AS subnet_cidr,
    masklen((subnet.cidr)::inet) AS subnet_prefixlen
   FROM (((((((maasserver_neighbour neigh
     JOIN maasserver_interface iface ON ((neigh.interface_id = iface.id)))
     JOIN maasserver_node node ON ((node.id = iface.node_id)))
     JOIN maasserver_vlan vlan ON ((iface.vlan_id = vlan.id)))
     JOIN maasserver_fabric fabric ON ((vlan.fabric_id = fabric.id)))
     LEFT JOIN maasserver_mdns mdns ON ((mdns.ip = neigh.ip)))
     LEFT JOIN maasserver_rdns rdns ON ((rdns.ip = neigh.ip)))
     LEFT JOIN maasserver_subnet subnet ON (((vlan.id = subnet.vlan_id) AND (neigh.ip << (subnet.cidr)::inet))))
  ORDER BY neigh.mac_address, neigh.ip, neigh.updated DESC, rdns.updated DESC, mdns.updated DESC, (masklen((subnet.cidr)::inet)) DESC;


ALTER TABLE maasserver_discovery OWNER TO maas;

--
-- Name: maasserver_dnsdata; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_dnsdata (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    rrtype character varying(8) NOT NULL,
    rrdata text NOT NULL,
    dnsresource_id integer NOT NULL,
    ttl integer,
    CONSTRAINT maasserver_dnsdata_ttl_check CHECK ((ttl >= 0))
);


ALTER TABLE maasserver_dnsdata OWNER TO maas;

--
-- Name: maasserver_dnsdata_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_dnsdata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_dnsdata_id_seq OWNER TO maas;

--
-- Name: maasserver_dnsdata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_dnsdata_id_seq OWNED BY maasserver_dnsdata.id;


--
-- Name: maasserver_dnspublication; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_dnspublication (
    id integer NOT NULL,
    serial bigint NOT NULL,
    created timestamp with time zone NOT NULL,
    source character varying(255) NOT NULL
);


ALTER TABLE maasserver_dnspublication OWNER TO maas;

--
-- Name: maasserver_dnspublication_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_dnspublication_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_dnspublication_id_seq OWNER TO maas;

--
-- Name: maasserver_dnspublication_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_dnspublication_id_seq OWNED BY maasserver_dnspublication.id;


--
-- Name: maasserver_dnsresource; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_dnsresource (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(191),
    domain_id integer NOT NULL,
    address_ttl integer,
    CONSTRAINT maasserver_dnsresource_address_ttl_check CHECK ((address_ttl >= 0))
);


ALTER TABLE maasserver_dnsresource OWNER TO maas;

--
-- Name: maasserver_dnsresource_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_dnsresource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_dnsresource_id_seq OWNER TO maas;

--
-- Name: maasserver_dnsresource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_dnsresource_id_seq OWNED BY maasserver_dnsresource.id;


--
-- Name: maasserver_dnsresource_ip_addresses; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_dnsresource_ip_addresses (
    id integer NOT NULL,
    dnsresource_id integer NOT NULL,
    staticipaddress_id integer NOT NULL
);


ALTER TABLE maasserver_dnsresource_ip_addresses OWNER TO maas;

--
-- Name: maasserver_dnsresource_ip_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_dnsresource_ip_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_dnsresource_ip_addresses_id_seq OWNER TO maas;

--
-- Name: maasserver_dnsresource_ip_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_dnsresource_ip_addresses_id_seq OWNED BY maasserver_dnsresource_ip_addresses.id;


--
-- Name: maasserver_domain; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_domain (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(256) NOT NULL,
    authoritative boolean,
    ttl integer,
    CONSTRAINT maasserver_domain_ttl_check CHECK ((ttl >= 0))
);


ALTER TABLE maasserver_domain OWNER TO maas;

--
-- Name: maasserver_domain_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_domain_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_domain_id_seq OWNER TO maas;

--
-- Name: maasserver_domain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_domain_id_seq OWNED BY maasserver_domain.id;


--
-- Name: maasserver_event; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_event (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    action text NOT NULL,
    description text NOT NULL,
    node_id integer NOT NULL,
    type_id integer NOT NULL
);


ALTER TABLE maasserver_event OWNER TO maas;

--
-- Name: maasserver_event_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_event_id_seq OWNER TO maas;

--
-- Name: maasserver_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_event_id_seq OWNED BY maasserver_event.id;


--
-- Name: maasserver_eventtype; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_eventtype (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    level integer NOT NULL
);


ALTER TABLE maasserver_eventtype OWNER TO maas;

--
-- Name: maasserver_eventtype_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_eventtype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_eventtype_id_seq OWNER TO maas;

--
-- Name: maasserver_eventtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_eventtype_id_seq OWNED BY maasserver_eventtype.id;


--
-- Name: maasserver_fabric_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_fabric_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_fabric_id_seq OWNER TO maas;

--
-- Name: maasserver_fabric_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_fabric_id_seq OWNED BY maasserver_fabric.id;


--
-- Name: maasserver_fannetwork; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_fannetwork (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(256) NOT NULL,
    "overlay" cidr NOT NULL,
    underlay cidr NOT NULL,
    dhcp boolean,
    host_reserve integer,
    bridge character varying(255),
    off boolean,
    CONSTRAINT maasserver_fannetwork_host_reserve_check CHECK ((host_reserve >= 0))
);


ALTER TABLE maasserver_fannetwork OWNER TO maas;

--
-- Name: maasserver_fannetwork_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_fannetwork_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_fannetwork_id_seq OWNER TO maas;

--
-- Name: maasserver_fannetwork_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_fannetwork_id_seq OWNED BY maasserver_fannetwork.id;


--
-- Name: maasserver_filestorage; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_filestorage (
    id integer NOT NULL,
    filename character varying(255) NOT NULL,
    content text NOT NULL,
    key character varying(36) NOT NULL,
    owner_id integer
);


ALTER TABLE maasserver_filestorage OWNER TO maas;

--
-- Name: maasserver_filestorage_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_filestorage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_filestorage_id_seq OWNER TO maas;

--
-- Name: maasserver_filestorage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_filestorage_id_seq OWNED BY maasserver_filestorage.id;


--
-- Name: maasserver_filesystem; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_filesystem (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    uuid character varying(36) NOT NULL,
    fstype character varying(20) NOT NULL,
    label character varying(255),
    create_params character varying(255),
    mount_point character varying(255),
    mount_options character varying(255),
    acquired boolean NOT NULL,
    block_device_id integer,
    cache_set_id integer,
    filesystem_group_id integer,
    partition_id integer,
    node_id integer
);


ALTER TABLE maasserver_filesystem OWNER TO maas;

--
-- Name: maasserver_filesystem_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_filesystem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_filesystem_id_seq OWNER TO maas;

--
-- Name: maasserver_filesystem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_filesystem_id_seq OWNED BY maasserver_filesystem.id;


--
-- Name: maasserver_filesystemgroup; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_filesystemgroup (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    uuid character varying(36) NOT NULL,
    group_type character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    create_params character varying(255),
    cache_mode character varying(20),
    cache_set_id integer
);


ALTER TABLE maasserver_filesystemgroup OWNER TO maas;

--
-- Name: maasserver_filesystemgroup_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_filesystemgroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_filesystemgroup_id_seq OWNER TO maas;

--
-- Name: maasserver_filesystemgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_filesystemgroup_id_seq OWNED BY maasserver_filesystemgroup.id;


--
-- Name: maasserver_interface_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_interface_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_interface_id_seq OWNER TO maas;

--
-- Name: maasserver_interface_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_interface_id_seq OWNED BY maasserver_interface.id;


--
-- Name: maasserver_interface_ip_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_interface_ip_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_interface_ip_addresses_id_seq OWNER TO maas;

--
-- Name: maasserver_interface_ip_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_interface_ip_addresses_id_seq OWNED BY maasserver_interface_ip_addresses.id;


--
-- Name: maasserver_interfacerelationship; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_interfacerelationship (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    child_id integer NOT NULL,
    parent_id integer NOT NULL
);


ALTER TABLE maasserver_interfacerelationship OWNER TO maas;

--
-- Name: maasserver_interfacerelationship_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_interfacerelationship_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_interfacerelationship_id_seq OWNER TO maas;

--
-- Name: maasserver_interfacerelationship_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_interfacerelationship_id_seq OWNED BY maasserver_interfacerelationship.id;


--
-- Name: maasserver_iprange; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_iprange (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    type character varying(20) NOT NULL,
    start_ip inet NOT NULL,
    end_ip inet NOT NULL,
    comment character varying(255),
    subnet_id integer NOT NULL,
    user_id integer
);


ALTER TABLE maasserver_iprange OWNER TO maas;

--
-- Name: maasserver_iprange_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_iprange_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_iprange_id_seq OWNER TO maas;

--
-- Name: maasserver_iprange_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_iprange_id_seq OWNED BY maasserver_iprange.id;


--
-- Name: maasserver_iscsiblockdevice; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_iscsiblockdevice (
    blockdevice_ptr_id integer NOT NULL,
    target character varying(4096) NOT NULL
);


ALTER TABLE maasserver_iscsiblockdevice OWNER TO maas;

--
-- Name: maasserver_keysource; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_keysource (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    protocol character varying(64) NOT NULL,
    auth_id character varying(255) NOT NULL,
    auto_update boolean NOT NULL
);


ALTER TABLE maasserver_keysource OWNER TO maas;

--
-- Name: maasserver_keysource_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_keysource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_keysource_id_seq OWNER TO maas;

--
-- Name: maasserver_keysource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_keysource_id_seq OWNED BY maasserver_keysource.id;


--
-- Name: maasserver_largefile; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_largefile (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    sha256 character varying(64) NOT NULL,
    total_size bigint NOT NULL,
    content oid NOT NULL,
    size bigint NOT NULL
);


ALTER TABLE maasserver_largefile OWNER TO maas;

--
-- Name: maasserver_largefile_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_largefile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_largefile_id_seq OWNER TO maas;

--
-- Name: maasserver_largefile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_largefile_id_seq OWNED BY maasserver_largefile.id;


--
-- Name: maasserver_licensekey_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_licensekey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_licensekey_id_seq OWNER TO maas;

--
-- Name: maasserver_licensekey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_licensekey_id_seq OWNED BY maasserver_licensekey.id;


--
-- Name: maasserver_mdns_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_mdns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_mdns_id_seq OWNER TO maas;

--
-- Name: maasserver_mdns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_mdns_id_seq OWNED BY maasserver_mdns.id;


--
-- Name: maasserver_neighbour_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_neighbour_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_neighbour_id_seq OWNER TO maas;

--
-- Name: maasserver_neighbour_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_neighbour_id_seq OWNED BY maasserver_neighbour.id;


--
-- Name: maasserver_node_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_node_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_node_id_seq OWNER TO maas;

--
-- Name: maasserver_node_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_node_id_seq OWNED BY maasserver_node.id;


--
-- Name: maasserver_node_tags; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_node_tags (
    id integer NOT NULL,
    node_id integer NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE maasserver_node_tags OWNER TO maas;

--
-- Name: maasserver_node_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_node_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_node_tags_id_seq OWNER TO maas;

--
-- Name: maasserver_node_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_node_tags_id_seq OWNED BY maasserver_node_tags.id;


--
-- Name: maasserver_nodegrouptorackcontroller; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_nodegrouptorackcontroller (
    id integer NOT NULL,
    uuid character varying(36) NOT NULL,
    subnet_id integer NOT NULL
);


ALTER TABLE maasserver_nodegrouptorackcontroller OWNER TO maas;

--
-- Name: maasserver_nodegrouptorackcontroller_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_nodegrouptorackcontroller_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_nodegrouptorackcontroller_id_seq OWNER TO maas;

--
-- Name: maasserver_nodegrouptorackcontroller_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_nodegrouptorackcontroller_id_seq OWNED BY maasserver_nodegrouptorackcontroller.id;


--
-- Name: maasserver_notification; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_notification (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    ident character varying(40),
    users boolean NOT NULL,
    admins boolean NOT NULL,
    message text NOT NULL,
    context text NOT NULL,
    user_id integer,
    category character varying(10) NOT NULL
);


ALTER TABLE maasserver_notification OWNER TO maas;

--
-- Name: maasserver_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_notification_id_seq OWNER TO maas;

--
-- Name: maasserver_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_notification_id_seq OWNED BY maasserver_notification.id;


--
-- Name: maasserver_notificationdismissal; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_notificationdismissal (
    id integer NOT NULL,
    notification_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE maasserver_notificationdismissal OWNER TO maas;

--
-- Name: maasserver_notificationdismissal_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_notificationdismissal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_notificationdismissal_id_seq OWNER TO maas;

--
-- Name: maasserver_notificationdismissal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_notificationdismissal_id_seq OWNED BY maasserver_notificationdismissal.id;


--
-- Name: maasserver_ownerdata; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_ownerdata (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL,
    node_id integer NOT NULL
);


ALTER TABLE maasserver_ownerdata OWNER TO maas;

--
-- Name: maasserver_ownerdata_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_ownerdata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_ownerdata_id_seq OWNER TO maas;

--
-- Name: maasserver_ownerdata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_ownerdata_id_seq OWNED BY maasserver_ownerdata.id;


--
-- Name: maasserver_packagerepository; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_packagerepository (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(41) NOT NULL,
    url character varying(200) NOT NULL,
    components text[],
    arches text[],
    key text NOT NULL,
    "default" boolean NOT NULL,
    enabled boolean NOT NULL,
    disabled_pockets text[],
    distributions text[],
    disabled_components text[]
);


ALTER TABLE maasserver_packagerepository OWNER TO maas;

--
-- Name: maasserver_packagerepository_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_packagerepository_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_packagerepository_id_seq OWNER TO maas;

--
-- Name: maasserver_packagerepository_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_packagerepository_id_seq OWNED BY maasserver_packagerepository.id;


--
-- Name: maasserver_partition; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_partition (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    uuid character varying(36),
    size bigint NOT NULL,
    bootable boolean NOT NULL,
    partition_table_id integer NOT NULL
);


ALTER TABLE maasserver_partition OWNER TO maas;

--
-- Name: maasserver_partition_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_partition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_partition_id_seq OWNER TO maas;

--
-- Name: maasserver_partition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_partition_id_seq OWNED BY maasserver_partition.id;


--
-- Name: maasserver_partitiontable; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_partitiontable (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    table_type character varying(20) NOT NULL,
    block_device_id integer NOT NULL
);


ALTER TABLE maasserver_partitiontable OWNER TO maas;

--
-- Name: maasserver_partitiontable_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_partitiontable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_partitiontable_id_seq OWNER TO maas;

--
-- Name: maasserver_partitiontable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_partitiontable_id_seq OWNED BY maasserver_partitiontable.id;


--
-- Name: maasserver_physicalblockdevice; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_physicalblockdevice (
    blockdevice_ptr_id integer NOT NULL,
    model character varying(255) NOT NULL,
    serial character varying(255) NOT NULL
);


ALTER TABLE maasserver_physicalblockdevice OWNER TO maas;

--
-- Name: maasserver_podhints; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_podhints (
    id integer NOT NULL,
    cores integer NOT NULL,
    memory integer NOT NULL,
    local_storage bigint NOT NULL,
    local_disks integer NOT NULL,
    pod_id integer NOT NULL,
    cpu_speed integer NOT NULL,
    iscsi_storage bigint NOT NULL
);


ALTER TABLE maasserver_podhints OWNER TO maas;

--
-- Name: maasserver_podhints_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_podhints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_podhints_id_seq OWNER TO maas;

--
-- Name: maasserver_podhints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_podhints_id_seq OWNED BY maasserver_podhints.id;


--
-- Name: maasserver_rdns_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_rdns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_rdns_id_seq OWNER TO maas;

--
-- Name: maasserver_rdns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_rdns_id_seq OWNED BY maasserver_rdns.id;


--
-- Name: maasserver_regioncontrollerprocess_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_regioncontrollerprocess_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_regioncontrollerprocess_id_seq OWNER TO maas;

--
-- Name: maasserver_regioncontrollerprocess_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_regioncontrollerprocess_id_seq OWNED BY maasserver_regioncontrollerprocess.id;


--
-- Name: maasserver_regioncontrollerprocessendpoint; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_regioncontrollerprocessendpoint (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    address inet NOT NULL,
    port integer NOT NULL,
    process_id integer NOT NULL
);


ALTER TABLE maasserver_regioncontrollerprocessendpoint OWNER TO maas;

--
-- Name: maasserver_regioncontrollerprocessendpoint_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_regioncontrollerprocessendpoint_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_regioncontrollerprocessendpoint_id_seq OWNER TO maas;

--
-- Name: maasserver_regioncontrollerprocessendpoint_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_regioncontrollerprocessendpoint_id_seq OWNED BY maasserver_regioncontrollerprocessendpoint.id;


--
-- Name: maasserver_regionrackrpcconnection; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_regionrackrpcconnection (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    endpoint_id integer NOT NULL,
    rack_controller_id integer NOT NULL
);


ALTER TABLE maasserver_regionrackrpcconnection OWNER TO maas;

--
-- Name: maasserver_regionrackrpcconnection_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_regionrackrpcconnection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_regionrackrpcconnection_id_seq OWNER TO maas;

--
-- Name: maasserver_regionrackrpcconnection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_regionrackrpcconnection_id_seq OWNED BY maasserver_regionrackrpcconnection.id;


--
-- Name: maasserver_routable_pairs; Type: VIEW; Schema: public; Owner: maas
--

CREATE VIEW maasserver_routable_pairs AS
 SELECT if_left.node_id AS left_node_id,
    if_left.id AS left_interface_id,
    subnet_left.id AS left_subnet_id,
    vlan_left.id AS left_vlan_id,
    sip_left.ip AS left_ip,
    if_right.node_id AS right_node_id,
    if_right.id AS right_interface_id,
    subnet_right.id AS right_subnet_id,
    vlan_right.id AS right_vlan_id,
    sip_right.ip AS right_ip,
    vlan_left.space_id,
        CASE
            WHEN (if_left.node_id = if_right.node_id) THEN 0
            WHEN (subnet_left.id = subnet_right.id) THEN 1
            WHEN (vlan_left.id = vlan_right.id) THEN 2
            WHEN (vlan_left.space_id IS NOT NULL) THEN 3
            ELSE 4
        END AS metric
   FROM (((((((((maasserver_interface if_left
     JOIN maasserver_interface_ip_addresses ifia_left ON ((if_left.id = ifia_left.interface_id)))
     JOIN maasserver_staticipaddress sip_left ON ((ifia_left.staticipaddress_id = sip_left.id)))
     JOIN maasserver_subnet subnet_left ON ((sip_left.subnet_id = subnet_left.id)))
     JOIN maasserver_vlan vlan_left ON ((subnet_left.vlan_id = vlan_left.id)))
     JOIN maasserver_vlan vlan_right ON ((NOT (vlan_left.space_id IS DISTINCT FROM vlan_right.space_id))))
     JOIN maasserver_subnet subnet_right ON ((vlan_right.id = subnet_right.vlan_id)))
     JOIN maasserver_staticipaddress sip_right ON ((subnet_right.id = sip_right.subnet_id)))
     JOIN maasserver_interface_ip_addresses ifia_right ON ((sip_right.id = ifia_right.staticipaddress_id)))
     JOIN maasserver_interface if_right ON ((ifia_right.interface_id = if_right.id)))
  WHERE (if_left.enabled AND (sip_left.ip IS NOT NULL) AND if_right.enabled AND (sip_right.ip IS NOT NULL) AND (family(sip_left.ip) = family(sip_right.ip)));


ALTER TABLE maasserver_routable_pairs OWNER TO maas;

--
-- Name: maasserver_service; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_service (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    status character varying(10) NOT NULL,
    status_info character varying(255) NOT NULL,
    node_id integer NOT NULL
);


ALTER TABLE maasserver_service OWNER TO maas;

--
-- Name: maasserver_service_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_service_id_seq OWNER TO maas;

--
-- Name: maasserver_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_service_id_seq OWNED BY maasserver_service.id;


--
-- Name: maasserver_space; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_space (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(256),
    description text NOT NULL
);


ALTER TABLE maasserver_space OWNER TO maas;

--
-- Name: maasserver_space_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_space_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_space_id_seq OWNER TO maas;

--
-- Name: maasserver_space_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_space_id_seq OWNED BY maasserver_space.id;


--
-- Name: maasserver_sshkey_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_sshkey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_sshkey_id_seq OWNER TO maas;

--
-- Name: maasserver_sshkey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_sshkey_id_seq OWNED BY maasserver_sshkey.id;


--
-- Name: maasserver_sslkey; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_sslkey (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    key text NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE maasserver_sslkey OWNER TO maas;

--
-- Name: maasserver_sslkey_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_sslkey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_sslkey_id_seq OWNER TO maas;

--
-- Name: maasserver_sslkey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_sslkey_id_seq OWNED BY maasserver_sslkey.id;


--
-- Name: maasserver_staticipaddress_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_staticipaddress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_staticipaddress_id_seq OWNER TO maas;

--
-- Name: maasserver_staticipaddress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_staticipaddress_id_seq OWNED BY maasserver_staticipaddress.id;


--
-- Name: maasserver_staticroute; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_staticroute (
    id integer NOT NULL,
    gateway_ip inet NOT NULL,
    metric integer NOT NULL,
    destination_id integer NOT NULL,
    source_id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    CONSTRAINT maasserver_staticroute_metric_check CHECK ((metric >= 0))
);


ALTER TABLE maasserver_staticroute OWNER TO maas;

--
-- Name: maasserver_staticroute_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_staticroute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_staticroute_id_seq OWNER TO maas;

--
-- Name: maasserver_staticroute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_staticroute_id_seq OWNED BY maasserver_staticroute.id;


--
-- Name: maasserver_subnet_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_subnet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_subnet_id_seq OWNER TO maas;

--
-- Name: maasserver_subnet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_subnet_id_seq OWNED BY maasserver_subnet.id;


--
-- Name: maasserver_tag; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_tag (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(256) NOT NULL,
    definition text NOT NULL,
    comment text NOT NULL,
    kernel_opts text
);


ALTER TABLE maasserver_tag OWNER TO maas;

--
-- Name: maasserver_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_tag_id_seq OWNER TO maas;

--
-- Name: maasserver_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_tag_id_seq OWNED BY maasserver_tag.id;


--
-- Name: maasserver_template; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_template (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    filename character varying(64) NOT NULL,
    default_version_id integer NOT NULL,
    version_id integer
);


ALTER TABLE maasserver_template OWNER TO maas;

--
-- Name: maasserver_template_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_template_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_template_id_seq OWNER TO maas;

--
-- Name: maasserver_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_template_id_seq OWNED BY maasserver_template.id;


--
-- Name: maasserver_userprofile; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_userprofile (
    id integer NOT NULL,
    user_id integer NOT NULL,
    completed_intro boolean NOT NULL
);


ALTER TABLE maasserver_userprofile OWNER TO maas;

--
-- Name: maasserver_userprofile_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_userprofile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_userprofile_id_seq OWNER TO maas;

--
-- Name: maasserver_userprofile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_userprofile_id_seq OWNED BY maasserver_userprofile.id;


--
-- Name: maasserver_versionedtextfile; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_versionedtextfile (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    data text,
    comment character varying(255),
    previous_version_id integer
);


ALTER TABLE maasserver_versionedtextfile OWNER TO maas;

--
-- Name: maasserver_versionedtextfile_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_versionedtextfile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_versionedtextfile_id_seq OWNER TO maas;

--
-- Name: maasserver_versionedtextfile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_versionedtextfile_id_seq OWNED BY maasserver_versionedtextfile.id;


--
-- Name: maasserver_virtualblockdevice; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_virtualblockdevice (
    blockdevice_ptr_id integer NOT NULL,
    uuid character varying(36) NOT NULL,
    filesystem_group_id integer NOT NULL
);


ALTER TABLE maasserver_virtualblockdevice OWNER TO maas;

--
-- Name: maasserver_vlan_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_vlan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_vlan_id_seq OWNER TO maas;

--
-- Name: maasserver_vlan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_vlan_id_seq OWNED BY maasserver_vlan.id;


--
-- Name: maasserver_zone; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE maasserver_zone (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(256) NOT NULL,
    description text NOT NULL
);


ALTER TABLE maasserver_zone OWNER TO maas;

--
-- Name: maasserver_zone_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_zone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maasserver_zone_id_seq OWNER TO maas;

--
-- Name: maasserver_zone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_zone_id_seq OWNED BY maasserver_zone.id;


--
-- Name: maasserver_zone_serial_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE maasserver_zone_serial_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 4294967295
    CACHE 1
    CYCLE;


ALTER TABLE maasserver_zone_serial_seq OWNER TO maas;

--
-- Name: maasserver_zone_serial_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE maasserver_zone_serial_seq OWNED BY maasserver_dnspublication.serial;


--
-- Name: metadataserver_nodekey; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE metadataserver_nodekey (
    id integer NOT NULL,
    key character varying(18) NOT NULL,
    node_id integer NOT NULL,
    token_id integer NOT NULL
);


ALTER TABLE metadataserver_nodekey OWNER TO maas;

--
-- Name: metadataserver_nodekey_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE metadataserver_nodekey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE metadataserver_nodekey_id_seq OWNER TO maas;

--
-- Name: metadataserver_nodekey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE metadataserver_nodekey_id_seq OWNED BY metadataserver_nodekey.id;


--
-- Name: metadataserver_nodeuserdata; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE metadataserver_nodeuserdata (
    id integer NOT NULL,
    data text NOT NULL,
    node_id integer NOT NULL
);


ALTER TABLE metadataserver_nodeuserdata OWNER TO maas;

--
-- Name: metadataserver_nodeuserdata_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE metadataserver_nodeuserdata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE metadataserver_nodeuserdata_id_seq OWNER TO maas;

--
-- Name: metadataserver_nodeuserdata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE metadataserver_nodeuserdata_id_seq OWNED BY metadataserver_nodeuserdata.id;


--
-- Name: metadataserver_script; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE metadataserver_script (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    tags text[],
    script_type integer NOT NULL,
    timeout interval NOT NULL,
    destructive boolean NOT NULL,
    "default" boolean NOT NULL,
    script_id integer NOT NULL,
    title character varying(255) NOT NULL
);


ALTER TABLE metadataserver_script OWNER TO maas;

--
-- Name: metadataserver_script_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE metadataserver_script_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE metadataserver_script_id_seq OWNER TO maas;

--
-- Name: metadataserver_script_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE metadataserver_script_id_seq OWNED BY metadataserver_script.id;


--
-- Name: metadataserver_scriptresult; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE metadataserver_scriptresult (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    status integer NOT NULL,
    exit_status integer,
    script_name character varying(255),
    stdout text NOT NULL,
    stderr text NOT NULL,
    result text NOT NULL,
    script_id integer,
    script_set_id integer NOT NULL,
    script_version_id integer,
    output text NOT NULL,
    ended timestamp with time zone,
    started timestamp with time zone
);


ALTER TABLE metadataserver_scriptresult OWNER TO maas;

--
-- Name: metadataserver_scriptresult_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE metadataserver_scriptresult_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE metadataserver_scriptresult_id_seq OWNER TO maas;

--
-- Name: metadataserver_scriptresult_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE metadataserver_scriptresult_id_seq OWNED BY metadataserver_scriptresult.id;


--
-- Name: metadataserver_scriptset; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE metadataserver_scriptset (
    id integer NOT NULL,
    last_ping timestamp with time zone,
    result_type integer NOT NULL,
    node_id integer NOT NULL,
    power_state_before_transition character varying(10) NOT NULL
);


ALTER TABLE metadataserver_scriptset OWNER TO maas;

--
-- Name: metadataserver_scriptset_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE metadataserver_scriptset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE metadataserver_scriptset_id_seq OWNER TO maas;

--
-- Name: metadataserver_scriptset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE metadataserver_scriptset_id_seq OWNED BY metadataserver_scriptset.id;


--
-- Name: piston3_consumer; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE piston3_consumer (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    key character varying(18) NOT NULL,
    secret character varying(32) NOT NULL,
    status character varying(16) NOT NULL,
    user_id integer
);


ALTER TABLE piston3_consumer OWNER TO maas;

--
-- Name: piston3_consumer_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE piston3_consumer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE piston3_consumer_id_seq OWNER TO maas;

--
-- Name: piston3_consumer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE piston3_consumer_id_seq OWNED BY piston3_consumer.id;


--
-- Name: piston3_nonce; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE piston3_nonce (
    id integer NOT NULL,
    token_key character varying(18) NOT NULL,
    consumer_key character varying(18) NOT NULL,
    key character varying(255) NOT NULL
);


ALTER TABLE piston3_nonce OWNER TO maas;

--
-- Name: piston3_nonce_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE piston3_nonce_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE piston3_nonce_id_seq OWNER TO maas;

--
-- Name: piston3_nonce_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE piston3_nonce_id_seq OWNED BY piston3_nonce.id;


--
-- Name: piston3_token; Type: TABLE; Schema: public; Owner: maas
--

CREATE TABLE piston3_token (
    id integer NOT NULL,
    key character varying(18) NOT NULL,
    secret character varying(32) NOT NULL,
    verifier character varying(10) NOT NULL,
    token_type integer NOT NULL,
    "timestamp" integer NOT NULL,
    is_approved boolean NOT NULL,
    callback character varying(255),
    callback_confirmed boolean NOT NULL,
    consumer_id integer NOT NULL,
    user_id integer
);


ALTER TABLE piston3_token OWNER TO maas;

--
-- Name: piston3_token_id_seq; Type: SEQUENCE; Schema: public; Owner: maas
--

CREATE SEQUENCE piston3_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE piston3_token_id_seq OWNER TO maas;

--
-- Name: piston3_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maas
--

ALTER SEQUENCE piston3_token_id_seq OWNED BY piston3_token.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY django_migrations ALTER COLUMN id SET DEFAULT nextval('django_migrations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY django_site ALTER COLUMN id SET DEFAULT nextval('django_site_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_blockdevice ALTER COLUMN id SET DEFAULT nextval('maasserver_blockdevice_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bmc ALTER COLUMN id SET DEFAULT nextval('maasserver_bmc_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bmcroutablerackcontrollerrelationship ALTER COLUMN id SET DEFAULT nextval('maasserver_bmcroutablerackcontrollerrelationship_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootresource ALTER COLUMN id SET DEFAULT nextval('maasserver_bootresource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootresourcefile ALTER COLUMN id SET DEFAULT nextval('maasserver_bootresourcefile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootresourceset ALTER COLUMN id SET DEFAULT nextval('maasserver_bootresourceset_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootsource ALTER COLUMN id SET DEFAULT nextval('maasserver_bootsource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootsourcecache ALTER COLUMN id SET DEFAULT nextval('maasserver_bootsourcecache_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootsourceselection ALTER COLUMN id SET DEFAULT nextval('maasserver_bootsourceselection_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_cacheset ALTER COLUMN id SET DEFAULT nextval('maasserver_cacheset_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_config ALTER COLUMN id SET DEFAULT nextval('maasserver_config_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dhcpsnippet ALTER COLUMN id SET DEFAULT nextval('maasserver_dhcpsnippet_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnsdata ALTER COLUMN id SET DEFAULT nextval('maasserver_dnsdata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnspublication ALTER COLUMN id SET DEFAULT nextval('maasserver_dnspublication_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnsresource ALTER COLUMN id SET DEFAULT nextval('maasserver_dnsresource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnsresource_ip_addresses ALTER COLUMN id SET DEFAULT nextval('maasserver_dnsresource_ip_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_domain ALTER COLUMN id SET DEFAULT nextval('maasserver_domain_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_event ALTER COLUMN id SET DEFAULT nextval('maasserver_event_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_eventtype ALTER COLUMN id SET DEFAULT nextval('maasserver_eventtype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_fabric ALTER COLUMN id SET DEFAULT nextval('maasserver_fabric_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_fannetwork ALTER COLUMN id SET DEFAULT nextval('maasserver_fannetwork_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filestorage ALTER COLUMN id SET DEFAULT nextval('maasserver_filestorage_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystem ALTER COLUMN id SET DEFAULT nextval('maasserver_filesystem_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystemgroup ALTER COLUMN id SET DEFAULT nextval('maasserver_filesystemgroup_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interface ALTER COLUMN id SET DEFAULT nextval('maasserver_interface_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interface_ip_addresses ALTER COLUMN id SET DEFAULT nextval('maasserver_interface_ip_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interfacerelationship ALTER COLUMN id SET DEFAULT nextval('maasserver_interfacerelationship_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_iprange ALTER COLUMN id SET DEFAULT nextval('maasserver_iprange_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_keysource ALTER COLUMN id SET DEFAULT nextval('maasserver_keysource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_largefile ALTER COLUMN id SET DEFAULT nextval('maasserver_largefile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_licensekey ALTER COLUMN id SET DEFAULT nextval('maasserver_licensekey_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_mdns ALTER COLUMN id SET DEFAULT nextval('maasserver_mdns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_neighbour ALTER COLUMN id SET DEFAULT nextval('maasserver_neighbour_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node ALTER COLUMN id SET DEFAULT nextval('maasserver_node_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node_tags ALTER COLUMN id SET DEFAULT nextval('maasserver_node_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_nodegrouptorackcontroller ALTER COLUMN id SET DEFAULT nextval('maasserver_nodegrouptorackcontroller_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_notification ALTER COLUMN id SET DEFAULT nextval('maasserver_notification_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_notificationdismissal ALTER COLUMN id SET DEFAULT nextval('maasserver_notificationdismissal_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_ownerdata ALTER COLUMN id SET DEFAULT nextval('maasserver_ownerdata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_packagerepository ALTER COLUMN id SET DEFAULT nextval('maasserver_packagerepository_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_partition ALTER COLUMN id SET DEFAULT nextval('maasserver_partition_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_partitiontable ALTER COLUMN id SET DEFAULT nextval('maasserver_partitiontable_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_podhints ALTER COLUMN id SET DEFAULT nextval('maasserver_podhints_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_rdns ALTER COLUMN id SET DEFAULT nextval('maasserver_rdns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regioncontrollerprocess ALTER COLUMN id SET DEFAULT nextval('maasserver_regioncontrollerprocess_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regioncontrollerprocessendpoint ALTER COLUMN id SET DEFAULT nextval('maasserver_regioncontrollerprocessendpoint_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regionrackrpcconnection ALTER COLUMN id SET DEFAULT nextval('maasserver_regionrackrpcconnection_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_service ALTER COLUMN id SET DEFAULT nextval('maasserver_service_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_space ALTER COLUMN id SET DEFAULT nextval('maasserver_space_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_sshkey ALTER COLUMN id SET DEFAULT nextval('maasserver_sshkey_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_sslkey ALTER COLUMN id SET DEFAULT nextval('maasserver_sslkey_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_staticipaddress ALTER COLUMN id SET DEFAULT nextval('maasserver_staticipaddress_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_staticroute ALTER COLUMN id SET DEFAULT nextval('maasserver_staticroute_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_subnet ALTER COLUMN id SET DEFAULT nextval('maasserver_subnet_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_tag ALTER COLUMN id SET DEFAULT nextval('maasserver_tag_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_template ALTER COLUMN id SET DEFAULT nextval('maasserver_template_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_userprofile ALTER COLUMN id SET DEFAULT nextval('maasserver_userprofile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_versionedtextfile ALTER COLUMN id SET DEFAULT nextval('maasserver_versionedtextfile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_vlan ALTER COLUMN id SET DEFAULT nextval('maasserver_vlan_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_zone ALTER COLUMN id SET DEFAULT nextval('maasserver_zone_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_nodekey ALTER COLUMN id SET DEFAULT nextval('metadataserver_nodekey_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_nodeuserdata ALTER COLUMN id SET DEFAULT nextval('metadataserver_nodeuserdata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_script ALTER COLUMN id SET DEFAULT nextval('metadataserver_script_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_scriptresult ALTER COLUMN id SET DEFAULT nextval('metadataserver_scriptresult_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_scriptset ALTER COLUMN id SET DEFAULT nextval('metadataserver_scriptset_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY piston3_consumer ALTER COLUMN id SET DEFAULT nextval('piston3_consumer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY piston3_nonce ALTER COLUMN id SET DEFAULT nextval('piston3_nonce_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: maas
--

ALTER TABLE ONLY piston3_token ALTER COLUMN id SET DEFAULT nextval('piston3_token_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY auth_group (id, name) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('auth_group_id_seq', 1, false);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add permission	1	add_permission
2	Can change permission	1	change_permission
3	Can delete permission	1	delete_permission
4	Can add group	2	add_group
5	Can change group	2	change_group
6	Can delete group	2	delete_group
7	Can add user	3	add_user
8	Can change user	3	change_user
9	Can delete user	3	delete_user
10	Can add content type	4	add_contenttype
11	Can change content type	4	change_contenttype
12	Can delete content type	4	delete_contenttype
13	Can add session	5	add_session
14	Can change session	5	change_session
15	Can delete session	5	delete_session
16	Can add site	6	add_site
17	Can change site	6	change_site
18	Can delete site	6	delete_site
19	Can add block device	7	add_blockdevice
20	Can change block device	7	change_blockdevice
21	Can delete block device	7	delete_blockdevice
22	Can add VersionedTextFile	8	add_versionedtextfile
23	Can change VersionedTextFile	8	change_versionedtextfile
24	Can delete VersionedTextFile	8	delete_versionedtextfile
25	Can add config	9	add_config
26	Can change config	9	change_config
27	Can delete config	9	delete_config
28	Can add Domain	10	add_domain
29	Can change Domain	10	change_domain
30	Can delete Domain	10	delete_domain
31	Can add static route	11	add_staticroute
32	Can change static route	11	change_staticroute
33	Can delete static route	11	delete_staticroute
34	Can add subnet	12	add_subnet
35	Can change subnet	12	change_subnet
36	Can delete subnet	12	delete_subnet
37	Can add Static IP Address	13	add_staticipaddress
38	Can change Static IP Address	13	change_staticipaddress
39	Can delete Static IP Address	13	delete_staticipaddress
40	Can add Interface	14	add_interface
41	Can change Interface	14	change_interface
42	Can delete Interface	14	delete_interface
43	Can add interface relationship	15	add_interfacerelationship
44	Can change interface relationship	15	change_interfacerelationship
45	Can delete interface relationship	15	delete_interfacerelationship
46	Can add Physical interface	14	add_physicalinterface
47	Can change Physical interface	14	change_physicalinterface
48	Can delete Physical interface	14	delete_physicalinterface
49	Can add child interface	14	add_childinterface
50	Can change child interface	14	change_childinterface
51	Can delete child interface	14	delete_childinterface
52	Can add Bridge	14	add_bridgeinterface
53	Can change Bridge	14	change_bridgeinterface
54	Can delete Bridge	14	delete_bridgeinterface
55	Can add Bond	14	add_bondinterface
56	Can change Bond	14	change_bondinterface
57	Can delete Bond	14	delete_bondinterface
58	Can add VLAN interface	14	add_vlaninterface
59	Can change VLAN interface	14	change_vlaninterface
60	Can delete VLAN interface	14	delete_vlaninterface
61	Can add Unknown interface	14	add_unknowninterface
62	Can change Unknown interface	14	change_unknowninterface
63	Can delete Unknown interface	14	delete_unknowninterface
64	Can add Fabric	16	add_fabric
65	Can change Fabric	16	change_fabric
66	Can delete Fabric	16	delete_fabric
67	Can add iscsi block device	17	add_iscsiblockdevice
68	Can change iscsi block device	17	change_iscsiblockdevice
69	Can delete iscsi block device	17	delete_iscsiblockdevice
70	Can add boot source	18	add_bootsource
71	Can change boot source	18	change_bootsource
72	Can delete boot source	18	delete_bootsource
73	Can add boot source cache	19	add_bootsourcecache
74	Can change boot source cache	19	change_bootsourcecache
75	Can delete boot source cache	19	delete_bootsourcecache
76	Can add boot resource	20	add_bootresource
77	Can change boot resource	20	change_bootresource
78	Can delete boot resource	20	delete_bootresource
79	Can add cache set	21	add_cacheset
80	Can change cache set	21	change_cacheset
81	Can delete cache set	21	delete_cacheset
82	Can add filesystem group	22	add_filesystemgroup
83	Can change filesystem group	22	change_filesystemgroup
84	Can delete filesystem group	22	delete_filesystemgroup
85	Can add volume group	22	add_volumegroup
86	Can change volume group	22	change_volumegroup
87	Can delete volume group	22	delete_volumegroup
88	Can add raid	22	add_raid
89	Can change raid	22	change_raid
90	Can delete raid	22	delete_raid
91	Can add bcache	22	add_bcache
92	Can change bcache	22	change_bcache
93	Can delete bcache	22	delete_bcache
94	Can add partition	23	add_partition
95	Can change partition	23	change_partition
96	Can delete partition	23	delete_partition
97	Can add filesystem	24	add_filesystem
98	Can change filesystem	24	change_filesystem
99	Can delete filesystem	24	delete_filesystem
100	Can add license key	25	add_licensekey
101	Can change license key	25	change_licensekey
102	Can delete license key	25	delete_licensekey
103	Can add owner data	26	add_ownerdata
104	Can change owner data	26	change_ownerdata
105	Can delete owner data	26	delete_ownerdata
106	Can add partition table	27	add_partitiontable
107	Can change partition table	27	change_partitiontable
108	Can delete partition table	27	delete_partitiontable
109	Can add physical block device	28	add_physicalblockdevice
110	Can change physical block device	28	change_physicalblockdevice
111	Can delete physical block device	28	delete_physicalblockdevice
112	Can add service	29	add_service
113	Can change service	29	change_service
114	Can delete service	29	delete_service
115	Can add tag	30	add_tag
116	Can change tag	30	change_tag
117	Can delete tag	30	delete_tag
118	Can add notification	31	add_notification
119	Can change notification	31	change_notification
120	Can delete notification	31	delete_notification
121	Can add notification dismissal	32	add_notificationdismissal
122	Can change notification dismissal	32	change_notificationdismissal
123	Can delete notification dismissal	32	delete_notificationdismissal
124	Can add VLAN	33	add_vlan
125	Can change VLAN	33	change_vlan
126	Can delete VLAN	33	delete_vlan
127	Can add Physical zone	34	add_zone
128	Can change Physical zone	34	change_zone
129	Can delete Physical zone	34	delete_zone
130	Can add node	35	add_node
131	Can change node	35	change_node
132	Can delete node	35	delete_node
133	Can add machine	35	add_machine
134	Can change machine	35	change_machine
135	Can delete machine	35	delete_machine
136	Can add controller	35	add_controller
137	Can change controller	35	change_controller
138	Can delete controller	35	delete_controller
139	Can add rack controller	35	add_rackcontroller
140	Can change rack controller	35	change_rackcontroller
141	Can delete rack controller	35	delete_rackcontroller
142	Can add region controller	35	add_regioncontroller
143	Can change region controller	35	change_regioncontroller
144	Can delete region controller	35	delete_regioncontroller
145	Can add device	35	add_device
146	Can change device	35	change_device
147	Can delete device	35	delete_device
148	Can add node group to rack controller	36	add_nodegrouptorackcontroller
149	Can change node group to rack controller	36	change_nodegrouptorackcontroller
150	Can delete node group to rack controller	36	delete_nodegrouptorackcontroller
151	Can add pod hints	37	add_podhints
152	Can change pod hints	37	change_podhints
153	Can delete pod hints	37	delete_podhints
154	Can add bmc	38	add_bmc
155	Can change bmc	38	change_bmc
156	Can delete bmc	38	delete_bmc
157	Can add pod	38	add_pod
158	Can change pod	38	change_pod
159	Can delete pod	38	delete_pod
160	Can add bmc routable rack controller relationship	39	add_bmcroutablerackcontrollerrelationship
161	Can change bmc routable rack controller relationship	39	change_bmcroutablerackcontrollerrelationship
162	Can delete bmc routable rack controller relationship	39	delete_bmcroutablerackcontrollerrelationship
163	Can add boot resource set	40	add_bootresourceset
164	Can change boot resource set	40	change_bootresourceset
165	Can delete boot resource set	40	delete_bootresourceset
166	Can add large file	41	add_largefile
167	Can change large file	41	change_largefile
168	Can delete large file	41	delete_largefile
169	Can add boot resource file	42	add_bootresourcefile
170	Can change boot resource file	42	change_bootresourcefile
171	Can delete boot resource file	42	delete_bootresourcefile
172	Can add boot source selection	43	add_bootsourceselection
173	Can change boot source selection	43	change_bootsourceselection
174	Can delete boot source selection	43	delete_bootsourceselection
175	Can add dhcp snippet	44	add_dhcpsnippet
176	Can change dhcp snippet	44	change_dhcpsnippet
177	Can delete dhcp snippet	44	delete_dhcpsnippet
178	Can add Discovery	45	add_discovery
179	Can change Discovery	45	change_discovery
180	Can delete Discovery	45	delete_discovery
181	Can add DNSResource	46	add_dnsresource
182	Can change DNSResource	46	change_dnsresource
183	Can delete DNSResource	46	delete_dnsresource
184	Can add DNSData	47	add_dnsdata
185	Can change DNSData	47	change_dnsdata
186	Can delete DNSData	47	delete_dnsdata
187	Can add dns publication	48	add_dnspublication
188	Can change dns publication	48	change_dnspublication
189	Can delete dns publication	48	delete_dnspublication
190	Can add Event type	49	add_eventtype
191	Can change Event type	49	change_eventtype
192	Can delete Event type	49	delete_eventtype
193	Can add Event record	50	add_event
194	Can change Event record	50	change_event
195	Can delete Event record	50	delete_event
196	Can add Fan Network	51	add_fannetwork
197	Can change Fan Network	51	change_fannetwork
198	Can delete Fan Network	51	delete_fannetwork
199	Can add file storage	52	add_filestorage
200	Can change file storage	52	change_filestorage
201	Can delete file storage	52	delete_filestorage
202	Can add ip range	53	add_iprange
203	Can change ip range	53	change_iprange
204	Can delete ip range	53	delete_iprange
205	Can add Key Source	54	add_keysource
206	Can change Key Source	54	change_keysource
207	Can delete Key Source	54	delete_keysource
208	Can add mDNS binding	55	add_mdns
209	Can change mDNS binding	55	change_mdns
210	Can delete mDNS binding	55	delete_mdns
211	Can add Neighbour	56	add_neighbour
212	Can change Neighbour	56	change_neighbour
213	Can delete Neighbour	56	delete_neighbour
214	Can add package repository	57	add_packagerepository
215	Can change package repository	57	change_packagerepository
216	Can delete package repository	57	delete_packagerepository
217	Can add Reverse-DNS entry	58	add_rdns
218	Can change Reverse-DNS entry	58	change_rdns
219	Can delete Reverse-DNS entry	58	delete_rdns
220	Can add region controller process	59	add_regioncontrollerprocess
221	Can change region controller process	59	change_regioncontrollerprocess
222	Can delete region controller process	59	delete_regioncontrollerprocess
223	Can add region controller process endpoint	60	add_regioncontrollerprocessendpoint
224	Can change region controller process endpoint	60	change_regioncontrollerprocessendpoint
225	Can delete region controller process endpoint	60	delete_regioncontrollerprocessendpoint
226	Can add region rack rpc connection	61	add_regionrackrpcconnection
227	Can change region rack rpc connection	61	change_regionrackrpcconnection
228	Can delete region rack rpc connection	61	delete_regionrackrpcconnection
229	Can add Space	62	add_space
230	Can change Space	62	change_space
231	Can delete Space	62	delete_space
232	Can add SSH key	63	add_sshkey
233	Can change SSH key	63	change_sshkey
234	Can delete SSH key	63	delete_sshkey
235	Can add SSL key	64	add_sslkey
236	Can change SSL key	64	change_sslkey
237	Can delete SSL key	64	delete_sslkey
238	Can add Template	65	add_template
239	Can change Template	65	change_template
240	Can delete Template	65	delete_template
241	Can add user profile	66	add_userprofile
242	Can change user profile	66	change_userprofile
243	Can delete user profile	66	delete_userprofile
244	Can add virtual block device	67	add_virtualblockdevice
245	Can change virtual block device	67	change_virtualblockdevice
246	Can delete virtual block device	67	delete_virtualblockdevice
247	Can add node key	83	add_nodekey
248	Can change node key	83	change_nodekey
249	Can delete node key	83	delete_nodekey
250	Can add node user data	84	add_nodeuserdata
251	Can change node user data	84	change_nodeuserdata
252	Can delete node user data	84	delete_nodeuserdata
253	Can add script	85	add_script
254	Can change script	85	change_script
255	Can delete script	85	delete_script
256	Can add script set	86	add_scriptset
257	Can change script set	86	change_scriptset
258	Can delete script set	86	delete_scriptset
259	Can add script result	87	add_scriptresult
260	Can change script result	87	change_scriptresult
261	Can delete script result	87	delete_scriptresult
262	Can add nonce	88	add_nonce
263	Can change nonce	88	change_nonce
264	Can delete nonce	88	delete_nonce
265	Can add consumer	89	add_consumer
266	Can change consumer	89	change_consumer
267	Can delete consumer	89	delete_consumer
268	Can add token	90	add_token
269	Can change token	90	change_token
270	Can delete token	90	delete_token
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('auth_permission_id_seq', 270, true);


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1		\N	f	MAAS	MAAS	Special user	maas@localhost	f	t	2017-08-14 23:10:01.691831+00
2		\N	f	maas-init-node	Node-init user	Special user	node-init-user@localhost	f	f	2017-08-14 23:10:04.208375+00
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('auth_user_id_seq', 2, true);


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 1, false);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY django_content_type (id, app_label, model) FROM stdin;
1	auth	permission
2	auth	group
3	auth	user
4	contenttypes	contenttype
5	sessions	session
6	sites	site
7	maasserver	blockdevice
8	maasserver	versionedtextfile
9	maasserver	config
10	maasserver	domain
11	maasserver	staticroute
12	maasserver	subnet
13	maasserver	staticipaddress
14	maasserver	interface
15	maasserver	interfacerelationship
16	maasserver	fabric
17	maasserver	iscsiblockdevice
18	maasserver	bootsource
19	maasserver	bootsourcecache
20	maasserver	bootresource
21	maasserver	cacheset
22	maasserver	filesystemgroup
23	maasserver	partition
24	maasserver	filesystem
25	maasserver	licensekey
26	maasserver	ownerdata
27	maasserver	partitiontable
28	maasserver	physicalblockdevice
29	maasserver	service
30	maasserver	tag
31	maasserver	notification
32	maasserver	notificationdismissal
33	maasserver	vlan
34	maasserver	zone
35	maasserver	node
36	maasserver	nodegrouptorackcontroller
37	maasserver	podhints
38	maasserver	bmc
39	maasserver	bmcroutablerackcontrollerrelationship
40	maasserver	bootresourceset
41	maasserver	largefile
42	maasserver	bootresourcefile
43	maasserver	bootsourceselection
44	maasserver	dhcpsnippet
45	maasserver	discovery
46	maasserver	dnsresource
47	maasserver	dnsdata
48	maasserver	dnspublication
49	maasserver	eventtype
50	maasserver	event
51	maasserver	fannetwork
52	maasserver	filestorage
53	maasserver	iprange
54	maasserver	keysource
55	maasserver	mdns
56	maasserver	neighbour
57	maasserver	packagerepository
58	maasserver	rdns
59	maasserver	regioncontrollerprocess
60	maasserver	regioncontrollerprocessendpoint
61	maasserver	regionrackrpcconnection
62	maasserver	space
63	maasserver	sshkey
64	maasserver	sslkey
65	maasserver	template
66	maasserver	userprofile
67	maasserver	virtualblockdevice
68	maasserver	raid
69	maasserver	unknowninterface
70	maasserver	rackcontroller
71	maasserver	device
72	maasserver	volumegroup
73	maasserver	machine
74	maasserver	vlaninterface
75	maasserver	pod
76	maasserver	regioncontroller
77	maasserver	bridgeinterface
78	maasserver	bcache
79	maasserver	controller
80	maasserver	bondinterface
81	maasserver	physicalinterface
82	maasserver	childinterface
83	metadataserver	nodekey
84	metadataserver	nodeuserdata
85	metadataserver	script
86	metadataserver	scriptset
87	metadataserver	scriptresult
88	piston3	nonce
89	piston3	consumer
90	piston3	token
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('django_content_type_id_seq', 90, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2017-08-14 23:08:53.206086+00
2	auth	0001_initial	2017-08-14 23:08:54.093012+00
3	auth	0002_auto_20151119_1629	2017-08-14 23:08:54.239329+00
4	contenttypes	0002_remove_content_type_name	2017-08-14 23:08:54.291859+00
5	piston3	0001_initial	2017-08-14 23:08:54.59461+00
6	maasserver	0001_initial	2017-08-14 23:09:04.94224+00
7	metadataserver	0001_initial	2017-08-14 23:09:06.059107+00
8	maasserver	0002_remove_candidate_name_model	2017-08-14 23:09:06.074802+00
9	maasserver	0003_add_node_type_to_node	2017-08-14 23:09:06.935303+00
10	maasserver	0004_migrate_installable_to_node_type	2017-08-14 23:09:06.947245+00
11	maasserver	0005_delete_installable_from_node	2017-08-14 23:09:07.061966+00
12	maasserver	0006_add_lease_time_to_staticipaddress	2017-08-14 23:09:07.369167+00
13	maasserver	0007_create_node_proxy_models	2017-08-14 23:09:07.386556+00
14	maasserver	0008_use_new_arrayfield	2017-08-14 23:09:07.766225+00
15	maasserver	0009_remove_routers_field_from_node	2017-08-14 23:09:07.902315+00
16	maasserver	0010_add_dns_models	2017-08-14 23:09:08.761468+00
17	maasserver	0011_domain_data	2017-08-14 23:09:08.7936+00
18	maasserver	0012_drop_dns_fields	2017-08-14 23:09:09.195639+00
19	maasserver	0013_remove_boot_type_from_node	2017-08-14 23:09:09.302514+00
20	maasserver	0014_add_region_models	2017-08-14 23:09:10.320102+00
21	maasserver	0015_add_bmc_model	2017-08-14 23:09:11.031442+00
22	maasserver	0016_migrate_power_data_node_to_bmc	2017-08-14 23:09:11.053459+00
23	maasserver	0017_remove_node_power_type	2017-08-14 23:09:11.713027+00
24	maasserver	0018_add_dnsdata	2017-08-14 23:09:12.320188+00
25	maasserver	0019_add_iprange	2017-08-14 23:09:12.570322+00
26	maasserver	0020_nodegroup_to_rackcontroller	2017-08-14 23:09:12.777569+00
27	maasserver	0021_nodegroupinterface_to_iprange	2017-08-14 23:09:12.790936+00
28	maasserver	0022_extract_ip_for_bmcs	2017-08-14 23:09:12.804122+00
29	maasserver	0023_add_ttl_field	2017-08-14 23:09:13.620278+00
30	maasserver	0024_remove_nodegroupinterface	2017-08-14 23:09:16.11217+00
31	maasserver	0025_create_node_system_id_sequence	2017-08-14 23:09:16.127314+00
32	maasserver	0026_create_zone_serial_sequence	2017-08-14 23:09:16.14223+00
33	maasserver	0027_replace_static_range_with_admin_reserved_ranges	2017-08-14 23:09:16.153922+00
34	maasserver	0028_update_default_vlan_on_interface_and_subnet	2017-08-14 23:09:16.400368+00
35	maasserver	0029_add_rdns_mode	2017-08-14 23:09:16.668517+00
36	maasserver	0030_drop_all_old_funcs	2017-08-14 23:09:16.679204+00
37	maasserver	0031_add_region_rack_rpc_conn_model	2017-08-14 23:09:17.234342+00
38	maasserver	0032_loosen_vlan	2017-08-14 23:09:18.047722+00
39	maasserver	0033_iprange_minor_changes	2017-08-14 23:09:18.46883+00
40	maasserver	0034_rename_mount_params_as_mount_options	2017-08-14 23:09:18.574184+00
41	maasserver	0035_convert_ether_wake_to_manual_power_type	2017-08-14 23:09:18.588814+00
42	maasserver	0036_add_service_model	2017-08-14 23:09:18.890744+00
43	maasserver	0037_node_last_image_sync	2017-08-14 23:09:18.993453+00
44	maasserver	0038_filesystem_ramfs_tmpfs_support	2017-08-14 23:09:19.216929+00
45	maasserver	0039_create_template_and_versionedtextfile_models	2017-08-14 23:09:19.534799+00
46	maasserver	0040_fix_id_seq	2017-08-14 23:09:19.549993+00
47	maasserver	0041_change_bmc_on_delete_to_set_null	2017-08-14 23:09:19.749404+00
48	maasserver	0042_add_routable_rack_controllers_to_bmc	2017-08-14 23:09:20.057969+00
49	maasserver	0043_dhcpsnippet	2017-08-14 23:09:20.369623+00
50	maasserver	0044_remove_di_bootresourcefiles	2017-08-14 23:09:20.405009+00
51	maasserver	0045_add_node_to_filesystem	2017-08-14 23:09:20.631356+00
52	maasserver	0046_add_bridge_interface_type	2017-08-14 23:09:20.763572+00
53	maasserver	0047_fix_spelling_of_degraded	2017-08-14 23:09:20.879235+00
54	maasserver	0048_add_subnet_allow_proxy	2017-08-14 23:09:21.192087+00
55	maasserver	0049_add_external_dhcp_present_to_vlan	2017-08-14 23:09:21.722595+00
56	maasserver	0050_modify_external_dhcp_on_vlan	2017-08-14 23:09:22.21667+00
57	maasserver	0051_space_fabric_unique	2017-08-14 23:09:22.53159+00
58	maasserver	0052_add_codename_title_eol_to_bootresourcecache	2017-08-14 23:09:22.619987+00
59	maasserver	0053_add_ownerdata_model	2017-08-14 23:09:23.028266+00
60	maasserver	0054_controller	2017-08-14 23:09:23.041773+00
61	maasserver	0055_dns_publications	2017-08-14 23:09:23.109657+00
62	maasserver	0056_zone_serial_ownership	2017-08-14 23:09:23.129828+00
63	maasserver	0057_initial_dns_publication	2017-08-14 23:09:23.147226+00
64	maasserver	0058_bigger_integer_for_dns_publication_serial	2017-08-14 23:09:23.230558+00
65	maasserver	0056_add_description_to_fabric_and_space	2017-08-14 23:09:25.250583+00
66	maasserver	0057_merge	2017-08-14 23:09:25.256012+00
67	maasserver	0059_merge	2017-08-14 23:09:25.261227+00
68	maasserver	0060_amt_remove_mac_address	2017-08-14 23:09:25.273643+00
69	maasserver	0061_maas_nodegroup_worker_to_maas	2017-08-14 23:09:25.286561+00
70	maasserver	0062_fix_bootsource_daily_label	2017-08-14 23:09:25.298916+00
71	maasserver	0063_remove_orphaned_bmcs_and_ips	2017-08-14 23:09:25.314679+00
72	maasserver	0064_remove_unneeded_event_triggers	2017-08-14 23:09:25.326509+00
73	maasserver	0065_larger_osystem_and_distro_series	2017-08-14 23:09:25.582542+00
74	maasserver	0066_allow_squashfs	2017-08-14 23:09:25.601716+00
75	maasserver	0067_add_size_to_largefile	2017-08-14 23:09:25.735125+00
76	maasserver	0068_drop_node_system_id_sequence	2017-08-14 23:09:25.752144+00
77	maasserver	0069_add_previous_node_status_to_node	2017-08-14 23:09:26.501949+00
78	maasserver	0070_allow_null_vlan_on_interface	2017-08-14 23:09:26.644272+00
79	maasserver	0071_ntp_server_to_ntp_servers	2017-08-14 23:09:26.656005+00
80	maasserver	0072_packagerepository	2017-08-14 23:09:26.784245+00
81	maasserver	0073_migrate_package_repositories	2017-08-14 23:09:26.813891+00
82	maasserver	0072_update_status_and_previous_status	2017-08-14 23:09:27.230675+00
83	maasserver	0074_merge	2017-08-14 23:09:27.235511+00
84	maasserver	0075_modify_packagerepository	2017-08-14 23:09:27.666452+00
85	maasserver	0076_interface_discovery_rescue_mode	2017-08-14 23:09:30.39485+00
86	maasserver	0077_static_routes	2017-08-14 23:09:30.986919+00
87	maasserver	0078_remove_packagerepository_description	2017-08-14 23:09:31.00801+00
88	maasserver	0079_add_keysource_model	2017-08-14 23:09:31.422509+00
89	maasserver	0080_change_packagerepository_url_type	2017-08-14 23:09:31.440633+00
90	maasserver	0081_allow_larger_bootsourcecache_fields	2017-08-14 23:09:31.535258+00
91	maasserver	0082_add_kflavor	2017-08-14 23:09:31.598711+00
92	maasserver	0083_device_discovery	2017-08-14 23:09:31.730981+00
93	maasserver	0084_add_default_user_to_node_model	2017-08-14 23:09:32.639865+00
94	maasserver	0085_no_intro_on_upgrade	2017-08-14 23:09:32.652293+00
95	maasserver	0086_remove_powerpc_from_ports_arches	2017-08-14 23:09:32.696066+00
96	maasserver	0087_add_completed_intro_to_userprofile	2017-08-14 23:09:32.910457+00
97	maasserver	0088_remove_node_disable_ipv4	2017-08-14 23:09:33.658351+00
98	maasserver	0089_active_discovery	2017-08-14 23:09:34.527875+00
99	maasserver	0090_bootloaders	2017-08-14 23:09:34.663864+00
100	maasserver	0091_v2_to_v3	2017-08-14 23:09:34.679194+00
101	maasserver	0092_rolling	2017-08-14 23:09:34.761679+00
102	maasserver	0093_add_rdns_model	2017-08-14 23:09:35.12551+00
103	maasserver	0094_add_unmanaged_subnets	2017-08-14 23:09:35.546047+00
104	maasserver	0095_vlan_relay_vlan	2017-08-14 23:09:35.738292+00
105	maasserver	0096_set_default_vlan_field	2017-08-14 23:09:35.946045+00
106	maasserver	0097_node_chassis_storage_hints	2017-08-14 23:09:38.290448+00
107	maasserver	0098_add_space_to_vlan	2017-08-14 23:09:38.459211+00
108	maasserver	0099_set_default_vlan_field	2017-08-14 23:09:38.616591+00
109	maasserver	0100_migrate_spaces_from_subnet_to_vlan	2017-08-14 23:09:38.639749+00
110	maasserver	0101_filesystem_btrfs_support	2017-08-14 23:09:38.834034+00
111	maasserver	0102_remove_space_from_subnet	2017-08-14 23:09:39.349113+00
112	maasserver	0103_notifications	2017-08-14 23:09:39.594862+00
113	maasserver	0104_notifications_dismissals	2017-08-14 23:09:39.827355+00
114	metadataserver	0002_script_models	2017-08-14 23:09:41.305831+00
115	maasserver	0105_add_script_sets_to_node_model	2017-08-14 23:09:42.577065+00
116	maasserver	0106_testing_status	2017-08-14 23:09:43.130856+00
117	maasserver	0107_chassis_to_pods	2017-08-14 23:09:46.642734+00
118	maasserver	0108_generate_bmc_names	2017-08-14 23:09:46.661319+00
119	maasserver	0109_bmc_names_unique	2017-08-14 23:09:46.861626+00
120	maasserver	0110_notification_category	2017-08-14 23:09:47.211163+00
121	maasserver	0111_remove_component_error	2017-08-14 23:09:47.229944+00
122	maasserver	0112_update_notification	2017-08-14 23:09:47.860433+00
123	maasserver	0113_set_filepath_limit_to_linux_max	2017-08-14 23:09:48.052392+00
124	maasserver	0114_node_dynamic_to_creation_type	2017-08-14 23:09:49.227201+00
125	maasserver	0115_additional_boot_resource_filetypes	2017-08-14 23:09:49.248975+00
126	maasserver	0116_add_disabled_components_for_mirrors	2017-08-14 23:09:49.447282+00
127	maasserver	0117_add_iscsi_block_device	2017-08-14 23:09:50.556122+00
128	maasserver	0118_add_iscsi_storage_pod	2017-08-14 23:09:51.533724+00
129	maasserver	0119_set_default_vlan_field	2017-08-14 23:09:51.75478+00
130	maasserver	0120_bootsourcecache_extra	2017-08-14 23:09:51.929775+00
131	maasserver	0121_relax_staticipaddress_unique_constraint	2017-08-14 23:09:52.322279+00
132	metadataserver	0003_remove_noderesult	2017-08-14 23:09:52.337818+00
133	metadataserver	0004_aborted_script_status	2017-08-14 23:09:52.495428+00
134	metadataserver	0005_store_powerstate_on_scriptset_creation	2017-08-14 23:09:52.719641+00
135	metadataserver	0006_scriptresult_combined_output	2017-08-14 23:09:53.16854+00
136	metadataserver	0007_migrate-commissioningscripts	2017-08-14 23:09:53.188323+00
137	metadataserver	0008_remove-commissioningscripts	2017-08-14 23:09:53.215549+00
138	metadataserver	0009_remove_noderesult_schema	2017-08-14 23:09:53.240697+00
139	metadataserver	0010_scriptresult_time_and_script_title	2017-08-14 23:09:53.868186+00
140	piston3	0002_auto_20151209_1652	2017-08-14 23:09:54.020273+00
141	sessions	0001_initial	2017-08-14 23:09:54.156155+00
142	sites	0001_initial	2017-08-14 23:09:54.223596+00
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('django_migrations_id_seq', 142, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY django_site (id, domain, name) FROM stdin;
1	example.com	example.com
\.


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('django_site_id_seq', 1, true);


--
-- Data for Name: maasserver_blockdevice; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_blockdevice (id, created, updated, name, id_path, size, block_size, tags, node_id) FROM stdin;
1	2017-08-14 23:10:07.714521+00	2017-08-14 23:10:07.714521+00	vda	/dev/vda	10737418240	4096	{rotary}	1
\.


--
-- Name: maasserver_blockdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_blockdevice_id_seq', 1, true);


--
-- Data for Name: maasserver_bmc; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_bmc (id, created, updated, power_type, power_parameters, ip_address_id, architectures, bmc_type, capabilities, cores, cpu_speed, local_disks, local_storage, memory, name, iscsi_storage) FROM stdin;
\.


--
-- Name: maasserver_bmc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_bmc_id_seq', 1, false);


--
-- Data for Name: maasserver_bmcroutablerackcontrollerrelationship; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_bmcroutablerackcontrollerrelationship (id, created, updated, routable, bmc_id, rack_controller_id) FROM stdin;
\.


--
-- Name: maasserver_bmcroutablerackcontrollerrelationship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_bmcroutablerackcontrollerrelationship_id_seq', 1, false);


--
-- Data for Name: maasserver_bootresource; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_bootresource (id, created, updated, rtype, name, architecture, extra, kflavor, bootloader_type, rolling) FROM stdin;
\.


--
-- Name: maasserver_bootresource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_bootresource_id_seq', 1, false);


--
-- Data for Name: maasserver_bootresourcefile; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_bootresourcefile (id, created, updated, filename, filetype, extra, largefile_id, resource_set_id) FROM stdin;
\.


--
-- Name: maasserver_bootresourcefile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_bootresourcefile_id_seq', 1, false);


--
-- Data for Name: maasserver_bootresourceset; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_bootresourceset (id, created, updated, version, label, resource_id) FROM stdin;
\.


--
-- Name: maasserver_bootresourceset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_bootresourceset_id_seq', 1, false);


--
-- Data for Name: maasserver_bootsource; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_bootsource (id, created, updated, url, keyring_filename, keyring_data) FROM stdin;
1	2017-08-14 23:10:03.007302+00	2017-08-14 23:10:03.007302+00	http://images.maas.io/ephemeral-v3/daily/	/usr/share/keyrings/ubuntu-cloudimage-keyring.gpg	\\x
\.


--
-- Name: maasserver_bootsource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_bootsource_id_seq', 1, true);


--
-- Data for Name: maasserver_bootsourcecache; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_bootsourcecache (id, created, updated, os, arch, subarch, release, label, boot_source_id, release_codename, release_title, support_eol, kflavor, bootloader_type, extra) FROM stdin;
\.


--
-- Name: maasserver_bootsourcecache_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_bootsourcecache_id_seq', 1, false);


--
-- Data for Name: maasserver_bootsourceselection; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_bootsourceselection (id, created, updated, os, release, arches, subarches, labels, boot_source_id) FROM stdin;
1	2017-08-14 23:10:03.007302+00	2017-08-14 23:10:03.007302+00	ubuntu	xenial	{amd64}	{*}	{*}	1
\.


--
-- Name: maasserver_bootsourceselection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_bootsourceselection_id_seq', 1, true);


--
-- Data for Name: maasserver_cacheset; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_cacheset (id, created, updated) FROM stdin;
\.


--
-- Name: maasserver_cacheset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_cacheset_id_seq', 1, false);


--
-- Data for Name: maasserver_config; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_config (id, name, value) FROM stdin;
1	dnssec_validation	"auto"
2	rpc_shared_secret	"707febdce16b5ef6e70f78932de7a16c"
\.


--
-- Name: maasserver_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_config_id_seq', 2, true);


--
-- Data for Name: maasserver_dhcpsnippet; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_dhcpsnippet (id, created, updated, name, description, enabled, node_id, subnet_id, value_id) FROM stdin;
\.


--
-- Name: maasserver_dhcpsnippet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_dhcpsnippet_id_seq', 1, false);


--
-- Data for Name: maasserver_dnsdata; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_dnsdata (id, created, updated, rrtype, rrdata, dnsresource_id, ttl) FROM stdin;
\.


--
-- Name: maasserver_dnsdata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_dnsdata_id_seq', 1, false);


--
-- Data for Name: maasserver_dnspublication; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_dnspublication (id, serial, created, source) FROM stdin;
1	1	2017-08-14 23:09:23.141802+00	Initial publication
2	4	2017-08-14 23:09:57.773726+00	Configuration dnssec_validation set to "auto"
3	5	2017-08-14 23:10:04.469477+00	Call to sys_dns_subnet_insert
4	6	2017-08-14 23:10:04.469477+00	Call to sys_dns_staticipaddress_update
5	7	2017-08-14 23:10:04.469477+00	Call to sys_dns_nic_ip_link
6	8	2017-08-14 23:10:07.944646+00	Call to sys_dns_nic_ip_unlink
7	9	2017-08-14 23:10:07.944646+00	Call to sys_dns_nic_ip_link
8	10	2017-08-14 23:10:31.547922+00	Call to sys_dns_staticipaddress_update
9	11	2017-08-14 23:10:31.547922+00	Call to sys_dns_nic_ip_link
10	12	2017-08-14 23:10:31.547922+00	Call to sys_dns_nic_ip_unlink
\.


--
-- Name: maasserver_dnspublication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_dnspublication_id_seq', 10, true);


--
-- Data for Name: maasserver_dnsresource; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_dnsresource (id, created, updated, name, domain_id, address_ttl) FROM stdin;
\.


--
-- Name: maasserver_dnsresource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_dnsresource_id_seq', 1, false);


--
-- Data for Name: maasserver_dnsresource_ip_addresses; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_dnsresource_ip_addresses (id, dnsresource_id, staticipaddress_id) FROM stdin;
\.


--
-- Name: maasserver_dnsresource_ip_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_dnsresource_ip_addresses_id_seq', 1, false);


--
-- Data for Name: maasserver_domain; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_domain (id, created, updated, name, authoritative, ttl) FROM stdin;
0	2017-08-14 23:09:08.771734+00	2017-08-14 23:09:08.771734+00	maas	t	\N
\.


--
-- Name: maasserver_domain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_domain_id_seq', 1, false);


--
-- Data for Name: maasserver_event; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_event (id, created, updated, action, description, node_id, type_id) FROM stdin;
1	2017-08-14 23:10:04.272971+00	2017-08-14 23:10:04.272971+00	starting refresh	(MAAS)	1	1
2	2017-08-14 23:10:04.323303+00	2017-08-14 23:10:04.323303+00		Started importing of boot images from 1 source(s).	1	2
\.


--
-- Name: maasserver_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_event_id_seq', 2, true);


--
-- Data for Name: maasserver_eventtype; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_eventtype (id, created, updated, name, description, level) FROM stdin;
1	2017-08-14 23:10:04.272971+00	2017-08-14 23:10:04.272971+00	REQUEST_CONTROLLER_REFRESH	Starting refresh of controller hardware and networking information	20
2	2017-08-14 23:10:04.305291+00	2017-08-14 23:10:04.305291+00	REGION_IMPORT_INFO	Region import info	20
\.


--
-- Name: maasserver_eventtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_eventtype_id_seq', 2, true);


--
-- Data for Name: maasserver_fabric; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_fabric (id, created, updated, name, class_type, description) FROM stdin;
0	2017-08-14 23:09:51.731401+00	2017-08-14 23:09:51.713925+00	fabric-0	\N	
1	2017-08-14 23:10:04.469477+00	2017-08-14 23:10:04.469477+00	fabric-1	\N	
\.


--
-- Name: maasserver_fabric_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_fabric_id_seq', 1, true);


--
-- Data for Name: maasserver_fannetwork; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_fannetwork (id, created, updated, name, "overlay", underlay, dhcp, host_reserve, bridge, off) FROM stdin;
\.


--
-- Name: maasserver_fannetwork_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_fannetwork_id_seq', 1, false);


--
-- Data for Name: maasserver_filestorage; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_filestorage (id, filename, content, key, owner_id) FROM stdin;
\.


--
-- Name: maasserver_filestorage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_filestorage_id_seq', 1, false);


--
-- Data for Name: maasserver_filesystem; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_filesystem (id, created, updated, uuid, fstype, label, create_params, mount_point, mount_options, acquired, block_device_id, cache_set_id, filesystem_group_id, partition_id, node_id) FROM stdin;
1	2017-08-14 23:10:07.944646+00	2017-08-14 23:10:07.944646+00	94a9c314-12f7-4548-bb30-5d7a532181d9	ext4	root	\N	/	\N	f	\N	\N	\N	1	\N
\.


--
-- Name: maasserver_filesystem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_filesystem_id_seq', 1, true);


--
-- Data for Name: maasserver_filesystemgroup; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_filesystemgroup (id, created, updated, uuid, group_type, name, create_params, cache_mode, cache_set_id) FROM stdin;
\.


--
-- Name: maasserver_filesystemgroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_filesystemgroup_id_seq', 1, false);


--
-- Data for Name: maasserver_interface; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_interface (id, created, updated, name, type, mac_address, ipv4_params, ipv6_params, params, tags, enabled, node_id, vlan_id, acquired, mdns_discovery_state, neighbour_discovery_state) FROM stdin;
1	2017-08-14 23:10:04.469477+00	2017-08-14 23:10:31.547922+00	ens3	physical	52:54:00:f0:13:97	""	""	""	{}	t	1	5001	f	t	t
2	2017-08-14 23:10:04.469477+00	2017-08-14 23:10:31.547922+00	ens9	physical	52:54:00:e2:f1:d5	""	""	""	{}	f	1	5002	f	t	f
\.


--
-- Name: maasserver_interface_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_interface_id_seq', 2, true);


--
-- Data for Name: maasserver_interface_ip_addresses; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_interface_ip_addresses (id, interface_id, staticipaddress_id) FROM stdin;
3	1	3
\.


--
-- Name: maasserver_interface_ip_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_interface_ip_addresses_id_seq', 3, true);


--
-- Data for Name: maasserver_interfacerelationship; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_interfacerelationship (id, created, updated, child_id, parent_id) FROM stdin;
\.


--
-- Name: maasserver_interfacerelationship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_interfacerelationship_id_seq', 1, false);


--
-- Data for Name: maasserver_iprange; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_iprange (id, created, updated, type, start_ip, end_ip, comment, subnet_id, user_id) FROM stdin;
\.


--
-- Name: maasserver_iprange_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_iprange_id_seq', 1, false);


--
-- Data for Name: maasserver_iscsiblockdevice; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_iscsiblockdevice (blockdevice_ptr_id, target) FROM stdin;
\.


--
-- Data for Name: maasserver_keysource; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_keysource (id, created, updated, protocol, auth_id, auto_update) FROM stdin;
\.


--
-- Name: maasserver_keysource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_keysource_id_seq', 1, false);


--
-- Data for Name: maasserver_largefile; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_largefile (id, created, updated, sha256, total_size, content, size) FROM stdin;
\.


--
-- Name: maasserver_largefile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_largefile_id_seq', 1, false);


--
-- Data for Name: maasserver_licensekey; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_licensekey (id, created, updated, osystem, distro_series, license_key) FROM stdin;
\.


--
-- Name: maasserver_licensekey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_licensekey_id_seq', 1, false);


--
-- Data for Name: maasserver_mdns; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_mdns (id, created, updated, ip, hostname, count, interface_id) FROM stdin;
\.


--
-- Name: maasserver_mdns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_mdns_id_seq', 1, false);


--
-- Data for Name: maasserver_neighbour; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_neighbour (id, created, updated, ip, "time", vid, count, mac_address, interface_id) FROM stdin;
\.


--
-- Name: maasserver_neighbour_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_neighbour_id_seq', 1, false);


--
-- Data for Name: maasserver_node; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_node (id, created, updated, system_id, hostname, status, bios_boot_method, osystem, distro_series, architecture, min_hwe_kernel, hwe_kernel, agent_name, error_description, cpu_count, memory, swap_size, instance_power_parameters, power_state, power_state_updated, error, netboot, license_key, boot_cluster_ip, enable_ssh, skip_networking, skip_storage, boot_interface_id, gateway_link_ipv4_id, gateway_link_ipv6_id, owner_id, parent_id, token_id, zone_id, boot_disk_id, node_type, domain_id, dns_process_id, bmc_id, address_ttl, status_expires, power_state_queried, url, managing_process_id, last_image_sync, previous_status, default_user, cpu_speed, current_commissioning_script_set_id, current_installation_script_set_id, current_testing_script_set_id, creation_type) FROM stdin;
1	2017-08-14 23:10:01.648973+00	2017-08-14 23:14:02.831023+00	my3sad	os-node2	0	\N	ubuntu	xenial	amd64/generic	\N	\N			2	2048	\N	""	unknown	\N	Finished refreshing my3sad	t	\N	\N	f	f	f	\N	\N	\N	1	\N	\N	1	\N	3	0	\N	\N	\N	\N	\N		\N	\N	0		0	1	\N	\N	1
\.


--
-- Name: maasserver_node_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_node_id_seq', 1, true);


--
-- Data for Name: maasserver_node_tags; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_node_tags (id, node_id, tag_id) FROM stdin;
1	1	1
\.


--
-- Name: maasserver_node_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_node_tags_id_seq', 1, true);


--
-- Data for Name: maasserver_nodegrouptorackcontroller; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_nodegrouptorackcontroller (id, uuid, subnet_id) FROM stdin;
\.


--
-- Name: maasserver_nodegrouptorackcontroller_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_nodegrouptorackcontroller_id_seq', 1, false);


--
-- Data for Name: maasserver_notification; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_notification (id, created, updated, ident, users, admins, message, context, user_id, category) FROM stdin;
1	2017-08-14 23:09:51.713925+00	2017-08-14 23:09:51.713925+00	dhcp_disabled_all_vlans	f	t	DHCP is not enabled on any VLAN.  This will prevent machines from being able to PXE boot, unless an external DHCP server is being used.	{}	\N	warning
2	2017-08-14 23:10:03.662173+00	2017-08-14 23:10:03.662173+00	maas-import-pxe-files script	f	t	Boot image import process not started. Machines will not be able to\nprovision without boot images. Visit the\n<a href="/MAAS/#/images">boot images</a> page to start the import.\n	{}	\N	error
3	2017-08-14 23:10:04.193313+00	2017-08-14 23:10:04.193313+00	commissioning_series_unavailable	t	t	ubuntu xenial is configured as the commissioning release but it is unavailable in the configured streams!	{}	\N	error
4	2017-08-14 23:10:04.247628+00	2017-08-14 23:10:04.247628+00	Image importer	f	t	Failed to import images from boot source http://images.maas.io/ephemeral-v3/daily/: HTTPConnectionPool(host=&#x27;images.maas.io&#x27;, port=80): Max retries exceeded with url: /ephemeral-v3/daily/streams/v1/index.sjson (Caused by NewConnectionError(&#x27;&lt;requests.packages.urllib3.connection.HTTPConnection object at 0x7f34e85a80f0&gt;: Failed to establish a new connection: [Errno 101] Network is unreachable&#x27;,))	{}	\N	error
\.


--
-- Name: maasserver_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_notification_id_seq', 4, true);


--
-- Data for Name: maasserver_notificationdismissal; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_notificationdismissal (id, notification_id, user_id) FROM stdin;
\.


--
-- Name: maasserver_notificationdismissal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_notificationdismissal_id_seq', 1, false);


--
-- Data for Name: maasserver_ownerdata; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_ownerdata (id, key, value, node_id) FROM stdin;
\.


--
-- Name: maasserver_ownerdata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_ownerdata_id_seq', 1, false);


--
-- Data for Name: maasserver_packagerepository; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_packagerepository (id, created, updated, name, url, components, arches, key, "default", enabled, disabled_pockets, distributions, disabled_components) FROM stdin;
1	2017-08-14 23:09:26.798322+00	2017-08-14 23:09:26.798322+00	main_archive	http://archive.ubuntu.com/ubuntu	{}	{amd64,i386}		t	t	{}	{}	{}
2	2017-08-14 23:09:26.798322+00	2017-08-14 23:09:26.798322+00	ports_archive	http://ports.ubuntu.com/ubuntu-ports	{}	{armhf,arm64,ppc64el}		t	t	{}	{}	{}
\.


--
-- Name: maasserver_packagerepository_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_packagerepository_id_seq', 2, true);


--
-- Data for Name: maasserver_partition; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_partition (id, created, updated, uuid, size, bootable, partition_table_id) FROM stdin;
1	2017-08-14 23:10:07.944646+00	2017-08-14 23:10:07.944646+00	0edc4ca9-d6df-4f1e-ac64-00fb88b9e438	10729029632	f	1
\.


--
-- Name: maasserver_partition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_partition_id_seq', 1, true);


--
-- Data for Name: maasserver_partitiontable; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_partitiontable (id, created, updated, table_type, block_device_id) FROM stdin;
1	2017-08-14 23:10:07.944646+00	2017-08-14 23:10:07.944646+00	MBR	1
\.


--
-- Name: maasserver_partitiontable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_partitiontable_id_seq', 1, true);


--
-- Data for Name: maasserver_physicalblockdevice; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_physicalblockdevice (blockdevice_ptr_id, model, serial) FROM stdin;
1		
\.


--
-- Data for Name: maasserver_podhints; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_podhints (id, cores, memory, local_storage, local_disks, pod_id, cpu_speed, iscsi_storage) FROM stdin;
\.


--
-- Name: maasserver_podhints_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_podhints_id_seq', 1, false);


--
-- Data for Name: maasserver_rdns; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_rdns (id, created, updated, ip, hostname, hostnames, observer_id) FROM stdin;
\.


--
-- Name: maasserver_rdns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_rdns_id_seq', 1, false);


--
-- Data for Name: maasserver_regioncontrollerprocess; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_regioncontrollerprocess (id, created, updated, pid, region_id) FROM stdin;
1	2017-08-14 23:10:01.953091+00	2017-08-14 23:14:02.047971+00	8552	1
2	2017-08-14 23:10:02.641469+00	2017-08-14 23:14:02.688796+00	8557	1
3	2017-08-14 23:10:02.679854+00	2017-08-14 23:14:02.753018+00	8569	1
4	2017-08-14 23:10:02.798376+00	2017-08-14 23:14:02.831023+00	8571	1
\.


--
-- Name: maasserver_regioncontrollerprocess_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_regioncontrollerprocess_id_seq', 4, true);


--
-- Data for Name: maasserver_regioncontrollerprocessendpoint; Type: TABLE DATA; Schema: public; Owner: maas
--

--COPY maasserver_regioncontrollerprocessendpoint (id, created, updated, address, port, process_id) FROM stdin;
--1	2017-08-14 23:10:02.696901+00	2017-08-14 23:10:02.696901+00	172.20.0.46	5252	2
--2	2017-08-14 23:10:02.842956+00	2017-08-14 23:10:02.842956+00	172.20.0.46	5253	4
--3	2017-08-14 23:10:03.001062+00	2017-08-14 23:10:03.001062+00	172.20.0.46	5250	3
--4	2017-08-14 23:10:03.287548+00	2017-08-14 23:10:03.287548+00	172.20.0.46	5251	1
--\.


--
-- Name: maasserver_regioncontrollerprocessendpoint_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_regioncontrollerprocessendpoint_id_seq', 4, true);


--
-- Data for Name: maasserver_regionrackrpcconnection; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_regionrackrpcconnection (id, created, updated, endpoint_id, rack_controller_id) FROM stdin;
\.


--
-- Name: maasserver_regionrackrpcconnection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_regionrackrpcconnection_id_seq', 1, false);


--
-- Data for Name: maasserver_service; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_service (id, created, updated, name, status, status_info, node_id) FROM stdin;
1	2017-08-14 23:10:01.648973+00	2017-08-14 23:10:02.842956+00	regiond	running		1
3	2017-08-14 23:10:01.648973+00	2017-08-14 23:10:03.202776+00	ntp_region	running		1
4	2017-08-14 23:10:01.648973+00	2017-08-14 23:10:03.202776+00	bind9	running		1
2	2017-08-14 23:10:01.648973+00	2017-08-14 23:11:01.944265+00	proxy	running		1
\.


--
-- Name: maasserver_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_service_id_seq', 4, true);


--
-- Data for Name: maasserver_space; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_space (id, created, updated, name, description) FROM stdin;
\.


--
-- Name: maasserver_space_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_space_id_seq', 1, false);


--
-- Data for Name: maasserver_sshkey; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_sshkey (id, created, updated, key, user_id, keysource_id) FROM stdin;
\.


--
-- Name: maasserver_sshkey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_sshkey_id_seq', 1, false);


--
-- Data for Name: maasserver_sslkey; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_sslkey (id, created, updated, key, user_id) FROM stdin;
\.


--
-- Name: maasserver_sslkey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_sslkey_id_seq', 1, false);


--
-- Data for Name: maasserver_staticipaddress; Type: TABLE DATA; Schema: public; Owner: maas
--

--COPY maasserver_staticipaddress (id, created, updated, ip, alloc_type, subnet_id, user_id, lease_time) FROM stdin;
--3	2017-08-14 23:10:31.547922+00	2017-08-14 23:10:31.547922+00	172.20.0.46	1	1	\N	0
--\.


--
-- Name: maasserver_staticipaddress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_staticipaddress_id_seq', 3, true);


--
-- Data for Name: maasserver_staticroute; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_staticroute (id, gateway_ip, metric, destination_id, source_id, created, updated) FROM stdin;
\.


--
-- Name: maasserver_staticroute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_staticroute_id_seq', 1, false);


--
-- Data for Name: maasserver_subnet; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_subnet (id, created, updated, name, cidr, gateway_ip, dns_servers, vlan_id, rdns_mode, allow_proxy, description, active_discovery, managed) FROM stdin;
1	2017-08-14 23:10:04.469477+00	2017-08-14 23:10:04.469477+00	172.20.0.0/24	172.20.0.0/24	172.20.0.10	{}	5001	2	t		f	t
\.


--
-- Name: maasserver_subnet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_subnet_id_seq', 1, true);


--
-- Data for Name: maasserver_tag; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_tag (id, created, updated, name, definition, comment, kernel_opts) FROM stdin;
1	2017-08-14 23:10:07.312315+00	2017-08-14 23:10:07.312315+00	virtual			\N
\.


--
-- Name: maasserver_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_tag_id_seq', 1, true);


--
-- Data for Name: maasserver_template; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_template (id, created, updated, filename, default_version_id, version_id) FROM stdin;
\.


--
-- Name: maasserver_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_template_id_seq', 1, false);


--
-- Data for Name: maasserver_userprofile; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_userprofile (id, user_id, completed_intro) FROM stdin;
\.


--
-- Name: maasserver_userprofile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_userprofile_id_seq', 1, false);


--
-- Data for Name: maasserver_versionedtextfile; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_versionedtextfile (id, created, updated, data, comment, previous_version_id) FROM stdin;
1	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/usr/bin/env python3\n#\n# smartctl - Run smartctl on all drives in parellel\n#\n# Author: Lee Trager <lee.trager@canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\nimport re\nfrom subprocess import (\n    CalledProcessError,\n    check_call,\n    check_output,\n    DEVNULL,\n    PIPE,\n    Popen,\n    STDOUT,\n    TimeoutExpired,\n)\nimport sys\nfrom threading import Thread\nfrom time import sleep\n\n# We're just reading the SMART data or asking the drive to run a self test.\n# If this takes more then a minute there is something wrong the with drive.\nTIMEOUT = 60\n\n\nclass RunSmartCtl(Thread):\n\n    def __init__(self, smartctl_args, test=None):\n        super().__init__(name=smartctl_args[0])\n        self.smartctl_args = smartctl_args\n        self.test = test\n        self.running_test_failed = False\n        self.output = b''\n        self.timedout = False\n\n    def _run_smartctl_selftest(self):\n        try:\n            # Start testing.\n            check_call(\n                ['sudo', '-n', 'smartctl', '-s', 'on', '-t', self.test] +\n                self.smartctl_args, timeout=TIMEOUT, stdout=DEVNULL,\n                stderr=DEVNULL)\n        except (TimeoutExpired, CalledProcessError):\n            self.running_test_failed = True\n        else:\n            # Wait for testing to complete.\n            status_regex = re.compile(\n                'Self-test execution status:\\s+\\(\\s*(?P<status>\\d+)\\s*\\)')\n            while True:\n                try:\n                    stdout = check_output(\n                        ['sudo', '-n', 'smartctl', '-c'] + self.smartctl_args,\n                        timeout=TIMEOUT)\n                except (TimeoutExpired, CalledProcessError):\n                    self.running_test_failed = True\n                    break\n                else:\n                    m = status_regex.search(stdout.decode('utf-8'))\n                    if m is not None and int(m.group('status')) == 0:\n                        break\n                    else:\n                        sleep(1)\n\n    def run(self):\n        if self.test not in ('validate', None):\n            self._run_smartctl_selftest()\n\n        # Run smartctl and capture its output. Once all threads have completed\n        # we'll output the results serially so output is properly grouped.\n        with Popen(\n                ['sudo', '-n', 'smartctl', '--xall'] + self.smartctl_args,\n                stdout=PIPE, stderr=STDOUT) as proc:\n            try:\n                self.output, _ = proc.communicate(timeout=TIMEOUT)\n            except TimeoutExpired:\n                proc.kill()\n                self.timedout = True\n            self.returncode = proc.returncode\n\n    @property\n    def was_successful(self):\n        # smartctl returns 0 when there are no errors. It returns 4 if a SMART\n        # or ATA command to the disk failed. This is surprisingly common so\n        # ignore it.\n        return self.returncode in {0, 4}\n\n\ndef list_supported_drives():\n    """Ask smartctl to give us a list of drives which have SMART data.\n\n    :return: A list of drives that have SMART data.\n    """\n    # Gather a list of connected ISCSI drives. ISCSI has SMART data but we\n    # only want to scan local disks during testing.\n    try:\n        output = check_output(\n            ['sudo', '-n', 'iscsiadm', '-m', 'session', '-P', '3'],\n            timeout=TIMEOUT, stderr=DEVNULL)\n    except (TimeoutExpired, CalledProcessError):\n        # If this command failed ISCSI is most likely not running/installed.\n        # Ignore the error and move on, worst case scenario we run smartctl\n        # on ISCSI drives.\n        iscsi_drives = []\n    else:\n        iscsi_drives = re.findall(\n            'Attached scsi disk (?P<disk>\\w+)', output.decode('utf-8'))\n\n    drives = []\n    smart_support_regex = re.compile('SMART support is:\\s+Available')\n    output = check_output(\n        ['sudo', '-n', 'smartctl', '--scan-open'], timeout=TIMEOUT)\n    for line in output.decode('utf-8').splitlines():\n        try:\n            # Each line contains the drive and the device type along with any\n            # options needed to run smartctl against the drive.\n            drive_with_device_type = line.split('#')[0].split()\n            drive = drive_with_device_type[0]\n        except IndexError:\n            continue\n        if drive != '' and drive.split('/')[-1] not in iscsi_drives:\n            # Check that SMART is actually supported on the drive.\n            with Popen(\n                    ['sudo', '-n', 'smartctl', '-i'] + drive_with_device_type,\n                    stdout=PIPE, stderr=DEVNULL) as proc:\n                try:\n                    output, _ = proc.communicate(timeout=TIMEOUT)\n                except TimeoutExpired:\n                    sys.stderr.write(\n                        "Unable to determine if %s supports SMART" % drive)\n                else:\n                    m = smart_support_regex.search(output.decode('utf-8'))\n                    if m is not None:\n                        drives.append(drive_with_device_type)\n\n    try:\n        all_drives = check_output(\n            [\n                'lsblk', '--exclude', '1,2,7', '-d', '-l', '-o',\n                'NAME,MODEL,SERIAL', '-x', 'NAME',\n            ], timeout=TIMEOUT, stderr=DEVNULL).decode('utf-8').splitlines()\n    except CalledProcessError:\n        # The SERIAL column and sorting(-x) are unsupported in the Trusty\n        # version of lsblk. Try again without them.\n        all_drives = check_output(\n            [\n                'lsblk', '--exclude', '1,2,7', '-d', '-l', '-o',\n                'NAME,MODEL',\n            ], timeout=TIMEOUT, stderr=DEVNULL).decode('utf-8').splitlines()\n    supported_drives = iscsi_drives + [\n        drive[0].split('/')[-1] for drive in drives]\n    unsupported_drives = [\n        line for line in all_drives[1:]\n        if line.split()[0] not in supported_drives\n    ]\n    if len(unsupported_drives) != 0:\n        print()\n        print('The following drives do not support SMART:')\n        print(all_drives[0])\n        print('\\n'.join(unsupported_drives))\n        print()\n\n    return drives\n\n\ndef run_smartctl(test=None):\n    """Run smartctl against all drives on the system with SMART data.\n\n    Runs smartctl against all drives on the system each in their own thread.\n    Once SMART data has been read from all drives output the result and if\n    smartctl timedout or detected an error.\n\n    :return: The number of drives which SMART indicates are failing.\n    """\n    threads = []\n    for smartctl_args in list_supported_drives():\n        thread = RunSmartCtl(smartctl_args, test)\n        thread.start()\n        threads.append(thread)\n\n    smartctl_failures = 0\n    for thread in threads:\n        thread.join()\n        drive = thread.smartctl_args[0]\n        dashes = '-' * int((80.0 - (2 + len(drive))) / 2)\n        print('%s %s %s' % (dashes, drive, dashes))\n        print()\n\n        if thread.running_test_failed:\n            smartctl_failures += 1\n            print('Failed to start and wait for smartctl self-test: %s' % test)\n            print()\n        if thread.timedout:\n            smartctl_failures += 1\n            print(\n                'Running `smartctl --xall %s` timed out!' %\n                ' '.join(thread.smartctl_args))\n            continue\n        elif not thread.was_successful:\n            # smartctl returns 0 when there are no errors. It returns 4 if\n            # a SMART or ATA command to the disk failed. This is surprisingly\n            # common so ignore it.\n            smartctl_failures += 1\n            print(\n                'Error, `smartctl --xall %s` returned %d!' % (\n                    ' '.join(smartctl_args), thread.returncode))\n            print('See the smartctl man page for return code meaning')\n            print()\n        print(thread.output.decode('utf-8'))\n\n    return smartctl_failures\n\n\nif __name__ == '__main__':\n    # The MAAS ephemeral environment runs apt-get update for us.\n    # Don't use timeout here incase the mirror is running really slow.\n    check_call(\n        ['sudo', '-n', 'apt-get', '-q', '-y', 'install', 'smartmontools'])\n\n    # Determine which test should be run based from the first argument or\n    # script name.\n    if len(sys.argv) > 1:\n        test = sys.argv[1]\n    else:\n        test = None\n        for test_name in {'short', 'long', 'conveyance'}:\n            if test_name in sys.argv[0]:\n                test = test_name\n                break\n    sys.exit(run_smartctl(test))\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
2	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/usr/bin/env python3\n#\n# smartctl - Run smartctl on all drives in parellel\n#\n# Author: Lee Trager <lee.trager@canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\nimport re\nfrom subprocess import (\n    CalledProcessError,\n    check_call,\n    check_output,\n    DEVNULL,\n    PIPE,\n    Popen,\n    STDOUT,\n    TimeoutExpired,\n)\nimport sys\nfrom threading import Thread\nfrom time import sleep\n\n# We're just reading the SMART data or asking the drive to run a self test.\n# If this takes more then a minute there is something wrong the with drive.\nTIMEOUT = 60\n\n\nclass RunSmartCtl(Thread):\n\n    def __init__(self, smartctl_args, test=None):\n        super().__init__(name=smartctl_args[0])\n        self.smartctl_args = smartctl_args\n        self.test = test\n        self.running_test_failed = False\n        self.output = b''\n        self.timedout = False\n\n    def _run_smartctl_selftest(self):\n        try:\n            # Start testing.\n            check_call(\n                ['sudo', '-n', 'smartctl', '-s', 'on', '-t', self.test] +\n                self.smartctl_args, timeout=TIMEOUT, stdout=DEVNULL,\n                stderr=DEVNULL)\n        except (TimeoutExpired, CalledProcessError):\n            self.running_test_failed = True\n        else:\n            # Wait for testing to complete.\n            status_regex = re.compile(\n                'Self-test execution status:\\s+\\(\\s*(?P<status>\\d+)\\s*\\)')\n            while True:\n                try:\n                    stdout = check_output(\n                        ['sudo', '-n', 'smartctl', '-c'] + self.smartctl_args,\n                        timeout=TIMEOUT)\n                except (TimeoutExpired, CalledProcessError):\n                    self.running_test_failed = True\n                    break\n                else:\n                    m = status_regex.search(stdout.decode('utf-8'))\n                    if m is not None and int(m.group('status')) == 0:\n                        break\n                    else:\n                        sleep(1)\n\n    def run(self):\n        if self.test not in ('validate', None):\n            self._run_smartctl_selftest()\n\n        # Run smartctl and capture its output. Once all threads have completed\n        # we'll output the results serially so output is properly grouped.\n        with Popen(\n                ['sudo', '-n', 'smartctl', '--xall'] + self.smartctl_args,\n                stdout=PIPE, stderr=STDOUT) as proc:\n            try:\n                self.output, _ = proc.communicate(timeout=TIMEOUT)\n            except TimeoutExpired:\n                proc.kill()\n                self.timedout = True\n            self.returncode = proc.returncode\n\n    @property\n    def was_successful(self):\n        # smartctl returns 0 when there are no errors. It returns 4 if a SMART\n        # or ATA command to the disk failed. This is surprisingly common so\n        # ignore it.\n        return self.returncode in {0, 4}\n\n\ndef list_supported_drives():\n    """Ask smartctl to give us a list of drives which have SMART data.\n\n    :return: A list of drives that have SMART data.\n    """\n    # Gather a list of connected ISCSI drives. ISCSI has SMART data but we\n    # only want to scan local disks during testing.\n    try:\n        output = check_output(\n            ['sudo', '-n', 'iscsiadm', '-m', 'session', '-P', '3'],\n            timeout=TIMEOUT, stderr=DEVNULL)\n    except (TimeoutExpired, CalledProcessError):\n        # If this command failed ISCSI is most likely not running/installed.\n        # Ignore the error and move on, worst case scenario we run smartctl\n        # on ISCSI drives.\n        iscsi_drives = []\n    else:\n        iscsi_drives = re.findall(\n            'Attached scsi disk (?P<disk>\\w+)', output.decode('utf-8'))\n\n    drives = []\n    smart_support_regex = re.compile('SMART support is:\\s+Available')\n    output = check_output(\n        ['sudo', '-n', 'smartctl', '--scan-open'], timeout=TIMEOUT)\n    for line in output.decode('utf-8').splitlines():\n        try:\n            # Each line contains the drive and the device type along with any\n            # options needed to run smartctl against the drive.\n            drive_with_device_type = line.split('#')[0].split()\n            drive = drive_with_device_type[0]\n        except IndexError:\n            continue\n        if drive != '' and drive.split('/')[-1] not in iscsi_drives:\n            # Check that SMART is actually supported on the drive.\n            with Popen(\n                    ['sudo', '-n', 'smartctl', '-i'] + drive_with_device_type,\n                    stdout=PIPE, stderr=DEVNULL) as proc:\n                try:\n                    output, _ = proc.communicate(timeout=TIMEOUT)\n                except TimeoutExpired:\n                    sys.stderr.write(\n                        "Unable to determine if %s supports SMART" % drive)\n                else:\n                    m = smart_support_regex.search(output.decode('utf-8'))\n                    if m is not None:\n                        drives.append(drive_with_device_type)\n\n    try:\n        all_drives = check_output(\n            [\n                'lsblk', '--exclude', '1,2,7', '-d', '-l', '-o',\n                'NAME,MODEL,SERIAL', '-x', 'NAME',\n            ], timeout=TIMEOUT, stderr=DEVNULL).decode('utf-8').splitlines()\n    except CalledProcessError:\n        # The SERIAL column and sorting(-x) are unsupported in the Trusty\n        # version of lsblk. Try again without them.\n        all_drives = check_output(\n            [\n                'lsblk', '--exclude', '1,2,7', '-d', '-l', '-o',\n                'NAME,MODEL',\n            ], timeout=TIMEOUT, stderr=DEVNULL).decode('utf-8').splitlines()\n    supported_drives = iscsi_drives + [\n        drive[0].split('/')[-1] for drive in drives]\n    unsupported_drives = [\n        line for line in all_drives[1:]\n        if line.split()[0] not in supported_drives\n    ]\n    if len(unsupported_drives) != 0:\n        print()\n        print('The following drives do not support SMART:')\n        print(all_drives[0])\n        print('\\n'.join(unsupported_drives))\n        print()\n\n    return drives\n\n\ndef run_smartctl(test=None):\n    """Run smartctl against all drives on the system with SMART data.\n\n    Runs smartctl against all drives on the system each in their own thread.\n    Once SMART data has been read from all drives output the result and if\n    smartctl timedout or detected an error.\n\n    :return: The number of drives which SMART indicates are failing.\n    """\n    threads = []\n    for smartctl_args in list_supported_drives():\n        thread = RunSmartCtl(smartctl_args, test)\n        thread.start()\n        threads.append(thread)\n\n    smartctl_failures = 0\n    for thread in threads:\n        thread.join()\n        drive = thread.smartctl_args[0]\n        dashes = '-' * int((80.0 - (2 + len(drive))) / 2)\n        print('%s %s %s' % (dashes, drive, dashes))\n        print()\n\n        if thread.running_test_failed:\n            smartctl_failures += 1\n            print('Failed to start and wait for smartctl self-test: %s' % test)\n            print()\n        if thread.timedout:\n            smartctl_failures += 1\n            print(\n                'Running `smartctl --xall %s` timed out!' %\n                ' '.join(thread.smartctl_args))\n            continue\n        elif not thread.was_successful:\n            # smartctl returns 0 when there are no errors. It returns 4 if\n            # a SMART or ATA command to the disk failed. This is surprisingly\n            # common so ignore it.\n            smartctl_failures += 1\n            print(\n                'Error, `smartctl --xall %s` returned %d!' % (\n                    ' '.join(smartctl_args), thread.returncode))\n            print('See the smartctl man page for return code meaning')\n            print()\n        print(thread.output.decode('utf-8'))\n\n    return smartctl_failures\n\n\nif __name__ == '__main__':\n    # The MAAS ephemeral environment runs apt-get update for us.\n    # Don't use timeout here incase the mirror is running really slow.\n    check_call(\n        ['sudo', '-n', 'apt-get', '-q', '-y', 'install', 'smartmontools'])\n\n    # Determine which test should be run based from the first argument or\n    # script name.\n    if len(sys.argv) > 1:\n        test = sys.argv[1]\n    else:\n        test = None\n        for test_name in {'short', 'long', 'conveyance'}:\n            if test_name in sys.argv[0]:\n                test = test_name\n                break\n    sys.exit(run_smartctl(test))\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
3	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/usr/bin/env python3\n#\n# smartctl - Run smartctl on all drives in parellel\n#\n# Author: Lee Trager <lee.trager@canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\nimport re\nfrom subprocess import (\n    CalledProcessError,\n    check_call,\n    check_output,\n    DEVNULL,\n    PIPE,\n    Popen,\n    STDOUT,\n    TimeoutExpired,\n)\nimport sys\nfrom threading import Thread\nfrom time import sleep\n\n# We're just reading the SMART data or asking the drive to run a self test.\n# If this takes more then a minute there is something wrong the with drive.\nTIMEOUT = 60\n\n\nclass RunSmartCtl(Thread):\n\n    def __init__(self, smartctl_args, test=None):\n        super().__init__(name=smartctl_args[0])\n        self.smartctl_args = smartctl_args\n        self.test = test\n        self.running_test_failed = False\n        self.output = b''\n        self.timedout = False\n\n    def _run_smartctl_selftest(self):\n        try:\n            # Start testing.\n            check_call(\n                ['sudo', '-n', 'smartctl', '-s', 'on', '-t', self.test] +\n                self.smartctl_args, timeout=TIMEOUT, stdout=DEVNULL,\n                stderr=DEVNULL)\n        except (TimeoutExpired, CalledProcessError):\n            self.running_test_failed = True\n        else:\n            # Wait for testing to complete.\n            status_regex = re.compile(\n                'Self-test execution status:\\s+\\(\\s*(?P<status>\\d+)\\s*\\)')\n            while True:\n                try:\n                    stdout = check_output(\n                        ['sudo', '-n', 'smartctl', '-c'] + self.smartctl_args,\n                        timeout=TIMEOUT)\n                except (TimeoutExpired, CalledProcessError):\n                    self.running_test_failed = True\n                    break\n                else:\n                    m = status_regex.search(stdout.decode('utf-8'))\n                    if m is not None and int(m.group('status')) == 0:\n                        break\n                    else:\n                        sleep(1)\n\n    def run(self):\n        if self.test not in ('validate', None):\n            self._run_smartctl_selftest()\n\n        # Run smartctl and capture its output. Once all threads have completed\n        # we'll output the results serially so output is properly grouped.\n        with Popen(\n                ['sudo', '-n', 'smartctl', '--xall'] + self.smartctl_args,\n                stdout=PIPE, stderr=STDOUT) as proc:\n            try:\n                self.output, _ = proc.communicate(timeout=TIMEOUT)\n            except TimeoutExpired:\n                proc.kill()\n                self.timedout = True\n            self.returncode = proc.returncode\n\n    @property\n    def was_successful(self):\n        # smartctl returns 0 when there are no errors. It returns 4 if a SMART\n        # or ATA command to the disk failed. This is surprisingly common so\n        # ignore it.\n        return self.returncode in {0, 4}\n\n\ndef list_supported_drives():\n    """Ask smartctl to give us a list of drives which have SMART data.\n\n    :return: A list of drives that have SMART data.\n    """\n    # Gather a list of connected ISCSI drives. ISCSI has SMART data but we\n    # only want to scan local disks during testing.\n    try:\n        output = check_output(\n            ['sudo', '-n', 'iscsiadm', '-m', 'session', '-P', '3'],\n            timeout=TIMEOUT, stderr=DEVNULL)\n    except (TimeoutExpired, CalledProcessError):\n        # If this command failed ISCSI is most likely not running/installed.\n        # Ignore the error and move on, worst case scenario we run smartctl\n        # on ISCSI drives.\n        iscsi_drives = []\n    else:\n        iscsi_drives = re.findall(\n            'Attached scsi disk (?P<disk>\\w+)', output.decode('utf-8'))\n\n    drives = []\n    smart_support_regex = re.compile('SMART support is:\\s+Available')\n    output = check_output(\n        ['sudo', '-n', 'smartctl', '--scan-open'], timeout=TIMEOUT)\n    for line in output.decode('utf-8').splitlines():\n        try:\n            # Each line contains the drive and the device type along with any\n            # options needed to run smartctl against the drive.\n            drive_with_device_type = line.split('#')[0].split()\n            drive = drive_with_device_type[0]\n        except IndexError:\n            continue\n        if drive != '' and drive.split('/')[-1] not in iscsi_drives:\n            # Check that SMART is actually supported on the drive.\n            with Popen(\n                    ['sudo', '-n', 'smartctl', '-i'] + drive_with_device_type,\n                    stdout=PIPE, stderr=DEVNULL) as proc:\n                try:\n                    output, _ = proc.communicate(timeout=TIMEOUT)\n                except TimeoutExpired:\n                    sys.stderr.write(\n                        "Unable to determine if %s supports SMART" % drive)\n                else:\n                    m = smart_support_regex.search(output.decode('utf-8'))\n                    if m is not None:\n                        drives.append(drive_with_device_type)\n\n    try:\n        all_drives = check_output(\n            [\n                'lsblk', '--exclude', '1,2,7', '-d', '-l', '-o',\n                'NAME,MODEL,SERIAL', '-x', 'NAME',\n            ], timeout=TIMEOUT, stderr=DEVNULL).decode('utf-8').splitlines()\n    except CalledProcessError:\n        # The SERIAL column and sorting(-x) are unsupported in the Trusty\n        # version of lsblk. Try again without them.\n        all_drives = check_output(\n            [\n                'lsblk', '--exclude', '1,2,7', '-d', '-l', '-o',\n                'NAME,MODEL',\n            ], timeout=TIMEOUT, stderr=DEVNULL).decode('utf-8').splitlines()\n    supported_drives = iscsi_drives + [\n        drive[0].split('/')[-1] for drive in drives]\n    unsupported_drives = [\n        line for line in all_drives[1:]\n        if line.split()[0] not in supported_drives\n    ]\n    if len(unsupported_drives) != 0:\n        print()\n        print('The following drives do not support SMART:')\n        print(all_drives[0])\n        print('\\n'.join(unsupported_drives))\n        print()\n\n    return drives\n\n\ndef run_smartctl(test=None):\n    """Run smartctl against all drives on the system with SMART data.\n\n    Runs smartctl against all drives on the system each in their own thread.\n    Once SMART data has been read from all drives output the result and if\n    smartctl timedout or detected an error.\n\n    :return: The number of drives which SMART indicates are failing.\n    """\n    threads = []\n    for smartctl_args in list_supported_drives():\n        thread = RunSmartCtl(smartctl_args, test)\n        thread.start()\n        threads.append(thread)\n\n    smartctl_failures = 0\n    for thread in threads:\n        thread.join()\n        drive = thread.smartctl_args[0]\n        dashes = '-' * int((80.0 - (2 + len(drive))) / 2)\n        print('%s %s %s' % (dashes, drive, dashes))\n        print()\n\n        if thread.running_test_failed:\n            smartctl_failures += 1\n            print('Failed to start and wait for smartctl self-test: %s' % test)\n            print()\n        if thread.timedout:\n            smartctl_failures += 1\n            print(\n                'Running `smartctl --xall %s` timed out!' %\n                ' '.join(thread.smartctl_args))\n            continue\n        elif not thread.was_successful:\n            # smartctl returns 0 when there are no errors. It returns 4 if\n            # a SMART or ATA command to the disk failed. This is surprisingly\n            # common so ignore it.\n            smartctl_failures += 1\n            print(\n                'Error, `smartctl --xall %s` returned %d!' % (\n                    ' '.join(smartctl_args), thread.returncode))\n            print('See the smartctl man page for return code meaning')\n            print()\n        print(thread.output.decode('utf-8'))\n\n    return smartctl_failures\n\n\nif __name__ == '__main__':\n    # The MAAS ephemeral environment runs apt-get update for us.\n    # Don't use timeout here incase the mirror is running really slow.\n    check_call(\n        ['sudo', '-n', 'apt-get', '-q', '-y', 'install', 'smartmontools'])\n\n    # Determine which test should be run based from the first argument or\n    # script name.\n    if len(sys.argv) > 1:\n        test = sys.argv[1]\n    else:\n        test = None\n        for test_name in {'short', 'long', 'conveyance'}:\n            if test_name in sys.argv[0]:\n                test = test_name\n                break\n    sys.exit(run_smartctl(test))\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
4	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/usr/bin/env python3\n#\n# smartctl - Run smartctl on all drives in parellel\n#\n# Author: Lee Trager <lee.trager@canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\nimport re\nfrom subprocess import (\n    CalledProcessError,\n    check_call,\n    check_output,\n    DEVNULL,\n    PIPE,\n    Popen,\n    STDOUT,\n    TimeoutExpired,\n)\nimport sys\nfrom threading import Thread\nfrom time import sleep\n\n# We're just reading the SMART data or asking the drive to run a self test.\n# If this takes more then a minute there is something wrong the with drive.\nTIMEOUT = 60\n\n\nclass RunSmartCtl(Thread):\n\n    def __init__(self, smartctl_args, test=None):\n        super().__init__(name=smartctl_args[0])\n        self.smartctl_args = smartctl_args\n        self.test = test\n        self.running_test_failed = False\n        self.output = b''\n        self.timedout = False\n\n    def _run_smartctl_selftest(self):\n        try:\n            # Start testing.\n            check_call(\n                ['sudo', '-n', 'smartctl', '-s', 'on', '-t', self.test] +\n                self.smartctl_args, timeout=TIMEOUT, stdout=DEVNULL,\n                stderr=DEVNULL)\n        except (TimeoutExpired, CalledProcessError):\n            self.running_test_failed = True\n        else:\n            # Wait for testing to complete.\n            status_regex = re.compile(\n                'Self-test execution status:\\s+\\(\\s*(?P<status>\\d+)\\s*\\)')\n            while True:\n                try:\n                    stdout = check_output(\n                        ['sudo', '-n', 'smartctl', '-c'] + self.smartctl_args,\n                        timeout=TIMEOUT)\n                except (TimeoutExpired, CalledProcessError):\n                    self.running_test_failed = True\n                    break\n                else:\n                    m = status_regex.search(stdout.decode('utf-8'))\n                    if m is not None and int(m.group('status')) == 0:\n                        break\n                    else:\n                        sleep(1)\n\n    def run(self):\n        if self.test not in ('validate', None):\n            self._run_smartctl_selftest()\n\n        # Run smartctl and capture its output. Once all threads have completed\n        # we'll output the results serially so output is properly grouped.\n        with Popen(\n                ['sudo', '-n', 'smartctl', '--xall'] + self.smartctl_args,\n                stdout=PIPE, stderr=STDOUT) as proc:\n            try:\n                self.output, _ = proc.communicate(timeout=TIMEOUT)\n            except TimeoutExpired:\n                proc.kill()\n                self.timedout = True\n            self.returncode = proc.returncode\n\n    @property\n    def was_successful(self):\n        # smartctl returns 0 when there are no errors. It returns 4 if a SMART\n        # or ATA command to the disk failed. This is surprisingly common so\n        # ignore it.\n        return self.returncode in {0, 4}\n\n\ndef list_supported_drives():\n    """Ask smartctl to give us a list of drives which have SMART data.\n\n    :return: A list of drives that have SMART data.\n    """\n    # Gather a list of connected ISCSI drives. ISCSI has SMART data but we\n    # only want to scan local disks during testing.\n    try:\n        output = check_output(\n            ['sudo', '-n', 'iscsiadm', '-m', 'session', '-P', '3'],\n            timeout=TIMEOUT, stderr=DEVNULL)\n    except (TimeoutExpired, CalledProcessError):\n        # If this command failed ISCSI is most likely not running/installed.\n        # Ignore the error and move on, worst case scenario we run smartctl\n        # on ISCSI drives.\n        iscsi_drives = []\n    else:\n        iscsi_drives = re.findall(\n            'Attached scsi disk (?P<disk>\\w+)', output.decode('utf-8'))\n\n    drives = []\n    smart_support_regex = re.compile('SMART support is:\\s+Available')\n    output = check_output(\n        ['sudo', '-n', 'smartctl', '--scan-open'], timeout=TIMEOUT)\n    for line in output.decode('utf-8').splitlines():\n        try:\n            # Each line contains the drive and the device type along with any\n            # options needed to run smartctl against the drive.\n            drive_with_device_type = line.split('#')[0].split()\n            drive = drive_with_device_type[0]\n        except IndexError:\n            continue\n        if drive != '' and drive.split('/')[-1] not in iscsi_drives:\n            # Check that SMART is actually supported on the drive.\n            with Popen(\n                    ['sudo', '-n', 'smartctl', '-i'] + drive_with_device_type,\n                    stdout=PIPE, stderr=DEVNULL) as proc:\n                try:\n                    output, _ = proc.communicate(timeout=TIMEOUT)\n                except TimeoutExpired:\n                    sys.stderr.write(\n                        "Unable to determine if %s supports SMART" % drive)\n                else:\n                    m = smart_support_regex.search(output.decode('utf-8'))\n                    if m is not None:\n                        drives.append(drive_with_device_type)\n\n    try:\n        all_drives = check_output(\n            [\n                'lsblk', '--exclude', '1,2,7', '-d', '-l', '-o',\n                'NAME,MODEL,SERIAL', '-x', 'NAME',\n            ], timeout=TIMEOUT, stderr=DEVNULL).decode('utf-8').splitlines()\n    except CalledProcessError:\n        # The SERIAL column and sorting(-x) are unsupported in the Trusty\n        # version of lsblk. Try again without them.\n        all_drives = check_output(\n            [\n                'lsblk', '--exclude', '1,2,7', '-d', '-l', '-o',\n                'NAME,MODEL',\n            ], timeout=TIMEOUT, stderr=DEVNULL).decode('utf-8').splitlines()\n    supported_drives = iscsi_drives + [\n        drive[0].split('/')[-1] for drive in drives]\n    unsupported_drives = [\n        line for line in all_drives[1:]\n        if line.split()[0] not in supported_drives\n    ]\n    if len(unsupported_drives) != 0:\n        print()\n        print('The following drives do not support SMART:')\n        print(all_drives[0])\n        print('\\n'.join(unsupported_drives))\n        print()\n\n    return drives\n\n\ndef run_smartctl(test=None):\n    """Run smartctl against all drives on the system with SMART data.\n\n    Runs smartctl against all drives on the system each in their own thread.\n    Once SMART data has been read from all drives output the result and if\n    smartctl timedout or detected an error.\n\n    :return: The number of drives which SMART indicates are failing.\n    """\n    threads = []\n    for smartctl_args in list_supported_drives():\n        thread = RunSmartCtl(smartctl_args, test)\n        thread.start()\n        threads.append(thread)\n\n    smartctl_failures = 0\n    for thread in threads:\n        thread.join()\n        drive = thread.smartctl_args[0]\n        dashes = '-' * int((80.0 - (2 + len(drive))) / 2)\n        print('%s %s %s' % (dashes, drive, dashes))\n        print()\n\n        if thread.running_test_failed:\n            smartctl_failures += 1\n            print('Failed to start and wait for smartctl self-test: %s' % test)\n            print()\n        if thread.timedout:\n            smartctl_failures += 1\n            print(\n                'Running `smartctl --xall %s` timed out!' %\n                ' '.join(thread.smartctl_args))\n            continue\n        elif not thread.was_successful:\n            # smartctl returns 0 when there are no errors. It returns 4 if\n            # a SMART or ATA command to the disk failed. This is surprisingly\n            # common so ignore it.\n            smartctl_failures += 1\n            print(\n                'Error, `smartctl --xall %s` returned %d!' % (\n                    ' '.join(smartctl_args), thread.returncode))\n            print('See the smartctl man page for return code meaning')\n            print()\n        print(thread.output.decode('utf-8'))\n\n    return smartctl_failures\n\n\nif __name__ == '__main__':\n    # The MAAS ephemeral environment runs apt-get update for us.\n    # Don't use timeout here incase the mirror is running really slow.\n    check_call(\n        ['sudo', '-n', 'apt-get', '-q', '-y', 'install', 'smartmontools'])\n\n    # Determine which test should be run based from the first argument or\n    # script name.\n    if len(sys.argv) > 1:\n        test = sys.argv[1]\n    else:\n        test = None\n        for test_name in {'short', 'long', 'conveyance'}:\n            if test_name in sys.argv[0]:\n                test = test_name\n                break\n    sys.exit(run_smartctl(test))\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
5	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/bin/bash -e\n#\n# memtester - Run memtester against all available userspace memory.\n#\n# Author: Lee Trager <lee.trager@canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\nsudo -n apt-get install -q -y memtester\necho\n\n# Memtester can only test memory available to userspace. Reserve 32M so the\n# test doesn't fail due to the OOM killer. Only run memtester against available\n# RAM once.\nsudo -n memtester \\\n     $(awk '/MemAvailable/ { print ($2 - 32768) "K"}' /proc/meminfo) 1\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
6	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/bin/bash -e\n#\n# internet_connectivity - Check if the system has access to the Internet.\n#\n# Author: Lee Trager <lee.trager@canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\n# Download the index.sjson file used by MAAS to download images to validate\n# internet connectivity.\nURL="https://images.maas.io/ephemeral-v3/daily/streams/v1/index.sjson"\necho "Attempting to retrieve: $URL"\ncurl -ILSsv -A maas_internet_connectivity_test $URL\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
7	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/bin/bash -e\n#\n# stress-ng-cpu-long - Run stress-ng memory tests over 12 hours.\n#\n# Author: Lee Trager <lee.trager@canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\nsource /etc/os-release\nif [ $VERSION_ID == '14.04' ]; then\n    # The version of stress-ng in 14.04 does not support required features\n    # for testing. Warn and attempt to run incase stress-ng is ever upgraded.\n    echo 'stress-ng-cpu-long unsupported on 14.04, ' \\\n\t 'please use 16.04 or above.' 1>&2\n    exit 1\nfi\n\nsudo -n apt-get install -q -y stress-ng\necho\n\nsudo -n stress-ng --aggressive -a 0 --class cpu,cpu-cache --ignite-cpu \\\n    --log-brief --metrics-brief --times --tz --verify --timeout 12h\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
8	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/bin/bash -e\n#\n# stress-ng-cpu-short - Stress test the CPU for 5 minutes.\n#\n# Author: Lee Trager <lee.trager@canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\nsource /etc/os-release\nif [ $VERSION_ID == '14.04' ]; then\n    # The version of stress-ng in 14.04 does not support required features\n    # for testing. Warn and attempt to run incase stress-ng is ever upgraded.\n    echo 'stress-ng-cpu-short unsupported on 14.04, ' \\\n\t 'please use 16.04 or above.' 1>&2\n    exit 1\nfi\n\nsudo -n apt-get install -q -y stress-ng\necho\n\nsudo -n stress-ng --matrix 0 --ignite-cpu --log-brief --metrics-brief --times \\\n    --tz --verify --timeout 2m\necho\nsudo -n stress-ng --cache 0 --ignite-cpu --log-brief --metrics-brief --times \\\n    --tz --verify --timeout 1m\necho\nsudo -n stress-ng --cpu 0 --ignite-cpu --log-brief --metrics-brief --times --tz \\\n    --verify --timeout 2m\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
9	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/bin/bash -e\n#\n# stress_ng_memory_long - Run stress-ng memory tests over 12 hours.\n#\n# Author: Lee Trager <lee.trager@canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\nsource /etc/os-release\nif [ $VERSION_ID == '14.04' ]; then\n    # The version of stress-ng in 14.04 does not support required features\n    # for testing. Warn and attempt to run incase stress-ng is ever upgraded.\n    echo 'stress-ng-memory-long unsupported on 14.04, ' \\\n\t 'please use 16.04 or above.' 1>&2\n    exit 1\nfi\n\nsudo -n apt-get install -q -y stress-ng\necho\n\n# Reserve 64M so the test doesn't fail due to the OOM killer.\ntotal_memory=$(awk '/MemAvailable/ { print ($2 - 65536) }' /proc/meminfo)\nthreads=$(lscpu --all --parse | grep -v '#' | wc -l)\nmemory_per_thread=$(($total_memory / $threads))\n# stress-ng only allows 4GB of memory per thread.\nif [ $memory_per_thread -ge 4194304 ]; then\n    threads=$(($total_memory / 4194304 + 1))\n    memory_per_thread=$(($total_memory / $threads))\nfi\n\nstress-ng --vm $threads --vm-bytes ${memory_per_thread}k --page-in \\\n    --log-brief --metrics-brief --times --tz --verify --timeout 12h\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
10	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/bin/bash -e\n#\n# stress-ng-memory-short - Stress test memory for 5 minutes.\n#\n# Author: Lee Trager <lee.trager@canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\nsource /etc/os-release\nif [ $VERSION_ID == '14.04' ]; then\n    # The version of stress-ng in 14.04 does not support required features\n    # for testing. Warn and attempt to run incase stress-ng is ever upgraded.\n    echo 'stress-ng-memory-short unsupported on 14.04, ' \\\n\t 'please use 16.04 or above.' 1>&2\n    exit 1\nfi\n\nsudo -n apt-get install -q -y stress-ng\necho\n\n# Reserve 64M so the test doesn't fail due to the OOM killer.\ntotal_memory=$(awk '/MemAvailable/ { print ($2 - 65536) }' /proc/meminfo)\nthreads=$(lscpu --all --parse | grep -v '#' | wc -l)\nmemory_per_thread=$(($total_memory / $threads))\n# stress-ng only allows 4GB of memory per thread.\nif [ $memory_per_thread -ge 4194304 ]; then\n    threads=$(($total_memory / 4194304 + 1))\n    memory_per_thread=$(($total_memory / $threads))\nfi\n\nstress-ng --vm $threads --vm-bytes ${memory_per_thread}k --page-in \\\n    --log-brief --metrics-brief --times --tz --verify --timeout 5m\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
11	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/bin/bash\n#\n# ntp - Run ntp clock set to verify NTP connectivity.\n#\n# Author: Michael Iatrou <michael.iatrou (at) canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\n# cloud-init configures ntp to use the rack controller or a user configured\n# external ntp server before running the test scripts. This test ensures that\n# the configured NTP server is accessible.\n\nsource /etc/os-release\n\nif [ $VERSION_ID == "14.04" ]; then\n    which ntpq >/dev/null\n    if [ $? -ne 0 ]; then\n\techo -en 'Warning: NTP configuration is not supported in Trusty. ' 1>&2\n\techo -en 'Running with the default NTP configuration.\\n\\n' 1>&2\n\tsudo -n apt-get install -q -y ntp\n    fi\n    ntpq -np\n    sudo -n service ntp stop\n    sudo -n timeout 10 ntpd -gq\n    ret=$?\n    sudo -n service ntp start\nelse\n    ntpq -np\n    sudo -n systemctl stop ntp.service\n    sudo -n timeout 10 ntpd -gq\n    ret=$?\n    sudo -n systemctl start ntp.service\nfi\nexit $ret\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
12	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/usr/bin/env python3\n#\n# badblocks - Run badblocks on all drives in parallel\n#\n# Author: Lee Trager <lee.trager@canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\nimport re\nimport shlex\nfrom subprocess import (\n    CalledProcessError,\n    check_output,\n    DEVNULL,\n    PIPE,\n    Popen,\n    STDOUT,\n    TimeoutExpired,\n)\nimport sys\nfrom threading import Thread\n\n# Short running commands which are used to query info about the drive should\n# work in under a minute otherwise assume a failure.\nTIMEOUT = 60\n\n\nclass RunBadBlocks(Thread):\n\n    def __init__(self, drive, destructive=False):\n        super().__init__(name=drive['PATH'])\n        self.drive = drive\n        self.destructive = destructive\n        self.output = b''\n        self.returncode = None\n\n    def run(self):\n        if self.destructive:\n            cmd = ['sudo', '-n', 'badblocks', '-v', '-w', self.drive['PATH']]\n        else:\n            cmd = ['sudo', '-n', 'badblocks', '-v', '-n', self.drive['PATH']]\n        # Run badblocks and capture its output. Once all threads have completed\n        # output the results serially so output is proerly grouped.\n        with Popen(cmd, stdout=PIPE, stderr=STDOUT) as proc:\n            self.output, _ = proc.communicate()\n            self.returncode = proc.returncode\n\n\ndef list_drives():\n    """List all drives available to test\n\n    :return: A list of drives that have SMART data.\n    """\n    # Gather a list of connected ISCSI drives to ignore.\n    try:\n        output = check_output(\n            ['sudo', '-n', 'iscsiadm', '-m', 'session', '-P', '3'],\n            timeout=TIMEOUT, stderr=DEVNULL)\n    except (TimeoutExpired, CalledProcessError):\n        # If this command failed ISCSI is most likely not running/installed.\n        # Ignore the error and move on.\n        iscsi_drives = []\n    else:\n        iscsi_drives = re.findall(\n            'Attached scsi disk (?P<disk>\\w+)', output.decode('utf-8'))\n\n    try:\n        lsblk_output = check_output(\n            [\n                'lsblk', '--exclude', '1,2,7', '-d', '-P', '-o',\n                'NAME,RO,MODEL,SERIAL',\n            ], timeout=TIMEOUT).decode('utf-8')\n    except CalledProcessError:\n        # The SERIAL column is unsupported in the Trusty version of lsblk. Try\n        # again without it.\n        lsblk_output = check_output(\n            [\n                'lsblk', '--exclude', '1,2,7', '-d', '-P', '-o',\n                'NAME,RO,MODEL',\n            ], timeout=TIMEOUT).decode('utf-8')\n    drives = []\n    for line in lsblk_output.splitlines():\n        drive = {}\n        for part in shlex.split(line):\n            key, value = part.split('=')\n            drive[key.strip()] = value.strip()\n        if drive['NAME'] not in iscsi_drives and drive['RO'] == '0':\n            drive['PATH'] = '/dev/%s' % drive['NAME']\n            drives.append(drive)\n\n    return drives\n\n\ndef run_badblocks(destructive=False):\n    """Run badblocks against all drives on the system.\n\n    Runs badblocks against all drives on the system each in their own thread.\n    Once badblocks has finished output the result.\n\n    :return: The number of drives which badblocks detected as failures.\n    """\n    threads = []\n    for drive in list_drives():\n        thread = RunBadBlocks(drive, destructive)\n        thread.start()\n        threads.append(thread)\n\n    badblock_failures = 0\n    for thread in threads:\n        thread.join()\n        dashes = '-' * int((80.0 - (2 + len(thread.drive['PATH']))) / 2)\n        print('%s %s %s' % (dashes, thread.drive['PATH'], dashes))\n        print('Model:  %s' % thread.drive['MODEL'])\n        # The SERIAL column is only available in newer versions of lsblk. This\n        # can be removed with Trusty support.\n        if 'SERIAL' in thread.drive:\n            print('Serial: %s' % thread.drive['SERIAL'])\n        print()\n\n        if thread.returncode != 0:\n            badblock_failures += 1\n            print('Badblocks exited with %d!' % thread.returncode)\n            print()\n        print(thread.output.decode('utf-8'))\n\n    return badblock_failures\n\n\nif __name__ == '__main__':\n    # Determine if badblocks should run destructively from the first argument\n    # or script name.\n    if len(sys.argv) > 1 and sys.argv[1] == 'destructive':\n        destructive = True\n    elif 'destructive' in sys.argv[0]:\n        destructive = True\n    else:\n        destructive = False\n\n    sys.exit(run_badblocks(destructive))\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
13	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	#!/usr/bin/env python3\n#\n# badblocks - Run badblocks on all drives in parallel\n#\n# Author: Lee Trager <lee.trager@canonical.com>\n#\n# Copyright (C) 2017 Canonical\n#\n# This program is free software: you can redistribute it and/or modify\n# it under the terms of the GNU Affero General Public License as\n# published by the Free Software Foundation, either version 3 of the\n# License, or (at your option) any later version.\n#\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU Affero General Public License for more details.\n#\n# You should have received a copy of the GNU Affero General Public License\n# along with this program.  If not, see <http://www.gnu.org/licenses/>.\n\nimport re\nimport shlex\nfrom subprocess import (\n    CalledProcessError,\n    check_output,\n    DEVNULL,\n    PIPE,\n    Popen,\n    STDOUT,\n    TimeoutExpired,\n)\nimport sys\nfrom threading import Thread\n\n# Short running commands which are used to query info about the drive should\n# work in under a minute otherwise assume a failure.\nTIMEOUT = 60\n\n\nclass RunBadBlocks(Thread):\n\n    def __init__(self, drive, destructive=False):\n        super().__init__(name=drive['PATH'])\n        self.drive = drive\n        self.destructive = destructive\n        self.output = b''\n        self.returncode = None\n\n    def run(self):\n        if self.destructive:\n            cmd = ['sudo', '-n', 'badblocks', '-v', '-w', self.drive['PATH']]\n        else:\n            cmd = ['sudo', '-n', 'badblocks', '-v', '-n', self.drive['PATH']]\n        # Run badblocks and capture its output. Once all threads have completed\n        # output the results serially so output is proerly grouped.\n        with Popen(cmd, stdout=PIPE, stderr=STDOUT) as proc:\n            self.output, _ = proc.communicate()\n            self.returncode = proc.returncode\n\n\ndef list_drives():\n    """List all drives available to test\n\n    :return: A list of drives that have SMART data.\n    """\n    # Gather a list of connected ISCSI drives to ignore.\n    try:\n        output = check_output(\n            ['sudo', '-n', 'iscsiadm', '-m', 'session', '-P', '3'],\n            timeout=TIMEOUT, stderr=DEVNULL)\n    except (TimeoutExpired, CalledProcessError):\n        # If this command failed ISCSI is most likely not running/installed.\n        # Ignore the error and move on.\n        iscsi_drives = []\n    else:\n        iscsi_drives = re.findall(\n            'Attached scsi disk (?P<disk>\\w+)', output.decode('utf-8'))\n\n    try:\n        lsblk_output = check_output(\n            [\n                'lsblk', '--exclude', '1,2,7', '-d', '-P', '-o',\n                'NAME,RO,MODEL,SERIAL',\n            ], timeout=TIMEOUT).decode('utf-8')\n    except CalledProcessError:\n        # The SERIAL column is unsupported in the Trusty version of lsblk. Try\n        # again without it.\n        lsblk_output = check_output(\n            [\n                'lsblk', '--exclude', '1,2,7', '-d', '-P', '-o',\n                'NAME,RO,MODEL',\n            ], timeout=TIMEOUT).decode('utf-8')\n    drives = []\n    for line in lsblk_output.splitlines():\n        drive = {}\n        for part in shlex.split(line):\n            key, value = part.split('=')\n            drive[key.strip()] = value.strip()\n        if drive['NAME'] not in iscsi_drives and drive['RO'] == '0':\n            drive['PATH'] = '/dev/%s' % drive['NAME']\n            drives.append(drive)\n\n    return drives\n\n\ndef run_badblocks(destructive=False):\n    """Run badblocks against all drives on the system.\n\n    Runs badblocks against all drives on the system each in their own thread.\n    Once badblocks has finished output the result.\n\n    :return: The number of drives which badblocks detected as failures.\n    """\n    threads = []\n    for drive in list_drives():\n        thread = RunBadBlocks(drive, destructive)\n        thread.start()\n        threads.append(thread)\n\n    badblock_failures = 0\n    for thread in threads:\n        thread.join()\n        dashes = '-' * int((80.0 - (2 + len(thread.drive['PATH']))) / 2)\n        print('%s %s %s' % (dashes, thread.drive['PATH'], dashes))\n        print('Model:  %s' % thread.drive['MODEL'])\n        # The SERIAL column is only available in newer versions of lsblk. This\n        # can be removed with Trusty support.\n        if 'SERIAL' in thread.drive:\n            print('Serial: %s' % thread.drive['SERIAL'])\n        print()\n\n        if thread.returncode != 0:\n            badblock_failures += 1\n            print('Badblocks exited with %d!' % thread.returncode)\n            print()\n        print(thread.output.decode('utf-8'))\n\n    return badblock_failures\n\n\nif __name__ == '__main__':\n    # Determine if badblocks should run destructively from the first argument\n    # or script name.\n    if len(sys.argv) > 1 and sys.argv[1] == 'destructive':\n        destructive = True\n    elif 'destructive' in sys.argv[0]:\n        destructive = True\n    else:\n        destructive = False\n\n    sys.exit(run_badblocks(destructive))\n	Created by maas-2.2.0+bzr6054-0ubuntu2~16.04.1	\N
\.


--
-- Name: maasserver_versionedtextfile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_versionedtextfile_id_seq', 13, true);


--
-- Data for Name: maasserver_virtualblockdevice; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_virtualblockdevice (blockdevice_ptr_id, uuid, filesystem_group_id) FROM stdin;
\.


--
-- Data for Name: maasserver_vlan; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_vlan (id, created, updated, name, vid, mtu, fabric_id, dhcp_on, primary_rack_id, secondary_rack_id, external_dhcp, description, relay_vlan_id, space_id) FROM stdin;
5001	2017-08-14 23:09:51.713925+00	2017-08-14 23:09:51.713925+00	Default VLAN	0	1500	0	f	\N	\N	\N		\N	\N
5002	2017-08-14 23:10:04.469477+00	2017-08-14 23:10:04.469477+00	Default VLAN	0	1500	1	f	\N	\N	\N		\N	\N
\.


--
-- Name: maasserver_vlan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_vlan_id_seq', 5002, true);


--
-- Data for Name: maasserver_zone; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY maasserver_zone (id, created, updated, name, description) FROM stdin;
1	2017-08-14 23:08:59.611708+00	2017-08-14 23:08:59.611708+00	default	
\.


--
-- Name: maasserver_zone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_zone_id_seq', 1, true);


--
-- Name: maasserver_zone_serial_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('maasserver_zone_serial_seq', 12, true);


--
-- Data for Name: metadataserver_nodekey; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY metadataserver_nodekey (id, key, node_id, token_id) FROM stdin;
1	GGDH9rfxr5wX32DdVv	1	1
\.


--
-- Name: metadataserver_nodekey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('metadataserver_nodekey_id_seq', 1, true);


--
-- Data for Name: metadataserver_nodeuserdata; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY metadataserver_nodeuserdata (id, data, node_id) FROM stdin;
\.


--
-- Name: metadataserver_nodeuserdata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('metadataserver_nodeuserdata_id_seq', 1, false);


--
-- Data for Name: metadataserver_script; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY metadataserver_script (id, created, updated, name, description, tags, script_type, timeout, destructive, "default", script_id, title) FROM stdin;
1	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	smartctl-validate	Validate SMART health for all drives in parallel.	{storage,commissioning}	2	00:05:00	f	t	1	Storage status
2	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	smartctl-short	Run the short SMART self-test and validate SMART health on all drives in parallel	{storage}	2	00:10:00	f	t	2	Storage integrity
3	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	smartctl-long	Run the long SMART self-test and validate SMART health on all drives in parallel	{storage}	2	00:00:00	f	t	3	Storage integrity
4	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	smartctl-conveyance	Run the conveyance SMART self-test and validate SMART health on all drives in parallel	{storage}	2	00:00:00	f	t	4	Storage integrity
5	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	memtester	Run memtester against all available RAM.	{memory}	2	00:00:00	f	t	5	Memory integrity
6	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	internet-connectivity	Download a file from images.maas.io.	{network,internet}	2	00:05:00	f	t	6	Network validation
7	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	stress-ng-cpu-long	Run the stress-ng CPU tests over 12 hours.	{cpu}	2	12:00:00	f	t	7	CPU validation
8	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	stress-ng-cpu-short	Stress test the CPU for 5 minutes.	{cpu}	2	00:05:00	f	t	8	CPU validation
9	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	stress-ng-memory-long	Run the stress-ng memory tests over 12 hours.	{memory}	2	12:00:00	f	t	9	Memory integrity
10	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	stress-ng-memory-short	Stress test memory for 5 minutes.	{memory}	2	00:05:00	f	t	10	Memory validation
11	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	ntp	Run ntp clock set to verify NTP connectivity.	{network,ntp}	2	00:01:00	f	t	11	NTP validation
12	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	badblocks	Run badblocks readonly tests against all drives in parallel.	{storage}	2	00:00:00	f	t	12	Storage integrity
13	2017-08-14 23:10:02.057255+00	2017-08-14 23:10:02.057255+00	badblocks-destructive	Run badblocks destructive tests against all drives in parallel.	{storage,destructive}	2	00:00:00	t	t	13	Storage integrity
\.


--
-- Name: metadataserver_script_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('metadataserver_script_id_seq', 13, true);


--
-- Data for Name: metadataserver_scriptresult; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY metadataserver_scriptresult (id, created, updated, status, exit_status, script_name, stdout, stderr, result, script_id, script_set_id, script_version_id, output, ended, started) FROM stdin;
1	2017-08-14 23:10:01.648973+00	2017-08-14 23:10:05.360033+00	2	0	00-maas-00-support-info	LS0tLS1CRUdJTiBLRVJORUwgSU5GTy0tLS0tCkxpbnV4IG9zLW5vZGUyIDQuMTAuMC0zMi1nZW5lcmljICMzNn4xNi4wNC4xLVVidW50dSBTTVAgV2VkIEF1ZyA5IDA5OjE5OjAyIFVUQyAyMDE3IHg4Nl82NCB4ODZfNjQgeDg2XzY0IEdOVS9MaW51eAotLS0tLUVORCBLRVJORUwgSU5GTy0tLS0tCgotLS0tLUJFR0lOIEtFUk5FTCBDT01NQU5EIExJTkUtLS0tLQpCT09UX0lNQUdFPS9ib290L3ZtbGludXotNC4xMC4wLTMyLWdlbmVyaWMgcm9vdD1VVUlEPTcxZjkwYmQ5LTkzYzUtNGFjZC05MzY3LTUyNzIwYzA0MTgwMiBybwotLS0tLUVORCBLRVJORUwgQ09NTUFORCBMSU5FLS0tLS0KCi0tLS0tQkVHSU4gQ1BVIENPUkUgQ09VTlQgQU5EIE1PREVMLS0tLS0KICAgICAgMiAgSW50ZWwgQ29yZSBQcm9jZXNzb3IgKFNreWxha2UpCi0tLS0tQkVHSU4gQ1BVIENPUkUgQ09VTlQgQU5EIE1PREVMLS0tLS0KCi0tLS0tQkVHSU4gUENJIElORk8tLS0tLQowMDowMC4wIEhvc3QgYnJpZGdlIFswNjAwXTogSW50ZWwgQ29ycG9yYXRpb24gNDQwRlggLSA4MjQ0MUZYIFBNQyBbTmF0b21hXSBbODA4NjoxMjM3XSAocmV2IDAyKQowMDowMS4wIElTQSBicmlkZ2UgWzA2MDFdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjM3MVNCIFBJSVgzIElTQSBbTmF0b21hL1RyaXRvbiBJSV0gWzgwODY6NzAwMF0KMDA6MDEuMSBJREUgaW50ZXJmYWNlIFswMTAxXTogSW50ZWwgQ29ycG9yYXRpb24gODIzNzFTQiBQSUlYMyBJREUgW05hdG9tYS9Ucml0b24gSUldIFs4MDg2OjcwMTBdCjAwOjAxLjMgQnJpZGdlIFswNjgwXTogSW50ZWwgQ29ycG9yYXRpb24gODIzNzFBQi9FQi9NQiBQSUlYNCBBQ1BJIFs4MDg2OjcxMTNdIChyZXYgMDMpCjAwOjAyLjAgVkdBIGNvbXBhdGlibGUgY29udHJvbGxlciBbMDMwMF06IFZNd2FyZSBTVkdBIElJIEFkYXB0ZXIgWzE1YWQ6MDQwNV0KMDA6MDMuMCBFdGhlcm5ldCBjb250cm9sbGVyIFswMjAwXTogUmVkIEhhdCwgSW5jIFZpcnRpbyBuZXR3b3JrIGRldmljZSBbMWFmNDoxMDAwXQowMDowNC4wIEF1ZGlvIGRldmljZSBbMDQwM106IEludGVsIENvcnBvcmF0aW9uIDgyODAxRkIvRkJNL0ZSL0ZXL0ZSVyAoSUNINiBGYW1pbHkpIEhpZ2ggRGVmaW5pdGlvbiBBdWRpbyBDb250cm9sbGVyIFs4MDg2OjI2NjhdIChyZXYgMDEpCjAwOjA1LjAgVVNCIGNvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUkgKElDSDkgRmFtaWx5KSBVU0IgVUhDSSBDb250cm9sbGVyICMxIFs4MDg2OjI5MzRdIChyZXYgMDMpCjAwOjA1LjEgVVNCIGNvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUkgKElDSDkgRmFtaWx5KSBVU0IgVUhDSSBDb250cm9sbGVyICMyIFs4MDg2OjI5MzVdIChyZXYgMDMpCjAwOjA1LjIgVVNCIGNvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUkgKElDSDkgRmFtaWx5KSBVU0IgVUhDSSBDb250cm9sbGVyICMzIFs4MDg2OjI5MzZdIChyZXYgMDMpCjAwOjA1LjcgVVNCIGNvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUkgKElDSDkgRmFtaWx5KSBVU0IyIEVIQ0kgQ29udHJvbGxlciAjMSBbODA4NjoyOTNhXSAocmV2IDAzKQowMDowNi4wIENvbW11bmljYXRpb24gY29udHJvbGxlciBbMDc4MF06IFJlZCBIYXQsIEluYyBWaXJ0aW8gY29uc29sZSBbMWFmNDoxMDAzXQowMDowNy4wIFNDU0kgc3RvcmFnZSBjb250cm9sbGVyIFswMTAwXTogUmVkIEhhdCwgSW5jIFZpcnRpbyBibG9jayBkZXZpY2UgWzFhZjQ6MTAwMV0KMDA6MDguMCBVbmNsYXNzaWZpZWQgZGV2aWNlIFswMGZmXTogUmVkIEhhdCwgSW5jIFZpcnRpbyBtZW1vcnkgYmFsbG9vbiBbMWFmNDoxMDAyXQowMDowOS4wIEV0aGVybmV0IGNvbnRyb2xsZXIgWzAyMDBdOiBSZWQgSGF0LCBJbmMgVmlydGlvIG5ldHdvcmsgZGV2aWNlIFsxYWY0OjEwMDBdCi0tLS0tRU5EIFBDSSBJTkZPLS0tLS0KCi0tLS0tQkVHSU4gVVNCIElORk8tLS0tLQpCdXMgMDAxIERldmljZSAwMDE6IElEIDFkNmI6MDAwMiBMaW51eCBGb3VuZGF0aW9uIDIuMCByb290IGh1YgpCdXMgMDA0IERldmljZSAwMDE6IElEIDFkNmI6MDAwMSBMaW51eCBGb3VuZGF0aW9uIDEuMSByb290IGh1YgpCdXMgMDAzIERldmljZSAwMDE6IElEIDFkNmI6MDAwMSBMaW51eCBGb3VuZGF0aW9uIDEuMSByb290IGh1YgpCdXMgMDAyIERldmljZSAwMDE6IElEIDFkNmI6MDAwMSBMaW51eCBGb3VuZGF0aW9uIDEuMSByb290IGh1YgotLS0tLUVORCBVU0IgSU5GTy0tLS0tCgotLS0tLUJFR0lOIE1PREFMSUFTRVMtLS0tLQogICAgICAxIGFjcGk6QUNQSTAwMTA6UE5QMEEwNToKICAgICAgMiBhY3BpOkxOWENQVToKICAgICAgMSBhY3BpOkxOWFBXUkJOOgogICAgICAyIGFjcGk6TE5YU1lCVVM6CiAgICAgIDEgYWNwaTpMTlhTWVNUTToKICAgICAgMSBhY3BpOlBOUDAxMDM6CiAgICAgIDEgYWNwaTpQTlAwMzAzOgogICAgICAxIGFjcGk6UE5QMDQwMDoKICAgICAgMiBhY3BpOlBOUDA1MDE6CiAgICAgIDEgYWNwaTpQTlAwNzAwOgogICAgICAxIGFjcGk6UE5QMEEwMzoKICAgICAgMyBhY3BpOlBOUDBBMDY6CiAgICAgIDEgYWNwaTpQTlAwQjAwOgogICAgICA1IGFjcGk6UE5QMEMwRjoKICAgICAgMSBhY3BpOlBOUDBGMTM6CiAgICAgIDIgYWNwaTpRRU1VMDAwMjoKICAgICAgMSBjcHU6dHlwZTp4ODYsdmVuMDAwMGZhbTAwMDZtb2QwMDVFOmZlYXR1cmU6LDAwMDAsMDAwMSwwMDAyLDAwMDMsMDAwNCwwMDA1LDAwMDYsMDAwNywwMDA4LDAwMDksMDAwQiwwMDBDLDAwMEQsMDAwRSwwMDBGLDAwMTAsMDAxMSwwMDEzLDAwMTcsMDAxOCwwMDE5LDAwMUEsMDAyQiwwMDM0LDAwM0IsMDAzRCwwMDY4LDAwNkYsMDA3MCwwMDcyLDAwNzQsMDA3NSwwMDc2LDAwODAsMDA4MSwwMDg5LDAwOEMsMDA4RCwwMDkxLDAwOTMsMDA5NCwwMDk1LDAwOTYsMDA5NywwMDk4LDAwOTksMDA5QSwwMDlCLDAwOUMsMDA5RCwwMDlFLDAwOUYsMDBDMCwwMEM1LDAwQzgsMDEyMCwwMTIzLDAxMjQsMDEyNSwwMTI3LDAxMjgsMDEyOSwwMTJBLDAxMkIsMDEyRSwwMTMyLDAxMzMsMDEzNCwwMTQwLDAxNDEsMDE0MiwwMUMyCiAgICAgIDEgZG1pOmJ2blNlYUJJT1M6YnZycmVsLTEuMTAuMi0wLWc1ZjRjN2IxLXByZWJ1aWx0LnFlbXUtcHJvamVjdC5vcmc6YmQwNC8wMS8yMDE0OnN2blFFTVU6cG5TdGFuZGFyZFBDKGk0NDBGWCtQSUlYLDE5OTYpOnB2cnBjLWk0NDBmeC0yLjk6Y3ZuUUVNVTpjdDE6Y3ZycGMtaTQ0MGZ4LTIuOToKICAgICAgMSBoZGF1ZGlvOnYxQUY0MDAyMnIwMDEwMDEwMWEwMQogICAgICAxIGlucHV0OmIwMDExdjAwMDFwMDAwMWVBQjQxLWUwLDEsNCwxMSwxNCxrNzEsNzIsNzMsNzQsNzUsNzYsNzcsNzksN0EsN0IsN0MsN0QsN0UsN0YsODAsOEMsOEUsOEYsOUIsOUMsOUQsOUUsOUYsQTMsQTQsQTUsQTYsQUMsQUQsQjcsQjgsQjksRDksRTIscmFtNCxsMCwxLDIsc2Z3CiAgICAgIDEgaW5wdXQ6YjAwMTF2MDAwMnAwMDA2ZTAwMDAtZTAsMSwyLGsxMTAsMTExLDExMiwxMTMsMTE0LHIwLDEsNiw4LGFtbHNmdwogICAgICAxIGlucHV0OmIwMDE5djAwMDBwMDAwMWUwMDAwLWUwLDEsazc0LHJhbWxzZncKICAgICAgMSBwY2k6djAwMDAxNUFEZDAwMDAwNDA1c3YwMDAwMTVBRHNkMDAwMDA0MDViYzAzc2MwMGkwMAogICAgICAyIHBjaTp2MDAwMDFBRjRkMDAwMDEwMDBzdjAwMDAxQUY0c2QwMDAwMDAwMWJjMDJzYzAwaTAwCiAgICAgIDEgcGNpOnYwMDAwMUFGNGQwMDAwMTAwMXN2MDAwMDFBRjRzZDAwMDAwMDAyYmMwMXNjMDBpMDAKICAgICAgMSBwY2k6djAwMDAxQUY0ZDAwMDAxMDAyc3YwMDAwMUFGNHNkMDAwMDAwMDViYzAwc2NGRmkwMAogICAgICAxIHBjaTp2MDAwMDFBRjRkMDAwMDEwMDNzdjAwMDAxQUY0c2QwMDAwMDAwM2JjMDdzYzgwaTAwCiAgICAgIDEgcGNpOnYwMDAwODA4NmQwMDAwMTIzN3N2MDAwMDFBRjRzZDAwMDAxMTAwYmMwNnNjMDBpMDAKICAgICAgMSBwY2k6djAwMDA4MDg2ZDAwMDAyNjY4c3YwMDAwMUFGNHNkMDAwMDExMDBiYzA0c2MwM2kwMAogICAgICAxIHBjaTp2MDAwMDgwODZkMDAwMDI5MzRzdjAwMDAxQUY0c2QwMDAwMTEwMGJjMENzYzAzaTAwCiAgICAgIDEgcGNpOnYwMDAwODA4NmQwMDAwMjkzNXN2MDAwMDFBRjRzZDAwMDAxMTAwYmMwQ3NjMDNpMDAKICAgICAgMSBwY2k6djAwMDA4MDg2ZDAwMDAyOTM2c3YwMDAwMUFGNHNkMDAwMDExMDBiYzBDc2MwM2kwMAogICAgICAxIHBjaTp2MDAwMDgwODZkMDAwMDI5M0FzdjAwMDAxQUY0c2QwMDAwMTEwMGJjMENzYzAzaTIwCiAgICAgIDEgcGNpOnYwMDAwODA4NmQwMDAwNzAwMHN2MDAwMDFBRjRzZDAwMDAxMTAwYmMwNnNjMDFpMDAKICAgICAgMSBwY2k6djAwMDA4MDg2ZDAwMDA3MDEwc3YwMDAwMUFGNHNkMDAwMDExMDBiYzAxc2MwMWk4MAogICAgICAxIHBjaTp2MDAwMDgwODZkMDAwMDcxMTNzdjAwMDAxQUY0c2QwMDAwMTEwMGJjMDZzYzgwaTAwCiAgICAgIDEgcGxhdGZvcm06Rml4ZWQgTURJTyBidXMKICAgICAgMSBwbGF0Zm9ybTphbGFybXRpbWVyCiAgICAgIDEgcGxhdGZvcm06aTgwNDIKICAgICAgMSBwbGF0Zm9ybTpwY3Nwa3IKICAgICAgMSBwbGF0Zm9ybTpwbGF0Zm9ybS1mcmFtZWJ1ZmZlcgogICAgICAxIHBsYXRmb3JtOnJlZy1kdW1teQogICAgICAxIHBsYXRmb3JtOnNlcmlhbDgyNTAKICAgICAgMSBzZXJpbzp0eTAxcHIwMGlkMDBleDAwCiAgICAgIDEgc2VyaW86dHkwNnByMDBpZDAwZXgwMAogICAgICAzIHVzYjp2MUQ2QnAwMDAxZDA0MTBkYzA5ZHNjMDBkcDAwaWMwOWlzYzAwaXAwMGluMDAKICAgICAgMSB1c2I6djFENkJwMDAwMmQwNDEwZGMwOWRzYzAwZHAwMGljMDlpc2MwMGlwMDBpbjAwCiAgICAgIDIgdmlydGlvOmQwMDAwMDAwMXYwMDAwMUFGNAogICAgICAxIHZpcnRpbzpkMDAwMDAwMDJ2MDAwMDFBRjQKICAgICAgMSB2aXJ0aW86ZDAwMDAwMDAzdjAwMDAxQUY0CiAgICAgIDEgdmlydGlvOmQwMDAwMDAwNXYwMDAwMUFGNAotLS0tLUVORCBNT0RBTElBU0VTLS0tLS0KCi0tLS0tQkVHSU4gU0VSSUFMIFBPUlRTLS0tLS0KL3N5cy9kZXZpY2VzL3BucDAvMDA6MDQvdHR5L3R0eVMwCi0tLS0tRU5EIFNFUklBTCBQT1JUUy0tLS0tCgotLS0tLUJFR0lOIE5FVFdPUksgSU5URVJGQUNFUy0tLS0tCjE6IGxvOiA8TE9PUEJBQ0ssVVAsTE9XRVJfVVA+IG10dSA2NTUzNiBxZGlzYyBub3F1ZXVlIHN0YXRlIFVOS05PV04gbW9kZSBERUZBVUxUIGdyb3VwIGRlZmF1bHQgcWxlbiAxMDAwXCAgICBsaW5rL2xvb3BiYWNrIDAwOjAwOjAwOjAwOjAwOjAwIGJyZCAwMDowMDowMDowMDowMDowMAoyOiBlbnMzOiA8QlJPQURDQVNULE1VTFRJQ0FTVCxVUCxMT1dFUl9VUD4gbXR1IDE1MDAgcWRpc2MgcGZpZm9fZmFzdCBzdGF0ZSBVUCBtb2RlIERFRkFVTFQgZ3JvdXAgZGVmYXVsdCBxbGVuIDEwMDBcICAgIGxpbmsvZXRoZXIgNTI6NTQ6MDA6ZjA6MTM6OTcgYnJkIGZmOmZmOmZmOmZmOmZmOmZmCjM6IGVuczk6IDxCUk9BRENBU1QsTVVMVElDQVNUPiBtdHUgMTUwMCBxZGlzYyBub29wIHN0YXRlIERPV04gbW9kZSBERUZBVUxUIGdyb3VwIGRlZmF1bHQgcWxlbiAxMDAwXCAgICBsaW5rL2V0aGVyIDUyOjU0OjAwOmUyOmYxOmQ1IGJyZCBmZjpmZjpmZjpmZjpmZjpmZgotLS0tLUVORCBORVRXT1JLIElOVEVSRkFDRVMtLS0tLQoKLS0tLS1CRUdJTiBCTE9DSyBERVZJQ0UgU1VNTUFSWS0tLS0tCk5BTUUgICBNQUo6TUlOIFJNIFNJWkUgUk8gVFlQRSBNT1VOVFBPSU5UCnZkYSAgICAyNTI6MCAgICAwICAxMEcgIDAgZGlzayAKYC12ZGExIDI1MjoxICAgIDAgIDEwRyAgMCBwYXJ0IC8KLS0tLS1FTkQgQkxPQ0sgREVWSUNFIFNVTU1BUlktLS0tLQo=		""	\N	1	\N	LS0tLS1CRUdJTiBLRVJORUwgSU5GTy0tLS0tCkxpbnV4IG9zLW5vZGUyIDQuMTAuMC0zMi1nZW5lcmljICMzNn4xNi4wNC4xLVVidW50dSBTTVAgV2VkIEF1ZyA5IDA5OjE5OjAyIFVUQyAyMDE3IHg4Nl82NCB4ODZfNjQgeDg2XzY0IEdOVS9MaW51eAotLS0tLUVORCBLRVJORUwgSU5GTy0tLS0tCgotLS0tLUJFR0lOIEtFUk5FTCBDT01NQU5EIExJTkUtLS0tLQpCT09UX0lNQUdFPS9ib290L3ZtbGludXotNC4xMC4wLTMyLWdlbmVyaWMgcm9vdD1VVUlEPTcxZjkwYmQ5LTkzYzUtNGFjZC05MzY3LTUyNzIwYzA0MTgwMiBybwotLS0tLUVORCBLRVJORUwgQ09NTUFORCBMSU5FLS0tLS0KCi0tLS0tQkVHSU4gQ1BVIENPUkUgQ09VTlQgQU5EIE1PREVMLS0tLS0KICAgICAgMiAgSW50ZWwgQ29yZSBQcm9jZXNzb3IgKFNreWxha2UpCi0tLS0tQkVHSU4gQ1BVIENPUkUgQ09VTlQgQU5EIE1PREVMLS0tLS0KCi0tLS0tQkVHSU4gUENJIElORk8tLS0tLQowMDowMC4wIEhvc3QgYnJpZGdlIFswNjAwXTogSW50ZWwgQ29ycG9yYXRpb24gNDQwRlggLSA4MjQ0MUZYIFBNQyBbTmF0b21hXSBbODA4NjoxMjM3XSAocmV2IDAyKQowMDowMS4wIElTQSBicmlkZ2UgWzA2MDFdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjM3MVNCIFBJSVgzIElTQSBbTmF0b21hL1RyaXRvbiBJSV0gWzgwODY6NzAwMF0KMDA6MDEuMSBJREUgaW50ZXJmYWNlIFswMTAxXTogSW50ZWwgQ29ycG9yYXRpb24gODIzNzFTQiBQSUlYMyBJREUgW05hdG9tYS9Ucml0b24gSUldIFs4MDg2OjcwMTBdCjAwOjAxLjMgQnJpZGdlIFswNjgwXTogSW50ZWwgQ29ycG9yYXRpb24gODIzNzFBQi9FQi9NQiBQSUlYNCBBQ1BJIFs4MDg2OjcxMTNdIChyZXYgMDMpCjAwOjAyLjAgVkdBIGNvbXBhdGlibGUgY29udHJvbGxlciBbMDMwMF06IFZNd2FyZSBTVkdBIElJIEFkYXB0ZXIgWzE1YWQ6MDQwNV0KMDA6MDMuMCBFdGhlcm5ldCBjb250cm9sbGVyIFswMjAwXTogUmVkIEhhdCwgSW5jIFZpcnRpbyBuZXR3b3JrIGRldmljZSBbMWFmNDoxMDAwXQowMDowNC4wIEF1ZGlvIGRldmljZSBbMDQwM106IEludGVsIENvcnBvcmF0aW9uIDgyODAxRkIvRkJNL0ZSL0ZXL0ZSVyAoSUNINiBGYW1pbHkpIEhpZ2ggRGVmaW5pdGlvbiBBdWRpbyBDb250cm9sbGVyIFs4MDg2OjI2NjhdIChyZXYgMDEpCjAwOjA1LjAgVVNCIGNvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUkgKElDSDkgRmFtaWx5KSBVU0IgVUhDSSBDb250cm9sbGVyICMxIFs4MDg2OjI5MzRdIChyZXYgMDMpCjAwOjA1LjEgVVNCIGNvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUkgKElDSDkgRmFtaWx5KSBVU0IgVUhDSSBDb250cm9sbGVyICMyIFs4MDg2OjI5MzVdIChyZXYgMDMpCjAwOjA1LjIgVVNCIGNvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUkgKElDSDkgRmFtaWx5KSBVU0IgVUhDSSBDb250cm9sbGVyICMzIFs4MDg2OjI5MzZdIChyZXYgMDMpCjAwOjA1LjcgVVNCIGNvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUkgKElDSDkgRmFtaWx5KSBVU0IyIEVIQ0kgQ29udHJvbGxlciAjMSBbODA4NjoyOTNhXSAocmV2IDAzKQowMDowNi4wIENvbW11bmljYXRpb24gY29udHJvbGxlciBbMDc4MF06IFJlZCBIYXQsIEluYyBWaXJ0aW8gY29uc29sZSBbMWFmNDoxMDAzXQowMDowNy4wIFNDU0kgc3RvcmFnZSBjb250cm9sbGVyIFswMTAwXTogUmVkIEhhdCwgSW5jIFZpcnRpbyBibG9jayBkZXZpY2UgWzFhZjQ6MTAwMV0KMDA6MDguMCBVbmNsYXNzaWZpZWQgZGV2aWNlIFswMGZmXTogUmVkIEhhdCwgSW5jIFZpcnRpbyBtZW1vcnkgYmFsbG9vbiBbMWFmNDoxMDAyXQowMDowOS4wIEV0aGVybmV0IGNvbnRyb2xsZXIgWzAyMDBdOiBSZWQgSGF0LCBJbmMgVmlydGlvIG5ldHdvcmsgZGV2aWNlIFsxYWY0OjEwMDBdCi0tLS0tRU5EIFBDSSBJTkZPLS0tLS0KCi0tLS0tQkVHSU4gVVNCIElORk8tLS0tLQpCdXMgMDAxIERldmljZSAwMDE6IElEIDFkNmI6MDAwMiBMaW51eCBGb3VuZGF0aW9uIDIuMCByb290IGh1YgpCdXMgMDA0IERldmljZSAwMDE6IElEIDFkNmI6MDAwMSBMaW51eCBGb3VuZGF0aW9uIDEuMSByb290IGh1YgpCdXMgMDAzIERldmljZSAwMDE6IElEIDFkNmI6MDAwMSBMaW51eCBGb3VuZGF0aW9uIDEuMSByb290IGh1YgpCdXMgMDAyIERldmljZSAwMDE6IElEIDFkNmI6MDAwMSBMaW51eCBGb3VuZGF0aW9uIDEuMSByb290IGh1YgotLS0tLUVORCBVU0IgSU5GTy0tLS0tCgotLS0tLUJFR0lOIE1PREFMSUFTRVMtLS0tLQogICAgICAxIGFjcGk6QUNQSTAwMTA6UE5QMEEwNToKICAgICAgMiBhY3BpOkxOWENQVToKICAgICAgMSBhY3BpOkxOWFBXUkJOOgogICAgICAyIGFjcGk6TE5YU1lCVVM6CiAgICAgIDEgYWNwaTpMTlhTWVNUTToKICAgICAgMSBhY3BpOlBOUDAxMDM6CiAgICAgIDEgYWNwaTpQTlAwMzAzOgogICAgICAxIGFjcGk6UE5QMDQwMDoKICAgICAgMiBhY3BpOlBOUDA1MDE6CiAgICAgIDEgYWNwaTpQTlAwNzAwOgogICAgICAxIGFjcGk6UE5QMEEwMzoKICAgICAgMyBhY3BpOlBOUDBBMDY6CiAgICAgIDEgYWNwaTpQTlAwQjAwOgogICAgICA1IGFjcGk6UE5QMEMwRjoKICAgICAgMSBhY3BpOlBOUDBGMTM6CiAgICAgIDIgYWNwaTpRRU1VMDAwMjoKICAgICAgMSBjcHU6dHlwZTp4ODYsdmVuMDAwMGZhbTAwMDZtb2QwMDVFOmZlYXR1cmU6LDAwMDAsMDAwMSwwMDAyLDAwMDMsMDAwNCwwMDA1LDAwMDYsMDAwNywwMDA4LDAwMDksMDAwQiwwMDBDLDAwMEQsMDAwRSwwMDBGLDAwMTAsMDAxMSwwMDEzLDAwMTcsMDAxOCwwMDE5LDAwMUEsMDAyQiwwMDM0LDAwM0IsMDAzRCwwMDY4LDAwNkYsMDA3MCwwMDcyLDAwNzQsMDA3NSwwMDc2LDAwODAsMDA4MSwwMDg5LDAwOEMsMDA4RCwwMDkxLDAwOTMsMDA5NCwwMDk1LDAwOTYsMDA5NywwMDk4LDAwOTksMDA5QSwwMDlCLDAwOUMsMDA5RCwwMDlFLDAwOUYsMDBDMCwwMEM1LDAwQzgsMDEyMCwwMTIzLDAxMjQsMDEyNSwwMTI3LDAxMjgsMDEyOSwwMTJBLDAxMkIsMDEyRSwwMTMyLDAxMzMsMDEzNCwwMTQwLDAxNDEsMDE0MiwwMUMyCiAgICAgIDEgZG1pOmJ2blNlYUJJT1M6YnZycmVsLTEuMTAuMi0wLWc1ZjRjN2IxLXByZWJ1aWx0LnFlbXUtcHJvamVjdC5vcmc6YmQwNC8wMS8yMDE0OnN2blFFTVU6cG5TdGFuZGFyZFBDKGk0NDBGWCtQSUlYLDE5OTYpOnB2cnBjLWk0NDBmeC0yLjk6Y3ZuUUVNVTpjdDE6Y3ZycGMtaTQ0MGZ4LTIuOToKICAgICAgMSBoZGF1ZGlvOnYxQUY0MDAyMnIwMDEwMDEwMWEwMQogICAgICAxIGlucHV0OmIwMDExdjAwMDFwMDAwMWVBQjQxLWUwLDEsNCwxMSwxNCxrNzEsNzIsNzMsNzQsNzUsNzYsNzcsNzksN0EsN0IsN0MsN0QsN0UsN0YsODAsOEMsOEUsOEYsOUIsOUMsOUQsOUUsOUYsQTMsQTQsQTUsQTYsQUMsQUQsQjcsQjgsQjksRDksRTIscmFtNCxsMCwxLDIsc2Z3CiAgICAgIDEgaW5wdXQ6YjAwMTF2MDAwMnAwMDA2ZTAwMDAtZTAsMSwyLGsxMTAsMTExLDExMiwxMTMsMTE0LHIwLDEsNiw4LGFtbHNmdwogICAgICAxIGlucHV0OmIwMDE5djAwMDBwMDAwMWUwMDAwLWUwLDEsazc0LHJhbWxzZncKICAgICAgMSBwY2k6djAwMDAxNUFEZDAwMDAwNDA1c3YwMDAwMTVBRHNkMDAwMDA0MDViYzAzc2MwMGkwMAogICAgICAyIHBjaTp2MDAwMDFBRjRkMDAwMDEwMDBzdjAwMDAxQUY0c2QwMDAwMDAwMWJjMDJzYzAwaTAwCiAgICAgIDEgcGNpOnYwMDAwMUFGNGQwMDAwMTAwMXN2MDAwMDFBRjRzZDAwMDAwMDAyYmMwMXNjMDBpMDAKICAgICAgMSBwY2k6djAwMDAxQUY0ZDAwMDAxMDAyc3YwMDAwMUFGNHNkMDAwMDAwMDViYzAwc2NGRmkwMAogICAgICAxIHBjaTp2MDAwMDFBRjRkMDAwMDEwMDNzdjAwMDAxQUY0c2QwMDAwMDAwM2JjMDdzYzgwaTAwCiAgICAgIDEgcGNpOnYwMDAwODA4NmQwMDAwMTIzN3N2MDAwMDFBRjRzZDAwMDAxMTAwYmMwNnNjMDBpMDAKICAgICAgMSBwY2k6djAwMDA4MDg2ZDAwMDAyNjY4c3YwMDAwMUFGNHNkMDAwMDExMDBiYzA0c2MwM2kwMAogICAgICAxIHBjaTp2MDAwMDgwODZkMDAwMDI5MzRzdjAwMDAxQUY0c2QwMDAwMTEwMGJjMENzYzAzaTAwCiAgICAgIDEgcGNpOnYwMDAwODA4NmQwMDAwMjkzNXN2MDAwMDFBRjRzZDAwMDAxMTAwYmMwQ3NjMDNpMDAKICAgICAgMSBwY2k6djAwMDA4MDg2ZDAwMDAyOTM2c3YwMDAwMUFGNHNkMDAwMDExMDBiYzBDc2MwM2kwMAogICAgICAxIHBjaTp2MDAwMDgwODZkMDAwMDI5M0FzdjAwMDAxQUY0c2QwMDAwMTEwMGJjMENzYzAzaTIwCiAgICAgIDEgcGNpOnYwMDAwODA4NmQwMDAwNzAwMHN2MDAwMDFBRjRzZDAwMDAxMTAwYmMwNnNjMDFpMDAKICAgICAgMSBwY2k6djAwMDA4MDg2ZDAwMDA3MDEwc3YwMDAwMUFGNHNkMDAwMDExMDBiYzAxc2MwMWk4MAogICAgICAxIHBjaTp2MDAwMDgwODZkMDAwMDcxMTNzdjAwMDAxQUY0c2QwMDAwMTEwMGJjMDZzYzgwaTAwCiAgICAgIDEgcGxhdGZvcm06Rml4ZWQgTURJTyBidXMKICAgICAgMSBwbGF0Zm9ybTphbGFybXRpbWVyCiAgICAgIDEgcGxhdGZvcm06aTgwNDIKICAgICAgMSBwbGF0Zm9ybTpwY3Nwa3IKICAgICAgMSBwbGF0Zm9ybTpwbGF0Zm9ybS1mcmFtZWJ1ZmZlcgogICAgICAxIHBsYXRmb3JtOnJlZy1kdW1teQogICAgICAxIHBsYXRmb3JtOnNlcmlhbDgyNTAKICAgICAgMSBzZXJpbzp0eTAxcHIwMGlkMDBleDAwCiAgICAgIDEgc2VyaW86dHkwNnByMDBpZDAwZXgwMAogICAgICAzIHVzYjp2MUQ2QnAwMDAxZDA0MTBkYzA5ZHNjMDBkcDAwaWMwOWlzYzAwaXAwMGluMDAKICAgICAgMSB1c2I6djFENkJwMDAwMmQwNDEwZGMwOWRzYzAwZHAwMGljMDlpc2MwMGlwMDBpbjAwCiAgICAgIDIgdmlydGlvOmQwMDAwMDAwMXYwMDAwMUFGNAogICAgICAxIHZpcnRpbzpkMDAwMDAwMDJ2MDAwMDFBRjQKICAgICAgMSB2aXJ0aW86ZDAwMDAwMDAzdjAwMDAxQUY0CiAgICAgIDEgdmlydGlvOmQwMDAwMDAwNXYwMDAwMUFGNAotLS0tLUVORCBNT0RBTElBU0VTLS0tLS0KCi0tLS0tQkVHSU4gU0VSSUFMIFBPUlRTLS0tLS0KL3N5cy9kZXZpY2VzL3BucDAvMDA6MDQvdHR5L3R0eVMwCi0tLS0tRU5EIFNFUklBTCBQT1JUUy0tLS0tCgotLS0tLUJFR0lOIE5FVFdPUksgSU5URVJGQUNFUy0tLS0tCjE6IGxvOiA8TE9PUEJBQ0ssVVAsTE9XRVJfVVA+IG10dSA2NTUzNiBxZGlzYyBub3F1ZXVlIHN0YXRlIFVOS05PV04gbW9kZSBERUZBVUxUIGdyb3VwIGRlZmF1bHQgcWxlbiAxMDAwXCAgICBsaW5rL2xvb3BiYWNrIDAwOjAwOjAwOjAwOjAwOjAwIGJyZCAwMDowMDowMDowMDowMDowMAoyOiBlbnMzOiA8QlJPQURDQVNULE1VTFRJQ0FTVCxVUCxMT1dFUl9VUD4gbXR1IDE1MDAgcWRpc2MgcGZpZm9fZmFzdCBzdGF0ZSBVUCBtb2RlIERFRkFVTFQgZ3JvdXAgZGVmYXVsdCBxbGVuIDEwMDBcICAgIGxpbmsvZXRoZXIgNTI6NTQ6MDA6ZjA6MTM6OTcgYnJkIGZmOmZmOmZmOmZmOmZmOmZmCjM6IGVuczk6IDxCUk9BRENBU1QsTVVMVElDQVNUPiBtdHUgMTUwMCBxZGlzYyBub29wIHN0YXRlIERPV04gbW9kZSBERUZBVUxUIGdyb3VwIGRlZmF1bHQgcWxlbiAxMDAwXCAgICBsaW5rL2V0aGVyIDUyOjU0OjAwOmUyOmYxOmQ1IGJyZCBmZjpmZjpmZjpmZjpmZjpmZgotLS0tLUVORCBORVRXT1JLIElOVEVSRkFDRVMtLS0tLQoKLS0tLS1CRUdJTiBCTE9DSyBERVZJQ0UgU1VNTUFSWS0tLS0tCk5BTUUgICBNQUo6TUlOIFJNIFNJWkUgUk8gVFlQRSBNT1VOVFBPSU5UCnZkYSAgICAyNTI6MCAgICAwICAxMEcgIDAgZGlzayAKYC12ZGExIDI1MjoxICAgIDAgIDEwRyAgMCBwYXJ0IC8KLS0tLS1FTkQgQkxPQ0sgREVWSUNFIFNVTU1BUlktLS0tLQo=	2017-08-14 23:10:05.397435+00	\N
3	2017-08-14 23:10:01.648973+00	2017-08-14 23:10:05.787741+00	2	0	00-maas-01-cpuinfo	QXJjaGl0ZWN0dXJlOiAgICAgICAgICB4ODZfNjQKQ1BVIG9wLW1vZGUocyk6ICAgICAgICAzMi1iaXQsIDY0LWJpdApCeXRlIE9yZGVyOiAgICAgICAgICAgIExpdHRsZSBFbmRpYW4KQ1BVKHMpOiAgICAgICAgICAgICAgICAyCk9uLWxpbmUgQ1BVKHMpIGxpc3Q6ICAgMCwxClRocmVhZChzKSBwZXIgY29yZTogICAgMQpDb3JlKHMpIHBlciBzb2NrZXQ6ICAgIDEKU29ja2V0KHMpOiAgICAgICAgICAgICAyCk5VTUEgbm9kZShzKTogICAgICAgICAgMQpWZW5kb3IgSUQ6ICAgICAgICAgICAgIEdlbnVpbmVJbnRlbApDUFUgZmFtaWx5OiAgICAgICAgICAgIDYKTW9kZWw6ICAgICAgICAgICAgICAgICA5NApNb2RlbCBuYW1lOiAgICAgICAgICAgIEludGVsIENvcmUgUHJvY2Vzc29yIChTa3lsYWtlKQpTdGVwcGluZzogICAgICAgICAgICAgIDMKQ1BVIE1IejogICAgICAgICAgICAgICAyNTkxLjk5OApCb2dvTUlQUzogICAgICAgICAgICAgIDUxODMuOTkKSHlwZXJ2aXNvciB2ZW5kb3I6ICAgICBLVk0KVmlydHVhbGl6YXRpb24gdHlwZTogICBmdWxsCkwxZCBjYWNoZTogICAgICAgICAgICAgMzJLCkwxaSBjYWNoZTogICAgICAgICAgICAgMzJLCkwyIGNhY2hlOiAgICAgICAgICAgICAgNDA5NksKTDMgY2FjaGU6ICAgICAgICAgICAgICAxNjM4NEsKTlVNQSBub2RlMCBDUFUocyk6ICAgICAwLDEKRmxhZ3M6ICAgICAgICAgICAgICAgICBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIG1teCBmeHNyIHNzZSBzc2UyIHN5c2NhbGwgbnggcmR0c2NwIGxtIGNvbnN0YW50X3RzYyByZXBfZ29vZCBub3BsIHh0b3BvbG9neSBwbmkgcGNsbXVscWRxIHNzc2UzIGZtYSBjeDE2IHBjaWQgc3NlNF8xIHNzZTRfMiB4MmFwaWMgbW92YmUgcG9wY250IHRzY19kZWFkbGluZV90aW1lciBhZXMgeHNhdmUgYXZ4IGYxNmMgcmRyYW5kIGh5cGVydmlzb3IgbGFoZl9sbSBhYm0gM2Rub3dwcmVmZXRjaCBmc2dzYmFzZSBibWkxIGhsZSBhdngyIHNtZXAgYm1pMiBlcm1zIGludnBjaWQgcnRtIG1weCByZHNlZWQgYWR4IHNtYXAgeHNhdmVvcHQgeHNhdmVjIHhnZXRidjEgYXJhdAojIFRoZSBmb2xsb3dpbmcgaXMgdGhlIHBhcnNhYmxlIGZvcm1hdCwgd2hpY2ggY2FuIGJlIGZlZCB0byBvdGhlcgojIHByb2dyYW1zLiBFYWNoIGRpZmZlcmVudCBpdGVtIGluIGV2ZXJ5IGNvbHVtbiBoYXMgYW4gdW5pcXVlIElECiMgc3RhcnRpbmcgZnJvbSB6ZXJvLgojIENQVSxDb3JlLFNvY2tldAowLDAsMAoxLDEsMQo=		""	\N	1	\N	QXJjaGl0ZWN0dXJlOiAgICAgICAgICB4ODZfNjQKQ1BVIG9wLW1vZGUocyk6ICAgICAgICAzMi1iaXQsIDY0LWJpdApCeXRlIE9yZGVyOiAgICAgICAgICAgIExpdHRsZSBFbmRpYW4KQ1BVKHMpOiAgICAgICAgICAgICAgICAyCk9uLWxpbmUgQ1BVKHMpIGxpc3Q6ICAgMCwxClRocmVhZChzKSBwZXIgY29yZTogICAgMQpDb3JlKHMpIHBlciBzb2NrZXQ6ICAgIDEKU29ja2V0KHMpOiAgICAgICAgICAgICAyCk5VTUEgbm9kZShzKTogICAgICAgICAgMQpWZW5kb3IgSUQ6ICAgICAgICAgICAgIEdlbnVpbmVJbnRlbApDUFUgZmFtaWx5OiAgICAgICAgICAgIDYKTW9kZWw6ICAgICAgICAgICAgICAgICA5NApNb2RlbCBuYW1lOiAgICAgICAgICAgIEludGVsIENvcmUgUHJvY2Vzc29yIChTa3lsYWtlKQpTdGVwcGluZzogICAgICAgICAgICAgIDMKQ1BVIE1IejogICAgICAgICAgICAgICAyNTkxLjk5OApCb2dvTUlQUzogICAgICAgICAgICAgIDUxODMuOTkKSHlwZXJ2aXNvciB2ZW5kb3I6ICAgICBLVk0KVmlydHVhbGl6YXRpb24gdHlwZTogICBmdWxsCkwxZCBjYWNoZTogICAgICAgICAgICAgMzJLCkwxaSBjYWNoZTogICAgICAgICAgICAgMzJLCkwyIGNhY2hlOiAgICAgICAgICAgICAgNDA5NksKTDMgY2FjaGU6ICAgICAgICAgICAgICAxNjM4NEsKTlVNQSBub2RlMCBDUFUocyk6ICAgICAwLDEKRmxhZ3M6ICAgICAgICAgICAgICAgICBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIG1teCBmeHNyIHNzZSBzc2UyIHN5c2NhbGwgbnggcmR0c2NwIGxtIGNvbnN0YW50X3RzYyByZXBfZ29vZCBub3BsIHh0b3BvbG9neSBwbmkgcGNsbXVscWRxIHNzc2UzIGZtYSBjeDE2IHBjaWQgc3NlNF8xIHNzZTRfMiB4MmFwaWMgbW92YmUgcG9wY250IHRzY19kZWFkbGluZV90aW1lciBhZXMgeHNhdmUgYXZ4IGYxNmMgcmRyYW5kIGh5cGVydmlzb3IgbGFoZl9sbSBhYm0gM2Rub3dwcmVmZXRjaCBmc2dzYmFzZSBibWkxIGhsZSBhdngyIHNtZXAgYm1pMiBlcm1zIGludnBjaWQgcnRtIG1weCByZHNlZWQgYWR4IHNtYXAgeHNhdmVvcHQgeHNhdmVjIHhnZXRidjEgYXJhdAojIFRoZSBmb2xsb3dpbmcgaXMgdGhlIHBhcnNhYmxlIGZvcm1hdCwgd2hpY2ggY2FuIGJlIGZlZCB0byBvdGhlcgojIHByb2dyYW1zLiBFYWNoIGRpZmZlcmVudCBpdGVtIGluIGV2ZXJ5IGNvbHVtbiBoYXMgYW4gdW5pcXVlIElECiMgc3RhcnRpbmcgZnJvbSB6ZXJvLgojIENQVSxDb3JlLFNvY2tldAowLDAsMAoxLDEsMQo=	2017-08-14 23:10:05.835089+00	\N
2	2017-08-14 23:10:01.648973+00	2017-08-14 23:10:06.962798+00	2	0	00-maas-01-lshw	PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJ5ZXMiID8+CjwhLS0gZ2VuZXJhdGVkIGJ5IGxzaHctQi4wMi4xNyAtLT4KPCEtLSBHQ0MgNS4zLjEgMjAxNjA0MTMgLS0+CjwhLS0gTGludXggNC4xMC4wLTMyLWdlbmVyaWMgIzM2fjE2LjA0LjEtVWJ1bnR1IFNNUCBXZWQgQXVnIDkgMDk6MTk6MDIgVVRDIDIwMTcgeDg2XzY0IC0tPgo8IS0tIEdOVSBsaWJjIDIgKGdsaWJjIDIuMjMpIC0tPgo8bGlzdD4KPG5vZGUgaWQ9Im9zLW5vZGUyIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0ic3lzdGVtIiBoYW5kbGU9IkRNSTowMTAwIj4KIDxkZXNjcmlwdGlvbj5Db21wdXRlcjwvZGVzY3JpcHRpb24+CiA8cHJvZHVjdD5TdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5Nik8L3Byb2R1Y3Q+CiA8dmVuZG9yPlFFTVU8L3ZlbmRvcj4KIDx2ZXJzaW9uPnBjLWk0NDBmeC0yLjk8L3ZlcnNpb24+CiA8d2lkdGggdW5pdHM9ImJpdHMiPjY0PC93aWR0aD4KIDxjb25maWd1cmF0aW9uPgogIDxzZXR0aW5nIGlkPSJib290IiB2YWx1ZT0ibm9ybWFsIiAvPgogIDxzZXR0aW5nIGlkPSJ1dWlkIiB2YWx1ZT0iMkFFRDlEODMtNzUxMi03RjRELUJFRDQtNUU0QTUxMzFBMDExIiAvPgogPC9jb25maWd1cmF0aW9uPgogPGNhcGFiaWxpdGllcz4KICA8Y2FwYWJpbGl0eSBpZD0ic21iaW9zLTIuOCIgPlNNQklPUyB2ZXJzaW9uIDIuODwvY2FwYWJpbGl0eT4KICA8Y2FwYWJpbGl0eSBpZD0iZG1pLTIuOCIgPkRNSSB2ZXJzaW9uIDIuODwvY2FwYWJpbGl0eT4KICA8Y2FwYWJpbGl0eSBpZD0idnN5c2NhbGwzMiIgPjMyLWJpdCBwcm9jZXNzZXM8L2NhcGFiaWxpdHk+CiA8L2NhcGFiaWxpdGllcz4KICA8bm9kZSBpZD0iY29yZSIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9ImJ1cyIgaGFuZGxlPSIiPgogICA8ZGVzY3JpcHRpb24+TW90aGVyYm9hcmQ8L2Rlc2NyaXB0aW9uPgogICA8cGh5c2lkPjA8L3BoeXNpZD4KICAgIDxub2RlIGlkPSJmaXJtd2FyZSIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9Im1lbW9yeSIgaGFuZGxlPSIiPgogICAgIDxkZXNjcmlwdGlvbj5CSU9TPC9kZXNjcmlwdGlvbj4KICAgICA8dmVuZG9yPlNlYUJJT1M8L3ZlbmRvcj4KICAgICA8cGh5c2lkPjA8L3BoeXNpZD4KICAgICA8dmVyc2lvbj5yZWwtMS4xMC4yLTAtZzVmNGM3YjEtcHJlYnVpbHQucWVtdS1wcm9qZWN0Lm9yZzwvdmVyc2lvbj4KICAgICA8ZGF0ZT4wNC8wMS8yMDE0PC9kYXRlPgogICAgIDxzaXplIHVuaXRzPSJieXRlcyI+OTgzMDQ8L3NpemU+CiAgICA8L25vZGU+CiAgICA8bm9kZSBpZD0iY3B1OjAiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJwcm9jZXNzb3IiIGhhbmRsZT0iRE1JOjA0MDAiPgogICAgIDxkZXNjcmlwdGlvbj5DUFU8L2Rlc2NyaXB0aW9uPgogICAgIDxwcm9kdWN0PkludGVsIENvcmUgUHJvY2Vzc29yIChTa3lsYWtlKTwvcHJvZHVjdD4KICAgICA8dmVuZG9yPkludGVsIENvcnAuPC92ZW5kb3I+CiAgICAgPHBoeXNpZD40MDA8L3BoeXNpZD4KICAgICA8YnVzaW5mbz5jcHVAMDwvYnVzaW5mbz4KICAgICA8dmVyc2lvbj5wYy1pNDQwZngtMi45PC92ZXJzaW9uPgogICAgIDxzbG90PkNQVSAwPC9zbG90PgogICAgIDxzaXplIHVuaXRzPSJIeiI+MjAwMDAwMDAwMDwvc2l6ZT4KICAgICA8Y2FwYWNpdHkgdW5pdHM9Ikh6Ij4yMDAwMDAwMDAwPC9jYXBhY2l0eT4KICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjY0PC93aWR0aD4KICAgICA8Y29uZmlndXJhdGlvbj4KICAgICAgPHNldHRpbmcgaWQ9ImNvcmVzIiB2YWx1ZT0iMSIgLz4KICAgICAgPHNldHRpbmcgaWQ9ImVuYWJsZWRjb3JlcyIgdmFsdWU9IjEiIC8+CiAgICAgIDxzZXR0aW5nIGlkPSJ0aHJlYWRzIiB2YWx1ZT0iMSIgLz4KICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImZwdSIgPm1hdGhlbWF0aWNhbCBjby1wcm9jZXNzb3I8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJmcHVfZXhjZXB0aW9uIiA+RlBVIGV4Y2VwdGlvbnMgcmVwb3J0aW5nPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0id3AiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ2bWUiID52aXJ0dWFsIG1vZGUgZXh0ZW5zaW9uczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImRlIiA+ZGVidWdnaW5nIGV4dGVuc2lvbnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwc2UiID5wYWdlIHNpemUgZXh0ZW5zaW9uczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InRzYyIgPnRpbWUgc3RhbXAgY291bnRlcjwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im1zciIgPm1vZGVsLXNwZWNpZmljIHJlZ2lzdGVyczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InBhZSIgPjRHQisgbWVtb3J5IGFkZHJlc3NpbmcgKFBoeXNpY2FsIEFkZHJlc3MgRXh0ZW5zaW9uKTwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im1jZSIgPm1hY2hpbmUgY2hlY2sgZXhjZXB0aW9uczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImN4OCIgPmNvbXBhcmUgYW5kIGV4Y2hhbmdlIDgtYnl0ZTwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImFwaWMiID5vbi1jaGlwIGFkdmFuY2VkIHByb2dyYW1tYWJsZSBpbnRlcnJ1cHQgY29udHJvbGxlciAoQVBJQyk8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJzZXAiID5mYXN0IHN5c3RlbSBjYWxsczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im10cnIiID5tZW1vcnkgdHlwZSByYW5nZSByZWdpc3RlcnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwZ2UiID5wYWdlIGdsb2JhbCBlbmFibGU8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJtY2EiID5tYWNoaW5lIGNoZWNrIGFyY2hpdGVjdHVyZTwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImNtb3YiID5jb25kaXRpb25hbCBtb3ZlIGluc3RydWN0aW9uPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0icGF0IiA+cGFnZSBhdHRyaWJ1dGUgdGFibGU8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwc2UzNiIgPjM2LWJpdCBwYWdlIHNpemUgZXh0ZW5zaW9uczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImNsZmx1c2giIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJtbXgiID5tdWx0aW1lZGlhIGV4dGVuc2lvbnMgKE1NWCk8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJmeHNyIiA+ZmFzdCBmbG9hdGluZyBwb2ludCBzYXZlL3Jlc3RvcmU8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJzc2UiID5zdHJlYW1pbmcgU0lNRCBleHRlbnNpb25zIChTU0UpPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic3NlMiIgPnN0cmVhbWluZyBTSU1EIGV4dGVuc2lvbnMgKFNTRTIpPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic3lzY2FsbCIgPmZhc3Qgc3lzdGVtIGNhbGxzPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0ibngiID5uby1leGVjdXRlIGJpdCAoTlgpPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0icmR0c2NwIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ieDg2LTY0IiA+NjRiaXRzIGV4dGVuc2lvbnMgKHg4Ni02NCk8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJjb25zdGFudF90c2MiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJyZXBfZ29vZCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im5vcGwiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ4dG9wb2xvZ3kiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwbmkiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwY2xtdWxxZHEiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJzc3NlMyIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImZtYSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImN4MTYiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwY2lkIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic3NlNF8xIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic3NlNF8yIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ieDJhcGljIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ibW92YmUiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwb3BjbnQiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ0c2NfZGVhZGxpbmVfdGltZXIiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhZXMiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ4c2F2ZSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImF2eCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImYxNmMiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJyZHJhbmQiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJoeXBlcnZpc29yIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ibGFoZl9sbSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImFibSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9IjNkbm93cHJlZmV0Y2giIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJmc2dzYmFzZSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJtaTEiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJobGUiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhdngyIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic21lcCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJtaTIiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJlcm1zIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iaW52cGNpZCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InJ0bSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im1weCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InJkc2VlZCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImFkeCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InNtYXAiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ4c2F2ZW9wdCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InhzYXZlYyIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InhnZXRidjEiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhcmF0IiAvPgogICAgIDwvY2FwYWJpbGl0aWVzPgogICAgPC9ub2RlPgogICAgPG5vZGUgaWQ9ImNwdToxIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0icHJvY2Vzc29yIiBoYW5kbGU9IkRNSTowNDAxIj4KICAgICA8ZGVzY3JpcHRpb24+Q1BVPC9kZXNjcmlwdGlvbj4KICAgICA8cHJvZHVjdD5JbnRlbCBDb3JlIFByb2Nlc3NvciAoU2t5bGFrZSk8L3Byb2R1Y3Q+CiAgICAgPHZlbmRvcj5JbnRlbCBDb3JwLjwvdmVuZG9yPgogICAgIDxwaHlzaWQ+NDAxPC9waHlzaWQ+CiAgICAgPGJ1c2luZm8+Y3B1QDE8L2J1c2luZm8+CiAgICAgPHZlcnNpb24+cGMtaTQ0MGZ4LTIuOTwvdmVyc2lvbj4KICAgICA8c2xvdD5DUFUgMTwvc2xvdD4KICAgICA8c2l6ZSB1bml0cz0iSHoiPjIwMDAwMDAwMDA8L3NpemU+CiAgICAgPGNhcGFjaXR5IHVuaXRzPSJIeiI+MjAwMDAwMDAwMDwvY2FwYWNpdHk+CiAgICAgPHdpZHRoIHVuaXRzPSJiaXRzIj42NDwvd2lkdGg+CiAgICAgPGNvbmZpZ3VyYXRpb24+CiAgICAgIDxzZXR0aW5nIGlkPSJjb3JlcyIgdmFsdWU9IjEiIC8+CiAgICAgIDxzZXR0aW5nIGlkPSJlbmFibGVkY29yZXMiIHZhbHVlPSIxIiAvPgogICAgICA8c2V0dGluZyBpZD0idGhyZWFkcyIgdmFsdWU9IjEiIC8+CiAgICAgPC9jb25maWd1cmF0aW9uPgogICAgIDxjYXBhYmlsaXRpZXM+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJmcHUiID5tYXRoZW1hdGljYWwgY28tcHJvY2Vzc29yPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0iZnB1X2V4Y2VwdGlvbiIgPkZQVSBleGNlcHRpb25zIHJlcG9ydGluZzwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9IndwIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0idm1lIiA+dmlydHVhbCBtb2RlIGV4dGVuc2lvbnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJkZSIgPmRlYnVnZ2luZyBleHRlbnNpb25zPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0icHNlIiA+cGFnZSBzaXplIGV4dGVuc2lvbnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ0c2MiID50aW1lIHN0YW1wIGNvdW50ZXI8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJtc3IiID5tb2RlbC1zcGVjaWZpYyByZWdpc3RlcnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwYWUiID40R0IrIG1lbW9yeSBhZGRyZXNzaW5nIChQaHlzaWNhbCBBZGRyZXNzIEV4dGVuc2lvbik8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJtY2UiID5tYWNoaW5lIGNoZWNrIGV4Y2VwdGlvbnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJjeDgiID5jb21wYXJlIGFuZCBleGNoYW5nZSA4LWJ5dGU8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhcGljIiA+b24tY2hpcCBhZHZhbmNlZCBwcm9ncmFtbWFibGUgaW50ZXJydXB0IGNvbnRyb2xsZXIgKEFQSUMpPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic2VwIiA+ZmFzdCBzeXN0ZW0gY2FsbHM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJtdHJyIiA+bWVtb3J5IHR5cGUgcmFuZ2UgcmVnaXN0ZXJzPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0icGdlIiA+cGFnZSBnbG9iYWwgZW5hYmxlPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0ibWNhIiA+bWFjaGluZSBjaGVjayBhcmNoaXRlY3R1cmU8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJjbW92IiA+Y29uZGl0aW9uYWwgbW92ZSBpbnN0cnVjdGlvbjwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InBhdCIgPnBhZ2UgYXR0cmlidXRlIHRhYmxlPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0icHNlMzYiID4zNi1iaXQgcGFnZSBzaXplIGV4dGVuc2lvbnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJjbGZsdXNoIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ibW14IiA+bXVsdGltZWRpYSBleHRlbnNpb25zIChNTVgpPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0iZnhzciIgPmZhc3QgZmxvYXRpbmcgcG9pbnQgc2F2ZS9yZXN0b3JlPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic3NlIiA+c3RyZWFtaW5nIFNJTUQgZXh0ZW5zaW9ucyAoU1NFKTwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InNzZTIiID5zdHJlYW1pbmcgU0lNRCBleHRlbnNpb25zIChTU0UyKTwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InN5c2NhbGwiID5mYXN0IHN5c3RlbSBjYWxsczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im54IiA+bm8tZXhlY3V0ZSBiaXQgKE5YKTwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InJkdHNjcCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Ing4Ni02NCIgPjY0Yml0cyBleHRlbnNpb25zICh4ODYtNjQpPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0iY29uc3RhbnRfdHNjIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0icmVwX2dvb2QiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJub3BsIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ieHRvcG9sb2d5IiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0icG5pIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0icGNsbXVscWRxIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic3NzZTMiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJmbWEiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJjeDE2IiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0icGNpZCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InNzZTRfMSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InNzZTRfMiIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9IngyYXBpYyIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im1vdmJlIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0icG9wY250IiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0idHNjX2RlYWRsaW5lX3RpbWVyIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iYWVzIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ieHNhdmUiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhdngiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJmMTZjIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0icmRyYW5kIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iaHlwZXJ2aXNvciIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImxhaGZfbG0iIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhYm0iIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSIzZG5vd3ByZWZldGNoIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iZnNnc2Jhc2UiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJibWkxIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iaGxlIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iYXZ4MiIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InNtZXAiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJibWkyIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iZXJtcyIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImludnBjaWQiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJydG0iIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJtcHgiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJyZHNlZWQiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhZHgiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJzbWFwIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ieHNhdmVvcHQiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ4c2F2ZWMiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ4Z2V0YnYxIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iYXJhdCIgLz4KICAgICA8L2NhcGFiaWxpdGllcz4KICAgIDwvbm9kZT4KICAgIDxub2RlIGlkPSJtZW1vcnkiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJtZW1vcnkiIGhhbmRsZT0iRE1JOjEwMDAiPgogICAgIDxkZXNjcmlwdGlvbj5TeXN0ZW0gTWVtb3J5PC9kZXNjcmlwdGlvbj4KICAgICA8cGh5c2lkPjEwMDA8L3BoeXNpZD4KICAgICA8c2l6ZSB1bml0cz0iYnl0ZXMiPjIxNDc0ODM2NDg8L3NpemU+CiAgICAgPGNhcGFjaXR5IHVuaXRzPSJieXRlcyI+MjE0NzQ4MzY0ODwvY2FwYWNpdHk+CiAgICAgIDxub2RlIGlkPSJiYW5rIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0ibWVtb3J5IiBoYW5kbGU9IkRNSToxMTAwIj4KICAgICAgIDxkZXNjcmlwdGlvbj5ESU1NIFJBTTwvZGVzY3JpcHRpb24+CiAgICAgICA8dmVuZG9yPlFFTVU8L3ZlbmRvcj4KICAgICAgIDxwaHlzaWQ+MDwvcGh5c2lkPgogICAgICAgPHNsb3Q+RElNTSAwPC9zbG90PgogICAgICAgPHNpemUgdW5pdHM9ImJ5dGVzIj4yMTQ3NDgzNjQ4PC9zaXplPgogICAgICA8L25vZGU+CiAgICA8L25vZGU+CiAgICA8bm9kZSBpZD0icGNpIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0iYnJpZGdlIiBoYW5kbGU9IlBDSUJVUzowMDAwOjAwIj4KICAgICA8ZGVzY3JpcHRpb24+SG9zdCBicmlkZ2U8L2Rlc2NyaXB0aW9uPgogICAgIDxwcm9kdWN0PjQ0MEZYIC0gODI0NDFGWCBQTUMgW05hdG9tYV08L3Byb2R1Y3Q+CiAgICAgPHZlbmRvcj5JbnRlbCBDb3Jwb3JhdGlvbjwvdmVuZG9yPgogICAgIDxwaHlzaWQ+MTAwPC9waHlzaWQ+CiAgICAgPGJ1c2luZm8+cGNpQDAwMDA6MDA6MDAuMDwvYnVzaW5mbz4KICAgICA8dmVyc2lvbj4wMjwvdmVyc2lvbj4KICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjMyPC93aWR0aD4KICAgICA8Y2xvY2sgdW5pdHM9Ikh6Ij4zMzAwMDAwMDwvY2xvY2s+CiAgICAgIDxub2RlIGlkPSJpc2EiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJicmlkZ2UiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDEuMCI+CiAgICAgICA8ZGVzY3JpcHRpb24+SVNBIGJyaWRnZTwvZGVzY3JpcHRpb24+CiAgICAgICA8cHJvZHVjdD44MjM3MVNCIFBJSVgzIElTQSBbTmF0b21hL1RyaXRvbiBJSV08L3Byb2R1Y3Q+CiAgICAgICA8dmVuZG9yPkludGVsIENvcnBvcmF0aW9uPC92ZW5kb3I+CiAgICAgICA8cGh5c2lkPjE8L3BoeXNpZD4KICAgICAgIDxidXNpbmZvPnBjaUAwMDAwOjAwOjAxLjA8L2J1c2luZm8+CiAgICAgICA8dmVyc2lvbj4wMDwvdmVyc2lvbj4KICAgICAgIDx3aWR0aCB1bml0cz0iYml0cyI+MzI8L3dpZHRoPgogICAgICAgPGNsb2NrIHVuaXRzPSJIeiI+MzMwMDAwMDA8L2Nsb2NrPgogICAgICAgPGNvbmZpZ3VyYXRpb24+CiAgICAgICAgPHNldHRpbmcgaWQ9ImxhdGVuY3kiIHZhbHVlPSIwIiAvPgogICAgICAgPC9jb25maWd1cmF0aW9uPgogICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0iaXNhIiAvPgogICAgICAgPC9jYXBhYmlsaXRpZXM+CiAgICAgIDwvbm9kZT4KICAgICAgPG5vZGUgaWQ9ImlkZSIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9InN0b3JhZ2UiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDEuMSI+CiAgICAgICA8ZGVzY3JpcHRpb24+SURFIGludGVyZmFjZTwvZGVzY3JpcHRpb24+CiAgICAgICA8cHJvZHVjdD44MjM3MVNCIFBJSVgzIElERSBbTmF0b21hL1RyaXRvbiBJSV08L3Byb2R1Y3Q+CiAgICAgICA8dmVuZG9yPkludGVsIENvcnBvcmF0aW9uPC92ZW5kb3I+CiAgICAgICA8cGh5c2lkPjEuMTwvcGh5c2lkPgogICAgICAgPGJ1c2luZm8+cGNpQDAwMDA6MDA6MDEuMTwvYnVzaW5mbz4KICAgICAgIDx2ZXJzaW9uPjAwPC92ZXJzaW9uPgogICAgICAgPHdpZHRoIHVuaXRzPSJiaXRzIj4zMjwvd2lkdGg+CiAgICAgICA8Y2xvY2sgdW5pdHM9Ikh6Ij4zMzAwMDAwMDwvY2xvY2s+CiAgICAgICA8Y29uZmlndXJhdGlvbj4KICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVyIiB2YWx1ZT0iYXRhX3BpaXgiIC8+CiAgICAgICAgPHNldHRpbmcgaWQ9ImxhdGVuY3kiIHZhbHVlPSIwIiAvPgogICAgICAgPC9jb25maWd1cmF0aW9uPgogICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0iaWRlIiAvPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJidXNfbWFzdGVyIiA+YnVzIG1hc3RlcmluZzwvY2FwYWJpbGl0eT4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaXJxIiB2YWx1ZT0iMCIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaW9wb3J0IiB2YWx1ZT0iMWYwKHNpemU9OCkiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlvcG9ydCIgdmFsdWU9IjNmNiIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaW9wb3J0IiB2YWx1ZT0iMTcwKHNpemU9OCkiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlvcG9ydCIgdmFsdWU9IjM3NiIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaW9wb3J0IiB2YWx1ZT0iYzE4MChzaXplPTE2KSIgLz4KICAgICAgIDwvcmVzb3VyY2VzPgogICAgICA8L25vZGU+CiAgICAgIDxub2RlIGlkPSJicmlkZ2UiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJicmlkZ2UiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDEuMyI+CiAgICAgICA8ZGVzY3JpcHRpb24+QnJpZGdlPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PjgyMzcxQUIvRUIvTUIgUElJWDQgQUNQSTwvcHJvZHVjdD4KICAgICAgIDx2ZW5kb3I+SW50ZWwgQ29ycG9yYXRpb248L3ZlbmRvcj4KICAgICAgIDxwaHlzaWQ+MS4zPC9waHlzaWQ+CiAgICAgICA8YnVzaW5mbz5wY2lAMDAwMDowMDowMS4zPC9idXNpbmZvPgogICAgICAgPHZlcnNpb24+MDM8L3ZlcnNpb24+CiAgICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjMyPC93aWR0aD4KICAgICAgIDxjbG9jayB1bml0cz0iSHoiPjMzMDAwMDAwPC9jbG9jaz4KICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXIiIHZhbHVlPSJwaWl4NF9zbWJ1cyIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibGF0ZW5jeSIgdmFsdWU9IjAiIC8+CiAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJicmlkZ2UiIC8+CiAgICAgICA8L2NhcGFiaWxpdGllcz4KICAgICAgIDxyZXNvdXJjZXM+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlycSIgdmFsdWU9IjkiIC8+CiAgICAgICA8L3Jlc291cmNlcz4KICAgICAgPC9ub2RlPgogICAgICA8bm9kZSBpZD0iZGlzcGxheSIgY2xhc3M9ImRpc3BsYXkiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDIuMCI+CiAgICAgICA8ZGVzY3JpcHRpb24+VkdBIGNvbXBhdGlibGUgY29udHJvbGxlcjwvZGVzY3JpcHRpb24+CiAgICAgICA8cHJvZHVjdD5TVkdBIElJIEFkYXB0ZXI8L3Byb2R1Y3Q+CiAgICAgICA8dmVuZG9yPlZNd2FyZTwvdmVuZG9yPgogICAgICAgPHBoeXNpZD4yPC9waHlzaWQ+CiAgICAgICA8YnVzaW5mbz5wY2lAMDAwMDowMDowMi4wPC9idXNpbmZvPgogICAgICAgPHZlcnNpb24+MDA8L3ZlcnNpb24+CiAgICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjMyPC93aWR0aD4KICAgICAgIDxjbG9jayB1bml0cz0iSHoiPjMzMDAwMDAwPC9jbG9jaz4KICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgIDxzZXR0aW5nIGlkPSJsYXRlbmN5IiB2YWx1ZT0iNjQiIC8+CiAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJ2Z2FfY29udHJvbGxlciIgLz4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaW9wb3J0IiB2YWx1ZT0iYzE5MChzaXplPTE2KSIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0ibWVtb3J5IiB2YWx1ZT0iZmQwMDAwMDAtZmRmZmZmZmYiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9Im1lbW9yeSIgdmFsdWU9ImZlMDAwMDAwLWZlMDBmZmZmIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJtZW1vcnkiIHZhbHVlPSJjMDAwMC1kZmZmZiIgLz4KICAgICAgIDwvcmVzb3VyY2VzPgogICAgICA8L25vZGU+CiAgICAgIDxub2RlIGlkPSJuZXR3b3JrOjAiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJuZXR3b3JrIiBoYW5kbGU9IlBDSTowMDAwOjAwOjAzLjAiPgogICAgICAgPGRlc2NyaXB0aW9uPkV0aGVybmV0IGludGVyZmFjZTwvZGVzY3JpcHRpb24+CiAgICAgICA8cHJvZHVjdD5WaXJ0aW8gbmV0d29yayBkZXZpY2U8L3Byb2R1Y3Q+CiAgICAgICA8dmVuZG9yPlJlZCBIYXQsIEluYzwvdmVuZG9yPgogICAgICAgPHBoeXNpZD4zPC9waHlzaWQ+CiAgICAgICA8YnVzaW5mbz5wY2lAMDAwMDowMDowMy4wPC9idXNpbmZvPgogICAgICAgPGxvZ2ljYWxuYW1lPmVuczM8L2xvZ2ljYWxuYW1lPgogICAgICAgPHZlcnNpb24+MDA8L3ZlcnNpb24+CiAgICAgICA8c2VyaWFsPjUyOjU0OjAwOmYwOjEzOjk3PC9zZXJpYWw+CiAgICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjY0PC93aWR0aD4KICAgICAgIDxjbG9jayB1bml0cz0iSHoiPjMzMDAwMDAwPC9jbG9jaz4KICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgIDxzZXR0aW5nIGlkPSJhdXRvbmVnb3RpYXRpb24iIHZhbHVlPSJvZmYiIC8+CiAgICAgICAgPHNldHRpbmcgaWQ9ImJyb2FkY2FzdCIgdmFsdWU9InllcyIgLz4KICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVyIiB2YWx1ZT0idmlydGlvX25ldCIgLz4KICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVydmVyc2lvbiIgdmFsdWU9IjEuMC4wIiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJpcCIgdmFsdWU9IjE3Mi4yMC4wLjQ2IiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJsYXRlbmN5IiB2YWx1ZT0iMCIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibGluayIgdmFsdWU9InllcyIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibXVsdGljYXN0IiB2YWx1ZT0ieWVzIiAvPgogICAgICAgPC9jb25maWd1cmF0aW9uPgogICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0ibXNpeCIgPk1TSS1YPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJidXNfbWFzdGVyIiA+YnVzIG1hc3RlcmluZzwvY2FwYWJpbGl0eT4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0iY2FwX2xpc3QiID5QQ0kgY2FwYWJpbGl0aWVzIGxpc3Rpbmc8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9InJvbSIgPmV4dGVuc2lvbiBST008L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImV0aGVybmV0IiAvPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJwaHlzaWNhbCIgPlBoeXNpY2FsIGludGVyZmFjZTwvY2FwYWJpbGl0eT4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaXJxIiB2YWx1ZT0iMTEiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlvcG9ydCIgdmFsdWU9ImMwMDAoc2l6ZT02NCkiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9Im1lbW9yeSIgdmFsdWU9ImZlYmQ0MDAwLWZlYmQ0ZmZmIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJtZW1vcnkiIHZhbHVlPSJmZTAxMDAwMC1mZTAxM2ZmZiIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0ibWVtb3J5IiB2YWx1ZT0iZmViNDAwMDAtZmViN2ZmZmYiIC8+CiAgICAgICA8L3Jlc291cmNlcz4KICAgICAgPC9ub2RlPgogICAgICA8bm9kZSBpZD0ibXVsdGltZWRpYSIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9Im11bHRpbWVkaWEiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDQuMCI+CiAgICAgICA8ZGVzY3JpcHRpb24+QXVkaW8gZGV2aWNlPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PjgyODAxRkIvRkJNL0ZSL0ZXL0ZSVyAoSUNINiBGYW1pbHkpIEhpZ2ggRGVmaW5pdGlvbiBBdWRpbyBDb250cm9sbGVyPC9wcm9kdWN0PgogICAgICAgPHZlbmRvcj5JbnRlbCBDb3Jwb3JhdGlvbjwvdmVuZG9yPgogICAgICAgPHBoeXNpZD40PC9waHlzaWQ+CiAgICAgICA8YnVzaW5mbz5wY2lAMDAwMDowMDowNC4wPC9idXNpbmZvPgogICAgICAgPHZlcnNpb24+MDE8L3ZlcnNpb24+CiAgICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjMyPC93aWR0aD4KICAgICAgIDxjbG9jayB1bml0cz0iSHoiPjMzMDAwMDAwPC9jbG9jaz4KICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXIiIHZhbHVlPSJzbmRfaGRhX2ludGVsIiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJsYXRlbmN5IiB2YWx1ZT0iMCIgLz4KICAgICAgIDwvY29uZmlndXJhdGlvbj4KICAgICAgIDxjYXBhYmlsaXRpZXM+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9Im1zaSIgPk1lc3NhZ2UgU2lnbmFsbGVkIEludGVycnVwdHM8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJ1c19tYXN0ZXIiID5idXMgbWFzdGVyaW5nPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJjYXBfbGlzdCIgPlBDSSBjYXBhYmlsaXRpZXMgbGlzdGluZzwvY2FwYWJpbGl0eT4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaXJxIiB2YWx1ZT0iMzQiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9Im1lbW9yeSIgdmFsdWU9ImZlYmQwMDAwLWZlYmQzZmZmIiAvPgogICAgICAgPC9yZXNvdXJjZXM+CiAgICAgIDwvbm9kZT4KICAgICAgPG5vZGUgaWQ9InVzYjowIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0iYnVzIiBoYW5kbGU9IlBDSTowMDAwOjAwOjA1LjAiPgogICAgICAgPGRlc2NyaXB0aW9uPlVTQiBjb250cm9sbGVyPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PjgyODAxSSAoSUNIOSBGYW1pbHkpIFVTQiBVSENJIENvbnRyb2xsZXIgIzE8L3Byb2R1Y3Q+CiAgICAgICA8dmVuZG9yPkludGVsIENvcnBvcmF0aW9uPC92ZW5kb3I+CiAgICAgICA8cGh5c2lkPjU8L3BoeXNpZD4KICAgICAgIDxidXNpbmZvPnBjaUAwMDAwOjAwOjA1LjA8L2J1c2luZm8+CiAgICAgICA8dmVyc2lvbj4wMzwvdmVyc2lvbj4KICAgICAgIDx3aWR0aCB1bml0cz0iYml0cyI+MzI8L3dpZHRoPgogICAgICAgPGNsb2NrIHVuaXRzPSJIeiI+MzMwMDAwMDA8L2Nsb2NrPgogICAgICAgPGNvbmZpZ3VyYXRpb24+CiAgICAgICAgPHNldHRpbmcgaWQ9ImRyaXZlciIgdmFsdWU9InVoY2lfaGNkIiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJsYXRlbmN5IiB2YWx1ZT0iMCIgLz4KICAgICAgIDwvY29uZmlndXJhdGlvbj4KICAgICAgIDxjYXBhYmlsaXRpZXM+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9InVoY2kiID5Vbml2ZXJzYWwgSG9zdCBDb250cm9sbGVyIEludGVyZmFjZSAoVVNCMSk8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJ1c19tYXN0ZXIiID5idXMgbWFzdGVyaW5nPC9jYXBhYmlsaXR5PgogICAgICAgPC9jYXBhYmlsaXRpZXM+CiAgICAgICA8cmVzb3VyY2VzPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJpcnEiIHZhbHVlPSIxMCIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaW9wb3J0IiB2YWx1ZT0iYzEwMChzaXplPTMyKSIgLz4KICAgICAgIDwvcmVzb3VyY2VzPgogICAgICAgIDxub2RlIGlkPSJ1c2Job3N0IiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0iYnVzIiBoYW5kbGU9IlVTQjoyOjEiPgogICAgICAgICA8cHJvZHVjdD5VSENJIEhvc3QgQ29udHJvbGxlcjwvcHJvZHVjdD4KICAgICAgICAgPHZlbmRvcj5MaW51eCA0LjEwLjAtMzItZ2VuZXJpYyB1aGNpX2hjZDwvdmVuZG9yPgogICAgICAgICA8cGh5c2lkPjE8L3BoeXNpZD4KICAgICAgICAgPGJ1c2luZm8+dXNiQDI8L2J1c2luZm8+CiAgICAgICAgIDxsb2dpY2FsbmFtZT51c2IyPC9sb2dpY2FsbmFtZT4KICAgICAgICAgPHZlcnNpb24+NC4xMDwvdmVyc2lvbj4KICAgICAgICAgPGNvbmZpZ3VyYXRpb24+CiAgICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVyIiB2YWx1ZT0iaHViIiAvPgogICAgICAgICAgPHNldHRpbmcgaWQ9InNsb3RzIiB2YWx1ZT0iMiIgLz4KICAgICAgICAgIDxzZXR0aW5nIGlkPSJzcGVlZCIgdmFsdWU9IjEyTWJpdC9zIiAvPgogICAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICAgIDxjYXBhYmlsaXRpZXM+CiAgICAgICAgICA8Y2FwYWJpbGl0eSBpZD0idXNiLTEuMTAiID5VU0IgMS4xPC9jYXBhYmlsaXR5PgogICAgICAgICA8L2NhcGFiaWxpdGllcz4KICAgICAgICA8L25vZGU+CiAgICAgIDwvbm9kZT4KICAgICAgPG5vZGUgaWQ9InVzYjoxIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0iYnVzIiBoYW5kbGU9IlBDSTowMDAwOjAwOjA1LjEiPgogICAgICAgPGRlc2NyaXB0aW9uPlVTQiBjb250cm9sbGVyPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PjgyODAxSSAoSUNIOSBGYW1pbHkpIFVTQiBVSENJIENvbnRyb2xsZXIgIzI8L3Byb2R1Y3Q+CiAgICAgICA8dmVuZG9yPkludGVsIENvcnBvcmF0aW9uPC92ZW5kb3I+CiAgICAgICA8cGh5c2lkPjUuMTwvcGh5c2lkPgogICAgICAgPGJ1c2luZm8+cGNpQDAwMDA6MDA6MDUuMTwvYnVzaW5mbz4KICAgICAgIDx2ZXJzaW9uPjAzPC92ZXJzaW9uPgogICAgICAgPHdpZHRoIHVuaXRzPSJiaXRzIj4zMjwvd2lkdGg+CiAgICAgICA8Y2xvY2sgdW5pdHM9Ikh6Ij4zMzAwMDAwMDwvY2xvY2s+CiAgICAgICA8Y29uZmlndXJhdGlvbj4KICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVyIiB2YWx1ZT0idWhjaV9oY2QiIC8+CiAgICAgICAgPHNldHRpbmcgaWQ9ImxhdGVuY3kiIHZhbHVlPSIwIiAvPgogICAgICAgPC9jb25maWd1cmF0aW9uPgogICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0idWhjaSIgPlVuaXZlcnNhbCBIb3N0IENvbnRyb2xsZXIgSW50ZXJmYWNlIChVU0IxKTwvY2FwYWJpbGl0eT4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0iYnVzX21hc3RlciIgPmJ1cyBtYXN0ZXJpbmc8L2NhcGFiaWxpdHk+CiAgICAgICA8L2NhcGFiaWxpdGllcz4KICAgICAgIDxyZXNvdXJjZXM+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlycSIgdmFsdWU9IjExIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJpb3BvcnQiIHZhbHVlPSJjMTIwKHNpemU9MzIpIiAvPgogICAgICAgPC9yZXNvdXJjZXM+CiAgICAgICAgPG5vZGUgaWQ9InVzYmhvc3QiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJidXMiIGhhbmRsZT0iVVNCOjM6MSI+CiAgICAgICAgIDxwcm9kdWN0PlVIQ0kgSG9zdCBDb250cm9sbGVyPC9wcm9kdWN0PgogICAgICAgICA8dmVuZG9yPkxpbnV4IDQuMTAuMC0zMi1nZW5lcmljIHVoY2lfaGNkPC92ZW5kb3I+CiAgICAgICAgIDxwaHlzaWQ+MTwvcGh5c2lkPgogICAgICAgICA8YnVzaW5mbz51c2JAMzwvYnVzaW5mbz4KICAgICAgICAgPGxvZ2ljYWxuYW1lPnVzYjM8L2xvZ2ljYWxuYW1lPgogICAgICAgICA8dmVyc2lvbj40LjEwPC92ZXJzaW9uPgogICAgICAgICA8Y29uZmlndXJhdGlvbj4KICAgICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXIiIHZhbHVlPSJodWIiIC8+CiAgICAgICAgICA8c2V0dGluZyBpZD0ic2xvdHMiIHZhbHVlPSIyIiAvPgogICAgICAgICAgPHNldHRpbmcgaWQ9InNwZWVkIiB2YWx1ZT0iMTJNYml0L3MiIC8+CiAgICAgICAgIDwvY29uZmlndXJhdGlvbj4KICAgICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICAgIDxjYXBhYmlsaXR5IGlkPSJ1c2ItMS4xMCIgPlVTQiAxLjE8L2NhcGFiaWxpdHk+CiAgICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgIDwvbm9kZT4KICAgICAgPC9ub2RlPgogICAgICA8bm9kZSBpZD0idXNiOjIiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJidXMiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDUuMiI+CiAgICAgICA8ZGVzY3JpcHRpb24+VVNCIGNvbnRyb2xsZXI8L2Rlc2NyaXB0aW9uPgogICAgICAgPHByb2R1Y3Q+ODI4MDFJIChJQ0g5IEZhbWlseSkgVVNCIFVIQ0kgQ29udHJvbGxlciAjMzwvcHJvZHVjdD4KICAgICAgIDx2ZW5kb3I+SW50ZWwgQ29ycG9yYXRpb248L3ZlbmRvcj4KICAgICAgIDxwaHlzaWQ+NS4yPC9waHlzaWQ+CiAgICAgICA8YnVzaW5mbz5wY2lAMDAwMDowMDowNS4yPC9idXNpbmZvPgogICAgICAgPHZlcnNpb24+MDM8L3ZlcnNpb24+CiAgICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjMyPC93aWR0aD4KICAgICAgIDxjbG9jayB1bml0cz0iSHoiPjMzMDAwMDAwPC9jbG9jaz4KICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXIiIHZhbHVlPSJ1aGNpX2hjZCIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibGF0ZW5jeSIgdmFsdWU9IjAiIC8+CiAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJ1aGNpIiA+VW5pdmVyc2FsIEhvc3QgQ29udHJvbGxlciBJbnRlcmZhY2UgKFVTQjEpPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJidXNfbWFzdGVyIiA+YnVzIG1hc3RlcmluZzwvY2FwYWJpbGl0eT4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaXJxIiB2YWx1ZT0iMTEiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlvcG9ydCIgdmFsdWU9ImMxNDAoc2l6ZT0zMikiIC8+CiAgICAgICA8L3Jlc291cmNlcz4KICAgICAgICA8bm9kZSBpZD0idXNiaG9zdCIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9ImJ1cyIgaGFuZGxlPSJVU0I6NDoxIj4KICAgICAgICAgPHByb2R1Y3Q+VUhDSSBIb3N0IENvbnRyb2xsZXI8L3Byb2R1Y3Q+CiAgICAgICAgIDx2ZW5kb3I+TGludXggNC4xMC4wLTMyLWdlbmVyaWMgdWhjaV9oY2Q8L3ZlbmRvcj4KICAgICAgICAgPHBoeXNpZD4xPC9waHlzaWQ+CiAgICAgICAgIDxidXNpbmZvPnVzYkA0PC9idXNpbmZvPgogICAgICAgICA8bG9naWNhbG5hbWU+dXNiNDwvbG9naWNhbG5hbWU+CiAgICAgICAgIDx2ZXJzaW9uPjQuMTA8L3ZlcnNpb24+CiAgICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgICAgPHNldHRpbmcgaWQ9ImRyaXZlciIgdmFsdWU9Imh1YiIgLz4KICAgICAgICAgIDxzZXR0aW5nIGlkPSJzbG90cyIgdmFsdWU9IjIiIC8+CiAgICAgICAgICA8c2V0dGluZyBpZD0ic3BlZWQiIHZhbHVlPSIxMk1iaXQvcyIgLz4KICAgICAgICAgPC9jb25maWd1cmF0aW9uPgogICAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgICAgPGNhcGFiaWxpdHkgaWQ9InVzYi0xLjEwIiA+VVNCIDEuMTwvY2FwYWJpbGl0eT4KICAgICAgICAgPC9jYXBhYmlsaXRpZXM+CiAgICAgICAgPC9ub2RlPgogICAgICA8L25vZGU+CiAgICAgIDxub2RlIGlkPSJ1c2I6MyIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9ImJ1cyIgaGFuZGxlPSJQQ0k6MDAwMDowMDowNS43Ij4KICAgICAgIDxkZXNjcmlwdGlvbj5VU0IgY29udHJvbGxlcjwvZGVzY3JpcHRpb24+CiAgICAgICA8cHJvZHVjdD44MjgwMUkgKElDSDkgRmFtaWx5KSBVU0IyIEVIQ0kgQ29udHJvbGxlciAjMTwvcHJvZHVjdD4KICAgICAgIDx2ZW5kb3I+SW50ZWwgQ29ycG9yYXRpb248L3ZlbmRvcj4KICAgICAgIDxwaHlzaWQ+NS43PC9waHlzaWQ+CiAgICAgICA8YnVzaW5mbz5wY2lAMDAwMDowMDowNS43PC9idXNpbmZvPgogICAgICAgPHZlcnNpb24+MDM8L3ZlcnNpb24+CiAgICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjMyPC93aWR0aD4KICAgICAgIDxjbG9jayB1bml0cz0iSHoiPjMzMDAwMDAwPC9jbG9jaz4KICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXIiIHZhbHVlPSJlaGNpLXBjaSIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibGF0ZW5jeSIgdmFsdWU9IjAiIC8+CiAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJlaGNpIiA+RW5oYW5jZWQgSG9zdCBDb250cm9sbGVyIEludGVyZmFjZSAoVVNCMik8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJ1c19tYXN0ZXIiID5idXMgbWFzdGVyaW5nPC9jYXBhYmlsaXR5PgogICAgICAgPC9jYXBhYmlsaXRpZXM+CiAgICAgICA8cmVzb3VyY2VzPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJpcnEiIHZhbHVlPSIxMCIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0ibWVtb3J5IiB2YWx1ZT0iZmViZDUwMDAtZmViZDVmZmYiIC8+CiAgICAgICA8L3Jlc291cmNlcz4KICAgICAgICA8bm9kZSBpZD0idXNiaG9zdCIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9ImJ1cyIgaGFuZGxlPSJVU0I6MToxIj4KICAgICAgICAgPHByb2R1Y3Q+RUhDSSBIb3N0IENvbnRyb2xsZXI8L3Byb2R1Y3Q+CiAgICAgICAgIDx2ZW5kb3I+TGludXggNC4xMC4wLTMyLWdlbmVyaWMgZWhjaV9oY2Q8L3ZlbmRvcj4KICAgICAgICAgPHBoeXNpZD4xPC9waHlzaWQ+CiAgICAgICAgIDxidXNpbmZvPnVzYkAxPC9idXNpbmZvPgogICAgICAgICA8bG9naWNhbG5hbWU+dXNiMTwvbG9naWNhbG5hbWU+CiAgICAgICAgIDx2ZXJzaW9uPjQuMTA8L3ZlcnNpb24+CiAgICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgICAgPHNldHRpbmcgaWQ9ImRyaXZlciIgdmFsdWU9Imh1YiIgLz4KICAgICAgICAgIDxzZXR0aW5nIGlkPSJzbG90cyIgdmFsdWU9IjYiIC8+CiAgICAgICAgICA8c2V0dGluZyBpZD0ic3BlZWQiIHZhbHVlPSI0ODBNYml0L3MiIC8+CiAgICAgICAgIDwvY29uZmlndXJhdGlvbj4KICAgICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICAgIDxjYXBhYmlsaXR5IGlkPSJ1c2ItMi4wMCIgPlVTQiAyLjA8L2NhcGFiaWxpdHk+CiAgICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgIDwvbm9kZT4KICAgICAgPC9ub2RlPgogICAgICA8bm9kZSBpZD0iY29tbXVuaWNhdGlvbiIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9ImNvbW11bmljYXRpb24iIGhhbmRsZT0iUENJOjAwMDA6MDA6MDYuMCI+CiAgICAgICA8ZGVzY3JpcHRpb24+Q29tbXVuaWNhdGlvbiBjb250cm9sbGVyPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PlZpcnRpbyBjb25zb2xlPC9wcm9kdWN0PgogICAgICAgPHZlbmRvcj5SZWQgSGF0LCBJbmM8L3ZlbmRvcj4KICAgICAgIDxwaHlzaWQ+NjwvcGh5c2lkPgogICAgICAgPGJ1c2luZm8+cGNpQDAwMDA6MDA6MDYuMDwvYnVzaW5mbz4KICAgICAgIDx2ZXJzaW9uPjAwPC92ZXJzaW9uPgogICAgICAgPHdpZHRoIHVuaXRzPSJiaXRzIj42NDwvd2lkdGg+CiAgICAgICA8Y2xvY2sgdW5pdHM9Ikh6Ij4zMzAwMDAwMDwvY2xvY2s+CiAgICAgICA8Y29uZmlndXJhdGlvbj4KICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVyIiB2YWx1ZT0idmlydGlvLXBjaSIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibGF0ZW5jeSIgdmFsdWU9IjAiIC8+CiAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJtc2l4IiA+TVNJLVg8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJ1c19tYXN0ZXIiID5idXMgbWFzdGVyaW5nPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJjYXBfbGlzdCIgPlBDSSBjYXBhYmlsaXRpZXMgbGlzdGluZzwvY2FwYWJpbGl0eT4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaXJxIiB2YWx1ZT0iMTEiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlvcG9ydCIgdmFsdWU9ImMwNDAoc2l6ZT02NCkiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9Im1lbW9yeSIgdmFsdWU9ImZlYmQ2MDAwLWZlYmQ2ZmZmIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJtZW1vcnkiIHZhbHVlPSJmZTAxNDAwMC1mZTAxN2ZmZiIgLz4KICAgICAgIDwvcmVzb3VyY2VzPgogICAgICA8L25vZGU+CiAgICAgIDxub2RlIGlkPSJzY3NpIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0ic3RvcmFnZSIgaGFuZGxlPSJQQ0k6MDAwMDowMDowNy4wIj4KICAgICAgIDxkZXNjcmlwdGlvbj5TQ1NJIHN0b3JhZ2UgY29udHJvbGxlcjwvZGVzY3JpcHRpb24+CiAgICAgICA8cHJvZHVjdD5WaXJ0aW8gYmxvY2sgZGV2aWNlPC9wcm9kdWN0PgogICAgICAgPHZlbmRvcj5SZWQgSGF0LCBJbmM8L3ZlbmRvcj4KICAgICAgIDxwaHlzaWQ+NzwvcGh5c2lkPgogICAgICAgPGJ1c2luZm8+cGNpQDAwMDA6MDA6MDcuMDwvYnVzaW5mbz4KICAgICAgIDx2ZXJzaW9uPjAwPC92ZXJzaW9uPgogICAgICAgPHdpZHRoIHVuaXRzPSJiaXRzIj42NDwvd2lkdGg+CiAgICAgICA8Y2xvY2sgdW5pdHM9Ikh6Ij4zMzAwMDAwMDwvY2xvY2s+CiAgICAgICA8Y29uZmlndXJhdGlvbj4KICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVyIiB2YWx1ZT0idmlydGlvLXBjaSIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibGF0ZW5jeSIgdmFsdWU9IjAiIC8+CiAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJzY3NpIiAvPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJtc2l4IiA+TVNJLVg8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJ1c19tYXN0ZXIiID5idXMgbWFzdGVyaW5nPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJjYXBfbGlzdCIgPlBDSSBjYXBhYmlsaXRpZXMgbGlzdGluZzwvY2FwYWJpbGl0eT4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaXJxIiB2YWx1ZT0iMTEiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlvcG9ydCIgdmFsdWU9ImMwODAoc2l6ZT02NCkiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9Im1lbW9yeSIgdmFsdWU9ImZlYmQ3MDAwLWZlYmQ3ZmZmIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJtZW1vcnkiIHZhbHVlPSJmZTAxODAwMC1mZTAxYmZmZiIgLz4KICAgICAgIDwvcmVzb3VyY2VzPgogICAgICA8L25vZGU+CiAgICAgIDxub2RlIGlkPSJnZW5lcmljIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0iZ2VuZXJpYyIgaGFuZGxlPSJQQ0k6MDAwMDowMDowOC4wIj4KICAgICAgIDxkZXNjcmlwdGlvbj5VbmNsYXNzaWZpZWQgZGV2aWNlPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PlZpcnRpbyBtZW1vcnkgYmFsbG9vbjwvcHJvZHVjdD4KICAgICAgIDx2ZW5kb3I+UmVkIEhhdCwgSW5jPC92ZW5kb3I+CiAgICAgICA8cGh5c2lkPjg8L3BoeXNpZD4KICAgICAgIDxidXNpbmZvPnBjaUAwMDAwOjAwOjA4LjA8L2J1c2luZm8+CiAgICAgICA8dmVyc2lvbj4wMDwvdmVyc2lvbj4KICAgICAgIDx3aWR0aCB1bml0cz0iYml0cyI+NjQ8L3dpZHRoPgogICAgICAgPGNsb2NrIHVuaXRzPSJIeiI+MzMwMDAwMDA8L2Nsb2NrPgogICAgICAgPGNvbmZpZ3VyYXRpb24+CiAgICAgICAgPHNldHRpbmcgaWQ9ImRyaXZlciIgdmFsdWU9InZpcnRpby1wY2kiIC8+CiAgICAgICAgPHNldHRpbmcgaWQ9ImxhdGVuY3kiIHZhbHVlPSIwIiAvPgogICAgICAgPC9jb25maWd1cmF0aW9uPgogICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0iYnVzX21hc3RlciIgPmJ1cyBtYXN0ZXJpbmc8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImNhcF9saXN0IiA+UENJIGNhcGFiaWxpdGllcyBsaXN0aW5nPC9jYXBhYmlsaXR5PgogICAgICAgPC9jYXBhYmlsaXRpZXM+CiAgICAgICA8cmVzb3VyY2VzPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJpcnEiIHZhbHVlPSIxMCIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaW9wb3J0IiB2YWx1ZT0iYzE2MChzaXplPTMyKSIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0ibWVtb3J5IiB2YWx1ZT0iZmUwMWMwMDAtZmUwMWZmZmYiIC8+CiAgICAgICA8L3Jlc291cmNlcz4KICAgICAgPC9ub2RlPgogICAgICA8bm9kZSBpZD0ibmV0d29yazoxIiBkaXNhYmxlZD0idHJ1ZSIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9Im5ldHdvcmsiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDkuMCI+CiAgICAgICA8ZGVzY3JpcHRpb24+RXRoZXJuZXQgaW50ZXJmYWNlPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PlZpcnRpbyBuZXR3b3JrIGRldmljZTwvcHJvZHVjdD4KICAgICAgIDx2ZW5kb3I+UmVkIEhhdCwgSW5jPC92ZW5kb3I+CiAgICAgICA8cGh5c2lkPjk8L3BoeXNpZD4KICAgICAgIDxidXNpbmZvPnBjaUAwMDAwOjAwOjA5LjA8L2J1c2luZm8+CiAgICAgICA8bG9naWNhbG5hbWU+ZW5zOTwvbG9naWNhbG5hbWU+CiAgICAgICA8dmVyc2lvbj4wMDwvdmVyc2lvbj4KICAgICAgIDxzZXJpYWw+NTI6NTQ6MDA6ZTI6ZjE6ZDU8L3NlcmlhbD4KICAgICAgIDx3aWR0aCB1bml0cz0iYml0cyI+NjQ8L3dpZHRoPgogICAgICAgPGNsb2NrIHVuaXRzPSJIeiI+MzMwMDAwMDA8L2Nsb2NrPgogICAgICAgPGNvbmZpZ3VyYXRpb24+CiAgICAgICAgPHNldHRpbmcgaWQ9ImF1dG9uZWdvdGlhdGlvbiIgdmFsdWU9Im9mZiIgLz4KICAgICAgICA8c2V0dGluZyBpZD0iYnJvYWRjYXN0IiB2YWx1ZT0ieWVzIiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXIiIHZhbHVlPSJ2aXJ0aW9fbmV0IiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXJ2ZXJzaW9uIiB2YWx1ZT0iMS4wLjAiIC8+CiAgICAgICAgPHNldHRpbmcgaWQ9ImxhdGVuY3kiIHZhbHVlPSIwIiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJsaW5rIiB2YWx1ZT0ibm8iIC8+CiAgICAgICAgPHNldHRpbmcgaWQ9Im11bHRpY2FzdCIgdmFsdWU9InllcyIgLz4KICAgICAgIDwvY29uZmlndXJhdGlvbj4KICAgICAgIDxjYXBhYmlsaXRpZXM+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9Im1zaXgiID5NU0ktWDwvY2FwYWJpbGl0eT4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0iYnVzX21hc3RlciIgPmJ1cyBtYXN0ZXJpbmc8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImNhcF9saXN0IiA+UENJIGNhcGFiaWxpdGllcyBsaXN0aW5nPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJyb20iID5leHRlbnNpb24gUk9NPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJldGhlcm5ldCIgLz4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0icGh5c2ljYWwiID5QaHlzaWNhbCBpbnRlcmZhY2U8L2NhcGFiaWxpdHk+CiAgICAgICA8L2NhcGFiaWxpdGllcz4KICAgICAgIDxyZXNvdXJjZXM+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlycSIgdmFsdWU9IjEwIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJpb3BvcnQiIHZhbHVlPSJjMGMwKHNpemU9NjQpIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJtZW1vcnkiIHZhbHVlPSJmZWJkODAwMC1mZWJkOGZmZiIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0ibWVtb3J5IiB2YWx1ZT0iZmUwMjAwMDAtZmUwMjNmZmYiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9Im1lbW9yeSIgdmFsdWU9ImZlYjgwMDAwLWZlYmJmZmZmIiAvPgogICAgICAgPC9yZXNvdXJjZXM+CiAgICAgIDwvbm9kZT4KICAgIDwvbm9kZT4KICA8L25vZGU+Cjwvbm9kZT4KPC9saXN0Pgo=		""	\N	1	\N	PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJ5ZXMiID8+CjwhLS0gZ2VuZXJhdGVkIGJ5IGxzaHctQi4wMi4xNyAtLT4KPCEtLSBHQ0MgNS4zLjEgMjAxNjA0MTMgLS0+CjwhLS0gTGludXggNC4xMC4wLTMyLWdlbmVyaWMgIzM2fjE2LjA0LjEtVWJ1bnR1IFNNUCBXZWQgQXVnIDkgMDk6MTk6MDIgVVRDIDIwMTcgeDg2XzY0IC0tPgo8IS0tIEdOVSBsaWJjIDIgKGdsaWJjIDIuMjMpIC0tPgo8bGlzdD4KPG5vZGUgaWQ9Im9zLW5vZGUyIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0ic3lzdGVtIiBoYW5kbGU9IkRNSTowMTAwIj4KIDxkZXNjcmlwdGlvbj5Db21wdXRlcjwvZGVzY3JpcHRpb24+CiA8cHJvZHVjdD5TdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5Nik8L3Byb2R1Y3Q+CiA8dmVuZG9yPlFFTVU8L3ZlbmRvcj4KIDx2ZXJzaW9uPnBjLWk0NDBmeC0yLjk8L3ZlcnNpb24+CiA8d2lkdGggdW5pdHM9ImJpdHMiPjY0PC93aWR0aD4KIDxjb25maWd1cmF0aW9uPgogIDxzZXR0aW5nIGlkPSJib290IiB2YWx1ZT0ibm9ybWFsIiAvPgogIDxzZXR0aW5nIGlkPSJ1dWlkIiB2YWx1ZT0iMkFFRDlEODMtNzUxMi03RjRELUJFRDQtNUU0QTUxMzFBMDExIiAvPgogPC9jb25maWd1cmF0aW9uPgogPGNhcGFiaWxpdGllcz4KICA8Y2FwYWJpbGl0eSBpZD0ic21iaW9zLTIuOCIgPlNNQklPUyB2ZXJzaW9uIDIuODwvY2FwYWJpbGl0eT4KICA8Y2FwYWJpbGl0eSBpZD0iZG1pLTIuOCIgPkRNSSB2ZXJzaW9uIDIuODwvY2FwYWJpbGl0eT4KICA8Y2FwYWJpbGl0eSBpZD0idnN5c2NhbGwzMiIgPjMyLWJpdCBwcm9jZXNzZXM8L2NhcGFiaWxpdHk+CiA8L2NhcGFiaWxpdGllcz4KICA8bm9kZSBpZD0iY29yZSIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9ImJ1cyIgaGFuZGxlPSIiPgogICA8ZGVzY3JpcHRpb24+TW90aGVyYm9hcmQ8L2Rlc2NyaXB0aW9uPgogICA8cGh5c2lkPjA8L3BoeXNpZD4KICAgIDxub2RlIGlkPSJmaXJtd2FyZSIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9Im1lbW9yeSIgaGFuZGxlPSIiPgogICAgIDxkZXNjcmlwdGlvbj5CSU9TPC9kZXNjcmlwdGlvbj4KICAgICA8dmVuZG9yPlNlYUJJT1M8L3ZlbmRvcj4KICAgICA8cGh5c2lkPjA8L3BoeXNpZD4KICAgICA8dmVyc2lvbj5yZWwtMS4xMC4yLTAtZzVmNGM3YjEtcHJlYnVpbHQucWVtdS1wcm9qZWN0Lm9yZzwvdmVyc2lvbj4KICAgICA8ZGF0ZT4wNC8wMS8yMDE0PC9kYXRlPgogICAgIDxzaXplIHVuaXRzPSJieXRlcyI+OTgzMDQ8L3NpemU+CiAgICA8L25vZGU+CiAgICA8bm9kZSBpZD0iY3B1OjAiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJwcm9jZXNzb3IiIGhhbmRsZT0iRE1JOjA0MDAiPgogICAgIDxkZXNjcmlwdGlvbj5DUFU8L2Rlc2NyaXB0aW9uPgogICAgIDxwcm9kdWN0PkludGVsIENvcmUgUHJvY2Vzc29yIChTa3lsYWtlKTwvcHJvZHVjdD4KICAgICA8dmVuZG9yPkludGVsIENvcnAuPC92ZW5kb3I+CiAgICAgPHBoeXNpZD40MDA8L3BoeXNpZD4KICAgICA8YnVzaW5mbz5jcHVAMDwvYnVzaW5mbz4KICAgICA8dmVyc2lvbj5wYy1pNDQwZngtMi45PC92ZXJzaW9uPgogICAgIDxzbG90PkNQVSAwPC9zbG90PgogICAgIDxzaXplIHVuaXRzPSJIeiI+MjAwMDAwMDAwMDwvc2l6ZT4KICAgICA8Y2FwYWNpdHkgdW5pdHM9Ikh6Ij4yMDAwMDAwMDAwPC9jYXBhY2l0eT4KICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjY0PC93aWR0aD4KICAgICA8Y29uZmlndXJhdGlvbj4KICAgICAgPHNldHRpbmcgaWQ9ImNvcmVzIiB2YWx1ZT0iMSIgLz4KICAgICAgPHNldHRpbmcgaWQ9ImVuYWJsZWRjb3JlcyIgdmFsdWU9IjEiIC8+CiAgICAgIDxzZXR0aW5nIGlkPSJ0aHJlYWRzIiB2YWx1ZT0iMSIgLz4KICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImZwdSIgPm1hdGhlbWF0aWNhbCBjby1wcm9jZXNzb3I8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJmcHVfZXhjZXB0aW9uIiA+RlBVIGV4Y2VwdGlvbnMgcmVwb3J0aW5nPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0id3AiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ2bWUiID52aXJ0dWFsIG1vZGUgZXh0ZW5zaW9uczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImRlIiA+ZGVidWdnaW5nIGV4dGVuc2lvbnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwc2UiID5wYWdlIHNpemUgZXh0ZW5zaW9uczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InRzYyIgPnRpbWUgc3RhbXAgY291bnRlcjwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im1zciIgPm1vZGVsLXNwZWNpZmljIHJlZ2lzdGVyczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InBhZSIgPjRHQisgbWVtb3J5IGFkZHJlc3NpbmcgKFBoeXNpY2FsIEFkZHJlc3MgRXh0ZW5zaW9uKTwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im1jZSIgPm1hY2hpbmUgY2hlY2sgZXhjZXB0aW9uczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImN4OCIgPmNvbXBhcmUgYW5kIGV4Y2hhbmdlIDgtYnl0ZTwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImFwaWMiID5vbi1jaGlwIGFkdmFuY2VkIHByb2dyYW1tYWJsZSBpbnRlcnJ1cHQgY29udHJvbGxlciAoQVBJQyk8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJzZXAiID5mYXN0IHN5c3RlbSBjYWxsczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im10cnIiID5tZW1vcnkgdHlwZSByYW5nZSByZWdpc3RlcnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwZ2UiID5wYWdlIGdsb2JhbCBlbmFibGU8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJtY2EiID5tYWNoaW5lIGNoZWNrIGFyY2hpdGVjdHVyZTwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImNtb3YiID5jb25kaXRpb25hbCBtb3ZlIGluc3RydWN0aW9uPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0icGF0IiA+cGFnZSBhdHRyaWJ1dGUgdGFibGU8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwc2UzNiIgPjM2LWJpdCBwYWdlIHNpemUgZXh0ZW5zaW9uczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImNsZmx1c2giIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJtbXgiID5tdWx0aW1lZGlhIGV4dGVuc2lvbnMgKE1NWCk8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJmeHNyIiA+ZmFzdCBmbG9hdGluZyBwb2ludCBzYXZlL3Jlc3RvcmU8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJzc2UiID5zdHJlYW1pbmcgU0lNRCBleHRlbnNpb25zIChTU0UpPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic3NlMiIgPnN0cmVhbWluZyBTSU1EIGV4dGVuc2lvbnMgKFNTRTIpPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic3lzY2FsbCIgPmZhc3Qgc3lzdGVtIGNhbGxzPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0ibngiID5uby1leGVjdXRlIGJpdCAoTlgpPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0icmR0c2NwIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ieDg2LTY0IiA+NjRiaXRzIGV4dGVuc2lvbnMgKHg4Ni02NCk8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJjb25zdGFudF90c2MiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJyZXBfZ29vZCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im5vcGwiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ4dG9wb2xvZ3kiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwbmkiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwY2xtdWxxZHEiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJzc3NlMyIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImZtYSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImN4MTYiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwY2lkIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic3NlNF8xIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic3NlNF8yIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ieDJhcGljIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ibW92YmUiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwb3BjbnQiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ0c2NfZGVhZGxpbmVfdGltZXIiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhZXMiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ4c2F2ZSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImF2eCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImYxNmMiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJyZHJhbmQiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJoeXBlcnZpc29yIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ibGFoZl9sbSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImFibSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9IjNkbm93cHJlZmV0Y2giIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJmc2dzYmFzZSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJtaTEiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJobGUiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhdngyIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic21lcCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJtaTIiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJlcm1zIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iaW52cGNpZCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InJ0bSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im1weCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InJkc2VlZCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImFkeCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InNtYXAiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ4c2F2ZW9wdCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InhzYXZlYyIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InhnZXRidjEiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhcmF0IiAvPgogICAgIDwvY2FwYWJpbGl0aWVzPgogICAgPC9ub2RlPgogICAgPG5vZGUgaWQ9ImNwdToxIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0icHJvY2Vzc29yIiBoYW5kbGU9IkRNSTowNDAxIj4KICAgICA8ZGVzY3JpcHRpb24+Q1BVPC9kZXNjcmlwdGlvbj4KICAgICA8cHJvZHVjdD5JbnRlbCBDb3JlIFByb2Nlc3NvciAoU2t5bGFrZSk8L3Byb2R1Y3Q+CiAgICAgPHZlbmRvcj5JbnRlbCBDb3JwLjwvdmVuZG9yPgogICAgIDxwaHlzaWQ+NDAxPC9waHlzaWQ+CiAgICAgPGJ1c2luZm8+Y3B1QDE8L2J1c2luZm8+CiAgICAgPHZlcnNpb24+cGMtaTQ0MGZ4LTIuOTwvdmVyc2lvbj4KICAgICA8c2xvdD5DUFUgMTwvc2xvdD4KICAgICA8c2l6ZSB1bml0cz0iSHoiPjIwMDAwMDAwMDA8L3NpemU+CiAgICAgPGNhcGFjaXR5IHVuaXRzPSJIeiI+MjAwMDAwMDAwMDwvY2FwYWNpdHk+CiAgICAgPHdpZHRoIHVuaXRzPSJiaXRzIj42NDwvd2lkdGg+CiAgICAgPGNvbmZpZ3VyYXRpb24+CiAgICAgIDxzZXR0aW5nIGlkPSJjb3JlcyIgdmFsdWU9IjEiIC8+CiAgICAgIDxzZXR0aW5nIGlkPSJlbmFibGVkY29yZXMiIHZhbHVlPSIxIiAvPgogICAgICA8c2V0dGluZyBpZD0idGhyZWFkcyIgdmFsdWU9IjEiIC8+CiAgICAgPC9jb25maWd1cmF0aW9uPgogICAgIDxjYXBhYmlsaXRpZXM+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJmcHUiID5tYXRoZW1hdGljYWwgY28tcHJvY2Vzc29yPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0iZnB1X2V4Y2VwdGlvbiIgPkZQVSBleGNlcHRpb25zIHJlcG9ydGluZzwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9IndwIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0idm1lIiA+dmlydHVhbCBtb2RlIGV4dGVuc2lvbnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJkZSIgPmRlYnVnZ2luZyBleHRlbnNpb25zPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0icHNlIiA+cGFnZSBzaXplIGV4dGVuc2lvbnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ0c2MiID50aW1lIHN0YW1wIGNvdW50ZXI8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJtc3IiID5tb2RlbC1zcGVjaWZpYyByZWdpc3RlcnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJwYWUiID40R0IrIG1lbW9yeSBhZGRyZXNzaW5nIChQaHlzaWNhbCBBZGRyZXNzIEV4dGVuc2lvbik8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJtY2UiID5tYWNoaW5lIGNoZWNrIGV4Y2VwdGlvbnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJjeDgiID5jb21wYXJlIGFuZCBleGNoYW5nZSA4LWJ5dGU8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhcGljIiA+b24tY2hpcCBhZHZhbmNlZCBwcm9ncmFtbWFibGUgaW50ZXJydXB0IGNvbnRyb2xsZXIgKEFQSUMpPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic2VwIiA+ZmFzdCBzeXN0ZW0gY2FsbHM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJtdHJyIiA+bWVtb3J5IHR5cGUgcmFuZ2UgcmVnaXN0ZXJzPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0icGdlIiA+cGFnZSBnbG9iYWwgZW5hYmxlPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0ibWNhIiA+bWFjaGluZSBjaGVjayBhcmNoaXRlY3R1cmU8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJjbW92IiA+Y29uZGl0aW9uYWwgbW92ZSBpbnN0cnVjdGlvbjwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InBhdCIgPnBhZ2UgYXR0cmlidXRlIHRhYmxlPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0icHNlMzYiID4zNi1iaXQgcGFnZSBzaXplIGV4dGVuc2lvbnM8L2NhcGFiaWxpdHk+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJjbGZsdXNoIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ibW14IiA+bXVsdGltZWRpYSBleHRlbnNpb25zIChNTVgpPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0iZnhzciIgPmZhc3QgZmxvYXRpbmcgcG9pbnQgc2F2ZS9yZXN0b3JlPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic3NlIiA+c3RyZWFtaW5nIFNJTUQgZXh0ZW5zaW9ucyAoU1NFKTwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InNzZTIiID5zdHJlYW1pbmcgU0lNRCBleHRlbnNpb25zIChTU0UyKTwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InN5c2NhbGwiID5mYXN0IHN5c3RlbSBjYWxsczwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im54IiA+bm8tZXhlY3V0ZSBiaXQgKE5YKTwvY2FwYWJpbGl0eT4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InJkdHNjcCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Ing4Ni02NCIgPjY0Yml0cyBleHRlbnNpb25zICh4ODYtNjQpPC9jYXBhYmlsaXR5PgogICAgICA8Y2FwYWJpbGl0eSBpZD0iY29uc3RhbnRfdHNjIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0icmVwX2dvb2QiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJub3BsIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ieHRvcG9sb2d5IiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0icG5pIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0icGNsbXVscWRxIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ic3NzZTMiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJmbWEiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJjeDE2IiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0icGNpZCIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InNzZTRfMSIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InNzZTRfMiIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9IngyYXBpYyIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9Im1vdmJlIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0icG9wY250IiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0idHNjX2RlYWRsaW5lX3RpbWVyIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iYWVzIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ieHNhdmUiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhdngiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJmMTZjIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0icmRyYW5kIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iaHlwZXJ2aXNvciIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImxhaGZfbG0iIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhYm0iIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSIzZG5vd3ByZWZldGNoIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iZnNnc2Jhc2UiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJibWkxIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iaGxlIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iYXZ4MiIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9InNtZXAiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJibWkyIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iZXJtcyIgLz4KICAgICAgPGNhcGFiaWxpdHkgaWQ9ImludnBjaWQiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJydG0iIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJtcHgiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJyZHNlZWQiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJhZHgiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJzbWFwIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0ieHNhdmVvcHQiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ4c2F2ZWMiIC8+CiAgICAgIDxjYXBhYmlsaXR5IGlkPSJ4Z2V0YnYxIiAvPgogICAgICA8Y2FwYWJpbGl0eSBpZD0iYXJhdCIgLz4KICAgICA8L2NhcGFiaWxpdGllcz4KICAgIDwvbm9kZT4KICAgIDxub2RlIGlkPSJtZW1vcnkiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJtZW1vcnkiIGhhbmRsZT0iRE1JOjEwMDAiPgogICAgIDxkZXNjcmlwdGlvbj5TeXN0ZW0gTWVtb3J5PC9kZXNjcmlwdGlvbj4KICAgICA8cGh5c2lkPjEwMDA8L3BoeXNpZD4KICAgICA8c2l6ZSB1bml0cz0iYnl0ZXMiPjIxNDc0ODM2NDg8L3NpemU+CiAgICAgPGNhcGFjaXR5IHVuaXRzPSJieXRlcyI+MjE0NzQ4MzY0ODwvY2FwYWNpdHk+CiAgICAgIDxub2RlIGlkPSJiYW5rIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0ibWVtb3J5IiBoYW5kbGU9IkRNSToxMTAwIj4KICAgICAgIDxkZXNjcmlwdGlvbj5ESU1NIFJBTTwvZGVzY3JpcHRpb24+CiAgICAgICA8dmVuZG9yPlFFTVU8L3ZlbmRvcj4KICAgICAgIDxwaHlzaWQ+MDwvcGh5c2lkPgogICAgICAgPHNsb3Q+RElNTSAwPC9zbG90PgogICAgICAgPHNpemUgdW5pdHM9ImJ5dGVzIj4yMTQ3NDgzNjQ4PC9zaXplPgogICAgICA8L25vZGU+CiAgICA8L25vZGU+CiAgICA8bm9kZSBpZD0icGNpIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0iYnJpZGdlIiBoYW5kbGU9IlBDSUJVUzowMDAwOjAwIj4KICAgICA8ZGVzY3JpcHRpb24+SG9zdCBicmlkZ2U8L2Rlc2NyaXB0aW9uPgogICAgIDxwcm9kdWN0PjQ0MEZYIC0gODI0NDFGWCBQTUMgW05hdG9tYV08L3Byb2R1Y3Q+CiAgICAgPHZlbmRvcj5JbnRlbCBDb3Jwb3JhdGlvbjwvdmVuZG9yPgogICAgIDxwaHlzaWQ+MTAwPC9waHlzaWQ+CiAgICAgPGJ1c2luZm8+cGNpQDAwMDA6MDA6MDAuMDwvYnVzaW5mbz4KICAgICA8dmVyc2lvbj4wMjwvdmVyc2lvbj4KICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjMyPC93aWR0aD4KICAgICA8Y2xvY2sgdW5pdHM9Ikh6Ij4zMzAwMDAwMDwvY2xvY2s+CiAgICAgIDxub2RlIGlkPSJpc2EiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJicmlkZ2UiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDEuMCI+CiAgICAgICA8ZGVzY3JpcHRpb24+SVNBIGJyaWRnZTwvZGVzY3JpcHRpb24+CiAgICAgICA8cHJvZHVjdD44MjM3MVNCIFBJSVgzIElTQSBbTmF0b21hL1RyaXRvbiBJSV08L3Byb2R1Y3Q+CiAgICAgICA8dmVuZG9yPkludGVsIENvcnBvcmF0aW9uPC92ZW5kb3I+CiAgICAgICA8cGh5c2lkPjE8L3BoeXNpZD4KICAgICAgIDxidXNpbmZvPnBjaUAwMDAwOjAwOjAxLjA8L2J1c2luZm8+CiAgICAgICA8dmVyc2lvbj4wMDwvdmVyc2lvbj4KICAgICAgIDx3aWR0aCB1bml0cz0iYml0cyI+MzI8L3dpZHRoPgogICAgICAgPGNsb2NrIHVuaXRzPSJIeiI+MzMwMDAwMDA8L2Nsb2NrPgogICAgICAgPGNvbmZpZ3VyYXRpb24+CiAgICAgICAgPHNldHRpbmcgaWQ9ImxhdGVuY3kiIHZhbHVlPSIwIiAvPgogICAgICAgPC9jb25maWd1cmF0aW9uPgogICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0iaXNhIiAvPgogICAgICAgPC9jYXBhYmlsaXRpZXM+CiAgICAgIDwvbm9kZT4KICAgICAgPG5vZGUgaWQ9ImlkZSIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9InN0b3JhZ2UiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDEuMSI+CiAgICAgICA8ZGVzY3JpcHRpb24+SURFIGludGVyZmFjZTwvZGVzY3JpcHRpb24+CiAgICAgICA8cHJvZHVjdD44MjM3MVNCIFBJSVgzIElERSBbTmF0b21hL1RyaXRvbiBJSV08L3Byb2R1Y3Q+CiAgICAgICA8dmVuZG9yPkludGVsIENvcnBvcmF0aW9uPC92ZW5kb3I+CiAgICAgICA8cGh5c2lkPjEuMTwvcGh5c2lkPgogICAgICAgPGJ1c2luZm8+cGNpQDAwMDA6MDA6MDEuMTwvYnVzaW5mbz4KICAgICAgIDx2ZXJzaW9uPjAwPC92ZXJzaW9uPgogICAgICAgPHdpZHRoIHVuaXRzPSJiaXRzIj4zMjwvd2lkdGg+CiAgICAgICA8Y2xvY2sgdW5pdHM9Ikh6Ij4zMzAwMDAwMDwvY2xvY2s+CiAgICAgICA8Y29uZmlndXJhdGlvbj4KICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVyIiB2YWx1ZT0iYXRhX3BpaXgiIC8+CiAgICAgICAgPHNldHRpbmcgaWQ9ImxhdGVuY3kiIHZhbHVlPSIwIiAvPgogICAgICAgPC9jb25maWd1cmF0aW9uPgogICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0iaWRlIiAvPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJidXNfbWFzdGVyIiA+YnVzIG1hc3RlcmluZzwvY2FwYWJpbGl0eT4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaXJxIiB2YWx1ZT0iMCIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaW9wb3J0IiB2YWx1ZT0iMWYwKHNpemU9OCkiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlvcG9ydCIgdmFsdWU9IjNmNiIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaW9wb3J0IiB2YWx1ZT0iMTcwKHNpemU9OCkiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlvcG9ydCIgdmFsdWU9IjM3NiIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaW9wb3J0IiB2YWx1ZT0iYzE4MChzaXplPTE2KSIgLz4KICAgICAgIDwvcmVzb3VyY2VzPgogICAgICA8L25vZGU+CiAgICAgIDxub2RlIGlkPSJicmlkZ2UiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJicmlkZ2UiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDEuMyI+CiAgICAgICA8ZGVzY3JpcHRpb24+QnJpZGdlPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PjgyMzcxQUIvRUIvTUIgUElJWDQgQUNQSTwvcHJvZHVjdD4KICAgICAgIDx2ZW5kb3I+SW50ZWwgQ29ycG9yYXRpb248L3ZlbmRvcj4KICAgICAgIDxwaHlzaWQ+MS4zPC9waHlzaWQ+CiAgICAgICA8YnVzaW5mbz5wY2lAMDAwMDowMDowMS4zPC9idXNpbmZvPgogICAgICAgPHZlcnNpb24+MDM8L3ZlcnNpb24+CiAgICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjMyPC93aWR0aD4KICAgICAgIDxjbG9jayB1bml0cz0iSHoiPjMzMDAwMDAwPC9jbG9jaz4KICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXIiIHZhbHVlPSJwaWl4NF9zbWJ1cyIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibGF0ZW5jeSIgdmFsdWU9IjAiIC8+CiAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJicmlkZ2UiIC8+CiAgICAgICA8L2NhcGFiaWxpdGllcz4KICAgICAgIDxyZXNvdXJjZXM+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlycSIgdmFsdWU9IjkiIC8+CiAgICAgICA8L3Jlc291cmNlcz4KICAgICAgPC9ub2RlPgogICAgICA8bm9kZSBpZD0iZGlzcGxheSIgY2xhc3M9ImRpc3BsYXkiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDIuMCI+CiAgICAgICA8ZGVzY3JpcHRpb24+VkdBIGNvbXBhdGlibGUgY29udHJvbGxlcjwvZGVzY3JpcHRpb24+CiAgICAgICA8cHJvZHVjdD5TVkdBIElJIEFkYXB0ZXI8L3Byb2R1Y3Q+CiAgICAgICA8dmVuZG9yPlZNd2FyZTwvdmVuZG9yPgogICAgICAgPHBoeXNpZD4yPC9waHlzaWQ+CiAgICAgICA8YnVzaW5mbz5wY2lAMDAwMDowMDowMi4wPC9idXNpbmZvPgogICAgICAgPHZlcnNpb24+MDA8L3ZlcnNpb24+CiAgICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjMyPC93aWR0aD4KICAgICAgIDxjbG9jayB1bml0cz0iSHoiPjMzMDAwMDAwPC9jbG9jaz4KICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgIDxzZXR0aW5nIGlkPSJsYXRlbmN5IiB2YWx1ZT0iNjQiIC8+CiAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJ2Z2FfY29udHJvbGxlciIgLz4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaW9wb3J0IiB2YWx1ZT0iYzE5MChzaXplPTE2KSIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0ibWVtb3J5IiB2YWx1ZT0iZmQwMDAwMDAtZmRmZmZmZmYiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9Im1lbW9yeSIgdmFsdWU9ImZlMDAwMDAwLWZlMDBmZmZmIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJtZW1vcnkiIHZhbHVlPSJjMDAwMC1kZmZmZiIgLz4KICAgICAgIDwvcmVzb3VyY2VzPgogICAgICA8L25vZGU+CiAgICAgIDxub2RlIGlkPSJuZXR3b3JrOjAiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJuZXR3b3JrIiBoYW5kbGU9IlBDSTowMDAwOjAwOjAzLjAiPgogICAgICAgPGRlc2NyaXB0aW9uPkV0aGVybmV0IGludGVyZmFjZTwvZGVzY3JpcHRpb24+CiAgICAgICA8cHJvZHVjdD5WaXJ0aW8gbmV0d29yayBkZXZpY2U8L3Byb2R1Y3Q+CiAgICAgICA8dmVuZG9yPlJlZCBIYXQsIEluYzwvdmVuZG9yPgogICAgICAgPHBoeXNpZD4zPC9waHlzaWQ+CiAgICAgICA8YnVzaW5mbz5wY2lAMDAwMDowMDowMy4wPC9idXNpbmZvPgogICAgICAgPGxvZ2ljYWxuYW1lPmVuczM8L2xvZ2ljYWxuYW1lPgogICAgICAgPHZlcnNpb24+MDA8L3ZlcnNpb24+CiAgICAgICA8c2VyaWFsPjUyOjU0OjAwOmYwOjEzOjk3PC9zZXJpYWw+CiAgICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjY0PC93aWR0aD4KICAgICAgIDxjbG9jayB1bml0cz0iSHoiPjMzMDAwMDAwPC9jbG9jaz4KICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgIDxzZXR0aW5nIGlkPSJhdXRvbmVnb3RpYXRpb24iIHZhbHVlPSJvZmYiIC8+CiAgICAgICAgPHNldHRpbmcgaWQ9ImJyb2FkY2FzdCIgdmFsdWU9InllcyIgLz4KICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVyIiB2YWx1ZT0idmlydGlvX25ldCIgLz4KICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVydmVyc2lvbiIgdmFsdWU9IjEuMC4wIiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJpcCIgdmFsdWU9IjE3Mi4yMC4wLjQ2IiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJsYXRlbmN5IiB2YWx1ZT0iMCIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibGluayIgdmFsdWU9InllcyIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibXVsdGljYXN0IiB2YWx1ZT0ieWVzIiAvPgogICAgICAgPC9jb25maWd1cmF0aW9uPgogICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0ibXNpeCIgPk1TSS1YPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJidXNfbWFzdGVyIiA+YnVzIG1hc3RlcmluZzwvY2FwYWJpbGl0eT4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0iY2FwX2xpc3QiID5QQ0kgY2FwYWJpbGl0aWVzIGxpc3Rpbmc8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9InJvbSIgPmV4dGVuc2lvbiBST008L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImV0aGVybmV0IiAvPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJwaHlzaWNhbCIgPlBoeXNpY2FsIGludGVyZmFjZTwvY2FwYWJpbGl0eT4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaXJxIiB2YWx1ZT0iMTEiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlvcG9ydCIgdmFsdWU9ImMwMDAoc2l6ZT02NCkiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9Im1lbW9yeSIgdmFsdWU9ImZlYmQ0MDAwLWZlYmQ0ZmZmIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJtZW1vcnkiIHZhbHVlPSJmZTAxMDAwMC1mZTAxM2ZmZiIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0ibWVtb3J5IiB2YWx1ZT0iZmViNDAwMDAtZmViN2ZmZmYiIC8+CiAgICAgICA8L3Jlc291cmNlcz4KICAgICAgPC9ub2RlPgogICAgICA8bm9kZSBpZD0ibXVsdGltZWRpYSIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9Im11bHRpbWVkaWEiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDQuMCI+CiAgICAgICA8ZGVzY3JpcHRpb24+QXVkaW8gZGV2aWNlPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PjgyODAxRkIvRkJNL0ZSL0ZXL0ZSVyAoSUNINiBGYW1pbHkpIEhpZ2ggRGVmaW5pdGlvbiBBdWRpbyBDb250cm9sbGVyPC9wcm9kdWN0PgogICAgICAgPHZlbmRvcj5JbnRlbCBDb3Jwb3JhdGlvbjwvdmVuZG9yPgogICAgICAgPHBoeXNpZD40PC9waHlzaWQ+CiAgICAgICA8YnVzaW5mbz5wY2lAMDAwMDowMDowNC4wPC9idXNpbmZvPgogICAgICAgPHZlcnNpb24+MDE8L3ZlcnNpb24+CiAgICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjMyPC93aWR0aD4KICAgICAgIDxjbG9jayB1bml0cz0iSHoiPjMzMDAwMDAwPC9jbG9jaz4KICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXIiIHZhbHVlPSJzbmRfaGRhX2ludGVsIiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJsYXRlbmN5IiB2YWx1ZT0iMCIgLz4KICAgICAgIDwvY29uZmlndXJhdGlvbj4KICAgICAgIDxjYXBhYmlsaXRpZXM+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9Im1zaSIgPk1lc3NhZ2UgU2lnbmFsbGVkIEludGVycnVwdHM8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJ1c19tYXN0ZXIiID5idXMgbWFzdGVyaW5nPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJjYXBfbGlzdCIgPlBDSSBjYXBhYmlsaXRpZXMgbGlzdGluZzwvY2FwYWJpbGl0eT4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaXJxIiB2YWx1ZT0iMzQiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9Im1lbW9yeSIgdmFsdWU9ImZlYmQwMDAwLWZlYmQzZmZmIiAvPgogICAgICAgPC9yZXNvdXJjZXM+CiAgICAgIDwvbm9kZT4KICAgICAgPG5vZGUgaWQ9InVzYjowIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0iYnVzIiBoYW5kbGU9IlBDSTowMDAwOjAwOjA1LjAiPgogICAgICAgPGRlc2NyaXB0aW9uPlVTQiBjb250cm9sbGVyPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PjgyODAxSSAoSUNIOSBGYW1pbHkpIFVTQiBVSENJIENvbnRyb2xsZXIgIzE8L3Byb2R1Y3Q+CiAgICAgICA8dmVuZG9yPkludGVsIENvcnBvcmF0aW9uPC92ZW5kb3I+CiAgICAgICA8cGh5c2lkPjU8L3BoeXNpZD4KICAgICAgIDxidXNpbmZvPnBjaUAwMDAwOjAwOjA1LjA8L2J1c2luZm8+CiAgICAgICA8dmVyc2lvbj4wMzwvdmVyc2lvbj4KICAgICAgIDx3aWR0aCB1bml0cz0iYml0cyI+MzI8L3dpZHRoPgogICAgICAgPGNsb2NrIHVuaXRzPSJIeiI+MzMwMDAwMDA8L2Nsb2NrPgogICAgICAgPGNvbmZpZ3VyYXRpb24+CiAgICAgICAgPHNldHRpbmcgaWQ9ImRyaXZlciIgdmFsdWU9InVoY2lfaGNkIiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJsYXRlbmN5IiB2YWx1ZT0iMCIgLz4KICAgICAgIDwvY29uZmlndXJhdGlvbj4KICAgICAgIDxjYXBhYmlsaXRpZXM+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9InVoY2kiID5Vbml2ZXJzYWwgSG9zdCBDb250cm9sbGVyIEludGVyZmFjZSAoVVNCMSk8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJ1c19tYXN0ZXIiID5idXMgbWFzdGVyaW5nPC9jYXBhYmlsaXR5PgogICAgICAgPC9jYXBhYmlsaXRpZXM+CiAgICAgICA8cmVzb3VyY2VzPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJpcnEiIHZhbHVlPSIxMCIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaW9wb3J0IiB2YWx1ZT0iYzEwMChzaXplPTMyKSIgLz4KICAgICAgIDwvcmVzb3VyY2VzPgogICAgICAgIDxub2RlIGlkPSJ1c2Job3N0IiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0iYnVzIiBoYW5kbGU9IlVTQjoyOjEiPgogICAgICAgICA8cHJvZHVjdD5VSENJIEhvc3QgQ29udHJvbGxlcjwvcHJvZHVjdD4KICAgICAgICAgPHZlbmRvcj5MaW51eCA0LjEwLjAtMzItZ2VuZXJpYyB1aGNpX2hjZDwvdmVuZG9yPgogICAgICAgICA8cGh5c2lkPjE8L3BoeXNpZD4KICAgICAgICAgPGJ1c2luZm8+dXNiQDI8L2J1c2luZm8+CiAgICAgICAgIDxsb2dpY2FsbmFtZT51c2IyPC9sb2dpY2FsbmFtZT4KICAgICAgICAgPHZlcnNpb24+NC4xMDwvdmVyc2lvbj4KICAgICAgICAgPGNvbmZpZ3VyYXRpb24+CiAgICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVyIiB2YWx1ZT0iaHViIiAvPgogICAgICAgICAgPHNldHRpbmcgaWQ9InNsb3RzIiB2YWx1ZT0iMiIgLz4KICAgICAgICAgIDxzZXR0aW5nIGlkPSJzcGVlZCIgdmFsdWU9IjEyTWJpdC9zIiAvPgogICAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICAgIDxjYXBhYmlsaXRpZXM+CiAgICAgICAgICA8Y2FwYWJpbGl0eSBpZD0idXNiLTEuMTAiID5VU0IgMS4xPC9jYXBhYmlsaXR5PgogICAgICAgICA8L2NhcGFiaWxpdGllcz4KICAgICAgICA8L25vZGU+CiAgICAgIDwvbm9kZT4KICAgICAgPG5vZGUgaWQ9InVzYjoxIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0iYnVzIiBoYW5kbGU9IlBDSTowMDAwOjAwOjA1LjEiPgogICAgICAgPGRlc2NyaXB0aW9uPlVTQiBjb250cm9sbGVyPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PjgyODAxSSAoSUNIOSBGYW1pbHkpIFVTQiBVSENJIENvbnRyb2xsZXIgIzI8L3Byb2R1Y3Q+CiAgICAgICA8dmVuZG9yPkludGVsIENvcnBvcmF0aW9uPC92ZW5kb3I+CiAgICAgICA8cGh5c2lkPjUuMTwvcGh5c2lkPgogICAgICAgPGJ1c2luZm8+cGNpQDAwMDA6MDA6MDUuMTwvYnVzaW5mbz4KICAgICAgIDx2ZXJzaW9uPjAzPC92ZXJzaW9uPgogICAgICAgPHdpZHRoIHVuaXRzPSJiaXRzIj4zMjwvd2lkdGg+CiAgICAgICA8Y2xvY2sgdW5pdHM9Ikh6Ij4zMzAwMDAwMDwvY2xvY2s+CiAgICAgICA8Y29uZmlndXJhdGlvbj4KICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVyIiB2YWx1ZT0idWhjaV9oY2QiIC8+CiAgICAgICAgPHNldHRpbmcgaWQ9ImxhdGVuY3kiIHZhbHVlPSIwIiAvPgogICAgICAgPC9jb25maWd1cmF0aW9uPgogICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0idWhjaSIgPlVuaXZlcnNhbCBIb3N0IENvbnRyb2xsZXIgSW50ZXJmYWNlIChVU0IxKTwvY2FwYWJpbGl0eT4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0iYnVzX21hc3RlciIgPmJ1cyBtYXN0ZXJpbmc8L2NhcGFiaWxpdHk+CiAgICAgICA8L2NhcGFiaWxpdGllcz4KICAgICAgIDxyZXNvdXJjZXM+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlycSIgdmFsdWU9IjExIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJpb3BvcnQiIHZhbHVlPSJjMTIwKHNpemU9MzIpIiAvPgogICAgICAgPC9yZXNvdXJjZXM+CiAgICAgICAgPG5vZGUgaWQ9InVzYmhvc3QiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJidXMiIGhhbmRsZT0iVVNCOjM6MSI+CiAgICAgICAgIDxwcm9kdWN0PlVIQ0kgSG9zdCBDb250cm9sbGVyPC9wcm9kdWN0PgogICAgICAgICA8dmVuZG9yPkxpbnV4IDQuMTAuMC0zMi1nZW5lcmljIHVoY2lfaGNkPC92ZW5kb3I+CiAgICAgICAgIDxwaHlzaWQ+MTwvcGh5c2lkPgogICAgICAgICA8YnVzaW5mbz51c2JAMzwvYnVzaW5mbz4KICAgICAgICAgPGxvZ2ljYWxuYW1lPnVzYjM8L2xvZ2ljYWxuYW1lPgogICAgICAgICA8dmVyc2lvbj40LjEwPC92ZXJzaW9uPgogICAgICAgICA8Y29uZmlndXJhdGlvbj4KICAgICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXIiIHZhbHVlPSJodWIiIC8+CiAgICAgICAgICA8c2V0dGluZyBpZD0ic2xvdHMiIHZhbHVlPSIyIiAvPgogICAgICAgICAgPHNldHRpbmcgaWQ9InNwZWVkIiB2YWx1ZT0iMTJNYml0L3MiIC8+CiAgICAgICAgIDwvY29uZmlndXJhdGlvbj4KICAgICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICAgIDxjYXBhYmlsaXR5IGlkPSJ1c2ItMS4xMCIgPlVTQiAxLjE8L2NhcGFiaWxpdHk+CiAgICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgIDwvbm9kZT4KICAgICAgPC9ub2RlPgogICAgICA8bm9kZSBpZD0idXNiOjIiIGNsYWltZWQ9InRydWUiIGNsYXNzPSJidXMiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDUuMiI+CiAgICAgICA8ZGVzY3JpcHRpb24+VVNCIGNvbnRyb2xsZXI8L2Rlc2NyaXB0aW9uPgogICAgICAgPHByb2R1Y3Q+ODI4MDFJIChJQ0g5IEZhbWlseSkgVVNCIFVIQ0kgQ29udHJvbGxlciAjMzwvcHJvZHVjdD4KICAgICAgIDx2ZW5kb3I+SW50ZWwgQ29ycG9yYXRpb248L3ZlbmRvcj4KICAgICAgIDxwaHlzaWQ+NS4yPC9waHlzaWQ+CiAgICAgICA8YnVzaW5mbz5wY2lAMDAwMDowMDowNS4yPC9idXNpbmZvPgogICAgICAgPHZlcnNpb24+MDM8L3ZlcnNpb24+CiAgICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjMyPC93aWR0aD4KICAgICAgIDxjbG9jayB1bml0cz0iSHoiPjMzMDAwMDAwPC9jbG9jaz4KICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXIiIHZhbHVlPSJ1aGNpX2hjZCIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibGF0ZW5jeSIgdmFsdWU9IjAiIC8+CiAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJ1aGNpIiA+VW5pdmVyc2FsIEhvc3QgQ29udHJvbGxlciBJbnRlcmZhY2UgKFVTQjEpPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJidXNfbWFzdGVyIiA+YnVzIG1hc3RlcmluZzwvY2FwYWJpbGl0eT4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaXJxIiB2YWx1ZT0iMTEiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlvcG9ydCIgdmFsdWU9ImMxNDAoc2l6ZT0zMikiIC8+CiAgICAgICA8L3Jlc291cmNlcz4KICAgICAgICA8bm9kZSBpZD0idXNiaG9zdCIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9ImJ1cyIgaGFuZGxlPSJVU0I6NDoxIj4KICAgICAgICAgPHByb2R1Y3Q+VUhDSSBIb3N0IENvbnRyb2xsZXI8L3Byb2R1Y3Q+CiAgICAgICAgIDx2ZW5kb3I+TGludXggNC4xMC4wLTMyLWdlbmVyaWMgdWhjaV9oY2Q8L3ZlbmRvcj4KICAgICAgICAgPHBoeXNpZD4xPC9waHlzaWQ+CiAgICAgICAgIDxidXNpbmZvPnVzYkA0PC9idXNpbmZvPgogICAgICAgICA8bG9naWNhbG5hbWU+dXNiNDwvbG9naWNhbG5hbWU+CiAgICAgICAgIDx2ZXJzaW9uPjQuMTA8L3ZlcnNpb24+CiAgICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgICAgPHNldHRpbmcgaWQ9ImRyaXZlciIgdmFsdWU9Imh1YiIgLz4KICAgICAgICAgIDxzZXR0aW5nIGlkPSJzbG90cyIgdmFsdWU9IjIiIC8+CiAgICAgICAgICA8c2V0dGluZyBpZD0ic3BlZWQiIHZhbHVlPSIxMk1iaXQvcyIgLz4KICAgICAgICAgPC9jb25maWd1cmF0aW9uPgogICAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgICAgPGNhcGFiaWxpdHkgaWQ9InVzYi0xLjEwIiA+VVNCIDEuMTwvY2FwYWJpbGl0eT4KICAgICAgICAgPC9jYXBhYmlsaXRpZXM+CiAgICAgICAgPC9ub2RlPgogICAgICA8L25vZGU+CiAgICAgIDxub2RlIGlkPSJ1c2I6MyIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9ImJ1cyIgaGFuZGxlPSJQQ0k6MDAwMDowMDowNS43Ij4KICAgICAgIDxkZXNjcmlwdGlvbj5VU0IgY29udHJvbGxlcjwvZGVzY3JpcHRpb24+CiAgICAgICA8cHJvZHVjdD44MjgwMUkgKElDSDkgRmFtaWx5KSBVU0IyIEVIQ0kgQ29udHJvbGxlciAjMTwvcHJvZHVjdD4KICAgICAgIDx2ZW5kb3I+SW50ZWwgQ29ycG9yYXRpb248L3ZlbmRvcj4KICAgICAgIDxwaHlzaWQ+NS43PC9waHlzaWQ+CiAgICAgICA8YnVzaW5mbz5wY2lAMDAwMDowMDowNS43PC9idXNpbmZvPgogICAgICAgPHZlcnNpb24+MDM8L3ZlcnNpb24+CiAgICAgICA8d2lkdGggdW5pdHM9ImJpdHMiPjMyPC93aWR0aD4KICAgICAgIDxjbG9jayB1bml0cz0iSHoiPjMzMDAwMDAwPC9jbG9jaz4KICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXIiIHZhbHVlPSJlaGNpLXBjaSIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibGF0ZW5jeSIgdmFsdWU9IjAiIC8+CiAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJlaGNpIiA+RW5oYW5jZWQgSG9zdCBDb250cm9sbGVyIEludGVyZmFjZSAoVVNCMik8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJ1c19tYXN0ZXIiID5idXMgbWFzdGVyaW5nPC9jYXBhYmlsaXR5PgogICAgICAgPC9jYXBhYmlsaXRpZXM+CiAgICAgICA8cmVzb3VyY2VzPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJpcnEiIHZhbHVlPSIxMCIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0ibWVtb3J5IiB2YWx1ZT0iZmViZDUwMDAtZmViZDVmZmYiIC8+CiAgICAgICA8L3Jlc291cmNlcz4KICAgICAgICA8bm9kZSBpZD0idXNiaG9zdCIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9ImJ1cyIgaGFuZGxlPSJVU0I6MToxIj4KICAgICAgICAgPHByb2R1Y3Q+RUhDSSBIb3N0IENvbnRyb2xsZXI8L3Byb2R1Y3Q+CiAgICAgICAgIDx2ZW5kb3I+TGludXggNC4xMC4wLTMyLWdlbmVyaWMgZWhjaV9oY2Q8L3ZlbmRvcj4KICAgICAgICAgPHBoeXNpZD4xPC9waHlzaWQ+CiAgICAgICAgIDxidXNpbmZvPnVzYkAxPC9idXNpbmZvPgogICAgICAgICA8bG9naWNhbG5hbWU+dXNiMTwvbG9naWNhbG5hbWU+CiAgICAgICAgIDx2ZXJzaW9uPjQuMTA8L3ZlcnNpb24+CiAgICAgICAgIDxjb25maWd1cmF0aW9uPgogICAgICAgICAgPHNldHRpbmcgaWQ9ImRyaXZlciIgdmFsdWU9Imh1YiIgLz4KICAgICAgICAgIDxzZXR0aW5nIGlkPSJzbG90cyIgdmFsdWU9IjYiIC8+CiAgICAgICAgICA8c2V0dGluZyBpZD0ic3BlZWQiIHZhbHVlPSI0ODBNYml0L3MiIC8+CiAgICAgICAgIDwvY29uZmlndXJhdGlvbj4KICAgICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICAgIDxjYXBhYmlsaXR5IGlkPSJ1c2ItMi4wMCIgPlVTQiAyLjA8L2NhcGFiaWxpdHk+CiAgICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgIDwvbm9kZT4KICAgICAgPC9ub2RlPgogICAgICA8bm9kZSBpZD0iY29tbXVuaWNhdGlvbiIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9ImNvbW11bmljYXRpb24iIGhhbmRsZT0iUENJOjAwMDA6MDA6MDYuMCI+CiAgICAgICA8ZGVzY3JpcHRpb24+Q29tbXVuaWNhdGlvbiBjb250cm9sbGVyPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PlZpcnRpbyBjb25zb2xlPC9wcm9kdWN0PgogICAgICAgPHZlbmRvcj5SZWQgSGF0LCBJbmM8L3ZlbmRvcj4KICAgICAgIDxwaHlzaWQ+NjwvcGh5c2lkPgogICAgICAgPGJ1c2luZm8+cGNpQDAwMDA6MDA6MDYuMDwvYnVzaW5mbz4KICAgICAgIDx2ZXJzaW9uPjAwPC92ZXJzaW9uPgogICAgICAgPHdpZHRoIHVuaXRzPSJiaXRzIj42NDwvd2lkdGg+CiAgICAgICA8Y2xvY2sgdW5pdHM9Ikh6Ij4zMzAwMDAwMDwvY2xvY2s+CiAgICAgICA8Y29uZmlndXJhdGlvbj4KICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVyIiB2YWx1ZT0idmlydGlvLXBjaSIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibGF0ZW5jeSIgdmFsdWU9IjAiIC8+CiAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJtc2l4IiA+TVNJLVg8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJ1c19tYXN0ZXIiID5idXMgbWFzdGVyaW5nPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJjYXBfbGlzdCIgPlBDSSBjYXBhYmlsaXRpZXMgbGlzdGluZzwvY2FwYWJpbGl0eT4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaXJxIiB2YWx1ZT0iMTEiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlvcG9ydCIgdmFsdWU9ImMwNDAoc2l6ZT02NCkiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9Im1lbW9yeSIgdmFsdWU9ImZlYmQ2MDAwLWZlYmQ2ZmZmIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJtZW1vcnkiIHZhbHVlPSJmZTAxNDAwMC1mZTAxN2ZmZiIgLz4KICAgICAgIDwvcmVzb3VyY2VzPgogICAgICA8L25vZGU+CiAgICAgIDxub2RlIGlkPSJzY3NpIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0ic3RvcmFnZSIgaGFuZGxlPSJQQ0k6MDAwMDowMDowNy4wIj4KICAgICAgIDxkZXNjcmlwdGlvbj5TQ1NJIHN0b3JhZ2UgY29udHJvbGxlcjwvZGVzY3JpcHRpb24+CiAgICAgICA8cHJvZHVjdD5WaXJ0aW8gYmxvY2sgZGV2aWNlPC9wcm9kdWN0PgogICAgICAgPHZlbmRvcj5SZWQgSGF0LCBJbmM8L3ZlbmRvcj4KICAgICAgIDxwaHlzaWQ+NzwvcGh5c2lkPgogICAgICAgPGJ1c2luZm8+cGNpQDAwMDA6MDA6MDcuMDwvYnVzaW5mbz4KICAgICAgIDx2ZXJzaW9uPjAwPC92ZXJzaW9uPgogICAgICAgPHdpZHRoIHVuaXRzPSJiaXRzIj42NDwvd2lkdGg+CiAgICAgICA8Y2xvY2sgdW5pdHM9Ikh6Ij4zMzAwMDAwMDwvY2xvY2s+CiAgICAgICA8Y29uZmlndXJhdGlvbj4KICAgICAgICA8c2V0dGluZyBpZD0iZHJpdmVyIiB2YWx1ZT0idmlydGlvLXBjaSIgLz4KICAgICAgICA8c2V0dGluZyBpZD0ibGF0ZW5jeSIgdmFsdWU9IjAiIC8+CiAgICAgICA8L2NvbmZpZ3VyYXRpb24+CiAgICAgICA8Y2FwYWJpbGl0aWVzPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJzY3NpIiAvPgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJtc2l4IiA+TVNJLVg8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImJ1c19tYXN0ZXIiID5idXMgbWFzdGVyaW5nPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJjYXBfbGlzdCIgPlBDSSBjYXBhYmlsaXRpZXMgbGlzdGluZzwvY2FwYWJpbGl0eT4KICAgICAgIDwvY2FwYWJpbGl0aWVzPgogICAgICAgPHJlc291cmNlcz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaXJxIiB2YWx1ZT0iMTEiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlvcG9ydCIgdmFsdWU9ImMwODAoc2l6ZT02NCkiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9Im1lbW9yeSIgdmFsdWU9ImZlYmQ3MDAwLWZlYmQ3ZmZmIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJtZW1vcnkiIHZhbHVlPSJmZTAxODAwMC1mZTAxYmZmZiIgLz4KICAgICAgIDwvcmVzb3VyY2VzPgogICAgICA8L25vZGU+CiAgICAgIDxub2RlIGlkPSJnZW5lcmljIiBjbGFpbWVkPSJ0cnVlIiBjbGFzcz0iZ2VuZXJpYyIgaGFuZGxlPSJQQ0k6MDAwMDowMDowOC4wIj4KICAgICAgIDxkZXNjcmlwdGlvbj5VbmNsYXNzaWZpZWQgZGV2aWNlPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PlZpcnRpbyBtZW1vcnkgYmFsbG9vbjwvcHJvZHVjdD4KICAgICAgIDx2ZW5kb3I+UmVkIEhhdCwgSW5jPC92ZW5kb3I+CiAgICAgICA8cGh5c2lkPjg8L3BoeXNpZD4KICAgICAgIDxidXNpbmZvPnBjaUAwMDAwOjAwOjA4LjA8L2J1c2luZm8+CiAgICAgICA8dmVyc2lvbj4wMDwvdmVyc2lvbj4KICAgICAgIDx3aWR0aCB1bml0cz0iYml0cyI+NjQ8L3dpZHRoPgogICAgICAgPGNsb2NrIHVuaXRzPSJIeiI+MzMwMDAwMDA8L2Nsb2NrPgogICAgICAgPGNvbmZpZ3VyYXRpb24+CiAgICAgICAgPHNldHRpbmcgaWQ9ImRyaXZlciIgdmFsdWU9InZpcnRpby1wY2kiIC8+CiAgICAgICAgPHNldHRpbmcgaWQ9ImxhdGVuY3kiIHZhbHVlPSIwIiAvPgogICAgICAgPC9jb25maWd1cmF0aW9uPgogICAgICAgPGNhcGFiaWxpdGllcz4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0iYnVzX21hc3RlciIgPmJ1cyBtYXN0ZXJpbmc8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImNhcF9saXN0IiA+UENJIGNhcGFiaWxpdGllcyBsaXN0aW5nPC9jYXBhYmlsaXR5PgogICAgICAgPC9jYXBhYmlsaXRpZXM+CiAgICAgICA8cmVzb3VyY2VzPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJpcnEiIHZhbHVlPSIxMCIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0iaW9wb3J0IiB2YWx1ZT0iYzE2MChzaXplPTMyKSIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0ibWVtb3J5IiB2YWx1ZT0iZmUwMWMwMDAtZmUwMWZmZmYiIC8+CiAgICAgICA8L3Jlc291cmNlcz4KICAgICAgPC9ub2RlPgogICAgICA8bm9kZSBpZD0ibmV0d29yazoxIiBkaXNhYmxlZD0idHJ1ZSIgY2xhaW1lZD0idHJ1ZSIgY2xhc3M9Im5ldHdvcmsiIGhhbmRsZT0iUENJOjAwMDA6MDA6MDkuMCI+CiAgICAgICA8ZGVzY3JpcHRpb24+RXRoZXJuZXQgaW50ZXJmYWNlPC9kZXNjcmlwdGlvbj4KICAgICAgIDxwcm9kdWN0PlZpcnRpbyBuZXR3b3JrIGRldmljZTwvcHJvZHVjdD4KICAgICAgIDx2ZW5kb3I+UmVkIEhhdCwgSW5jPC92ZW5kb3I+CiAgICAgICA8cGh5c2lkPjk8L3BoeXNpZD4KICAgICAgIDxidXNpbmZvPnBjaUAwMDAwOjAwOjA5LjA8L2J1c2luZm8+CiAgICAgICA8bG9naWNhbG5hbWU+ZW5zOTwvbG9naWNhbG5hbWU+CiAgICAgICA8dmVyc2lvbj4wMDwvdmVyc2lvbj4KICAgICAgIDxzZXJpYWw+NTI6NTQ6MDA6ZTI6ZjE6ZDU8L3NlcmlhbD4KICAgICAgIDx3aWR0aCB1bml0cz0iYml0cyI+NjQ8L3dpZHRoPgogICAgICAgPGNsb2NrIHVuaXRzPSJIeiI+MzMwMDAwMDA8L2Nsb2NrPgogICAgICAgPGNvbmZpZ3VyYXRpb24+CiAgICAgICAgPHNldHRpbmcgaWQ9ImF1dG9uZWdvdGlhdGlvbiIgdmFsdWU9Im9mZiIgLz4KICAgICAgICA8c2V0dGluZyBpZD0iYnJvYWRjYXN0IiB2YWx1ZT0ieWVzIiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXIiIHZhbHVlPSJ2aXJ0aW9fbmV0IiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJkcml2ZXJ2ZXJzaW9uIiB2YWx1ZT0iMS4wLjAiIC8+CiAgICAgICAgPHNldHRpbmcgaWQ9ImxhdGVuY3kiIHZhbHVlPSIwIiAvPgogICAgICAgIDxzZXR0aW5nIGlkPSJsaW5rIiB2YWx1ZT0ibm8iIC8+CiAgICAgICAgPHNldHRpbmcgaWQ9Im11bHRpY2FzdCIgdmFsdWU9InllcyIgLz4KICAgICAgIDwvY29uZmlndXJhdGlvbj4KICAgICAgIDxjYXBhYmlsaXRpZXM+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9Im1zaXgiID5NU0ktWDwvY2FwYWJpbGl0eT4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0iYnVzX21hc3RlciIgPmJ1cyBtYXN0ZXJpbmc8L2NhcGFiaWxpdHk+CiAgICAgICAgPGNhcGFiaWxpdHkgaWQ9ImNhcF9saXN0IiA+UENJIGNhcGFiaWxpdGllcyBsaXN0aW5nPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJyb20iID5leHRlbnNpb24gUk9NPC9jYXBhYmlsaXR5PgogICAgICAgIDxjYXBhYmlsaXR5IGlkPSJldGhlcm5ldCIgLz4KICAgICAgICA8Y2FwYWJpbGl0eSBpZD0icGh5c2ljYWwiID5QaHlzaWNhbCBpbnRlcmZhY2U8L2NhcGFiaWxpdHk+CiAgICAgICA8L2NhcGFiaWxpdGllcz4KICAgICAgIDxyZXNvdXJjZXM+CiAgICAgICAgPHJlc291cmNlIHR5cGU9ImlycSIgdmFsdWU9IjEwIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJpb3BvcnQiIHZhbHVlPSJjMGMwKHNpemU9NjQpIiAvPgogICAgICAgIDxyZXNvdXJjZSB0eXBlPSJtZW1vcnkiIHZhbHVlPSJmZWJkODAwMC1mZWJkOGZmZiIgLz4KICAgICAgICA8cmVzb3VyY2UgdHlwZT0ibWVtb3J5IiB2YWx1ZT0iZmUwMjAwMDAtZmUwMjNmZmYiIC8+CiAgICAgICAgPHJlc291cmNlIHR5cGU9Im1lbW9yeSIgdmFsdWU9ImZlYjgwMDAwLWZlYmJmZmZmIiAvPgogICAgICAgPC9yZXNvdXJjZXM+CiAgICAgIDwvbm9kZT4KICAgIDwvbm9kZT4KICA8L25vZGU+Cjwvbm9kZT4KPC9saXN0Pgo=	2017-08-14 23:10:07.011736+00	\N
4	2017-08-14 23:10:01.648973+00	2017-08-14 23:10:07.312315+00	2	0	00-maas-02-virtuality	cWVtdQo=		""	\N	1	\N	cWVtdQo=	2017-08-14 23:10:07.35464+00	\N
5	2017-08-14 23:10:01.648973+00	2017-08-14 23:10:07.516125+00	2	0	00-maas-04-list-modaliases	YWNwaTpBQ1BJMDAxMDpQTlAwQTA1OgphY3BpOkxOWENQVToKYWNwaTpMTlhQV1JCTjoKYWNwaTpMTlhTWUJVUzoKYWNwaTpMTlhTWVNUTToKYWNwaTpQTlAwMTAzOgphY3BpOlBOUDAzMDM6CmFjcGk6UE5QMDQwMDoKYWNwaTpQTlAwNTAxOgphY3BpOlBOUDA3MDA6CmFjcGk6UE5QMEEwMzoKYWNwaTpQTlAwQTA2OgphY3BpOlBOUDBCMDA6CmFjcGk6UE5QMEMwRjoKYWNwaTpQTlAwRjEzOgphY3BpOlFFTVUwMDAyOgpjcHU6dHlwZTp4ODYsdmVuMDAwMGZhbTAwMDZtb2QwMDVFOmZlYXR1cmU6LDAwMDAsMDAwMSwwMDAyLDAwMDMsMDAwNCwwMDA1LDAwMDYsMDAwNywwMDA4LDAwMDksMDAwQiwwMDBDLDAwMEQsMDAwRSwwMDBGLDAwMTAsMDAxMSwwMDEzLDAwMTcsMDAxOCwwMDE5LDAwMUEsMDAyQiwwMDM0LDAwM0IsMDAzRCwwMDY4LDAwNkYsMDA3MCwwMDcyLDAwNzQsMDA3NSwwMDc2LDAwODAsMDA4MSwwMDg5LDAwOEMsMDA4RCwwMDkxLDAwOTMsMDA5NCwwMDk1LDAwOTYsMDA5NywwMDk4LDAwOTksMDA5QSwwMDlCLDAwOUMsMDA5RCwwMDlFLDAwOUYsMDBDMCwwMEM1LDAwQzgsMDEyMCwwMTIzLDAxMjQsMDEyNSwwMTI3LDAxMjgsMDEyOSwwMTJBLDAxMkIsMDEyRSwwMTMyLDAxMzMsMDEzNCwwMTQwLDAxNDEsMDE0MiwwMUMyCmRtaTpidm5TZWFCSU9TOmJ2cnJlbC0xLjEwLjItMC1nNWY0YzdiMS1wcmVidWlsdC5xZW11LXByb2plY3Qub3JnOmJkMDQvMDEvMjAxNDpzdm5RRU1VOnBuU3RhbmRhcmRQQyhpNDQwRlgrUElJWCwxOTk2KTpwdnJwYy1pNDQwZngtMi45OmN2blFFTVU6Y3QxOmN2cnBjLWk0NDBmeC0yLjk6CmhkYXVkaW86djFBRjQwMDIycjAwMTAwMTAxYTAxCmlucHV0OmIwMDExdjAwMDFwMDAwMWVBQjQxLWUwLDEsNCwxMSwxNCxrNzEsNzIsNzMsNzQsNzUsNzYsNzcsNzksN0EsN0IsN0MsN0QsN0UsN0YsODAsOEMsOEUsOEYsOUIsOUMsOUQsOUUsOUYsQTMsQTQsQTUsQTYsQUMsQUQsQjcsQjgsQjksRDksRTIscmFtNCxsMCwxLDIsc2Z3CmlucHV0OmIwMDExdjAwMDJwMDAwNmUwMDAwLWUwLDEsMixrMTEwLDExMSwxMTIsMTEzLDExNCxyMCwxLDYsOCxhbWxzZncKaW5wdXQ6YjAwMTl2MDAwMHAwMDAxZTAwMDAtZTAsMSxrNzQscmFtbHNmdwpwY2k6djAwMDAxNUFEZDAwMDAwNDA1c3YwMDAwMTVBRHNkMDAwMDA0MDViYzAzc2MwMGkwMApwY2k6djAwMDAxQUY0ZDAwMDAxMDAwc3YwMDAwMUFGNHNkMDAwMDAwMDFiYzAyc2MwMGkwMApwY2k6djAwMDAxQUY0ZDAwMDAxMDAxc3YwMDAwMUFGNHNkMDAwMDAwMDJiYzAxc2MwMGkwMApwY2k6djAwMDAxQUY0ZDAwMDAxMDAyc3YwMDAwMUFGNHNkMDAwMDAwMDViYzAwc2NGRmkwMApwY2k6djAwMDAxQUY0ZDAwMDAxMDAzc3YwMDAwMUFGNHNkMDAwMDAwMDNiYzA3c2M4MGkwMApwY2k6djAwMDA4MDg2ZDAwMDAxMjM3c3YwMDAwMUFGNHNkMDAwMDExMDBiYzA2c2MwMGkwMApwY2k6djAwMDA4MDg2ZDAwMDAyNjY4c3YwMDAwMUFGNHNkMDAwMDExMDBiYzA0c2MwM2kwMApwY2k6djAwMDA4MDg2ZDAwMDAyOTM0c3YwMDAwMUFGNHNkMDAwMDExMDBiYzBDc2MwM2kwMApwY2k6djAwMDA4MDg2ZDAwMDAyOTM1c3YwMDAwMUFGNHNkMDAwMDExMDBiYzBDc2MwM2kwMApwY2k6djAwMDA4MDg2ZDAwMDAyOTM2c3YwMDAwMUFGNHNkMDAwMDExMDBiYzBDc2MwM2kwMApwY2k6djAwMDA4MDg2ZDAwMDAyOTNBc3YwMDAwMUFGNHNkMDAwMDExMDBiYzBDc2MwM2kyMApwY2k6djAwMDA4MDg2ZDAwMDA3MDAwc3YwMDAwMUFGNHNkMDAwMDExMDBiYzA2c2MwMWkwMApwY2k6djAwMDA4MDg2ZDAwMDA3MDEwc3YwMDAwMUFGNHNkMDAwMDExMDBiYzAxc2MwMWk4MApwY2k6djAwMDA4MDg2ZDAwMDA3MTEzc3YwMDAwMUFGNHNkMDAwMDExMDBiYzA2c2M4MGkwMApwbGF0Zm9ybTpGaXhlZCBNRElPIGJ1cwpwbGF0Zm9ybTphbGFybXRpbWVyCnBsYXRmb3JtOmk4MDQyCnBsYXRmb3JtOnBjc3BrcgpwbGF0Zm9ybTpwbGF0Zm9ybS1mcmFtZWJ1ZmZlcgpwbGF0Zm9ybTpyZWctZHVtbXkKcGxhdGZvcm06c2VyaWFsODI1MApzZXJpbzp0eTAxcHIwMGlkMDBleDAwCnNlcmlvOnR5MDZwcjAwaWQwMGV4MDAKdXNiOnYxRDZCcDAwMDFkMDQxMGRjMDlkc2MwMGRwMDBpYzA5aXNjMDBpcDAwaW4wMAp1c2I6djFENkJwMDAwMmQwNDEwZGMwOWRzYzAwZHAwMGljMDlpc2MwMGlwMDBpbjAwCnZpcnRpbzpkMDAwMDAwMDF2MDAwMDFBRjQKdmlydGlvOmQwMDAwMDAwMnYwMDAwMUFGNAp2aXJ0aW86ZDAwMDAwMDAzdjAwMDAxQUY0CnZpcnRpbzpkMDAwMDAwMDV2MDAwMDFBRjQK	ZmluZDogJy9zeXMva2VybmVsL2RlYnVnJzogUGVybWlzc2lvbiBkZW5pZWQKZmluZDogJy9zeXMvZnMvZnVzZS9jb25uZWN0aW9ucy80MSc6IFBlcm1pc3Npb24gZGVuaWVkCg==	""	\N	1	\N	ZmluZDogJy9zeXMva2VybmVsL2RlYnVnJzogUGVybWlzc2lvbiBkZW5pZWQKZmluZDogJy9zeXMvZnMvZnVzZS9jb25uZWN0aW9ucy80MSc6IFBlcm1pc3Npb24gZGVuaWVkCmFjcGk6QUNQSTAwMTA6UE5QMEEwNToKYWNwaTpMTlhDUFU6CmFjcGk6TE5YUFdSQk46CmFjcGk6TE5YU1lCVVM6CmFjcGk6TE5YU1lTVE06CmFjcGk6UE5QMDEwMzoKYWNwaTpQTlAwMzAzOgphY3BpOlBOUDA0MDA6CmFjcGk6UE5QMDUwMToKYWNwaTpQTlAwNzAwOgphY3BpOlBOUDBBMDM6CmFjcGk6UE5QMEEwNjoKYWNwaTpQTlAwQjAwOgphY3BpOlBOUDBDMEY6CmFjcGk6UE5QMEYxMzoKYWNwaTpRRU1VMDAwMjoKY3B1OnR5cGU6eDg2LHZlbjAwMDBmYW0wMDA2bW9kMDA1RTpmZWF0dXJlOiwwMDAwLDAwMDEsMDAwMiwwMDAzLDAwMDQsMDAwNSwwMDA2LDAwMDcsMDAwOCwwMDA5LDAwMEIsMDAwQywwMDBELDAwMEUsMDAwRiwwMDEwLDAwMTEsMDAxMywwMDE3LDAwMTgsMDAxOSwwMDFBLDAwMkIsMDAzNCwwMDNCLDAwM0QsMDA2OCwwMDZGLDAwNzAsMDA3MiwwMDc0LDAwNzUsMDA3NiwwMDgwLDAwODEsMDA4OSwwMDhDLDAwOEQsMDA5MSwwMDkzLDAwOTQsMDA5NSwwMDk2LDAwOTcsMDA5OCwwMDk5LDAwOUEsMDA5QiwwMDlDLDAwOUQsMDA5RSwwMDlGLDAwQzAsMDBDNSwwMEM4LDAxMjAsMDEyMywwMTI0LDAxMjUsMDEyNywwMTI4LDAxMjksMDEyQSwwMTJCLDAxMkUsMDEzMiwwMTMzLDAxMzQsMDE0MCwwMTQxLDAxNDIsMDFDMgpkbWk6YnZuU2VhQklPUzpidnJyZWwtMS4xMC4yLTAtZzVmNGM3YjEtcHJlYnVpbHQucWVtdS1wcm9qZWN0Lm9yZzpiZDA0LzAxLzIwMTQ6c3ZuUUVNVTpwblN0YW5kYXJkUEMoaTQ0MEZYK1BJSVgsMTk5Nik6cHZycGMtaTQ0MGZ4LTIuOTpjdm5RRU1VOmN0MTpjdnJwYy1pNDQwZngtMi45OgpoZGF1ZGlvOnYxQUY0MDAyMnIwMDEwMDEwMWEwMQppbnB1dDpiMDAxMXYwMDAxcDAwMDFlQUI0MS1lMCwxLDQsMTEsMTQsazcxLDcyLDczLDc0LDc1LDc2LDc3LDc5LDdBLDdCLDdDLDdELDdFLDdGLDgwLDhDLDhFLDhGLDlCLDlDLDlELDlFLDlGLEEzLEE0LEE1LEE2LEFDLEFELEI3LEI4LEI5LEQ5LEUyLHJhbTQsbDAsMSwyLHNmdwppbnB1dDpiMDAxMXYwMDAycDAwMDZlMDAwMC1lMCwxLDIsazExMCwxMTEsMTEyLDExMywxMTQscjAsMSw2LDgsYW1sc2Z3CmlucHV0OmIwMDE5djAwMDBwMDAwMWUwMDAwLWUwLDEsazc0LHJhbWxzZncKcGNpOnYwMDAwMTVBRGQwMDAwMDQwNXN2MDAwMDE1QURzZDAwMDAwNDA1YmMwM3NjMDBpMDAKcGNpOnYwMDAwMUFGNGQwMDAwMTAwMHN2MDAwMDFBRjRzZDAwMDAwMDAxYmMwMnNjMDBpMDAKcGNpOnYwMDAwMUFGNGQwMDAwMTAwMXN2MDAwMDFBRjRzZDAwMDAwMDAyYmMwMXNjMDBpMDAKcGNpOnYwMDAwMUFGNGQwMDAwMTAwMnN2MDAwMDFBRjRzZDAwMDAwMDA1YmMwMHNjRkZpMDAKcGNpOnYwMDAwMUFGNGQwMDAwMTAwM3N2MDAwMDFBRjRzZDAwMDAwMDAzYmMwN3NjODBpMDAKcGNpOnYwMDAwODA4NmQwMDAwMTIzN3N2MDAwMDFBRjRzZDAwMDAxMTAwYmMwNnNjMDBpMDAKcGNpOnYwMDAwODA4NmQwMDAwMjY2OHN2MDAwMDFBRjRzZDAwMDAxMTAwYmMwNHNjMDNpMDAKcGNpOnYwMDAwODA4NmQwMDAwMjkzNHN2MDAwMDFBRjRzZDAwMDAxMTAwYmMwQ3NjMDNpMDAKcGNpOnYwMDAwODA4NmQwMDAwMjkzNXN2MDAwMDFBRjRzZDAwMDAxMTAwYmMwQ3NjMDNpMDAKcGNpOnYwMDAwODA4NmQwMDAwMjkzNnN2MDAwMDFBRjRzZDAwMDAxMTAwYmMwQ3NjMDNpMDAKcGNpOnYwMDAwODA4NmQwMDAwMjkzQXN2MDAwMDFBRjRzZDAwMDAxMTAwYmMwQ3NjMDNpMjAKcGNpOnYwMDAwODA4NmQwMDAwNzAwMHN2MDAwMDFBRjRzZDAwMDAxMTAwYmMwNnNjMDFpMDAKcGNpOnYwMDAwODA4NmQwMDAwNzAxMHN2MDAwMDFBRjRzZDAwMDAxMTAwYmMwMXNjMDFpODAKcGNpOnYwMDAwODA4NmQwMDAwNzExM3N2MDAwMDFBRjRzZDAwMDAxMTAwYmMwNnNjODBpMDAKcGxhdGZvcm06Rml4ZWQgTURJTyBidXMKcGxhdGZvcm06YWxhcm10aW1lcgpwbGF0Zm9ybTppODA0MgpwbGF0Zm9ybTpwY3Nwa3IKcGxhdGZvcm06cGxhdGZvcm0tZnJhbWVidWZmZXIKcGxhdGZvcm06cmVnLWR1bW15CnBsYXRmb3JtOnNlcmlhbDgyNTAKc2VyaW86dHkwMXByMDBpZDAwZXgwMApzZXJpbzp0eTA2cHIwMGlkMDBleDAwCnVzYjp2MUQ2QnAwMDAxZDA0MTBkYzA5ZHNjMDBkcDAwaWMwOWlzYzAwaXAwMGluMDAKdXNiOnYxRDZCcDAwMDJkMDQxMGRjMDlkc2MwMGRwMDBpYzA5aXNjMDBpcDAwaW4wMAp2aXJ0aW86ZDAwMDAwMDAxdjAwMDAxQUY0CnZpcnRpbzpkMDAwMDAwMDJ2MDAwMDFBRjQKdmlydGlvOmQwMDAwMDAwM3YwMDAwMUFGNAp2aXJ0aW86ZDAwMDAwMDA1djAwMDAxQUY0Cg==	2017-08-14 23:10:07.550437+00	\N
6	2017-08-14 23:10:01.648973+00	2017-08-14 23:10:07.714521+00	2	0	00-maas-07-block-devices	WwogewogICJNT0RFTCI6ICIiLAogICJNQUo6TUlOIjogIjI1MjowIiwKICAiUk8iOiAiMCIsCiAgIkJMT0NLX1NJWkUiOiAiNDA5NiIsCiAgIlJPVEEiOiAiMSIsCiAgIlBBVEgiOiAiL2Rldi92ZGEiLAogICJTSVpFIjogIjEwNzM3NDE4MjQwIiwKICAiUk0iOiAiMCIsCiAgIk5BTUUiOiAidmRhIgogfQpdCg==		""	\N	1	\N	WwogewogICJNT0RFTCI6ICIiLAogICJNQUo6TUlOIjogIjI1MjowIiwKICAiUk8iOiAiMCIsCiAgIkJMT0NLX1NJWkUiOiAiNDA5NiIsCiAgIlJPVEEiOiAiMSIsCiAgIlBBVEgiOiAiL2Rldi92ZGEiLAogICJTSVpFIjogIjEwNzM3NDE4MjQwIiwKICAiUk0iOiAiMCIsCiAgIk5BTUUiOiAidmRhIgogfQpdCg==	2017-08-14 23:10:07.767117+00	\N
7	2017-08-14 23:10:01.648973+00	2017-08-14 23:10:07.880418+00	2	0	00-maas-08-serial-ports	L3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMxCi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMTAKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMxMQovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzEyCi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMTMKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMxNAovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzE1Ci9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMTYKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMxNwovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzE4Ci9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMTkKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMyCi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMjAKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMyMQovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzIyCi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMjMKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMyNAovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzI1Ci9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMjYKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMyNwovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzI4Ci9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMjkKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMzCi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMzAKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMzMQovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzQKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVM1Ci9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTNgovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzcKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVM4Ci9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTOQovc3lzL2RldmljZXMvcG5wMC8wMDowNC90dHkvdHR5UzAKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L2NvbnNvbGUKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3B0bXgKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MTAKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTExCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkxMgovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MTMKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTE0Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkxNQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MTYKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTE3Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkxOAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MTkKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTIKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTIwCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkyMQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MjIKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTIzCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkyNAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MjUKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTI2Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkyNwovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MjgKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTI5Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkzCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkzMAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MzEKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTMyCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkzMwovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MzQKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTM1Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkzNgovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MzcKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTM4Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkzOQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NDAKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTQxCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk0Mgovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NDMKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTQ0Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk0NQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NDYKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTQ3Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk0OAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NDkKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTUKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTUwCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk1MQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NTIKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTUzCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk1NAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NTUKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTU2Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk1Nwovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NTgKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTU5Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk2Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk2MAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NjEKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTYyCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk2Mwovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5Nwovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5OAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5OQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5cHJpbnRrCg==		""	\N	1	\N	L3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMxCi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMTAKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMxMQovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzEyCi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMTMKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMxNAovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzE1Ci9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMTYKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMxNwovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzE4Ci9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMTkKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMyCi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMjAKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMyMQovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzIyCi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMjMKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMyNAovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzI1Ci9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMjYKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMyNwovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzI4Ci9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMjkKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMzCi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTMzAKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVMzMQovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzQKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVM1Ci9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTNgovc3lzL2RldmljZXMvcGxhdGZvcm0vc2VyaWFsODI1MC90dHkvdHR5UzcKL3N5cy9kZXZpY2VzL3BsYXRmb3JtL3NlcmlhbDgyNTAvdHR5L3R0eVM4Ci9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9zZXJpYWw4MjUwL3R0eS90dHlTOQovc3lzL2RldmljZXMvcG5wMC8wMDowNC90dHkvdHR5UzAKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L2NvbnNvbGUKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3B0bXgKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MTAKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTExCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkxMgovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MTMKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTE0Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkxNQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MTYKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTE3Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkxOAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MTkKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTIKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTIwCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkyMQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MjIKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTIzCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkyNAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MjUKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTI2Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkyNwovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MjgKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTI5Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkzCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkzMAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MzEKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTMyCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkzMwovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MzQKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTM1Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkzNgovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5MzcKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTM4Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHkzOQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NDAKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTQxCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk0Mgovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NDMKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTQ0Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk0NQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NDYKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTQ3Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk0OAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NDkKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTUKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTUwCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk1MQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NTIKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTUzCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk1NAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NTUKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTU2Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk1Nwovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NTgKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTU5Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk2Ci9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk2MAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5NjEKL3N5cy9kZXZpY2VzL3ZpcnR1YWwvdHR5L3R0eTYyCi9zeXMvZGV2aWNlcy92aXJ0dWFsL3R0eS90dHk2Mwovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5Nwovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5OAovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5OQovc3lzL2RldmljZXMvdmlydHVhbC90dHkvdHR5cHJpbnRrCg==	2017-08-14 23:10:07.920283+00	\N
\.


--
-- Name: metadataserver_scriptresult_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('metadataserver_scriptresult_id_seq', 7, true);


--
-- Data for Name: metadataserver_scriptset; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY metadataserver_scriptset (id, last_ping, result_type, node_id, power_state_before_transition) FROM stdin;
1	2017-08-14 23:10:07.962946+00	0	1	unknown
\.


--
-- Name: metadataserver_scriptset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('metadataserver_scriptset_id_seq', 1, true);


--
-- Data for Name: piston3_consumer; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY piston3_consumer (id, name, description, key, secret, status, user_id) FROM stdin;
1	MAAS consumer		X3SBhG6wXt2FFQTrVh		accepted	2
\.


--
-- Name: piston3_consumer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('piston3_consumer_id_seq', 1, true);


--
-- Data for Name: piston3_nonce; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY piston3_nonce (id, token_key, consumer_key, key) FROM stdin;
1			CHECKPOINT#1502752201.977529
2	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	95325239851516120911502752204
3	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	146105839687940406821502752205
4	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	78890938696325637421502752205
5	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	145366124362988886691502752205
6	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	181907071380606908791502752206
7	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	151517974146043786871502752206
8	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	60802974424281445111502752207
9	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	5717434643937700051502752207
10	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	37803717300899814981502752207
11	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	26351500098360094531502752207
12	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	96300353244840524961502752207
13	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	100877065501762137351502752207
14	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	4198016522680701391502752207
15	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	63946259656441294481502752207
16	GGDH9rfxr5wX32DdVv	X3SBhG6wXt2FFQTrVh	103008405016193871591502752207
\.


--
-- Name: piston3_nonce_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('piston3_nonce_id_seq', 16, true);


--
-- Data for Name: piston3_token; Type: TABLE DATA; Schema: public; Owner: maas
--

COPY piston3_token (id, key, secret, verifier, token_type, "timestamp", is_approved, callback, callback_confirmed, consumer_id, user_id) FROM stdin;
1	GGDH9rfxr5wX32DdVv	8yzSxtGSbLCZfU4YKHL532CknxyeEwqv		2	1502752204	t	\N	f	1	2
\.


--
-- Name: piston3_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: maas
--

SELECT pg_catalog.setval('piston3_token_id_seq', 1, true);


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_email_532739e98ad012f2_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_email_532739e98ad012f2_uniq UNIQUE (email);


--
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_user_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_key UNIQUE (user_id, permission_id);


--
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_content_type_app_label_67475fdc4983804c_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_67475fdc4983804c_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: maasserver_blockdevice_node_id_620bd110c287e083_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_blockdevice
    ADD CONSTRAINT maasserver_blockdevice_node_id_620bd110c287e083_uniq UNIQUE (node_id, name);


--
-- Name: maasserver_blockdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_blockdevice
    ADD CONSTRAINT maasserver_blockdevice_pkey PRIMARY KEY (id);


--
-- Name: maasserver_bmc_name_6c0e5302cd8a9079_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bmc
    ADD CONSTRAINT maasserver_bmc_name_6c0e5302cd8a9079_uniq UNIQUE (name);


--
-- Name: maasserver_bmc_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bmc
    ADD CONSTRAINT maasserver_bmc_pkey PRIMARY KEY (id);


--
-- Name: maasserver_bmc_power_type_2847f6b3410c1fe3_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bmc
    ADD CONSTRAINT maasserver_bmc_power_type_2847f6b3410c1fe3_uniq UNIQUE (power_type, power_parameters, ip_address_id);


--
-- Name: maasserver_bmcroutablerackcontrollerrelationship_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bmcroutablerackcontrollerrelationship
    ADD CONSTRAINT maasserver_bmcroutablerackcontrollerrelationship_pkey PRIMARY KEY (id);


--
-- Name: maasserver_bootresource_name_2350a43f97fe3001_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootresource
    ADD CONSTRAINT maasserver_bootresource_name_2350a43f97fe3001_uniq UNIQUE (name, architecture);


--
-- Name: maasserver_bootresource_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootresource
    ADD CONSTRAINT maasserver_bootresource_pkey PRIMARY KEY (id);


--
-- Name: maasserver_bootresourcefi_resource_set_id_2c0bc69dd0c1d51a_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootresourcefile
    ADD CONSTRAINT maasserver_bootresourcefi_resource_set_id_2c0bc69dd0c1d51a_uniq UNIQUE (resource_set_id, filename);


--
-- Name: maasserver_bootresourcefile_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootresourcefile
    ADD CONSTRAINT maasserver_bootresourcefile_pkey PRIMARY KEY (id);


--
-- Name: maasserver_bootresourceset_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootresourceset
    ADD CONSTRAINT maasserver_bootresourceset_pkey PRIMARY KEY (id);


--
-- Name: maasserver_bootresourceset_resource_id_40eedfb937647466_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootresourceset
    ADD CONSTRAINT maasserver_bootresourceset_resource_id_40eedfb937647466_uniq UNIQUE (resource_id, version);


--
-- Name: maasserver_bootsource_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootsource
    ADD CONSTRAINT maasserver_bootsource_pkey PRIMARY KEY (id);


--
-- Name: maasserver_bootsource_url_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootsource
    ADD CONSTRAINT maasserver_bootsource_url_key UNIQUE (url);


--
-- Name: maasserver_bootsourcecache_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootsourcecache
    ADD CONSTRAINT maasserver_bootsourcecache_pkey PRIMARY KEY (id);


--
-- Name: maasserver_bootsourceselec_boot_source_id_521da2844bb18931_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootsourceselection
    ADD CONSTRAINT maasserver_bootsourceselec_boot_source_id_521da2844bb18931_uniq UNIQUE (boot_source_id, os, release);


--
-- Name: maasserver_bootsourceselection_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootsourceselection
    ADD CONSTRAINT maasserver_bootsourceselection_pkey PRIMARY KEY (id);


--
-- Name: maasserver_cacheset_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_cacheset
    ADD CONSTRAINT maasserver_cacheset_pkey PRIMARY KEY (id);


--
-- Name: maasserver_config_name_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_config
    ADD CONSTRAINT maasserver_config_name_key UNIQUE (name);


--
-- Name: maasserver_config_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_config
    ADD CONSTRAINT maasserver_config_pkey PRIMARY KEY (id);


--
-- Name: maasserver_dhcpsnippet_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dhcpsnippet
    ADD CONSTRAINT maasserver_dhcpsnippet_pkey PRIMARY KEY (id);


--
-- Name: maasserver_dnsdata_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnsdata
    ADD CONSTRAINT maasserver_dnsdata_pkey PRIMARY KEY (id);


--
-- Name: maasserver_dnspublication_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnspublication
    ADD CONSTRAINT maasserver_dnspublication_pkey PRIMARY KEY (id);


--
-- Name: maasserver_dnsresource_ip_add_dnsresource_id_staticipaddres_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnsresource_ip_addresses
    ADD CONSTRAINT maasserver_dnsresource_ip_add_dnsresource_id_staticipaddres_key UNIQUE (dnsresource_id, staticipaddress_id);


--
-- Name: maasserver_dnsresource_ip_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnsresource_ip_addresses
    ADD CONSTRAINT maasserver_dnsresource_ip_addresses_pkey PRIMARY KEY (id);


--
-- Name: maasserver_dnsresource_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnsresource
    ADD CONSTRAINT maasserver_dnsresource_pkey PRIMARY KEY (id);


--
-- Name: maasserver_domain_name_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_domain
    ADD CONSTRAINT maasserver_domain_name_key UNIQUE (name);


--
-- Name: maasserver_domain_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_domain
    ADD CONSTRAINT maasserver_domain_pkey PRIMARY KEY (id);


--
-- Name: maasserver_event_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_event
    ADD CONSTRAINT maasserver_event_pkey PRIMARY KEY (id);


--
-- Name: maasserver_eventtype_name_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_eventtype
    ADD CONSTRAINT maasserver_eventtype_name_key UNIQUE (name);


--
-- Name: maasserver_eventtype_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_eventtype
    ADD CONSTRAINT maasserver_eventtype_pkey PRIMARY KEY (id);


--
-- Name: maasserver_fabric_name_2c6cbaff8aa67d61_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_fabric
    ADD CONSTRAINT maasserver_fabric_name_2c6cbaff8aa67d61_uniq UNIQUE (name);


--
-- Name: maasserver_fabric_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_fabric
    ADD CONSTRAINT maasserver_fabric_pkey PRIMARY KEY (id);


--
-- Name: maasserver_fannetwork_name_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_fannetwork
    ADD CONSTRAINT maasserver_fannetwork_name_key UNIQUE (name);


--
-- Name: maasserver_fannetwork_overlay_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_fannetwork
    ADD CONSTRAINT maasserver_fannetwork_overlay_key UNIQUE ("overlay");


--
-- Name: maasserver_fannetwork_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_fannetwork
    ADD CONSTRAINT maasserver_fannetwork_pkey PRIMARY KEY (id);


--
-- Name: maasserver_fannetwork_underlay_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_fannetwork
    ADD CONSTRAINT maasserver_fannetwork_underlay_key UNIQUE (underlay);


--
-- Name: maasserver_filestorage_filename_34f4c5ead899df1f_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filestorage
    ADD CONSTRAINT maasserver_filestorage_filename_34f4c5ead899df1f_uniq UNIQUE (filename, owner_id);


--
-- Name: maasserver_filestorage_key_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filestorage
    ADD CONSTRAINT maasserver_filestorage_key_key UNIQUE (key);


--
-- Name: maasserver_filestorage_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filestorage
    ADD CONSTRAINT maasserver_filestorage_pkey PRIMARY KEY (id);


--
-- Name: maasserver_filesystem_block_device_id_370d2217030320b2_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystem
    ADD CONSTRAINT maasserver_filesystem_block_device_id_370d2217030320b2_uniq UNIQUE (block_device_id, acquired);


--
-- Name: maasserver_filesystem_partition_id_2e7aaace9eb9d1a7_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystem
    ADD CONSTRAINT maasserver_filesystem_partition_id_2e7aaace9eb9d1a7_uniq UNIQUE (partition_id, acquired);


--
-- Name: maasserver_filesystem_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystem
    ADD CONSTRAINT maasserver_filesystem_pkey PRIMARY KEY (id);


--
-- Name: maasserver_filesystemgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystemgroup
    ADD CONSTRAINT maasserver_filesystemgroup_pkey PRIMARY KEY (id);


--
-- Name: maasserver_filesystemgroup_uuid_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystemgroup
    ADD CONSTRAINT maasserver_filesystemgroup_uuid_key UNIQUE (uuid);


--
-- Name: maasserver_interface_ip_addre_interface_id_staticipaddress__key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interface_ip_addresses
    ADD CONSTRAINT maasserver_interface_ip_addre_interface_id_staticipaddress__key UNIQUE (interface_id, staticipaddress_id);


--
-- Name: maasserver_interface_ip_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interface_ip_addresses
    ADD CONSTRAINT maasserver_interface_ip_addresses_pkey PRIMARY KEY (id);


--
-- Name: maasserver_interface_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interface
    ADD CONSTRAINT maasserver_interface_pkey PRIMARY KEY (id);


--
-- Name: maasserver_interfacerelationship_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interfacerelationship
    ADD CONSTRAINT maasserver_interfacerelationship_pkey PRIMARY KEY (id);


--
-- Name: maasserver_iprange_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_iprange
    ADD CONSTRAINT maasserver_iprange_pkey PRIMARY KEY (id);


--
-- Name: maasserver_iscsiblockdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_iscsiblockdevice
    ADD CONSTRAINT maasserver_iscsiblockdevice_pkey PRIMARY KEY (blockdevice_ptr_id);


--
-- Name: maasserver_iscsiblockdevice_target_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_iscsiblockdevice
    ADD CONSTRAINT maasserver_iscsiblockdevice_target_key UNIQUE (target);


--
-- Name: maasserver_keysource_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_keysource
    ADD CONSTRAINT maasserver_keysource_pkey PRIMARY KEY (id);


--
-- Name: maasserver_largefile_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_largefile
    ADD CONSTRAINT maasserver_largefile_pkey PRIMARY KEY (id);


--
-- Name: maasserver_largefile_sha256_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_largefile
    ADD CONSTRAINT maasserver_largefile_sha256_key UNIQUE (sha256);


--
-- Name: maasserver_licensekey_osystem_60cca2b224b2d777_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_licensekey
    ADD CONSTRAINT maasserver_licensekey_osystem_60cca2b224b2d777_uniq UNIQUE (osystem, distro_series);


--
-- Name: maasserver_licensekey_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_licensekey
    ADD CONSTRAINT maasserver_licensekey_pkey PRIMARY KEY (id);


--
-- Name: maasserver_mdns_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_mdns
    ADD CONSTRAINT maasserver_mdns_pkey PRIMARY KEY (id);


--
-- Name: maasserver_neighbour_interface_id_1dba4d2f89748e76_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_neighbour
    ADD CONSTRAINT maasserver_neighbour_interface_id_1dba4d2f89748e76_uniq UNIQUE (interface_id, vid, mac_address, ip);


--
-- Name: maasserver_neighbour_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_neighbour
    ADD CONSTRAINT maasserver_neighbour_pkey PRIMARY KEY (id);


--
-- Name: maasserver_node_dns_process_id_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT maasserver_node_dns_process_id_key UNIQUE (dns_process_id);


--
-- Name: maasserver_node_hostname_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT maasserver_node_hostname_key UNIQUE (hostname);


--
-- Name: maasserver_node_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT maasserver_node_pkey PRIMARY KEY (id);


--
-- Name: maasserver_node_system_id_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT maasserver_node_system_id_key UNIQUE (system_id);


--
-- Name: maasserver_node_tags_node_id_tag_id_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node_tags
    ADD CONSTRAINT maasserver_node_tags_node_id_tag_id_key UNIQUE (node_id, tag_id);


--
-- Name: maasserver_node_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node_tags
    ADD CONSTRAINT maasserver_node_tags_pkey PRIMARY KEY (id);


--
-- Name: maasserver_nodegrouptorackcontroller_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_nodegrouptorackcontroller
    ADD CONSTRAINT maasserver_nodegrouptorackcontroller_pkey PRIMARY KEY (id);


--
-- Name: maasserver_notification_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_notification
    ADD CONSTRAINT maasserver_notification_pkey PRIMARY KEY (id);


--
-- Name: maasserver_notificationdismissal_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_notificationdismissal
    ADD CONSTRAINT maasserver_notificationdismissal_pkey PRIMARY KEY (id);


--
-- Name: maasserver_ownerdata_node_id_6484bb43fe7bcec1_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_ownerdata
    ADD CONSTRAINT maasserver_ownerdata_node_id_6484bb43fe7bcec1_uniq UNIQUE (node_id, key);


--
-- Name: maasserver_ownerdata_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_ownerdata
    ADD CONSTRAINT maasserver_ownerdata_pkey PRIMARY KEY (id);


--
-- Name: maasserver_packagerepository_name_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_packagerepository
    ADD CONSTRAINT maasserver_packagerepository_name_key UNIQUE (name);


--
-- Name: maasserver_packagerepository_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_packagerepository
    ADD CONSTRAINT maasserver_packagerepository_pkey PRIMARY KEY (id);


--
-- Name: maasserver_partition_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_partition
    ADD CONSTRAINT maasserver_partition_pkey PRIMARY KEY (id);


--
-- Name: maasserver_partition_uuid_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_partition
    ADD CONSTRAINT maasserver_partition_uuid_key UNIQUE (uuid);


--
-- Name: maasserver_partitiontable_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_partitiontable
    ADD CONSTRAINT maasserver_partitiontable_pkey PRIMARY KEY (id);


--
-- Name: maasserver_physicalblockdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_physicalblockdevice
    ADD CONSTRAINT maasserver_physicalblockdevice_pkey PRIMARY KEY (blockdevice_ptr_id);


--
-- Name: maasserver_podhints_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_podhints
    ADD CONSTRAINT maasserver_podhints_pkey PRIMARY KEY (id);


--
-- Name: maasserver_podhints_pod_id_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_podhints
    ADD CONSTRAINT maasserver_podhints_pod_id_key UNIQUE (pod_id);


--
-- Name: maasserver_rdns_ip_461beb4f766ff3c0_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_rdns
    ADD CONSTRAINT maasserver_rdns_ip_461beb4f766ff3c0_uniq UNIQUE (ip, observer_id);


--
-- Name: maasserver_rdns_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_rdns
    ADD CONSTRAINT maasserver_rdns_pkey PRIMARY KEY (id);


--
-- Name: maasserver_regioncontrollerpro_process_id_3368058a0b2549b2_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regioncontrollerprocessendpoint
    ADD CONSTRAINT maasserver_regioncontrollerpro_process_id_3368058a0b2549b2_uniq UNIQUE (process_id, address, port);


--
-- Name: maasserver_regioncontrollerproc_region_id_1af0994bfe73898c_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regioncontrollerprocess
    ADD CONSTRAINT maasserver_regioncontrollerproc_region_id_1af0994bfe73898c_uniq UNIQUE (region_id, pid);


--
-- Name: maasserver_regioncontrollerprocess_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regioncontrollerprocess
    ADD CONSTRAINT maasserver_regioncontrollerprocess_pkey PRIMARY KEY (id);


--
-- Name: maasserver_regioncontrollerprocessendpoint_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regioncontrollerprocessendpoint
    ADD CONSTRAINT maasserver_regioncontrollerprocessendpoint_pkey PRIMARY KEY (id);


--
-- Name: maasserver_regionrackrpcconne_endpoint_id_2d4ee829ab3abe36_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regionrackrpcconnection
    ADD CONSTRAINT maasserver_regionrackrpcconne_endpoint_id_2d4ee829ab3abe36_uniq UNIQUE (endpoint_id, rack_controller_id);


--
-- Name: maasserver_regionrackrpcconnection_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regionrackrpcconnection
    ADD CONSTRAINT maasserver_regionrackrpcconnection_pkey PRIMARY KEY (id);


--
-- Name: maasserver_service_node_id_2026628e54bdd7bf_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_service
    ADD CONSTRAINT maasserver_service_node_id_2026628e54bdd7bf_uniq UNIQUE (node_id, name);


--
-- Name: maasserver_service_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_service
    ADD CONSTRAINT maasserver_service_pkey PRIMARY KEY (id);


--
-- Name: maasserver_space_name_10dc0cc4c3faa27_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_space
    ADD CONSTRAINT maasserver_space_name_10dc0cc4c3faa27_uniq UNIQUE (name);


--
-- Name: maasserver_space_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_space
    ADD CONSTRAINT maasserver_space_pkey PRIMARY KEY (id);


--
-- Name: maasserver_sshkey_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_sshkey
    ADD CONSTRAINT maasserver_sshkey_pkey PRIMARY KEY (id);


--
-- Name: maasserver_sshkey_user_id_1b56b5dd5724b134_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_sshkey
    ADD CONSTRAINT maasserver_sshkey_user_id_1b56b5dd5724b134_uniq UNIQUE (user_id, key, keysource_id);


--
-- Name: maasserver_sslkey_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_sslkey
    ADD CONSTRAINT maasserver_sslkey_pkey PRIMARY KEY (id);


--
-- Name: maasserver_sslkey_user_id_1c8ac740e219d40f_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_sslkey
    ADD CONSTRAINT maasserver_sslkey_user_id_1c8ac740e219d40f_uniq UNIQUE (user_id, key);


--
-- Name: maasserver_staticipaddress_alloc_type_138411cf98697975_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_staticipaddress
    ADD CONSTRAINT maasserver_staticipaddress_alloc_type_138411cf98697975_uniq UNIQUE (alloc_type, ip);


--
-- Name: maasserver_staticipaddress_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_staticipaddress
    ADD CONSTRAINT maasserver_staticipaddress_pkey PRIMARY KEY (id);


--
-- Name: maasserver_staticroute_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_staticroute
    ADD CONSTRAINT maasserver_staticroute_pkey PRIMARY KEY (id);


--
-- Name: maasserver_staticroute_source_id_2e7a02175f92c3d7_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_staticroute
    ADD CONSTRAINT maasserver_staticroute_source_id_2e7a02175f92c3d7_uniq UNIQUE (source_id, destination_id, gateway_ip);


--
-- Name: maasserver_subnet_cidr_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_subnet
    ADD CONSTRAINT maasserver_subnet_cidr_key UNIQUE (cidr);


--
-- Name: maasserver_subnet_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_subnet
    ADD CONSTRAINT maasserver_subnet_pkey PRIMARY KEY (id);


--
-- Name: maasserver_tag_name_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_tag
    ADD CONSTRAINT maasserver_tag_name_key UNIQUE (name);


--
-- Name: maasserver_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_tag
    ADD CONSTRAINT maasserver_tag_pkey PRIMARY KEY (id);


--
-- Name: maasserver_template_filename_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_template
    ADD CONSTRAINT maasserver_template_filename_key UNIQUE (filename);


--
-- Name: maasserver_template_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_template
    ADD CONSTRAINT maasserver_template_pkey PRIMARY KEY (id);


--
-- Name: maasserver_userprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_userprofile
    ADD CONSTRAINT maasserver_userprofile_pkey PRIMARY KEY (id);


--
-- Name: maasserver_userprofile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_userprofile
    ADD CONSTRAINT maasserver_userprofile_user_id_key UNIQUE (user_id);


--
-- Name: maasserver_versionedtextfile_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_versionedtextfile
    ADD CONSTRAINT maasserver_versionedtextfile_pkey PRIMARY KEY (id);


--
-- Name: maasserver_virtualblockdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_virtualblockdevice
    ADD CONSTRAINT maasserver_virtualblockdevice_pkey PRIMARY KEY (blockdevice_ptr_id);


--
-- Name: maasserver_virtualblockdevice_uuid_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_virtualblockdevice
    ADD CONSTRAINT maasserver_virtualblockdevice_uuid_key UNIQUE (uuid);


--
-- Name: maasserver_vlan_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_vlan
    ADD CONSTRAINT maasserver_vlan_pkey PRIMARY KEY (id);


--
-- Name: maasserver_vlan_vid_6b09f2513fee938e_uniq; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_vlan
    ADD CONSTRAINT maasserver_vlan_vid_6b09f2513fee938e_uniq UNIQUE (vid, fabric_id);


--
-- Name: maasserver_zone_name_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_zone
    ADD CONSTRAINT maasserver_zone_name_key UNIQUE (name);


--
-- Name: maasserver_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_zone
    ADD CONSTRAINT maasserver_zone_pkey PRIMARY KEY (id);


--
-- Name: metadataserver_nodekey_key_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_nodekey
    ADD CONSTRAINT metadataserver_nodekey_key_key UNIQUE (key);


--
-- Name: metadataserver_nodekey_node_id_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_nodekey
    ADD CONSTRAINT metadataserver_nodekey_node_id_key UNIQUE (node_id);


--
-- Name: metadataserver_nodekey_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_nodekey
    ADD CONSTRAINT metadataserver_nodekey_pkey PRIMARY KEY (id);


--
-- Name: metadataserver_nodekey_token_id_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_nodekey
    ADD CONSTRAINT metadataserver_nodekey_token_id_key UNIQUE (token_id);


--
-- Name: metadataserver_nodeuserdata_node_id_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_nodeuserdata
    ADD CONSTRAINT metadataserver_nodeuserdata_node_id_key UNIQUE (node_id);


--
-- Name: metadataserver_nodeuserdata_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_nodeuserdata
    ADD CONSTRAINT metadataserver_nodeuserdata_pkey PRIMARY KEY (id);


--
-- Name: metadataserver_script_name_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_script
    ADD CONSTRAINT metadataserver_script_name_key UNIQUE (name);


--
-- Name: metadataserver_script_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_script
    ADD CONSTRAINT metadataserver_script_pkey PRIMARY KEY (id);


--
-- Name: metadataserver_script_script_id_key; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_script
    ADD CONSTRAINT metadataserver_script_script_id_key UNIQUE (script_id);


--
-- Name: metadataserver_scriptresult_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_scriptresult
    ADD CONSTRAINT metadataserver_scriptresult_pkey PRIMARY KEY (id);


--
-- Name: metadataserver_scriptset_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_scriptset
    ADD CONSTRAINT metadataserver_scriptset_pkey PRIMARY KEY (id);


--
-- Name: piston3_consumer_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY piston3_consumer
    ADD CONSTRAINT piston3_consumer_pkey PRIMARY KEY (id);


--
-- Name: piston3_nonce_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY piston3_nonce
    ADD CONSTRAINT piston3_nonce_pkey PRIMARY KEY (id);


--
-- Name: piston3_token_pkey; Type: CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY piston3_token
    ADD CONSTRAINT piston3_token_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_7af7f2da16e833aa_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX auth_group_name_7af7f2da16e833aa_like ON auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_0e939a4f; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX auth_group_permissions_0e939a4f ON auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_8373b171; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX auth_group_permissions_8373b171 ON auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_417f1b1c; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX auth_permission_417f1b1c ON auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_0e939a4f; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX auth_user_groups_0e939a4f ON auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_e8701ad4; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX auth_user_groups_e8701ad4 ON auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_8373b171; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX auth_user_user_permissions_8373b171 ON auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_e8701ad4; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX auth_user_user_permissions_e8701ad4 ON auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_338f251ed66dc3d5_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX auth_user_username_338f251ed66dc3d5_like ON auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_session_de54fa62; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX django_session_de54fa62 ON django_session USING btree (expire_date);


--
-- Name: django_session_session_key_320c68599bcae10f_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX django_session_session_key_320c68599bcae10f_like ON django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: maasserver_blockdevice_c693ebc8; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_blockdevice_c693ebc8 ON maasserver_blockdevice USING btree (node_id);


--
-- Name: maasserver_bmc_3af51f48; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_bmc_3af51f48 ON maasserver_bmc USING btree (ip_address_id);


--
-- Name: maasserver_bmcroutablerackcontrollerrelationship_ccba0524; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_bmcroutablerackcontrollerrelationship_ccba0524 ON maasserver_bmcroutablerackcontrollerrelationship USING btree (rack_controller_id);


--
-- Name: maasserver_bmcroutablerackcontrollerrelationship_e182f516; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_bmcroutablerackcontrollerrelationship_e182f516 ON maasserver_bmcroutablerackcontrollerrelationship USING btree (bmc_id);


--
-- Name: maasserver_bootresourcefile_770a4a6a; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_bootresourcefile_770a4a6a ON maasserver_bootresourcefile USING btree (resource_set_id);


--
-- Name: maasserver_bootresourcefile_7deea471; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_bootresourcefile_7deea471 ON maasserver_bootresourcefile USING btree (largefile_id);


--
-- Name: maasserver_bootresourceset_e2f3ef5b; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_bootresourceset_e2f3ef5b ON maasserver_bootresourceset USING btree (resource_id);


--
-- Name: maasserver_bootsource_url_a7ace45d49dc9d8_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_bootsource_url_a7ace45d49dc9d8_like ON maasserver_bootsource USING btree (url varchar_pattern_ops);


--
-- Name: maasserver_bootsourcecache_93d77297; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_bootsourcecache_93d77297 ON maasserver_bootsourcecache USING btree (boot_source_id);


--
-- Name: maasserver_bootsourceselection_93d77297; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_bootsourceselection_93d77297 ON maasserver_bootsourceselection USING btree (boot_source_id);


--
-- Name: maasserver_config_name_3df95d25e18cc141_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_config_name_3df95d25e18cc141_like ON maasserver_config USING btree (name varchar_pattern_ops);


--
-- Name: maasserver_dhcpsnippet_b0304493; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_dhcpsnippet_b0304493 ON maasserver_dhcpsnippet USING btree (value_id);


--
-- Name: maasserver_dhcpsnippet_c693ebc8; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_dhcpsnippet_c693ebc8 ON maasserver_dhcpsnippet USING btree (node_id);


--
-- Name: maasserver_dhcpsnippet_fe866fcb; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_dhcpsnippet_fe866fcb ON maasserver_dhcpsnippet USING btree (subnet_id);


--
-- Name: maasserver_dnsdata_58d0cea5; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_dnsdata_58d0cea5 ON maasserver_dnsdata USING btree (dnsresource_id);


--
-- Name: maasserver_dnsresource_662cbf12; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_dnsresource_662cbf12 ON maasserver_dnsresource USING btree (domain_id);


--
-- Name: maasserver_dnsresource_ip_addresses_58d0cea5; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_dnsresource_ip_addresses_58d0cea5 ON maasserver_dnsresource_ip_addresses USING btree (dnsresource_id);


--
-- Name: maasserver_dnsresource_ip_addresses_7773056d; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_dnsresource_ip_addresses_7773056d ON maasserver_dnsresource_ip_addresses USING btree (staticipaddress_id);


--
-- Name: maasserver_domain_946f3fba; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_domain_946f3fba ON maasserver_domain USING btree (authoritative);


--
-- Name: maasserver_domain_name_13e4d4a871ce89ef_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_domain_name_13e4d4a871ce89ef_like ON maasserver_domain USING btree (name varchar_pattern_ops);


--
-- Name: maasserver_event_94757cae; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_event_94757cae ON maasserver_event USING btree (type_id);


--
-- Name: maasserver_event_c693ebc8; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_event_c693ebc8 ON maasserver_event USING btree (node_id);


--
-- Name: maasserver_event_node_id_9050f7c0babad1d_idx; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_event_node_id_9050f7c0babad1d_idx ON maasserver_event USING btree (node_id, id);


--
-- Name: maasserver_eventtype_c9e9a848; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_eventtype_c9e9a848 ON maasserver_eventtype USING btree (level);


--
-- Name: maasserver_eventtype_name_3a9e92107c358dd8_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_eventtype_name_3a9e92107c358dd8_like ON maasserver_eventtype USING btree (name varchar_pattern_ops);


--
-- Name: maasserver_fannetwork_name_4dec8c84bd65740f_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_fannetwork_name_4dec8c84bd65740f_like ON maasserver_fannetwork USING btree (name varchar_pattern_ops);


--
-- Name: maasserver_filestorage_5e7b1936; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_filestorage_5e7b1936 ON maasserver_filestorage USING btree (owner_id);


--
-- Name: maasserver_filestorage_key_14dd76ee356b0f30_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_filestorage_key_14dd76ee356b0f30_like ON maasserver_filestorage USING btree (key varchar_pattern_ops);


--
-- Name: maasserver_filesystem_2f3347f9; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_filesystem_2f3347f9 ON maasserver_filesystem USING btree (filesystem_group_id);


--
-- Name: maasserver_filesystem_5e15e269; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_filesystem_5e15e269 ON maasserver_filesystem USING btree (block_device_id);


--
-- Name: maasserver_filesystem_c693ebc8; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_filesystem_c693ebc8 ON maasserver_filesystem USING btree (node_id);


--
-- Name: maasserver_filesystem_da479efe; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_filesystem_da479efe ON maasserver_filesystem USING btree (partition_id);


--
-- Name: maasserver_filesystem_f098899f; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_filesystem_f098899f ON maasserver_filesystem USING btree (cache_set_id);


--
-- Name: maasserver_filesystemgroup_f098899f; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_filesystemgroup_f098899f ON maasserver_filesystemgroup USING btree (cache_set_id);


--
-- Name: maasserver_filesystemgroup_uuid_667f85386ad5676e_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_filesystemgroup_uuid_667f85386ad5676e_like ON maasserver_filesystemgroup USING btree (uuid varchar_pattern_ops);


--
-- Name: maasserver_interface_c693ebc8; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_interface_c693ebc8 ON maasserver_interface USING btree (node_id);


--
-- Name: maasserver_interface_cd1dc8b7; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_interface_cd1dc8b7 ON maasserver_interface USING btree (vlan_id);


--
-- Name: maasserver_interface_ip_addresses_7773056d; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_interface_ip_addresses_7773056d ON maasserver_interface_ip_addresses USING btree (staticipaddress_id);


--
-- Name: maasserver_interface_ip_addresses_991706b3; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_interface_ip_addresses_991706b3 ON maasserver_interface_ip_addresses USING btree (interface_id);


--
-- Name: maasserver_interfacerelationship_6be37982; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_interfacerelationship_6be37982 ON maasserver_interfacerelationship USING btree (parent_id);


--
-- Name: maasserver_interfacerelationship_f36263a3; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_interfacerelationship_f36263a3 ON maasserver_interfacerelationship USING btree (child_id);


--
-- Name: maasserver_iprange_e8701ad4; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_iprange_e8701ad4 ON maasserver_iprange USING btree (user_id);


--
-- Name: maasserver_iprange_fe866fcb; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_iprange_fe866fcb ON maasserver_iprange USING btree (subnet_id);


--
-- Name: maasserver_iscsiblockdevice_target_3a8d707f38a232ff_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_iscsiblockdevice_target_3a8d707f38a232ff_like ON maasserver_iscsiblockdevice USING btree (target varchar_pattern_ops);


--
-- Name: maasserver_largefile_sha256_5af8460c9ac2333b_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_largefile_sha256_5af8460c9ac2333b_like ON maasserver_largefile USING btree (sha256 varchar_pattern_ops);


--
-- Name: maasserver_mdns_991706b3; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_mdns_991706b3 ON maasserver_mdns USING btree (interface_id);


--
-- Name: maasserver_neighbour_991706b3; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_neighbour_991706b3 ON maasserver_neighbour USING btree (interface_id);


--
-- Name: maasserver_node_06342dd7; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_06342dd7 ON maasserver_node USING btree (zone_id);


--
-- Name: maasserver_node_3e55af71; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_3e55af71 ON maasserver_node USING btree (current_installation_script_set_id);


--
-- Name: maasserver_node_4eb4a6b7; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_4eb4a6b7 ON maasserver_node USING btree (gateway_link_ipv4_id);


--
-- Name: maasserver_node_55d551ed; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_55d551ed ON maasserver_node USING btree (token_id);


--
-- Name: maasserver_node_5e7b1936; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_5e7b1936 ON maasserver_node USING btree (owner_id);


--
-- Name: maasserver_node_662cbf12; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_662cbf12 ON maasserver_node USING btree (domain_id);


--
-- Name: maasserver_node_6be37982; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_6be37982 ON maasserver_node USING btree (parent_id);


--
-- Name: maasserver_node_888a6f50; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_888a6f50 ON maasserver_node USING btree (boot_interface_id);


--
-- Name: maasserver_node_8f61c804; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_8f61c804 ON maasserver_node USING btree (managing_process_id);


--
-- Name: maasserver_node_98e26801; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_98e26801 ON maasserver_node USING btree (boot_disk_id);


--
-- Name: maasserver_node_c1526556; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_c1526556 ON maasserver_node USING btree (gateway_link_ipv6_id);


--
-- Name: maasserver_node_cfe704b1; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_cfe704b1 ON maasserver_node USING btree (current_commissioning_script_set_id);


--
-- Name: maasserver_node_d139014e; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_d139014e ON maasserver_node USING btree (current_testing_script_set_id);


--
-- Name: maasserver_node_e182f516; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_e182f516 ON maasserver_node USING btree (bmc_id);


--
-- Name: maasserver_node_hostname_5f95ec9af16e0a54_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_hostname_5f95ec9af16e0a54_like ON maasserver_node USING btree (hostname varchar_pattern_ops);


--
-- Name: maasserver_node_system_id_5625f5a47dd7d3ff_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_system_id_5625f5a47dd7d3ff_like ON maasserver_node USING btree (system_id varchar_pattern_ops);


--
-- Name: maasserver_node_tags_76f094bc; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_tags_76f094bc ON maasserver_node_tags USING btree (tag_id);


--
-- Name: maasserver_node_tags_c693ebc8; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_node_tags_c693ebc8 ON maasserver_node_tags USING btree (node_id);


--
-- Name: maasserver_nodegrouptorackcontroller_fe866fcb; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_nodegrouptorackcontroller_fe866fcb ON maasserver_nodegrouptorackcontroller USING btree (subnet_id);


--
-- Name: maasserver_notification_e8701ad4; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_notification_e8701ad4 ON maasserver_notification USING btree (user_id);


--
-- Name: maasserver_notification_ident; Type: INDEX; Schema: public; Owner: maas
--

CREATE UNIQUE INDEX maasserver_notification_ident ON maasserver_notification USING btree (ident) WHERE (ident IS NOT NULL);


--
-- Name: maasserver_notificationdismissal_53fb5b6b; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_notificationdismissal_53fb5b6b ON maasserver_notificationdismissal USING btree (notification_id);


--
-- Name: maasserver_notificationdismissal_e8701ad4; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_notificationdismissal_e8701ad4 ON maasserver_notificationdismissal USING btree (user_id);


--
-- Name: maasserver_ownerdata_c693ebc8; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_ownerdata_c693ebc8 ON maasserver_ownerdata USING btree (node_id);


--
-- Name: maasserver_packagerepository_name_2133ae3a29a1fd72_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_packagerepository_name_2133ae3a29a1fd72_like ON maasserver_packagerepository USING btree (name varchar_pattern_ops);


--
-- Name: maasserver_partition_b3f74362; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_partition_b3f74362 ON maasserver_partition USING btree (partition_table_id);


--
-- Name: maasserver_partition_uuid_229d9d0bb378a9cc_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_partition_uuid_229d9d0bb378a9cc_like ON maasserver_partition USING btree (uuid varchar_pattern_ops);


--
-- Name: maasserver_partitiontable_5e15e269; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_partitiontable_5e15e269 ON maasserver_partitiontable USING btree (block_device_id);


--
-- Name: maasserver_rdns_b5aa8205; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_rdns_b5aa8205 ON maasserver_rdns USING btree (observer_id);


--
-- Name: maasserver_regioncontrollerprocess_0f442f96; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_regioncontrollerprocess_0f442f96 ON maasserver_regioncontrollerprocess USING btree (region_id);


--
-- Name: maasserver_regioncontrollerprocessendpoint_c9cf7ee8; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_regioncontrollerprocessendpoint_c9cf7ee8 ON maasserver_regioncontrollerprocessendpoint USING btree (process_id);


--
-- Name: maasserver_regionrackrpcconnection_955e573e; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_regionrackrpcconnection_955e573e ON maasserver_regionrackrpcconnection USING btree (endpoint_id);


--
-- Name: maasserver_regionrackrpcconnection_ccba0524; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_regionrackrpcconnection_ccba0524 ON maasserver_regionrackrpcconnection USING btree (rack_controller_id);


--
-- Name: maasserver_service_c693ebc8; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_service_c693ebc8 ON maasserver_service USING btree (node_id);


--
-- Name: maasserver_sshkey_ceb61aa3; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_sshkey_ceb61aa3 ON maasserver_sshkey USING btree (keysource_id);


--
-- Name: maasserver_sshkey_e8701ad4; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_sshkey_e8701ad4 ON maasserver_sshkey USING btree (user_id);


--
-- Name: maasserver_sslkey_e8701ad4; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_sslkey_e8701ad4 ON maasserver_sslkey USING btree (user_id);


--
-- Name: maasserver_staticipaddress__discovered_unique; Type: INDEX; Schema: public; Owner: maas
--

CREATE UNIQUE INDEX maasserver_staticipaddress__discovered_unique ON maasserver_staticipaddress USING btree (ip) WHERE (alloc_type <> 6);


--
-- Name: maasserver_staticipaddress_e8701ad4; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_staticipaddress_e8701ad4 ON maasserver_staticipaddress USING btree (user_id);


--
-- Name: maasserver_staticipaddress_fe866fcb; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_staticipaddress_fe866fcb ON maasserver_staticipaddress USING btree (subnet_id);


--
-- Name: maasserver_staticroute_0afd9202; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_staticroute_0afd9202 ON maasserver_staticroute USING btree (source_id);


--
-- Name: maasserver_staticroute_279358a3; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_staticroute_279358a3 ON maasserver_staticroute USING btree (destination_id);


--
-- Name: maasserver_subnet_cd1dc8b7; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_subnet_cd1dc8b7 ON maasserver_subnet USING btree (vlan_id);


--
-- Name: maasserver_tag_name_9a7d8611226b717_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_tag_name_9a7d8611226b717_like ON maasserver_tag USING btree (name varchar_pattern_ops);


--
-- Name: maasserver_template_316e8552; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_template_316e8552 ON maasserver_template USING btree (version_id);


--
-- Name: maasserver_template_9fa167e5; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_template_9fa167e5 ON maasserver_template USING btree (default_version_id);


--
-- Name: maasserver_template_filename_e62574f03123520_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_template_filename_e62574f03123520_like ON maasserver_template USING btree (filename varchar_pattern_ops);


--
-- Name: maasserver_versionedtextfile_5c3aef85; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_versionedtextfile_5c3aef85 ON maasserver_versionedtextfile USING btree (previous_version_id);


--
-- Name: maasserver_virtualblockdevice_2f3347f9; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_virtualblockdevice_2f3347f9 ON maasserver_virtualblockdevice USING btree (filesystem_group_id);


--
-- Name: maasserver_virtualblockdevice_uuid_466eaa9222d256f3_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_virtualblockdevice_uuid_466eaa9222d256f3_like ON maasserver_virtualblockdevice USING btree (uuid varchar_pattern_ops);


--
-- Name: maasserver_vlan_0c4809fb; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_vlan_0c4809fb ON maasserver_vlan USING btree (fabric_id);


--
-- Name: maasserver_vlan_6961fc1b; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_vlan_6961fc1b ON maasserver_vlan USING btree (primary_rack_id);


--
-- Name: maasserver_vlan_84defa73; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_vlan_84defa73 ON maasserver_vlan USING btree (space_id);


--
-- Name: maasserver_vlan_a6b3d502; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_vlan_a6b3d502 ON maasserver_vlan USING btree (secondary_rack_id);


--
-- Name: maasserver_vlan_a8226f8a; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_vlan_a8226f8a ON maasserver_vlan USING btree (relay_vlan_id);


--
-- Name: maasserver_zone_name_6c84641a7e87419f_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX maasserver_zone_name_6c84641a7e87419f_like ON maasserver_zone USING btree (name varchar_pattern_ops);


--
-- Name: metadataserver_nodekey_key_54bcea5c28c9e40e_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX metadataserver_nodekey_key_54bcea5c28c9e40e_like ON metadataserver_nodekey USING btree (key varchar_pattern_ops);


--
-- Name: metadataserver_script_name_49d784e0eee7aa77_like; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX metadataserver_script_name_49d784e0eee7aa77_like ON metadataserver_script USING btree (name varchar_pattern_ops);


--
-- Name: metadataserver_scriptresult_109dfc9e; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX metadataserver_scriptresult_109dfc9e ON metadataserver_scriptresult USING btree (script_version_id);


--
-- Name: metadataserver_scriptresult_a19ff0c0; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX metadataserver_scriptresult_a19ff0c0 ON metadataserver_scriptresult USING btree (script_id);


--
-- Name: metadataserver_scriptresult_fe205b98; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX metadataserver_scriptresult_fe205b98 ON metadataserver_scriptresult USING btree (script_set_id);


--
-- Name: metadataserver_scriptset_c693ebc8; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX metadataserver_scriptset_c693ebc8 ON metadataserver_scriptset USING btree (node_id);


--
-- Name: piston3_consumer_e8701ad4; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX piston3_consumer_e8701ad4 ON piston3_consumer USING btree (user_id);


--
-- Name: piston3_token_1db5a817; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX piston3_token_1db5a817 ON piston3_token USING btree (consumer_id);


--
-- Name: piston3_token_e8701ad4; Type: INDEX; Schema: public; Owner: maas
--

CREATE INDEX piston3_token_e8701ad4 ON piston3_token USING btree (user_id);


--
-- Name: auth_user_user_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER auth_user_user_create_notify AFTER INSERT ON auth_user FOR EACH ROW EXECUTE PROCEDURE user_create_notify();


--
-- Name: auth_user_user_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER auth_user_user_delete_notify AFTER DELETE ON auth_user FOR EACH ROW EXECUTE PROCEDURE user_delete_notify();


--
-- Name: auth_user_user_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER auth_user_user_update_notify AFTER UPDATE ON auth_user FOR EACH ROW EXECUTE PROCEDURE user_update_notify();


--
-- Name: blockdevice_nd_blockdevice_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER blockdevice_nd_blockdevice_link_notify AFTER INSERT ON maasserver_blockdevice FOR EACH ROW EXECUTE PROCEDURE nd_blockdevice_link_notify();


--
-- Name: blockdevice_nd_blockdevice_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER blockdevice_nd_blockdevice_unlink_notify AFTER DELETE ON maasserver_blockdevice FOR EACH ROW EXECUTE PROCEDURE nd_blockdevice_unlink_notify();


--
-- Name: blockdevice_nd_blockdevice_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER blockdevice_nd_blockdevice_update_notify AFTER UPDATE ON maasserver_blockdevice FOR EACH ROW EXECUTE PROCEDURE nd_blockdevice_update_notify();


--
-- Name: bmc_pod_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER bmc_pod_delete_notify AFTER DELETE ON maasserver_bmc FOR EACH ROW EXECUTE PROCEDURE pod_delete_notify();


--
-- Name: bmc_pod_insert_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER bmc_pod_insert_notify AFTER INSERT ON maasserver_bmc FOR EACH ROW EXECUTE PROCEDURE pod_insert_notify();


--
-- Name: bmc_pod_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER bmc_pod_update_notify AFTER UPDATE ON maasserver_bmc FOR EACH ROW EXECUTE PROCEDURE pod_update_notify();


--
-- Name: cacheset_nd_cacheset_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER cacheset_nd_cacheset_link_notify AFTER INSERT ON maasserver_cacheset FOR EACH ROW EXECUTE PROCEDURE nd_cacheset_link_notify();


--
-- Name: cacheset_nd_cacheset_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER cacheset_nd_cacheset_unlink_notify AFTER DELETE ON maasserver_cacheset FOR EACH ROW EXECUTE PROCEDURE nd_cacheset_unlink_notify();


--
-- Name: cacheset_nd_cacheset_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER cacheset_nd_cacheset_update_notify AFTER UPDATE ON maasserver_cacheset FOR EACH ROW EXECUTE PROCEDURE nd_cacheset_update_notify();


--
-- Name: config_config_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER config_config_create_notify AFTER INSERT ON maasserver_config FOR EACH ROW EXECUTE PROCEDURE config_create_notify();


--
-- Name: config_config_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER config_config_delete_notify AFTER DELETE ON maasserver_config FOR EACH ROW EXECUTE PROCEDURE config_delete_notify();


--
-- Name: config_config_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER config_config_update_notify AFTER UPDATE ON maasserver_config FOR EACH ROW EXECUTE PROCEDURE config_update_notify();


--
-- Name: config_sys_dhcp_config_ntp_servers_delete; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER config_sys_dhcp_config_ntp_servers_delete AFTER DELETE ON maasserver_config FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_config_ntp_servers_delete();


--
-- Name: config_sys_dhcp_config_ntp_servers_insert; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER config_sys_dhcp_config_ntp_servers_insert AFTER INSERT ON maasserver_config FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_config_ntp_servers_insert();


--
-- Name: config_sys_dhcp_config_ntp_servers_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER config_sys_dhcp_config_ntp_servers_update AFTER UPDATE ON maasserver_config FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_config_ntp_servers_update();


--
-- Name: config_sys_dns_config_insert; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER config_sys_dns_config_insert AFTER INSERT ON maasserver_config FOR EACH ROW EXECUTE PROCEDURE sys_dns_config_insert();


--
-- Name: config_sys_dns_config_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER config_sys_dns_config_update AFTER UPDATE ON maasserver_config FOR EACH ROW EXECUTE PROCEDURE sys_dns_config_update();


--
-- Name: dhcpsnippet_dhcpsnippet_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dhcpsnippet_dhcpsnippet_create_notify AFTER INSERT ON maasserver_dhcpsnippet FOR EACH ROW EXECUTE PROCEDURE dhcpsnippet_create_notify();


--
-- Name: dhcpsnippet_dhcpsnippet_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dhcpsnippet_dhcpsnippet_delete_notify AFTER DELETE ON maasserver_dhcpsnippet FOR EACH ROW EXECUTE PROCEDURE dhcpsnippet_delete_notify();


--
-- Name: dhcpsnippet_dhcpsnippet_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dhcpsnippet_dhcpsnippet_update_notify AFTER UPDATE ON maasserver_dhcpsnippet FOR EACH ROW EXECUTE PROCEDURE dhcpsnippet_update_notify();


--
-- Name: dhcpsnippet_sys_dhcp_snippet_delete; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dhcpsnippet_sys_dhcp_snippet_delete AFTER DELETE ON maasserver_dhcpsnippet FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_snippet_delete();


--
-- Name: dhcpsnippet_sys_dhcp_snippet_insert; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dhcpsnippet_sys_dhcp_snippet_insert AFTER INSERT ON maasserver_dhcpsnippet FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_snippet_insert();


--
-- Name: dhcpsnippet_sys_dhcp_snippet_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dhcpsnippet_sys_dhcp_snippet_update AFTER UPDATE ON maasserver_dhcpsnippet FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_snippet_update();


--
-- Name: dnsdata_dnsdata_domain_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsdata_dnsdata_domain_delete_notify AFTER DELETE ON maasserver_dnsdata FOR EACH ROW EXECUTE PROCEDURE dnsdata_domain_delete_notify();


--
-- Name: dnsdata_dnsdata_domain_insert_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsdata_dnsdata_domain_insert_notify AFTER INSERT ON maasserver_dnsdata FOR EACH ROW EXECUTE PROCEDURE dnsdata_domain_insert_notify();


--
-- Name: dnsdata_dnsdata_domain_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsdata_dnsdata_domain_update_notify AFTER UPDATE ON maasserver_dnsdata FOR EACH ROW EXECUTE PROCEDURE dnsdata_domain_update_notify();


--
-- Name: dnsdata_sys_dns_dnsdata_delete; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsdata_sys_dns_dnsdata_delete AFTER DELETE ON maasserver_dnsdata FOR EACH ROW EXECUTE PROCEDURE sys_dns_dnsdata_delete();


--
-- Name: dnsdata_sys_dns_dnsdata_insert; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsdata_sys_dns_dnsdata_insert AFTER INSERT ON maasserver_dnsdata FOR EACH ROW EXECUTE PROCEDURE sys_dns_dnsdata_insert();


--
-- Name: dnsdata_sys_dns_dnsdata_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsdata_sys_dns_dnsdata_update AFTER UPDATE ON maasserver_dnsdata FOR EACH ROW EXECUTE PROCEDURE sys_dns_dnsdata_update();


--
-- Name: dnspublication_sys_dns_publish; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnspublication_sys_dns_publish AFTER INSERT ON maasserver_dnspublication FOR EACH ROW EXECUTE PROCEDURE sys_dns_publish();


--
-- Name: dnsresource_dnsresource_domain_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsresource_dnsresource_domain_delete_notify AFTER DELETE ON maasserver_dnsresource FOR EACH ROW EXECUTE PROCEDURE dnsresource_domain_delete_notify();


--
-- Name: dnsresource_dnsresource_domain_insert_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsresource_dnsresource_domain_insert_notify AFTER INSERT ON maasserver_dnsresource FOR EACH ROW EXECUTE PROCEDURE dnsresource_domain_insert_notify();


--
-- Name: dnsresource_dnsresource_domain_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsresource_dnsresource_domain_update_notify AFTER UPDATE ON maasserver_dnsresource FOR EACH ROW EXECUTE PROCEDURE dnsresource_domain_update_notify();


--
-- Name: dnsresource_ip_addresses_rrset_sipaddress_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsresource_ip_addresses_rrset_sipaddress_link_notify AFTER INSERT ON maasserver_dnsresource_ip_addresses FOR EACH ROW EXECUTE PROCEDURE rrset_sipaddress_link_notify();


--
-- Name: dnsresource_ip_addresses_rrset_sipaddress_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsresource_ip_addresses_rrset_sipaddress_unlink_notify AFTER DELETE ON maasserver_dnsresource_ip_addresses FOR EACH ROW EXECUTE PROCEDURE rrset_sipaddress_unlink_notify();


--
-- Name: dnsresource_ip_addresses_sys_dns_dnsresource_ip_link; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsresource_ip_addresses_sys_dns_dnsresource_ip_link AFTER INSERT ON maasserver_dnsresource_ip_addresses FOR EACH ROW EXECUTE PROCEDURE sys_dns_dnsresource_ip_link();


--
-- Name: dnsresource_ip_addresses_sys_dns_dnsresource_ip_unlink; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsresource_ip_addresses_sys_dns_dnsresource_ip_unlink AFTER DELETE ON maasserver_dnsresource_ip_addresses FOR EACH ROW EXECUTE PROCEDURE sys_dns_dnsresource_ip_unlink();


--
-- Name: dnsresource_sys_dns_dnsresource_delete; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsresource_sys_dns_dnsresource_delete AFTER DELETE ON maasserver_dnsresource FOR EACH ROW EXECUTE PROCEDURE sys_dns_dnsresource_delete();


--
-- Name: dnsresource_sys_dns_dnsresource_insert; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsresource_sys_dns_dnsresource_insert AFTER INSERT ON maasserver_dnsresource FOR EACH ROW EXECUTE PROCEDURE sys_dns_dnsresource_insert();


--
-- Name: dnsresource_sys_dns_dnsresource_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER dnsresource_sys_dns_dnsresource_update AFTER UPDATE ON maasserver_dnsresource FOR EACH ROW EXECUTE PROCEDURE sys_dns_dnsresource_update();


--
-- Name: domain_domain_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER domain_domain_create_notify AFTER INSERT ON maasserver_domain FOR EACH ROW EXECUTE PROCEDURE domain_create_notify();


--
-- Name: domain_domain_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER domain_domain_delete_notify AFTER DELETE ON maasserver_domain FOR EACH ROW EXECUTE PROCEDURE domain_delete_notify();


--
-- Name: domain_domain_node_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER domain_domain_node_update_notify AFTER UPDATE ON maasserver_domain FOR EACH ROW EXECUTE PROCEDURE domain_node_update_notify();


--
-- Name: domain_domain_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER domain_domain_update_notify AFTER UPDATE ON maasserver_domain FOR EACH ROW EXECUTE PROCEDURE domain_update_notify();


--
-- Name: domain_sys_dns_domain_delete; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER domain_sys_dns_domain_delete AFTER DELETE ON maasserver_domain FOR EACH ROW EXECUTE PROCEDURE sys_dns_domain_delete();


--
-- Name: domain_sys_dns_domain_insert; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER domain_sys_dns_domain_insert AFTER INSERT ON maasserver_domain FOR EACH ROW EXECUTE PROCEDURE sys_dns_domain_insert();


--
-- Name: domain_sys_dns_domain_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER domain_sys_dns_domain_update AFTER UPDATE ON maasserver_domain FOR EACH ROW EXECUTE PROCEDURE sys_dns_domain_update();


--
-- Name: event_event_create_machine_device_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER event_event_create_machine_device_notify AFTER INSERT ON maasserver_event FOR EACH ROW EXECUTE PROCEDURE event_create_machine_device_notify();


--
-- Name: event_event_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER event_event_create_notify AFTER INSERT ON maasserver_event FOR EACH ROW EXECUTE PROCEDURE event_create_notify();


--
-- Name: fabric_fabric_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER fabric_fabric_create_notify AFTER INSERT ON maasserver_fabric FOR EACH ROW EXECUTE PROCEDURE fabric_create_notify();


--
-- Name: fabric_fabric_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER fabric_fabric_delete_notify AFTER DELETE ON maasserver_fabric FOR EACH ROW EXECUTE PROCEDURE fabric_delete_notify();


--
-- Name: fabric_fabric_machine_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER fabric_fabric_machine_update_notify AFTER UPDATE ON maasserver_fabric FOR EACH ROW EXECUTE PROCEDURE fabric_machine_update_notify();


--
-- Name: fabric_fabric_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER fabric_fabric_update_notify AFTER UPDATE ON maasserver_fabric FOR EACH ROW EXECUTE PROCEDURE fabric_update_notify();


--
-- Name: filesystem_nd_filesystem_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER filesystem_nd_filesystem_link_notify AFTER INSERT ON maasserver_filesystem FOR EACH ROW EXECUTE PROCEDURE nd_filesystem_link_notify();


--
-- Name: filesystem_nd_filesystem_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER filesystem_nd_filesystem_unlink_notify AFTER DELETE ON maasserver_filesystem FOR EACH ROW EXECUTE PROCEDURE nd_filesystem_unlink_notify();


--
-- Name: filesystem_nd_filesystem_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER filesystem_nd_filesystem_update_notify AFTER UPDATE ON maasserver_filesystem FOR EACH ROW EXECUTE PROCEDURE nd_filesystem_update_notify();


--
-- Name: filesystemgroup_nd_filesystemgroup_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER filesystemgroup_nd_filesystemgroup_link_notify AFTER INSERT ON maasserver_filesystemgroup FOR EACH ROW EXECUTE PROCEDURE nd_filesystemgroup_link_notify();


--
-- Name: filesystemgroup_nd_filesystemgroup_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER filesystemgroup_nd_filesystemgroup_unlink_notify AFTER DELETE ON maasserver_filesystemgroup FOR EACH ROW EXECUTE PROCEDURE nd_filesystemgroup_unlink_notify();


--
-- Name: filesystemgroup_nd_filesystemgroup_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER filesystemgroup_nd_filesystemgroup_update_notify AFTER UPDATE ON maasserver_filesystemgroup FOR EACH ROW EXECUTE PROCEDURE nd_filesystemgroup_update_notify();


--
-- Name: interface_ip_addresses_nd_sipaddress_dns_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER interface_ip_addresses_nd_sipaddress_dns_link_notify AFTER INSERT ON maasserver_interface_ip_addresses FOR EACH ROW EXECUTE PROCEDURE nd_sipaddress_dns_link_notify();


--
-- Name: interface_ip_addresses_nd_sipaddress_dns_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER interface_ip_addresses_nd_sipaddress_dns_unlink_notify AFTER DELETE ON maasserver_interface_ip_addresses FOR EACH ROW EXECUTE PROCEDURE nd_sipaddress_dns_unlink_notify();


--
-- Name: interface_ip_addresses_nd_sipaddress_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER interface_ip_addresses_nd_sipaddress_link_notify AFTER INSERT ON maasserver_interface_ip_addresses FOR EACH ROW EXECUTE PROCEDURE nd_sipaddress_link_notify();


--
-- Name: interface_ip_addresses_nd_sipaddress_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER interface_ip_addresses_nd_sipaddress_unlink_notify AFTER DELETE ON maasserver_interface_ip_addresses FOR EACH ROW EXECUTE PROCEDURE nd_sipaddress_unlink_notify();


--
-- Name: interface_ip_addresses_sys_dns_nic_ip_link; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER interface_ip_addresses_sys_dns_nic_ip_link AFTER INSERT ON maasserver_interface_ip_addresses FOR EACH ROW EXECUTE PROCEDURE sys_dns_nic_ip_link();


--
-- Name: interface_ip_addresses_sys_dns_nic_ip_unlink; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER interface_ip_addresses_sys_dns_nic_ip_unlink AFTER DELETE ON maasserver_interface_ip_addresses FOR EACH ROW EXECUTE PROCEDURE sys_dns_nic_ip_unlink();


--
-- Name: interface_nd_interface_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER interface_nd_interface_link_notify AFTER INSERT ON maasserver_interface FOR EACH ROW EXECUTE PROCEDURE nd_interface_link_notify();


--
-- Name: interface_nd_interface_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER interface_nd_interface_unlink_notify AFTER DELETE ON maasserver_interface FOR EACH ROW EXECUTE PROCEDURE nd_interface_unlink_notify();


--
-- Name: interface_nd_interface_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER interface_nd_interface_update_notify AFTER UPDATE ON maasserver_interface FOR EACH ROW EXECUTE PROCEDURE nd_interface_update_notify();


--
-- Name: interface_sys_dhcp_interface_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER interface_sys_dhcp_interface_update AFTER UPDATE ON maasserver_interface FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_interface_update();


--
-- Name: interface_sys_dns_interface_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER interface_sys_dns_interface_update AFTER UPDATE ON maasserver_interface FOR EACH ROW EXECUTE PROCEDURE sys_dns_interface_update();


--
-- Name: iprange_iprange_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER iprange_iprange_create_notify AFTER INSERT ON maasserver_iprange FOR EACH ROW EXECUTE PROCEDURE iprange_create_notify();


--
-- Name: iprange_iprange_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER iprange_iprange_delete_notify AFTER DELETE ON maasserver_iprange FOR EACH ROW EXECUTE PROCEDURE iprange_delete_notify();


--
-- Name: iprange_iprange_subnet_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER iprange_iprange_subnet_delete_notify AFTER DELETE ON maasserver_iprange FOR EACH ROW EXECUTE PROCEDURE iprange_subnet_delete_notify();


--
-- Name: iprange_iprange_subnet_insert_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER iprange_iprange_subnet_insert_notify AFTER INSERT ON maasserver_iprange FOR EACH ROW EXECUTE PROCEDURE iprange_subnet_insert_notify();


--
-- Name: iprange_iprange_subnet_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER iprange_iprange_subnet_update_notify AFTER UPDATE ON maasserver_iprange FOR EACH ROW EXECUTE PROCEDURE iprange_subnet_update_notify();


--
-- Name: iprange_iprange_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER iprange_iprange_update_notify AFTER UPDATE ON maasserver_iprange FOR EACH ROW EXECUTE PROCEDURE iprange_update_notify();


--
-- Name: iprange_sys_dhcp_iprange_delete; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER iprange_sys_dhcp_iprange_delete AFTER DELETE ON maasserver_iprange FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_iprange_delete();


--
-- Name: iprange_sys_dhcp_iprange_insert; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER iprange_sys_dhcp_iprange_insert AFTER INSERT ON maasserver_iprange FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_iprange_insert();


--
-- Name: iprange_sys_dhcp_iprange_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER iprange_sys_dhcp_iprange_update AFTER UPDATE ON maasserver_iprange FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_iprange_update();


--
-- Name: metadataserver_script_script_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER metadataserver_script_script_create_notify AFTER INSERT ON metadataserver_script FOR EACH ROW EXECUTE PROCEDURE script_create_notify();


--
-- Name: metadataserver_script_script_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER metadataserver_script_script_delete_notify AFTER DELETE ON metadataserver_script FOR EACH ROW EXECUTE PROCEDURE script_delete_notify();


--
-- Name: metadataserver_script_script_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER metadataserver_script_script_update_notify AFTER UPDATE ON metadataserver_script FOR EACH ROW EXECUTE PROCEDURE script_update_notify();


--
-- Name: metadataserver_scriptresult_nd_scriptresult_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER metadataserver_scriptresult_nd_scriptresult_link_notify AFTER INSERT ON metadataserver_scriptresult FOR EACH ROW EXECUTE PROCEDURE nd_scriptresult_link_notify();


--
-- Name: metadataserver_scriptresult_nd_scriptresult_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER metadataserver_scriptresult_nd_scriptresult_unlink_notify AFTER DELETE ON metadataserver_scriptresult FOR EACH ROW EXECUTE PROCEDURE nd_scriptresult_unlink_notify();


--
-- Name: metadataserver_scriptresult_nd_scriptresult_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER metadataserver_scriptresult_nd_scriptresult_update_notify AFTER UPDATE ON metadataserver_scriptresult FOR EACH ROW EXECUTE PROCEDURE nd_scriptresult_update_notify();


--
-- Name: metadataserver_scriptset_nd_scriptset_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER metadataserver_scriptset_nd_scriptset_link_notify AFTER INSERT ON metadataserver_scriptset FOR EACH ROW EXECUTE PROCEDURE nd_scriptset_link_notify();


--
-- Name: metadataserver_scriptset_nd_scriptset_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER metadataserver_scriptset_nd_scriptset_unlink_notify AFTER DELETE ON metadataserver_scriptset FOR EACH ROW EXECUTE PROCEDURE nd_scriptset_unlink_notify();


--
-- Name: neighbour_neighbour_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER neighbour_neighbour_create_notify AFTER INSERT ON maasserver_neighbour FOR EACH ROW EXECUTE PROCEDURE neighbour_create_notify();


--
-- Name: neighbour_neighbour_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER neighbour_neighbour_delete_notify AFTER DELETE ON maasserver_neighbour FOR EACH ROW EXECUTE PROCEDURE neighbour_delete_notify();


--
-- Name: neighbour_neighbour_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER neighbour_neighbour_update_notify AFTER UPDATE ON maasserver_neighbour FOR EACH ROW EXECUTE PROCEDURE neighbour_update_notify();


--
-- Name: node_device_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_device_create_notify AFTER INSERT ON maasserver_node FOR EACH ROW WHEN ((new.node_type = 1)) EXECUTE PROCEDURE device_create_notify();


--
-- Name: node_device_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_device_delete_notify AFTER DELETE ON maasserver_node FOR EACH ROW WHEN ((old.node_type = 1)) EXECUTE PROCEDURE device_delete_notify();


--
-- Name: node_device_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_device_update_notify AFTER UPDATE ON maasserver_node FOR EACH ROW WHEN ((new.node_type = 1)) EXECUTE PROCEDURE device_update_notify();


--
-- Name: node_machine_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_machine_create_notify AFTER INSERT ON maasserver_node FOR EACH ROW WHEN ((new.node_type = 0)) EXECUTE PROCEDURE machine_create_notify();


--
-- Name: node_machine_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_machine_delete_notify AFTER DELETE ON maasserver_node FOR EACH ROW WHEN ((old.node_type = 0)) EXECUTE PROCEDURE machine_delete_notify();


--
-- Name: node_machine_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_machine_update_notify AFTER UPDATE ON maasserver_node FOR EACH ROW WHEN ((new.node_type = 0)) EXECUTE PROCEDURE machine_update_notify();


--
-- Name: node_node_pod_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_node_pod_delete_notify AFTER DELETE ON maasserver_node FOR EACH ROW EXECUTE PROCEDURE node_pod_delete_notify();


--
-- Name: node_node_pod_insert_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_node_pod_insert_notify AFTER INSERT ON maasserver_node FOR EACH ROW EXECUTE PROCEDURE node_pod_insert_notify();


--
-- Name: node_node_pod_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_node_pod_update_notify AFTER UPDATE ON maasserver_node FOR EACH ROW EXECUTE PROCEDURE node_pod_update_notify();


--
-- Name: node_node_type_change_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_node_type_change_notify AFTER UPDATE ON maasserver_node FOR EACH ROW EXECUTE PROCEDURE node_type_change_notify();


--
-- Name: node_rack_controller_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_rack_controller_create_notify AFTER INSERT ON maasserver_node FOR EACH ROW WHEN ((new.node_type = 2)) EXECUTE PROCEDURE rack_controller_create_notify();


--
-- Name: node_rack_controller_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_rack_controller_delete_notify AFTER DELETE ON maasserver_node FOR EACH ROW WHEN ((old.node_type = 2)) EXECUTE PROCEDURE rack_controller_delete_notify();


--
-- Name: node_rack_controller_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_rack_controller_update_notify AFTER UPDATE ON maasserver_node FOR EACH ROW WHEN ((new.node_type = 2)) EXECUTE PROCEDURE rack_controller_update_notify();


--
-- Name: node_region_and_rack_controller_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_region_and_rack_controller_create_notify AFTER INSERT ON maasserver_node FOR EACH ROW WHEN ((new.node_type = 4)) EXECUTE PROCEDURE region_and_rack_controller_create_notify();


--
-- Name: node_region_and_rack_controller_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_region_and_rack_controller_delete_notify AFTER DELETE ON maasserver_node FOR EACH ROW WHEN ((old.node_type = 4)) EXECUTE PROCEDURE region_and_rack_controller_delete_notify();


--
-- Name: node_region_and_rack_controller_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_region_and_rack_controller_update_notify AFTER UPDATE ON maasserver_node FOR EACH ROW WHEN ((new.node_type = 4)) EXECUTE PROCEDURE region_and_rack_controller_update_notify();


--
-- Name: node_region_controller_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_region_controller_create_notify AFTER INSERT ON maasserver_node FOR EACH ROW WHEN ((new.node_type = 3)) EXECUTE PROCEDURE region_controller_create_notify();


--
-- Name: node_region_controller_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_region_controller_delete_notify AFTER DELETE ON maasserver_node FOR EACH ROW WHEN ((old.node_type = 3)) EXECUTE PROCEDURE region_controller_delete_notify();


--
-- Name: node_region_controller_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_region_controller_update_notify AFTER UPDATE ON maasserver_node FOR EACH ROW WHEN ((new.node_type = 3)) EXECUTE PROCEDURE region_controller_update_notify();


--
-- Name: node_sys_dhcp_node_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_sys_dhcp_node_update AFTER UPDATE ON maasserver_node FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_node_update();


--
-- Name: node_sys_dns_node_delete; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_sys_dns_node_delete AFTER DELETE ON maasserver_node FOR EACH ROW EXECUTE PROCEDURE sys_dns_node_delete();


--
-- Name: node_sys_dns_node_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_sys_dns_node_update AFTER UPDATE ON maasserver_node FOR EACH ROW EXECUTE PROCEDURE sys_dns_node_update();


--
-- Name: node_tags_machine_device_tag_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_tags_machine_device_tag_link_notify AFTER INSERT ON maasserver_node_tags FOR EACH ROW EXECUTE PROCEDURE machine_device_tag_link_notify();


--
-- Name: node_tags_machine_device_tag_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER node_tags_machine_device_tag_unlink_notify AFTER DELETE ON maasserver_node_tags FOR EACH ROW EXECUTE PROCEDURE machine_device_tag_unlink_notify();


--
-- Name: notification_notification_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER notification_notification_create_notify AFTER INSERT ON maasserver_notification FOR EACH ROW EXECUTE PROCEDURE notification_create_notify();


--
-- Name: notification_notification_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER notification_notification_delete_notify AFTER DELETE ON maasserver_notification FOR EACH ROW EXECUTE PROCEDURE notification_delete_notify();


--
-- Name: notification_notification_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER notification_notification_update_notify AFTER UPDATE ON maasserver_notification FOR EACH ROW EXECUTE PROCEDURE notification_update_notify();


--
-- Name: notificationdismissal_notificationdismissal_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER notificationdismissal_notificationdismissal_create_notify AFTER INSERT ON maasserver_notificationdismissal FOR EACH ROW EXECUTE PROCEDURE notificationdismissal_create_notify();


--
-- Name: packagerepository_packagerepository_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER packagerepository_packagerepository_create_notify AFTER INSERT ON maasserver_packagerepository FOR EACH ROW EXECUTE PROCEDURE packagerepository_create_notify();


--
-- Name: packagerepository_packagerepository_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER packagerepository_packagerepository_delete_notify AFTER DELETE ON maasserver_packagerepository FOR EACH ROW EXECUTE PROCEDURE packagerepository_delete_notify();


--
-- Name: packagerepository_packagerepository_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER packagerepository_packagerepository_update_notify AFTER UPDATE ON maasserver_packagerepository FOR EACH ROW EXECUTE PROCEDURE packagerepository_update_notify();


--
-- Name: partition_nd_partition_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER partition_nd_partition_link_notify AFTER INSERT ON maasserver_partition FOR EACH ROW EXECUTE PROCEDURE nd_partition_link_notify();


--
-- Name: partition_nd_partition_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER partition_nd_partition_unlink_notify AFTER DELETE ON maasserver_partition FOR EACH ROW EXECUTE PROCEDURE nd_partition_unlink_notify();


--
-- Name: partition_nd_partition_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER partition_nd_partition_update_notify AFTER UPDATE ON maasserver_partition FOR EACH ROW EXECUTE PROCEDURE nd_partition_update_notify();


--
-- Name: partitiontable_nd_partitiontable_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER partitiontable_nd_partitiontable_link_notify AFTER INSERT ON maasserver_partitiontable FOR EACH ROW EXECUTE PROCEDURE nd_partitiontable_link_notify();


--
-- Name: partitiontable_nd_partitiontable_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER partitiontable_nd_partitiontable_unlink_notify AFTER DELETE ON maasserver_partitiontable FOR EACH ROW EXECUTE PROCEDURE nd_partitiontable_unlink_notify();


--
-- Name: partitiontable_nd_partitiontable_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER partitiontable_nd_partitiontable_update_notify AFTER UPDATE ON maasserver_partitiontable FOR EACH ROW EXECUTE PROCEDURE nd_partitiontable_update_notify();


--
-- Name: physicalblockdevice_nd_physblockdevice_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER physicalblockdevice_nd_physblockdevice_update_notify AFTER UPDATE ON maasserver_physicalblockdevice FOR EACH ROW EXECUTE PROCEDURE nd_physblockdevice_update_notify();


--
-- Name: regionrackrpcconnection_sys_core_rpc_delete; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER regionrackrpcconnection_sys_core_rpc_delete AFTER DELETE ON maasserver_regionrackrpcconnection FOR EACH ROW EXECUTE PROCEDURE sys_core_rpc_delete();


--
-- Name: regionrackrpcconnection_sys_core_rpc_insert; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER regionrackrpcconnection_sys_core_rpc_insert AFTER INSERT ON maasserver_regionrackrpcconnection FOR EACH ROW EXECUTE PROCEDURE sys_core_rpc_insert();


--
-- Name: service_service_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER service_service_create_notify AFTER INSERT ON maasserver_service FOR EACH ROW EXECUTE PROCEDURE service_create_notify();


--
-- Name: service_service_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER service_service_delete_notify AFTER DELETE ON maasserver_service FOR EACH ROW EXECUTE PROCEDURE service_delete_notify();


--
-- Name: service_service_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER service_service_update_notify AFTER UPDATE ON maasserver_service FOR EACH ROW EXECUTE PROCEDURE service_update_notify();


--
-- Name: space_space_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER space_space_create_notify AFTER INSERT ON maasserver_space FOR EACH ROW EXECUTE PROCEDURE space_create_notify();


--
-- Name: space_space_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER space_space_delete_notify AFTER DELETE ON maasserver_space FOR EACH ROW EXECUTE PROCEDURE space_delete_notify();


--
-- Name: space_space_machine_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER space_space_machine_update_notify AFTER UPDATE ON maasserver_space FOR EACH ROW EXECUTE PROCEDURE space_machine_update_notify();


--
-- Name: space_space_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER space_space_update_notify AFTER UPDATE ON maasserver_space FOR EACH ROW EXECUTE PROCEDURE space_update_notify();


--
-- Name: sshkey_sshkey_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER sshkey_sshkey_create_notify AFTER INSERT ON maasserver_sshkey FOR EACH ROW EXECUTE PROCEDURE sshkey_create_notify();


--
-- Name: sshkey_sshkey_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER sshkey_sshkey_delete_notify AFTER DELETE ON maasserver_sshkey FOR EACH ROW EXECUTE PROCEDURE sshkey_delete_notify();


--
-- Name: sshkey_sshkey_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER sshkey_sshkey_update_notify AFTER UPDATE ON maasserver_sshkey FOR EACH ROW EXECUTE PROCEDURE sshkey_update_notify();


--
-- Name: sshkey_user_sshkey_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER sshkey_user_sshkey_link_notify AFTER INSERT ON maasserver_sshkey FOR EACH ROW EXECUTE PROCEDURE user_sshkey_link_notify();


--
-- Name: sshkey_user_sshkey_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER sshkey_user_sshkey_unlink_notify AFTER DELETE ON maasserver_sshkey FOR EACH ROW EXECUTE PROCEDURE user_sshkey_unlink_notify();


--
-- Name: sslkey_user_sslkey_link_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER sslkey_user_sslkey_link_notify AFTER INSERT ON maasserver_sslkey FOR EACH ROW EXECUTE PROCEDURE user_sslkey_link_notify();


--
-- Name: sslkey_user_sslkey_unlink_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER sslkey_user_sslkey_unlink_notify AFTER DELETE ON maasserver_sslkey FOR EACH ROW EXECUTE PROCEDURE user_sslkey_unlink_notify();


--
-- Name: staticipaddress_ipaddress_domain_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER staticipaddress_ipaddress_domain_delete_notify AFTER DELETE ON maasserver_staticipaddress FOR EACH ROW EXECUTE PROCEDURE ipaddress_domain_delete_notify();


--
-- Name: staticipaddress_ipaddress_domain_insert_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER staticipaddress_ipaddress_domain_insert_notify AFTER INSERT ON maasserver_staticipaddress FOR EACH ROW EXECUTE PROCEDURE ipaddress_domain_insert_notify();


--
-- Name: staticipaddress_ipaddress_domain_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER staticipaddress_ipaddress_domain_update_notify AFTER UPDATE ON maasserver_staticipaddress FOR EACH ROW EXECUTE PROCEDURE ipaddress_domain_update_notify();


--
-- Name: staticipaddress_ipaddress_machine_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER staticipaddress_ipaddress_machine_update_notify AFTER UPDATE ON maasserver_staticipaddress FOR EACH ROW EXECUTE PROCEDURE ipaddress_machine_update_notify();


--
-- Name: staticipaddress_ipaddress_subnet_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER staticipaddress_ipaddress_subnet_update_notify AFTER UPDATE ON maasserver_staticipaddress FOR EACH ROW EXECUTE PROCEDURE ipaddress_subnet_update_notify();


--
-- Name: staticipaddress_sys_dhcp_staticipaddress_delete; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER staticipaddress_sys_dhcp_staticipaddress_delete AFTER DELETE ON maasserver_staticipaddress FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_staticipaddress_delete();


--
-- Name: staticipaddress_sys_dhcp_staticipaddress_insert; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER staticipaddress_sys_dhcp_staticipaddress_insert AFTER INSERT ON maasserver_staticipaddress FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_staticipaddress_insert();


--
-- Name: staticipaddress_sys_dhcp_staticipaddress_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER staticipaddress_sys_dhcp_staticipaddress_update AFTER UPDATE ON maasserver_staticipaddress FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_staticipaddress_update();


--
-- Name: staticipaddress_sys_dns_staticipaddress_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER staticipaddress_sys_dns_staticipaddress_update AFTER UPDATE ON maasserver_staticipaddress FOR EACH ROW EXECUTE PROCEDURE sys_dns_staticipaddress_update();


--
-- Name: staticroute_staticroute_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER staticroute_staticroute_create_notify AFTER INSERT ON maasserver_staticroute FOR EACH ROW EXECUTE PROCEDURE staticroute_create_notify();


--
-- Name: staticroute_staticroute_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER staticroute_staticroute_delete_notify AFTER DELETE ON maasserver_staticroute FOR EACH ROW EXECUTE PROCEDURE staticroute_delete_notify();


--
-- Name: staticroute_staticroute_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER staticroute_staticroute_update_notify AFTER UPDATE ON maasserver_staticroute FOR EACH ROW EXECUTE PROCEDURE staticroute_update_notify();


--
-- Name: subnet_subnet_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER subnet_subnet_create_notify AFTER INSERT ON maasserver_subnet FOR EACH ROW EXECUTE PROCEDURE subnet_create_notify();


--
-- Name: subnet_subnet_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER subnet_subnet_delete_notify AFTER DELETE ON maasserver_subnet FOR EACH ROW EXECUTE PROCEDURE subnet_delete_notify();


--
-- Name: subnet_subnet_machine_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER subnet_subnet_machine_update_notify AFTER UPDATE ON maasserver_subnet FOR EACH ROW EXECUTE PROCEDURE subnet_machine_update_notify();


--
-- Name: subnet_subnet_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER subnet_subnet_update_notify AFTER UPDATE ON maasserver_subnet FOR EACH ROW EXECUTE PROCEDURE subnet_update_notify();


--
-- Name: subnet_sys_dhcp_subnet_delete; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER subnet_sys_dhcp_subnet_delete AFTER DELETE ON maasserver_subnet FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_subnet_delete();


--
-- Name: subnet_sys_dhcp_subnet_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER subnet_sys_dhcp_subnet_update AFTER UPDATE ON maasserver_subnet FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_subnet_update();


--
-- Name: subnet_sys_dns_subnet_delete; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER subnet_sys_dns_subnet_delete AFTER DELETE ON maasserver_subnet FOR EACH ROW EXECUTE PROCEDURE sys_dns_subnet_delete();


--
-- Name: subnet_sys_dns_subnet_insert; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER subnet_sys_dns_subnet_insert AFTER INSERT ON maasserver_subnet FOR EACH ROW EXECUTE PROCEDURE sys_dns_subnet_insert();


--
-- Name: subnet_sys_dns_subnet_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER subnet_sys_dns_subnet_update AFTER UPDATE ON maasserver_subnet FOR EACH ROW EXECUTE PROCEDURE sys_dns_subnet_update();


--
-- Name: subnet_sys_proxy_subnet_delete; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER subnet_sys_proxy_subnet_delete AFTER DELETE ON maasserver_subnet FOR EACH ROW EXECUTE PROCEDURE sys_proxy_subnet_delete();


--
-- Name: subnet_sys_proxy_subnet_insert; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER subnet_sys_proxy_subnet_insert AFTER INSERT ON maasserver_subnet FOR EACH ROW EXECUTE PROCEDURE sys_proxy_subnet_insert();


--
-- Name: subnet_sys_proxy_subnet_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER subnet_sys_proxy_subnet_update AFTER UPDATE ON maasserver_subnet FOR EACH ROW EXECUTE PROCEDURE sys_proxy_subnet_update();


--
-- Name: tag_tag_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER tag_tag_create_notify AFTER INSERT ON maasserver_tag FOR EACH ROW EXECUTE PROCEDURE tag_create_notify();


--
-- Name: tag_tag_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER tag_tag_delete_notify AFTER DELETE ON maasserver_tag FOR EACH ROW EXECUTE PROCEDURE tag_delete_notify();


--
-- Name: tag_tag_update_machine_device_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER tag_tag_update_machine_device_notify AFTER UPDATE ON maasserver_tag FOR EACH ROW EXECUTE PROCEDURE tag_update_machine_device_notify();


--
-- Name: tag_tag_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER tag_tag_update_notify AFTER UPDATE ON maasserver_tag FOR EACH ROW EXECUTE PROCEDURE tag_update_notify();


--
-- Name: virtualblockdevice_nd_virtblockdevice_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER virtualblockdevice_nd_virtblockdevice_update_notify AFTER UPDATE ON maasserver_virtualblockdevice FOR EACH ROW EXECUTE PROCEDURE nd_virtblockdevice_update_notify();


--
-- Name: vlan_sys_dhcp_vlan_update; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER vlan_sys_dhcp_vlan_update AFTER UPDATE ON maasserver_vlan FOR EACH ROW EXECUTE PROCEDURE sys_dhcp_vlan_update();


--
-- Name: vlan_vlan_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER vlan_vlan_create_notify AFTER INSERT ON maasserver_vlan FOR EACH ROW EXECUTE PROCEDURE vlan_create_notify();


--
-- Name: vlan_vlan_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER vlan_vlan_delete_notify AFTER DELETE ON maasserver_vlan FOR EACH ROW EXECUTE PROCEDURE vlan_delete_notify();


--
-- Name: vlan_vlan_machine_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER vlan_vlan_machine_update_notify AFTER UPDATE ON maasserver_vlan FOR EACH ROW EXECUTE PROCEDURE vlan_machine_update_notify();


--
-- Name: vlan_vlan_subnet_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER vlan_vlan_subnet_update_notify AFTER UPDATE ON maasserver_vlan FOR EACH ROW EXECUTE PROCEDURE vlan_subnet_update_notify();


--
-- Name: vlan_vlan_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER vlan_vlan_update_notify AFTER UPDATE ON maasserver_vlan FOR EACH ROW EXECUTE PROCEDURE vlan_update_notify();


--
-- Name: zone_zone_create_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER zone_zone_create_notify AFTER INSERT ON maasserver_zone FOR EACH ROW EXECUTE PROCEDURE zone_create_notify();


--
-- Name: zone_zone_delete_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER zone_zone_delete_notify AFTER DELETE ON maasserver_zone FOR EACH ROW EXECUTE PROCEDURE zone_delete_notify();


--
-- Name: zone_zone_update_notify; Type: TRIGGER; Schema: public; Owner: maas
--

CREATE TRIGGER zone_zone_update_notify AFTER UPDATE ON maasserver_zone FOR EACH ROW EXECUTE PROCEDURE zone_update_notify();


--
-- Name: D14b6f6b370df3d2558669101a12bdc9; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_versionedtextfile
    ADD CONSTRAINT "D14b6f6b370df3d2558669101a12bdc9" FOREIGN KEY (previous_version_id) REFERENCES maasserver_versionedtextfile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D221991baf83eac69753f0ca16e719b4; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT "D221991baf83eac69753f0ca16e719b4" FOREIGN KEY (current_commissioning_script_set_id) REFERENCES metadataserver_scriptset(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D2e53cb5528a561572dd9913435b5a8f; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regionrackrpcconnection
    ADD CONSTRAINT "D2e53cb5528a561572dd9913435b5a8f" FOREIGN KEY (endpoint_id) REFERENCES maasserver_regioncontrollerprocessendpoint(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D2f7ccc692ebc9a4f8ed2c4cf18f57dc; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_scriptresult
    ADD CONSTRAINT "D2f7ccc692ebc9a4f8ed2c4cf18f57dc" FOREIGN KEY (script_version_id) REFERENCES maasserver_versionedtextfile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D3001f6c94e68ff9341688a2544f4632; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_partition
    ADD CONSTRAINT "D3001f6c94e68ff9341688a2544f4632" FOREIGN KEY (partition_table_id) REFERENCES maasserver_partitiontable(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D335545b1bc6099548f31aa41e741d1c; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT "D335545b1bc6099548f31aa41e741d1c" FOREIGN KEY (dns_process_id) REFERENCES maasserver_regioncontrollerprocess(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D50abb731cab08de698bdc51da981dfa; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_physicalblockdevice
    ADD CONSTRAINT "D50abb731cab08de698bdc51da981dfa" FOREIGN KEY (blockdevice_ptr_id) REFERENCES maasserver_blockdevice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D5873b4fb88f7cf37ec8ddf0de697f4f; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regioncontrollerprocessendpoint
    ADD CONSTRAINT "D5873b4fb88f7cf37ec8ddf0de697f4f" FOREIGN KEY (process_id) REFERENCES maasserver_regioncontrollerprocess(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D6a5ccb21566af4a0a31876f1f734dcf; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bmc
    ADD CONSTRAINT "D6a5ccb21566af4a0a31876f1f734dcf" FOREIGN KEY (ip_address_id) REFERENCES maasserver_staticipaddress(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D6dcf9c31ad562fa52e3c36e9c5629d1; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystem
    ADD CONSTRAINT "D6dcf9c31ad562fa52e3c36e9c5629d1" FOREIGN KEY (filesystem_group_id) REFERENCES maasserver_filesystemgroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D720748823026d08fc1c5ff152a14a77; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT "D720748823026d08fc1c5ff152a14a77" FOREIGN KEY (current_installation_script_set_id) REFERENCES metadataserver_scriptset(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D7cf0fea41170fc1abdb98baa6c960e5; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interface_ip_addresses
    ADD CONSTRAINT "D7cf0fea41170fc1abdb98baa6c960e5" FOREIGN KEY (staticipaddress_id) REFERENCES maasserver_staticipaddress(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D82cc49798d203e6d8a04f601776e460; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT "D82cc49798d203e6d8a04f601776e460" FOREIGN KEY (gateway_link_ipv6_id) REFERENCES maasserver_staticipaddress(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D93ddc4b0bc8a32b65562d8590b8d21e; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT "D93ddc4b0bc8a32b65562d8590b8d21e" FOREIGN KEY (current_testing_script_set_id) REFERENCES metadataserver_scriptset(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D9cf7c7591534fd1dc03c5e75556169f; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnsresource_ip_addresses
    ADD CONSTRAINT "D9cf7c7591534fd1dc03c5e75556169f" FOREIGN KEY (staticipaddress_id) REFERENCES maasserver_staticipaddress(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ac8cce83dcbe9b509ffe4bcbfd7a3347; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT ac8cce83dcbe9b509ffe4bcbfd7a3347 FOREIGN KEY (boot_disk_id) REFERENCES maasserver_physicalblockdevice(blockdevice_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_content_type_id_630c3430673171bd_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_content_type_id_630c3430673171bd_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissio_group_id_6a9a54a91e1d859b_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_group_id_6a9a54a91e1d859b_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permission_id_70f243352c6a52eb_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permission_id_70f243352c6a52eb_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user__permission_id_20557292d0ee8d80_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user__permission_id_20557292d0ee8d80_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_group_id_5911bfbbf4a1c181_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_5911bfbbf4a1c181_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_user_id_75f77d5929cd8a70_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_75f77d5929cd8a70_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permiss_user_id_6a051b05b2973141_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permiss_user_id_6a051b05b2973141_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: b0fad31d965a33cc6a5edd7da91e09a9; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT b0fad31d965a33cc6a5edd7da91e09a9 FOREIGN KEY (gateway_link_ipv4_id) REFERENCES maasserver_staticipaddress(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: blockdevice_ptr_id_ac083bb0d2d78e_fk_maasserver_blockdevice_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_iscsiblockdevice
    ADD CONSTRAINT blockdevice_ptr_id_ac083bb0d2d78e_fk_maasserver_blockdevice_id FOREIGN KEY (blockdevice_ptr_id) REFERENCES maasserver_blockdevice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ceabcd59769099c3dcd9ad705c395bfd; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_virtualblockdevice
    ADD CONSTRAINT ceabcd59769099c3dcd9ad705c395bfd FOREIGN KEY (filesystem_group_id) REFERENCES maasserver_filesystemgroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: d59c717a6e438526fc245e37ecfecb02; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT d59c717a6e438526fc245e37ecfecb02 FOREIGN KEY (managing_process_id) REFERENCES maasserver_regioncontrollerprocess(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: d894a93ac134b45a2e92b09d8208b834; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_template
    ADD CONSTRAINT d894a93ac134b45a2e92b09d8208b834 FOREIGN KEY (default_version_id) REFERENCES maasserver_versionedtextfile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: df7a86a198751203791331ce52d60a03; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootresourcefile
    ADD CONSTRAINT df7a86a198751203791331ce52d60a03 FOREIGN KEY (resource_set_id) REFERENCES maasserver_bootresourceset(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fedb1f2c3aeb145ffe5103b96a6b496d; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_virtualblockdevice
    ADD CONSTRAINT fedb1f2c3aeb145ffe5103b96a6b496d FOREIGN KEY (blockdevice_ptr_id) REFERENCES maasserver_blockdevice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: m_block_device_id_1d3b0af9f36398da_fk_maasserver_blockdevice_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_partitiontable
    ADD CONSTRAINT m_block_device_id_1d3b0af9f36398da_fk_maasserver_blockdevice_id FOREIGN KEY (block_device_id) REFERENCES maasserver_blockdevice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: m_block_device_id_648e67ab347c6929_fk_maasserver_blockdevice_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystem
    ADD CONSTRAINT m_block_device_id_648e67ab347c6929_fk_maasserver_blockdevice_id FOREIGN KEY (block_device_id) REFERENCES maasserver_blockdevice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: m_boot_interface_id_3edc5eeccb2a78b0_fk_maasserver_interface_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT m_boot_interface_id_3edc5eeccb2a78b0_fk_maasserver_interface_id FOREIGN KEY (boot_interface_id) REFERENCES maasserver_interface(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: m_script_id_7bfcf616003e46bb_fk_maasserver_versionedtextfile_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_script
    ADD CONSTRAINT m_script_id_7bfcf616003e46bb_fk_maasserver_versionedtextfile_id FOREIGN KEY (script_id) REFERENCES maasserver_versionedtextfile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: m_script_set_id_7e0f8fc2daea0b8a_fk_metadataserver_scriptset_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_scriptresult
    ADD CONSTRAINT m_script_set_id_7e0f8fc2daea0b8a_fk_metadataserver_scriptset_id FOREIGN KEY (script_set_id) REFERENCES metadataserver_scriptset(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ma_dnsresource_id_3afcd62e7d77d943_fk_maasserver_dnsresource_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnsresource_ip_addresses
    ADD CONSTRAINT ma_dnsresource_id_3afcd62e7d77d943_fk_maasserver_dnsresource_id FOREIGN KEY (dnsresource_id) REFERENCES maasserver_dnsresource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ma_dnsresource_id_6db36ac2ec514c64_fk_maasserver_dnsresource_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnsdata
    ADD CONSTRAINT ma_dnsresource_id_6db36ac2ec514c64_fk_maasserver_dnsresource_id FOREIGN KEY (dnsresource_id) REFERENCES maasserver_dnsresource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ma_value_id_6414b9dfcaa6c7ed_fk_maasserver_versionedtextfile_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dhcpsnippet
    ADD CONSTRAINT ma_value_id_6414b9dfcaa6c7ed_fk_maasserver_versionedtextfile_id FOREIGN KEY (value_id) REFERENCES maasserver_versionedtextfile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maa_boot_source_id_22f45d77d1d7dfe9_fk_maasserver_bootsource_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootsourcecache
    ADD CONSTRAINT maa_boot_source_id_22f45d77d1d7dfe9_fk_maasserver_bootsource_id FOREIGN KEY (boot_source_id) REFERENCES maasserver_bootsource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maa_boot_source_id_4d31bb30a338b463_fk_maasserver_bootsource_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootsourceselection
    ADD CONSTRAINT maa_boot_source_id_4d31bb30a338b463_fk_maasserver_bootsource_id FOREIGN KEY (boot_source_id) REFERENCES maasserver_bootsource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maas_resource_id_10335b67c122f3c9_fk_maasserver_bootresource_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootresourceset
    ADD CONSTRAINT maas_resource_id_10335b67c122f3c9_fk_maasserver_bootresource_id FOREIGN KEY (resource_id) REFERENCES maasserver_bootresource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maass_rack_controller_id_6ef5a263197c4d26_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bmcroutablerackcontrollerrelationship
    ADD CONSTRAINT maass_rack_controller_id_6ef5a263197c4d26_fk_maasserver_node_id FOREIGN KEY (rack_controller_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasse_interface_id_1c3b008d0a7801d1_fk_maasserver_interface_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_neighbour
    ADD CONSTRAINT maasse_interface_id_1c3b008d0a7801d1_fk_maasserver_interface_id FOREIGN KEY (interface_id) REFERENCES maasserver_interface(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasse_interface_id_5b1357376091f8e7_fk_maasserver_interface_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_mdns
    ADD CONSTRAINT maasse_interface_id_5b1357376091f8e7_fk_maasserver_interface_id FOREIGN KEY (interface_id) REFERENCES maasserver_interface(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasse_keysource_id_4415137aa95e837a_fk_maasserver_keysource_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_sshkey
    ADD CONSTRAINT maasse_keysource_id_4415137aa95e837a_fk_maasserver_keysource_id FOREIGN KEY (keysource_id) REFERENCES maasserver_keysource(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasse_largefile_id_4f193e8e3cc48437_fk_maasserver_largefile_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bootresourcefile
    ADD CONSTRAINT maasse_largefile_id_4f193e8e3cc48437_fk_maasserver_largefile_id FOREIGN KEY (largefile_id) REFERENCES maasserver_largefile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasse_rack_controller_id_2cc6aafaca4791a_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regionrackrpcconnection
    ADD CONSTRAINT maasse_rack_controller_id_2cc6aafaca4791a_fk_maasserver_node_id FOREIGN KEY (rack_controller_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasse_secondary_rack_id_474f4eddc1893bbe_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_vlan
    ADD CONSTRAINT maasse_secondary_rack_id_474f4eddc1893bbe_fk_maasserver_node_id FOREIGN KEY (secondary_rack_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasser_cache_set_id_199f4f699b5b98b5_fk_maasserver_cacheset_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystem
    ADD CONSTRAINT maasser_cache_set_id_199f4f699b5b98b5_fk_maasserver_cacheset_id FOREIGN KEY (cache_set_id) REFERENCES maasserver_cacheset(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasser_destination_id_2416790f7ea08492_fk_maasserver_subnet_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_staticroute
    ADD CONSTRAINT maasser_destination_id_2416790f7ea08492_fk_maasserver_subnet_id FOREIGN KEY (destination_id) REFERENCES maasserver_subnet(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasser_interface_id_574b71d5e99a3ca_fk_maasserver_interface_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interface_ip_addresses
    ADD CONSTRAINT maasser_interface_id_574b71d5e99a3ca_fk_maasserver_interface_id FOREIGN KEY (interface_id) REFERENCES maasserver_interface(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasser_partition_id_f3d1471c9fe64da_fk_maasserver_partition_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystem
    ADD CONSTRAINT maasser_partition_id_f3d1471c9fe64da_fk_maasserver_partition_id FOREIGN KEY (partition_id) REFERENCES maasserver_partition(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserv_cache_set_id_eab28cf44e920b1_fk_maasserver_cacheset_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystemgroup
    ADD CONSTRAINT maasserv_cache_set_id_eab28cf44e920b1_fk_maasserver_cacheset_id FOREIGN KEY (cache_set_id) REFERENCES maasserver_cacheset(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserv_primary_rack_id_60fcfcb4a3301ff6_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_vlan
    ADD CONSTRAINT maasserv_primary_rack_id_60fcfcb4a3301ff6_fk_maasserver_node_id FOREIGN KEY (primary_rack_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserve_parent_id_5d0e38b30e845849_fk_maasserver_interface_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interfacerelationship
    ADD CONSTRAINT maasserve_parent_id_5d0e38b30e845849_fk_maasserver_interface_id FOREIGN KEY (parent_id) REFERENCES maasserver_interface(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver__child_id_e911519fc16bb34_fk_maasserver_interface_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interfacerelationship
    ADD CONSTRAINT maasserver__child_id_e911519fc16bb34_fk_maasserver_interface_id FOREIGN KEY (child_id) REFERENCES maasserver_interface(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver__type_id_159274730f1edf24_fk_maasserver_eventtype_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_event
    ADD CONSTRAINT maasserver__type_id_159274730f1edf24_fk_maasserver_eventtype_id FOREIGN KEY (type_id) REFERENCES maasserver_eventtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_blockde_node_id_54d721ef7639a2_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_blockdevice
    ADD CONSTRAINT maasserver_blockde_node_id_54d721ef7639a2_fk_maasserver_node_id FOREIGN KEY (node_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_bmcrout_bmc_id_2ead1eccaba02e82_fk_maasserver_bmc_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_bmcroutablerackcontrollerrelationship
    ADD CONSTRAINT maasserver_bmcrout_bmc_id_2ead1eccaba02e82_fk_maasserver_bmc_id FOREIGN KEY (bmc_id) REFERENCES maasserver_bmc(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_d_domain_id_6905657a41cf6b2f_fk_maasserver_domain_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dnsresource
    ADD CONSTRAINT maasserver_d_domain_id_6905657a41cf6b2f_fk_maasserver_domain_id FOREIGN KEY (domain_id) REFERENCES maasserver_domain(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_d_subnet_id_57fab4e0443a1223_fk_maasserver_subnet_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dhcpsnippet
    ADD CONSTRAINT maasserver_d_subnet_id_57fab4e0443a1223_fk_maasserver_subnet_id FOREIGN KEY (subnet_id) REFERENCES maasserver_subnet(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_dhcpsn_node_id_7440a8ce2624d0d_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_dhcpsnippet
    ADD CONSTRAINT maasserver_dhcpsn_node_id_7440a8ce2624d0d_fk_maasserver_node_id FOREIGN KEY (node_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_event_node_id_6bb442a9f6cd453_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_event
    ADD CONSTRAINT maasserver_event_node_id_6bb442a9f6cd453_fk_maasserver_node_id FOREIGN KEY (node_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_files_node_id_3ed8e401b641fad7_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filesystem
    ADD CONSTRAINT maasserver_files_node_id_3ed8e401b641fad7_fk_maasserver_node_id FOREIGN KEY (node_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_filestorag_owner_id_6f918f56f8544259_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_filestorage
    ADD CONSTRAINT maasserver_filestorag_owner_id_6f918f56f8544259_fk_auth_user_id FOREIGN KEY (owner_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_i_subnet_id_4ff75d8d3a76c752_fk_maasserver_subnet_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_iprange
    ADD CONSTRAINT maasserver_i_subnet_id_4ff75d8d3a76c752_fk_maasserver_subnet_id FOREIGN KEY (subnet_id) REFERENCES maasserver_subnet(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_inter_node_id_18d320af406b15fb_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interface
    ADD CONSTRAINT maasserver_inter_node_id_18d320af406b15fb_fk_maasserver_node_id FOREIGN KEY (node_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_inter_vlan_id_6c4943f4415130d0_fk_maasserver_vlan_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_interface
    ADD CONSTRAINT maasserver_inter_vlan_id_6c4943f4415130d0_fk_maasserver_vlan_id FOREIGN KEY (vlan_id) REFERENCES maasserver_vlan(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_iprange_user_id_1ab71d4b12fa1e81_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_iprange
    ADD CONSTRAINT maasserver_iprange_user_id_1ab71d4b12fa1e81_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_n_domain_id_79d8a7617bd37d27_fk_maasserver_domain_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT maasserver_n_domain_id_79d8a7617bd37d27_fk_maasserver_domain_id FOREIGN KEY (domain_id) REFERENCES maasserver_domain(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_no_subnet_id_bd891006cb9ee7f_fk_maasserver_subnet_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_nodegrouptorackcontroller
    ADD CONSTRAINT maasserver_no_subnet_id_bd891006cb9ee7f_fk_maasserver_subnet_id FOREIGN KEY (subnet_id) REFERENCES maasserver_subnet(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_nod_parent_id_7b2ca7cd523a083f_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT maasserver_nod_parent_id_7b2ca7cd523a083f_fk_maasserver_node_id FOREIGN KEY (parent_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_node__node_id_69c55140de3a6850_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node_tags
    ADD CONSTRAINT maasserver_node__node_id_69c55140de3a6850_fk_maasserver_node_id FOREIGN KEY (node_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_node_bmc_id_3597b26907baf494_fk_maasserver_bmc_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT maasserver_node_bmc_id_3597b26907baf494_fk_maasserver_bmc_id FOREIGN KEY (bmc_id) REFERENCES maasserver_bmc(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_node_owner_id_4f48b1deea2e46e5_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT maasserver_node_owner_id_4f48b1deea2e46e5_fk_auth_user_id FOREIGN KEY (owner_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_node_ta_tag_id_65f62b366124cb2e_fk_maasserver_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node_tags
    ADD CONSTRAINT maasserver_node_ta_tag_id_65f62b366124cb2e_fk_maasserver_tag_id FOREIGN KEY (tag_id) REFERENCES maasserver_tag(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_node_token_id_7849cdcfdcf7e4e6_fk_piston3_token_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT maasserver_node_token_id_7849cdcfdcf7e4e6_fk_piston3_token_id FOREIGN KEY (token_id) REFERENCES piston3_token(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_node_zone_id_3e7c7a5c63753d5a_fk_maasserver_zone_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_node
    ADD CONSTRAINT maasserver_node_zone_id_3e7c7a5c63753d5a_fk_maasserver_zone_id FOREIGN KEY (zone_id) REFERENCES maasserver_zone(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_notificatio_user_id_2565bd3cb9ec5ce9_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_notification
    ADD CONSTRAINT maasserver_notificatio_user_id_2565bd3cb9ec5ce9_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_notificatio_user_id_4e1cf9a7abb40d81_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_notificationdismissal
    ADD CONSTRAINT maasserver_notificatio_user_id_4e1cf9a7abb40d81_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_owner_node_id_324060b5aed52d4f_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_ownerdata
    ADD CONSTRAINT maasserver_owner_node_id_324060b5aed52d4f_fk_maasserver_node_id FOREIGN KEY (node_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_podhint_pod_id_62e4460a877d0031_fk_maasserver_bmc_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_podhints
    ADD CONSTRAINT maasserver_podhint_pod_id_62e4460a877d0031_fk_maasserver_bmc_id FOREIGN KEY (pod_id) REFERENCES maasserver_bmc(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_r_observer_id_178d1d87234cc93b_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_rdns
    ADD CONSTRAINT maasserver_r_observer_id_178d1d87234cc93b_fk_maasserver_node_id FOREIGN KEY (observer_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_reg_region_id_260f00cba1904298_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_regioncontrollerprocess
    ADD CONSTRAINT maasserver_reg_region_id_260f00cba1904298_fk_maasserver_node_id FOREIGN KEY (region_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_relay_vlan_id_13a827ec02e93f91_fk_maasserver_vlan_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_vlan
    ADD CONSTRAINT maasserver_relay_vlan_id_13a827ec02e93f91_fk_maasserver_vlan_id FOREIGN KEY (relay_vlan_id) REFERENCES maasserver_vlan(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_s_source_id_1fe5356646f57368_fk_maasserver_subnet_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_staticroute
    ADD CONSTRAINT maasserver_s_source_id_1fe5356646f57368_fk_maasserver_subnet_id FOREIGN KEY (source_id) REFERENCES maasserver_subnet(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_servi_node_id_79bbfeb0180395b2_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_service
    ADD CONSTRAINT maasserver_servi_node_id_79bbfeb0180395b2_fk_maasserver_node_id FOREIGN KEY (node_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_sshkey_user_id_359c3b39e467fc71_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_sshkey
    ADD CONSTRAINT maasserver_sshkey_user_id_359c3b39e467fc71_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_sslkey_user_id_3595ec5ddff9cd21_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_sslkey
    ADD CONSTRAINT maasserver_sslkey_user_id_3595ec5ddff9cd21_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_st_subnet_id_ea814533e8f44ad_fk_maasserver_subnet_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_staticipaddress
    ADD CONSTRAINT maasserver_st_subnet_id_ea814533e8f44ad_fk_maasserver_subnet_id FOREIGN KEY (subnet_id) REFERENCES maasserver_subnet(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_staticipadd_user_id_5f11f5257227fa0c_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_staticipaddress
    ADD CONSTRAINT maasserver_staticipadd_user_id_5f11f5257227fa0c_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_subne_vlan_id_679f06cc4cb8854a_fk_maasserver_vlan_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_subnet
    ADD CONSTRAINT maasserver_subne_vlan_id_679f06cc4cb8854a_fk_maasserver_vlan_id FOREIGN KEY (vlan_id) REFERENCES maasserver_vlan(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_userprofile_user_id_33970c143ad19ad9_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_userprofile
    ADD CONSTRAINT maasserver_userprofile_user_id_33970c143ad19ad9_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_vl_fabric_id_db1ba6e0318603c_fk_maasserver_fabric_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_vlan
    ADD CONSTRAINT maasserver_vl_fabric_id_db1ba6e0318603c_fk_maasserver_fabric_id FOREIGN KEY (fabric_id) REFERENCES maasserver_fabric(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: maasserver_vla_space_id_2e9db887855c3548_fk_maasserver_space_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_vlan
    ADD CONSTRAINT maasserver_vla_space_id_2e9db887855c3548_fk_maasserver_space_id FOREIGN KEY (space_id) REFERENCES maasserver_space(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: metadata_script_id_1f9716e4d38a9c75_fk_metadataserver_script_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_scriptresult
    ADD CONSTRAINT metadata_script_id_1f9716e4d38a9c75_fk_metadataserver_script_id FOREIGN KEY (script_id) REFERENCES metadataserver_script(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: metadataserver_n_node_id_1339caf33a0f4d78_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_nodekey
    ADD CONSTRAINT metadataserver_n_node_id_1339caf33a0f4d78_fk_maasserver_node_id FOREIGN KEY (node_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: metadataserver_no_node_id_8b31f87a1ee0e37_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_nodeuserdata
    ADD CONSTRAINT metadataserver_no_node_id_8b31f87a1ee0e37_fk_maasserver_node_id FOREIGN KEY (node_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: metadataserver_no_token_id_4327019ed696175e_fk_piston3_token_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_nodekey
    ADD CONSTRAINT metadataserver_no_token_id_4327019ed696175e_fk_piston3_token_id FOREIGN KEY (token_id) REFERENCES piston3_token(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: metadataserver_s_node_id_1d7b603ce100dc96_fk_maasserver_node_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY metadataserver_scriptset
    ADD CONSTRAINT metadataserver_s_node_id_1d7b603ce100dc96_fk_maasserver_node_id FOREIGN KEY (node_id) REFERENCES maasserver_node(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notification_id_6c8ade2ad9b0aebd_fk_maasserver_notification_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_notificationdismissal
    ADD CONSTRAINT notification_id_6c8ade2ad9b0aebd_fk_maasserver_notification_id FOREIGN KEY (notification_id) REFERENCES maasserver_notification(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: piston3_consumer_user_id_64b2fc0f3a84b2e_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY piston3_consumer
    ADD CONSTRAINT piston3_consumer_user_id_64b2fc0f3a84b2e_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: piston3_tok_consumer_id_6e274ef8022860d2_fk_piston3_consumer_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY piston3_token
    ADD CONSTRAINT piston3_tok_consumer_id_6e274ef8022860d2_fk_piston3_consumer_id FOREIGN KEY (consumer_id) REFERENCES piston3_consumer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: piston3_token_user_id_90e0612f0d0f4f4_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY piston3_token
    ADD CONSTRAINT piston3_token_user_id_90e0612f0d0f4f4_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: version_id_7805cca72f6d62e0_fk_maasserver_versionedtextfile_id; Type: FK CONSTRAINT; Schema: public; Owner: maas
--

ALTER TABLE ONLY maasserver_template
    ADD CONSTRAINT version_id_7805cca72f6d62e0_fk_maasserver_versionedtextfile_id FOREIGN KEY (version_id) REFERENCES maasserver_versionedtextfile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

