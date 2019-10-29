
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: KeyVaultClient
## version: 2015-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Performs cryptographic key operations and vault operations against the Key Vault service.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_563564 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563564](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563564): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "keyvault"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetCertificates_563786 = ref object of OpenApiRestCall_563564
proc url_GetCertificates_563788(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificates_563787(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List certificates in the specified vault
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563949 = query.getOrDefault("api-version")
  valid_563949 = validateParameter(valid_563949, JString, required = true,
                                 default = nil)
  if valid_563949 != nil:
    section.add "api-version", valid_563949
  var valid_563950 = query.getOrDefault("maxresults")
  valid_563950 = validateParameter(valid_563950, JInt, required = false, default = nil)
  if valid_563950 != nil:
    section.add "maxresults", valid_563950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563973: Call_GetCertificates_563786; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List certificates in the specified vault
  ## 
  let valid = call_563973.validator(path, query, header, formData, body)
  let scheme = call_563973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563973.url(scheme.get, call_563973.host, call_563973.base,
                         call_563973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563973, url, valid)

proc call*(call_564044: Call_GetCertificates_563786; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getCertificates
  ## List certificates in the specified vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  add(query_564045, "maxresults", newJInt(maxresults))
  result = call_564044.call(nil, query_564045, nil, nil, nil)

var getCertificates* = Call_GetCertificates_563786(name: "getCertificates",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates",
    validator: validate_GetCertificates_563787, base: "", url: url_GetCertificates_563788,
    schemes: {Scheme.Https})
type
  Call_SetCertificateContacts_564092 = ref object of OpenApiRestCall_563564
proc url_SetCertificateContacts_564094(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SetCertificateContacts_564093(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the certificate contacts for the specified vault.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564112 = query.getOrDefault("api-version")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "api-version", valid_564112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   contacts: JObject (required)
  ##           : The contacts for the vault certificates.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564114: Call_SetCertificateContacts_564092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the certificate contacts for the specified vault.
  ## 
  let valid = call_564114.validator(path, query, header, formData, body)
  let scheme = call_564114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564114.url(scheme.get, call_564114.host, call_564114.base,
                         call_564114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564114, url, valid)

proc call*(call_564115: Call_SetCertificateContacts_564092; apiVersion: string;
          contacts: JsonNode): Recallable =
  ## setCertificateContacts
  ## Sets the certificate contacts for the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   contacts: JObject (required)
  ##           : The contacts for the vault certificates.
  var query_564116 = newJObject()
  var body_564117 = newJObject()
  add(query_564116, "api-version", newJString(apiVersion))
  if contacts != nil:
    body_564117 = contacts
  result = call_564115.call(nil, query_564116, nil, nil, body_564117)

var setCertificateContacts* = Call_SetCertificateContacts_564092(
    name: "setCertificateContacts", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/certificates/contacts", validator: validate_SetCertificateContacts_564093,
    base: "", url: url_SetCertificateContacts_564094, schemes: {Scheme.Https})
type
  Call_GetCertificateContacts_564085 = ref object of OpenApiRestCall_563564
proc url_GetCertificateContacts_564087(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificateContacts_564086(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the certificate contacts for the specified vault.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564088 = query.getOrDefault("api-version")
  valid_564088 = validateParameter(valid_564088, JString, required = true,
                                 default = nil)
  if valid_564088 != nil:
    section.add "api-version", valid_564088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564089: Call_GetCertificateContacts_564085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the certificate contacts for the specified vault.
  ## 
  let valid = call_564089.validator(path, query, header, formData, body)
  let scheme = call_564089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564089.url(scheme.get, call_564089.host, call_564089.base,
                         call_564089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564089, url, valid)

proc call*(call_564090: Call_GetCertificateContacts_564085; apiVersion: string): Recallable =
  ## getCertificateContacts
  ## Gets the certificate contacts for the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564091 = newJObject()
  add(query_564091, "api-version", newJString(apiVersion))
  result = call_564090.call(nil, query_564091, nil, nil, nil)

var getCertificateContacts* = Call_GetCertificateContacts_564085(
    name: "getCertificateContacts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/contacts", validator: validate_GetCertificateContacts_564086,
    base: "", url: url_GetCertificateContacts_564087, schemes: {Scheme.Https})
type
  Call_DeleteCertificateContacts_564118 = ref object of OpenApiRestCall_563564
proc url_DeleteCertificateContacts_564120(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeleteCertificateContacts_564119(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the certificate contacts for the specified vault.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564122: Call_DeleteCertificateContacts_564118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the certificate contacts for the specified vault.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_DeleteCertificateContacts_564118; apiVersion: string): Recallable =
  ## deleteCertificateContacts
  ## Deletes the certificate contacts for the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564124 = newJObject()
  add(query_564124, "api-version", newJString(apiVersion))
  result = call_564123.call(nil, query_564124, nil, nil, nil)

var deleteCertificateContacts* = Call_DeleteCertificateContacts_564118(
    name: "deleteCertificateContacts", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/contacts",
    validator: validate_DeleteCertificateContacts_564119, base: "",
    url: url_DeleteCertificateContacts_564120, schemes: {Scheme.Https})
type
  Call_GetCertificateIssuers_564125 = ref object of OpenApiRestCall_563564
proc url_GetCertificateIssuers_564127(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificateIssuers_564126(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List certificate issuers for the specified vault.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  var valid_564129 = query.getOrDefault("maxresults")
  valid_564129 = validateParameter(valid_564129, JInt, required = false, default = nil)
  if valid_564129 != nil:
    section.add "maxresults", valid_564129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564130: Call_GetCertificateIssuers_564125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List certificate issuers for the specified vault.
  ## 
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_GetCertificateIssuers_564125; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getCertificateIssuers
  ## List certificate issuers for the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564132 = newJObject()
  add(query_564132, "api-version", newJString(apiVersion))
  add(query_564132, "maxresults", newJInt(maxresults))
  result = call_564131.call(nil, query_564132, nil, nil, nil)

var getCertificateIssuers* = Call_GetCertificateIssuers_564125(
    name: "getCertificateIssuers", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/issuers", validator: validate_GetCertificateIssuers_564126,
    base: "", url: url_GetCertificateIssuers_564127, schemes: {Scheme.Https})
type
  Call_SetCertificateIssuer_564156 = ref object of OpenApiRestCall_563564
proc url_SetCertificateIssuer_564158(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "issuer-name" in path, "`issuer-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/issuers/"),
               (kind: VariableSegment, value: "issuer-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SetCertificateIssuer_564157(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the specified certificate issuer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   issuer-name: JString (required)
  ##              : The name of the issuer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `issuer-name` field"
  var valid_564159 = path.getOrDefault("issuer-name")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "issuer-name", valid_564159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564160 = query.getOrDefault("api-version")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "api-version", valid_564160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameter: JObject (required)
  ##            : Certificate issuer set parameter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564162: Call_SetCertificateIssuer_564156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the specified certificate issuer.
  ## 
  let valid = call_564162.validator(path, query, header, formData, body)
  let scheme = call_564162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564162.url(scheme.get, call_564162.host, call_564162.base,
                         call_564162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564162, url, valid)

proc call*(call_564163: Call_SetCertificateIssuer_564156; apiVersion: string;
          parameter: JsonNode; issuerName: string): Recallable =
  ## setCertificateIssuer
  ## Sets the specified certificate issuer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameter: JObject (required)
  ##            : Certificate issuer set parameter.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_564164 = newJObject()
  var query_564165 = newJObject()
  var body_564166 = newJObject()
  add(query_564165, "api-version", newJString(apiVersion))
  if parameter != nil:
    body_564166 = parameter
  add(path_564164, "issuer-name", newJString(issuerName))
  result = call_564163.call(path_564164, query_564165, nil, nil, body_564166)

var setCertificateIssuer* = Call_SetCertificateIssuer_564156(
    name: "setCertificateIssuer", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/certificates/issuers/{issuer-name}",
    validator: validate_SetCertificateIssuer_564157, base: "",
    url: url_SetCertificateIssuer_564158, schemes: {Scheme.Https})
type
  Call_GetCertificateIssuer_564133 = ref object of OpenApiRestCall_563564
proc url_GetCertificateIssuer_564135(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "issuer-name" in path, "`issuer-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/issuers/"),
               (kind: VariableSegment, value: "issuer-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetCertificateIssuer_564134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified certificate issuer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   issuer-name: JString (required)
  ##              : The name of the issuer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `issuer-name` field"
  var valid_564150 = path.getOrDefault("issuer-name")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "issuer-name", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564152: Call_GetCertificateIssuer_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified certificate issuer.
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_GetCertificateIssuer_564133; apiVersion: string;
          issuerName: string): Recallable =
  ## getCertificateIssuer
  ## Gets the specified certificate issuer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  add(query_564155, "api-version", newJString(apiVersion))
  add(path_564154, "issuer-name", newJString(issuerName))
  result = call_564153.call(path_564154, query_564155, nil, nil, nil)

var getCertificateIssuer* = Call_GetCertificateIssuer_564133(
    name: "getCertificateIssuer", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/issuers/{issuer-name}",
    validator: validate_GetCertificateIssuer_564134, base: "",
    url: url_GetCertificateIssuer_564135, schemes: {Scheme.Https})
type
  Call_UpdateCertificateIssuer_564176 = ref object of OpenApiRestCall_563564
proc url_UpdateCertificateIssuer_564178(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "issuer-name" in path, "`issuer-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/issuers/"),
               (kind: VariableSegment, value: "issuer-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateCertificateIssuer_564177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified certificate issuer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   issuer-name: JString (required)
  ##              : The name of the issuer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `issuer-name` field"
  var valid_564179 = path.getOrDefault("issuer-name")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "issuer-name", valid_564179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameter: JObject (required)
  ##            : Certificate issuer update parameter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564182: Call_UpdateCertificateIssuer_564176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified certificate issuer.
  ## 
  let valid = call_564182.validator(path, query, header, formData, body)
  let scheme = call_564182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564182.url(scheme.get, call_564182.host, call_564182.base,
                         call_564182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564182, url, valid)

proc call*(call_564183: Call_UpdateCertificateIssuer_564176; apiVersion: string;
          parameter: JsonNode; issuerName: string): Recallable =
  ## updateCertificateIssuer
  ## Updates the specified certificate issuer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameter: JObject (required)
  ##            : Certificate issuer update parameter.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_564184 = newJObject()
  var query_564185 = newJObject()
  var body_564186 = newJObject()
  add(query_564185, "api-version", newJString(apiVersion))
  if parameter != nil:
    body_564186 = parameter
  add(path_564184, "issuer-name", newJString(issuerName))
  result = call_564183.call(path_564184, query_564185, nil, nil, body_564186)

var updateCertificateIssuer* = Call_UpdateCertificateIssuer_564176(
    name: "updateCertificateIssuer", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/issuers/{issuer-name}",
    validator: validate_UpdateCertificateIssuer_564177, base: "",
    url: url_UpdateCertificateIssuer_564178, schemes: {Scheme.Https})
type
  Call_DeleteCertificateIssuer_564167 = ref object of OpenApiRestCall_563564
proc url_DeleteCertificateIssuer_564169(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "issuer-name" in path, "`issuer-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/issuers/"),
               (kind: VariableSegment, value: "issuer-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteCertificateIssuer_564168(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified certificate issuer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   issuer-name: JString (required)
  ##              : The name of the issuer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `issuer-name` field"
  var valid_564170 = path.getOrDefault("issuer-name")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "issuer-name", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564171 = query.getOrDefault("api-version")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "api-version", valid_564171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564172: Call_DeleteCertificateIssuer_564167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified certificate issuer.
  ## 
  let valid = call_564172.validator(path, query, header, formData, body)
  let scheme = call_564172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564172.url(scheme.get, call_564172.host, call_564172.base,
                         call_564172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564172, url, valid)

proc call*(call_564173: Call_DeleteCertificateIssuer_564167; apiVersion: string;
          issuerName: string): Recallable =
  ## deleteCertificateIssuer
  ## Deletes the specified certificate issuer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_564174 = newJObject()
  var query_564175 = newJObject()
  add(query_564175, "api-version", newJString(apiVersion))
  add(path_564174, "issuer-name", newJString(issuerName))
  result = call_564173.call(path_564174, query_564175, nil, nil, nil)

var deleteCertificateIssuer* = Call_DeleteCertificateIssuer_564167(
    name: "deleteCertificateIssuer", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/issuers/{issuer-name}",
    validator: validate_DeleteCertificateIssuer_564168, base: "",
    url: url_DeleteCertificateIssuer_564169, schemes: {Scheme.Https})
type
  Call_DeleteCertificate_564187 = ref object of OpenApiRestCall_563564
proc url_DeleteCertificate_564189(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificate-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteCertificate_564188(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a certificate from the specified vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate in the given vault
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_564190 = path.getOrDefault("certificate-name")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "certificate-name", valid_564190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564191 = query.getOrDefault("api-version")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "api-version", valid_564191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564192: Call_DeleteCertificate_564187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a certificate from the specified vault.
  ## 
  let valid = call_564192.validator(path, query, header, formData, body)
  let scheme = call_564192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564192.url(scheme.get, call_564192.host, call_564192.base,
                         call_564192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564192, url, valid)

proc call*(call_564193: Call_DeleteCertificate_564187; apiVersion: string;
          certificateName: string): Recallable =
  ## deleteCertificate
  ## Deletes a certificate from the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault
  var path_564194 = newJObject()
  var query_564195 = newJObject()
  add(query_564195, "api-version", newJString(apiVersion))
  add(path_564194, "certificate-name", newJString(certificateName))
  result = call_564193.call(path_564194, query_564195, nil, nil, nil)

var deleteCertificate* = Call_DeleteCertificate_564187(name: "deleteCertificate",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/certificates/{certificate-name}",
    validator: validate_DeleteCertificate_564188, base: "",
    url: url_DeleteCertificate_564189, schemes: {Scheme.Https})
type
  Call_CreateCertificate_564196 = ref object of OpenApiRestCall_563564
proc url_CreateCertificate_564198(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificate-name"),
               (kind: ConstantSegment, value: "/create")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CreateCertificate_564197(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a new certificate version. If this is the first version, the certificate resource is created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_564199 = path.getOrDefault("certificate-name")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "certificate-name", valid_564199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564200 = query.getOrDefault("api-version")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "api-version", valid_564200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to create certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564202: Call_CreateCertificate_564196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new certificate version. If this is the first version, the certificate resource is created.
  ## 
  let valid = call_564202.validator(path, query, header, formData, body)
  let scheme = call_564202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564202.url(scheme.get, call_564202.host, call_564202.base,
                         call_564202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564202, url, valid)

proc call*(call_564203: Call_CreateCertificate_564196; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## createCertificate
  ## Creates a new certificate version. If this is the first version, the certificate resource is created.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  ##   parameters: JObject (required)
  ##             : The parameters to create certificate.
  var path_564204 = newJObject()
  var query_564205 = newJObject()
  var body_564206 = newJObject()
  add(query_564205, "api-version", newJString(apiVersion))
  add(path_564204, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_564206 = parameters
  result = call_564203.call(path_564204, query_564205, nil, nil, body_564206)

var createCertificate* = Call_CreateCertificate_564196(name: "createCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/create",
    validator: validate_CreateCertificate_564197, base: "",
    url: url_CreateCertificate_564198, schemes: {Scheme.Https})
type
  Call_ImportCertificate_564207 = ref object of OpenApiRestCall_563564
proc url_ImportCertificate_564209(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificate-name"),
               (kind: ConstantSegment, value: "/import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImportCertificate_564208(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Imports a certificate into the specified vault
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_564210 = path.getOrDefault("certificate-name")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "certificate-name", valid_564210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564211 = query.getOrDefault("api-version")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "api-version", valid_564211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to import certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564213: Call_ImportCertificate_564207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a certificate into the specified vault
  ## 
  let valid = call_564213.validator(path, query, header, formData, body)
  let scheme = call_564213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564213.url(scheme.get, call_564213.host, call_564213.base,
                         call_564213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564213, url, valid)

proc call*(call_564214: Call_ImportCertificate_564207; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## importCertificate
  ## Imports a certificate into the specified vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  ##   parameters: JObject (required)
  ##             : The parameters to import certificate.
  var path_564215 = newJObject()
  var query_564216 = newJObject()
  var body_564217 = newJObject()
  add(query_564216, "api-version", newJString(apiVersion))
  add(path_564215, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_564217 = parameters
  result = call_564214.call(path_564215, query_564216, nil, nil, body_564217)

var importCertificate* = Call_ImportCertificate_564207(name: "importCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/import",
    validator: validate_ImportCertificate_564208, base: "",
    url: url_ImportCertificate_564209, schemes: {Scheme.Https})
type
  Call_GetCertificateOperation_564218 = ref object of OpenApiRestCall_563564
proc url_GetCertificateOperation_564220(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificate-name"),
               (kind: ConstantSegment, value: "/pending")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetCertificateOperation_564219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the certificate operation response.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_564221 = path.getOrDefault("certificate-name")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "certificate-name", valid_564221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564222 = query.getOrDefault("api-version")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "api-version", valid_564222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564223: Call_GetCertificateOperation_564218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the certificate operation response.
  ## 
  let valid = call_564223.validator(path, query, header, formData, body)
  let scheme = call_564223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564223.url(scheme.get, call_564223.host, call_564223.base,
                         call_564223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564223, url, valid)

proc call*(call_564224: Call_GetCertificateOperation_564218; apiVersion: string;
          certificateName: string): Recallable =
  ## getCertificateOperation
  ## Gets the certificate operation response.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_564225 = newJObject()
  var query_564226 = newJObject()
  add(query_564226, "api-version", newJString(apiVersion))
  add(path_564225, "certificate-name", newJString(certificateName))
  result = call_564224.call(path_564225, query_564226, nil, nil, nil)

var getCertificateOperation* = Call_GetCertificateOperation_564218(
    name: "getCertificateOperation", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/pending",
    validator: validate_GetCertificateOperation_564219, base: "",
    url: url_GetCertificateOperation_564220, schemes: {Scheme.Https})
type
  Call_UpdateCertificateOperation_564236 = ref object of OpenApiRestCall_563564
proc url_UpdateCertificateOperation_564238(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificate-name"),
               (kind: ConstantSegment, value: "/pending")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateCertificateOperation_564237(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a certificate operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_564239 = path.getOrDefault("certificate-name")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "certificate-name", valid_564239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564240 = query.getOrDefault("api-version")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "api-version", valid_564240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   certificateOperation: JObject (required)
  ##                       : The certificate operation response.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564242: Call_UpdateCertificateOperation_564236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a certificate operation.
  ## 
  let valid = call_564242.validator(path, query, header, formData, body)
  let scheme = call_564242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564242.url(scheme.get, call_564242.host, call_564242.base,
                         call_564242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564242, url, valid)

proc call*(call_564243: Call_UpdateCertificateOperation_564236; apiVersion: string;
          certificateOperation: JsonNode; certificateName: string): Recallable =
  ## updateCertificateOperation
  ## Updates a certificate operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateOperation: JObject (required)
  ##                       : The certificate operation response.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_564244 = newJObject()
  var query_564245 = newJObject()
  var body_564246 = newJObject()
  add(query_564245, "api-version", newJString(apiVersion))
  if certificateOperation != nil:
    body_564246 = certificateOperation
  add(path_564244, "certificate-name", newJString(certificateName))
  result = call_564243.call(path_564244, query_564245, nil, nil, body_564246)

var updateCertificateOperation* = Call_UpdateCertificateOperation_564236(
    name: "updateCertificateOperation", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/{certificate-name}/pending",
    validator: validate_UpdateCertificateOperation_564237, base: "",
    url: url_UpdateCertificateOperation_564238, schemes: {Scheme.Https})
type
  Call_DeleteCertificateOperation_564227 = ref object of OpenApiRestCall_563564
proc url_DeleteCertificateOperation_564229(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificate-name"),
               (kind: ConstantSegment, value: "/pending")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteCertificateOperation_564228(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the certificate operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_564230 = path.getOrDefault("certificate-name")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "certificate-name", valid_564230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564231 = query.getOrDefault("api-version")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "api-version", valid_564231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564232: Call_DeleteCertificateOperation_564227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the certificate operation.
  ## 
  let valid = call_564232.validator(path, query, header, formData, body)
  let scheme = call_564232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564232.url(scheme.get, call_564232.host, call_564232.base,
                         call_564232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564232, url, valid)

proc call*(call_564233: Call_DeleteCertificateOperation_564227; apiVersion: string;
          certificateName: string): Recallable =
  ## deleteCertificateOperation
  ## Deletes the certificate operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_564234 = newJObject()
  var query_564235 = newJObject()
  add(query_564235, "api-version", newJString(apiVersion))
  add(path_564234, "certificate-name", newJString(certificateName))
  result = call_564233.call(path_564234, query_564235, nil, nil, nil)

var deleteCertificateOperation* = Call_DeleteCertificateOperation_564227(
    name: "deleteCertificateOperation", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/{certificate-name}/pending",
    validator: validate_DeleteCertificateOperation_564228, base: "",
    url: url_DeleteCertificateOperation_564229, schemes: {Scheme.Https})
type
  Call_MergeCertificate_564247 = ref object of OpenApiRestCall_563564
proc url_MergeCertificate_564249(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificate-name"),
               (kind: ConstantSegment, value: "/pending/merge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MergeCertificate_564248(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Merges a certificate or a certificate chain with a key pair existing on the server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_564250 = path.getOrDefault("certificate-name")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "certificate-name", valid_564250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564251 = query.getOrDefault("api-version")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "api-version", valid_564251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to merge certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564253: Call_MergeCertificate_564247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Merges a certificate or a certificate chain with a key pair existing on the server.
  ## 
  let valid = call_564253.validator(path, query, header, formData, body)
  let scheme = call_564253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564253.url(scheme.get, call_564253.host, call_564253.base,
                         call_564253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564253, url, valid)

proc call*(call_564254: Call_MergeCertificate_564247; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## mergeCertificate
  ## Merges a certificate or a certificate chain with a key pair existing on the server.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  ##   parameters: JObject (required)
  ##             : The parameters to merge certificate.
  var path_564255 = newJObject()
  var query_564256 = newJObject()
  var body_564257 = newJObject()
  add(query_564256, "api-version", newJString(apiVersion))
  add(path_564255, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_564257 = parameters
  result = call_564254.call(path_564255, query_564256, nil, nil, body_564257)

var mergeCertificate* = Call_MergeCertificate_564247(name: "mergeCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/pending/merge",
    validator: validate_MergeCertificate_564248, base: "",
    url: url_MergeCertificate_564249, schemes: {Scheme.Https})
type
  Call_GetCertificatePolicy_564258 = ref object of OpenApiRestCall_563564
proc url_GetCertificatePolicy_564260(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificate-name"),
               (kind: ConstantSegment, value: "/policy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetCertificatePolicy_564259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the policy for a certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate in the given vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_564261 = path.getOrDefault("certificate-name")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "certificate-name", valid_564261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564262 = query.getOrDefault("api-version")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "api-version", valid_564262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564263: Call_GetCertificatePolicy_564258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the policy for a certificate.
  ## 
  let valid = call_564263.validator(path, query, header, formData, body)
  let scheme = call_564263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564263.url(scheme.get, call_564263.host, call_564263.base,
                         call_564263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564263, url, valid)

proc call*(call_564264: Call_GetCertificatePolicy_564258; apiVersion: string;
          certificateName: string): Recallable =
  ## getCertificatePolicy
  ## Gets the policy for a certificate.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault.
  var path_564265 = newJObject()
  var query_564266 = newJObject()
  add(query_564266, "api-version", newJString(apiVersion))
  add(path_564265, "certificate-name", newJString(certificateName))
  result = call_564264.call(path_564265, query_564266, nil, nil, nil)

var getCertificatePolicy* = Call_GetCertificatePolicy_564258(
    name: "getCertificatePolicy", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/policy",
    validator: validate_GetCertificatePolicy_564259, base: "",
    url: url_GetCertificatePolicy_564260, schemes: {Scheme.Https})
type
  Call_UpdateCertificatePolicy_564267 = ref object of OpenApiRestCall_563564
proc url_UpdateCertificatePolicy_564269(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificate-name"),
               (kind: ConstantSegment, value: "/policy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateCertificatePolicy_564268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the policy for a certificate. Set appropriate members in the certificatePolicy that must be updated. Leave others as null.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate in the given vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_564270 = path.getOrDefault("certificate-name")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "certificate-name", valid_564270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564271 = query.getOrDefault("api-version")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "api-version", valid_564271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   certificatePolicy: JObject (required)
  ##                    : The policy for the certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564273: Call_UpdateCertificatePolicy_564267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the policy for a certificate. Set appropriate members in the certificatePolicy that must be updated. Leave others as null.
  ## 
  let valid = call_564273.validator(path, query, header, formData, body)
  let scheme = call_564273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564273.url(scheme.get, call_564273.host, call_564273.base,
                         call_564273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564273, url, valid)

proc call*(call_564274: Call_UpdateCertificatePolicy_564267; apiVersion: string;
          certificateName: string; certificatePolicy: JsonNode): Recallable =
  ## updateCertificatePolicy
  ## Updates the policy for a certificate. Set appropriate members in the certificatePolicy that must be updated. Leave others as null.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault.
  ##   certificatePolicy: JObject (required)
  ##                    : The policy for the certificate.
  var path_564275 = newJObject()
  var query_564276 = newJObject()
  var body_564277 = newJObject()
  add(query_564276, "api-version", newJString(apiVersion))
  add(path_564275, "certificate-name", newJString(certificateName))
  if certificatePolicy != nil:
    body_564277 = certificatePolicy
  result = call_564274.call(path_564275, query_564276, nil, nil, body_564277)

var updateCertificatePolicy* = Call_UpdateCertificatePolicy_564267(
    name: "updateCertificatePolicy", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/{certificate-name}/policy",
    validator: validate_UpdateCertificatePolicy_564268, base: "",
    url: url_UpdateCertificatePolicy_564269, schemes: {Scheme.Https})
type
  Call_GetCertificateVersions_564278 = ref object of OpenApiRestCall_563564
proc url_GetCertificateVersions_564280(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificate-name"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetCertificateVersions_564279(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the versions of a certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_564281 = path.getOrDefault("certificate-name")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "certificate-name", valid_564281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564282 = query.getOrDefault("api-version")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "api-version", valid_564282
  var valid_564283 = query.getOrDefault("maxresults")
  valid_564283 = validateParameter(valid_564283, JInt, required = false, default = nil)
  if valid_564283 != nil:
    section.add "maxresults", valid_564283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564284: Call_GetCertificateVersions_564278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the versions of a certificate.
  ## 
  let valid = call_564284.validator(path, query, header, formData, body)
  let scheme = call_564284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564284.url(scheme.get, call_564284.host, call_564284.base,
                         call_564284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564284, url, valid)

proc call*(call_564285: Call_GetCertificateVersions_564278; apiVersion: string;
          certificateName: string; maxresults: int = 0): Recallable =
  ## getCertificateVersions
  ## List the versions of a certificate.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_564286 = newJObject()
  var query_564287 = newJObject()
  add(query_564287, "api-version", newJString(apiVersion))
  add(query_564287, "maxresults", newJInt(maxresults))
  add(path_564286, "certificate-name", newJString(certificateName))
  result = call_564285.call(path_564286, query_564287, nil, nil, nil)

var getCertificateVersions* = Call_GetCertificateVersions_564278(
    name: "getCertificateVersions", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/versions",
    validator: validate_GetCertificateVersions_564279, base: "",
    url: url_GetCertificateVersions_564280, schemes: {Scheme.Https})
type
  Call_GetCertificate_564288 = ref object of OpenApiRestCall_563564
proc url_GetCertificate_564290(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  assert "certificate-version" in path,
        "`certificate-version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificate-name"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "certificate-version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetCertificate_564289(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a Certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-version: JString (required)
  ##                      : The version of the certificate
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate in the given vault
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificate-version` field"
  var valid_564291 = path.getOrDefault("certificate-version")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "certificate-version", valid_564291
  var valid_564292 = path.getOrDefault("certificate-name")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "certificate-name", valid_564292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564293 = query.getOrDefault("api-version")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "api-version", valid_564293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564294: Call_GetCertificate_564288; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Certificate.
  ## 
  let valid = call_564294.validator(path, query, header, formData, body)
  let scheme = call_564294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564294.url(scheme.get, call_564294.host, call_564294.base,
                         call_564294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564294, url, valid)

proc call*(call_564295: Call_GetCertificate_564288; apiVersion: string;
          certificateVersion: string; certificateName: string): Recallable =
  ## getCertificate
  ## Gets a Certificate.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateVersion: string (required)
  ##                     : The version of the certificate
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault
  var path_564296 = newJObject()
  var query_564297 = newJObject()
  add(query_564297, "api-version", newJString(apiVersion))
  add(path_564296, "certificate-version", newJString(certificateVersion))
  add(path_564296, "certificate-name", newJString(certificateName))
  result = call_564295.call(path_564296, query_564297, nil, nil, nil)

var getCertificate* = Call_GetCertificate_564288(name: "getCertificate",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/{certificate-version}",
    validator: validate_GetCertificate_564289, base: "", url: url_GetCertificate_564290,
    schemes: {Scheme.Https})
type
  Call_UpdateCertificate_564298 = ref object of OpenApiRestCall_563564
proc url_UpdateCertificate_564300(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  assert "certificate-version" in path,
        "`certificate-version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificate-name"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "certificate-version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateCertificate_564299(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the attributes associated with the specified certificate
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-version: JString (required)
  ##                      : The version of the certificate
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate in the given vault
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificate-version` field"
  var valid_564301 = path.getOrDefault("certificate-version")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "certificate-version", valid_564301
  var valid_564302 = path.getOrDefault("certificate-name")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "certificate-name", valid_564302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564303 = query.getOrDefault("api-version")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "api-version", valid_564303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564305: Call_UpdateCertificate_564298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the attributes associated with the specified certificate
  ## 
  let valid = call_564305.validator(path, query, header, formData, body)
  let scheme = call_564305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564305.url(scheme.get, call_564305.host, call_564305.base,
                         call_564305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564305, url, valid)

proc call*(call_564306: Call_UpdateCertificate_564298; apiVersion: string;
          certificateVersion: string; certificateName: string; parameters: JsonNode): Recallable =
  ## updateCertificate
  ## Updates the attributes associated with the specified certificate
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateVersion: string (required)
  ##                     : The version of the certificate
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault
  ##   parameters: JObject (required)
  var path_564307 = newJObject()
  var query_564308 = newJObject()
  var body_564309 = newJObject()
  add(query_564308, "api-version", newJString(apiVersion))
  add(path_564307, "certificate-version", newJString(certificateVersion))
  add(path_564307, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_564309 = parameters
  result = call_564306.call(path_564307, query_564308, nil, nil, body_564309)

var updateCertificate* = Call_UpdateCertificate_564298(name: "updateCertificate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/certificates/{certificate-name}/{certificate-version}",
    validator: validate_UpdateCertificate_564299, base: "",
    url: url_UpdateCertificate_564300, schemes: {Scheme.Https})
type
  Call_GetKeys_564310 = ref object of OpenApiRestCall_563564
proc url_GetKeys_564312(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetKeys_564311(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## List keys in the specified vault
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  var valid_564314 = query.getOrDefault("maxresults")
  valid_564314 = validateParameter(valid_564314, JInt, required = false, default = nil)
  if valid_564314 != nil:
    section.add "maxresults", valid_564314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564315: Call_GetKeys_564310; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List keys in the specified vault
  ## 
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_GetKeys_564310; apiVersion: string; maxresults: int = 0): Recallable =
  ## getKeys
  ## List keys in the specified vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564317 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(query_564317, "maxresults", newJInt(maxresults))
  result = call_564316.call(nil, query_564317, nil, nil, nil)

var getKeys* = Call_GetKeys_564310(name: "getKeys", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/keys",
                                validator: validate_GetKeys_564311, base: "",
                                url: url_GetKeys_564312, schemes: {Scheme.Https})
type
  Call_RestoreKey_564318 = ref object of OpenApiRestCall_563564
proc url_RestoreKey_564320(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreKey_564319(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores the backup key in to a vault
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564321 = query.getOrDefault("api-version")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "api-version", valid_564321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to restore key
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564323: Call_RestoreKey_564318; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the backup key in to a vault
  ## 
  let valid = call_564323.validator(path, query, header, formData, body)
  let scheme = call_564323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564323.url(scheme.get, call_564323.host, call_564323.base,
                         call_564323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564323, url, valid)

proc call*(call_564324: Call_RestoreKey_564318; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreKey
  ## Restores the backup key in to a vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore key
  var query_564325 = newJObject()
  var body_564326 = newJObject()
  add(query_564325, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564326 = parameters
  result = call_564324.call(nil, query_564325, nil, nil, body_564326)

var restoreKey* = Call_RestoreKey_564318(name: "restoreKey",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/keys/restore",
                                      validator: validate_RestoreKey_564319,
                                      base: "", url: url_RestoreKey_564320,
                                      schemes: {Scheme.Https})
type
  Call_ImportKey_564327 = ref object of OpenApiRestCall_563564
proc url_ImportKey_564329(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImportKey_564328(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports a key into the specified vault
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_564330 = path.getOrDefault("key-name")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "key-name", valid_564330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564331 = query.getOrDefault("api-version")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "api-version", valid_564331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to import key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564333: Call_ImportKey_564327; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a key into the specified vault
  ## 
  let valid = call_564333.validator(path, query, header, formData, body)
  let scheme = call_564333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564333.url(scheme.get, call_564333.host, call_564333.base,
                         call_564333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564333, url, valid)

proc call*(call_564334: Call_ImportKey_564327; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## importKey
  ## Imports a key into the specified vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The parameters to import key.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564335 = newJObject()
  var query_564336 = newJObject()
  var body_564337 = newJObject()
  add(query_564336, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564337 = parameters
  add(path_564335, "key-name", newJString(keyName))
  result = call_564334.call(path_564335, query_564336, nil, nil, body_564337)

var importKey* = Call_ImportKey_564327(name: "importKey", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_ImportKey_564328,
                                    base: "", url: url_ImportKey_564329,
                                    schemes: {Scheme.Https})
type
  Call_DeleteKey_564338 = ref object of OpenApiRestCall_563564
proc url_DeleteKey_564340(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteKey_564339(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified key
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_564341 = path.getOrDefault("key-name")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "key-name", valid_564341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564342 = query.getOrDefault("api-version")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "api-version", valid_564342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564343: Call_DeleteKey_564338; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified key
  ## 
  let valid = call_564343.validator(path, query, header, formData, body)
  let scheme = call_564343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564343.url(scheme.get, call_564343.host, call_564343.base,
                         call_564343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564343, url, valid)

proc call*(call_564344: Call_DeleteKey_564338; apiVersion: string; keyName: string): Recallable =
  ## deleteKey
  ## Deletes the specified key
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564345 = newJObject()
  var query_564346 = newJObject()
  add(query_564346, "api-version", newJString(apiVersion))
  add(path_564345, "key-name", newJString(keyName))
  result = call_564344.call(path_564345, query_564346, nil, nil, nil)

var deleteKey* = Call_DeleteKey_564338(name: "deleteKey",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_DeleteKey_564339,
                                    base: "", url: url_DeleteKey_564340,
                                    schemes: {Scheme.Https})
type
  Call_BackupKey_564347 = ref object of OpenApiRestCall_563564
proc url_BackupKey_564349(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name"),
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupKey_564348(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests that a backup of the specified key be downloaded to the client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_564350 = path.getOrDefault("key-name")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "key-name", valid_564350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564351 = query.getOrDefault("api-version")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "api-version", valid_564351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564352: Call_BackupKey_564347; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified key be downloaded to the client.
  ## 
  let valid = call_564352.validator(path, query, header, formData, body)
  let scheme = call_564352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564352.url(scheme.get, call_564352.host, call_564352.base,
                         call_564352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564352, url, valid)

proc call*(call_564353: Call_BackupKey_564347; apiVersion: string; keyName: string): Recallable =
  ## backupKey
  ## Requests that a backup of the specified key be downloaded to the client.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564354 = newJObject()
  var query_564355 = newJObject()
  add(query_564355, "api-version", newJString(apiVersion))
  add(path_564354, "key-name", newJString(keyName))
  result = call_564353.call(path_564354, query_564355, nil, nil, nil)

var backupKey* = Call_BackupKey_564347(name: "backupKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/backup",
                                    validator: validate_BackupKey_564348,
                                    base: "", url: url_BackupKey_564349,
                                    schemes: {Scheme.Https})
type
  Call_CreateKey_564356 = ref object of OpenApiRestCall_563564
proc url_CreateKey_564358(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name"),
               (kind: ConstantSegment, value: "/create")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CreateKey_564357(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new, named, key in the specified vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_564369 = path.getOrDefault("key-name")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "key-name", valid_564369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564370 = query.getOrDefault("api-version")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "api-version", valid_564370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to create key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564372: Call_CreateKey_564356; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new, named, key in the specified vault.
  ## 
  let valid = call_564372.validator(path, query, header, formData, body)
  let scheme = call_564372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564372.url(scheme.get, call_564372.host, call_564372.base,
                         call_564372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564372, url, valid)

proc call*(call_564373: Call_CreateKey_564356; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## createKey
  ## Creates a new, named, key in the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The parameters to create key.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564374 = newJObject()
  var query_564375 = newJObject()
  var body_564376 = newJObject()
  add(query_564375, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564376 = parameters
  add(path_564374, "key-name", newJString(keyName))
  result = call_564373.call(path_564374, query_564375, nil, nil, body_564376)

var createKey* = Call_CreateKey_564356(name: "createKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/create",
                                    validator: validate_CreateKey_564357,
                                    base: "", url: url_CreateKey_564358,
                                    schemes: {Scheme.Https})
type
  Call_GetKeyVersions_564377 = ref object of OpenApiRestCall_563564
proc url_GetKeyVersions_564379(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetKeyVersions_564378(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List the versions of the specified key
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_564380 = path.getOrDefault("key-name")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "key-name", valid_564380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564381 = query.getOrDefault("api-version")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "api-version", valid_564381
  var valid_564382 = query.getOrDefault("maxresults")
  valid_564382 = validateParameter(valid_564382, JInt, required = false, default = nil)
  if valid_564382 != nil:
    section.add "maxresults", valid_564382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564383: Call_GetKeyVersions_564377; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the versions of the specified key
  ## 
  let valid = call_564383.validator(path, query, header, formData, body)
  let scheme = call_564383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564383.url(scheme.get, call_564383.host, call_564383.base,
                         call_564383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564383, url, valid)

proc call*(call_564384: Call_GetKeyVersions_564377; apiVersion: string;
          keyName: string; maxresults: int = 0): Recallable =
  ## getKeyVersions
  ## List the versions of the specified key
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564385 = newJObject()
  var query_564386 = newJObject()
  add(query_564386, "api-version", newJString(apiVersion))
  add(query_564386, "maxresults", newJInt(maxresults))
  add(path_564385, "key-name", newJString(keyName))
  result = call_564384.call(path_564385, query_564386, nil, nil, nil)

var getKeyVersions* = Call_GetKeyVersions_564377(name: "getKeyVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/keys/{key-name}/versions", validator: validate_GetKeyVersions_564378,
    base: "", url: url_GetKeyVersions_564379, schemes: {Scheme.Https})
type
  Call_GetKey_564387 = ref object of OpenApiRestCall_563564
proc url_GetKey_564389(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  assert "key-version" in path, "`key-version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "key-version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetKey_564388(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the public portion of a key plus its attributes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_564390 = path.getOrDefault("key-version")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "key-version", valid_564390
  var valid_564391 = path.getOrDefault("key-name")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "key-name", valid_564391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564392 = query.getOrDefault("api-version")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "api-version", valid_564392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564393: Call_GetKey_564387; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the public portion of a key plus its attributes
  ## 
  let valid = call_564393.validator(path, query, header, formData, body)
  let scheme = call_564393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564393.url(scheme.get, call_564393.host, call_564393.base,
                         call_564393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564393, url, valid)

proc call*(call_564394: Call_GetKey_564387; apiVersion: string; keyVersion: string;
          keyName: string): Recallable =
  ## getKey
  ## Retrieves the public portion of a key plus its attributes
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyVersion: string (required)
  ##             : The version of the key
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564395 = newJObject()
  var query_564396 = newJObject()
  add(query_564396, "api-version", newJString(apiVersion))
  add(path_564395, "key-version", newJString(keyVersion))
  add(path_564395, "key-name", newJString(keyName))
  result = call_564394.call(path_564395, query_564396, nil, nil, nil)

var getKey* = Call_GetKey_564387(name: "getKey", meth: HttpMethod.HttpGet,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}",
                              validator: validate_GetKey_564388, base: "",
                              url: url_GetKey_564389, schemes: {Scheme.Https})
type
  Call_UpdateKey_564397 = ref object of OpenApiRestCall_563564
proc url_UpdateKey_564399(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  assert "key-version" in path, "`key-version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "key-version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateKey_564398(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the Key Attributes associated with the specified key
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_564400 = path.getOrDefault("key-version")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "key-version", valid_564400
  var valid_564401 = path.getOrDefault("key-name")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "key-name", valid_564401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564402 = query.getOrDefault("api-version")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "api-version", valid_564402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to update key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564404: Call_UpdateKey_564397; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Key Attributes associated with the specified key
  ## 
  let valid = call_564404.validator(path, query, header, formData, body)
  let scheme = call_564404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564404.url(scheme.get, call_564404.host, call_564404.base,
                         call_564404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564404, url, valid)

proc call*(call_564405: Call_UpdateKey_564397; apiVersion: string;
          keyVersion: string; parameters: JsonNode; keyName: string): Recallable =
  ## updateKey
  ## Updates the Key Attributes associated with the specified key
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyVersion: string (required)
  ##             : The version of the key
  ##   parameters: JObject (required)
  ##             : The parameters to update key.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564406 = newJObject()
  var query_564407 = newJObject()
  var body_564408 = newJObject()
  add(query_564407, "api-version", newJString(apiVersion))
  add(path_564406, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564408 = parameters
  add(path_564406, "key-name", newJString(keyName))
  result = call_564405.call(path_564406, query_564407, nil, nil, body_564408)

var updateKey* = Call_UpdateKey_564397(name: "updateKey", meth: HttpMethod.HttpPatch,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/{key-version}",
                                    validator: validate_UpdateKey_564398,
                                    base: "", url: url_UpdateKey_564399,
                                    schemes: {Scheme.Https})
type
  Call_Decrypt_564409 = ref object of OpenApiRestCall_563564
proc url_Decrypt_564411(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  assert "key-version" in path, "`key-version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "key-version"),
               (kind: ConstantSegment, value: "/decrypt")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Decrypt_564410(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Decrypts a single block of encrypted data
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_564412 = path.getOrDefault("key-version")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "key-version", valid_564412
  var valid_564413 = path.getOrDefault("key-name")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "key-name", valid_564413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564414 = query.getOrDefault("api-version")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "api-version", valid_564414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for key operations.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564416: Call_Decrypt_564409; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Decrypts a single block of encrypted data
  ## 
  let valid = call_564416.validator(path, query, header, formData, body)
  let scheme = call_564416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564416.url(scheme.get, call_564416.host, call_564416.base,
                         call_564416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564416, url, valid)

proc call*(call_564417: Call_Decrypt_564409; apiVersion: string; keyVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## decrypt
  ## Decrypts a single block of encrypted data
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyVersion: string (required)
  ##             : The version of the key
  ##   parameters: JObject (required)
  ##             : The parameters for key operations.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564418 = newJObject()
  var query_564419 = newJObject()
  var body_564420 = newJObject()
  add(query_564419, "api-version", newJString(apiVersion))
  add(path_564418, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564420 = parameters
  add(path_564418, "key-name", newJString(keyName))
  result = call_564417.call(path_564418, query_564419, nil, nil, body_564420)

var decrypt* = Call_Decrypt_564409(name: "decrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/decrypt",
                                validator: validate_Decrypt_564410, base: "",
                                url: url_Decrypt_564411, schemes: {Scheme.Https})
type
  Call_Encrypt_564421 = ref object of OpenApiRestCall_563564
proc url_Encrypt_564423(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  assert "key-version" in path, "`key-version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "key-version"),
               (kind: ConstantSegment, value: "/encrypt")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Encrypt_564422(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Encrypts an arbitrary sequence of bytes using an encryption key that is stored in Azure Key Vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_564424 = path.getOrDefault("key-version")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "key-version", valid_564424
  var valid_564425 = path.getOrDefault("key-name")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "key-name", valid_564425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564426 = query.getOrDefault("api-version")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "api-version", valid_564426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for key operations.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564428: Call_Encrypt_564421; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Encrypts an arbitrary sequence of bytes using an encryption key that is stored in Azure Key Vault.
  ## 
  let valid = call_564428.validator(path, query, header, formData, body)
  let scheme = call_564428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564428.url(scheme.get, call_564428.host, call_564428.base,
                         call_564428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564428, url, valid)

proc call*(call_564429: Call_Encrypt_564421; apiVersion: string; keyVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## encrypt
  ## Encrypts an arbitrary sequence of bytes using an encryption key that is stored in Azure Key Vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyVersion: string (required)
  ##             : The version of the key
  ##   parameters: JObject (required)
  ##             : The parameters for key operations.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564430 = newJObject()
  var query_564431 = newJObject()
  var body_564432 = newJObject()
  add(query_564431, "api-version", newJString(apiVersion))
  add(path_564430, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564432 = parameters
  add(path_564430, "key-name", newJString(keyName))
  result = call_564429.call(path_564430, query_564431, nil, nil, body_564432)

var encrypt* = Call_Encrypt_564421(name: "encrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/encrypt",
                                validator: validate_Encrypt_564422, base: "",
                                url: url_Encrypt_564423, schemes: {Scheme.Https})
type
  Call_Sign_564433 = ref object of OpenApiRestCall_563564
proc url_Sign_564435(protocol: Scheme; host: string; base: string; route: string;
                    path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  assert "key-version" in path, "`key-version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "key-version"),
               (kind: ConstantSegment, value: "/sign")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Sign_564434(path: JsonNode; query: JsonNode; header: JsonNode;
                         formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a signature from a digest using the specified key in the vault
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_564436 = path.getOrDefault("key-version")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "key-version", valid_564436
  var valid_564437 = path.getOrDefault("key-name")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "key-name", valid_564437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564438 = query.getOrDefault("api-version")
  valid_564438 = validateParameter(valid_564438, JString, required = true,
                                 default = nil)
  if valid_564438 != nil:
    section.add "api-version", valid_564438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for key operations.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564440: Call_Sign_564433; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a signature from a digest using the specified key in the vault
  ## 
  let valid = call_564440.validator(path, query, header, formData, body)
  let scheme = call_564440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564440.url(scheme.get, call_564440.host, call_564440.base,
                         call_564440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564440, url, valid)

proc call*(call_564441: Call_Sign_564433; apiVersion: string; keyVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## sign
  ## Creates a signature from a digest using the specified key in the vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyVersion: string (required)
  ##             : The version of the key
  ##   parameters: JObject (required)
  ##             : The parameters for key operations.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564442 = newJObject()
  var query_564443 = newJObject()
  var body_564444 = newJObject()
  add(query_564443, "api-version", newJString(apiVersion))
  add(path_564442, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564444 = parameters
  add(path_564442, "key-name", newJString(keyName))
  result = call_564441.call(path_564442, query_564443, nil, nil, body_564444)

var sign* = Call_Sign_564433(name: "sign", meth: HttpMethod.HttpPost,
                          host: "azure.local",
                          route: "/keys/{key-name}/{key-version}/sign",
                          validator: validate_Sign_564434, base: "", url: url_Sign_564435,
                          schemes: {Scheme.Https})
type
  Call_UnwrapKey_564445 = ref object of OpenApiRestCall_563564
proc url_UnwrapKey_564447(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  assert "key-version" in path, "`key-version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "key-version"),
               (kind: ConstantSegment, value: "/unwrapkey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UnwrapKey_564446(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Unwraps a symmetric key using the specified key in the vault that has initially been used for wrapping the key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_564448 = path.getOrDefault("key-version")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "key-version", valid_564448
  var valid_564449 = path.getOrDefault("key-name")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "key-name", valid_564449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564450 = query.getOrDefault("api-version")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "api-version", valid_564450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for key operations.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564452: Call_UnwrapKey_564445; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unwraps a symmetric key using the specified key in the vault that has initially been used for wrapping the key.
  ## 
  let valid = call_564452.validator(path, query, header, formData, body)
  let scheme = call_564452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564452.url(scheme.get, call_564452.host, call_564452.base,
                         call_564452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564452, url, valid)

proc call*(call_564453: Call_UnwrapKey_564445; apiVersion: string;
          keyVersion: string; parameters: JsonNode; keyName: string): Recallable =
  ## unwrapKey
  ## Unwraps a symmetric key using the specified key in the vault that has initially been used for wrapping the key.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyVersion: string (required)
  ##             : The version of the key
  ##   parameters: JObject (required)
  ##             : The parameters for key operations.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564454 = newJObject()
  var query_564455 = newJObject()
  var body_564456 = newJObject()
  add(query_564455, "api-version", newJString(apiVersion))
  add(path_564454, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564456 = parameters
  add(path_564454, "key-name", newJString(keyName))
  result = call_564453.call(path_564454, query_564455, nil, nil, body_564456)

var unwrapKey* = Call_UnwrapKey_564445(name: "unwrapKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/keys/{key-name}/{key-version}/unwrapkey",
                                    validator: validate_UnwrapKey_564446,
                                    base: "", url: url_UnwrapKey_564447,
                                    schemes: {Scheme.Https})
type
  Call_Verify_564457 = ref object of OpenApiRestCall_563564
proc url_Verify_564459(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  assert "key-version" in path, "`key-version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "key-version"),
               (kind: ConstantSegment, value: "/verify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Verify_564458(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies a signature using the specified key
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_564460 = path.getOrDefault("key-version")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "key-version", valid_564460
  var valid_564461 = path.getOrDefault("key-name")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "key-name", valid_564461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564462 = query.getOrDefault("api-version")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "api-version", valid_564462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for key operations.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564464: Call_Verify_564457; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verifies a signature using the specified key
  ## 
  let valid = call_564464.validator(path, query, header, formData, body)
  let scheme = call_564464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564464.url(scheme.get, call_564464.host, call_564464.base,
                         call_564464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564464, url, valid)

proc call*(call_564465: Call_Verify_564457; apiVersion: string; keyVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## verify
  ## Verifies a signature using the specified key
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyVersion: string (required)
  ##             : The version of the key
  ##   parameters: JObject (required)
  ##             : The parameters for key operations.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564466 = newJObject()
  var query_564467 = newJObject()
  var body_564468 = newJObject()
  add(query_564467, "api-version", newJString(apiVersion))
  add(path_564466, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564468 = parameters
  add(path_564466, "key-name", newJString(keyName))
  result = call_564465.call(path_564466, query_564467, nil, nil, body_564468)

var verify* = Call_Verify_564457(name: "verify", meth: HttpMethod.HttpPost,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}/verify",
                              validator: validate_Verify_564458, base: "",
                              url: url_Verify_564459, schemes: {Scheme.Https})
type
  Call_WrapKey_564469 = ref object of OpenApiRestCall_563564
proc url_WrapKey_564471(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  assert "key-version" in path, "`key-version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/keys/"),
               (kind: VariableSegment, value: "key-name"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "key-version"),
               (kind: ConstantSegment, value: "/wrapkey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WrapKey_564470(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Wraps a symmetric key using the specified key
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_564472 = path.getOrDefault("key-version")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "key-version", valid_564472
  var valid_564473 = path.getOrDefault("key-name")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "key-name", valid_564473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564474 = query.getOrDefault("api-version")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "api-version", valid_564474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for key operations.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564476: Call_WrapKey_564469; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Wraps a symmetric key using the specified key
  ## 
  let valid = call_564476.validator(path, query, header, formData, body)
  let scheme = call_564476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564476.url(scheme.get, call_564476.host, call_564476.base,
                         call_564476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564476, url, valid)

proc call*(call_564477: Call_WrapKey_564469; apiVersion: string; keyVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## wrapKey
  ## Wraps a symmetric key using the specified key
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyVersion: string (required)
  ##             : The version of the key
  ##   parameters: JObject (required)
  ##             : The parameters for key operations.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564478 = newJObject()
  var query_564479 = newJObject()
  var body_564480 = newJObject()
  add(query_564479, "api-version", newJString(apiVersion))
  add(path_564478, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564480 = parameters
  add(path_564478, "key-name", newJString(keyName))
  result = call_564477.call(path_564478, query_564479, nil, nil, body_564480)

var wrapKey* = Call_WrapKey_564469(name: "wrapKey", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/wrapkey",
                                validator: validate_WrapKey_564470, base: "",
                                url: url_WrapKey_564471, schemes: {Scheme.Https})
type
  Call_GetSecrets_564481 = ref object of OpenApiRestCall_563564
proc url_GetSecrets_564483(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetSecrets_564482(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## List secrets in the specified vault
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564484 = query.getOrDefault("api-version")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "api-version", valid_564484
  var valid_564485 = query.getOrDefault("maxresults")
  valid_564485 = validateParameter(valid_564485, JInt, required = false, default = nil)
  if valid_564485 != nil:
    section.add "maxresults", valid_564485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564486: Call_GetSecrets_564481; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List secrets in the specified vault
  ## 
  let valid = call_564486.validator(path, query, header, formData, body)
  let scheme = call_564486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564486.url(scheme.get, call_564486.host, call_564486.base,
                         call_564486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564486, url, valid)

proc call*(call_564487: Call_GetSecrets_564481; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getSecrets
  ## List secrets in the specified vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564488 = newJObject()
  add(query_564488, "api-version", newJString(apiVersion))
  add(query_564488, "maxresults", newJInt(maxresults))
  result = call_564487.call(nil, query_564488, nil, nil, nil)

var getSecrets* = Call_GetSecrets_564481(name: "getSecrets",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/secrets",
                                      validator: validate_GetSecrets_564482,
                                      base: "", url: url_GetSecrets_564483,
                                      schemes: {Scheme.Https})
type
  Call_SetSecret_564489 = ref object of OpenApiRestCall_563564
proc url_SetSecret_564491(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "secret-name" in path, "`secret-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "secret-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SetSecret_564490(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets a secret in the specified vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-name: JString (required)
  ##              : The name of the secret in the given vault
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-name` field"
  var valid_564492 = path.getOrDefault("secret-name")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "secret-name", valid_564492
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564493 = query.getOrDefault("api-version")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "api-version", valid_564493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for secret set
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564495: Call_SetSecret_564489; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets a secret in the specified vault.
  ## 
  let valid = call_564495.validator(path, query, header, formData, body)
  let scheme = call_564495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564495.url(scheme.get, call_564495.host, call_564495.base,
                         call_564495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564495, url, valid)

proc call*(call_564496: Call_SetSecret_564489; apiVersion: string;
          secretName: string; parameters: JsonNode): Recallable =
  ## setSecret
  ## Sets a secret in the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret in the given vault
  ##   parameters: JObject (required)
  ##             : The parameters for secret set
  var path_564497 = newJObject()
  var query_564498 = newJObject()
  var body_564499 = newJObject()
  add(query_564498, "api-version", newJString(apiVersion))
  add(path_564497, "secret-name", newJString(secretName))
  if parameters != nil:
    body_564499 = parameters
  result = call_564496.call(path_564497, query_564498, nil, nil, body_564499)

var setSecret* = Call_SetSecret_564489(name: "setSecret", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/secrets/{secret-name}",
                                    validator: validate_SetSecret_564490,
                                    base: "", url: url_SetSecret_564491,
                                    schemes: {Scheme.Https})
type
  Call_DeleteSecret_564500 = ref object of OpenApiRestCall_563564
proc url_DeleteSecret_564502(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "secret-name" in path, "`secret-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "secret-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteSecret_564501(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a secret from the specified vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-name: JString (required)
  ##              : The name of the secret in the given vault
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-name` field"
  var valid_564503 = path.getOrDefault("secret-name")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "secret-name", valid_564503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564504 = query.getOrDefault("api-version")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "api-version", valid_564504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564505: Call_DeleteSecret_564500; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a secret from the specified vault.
  ## 
  let valid = call_564505.validator(path, query, header, formData, body)
  let scheme = call_564505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564505.url(scheme.get, call_564505.host, call_564505.base,
                         call_564505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564505, url, valid)

proc call*(call_564506: Call_DeleteSecret_564500; apiVersion: string;
          secretName: string): Recallable =
  ## deleteSecret
  ## Deletes a secret from the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret in the given vault
  var path_564507 = newJObject()
  var query_564508 = newJObject()
  add(query_564508, "api-version", newJString(apiVersion))
  add(path_564507, "secret-name", newJString(secretName))
  result = call_564506.call(path_564507, query_564508, nil, nil, nil)

var deleteSecret* = Call_DeleteSecret_564500(name: "deleteSecret",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/secrets/{secret-name}", validator: validate_DeleteSecret_564501,
    base: "", url: url_DeleteSecret_564502, schemes: {Scheme.Https})
type
  Call_GetSecretVersions_564509 = ref object of OpenApiRestCall_563564
proc url_GetSecretVersions_564511(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "secret-name" in path, "`secret-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "secret-name"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetSecretVersions_564510(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List the versions of the specified secret
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-name: JString (required)
  ##              : The name of the secret in the given vault
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-name` field"
  var valid_564512 = path.getOrDefault("secret-name")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "secret-name", valid_564512
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564513 = query.getOrDefault("api-version")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "api-version", valid_564513
  var valid_564514 = query.getOrDefault("maxresults")
  valid_564514 = validateParameter(valid_564514, JInt, required = false, default = nil)
  if valid_564514 != nil:
    section.add "maxresults", valid_564514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564515: Call_GetSecretVersions_564509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the versions of the specified secret
  ## 
  let valid = call_564515.validator(path, query, header, formData, body)
  let scheme = call_564515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564515.url(scheme.get, call_564515.host, call_564515.base,
                         call_564515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564515, url, valid)

proc call*(call_564516: Call_GetSecretVersions_564509; apiVersion: string;
          secretName: string; maxresults: int = 0): Recallable =
  ## getSecretVersions
  ## List the versions of the specified secret
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret in the given vault
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var path_564517 = newJObject()
  var query_564518 = newJObject()
  add(query_564518, "api-version", newJString(apiVersion))
  add(path_564517, "secret-name", newJString(secretName))
  add(query_564518, "maxresults", newJInt(maxresults))
  result = call_564516.call(path_564517, query_564518, nil, nil, nil)

var getSecretVersions* = Call_GetSecretVersions_564509(name: "getSecretVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/secrets/{secret-name}/versions",
    validator: validate_GetSecretVersions_564510, base: "",
    url: url_GetSecretVersions_564511, schemes: {Scheme.Https})
type
  Call_GetSecret_564519 = ref object of OpenApiRestCall_563564
proc url_GetSecret_564521(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "secret-name" in path, "`secret-name` is a required path parameter"
  assert "secret-version" in path, "`secret-version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "secret-name"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "secret-version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetSecret_564520(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-version: JString (required)
  ##                 : The version of the secret
  ##   secret-name: JString (required)
  ##              : The name of the secret in the given vault
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-version` field"
  var valid_564522 = path.getOrDefault("secret-version")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "secret-version", valid_564522
  var valid_564523 = path.getOrDefault("secret-name")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = nil)
  if valid_564523 != nil:
    section.add "secret-name", valid_564523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564524 = query.getOrDefault("api-version")
  valid_564524 = validateParameter(valid_564524, JString, required = true,
                                 default = nil)
  if valid_564524 != nil:
    section.add "api-version", valid_564524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564525: Call_GetSecret_564519; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a secret.
  ## 
  let valid = call_564525.validator(path, query, header, formData, body)
  let scheme = call_564525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564525.url(scheme.get, call_564525.host, call_564525.base,
                         call_564525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564525, url, valid)

proc call*(call_564526: Call_GetSecret_564519; apiVersion: string;
          secretVersion: string; secretName: string): Recallable =
  ## getSecret
  ## Gets a secret.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretVersion: string (required)
  ##                : The version of the secret
  ##   secretName: string (required)
  ##             : The name of the secret in the given vault
  var path_564527 = newJObject()
  var query_564528 = newJObject()
  add(query_564528, "api-version", newJString(apiVersion))
  add(path_564527, "secret-version", newJString(secretVersion))
  add(path_564527, "secret-name", newJString(secretName))
  result = call_564526.call(path_564527, query_564528, nil, nil, nil)

var getSecret* = Call_GetSecret_564519(name: "getSecret", meth: HttpMethod.HttpGet,
                                    host: "azure.local", route: "/secrets/{secret-name}/{secret-version}",
                                    validator: validate_GetSecret_564520,
                                    base: "", url: url_GetSecret_564521,
                                    schemes: {Scheme.Https})
type
  Call_UpdateSecret_564529 = ref object of OpenApiRestCall_563564
proc url_UpdateSecret_564531(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "secret-name" in path, "`secret-name` is a required path parameter"
  assert "secret-version" in path, "`secret-version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "secret-name"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "secret-version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateSecret_564530(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the attributes associated with the specified secret
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-version: JString (required)
  ##                 : The version of the secret
  ##   secret-name: JString (required)
  ##              : The name of the secret in the given vault
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-version` field"
  var valid_564532 = path.getOrDefault("secret-version")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "secret-version", valid_564532
  var valid_564533 = path.getOrDefault("secret-name")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "secret-name", valid_564533
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564534 = query.getOrDefault("api-version")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "api-version", valid_564534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564536: Call_UpdateSecret_564529; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the attributes associated with the specified secret
  ## 
  let valid = call_564536.validator(path, query, header, formData, body)
  let scheme = call_564536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564536.url(scheme.get, call_564536.host, call_564536.base,
                         call_564536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564536, url, valid)

proc call*(call_564537: Call_UpdateSecret_564529; apiVersion: string;
          secretVersion: string; secretName: string; parameters: JsonNode): Recallable =
  ## updateSecret
  ## Updates the attributes associated with the specified secret
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretVersion: string (required)
  ##                : The version of the secret
  ##   secretName: string (required)
  ##             : The name of the secret in the given vault
  ##   parameters: JObject (required)
  var path_564538 = newJObject()
  var query_564539 = newJObject()
  var body_564540 = newJObject()
  add(query_564539, "api-version", newJString(apiVersion))
  add(path_564538, "secret-version", newJString(secretVersion))
  add(path_564538, "secret-name", newJString(secretName))
  if parameters != nil:
    body_564540 = parameters
  result = call_564537.call(path_564538, query_564539, nil, nil, body_564540)

var updateSecret* = Call_UpdateSecret_564529(name: "updateSecret",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/secrets/{secret-name}/{secret-version}",
    validator: validate_UpdateSecret_564530, base: "", url: url_UpdateSecret_564531,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
