
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: KeyVaultClient
## version: 2016-10-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The key vault client performs cryptographic key operations and vault operations against the Key Vault service.
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
  ## The GetCertificates operation returns the set of certificates resources in the specified key vault. This operation requires the certificates/list permission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## The GetCertificates operation returns the set of certificates resources in the specified key vault. This operation requires the certificates/list permission.
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
  ## The GetCertificates operation returns the set of certificates resources in the specified key vault. This operation requires the certificates/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  ## Sets the certificate contacts for the specified key vault. This operation requires the certificates/managecontacts permission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ##           : The contacts for the key vault certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574214: Call_SetCertificateContacts_574192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the certificate contacts for the specified key vault. This operation requires the certificates/managecontacts permission.
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
  ## Sets the certificate contacts for the specified key vault. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   contacts: JObject (required)
  ##           : The contacts for the key vault certificate.
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
  ## The GetCertificateContacts operation returns the set of certificate contact resources in the specified key vault. This operation requires the certificates/managecontacts permission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## The GetCertificateContacts operation returns the set of certificate contact resources in the specified key vault. This operation requires the certificates/managecontacts permission.
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
  ## The GetCertificateContacts operation returns the set of certificate contact resources in the specified key vault. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  ## Deletes the certificate contacts for a specified key vault certificate. This operation requires the certificates/managecontacts permission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## Deletes the certificate contacts for a specified key vault certificate. This operation requires the certificates/managecontacts permission.
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
  ## Deletes the certificate contacts for a specified key vault certificate. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  ## The GetCertificateIssuers operation returns the set of certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## The GetCertificateIssuers operation returns the set of certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
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
  ## The GetCertificateIssuers operation returns the set of certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  ## The SetCertificateIssuer operation adds or updates the specified certificate issuer. This operation requires the certificates/setissuers permission.
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
  ##              : Client API version.
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
  ## The SetCertificateIssuer operation adds or updates the specified certificate issuer. This operation requires the certificates/setissuers permission.
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
  ## The SetCertificateIssuer operation adds or updates the specified certificate issuer. This operation requires the certificates/setissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  ## The GetCertificateIssuer operation returns the specified certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
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
  ##              : Client API version.
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
  ## The GetCertificateIssuer operation returns the specified certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
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
  ## The GetCertificateIssuer operation returns the specified certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  ## The UpdateCertificateIssuer operation performs an update on the specified certificate issuer entity. This operation requires the certificates/setissuers permission.
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
  ##              : Client API version.
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
  ## The UpdateCertificateIssuer operation performs an update on the specified certificate issuer entity. This operation requires the certificates/setissuers permission.
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
  ## The UpdateCertificateIssuer operation performs an update on the specified certificate issuer entity. This operation requires the certificates/setissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  ## The DeleteCertificateIssuer operation permanently removes the specified certificate issuer from the vault. This operation requires the certificates/manageissuers/deleteissuers permission.
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
  ##              : Client API version.
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
  ## The DeleteCertificateIssuer operation permanently removes the specified certificate issuer from the vault. This operation requires the certificates/manageissuers/deleteissuers permission.
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
  ## The DeleteCertificateIssuer operation permanently removes the specified certificate issuer from the vault. This operation requires the certificates/manageissuers/deleteissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  ## Deletes all versions of a certificate object along with its associated policy. Delete certificate cannot be used to remove individual versions of a certificate object. This operation requires the certificates/delete permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate.
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
  ##              : Client API version.
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
  ## Deletes all versions of a certificate object along with its associated policy. Delete certificate cannot be used to remove individual versions of a certificate object. This operation requires the certificates/delete permission.
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
  ## Deletes all versions of a certificate object along with its associated policy. Delete certificate cannot be used to remove individual versions of a certificate object. This operation requires the certificates/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
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
  ## If this is the first version, the certificate resource is created. This operation requires the certificates/create permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate.
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
  ##              : Client API version.
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
  ##             : The parameters to create a certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574302: Call_CreateCertificate_574296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If this is the first version, the certificate resource is created. This operation requires the certificates/create permission.
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
  ## If this is the first version, the certificate resource is created. This operation requires the certificates/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to create a certificate.
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
  ## Imports an existing valid certificate, containing a private key, into Azure Key Vault. The certificate to be imported can be in either PFX or PEM format. If the certificate is in PEM format the PEM file must contain the key as well as x509 certificates. This operation requires the certificates/import permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate.
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
  ##              : Client API version.
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
  ##             : The parameters to import the certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574313: Call_ImportCertificate_574307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an existing valid certificate, containing a private key, into Azure Key Vault. The certificate to be imported can be in either PFX or PEM format. If the certificate is in PEM format the PEM file must contain the key as well as x509 certificates. This operation requires the certificates/import permission.
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
  ## Imports an existing valid certificate, containing a private key, into Azure Key Vault. The certificate to be imported can be in either PFX or PEM format. If the certificate is in PEM format the PEM file must contain the key as well as x509 certificates. This operation requires the certificates/import permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to import the certificate.
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
  ## Gets the creation operation associated with a specified certificate. This operation requires the certificates/get permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate.
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
  ##              : Client API version.
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
  ## Gets the creation operation associated with a specified certificate. This operation requires the certificates/get permission.
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
  ## Gets the creation operation associated with a specified certificate. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
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
  ## Updates a certificate creation operation that is already in progress. This operation requires the certificates/update permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate.
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
  ##              : Client API version.
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
  ## Updates a certificate creation operation that is already in progress. This operation requires the certificates/update permission.
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
  ## Updates a certificate creation operation that is already in progress. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
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
  ## Deletes the creation operation for a specified certificate that is in the process of being created. The certificate is no longer created. This operation requires the certificates/update permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate.
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
  ##              : Client API version.
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
  ## Deletes the creation operation for a specified certificate that is in the process of being created. The certificate is no longer created. This operation requires the certificates/update permission.
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
  ## Deletes the creation operation for a specified certificate that is in the process of being created. The certificate is no longer created. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
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
  ## The MergeCertificate operation performs the merging of a certificate or certificate chain with a key pair currently available in the service. This operation requires the certificates/create permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate.
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
  ##              : Client API version.
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
  ## The MergeCertificate operation performs the merging of a certificate or certificate chain with a key pair currently available in the service. This operation requires the certificates/create permission.
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
  ## The MergeCertificate operation performs the merging of a certificate or certificate chain with a key pair currently available in the service. This operation requires the certificates/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
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
  ## The GetCertificatePolicy operation returns the specified certificate policy resources in the specified key vault. This operation requires the certificates/get permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate in a given key vault.
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
  ##              : Client API version.
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
  ## The GetCertificatePolicy operation returns the specified certificate policy resources in the specified key vault. This operation requires the certificates/get permission.
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
  ## The GetCertificatePolicy operation returns the specified certificate policy resources in the specified key vault. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in a given key vault.
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
  ## Set specified members in the certificate policy. Leave others as null. This operation requires the certificates/update permission.
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
  ##              : Client API version.
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
  ## Set specified members in the certificate policy. Leave others as null. This operation requires the certificates/update permission.
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
  ## Set specified members in the certificate policy. Leave others as null. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  ## The GetCertificateVersions operation returns the versions of a certificate in the specified key vault. This operation requires the certificates/list permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate.
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
  ##              : Client API version.
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
  ## The GetCertificateVersions operation returns the versions of a certificate in the specified key vault. This operation requires the certificates/list permission.
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
  ## The GetCertificateVersions operation returns the versions of a certificate in the specified key vault. This operation requires the certificates/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
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
  ## Gets information about a specific certificate. This operation requires the certificates/get permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate in the given vault.
  ##   certificate-version: JString (required)
  ##                      : The version of the certificate.
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
  ##              : Client API version.
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
  ## Gets information about a specific certificate. This operation requires the certificates/get permission.
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
  ## Gets information about a specific certificate. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault.
  ##   certificateVersion: string (required)
  ##                     : The version of the certificate.
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
  ## The UpdateCertificate operation applies the specified update on the given certificate; the only elements updated are the certificate's attributes. This operation requires the certificates/update permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate in the given key vault.
  ##   certificate-version: JString (required)
  ##                      : The version of the certificate.
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
  ##              : Client API version.
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
  ##             : The parameters for certificate update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574405: Call_UpdateCertificate_574398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UpdateCertificate operation applies the specified update on the given certificate; the only elements updated are the certificate's attributes. This operation requires the certificates/update permission.
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
  ## The UpdateCertificate operation applies the specified update on the given certificate; the only elements updated are the certificate's attributes. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given key vault.
  ##   certificateVersion: string (required)
  ##                     : The version of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters for certificate update.
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
  Call_GetDeletedCertificates_574410 = ref object of OpenApiRestCall_573666
