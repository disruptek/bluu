
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

  OpenApiRestCall_573666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573666): Option[Scheme] {.used.} =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "keyvault"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetCertificates_573888 = ref object of OpenApiRestCall_573666
proc url_GetCertificates_573890(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificates_573889(path: JsonNode; query: JsonNode;
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
  var valid_574049 = query.getOrDefault("api-version")
  valid_574049 = validateParameter(valid_574049, JString, required = true,
                                 default = nil)
  if valid_574049 != nil:
    section.add "api-version", valid_574049
  var valid_574050 = query.getOrDefault("maxresults")
  valid_574050 = validateParameter(valid_574050, JInt, required = false, default = nil)
  if valid_574050 != nil:
    section.add "maxresults", valid_574050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574073: Call_GetCertificates_573888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List certificates in the specified vault
  ## 
  let valid = call_574073.validator(path, query, header, formData, body)
  let scheme = call_574073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574073.url(scheme.get, call_574073.host, call_574073.base,
                         call_574073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574073, url, valid)

proc call*(call_574144: Call_GetCertificates_573888; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getCertificates
  ## List certificates in the specified vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_574145 = newJObject()
  add(query_574145, "api-version", newJString(apiVersion))
  add(query_574145, "maxresults", newJInt(maxresults))
  result = call_574144.call(nil, query_574145, nil, nil, nil)

var getCertificates* = Call_GetCertificates_573888(name: "getCertificates",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates",
    validator: validate_GetCertificates_573889, base: "", url: url_GetCertificates_573890,
    schemes: {Scheme.Https})
type
  Call_SetCertificateContacts_574192 = ref object of OpenApiRestCall_573666
proc url_SetCertificateContacts_574194(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SetCertificateContacts_574193(path: JsonNode; query: JsonNode;
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
  var valid_574212 = query.getOrDefault("api-version")
  valid_574212 = validateParameter(valid_574212, JString, required = true,
                                 default = nil)
  if valid_574212 != nil:
    section.add "api-version", valid_574212
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

proc call*(call_574214: Call_SetCertificateContacts_574192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the certificate contacts for the specified vault.
  ## 
  let valid = call_574214.validator(path, query, header, formData, body)
  let scheme = call_574214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574214.url(scheme.get, call_574214.host, call_574214.base,
                         call_574214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574214, url, valid)

proc call*(call_574215: Call_SetCertificateContacts_574192; apiVersion: string;
          contacts: JsonNode): Recallable =
  ## setCertificateContacts
  ## Sets the certificate contacts for the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   contacts: JObject (required)
  ##           : The contacts for the vault certificates.
  var query_574216 = newJObject()
  var body_574217 = newJObject()
  add(query_574216, "api-version", newJString(apiVersion))
  if contacts != nil:
    body_574217 = contacts
  result = call_574215.call(nil, query_574216, nil, nil, body_574217)

var setCertificateContacts* = Call_SetCertificateContacts_574192(
    name: "setCertificateContacts", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/certificates/contacts", validator: validate_SetCertificateContacts_574193,
    base: "", url: url_SetCertificateContacts_574194, schemes: {Scheme.Https})
type
  Call_GetCertificateContacts_574185 = ref object of OpenApiRestCall_573666
proc url_GetCertificateContacts_574187(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificateContacts_574186(path: JsonNode; query: JsonNode;
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
  var valid_574188 = query.getOrDefault("api-version")
  valid_574188 = validateParameter(valid_574188, JString, required = true,
                                 default = nil)
  if valid_574188 != nil:
    section.add "api-version", valid_574188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574189: Call_GetCertificateContacts_574185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the certificate contacts for the specified vault.
  ## 
  let valid = call_574189.validator(path, query, header, formData, body)
  let scheme = call_574189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574189.url(scheme.get, call_574189.host, call_574189.base,
                         call_574189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574189, url, valid)

proc call*(call_574190: Call_GetCertificateContacts_574185; apiVersion: string): Recallable =
  ## getCertificateContacts
  ## Gets the certificate contacts for the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_574191 = newJObject()
  add(query_574191, "api-version", newJString(apiVersion))
  result = call_574190.call(nil, query_574191, nil, nil, nil)

var getCertificateContacts* = Call_GetCertificateContacts_574185(
    name: "getCertificateContacts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/contacts", validator: validate_GetCertificateContacts_574186,
    base: "", url: url_GetCertificateContacts_574187, schemes: {Scheme.Https})
type
  Call_DeleteCertificateContacts_574218 = ref object of OpenApiRestCall_573666
proc url_DeleteCertificateContacts_574220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeleteCertificateContacts_574219(path: JsonNode; query: JsonNode;
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
  var valid_574221 = query.getOrDefault("api-version")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "api-version", valid_574221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574222: Call_DeleteCertificateContacts_574218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the certificate contacts for the specified vault.
  ## 
  let valid = call_574222.validator(path, query, header, formData, body)
  let scheme = call_574222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574222.url(scheme.get, call_574222.host, call_574222.base,
                         call_574222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574222, url, valid)

proc call*(call_574223: Call_DeleteCertificateContacts_574218; apiVersion: string): Recallable =
  ## deleteCertificateContacts
  ## Deletes the certificate contacts for the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_574224 = newJObject()
  add(query_574224, "api-version", newJString(apiVersion))
  result = call_574223.call(nil, query_574224, nil, nil, nil)

var deleteCertificateContacts* = Call_DeleteCertificateContacts_574218(
    name: "deleteCertificateContacts", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/contacts",
    validator: validate_DeleteCertificateContacts_574219, base: "",
    url: url_DeleteCertificateContacts_574220, schemes: {Scheme.Https})
type
  Call_GetCertificateIssuers_574225 = ref object of OpenApiRestCall_573666
proc url_GetCertificateIssuers_574227(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificateIssuers_574226(path: JsonNode; query: JsonNode;
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
  var valid_574228 = query.getOrDefault("api-version")
  valid_574228 = validateParameter(valid_574228, JString, required = true,
                                 default = nil)
  if valid_574228 != nil:
    section.add "api-version", valid_574228
  var valid_574229 = query.getOrDefault("maxresults")
  valid_574229 = validateParameter(valid_574229, JInt, required = false, default = nil)
  if valid_574229 != nil:
    section.add "maxresults", valid_574229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574230: Call_GetCertificateIssuers_574225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List certificate issuers for the specified vault.
  ## 
  let valid = call_574230.validator(path, query, header, formData, body)
  let scheme = call_574230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574230.url(scheme.get, call_574230.host, call_574230.base,
                         call_574230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574230, url, valid)

proc call*(call_574231: Call_GetCertificateIssuers_574225; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getCertificateIssuers
  ## List certificate issuers for the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_574232 = newJObject()
  add(query_574232, "api-version", newJString(apiVersion))
  add(query_574232, "maxresults", newJInt(maxresults))
  result = call_574231.call(nil, query_574232, nil, nil, nil)

var getCertificateIssuers* = Call_GetCertificateIssuers_574225(
    name: "getCertificateIssuers", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/issuers", validator: validate_GetCertificateIssuers_574226,
    base: "", url: url_GetCertificateIssuers_574227, schemes: {Scheme.Https})
type
  Call_SetCertificateIssuer_574256 = ref object of OpenApiRestCall_573666
proc url_SetCertificateIssuer_574258(protocol: Scheme; host: string; base: string;
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

proc validate_SetCertificateIssuer_574257(path: JsonNode; query: JsonNode;
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
  var valid_574259 = path.getOrDefault("issuer-name")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "issuer-name", valid_574259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574260 = query.getOrDefault("api-version")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "api-version", valid_574260
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

proc call*(call_574262: Call_SetCertificateIssuer_574256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the specified certificate issuer.
  ## 
  let valid = call_574262.validator(path, query, header, formData, body)
  let scheme = call_574262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574262.url(scheme.get, call_574262.host, call_574262.base,
                         call_574262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574262, url, valid)

proc call*(call_574263: Call_SetCertificateIssuer_574256; apiVersion: string;
          parameter: JsonNode; issuerName: string): Recallable =
  ## setCertificateIssuer
  ## Sets the specified certificate issuer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameter: JObject (required)
  ##            : Certificate issuer set parameter.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_574264 = newJObject()
  var query_574265 = newJObject()
  var body_574266 = newJObject()
  add(query_574265, "api-version", newJString(apiVersion))
  if parameter != nil:
    body_574266 = parameter
  add(path_574264, "issuer-name", newJString(issuerName))
  result = call_574263.call(path_574264, query_574265, nil, nil, body_574266)

var setCertificateIssuer* = Call_SetCertificateIssuer_574256(
    name: "setCertificateIssuer", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/certificates/issuers/{issuer-name}",
    validator: validate_SetCertificateIssuer_574257, base: "",
    url: url_SetCertificateIssuer_574258, schemes: {Scheme.Https})
type
  Call_GetCertificateIssuer_574233 = ref object of OpenApiRestCall_573666
proc url_GetCertificateIssuer_574235(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificateIssuer_574234(path: JsonNode; query: JsonNode;
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
  var valid_574250 = path.getOrDefault("issuer-name")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "issuer-name", valid_574250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574251 = query.getOrDefault("api-version")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "api-version", valid_574251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574252: Call_GetCertificateIssuer_574233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified certificate issuer.
  ## 
  let valid = call_574252.validator(path, query, header, formData, body)
  let scheme = call_574252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574252.url(scheme.get, call_574252.host, call_574252.base,
                         call_574252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574252, url, valid)

proc call*(call_574253: Call_GetCertificateIssuer_574233; apiVersion: string;
          issuerName: string): Recallable =
  ## getCertificateIssuer
  ## Gets the specified certificate issuer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_574254 = newJObject()
  var query_574255 = newJObject()
  add(query_574255, "api-version", newJString(apiVersion))
  add(path_574254, "issuer-name", newJString(issuerName))
  result = call_574253.call(path_574254, query_574255, nil, nil, nil)

var getCertificateIssuer* = Call_GetCertificateIssuer_574233(
    name: "getCertificateIssuer", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/issuers/{issuer-name}",
    validator: validate_GetCertificateIssuer_574234, base: "",
    url: url_GetCertificateIssuer_574235, schemes: {Scheme.Https})
type
  Call_UpdateCertificateIssuer_574276 = ref object of OpenApiRestCall_573666
proc url_UpdateCertificateIssuer_574278(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCertificateIssuer_574277(path: JsonNode; query: JsonNode;
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
  var valid_574279 = path.getOrDefault("issuer-name")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "issuer-name", valid_574279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574280 = query.getOrDefault("api-version")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "api-version", valid_574280
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

proc call*(call_574282: Call_UpdateCertificateIssuer_574276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified certificate issuer.
  ## 
  let valid = call_574282.validator(path, query, header, formData, body)
  let scheme = call_574282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574282.url(scheme.get, call_574282.host, call_574282.base,
                         call_574282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574282, url, valid)

proc call*(call_574283: Call_UpdateCertificateIssuer_574276; apiVersion: string;
          parameter: JsonNode; issuerName: string): Recallable =
  ## updateCertificateIssuer
  ## Updates the specified certificate issuer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameter: JObject (required)
  ##            : Certificate issuer update parameter.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_574284 = newJObject()
  var query_574285 = newJObject()
  var body_574286 = newJObject()
  add(query_574285, "api-version", newJString(apiVersion))
  if parameter != nil:
    body_574286 = parameter
  add(path_574284, "issuer-name", newJString(issuerName))
  result = call_574283.call(path_574284, query_574285, nil, nil, body_574286)

var updateCertificateIssuer* = Call_UpdateCertificateIssuer_574276(
    name: "updateCertificateIssuer", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/issuers/{issuer-name}",
    validator: validate_UpdateCertificateIssuer_574277, base: "",
    url: url_UpdateCertificateIssuer_574278, schemes: {Scheme.Https})
type
  Call_DeleteCertificateIssuer_574267 = ref object of OpenApiRestCall_573666
proc url_DeleteCertificateIssuer_574269(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteCertificateIssuer_574268(path: JsonNode; query: JsonNode;
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
  var valid_574270 = path.getOrDefault("issuer-name")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "issuer-name", valid_574270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574271 = query.getOrDefault("api-version")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "api-version", valid_574271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574272: Call_DeleteCertificateIssuer_574267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified certificate issuer.
  ## 
  let valid = call_574272.validator(path, query, header, formData, body)
  let scheme = call_574272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574272.url(scheme.get, call_574272.host, call_574272.base,
                         call_574272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574272, url, valid)

proc call*(call_574273: Call_DeleteCertificateIssuer_574267; apiVersion: string;
          issuerName: string): Recallable =
  ## deleteCertificateIssuer
  ## Deletes the specified certificate issuer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_574274 = newJObject()
  var query_574275 = newJObject()
  add(query_574275, "api-version", newJString(apiVersion))
  add(path_574274, "issuer-name", newJString(issuerName))
  result = call_574273.call(path_574274, query_574275, nil, nil, nil)

var deleteCertificateIssuer* = Call_DeleteCertificateIssuer_574267(
    name: "deleteCertificateIssuer", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/issuers/{issuer-name}",
    validator: validate_DeleteCertificateIssuer_574268, base: "",
    url: url_DeleteCertificateIssuer_574269, schemes: {Scheme.Https})
type
  Call_DeleteCertificate_574287 = ref object of OpenApiRestCall_573666
proc url_DeleteCertificate_574289(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteCertificate_574288(path: JsonNode; query: JsonNode;
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
  var valid_574290 = path.getOrDefault("certificate-name")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "certificate-name", valid_574290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574291 = query.getOrDefault("api-version")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = nil)
  if valid_574291 != nil:
    section.add "api-version", valid_574291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574292: Call_DeleteCertificate_574287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a certificate from the specified vault.
  ## 
  let valid = call_574292.validator(path, query, header, formData, body)
  let scheme = call_574292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574292.url(scheme.get, call_574292.host, call_574292.base,
                         call_574292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574292, url, valid)

proc call*(call_574293: Call_DeleteCertificate_574287; apiVersion: string;
          certificateName: string): Recallable =
  ## deleteCertificate
  ## Deletes a certificate from the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault
  var path_574294 = newJObject()
  var query_574295 = newJObject()
  add(query_574295, "api-version", newJString(apiVersion))
  add(path_574294, "certificate-name", newJString(certificateName))
  result = call_574293.call(path_574294, query_574295, nil, nil, nil)

var deleteCertificate* = Call_DeleteCertificate_574287(name: "deleteCertificate",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/certificates/{certificate-name}",
    validator: validate_DeleteCertificate_574288, base: "",
    url: url_DeleteCertificate_574289, schemes: {Scheme.Https})
type
  Call_CreateCertificate_574296 = ref object of OpenApiRestCall_573666
proc url_CreateCertificate_574298(protocol: Scheme; host: string; base: string;
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

proc validate_CreateCertificate_574297(path: JsonNode; query: JsonNode;
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
  var valid_574299 = path.getOrDefault("certificate-name")
  valid_574299 = validateParameter(valid_574299, JString, required = true,
                                 default = nil)
  if valid_574299 != nil:
    section.add "certificate-name", valid_574299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574300 = query.getOrDefault("api-version")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "api-version", valid_574300
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

proc call*(call_574302: Call_CreateCertificate_574296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new certificate version. If this is the first version, the certificate resource is created.
  ## 
  let valid = call_574302.validator(path, query, header, formData, body)
  let scheme = call_574302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574302.url(scheme.get, call_574302.host, call_574302.base,
                         call_574302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574302, url, valid)

proc call*(call_574303: Call_CreateCertificate_574296; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## createCertificate
  ## Creates a new certificate version. If this is the first version, the certificate resource is created.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  ##   parameters: JObject (required)
  ##             : The parameters to create certificate.
  var path_574304 = newJObject()
  var query_574305 = newJObject()
  var body_574306 = newJObject()
  add(query_574305, "api-version", newJString(apiVersion))
  add(path_574304, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_574306 = parameters
  result = call_574303.call(path_574304, query_574305, nil, nil, body_574306)

var createCertificate* = Call_CreateCertificate_574296(name: "createCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/create",
    validator: validate_CreateCertificate_574297, base: "",
    url: url_CreateCertificate_574298, schemes: {Scheme.Https})
type
  Call_ImportCertificate_574307 = ref object of OpenApiRestCall_573666
proc url_ImportCertificate_574309(protocol: Scheme; host: string; base: string;
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

proc validate_ImportCertificate_574308(path: JsonNode; query: JsonNode;
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
  var valid_574310 = path.getOrDefault("certificate-name")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "certificate-name", valid_574310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574311 = query.getOrDefault("api-version")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "api-version", valid_574311
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

proc call*(call_574313: Call_ImportCertificate_574307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a certificate into the specified vault
  ## 
  let valid = call_574313.validator(path, query, header, formData, body)
  let scheme = call_574313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574313.url(scheme.get, call_574313.host, call_574313.base,
                         call_574313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574313, url, valid)

proc call*(call_574314: Call_ImportCertificate_574307; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## importCertificate
  ## Imports a certificate into the specified vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  ##   parameters: JObject (required)
  ##             : The parameters to import certificate.
  var path_574315 = newJObject()
  var query_574316 = newJObject()
  var body_574317 = newJObject()
  add(query_574316, "api-version", newJString(apiVersion))
  add(path_574315, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_574317 = parameters
  result = call_574314.call(path_574315, query_574316, nil, nil, body_574317)

var importCertificate* = Call_ImportCertificate_574307(name: "importCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/import",
    validator: validate_ImportCertificate_574308, base: "",
    url: url_ImportCertificate_574309, schemes: {Scheme.Https})
type
  Call_GetCertificateOperation_574318 = ref object of OpenApiRestCall_573666
proc url_GetCertificateOperation_574320(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificateOperation_574319(path: JsonNode; query: JsonNode;
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
  var valid_574321 = path.getOrDefault("certificate-name")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "certificate-name", valid_574321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574322 = query.getOrDefault("api-version")
  valid_574322 = validateParameter(valid_574322, JString, required = true,
                                 default = nil)
  if valid_574322 != nil:
    section.add "api-version", valid_574322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574323: Call_GetCertificateOperation_574318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the certificate operation response.
  ## 
  let valid = call_574323.validator(path, query, header, formData, body)
  let scheme = call_574323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574323.url(scheme.get, call_574323.host, call_574323.base,
                         call_574323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574323, url, valid)

proc call*(call_574324: Call_GetCertificateOperation_574318; apiVersion: string;
          certificateName: string): Recallable =
  ## getCertificateOperation
  ## Gets the certificate operation response.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_574325 = newJObject()
  var query_574326 = newJObject()
  add(query_574326, "api-version", newJString(apiVersion))
  add(path_574325, "certificate-name", newJString(certificateName))
  result = call_574324.call(path_574325, query_574326, nil, nil, nil)

var getCertificateOperation* = Call_GetCertificateOperation_574318(
    name: "getCertificateOperation", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/pending",
    validator: validate_GetCertificateOperation_574319, base: "",
    url: url_GetCertificateOperation_574320, schemes: {Scheme.Https})
type
  Call_UpdateCertificateOperation_574336 = ref object of OpenApiRestCall_573666
proc url_UpdateCertificateOperation_574338(protocol: Scheme; host: string;
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

proc validate_UpdateCertificateOperation_574337(path: JsonNode; query: JsonNode;
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
  var valid_574339 = path.getOrDefault("certificate-name")
  valid_574339 = validateParameter(valid_574339, JString, required = true,
                                 default = nil)
  if valid_574339 != nil:
    section.add "certificate-name", valid_574339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574340 = query.getOrDefault("api-version")
  valid_574340 = validateParameter(valid_574340, JString, required = true,
                                 default = nil)
  if valid_574340 != nil:
    section.add "api-version", valid_574340
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

proc call*(call_574342: Call_UpdateCertificateOperation_574336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a certificate operation.
  ## 
  let valid = call_574342.validator(path, query, header, formData, body)
  let scheme = call_574342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574342.url(scheme.get, call_574342.host, call_574342.base,
                         call_574342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574342, url, valid)

proc call*(call_574343: Call_UpdateCertificateOperation_574336; apiVersion: string;
          certificateName: string; certificateOperation: JsonNode): Recallable =
  ## updateCertificateOperation
  ## Updates a certificate operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  ##   certificateOperation: JObject (required)
  ##                       : The certificate operation response.
  var path_574344 = newJObject()
  var query_574345 = newJObject()
  var body_574346 = newJObject()
  add(query_574345, "api-version", newJString(apiVersion))
  add(path_574344, "certificate-name", newJString(certificateName))
  if certificateOperation != nil:
    body_574346 = certificateOperation
  result = call_574343.call(path_574344, query_574345, nil, nil, body_574346)

var updateCertificateOperation* = Call_UpdateCertificateOperation_574336(
    name: "updateCertificateOperation", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/{certificate-name}/pending",
    validator: validate_UpdateCertificateOperation_574337, base: "",
    url: url_UpdateCertificateOperation_574338, schemes: {Scheme.Https})
type
  Call_DeleteCertificateOperation_574327 = ref object of OpenApiRestCall_573666
proc url_DeleteCertificateOperation_574329(protocol: Scheme; host: string;
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

proc validate_DeleteCertificateOperation_574328(path: JsonNode; query: JsonNode;
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
  var valid_574330 = path.getOrDefault("certificate-name")
  valid_574330 = validateParameter(valid_574330, JString, required = true,
                                 default = nil)
  if valid_574330 != nil:
    section.add "certificate-name", valid_574330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574331 = query.getOrDefault("api-version")
  valid_574331 = validateParameter(valid_574331, JString, required = true,
                                 default = nil)
  if valid_574331 != nil:
    section.add "api-version", valid_574331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574332: Call_DeleteCertificateOperation_574327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the certificate operation.
  ## 
  let valid = call_574332.validator(path, query, header, formData, body)
  let scheme = call_574332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574332.url(scheme.get, call_574332.host, call_574332.base,
                         call_574332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574332, url, valid)

proc call*(call_574333: Call_DeleteCertificateOperation_574327; apiVersion: string;
          certificateName: string): Recallable =
  ## deleteCertificateOperation
  ## Deletes the certificate operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_574334 = newJObject()
  var query_574335 = newJObject()
  add(query_574335, "api-version", newJString(apiVersion))
  add(path_574334, "certificate-name", newJString(certificateName))
  result = call_574333.call(path_574334, query_574335, nil, nil, nil)

var deleteCertificateOperation* = Call_DeleteCertificateOperation_574327(
    name: "deleteCertificateOperation", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/{certificate-name}/pending",
    validator: validate_DeleteCertificateOperation_574328, base: "",
    url: url_DeleteCertificateOperation_574329, schemes: {Scheme.Https})
type
  Call_MergeCertificate_574347 = ref object of OpenApiRestCall_573666
proc url_MergeCertificate_574349(protocol: Scheme; host: string; base: string;
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

proc validate_MergeCertificate_574348(path: JsonNode; query: JsonNode;
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
  var valid_574350 = path.getOrDefault("certificate-name")
  valid_574350 = validateParameter(valid_574350, JString, required = true,
                                 default = nil)
  if valid_574350 != nil:
    section.add "certificate-name", valid_574350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574351 = query.getOrDefault("api-version")
  valid_574351 = validateParameter(valid_574351, JString, required = true,
                                 default = nil)
  if valid_574351 != nil:
    section.add "api-version", valid_574351
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

proc call*(call_574353: Call_MergeCertificate_574347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Merges a certificate or a certificate chain with a key pair existing on the server.
  ## 
  let valid = call_574353.validator(path, query, header, formData, body)
  let scheme = call_574353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574353.url(scheme.get, call_574353.host, call_574353.base,
                         call_574353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574353, url, valid)

proc call*(call_574354: Call_MergeCertificate_574347; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## mergeCertificate
  ## Merges a certificate or a certificate chain with a key pair existing on the server.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  ##   parameters: JObject (required)
  ##             : The parameters to merge certificate.
  var path_574355 = newJObject()
  var query_574356 = newJObject()
  var body_574357 = newJObject()
  add(query_574356, "api-version", newJString(apiVersion))
  add(path_574355, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_574357 = parameters
  result = call_574354.call(path_574355, query_574356, nil, nil, body_574357)

var mergeCertificate* = Call_MergeCertificate_574347(name: "mergeCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/pending/merge",
    validator: validate_MergeCertificate_574348, base: "",
    url: url_MergeCertificate_574349, schemes: {Scheme.Https})
type
  Call_GetCertificatePolicy_574358 = ref object of OpenApiRestCall_573666
proc url_GetCertificatePolicy_574360(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificatePolicy_574359(path: JsonNode; query: JsonNode;
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
  var valid_574361 = path.getOrDefault("certificate-name")
  valid_574361 = validateParameter(valid_574361, JString, required = true,
                                 default = nil)
  if valid_574361 != nil:
    section.add "certificate-name", valid_574361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574362 = query.getOrDefault("api-version")
  valid_574362 = validateParameter(valid_574362, JString, required = true,
                                 default = nil)
  if valid_574362 != nil:
    section.add "api-version", valid_574362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574363: Call_GetCertificatePolicy_574358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the policy for a certificate.
  ## 
  let valid = call_574363.validator(path, query, header, formData, body)
  let scheme = call_574363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574363.url(scheme.get, call_574363.host, call_574363.base,
                         call_574363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574363, url, valid)

proc call*(call_574364: Call_GetCertificatePolicy_574358; apiVersion: string;
          certificateName: string): Recallable =
  ## getCertificatePolicy
  ## Gets the policy for a certificate.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault.
  var path_574365 = newJObject()
  var query_574366 = newJObject()
  add(query_574366, "api-version", newJString(apiVersion))
  add(path_574365, "certificate-name", newJString(certificateName))
  result = call_574364.call(path_574365, query_574366, nil, nil, nil)

var getCertificatePolicy* = Call_GetCertificatePolicy_574358(
    name: "getCertificatePolicy", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/policy",
    validator: validate_GetCertificatePolicy_574359, base: "",
    url: url_GetCertificatePolicy_574360, schemes: {Scheme.Https})
type
  Call_UpdateCertificatePolicy_574367 = ref object of OpenApiRestCall_573666
proc url_UpdateCertificatePolicy_574369(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCertificatePolicy_574368(path: JsonNode; query: JsonNode;
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
  var valid_574370 = path.getOrDefault("certificate-name")
  valid_574370 = validateParameter(valid_574370, JString, required = true,
                                 default = nil)
  if valid_574370 != nil:
    section.add "certificate-name", valid_574370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574371 = query.getOrDefault("api-version")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "api-version", valid_574371
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

proc call*(call_574373: Call_UpdateCertificatePolicy_574367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the policy for a certificate. Set appropriate members in the certificatePolicy that must be updated. Leave others as null.
  ## 
  let valid = call_574373.validator(path, query, header, formData, body)
  let scheme = call_574373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574373.url(scheme.get, call_574373.host, call_574373.base,
                         call_574373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574373, url, valid)

proc call*(call_574374: Call_UpdateCertificatePolicy_574367; apiVersion: string;
          certificateName: string; certificatePolicy: JsonNode): Recallable =
  ## updateCertificatePolicy
  ## Updates the policy for a certificate. Set appropriate members in the certificatePolicy that must be updated. Leave others as null.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault.
  ##   certificatePolicy: JObject (required)
  ##                    : The policy for the certificate.
  var path_574375 = newJObject()
  var query_574376 = newJObject()
  var body_574377 = newJObject()
  add(query_574376, "api-version", newJString(apiVersion))
  add(path_574375, "certificate-name", newJString(certificateName))
  if certificatePolicy != nil:
    body_574377 = certificatePolicy
  result = call_574374.call(path_574375, query_574376, nil, nil, body_574377)

var updateCertificatePolicy* = Call_UpdateCertificatePolicy_574367(
    name: "updateCertificatePolicy", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/{certificate-name}/policy",
    validator: validate_UpdateCertificatePolicy_574368, base: "",
    url: url_UpdateCertificatePolicy_574369, schemes: {Scheme.Https})
type
  Call_GetCertificateVersions_574378 = ref object of OpenApiRestCall_573666
proc url_GetCertificateVersions_574380(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificateVersions_574379(path: JsonNode; query: JsonNode;
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
  var valid_574381 = path.getOrDefault("certificate-name")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "certificate-name", valid_574381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574382 = query.getOrDefault("api-version")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "api-version", valid_574382
  var valid_574383 = query.getOrDefault("maxresults")
  valid_574383 = validateParameter(valid_574383, JInt, required = false, default = nil)
  if valid_574383 != nil:
    section.add "maxresults", valid_574383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574384: Call_GetCertificateVersions_574378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the versions of a certificate.
  ## 
  let valid = call_574384.validator(path, query, header, formData, body)
  let scheme = call_574384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574384.url(scheme.get, call_574384.host, call_574384.base,
                         call_574384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574384, url, valid)

proc call*(call_574385: Call_GetCertificateVersions_574378; apiVersion: string;
          certificateName: string; maxresults: int = 0): Recallable =
  ## getCertificateVersions
  ## List the versions of a certificate.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var path_574386 = newJObject()
  var query_574387 = newJObject()
  add(query_574387, "api-version", newJString(apiVersion))
  add(path_574386, "certificate-name", newJString(certificateName))
  add(query_574387, "maxresults", newJInt(maxresults))
  result = call_574385.call(path_574386, query_574387, nil, nil, nil)

var getCertificateVersions* = Call_GetCertificateVersions_574378(
    name: "getCertificateVersions", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/versions",
    validator: validate_GetCertificateVersions_574379, base: "",
    url: url_GetCertificateVersions_574380, schemes: {Scheme.Https})
type
  Call_GetCertificate_574388 = ref object of OpenApiRestCall_573666
proc url_GetCertificate_574390(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificate_574389(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a Certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate in the given vault
  ##   certificate-version: JString (required)
  ##                      : The version of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_574391 = path.getOrDefault("certificate-name")
  valid_574391 = validateParameter(valid_574391, JString, required = true,
                                 default = nil)
  if valid_574391 != nil:
    section.add "certificate-name", valid_574391
  var valid_574392 = path.getOrDefault("certificate-version")
  valid_574392 = validateParameter(valid_574392, JString, required = true,
                                 default = nil)
  if valid_574392 != nil:
    section.add "certificate-version", valid_574392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574393 = query.getOrDefault("api-version")
  valid_574393 = validateParameter(valid_574393, JString, required = true,
                                 default = nil)
  if valid_574393 != nil:
    section.add "api-version", valid_574393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574394: Call_GetCertificate_574388; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Certificate.
  ## 
  let valid = call_574394.validator(path, query, header, formData, body)
  let scheme = call_574394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574394.url(scheme.get, call_574394.host, call_574394.base,
                         call_574394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574394, url, valid)

proc call*(call_574395: Call_GetCertificate_574388; apiVersion: string;
          certificateName: string; certificateVersion: string): Recallable =
  ## getCertificate
  ## Gets a Certificate.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault
  ##   certificateVersion: string (required)
  ##                     : The version of the certificate
  var path_574396 = newJObject()
  var query_574397 = newJObject()
  add(query_574397, "api-version", newJString(apiVersion))
  add(path_574396, "certificate-name", newJString(certificateName))
  add(path_574396, "certificate-version", newJString(certificateVersion))
  result = call_574395.call(path_574396, query_574397, nil, nil, nil)

var getCertificate* = Call_GetCertificate_574388(name: "getCertificate",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/{certificate-version}",
    validator: validate_GetCertificate_574389, base: "", url: url_GetCertificate_574390,
    schemes: {Scheme.Https})
type
  Call_UpdateCertificate_574398 = ref object of OpenApiRestCall_573666
proc url_UpdateCertificate_574400(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCertificate_574399(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the attributes associated with the specified certificate
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate in the given vault
  ##   certificate-version: JString (required)
  ##                      : The version of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_574401 = path.getOrDefault("certificate-name")
  valid_574401 = validateParameter(valid_574401, JString, required = true,
                                 default = nil)
  if valid_574401 != nil:
    section.add "certificate-name", valid_574401
  var valid_574402 = path.getOrDefault("certificate-version")
  valid_574402 = validateParameter(valid_574402, JString, required = true,
                                 default = nil)
  if valid_574402 != nil:
    section.add "certificate-version", valid_574402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574403 = query.getOrDefault("api-version")
  valid_574403 = validateParameter(valid_574403, JString, required = true,
                                 default = nil)
  if valid_574403 != nil:
    section.add "api-version", valid_574403
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

proc call*(call_574405: Call_UpdateCertificate_574398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the attributes associated with the specified certificate
  ## 
  let valid = call_574405.validator(path, query, header, formData, body)
  let scheme = call_574405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574405.url(scheme.get, call_574405.host, call_574405.base,
                         call_574405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574405, url, valid)

proc call*(call_574406: Call_UpdateCertificate_574398; apiVersion: string;
          certificateName: string; certificateVersion: string; parameters: JsonNode): Recallable =
  ## updateCertificate
  ## Updates the attributes associated with the specified certificate
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault
  ##   certificateVersion: string (required)
  ##                     : The version of the certificate
  ##   parameters: JObject (required)
  var path_574407 = newJObject()
  var query_574408 = newJObject()
  var body_574409 = newJObject()
  add(query_574408, "api-version", newJString(apiVersion))
  add(path_574407, "certificate-name", newJString(certificateName))
  add(path_574407, "certificate-version", newJString(certificateVersion))
  if parameters != nil:
    body_574409 = parameters
  result = call_574406.call(path_574407, query_574408, nil, nil, body_574409)

var updateCertificate* = Call_UpdateCertificate_574398(name: "updateCertificate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/certificates/{certificate-name}/{certificate-version}",
    validator: validate_UpdateCertificate_574399, base: "",
    url: url_UpdateCertificate_574400, schemes: {Scheme.Https})
type
  Call_GetKeys_574410 = ref object of OpenApiRestCall_573666
proc url_GetKeys_574412(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetKeys_574411(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574413 = query.getOrDefault("api-version")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = nil)
  if valid_574413 != nil:
    section.add "api-version", valid_574413
  var valid_574414 = query.getOrDefault("maxresults")
  valid_574414 = validateParameter(valid_574414, JInt, required = false, default = nil)
  if valid_574414 != nil:
    section.add "maxresults", valid_574414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574415: Call_GetKeys_574410; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List keys in the specified vault
  ## 
  let valid = call_574415.validator(path, query, header, formData, body)
  let scheme = call_574415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574415.url(scheme.get, call_574415.host, call_574415.base,
                         call_574415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574415, url, valid)

proc call*(call_574416: Call_GetKeys_574410; apiVersion: string; maxresults: int = 0): Recallable =
  ## getKeys
  ## List keys in the specified vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_574417 = newJObject()
  add(query_574417, "api-version", newJString(apiVersion))
  add(query_574417, "maxresults", newJInt(maxresults))
  result = call_574416.call(nil, query_574417, nil, nil, nil)

var getKeys* = Call_GetKeys_574410(name: "getKeys", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/keys",
                                validator: validate_GetKeys_574411, base: "",
                                url: url_GetKeys_574412, schemes: {Scheme.Https})
type
  Call_RestoreKey_574418 = ref object of OpenApiRestCall_573666
proc url_RestoreKey_574420(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreKey_574419(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574421 = query.getOrDefault("api-version")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "api-version", valid_574421
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

proc call*(call_574423: Call_RestoreKey_574418; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the backup key in to a vault
  ## 
  let valid = call_574423.validator(path, query, header, formData, body)
  let scheme = call_574423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574423.url(scheme.get, call_574423.host, call_574423.base,
                         call_574423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574423, url, valid)

proc call*(call_574424: Call_RestoreKey_574418; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreKey
  ## Restores the backup key in to a vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore key
  var query_574425 = newJObject()
  var body_574426 = newJObject()
  add(query_574425, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574426 = parameters
  result = call_574424.call(nil, query_574425, nil, nil, body_574426)

var restoreKey* = Call_RestoreKey_574418(name: "restoreKey",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/keys/restore",
                                      validator: validate_RestoreKey_574419,
                                      base: "", url: url_RestoreKey_574420,
                                      schemes: {Scheme.Https})
type
  Call_ImportKey_574427 = ref object of OpenApiRestCall_573666
proc url_ImportKey_574429(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImportKey_574428(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574430 = path.getOrDefault("key-name")
  valid_574430 = validateParameter(valid_574430, JString, required = true,
                                 default = nil)
  if valid_574430 != nil:
    section.add "key-name", valid_574430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574431 = query.getOrDefault("api-version")
  valid_574431 = validateParameter(valid_574431, JString, required = true,
                                 default = nil)
  if valid_574431 != nil:
    section.add "api-version", valid_574431
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

proc call*(call_574433: Call_ImportKey_574427; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a key into the specified vault
  ## 
  let valid = call_574433.validator(path, query, header, formData, body)
  let scheme = call_574433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574433.url(scheme.get, call_574433.host, call_574433.base,
                         call_574433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574433, url, valid)

proc call*(call_574434: Call_ImportKey_574427; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## importKey
  ## Imports a key into the specified vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The parameters to import key.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_574435 = newJObject()
  var query_574436 = newJObject()
  var body_574437 = newJObject()
  add(query_574436, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574437 = parameters
  add(path_574435, "key-name", newJString(keyName))
  result = call_574434.call(path_574435, query_574436, nil, nil, body_574437)

var importKey* = Call_ImportKey_574427(name: "importKey", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_ImportKey_574428,
                                    base: "", url: url_ImportKey_574429,
                                    schemes: {Scheme.Https})
type
  Call_DeleteKey_574438 = ref object of OpenApiRestCall_573666
proc url_DeleteKey_574440(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DeleteKey_574439(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574441 = path.getOrDefault("key-name")
  valid_574441 = validateParameter(valid_574441, JString, required = true,
                                 default = nil)
  if valid_574441 != nil:
    section.add "key-name", valid_574441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574442 = query.getOrDefault("api-version")
  valid_574442 = validateParameter(valid_574442, JString, required = true,
                                 default = nil)
  if valid_574442 != nil:
    section.add "api-version", valid_574442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574443: Call_DeleteKey_574438; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified key
  ## 
  let valid = call_574443.validator(path, query, header, formData, body)
  let scheme = call_574443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574443.url(scheme.get, call_574443.host, call_574443.base,
                         call_574443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574443, url, valid)

proc call*(call_574444: Call_DeleteKey_574438; apiVersion: string; keyName: string): Recallable =
  ## deleteKey
  ## Deletes the specified key
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_574445 = newJObject()
  var query_574446 = newJObject()
  add(query_574446, "api-version", newJString(apiVersion))
  add(path_574445, "key-name", newJString(keyName))
  result = call_574444.call(path_574445, query_574446, nil, nil, nil)

var deleteKey* = Call_DeleteKey_574438(name: "deleteKey",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_DeleteKey_574439,
                                    base: "", url: url_DeleteKey_574440,
                                    schemes: {Scheme.Https})
type
  Call_BackupKey_574447 = ref object of OpenApiRestCall_573666
proc url_BackupKey_574449(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BackupKey_574448(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574450 = path.getOrDefault("key-name")
  valid_574450 = validateParameter(valid_574450, JString, required = true,
                                 default = nil)
  if valid_574450 != nil:
    section.add "key-name", valid_574450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574451 = query.getOrDefault("api-version")
  valid_574451 = validateParameter(valid_574451, JString, required = true,
                                 default = nil)
  if valid_574451 != nil:
    section.add "api-version", valid_574451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574452: Call_BackupKey_574447; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified key be downloaded to the client.
  ## 
  let valid = call_574452.validator(path, query, header, formData, body)
  let scheme = call_574452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574452.url(scheme.get, call_574452.host, call_574452.base,
                         call_574452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574452, url, valid)

proc call*(call_574453: Call_BackupKey_574447; apiVersion: string; keyName: string): Recallable =
  ## backupKey
  ## Requests that a backup of the specified key be downloaded to the client.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_574454 = newJObject()
  var query_574455 = newJObject()
  add(query_574455, "api-version", newJString(apiVersion))
  add(path_574454, "key-name", newJString(keyName))
  result = call_574453.call(path_574454, query_574455, nil, nil, nil)

var backupKey* = Call_BackupKey_574447(name: "backupKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/backup",
                                    validator: validate_BackupKey_574448,
                                    base: "", url: url_BackupKey_574449,
                                    schemes: {Scheme.Https})
type
  Call_CreateKey_574456 = ref object of OpenApiRestCall_573666
proc url_CreateKey_574458(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CreateKey_574457(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574469 = path.getOrDefault("key-name")
  valid_574469 = validateParameter(valid_574469, JString, required = true,
                                 default = nil)
  if valid_574469 != nil:
    section.add "key-name", valid_574469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574470 = query.getOrDefault("api-version")
  valid_574470 = validateParameter(valid_574470, JString, required = true,
                                 default = nil)
  if valid_574470 != nil:
    section.add "api-version", valid_574470
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

proc call*(call_574472: Call_CreateKey_574456; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new, named, key in the specified vault.
  ## 
  let valid = call_574472.validator(path, query, header, formData, body)
  let scheme = call_574472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574472.url(scheme.get, call_574472.host, call_574472.base,
                         call_574472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574472, url, valid)

proc call*(call_574473: Call_CreateKey_574456; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## createKey
  ## Creates a new, named, key in the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The parameters to create key.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_574474 = newJObject()
  var query_574475 = newJObject()
  var body_574476 = newJObject()
  add(query_574475, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574476 = parameters
  add(path_574474, "key-name", newJString(keyName))
  result = call_574473.call(path_574474, query_574475, nil, nil, body_574476)

var createKey* = Call_CreateKey_574456(name: "createKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/create",
                                    validator: validate_CreateKey_574457,
                                    base: "", url: url_CreateKey_574458,
                                    schemes: {Scheme.Https})
type
  Call_GetKeyVersions_574477 = ref object of OpenApiRestCall_573666
proc url_GetKeyVersions_574479(protocol: Scheme; host: string; base: string;
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

proc validate_GetKeyVersions_574478(path: JsonNode; query: JsonNode;
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
  var valid_574480 = path.getOrDefault("key-name")
  valid_574480 = validateParameter(valid_574480, JString, required = true,
                                 default = nil)
  if valid_574480 != nil:
    section.add "key-name", valid_574480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574481 = query.getOrDefault("api-version")
  valid_574481 = validateParameter(valid_574481, JString, required = true,
                                 default = nil)
  if valid_574481 != nil:
    section.add "api-version", valid_574481
  var valid_574482 = query.getOrDefault("maxresults")
  valid_574482 = validateParameter(valid_574482, JInt, required = false, default = nil)
  if valid_574482 != nil:
    section.add "maxresults", valid_574482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574483: Call_GetKeyVersions_574477; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the versions of the specified key
  ## 
  let valid = call_574483.validator(path, query, header, formData, body)
  let scheme = call_574483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574483.url(scheme.get, call_574483.host, call_574483.base,
                         call_574483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574483, url, valid)

proc call*(call_574484: Call_GetKeyVersions_574477; apiVersion: string;
          keyName: string; maxresults: int = 0): Recallable =
  ## getKeyVersions
  ## List the versions of the specified key
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_574485 = newJObject()
  var query_574486 = newJObject()
  add(query_574486, "api-version", newJString(apiVersion))
  add(query_574486, "maxresults", newJInt(maxresults))
  add(path_574485, "key-name", newJString(keyName))
  result = call_574484.call(path_574485, query_574486, nil, nil, nil)

var getKeyVersions* = Call_GetKeyVersions_574477(name: "getKeyVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/keys/{key-name}/versions", validator: validate_GetKeyVersions_574478,
    base: "", url: url_GetKeyVersions_574479, schemes: {Scheme.Https})
type
  Call_GetKey_574487 = ref object of OpenApiRestCall_573666
proc url_GetKey_574489(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetKey_574488(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574490 = path.getOrDefault("key-version")
  valid_574490 = validateParameter(valid_574490, JString, required = true,
                                 default = nil)
  if valid_574490 != nil:
    section.add "key-version", valid_574490
  var valid_574491 = path.getOrDefault("key-name")
  valid_574491 = validateParameter(valid_574491, JString, required = true,
                                 default = nil)
  if valid_574491 != nil:
    section.add "key-name", valid_574491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574492 = query.getOrDefault("api-version")
  valid_574492 = validateParameter(valid_574492, JString, required = true,
                                 default = nil)
  if valid_574492 != nil:
    section.add "api-version", valid_574492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574493: Call_GetKey_574487; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the public portion of a key plus its attributes
  ## 
  let valid = call_574493.validator(path, query, header, formData, body)
  let scheme = call_574493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574493.url(scheme.get, call_574493.host, call_574493.base,
                         call_574493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574493, url, valid)

proc call*(call_574494: Call_GetKey_574487; apiVersion: string; keyVersion: string;
          keyName: string): Recallable =
  ## getKey
  ## Retrieves the public portion of a key plus its attributes
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   keyVersion: string (required)
  ##             : The version of the key
  ##   keyName: string (required)
  ##          : The name of the key
  var path_574495 = newJObject()
  var query_574496 = newJObject()
  add(query_574496, "api-version", newJString(apiVersion))
  add(path_574495, "key-version", newJString(keyVersion))
  add(path_574495, "key-name", newJString(keyName))
  result = call_574494.call(path_574495, query_574496, nil, nil, nil)

var getKey* = Call_GetKey_574487(name: "getKey", meth: HttpMethod.HttpGet,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}",
                              validator: validate_GetKey_574488, base: "",
                              url: url_GetKey_574489, schemes: {Scheme.Https})
type
  Call_UpdateKey_574497 = ref object of OpenApiRestCall_573666
proc url_UpdateKey_574499(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UpdateKey_574498(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574500 = path.getOrDefault("key-version")
  valid_574500 = validateParameter(valid_574500, JString, required = true,
                                 default = nil)
  if valid_574500 != nil:
    section.add "key-version", valid_574500
  var valid_574501 = path.getOrDefault("key-name")
  valid_574501 = validateParameter(valid_574501, JString, required = true,
                                 default = nil)
  if valid_574501 != nil:
    section.add "key-name", valid_574501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574502 = query.getOrDefault("api-version")
  valid_574502 = validateParameter(valid_574502, JString, required = true,
                                 default = nil)
  if valid_574502 != nil:
    section.add "api-version", valid_574502
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

proc call*(call_574504: Call_UpdateKey_574497; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the Key Attributes associated with the specified key
  ## 
  let valid = call_574504.validator(path, query, header, formData, body)
  let scheme = call_574504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574504.url(scheme.get, call_574504.host, call_574504.base,
                         call_574504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574504, url, valid)

proc call*(call_574505: Call_UpdateKey_574497; apiVersion: string;
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
  var path_574506 = newJObject()
  var query_574507 = newJObject()
  var body_574508 = newJObject()
  add(query_574507, "api-version", newJString(apiVersion))
  add(path_574506, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574508 = parameters
  add(path_574506, "key-name", newJString(keyName))
  result = call_574505.call(path_574506, query_574507, nil, nil, body_574508)

var updateKey* = Call_UpdateKey_574497(name: "updateKey", meth: HttpMethod.HttpPatch,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/{key-version}",
                                    validator: validate_UpdateKey_574498,
                                    base: "", url: url_UpdateKey_574499,
                                    schemes: {Scheme.Https})
type
  Call_Decrypt_574509 = ref object of OpenApiRestCall_573666
proc url_Decrypt_574511(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Decrypt_574510(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574512 = path.getOrDefault("key-version")
  valid_574512 = validateParameter(valid_574512, JString, required = true,
                                 default = nil)
  if valid_574512 != nil:
    section.add "key-version", valid_574512
  var valid_574513 = path.getOrDefault("key-name")
  valid_574513 = validateParameter(valid_574513, JString, required = true,
                                 default = nil)
  if valid_574513 != nil:
    section.add "key-name", valid_574513
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574514 = query.getOrDefault("api-version")
  valid_574514 = validateParameter(valid_574514, JString, required = true,
                                 default = nil)
  if valid_574514 != nil:
    section.add "api-version", valid_574514
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

proc call*(call_574516: Call_Decrypt_574509; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Decrypts a single block of encrypted data
  ## 
  let valid = call_574516.validator(path, query, header, formData, body)
  let scheme = call_574516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574516.url(scheme.get, call_574516.host, call_574516.base,
                         call_574516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574516, url, valid)

proc call*(call_574517: Call_Decrypt_574509; apiVersion: string; keyVersion: string;
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
  var path_574518 = newJObject()
  var query_574519 = newJObject()
  var body_574520 = newJObject()
  add(query_574519, "api-version", newJString(apiVersion))
  add(path_574518, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574520 = parameters
  add(path_574518, "key-name", newJString(keyName))
  result = call_574517.call(path_574518, query_574519, nil, nil, body_574520)

var decrypt* = Call_Decrypt_574509(name: "decrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/decrypt",
                                validator: validate_Decrypt_574510, base: "",
                                url: url_Decrypt_574511, schemes: {Scheme.Https})
type
  Call_Encrypt_574521 = ref object of OpenApiRestCall_573666
proc url_Encrypt_574523(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Encrypt_574522(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574524 = path.getOrDefault("key-version")
  valid_574524 = validateParameter(valid_574524, JString, required = true,
                                 default = nil)
  if valid_574524 != nil:
    section.add "key-version", valid_574524
  var valid_574525 = path.getOrDefault("key-name")
  valid_574525 = validateParameter(valid_574525, JString, required = true,
                                 default = nil)
  if valid_574525 != nil:
    section.add "key-name", valid_574525
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574526 = query.getOrDefault("api-version")
  valid_574526 = validateParameter(valid_574526, JString, required = true,
                                 default = nil)
  if valid_574526 != nil:
    section.add "api-version", valid_574526
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

proc call*(call_574528: Call_Encrypt_574521; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Encrypts an arbitrary sequence of bytes using an encryption key that is stored in Azure Key Vault.
  ## 
  let valid = call_574528.validator(path, query, header, formData, body)
  let scheme = call_574528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574528.url(scheme.get, call_574528.host, call_574528.base,
                         call_574528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574528, url, valid)

proc call*(call_574529: Call_Encrypt_574521; apiVersion: string; keyVersion: string;
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
  var path_574530 = newJObject()
  var query_574531 = newJObject()
  var body_574532 = newJObject()
  add(query_574531, "api-version", newJString(apiVersion))
  add(path_574530, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574532 = parameters
  add(path_574530, "key-name", newJString(keyName))
  result = call_574529.call(path_574530, query_574531, nil, nil, body_574532)

var encrypt* = Call_Encrypt_574521(name: "encrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/encrypt",
                                validator: validate_Encrypt_574522, base: "",
                                url: url_Encrypt_574523, schemes: {Scheme.Https})
type
  Call_Sign_574533 = ref object of OpenApiRestCall_573666
proc url_Sign_574535(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Sign_574534(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574536 = path.getOrDefault("key-version")
  valid_574536 = validateParameter(valid_574536, JString, required = true,
                                 default = nil)
  if valid_574536 != nil:
    section.add "key-version", valid_574536
  var valid_574537 = path.getOrDefault("key-name")
  valid_574537 = validateParameter(valid_574537, JString, required = true,
                                 default = nil)
  if valid_574537 != nil:
    section.add "key-name", valid_574537
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574538 = query.getOrDefault("api-version")
  valid_574538 = validateParameter(valid_574538, JString, required = true,
                                 default = nil)
  if valid_574538 != nil:
    section.add "api-version", valid_574538
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

proc call*(call_574540: Call_Sign_574533; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a signature from a digest using the specified key in the vault
  ## 
  let valid = call_574540.validator(path, query, header, formData, body)
  let scheme = call_574540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574540.url(scheme.get, call_574540.host, call_574540.base,
                         call_574540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574540, url, valid)

proc call*(call_574541: Call_Sign_574533; apiVersion: string; keyVersion: string;
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
  var path_574542 = newJObject()
  var query_574543 = newJObject()
  var body_574544 = newJObject()
  add(query_574543, "api-version", newJString(apiVersion))
  add(path_574542, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574544 = parameters
  add(path_574542, "key-name", newJString(keyName))
  result = call_574541.call(path_574542, query_574543, nil, nil, body_574544)

var sign* = Call_Sign_574533(name: "sign", meth: HttpMethod.HttpPost,
                          host: "azure.local",
                          route: "/keys/{key-name}/{key-version}/sign",
                          validator: validate_Sign_574534, base: "", url: url_Sign_574535,
                          schemes: {Scheme.Https})
type
  Call_UnwrapKey_574545 = ref object of OpenApiRestCall_573666
proc url_UnwrapKey_574547(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UnwrapKey_574546(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574548 = path.getOrDefault("key-version")
  valid_574548 = validateParameter(valid_574548, JString, required = true,
                                 default = nil)
  if valid_574548 != nil:
    section.add "key-version", valid_574548
  var valid_574549 = path.getOrDefault("key-name")
  valid_574549 = validateParameter(valid_574549, JString, required = true,
                                 default = nil)
  if valid_574549 != nil:
    section.add "key-name", valid_574549
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574550 = query.getOrDefault("api-version")
  valid_574550 = validateParameter(valid_574550, JString, required = true,
                                 default = nil)
  if valid_574550 != nil:
    section.add "api-version", valid_574550
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

proc call*(call_574552: Call_UnwrapKey_574545; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unwraps a symmetric key using the specified key in the vault that has initially been used for wrapping the key.
  ## 
  let valid = call_574552.validator(path, query, header, formData, body)
  let scheme = call_574552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574552.url(scheme.get, call_574552.host, call_574552.base,
                         call_574552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574552, url, valid)

proc call*(call_574553: Call_UnwrapKey_574545; apiVersion: string;
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
  var path_574554 = newJObject()
  var query_574555 = newJObject()
  var body_574556 = newJObject()
  add(query_574555, "api-version", newJString(apiVersion))
  add(path_574554, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574556 = parameters
  add(path_574554, "key-name", newJString(keyName))
  result = call_574553.call(path_574554, query_574555, nil, nil, body_574556)

var unwrapKey* = Call_UnwrapKey_574545(name: "unwrapKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/keys/{key-name}/{key-version}/unwrapkey",
                                    validator: validate_UnwrapKey_574546,
                                    base: "", url: url_UnwrapKey_574547,
                                    schemes: {Scheme.Https})
type
  Call_Verify_574557 = ref object of OpenApiRestCall_573666
proc url_Verify_574559(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Verify_574558(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574560 = path.getOrDefault("key-version")
  valid_574560 = validateParameter(valid_574560, JString, required = true,
                                 default = nil)
  if valid_574560 != nil:
    section.add "key-version", valid_574560
  var valid_574561 = path.getOrDefault("key-name")
  valid_574561 = validateParameter(valid_574561, JString, required = true,
                                 default = nil)
  if valid_574561 != nil:
    section.add "key-name", valid_574561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574562 = query.getOrDefault("api-version")
  valid_574562 = validateParameter(valid_574562, JString, required = true,
                                 default = nil)
  if valid_574562 != nil:
    section.add "api-version", valid_574562
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

proc call*(call_574564: Call_Verify_574557; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verifies a signature using the specified key
  ## 
  let valid = call_574564.validator(path, query, header, formData, body)
  let scheme = call_574564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574564.url(scheme.get, call_574564.host, call_574564.base,
                         call_574564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574564, url, valid)

proc call*(call_574565: Call_Verify_574557; apiVersion: string; keyVersion: string;
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
  var path_574566 = newJObject()
  var query_574567 = newJObject()
  var body_574568 = newJObject()
  add(query_574567, "api-version", newJString(apiVersion))
  add(path_574566, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574568 = parameters
  add(path_574566, "key-name", newJString(keyName))
  result = call_574565.call(path_574566, query_574567, nil, nil, body_574568)

var verify* = Call_Verify_574557(name: "verify", meth: HttpMethod.HttpPost,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}/verify",
                              validator: validate_Verify_574558, base: "",
                              url: url_Verify_574559, schemes: {Scheme.Https})
type
  Call_WrapKey_574569 = ref object of OpenApiRestCall_573666
proc url_WrapKey_574571(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_WrapKey_574570(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574572 = path.getOrDefault("key-version")
  valid_574572 = validateParameter(valid_574572, JString, required = true,
                                 default = nil)
  if valid_574572 != nil:
    section.add "key-version", valid_574572
  var valid_574573 = path.getOrDefault("key-name")
  valid_574573 = validateParameter(valid_574573, JString, required = true,
                                 default = nil)
  if valid_574573 != nil:
    section.add "key-name", valid_574573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574574 = query.getOrDefault("api-version")
  valid_574574 = validateParameter(valid_574574, JString, required = true,
                                 default = nil)
  if valid_574574 != nil:
    section.add "api-version", valid_574574
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

proc call*(call_574576: Call_WrapKey_574569; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Wraps a symmetric key using the specified key
  ## 
  let valid = call_574576.validator(path, query, header, formData, body)
  let scheme = call_574576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574576.url(scheme.get, call_574576.host, call_574576.base,
                         call_574576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574576, url, valid)

proc call*(call_574577: Call_WrapKey_574569; apiVersion: string; keyVersion: string;
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
  var path_574578 = newJObject()
  var query_574579 = newJObject()
  var body_574580 = newJObject()
  add(query_574579, "api-version", newJString(apiVersion))
  add(path_574578, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574580 = parameters
  add(path_574578, "key-name", newJString(keyName))
  result = call_574577.call(path_574578, query_574579, nil, nil, body_574580)

var wrapKey* = Call_WrapKey_574569(name: "wrapKey", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/wrapkey",
                                validator: validate_WrapKey_574570, base: "",
                                url: url_WrapKey_574571, schemes: {Scheme.Https})
type
  Call_GetSecrets_574581 = ref object of OpenApiRestCall_573666
proc url_GetSecrets_574583(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetSecrets_574582(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574584 = query.getOrDefault("api-version")
  valid_574584 = validateParameter(valid_574584, JString, required = true,
                                 default = nil)
  if valid_574584 != nil:
    section.add "api-version", valid_574584
  var valid_574585 = query.getOrDefault("maxresults")
  valid_574585 = validateParameter(valid_574585, JInt, required = false, default = nil)
  if valid_574585 != nil:
    section.add "maxresults", valid_574585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574586: Call_GetSecrets_574581; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List secrets in the specified vault
  ## 
  let valid = call_574586.validator(path, query, header, formData, body)
  let scheme = call_574586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574586.url(scheme.get, call_574586.host, call_574586.base,
                         call_574586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574586, url, valid)

proc call*(call_574587: Call_GetSecrets_574581; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getSecrets
  ## List secrets in the specified vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_574588 = newJObject()
  add(query_574588, "api-version", newJString(apiVersion))
  add(query_574588, "maxresults", newJInt(maxresults))
  result = call_574587.call(nil, query_574588, nil, nil, nil)

var getSecrets* = Call_GetSecrets_574581(name: "getSecrets",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/secrets",
                                      validator: validate_GetSecrets_574582,
                                      base: "", url: url_GetSecrets_574583,
                                      schemes: {Scheme.Https})
type
  Call_SetSecret_574589 = ref object of OpenApiRestCall_573666
proc url_SetSecret_574591(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SetSecret_574590(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574592 = path.getOrDefault("secret-name")
  valid_574592 = validateParameter(valid_574592, JString, required = true,
                                 default = nil)
  if valid_574592 != nil:
    section.add "secret-name", valid_574592
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574593 = query.getOrDefault("api-version")
  valid_574593 = validateParameter(valid_574593, JString, required = true,
                                 default = nil)
  if valid_574593 != nil:
    section.add "api-version", valid_574593
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

proc call*(call_574595: Call_SetSecret_574589; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets a secret in the specified vault.
  ## 
  let valid = call_574595.validator(path, query, header, formData, body)
  let scheme = call_574595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574595.url(scheme.get, call_574595.host, call_574595.base,
                         call_574595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574595, url, valid)

proc call*(call_574596: Call_SetSecret_574589; apiVersion: string;
          secretName: string; parameters: JsonNode): Recallable =
  ## setSecret
  ## Sets a secret in the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret in the given vault
  ##   parameters: JObject (required)
  ##             : The parameters for secret set
  var path_574597 = newJObject()
  var query_574598 = newJObject()
  var body_574599 = newJObject()
  add(query_574598, "api-version", newJString(apiVersion))
  add(path_574597, "secret-name", newJString(secretName))
  if parameters != nil:
    body_574599 = parameters
  result = call_574596.call(path_574597, query_574598, nil, nil, body_574599)

var setSecret* = Call_SetSecret_574589(name: "setSecret", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/secrets/{secret-name}",
                                    validator: validate_SetSecret_574590,
                                    base: "", url: url_SetSecret_574591,
                                    schemes: {Scheme.Https})
type
  Call_DeleteSecret_574600 = ref object of OpenApiRestCall_573666
proc url_DeleteSecret_574602(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteSecret_574601(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574603 = path.getOrDefault("secret-name")
  valid_574603 = validateParameter(valid_574603, JString, required = true,
                                 default = nil)
  if valid_574603 != nil:
    section.add "secret-name", valid_574603
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574604 = query.getOrDefault("api-version")
  valid_574604 = validateParameter(valid_574604, JString, required = true,
                                 default = nil)
  if valid_574604 != nil:
    section.add "api-version", valid_574604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574605: Call_DeleteSecret_574600; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a secret from the specified vault.
  ## 
  let valid = call_574605.validator(path, query, header, formData, body)
  let scheme = call_574605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574605.url(scheme.get, call_574605.host, call_574605.base,
                         call_574605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574605, url, valid)

proc call*(call_574606: Call_DeleteSecret_574600; apiVersion: string;
          secretName: string): Recallable =
  ## deleteSecret
  ## Deletes a secret from the specified vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretName: string (required)
  ##             : The name of the secret in the given vault
  var path_574607 = newJObject()
  var query_574608 = newJObject()
  add(query_574608, "api-version", newJString(apiVersion))
  add(path_574607, "secret-name", newJString(secretName))
  result = call_574606.call(path_574607, query_574608, nil, nil, nil)

var deleteSecret* = Call_DeleteSecret_574600(name: "deleteSecret",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/secrets/{secret-name}", validator: validate_DeleteSecret_574601,
    base: "", url: url_DeleteSecret_574602, schemes: {Scheme.Https})
type
  Call_GetSecretVersions_574609 = ref object of OpenApiRestCall_573666
proc url_GetSecretVersions_574611(protocol: Scheme; host: string; base: string;
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

proc validate_GetSecretVersions_574610(path: JsonNode; query: JsonNode;
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
  var valid_574612 = path.getOrDefault("secret-name")
  valid_574612 = validateParameter(valid_574612, JString, required = true,
                                 default = nil)
  if valid_574612 != nil:
    section.add "secret-name", valid_574612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574613 = query.getOrDefault("api-version")
  valid_574613 = validateParameter(valid_574613, JString, required = true,
                                 default = nil)
  if valid_574613 != nil:
    section.add "api-version", valid_574613
  var valid_574614 = query.getOrDefault("maxresults")
  valid_574614 = validateParameter(valid_574614, JInt, required = false, default = nil)
  if valid_574614 != nil:
    section.add "maxresults", valid_574614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574615: Call_GetSecretVersions_574609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the versions of the specified secret
  ## 
  let valid = call_574615.validator(path, query, header, formData, body)
  let scheme = call_574615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574615.url(scheme.get, call_574615.host, call_574615.base,
                         call_574615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574615, url, valid)

proc call*(call_574616: Call_GetSecretVersions_574609; apiVersion: string;
          secretName: string; maxresults: int = 0): Recallable =
  ## getSecretVersions
  ## List the versions of the specified secret
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   secretName: string (required)
  ##             : The name of the secret in the given vault
  var path_574617 = newJObject()
  var query_574618 = newJObject()
  add(query_574618, "api-version", newJString(apiVersion))
  add(query_574618, "maxresults", newJInt(maxresults))
  add(path_574617, "secret-name", newJString(secretName))
  result = call_574616.call(path_574617, query_574618, nil, nil, nil)

var getSecretVersions* = Call_GetSecretVersions_574609(name: "getSecretVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/secrets/{secret-name}/versions",
    validator: validate_GetSecretVersions_574610, base: "",
    url: url_GetSecretVersions_574611, schemes: {Scheme.Https})
type
  Call_GetSecret_574619 = ref object of OpenApiRestCall_573666
proc url_GetSecret_574621(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetSecret_574620(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574622 = path.getOrDefault("secret-version")
  valid_574622 = validateParameter(valid_574622, JString, required = true,
                                 default = nil)
  if valid_574622 != nil:
    section.add "secret-version", valid_574622
  var valid_574623 = path.getOrDefault("secret-name")
  valid_574623 = validateParameter(valid_574623, JString, required = true,
                                 default = nil)
  if valid_574623 != nil:
    section.add "secret-name", valid_574623
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574624 = query.getOrDefault("api-version")
  valid_574624 = validateParameter(valid_574624, JString, required = true,
                                 default = nil)
  if valid_574624 != nil:
    section.add "api-version", valid_574624
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574625: Call_GetSecret_574619; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a secret.
  ## 
  let valid = call_574625.validator(path, query, header, formData, body)
  let scheme = call_574625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574625.url(scheme.get, call_574625.host, call_574625.base,
                         call_574625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574625, url, valid)

proc call*(call_574626: Call_GetSecret_574619; apiVersion: string;
          secretVersion: string; secretName: string): Recallable =
  ## getSecret
  ## Gets a secret.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   secretVersion: string (required)
  ##                : The version of the secret
  ##   secretName: string (required)
  ##             : The name of the secret in the given vault
  var path_574627 = newJObject()
  var query_574628 = newJObject()
  add(query_574628, "api-version", newJString(apiVersion))
  add(path_574627, "secret-version", newJString(secretVersion))
  add(path_574627, "secret-name", newJString(secretName))
  result = call_574626.call(path_574627, query_574628, nil, nil, nil)

var getSecret* = Call_GetSecret_574619(name: "getSecret", meth: HttpMethod.HttpGet,
                                    host: "azure.local", route: "/secrets/{secret-name}/{secret-version}",
                                    validator: validate_GetSecret_574620,
                                    base: "", url: url_GetSecret_574621,
                                    schemes: {Scheme.Https})
type
  Call_UpdateSecret_574629 = ref object of OpenApiRestCall_573666
proc url_UpdateSecret_574631(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateSecret_574630(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574632 = path.getOrDefault("secret-version")
  valid_574632 = validateParameter(valid_574632, JString, required = true,
                                 default = nil)
  if valid_574632 != nil:
    section.add "secret-version", valid_574632
  var valid_574633 = path.getOrDefault("secret-name")
  valid_574633 = validateParameter(valid_574633, JString, required = true,
                                 default = nil)
  if valid_574633 != nil:
    section.add "secret-name", valid_574633
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574634 = query.getOrDefault("api-version")
  valid_574634 = validateParameter(valid_574634, JString, required = true,
                                 default = nil)
  if valid_574634 != nil:
    section.add "api-version", valid_574634
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

proc call*(call_574636: Call_UpdateSecret_574629; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the attributes associated with the specified secret
  ## 
  let valid = call_574636.validator(path, query, header, formData, body)
  let scheme = call_574636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574636.url(scheme.get, call_574636.host, call_574636.base,
                         call_574636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574636, url, valid)

proc call*(call_574637: Call_UpdateSecret_574629; apiVersion: string;
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
  var path_574638 = newJObject()
  var query_574639 = newJObject()
  var body_574640 = newJObject()
  add(query_574639, "api-version", newJString(apiVersion))
  add(path_574638, "secret-version", newJString(secretVersion))
  add(path_574638, "secret-name", newJString(secretName))
  if parameters != nil:
    body_574640 = parameters
  result = call_574637.call(path_574638, query_574639, nil, nil, body_574640)

var updateSecret* = Call_UpdateSecret_574629(name: "updateSecret",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/secrets/{secret-name}/{secret-version}",
    validator: validate_UpdateSecret_574630, base: "", url: url_UpdateSecret_574631,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
