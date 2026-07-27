#!/usr/bin/env node
const dns = require('dns').promises;
const net = require('net');

// Direct WHOIS lookup via TCP socket (port 43)
// Comprehensive lookup table for popular gTLDs, ccTLDs, and IDNs
const WHOIS_SERVERS = {
  // Legacy gTLDs
  'com': 'whois.verisign-grs.com',
  'net': 'whois.verisign-grs.com',
  'org': 'whois.publicinterestregistry.org',
  'info': 'whois.afilias.net',
  'biz': 'whois.nic.biz',
  'mobi': 'whois.nic.mobi',
  'pro': 'whois.nic.pro',

  // Google TLDs
  'dev': 'whois.nic.google',
  'app': 'whois.nic.google',
  'page': 'whois.nic.google',
  'how': 'whois.nic.google',

  // Popular New gTLDs
  'xyz': 'whois.nic.xyz',
  'online': 'whois.nic.online',
  'site': 'whois.nic.site',
  'tech': 'whois.nic.tech',
  'store': 'whois.nic.store',
  'club': 'whois.nic.club',
  'shop': 'whois.nic.shop',
  'top': 'whois.nic.top',
  'vip': 'whois.nic.vip',

  // Russia & Legacy Soviet Union
  'ru': 'whois.tcinet.ru',
  'xn--p1ai': 'whois.tcinet.ru', // .рф
  'su': 'whois.tcinet.ru',

  // Ukraine
  'ua': 'whois.ua',
  'xn--j1amh': 'whois.ua', // .укр

  // Belarus
  'by': 'whois.cctld.by',
  'xn--90ais': 'whois.cctld.by', // .бел

  // Moldova
  'md': 'whois.nic.md',

  // Central Asia
  'kz': 'whois.nic.kz',
  'xn--80asehdb': 'whois.nic.kz', // .қаз
  'uz': 'whois.cctld.uz',
  'kg': 'whois.domain.kg',
  'tj': 'whois.nic.tj',
  'tm': 'whois.nic.tm',

  // Caucasus
  'am': 'whois.amnic.net',
  'xn--y9a3aq': 'whois.amnic.net', // .хай
  'ge': 'whois.nic.ge',
  'az': 'whois.az',

  // Baltic States
  'lt': 'whois.domreg.lt',
  'lv': 'whois.nic.lv',
  'ee': 'whois.tld.ee',

  // Popular ccTLDs & IDNs
  'rf': 'whois.tcinet.ru',
  'uk': 'whois.nic.uk',
  'co.uk': 'whois.nic.uk',
  'de': 'whois.denic.de',
  'fr': 'whois.nic.fr',
  'it': 'whois.nic.it',
  'nl': 'whois.sidn.nl',
  'eu': 'whois.eu',
  'ch': 'whois.nic.ch',
  'es': 'whois.nic.es',
  'ca': 'whois.cira.ca',
  'us': 'whois.nic.us',
  'co': 'whois.nic.co',
  'io': 'whois.nic.io',
  'me': 'whois.nic.me',
  'tv': 'tvwhois.verisign-grs.com',
  'ai': 'whois.nic.ai',
  'au': 'whois.auda.org.au',
  'cn': 'whois.cnnic.cn',
  'jp': 'whois.jprs.jp',
  'in': 'whois.registry.in'
};

/**
 * Resolves the WHOIS server for a given domain.
 * 1. Checks local fast-path dictionary.
 * 2. Dynamically queries IANA root server for unknown TLDs.
 */
async function getWhoisServer(domain) {
  const parts = domain.toLowerCase().split('.');
  if (parts.length < 2) return 'whois.iana.org';

  const tld = parts.slice(-1)[0];
  const twoPartTld = parts.slice(-2).join('.');

  // Step 1: Fast local dictionary lookup
  if (WHOIS_SERVERS[twoPartTld]) return WHOIS_SERVERS[twoPartTld];
  if (WHOIS_SERVERS[tld]) return WHOIS_SERVERS[tld];

  // Step 2: Dynamic lookup via IANA for unknown TLDs
  try {
    const ianaData = await queryWhois(tld, 'whois.iana.org');
    const match = ianaData.match(/(?:refer|whois):\s*([^\s]+)/i);
    if (match && match[1]) {
      return match[1].trim();
    }
  } catch (err) {
    // If IANA query fails, fall back to IANA default
  }

  return 'whois.iana.org';
}

function queryWhois(domain, server) {
  return new Promise((resolve, reject) => {
    const client = net.createConnection(43, server, () => {
      client.write(domain + '\r\n');
    });
    let data = '';
    client.on('data', (chunk) => { data += chunk; });
    client.on('end', () => resolve(data));
    client.on('error', (err) => reject(err));
    client.setTimeout(5000, () => {
      client.destroy();
      reject(new Error('WHOIS request timed out'));
    });
  });
}

async function checkDomain(domain) {
  console.log(`\n========================================`);
  console.log(`🔍 Domain Lookup: ${domain}`);
  console.log(`========================================\n`);

  // 1. Fetch DNS records
  let ipAddresses = [];
  try {
    const aRecords = await dns.resolve4(domain).catch(() => []);
    const nsRecords = await dns.resolveNs(domain).catch(() => []);
    ipAddresses = aRecords;

    console.log('📌 DNS RECORDS:');
    console.log(`  • IP (A Records):  ${aRecords.join(', ') || 'Not found'}`);
    console.log(`  • Name Servers:   ${nsRecords.join(', ') || 'Not found'}\n`);
  } catch (err) {
    console.log(`⚠️ DNS Error: ${err.message}\n`);
  }

  // 2. Hosting provider and geolocation info
  if (ipAddresses.length > 0) {
    try {
      const ip = ipAddresses[0];
      const res = await fetch(`http://ip-api.com/json/${ip}?lang=en`);
      const ipData = await res.json();

      console.log('🌐 HOSTING / SERVER INFO:');
      console.log(`  • Provider (ISP): ${ipData.isp || 'N/A'}`);
      console.log(`  • Organization:   ${ipData.org || 'N/A'}`);
      console.log(`  • AS Network:     ${ipData.as || 'N/A'}`);
      console.log(`  • Location:       ${ipData.country || ''}, ${ipData.city || ''}\n`);
    } catch (err) {
      console.log(`⚠️ Failed to fetch IP info: ${err.message}\n`);
    }
  }

  // 3. WHOIS lookup
  try {
    const whoisServer = await getWhoisServer(domain);
    const rawWhois = await queryWhois(domain, whoisServer);

    // Extract basic WHOIS fields
    const registrar = rawWhois.match(/(?:registrar|registrar-name):\s*(.+)/i)?.[1] || 'Not found';
    const created = rawWhois.match(/(?:created|creation date|created-at):\s*(.+)/i)?.[1] || 'Not found';
    const paidTill = rawWhois.match(/(?:paid-till|expiration date|registry expiry date):\s*(.+)/i)?.[1] || 'Not found';

    console.log(`📋 WHOIS DATA (${whoisServer}):`);
    console.log(`  • Registrar:       ${registrar.trim()}`);
    console.log(`  • Creation Date:   ${created.trim()}`);
    console.log(`  • Expiration Date: ${paidTill.trim()}`);
  } catch (err) {
    console.log(`⚠️ WHOIS Error: ${err.message}`);
  }
}

if (process.argv.length < 3) {
  console.log('Please provide a domain name as an argument.');
  process.exit(1);
}

const targetDomain = process.argv[2];
checkDomain(targetDomain);