proc url_GetDeletedCertificates_574412(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedCertificates_574411(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The GetDeletedCertificates operation retrieves the certificates in the current vault which are in a deleted state and ready for recovery or purging. This operation includes deletion-specific information. This operation requires the certificates/get/list permission. This operation can only be enabled on soft-delete enabled vaults.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_574415: Call_GetDeletedCertificates_574410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetDeletedCertificates operation retrieves the certificates in the current vault which are in a deleted state and ready for recovery or purging. This operation includes deletion-specific information. This operation requires the certificates/get/list permission. This operation can only be enabled on soft-delete enabled vaults.
  ## 
  let valid = call_574415.validator(path, query, header, formData, body)
  let scheme = call_574415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574415.url(scheme.get, call_574415.host, call_574415.base,
                         call_574415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574415, url, valid)

proc call*(call_574416: Call_GetDeletedCertificates_574410; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedCertificates
  ## The GetDeletedCertificates operation retrieves the certificates in the current vault which are in a deleted state and ready for recovery or purging. This operation includes deletion-specific information. This operation requires the certificates/get/list permission. This operation can only be enabled on soft-delete enabled vaults.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_574417 = newJObject()
  add(query_574417, "api-version", newJString(apiVersion))
  add(query_574417, "maxresults", newJInt(maxresults))
  result = call_574416.call(nil, query_574417, nil, nil, nil)

var getDeletedCertificates* = Call_GetDeletedCertificates_574410(
    name: "getDeletedCertificates", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedcertificates", validator: validate_GetDeletedCertificates_574411,
    base: "", url: url_GetDeletedCertificates_574412, schemes: {Scheme.Https})
type
  Call_GetDeletedCertificate_574418 = ref object of OpenApiRestCall_573666
proc url_GetDeletedCertificate_574420(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedcertificates/"),
               (kind: VariableSegment, value: "certificate-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeletedCertificate_574419(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The GetDeletedCertificate operation retrieves the deleted certificate information plus its attributes, such as retention interval, scheduled permanent deletion and the current deletion recovery level. This operation requires the certificates/get permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_574421 = path.getOrDefault("certificate-name")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "certificate-name", valid_574421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574422 = query.getOrDefault("api-version")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "api-version", valid_574422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574423: Call_GetDeletedCertificate_574418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetDeletedCertificate operation retrieves the deleted certificate information plus its attributes, such as retention interval, scheduled permanent deletion and the current deletion recovery level. This operation requires the certificates/get permission.
  ## 
  let valid = call_574423.validator(path, query, header, formData, body)
  let scheme = call_574423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574423.url(scheme.get, call_574423.host, call_574423.base,
                         call_574423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574423, url, valid)

proc call*(call_574424: Call_GetDeletedCertificate_574418; apiVersion: string;
          certificateName: string): Recallable =
  ## getDeletedCertificate
  ## The GetDeletedCertificate operation retrieves the deleted certificate information plus its attributes, such as retention interval, scheduled permanent deletion and the current deletion recovery level. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_574425 = newJObject()
  var query_574426 = newJObject()
  add(query_574426, "api-version", newJString(apiVersion))
  add(path_574425, "certificate-name", newJString(certificateName))
  result = call_574424.call(path_574425, query_574426, nil, nil, nil)

var getDeletedCertificate* = Call_GetDeletedCertificate_574418(
    name: "getDeletedCertificate", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedcertificates/{certificate-name}",
    validator: validate_GetDeletedCertificate_574419, base: "",
    url: url_GetDeletedCertificate_574420, schemes: {Scheme.Https})
type
  Call_PurgeDeletedCertificate_574427 = ref object of OpenApiRestCall_573666
proc url_PurgeDeletedCertificate_574429(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedcertificates/"),
               (kind: VariableSegment, value: "certificate-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PurgeDeletedCertificate_574428(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The PurgeDeletedCertificate operation performs an irreversible deletion of the specified certificate, without possibility for recovery. The operation is not available if the recovery level does not specify 'Purgeable'. This operation requires the certificate/purge permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_574430 = path.getOrDefault("certificate-name")
  valid_574430 = validateParameter(valid_574430, JString, required = true,
                                 default = nil)
  if valid_574430 != nil:
    section.add "certificate-name", valid_574430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_574432: Call_PurgeDeletedCertificate_574427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The PurgeDeletedCertificate operation performs an irreversible deletion of the specified certificate, without possibility for recovery. The operation is not available if the recovery level does not specify 'Purgeable'. This operation requires the certificate/purge permission.
  ## 
  let valid = call_574432.validator(path, query, header, formData, body)
  let scheme = call_574432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574432.url(scheme.get, call_574432.host, call_574432.base,
                         call_574432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574432, url, valid)

proc call*(call_574433: Call_PurgeDeletedCertificate_574427; apiVersion: string;
          certificateName: string): Recallable =
  ## purgeDeletedCertificate
  ## The PurgeDeletedCertificate operation performs an irreversible deletion of the specified certificate, without possibility for recovery. The operation is not available if the recovery level does not specify 'Purgeable'. This operation requires the certificate/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_574434 = newJObject()
  var query_574435 = newJObject()
  add(query_574435, "api-version", newJString(apiVersion))
  add(path_574434, "certificate-name", newJString(certificateName))
  result = call_574433.call(path_574434, query_574435, nil, nil, nil)

var purgeDeletedCertificate* = Call_PurgeDeletedCertificate_574427(
    name: "purgeDeletedCertificate", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/deletedcertificates/{certificate-name}",
    validator: validate_PurgeDeletedCertificate_574428, base: "",
    url: url_PurgeDeletedCertificate_574429, schemes: {Scheme.Https})
type
  Call_RecoverDeletedCertificate_574436 = ref object of OpenApiRestCall_573666
proc url_RecoverDeletedCertificate_574438(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificate-name" in path,
        "`certificate-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedcertificates/"),
               (kind: VariableSegment, value: "certificate-name"),
               (kind: ConstantSegment, value: "/recover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoverDeletedCertificate_574437(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The RecoverDeletedCertificate operation performs the reversal of the Delete operation. The operation is applicable in vaults enabled for soft-delete, and must be issued during the retention interval (available in the deleted certificate's attributes). This operation requires the certificates/recover permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the deleted certificate
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_574439 = path.getOrDefault("certificate-name")
  valid_574439 = validateParameter(valid_574439, JString, required = true,
                                 default = nil)
  if valid_574439 != nil:
    section.add "certificate-name", valid_574439
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574440 = query.getOrDefault("api-version")
  valid_574440 = validateParameter(valid_574440, JString, required = true,
                                 default = nil)
  if valid_574440 != nil:
    section.add "api-version", valid_574440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574441: Call_RecoverDeletedCertificate_574436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RecoverDeletedCertificate operation performs the reversal of the Delete operation. The operation is applicable in vaults enabled for soft-delete, and must be issued during the retention interval (available in the deleted certificate's attributes). This operation requires the certificates/recover permission.
  ## 
  let valid = call_574441.validator(path, query, header, formData, body)
  let scheme = call_574441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574441.url(scheme.get, call_574441.host, call_574441.base,
                         call_574441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574441, url, valid)

proc call*(call_574442: Call_RecoverDeletedCertificate_574436; apiVersion: string;
          certificateName: string): Recallable =
  ## recoverDeletedCertificate
  ## The RecoverDeletedCertificate operation performs the reversal of the Delete operation. The operation is applicable in vaults enabled for soft-delete, and must be issued during the retention interval (available in the deleted certificate's attributes). This operation requires the certificates/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the deleted certificate
  var path_574443 = newJObject()
  var query_574444 = newJObject()
  add(query_574444, "api-version", newJString(apiVersion))
  add(path_574443, "certificate-name", newJString(certificateName))
  result = call_574442.call(path_574443, query_574444, nil, nil, nil)

var recoverDeletedCertificate* = Call_RecoverDeletedCertificate_574436(
    name: "recoverDeletedCertificate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/deletedcertificates/{certificate-name}/recover",
    validator: validate_RecoverDeletedCertificate_574437, base: "",
    url: url_RecoverDeletedCertificate_574438, schemes: {Scheme.Https})
type
  Call_GetDeletedKeys_574445 = ref object of OpenApiRestCall_573666
proc url_GetDeletedKeys_574447(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedKeys_574446(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a deleted key. This operation includes deletion-specific information. The Get Deleted Keys operation is applicable for vaults enabled for soft-delete. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/list permission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574448 = query.getOrDefault("api-version")
  valid_574448 = validateParameter(valid_574448, JString, required = true,
                                 default = nil)
  if valid_574448 != nil:
    section.add "api-version", valid_574448
  var valid_574449 = query.getOrDefault("maxresults")
  valid_574449 = validateParameter(valid_574449, JInt, required = false, default = nil)
  if valid_574449 != nil:
    section.add "maxresults", valid_574449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574450: Call_GetDeletedKeys_574445; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a deleted key. This operation includes deletion-specific information. The Get Deleted Keys operation is applicable for vaults enabled for soft-delete. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/list permission.
  ## 
  let valid = call_574450.validator(path, query, header, formData, body)
  let scheme = call_574450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574450.url(scheme.get, call_574450.host, call_574450.base,
                         call_574450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574450, url, valid)

proc call*(call_574451: Call_GetDeletedKeys_574445; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedKeys
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a deleted key. This operation includes deletion-specific information. The Get Deleted Keys operation is applicable for vaults enabled for soft-delete. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_574452 = newJObject()
  add(query_574452, "api-version", newJString(apiVersion))
  add(query_574452, "maxresults", newJInt(maxresults))
  result = call_574451.call(nil, query_574452, nil, nil, nil)

var getDeletedKeys* = Call_GetDeletedKeys_574445(name: "getDeletedKeys",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedkeys",
    validator: validate_GetDeletedKeys_574446, base: "", url: url_GetDeletedKeys_574447,
    schemes: {Scheme.Https})
type
  Call_GetDeletedKey_574453 = ref object of OpenApiRestCall_573666
proc url_GetDeletedKey_574455(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedkeys/"),
               (kind: VariableSegment, value: "key-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeletedKey_574454(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/get permission. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : The name of the key.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_574456 = path.getOrDefault("key-name")
  valid_574456 = validateParameter(valid_574456, JString, required = true,
                                 default = nil)
  if valid_574456 != nil:
    section.add "key-name", valid_574456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574457 = query.getOrDefault("api-version")
  valid_574457 = validateParameter(valid_574457, JString, required = true,
                                 default = nil)
  if valid_574457 != nil:
    section.add "api-version", valid_574457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574458: Call_GetDeletedKey_574453; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/get permission. 
  ## 
  let valid = call_574458.validator(path, query, header, formData, body)
  let scheme = call_574458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574458.url(scheme.get, call_574458.host, call_574458.base,
                         call_574458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574458, url, valid)

proc call*(call_574459: Call_GetDeletedKey_574453; apiVersion: string;
          keyName: string): Recallable =
  ## getDeletedKey
  ## The Get Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/get permission. 
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_574460 = newJObject()
  var query_574461 = newJObject()
  add(query_574461, "api-version", newJString(apiVersion))
  add(path_574460, "key-name", newJString(keyName))
  result = call_574459.call(path_574460, query_574461, nil, nil, nil)

var getDeletedKey* = Call_GetDeletedKey_574453(name: "getDeletedKey",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedkeys/{key-name}",
    validator: validate_GetDeletedKey_574454, base: "", url: url_GetDeletedKey_574455,
    schemes: {Scheme.Https})
type
  Call_PurgeDeletedKey_574462 = ref object of OpenApiRestCall_573666
proc url_PurgeDeletedKey_574464(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedkeys/"),
               (kind: VariableSegment, value: "key-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PurgeDeletedKey_574463(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## The Purge Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/purge permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : The name of the key
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_574465 = path.getOrDefault("key-name")
  valid_574465 = validateParameter(valid_574465, JString, required = true,
                                 default = nil)
  if valid_574465 != nil:
    section.add "key-name", valid_574465
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574466 = query.getOrDefault("api-version")
  valid_574466 = validateParameter(valid_574466, JString, required = true,
                                 default = nil)
  if valid_574466 != nil:
    section.add "api-version", valid_574466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574467: Call_PurgeDeletedKey_574462; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Purge Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/purge permission.
  ## 
  let valid = call_574467.validator(path, query, header, formData, body)
  let scheme = call_574467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574467.url(scheme.get, call_574467.host, call_574467.base,
                         call_574467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574467, url, valid)

proc call*(call_574468: Call_PurgeDeletedKey_574462; apiVersion: string;
          keyName: string): Recallable =
  ## purgeDeletedKey
  ## The Purge Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_574469 = newJObject()
  var query_574470 = newJObject()
  add(query_574470, "api-version", newJString(apiVersion))
  add(path_574469, "key-name", newJString(keyName))
  result = call_574468.call(path_574469, query_574470, nil, nil, nil)

var purgeDeletedKey* = Call_PurgeDeletedKey_574462(name: "purgeDeletedKey",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/deletedkeys/{key-name}", validator: validate_PurgeDeletedKey_574463,
    base: "", url: url_PurgeDeletedKey_574464, schemes: {Scheme.Https})
type
  Call_RecoverDeletedKey_574471 = ref object of OpenApiRestCall_573666
proc url_RecoverDeletedKey_574473(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "key-name" in path, "`key-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedkeys/"),
               (kind: VariableSegment, value: "key-name"),
               (kind: ConstantSegment, value: "/recover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoverDeletedKey_574472(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The Recover Deleted Key operation is applicable for deleted keys in soft-delete enabled vaults. It recovers the deleted key back to its latest version under /keys. An attempt to recover an non-deleted key will return an error. Consider this the inverse of the delete operation on soft-delete enabled vaults. This operation requires the keys/recover permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : The name of the deleted key.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_574474 = path.getOrDefault("key-name")
  valid_574474 = validateParameter(valid_574474, JString, required = true,
                                 default = nil)
  if valid_574474 != nil:
    section.add "key-name", valid_574474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574475 = query.getOrDefault("api-version")
  valid_574475 = validateParameter(valid_574475, JString, required = true,
                                 default = nil)
  if valid_574475 != nil:
    section.add "api-version", valid_574475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574476: Call_RecoverDeletedKey_574471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Recover Deleted Key operation is applicable for deleted keys in soft-delete enabled vaults. It recovers the deleted key back to its latest version under /keys. An attempt to recover an non-deleted key will return an error. Consider this the inverse of the delete operation on soft-delete enabled vaults. This operation requires the keys/recover permission.
  ## 
  let valid = call_574476.validator(path, query, header, formData, body)
  let scheme = call_574476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574476.url(scheme.get, call_574476.host, call_574476.base,
                         call_574476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574476, url, valid)

proc call*(call_574477: Call_RecoverDeletedKey_574471; apiVersion: string;
          keyName: string): Recallable =
  ## recoverDeletedKey
  ## The Recover Deleted Key operation is applicable for deleted keys in soft-delete enabled vaults. It recovers the deleted key back to its latest version under /keys. An attempt to recover an non-deleted key will return an error. Consider this the inverse of the delete operation on soft-delete enabled vaults. This operation requires the keys/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the deleted key.
  var path_574478 = newJObject()
  var query_574479 = newJObject()
  add(query_574479, "api-version", newJString(apiVersion))
  add(path_574478, "key-name", newJString(keyName))
  result = call_574477.call(path_574478, query_574479, nil, nil, nil)

var recoverDeletedKey* = Call_RecoverDeletedKey_574471(name: "recoverDeletedKey",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/deletedkeys/{key-name}/recover",
    validator: validate_RecoverDeletedKey_574472, base: "",
    url: url_RecoverDeletedKey_574473, schemes: {Scheme.Https})
type
  Call_GetDeletedSecrets_574480 = ref object of OpenApiRestCall_573666
proc url_GetDeletedSecrets_574482(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedSecrets_574481(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The Get Deleted Secrets operation returns the secrets that have been deleted for a vault enabled for soft-delete. This operation requires the secrets/list permission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574483 = query.getOrDefault("api-version")
  valid_574483 = validateParameter(valid_574483, JString, required = true,
                                 default = nil)
  if valid_574483 != nil:
    section.add "api-version", valid_574483
  var valid_574484 = query.getOrDefault("maxresults")
  valid_574484 = validateParameter(valid_574484, JInt, required = false, default = nil)
  if valid_574484 != nil:
    section.add "maxresults", valid_574484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574485: Call_GetDeletedSecrets_574480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Secrets operation returns the secrets that have been deleted for a vault enabled for soft-delete. This operation requires the secrets/list permission.
  ## 
  let valid = call_574485.validator(path, query, header, formData, body)
  let scheme = call_574485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574485.url(scheme.get, call_574485.host, call_574485.base,
                         call_574485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574485, url, valid)

proc call*(call_574486: Call_GetDeletedSecrets_574480; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedSecrets
  ## The Get Deleted Secrets operation returns the secrets that have been deleted for a vault enabled for soft-delete. This operation requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_574487 = newJObject()
  add(query_574487, "api-version", newJString(apiVersion))
  add(query_574487, "maxresults", newJInt(maxresults))
  result = call_574486.call(nil, query_574487, nil, nil, nil)

var getDeletedSecrets* = Call_GetDeletedSecrets_574480(name: "getDeletedSecrets",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedsecrets",
    validator: validate_GetDeletedSecrets_574481, base: "",
    url: url_GetDeletedSecrets_574482, schemes: {Scheme.Https})
type
  Call_GetDeletedSecret_574488 = ref object of OpenApiRestCall_573666
proc url_GetDeletedSecret_574490(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "secret-name" in path, "`secret-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedsecrets/"),
               (kind: VariableSegment, value: "secret-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeletedSecret_574489(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The Get Deleted Secret operation returns the specified deleted secret along with its attributes. This operation requires the secrets/get permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-name: JString (required)
  ##              : The name of the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-name` field"
  var valid_574491 = path.getOrDefault("secret-name")
  valid_574491 = validateParameter(valid_574491, JString, required = true,
                                 default = nil)
  if valid_574491 != nil:
    section.add "secret-name", valid_574491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_574493: Call_GetDeletedSecret_574488; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Secret operation returns the specified deleted secret along with its attributes. This operation requires the secrets/get permission.
  ## 
  let valid = call_574493.validator(path, query, header, formData, body)
  let scheme = call_574493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574493.url(scheme.get, call_574493.host, call_574493.base,
                         call_574493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574493, url, valid)

proc call*(call_574494: Call_GetDeletedSecret_574488; apiVersion: string;
          secretName: string): Recallable =
  ## getDeletedSecret
  ## The Get Deleted Secret operation returns the specified deleted secret along with its attributes. This operation requires the secrets/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_574495 = newJObject()
  var query_574496 = newJObject()
  add(query_574496, "api-version", newJString(apiVersion))
  add(path_574495, "secret-name", newJString(secretName))
  result = call_574494.call(path_574495, query_574496, nil, nil, nil)

var getDeletedSecret* = Call_GetDeletedSecret_574488(name: "getDeletedSecret",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedsecrets/{secret-name}", validator: validate_GetDeletedSecret_574489,
    base: "", url: url_GetDeletedSecret_574490, schemes: {Scheme.Https})
type
  Call_PurgeDeletedSecret_574497 = ref object of OpenApiRestCall_573666
proc url_PurgeDeletedSecret_574499(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "secret-name" in path, "`secret-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedsecrets/"),
               (kind: VariableSegment, value: "secret-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PurgeDeletedSecret_574498(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The purge deleted secret operation removes the secret permanently, without the possibility of recovery. This operation can only be enabled on a soft-delete enabled vault. This operation requires the secrets/purge permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-name: JString (required)
  ##              : The name of the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-name` field"
  var valid_574500 = path.getOrDefault("secret-name")
  valid_574500 = validateParameter(valid_574500, JString, required = true,
                                 default = nil)
  if valid_574500 != nil:
    section.add "secret-name", valid_574500
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574501 = query.getOrDefault("api-version")
  valid_574501 = validateParameter(valid_574501, JString, required = true,
                                 default = nil)
  if valid_574501 != nil:
    section.add "api-version", valid_574501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574502: Call_PurgeDeletedSecret_574497; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The purge deleted secret operation removes the secret permanently, without the possibility of recovery. This operation can only be enabled on a soft-delete enabled vault. This operation requires the secrets/purge permission.
  ## 
  let valid = call_574502.validator(path, query, header, formData, body)
  let scheme = call_574502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574502.url(scheme.get, call_574502.host, call_574502.base,
                         call_574502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574502, url, valid)

proc call*(call_574503: Call_PurgeDeletedSecret_574497; apiVersion: string;
          secretName: string): Recallable =
  ## purgeDeletedSecret
  ## The purge deleted secret operation removes the secret permanently, without the possibility of recovery. This operation can only be enabled on a soft-delete enabled vault. This operation requires the secrets/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_574504 = newJObject()
  var query_574505 = newJObject()
  add(query_574505, "api-version", newJString(apiVersion))
  add(path_574504, "secret-name", newJString(secretName))
  result = call_574503.call(path_574504, query_574505, nil, nil, nil)

var purgeDeletedSecret* = Call_PurgeDeletedSecret_574497(
    name: "purgeDeletedSecret", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/deletedsecrets/{secret-name}",
    validator: validate_PurgeDeletedSecret_574498, base: "",
    url: url_PurgeDeletedSecret_574499, schemes: {Scheme.Https})
type
  Call_RecoverDeletedSecret_574506 = ref object of OpenApiRestCall_573666
proc url_RecoverDeletedSecret_574508(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "secret-name" in path, "`secret-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedsecrets/"),
               (kind: VariableSegment, value: "secret-name"),
               (kind: ConstantSegment, value: "/recover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoverDeletedSecret_574507(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recovers the deleted secret in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the secrets/recover permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-name: JString (required)
  ##              : The name of the deleted secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-name` field"
  var valid_574509 = path.getOrDefault("secret-name")
  valid_574509 = validateParameter(valid_574509, JString, required = true,
                                 default = nil)
  if valid_574509 != nil:
    section.add "secret-name", valid_574509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574510 = query.getOrDefault("api-version")
  valid_574510 = validateParameter(valid_574510, JString, required = true,
                                 default = nil)
  if valid_574510 != nil:
    section.add "api-version", valid_574510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574511: Call_RecoverDeletedSecret_574506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recovers the deleted secret in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the secrets/recover permission.
  ## 
  let valid = call_574511.validator(path, query, header, formData, body)
  let scheme = call_574511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574511.url(scheme.get, call_574511.host, call_574511.base,
                         call_574511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574511, url, valid)

proc call*(call_574512: Call_RecoverDeletedSecret_574506; apiVersion: string;
          secretName: string): Recallable =
  ## recoverDeletedSecret
  ## Recovers the deleted secret in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the secrets/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the deleted secret.
  var path_574513 = newJObject()
  var query_574514 = newJObject()
  add(query_574514, "api-version", newJString(apiVersion))
  add(path_574513, "secret-name", newJString(secretName))
  result = call_574512.call(path_574513, query_574514, nil, nil, nil)

var recoverDeletedSecret* = Call_RecoverDeletedSecret_574506(
    name: "recoverDeletedSecret", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/deletedsecrets/{secret-name}/recover",
    validator: validate_RecoverDeletedSecret_574507, base: "",
    url: url_RecoverDeletedSecret_574508, schemes: {Scheme.Https})
type
  Call_GetKeys_574515 = ref object of OpenApiRestCall_573666
proc url_GetKeys_574517(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetKeys_574516(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a stored key. The LIST operation is applicable to all key types, however only the base key identifier, attributes, and tags are provided in the response. Individual versions of a key are not listed in the response. This operation requires the keys/list permission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574518 = query.getOrDefault("api-version")
  valid_574518 = validateParameter(valid_574518, JString, required = true,
                                 default = nil)
  if valid_574518 != nil:
    section.add "api-version", valid_574518
  var valid_574519 = query.getOrDefault("maxresults")
  valid_574519 = validateParameter(valid_574519, JInt, required = false, default = nil)
  if valid_574519 != nil:
    section.add "maxresults", valid_574519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574520: Call_GetKeys_574515; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a stored key. The LIST operation is applicable to all key types, however only the base key identifier, attributes, and tags are provided in the response. Individual versions of a key are not listed in the response. This operation requires the keys/list permission.
  ## 
  let valid = call_574520.validator(path, query, header, formData, body)
  let scheme = call_574520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574520.url(scheme.get, call_574520.host, call_574520.base,
                         call_574520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574520, url, valid)

proc call*(call_574521: Call_GetKeys_574515; apiVersion: string; maxresults: int = 0): Recallable =
  ## getKeys
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a stored key. The LIST operation is applicable to all key types, however only the base key identifier, attributes, and tags are provided in the response. Individual versions of a key are not listed in the response. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_574522 = newJObject()
  add(query_574522, "api-version", newJString(apiVersion))
  add(query_574522, "maxresults", newJInt(maxresults))
  result = call_574521.call(nil, query_574522, nil, nil, nil)

var getKeys* = Call_GetKeys_574515(name: "getKeys", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/keys",
                                validator: validate_GetKeys_574516, base: "",
                                url: url_GetKeys_574517, schemes: {Scheme.Https})
type
  Call_RestoreKey_574523 = ref object of OpenApiRestCall_573666
proc url_RestoreKey_574525(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreKey_574524(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports a previously backed up key into Azure Key Vault, restoring the key, its key identifier, attributes and access control policies. The RESTORE operation may be used to import a previously backed up key. Individual versions of a key cannot be restored. The key is restored in its entirety with the same key name as it had when it was backed up. If the key name is not available in the target Key Vault, the RESTORE operation will be rejected. While the key name is retained during restore, the final key identifier will change if the key is restored to a different vault. Restore will restore all versions and preserve version identifiers. The RESTORE operation is subject to security constraints: The target Key Vault must be owned by the same Microsoft Azure Subscription as the source Key Vault The user must have RESTORE permission in the target Key Vault. This operation requires the keys/restore permission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ##             : The parameters to restore the key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574528: Call_RestoreKey_574523; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a previously backed up key into Azure Key Vault, restoring the key, its key identifier, attributes and access control policies. The RESTORE operation may be used to import a previously backed up key. Individual versions of a key cannot be restored. The key is restored in its entirety with the same key name as it had when it was backed up. If the key name is not available in the target Key Vault, the RESTORE operation will be rejected. While the key name is retained during restore, the final key identifier will change if the key is restored to a different vault. Restore will restore all versions and preserve version identifiers. The RESTORE operation is subject to security constraints: The target Key Vault must be owned by the same Microsoft Azure Subscription as the source Key Vault The user must have RESTORE permission in the target Key Vault. This operation requires the keys/restore permission.
  ## 
  let valid = call_574528.validator(path, query, header, formData, body)
  let scheme = call_574528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574528.url(scheme.get, call_574528.host, call_574528.base,
                         call_574528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574528, url, valid)

proc call*(call_574529: Call_RestoreKey_574523; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreKey
  ## Imports a previously backed up key into Azure Key Vault, restoring the key, its key identifier, attributes and access control policies. The RESTORE operation may be used to import a previously backed up key. Individual versions of a key cannot be restored. The key is restored in its entirety with the same key name as it had when it was backed up. If the key name is not available in the target Key Vault, the RESTORE operation will be rejected. While the key name is retained during restore, the final key identifier will change if the key is restored to a different vault. Restore will restore all versions and preserve version identifiers. The RESTORE operation is subject to security constraints: The target Key Vault must be owned by the same Microsoft Azure Subscription as the source Key Vault The user must have RESTORE permission in the target Key Vault. This operation requires the keys/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the key.
  var query_574530 = newJObject()
  var body_574531 = newJObject()
  add(query_574530, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574531 = parameters
  result = call_574529.call(nil, query_574530, nil, nil, body_574531)

var restoreKey* = Call_RestoreKey_574523(name: "restoreKey",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/keys/restore",
                                      validator: validate_RestoreKey_574524,
                                      base: "", url: url_RestoreKey_574525,
                                      schemes: {Scheme.Https})
type
  Call_ImportKey_574532 = ref object of OpenApiRestCall_573666
proc url_ImportKey_574534(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImportKey_574533(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## The import key operation may be used to import any key type into an Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. This operation requires the keys/import permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : Name for the imported key.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_574535 = path.getOrDefault("key-name")
  valid_574535 = validateParameter(valid_574535, JString, required = true,
                                 default = nil)
  if valid_574535 != nil:
    section.add "key-name", valid_574535
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574536 = query.getOrDefault("api-version")
  valid_574536 = validateParameter(valid_574536, JString, required = true,
                                 default = nil)
  if valid_574536 != nil:
    section.add "api-version", valid_574536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to import a key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574538: Call_ImportKey_574532; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The import key operation may be used to import any key type into an Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. This operation requires the keys/import permission.
  ## 
  let valid = call_574538.validator(path, query, header, formData, body)
  let scheme = call_574538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574538.url(scheme.get, call_574538.host, call_574538.base,
                         call_574538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574538, url, valid)

proc call*(call_574539: Call_ImportKey_574532; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## importKey
  ## The import key operation may be used to import any key type into an Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. This operation requires the keys/import permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to import a key.
  ##   keyName: string (required)
  ##          : Name for the imported key.
  var path_574540 = newJObject()
  var query_574541 = newJObject()
  var body_574542 = newJObject()
  add(query_574541, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574542 = parameters
  add(path_574540, "key-name", newJString(keyName))
  result = call_574539.call(path_574540, query_574541, nil, nil, body_574542)

var importKey* = Call_ImportKey_574532(name: "importKey", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_ImportKey_574533,
                                    base: "", url: url_ImportKey_574534,
                                    schemes: {Scheme.Https})
type
  Call_DeleteKey_574543 = ref object of OpenApiRestCall_573666
proc url_DeleteKey_574545(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DeleteKey_574544(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## The delete key operation cannot be used to remove individual versions of a key. This operation removes the cryptographic material associated with the key, which means the key is not usable for Sign/Verify, Wrap/Unwrap or Encrypt/Decrypt operations. This operation requires the keys/delete permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : The name of the key to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_574546 = path.getOrDefault("key-name")
  valid_574546 = validateParameter(valid_574546, JString, required = true,
                                 default = nil)
  if valid_574546 != nil:
    section.add "key-name", valid_574546
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574547 = query.getOrDefault("api-version")
  valid_574547 = validateParameter(valid_574547, JString, required = true,
                                 default = nil)
  if valid_574547 != nil:
    section.add "api-version", valid_574547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574548: Call_DeleteKey_574543; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete key operation cannot be used to remove individual versions of a key. This operation removes the cryptographic material associated with the key, which means the key is not usable for Sign/Verify, Wrap/Unwrap or Encrypt/Decrypt operations. This operation requires the keys/delete permission.
  ## 
  let valid = call_574548.validator(path, query, header, formData, body)
  let scheme = call_574548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574548.url(scheme.get, call_574548.host, call_574548.base,
                         call_574548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574548, url, valid)

proc call*(call_574549: Call_DeleteKey_574543; apiVersion: string; keyName: string): Recallable =
  ## deleteKey
  ## The delete key operation cannot be used to remove individual versions of a key. This operation removes the cryptographic material associated with the key, which means the key is not usable for Sign/Verify, Wrap/Unwrap or Encrypt/Decrypt operations. This operation requires the keys/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key to delete.
  var path_574550 = newJObject()
  var query_574551 = newJObject()
  add(query_574551, "api-version", newJString(apiVersion))
  add(path_574550, "key-name", newJString(keyName))
  result = call_574549.call(path_574550, query_574551, nil, nil, nil)

var deleteKey* = Call_DeleteKey_574543(name: "deleteKey",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_DeleteKey_574544,
                                    base: "", url: url_DeleteKey_574545,
                                    schemes: {Scheme.Https})
type
  Call_BackupKey_574552 = ref object of OpenApiRestCall_573666
proc url_BackupKey_574554(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BackupKey_574553(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## The Key Backup operation exports a key from Azure Key Vault in a protected form. Note that this operation does NOT return key material in a form that can be used outside the Azure Key Vault system, the returned key material is either protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of this operation is to allow a client to GENERATE a key in one Azure Key Vault instance, BACKUP the key, and then RESTORE it into another Azure Key Vault instance. The BACKUP operation may be used to export, in protected form, any key type from Azure Key Vault. Individual versions of a key cannot be backed up. BACKUP / RESTORE can be performed within geographical boundaries only; meaning that a BACKUP from one geographical area cannot be restored to another geographical area. For example, a backup from the US geographical area cannot be restored in an EU geographical area. This operation requires the key/backup permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : The name of the key.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_574555 = path.getOrDefault("key-name")
  valid_574555 = validateParameter(valid_574555, JString, required = true,
                                 default = nil)
  if valid_574555 != nil:
    section.add "key-name", valid_574555
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574556 = query.getOrDefault("api-version")
  valid_574556 = validateParameter(valid_574556, JString, required = true,
                                 default = nil)
  if valid_574556 != nil:
    section.add "api-version", valid_574556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574557: Call_BackupKey_574552; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Key Backup operation exports a key from Azure Key Vault in a protected form. Note that this operation does NOT return key material in a form that can be used outside the Azure Key Vault system, the returned key material is either protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of this operation is to allow a client to GENERATE a key in one Azure Key Vault instance, BACKUP the key, and then RESTORE it into another Azure Key Vault instance. The BACKUP operation may be used to export, in protected form, any key type from Azure Key Vault. Individual versions of a key cannot be backed up. BACKUP / RESTORE can be performed within geographical boundaries only; meaning that a BACKUP from one geographical area cannot be restored to another geographical area. For example, a backup from the US geographical area cannot be restored in an EU geographical area. This operation requires the key/backup permission.
  ## 
  let valid = call_574557.validator(path, query, header, formData, body)
  let scheme = call_574557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574557.url(scheme.get, call_574557.host, call_574557.base,
                         call_574557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574557, url, valid)

proc call*(call_574558: Call_BackupKey_574552; apiVersion: string; keyName: string): Recallable =
  ## backupKey
  ## The Key Backup operation exports a key from Azure Key Vault in a protected form. Note that this operation does NOT return key material in a form that can be used outside the Azure Key Vault system, the returned key material is either protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of this operation is to allow a client to GENERATE a key in one Azure Key Vault instance, BACKUP the key, and then RESTORE it into another Azure Key Vault instance. The BACKUP operation may be used to export, in protected form, any key type from Azure Key Vault. Individual versions of a key cannot be backed up. BACKUP / RESTORE can be performed within geographical boundaries only; meaning that a BACKUP from one geographical area cannot be restored to another geographical area. For example, a backup from the US geographical area cannot be restored in an EU geographical area. This operation requires the key/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_574559 = newJObject()
  var query_574560 = newJObject()
  add(query_574560, "api-version", newJString(apiVersion))
  add(path_574559, "key-name", newJString(keyName))
  result = call_574558.call(path_574559, query_574560, nil, nil, nil)

var backupKey* = Call_BackupKey_574552(name: "backupKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/backup",
                                    validator: validate_BackupKey_574553,
                                    base: "", url: url_BackupKey_574554,
                                    schemes: {Scheme.Https})
type
  Call_CreateKey_574561 = ref object of OpenApiRestCall_573666
proc url_CreateKey_574563(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CreateKey_574562(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## The create key operation can be used to create any key type in Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. It requires the keys/create permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : The name for the new key. The system will generate the version name for the new key.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_574574 = path.getOrDefault("key-name")
  valid_574574 = validateParameter(valid_574574, JString, required = true,
                                 default = nil)
  if valid_574574 != nil:
    section.add "key-name", valid_574574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574575 = query.getOrDefault("api-version")
  valid_574575 = validateParameter(valid_574575, JString, required = true,
                                 default = nil)
  if valid_574575 != nil:
    section.add "api-version", valid_574575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to create a key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574577: Call_CreateKey_574561; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The create key operation can be used to create any key type in Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. It requires the keys/create permission.
  ## 
  let valid = call_574577.validator(path, query, header, formData, body)
  let scheme = call_574577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574577.url(scheme.get, call_574577.host, call_574577.base,
                         call_574577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574577, url, valid)

proc call*(call_574578: Call_CreateKey_574561; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## createKey
  ## The create key operation can be used to create any key type in Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. It requires the keys/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to create a key.
  ##   keyName: string (required)
  ##          : The name for the new key. The system will generate the version name for the new key.
  var path_574579 = newJObject()
  var query_574580 = newJObject()
  var body_574581 = newJObject()
  add(query_574580, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574581 = parameters
  add(path_574579, "key-name", newJString(keyName))
  result = call_574578.call(path_574579, query_574580, nil, nil, body_574581)

var createKey* = Call_CreateKey_574561(name: "createKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/create",
                                    validator: validate_CreateKey_574562,
                                    base: "", url: url_CreateKey_574563,
                                    schemes: {Scheme.Https})
type
  Call_GetKeyVersions_574582 = ref object of OpenApiRestCall_573666
proc url_GetKeyVersions_574584(protocol: Scheme; host: string; base: string;
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

proc validate_GetKeyVersions_574583(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The full key identifier, attributes, and tags are provided in the response. This operation requires the keys/list permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-name: JString (required)
  ##           : The name of the key.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `key-name` field"
  var valid_574585 = path.getOrDefault("key-name")
  valid_574585 = validateParameter(valid_574585, JString, required = true,
                                 default = nil)
  if valid_574585 != nil:
    section.add "key-name", valid_574585
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574586 = query.getOrDefault("api-version")
  valid_574586 = validateParameter(valid_574586, JString, required = true,
                                 default = nil)
  if valid_574586 != nil:
    section.add "api-version", valid_574586
  var valid_574587 = query.getOrDefault("maxresults")
  valid_574587 = validateParameter(valid_574587, JInt, required = false, default = nil)
  if valid_574587 != nil:
    section.add "maxresults", valid_574587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574588: Call_GetKeyVersions_574582; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The full key identifier, attributes, and tags are provided in the response. This operation requires the keys/list permission.
  ## 
  let valid = call_574588.validator(path, query, header, formData, body)
  let scheme = call_574588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574588.url(scheme.get, call_574588.host, call_574588.base,
                         call_574588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574588, url, valid)

proc call*(call_574589: Call_GetKeyVersions_574582; apiVersion: string;
          keyName: string; maxresults: int = 0): Recallable =
  ## getKeyVersions
  ## The full key identifier, attributes, and tags are provided in the response. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_574590 = newJObject()
  var query_574591 = newJObject()
  add(query_574591, "api-version", newJString(apiVersion))
  add(query_574591, "maxresults", newJInt(maxresults))
  add(path_574590, "key-name", newJString(keyName))
  result = call_574589.call(path_574590, query_574591, nil, nil, nil)

var getKeyVersions* = Call_GetKeyVersions_574582(name: "getKeyVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/keys/{key-name}/versions", validator: validate_GetKeyVersions_574583,
    base: "", url: url_GetKeyVersions_574584, schemes: {Scheme.Https})
type
  Call_GetKey_574592 = ref object of OpenApiRestCall_573666
proc url_GetKey_574594(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetKey_574593(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## The get key operation is applicable to all key types. If the requested key is symmetric, then no key material is released in the response. This operation requires the keys/get permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : Adding the version parameter retrieves a specific version of a key.
  ##   key-name: JString (required)
  ##           : The name of the key to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_574595 = path.getOrDefault("key-version")
  valid_574595 = validateParameter(valid_574595, JString, required = true,
                                 default = nil)
  if valid_574595 != nil:
    section.add "key-version", valid_574595
  var valid_574596 = path.getOrDefault("key-name")
  valid_574596 = validateParameter(valid_574596, JString, required = true,
                                 default = nil)
  if valid_574596 != nil:
    section.add "key-name", valid_574596
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574597 = query.getOrDefault("api-version")
  valid_574597 = validateParameter(valid_574597, JString, required = true,
                                 default = nil)
  if valid_574597 != nil:
    section.add "api-version", valid_574597
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574598: Call_GetKey_574592; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The get key operation is applicable to all key types. If the requested key is symmetric, then no key material is released in the response. This operation requires the keys/get permission.
  ## 
  let valid = call_574598.validator(path, query, header, formData, body)
  let scheme = call_574598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574598.url(scheme.get, call_574598.host, call_574598.base,
                         call_574598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574598, url, valid)

proc call*(call_574599: Call_GetKey_574592; apiVersion: string; keyVersion: string;
          keyName: string): Recallable =
  ## getKey
  ## The get key operation is applicable to all key types. If the requested key is symmetric, then no key material is released in the response. This operation requires the keys/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyVersion: string (required)
  ##             : Adding the version parameter retrieves a specific version of a key.
  ##   keyName: string (required)
  ##          : The name of the key to get.
  var path_574600 = newJObject()
  var query_574601 = newJObject()
  add(query_574601, "api-version", newJString(apiVersion))
  add(path_574600, "key-version", newJString(keyVersion))
  add(path_574600, "key-name", newJString(keyName))
  result = call_574599.call(path_574600, query_574601, nil, nil, nil)

var getKey* = Call_GetKey_574592(name: "getKey", meth: HttpMethod.HttpGet,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}",
                              validator: validate_GetKey_574593, base: "",
                              url: url_GetKey_574594, schemes: {Scheme.Https})
type
  Call_UpdateKey_574602 = ref object of OpenApiRestCall_573666
proc url_UpdateKey_574604(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UpdateKey_574603(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## In order to perform this operation, the key must already exist in the Key Vault. Note: The cryptographic material of a key itself cannot be changed. This operation requires the keys/update permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key to update.
  ##   key-name: JString (required)
  ##           : The name of key to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_574605 = path.getOrDefault("key-version")
  valid_574605 = validateParameter(valid_574605, JString, required = true,
                                 default = nil)
  if valid_574605 != nil:
    section.add "key-version", valid_574605
  var valid_574606 = path.getOrDefault("key-name")
  valid_574606 = validateParameter(valid_574606, JString, required = true,
                                 default = nil)
  if valid_574606 != nil:
    section.add "key-name", valid_574606
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574607 = query.getOrDefault("api-version")
  valid_574607 = validateParameter(valid_574607, JString, required = true,
                                 default = nil)
  if valid_574607 != nil:
    section.add "api-version", valid_574607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters of the key to update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574609: Call_UpdateKey_574602; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## In order to perform this operation, the key must already exist in the Key Vault. Note: The cryptographic material of a key itself cannot be changed. This operation requires the keys/update permission.
  ## 
  let valid = call_574609.validator(path, query, header, formData, body)
  let scheme = call_574609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574609.url(scheme.get, call_574609.host, call_574609.base,
                         call_574609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574609, url, valid)

proc call*(call_574610: Call_UpdateKey_574602; apiVersion: string;
          keyVersion: string; parameters: JsonNode; keyName: string): Recallable =
  ## updateKey
  ## In order to perform this operation, the key must already exist in the Key Vault. Note: The cryptographic material of a key itself cannot be changed. This operation requires the keys/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyVersion: string (required)
  ##             : The version of the key to update.
  ##   parameters: JObject (required)
  ##             : The parameters of the key to update.
  ##   keyName: string (required)
  ##          : The name of key to update.
  var path_574611 = newJObject()
  var query_574612 = newJObject()
  var body_574613 = newJObject()
  add(query_574612, "api-version", newJString(apiVersion))
  add(path_574611, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574613 = parameters
  add(path_574611, "key-name", newJString(keyName))
  result = call_574610.call(path_574611, query_574612, nil, nil, body_574613)

var updateKey* = Call_UpdateKey_574602(name: "updateKey", meth: HttpMethod.HttpPatch,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/{key-version}",
                                    validator: validate_UpdateKey_574603,
                                    base: "", url: url_UpdateKey_574604,
                                    schemes: {Scheme.Https})
type
  Call_Decrypt_574614 = ref object of OpenApiRestCall_573666
proc url_Decrypt_574616(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Decrypt_574615(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## The DECRYPT operation decrypts a well-formed block of ciphertext using the target encryption key and specified algorithm. This operation is the reverse of the ENCRYPT operation; only a single block of data may be decrypted, the size of this block is dependent on the target key and the algorithm to be used. The DECRYPT operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/decrypt permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key.
  ##   key-name: JString (required)
  ##           : The name of the key.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_574617 = path.getOrDefault("key-version")
  valid_574617 = validateParameter(valid_574617, JString, required = true,
                                 default = nil)
  if valid_574617 != nil:
    section.add "key-version", valid_574617
  var valid_574618 = path.getOrDefault("key-name")
  valid_574618 = validateParameter(valid_574618, JString, required = true,
                                 default = nil)
  if valid_574618 != nil:
    section.add "key-name", valid_574618
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574619 = query.getOrDefault("api-version")
  valid_574619 = validateParameter(valid_574619, JString, required = true,
                                 default = nil)
  if valid_574619 != nil:
    section.add "api-version", valid_574619
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for the decryption operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574621: Call_Decrypt_574614; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DECRYPT operation decrypts a well-formed block of ciphertext using the target encryption key and specified algorithm. This operation is the reverse of the ENCRYPT operation; only a single block of data may be decrypted, the size of this block is dependent on the target key and the algorithm to be used. The DECRYPT operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/decrypt permission.
  ## 
  let valid = call_574621.validator(path, query, header, formData, body)
  let scheme = call_574621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574621.url(scheme.get, call_574621.host, call_574621.base,
                         call_574621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574621, url, valid)

proc call*(call_574622: Call_Decrypt_574614; apiVersion: string; keyVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## decrypt
  ## The DECRYPT operation decrypts a well-formed block of ciphertext using the target encryption key and specified algorithm. This operation is the reverse of the ENCRYPT operation; only a single block of data may be decrypted, the size of this block is dependent on the target key and the algorithm to be used. The DECRYPT operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/decrypt permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyVersion: string (required)
  ##             : The version of the key.
  ##   parameters: JObject (required)
  ##             : The parameters for the decryption operation.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_574623 = newJObject()
  var query_574624 = newJObject()
  var body_574625 = newJObject()
  add(query_574624, "api-version", newJString(apiVersion))
  add(path_574623, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574625 = parameters
  add(path_574623, "key-name", newJString(keyName))
  result = call_574622.call(path_574623, query_574624, nil, nil, body_574625)

var decrypt* = Call_Decrypt_574614(name: "decrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/decrypt",
                                validator: validate_Decrypt_574615, base: "",
                                url: url_Decrypt_574616, schemes: {Scheme.Https})
type
  Call_Encrypt_574626 = ref object of OpenApiRestCall_573666
proc url_Encrypt_574628(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Encrypt_574627(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## The ENCRYPT operation encrypts an arbitrary sequence of bytes using an encryption key that is stored in Azure Key Vault. Note that the ENCRYPT operation only supports a single block of data, the size of which is dependent on the target key and the encryption algorithm to be used. The ENCRYPT operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/encrypt permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key.
  ##   key-name: JString (required)
  ##           : The name of the key.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_574629 = path.getOrDefault("key-version")
  valid_574629 = validateParameter(valid_574629, JString, required = true,
                                 default = nil)
  if valid_574629 != nil:
    section.add "key-version", valid_574629
  var valid_574630 = path.getOrDefault("key-name")
  valid_574630 = validateParameter(valid_574630, JString, required = true,
                                 default = nil)
  if valid_574630 != nil:
    section.add "key-name", valid_574630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574631 = query.getOrDefault("api-version")
  valid_574631 = validateParameter(valid_574631, JString, required = true,
                                 default = nil)
  if valid_574631 != nil:
    section.add "api-version", valid_574631
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for the encryption operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574633: Call_Encrypt_574626; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The ENCRYPT operation encrypts an arbitrary sequence of bytes using an encryption key that is stored in Azure Key Vault. Note that the ENCRYPT operation only supports a single block of data, the size of which is dependent on the target key and the encryption algorithm to be used. The ENCRYPT operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/encrypt permission.
  ## 
  let valid = call_574633.validator(path, query, header, formData, body)
  let scheme = call_574633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574633.url(scheme.get, call_574633.host, call_574633.base,
                         call_574633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574633, url, valid)

proc call*(call_574634: Call_Encrypt_574626; apiVersion: string; keyVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## encrypt
  ## The ENCRYPT operation encrypts an arbitrary sequence of bytes using an encryption key that is stored in Azure Key Vault. Note that the ENCRYPT operation only supports a single block of data, the size of which is dependent on the target key and the encryption algorithm to be used. The ENCRYPT operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/encrypt permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyVersion: string (required)
  ##             : The version of the key.
  ##   parameters: JObject (required)
  ##             : The parameters for the encryption operation.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_574635 = newJObject()
  var query_574636 = newJObject()
  var body_574637 = newJObject()
  add(query_574636, "api-version", newJString(apiVersion))
  add(path_574635, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574637 = parameters
  add(path_574635, "key-name", newJString(keyName))
  result = call_574634.call(path_574635, query_574636, nil, nil, body_574637)

var encrypt* = Call_Encrypt_574626(name: "encrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/encrypt",
                                validator: validate_Encrypt_574627, base: "",
                                url: url_Encrypt_574628, schemes: {Scheme.Https})
type
  Call_Sign_574638 = ref object of OpenApiRestCall_573666
proc url_Sign_574640(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Sign_574639(path: JsonNode; query: JsonNode; header: JsonNode;
                         formData: JsonNode; body: JsonNode): JsonNode =
  ## The SIGN operation is applicable to asymmetric and symmetric keys stored in Azure Key Vault since this operation uses the private portion of the key. This operation requires the keys/sign permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key.
  ##   key-name: JString (required)
  ##           : The name of the key.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_574641 = path.getOrDefault("key-version")
  valid_574641 = validateParameter(valid_574641, JString, required = true,
                                 default = nil)
  if valid_574641 != nil:
    section.add "key-version", valid_574641
  var valid_574642 = path.getOrDefault("key-name")
  valid_574642 = validateParameter(valid_574642, JString, required = true,
                                 default = nil)
  if valid_574642 != nil:
    section.add "key-name", valid_574642
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574643 = query.getOrDefault("api-version")
  valid_574643 = validateParameter(valid_574643, JString, required = true,
                                 default = nil)
  if valid_574643 != nil:
    section.add "api-version", valid_574643
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for the signing operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574645: Call_Sign_574638; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The SIGN operation is applicable to asymmetric and symmetric keys stored in Azure Key Vault since this operation uses the private portion of the key. This operation requires the keys/sign permission.
  ## 
  let valid = call_574645.validator(path, query, header, formData, body)
  let scheme = call_574645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574645.url(scheme.get, call_574645.host, call_574645.base,
                         call_574645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574645, url, valid)

proc call*(call_574646: Call_Sign_574638; apiVersion: string; keyVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## sign
  ## The SIGN operation is applicable to asymmetric and symmetric keys stored in Azure Key Vault since this operation uses the private portion of the key. This operation requires the keys/sign permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyVersion: string (required)
  ##             : The version of the key.
  ##   parameters: JObject (required)
  ##             : The parameters for the signing operation.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_574647 = newJObject()
  var query_574648 = newJObject()
  var body_574649 = newJObject()
  add(query_574648, "api-version", newJString(apiVersion))
  add(path_574647, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574649 = parameters
  add(path_574647, "key-name", newJString(keyName))
  result = call_574646.call(path_574647, query_574648, nil, nil, body_574649)

var sign* = Call_Sign_574638(name: "sign", meth: HttpMethod.HttpPost,
                          host: "azure.local",
                          route: "/keys/{key-name}/{key-version}/sign",
                          validator: validate_Sign_574639, base: "", url: url_Sign_574640,
                          schemes: {Scheme.Https})
type
  Call_UnwrapKey_574650 = ref object of OpenApiRestCall_573666
proc url_UnwrapKey_574652(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UnwrapKey_574651(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## The UNWRAP operation supports decryption of a symmetric key using the target key encryption key. This operation is the reverse of the WRAP operation. The UNWRAP operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/unwrapKey permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key.
  ##   key-name: JString (required)
  ##           : The name of the key.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_574653 = path.getOrDefault("key-version")
  valid_574653 = validateParameter(valid_574653, JString, required = true,
                                 default = nil)
  if valid_574653 != nil:
    section.add "key-version", valid_574653
  var valid_574654 = path.getOrDefault("key-name")
  valid_574654 = validateParameter(valid_574654, JString, required = true,
                                 default = nil)
  if valid_574654 != nil:
    section.add "key-name", valid_574654
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574655 = query.getOrDefault("api-version")
  valid_574655 = validateParameter(valid_574655, JString, required = true,
                                 default = nil)
  if valid_574655 != nil:
    section.add "api-version", valid_574655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for the key operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574657: Call_UnwrapKey_574650; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UNWRAP operation supports decryption of a symmetric key using the target key encryption key. This operation is the reverse of the WRAP operation. The UNWRAP operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/unwrapKey permission.
  ## 
  let valid = call_574657.validator(path, query, header, formData, body)
  let scheme = call_574657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574657.url(scheme.get, call_574657.host, call_574657.base,
                         call_574657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574657, url, valid)

proc call*(call_574658: Call_UnwrapKey_574650; apiVersion: string;
          keyVersion: string; parameters: JsonNode; keyName: string): Recallable =
  ## unwrapKey
  ## The UNWRAP operation supports decryption of a symmetric key using the target key encryption key. This operation is the reverse of the WRAP operation. The UNWRAP operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/unwrapKey permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyVersion: string (required)
  ##             : The version of the key.
  ##   parameters: JObject (required)
  ##             : The parameters for the key operation.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_574659 = newJObject()
  var query_574660 = newJObject()
  var body_574661 = newJObject()
  add(query_574660, "api-version", newJString(apiVersion))
  add(path_574659, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574661 = parameters
  add(path_574659, "key-name", newJString(keyName))
  result = call_574658.call(path_574659, query_574660, nil, nil, body_574661)

var unwrapKey* = Call_UnwrapKey_574650(name: "unwrapKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/keys/{key-name}/{key-version}/unwrapkey",
                                    validator: validate_UnwrapKey_574651,
                                    base: "", url: url_UnwrapKey_574652,
                                    schemes: {Scheme.Https})
type
  Call_Verify_574662 = ref object of OpenApiRestCall_573666
proc url_Verify_574664(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Verify_574663(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## The VERIFY operation is applicable to symmetric keys stored in Azure Key Vault. VERIFY is not strictly necessary for asymmetric keys stored in Azure Key Vault since signature verification can be performed using the public portion of the key but this operation is supported as a convenience for callers that only have a key-reference and not the public portion of the key. This operation requires the keys/verify permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key.
  ##   key-name: JString (required)
  ##           : The name of the key.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_574665 = path.getOrDefault("key-version")
  valid_574665 = validateParameter(valid_574665, JString, required = true,
                                 default = nil)
  if valid_574665 != nil:
    section.add "key-version", valid_574665
  var valid_574666 = path.getOrDefault("key-name")
  valid_574666 = validateParameter(valid_574666, JString, required = true,
                                 default = nil)
  if valid_574666 != nil:
    section.add "key-name", valid_574666
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574667 = query.getOrDefault("api-version")
  valid_574667 = validateParameter(valid_574667, JString, required = true,
                                 default = nil)
  if valid_574667 != nil:
    section.add "api-version", valid_574667
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for verify operations.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574669: Call_Verify_574662; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The VERIFY operation is applicable to symmetric keys stored in Azure Key Vault. VERIFY is not strictly necessary for asymmetric keys stored in Azure Key Vault since signature verification can be performed using the public portion of the key but this operation is supported as a convenience for callers that only have a key-reference and not the public portion of the key. This operation requires the keys/verify permission.
  ## 
  let valid = call_574669.validator(path, query, header, formData, body)
  let scheme = call_574669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574669.url(scheme.get, call_574669.host, call_574669.base,
                         call_574669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574669, url, valid)

proc call*(call_574670: Call_Verify_574662; apiVersion: string; keyVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## verify
  ## The VERIFY operation is applicable to symmetric keys stored in Azure Key Vault. VERIFY is not strictly necessary for asymmetric keys stored in Azure Key Vault since signature verification can be performed using the public portion of the key but this operation is supported as a convenience for callers that only have a key-reference and not the public portion of the key. This operation requires the keys/verify permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyVersion: string (required)
  ##             : The version of the key.
  ##   parameters: JObject (required)
  ##             : The parameters for verify operations.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_574671 = newJObject()
  var query_574672 = newJObject()
  var body_574673 = newJObject()
  add(query_574672, "api-version", newJString(apiVersion))
  add(path_574671, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574673 = parameters
  add(path_574671, "key-name", newJString(keyName))
  result = call_574670.call(path_574671, query_574672, nil, nil, body_574673)

var verify* = Call_Verify_574662(name: "verify", meth: HttpMethod.HttpPost,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}/verify",
                              validator: validate_Verify_574663, base: "",
                              url: url_Verify_574664, schemes: {Scheme.Https})
type
  Call_WrapKey_574674 = ref object of OpenApiRestCall_573666
proc url_WrapKey_574676(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_WrapKey_574675(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## The WRAP operation supports encryption of a symmetric key using a key encryption key that has previously been stored in an Azure Key Vault. The WRAP operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using the public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/wrapKey permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   key-version: JString (required)
  ##              : The version of the key.
  ##   key-name: JString (required)
  ##           : The name of the key.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `key-version` field"
  var valid_574677 = path.getOrDefault("key-version")
  valid_574677 = validateParameter(valid_574677, JString, required = true,
                                 default = nil)
  if valid_574677 != nil:
    section.add "key-version", valid_574677
  var valid_574678 = path.getOrDefault("key-name")
  valid_574678 = validateParameter(valid_574678, JString, required = true,
                                 default = nil)
  if valid_574678 != nil:
    section.add "key-name", valid_574678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574679 = query.getOrDefault("api-version")
  valid_574679 = validateParameter(valid_574679, JString, required = true,
                                 default = nil)
  if valid_574679 != nil:
    section.add "api-version", valid_574679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for wrap operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574681: Call_WrapKey_574674; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The WRAP operation supports encryption of a symmetric key using a key encryption key that has previously been stored in an Azure Key Vault. The WRAP operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using the public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/wrapKey permission.
  ## 
  let valid = call_574681.validator(path, query, header, formData, body)
  let scheme = call_574681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574681.url(scheme.get, call_574681.host, call_574681.base,
                         call_574681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574681, url, valid)

proc call*(call_574682: Call_WrapKey_574674; apiVersion: string; keyVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## wrapKey
  ## The WRAP operation supports encryption of a symmetric key using a key encryption key that has previously been stored in an Azure Key Vault. The WRAP operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using the public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/wrapKey permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyVersion: string (required)
  ##             : The version of the key.
  ##   parameters: JObject (required)
  ##             : The parameters for wrap operation.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_574683 = newJObject()
  var query_574684 = newJObject()
  var body_574685 = newJObject()
  add(query_574684, "api-version", newJString(apiVersion))
  add(path_574683, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_574685 = parameters
  add(path_574683, "key-name", newJString(keyName))
  result = call_574682.call(path_574683, query_574684, nil, nil, body_574685)

var wrapKey* = Call_WrapKey_574674(name: "wrapKey", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/wrapkey",
                                validator: validate_WrapKey_574675, base: "",
                                url: url_WrapKey_574676, schemes: {Scheme.Https})
type
  Call_GetSecrets_574686 = ref object of OpenApiRestCall_573666
proc url_GetSecrets_574688(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetSecrets_574687(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get Secrets operation is applicable to the entire vault. However, only the base secret identifier and its attributes are provided in the response. Individual secret versions are not listed in the response. This operation requires the secrets/list permission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574689 = query.getOrDefault("api-version")
  valid_574689 = validateParameter(valid_574689, JString, required = true,
                                 default = nil)
  if valid_574689 != nil:
    section.add "api-version", valid_574689
  var valid_574690 = query.getOrDefault("maxresults")
  valid_574690 = validateParameter(valid_574690, JInt, required = false, default = nil)
  if valid_574690 != nil:
    section.add "maxresults", valid_574690
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574691: Call_GetSecrets_574686; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Secrets operation is applicable to the entire vault. However, only the base secret identifier and its attributes are provided in the response. Individual secret versions are not listed in the response. This operation requires the secrets/list permission.
  ## 
  let valid = call_574691.validator(path, query, header, formData, body)
  let scheme = call_574691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574691.url(scheme.get, call_574691.host, call_574691.base,
                         call_574691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574691, url, valid)

proc call*(call_574692: Call_GetSecrets_574686; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getSecrets
  ## The Get Secrets operation is applicable to the entire vault. However, only the base secret identifier and its attributes are provided in the response. Individual secret versions are not listed in the response. This operation requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  var query_574693 = newJObject()
  add(query_574693, "api-version", newJString(apiVersion))
  add(query_574693, "maxresults", newJInt(maxresults))
  result = call_574692.call(nil, query_574693, nil, nil, nil)

var getSecrets* = Call_GetSecrets_574686(name: "getSecrets",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/secrets",
                                      validator: validate_GetSecrets_574687,
                                      base: "", url: url_GetSecrets_574688,
                                      schemes: {Scheme.Https})
type
  Call_RestoreSecret_574694 = ref object of OpenApiRestCall_573666
proc url_RestoreSecret_574696(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreSecret_574695(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores a backed up secret, and all its versions, to a vault. This operation requires the secrets/restore permission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574697 = query.getOrDefault("api-version")
  valid_574697 = validateParameter(valid_574697, JString, required = true,
                                 default = nil)
  if valid_574697 != nil:
    section.add "api-version", valid_574697
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to restore the secret.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574699: Call_RestoreSecret_574694; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backed up secret, and all its versions, to a vault. This operation requires the secrets/restore permission.
  ## 
  let valid = call_574699.validator(path, query, header, formData, body)
  let scheme = call_574699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574699.url(scheme.get, call_574699.host, call_574699.base,
                         call_574699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574699, url, valid)

proc call*(call_574700: Call_RestoreSecret_574694; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreSecret
  ## Restores a backed up secret, and all its versions, to a vault. This operation requires the secrets/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the secret.
  var query_574701 = newJObject()
  var body_574702 = newJObject()
  add(query_574701, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574702 = parameters
  result = call_574700.call(nil, query_574701, nil, nil, body_574702)

var restoreSecret* = Call_RestoreSecret_574694(name: "restoreSecret",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/secrets/restore",
    validator: validate_RestoreSecret_574695, base: "", url: url_RestoreSecret_574696,
    schemes: {Scheme.Https})
type
  Call_SetSecret_574703 = ref object of OpenApiRestCall_573666
proc url_SetSecret_574705(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SetSecret_574704(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ##  The SET operation adds a secret to the Azure Key Vault. If the named secret already exists, Azure Key Vault creates a new version of that secret. This operation requires the secrets/set permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-name: JString (required)
  ##              : The name of the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-name` field"
  var valid_574706 = path.getOrDefault("secret-name")
  valid_574706 = validateParameter(valid_574706, JString, required = true,
                                 default = nil)
  if valid_574706 != nil:
    section.add "secret-name", valid_574706
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574707 = query.getOrDefault("api-version")
  valid_574707 = validateParameter(valid_574707, JString, required = true,
                                 default = nil)
  if valid_574707 != nil:
    section.add "api-version", valid_574707
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for setting the secret.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574709: Call_SetSecret_574703; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ##  The SET operation adds a secret to the Azure Key Vault. If the named secret already exists, Azure Key Vault creates a new version of that secret. This operation requires the secrets/set permission.
  ## 
  let valid = call_574709.validator(path, query, header, formData, body)
  let scheme = call_574709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574709.url(scheme.get, call_574709.host, call_574709.base,
                         call_574709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574709, url, valid)

proc call*(call_574710: Call_SetSecret_574703; apiVersion: string;
          secretName: string; parameters: JsonNode): Recallable =
  ## setSecret
  ##  The SET operation adds a secret to the Azure Key Vault. If the named secret already exists, Azure Key Vault creates a new version of that secret. This operation requires the secrets/set permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  ##   parameters: JObject (required)
  ##             : The parameters for setting the secret.
  var path_574711 = newJObject()
  var query_574712 = newJObject()
  var body_574713 = newJObject()
  add(query_574712, "api-version", newJString(apiVersion))
  add(path_574711, "secret-name", newJString(secretName))
  if parameters != nil:
    body_574713 = parameters
  result = call_574710.call(path_574711, query_574712, nil, nil, body_574713)

var setSecret* = Call_SetSecret_574703(name: "setSecret", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/secrets/{secret-name}",
                                    validator: validate_SetSecret_574704,
                                    base: "", url: url_SetSecret_574705,
                                    schemes: {Scheme.Https})
type
  Call_DeleteSecret_574714 = ref object of OpenApiRestCall_573666
proc url_DeleteSecret_574716(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteSecret_574715(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The DELETE operation applies to any secret stored in Azure Key Vault. DELETE cannot be applied to an individual version of a secret. This operation requires the secrets/delete permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-name: JString (required)
  ##              : The name of the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-name` field"
  var valid_574717 = path.getOrDefault("secret-name")
  valid_574717 = validateParameter(valid_574717, JString, required = true,
                                 default = nil)
  if valid_574717 != nil:
    section.add "secret-name", valid_574717
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574718 = query.getOrDefault("api-version")
  valid_574718 = validateParameter(valid_574718, JString, required = true,
                                 default = nil)
  if valid_574718 != nil:
    section.add "api-version", valid_574718
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574719: Call_DeleteSecret_574714; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DELETE operation applies to any secret stored in Azure Key Vault. DELETE cannot be applied to an individual version of a secret. This operation requires the secrets/delete permission.
  ## 
  let valid = call_574719.validator(path, query, header, formData, body)
  let scheme = call_574719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574719.url(scheme.get, call_574719.host, call_574719.base,
                         call_574719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574719, url, valid)

proc call*(call_574720: Call_DeleteSecret_574714; apiVersion: string;
          secretName: string): Recallable =
  ## deleteSecret
  ## The DELETE operation applies to any secret stored in Azure Key Vault. DELETE cannot be applied to an individual version of a secret. This operation requires the secrets/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_574721 = newJObject()
  var query_574722 = newJObject()
  add(query_574722, "api-version", newJString(apiVersion))
  add(path_574721, "secret-name", newJString(secretName))
  result = call_574720.call(path_574721, query_574722, nil, nil, nil)

var deleteSecret* = Call_DeleteSecret_574714(name: "deleteSecret",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/secrets/{secret-name}", validator: validate_DeleteSecret_574715,
    base: "", url: url_DeleteSecret_574716, schemes: {Scheme.Https})
type
  Call_BackupSecret_574723 = ref object of OpenApiRestCall_573666
proc url_BackupSecret_574725(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "secret-name" in path, "`secret-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "secret-name"),
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupSecret_574724(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests that a backup of the specified secret be downloaded to the client. All versions of the secret will be downloaded. This operation requires the secrets/backup permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-name: JString (required)
  ##              : The name of the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-name` field"
  var valid_574726 = path.getOrDefault("secret-name")
  valid_574726 = validateParameter(valid_574726, JString, required = true,
                                 default = nil)
  if valid_574726 != nil:
    section.add "secret-name", valid_574726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574727 = query.getOrDefault("api-version")
  valid_574727 = validateParameter(valid_574727, JString, required = true,
                                 default = nil)
  if valid_574727 != nil:
    section.add "api-version", valid_574727
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574728: Call_BackupSecret_574723; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified secret be downloaded to the client. All versions of the secret will be downloaded. This operation requires the secrets/backup permission.
  ## 
  let valid = call_574728.validator(path, query, header, formData, body)
  let scheme = call_574728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574728.url(scheme.get, call_574728.host, call_574728.base,
                         call_574728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574728, url, valid)

proc call*(call_574729: Call_BackupSecret_574723; apiVersion: string;
          secretName: string): Recallable =
  ## backupSecret
  ## Requests that a backup of the specified secret be downloaded to the client. All versions of the secret will be downloaded. This operation requires the secrets/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_574730 = newJObject()
  var query_574731 = newJObject()
  add(query_574731, "api-version", newJString(apiVersion))
  add(path_574730, "secret-name", newJString(secretName))
  result = call_574729.call(path_574730, query_574731, nil, nil, nil)

var backupSecret* = Call_BackupSecret_574723(name: "backupSecret",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/secrets/{secret-name}/backup", validator: validate_BackupSecret_574724,
    base: "", url: url_BackupSecret_574725, schemes: {Scheme.Https})
type
  Call_GetSecretVersions_574732 = ref object of OpenApiRestCall_573666
proc url_GetSecretVersions_574734(protocol: Scheme; host: string; base: string;
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

proc validate_GetSecretVersions_574733(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The full secret identifier and attributes are provided in the response. No values are returned for the secrets. This operations requires the secrets/list permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-name: JString (required)
  ##              : The name of the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-name` field"
  var valid_574735 = path.getOrDefault("secret-name")
  valid_574735 = validateParameter(valid_574735, JString, required = true,
                                 default = nil)
  if valid_574735 != nil:
    section.add "secret-name", valid_574735
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574736 = query.getOrDefault("api-version")
  valid_574736 = validateParameter(valid_574736, JString, required = true,
                                 default = nil)
  if valid_574736 != nil:
    section.add "api-version", valid_574736
  var valid_574737 = query.getOrDefault("maxresults")
  valid_574737 = validateParameter(valid_574737, JInt, required = false, default = nil)
  if valid_574737 != nil:
    section.add "maxresults", valid_574737
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574738: Call_GetSecretVersions_574732; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The full secret identifier and attributes are provided in the response. No values are returned for the secrets. This operations requires the secrets/list permission.
  ## 
  let valid = call_574738.validator(path, query, header, formData, body)
  let scheme = call_574738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574738.url(scheme.get, call_574738.host, call_574738.base,
                         call_574738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574738, url, valid)

proc call*(call_574739: Call_GetSecretVersions_574732; apiVersion: string;
          secretName: string; maxresults: int = 0): Recallable =
  ## getSecretVersions
  ## The full secret identifier and attributes are provided in the response. No values are returned for the secrets. This operations requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_574740 = newJObject()
  var query_574741 = newJObject()
  add(query_574741, "api-version", newJString(apiVersion))
  add(query_574741, "maxresults", newJInt(maxresults))
  add(path_574740, "secret-name", newJString(secretName))
  result = call_574739.call(path_574740, query_574741, nil, nil, nil)

var getSecretVersions* = Call_GetSecretVersions_574732(name: "getSecretVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/secrets/{secret-name}/versions",
    validator: validate_GetSecretVersions_574733, base: "",
    url: url_GetSecretVersions_574734, schemes: {Scheme.Https})
type
  Call_GetSecret_574742 = ref object of OpenApiRestCall_573666
proc url_GetSecret_574744(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetSecret_574743(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## The GET operation is applicable to any secret stored in Azure Key Vault. This operation requires the secrets/get permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-version: JString (required)
  ##                 : The version of the secret.
  ##   secret-name: JString (required)
  ##              : The name of the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-version` field"
  var valid_574745 = path.getOrDefault("secret-version")
  valid_574745 = validateParameter(valid_574745, JString, required = true,
                                 default = nil)
  if valid_574745 != nil:
    section.add "secret-version", valid_574745
  var valid_574746 = path.getOrDefault("secret-name")
  valid_574746 = validateParameter(valid_574746, JString, required = true,
                                 default = nil)
  if valid_574746 != nil:
    section.add "secret-name", valid_574746
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574747 = query.getOrDefault("api-version")
  valid_574747 = validateParameter(valid_574747, JString, required = true,
                                 default = nil)
  if valid_574747 != nil:
    section.add "api-version", valid_574747
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574748: Call_GetSecret_574742; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GET operation is applicable to any secret stored in Azure Key Vault. This operation requires the secrets/get permission.
  ## 
  let valid = call_574748.validator(path, query, header, formData, body)
  let scheme = call_574748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574748.url(scheme.get, call_574748.host, call_574748.base,
                         call_574748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574748, url, valid)

proc call*(call_574749: Call_GetSecret_574742; apiVersion: string;
          secretVersion: string; secretName: string): Recallable =
  ## getSecret
  ## The GET operation is applicable to any secret stored in Azure Key Vault. This operation requires the secrets/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretVersion: string (required)
  ##                : The version of the secret.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_574750 = newJObject()
  var query_574751 = newJObject()
  add(query_574751, "api-version", newJString(apiVersion))
  add(path_574750, "secret-version", newJString(secretVersion))
  add(path_574750, "secret-name", newJString(secretName))
  result = call_574749.call(path_574750, query_574751, nil, nil, nil)

var getSecret* = Call_GetSecret_574742(name: "getSecret", meth: HttpMethod.HttpGet,
                                    host: "azure.local", route: "/secrets/{secret-name}/{secret-version}",
                                    validator: validate_GetSecret_574743,
                                    base: "", url: url_GetSecret_574744,
                                    schemes: {Scheme.Https})
type
  Call_UpdateSecret_574752 = ref object of OpenApiRestCall_573666
proc url_UpdateSecret_574754(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateSecret_574753(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The UPDATE operation changes specified attributes of an existing stored secret. Attributes that are not specified in the request are left unchanged. The value of a secret itself cannot be changed. This operation requires the secrets/set permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   secret-version: JString (required)
  ##                 : The version of the secret.
  ##   secret-name: JString (required)
  ##              : The name of the secret.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `secret-version` field"
  var valid_574755 = path.getOrDefault("secret-version")
  valid_574755 = validateParameter(valid_574755, JString, required = true,
                                 default = nil)
  if valid_574755 != nil:
    section.add "secret-version", valid_574755
  var valid_574756 = path.getOrDefault("secret-name")
  valid_574756 = validateParameter(valid_574756, JString, required = true,
                                 default = nil)
  if valid_574756 != nil:
    section.add "secret-name", valid_574756
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574757 = query.getOrDefault("api-version")
  valid_574757 = validateParameter(valid_574757, JString, required = true,
                                 default = nil)
  if valid_574757 != nil:
    section.add "api-version", valid_574757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for update secret operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574759: Call_UpdateSecret_574752; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UPDATE operation changes specified attributes of an existing stored secret. Attributes that are not specified in the request are left unchanged. The value of a secret itself cannot be changed. This operation requires the secrets/set permission.
  ## 
  let valid = call_574759.validator(path, query, header, formData, body)
  let scheme = call_574759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574759.url(scheme.get, call_574759.host, call_574759.base,
                         call_574759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574759, url, valid)

proc call*(call_574760: Call_UpdateSecret_574752; apiVersion: string;
          secretVersion: string; secretName: string; parameters: JsonNode): Recallable =
  ## updateSecret
  ## The UPDATE operation changes specified attributes of an existing stored secret. Attributes that are not specified in the request are left unchanged. The value of a secret itself cannot be changed. This operation requires the secrets/set permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretVersion: string (required)
  ##                : The version of the secret.
  ##   secretName: string (required)
  ##             : The name of the secret.
  ##   parameters: JObject (required)
  ##             : The parameters for update secret operation.
  var path_574761 = newJObject()
  var query_574762 = newJObject()
  var body_574763 = newJObject()
  add(query_574762, "api-version", newJString(apiVersion))
  add(path_574761, "secret-version", newJString(secretVersion))
  add(path_574761, "secret-name", newJString(secretName))
  if parameters != nil:
    body_574763 = parameters
  result = call_574760.call(path_574761, query_574762, nil, nil, body_574763)

var updateSecret* = Call_UpdateSecret_574752(name: "updateSecret",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/secrets/{secret-name}/{secret-version}",
    validator: validate_UpdateSecret_574753, base: "", url: url_UpdateSecret_574754,
    schemes: {Scheme.Https})
type
  Call_GetStorageAccounts_574764 = ref object of OpenApiRestCall_573666
proc url_GetStorageAccounts_574766(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetStorageAccounts_574765(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List storage accounts managed by the specified key vault. This operation requires the storage/list permission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574767 = query.getOrDefault("api-version")
  valid_574767 = validateParameter(valid_574767, JString, required = true,
                                 default = nil)
  if valid_574767 != nil:
    section.add "api-version", valid_574767
  var valid_574768 = query.getOrDefault("maxresults")
  valid_574768 = validateParameter(valid_574768, JInt, required = false, default = nil)
  if valid_574768 != nil:
    section.add "maxresults", valid_574768
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574769: Call_GetStorageAccounts_574764; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List storage accounts managed by the specified key vault. This operation requires the storage/list permission.
  ## 
  let valid = call_574769.validator(path, query, header, formData, body)
  let scheme = call_574769.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574769.url(scheme.get, call_574769.host, call_574769.base,
                         call_574769.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574769, url, valid)

proc call*(call_574770: Call_GetStorageAccounts_574764; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getStorageAccounts
  ## List storage accounts managed by the specified key vault. This operation requires the storage/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_574771 = newJObject()
  add(query_574771, "api-version", newJString(apiVersion))
  add(query_574771, "maxresults", newJInt(maxresults))
  result = call_574770.call(nil, query_574771, nil, nil, nil)

var getStorageAccounts* = Call_GetStorageAccounts_574764(
    name: "getStorageAccounts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage", validator: validate_GetStorageAccounts_574765, base: "",
    url: url_GetStorageAccounts_574766, schemes: {Scheme.Https})
type
  Call_SetStorageAccount_574781 = ref object of OpenApiRestCall_573666
proc url_SetStorageAccount_574783(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/storage/"),
               (kind: VariableSegment, value: "storage-account-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SetStorageAccount_574782(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates or updates a new storage account. This operation requires the storage/set permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_574784 = path.getOrDefault("storage-account-name")
  valid_574784 = validateParameter(valid_574784, JString, required = true,
                                 default = nil)
  if valid_574784 != nil:
    section.add "storage-account-name", valid_574784
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574785 = query.getOrDefault("api-version")
  valid_574785 = validateParameter(valid_574785, JString, required = true,
                                 default = nil)
  if valid_574785 != nil:
    section.add "api-version", valid_574785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to create a storage account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574787: Call_SetStorageAccount_574781; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new storage account. This operation requires the storage/set permission.
  ## 
  let valid = call_574787.validator(path, query, header, formData, body)
  let scheme = call_574787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574787.url(scheme.get, call_574787.host, call_574787.base,
                         call_574787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574787, url, valid)

proc call*(call_574788: Call_SetStorageAccount_574781; apiVersion: string;
          storageAccountName: string; parameters: JsonNode): Recallable =
  ## setStorageAccount
  ## Creates or updates a new storage account. This operation requires the storage/set permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to create a storage account.
  var path_574789 = newJObject()
  var query_574790 = newJObject()
  var body_574791 = newJObject()
  add(query_574790, "api-version", newJString(apiVersion))
  add(path_574789, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_574791 = parameters
  result = call_574788.call(path_574789, query_574790, nil, nil, body_574791)

var setStorageAccount* = Call_SetStorageAccount_574781(name: "setStorageAccount",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_SetStorageAccount_574782, base: "",
    url: url_SetStorageAccount_574783, schemes: {Scheme.Https})
type
  Call_GetStorageAccount_574772 = ref object of OpenApiRestCall_573666
proc url_GetStorageAccount_574774(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/storage/"),
               (kind: VariableSegment, value: "storage-account-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetStorageAccount_574773(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets information about a specified storage account. This operation requires the storage/get permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_574775 = path.getOrDefault("storage-account-name")
  valid_574775 = validateParameter(valid_574775, JString, required = true,
                                 default = nil)
  if valid_574775 != nil:
    section.add "storage-account-name", valid_574775
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574776 = query.getOrDefault("api-version")
  valid_574776 = validateParameter(valid_574776, JString, required = true,
                                 default = nil)
  if valid_574776 != nil:
    section.add "api-version", valid_574776
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574777: Call_GetStorageAccount_574772; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specified storage account. This operation requires the storage/get permission.
  ## 
  let valid = call_574777.validator(path, query, header, formData, body)
  let scheme = call_574777.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574777.url(scheme.get, call_574777.host, call_574777.base,
                         call_574777.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574777, url, valid)

proc call*(call_574778: Call_GetStorageAccount_574772; apiVersion: string;
          storageAccountName: string): Recallable =
  ## getStorageAccount
  ## Gets information about a specified storage account. This operation requires the storage/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_574779 = newJObject()
  var query_574780 = newJObject()
  add(query_574780, "api-version", newJString(apiVersion))
  add(path_574779, "storage-account-name", newJString(storageAccountName))
  result = call_574778.call(path_574779, query_574780, nil, nil, nil)

var getStorageAccount* = Call_GetStorageAccount_574772(name: "getStorageAccount",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_GetStorageAccount_574773, base: "",
    url: url_GetStorageAccount_574774, schemes: {Scheme.Https})
type
  Call_UpdateStorageAccount_574801 = ref object of OpenApiRestCall_573666
proc url_UpdateStorageAccount_574803(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/storage/"),
               (kind: VariableSegment, value: "storage-account-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateStorageAccount_574802(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified attributes associated with the given storage account. This operation requires the storage/set/update permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_574804 = path.getOrDefault("storage-account-name")
  valid_574804 = validateParameter(valid_574804, JString, required = true,
                                 default = nil)
  if valid_574804 != nil:
    section.add "storage-account-name", valid_574804
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574805 = query.getOrDefault("api-version")
  valid_574805 = validateParameter(valid_574805, JString, required = true,
                                 default = nil)
  if valid_574805 != nil:
    section.add "api-version", valid_574805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to update a storage account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574807: Call_UpdateStorageAccount_574801; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified attributes associated with the given storage account. This operation requires the storage/set/update permission.
  ## 
  let valid = call_574807.validator(path, query, header, formData, body)
  let scheme = call_574807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574807.url(scheme.get, call_574807.host, call_574807.base,
                         call_574807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574807, url, valid)

proc call*(call_574808: Call_UpdateStorageAccount_574801; apiVersion: string;
          storageAccountName: string; parameters: JsonNode): Recallable =
  ## updateStorageAccount
  ## Updates the specified attributes associated with the given storage account. This operation requires the storage/set/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to update a storage account.
  var path_574809 = newJObject()
  var query_574810 = newJObject()
  var body_574811 = newJObject()
  add(query_574810, "api-version", newJString(apiVersion))
  add(path_574809, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_574811 = parameters
  result = call_574808.call(path_574809, query_574810, nil, nil, body_574811)

var updateStorageAccount* = Call_UpdateStorageAccount_574801(
    name: "updateStorageAccount", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_UpdateStorageAccount_574802, base: "",
    url: url_UpdateStorageAccount_574803, schemes: {Scheme.Https})
type
  Call_DeleteStorageAccount_574792 = ref object of OpenApiRestCall_573666
proc url_DeleteStorageAccount_574794(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/storage/"),
               (kind: VariableSegment, value: "storage-account-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteStorageAccount_574793(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a storage account. This operation requires the storage/delete permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_574795 = path.getOrDefault("storage-account-name")
  valid_574795 = validateParameter(valid_574795, JString, required = true,
                                 default = nil)
  if valid_574795 != nil:
    section.add "storage-account-name", valid_574795
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574796 = query.getOrDefault("api-version")
  valid_574796 = validateParameter(valid_574796, JString, required = true,
                                 default = nil)
  if valid_574796 != nil:
    section.add "api-version", valid_574796
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574797: Call_DeleteStorageAccount_574792; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a storage account. This operation requires the storage/delete permission.
  ## 
  let valid = call_574797.validator(path, query, header, formData, body)
  let scheme = call_574797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574797.url(scheme.get, call_574797.host, call_574797.base,
                         call_574797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574797, url, valid)

proc call*(call_574798: Call_DeleteStorageAccount_574792; apiVersion: string;
          storageAccountName: string): Recallable =
  ## deleteStorageAccount
  ## Deletes a storage account. This operation requires the storage/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_574799 = newJObject()
  var query_574800 = newJObject()
  add(query_574800, "api-version", newJString(apiVersion))
  add(path_574799, "storage-account-name", newJString(storageAccountName))
  result = call_574798.call(path_574799, query_574800, nil, nil, nil)

var deleteStorageAccount* = Call_DeleteStorageAccount_574792(
    name: "deleteStorageAccount", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_DeleteStorageAccount_574793, base: "",
    url: url_DeleteStorageAccount_574794, schemes: {Scheme.Https})
type
  Call_RegenerateStorageAccountKey_574812 = ref object of OpenApiRestCall_573666
proc url_RegenerateStorageAccountKey_574814(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/storage/"),
               (kind: VariableSegment, value: "storage-account-name"),
               (kind: ConstantSegment, value: "/regeneratekey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegenerateStorageAccountKey_574813(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the specified key value for the given storage account. This operation requires the storage/regeneratekey permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_574815 = path.getOrDefault("storage-account-name")
  valid_574815 = validateParameter(valid_574815, JString, required = true,
                                 default = nil)
  if valid_574815 != nil:
    section.add "storage-account-name", valid_574815
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574816 = query.getOrDefault("api-version")
  valid_574816 = validateParameter(valid_574816, JString, required = true,
                                 default = nil)
  if valid_574816 != nil:
    section.add "api-version", valid_574816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to regenerate storage account key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574818: Call_RegenerateStorageAccountKey_574812; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the specified key value for the given storage account. This operation requires the storage/regeneratekey permission.
  ## 
  let valid = call_574818.validator(path, query, header, formData, body)
  let scheme = call_574818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574818.url(scheme.get, call_574818.host, call_574818.base,
                         call_574818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574818, url, valid)

proc call*(call_574819: Call_RegenerateStorageAccountKey_574812;
          apiVersion: string; storageAccountName: string; parameters: JsonNode): Recallable =
  ## regenerateStorageAccountKey
  ## Regenerates the specified key value for the given storage account. This operation requires the storage/regeneratekey permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to regenerate storage account key.
  var path_574820 = newJObject()
  var query_574821 = newJObject()
  var body_574822 = newJObject()
  add(query_574821, "api-version", newJString(apiVersion))
  add(path_574820, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_574822 = parameters
  result = call_574819.call(path_574820, query_574821, nil, nil, body_574822)

var regenerateStorageAccountKey* = Call_RegenerateStorageAccountKey_574812(
    name: "regenerateStorageAccountKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/storage/{storage-account-name}/regeneratekey",
    validator: validate_RegenerateStorageAccountKey_574813, base: "",
    url: url_RegenerateStorageAccountKey_574814, schemes: {Scheme.Https})
type
  Call_GetSasDefinitions_574823 = ref object of OpenApiRestCall_573666
proc url_GetSasDefinitions_574825(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/storage/"),
               (kind: VariableSegment, value: "storage-account-name"),
               (kind: ConstantSegment, value: "/sas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetSasDefinitions_574824(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List storage SAS definitions for the given storage account. This operation requires the storage/listsas permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_574826 = path.getOrDefault("storage-account-name")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "storage-account-name", valid_574826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574827 = query.getOrDefault("api-version")
  valid_574827 = validateParameter(valid_574827, JString, required = true,
                                 default = nil)
  if valid_574827 != nil:
    section.add "api-version", valid_574827
  var valid_574828 = query.getOrDefault("maxresults")
  valid_574828 = validateParameter(valid_574828, JInt, required = false, default = nil)
  if valid_574828 != nil:
    section.add "maxresults", valid_574828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574829: Call_GetSasDefinitions_574823; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List storage SAS definitions for the given storage account. This operation requires the storage/listsas permission.
  ## 
  let valid = call_574829.validator(path, query, header, formData, body)
  let scheme = call_574829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574829.url(scheme.get, call_574829.host, call_574829.base,
                         call_574829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574829, url, valid)

proc call*(call_574830: Call_GetSasDefinitions_574823; apiVersion: string;
          storageAccountName: string; maxresults: int = 0): Recallable =
  ## getSasDefinitions
  ## List storage SAS definitions for the given storage account. This operation requires the storage/listsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_574831 = newJObject()
  var query_574832 = newJObject()
  add(query_574832, "api-version", newJString(apiVersion))
  add(query_574832, "maxresults", newJInt(maxresults))
  add(path_574831, "storage-account-name", newJString(storageAccountName))
  result = call_574830.call(path_574831, query_574832, nil, nil, nil)

var getSasDefinitions* = Call_GetSasDefinitions_574823(name: "getSasDefinitions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}/sas",
    validator: validate_GetSasDefinitions_574824, base: "",
    url: url_GetSasDefinitions_574825, schemes: {Scheme.Https})
type
  Call_SetSasDefinition_574843 = ref object of OpenApiRestCall_573666
proc url_SetSasDefinition_574845(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  assert "sas-definition-name" in path,
        "`sas-definition-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/storage/"),
               (kind: VariableSegment, value: "storage-account-name"),
               (kind: ConstantSegment, value: "/sas/"),
               (kind: VariableSegment, value: "sas-definition-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SetSasDefinition_574844(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates or updates a new SAS definition for the specified storage account. This operation requires the storage/setsas permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  ##   sas-definition-name: JString (required)
  ##                      : The name of the SAS definition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_574846 = path.getOrDefault("storage-account-name")
  valid_574846 = validateParameter(valid_574846, JString, required = true,
                                 default = nil)
  if valid_574846 != nil:
    section.add "storage-account-name", valid_574846
  var valid_574847 = path.getOrDefault("sas-definition-name")
  valid_574847 = validateParameter(valid_574847, JString, required = true,
                                 default = nil)
  if valid_574847 != nil:
    section.add "sas-definition-name", valid_574847
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574848 = query.getOrDefault("api-version")
  valid_574848 = validateParameter(valid_574848, JString, required = true,
                                 default = nil)
  if valid_574848 != nil:
    section.add "api-version", valid_574848
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to create a SAS definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574850: Call_SetSasDefinition_574843; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new SAS definition for the specified storage account. This operation requires the storage/setsas permission.
  ## 
  let valid = call_574850.validator(path, query, header, formData, body)
  let scheme = call_574850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574850.url(scheme.get, call_574850.host, call_574850.base,
                         call_574850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574850, url, valid)

proc call*(call_574851: Call_SetSasDefinition_574843; apiVersion: string;
          storageAccountName: string; parameters: JsonNode;
          sasDefinitionName: string): Recallable =
  ## setSasDefinition
  ## Creates or updates a new SAS definition for the specified storage account. This operation requires the storage/setsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to create a SAS definition.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_574852 = newJObject()
  var query_574853 = newJObject()
  var body_574854 = newJObject()
  add(query_574853, "api-version", newJString(apiVersion))
  add(path_574852, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_574854 = parameters
  add(path_574852, "sas-definition-name", newJString(sasDefinitionName))
  result = call_574851.call(path_574852, query_574853, nil, nil, body_574854)

var setSasDefinition* = Call_SetSasDefinition_574843(name: "setSasDefinition",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_SetSasDefinition_574844, base: "",
    url: url_SetSasDefinition_574845, schemes: {Scheme.Https})
type
  Call_GetSasDefinition_574833 = ref object of OpenApiRestCall_573666
proc url_GetSasDefinition_574835(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  assert "sas-definition-name" in path,
        "`sas-definition-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/storage/"),
               (kind: VariableSegment, value: "storage-account-name"),
               (kind: ConstantSegment, value: "/sas/"),
               (kind: VariableSegment, value: "sas-definition-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetSasDefinition_574834(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about a SAS definition for the specified storage account. This operation requires the storage/getsas permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  ##   sas-definition-name: JString (required)
  ##                      : The name of the SAS definition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_574836 = path.getOrDefault("storage-account-name")
  valid_574836 = validateParameter(valid_574836, JString, required = true,
                                 default = nil)
  if valid_574836 != nil:
    section.add "storage-account-name", valid_574836
  var valid_574837 = path.getOrDefault("sas-definition-name")
  valid_574837 = validateParameter(valid_574837, JString, required = true,
                                 default = nil)
  if valid_574837 != nil:
    section.add "sas-definition-name", valid_574837
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574838 = query.getOrDefault("api-version")
  valid_574838 = validateParameter(valid_574838, JString, required = true,
                                 default = nil)
  if valid_574838 != nil:
    section.add "api-version", valid_574838
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574839: Call_GetSasDefinition_574833; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a SAS definition for the specified storage account. This operation requires the storage/getsas permission.
  ## 
  let valid = call_574839.validator(path, query, header, formData, body)
  let scheme = call_574839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574839.url(scheme.get, call_574839.host, call_574839.base,
                         call_574839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574839, url, valid)

proc call*(call_574840: Call_GetSasDefinition_574833; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## getSasDefinition
  ## Gets information about a SAS definition for the specified storage account. This operation requires the storage/getsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_574841 = newJObject()
  var query_574842 = newJObject()
  add(query_574842, "api-version", newJString(apiVersion))
  add(path_574841, "storage-account-name", newJString(storageAccountName))
  add(path_574841, "sas-definition-name", newJString(sasDefinitionName))
  result = call_574840.call(path_574841, query_574842, nil, nil, nil)

var getSasDefinition* = Call_GetSasDefinition_574833(name: "getSasDefinition",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_GetSasDefinition_574834, base: "",
    url: url_GetSasDefinition_574835, schemes: {Scheme.Https})
type
  Call_UpdateSasDefinition_574865 = ref object of OpenApiRestCall_573666
proc url_UpdateSasDefinition_574867(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  assert "sas-definition-name" in path,
        "`sas-definition-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/storage/"),
               (kind: VariableSegment, value: "storage-account-name"),
               (kind: ConstantSegment, value: "/sas/"),
               (kind: VariableSegment, value: "sas-definition-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateSasDefinition_574866(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the specified attributes associated with the given SAS definition. This operation requires the storage/setsas permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  ##   sas-definition-name: JString (required)
  ##                      : The name of the SAS definition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_574868 = path.getOrDefault("storage-account-name")
  valid_574868 = validateParameter(valid_574868, JString, required = true,
                                 default = nil)
  if valid_574868 != nil:
    section.add "storage-account-name", valid_574868
  var valid_574869 = path.getOrDefault("sas-definition-name")
  valid_574869 = validateParameter(valid_574869, JString, required = true,
                                 default = nil)
  if valid_574869 != nil:
    section.add "sas-definition-name", valid_574869
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574870 = query.getOrDefault("api-version")
  valid_574870 = validateParameter(valid_574870, JString, required = true,
                                 default = nil)
  if valid_574870 != nil:
    section.add "api-version", valid_574870
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to update a SAS definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574872: Call_UpdateSasDefinition_574865; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified attributes associated with the given SAS definition. This operation requires the storage/setsas permission.
  ## 
  let valid = call_574872.validator(path, query, header, formData, body)
  let scheme = call_574872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574872.url(scheme.get, call_574872.host, call_574872.base,
                         call_574872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574872, url, valid)

proc call*(call_574873: Call_UpdateSasDefinition_574865; apiVersion: string;
          storageAccountName: string; parameters: JsonNode;
          sasDefinitionName: string): Recallable =
  ## updateSasDefinition
  ## Updates the specified attributes associated with the given SAS definition. This operation requires the storage/setsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to update a SAS definition.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_574874 = newJObject()
  var query_574875 = newJObject()
  var body_574876 = newJObject()
  add(query_574875, "api-version", newJString(apiVersion))
  add(path_574874, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_574876 = parameters
  add(path_574874, "sas-definition-name", newJString(sasDefinitionName))
  result = call_574873.call(path_574874, query_574875, nil, nil, body_574876)

var updateSasDefinition* = Call_UpdateSasDefinition_574865(
    name: "updateSasDefinition", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_UpdateSasDefinition_574866, base: "",
    url: url_UpdateSasDefinition_574867, schemes: {Scheme.Https})
type
  Call_DeleteSasDefinition_574855 = ref object of OpenApiRestCall_573666
proc url_DeleteSasDefinition_574857(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  assert "sas-definition-name" in path,
        "`sas-definition-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/storage/"),
               (kind: VariableSegment, value: "storage-account-name"),
               (kind: ConstantSegment, value: "/sas/"),
               (kind: VariableSegment, value: "sas-definition-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteSasDefinition_574856(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a SAS definition from a specified storage account. This operation requires the storage/deletesas permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  ##   sas-definition-name: JString (required)
  ##                      : The name of the SAS definition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_574858 = path.getOrDefault("storage-account-name")
  valid_574858 = validateParameter(valid_574858, JString, required = true,
                                 default = nil)
  if valid_574858 != nil:
    section.add "storage-account-name", valid_574858
  var valid_574859 = path.getOrDefault("sas-definition-name")
  valid_574859 = validateParameter(valid_574859, JString, required = true,
                                 default = nil)
  if valid_574859 != nil:
    section.add "sas-definition-name", valid_574859
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574860 = query.getOrDefault("api-version")
  valid_574860 = validateParameter(valid_574860, JString, required = true,
                                 default = nil)
  if valid_574860 != nil:
    section.add "api-version", valid_574860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574861: Call_DeleteSasDefinition_574855; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SAS definition from a specified storage account. This operation requires the storage/deletesas permission.
  ## 
  let valid = call_574861.validator(path, query, header, formData, body)
  let scheme = call_574861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574861.url(scheme.get, call_574861.host, call_574861.base,
                         call_574861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574861, url, valid)

proc call*(call_574862: Call_DeleteSasDefinition_574855; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## deleteSasDefinition
  ## Deletes a SAS definition from a specified storage account. This operation requires the storage/deletesas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_574863 = newJObject()
  var query_574864 = newJObject()
  add(query_574864, "api-version", newJString(apiVersion))
  add(path_574863, "storage-account-name", newJString(storageAccountName))
  add(path_574863, "sas-definition-name", newJString(sasDefinitionName))
  result = call_574862.call(path_574863, query_574864, nil, nil, nil)

var deleteSasDefinition* = Call_DeleteSasDefinition_574855(
    name: "deleteSasDefinition", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_DeleteSasDefinition_574856, base: "",
    url: url_DeleteSasDefinition_574857, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
