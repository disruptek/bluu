
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: KeyVaultClient
## version: 7.0
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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  Call_GetCertificates_567889 = ref object of OpenApiRestCall_567667
proc url_GetCertificates_567891(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificates_567890(path: JsonNode; query: JsonNode;
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
  ##   includePending: JBool
  ##                 : Specifies whether to include certificates which are not completely provisioned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568050 = query.getOrDefault("api-version")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "api-version", valid_568050
  var valid_568051 = query.getOrDefault("maxresults")
  valid_568051 = validateParameter(valid_568051, JInt, required = false, default = nil)
  if valid_568051 != nil:
    section.add "maxresults", valid_568051
  var valid_568052 = query.getOrDefault("includePending")
  valid_568052 = validateParameter(valid_568052, JBool, required = false, default = nil)
  if valid_568052 != nil:
    section.add "includePending", valid_568052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568075: Call_GetCertificates_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificates operation returns the set of certificates resources in the specified key vault. This operation requires the certificates/list permission.
  ## 
  let valid = call_568075.validator(path, query, header, formData, body)
  let scheme = call_568075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568075.url(scheme.get, call_568075.host, call_568075.base,
                         call_568075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568075, url, valid)

proc call*(call_568146: Call_GetCertificates_567889; apiVersion: string;
          maxresults: int = 0; includePending: bool = false): Recallable =
  ## getCertificates
  ## The GetCertificates operation returns the set of certificates resources in the specified key vault. This operation requires the certificates/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   includePending: bool
  ##                 : Specifies whether to include certificates which are not completely provisioned.
  var query_568147 = newJObject()
  add(query_568147, "api-version", newJString(apiVersion))
  add(query_568147, "maxresults", newJInt(maxresults))
  add(query_568147, "includePending", newJBool(includePending))
  result = call_568146.call(nil, query_568147, nil, nil, nil)

var getCertificates* = Call_GetCertificates_567889(name: "getCertificates",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates",
    validator: validate_GetCertificates_567890, base: "", url: url_GetCertificates_567891,
    schemes: {Scheme.Https})
type
  Call_SetCertificateContacts_568194 = ref object of OpenApiRestCall_567667
proc url_SetCertificateContacts_568196(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SetCertificateContacts_568195(path: JsonNode; query: JsonNode;
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
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
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

proc call*(call_568216: Call_SetCertificateContacts_568194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the certificate contacts for the specified key vault. This operation requires the certificates/managecontacts permission.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_SetCertificateContacts_568194; apiVersion: string;
          contacts: JsonNode): Recallable =
  ## setCertificateContacts
  ## Sets the certificate contacts for the specified key vault. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   contacts: JObject (required)
  ##           : The contacts for the key vault certificate.
  var query_568218 = newJObject()
  var body_568219 = newJObject()
  add(query_568218, "api-version", newJString(apiVersion))
  if contacts != nil:
    body_568219 = contacts
  result = call_568217.call(nil, query_568218, nil, nil, body_568219)

var setCertificateContacts* = Call_SetCertificateContacts_568194(
    name: "setCertificateContacts", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/certificates/contacts", validator: validate_SetCertificateContacts_568195,
    base: "", url: url_SetCertificateContacts_568196, schemes: {Scheme.Https})
type
  Call_GetCertificateContacts_568187 = ref object of OpenApiRestCall_567667
proc url_GetCertificateContacts_568189(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificateContacts_568188(path: JsonNode; query: JsonNode;
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
  var valid_568190 = query.getOrDefault("api-version")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "api-version", valid_568190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568191: Call_GetCertificateContacts_568187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificateContacts operation returns the set of certificate contact resources in the specified key vault. This operation requires the certificates/managecontacts permission.
  ## 
  let valid = call_568191.validator(path, query, header, formData, body)
  let scheme = call_568191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568191.url(scheme.get, call_568191.host, call_568191.base,
                         call_568191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568191, url, valid)

proc call*(call_568192: Call_GetCertificateContacts_568187; apiVersion: string): Recallable =
  ## getCertificateContacts
  ## The GetCertificateContacts operation returns the set of certificate contact resources in the specified key vault. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_568193 = newJObject()
  add(query_568193, "api-version", newJString(apiVersion))
  result = call_568192.call(nil, query_568193, nil, nil, nil)

var getCertificateContacts* = Call_GetCertificateContacts_568187(
    name: "getCertificateContacts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/contacts", validator: validate_GetCertificateContacts_568188,
    base: "", url: url_GetCertificateContacts_568189, schemes: {Scheme.Https})
type
  Call_DeleteCertificateContacts_568220 = ref object of OpenApiRestCall_567667
proc url_DeleteCertificateContacts_568222(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeleteCertificateContacts_568221(path: JsonNode; query: JsonNode;
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
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_DeleteCertificateContacts_568220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the certificate contacts for a specified key vault certificate. This operation requires the certificates/managecontacts permission.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_DeleteCertificateContacts_568220; apiVersion: string): Recallable =
  ## deleteCertificateContacts
  ## Deletes the certificate contacts for a specified key vault certificate. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_568226 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  result = call_568225.call(nil, query_568226, nil, nil, nil)

var deleteCertificateContacts* = Call_DeleteCertificateContacts_568220(
    name: "deleteCertificateContacts", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/contacts",
    validator: validate_DeleteCertificateContacts_568221, base: "",
    url: url_DeleteCertificateContacts_568222, schemes: {Scheme.Https})
type
  Call_GetCertificateIssuers_568227 = ref object of OpenApiRestCall_567667
proc url_GetCertificateIssuers_568229(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificateIssuers_568228(path: JsonNode; query: JsonNode;
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
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
  var valid_568231 = query.getOrDefault("maxresults")
  valid_568231 = validateParameter(valid_568231, JInt, required = false, default = nil)
  if valid_568231 != nil:
    section.add "maxresults", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_GetCertificateIssuers_568227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificateIssuers operation returns the set of certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_GetCertificateIssuers_568227; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getCertificateIssuers
  ## The GetCertificateIssuers operation returns the set of certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_568234 = newJObject()
  add(query_568234, "api-version", newJString(apiVersion))
  add(query_568234, "maxresults", newJInt(maxresults))
  result = call_568233.call(nil, query_568234, nil, nil, nil)

var getCertificateIssuers* = Call_GetCertificateIssuers_568227(
    name: "getCertificateIssuers", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/issuers", validator: validate_GetCertificateIssuers_568228,
    base: "", url: url_GetCertificateIssuers_568229, schemes: {Scheme.Https})
type
  Call_SetCertificateIssuer_568258 = ref object of OpenApiRestCall_567667
proc url_SetCertificateIssuer_568260(protocol: Scheme; host: string; base: string;
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

proc validate_SetCertificateIssuer_568259(path: JsonNode; query: JsonNode;
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
  var valid_568261 = path.getOrDefault("issuer-name")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "issuer-name", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "api-version", valid_568262
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

proc call*(call_568264: Call_SetCertificateIssuer_568258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The SetCertificateIssuer operation adds or updates the specified certificate issuer. This operation requires the certificates/setissuers permission.
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_SetCertificateIssuer_568258; apiVersion: string;
          parameter: JsonNode; issuerName: string): Recallable =
  ## setCertificateIssuer
  ## The SetCertificateIssuer operation adds or updates the specified certificate issuer. This operation requires the certificates/setissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameter: JObject (required)
  ##            : Certificate issuer set parameter.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  var body_568268 = newJObject()
  add(query_568267, "api-version", newJString(apiVersion))
  if parameter != nil:
    body_568268 = parameter
  add(path_568266, "issuer-name", newJString(issuerName))
  result = call_568265.call(path_568266, query_568267, nil, nil, body_568268)

var setCertificateIssuer* = Call_SetCertificateIssuer_568258(
    name: "setCertificateIssuer", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/certificates/issuers/{issuer-name}",
    validator: validate_SetCertificateIssuer_568259, base: "",
    url: url_SetCertificateIssuer_568260, schemes: {Scheme.Https})
type
  Call_GetCertificateIssuer_568235 = ref object of OpenApiRestCall_567667
proc url_GetCertificateIssuer_568237(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificateIssuer_568236(path: JsonNode; query: JsonNode;
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
  var valid_568252 = path.getOrDefault("issuer-name")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "issuer-name", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "api-version", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_GetCertificateIssuer_568235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificateIssuer operation returns the specified certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_GetCertificateIssuer_568235; apiVersion: string;
          issuerName: string): Recallable =
  ## getCertificateIssuer
  ## The GetCertificateIssuer operation returns the specified certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "issuer-name", newJString(issuerName))
  result = call_568255.call(path_568256, query_568257, nil, nil, nil)

var getCertificateIssuer* = Call_GetCertificateIssuer_568235(
    name: "getCertificateIssuer", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/issuers/{issuer-name}",
    validator: validate_GetCertificateIssuer_568236, base: "",
    url: url_GetCertificateIssuer_568237, schemes: {Scheme.Https})
type
  Call_UpdateCertificateIssuer_568278 = ref object of OpenApiRestCall_567667
proc url_UpdateCertificateIssuer_568280(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCertificateIssuer_568279(path: JsonNode; query: JsonNode;
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
  var valid_568281 = path.getOrDefault("issuer-name")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "issuer-name", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
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

proc call*(call_568284: Call_UpdateCertificateIssuer_568278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UpdateCertificateIssuer operation performs an update on the specified certificate issuer entity. This operation requires the certificates/setissuers permission.
  ## 
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_UpdateCertificateIssuer_568278; apiVersion: string;
          parameter: JsonNode; issuerName: string): Recallable =
  ## updateCertificateIssuer
  ## The UpdateCertificateIssuer operation performs an update on the specified certificate issuer entity. This operation requires the certificates/setissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameter: JObject (required)
  ##            : Certificate issuer update parameter.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_568286 = newJObject()
  var query_568287 = newJObject()
  var body_568288 = newJObject()
  add(query_568287, "api-version", newJString(apiVersion))
  if parameter != nil:
    body_568288 = parameter
  add(path_568286, "issuer-name", newJString(issuerName))
  result = call_568285.call(path_568286, query_568287, nil, nil, body_568288)

var updateCertificateIssuer* = Call_UpdateCertificateIssuer_568278(
    name: "updateCertificateIssuer", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/issuers/{issuer-name}",
    validator: validate_UpdateCertificateIssuer_568279, base: "",
    url: url_UpdateCertificateIssuer_568280, schemes: {Scheme.Https})
type
  Call_DeleteCertificateIssuer_568269 = ref object of OpenApiRestCall_567667
proc url_DeleteCertificateIssuer_568271(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteCertificateIssuer_568270(path: JsonNode; query: JsonNode;
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
  var valid_568272 = path.getOrDefault("issuer-name")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "issuer-name", valid_568272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568273 = query.getOrDefault("api-version")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "api-version", valid_568273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_DeleteCertificateIssuer_568269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DeleteCertificateIssuer operation permanently removes the specified certificate issuer from the vault. This operation requires the certificates/manageissuers/deleteissuers permission.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_DeleteCertificateIssuer_568269; apiVersion: string;
          issuerName: string): Recallable =
  ## deleteCertificateIssuer
  ## The DeleteCertificateIssuer operation permanently removes the specified certificate issuer from the vault. This operation requires the certificates/manageissuers/deleteissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "issuer-name", newJString(issuerName))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var deleteCertificateIssuer* = Call_DeleteCertificateIssuer_568269(
    name: "deleteCertificateIssuer", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/issuers/{issuer-name}",
    validator: validate_DeleteCertificateIssuer_568270, base: "",
    url: url_DeleteCertificateIssuer_568271, schemes: {Scheme.Https})
type
  Call_RestoreCertificate_568289 = ref object of OpenApiRestCall_567667
proc url_RestoreCertificate_568291(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreCertificate_568290(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Restores a backed up certificate, and all its versions, to a vault. This operation requires the certificates/restore permission.
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
  var valid_568292 = query.getOrDefault("api-version")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "api-version", valid_568292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to restore the certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_RestoreCertificate_568289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backed up certificate, and all its versions, to a vault. This operation requires the certificates/restore permission.
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_RestoreCertificate_568289; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreCertificate
  ## Restores a backed up certificate, and all its versions, to a vault. This operation requires the certificates/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the certificate.
  var query_568296 = newJObject()
  var body_568297 = newJObject()
  add(query_568296, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568297 = parameters
  result = call_568295.call(nil, query_568296, nil, nil, body_568297)

var restoreCertificate* = Call_RestoreCertificate_568289(
    name: "restoreCertificate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/restore", validator: validate_RestoreCertificate_568290,
    base: "", url: url_RestoreCertificate_568291, schemes: {Scheme.Https})
type
  Call_DeleteCertificate_568298 = ref object of OpenApiRestCall_567667
proc url_DeleteCertificate_568300(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteCertificate_568299(path: JsonNode; query: JsonNode;
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
  var valid_568301 = path.getOrDefault("certificate-name")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "certificate-name", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568302 = query.getOrDefault("api-version")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "api-version", valid_568302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568303: Call_DeleteCertificate_568298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all versions of a certificate object along with its associated policy. Delete certificate cannot be used to remove individual versions of a certificate object. This operation requires the certificates/delete permission.
  ## 
  let valid = call_568303.validator(path, query, header, formData, body)
  let scheme = call_568303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568303.url(scheme.get, call_568303.host, call_568303.base,
                         call_568303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568303, url, valid)

proc call*(call_568304: Call_DeleteCertificate_568298; apiVersion: string;
          certificateName: string): Recallable =
  ## deleteCertificate
  ## Deletes all versions of a certificate object along with its associated policy. Delete certificate cannot be used to remove individual versions of a certificate object. This operation requires the certificates/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_568305 = newJObject()
  var query_568306 = newJObject()
  add(query_568306, "api-version", newJString(apiVersion))
  add(path_568305, "certificate-name", newJString(certificateName))
  result = call_568304.call(path_568305, query_568306, nil, nil, nil)

var deleteCertificate* = Call_DeleteCertificate_568298(name: "deleteCertificate",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/certificates/{certificate-name}",
    validator: validate_DeleteCertificate_568299, base: "",
    url: url_DeleteCertificate_568300, schemes: {Scheme.Https})
type
  Call_BackupCertificate_568307 = ref object of OpenApiRestCall_567667
proc url_BackupCertificate_568309(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupCertificate_568308(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Requests that a backup of the specified certificate be downloaded to the client. All versions of the certificate will be downloaded. This operation requires the certificates/backup permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificate-name` field"
  var valid_568310 = path.getOrDefault("certificate-name")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "certificate-name", valid_568310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568311 = query.getOrDefault("api-version")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "api-version", valid_568311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568312: Call_BackupCertificate_568307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified certificate be downloaded to the client. All versions of the certificate will be downloaded. This operation requires the certificates/backup permission.
  ## 
  let valid = call_568312.validator(path, query, header, formData, body)
  let scheme = call_568312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568312.url(scheme.get, call_568312.host, call_568312.base,
                         call_568312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568312, url, valid)

proc call*(call_568313: Call_BackupCertificate_568307; apiVersion: string;
          certificateName: string): Recallable =
  ## backupCertificate
  ## Requests that a backup of the specified certificate be downloaded to the client. All versions of the certificate will be downloaded. This operation requires the certificates/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_568314 = newJObject()
  var query_568315 = newJObject()
  add(query_568315, "api-version", newJString(apiVersion))
  add(path_568314, "certificate-name", newJString(certificateName))
  result = call_568313.call(path_568314, query_568315, nil, nil, nil)

var backupCertificate* = Call_BackupCertificate_568307(name: "backupCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/backup",
    validator: validate_BackupCertificate_568308, base: "",
    url: url_BackupCertificate_568309, schemes: {Scheme.Https})
type
  Call_CreateCertificate_568316 = ref object of OpenApiRestCall_567667
proc url_CreateCertificate_568318(protocol: Scheme; host: string; base: string;
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

proc validate_CreateCertificate_568317(path: JsonNode; query: JsonNode;
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
  var valid_568319 = path.getOrDefault("certificate-name")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "certificate-name", valid_568319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568320 = query.getOrDefault("api-version")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "api-version", valid_568320
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

proc call*(call_568322: Call_CreateCertificate_568316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If this is the first version, the certificate resource is created. This operation requires the certificates/create permission.
  ## 
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_CreateCertificate_568316; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## createCertificate
  ## If this is the first version, the certificate resource is created. This operation requires the certificates/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to create a certificate.
  var path_568324 = newJObject()
  var query_568325 = newJObject()
  var body_568326 = newJObject()
  add(query_568325, "api-version", newJString(apiVersion))
  add(path_568324, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_568326 = parameters
  result = call_568323.call(path_568324, query_568325, nil, nil, body_568326)

var createCertificate* = Call_CreateCertificate_568316(name: "createCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/create",
    validator: validate_CreateCertificate_568317, base: "",
    url: url_CreateCertificate_568318, schemes: {Scheme.Https})
type
  Call_ImportCertificate_568327 = ref object of OpenApiRestCall_567667
proc url_ImportCertificate_568329(protocol: Scheme; host: string; base: string;
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

proc validate_ImportCertificate_568328(path: JsonNode; query: JsonNode;
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
  var valid_568330 = path.getOrDefault("certificate-name")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "certificate-name", valid_568330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568331 = query.getOrDefault("api-version")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "api-version", valid_568331
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

proc call*(call_568333: Call_ImportCertificate_568327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an existing valid certificate, containing a private key, into Azure Key Vault. The certificate to be imported can be in either PFX or PEM format. If the certificate is in PEM format the PEM file must contain the key as well as x509 certificates. This operation requires the certificates/import permission.
  ## 
  let valid = call_568333.validator(path, query, header, formData, body)
  let scheme = call_568333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568333.url(scheme.get, call_568333.host, call_568333.base,
                         call_568333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568333, url, valid)

proc call*(call_568334: Call_ImportCertificate_568327; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## importCertificate
  ## Imports an existing valid certificate, containing a private key, into Azure Key Vault. The certificate to be imported can be in either PFX or PEM format. If the certificate is in PEM format the PEM file must contain the key as well as x509 certificates. This operation requires the certificates/import permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to import the certificate.
  var path_568335 = newJObject()
  var query_568336 = newJObject()
  var body_568337 = newJObject()
  add(query_568336, "api-version", newJString(apiVersion))
  add(path_568335, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_568337 = parameters
  result = call_568334.call(path_568335, query_568336, nil, nil, body_568337)

var importCertificate* = Call_ImportCertificate_568327(name: "importCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/import",
    validator: validate_ImportCertificate_568328, base: "",
    url: url_ImportCertificate_568329, schemes: {Scheme.Https})
type
  Call_GetCertificateOperation_568338 = ref object of OpenApiRestCall_567667
proc url_GetCertificateOperation_568340(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificateOperation_568339(path: JsonNode; query: JsonNode;
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
  var valid_568341 = path.getOrDefault("certificate-name")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "certificate-name", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568343: Call_GetCertificateOperation_568338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the creation operation associated with a specified certificate. This operation requires the certificates/get permission.
  ## 
  let valid = call_568343.validator(path, query, header, formData, body)
  let scheme = call_568343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568343.url(scheme.get, call_568343.host, call_568343.base,
                         call_568343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568343, url, valid)

proc call*(call_568344: Call_GetCertificateOperation_568338; apiVersion: string;
          certificateName: string): Recallable =
  ## getCertificateOperation
  ## Gets the creation operation associated with a specified certificate. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_568345 = newJObject()
  var query_568346 = newJObject()
  add(query_568346, "api-version", newJString(apiVersion))
  add(path_568345, "certificate-name", newJString(certificateName))
  result = call_568344.call(path_568345, query_568346, nil, nil, nil)

var getCertificateOperation* = Call_GetCertificateOperation_568338(
    name: "getCertificateOperation", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/pending",
    validator: validate_GetCertificateOperation_568339, base: "",
    url: url_GetCertificateOperation_568340, schemes: {Scheme.Https})
type
  Call_UpdateCertificateOperation_568356 = ref object of OpenApiRestCall_567667
proc url_UpdateCertificateOperation_568358(protocol: Scheme; host: string;
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

proc validate_UpdateCertificateOperation_568357(path: JsonNode; query: JsonNode;
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
  var valid_568359 = path.getOrDefault("certificate-name")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "certificate-name", valid_568359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568360 = query.getOrDefault("api-version")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "api-version", valid_568360
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

proc call*(call_568362: Call_UpdateCertificateOperation_568356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a certificate creation operation that is already in progress. This operation requires the certificates/update permission.
  ## 
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_UpdateCertificateOperation_568356; apiVersion: string;
          certificateName: string; certificateOperation: JsonNode): Recallable =
  ## updateCertificateOperation
  ## Updates a certificate creation operation that is already in progress. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   certificateOperation: JObject (required)
  ##                       : The certificate operation response.
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  var body_568366 = newJObject()
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "certificate-name", newJString(certificateName))
  if certificateOperation != nil:
    body_568366 = certificateOperation
  result = call_568363.call(path_568364, query_568365, nil, nil, body_568366)

var updateCertificateOperation* = Call_UpdateCertificateOperation_568356(
    name: "updateCertificateOperation", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/{certificate-name}/pending",
    validator: validate_UpdateCertificateOperation_568357, base: "",
    url: url_UpdateCertificateOperation_568358, schemes: {Scheme.Https})
type
  Call_DeleteCertificateOperation_568347 = ref object of OpenApiRestCall_567667
proc url_DeleteCertificateOperation_568349(protocol: Scheme; host: string;
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

proc validate_DeleteCertificateOperation_568348(path: JsonNode; query: JsonNode;
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
  var valid_568350 = path.getOrDefault("certificate-name")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "certificate-name", valid_568350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568351 = query.getOrDefault("api-version")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "api-version", valid_568351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568352: Call_DeleteCertificateOperation_568347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the creation operation for a specified certificate that is in the process of being created. The certificate is no longer created. This operation requires the certificates/update permission.
  ## 
  let valid = call_568352.validator(path, query, header, formData, body)
  let scheme = call_568352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568352.url(scheme.get, call_568352.host, call_568352.base,
                         call_568352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568352, url, valid)

proc call*(call_568353: Call_DeleteCertificateOperation_568347; apiVersion: string;
          certificateName: string): Recallable =
  ## deleteCertificateOperation
  ## Deletes the creation operation for a specified certificate that is in the process of being created. The certificate is no longer created. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_568354 = newJObject()
  var query_568355 = newJObject()
  add(query_568355, "api-version", newJString(apiVersion))
  add(path_568354, "certificate-name", newJString(certificateName))
  result = call_568353.call(path_568354, query_568355, nil, nil, nil)

var deleteCertificateOperation* = Call_DeleteCertificateOperation_568347(
    name: "deleteCertificateOperation", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/{certificate-name}/pending",
    validator: validate_DeleteCertificateOperation_568348, base: "",
    url: url_DeleteCertificateOperation_568349, schemes: {Scheme.Https})
type
  Call_MergeCertificate_568367 = ref object of OpenApiRestCall_567667
proc url_MergeCertificate_568369(protocol: Scheme; host: string; base: string;
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

proc validate_MergeCertificate_568368(path: JsonNode; query: JsonNode;
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
  var valid_568370 = path.getOrDefault("certificate-name")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "certificate-name", valid_568370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568371 = query.getOrDefault("api-version")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "api-version", valid_568371
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

proc call*(call_568373: Call_MergeCertificate_568367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The MergeCertificate operation performs the merging of a certificate or certificate chain with a key pair currently available in the service. This operation requires the certificates/create permission.
  ## 
  let valid = call_568373.validator(path, query, header, formData, body)
  let scheme = call_568373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568373.url(scheme.get, call_568373.host, call_568373.base,
                         call_568373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568373, url, valid)

proc call*(call_568374: Call_MergeCertificate_568367; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## mergeCertificate
  ## The MergeCertificate operation performs the merging of a certificate or certificate chain with a key pair currently available in the service. This operation requires the certificates/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to merge certificate.
  var path_568375 = newJObject()
  var query_568376 = newJObject()
  var body_568377 = newJObject()
  add(query_568376, "api-version", newJString(apiVersion))
  add(path_568375, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_568377 = parameters
  result = call_568374.call(path_568375, query_568376, nil, nil, body_568377)

var mergeCertificate* = Call_MergeCertificate_568367(name: "mergeCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/pending/merge",
    validator: validate_MergeCertificate_568368, base: "",
    url: url_MergeCertificate_568369, schemes: {Scheme.Https})
type
  Call_GetCertificatePolicy_568378 = ref object of OpenApiRestCall_567667
proc url_GetCertificatePolicy_568380(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificatePolicy_568379(path: JsonNode; query: JsonNode;
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
  var valid_568381 = path.getOrDefault("certificate-name")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "certificate-name", valid_568381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568382 = query.getOrDefault("api-version")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "api-version", valid_568382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568383: Call_GetCertificatePolicy_568378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificatePolicy operation returns the specified certificate policy resources in the specified key vault. This operation requires the certificates/get permission.
  ## 
  let valid = call_568383.validator(path, query, header, formData, body)
  let scheme = call_568383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568383.url(scheme.get, call_568383.host, call_568383.base,
                         call_568383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568383, url, valid)

proc call*(call_568384: Call_GetCertificatePolicy_568378; apiVersion: string;
          certificateName: string): Recallable =
  ## getCertificatePolicy
  ## The GetCertificatePolicy operation returns the specified certificate policy resources in the specified key vault. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in a given key vault.
  var path_568385 = newJObject()
  var query_568386 = newJObject()
  add(query_568386, "api-version", newJString(apiVersion))
  add(path_568385, "certificate-name", newJString(certificateName))
  result = call_568384.call(path_568385, query_568386, nil, nil, nil)

var getCertificatePolicy* = Call_GetCertificatePolicy_568378(
    name: "getCertificatePolicy", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/policy",
    validator: validate_GetCertificatePolicy_568379, base: "",
    url: url_GetCertificatePolicy_568380, schemes: {Scheme.Https})
type
  Call_UpdateCertificatePolicy_568387 = ref object of OpenApiRestCall_567667
proc url_UpdateCertificatePolicy_568389(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCertificatePolicy_568388(path: JsonNode; query: JsonNode;
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
  var valid_568390 = path.getOrDefault("certificate-name")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "certificate-name", valid_568390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568391 = query.getOrDefault("api-version")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "api-version", valid_568391
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

proc call*(call_568393: Call_UpdateCertificatePolicy_568387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set specified members in the certificate policy. Leave others as null. This operation requires the certificates/update permission.
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_UpdateCertificatePolicy_568387; apiVersion: string;
          certificateName: string; certificatePolicy: JsonNode): Recallable =
  ## updateCertificatePolicy
  ## Set specified members in the certificate policy. Leave others as null. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault.
  ##   certificatePolicy: JObject (required)
  ##                    : The policy for the certificate.
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  var body_568397 = newJObject()
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "certificate-name", newJString(certificateName))
  if certificatePolicy != nil:
    body_568397 = certificatePolicy
  result = call_568394.call(path_568395, query_568396, nil, nil, body_568397)

var updateCertificatePolicy* = Call_UpdateCertificatePolicy_568387(
    name: "updateCertificatePolicy", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/{certificate-name}/policy",
    validator: validate_UpdateCertificatePolicy_568388, base: "",
    url: url_UpdateCertificatePolicy_568389, schemes: {Scheme.Https})
type
  Call_GetCertificateVersions_568398 = ref object of OpenApiRestCall_567667
proc url_GetCertificateVersions_568400(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificateVersions_568399(path: JsonNode; query: JsonNode;
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
  var valid_568401 = path.getOrDefault("certificate-name")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "certificate-name", valid_568401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568402 = query.getOrDefault("api-version")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "api-version", valid_568402
  var valid_568403 = query.getOrDefault("maxresults")
  valid_568403 = validateParameter(valid_568403, JInt, required = false, default = nil)
  if valid_568403 != nil:
    section.add "maxresults", valid_568403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568404: Call_GetCertificateVersions_568398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificateVersions operation returns the versions of a certificate in the specified key vault. This operation requires the certificates/list permission.
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_GetCertificateVersions_568398; apiVersion: string;
          certificateName: string; maxresults: int = 0): Recallable =
  ## getCertificateVersions
  ## The GetCertificateVersions operation returns the versions of a certificate in the specified key vault. This operation requires the certificates/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  add(query_568407, "api-version", newJString(apiVersion))
  add(path_568406, "certificate-name", newJString(certificateName))
  add(query_568407, "maxresults", newJInt(maxresults))
  result = call_568405.call(path_568406, query_568407, nil, nil, nil)

var getCertificateVersions* = Call_GetCertificateVersions_568398(
    name: "getCertificateVersions", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/versions",
    validator: validate_GetCertificateVersions_568399, base: "",
    url: url_GetCertificateVersions_568400, schemes: {Scheme.Https})
type
  Call_GetCertificate_568408 = ref object of OpenApiRestCall_567667
proc url_GetCertificate_568410(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificate_568409(path: JsonNode; query: JsonNode;
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
  var valid_568411 = path.getOrDefault("certificate-name")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "certificate-name", valid_568411
  var valid_568412 = path.getOrDefault("certificate-version")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "certificate-version", valid_568412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568413 = query.getOrDefault("api-version")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "api-version", valid_568413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568414: Call_GetCertificate_568408; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific certificate. This operation requires the certificates/get permission.
  ## 
  let valid = call_568414.validator(path, query, header, formData, body)
  let scheme = call_568414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568414.url(scheme.get, call_568414.host, call_568414.base,
                         call_568414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568414, url, valid)

proc call*(call_568415: Call_GetCertificate_568408; apiVersion: string;
          certificateName: string; certificateVersion: string): Recallable =
  ## getCertificate
  ## Gets information about a specific certificate. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault.
  ##   certificateVersion: string (required)
  ##                     : The version of the certificate.
  var path_568416 = newJObject()
  var query_568417 = newJObject()
  add(query_568417, "api-version", newJString(apiVersion))
  add(path_568416, "certificate-name", newJString(certificateName))
  add(path_568416, "certificate-version", newJString(certificateVersion))
  result = call_568415.call(path_568416, query_568417, nil, nil, nil)

var getCertificate* = Call_GetCertificate_568408(name: "getCertificate",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/{certificate-version}",
    validator: validate_GetCertificate_568409, base: "", url: url_GetCertificate_568410,
    schemes: {Scheme.Https})
type
  Call_UpdateCertificate_568418 = ref object of OpenApiRestCall_567667
proc url_UpdateCertificate_568420(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCertificate_568419(path: JsonNode; query: JsonNode;
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
  var valid_568421 = path.getOrDefault("certificate-name")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "certificate-name", valid_568421
  var valid_568422 = path.getOrDefault("certificate-version")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "certificate-version", valid_568422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568423 = query.getOrDefault("api-version")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "api-version", valid_568423
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

proc call*(call_568425: Call_UpdateCertificate_568418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UpdateCertificate operation applies the specified update on the given certificate; the only elements updated are the certificate's attributes. This operation requires the certificates/update permission.
  ## 
  let valid = call_568425.validator(path, query, header, formData, body)
  let scheme = call_568425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568425.url(scheme.get, call_568425.host, call_568425.base,
                         call_568425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568425, url, valid)

proc call*(call_568426: Call_UpdateCertificate_568418; apiVersion: string;
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
  var path_568427 = newJObject()
  var query_568428 = newJObject()
  var body_568429 = newJObject()
  add(query_568428, "api-version", newJString(apiVersion))
  add(path_568427, "certificate-name", newJString(certificateName))
  add(path_568427, "certificate-version", newJString(certificateVersion))
  if parameters != nil:
    body_568429 = parameters
  result = call_568426.call(path_568427, query_568428, nil, nil, body_568429)

var updateCertificate* = Call_UpdateCertificate_568418(name: "updateCertificate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/certificates/{certificate-name}/{certificate-version}",
    validator: validate_UpdateCertificate_568419, base: "",
    url: url_UpdateCertificate_568420, schemes: {Scheme.Https})
type
  Call_GetDeletedCertificates_568430 = ref object of OpenApiRestCall_567667
proc url_GetDeletedCertificates_568432(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedCertificates_568431(path: JsonNode; query: JsonNode;
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
  ##   includePending: JBool
  ##                 : Specifies whether to include certificates which are not completely provisioned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568433 = query.getOrDefault("api-version")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "api-version", valid_568433
  var valid_568434 = query.getOrDefault("maxresults")
  valid_568434 = validateParameter(valid_568434, JInt, required = false, default = nil)
  if valid_568434 != nil:
    section.add "maxresults", valid_568434
  var valid_568435 = query.getOrDefault("includePending")
  valid_568435 = validateParameter(valid_568435, JBool, required = false, default = nil)
  if valid_568435 != nil:
    section.add "includePending", valid_568435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568436: Call_GetDeletedCertificates_568430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetDeletedCertificates operation retrieves the certificates in the current vault which are in a deleted state and ready for recovery or purging. This operation includes deletion-specific information. This operation requires the certificates/get/list permission. This operation can only be enabled on soft-delete enabled vaults.
  ## 
  let valid = call_568436.validator(path, query, header, formData, body)
  let scheme = call_568436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568436.url(scheme.get, call_568436.host, call_568436.base,
                         call_568436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568436, url, valid)

proc call*(call_568437: Call_GetDeletedCertificates_568430; apiVersion: string;
          maxresults: int = 0; includePending: bool = false): Recallable =
  ## getDeletedCertificates
  ## The GetDeletedCertificates operation retrieves the certificates in the current vault which are in a deleted state and ready for recovery or purging. This operation includes deletion-specific information. This operation requires the certificates/get/list permission. This operation can only be enabled on soft-delete enabled vaults.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   includePending: bool
  ##                 : Specifies whether to include certificates which are not completely provisioned.
  var query_568438 = newJObject()
  add(query_568438, "api-version", newJString(apiVersion))
  add(query_568438, "maxresults", newJInt(maxresults))
  add(query_568438, "includePending", newJBool(includePending))
  result = call_568437.call(nil, query_568438, nil, nil, nil)

var getDeletedCertificates* = Call_GetDeletedCertificates_568430(
    name: "getDeletedCertificates", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedcertificates", validator: validate_GetDeletedCertificates_568431,
    base: "", url: url_GetDeletedCertificates_568432, schemes: {Scheme.Https})
type
  Call_GetDeletedCertificate_568439 = ref object of OpenApiRestCall_567667
proc url_GetDeletedCertificate_568441(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedCertificate_568440(path: JsonNode; query: JsonNode;
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
  var valid_568442 = path.getOrDefault("certificate-name")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "certificate-name", valid_568442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568443 = query.getOrDefault("api-version")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "api-version", valid_568443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568444: Call_GetDeletedCertificate_568439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetDeletedCertificate operation retrieves the deleted certificate information plus its attributes, such as retention interval, scheduled permanent deletion and the current deletion recovery level. This operation requires the certificates/get permission.
  ## 
  let valid = call_568444.validator(path, query, header, formData, body)
  let scheme = call_568444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568444.url(scheme.get, call_568444.host, call_568444.base,
                         call_568444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568444, url, valid)

proc call*(call_568445: Call_GetDeletedCertificate_568439; apiVersion: string;
          certificateName: string): Recallable =
  ## getDeletedCertificate
  ## The GetDeletedCertificate operation retrieves the deleted certificate information plus its attributes, such as retention interval, scheduled permanent deletion and the current deletion recovery level. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_568446 = newJObject()
  var query_568447 = newJObject()
  add(query_568447, "api-version", newJString(apiVersion))
  add(path_568446, "certificate-name", newJString(certificateName))
  result = call_568445.call(path_568446, query_568447, nil, nil, nil)

var getDeletedCertificate* = Call_GetDeletedCertificate_568439(
    name: "getDeletedCertificate", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedcertificates/{certificate-name}",
    validator: validate_GetDeletedCertificate_568440, base: "",
    url: url_GetDeletedCertificate_568441, schemes: {Scheme.Https})
type
  Call_PurgeDeletedCertificate_568448 = ref object of OpenApiRestCall_567667
proc url_PurgeDeletedCertificate_568450(protocol: Scheme; host: string; base: string;
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

proc validate_PurgeDeletedCertificate_568449(path: JsonNode; query: JsonNode;
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
  var valid_568451 = path.getOrDefault("certificate-name")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "certificate-name", valid_568451
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568452 = query.getOrDefault("api-version")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "api-version", valid_568452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568453: Call_PurgeDeletedCertificate_568448; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The PurgeDeletedCertificate operation performs an irreversible deletion of the specified certificate, without possibility for recovery. The operation is not available if the recovery level does not specify 'Purgeable'. This operation requires the certificate/purge permission.
  ## 
  let valid = call_568453.validator(path, query, header, formData, body)
  let scheme = call_568453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568453.url(scheme.get, call_568453.host, call_568453.base,
                         call_568453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568453, url, valid)

proc call*(call_568454: Call_PurgeDeletedCertificate_568448; apiVersion: string;
          certificateName: string): Recallable =
  ## purgeDeletedCertificate
  ## The PurgeDeletedCertificate operation performs an irreversible deletion of the specified certificate, without possibility for recovery. The operation is not available if the recovery level does not specify 'Purgeable'. This operation requires the certificate/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_568455 = newJObject()
  var query_568456 = newJObject()
  add(query_568456, "api-version", newJString(apiVersion))
  add(path_568455, "certificate-name", newJString(certificateName))
  result = call_568454.call(path_568455, query_568456, nil, nil, nil)

var purgeDeletedCertificate* = Call_PurgeDeletedCertificate_568448(
    name: "purgeDeletedCertificate", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/deletedcertificates/{certificate-name}",
    validator: validate_PurgeDeletedCertificate_568449, base: "",
    url: url_PurgeDeletedCertificate_568450, schemes: {Scheme.Https})
type
  Call_RecoverDeletedCertificate_568457 = ref object of OpenApiRestCall_567667
proc url_RecoverDeletedCertificate_568459(protocol: Scheme; host: string;
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

proc validate_RecoverDeletedCertificate_568458(path: JsonNode; query: JsonNode;
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
  var valid_568460 = path.getOrDefault("certificate-name")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "certificate-name", valid_568460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568461 = query.getOrDefault("api-version")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "api-version", valid_568461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568462: Call_RecoverDeletedCertificate_568457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RecoverDeletedCertificate operation performs the reversal of the Delete operation. The operation is applicable in vaults enabled for soft-delete, and must be issued during the retention interval (available in the deleted certificate's attributes). This operation requires the certificates/recover permission.
  ## 
  let valid = call_568462.validator(path, query, header, formData, body)
  let scheme = call_568462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568462.url(scheme.get, call_568462.host, call_568462.base,
                         call_568462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568462, url, valid)

proc call*(call_568463: Call_RecoverDeletedCertificate_568457; apiVersion: string;
          certificateName: string): Recallable =
  ## recoverDeletedCertificate
  ## The RecoverDeletedCertificate operation performs the reversal of the Delete operation. The operation is applicable in vaults enabled for soft-delete, and must be issued during the retention interval (available in the deleted certificate's attributes). This operation requires the certificates/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the deleted certificate
  var path_568464 = newJObject()
  var query_568465 = newJObject()
  add(query_568465, "api-version", newJString(apiVersion))
  add(path_568464, "certificate-name", newJString(certificateName))
  result = call_568463.call(path_568464, query_568465, nil, nil, nil)

var recoverDeletedCertificate* = Call_RecoverDeletedCertificate_568457(
    name: "recoverDeletedCertificate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/deletedcertificates/{certificate-name}/recover",
    validator: validate_RecoverDeletedCertificate_568458, base: "",
    url: url_RecoverDeletedCertificate_568459, schemes: {Scheme.Https})
type
  Call_GetDeletedKeys_568466 = ref object of OpenApiRestCall_567667
proc url_GetDeletedKeys_568468(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedKeys_568467(path: JsonNode; query: JsonNode;
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
  var valid_568469 = query.getOrDefault("api-version")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "api-version", valid_568469
  var valid_568470 = query.getOrDefault("maxresults")
  valid_568470 = validateParameter(valid_568470, JInt, required = false, default = nil)
  if valid_568470 != nil:
    section.add "maxresults", valid_568470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568471: Call_GetDeletedKeys_568466; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a deleted key. This operation includes deletion-specific information. The Get Deleted Keys operation is applicable for vaults enabled for soft-delete. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/list permission.
  ## 
  let valid = call_568471.validator(path, query, header, formData, body)
  let scheme = call_568471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568471.url(scheme.get, call_568471.host, call_568471.base,
                         call_568471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568471, url, valid)

proc call*(call_568472: Call_GetDeletedKeys_568466; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedKeys
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a deleted key. This operation includes deletion-specific information. The Get Deleted Keys operation is applicable for vaults enabled for soft-delete. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_568473 = newJObject()
  add(query_568473, "api-version", newJString(apiVersion))
  add(query_568473, "maxresults", newJInt(maxresults))
  result = call_568472.call(nil, query_568473, nil, nil, nil)

var getDeletedKeys* = Call_GetDeletedKeys_568466(name: "getDeletedKeys",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedkeys",
    validator: validate_GetDeletedKeys_568467, base: "", url: url_GetDeletedKeys_568468,
    schemes: {Scheme.Https})
type
  Call_GetDeletedKey_568474 = ref object of OpenApiRestCall_567667
proc url_GetDeletedKey_568476(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedKey_568475(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568477 = path.getOrDefault("key-name")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "key-name", valid_568477
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568478 = query.getOrDefault("api-version")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "api-version", valid_568478
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568479: Call_GetDeletedKey_568474; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/get permission. 
  ## 
  let valid = call_568479.validator(path, query, header, formData, body)
  let scheme = call_568479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568479.url(scheme.get, call_568479.host, call_568479.base,
                         call_568479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568479, url, valid)

proc call*(call_568480: Call_GetDeletedKey_568474; apiVersion: string;
          keyName: string): Recallable =
  ## getDeletedKey
  ## The Get Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/get permission. 
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_568481 = newJObject()
  var query_568482 = newJObject()
  add(query_568482, "api-version", newJString(apiVersion))
  add(path_568481, "key-name", newJString(keyName))
  result = call_568480.call(path_568481, query_568482, nil, nil, nil)

var getDeletedKey* = Call_GetDeletedKey_568474(name: "getDeletedKey",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedkeys/{key-name}",
    validator: validate_GetDeletedKey_568475, base: "", url: url_GetDeletedKey_568476,
    schemes: {Scheme.Https})
type
  Call_PurgeDeletedKey_568483 = ref object of OpenApiRestCall_567667
proc url_PurgeDeletedKey_568485(protocol: Scheme; host: string; base: string;
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

proc validate_PurgeDeletedKey_568484(path: JsonNode; query: JsonNode;
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
  var valid_568486 = path.getOrDefault("key-name")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "key-name", valid_568486
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568487 = query.getOrDefault("api-version")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "api-version", valid_568487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568488: Call_PurgeDeletedKey_568483; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Purge Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/purge permission.
  ## 
  let valid = call_568488.validator(path, query, header, formData, body)
  let scheme = call_568488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568488.url(scheme.get, call_568488.host, call_568488.base,
                         call_568488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568488, url, valid)

proc call*(call_568489: Call_PurgeDeletedKey_568483; apiVersion: string;
          keyName: string): Recallable =
  ## purgeDeletedKey
  ## The Purge Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_568490 = newJObject()
  var query_568491 = newJObject()
  add(query_568491, "api-version", newJString(apiVersion))
  add(path_568490, "key-name", newJString(keyName))
  result = call_568489.call(path_568490, query_568491, nil, nil, nil)

var purgeDeletedKey* = Call_PurgeDeletedKey_568483(name: "purgeDeletedKey",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/deletedkeys/{key-name}", validator: validate_PurgeDeletedKey_568484,
    base: "", url: url_PurgeDeletedKey_568485, schemes: {Scheme.Https})
type
  Call_RecoverDeletedKey_568492 = ref object of OpenApiRestCall_567667
proc url_RecoverDeletedKey_568494(protocol: Scheme; host: string; base: string;
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

proc validate_RecoverDeletedKey_568493(path: JsonNode; query: JsonNode;
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
  var valid_568495 = path.getOrDefault("key-name")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "key-name", valid_568495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568496 = query.getOrDefault("api-version")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "api-version", valid_568496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568497: Call_RecoverDeletedKey_568492; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Recover Deleted Key operation is applicable for deleted keys in soft-delete enabled vaults. It recovers the deleted key back to its latest version under /keys. An attempt to recover an non-deleted key will return an error. Consider this the inverse of the delete operation on soft-delete enabled vaults. This operation requires the keys/recover permission.
  ## 
  let valid = call_568497.validator(path, query, header, formData, body)
  let scheme = call_568497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568497.url(scheme.get, call_568497.host, call_568497.base,
                         call_568497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568497, url, valid)

proc call*(call_568498: Call_RecoverDeletedKey_568492; apiVersion: string;
          keyName: string): Recallable =
  ## recoverDeletedKey
  ## The Recover Deleted Key operation is applicable for deleted keys in soft-delete enabled vaults. It recovers the deleted key back to its latest version under /keys. An attempt to recover an non-deleted key will return an error. Consider this the inverse of the delete operation on soft-delete enabled vaults. This operation requires the keys/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the deleted key.
  var path_568499 = newJObject()
  var query_568500 = newJObject()
  add(query_568500, "api-version", newJString(apiVersion))
  add(path_568499, "key-name", newJString(keyName))
  result = call_568498.call(path_568499, query_568500, nil, nil, nil)

var recoverDeletedKey* = Call_RecoverDeletedKey_568492(name: "recoverDeletedKey",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/deletedkeys/{key-name}/recover",
    validator: validate_RecoverDeletedKey_568493, base: "",
    url: url_RecoverDeletedKey_568494, schemes: {Scheme.Https})
type
  Call_GetDeletedSecrets_568501 = ref object of OpenApiRestCall_567667
proc url_GetDeletedSecrets_568503(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedSecrets_568502(path: JsonNode; query: JsonNode;
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
  var valid_568504 = query.getOrDefault("api-version")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "api-version", valid_568504
  var valid_568505 = query.getOrDefault("maxresults")
  valid_568505 = validateParameter(valid_568505, JInt, required = false, default = nil)
  if valid_568505 != nil:
    section.add "maxresults", valid_568505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568506: Call_GetDeletedSecrets_568501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Secrets operation returns the secrets that have been deleted for a vault enabled for soft-delete. This operation requires the secrets/list permission.
  ## 
  let valid = call_568506.validator(path, query, header, formData, body)
  let scheme = call_568506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568506.url(scheme.get, call_568506.host, call_568506.base,
                         call_568506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568506, url, valid)

proc call*(call_568507: Call_GetDeletedSecrets_568501; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedSecrets
  ## The Get Deleted Secrets operation returns the secrets that have been deleted for a vault enabled for soft-delete. This operation requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_568508 = newJObject()
  add(query_568508, "api-version", newJString(apiVersion))
  add(query_568508, "maxresults", newJInt(maxresults))
  result = call_568507.call(nil, query_568508, nil, nil, nil)

var getDeletedSecrets* = Call_GetDeletedSecrets_568501(name: "getDeletedSecrets",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedsecrets",
    validator: validate_GetDeletedSecrets_568502, base: "",
    url: url_GetDeletedSecrets_568503, schemes: {Scheme.Https})
type
  Call_GetDeletedSecret_568509 = ref object of OpenApiRestCall_567667
proc url_GetDeletedSecret_568511(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedSecret_568510(path: JsonNode; query: JsonNode;
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
  var valid_568512 = path.getOrDefault("secret-name")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "secret-name", valid_568512
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568513 = query.getOrDefault("api-version")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "api-version", valid_568513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568514: Call_GetDeletedSecret_568509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Secret operation returns the specified deleted secret along with its attributes. This operation requires the secrets/get permission.
  ## 
  let valid = call_568514.validator(path, query, header, formData, body)
  let scheme = call_568514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568514.url(scheme.get, call_568514.host, call_568514.base,
                         call_568514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568514, url, valid)

proc call*(call_568515: Call_GetDeletedSecret_568509; apiVersion: string;
          secretName: string): Recallable =
  ## getDeletedSecret
  ## The Get Deleted Secret operation returns the specified deleted secret along with its attributes. This operation requires the secrets/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_568516 = newJObject()
  var query_568517 = newJObject()
  add(query_568517, "api-version", newJString(apiVersion))
  add(path_568516, "secret-name", newJString(secretName))
  result = call_568515.call(path_568516, query_568517, nil, nil, nil)

var getDeletedSecret* = Call_GetDeletedSecret_568509(name: "getDeletedSecret",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedsecrets/{secret-name}", validator: validate_GetDeletedSecret_568510,
    base: "", url: url_GetDeletedSecret_568511, schemes: {Scheme.Https})
type
  Call_PurgeDeletedSecret_568518 = ref object of OpenApiRestCall_567667
proc url_PurgeDeletedSecret_568520(protocol: Scheme; host: string; base: string;
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

proc validate_PurgeDeletedSecret_568519(path: JsonNode; query: JsonNode;
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
  var valid_568521 = path.getOrDefault("secret-name")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "secret-name", valid_568521
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568522 = query.getOrDefault("api-version")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "api-version", valid_568522
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568523: Call_PurgeDeletedSecret_568518; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The purge deleted secret operation removes the secret permanently, without the possibility of recovery. This operation can only be enabled on a soft-delete enabled vault. This operation requires the secrets/purge permission.
  ## 
  let valid = call_568523.validator(path, query, header, formData, body)
  let scheme = call_568523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568523.url(scheme.get, call_568523.host, call_568523.base,
                         call_568523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568523, url, valid)

proc call*(call_568524: Call_PurgeDeletedSecret_568518; apiVersion: string;
          secretName: string): Recallable =
  ## purgeDeletedSecret
  ## The purge deleted secret operation removes the secret permanently, without the possibility of recovery. This operation can only be enabled on a soft-delete enabled vault. This operation requires the secrets/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_568525 = newJObject()
  var query_568526 = newJObject()
  add(query_568526, "api-version", newJString(apiVersion))
  add(path_568525, "secret-name", newJString(secretName))
  result = call_568524.call(path_568525, query_568526, nil, nil, nil)

var purgeDeletedSecret* = Call_PurgeDeletedSecret_568518(
    name: "purgeDeletedSecret", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/deletedsecrets/{secret-name}",
    validator: validate_PurgeDeletedSecret_568519, base: "",
    url: url_PurgeDeletedSecret_568520, schemes: {Scheme.Https})
type
  Call_RecoverDeletedSecret_568527 = ref object of OpenApiRestCall_567667
proc url_RecoverDeletedSecret_568529(protocol: Scheme; host: string; base: string;
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

proc validate_RecoverDeletedSecret_568528(path: JsonNode; query: JsonNode;
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
  var valid_568530 = path.getOrDefault("secret-name")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "secret-name", valid_568530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568531 = query.getOrDefault("api-version")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "api-version", valid_568531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568532: Call_RecoverDeletedSecret_568527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recovers the deleted secret in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the secrets/recover permission.
  ## 
  let valid = call_568532.validator(path, query, header, formData, body)
  let scheme = call_568532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568532.url(scheme.get, call_568532.host, call_568532.base,
                         call_568532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568532, url, valid)

proc call*(call_568533: Call_RecoverDeletedSecret_568527; apiVersion: string;
          secretName: string): Recallable =
  ## recoverDeletedSecret
  ## Recovers the deleted secret in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the secrets/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the deleted secret.
  var path_568534 = newJObject()
  var query_568535 = newJObject()
  add(query_568535, "api-version", newJString(apiVersion))
  add(path_568534, "secret-name", newJString(secretName))
  result = call_568533.call(path_568534, query_568535, nil, nil, nil)

var recoverDeletedSecret* = Call_RecoverDeletedSecret_568527(
    name: "recoverDeletedSecret", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/deletedsecrets/{secret-name}/recover",
    validator: validate_RecoverDeletedSecret_568528, base: "",
    url: url_RecoverDeletedSecret_568529, schemes: {Scheme.Https})
type
  Call_GetDeletedStorageAccounts_568536 = ref object of OpenApiRestCall_567667
proc url_GetDeletedStorageAccounts_568538(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedStorageAccounts_568537(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get Deleted Storage Accounts operation returns the storage accounts that have been deleted for a vault enabled for soft-delete. This operation requires the storage/list permission.
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
  var valid_568539 = query.getOrDefault("api-version")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "api-version", valid_568539
  var valid_568540 = query.getOrDefault("maxresults")
  valid_568540 = validateParameter(valid_568540, JInt, required = false, default = nil)
  if valid_568540 != nil:
    section.add "maxresults", valid_568540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568541: Call_GetDeletedStorageAccounts_568536; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Storage Accounts operation returns the storage accounts that have been deleted for a vault enabled for soft-delete. This operation requires the storage/list permission.
  ## 
  let valid = call_568541.validator(path, query, header, formData, body)
  let scheme = call_568541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568541.url(scheme.get, call_568541.host, call_568541.base,
                         call_568541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568541, url, valid)

proc call*(call_568542: Call_GetDeletedStorageAccounts_568536; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedStorageAccounts
  ## The Get Deleted Storage Accounts operation returns the storage accounts that have been deleted for a vault enabled for soft-delete. This operation requires the storage/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_568543 = newJObject()
  add(query_568543, "api-version", newJString(apiVersion))
  add(query_568543, "maxresults", newJInt(maxresults))
  result = call_568542.call(nil, query_568543, nil, nil, nil)

var getDeletedStorageAccounts* = Call_GetDeletedStorageAccounts_568536(
    name: "getDeletedStorageAccounts", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/deletedstorage",
    validator: validate_GetDeletedStorageAccounts_568537, base: "",
    url: url_GetDeletedStorageAccounts_568538, schemes: {Scheme.Https})
type
  Call_GetDeletedStorageAccount_568544 = ref object of OpenApiRestCall_567667
proc url_GetDeletedStorageAccount_568546(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedstorage/"),
               (kind: VariableSegment, value: "storage-account-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeletedStorageAccount_568545(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get Deleted Storage Account operation returns the specified deleted storage account along with its attributes. This operation requires the storage/get permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_568547 = path.getOrDefault("storage-account-name")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "storage-account-name", valid_568547
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568548 = query.getOrDefault("api-version")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "api-version", valid_568548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568549: Call_GetDeletedStorageAccount_568544; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Storage Account operation returns the specified deleted storage account along with its attributes. This operation requires the storage/get permission.
  ## 
  let valid = call_568549.validator(path, query, header, formData, body)
  let scheme = call_568549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568549.url(scheme.get, call_568549.host, call_568549.base,
                         call_568549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568549, url, valid)

proc call*(call_568550: Call_GetDeletedStorageAccount_568544; apiVersion: string;
          storageAccountName: string): Recallable =
  ## getDeletedStorageAccount
  ## The Get Deleted Storage Account operation returns the specified deleted storage account along with its attributes. This operation requires the storage/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_568551 = newJObject()
  var query_568552 = newJObject()
  add(query_568552, "api-version", newJString(apiVersion))
  add(path_568551, "storage-account-name", newJString(storageAccountName))
  result = call_568550.call(path_568551, query_568552, nil, nil, nil)

var getDeletedStorageAccount* = Call_GetDeletedStorageAccount_568544(
    name: "getDeletedStorageAccount", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedstorage/{storage-account-name}",
    validator: validate_GetDeletedStorageAccount_568545, base: "",
    url: url_GetDeletedStorageAccount_568546, schemes: {Scheme.Https})
type
  Call_PurgeDeletedStorageAccount_568553 = ref object of OpenApiRestCall_567667
proc url_PurgeDeletedStorageAccount_568555(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedstorage/"),
               (kind: VariableSegment, value: "storage-account-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PurgeDeletedStorageAccount_568554(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The purge deleted storage account operation removes the secret permanently, without the possibility of recovery. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/purge permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_568556 = path.getOrDefault("storage-account-name")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "storage-account-name", valid_568556
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568557 = query.getOrDefault("api-version")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "api-version", valid_568557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568558: Call_PurgeDeletedStorageAccount_568553; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The purge deleted storage account operation removes the secret permanently, without the possibility of recovery. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/purge permission.
  ## 
  let valid = call_568558.validator(path, query, header, formData, body)
  let scheme = call_568558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568558.url(scheme.get, call_568558.host, call_568558.base,
                         call_568558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568558, url, valid)

proc call*(call_568559: Call_PurgeDeletedStorageAccount_568553; apiVersion: string;
          storageAccountName: string): Recallable =
  ## purgeDeletedStorageAccount
  ## The purge deleted storage account operation removes the secret permanently, without the possibility of recovery. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_568560 = newJObject()
  var query_568561 = newJObject()
  add(query_568561, "api-version", newJString(apiVersion))
  add(path_568560, "storage-account-name", newJString(storageAccountName))
  result = call_568559.call(path_568560, query_568561, nil, nil, nil)

var purgeDeletedStorageAccount* = Call_PurgeDeletedStorageAccount_568553(
    name: "purgeDeletedStorageAccount", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/deletedstorage/{storage-account-name}",
    validator: validate_PurgeDeletedStorageAccount_568554, base: "",
    url: url_PurgeDeletedStorageAccount_568555, schemes: {Scheme.Https})
type
  Call_RecoverDeletedStorageAccount_568562 = ref object of OpenApiRestCall_567667
proc url_RecoverDeletedStorageAccount_568564(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedstorage/"),
               (kind: VariableSegment, value: "storage-account-name"),
               (kind: ConstantSegment, value: "/recover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoverDeletedStorageAccount_568563(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recovers the deleted storage account in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_568565 = path.getOrDefault("storage-account-name")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "storage-account-name", valid_568565
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568566 = query.getOrDefault("api-version")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "api-version", valid_568566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568567: Call_RecoverDeletedStorageAccount_568562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recovers the deleted storage account in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ## 
  let valid = call_568567.validator(path, query, header, formData, body)
  let scheme = call_568567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568567.url(scheme.get, call_568567.host, call_568567.base,
                         call_568567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568567, url, valid)

proc call*(call_568568: Call_RecoverDeletedStorageAccount_568562;
          apiVersion: string; storageAccountName: string): Recallable =
  ## recoverDeletedStorageAccount
  ## Recovers the deleted storage account in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_568569 = newJObject()
  var query_568570 = newJObject()
  add(query_568570, "api-version", newJString(apiVersion))
  add(path_568569, "storage-account-name", newJString(storageAccountName))
  result = call_568568.call(path_568569, query_568570, nil, nil, nil)

var recoverDeletedStorageAccount* = Call_RecoverDeletedStorageAccount_568562(
    name: "recoverDeletedStorageAccount", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/deletedstorage/{storage-account-name}/recover",
    validator: validate_RecoverDeletedStorageAccount_568563, base: "",
    url: url_RecoverDeletedStorageAccount_568564, schemes: {Scheme.Https})
type
  Call_GetDeletedSasDefinitions_568571 = ref object of OpenApiRestCall_567667
proc url_GetDeletedSasDefinitions_568573(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedstorage/"),
               (kind: VariableSegment, value: "storage-account-name"),
               (kind: ConstantSegment, value: "/sas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeletedSasDefinitions_568572(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get Deleted Sas Definitions operation returns the SAS definitions that have been deleted for a vault enabled for soft-delete. This operation requires the storage/listsas permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_568574 = path.getOrDefault("storage-account-name")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "storage-account-name", valid_568574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568575 = query.getOrDefault("api-version")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "api-version", valid_568575
  var valid_568576 = query.getOrDefault("maxresults")
  valid_568576 = validateParameter(valid_568576, JInt, required = false, default = nil)
  if valid_568576 != nil:
    section.add "maxresults", valid_568576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568577: Call_GetDeletedSasDefinitions_568571; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Sas Definitions operation returns the SAS definitions that have been deleted for a vault enabled for soft-delete. This operation requires the storage/listsas permission.
  ## 
  let valid = call_568577.validator(path, query, header, formData, body)
  let scheme = call_568577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568577.url(scheme.get, call_568577.host, call_568577.base,
                         call_568577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568577, url, valid)

proc call*(call_568578: Call_GetDeletedSasDefinitions_568571; apiVersion: string;
          storageAccountName: string; maxresults: int = 0): Recallable =
  ## getDeletedSasDefinitions
  ## The Get Deleted Sas Definitions operation returns the SAS definitions that have been deleted for a vault enabled for soft-delete. This operation requires the storage/listsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_568579 = newJObject()
  var query_568580 = newJObject()
  add(query_568580, "api-version", newJString(apiVersion))
  add(query_568580, "maxresults", newJInt(maxresults))
  add(path_568579, "storage-account-name", newJString(storageAccountName))
  result = call_568578.call(path_568579, query_568580, nil, nil, nil)

var getDeletedSasDefinitions* = Call_GetDeletedSasDefinitions_568571(
    name: "getDeletedSasDefinitions", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedstorage/{storage-account-name}/sas",
    validator: validate_GetDeletedSasDefinitions_568572, base: "",
    url: url_GetDeletedSasDefinitions_568573, schemes: {Scheme.Https})
type
  Call_GetDeletedSasDefinition_568581 = ref object of OpenApiRestCall_567667
proc url_GetDeletedSasDefinition_568583(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  assert "sas-definition-name" in path,
        "`sas-definition-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedstorage/"),
               (kind: VariableSegment, value: "storage-account-name"),
               (kind: ConstantSegment, value: "/sas/"),
               (kind: VariableSegment, value: "sas-definition-name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeletedSasDefinition_568582(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get Deleted SAS Definition operation returns the specified deleted SAS definition along with its attributes. This operation requires the storage/getsas permission.
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
  var valid_568584 = path.getOrDefault("storage-account-name")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "storage-account-name", valid_568584
  var valid_568585 = path.getOrDefault("sas-definition-name")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "sas-definition-name", valid_568585
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568586 = query.getOrDefault("api-version")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "api-version", valid_568586
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568587: Call_GetDeletedSasDefinition_568581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted SAS Definition operation returns the specified deleted SAS definition along with its attributes. This operation requires the storage/getsas permission.
  ## 
  let valid = call_568587.validator(path, query, header, formData, body)
  let scheme = call_568587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568587.url(scheme.get, call_568587.host, call_568587.base,
                         call_568587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568587, url, valid)

proc call*(call_568588: Call_GetDeletedSasDefinition_568581; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## getDeletedSasDefinition
  ## The Get Deleted SAS Definition operation returns the specified deleted SAS definition along with its attributes. This operation requires the storage/getsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_568589 = newJObject()
  var query_568590 = newJObject()
  add(query_568590, "api-version", newJString(apiVersion))
  add(path_568589, "storage-account-name", newJString(storageAccountName))
  add(path_568589, "sas-definition-name", newJString(sasDefinitionName))
  result = call_568588.call(path_568589, query_568590, nil, nil, nil)

var getDeletedSasDefinition* = Call_GetDeletedSasDefinition_568581(
    name: "getDeletedSasDefinition", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedstorage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_GetDeletedSasDefinition_568582, base: "",
    url: url_GetDeletedSasDefinition_568583, schemes: {Scheme.Https})
type
  Call_RecoverDeletedSasDefinition_568591 = ref object of OpenApiRestCall_567667
proc url_RecoverDeletedSasDefinition_568593(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "storage-account-name" in path,
        "`storage-account-name` is a required path parameter"
  assert "sas-definition-name" in path,
        "`sas-definition-name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/deletedstorage/"),
               (kind: VariableSegment, value: "storage-account-name"),
               (kind: ConstantSegment, value: "/sas/"),
               (kind: VariableSegment, value: "sas-definition-name"),
               (kind: ConstantSegment, value: "/recover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoverDeletedSasDefinition_568592(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recovers the deleted SAS definition for the specified storage account. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
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
  var valid_568594 = path.getOrDefault("storage-account-name")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "storage-account-name", valid_568594
  var valid_568595 = path.getOrDefault("sas-definition-name")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "sas-definition-name", valid_568595
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568596 = query.getOrDefault("api-version")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "api-version", valid_568596
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568597: Call_RecoverDeletedSasDefinition_568591; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recovers the deleted SAS definition for the specified storage account. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ## 
  let valid = call_568597.validator(path, query, header, formData, body)
  let scheme = call_568597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568597.url(scheme.get, call_568597.host, call_568597.base,
                         call_568597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568597, url, valid)

proc call*(call_568598: Call_RecoverDeletedSasDefinition_568591;
          apiVersion: string; storageAccountName: string; sasDefinitionName: string): Recallable =
  ## recoverDeletedSasDefinition
  ## Recovers the deleted SAS definition for the specified storage account. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_568599 = newJObject()
  var query_568600 = newJObject()
  add(query_568600, "api-version", newJString(apiVersion))
  add(path_568599, "storage-account-name", newJString(storageAccountName))
  add(path_568599, "sas-definition-name", newJString(sasDefinitionName))
  result = call_568598.call(path_568599, query_568600, nil, nil, nil)

var recoverDeletedSasDefinition* = Call_RecoverDeletedSasDefinition_568591(
    name: "recoverDeletedSasDefinition", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/deletedstorage/{storage-account-name}/sas/{sas-definition-name}/recover",
    validator: validate_RecoverDeletedSasDefinition_568592, base: "",
    url: url_RecoverDeletedSasDefinition_568593, schemes: {Scheme.Https})
type
  Call_GetKeys_568601 = ref object of OpenApiRestCall_567667
proc url_GetKeys_568603(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetKeys_568602(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568604 = query.getOrDefault("api-version")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "api-version", valid_568604
  var valid_568605 = query.getOrDefault("maxresults")
  valid_568605 = validateParameter(valid_568605, JInt, required = false, default = nil)
  if valid_568605 != nil:
    section.add "maxresults", valid_568605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568606: Call_GetKeys_568601; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a stored key. The LIST operation is applicable to all key types, however only the base key identifier, attributes, and tags are provided in the response. Individual versions of a key are not listed in the response. This operation requires the keys/list permission.
  ## 
  let valid = call_568606.validator(path, query, header, formData, body)
  let scheme = call_568606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568606.url(scheme.get, call_568606.host, call_568606.base,
                         call_568606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568606, url, valid)

proc call*(call_568607: Call_GetKeys_568601; apiVersion: string; maxresults: int = 0): Recallable =
  ## getKeys
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a stored key. The LIST operation is applicable to all key types, however only the base key identifier, attributes, and tags are provided in the response. Individual versions of a key are not listed in the response. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_568608 = newJObject()
  add(query_568608, "api-version", newJString(apiVersion))
  add(query_568608, "maxresults", newJInt(maxresults))
  result = call_568607.call(nil, query_568608, nil, nil, nil)

var getKeys* = Call_GetKeys_568601(name: "getKeys", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/keys",
                                validator: validate_GetKeys_568602, base: "",
                                url: url_GetKeys_568603, schemes: {Scheme.Https})
type
  Call_RestoreKey_568609 = ref object of OpenApiRestCall_567667
proc url_RestoreKey_568611(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreKey_568610(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568612 = query.getOrDefault("api-version")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "api-version", valid_568612
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

proc call*(call_568614: Call_RestoreKey_568609; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a previously backed up key into Azure Key Vault, restoring the key, its key identifier, attributes and access control policies. The RESTORE operation may be used to import a previously backed up key. Individual versions of a key cannot be restored. The key is restored in its entirety with the same key name as it had when it was backed up. If the key name is not available in the target Key Vault, the RESTORE operation will be rejected. While the key name is retained during restore, the final key identifier will change if the key is restored to a different vault. Restore will restore all versions and preserve version identifiers. The RESTORE operation is subject to security constraints: The target Key Vault must be owned by the same Microsoft Azure Subscription as the source Key Vault The user must have RESTORE permission in the target Key Vault. This operation requires the keys/restore permission.
  ## 
  let valid = call_568614.validator(path, query, header, formData, body)
  let scheme = call_568614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568614.url(scheme.get, call_568614.host, call_568614.base,
                         call_568614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568614, url, valid)

proc call*(call_568615: Call_RestoreKey_568609; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreKey
  ## Imports a previously backed up key into Azure Key Vault, restoring the key, its key identifier, attributes and access control policies. The RESTORE operation may be used to import a previously backed up key. Individual versions of a key cannot be restored. The key is restored in its entirety with the same key name as it had when it was backed up. If the key name is not available in the target Key Vault, the RESTORE operation will be rejected. While the key name is retained during restore, the final key identifier will change if the key is restored to a different vault. Restore will restore all versions and preserve version identifiers. The RESTORE operation is subject to security constraints: The target Key Vault must be owned by the same Microsoft Azure Subscription as the source Key Vault The user must have RESTORE permission in the target Key Vault. This operation requires the keys/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the key.
  var query_568616 = newJObject()
  var body_568617 = newJObject()
  add(query_568616, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568617 = parameters
  result = call_568615.call(nil, query_568616, nil, nil, body_568617)

var restoreKey* = Call_RestoreKey_568609(name: "restoreKey",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/keys/restore",
                                      validator: validate_RestoreKey_568610,
                                      base: "", url: url_RestoreKey_568611,
                                      schemes: {Scheme.Https})
type
  Call_ImportKey_568618 = ref object of OpenApiRestCall_567667
proc url_ImportKey_568620(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImportKey_568619(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568621 = path.getOrDefault("key-name")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "key-name", valid_568621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568622 = query.getOrDefault("api-version")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "api-version", valid_568622
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

proc call*(call_568624: Call_ImportKey_568618; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The import key operation may be used to import any key type into an Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. This operation requires the keys/import permission.
  ## 
  let valid = call_568624.validator(path, query, header, formData, body)
  let scheme = call_568624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568624.url(scheme.get, call_568624.host, call_568624.base,
                         call_568624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568624, url, valid)

proc call*(call_568625: Call_ImportKey_568618; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## importKey
  ## The import key operation may be used to import any key type into an Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. This operation requires the keys/import permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to import a key.
  ##   keyName: string (required)
  ##          : Name for the imported key.
  var path_568626 = newJObject()
  var query_568627 = newJObject()
  var body_568628 = newJObject()
  add(query_568627, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568628 = parameters
  add(path_568626, "key-name", newJString(keyName))
  result = call_568625.call(path_568626, query_568627, nil, nil, body_568628)

var importKey* = Call_ImportKey_568618(name: "importKey", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_ImportKey_568619,
                                    base: "", url: url_ImportKey_568620,
                                    schemes: {Scheme.Https})
type
  Call_DeleteKey_568629 = ref object of OpenApiRestCall_567667
proc url_DeleteKey_568631(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DeleteKey_568630(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568632 = path.getOrDefault("key-name")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "key-name", valid_568632
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568633 = query.getOrDefault("api-version")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "api-version", valid_568633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568634: Call_DeleteKey_568629; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete key operation cannot be used to remove individual versions of a key. This operation removes the cryptographic material associated with the key, which means the key is not usable for Sign/Verify, Wrap/Unwrap or Encrypt/Decrypt operations. This operation requires the keys/delete permission.
  ## 
  let valid = call_568634.validator(path, query, header, formData, body)
  let scheme = call_568634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568634.url(scheme.get, call_568634.host, call_568634.base,
                         call_568634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568634, url, valid)

proc call*(call_568635: Call_DeleteKey_568629; apiVersion: string; keyName: string): Recallable =
  ## deleteKey
  ## The delete key operation cannot be used to remove individual versions of a key. This operation removes the cryptographic material associated with the key, which means the key is not usable for Sign/Verify, Wrap/Unwrap or Encrypt/Decrypt operations. This operation requires the keys/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key to delete.
  var path_568636 = newJObject()
  var query_568637 = newJObject()
  add(query_568637, "api-version", newJString(apiVersion))
  add(path_568636, "key-name", newJString(keyName))
  result = call_568635.call(path_568636, query_568637, nil, nil, nil)

var deleteKey* = Call_DeleteKey_568629(name: "deleteKey",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_DeleteKey_568630,
                                    base: "", url: url_DeleteKey_568631,
                                    schemes: {Scheme.Https})
type
  Call_BackupKey_568638 = ref object of OpenApiRestCall_567667
proc url_BackupKey_568640(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BackupKey_568639(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568641 = path.getOrDefault("key-name")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "key-name", valid_568641
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568642 = query.getOrDefault("api-version")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "api-version", valid_568642
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568643: Call_BackupKey_568638; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Key Backup operation exports a key from Azure Key Vault in a protected form. Note that this operation does NOT return key material in a form that can be used outside the Azure Key Vault system, the returned key material is either protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of this operation is to allow a client to GENERATE a key in one Azure Key Vault instance, BACKUP the key, and then RESTORE it into another Azure Key Vault instance. The BACKUP operation may be used to export, in protected form, any key type from Azure Key Vault. Individual versions of a key cannot be backed up. BACKUP / RESTORE can be performed within geographical boundaries only; meaning that a BACKUP from one geographical area cannot be restored to another geographical area. For example, a backup from the US geographical area cannot be restored in an EU geographical area. This operation requires the key/backup permission.
  ## 
  let valid = call_568643.validator(path, query, header, formData, body)
  let scheme = call_568643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568643.url(scheme.get, call_568643.host, call_568643.base,
                         call_568643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568643, url, valid)

proc call*(call_568644: Call_BackupKey_568638; apiVersion: string; keyName: string): Recallable =
  ## backupKey
  ## The Key Backup operation exports a key from Azure Key Vault in a protected form. Note that this operation does NOT return key material in a form that can be used outside the Azure Key Vault system, the returned key material is either protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of this operation is to allow a client to GENERATE a key in one Azure Key Vault instance, BACKUP the key, and then RESTORE it into another Azure Key Vault instance. The BACKUP operation may be used to export, in protected form, any key type from Azure Key Vault. Individual versions of a key cannot be backed up. BACKUP / RESTORE can be performed within geographical boundaries only; meaning that a BACKUP from one geographical area cannot be restored to another geographical area. For example, a backup from the US geographical area cannot be restored in an EU geographical area. This operation requires the key/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_568645 = newJObject()
  var query_568646 = newJObject()
  add(query_568646, "api-version", newJString(apiVersion))
  add(path_568645, "key-name", newJString(keyName))
  result = call_568644.call(path_568645, query_568646, nil, nil, nil)

var backupKey* = Call_BackupKey_568638(name: "backupKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/backup",
                                    validator: validate_BackupKey_568639,
                                    base: "", url: url_BackupKey_568640,
                                    schemes: {Scheme.Https})
type
  Call_CreateKey_568647 = ref object of OpenApiRestCall_567667
proc url_CreateKey_568649(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CreateKey_568648(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568660 = path.getOrDefault("key-name")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "key-name", valid_568660
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568661 = query.getOrDefault("api-version")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "api-version", valid_568661
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

proc call*(call_568663: Call_CreateKey_568647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The create key operation can be used to create any key type in Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. It requires the keys/create permission.
  ## 
  let valid = call_568663.validator(path, query, header, formData, body)
  let scheme = call_568663.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568663.url(scheme.get, call_568663.host, call_568663.base,
                         call_568663.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568663, url, valid)

proc call*(call_568664: Call_CreateKey_568647; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## createKey
  ## The create key operation can be used to create any key type in Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. It requires the keys/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to create a key.
  ##   keyName: string (required)
  ##          : The name for the new key. The system will generate the version name for the new key.
  var path_568665 = newJObject()
  var query_568666 = newJObject()
  var body_568667 = newJObject()
  add(query_568666, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568667 = parameters
  add(path_568665, "key-name", newJString(keyName))
  result = call_568664.call(path_568665, query_568666, nil, nil, body_568667)

var createKey* = Call_CreateKey_568647(name: "createKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/create",
                                    validator: validate_CreateKey_568648,
                                    base: "", url: url_CreateKey_568649,
                                    schemes: {Scheme.Https})
type
  Call_GetKeyVersions_568668 = ref object of OpenApiRestCall_567667
proc url_GetKeyVersions_568670(protocol: Scheme; host: string; base: string;
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

proc validate_GetKeyVersions_568669(path: JsonNode; query: JsonNode;
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
  var valid_568671 = path.getOrDefault("key-name")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "key-name", valid_568671
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568672 = query.getOrDefault("api-version")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "api-version", valid_568672
  var valid_568673 = query.getOrDefault("maxresults")
  valid_568673 = validateParameter(valid_568673, JInt, required = false, default = nil)
  if valid_568673 != nil:
    section.add "maxresults", valid_568673
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568674: Call_GetKeyVersions_568668; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The full key identifier, attributes, and tags are provided in the response. This operation requires the keys/list permission.
  ## 
  let valid = call_568674.validator(path, query, header, formData, body)
  let scheme = call_568674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568674.url(scheme.get, call_568674.host, call_568674.base,
                         call_568674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568674, url, valid)

proc call*(call_568675: Call_GetKeyVersions_568668; apiVersion: string;
          keyName: string; maxresults: int = 0): Recallable =
  ## getKeyVersions
  ## The full key identifier, attributes, and tags are provided in the response. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_568676 = newJObject()
  var query_568677 = newJObject()
  add(query_568677, "api-version", newJString(apiVersion))
  add(query_568677, "maxresults", newJInt(maxresults))
  add(path_568676, "key-name", newJString(keyName))
  result = call_568675.call(path_568676, query_568677, nil, nil, nil)

var getKeyVersions* = Call_GetKeyVersions_568668(name: "getKeyVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/keys/{key-name}/versions", validator: validate_GetKeyVersions_568669,
    base: "", url: url_GetKeyVersions_568670, schemes: {Scheme.Https})
type
  Call_GetKey_568678 = ref object of OpenApiRestCall_567667
proc url_GetKey_568680(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetKey_568679(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568681 = path.getOrDefault("key-version")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "key-version", valid_568681
  var valid_568682 = path.getOrDefault("key-name")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "key-name", valid_568682
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568683 = query.getOrDefault("api-version")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "api-version", valid_568683
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568684: Call_GetKey_568678; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The get key operation is applicable to all key types. If the requested key is symmetric, then no key material is released in the response. This operation requires the keys/get permission.
  ## 
  let valid = call_568684.validator(path, query, header, formData, body)
  let scheme = call_568684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568684.url(scheme.get, call_568684.host, call_568684.base,
                         call_568684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568684, url, valid)

proc call*(call_568685: Call_GetKey_568678; apiVersion: string; keyVersion: string;
          keyName: string): Recallable =
  ## getKey
  ## The get key operation is applicable to all key types. If the requested key is symmetric, then no key material is released in the response. This operation requires the keys/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyVersion: string (required)
  ##             : Adding the version parameter retrieves a specific version of a key.
  ##   keyName: string (required)
  ##          : The name of the key to get.
  var path_568686 = newJObject()
  var query_568687 = newJObject()
  add(query_568687, "api-version", newJString(apiVersion))
  add(path_568686, "key-version", newJString(keyVersion))
  add(path_568686, "key-name", newJString(keyName))
  result = call_568685.call(path_568686, query_568687, nil, nil, nil)

var getKey* = Call_GetKey_568678(name: "getKey", meth: HttpMethod.HttpGet,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}",
                              validator: validate_GetKey_568679, base: "",
                              url: url_GetKey_568680, schemes: {Scheme.Https})
type
  Call_UpdateKey_568688 = ref object of OpenApiRestCall_567667
proc url_UpdateKey_568690(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UpdateKey_568689(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568691 = path.getOrDefault("key-version")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "key-version", valid_568691
  var valid_568692 = path.getOrDefault("key-name")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "key-name", valid_568692
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568693 = query.getOrDefault("api-version")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "api-version", valid_568693
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

proc call*(call_568695: Call_UpdateKey_568688; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## In order to perform this operation, the key must already exist in the Key Vault. Note: The cryptographic material of a key itself cannot be changed. This operation requires the keys/update permission.
  ## 
  let valid = call_568695.validator(path, query, header, formData, body)
  let scheme = call_568695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568695.url(scheme.get, call_568695.host, call_568695.base,
                         call_568695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568695, url, valid)

proc call*(call_568696: Call_UpdateKey_568688; apiVersion: string;
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
  var path_568697 = newJObject()
  var query_568698 = newJObject()
  var body_568699 = newJObject()
  add(query_568698, "api-version", newJString(apiVersion))
  add(path_568697, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_568699 = parameters
  add(path_568697, "key-name", newJString(keyName))
  result = call_568696.call(path_568697, query_568698, nil, nil, body_568699)

var updateKey* = Call_UpdateKey_568688(name: "updateKey", meth: HttpMethod.HttpPatch,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/{key-version}",
                                    validator: validate_UpdateKey_568689,
                                    base: "", url: url_UpdateKey_568690,
                                    schemes: {Scheme.Https})
type
  Call_Decrypt_568700 = ref object of OpenApiRestCall_567667
proc url_Decrypt_568702(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Decrypt_568701(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568703 = path.getOrDefault("key-version")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "key-version", valid_568703
  var valid_568704 = path.getOrDefault("key-name")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "key-name", valid_568704
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568705 = query.getOrDefault("api-version")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "api-version", valid_568705
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

proc call*(call_568707: Call_Decrypt_568700; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DECRYPT operation decrypts a well-formed block of ciphertext using the target encryption key and specified algorithm. This operation is the reverse of the ENCRYPT operation; only a single block of data may be decrypted, the size of this block is dependent on the target key and the algorithm to be used. The DECRYPT operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/decrypt permission.
  ## 
  let valid = call_568707.validator(path, query, header, formData, body)
  let scheme = call_568707.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568707.url(scheme.get, call_568707.host, call_568707.base,
                         call_568707.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568707, url, valid)

proc call*(call_568708: Call_Decrypt_568700; apiVersion: string; keyVersion: string;
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
  var path_568709 = newJObject()
  var query_568710 = newJObject()
  var body_568711 = newJObject()
  add(query_568710, "api-version", newJString(apiVersion))
  add(path_568709, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_568711 = parameters
  add(path_568709, "key-name", newJString(keyName))
  result = call_568708.call(path_568709, query_568710, nil, nil, body_568711)

var decrypt* = Call_Decrypt_568700(name: "decrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/decrypt",
                                validator: validate_Decrypt_568701, base: "",
                                url: url_Decrypt_568702, schemes: {Scheme.Https})
type
  Call_Encrypt_568712 = ref object of OpenApiRestCall_567667
proc url_Encrypt_568714(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Encrypt_568713(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568715 = path.getOrDefault("key-version")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "key-version", valid_568715
  var valid_568716 = path.getOrDefault("key-name")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "key-name", valid_568716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568717 = query.getOrDefault("api-version")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "api-version", valid_568717
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

proc call*(call_568719: Call_Encrypt_568712; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The ENCRYPT operation encrypts an arbitrary sequence of bytes using an encryption key that is stored in Azure Key Vault. Note that the ENCRYPT operation only supports a single block of data, the size of which is dependent on the target key and the encryption algorithm to be used. The ENCRYPT operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/encrypt permission.
  ## 
  let valid = call_568719.validator(path, query, header, formData, body)
  let scheme = call_568719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568719.url(scheme.get, call_568719.host, call_568719.base,
                         call_568719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568719, url, valid)

proc call*(call_568720: Call_Encrypt_568712; apiVersion: string; keyVersion: string;
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
  var path_568721 = newJObject()
  var query_568722 = newJObject()
  var body_568723 = newJObject()
  add(query_568722, "api-version", newJString(apiVersion))
  add(path_568721, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_568723 = parameters
  add(path_568721, "key-name", newJString(keyName))
  result = call_568720.call(path_568721, query_568722, nil, nil, body_568723)

var encrypt* = Call_Encrypt_568712(name: "encrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/encrypt",
                                validator: validate_Encrypt_568713, base: "",
                                url: url_Encrypt_568714, schemes: {Scheme.Https})
type
  Call_Sign_568724 = ref object of OpenApiRestCall_567667
proc url_Sign_568726(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Sign_568725(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568727 = path.getOrDefault("key-version")
  valid_568727 = validateParameter(valid_568727, JString, required = true,
                                 default = nil)
  if valid_568727 != nil:
    section.add "key-version", valid_568727
  var valid_568728 = path.getOrDefault("key-name")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "key-name", valid_568728
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568729 = query.getOrDefault("api-version")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "api-version", valid_568729
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

proc call*(call_568731: Call_Sign_568724; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The SIGN operation is applicable to asymmetric and symmetric keys stored in Azure Key Vault since this operation uses the private portion of the key. This operation requires the keys/sign permission.
  ## 
  let valid = call_568731.validator(path, query, header, formData, body)
  let scheme = call_568731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568731.url(scheme.get, call_568731.host, call_568731.base,
                         call_568731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568731, url, valid)

proc call*(call_568732: Call_Sign_568724; apiVersion: string; keyVersion: string;
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
  var path_568733 = newJObject()
  var query_568734 = newJObject()
  var body_568735 = newJObject()
  add(query_568734, "api-version", newJString(apiVersion))
  add(path_568733, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_568735 = parameters
  add(path_568733, "key-name", newJString(keyName))
  result = call_568732.call(path_568733, query_568734, nil, nil, body_568735)

var sign* = Call_Sign_568724(name: "sign", meth: HttpMethod.HttpPost,
                          host: "azure.local",
                          route: "/keys/{key-name}/{key-version}/sign",
                          validator: validate_Sign_568725, base: "", url: url_Sign_568726,
                          schemes: {Scheme.Https})
type
  Call_UnwrapKey_568736 = ref object of OpenApiRestCall_567667
proc url_UnwrapKey_568738(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UnwrapKey_568737(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568739 = path.getOrDefault("key-version")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "key-version", valid_568739
  var valid_568740 = path.getOrDefault("key-name")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "key-name", valid_568740
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568741 = query.getOrDefault("api-version")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "api-version", valid_568741
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

proc call*(call_568743: Call_UnwrapKey_568736; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UNWRAP operation supports decryption of a symmetric key using the target key encryption key. This operation is the reverse of the WRAP operation. The UNWRAP operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/unwrapKey permission.
  ## 
  let valid = call_568743.validator(path, query, header, formData, body)
  let scheme = call_568743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568743.url(scheme.get, call_568743.host, call_568743.base,
                         call_568743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568743, url, valid)

proc call*(call_568744: Call_UnwrapKey_568736; apiVersion: string;
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
  var path_568745 = newJObject()
  var query_568746 = newJObject()
  var body_568747 = newJObject()
  add(query_568746, "api-version", newJString(apiVersion))
  add(path_568745, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_568747 = parameters
  add(path_568745, "key-name", newJString(keyName))
  result = call_568744.call(path_568745, query_568746, nil, nil, body_568747)

var unwrapKey* = Call_UnwrapKey_568736(name: "unwrapKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/keys/{key-name}/{key-version}/unwrapkey",
                                    validator: validate_UnwrapKey_568737,
                                    base: "", url: url_UnwrapKey_568738,
                                    schemes: {Scheme.Https})
type
  Call_Verify_568748 = ref object of OpenApiRestCall_567667
proc url_Verify_568750(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Verify_568749(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568751 = path.getOrDefault("key-version")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "key-version", valid_568751
  var valid_568752 = path.getOrDefault("key-name")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "key-name", valid_568752
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568753 = query.getOrDefault("api-version")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "api-version", valid_568753
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

proc call*(call_568755: Call_Verify_568748; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The VERIFY operation is applicable to symmetric keys stored in Azure Key Vault. VERIFY is not strictly necessary for asymmetric keys stored in Azure Key Vault since signature verification can be performed using the public portion of the key but this operation is supported as a convenience for callers that only have a key-reference and not the public portion of the key. This operation requires the keys/verify permission.
  ## 
  let valid = call_568755.validator(path, query, header, formData, body)
  let scheme = call_568755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568755.url(scheme.get, call_568755.host, call_568755.base,
                         call_568755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568755, url, valid)

proc call*(call_568756: Call_Verify_568748; apiVersion: string; keyVersion: string;
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
  var path_568757 = newJObject()
  var query_568758 = newJObject()
  var body_568759 = newJObject()
  add(query_568758, "api-version", newJString(apiVersion))
  add(path_568757, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_568759 = parameters
  add(path_568757, "key-name", newJString(keyName))
  result = call_568756.call(path_568757, query_568758, nil, nil, body_568759)

var verify* = Call_Verify_568748(name: "verify", meth: HttpMethod.HttpPost,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}/verify",
                              validator: validate_Verify_568749, base: "",
                              url: url_Verify_568750, schemes: {Scheme.Https})
type
  Call_WrapKey_568760 = ref object of OpenApiRestCall_567667
proc url_WrapKey_568762(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_WrapKey_568761(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568763 = path.getOrDefault("key-version")
  valid_568763 = validateParameter(valid_568763, JString, required = true,
                                 default = nil)
  if valid_568763 != nil:
    section.add "key-version", valid_568763
  var valid_568764 = path.getOrDefault("key-name")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "key-name", valid_568764
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568765 = query.getOrDefault("api-version")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "api-version", valid_568765
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

proc call*(call_568767: Call_WrapKey_568760; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The WRAP operation supports encryption of a symmetric key using a key encryption key that has previously been stored in an Azure Key Vault. The WRAP operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using the public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/wrapKey permission.
  ## 
  let valid = call_568767.validator(path, query, header, formData, body)
  let scheme = call_568767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568767.url(scheme.get, call_568767.host, call_568767.base,
                         call_568767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568767, url, valid)

proc call*(call_568768: Call_WrapKey_568760; apiVersion: string; keyVersion: string;
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
  var path_568769 = newJObject()
  var query_568770 = newJObject()
  var body_568771 = newJObject()
  add(query_568770, "api-version", newJString(apiVersion))
  add(path_568769, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_568771 = parameters
  add(path_568769, "key-name", newJString(keyName))
  result = call_568768.call(path_568769, query_568770, nil, nil, body_568771)

var wrapKey* = Call_WrapKey_568760(name: "wrapKey", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/wrapkey",
                                validator: validate_WrapKey_568761, base: "",
                                url: url_WrapKey_568762, schemes: {Scheme.Https})
type
  Call_GetSecrets_568772 = ref object of OpenApiRestCall_567667
proc url_GetSecrets_568774(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetSecrets_568773(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568775 = query.getOrDefault("api-version")
  valid_568775 = validateParameter(valid_568775, JString, required = true,
                                 default = nil)
  if valid_568775 != nil:
    section.add "api-version", valid_568775
  var valid_568776 = query.getOrDefault("maxresults")
  valid_568776 = validateParameter(valid_568776, JInt, required = false, default = nil)
  if valid_568776 != nil:
    section.add "maxresults", valid_568776
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568777: Call_GetSecrets_568772; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Secrets operation is applicable to the entire vault. However, only the base secret identifier and its attributes are provided in the response. Individual secret versions are not listed in the response. This operation requires the secrets/list permission.
  ## 
  let valid = call_568777.validator(path, query, header, formData, body)
  let scheme = call_568777.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568777.url(scheme.get, call_568777.host, call_568777.base,
                         call_568777.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568777, url, valid)

proc call*(call_568778: Call_GetSecrets_568772; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getSecrets
  ## The Get Secrets operation is applicable to the entire vault. However, only the base secret identifier and its attributes are provided in the response. Individual secret versions are not listed in the response. This operation requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  var query_568779 = newJObject()
  add(query_568779, "api-version", newJString(apiVersion))
  add(query_568779, "maxresults", newJInt(maxresults))
  result = call_568778.call(nil, query_568779, nil, nil, nil)

var getSecrets* = Call_GetSecrets_568772(name: "getSecrets",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/secrets",
                                      validator: validate_GetSecrets_568773,
                                      base: "", url: url_GetSecrets_568774,
                                      schemes: {Scheme.Https})
type
  Call_RestoreSecret_568780 = ref object of OpenApiRestCall_567667
proc url_RestoreSecret_568782(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreSecret_568781(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568783 = query.getOrDefault("api-version")
  valid_568783 = validateParameter(valid_568783, JString, required = true,
                                 default = nil)
  if valid_568783 != nil:
    section.add "api-version", valid_568783
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

proc call*(call_568785: Call_RestoreSecret_568780; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backed up secret, and all its versions, to a vault. This operation requires the secrets/restore permission.
  ## 
  let valid = call_568785.validator(path, query, header, formData, body)
  let scheme = call_568785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568785.url(scheme.get, call_568785.host, call_568785.base,
                         call_568785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568785, url, valid)

proc call*(call_568786: Call_RestoreSecret_568780; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreSecret
  ## Restores a backed up secret, and all its versions, to a vault. This operation requires the secrets/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the secret.
  var query_568787 = newJObject()
  var body_568788 = newJObject()
  add(query_568787, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568788 = parameters
  result = call_568786.call(nil, query_568787, nil, nil, body_568788)

var restoreSecret* = Call_RestoreSecret_568780(name: "restoreSecret",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/secrets/restore",
    validator: validate_RestoreSecret_568781, base: "", url: url_RestoreSecret_568782,
    schemes: {Scheme.Https})
type
  Call_SetSecret_568789 = ref object of OpenApiRestCall_567667
proc url_SetSecret_568791(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SetSecret_568790(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568792 = path.getOrDefault("secret-name")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "secret-name", valid_568792
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568793 = query.getOrDefault("api-version")
  valid_568793 = validateParameter(valid_568793, JString, required = true,
                                 default = nil)
  if valid_568793 != nil:
    section.add "api-version", valid_568793
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

proc call*(call_568795: Call_SetSecret_568789; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ##  The SET operation adds a secret to the Azure Key Vault. If the named secret already exists, Azure Key Vault creates a new version of that secret. This operation requires the secrets/set permission.
  ## 
  let valid = call_568795.validator(path, query, header, formData, body)
  let scheme = call_568795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568795.url(scheme.get, call_568795.host, call_568795.base,
                         call_568795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568795, url, valid)

proc call*(call_568796: Call_SetSecret_568789; apiVersion: string;
          secretName: string; parameters: JsonNode): Recallable =
  ## setSecret
  ##  The SET operation adds a secret to the Azure Key Vault. If the named secret already exists, Azure Key Vault creates a new version of that secret. This operation requires the secrets/set permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  ##   parameters: JObject (required)
  ##             : The parameters for setting the secret.
  var path_568797 = newJObject()
  var query_568798 = newJObject()
  var body_568799 = newJObject()
  add(query_568798, "api-version", newJString(apiVersion))
  add(path_568797, "secret-name", newJString(secretName))
  if parameters != nil:
    body_568799 = parameters
  result = call_568796.call(path_568797, query_568798, nil, nil, body_568799)

var setSecret* = Call_SetSecret_568789(name: "setSecret", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/secrets/{secret-name}",
                                    validator: validate_SetSecret_568790,
                                    base: "", url: url_SetSecret_568791,
                                    schemes: {Scheme.Https})
type
  Call_DeleteSecret_568800 = ref object of OpenApiRestCall_567667
proc url_DeleteSecret_568802(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteSecret_568801(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568803 = path.getOrDefault("secret-name")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "secret-name", valid_568803
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568804 = query.getOrDefault("api-version")
  valid_568804 = validateParameter(valid_568804, JString, required = true,
                                 default = nil)
  if valid_568804 != nil:
    section.add "api-version", valid_568804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568805: Call_DeleteSecret_568800; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DELETE operation applies to any secret stored in Azure Key Vault. DELETE cannot be applied to an individual version of a secret. This operation requires the secrets/delete permission.
  ## 
  let valid = call_568805.validator(path, query, header, formData, body)
  let scheme = call_568805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568805.url(scheme.get, call_568805.host, call_568805.base,
                         call_568805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568805, url, valid)

proc call*(call_568806: Call_DeleteSecret_568800; apiVersion: string;
          secretName: string): Recallable =
  ## deleteSecret
  ## The DELETE operation applies to any secret stored in Azure Key Vault. DELETE cannot be applied to an individual version of a secret. This operation requires the secrets/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_568807 = newJObject()
  var query_568808 = newJObject()
  add(query_568808, "api-version", newJString(apiVersion))
  add(path_568807, "secret-name", newJString(secretName))
  result = call_568806.call(path_568807, query_568808, nil, nil, nil)

var deleteSecret* = Call_DeleteSecret_568800(name: "deleteSecret",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/secrets/{secret-name}", validator: validate_DeleteSecret_568801,
    base: "", url: url_DeleteSecret_568802, schemes: {Scheme.Https})
type
  Call_BackupSecret_568809 = ref object of OpenApiRestCall_567667
proc url_BackupSecret_568811(protocol: Scheme; host: string; base: string;
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

proc validate_BackupSecret_568810(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568812 = path.getOrDefault("secret-name")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "secret-name", valid_568812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568813 = query.getOrDefault("api-version")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "api-version", valid_568813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568814: Call_BackupSecret_568809; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified secret be downloaded to the client. All versions of the secret will be downloaded. This operation requires the secrets/backup permission.
  ## 
  let valid = call_568814.validator(path, query, header, formData, body)
  let scheme = call_568814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568814.url(scheme.get, call_568814.host, call_568814.base,
                         call_568814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568814, url, valid)

proc call*(call_568815: Call_BackupSecret_568809; apiVersion: string;
          secretName: string): Recallable =
  ## backupSecret
  ## Requests that a backup of the specified secret be downloaded to the client. All versions of the secret will be downloaded. This operation requires the secrets/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_568816 = newJObject()
  var query_568817 = newJObject()
  add(query_568817, "api-version", newJString(apiVersion))
  add(path_568816, "secret-name", newJString(secretName))
  result = call_568815.call(path_568816, query_568817, nil, nil, nil)

var backupSecret* = Call_BackupSecret_568809(name: "backupSecret",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/secrets/{secret-name}/backup", validator: validate_BackupSecret_568810,
    base: "", url: url_BackupSecret_568811, schemes: {Scheme.Https})
type
  Call_GetSecretVersions_568818 = ref object of OpenApiRestCall_567667
proc url_GetSecretVersions_568820(protocol: Scheme; host: string; base: string;
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

proc validate_GetSecretVersions_568819(path: JsonNode; query: JsonNode;
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
  var valid_568821 = path.getOrDefault("secret-name")
  valid_568821 = validateParameter(valid_568821, JString, required = true,
                                 default = nil)
  if valid_568821 != nil:
    section.add "secret-name", valid_568821
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568822 = query.getOrDefault("api-version")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = nil)
  if valid_568822 != nil:
    section.add "api-version", valid_568822
  var valid_568823 = query.getOrDefault("maxresults")
  valid_568823 = validateParameter(valid_568823, JInt, required = false, default = nil)
  if valid_568823 != nil:
    section.add "maxresults", valid_568823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568824: Call_GetSecretVersions_568818; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The full secret identifier and attributes are provided in the response. No values are returned for the secrets. This operations requires the secrets/list permission.
  ## 
  let valid = call_568824.validator(path, query, header, formData, body)
  let scheme = call_568824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568824.url(scheme.get, call_568824.host, call_568824.base,
                         call_568824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568824, url, valid)

proc call*(call_568825: Call_GetSecretVersions_568818; apiVersion: string;
          secretName: string; maxresults: int = 0): Recallable =
  ## getSecretVersions
  ## The full secret identifier and attributes are provided in the response. No values are returned for the secrets. This operations requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_568826 = newJObject()
  var query_568827 = newJObject()
  add(query_568827, "api-version", newJString(apiVersion))
  add(query_568827, "maxresults", newJInt(maxresults))
  add(path_568826, "secret-name", newJString(secretName))
  result = call_568825.call(path_568826, query_568827, nil, nil, nil)

var getSecretVersions* = Call_GetSecretVersions_568818(name: "getSecretVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/secrets/{secret-name}/versions",
    validator: validate_GetSecretVersions_568819, base: "",
    url: url_GetSecretVersions_568820, schemes: {Scheme.Https})
type
  Call_GetSecret_568828 = ref object of OpenApiRestCall_567667
proc url_GetSecret_568830(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetSecret_568829(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568831 = path.getOrDefault("secret-version")
  valid_568831 = validateParameter(valid_568831, JString, required = true,
                                 default = nil)
  if valid_568831 != nil:
    section.add "secret-version", valid_568831
  var valid_568832 = path.getOrDefault("secret-name")
  valid_568832 = validateParameter(valid_568832, JString, required = true,
                                 default = nil)
  if valid_568832 != nil:
    section.add "secret-name", valid_568832
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568833 = query.getOrDefault("api-version")
  valid_568833 = validateParameter(valid_568833, JString, required = true,
                                 default = nil)
  if valid_568833 != nil:
    section.add "api-version", valid_568833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568834: Call_GetSecret_568828; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GET operation is applicable to any secret stored in Azure Key Vault. This operation requires the secrets/get permission.
  ## 
  let valid = call_568834.validator(path, query, header, formData, body)
  let scheme = call_568834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568834.url(scheme.get, call_568834.host, call_568834.base,
                         call_568834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568834, url, valid)

proc call*(call_568835: Call_GetSecret_568828; apiVersion: string;
          secretVersion: string; secretName: string): Recallable =
  ## getSecret
  ## The GET operation is applicable to any secret stored in Azure Key Vault. This operation requires the secrets/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretVersion: string (required)
  ##                : The version of the secret.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_568836 = newJObject()
  var query_568837 = newJObject()
  add(query_568837, "api-version", newJString(apiVersion))
  add(path_568836, "secret-version", newJString(secretVersion))
  add(path_568836, "secret-name", newJString(secretName))
  result = call_568835.call(path_568836, query_568837, nil, nil, nil)

var getSecret* = Call_GetSecret_568828(name: "getSecret", meth: HttpMethod.HttpGet,
                                    host: "azure.local", route: "/secrets/{secret-name}/{secret-version}",
                                    validator: validate_GetSecret_568829,
                                    base: "", url: url_GetSecret_568830,
                                    schemes: {Scheme.Https})
type
  Call_UpdateSecret_568838 = ref object of OpenApiRestCall_567667
proc url_UpdateSecret_568840(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateSecret_568839(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568841 = path.getOrDefault("secret-version")
  valid_568841 = validateParameter(valid_568841, JString, required = true,
                                 default = nil)
  if valid_568841 != nil:
    section.add "secret-version", valid_568841
  var valid_568842 = path.getOrDefault("secret-name")
  valid_568842 = validateParameter(valid_568842, JString, required = true,
                                 default = nil)
  if valid_568842 != nil:
    section.add "secret-name", valid_568842
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568843 = query.getOrDefault("api-version")
  valid_568843 = validateParameter(valid_568843, JString, required = true,
                                 default = nil)
  if valid_568843 != nil:
    section.add "api-version", valid_568843
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

proc call*(call_568845: Call_UpdateSecret_568838; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UPDATE operation changes specified attributes of an existing stored secret. Attributes that are not specified in the request are left unchanged. The value of a secret itself cannot be changed. This operation requires the secrets/set permission.
  ## 
  let valid = call_568845.validator(path, query, header, formData, body)
  let scheme = call_568845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568845.url(scheme.get, call_568845.host, call_568845.base,
                         call_568845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568845, url, valid)

proc call*(call_568846: Call_UpdateSecret_568838; apiVersion: string;
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
  var path_568847 = newJObject()
  var query_568848 = newJObject()
  var body_568849 = newJObject()
  add(query_568848, "api-version", newJString(apiVersion))
  add(path_568847, "secret-version", newJString(secretVersion))
  add(path_568847, "secret-name", newJString(secretName))
  if parameters != nil:
    body_568849 = parameters
  result = call_568846.call(path_568847, query_568848, nil, nil, body_568849)

var updateSecret* = Call_UpdateSecret_568838(name: "updateSecret",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/secrets/{secret-name}/{secret-version}",
    validator: validate_UpdateSecret_568839, base: "", url: url_UpdateSecret_568840,
    schemes: {Scheme.Https})
type
  Call_GetStorageAccounts_568850 = ref object of OpenApiRestCall_567667
proc url_GetStorageAccounts_568852(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetStorageAccounts_568851(path: JsonNode; query: JsonNode;
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
  var valid_568853 = query.getOrDefault("api-version")
  valid_568853 = validateParameter(valid_568853, JString, required = true,
                                 default = nil)
  if valid_568853 != nil:
    section.add "api-version", valid_568853
  var valid_568854 = query.getOrDefault("maxresults")
  valid_568854 = validateParameter(valid_568854, JInt, required = false, default = nil)
  if valid_568854 != nil:
    section.add "maxresults", valid_568854
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568855: Call_GetStorageAccounts_568850; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List storage accounts managed by the specified key vault. This operation requires the storage/list permission.
  ## 
  let valid = call_568855.validator(path, query, header, formData, body)
  let scheme = call_568855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568855.url(scheme.get, call_568855.host, call_568855.base,
                         call_568855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568855, url, valid)

proc call*(call_568856: Call_GetStorageAccounts_568850; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getStorageAccounts
  ## List storage accounts managed by the specified key vault. This operation requires the storage/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_568857 = newJObject()
  add(query_568857, "api-version", newJString(apiVersion))
  add(query_568857, "maxresults", newJInt(maxresults))
  result = call_568856.call(nil, query_568857, nil, nil, nil)

var getStorageAccounts* = Call_GetStorageAccounts_568850(
    name: "getStorageAccounts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage", validator: validate_GetStorageAccounts_568851, base: "",
    url: url_GetStorageAccounts_568852, schemes: {Scheme.Https})
type
  Call_RestoreStorageAccount_568858 = ref object of OpenApiRestCall_567667
proc url_RestoreStorageAccount_568860(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreStorageAccount_568859(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores a backed up storage account to a vault. This operation requires the storage/restore permission.
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
  var valid_568861 = query.getOrDefault("api-version")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "api-version", valid_568861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to restore the storage account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568863: Call_RestoreStorageAccount_568858; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backed up storage account to a vault. This operation requires the storage/restore permission.
  ## 
  let valid = call_568863.validator(path, query, header, formData, body)
  let scheme = call_568863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568863.url(scheme.get, call_568863.host, call_568863.base,
                         call_568863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568863, url, valid)

proc call*(call_568864: Call_RestoreStorageAccount_568858; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreStorageAccount
  ## Restores a backed up storage account to a vault. This operation requires the storage/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the storage account.
  var query_568865 = newJObject()
  var body_568866 = newJObject()
  add(query_568865, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568866 = parameters
  result = call_568864.call(nil, query_568865, nil, nil, body_568866)

var restoreStorageAccount* = Call_RestoreStorageAccount_568858(
    name: "restoreStorageAccount", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/storage/restore", validator: validate_RestoreStorageAccount_568859,
    base: "", url: url_RestoreStorageAccount_568860, schemes: {Scheme.Https})
type
  Call_SetStorageAccount_568876 = ref object of OpenApiRestCall_567667
proc url_SetStorageAccount_568878(protocol: Scheme; host: string; base: string;
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

proc validate_SetStorageAccount_568877(path: JsonNode; query: JsonNode;
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
  var valid_568879 = path.getOrDefault("storage-account-name")
  valid_568879 = validateParameter(valid_568879, JString, required = true,
                                 default = nil)
  if valid_568879 != nil:
    section.add "storage-account-name", valid_568879
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568880 = query.getOrDefault("api-version")
  valid_568880 = validateParameter(valid_568880, JString, required = true,
                                 default = nil)
  if valid_568880 != nil:
    section.add "api-version", valid_568880
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

proc call*(call_568882: Call_SetStorageAccount_568876; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new storage account. This operation requires the storage/set permission.
  ## 
  let valid = call_568882.validator(path, query, header, formData, body)
  let scheme = call_568882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568882.url(scheme.get, call_568882.host, call_568882.base,
                         call_568882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568882, url, valid)

proc call*(call_568883: Call_SetStorageAccount_568876; apiVersion: string;
          storageAccountName: string; parameters: JsonNode): Recallable =
  ## setStorageAccount
  ## Creates or updates a new storage account. This operation requires the storage/set permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to create a storage account.
  var path_568884 = newJObject()
  var query_568885 = newJObject()
  var body_568886 = newJObject()
  add(query_568885, "api-version", newJString(apiVersion))
  add(path_568884, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_568886 = parameters
  result = call_568883.call(path_568884, query_568885, nil, nil, body_568886)

var setStorageAccount* = Call_SetStorageAccount_568876(name: "setStorageAccount",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_SetStorageAccount_568877, base: "",
    url: url_SetStorageAccount_568878, schemes: {Scheme.Https})
type
  Call_GetStorageAccount_568867 = ref object of OpenApiRestCall_567667
proc url_GetStorageAccount_568869(protocol: Scheme; host: string; base: string;
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

proc validate_GetStorageAccount_568868(path: JsonNode; query: JsonNode;
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
  var valid_568870 = path.getOrDefault("storage-account-name")
  valid_568870 = validateParameter(valid_568870, JString, required = true,
                                 default = nil)
  if valid_568870 != nil:
    section.add "storage-account-name", valid_568870
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568871 = query.getOrDefault("api-version")
  valid_568871 = validateParameter(valid_568871, JString, required = true,
                                 default = nil)
  if valid_568871 != nil:
    section.add "api-version", valid_568871
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568872: Call_GetStorageAccount_568867; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specified storage account. This operation requires the storage/get permission.
  ## 
  let valid = call_568872.validator(path, query, header, formData, body)
  let scheme = call_568872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568872.url(scheme.get, call_568872.host, call_568872.base,
                         call_568872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568872, url, valid)

proc call*(call_568873: Call_GetStorageAccount_568867; apiVersion: string;
          storageAccountName: string): Recallable =
  ## getStorageAccount
  ## Gets information about a specified storage account. This operation requires the storage/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_568874 = newJObject()
  var query_568875 = newJObject()
  add(query_568875, "api-version", newJString(apiVersion))
  add(path_568874, "storage-account-name", newJString(storageAccountName))
  result = call_568873.call(path_568874, query_568875, nil, nil, nil)

var getStorageAccount* = Call_GetStorageAccount_568867(name: "getStorageAccount",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_GetStorageAccount_568868, base: "",
    url: url_GetStorageAccount_568869, schemes: {Scheme.Https})
type
  Call_UpdateStorageAccount_568896 = ref object of OpenApiRestCall_567667
proc url_UpdateStorageAccount_568898(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateStorageAccount_568897(path: JsonNode; query: JsonNode;
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
  var valid_568899 = path.getOrDefault("storage-account-name")
  valid_568899 = validateParameter(valid_568899, JString, required = true,
                                 default = nil)
  if valid_568899 != nil:
    section.add "storage-account-name", valid_568899
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568900 = query.getOrDefault("api-version")
  valid_568900 = validateParameter(valid_568900, JString, required = true,
                                 default = nil)
  if valid_568900 != nil:
    section.add "api-version", valid_568900
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

proc call*(call_568902: Call_UpdateStorageAccount_568896; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified attributes associated with the given storage account. This operation requires the storage/set/update permission.
  ## 
  let valid = call_568902.validator(path, query, header, formData, body)
  let scheme = call_568902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568902.url(scheme.get, call_568902.host, call_568902.base,
                         call_568902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568902, url, valid)

proc call*(call_568903: Call_UpdateStorageAccount_568896; apiVersion: string;
          storageAccountName: string; parameters: JsonNode): Recallable =
  ## updateStorageAccount
  ## Updates the specified attributes associated with the given storage account. This operation requires the storage/set/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to update a storage account.
  var path_568904 = newJObject()
  var query_568905 = newJObject()
  var body_568906 = newJObject()
  add(query_568905, "api-version", newJString(apiVersion))
  add(path_568904, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_568906 = parameters
  result = call_568903.call(path_568904, query_568905, nil, nil, body_568906)

var updateStorageAccount* = Call_UpdateStorageAccount_568896(
    name: "updateStorageAccount", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_UpdateStorageAccount_568897, base: "",
    url: url_UpdateStorageAccount_568898, schemes: {Scheme.Https})
type
  Call_DeleteStorageAccount_568887 = ref object of OpenApiRestCall_567667
proc url_DeleteStorageAccount_568889(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteStorageAccount_568888(path: JsonNode; query: JsonNode;
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
  var valid_568890 = path.getOrDefault("storage-account-name")
  valid_568890 = validateParameter(valid_568890, JString, required = true,
                                 default = nil)
  if valid_568890 != nil:
    section.add "storage-account-name", valid_568890
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568891 = query.getOrDefault("api-version")
  valid_568891 = validateParameter(valid_568891, JString, required = true,
                                 default = nil)
  if valid_568891 != nil:
    section.add "api-version", valid_568891
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568892: Call_DeleteStorageAccount_568887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a storage account. This operation requires the storage/delete permission.
  ## 
  let valid = call_568892.validator(path, query, header, formData, body)
  let scheme = call_568892.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568892.url(scheme.get, call_568892.host, call_568892.base,
                         call_568892.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568892, url, valid)

proc call*(call_568893: Call_DeleteStorageAccount_568887; apiVersion: string;
          storageAccountName: string): Recallable =
  ## deleteStorageAccount
  ## Deletes a storage account. This operation requires the storage/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_568894 = newJObject()
  var query_568895 = newJObject()
  add(query_568895, "api-version", newJString(apiVersion))
  add(path_568894, "storage-account-name", newJString(storageAccountName))
  result = call_568893.call(path_568894, query_568895, nil, nil, nil)

var deleteStorageAccount* = Call_DeleteStorageAccount_568887(
    name: "deleteStorageAccount", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_DeleteStorageAccount_568888, base: "",
    url: url_DeleteStorageAccount_568889, schemes: {Scheme.Https})
type
  Call_BackupStorageAccount_568907 = ref object of OpenApiRestCall_567667
proc url_BackupStorageAccount_568909(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupStorageAccount_568908(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests that a backup of the specified storage account be downloaded to the client. This operation requires the storage/backup permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   storage-account-name: JString (required)
  ##                       : The name of the storage account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `storage-account-name` field"
  var valid_568910 = path.getOrDefault("storage-account-name")
  valid_568910 = validateParameter(valid_568910, JString, required = true,
                                 default = nil)
  if valid_568910 != nil:
    section.add "storage-account-name", valid_568910
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568911 = query.getOrDefault("api-version")
  valid_568911 = validateParameter(valid_568911, JString, required = true,
                                 default = nil)
  if valid_568911 != nil:
    section.add "api-version", valid_568911
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568912: Call_BackupStorageAccount_568907; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified storage account be downloaded to the client. This operation requires the storage/backup permission.
  ## 
  let valid = call_568912.validator(path, query, header, formData, body)
  let scheme = call_568912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568912.url(scheme.get, call_568912.host, call_568912.base,
                         call_568912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568912, url, valid)

proc call*(call_568913: Call_BackupStorageAccount_568907; apiVersion: string;
          storageAccountName: string): Recallable =
  ## backupStorageAccount
  ## Requests that a backup of the specified storage account be downloaded to the client. This operation requires the storage/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_568914 = newJObject()
  var query_568915 = newJObject()
  add(query_568915, "api-version", newJString(apiVersion))
  add(path_568914, "storage-account-name", newJString(storageAccountName))
  result = call_568913.call(path_568914, query_568915, nil, nil, nil)

var backupStorageAccount* = Call_BackupStorageAccount_568907(
    name: "backupStorageAccount", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/storage/{storage-account-name}/backup",
    validator: validate_BackupStorageAccount_568908, base: "",
    url: url_BackupStorageAccount_568909, schemes: {Scheme.Https})
type
  Call_RegenerateStorageAccountKey_568916 = ref object of OpenApiRestCall_567667
proc url_RegenerateStorageAccountKey_568918(protocol: Scheme; host: string;
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

proc validate_RegenerateStorageAccountKey_568917(path: JsonNode; query: JsonNode;
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
  var valid_568919 = path.getOrDefault("storage-account-name")
  valid_568919 = validateParameter(valid_568919, JString, required = true,
                                 default = nil)
  if valid_568919 != nil:
    section.add "storage-account-name", valid_568919
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568920 = query.getOrDefault("api-version")
  valid_568920 = validateParameter(valid_568920, JString, required = true,
                                 default = nil)
  if valid_568920 != nil:
    section.add "api-version", valid_568920
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

proc call*(call_568922: Call_RegenerateStorageAccountKey_568916; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the specified key value for the given storage account. This operation requires the storage/regeneratekey permission.
  ## 
  let valid = call_568922.validator(path, query, header, formData, body)
  let scheme = call_568922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568922.url(scheme.get, call_568922.host, call_568922.base,
                         call_568922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568922, url, valid)

proc call*(call_568923: Call_RegenerateStorageAccountKey_568916;
          apiVersion: string; storageAccountName: string; parameters: JsonNode): Recallable =
  ## regenerateStorageAccountKey
  ## Regenerates the specified key value for the given storage account. This operation requires the storage/regeneratekey permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to regenerate storage account key.
  var path_568924 = newJObject()
  var query_568925 = newJObject()
  var body_568926 = newJObject()
  add(query_568925, "api-version", newJString(apiVersion))
  add(path_568924, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_568926 = parameters
  result = call_568923.call(path_568924, query_568925, nil, nil, body_568926)

var regenerateStorageAccountKey* = Call_RegenerateStorageAccountKey_568916(
    name: "regenerateStorageAccountKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/storage/{storage-account-name}/regeneratekey",
    validator: validate_RegenerateStorageAccountKey_568917, base: "",
    url: url_RegenerateStorageAccountKey_568918, schemes: {Scheme.Https})
type
  Call_GetSasDefinitions_568927 = ref object of OpenApiRestCall_567667
proc url_GetSasDefinitions_568929(protocol: Scheme; host: string; base: string;
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

proc validate_GetSasDefinitions_568928(path: JsonNode; query: JsonNode;
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
  var valid_568930 = path.getOrDefault("storage-account-name")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = nil)
  if valid_568930 != nil:
    section.add "storage-account-name", valid_568930
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568931 = query.getOrDefault("api-version")
  valid_568931 = validateParameter(valid_568931, JString, required = true,
                                 default = nil)
  if valid_568931 != nil:
    section.add "api-version", valid_568931
  var valid_568932 = query.getOrDefault("maxresults")
  valid_568932 = validateParameter(valid_568932, JInt, required = false, default = nil)
  if valid_568932 != nil:
    section.add "maxresults", valid_568932
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568933: Call_GetSasDefinitions_568927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List storage SAS definitions for the given storage account. This operation requires the storage/listsas permission.
  ## 
  let valid = call_568933.validator(path, query, header, formData, body)
  let scheme = call_568933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568933.url(scheme.get, call_568933.host, call_568933.base,
                         call_568933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568933, url, valid)

proc call*(call_568934: Call_GetSasDefinitions_568927; apiVersion: string;
          storageAccountName: string; maxresults: int = 0): Recallable =
  ## getSasDefinitions
  ## List storage SAS definitions for the given storage account. This operation requires the storage/listsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_568935 = newJObject()
  var query_568936 = newJObject()
  add(query_568936, "api-version", newJString(apiVersion))
  add(query_568936, "maxresults", newJInt(maxresults))
  add(path_568935, "storage-account-name", newJString(storageAccountName))
  result = call_568934.call(path_568935, query_568936, nil, nil, nil)

var getSasDefinitions* = Call_GetSasDefinitions_568927(name: "getSasDefinitions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}/sas",
    validator: validate_GetSasDefinitions_568928, base: "",
    url: url_GetSasDefinitions_568929, schemes: {Scheme.Https})
type
  Call_SetSasDefinition_568947 = ref object of OpenApiRestCall_567667
proc url_SetSasDefinition_568949(protocol: Scheme; host: string; base: string;
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

proc validate_SetSasDefinition_568948(path: JsonNode; query: JsonNode;
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
  var valid_568950 = path.getOrDefault("storage-account-name")
  valid_568950 = validateParameter(valid_568950, JString, required = true,
                                 default = nil)
  if valid_568950 != nil:
    section.add "storage-account-name", valid_568950
  var valid_568951 = path.getOrDefault("sas-definition-name")
  valid_568951 = validateParameter(valid_568951, JString, required = true,
                                 default = nil)
  if valid_568951 != nil:
    section.add "sas-definition-name", valid_568951
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568952 = query.getOrDefault("api-version")
  valid_568952 = validateParameter(valid_568952, JString, required = true,
                                 default = nil)
  if valid_568952 != nil:
    section.add "api-version", valid_568952
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

proc call*(call_568954: Call_SetSasDefinition_568947; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new SAS definition for the specified storage account. This operation requires the storage/setsas permission.
  ## 
  let valid = call_568954.validator(path, query, header, formData, body)
  let scheme = call_568954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568954.url(scheme.get, call_568954.host, call_568954.base,
                         call_568954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568954, url, valid)

proc call*(call_568955: Call_SetSasDefinition_568947; apiVersion: string;
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
  var path_568956 = newJObject()
  var query_568957 = newJObject()
  var body_568958 = newJObject()
  add(query_568957, "api-version", newJString(apiVersion))
  add(path_568956, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_568958 = parameters
  add(path_568956, "sas-definition-name", newJString(sasDefinitionName))
  result = call_568955.call(path_568956, query_568957, nil, nil, body_568958)

var setSasDefinition* = Call_SetSasDefinition_568947(name: "setSasDefinition",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_SetSasDefinition_568948, base: "",
    url: url_SetSasDefinition_568949, schemes: {Scheme.Https})
type
  Call_GetSasDefinition_568937 = ref object of OpenApiRestCall_567667
proc url_GetSasDefinition_568939(protocol: Scheme; host: string; base: string;
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

proc validate_GetSasDefinition_568938(path: JsonNode; query: JsonNode;
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
  var valid_568940 = path.getOrDefault("storage-account-name")
  valid_568940 = validateParameter(valid_568940, JString, required = true,
                                 default = nil)
  if valid_568940 != nil:
    section.add "storage-account-name", valid_568940
  var valid_568941 = path.getOrDefault("sas-definition-name")
  valid_568941 = validateParameter(valid_568941, JString, required = true,
                                 default = nil)
  if valid_568941 != nil:
    section.add "sas-definition-name", valid_568941
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568942 = query.getOrDefault("api-version")
  valid_568942 = validateParameter(valid_568942, JString, required = true,
                                 default = nil)
  if valid_568942 != nil:
    section.add "api-version", valid_568942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568943: Call_GetSasDefinition_568937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a SAS definition for the specified storage account. This operation requires the storage/getsas permission.
  ## 
  let valid = call_568943.validator(path, query, header, formData, body)
  let scheme = call_568943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568943.url(scheme.get, call_568943.host, call_568943.base,
                         call_568943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568943, url, valid)

proc call*(call_568944: Call_GetSasDefinition_568937; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## getSasDefinition
  ## Gets information about a SAS definition for the specified storage account. This operation requires the storage/getsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_568945 = newJObject()
  var query_568946 = newJObject()
  add(query_568946, "api-version", newJString(apiVersion))
  add(path_568945, "storage-account-name", newJString(storageAccountName))
  add(path_568945, "sas-definition-name", newJString(sasDefinitionName))
  result = call_568944.call(path_568945, query_568946, nil, nil, nil)

var getSasDefinition* = Call_GetSasDefinition_568937(name: "getSasDefinition",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_GetSasDefinition_568938, base: "",
    url: url_GetSasDefinition_568939, schemes: {Scheme.Https})
type
  Call_UpdateSasDefinition_568969 = ref object of OpenApiRestCall_567667
proc url_UpdateSasDefinition_568971(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateSasDefinition_568970(path: JsonNode; query: JsonNode;
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
  var valid_568972 = path.getOrDefault("storage-account-name")
  valid_568972 = validateParameter(valid_568972, JString, required = true,
                                 default = nil)
  if valid_568972 != nil:
    section.add "storage-account-name", valid_568972
  var valid_568973 = path.getOrDefault("sas-definition-name")
  valid_568973 = validateParameter(valid_568973, JString, required = true,
                                 default = nil)
  if valid_568973 != nil:
    section.add "sas-definition-name", valid_568973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568974 = query.getOrDefault("api-version")
  valid_568974 = validateParameter(valid_568974, JString, required = true,
                                 default = nil)
  if valid_568974 != nil:
    section.add "api-version", valid_568974
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

proc call*(call_568976: Call_UpdateSasDefinition_568969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified attributes associated with the given SAS definition. This operation requires the storage/setsas permission.
  ## 
  let valid = call_568976.validator(path, query, header, formData, body)
  let scheme = call_568976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568976.url(scheme.get, call_568976.host, call_568976.base,
                         call_568976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568976, url, valid)

proc call*(call_568977: Call_UpdateSasDefinition_568969; apiVersion: string;
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
  var path_568978 = newJObject()
  var query_568979 = newJObject()
  var body_568980 = newJObject()
  add(query_568979, "api-version", newJString(apiVersion))
  add(path_568978, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_568980 = parameters
  add(path_568978, "sas-definition-name", newJString(sasDefinitionName))
  result = call_568977.call(path_568978, query_568979, nil, nil, body_568980)

var updateSasDefinition* = Call_UpdateSasDefinition_568969(
    name: "updateSasDefinition", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_UpdateSasDefinition_568970, base: "",
    url: url_UpdateSasDefinition_568971, schemes: {Scheme.Https})
type
  Call_DeleteSasDefinition_568959 = ref object of OpenApiRestCall_567667
proc url_DeleteSasDefinition_568961(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteSasDefinition_568960(path: JsonNode; query: JsonNode;
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
  var valid_568962 = path.getOrDefault("storage-account-name")
  valid_568962 = validateParameter(valid_568962, JString, required = true,
                                 default = nil)
  if valid_568962 != nil:
    section.add "storage-account-name", valid_568962
  var valid_568963 = path.getOrDefault("sas-definition-name")
  valid_568963 = validateParameter(valid_568963, JString, required = true,
                                 default = nil)
  if valid_568963 != nil:
    section.add "sas-definition-name", valid_568963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568964 = query.getOrDefault("api-version")
  valid_568964 = validateParameter(valid_568964, JString, required = true,
                                 default = nil)
  if valid_568964 != nil:
    section.add "api-version", valid_568964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568965: Call_DeleteSasDefinition_568959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SAS definition from a specified storage account. This operation requires the storage/deletesas permission.
  ## 
  let valid = call_568965.validator(path, query, header, formData, body)
  let scheme = call_568965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568965.url(scheme.get, call_568965.host, call_568965.base,
                         call_568965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568965, url, valid)

proc call*(call_568966: Call_DeleteSasDefinition_568959; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## deleteSasDefinition
  ## Deletes a SAS definition from a specified storage account. This operation requires the storage/deletesas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_568967 = newJObject()
  var query_568968 = newJObject()
  add(query_568968, "api-version", newJString(apiVersion))
  add(path_568967, "storage-account-name", newJString(storageAccountName))
  add(path_568967, "sas-definition-name", newJString(sasDefinitionName))
  result = call_568966.call(path_568967, query_568968, nil, nil, nil)

var deleteSasDefinition* = Call_DeleteSasDefinition_568959(
    name: "deleteSasDefinition", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_DeleteSasDefinition_568960, base: "",
    url: url_DeleteSasDefinition_568961, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
