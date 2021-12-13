<script>
	import 'https://unpkg.com/@picocss/pico@latest/css/pico.min.css';
	import isIp from 'is-ip'
	let generatedDomain, subdomain, ipaddress, protocol
	let domain_suffix = "sslip.io"
	const supportedIpProtocols = {
		"nip.io": [4, 6],
		"sslip.io": [4],
		"traefik.me": [4]
	}

	$: ipProtocol = isIp.version(ipaddress);
	$: ipValid = !~supportedIpProtocols[domain_suffix].indexOf(ipProtocol)

	let convertIntToHex = (num) => (num).toString(16).replace(/^(\w)$/, "0$1");

	let generateDomain = () => {
		subdomain = subdomain.trim()
		ipaddress = ipaddress.trim()
		let processed_ip = ipaddress.replace(/\./g, "-").replace(/\:/g, "-");
		generatedDomain = `${subdomain}.${processed_ip}.${domain_suffix}`;
	}
	let copyToClipboard = (str) => {
		navigator.clipboard.writeText(str);
	}
</script>

<main>
	<h3>Url Generator for {domain_suffix}</h3>

	<form id="urlgenForm" on:submit|preventDefault="{generateDomain}">
	  <!-- Grid -->
	  <div class="grid">
	  	<label for="subdomain">
			Name:
			<input type="text" name="subdomain" bind:value="{subdomain}" placeholder="Subdomain" required>
		</label>
		<label for="ipaddress">
			IP Address:
			<input type="text" name="ipaddress" bind:value={ipaddress} placeholder="x.x.x.x" aria-invalid="{ipValid}" required>
		</label>
	  </div>
	  <div class="grid">
		<label for="provider">
			Provider: 
			<select id="provider" bind:value="{domain_suffix}">
				<option value="sslip.io">sslip.io</option>
				<option value="nip.io">nip.io</option>
				<option value="traefik.me">traefik.me</option>
			</select>
		</label>
		<label for="protocol">
			Protocol: 
			<select id="protocol" bind:value="{protocol}">
				<option value="http">http</option>
				<option value="https">https</option>
				<option value="grpc">grpc</option>
				<option value="ws">ws</option>
			</select>
		</label>
		<button type="submit" disabled={ipValid}>Generate</button>
	  </div>
	</form>
	<div class="grid">
		{#if (generatedDomain) }
		<article>
			<code>{generatedDomain}</code> (<a href="{protocol}://{generatedDomain}">link</a>)
		</article>
		{/if}
	</div>
</main>

<style>

	main {
		text-align: center;
		padding: 1em;
		max-width: 240px;
		margin: 0 auto;
	}
	article {
		padding: 30px 20px;
	}

	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
	select {
		width: fit-content;
	}
</style>