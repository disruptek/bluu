
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
  Call_GetCertificates_563787 = ref object of OpenApiRestCall_563565
proc url_GetCertificates_563789(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificates_563788(path: JsonNode; query: JsonNode;
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
  ##   includePending: JBool
  ##                 : Specifies whether to include certificates which are not completely provisioned.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563950 = query.getOrDefault("api-version")
  valid_563950 = validateParameter(valid_563950, JString, required = true,
                                 default = nil)
  if valid_563950 != nil:
    section.add "api-version", valid_563950
  var valid_563951 = query.getOrDefault("includePending")
  valid_563951 = validateParameter(valid_563951, JBool, required = false, default = nil)
  if valid_563951 != nil:
    section.add "includePending", valid_563951
  var valid_563952 = query.getOrDefault("maxresults")
  valid_563952 = validateParameter(valid_563952, JInt, required = false, default = nil)
  if valid_563952 != nil:
    section.add "maxresults", valid_563952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563975: Call_GetCertificates_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificates operation returns the set of certificates resources in the specified key vault. This operation requires the certificates/list permission.
  ## 
  let valid = call_563975.validator(path, query, header, formData, body)
  let scheme = call_563975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563975.url(scheme.get, call_563975.host, call_563975.base,
                         call_563975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563975, url, valid)

proc call*(call_564046: Call_GetCertificates_563787; apiVersion: string;
          includePending: bool = false; maxresults: int = 0): Recallable =
  ## getCertificates
  ## The GetCertificates operation returns the set of certificates resources in the specified key vault. This operation requires the certificates/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   includePending: bool
  ##                 : Specifies whether to include certificates which are not completely provisioned.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564047 = newJObject()
  add(query_564047, "api-version", newJString(apiVersion))
  add(query_564047, "includePending", newJBool(includePending))
  add(query_564047, "maxresults", newJInt(maxresults))
  result = call_564046.call(nil, query_564047, nil, nil, nil)

var getCertificates* = Call_GetCertificates_563787(name: "getCertificates",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates",
    validator: validate_GetCertificates_563788, base: "", url: url_GetCertificates_563789,
    schemes: {Scheme.Https})
type
  Call_SetCertificateContacts_564094 = ref object of OpenApiRestCall_563565
proc url_SetCertificateContacts_564096(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SetCertificateContacts_564095(path: JsonNode; query: JsonNode;
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
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
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

proc call*(call_564116: Call_SetCertificateContacts_564094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the certificate contacts for the specified key vault. This operation requires the certificates/managecontacts permission.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_SetCertificateContacts_564094; apiVersion: string;
          contacts: JsonNode): Recallable =
  ## setCertificateContacts
  ## Sets the certificate contacts for the specified key vault. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   contacts: JObject (required)
  ##           : The contacts for the key vault certificate.
  var query_564118 = newJObject()
  var body_564119 = newJObject()
  add(query_564118, "api-version", newJString(apiVersion))
  if contacts != nil:
    body_564119 = contacts
  result = call_564117.call(nil, query_564118, nil, nil, body_564119)

var setCertificateContacts* = Call_SetCertificateContacts_564094(
    name: "setCertificateContacts", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/certificates/contacts", validator: validate_SetCertificateContacts_564095,
    base: "", url: url_SetCertificateContacts_564096, schemes: {Scheme.Https})
type
  Call_GetCertificateContacts_564087 = ref object of OpenApiRestCall_563565
proc url_GetCertificateContacts_564089(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificateContacts_564088(path: JsonNode; query: JsonNode;
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
  var valid_564090 = query.getOrDefault("api-version")
  valid_564090 = validateParameter(valid_564090, JString, required = true,
                                 default = nil)
  if valid_564090 != nil:
    section.add "api-version", valid_564090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564091: Call_GetCertificateContacts_564087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificateContacts operation returns the set of certificate contact resources in the specified key vault. This operation requires the certificates/managecontacts permission.
  ## 
  let valid = call_564091.validator(path, query, header, formData, body)
  let scheme = call_564091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564091.url(scheme.get, call_564091.host, call_564091.base,
                         call_564091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564091, url, valid)

proc call*(call_564092: Call_GetCertificateContacts_564087; apiVersion: string): Recallable =
  ## getCertificateContacts
  ## The GetCertificateContacts operation returns the set of certificate contact resources in the specified key vault. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_564093 = newJObject()
  add(query_564093, "api-version", newJString(apiVersion))
  result = call_564092.call(nil, query_564093, nil, nil, nil)

var getCertificateContacts* = Call_GetCertificateContacts_564087(
    name: "getCertificateContacts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/contacts", validator: validate_GetCertificateContacts_564088,
    base: "", url: url_GetCertificateContacts_564089, schemes: {Scheme.Https})
type
  Call_DeleteCertificateContacts_564120 = ref object of OpenApiRestCall_563565
proc url_DeleteCertificateContacts_564122(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeleteCertificateContacts_564121(path: JsonNode; query: JsonNode;
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
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_DeleteCertificateContacts_564120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the certificate contacts for a specified key vault certificate. This operation requires the certificates/managecontacts permission.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_DeleteCertificateContacts_564120; apiVersion: string): Recallable =
  ## deleteCertificateContacts
  ## Deletes the certificate contacts for a specified key vault certificate. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_564126 = newJObject()
  add(query_564126, "api-version", newJString(apiVersion))
  result = call_564125.call(nil, query_564126, nil, nil, nil)

var deleteCertificateContacts* = Call_DeleteCertificateContacts_564120(
    name: "deleteCertificateContacts", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/contacts",
    validator: validate_DeleteCertificateContacts_564121, base: "",
    url: url_DeleteCertificateContacts_564122, schemes: {Scheme.Https})
type
  Call_GetCertificateIssuers_564127 = ref object of OpenApiRestCall_563565
proc url_GetCertificateIssuers_564129(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificateIssuers_564128(path: JsonNode; query: JsonNode;
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
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "api-version", valid_564130
  var valid_564131 = query.getOrDefault("maxresults")
  valid_564131 = validateParameter(valid_564131, JInt, required = false, default = nil)
  if valid_564131 != nil:
    section.add "maxresults", valid_564131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564132: Call_GetCertificateIssuers_564127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificateIssuers operation returns the set of certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ## 
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_GetCertificateIssuers_564127; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getCertificateIssuers
  ## The GetCertificateIssuers operation returns the set of certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564134 = newJObject()
  add(query_564134, "api-version", newJString(apiVersion))
  add(query_564134, "maxresults", newJInt(maxresults))
  result = call_564133.call(nil, query_564134, nil, nil, nil)

var getCertificateIssuers* = Call_GetCertificateIssuers_564127(
    name: "getCertificateIssuers", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/issuers", validator: validate_GetCertificateIssuers_564128,
    base: "", url: url_GetCertificateIssuers_564129, schemes: {Scheme.Https})
type
  Call_SetCertificateIssuer_564158 = ref object of OpenApiRestCall_563565
proc url_SetCertificateIssuer_564160(protocol: Scheme; host: string; base: string;
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

proc validate_SetCertificateIssuer_564159(path: JsonNode; query: JsonNode;
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
  var valid_564161 = path.getOrDefault("issuer-name")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "issuer-name", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
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

proc call*(call_564164: Call_SetCertificateIssuer_564158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The SetCertificateIssuer operation adds or updates the specified certificate issuer. This operation requires the certificates/setissuers permission.
  ## 
  let valid = call_564164.validator(path, query, header, formData, body)
  let scheme = call_564164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564164.url(scheme.get, call_564164.host, call_564164.base,
                         call_564164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564164, url, valid)

proc call*(call_564165: Call_SetCertificateIssuer_564158; apiVersion: string;
          parameter: JsonNode; issuerName: string): Recallable =
  ## setCertificateIssuer
  ## The SetCertificateIssuer operation adds or updates the specified certificate issuer. This operation requires the certificates/setissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameter: JObject (required)
  ##            : Certificate issuer set parameter.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_564166 = newJObject()
  var query_564167 = newJObject()
  var body_564168 = newJObject()
  add(query_564167, "api-version", newJString(apiVersion))
  if parameter != nil:
    body_564168 = parameter
  add(path_564166, "issuer-name", newJString(issuerName))
  result = call_564165.call(path_564166, query_564167, nil, nil, body_564168)

var setCertificateIssuer* = Call_SetCertificateIssuer_564158(
    name: "setCertificateIssuer", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/certificates/issuers/{issuer-name}",
    validator: validate_SetCertificateIssuer_564159, base: "",
    url: url_SetCertificateIssuer_564160, schemes: {Scheme.Https})
type
  Call_GetCertificateIssuer_564135 = ref object of OpenApiRestCall_563565
proc url_GetCertificateIssuer_564137(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificateIssuer_564136(path: JsonNode; query: JsonNode;
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
  var valid_564152 = path.getOrDefault("issuer-name")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "issuer-name", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564153 = query.getOrDefault("api-version")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "api-version", valid_564153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564154: Call_GetCertificateIssuer_564135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificateIssuer operation returns the specified certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ## 
  let valid = call_564154.validator(path, query, header, formData, body)
  let scheme = call_564154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564154.url(scheme.get, call_564154.host, call_564154.base,
                         call_564154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564154, url, valid)

proc call*(call_564155: Call_GetCertificateIssuer_564135; apiVersion: string;
          issuerName: string): Recallable =
  ## getCertificateIssuer
  ## The GetCertificateIssuer operation returns the specified certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_564156 = newJObject()
  var query_564157 = newJObject()
  add(query_564157, "api-version", newJString(apiVersion))
  add(path_564156, "issuer-name", newJString(issuerName))
  result = call_564155.call(path_564156, query_564157, nil, nil, nil)

var getCertificateIssuer* = Call_GetCertificateIssuer_564135(
    name: "getCertificateIssuer", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/issuers/{issuer-name}",
    validator: validate_GetCertificateIssuer_564136, base: "",
    url: url_GetCertificateIssuer_564137, schemes: {Scheme.Https})
type
  Call_UpdateCertificateIssuer_564178 = ref object of OpenApiRestCall_563565
proc url_UpdateCertificateIssuer_564180(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCertificateIssuer_564179(path: JsonNode; query: JsonNode;
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
  var valid_564181 = path.getOrDefault("issuer-name")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "issuer-name", valid_564181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564182 = query.getOrDefault("api-version")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "api-version", valid_564182
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

proc call*(call_564184: Call_UpdateCertificateIssuer_564178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UpdateCertificateIssuer operation performs an update on the specified certificate issuer entity. This operation requires the certificates/setissuers permission.
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_UpdateCertificateIssuer_564178; apiVersion: string;
          parameter: JsonNode; issuerName: string): Recallable =
  ## updateCertificateIssuer
  ## The UpdateCertificateIssuer operation performs an update on the specified certificate issuer entity. This operation requires the certificates/setissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameter: JObject (required)
  ##            : Certificate issuer update parameter.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  var body_564188 = newJObject()
  add(query_564187, "api-version", newJString(apiVersion))
  if parameter != nil:
    body_564188 = parameter
  add(path_564186, "issuer-name", newJString(issuerName))
  result = call_564185.call(path_564186, query_564187, nil, nil, body_564188)

var updateCertificateIssuer* = Call_UpdateCertificateIssuer_564178(
    name: "updateCertificateIssuer", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/issuers/{issuer-name}",
    validator: validate_UpdateCertificateIssuer_564179, base: "",
    url: url_UpdateCertificateIssuer_564180, schemes: {Scheme.Https})
type
  Call_DeleteCertificateIssuer_564169 = ref object of OpenApiRestCall_563565
proc url_DeleteCertificateIssuer_564171(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteCertificateIssuer_564170(path: JsonNode; query: JsonNode;
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
  var valid_564172 = path.getOrDefault("issuer-name")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "issuer-name", valid_564172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "api-version", valid_564173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564174: Call_DeleteCertificateIssuer_564169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DeleteCertificateIssuer operation permanently removes the specified certificate issuer from the vault. This operation requires the certificates/manageissuers/deleteissuers permission.
  ## 
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_DeleteCertificateIssuer_564169; apiVersion: string;
          issuerName: string): Recallable =
  ## deleteCertificateIssuer
  ## The DeleteCertificateIssuer operation permanently removes the specified certificate issuer from the vault. This operation requires the certificates/manageissuers/deleteissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_564176 = newJObject()
  var query_564177 = newJObject()
  add(query_564177, "api-version", newJString(apiVersion))
  add(path_564176, "issuer-name", newJString(issuerName))
  result = call_564175.call(path_564176, query_564177, nil, nil, nil)

var deleteCertificateIssuer* = Call_DeleteCertificateIssuer_564169(
    name: "deleteCertificateIssuer", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/issuers/{issuer-name}",
    validator: validate_DeleteCertificateIssuer_564170, base: "",
    url: url_DeleteCertificateIssuer_564171, schemes: {Scheme.Https})
type
  Call_RestoreCertificate_564189 = ref object of OpenApiRestCall_563565
proc url_RestoreCertificate_564191(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreCertificate_564190(path: JsonNode; query: JsonNode;
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
  var valid_564192 = query.getOrDefault("api-version")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "api-version", valid_564192
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

proc call*(call_564194: Call_RestoreCertificate_564189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backed up certificate, and all its versions, to a vault. This operation requires the certificates/restore permission.
  ## 
  let valid = call_564194.validator(path, query, header, formData, body)
  let scheme = call_564194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564194.url(scheme.get, call_564194.host, call_564194.base,
                         call_564194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564194, url, valid)

proc call*(call_564195: Call_RestoreCertificate_564189; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreCertificate
  ## Restores a backed up certificate, and all its versions, to a vault. This operation requires the certificates/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the certificate.
  var query_564196 = newJObject()
  var body_564197 = newJObject()
  add(query_564196, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564197 = parameters
  result = call_564195.call(nil, query_564196, nil, nil, body_564197)

var restoreCertificate* = Call_RestoreCertificate_564189(
    name: "restoreCertificate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/restore", validator: validate_RestoreCertificate_564190,
    base: "", url: url_RestoreCertificate_564191, schemes: {Scheme.Https})
type
  Call_DeleteCertificate_564198 = ref object of OpenApiRestCall_563565
proc url_DeleteCertificate_564200(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteCertificate_564199(path: JsonNode; query: JsonNode;
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
  var valid_564201 = path.getOrDefault("certificate-name")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "certificate-name", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "api-version", valid_564202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564203: Call_DeleteCertificate_564198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all versions of a certificate object along with its associated policy. Delete certificate cannot be used to remove individual versions of a certificate object. This operation requires the certificates/delete permission.
  ## 
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_DeleteCertificate_564198; apiVersion: string;
          certificateName: string): Recallable =
  ## deleteCertificate
  ## Deletes all versions of a certificate object along with its associated policy. Delete certificate cannot be used to remove individual versions of a certificate object. This operation requires the certificates/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_564205 = newJObject()
  var query_564206 = newJObject()
  add(query_564206, "api-version", newJString(apiVersion))
  add(path_564205, "certificate-name", newJString(certificateName))
  result = call_564204.call(path_564205, query_564206, nil, nil, nil)

var deleteCertificate* = Call_DeleteCertificate_564198(name: "deleteCertificate",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/certificates/{certificate-name}",
    validator: validate_DeleteCertificate_564199, base: "",
    url: url_DeleteCertificate_564200, schemes: {Scheme.Https})
type
  Call_BackupCertificate_564207 = ref object of OpenApiRestCall_563565
proc url_BackupCertificate_564209(protocol: Scheme; host: string; base: string;
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

proc validate_BackupCertificate_564208(path: JsonNode; query: JsonNode;
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
  var valid_564210 = path.getOrDefault("certificate-name")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "certificate-name", valid_564210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564212: Call_BackupCertificate_564207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified certificate be downloaded to the client. All versions of the certificate will be downloaded. This operation requires the certificates/backup permission.
  ## 
  let valid = call_564212.validator(path, query, header, formData, body)
  let scheme = call_564212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564212.url(scheme.get, call_564212.host, call_564212.base,
                         call_564212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564212, url, valid)

proc call*(call_564213: Call_BackupCertificate_564207; apiVersion: string;
          certificateName: string): Recallable =
  ## backupCertificate
  ## Requests that a backup of the specified certificate be downloaded to the client. All versions of the certificate will be downloaded. This operation requires the certificates/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_564214 = newJObject()
  var query_564215 = newJObject()
  add(query_564215, "api-version", newJString(apiVersion))
  add(path_564214, "certificate-name", newJString(certificateName))
  result = call_564213.call(path_564214, query_564215, nil, nil, nil)

var backupCertificate* = Call_BackupCertificate_564207(name: "backupCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/backup",
    validator: validate_BackupCertificate_564208, base: "",
    url: url_BackupCertificate_564209, schemes: {Scheme.Https})
type
  Call_CreateCertificate_564216 = ref object of OpenApiRestCall_563565
proc url_CreateCertificate_564218(protocol: Scheme; host: string; base: string;
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

proc validate_CreateCertificate_564217(path: JsonNode; query: JsonNode;
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
  var valid_564219 = path.getOrDefault("certificate-name")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "certificate-name", valid_564219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564220 = query.getOrDefault("api-version")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "api-version", valid_564220
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

proc call*(call_564222: Call_CreateCertificate_564216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If this is the first version, the certificate resource is created. This operation requires the certificates/create permission.
  ## 
  let valid = call_564222.validator(path, query, header, formData, body)
  let scheme = call_564222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564222.url(scheme.get, call_564222.host, call_564222.base,
                         call_564222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564222, url, valid)

proc call*(call_564223: Call_CreateCertificate_564216; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## createCertificate
  ## If this is the first version, the certificate resource is created. This operation requires the certificates/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to create a certificate.
  var path_564224 = newJObject()
  var query_564225 = newJObject()
  var body_564226 = newJObject()
  add(query_564225, "api-version", newJString(apiVersion))
  add(path_564224, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_564226 = parameters
  result = call_564223.call(path_564224, query_564225, nil, nil, body_564226)

var createCertificate* = Call_CreateCertificate_564216(name: "createCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/create",
    validator: validate_CreateCertificate_564217, base: "",
    url: url_CreateCertificate_564218, schemes: {Scheme.Https})
type
  Call_ImportCertificate_564227 = ref object of OpenApiRestCall_563565
proc url_ImportCertificate_564229(protocol: Scheme; host: string; base: string;
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

proc validate_ImportCertificate_564228(path: JsonNode; query: JsonNode;
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
  var valid_564230 = path.getOrDefault("certificate-name")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "certificate-name", valid_564230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to import the certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564233: Call_ImportCertificate_564227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an existing valid certificate, containing a private key, into Azure Key Vault. The certificate to be imported can be in either PFX or PEM format. If the certificate is in PEM format the PEM file must contain the key as well as x509 certificates. This operation requires the certificates/import permission.
  ## 
  let valid = call_564233.validator(path, query, header, formData, body)
  let scheme = call_564233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564233.url(scheme.get, call_564233.host, call_564233.base,
                         call_564233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564233, url, valid)

proc call*(call_564234: Call_ImportCertificate_564227; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## importCertificate
  ## Imports an existing valid certificate, containing a private key, into Azure Key Vault. The certificate to be imported can be in either PFX or PEM format. If the certificate is in PEM format the PEM file must contain the key as well as x509 certificates. This operation requires the certificates/import permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to import the certificate.
  var path_564235 = newJObject()
  var query_564236 = newJObject()
  var body_564237 = newJObject()
  add(query_564236, "api-version", newJString(apiVersion))
  add(path_564235, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_564237 = parameters
  result = call_564234.call(path_564235, query_564236, nil, nil, body_564237)

var importCertificate* = Call_ImportCertificate_564227(name: "importCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/import",
    validator: validate_ImportCertificate_564228, base: "",
    url: url_ImportCertificate_564229, schemes: {Scheme.Https})
type
  Call_GetCertificateOperation_564238 = ref object of OpenApiRestCall_563565
proc url_GetCertificateOperation_564240(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificateOperation_564239(path: JsonNode; query: JsonNode;
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
  var valid_564241 = path.getOrDefault("certificate-name")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "certificate-name", valid_564241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564242 = query.getOrDefault("api-version")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "api-version", valid_564242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564243: Call_GetCertificateOperation_564238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the creation operation associated with a specified certificate. This operation requires the certificates/get permission.
  ## 
  let valid = call_564243.validator(path, query, header, formData, body)
  let scheme = call_564243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564243.url(scheme.get, call_564243.host, call_564243.base,
                         call_564243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564243, url, valid)

proc call*(call_564244: Call_GetCertificateOperation_564238; apiVersion: string;
          certificateName: string): Recallable =
  ## getCertificateOperation
  ## Gets the creation operation associated with a specified certificate. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_564245 = newJObject()
  var query_564246 = newJObject()
  add(query_564246, "api-version", newJString(apiVersion))
  add(path_564245, "certificate-name", newJString(certificateName))
  result = call_564244.call(path_564245, query_564246, nil, nil, nil)

var getCertificateOperation* = Call_GetCertificateOperation_564238(
    name: "getCertificateOperation", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/pending",
    validator: validate_GetCertificateOperation_564239, base: "",
    url: url_GetCertificateOperation_564240, schemes: {Scheme.Https})
type
  Call_UpdateCertificateOperation_564256 = ref object of OpenApiRestCall_563565
proc url_UpdateCertificateOperation_564258(protocol: Scheme; host: string;
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

proc validate_UpdateCertificateOperation_564257(path: JsonNode; query: JsonNode;
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
  var valid_564259 = path.getOrDefault("certificate-name")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "certificate-name", valid_564259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564260 = query.getOrDefault("api-version")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "api-version", valid_564260
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

proc call*(call_564262: Call_UpdateCertificateOperation_564256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a certificate creation operation that is already in progress. This operation requires the certificates/update permission.
  ## 
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_UpdateCertificateOperation_564256; apiVersion: string;
          certificateOperation: JsonNode; certificateName: string): Recallable =
  ## updateCertificateOperation
  ## Updates a certificate creation operation that is already in progress. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateOperation: JObject (required)
  ##                       : The certificate operation response.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  var body_564266 = newJObject()
  add(query_564265, "api-version", newJString(apiVersion))
  if certificateOperation != nil:
    body_564266 = certificateOperation
  add(path_564264, "certificate-name", newJString(certificateName))
  result = call_564263.call(path_564264, query_564265, nil, nil, body_564266)

var updateCertificateOperation* = Call_UpdateCertificateOperation_564256(
    name: "updateCertificateOperation", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/{certificate-name}/pending",
    validator: validate_UpdateCertificateOperation_564257, base: "",
    url: url_UpdateCertificateOperation_564258, schemes: {Scheme.Https})
type
  Call_DeleteCertificateOperation_564247 = ref object of OpenApiRestCall_563565
proc url_DeleteCertificateOperation_564249(protocol: Scheme; host: string;
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

proc validate_DeleteCertificateOperation_564248(path: JsonNode; query: JsonNode;
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
  var valid_564250 = path.getOrDefault("certificate-name")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "certificate-name", valid_564250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564252: Call_DeleteCertificateOperation_564247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the creation operation for a specified certificate that is in the process of being created. The certificate is no longer created. This operation requires the certificates/update permission.
  ## 
  let valid = call_564252.validator(path, query, header, formData, body)
  let scheme = call_564252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564252.url(scheme.get, call_564252.host, call_564252.base,
                         call_564252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564252, url, valid)

proc call*(call_564253: Call_DeleteCertificateOperation_564247; apiVersion: string;
          certificateName: string): Recallable =
  ## deleteCertificateOperation
  ## Deletes the creation operation for a specified certificate that is in the process of being created. The certificate is no longer created. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_564254 = newJObject()
  var query_564255 = newJObject()
  add(query_564255, "api-version", newJString(apiVersion))
  add(path_564254, "certificate-name", newJString(certificateName))
  result = call_564253.call(path_564254, query_564255, nil, nil, nil)

var deleteCertificateOperation* = Call_DeleteCertificateOperation_564247(
    name: "deleteCertificateOperation", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/{certificate-name}/pending",
    validator: validate_DeleteCertificateOperation_564248, base: "",
    url: url_DeleteCertificateOperation_564249, schemes: {Scheme.Https})
type
  Call_MergeCertificate_564267 = ref object of OpenApiRestCall_563565
proc url_MergeCertificate_564269(protocol: Scheme; host: string; base: string;
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

proc validate_MergeCertificate_564268(path: JsonNode; query: JsonNode;
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
  var valid_564270 = path.getOrDefault("certificate-name")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "certificate-name", valid_564270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ##   parameters: JObject (required)
  ##             : The parameters to merge certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564273: Call_MergeCertificate_564267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The MergeCertificate operation performs the merging of a certificate or certificate chain with a key pair currently available in the service. This operation requires the certificates/create permission.
  ## 
  let valid = call_564273.validator(path, query, header, formData, body)
  let scheme = call_564273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564273.url(scheme.get, call_564273.host, call_564273.base,
                         call_564273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564273, url, valid)

proc call*(call_564274: Call_MergeCertificate_564267; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## mergeCertificate
  ## The MergeCertificate operation performs the merging of a certificate or certificate chain with a key pair currently available in the service. This operation requires the certificates/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to merge certificate.
  var path_564275 = newJObject()
  var query_564276 = newJObject()
  var body_564277 = newJObject()
  add(query_564276, "api-version", newJString(apiVersion))
  add(path_564275, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_564277 = parameters
  result = call_564274.call(path_564275, query_564276, nil, nil, body_564277)

var mergeCertificate* = Call_MergeCertificate_564267(name: "mergeCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/pending/merge",
    validator: validate_MergeCertificate_564268, base: "",
    url: url_MergeCertificate_564269, schemes: {Scheme.Https})
type
  Call_GetCertificatePolicy_564278 = ref object of OpenApiRestCall_563565
proc url_GetCertificatePolicy_564280(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificatePolicy_564279(path: JsonNode; query: JsonNode;
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
  var valid_564281 = path.getOrDefault("certificate-name")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "certificate-name", valid_564281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564282 = query.getOrDefault("api-version")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "api-version", valid_564282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564283: Call_GetCertificatePolicy_564278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificatePolicy operation returns the specified certificate policy resources in the specified key vault. This operation requires the certificates/get permission.
  ## 
  let valid = call_564283.validator(path, query, header, formData, body)
  let scheme = call_564283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564283.url(scheme.get, call_564283.host, call_564283.base,
                         call_564283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564283, url, valid)

proc call*(call_564284: Call_GetCertificatePolicy_564278; apiVersion: string;
          certificateName: string): Recallable =
  ## getCertificatePolicy
  ## The GetCertificatePolicy operation returns the specified certificate policy resources in the specified key vault. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in a given key vault.
  var path_564285 = newJObject()
  var query_564286 = newJObject()
  add(query_564286, "api-version", newJString(apiVersion))
  add(path_564285, "certificate-name", newJString(certificateName))
  result = call_564284.call(path_564285, query_564286, nil, nil, nil)

var getCertificatePolicy* = Call_GetCertificatePolicy_564278(
    name: "getCertificatePolicy", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/policy",
    validator: validate_GetCertificatePolicy_564279, base: "",
    url: url_GetCertificatePolicy_564280, schemes: {Scheme.Https})
type
  Call_UpdateCertificatePolicy_564287 = ref object of OpenApiRestCall_563565
proc url_UpdateCertificatePolicy_564289(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCertificatePolicy_564288(path: JsonNode; query: JsonNode;
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
  var valid_564290 = path.getOrDefault("certificate-name")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "certificate-name", valid_564290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564291 = query.getOrDefault("api-version")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "api-version", valid_564291
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

proc call*(call_564293: Call_UpdateCertificatePolicy_564287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set specified members in the certificate policy. Leave others as null. This operation requires the certificates/update permission.
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_UpdateCertificatePolicy_564287; apiVersion: string;
          certificateName: string; certificatePolicy: JsonNode): Recallable =
  ## updateCertificatePolicy
  ## Set specified members in the certificate policy. Leave others as null. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault.
  ##   certificatePolicy: JObject (required)
  ##                    : The policy for the certificate.
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  var body_564297 = newJObject()
  add(query_564296, "api-version", newJString(apiVersion))
  add(path_564295, "certificate-name", newJString(certificateName))
  if certificatePolicy != nil:
    body_564297 = certificatePolicy
  result = call_564294.call(path_564295, query_564296, nil, nil, body_564297)

var updateCertificatePolicy* = Call_UpdateCertificatePolicy_564287(
    name: "updateCertificatePolicy", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/{certificate-name}/policy",
    validator: validate_UpdateCertificatePolicy_564288, base: "",
    url: url_UpdateCertificatePolicy_564289, schemes: {Scheme.Https})
type
  Call_GetCertificateVersions_564298 = ref object of OpenApiRestCall_563565
proc url_GetCertificateVersions_564300(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificateVersions_564299(path: JsonNode; query: JsonNode;
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
  var valid_564301 = path.getOrDefault("certificate-name")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "certificate-name", valid_564301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564302 = query.getOrDefault("api-version")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "api-version", valid_564302
  var valid_564303 = query.getOrDefault("maxresults")
  valid_564303 = validateParameter(valid_564303, JInt, required = false, default = nil)
  if valid_564303 != nil:
    section.add "maxresults", valid_564303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564304: Call_GetCertificateVersions_564298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificateVersions operation returns the versions of a certificate in the specified key vault. This operation requires the certificates/list permission.
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_GetCertificateVersions_564298; apiVersion: string;
          certificateName: string; maxresults: int = 0): Recallable =
  ## getCertificateVersions
  ## The GetCertificateVersions operation returns the versions of a certificate in the specified key vault. This operation requires the certificates/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  add(query_564307, "api-version", newJString(apiVersion))
  add(query_564307, "maxresults", newJInt(maxresults))
  add(path_564306, "certificate-name", newJString(certificateName))
  result = call_564305.call(path_564306, query_564307, nil, nil, nil)

var getCertificateVersions* = Call_GetCertificateVersions_564298(
    name: "getCertificateVersions", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/versions",
    validator: validate_GetCertificateVersions_564299, base: "",
    url: url_GetCertificateVersions_564300, schemes: {Scheme.Https})
type
  Call_GetCertificate_564308 = ref object of OpenApiRestCall_563565
proc url_GetCertificate_564310(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificate_564309(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about a specific certificate. This operation requires the certificates/get permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-version: JString (required)
  ##                      : The version of the certificate.
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate in the given vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificate-version` field"
  var valid_564311 = path.getOrDefault("certificate-version")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "certificate-version", valid_564311
  var valid_564312 = path.getOrDefault("certificate-name")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "certificate-name", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_GetCertificate_564308; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific certificate. This operation requires the certificates/get permission.
  ## 
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_GetCertificate_564308; apiVersion: string;
          certificateVersion: string; certificateName: string): Recallable =
  ## getCertificate
  ## Gets information about a specific certificate. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateVersion: string (required)
  ##                     : The version of the certificate.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault.
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(path_564316, "certificate-version", newJString(certificateVersion))
  add(path_564316, "certificate-name", newJString(certificateName))
  result = call_564315.call(path_564316, query_564317, nil, nil, nil)

var getCertificate* = Call_GetCertificate_564308(name: "getCertificate",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/{certificate-version}",
    validator: validate_GetCertificate_564309, base: "", url: url_GetCertificate_564310,
    schemes: {Scheme.Https})
type
  Call_UpdateCertificate_564318 = ref object of OpenApiRestCall_563565
proc url_UpdateCertificate_564320(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCertificate_564319(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The UpdateCertificate operation applies the specified update on the given certificate; the only elements updated are the certificate's attributes. This operation requires the certificates/update permission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificate-version: JString (required)
  ##                      : The version of the certificate.
  ##   certificate-name: JString (required)
  ##                   : The name of the certificate in the given key vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificate-version` field"
  var valid_564321 = path.getOrDefault("certificate-version")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "certificate-version", valid_564321
  var valid_564322 = path.getOrDefault("certificate-name")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "certificate-name", valid_564322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564323 = query.getOrDefault("api-version")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "api-version", valid_564323
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

proc call*(call_564325: Call_UpdateCertificate_564318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UpdateCertificate operation applies the specified update on the given certificate; the only elements updated are the certificate's attributes. This operation requires the certificates/update permission.
  ## 
  let valid = call_564325.validator(path, query, header, formData, body)
  let scheme = call_564325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564325.url(scheme.get, call_564325.host, call_564325.base,
                         call_564325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564325, url, valid)

proc call*(call_564326: Call_UpdateCertificate_564318; apiVersion: string;
          certificateVersion: string; certificateName: string; parameters: JsonNode): Recallable =
  ## updateCertificate
  ## The UpdateCertificate operation applies the specified update on the given certificate; the only elements updated are the certificate's attributes. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateVersion: string (required)
  ##                     : The version of the certificate.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given key vault.
  ##   parameters: JObject (required)
  ##             : The parameters for certificate update.
  var path_564327 = newJObject()
  var query_564328 = newJObject()
  var body_564329 = newJObject()
  add(query_564328, "api-version", newJString(apiVersion))
  add(path_564327, "certificate-version", newJString(certificateVersion))
  add(path_564327, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_564329 = parameters
  result = call_564326.call(path_564327, query_564328, nil, nil, body_564329)

var updateCertificate* = Call_UpdateCertificate_564318(name: "updateCertificate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/certificates/{certificate-name}/{certificate-version}",
    validator: validate_UpdateCertificate_564319, base: "",
    url: url_UpdateCertificate_564320, schemes: {Scheme.Https})
type
  Call_GetDeletedCertificates_564330 = ref object of OpenApiRestCall_563565
proc url_GetDeletedCertificates_564332(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedCertificates_564331(path: JsonNode; query: JsonNode;
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
  ##   includePending: JBool
  ##                 : Specifies whether to include certificates which are not completely provisioned.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564333 = query.getOrDefault("api-version")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "api-version", valid_564333
  var valid_564334 = query.getOrDefault("includePending")
  valid_564334 = validateParameter(valid_564334, JBool, required = false, default = nil)
  if valid_564334 != nil:
    section.add "includePending", valid_564334
  var valid_564335 = query.getOrDefault("maxresults")
  valid_564335 = validateParameter(valid_564335, JInt, required = false, default = nil)
  if valid_564335 != nil:
    section.add "maxresults", valid_564335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564336: Call_GetDeletedCertificates_564330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetDeletedCertificates operation retrieves the certificates in the current vault which are in a deleted state and ready for recovery or purging. This operation includes deletion-specific information. This operation requires the certificates/get/list permission. This operation can only be enabled on soft-delete enabled vaults.
  ## 
  let valid = call_564336.validator(path, query, header, formData, body)
  let scheme = call_564336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564336.url(scheme.get, call_564336.host, call_564336.base,
                         call_564336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564336, url, valid)

proc call*(call_564337: Call_GetDeletedCertificates_564330; apiVersion: string;
          includePending: bool = false; maxresults: int = 0): Recallable =
  ## getDeletedCertificates
  ## The GetDeletedCertificates operation retrieves the certificates in the current vault which are in a deleted state and ready for recovery or purging. This operation includes deletion-specific information. This operation requires the certificates/get/list permission. This operation can only be enabled on soft-delete enabled vaults.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   includePending: bool
  ##                 : Specifies whether to include certificates which are not completely provisioned.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564338 = newJObject()
  add(query_564338, "api-version", newJString(apiVersion))
  add(query_564338, "includePending", newJBool(includePending))
  add(query_564338, "maxresults", newJInt(maxresults))
  result = call_564337.call(nil, query_564338, nil, nil, nil)

var getDeletedCertificates* = Call_GetDeletedCertificates_564330(
    name: "getDeletedCertificates", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedcertificates", validator: validate_GetDeletedCertificates_564331,
    base: "", url: url_GetDeletedCertificates_564332, schemes: {Scheme.Https})
type
  Call_GetDeletedCertificate_564339 = ref object of OpenApiRestCall_563565
proc url_GetDeletedCertificate_564341(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedCertificate_564340(path: JsonNode; query: JsonNode;
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
  var valid_564342 = path.getOrDefault("certificate-name")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "certificate-name", valid_564342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564343 = query.getOrDefault("api-version")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "api-version", valid_564343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564344: Call_GetDeletedCertificate_564339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetDeletedCertificate operation retrieves the deleted certificate information plus its attributes, such as retention interval, scheduled permanent deletion and the current deletion recovery level. This operation requires the certificates/get permission.
  ## 
  let valid = call_564344.validator(path, query, header, formData, body)
  let scheme = call_564344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564344.url(scheme.get, call_564344.host, call_564344.base,
                         call_564344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564344, url, valid)

proc call*(call_564345: Call_GetDeletedCertificate_564339; apiVersion: string;
          certificateName: string): Recallable =
  ## getDeletedCertificate
  ## The GetDeletedCertificate operation retrieves the deleted certificate information plus its attributes, such as retention interval, scheduled permanent deletion and the current deletion recovery level. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_564346 = newJObject()
  var query_564347 = newJObject()
  add(query_564347, "api-version", newJString(apiVersion))
  add(path_564346, "certificate-name", newJString(certificateName))
  result = call_564345.call(path_564346, query_564347, nil, nil, nil)

var getDeletedCertificate* = Call_GetDeletedCertificate_564339(
    name: "getDeletedCertificate", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedcertificates/{certificate-name}",
    validator: validate_GetDeletedCertificate_564340, base: "",
    url: url_GetDeletedCertificate_564341, schemes: {Scheme.Https})
type
  Call_PurgeDeletedCertificate_564348 = ref object of OpenApiRestCall_563565
proc url_PurgeDeletedCertificate_564350(protocol: Scheme; host: string; base: string;
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

proc validate_PurgeDeletedCertificate_564349(path: JsonNode; query: JsonNode;
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
  var valid_564351 = path.getOrDefault("certificate-name")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "certificate-name", valid_564351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564352 = query.getOrDefault("api-version")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "api-version", valid_564352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564353: Call_PurgeDeletedCertificate_564348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The PurgeDeletedCertificate operation performs an irreversible deletion of the specified certificate, without possibility for recovery. The operation is not available if the recovery level does not specify 'Purgeable'. This operation requires the certificate/purge permission.
  ## 
  let valid = call_564353.validator(path, query, header, formData, body)
  let scheme = call_564353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564353.url(scheme.get, call_564353.host, call_564353.base,
                         call_564353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564353, url, valid)

proc call*(call_564354: Call_PurgeDeletedCertificate_564348; apiVersion: string;
          certificateName: string): Recallable =
  ## purgeDeletedCertificate
  ## The PurgeDeletedCertificate operation performs an irreversible deletion of the specified certificate, without possibility for recovery. The operation is not available if the recovery level does not specify 'Purgeable'. This operation requires the certificate/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_564355 = newJObject()
  var query_564356 = newJObject()
  add(query_564356, "api-version", newJString(apiVersion))
  add(path_564355, "certificate-name", newJString(certificateName))
  result = call_564354.call(path_564355, query_564356, nil, nil, nil)

var purgeDeletedCertificate* = Call_PurgeDeletedCertificate_564348(
    name: "purgeDeletedCertificate", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/deletedcertificates/{certificate-name}",
    validator: validate_PurgeDeletedCertificate_564349, base: "",
    url: url_PurgeDeletedCertificate_564350, schemes: {Scheme.Https})
type
  Call_RecoverDeletedCertificate_564357 = ref object of OpenApiRestCall_563565
proc url_RecoverDeletedCertificate_564359(protocol: Scheme; host: string;
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

proc validate_RecoverDeletedCertificate_564358(path: JsonNode; query: JsonNode;
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
  var valid_564360 = path.getOrDefault("certificate-name")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "certificate-name", valid_564360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564361 = query.getOrDefault("api-version")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "api-version", valid_564361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564362: Call_RecoverDeletedCertificate_564357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RecoverDeletedCertificate operation performs the reversal of the Delete operation. The operation is applicable in vaults enabled for soft-delete, and must be issued during the retention interval (available in the deleted certificate's attributes). This operation requires the certificates/recover permission.
  ## 
  let valid = call_564362.validator(path, query, header, formData, body)
  let scheme = call_564362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564362.url(scheme.get, call_564362.host, call_564362.base,
                         call_564362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564362, url, valid)

proc call*(call_564363: Call_RecoverDeletedCertificate_564357; apiVersion: string;
          certificateName: string): Recallable =
  ## recoverDeletedCertificate
  ## The RecoverDeletedCertificate operation performs the reversal of the Delete operation. The operation is applicable in vaults enabled for soft-delete, and must be issued during the retention interval (available in the deleted certificate's attributes). This operation requires the certificates/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the deleted certificate
  var path_564364 = newJObject()
  var query_564365 = newJObject()
  add(query_564365, "api-version", newJString(apiVersion))
  add(path_564364, "certificate-name", newJString(certificateName))
  result = call_564363.call(path_564364, query_564365, nil, nil, nil)

var recoverDeletedCertificate* = Call_RecoverDeletedCertificate_564357(
    name: "recoverDeletedCertificate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/deletedcertificates/{certificate-name}/recover",
    validator: validate_RecoverDeletedCertificate_564358, base: "",
    url: url_RecoverDeletedCertificate_564359, schemes: {Scheme.Https})
type
  Call_GetDeletedKeys_564366 = ref object of OpenApiRestCall_563565
proc url_GetDeletedKeys_564368(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedKeys_564367(path: JsonNode; query: JsonNode;
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
  var valid_564369 = query.getOrDefault("api-version")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "api-version", valid_564369
  var valid_564370 = query.getOrDefault("maxresults")
  valid_564370 = validateParameter(valid_564370, JInt, required = false, default = nil)
  if valid_564370 != nil:
    section.add "maxresults", valid_564370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564371: Call_GetDeletedKeys_564366; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a deleted key. This operation includes deletion-specific information. The Get Deleted Keys operation is applicable for vaults enabled for soft-delete. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/list permission.
  ## 
  let valid = call_564371.validator(path, query, header, formData, body)
  let scheme = call_564371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564371.url(scheme.get, call_564371.host, call_564371.base,
                         call_564371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564371, url, valid)

proc call*(call_564372: Call_GetDeletedKeys_564366; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedKeys
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a deleted key. This operation includes deletion-specific information. The Get Deleted Keys operation is applicable for vaults enabled for soft-delete. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564373 = newJObject()
  add(query_564373, "api-version", newJString(apiVersion))
  add(query_564373, "maxresults", newJInt(maxresults))
  result = call_564372.call(nil, query_564373, nil, nil, nil)

var getDeletedKeys* = Call_GetDeletedKeys_564366(name: "getDeletedKeys",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedkeys",
    validator: validate_GetDeletedKeys_564367, base: "", url: url_GetDeletedKeys_564368,
    schemes: {Scheme.Https})
type
  Call_GetDeletedKey_564374 = ref object of OpenApiRestCall_563565
proc url_GetDeletedKey_564376(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedKey_564375(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564377 = path.getOrDefault("key-name")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "key-name", valid_564377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564378 = query.getOrDefault("api-version")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "api-version", valid_564378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564379: Call_GetDeletedKey_564374; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/get permission. 
  ## 
  let valid = call_564379.validator(path, query, header, formData, body)
  let scheme = call_564379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564379.url(scheme.get, call_564379.host, call_564379.base,
                         call_564379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564379, url, valid)

proc call*(call_564380: Call_GetDeletedKey_564374; apiVersion: string;
          keyName: string): Recallable =
  ## getDeletedKey
  ## The Get Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/get permission. 
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_564381 = newJObject()
  var query_564382 = newJObject()
  add(query_564382, "api-version", newJString(apiVersion))
  add(path_564381, "key-name", newJString(keyName))
  result = call_564380.call(path_564381, query_564382, nil, nil, nil)

var getDeletedKey* = Call_GetDeletedKey_564374(name: "getDeletedKey",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedkeys/{key-name}",
    validator: validate_GetDeletedKey_564375, base: "", url: url_GetDeletedKey_564376,
    schemes: {Scheme.Https})
type
  Call_PurgeDeletedKey_564383 = ref object of OpenApiRestCall_563565
proc url_PurgeDeletedKey_564385(protocol: Scheme; host: string; base: string;
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

proc validate_PurgeDeletedKey_564384(path: JsonNode; query: JsonNode;
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
  var valid_564386 = path.getOrDefault("key-name")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "key-name", valid_564386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564387 = query.getOrDefault("api-version")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "api-version", valid_564387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564388: Call_PurgeDeletedKey_564383; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Purge Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/purge permission.
  ## 
  let valid = call_564388.validator(path, query, header, formData, body)
  let scheme = call_564388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564388.url(scheme.get, call_564388.host, call_564388.base,
                         call_564388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564388, url, valid)

proc call*(call_564389: Call_PurgeDeletedKey_564383; apiVersion: string;
          keyName: string): Recallable =
  ## purgeDeletedKey
  ## The Purge Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564390 = newJObject()
  var query_564391 = newJObject()
  add(query_564391, "api-version", newJString(apiVersion))
  add(path_564390, "key-name", newJString(keyName))
  result = call_564389.call(path_564390, query_564391, nil, nil, nil)

var purgeDeletedKey* = Call_PurgeDeletedKey_564383(name: "purgeDeletedKey",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/deletedkeys/{key-name}", validator: validate_PurgeDeletedKey_564384,
    base: "", url: url_PurgeDeletedKey_564385, schemes: {Scheme.Https})
type
  Call_RecoverDeletedKey_564392 = ref object of OpenApiRestCall_563565
proc url_RecoverDeletedKey_564394(protocol: Scheme; host: string; base: string;
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

proc validate_RecoverDeletedKey_564393(path: JsonNode; query: JsonNode;
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
  var valid_564395 = path.getOrDefault("key-name")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "key-name", valid_564395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564396 = query.getOrDefault("api-version")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "api-version", valid_564396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564397: Call_RecoverDeletedKey_564392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Recover Deleted Key operation is applicable for deleted keys in soft-delete enabled vaults. It recovers the deleted key back to its latest version under /keys. An attempt to recover an non-deleted key will return an error. Consider this the inverse of the delete operation on soft-delete enabled vaults. This operation requires the keys/recover permission.
  ## 
  let valid = call_564397.validator(path, query, header, formData, body)
  let scheme = call_564397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564397.url(scheme.get, call_564397.host, call_564397.base,
                         call_564397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564397, url, valid)

proc call*(call_564398: Call_RecoverDeletedKey_564392; apiVersion: string;
          keyName: string): Recallable =
  ## recoverDeletedKey
  ## The Recover Deleted Key operation is applicable for deleted keys in soft-delete enabled vaults. It recovers the deleted key back to its latest version under /keys. An attempt to recover an non-deleted key will return an error. Consider this the inverse of the delete operation on soft-delete enabled vaults. This operation requires the keys/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the deleted key.
  var path_564399 = newJObject()
  var query_564400 = newJObject()
  add(query_564400, "api-version", newJString(apiVersion))
  add(path_564399, "key-name", newJString(keyName))
  result = call_564398.call(path_564399, query_564400, nil, nil, nil)

var recoverDeletedKey* = Call_RecoverDeletedKey_564392(name: "recoverDeletedKey",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/deletedkeys/{key-name}/recover",
    validator: validate_RecoverDeletedKey_564393, base: "",
    url: url_RecoverDeletedKey_564394, schemes: {Scheme.Https})
type
  Call_GetDeletedSecrets_564401 = ref object of OpenApiRestCall_563565
proc url_GetDeletedSecrets_564403(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedSecrets_564402(path: JsonNode; query: JsonNode;
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
  var valid_564404 = query.getOrDefault("api-version")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "api-version", valid_564404
  var valid_564405 = query.getOrDefault("maxresults")
  valid_564405 = validateParameter(valid_564405, JInt, required = false, default = nil)
  if valid_564405 != nil:
    section.add "maxresults", valid_564405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564406: Call_GetDeletedSecrets_564401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Secrets operation returns the secrets that have been deleted for a vault enabled for soft-delete. This operation requires the secrets/list permission.
  ## 
  let valid = call_564406.validator(path, query, header, formData, body)
  let scheme = call_564406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564406.url(scheme.get, call_564406.host, call_564406.base,
                         call_564406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564406, url, valid)

proc call*(call_564407: Call_GetDeletedSecrets_564401; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedSecrets
  ## The Get Deleted Secrets operation returns the secrets that have been deleted for a vault enabled for soft-delete. This operation requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564408 = newJObject()
  add(query_564408, "api-version", newJString(apiVersion))
  add(query_564408, "maxresults", newJInt(maxresults))
  result = call_564407.call(nil, query_564408, nil, nil, nil)

var getDeletedSecrets* = Call_GetDeletedSecrets_564401(name: "getDeletedSecrets",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedsecrets",
    validator: validate_GetDeletedSecrets_564402, base: "",
    url: url_GetDeletedSecrets_564403, schemes: {Scheme.Https})
type
  Call_GetDeletedSecret_564409 = ref object of OpenApiRestCall_563565
proc url_GetDeletedSecret_564411(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedSecret_564410(path: JsonNode; query: JsonNode;
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
  var valid_564412 = path.getOrDefault("secret-name")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "secret-name", valid_564412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564413 = query.getOrDefault("api-version")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "api-version", valid_564413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564414: Call_GetDeletedSecret_564409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Secret operation returns the specified deleted secret along with its attributes. This operation requires the secrets/get permission.
  ## 
  let valid = call_564414.validator(path, query, header, formData, body)
  let scheme = call_564414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564414.url(scheme.get, call_564414.host, call_564414.base,
                         call_564414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564414, url, valid)

proc call*(call_564415: Call_GetDeletedSecret_564409; apiVersion: string;
          secretName: string): Recallable =
  ## getDeletedSecret
  ## The Get Deleted Secret operation returns the specified deleted secret along with its attributes. This operation requires the secrets/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_564416 = newJObject()
  var query_564417 = newJObject()
  add(query_564417, "api-version", newJString(apiVersion))
  add(path_564416, "secret-name", newJString(secretName))
  result = call_564415.call(path_564416, query_564417, nil, nil, nil)

var getDeletedSecret* = Call_GetDeletedSecret_564409(name: "getDeletedSecret",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedsecrets/{secret-name}", validator: validate_GetDeletedSecret_564410,
    base: "", url: url_GetDeletedSecret_564411, schemes: {Scheme.Https})
type
  Call_PurgeDeletedSecret_564418 = ref object of OpenApiRestCall_563565
proc url_PurgeDeletedSecret_564420(protocol: Scheme; host: string; base: string;
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

proc validate_PurgeDeletedSecret_564419(path: JsonNode; query: JsonNode;
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
  var valid_564421 = path.getOrDefault("secret-name")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "secret-name", valid_564421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564422 = query.getOrDefault("api-version")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "api-version", valid_564422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564423: Call_PurgeDeletedSecret_564418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The purge deleted secret operation removes the secret permanently, without the possibility of recovery. This operation can only be enabled on a soft-delete enabled vault. This operation requires the secrets/purge permission.
  ## 
  let valid = call_564423.validator(path, query, header, formData, body)
  let scheme = call_564423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564423.url(scheme.get, call_564423.host, call_564423.base,
                         call_564423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564423, url, valid)

proc call*(call_564424: Call_PurgeDeletedSecret_564418; apiVersion: string;
          secretName: string): Recallable =
  ## purgeDeletedSecret
  ## The purge deleted secret operation removes the secret permanently, without the possibility of recovery. This operation can only be enabled on a soft-delete enabled vault. This operation requires the secrets/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_564425 = newJObject()
  var query_564426 = newJObject()
  add(query_564426, "api-version", newJString(apiVersion))
  add(path_564425, "secret-name", newJString(secretName))
  result = call_564424.call(path_564425, query_564426, nil, nil, nil)

var purgeDeletedSecret* = Call_PurgeDeletedSecret_564418(
    name: "purgeDeletedSecret", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/deletedsecrets/{secret-name}",
    validator: validate_PurgeDeletedSecret_564419, base: "",
    url: url_PurgeDeletedSecret_564420, schemes: {Scheme.Https})
type
  Call_RecoverDeletedSecret_564427 = ref object of OpenApiRestCall_563565
proc url_RecoverDeletedSecret_564429(protocol: Scheme; host: string; base: string;
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

proc validate_RecoverDeletedSecret_564428(path: JsonNode; query: JsonNode;
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
  var valid_564430 = path.getOrDefault("secret-name")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "secret-name", valid_564430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564431 = query.getOrDefault("api-version")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "api-version", valid_564431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564432: Call_RecoverDeletedSecret_564427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recovers the deleted secret in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the secrets/recover permission.
  ## 
  let valid = call_564432.validator(path, query, header, formData, body)
  let scheme = call_564432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564432.url(scheme.get, call_564432.host, call_564432.base,
                         call_564432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564432, url, valid)

proc call*(call_564433: Call_RecoverDeletedSecret_564427; apiVersion: string;
          secretName: string): Recallable =
  ## recoverDeletedSecret
  ## Recovers the deleted secret in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the secrets/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the deleted secret.
  var path_564434 = newJObject()
  var query_564435 = newJObject()
  add(query_564435, "api-version", newJString(apiVersion))
  add(path_564434, "secret-name", newJString(secretName))
  result = call_564433.call(path_564434, query_564435, nil, nil, nil)

var recoverDeletedSecret* = Call_RecoverDeletedSecret_564427(
    name: "recoverDeletedSecret", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/deletedsecrets/{secret-name}/recover",
    validator: validate_RecoverDeletedSecret_564428, base: "",
    url: url_RecoverDeletedSecret_564429, schemes: {Scheme.Https})
type
  Call_GetDeletedStorageAccounts_564436 = ref object of OpenApiRestCall_563565
proc url_GetDeletedStorageAccounts_564438(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedStorageAccounts_564437(path: JsonNode; query: JsonNode;
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
  var valid_564439 = query.getOrDefault("api-version")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "api-version", valid_564439
  var valid_564440 = query.getOrDefault("maxresults")
  valid_564440 = validateParameter(valid_564440, JInt, required = false, default = nil)
  if valid_564440 != nil:
    section.add "maxresults", valid_564440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564441: Call_GetDeletedStorageAccounts_564436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Storage Accounts operation returns the storage accounts that have been deleted for a vault enabled for soft-delete. This operation requires the storage/list permission.
  ## 
  let valid = call_564441.validator(path, query, header, formData, body)
  let scheme = call_564441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564441.url(scheme.get, call_564441.host, call_564441.base,
                         call_564441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564441, url, valid)

proc call*(call_564442: Call_GetDeletedStorageAccounts_564436; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedStorageAccounts
  ## The Get Deleted Storage Accounts operation returns the storage accounts that have been deleted for a vault enabled for soft-delete. This operation requires the storage/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564443 = newJObject()
  add(query_564443, "api-version", newJString(apiVersion))
  add(query_564443, "maxresults", newJInt(maxresults))
  result = call_564442.call(nil, query_564443, nil, nil, nil)

var getDeletedStorageAccounts* = Call_GetDeletedStorageAccounts_564436(
    name: "getDeletedStorageAccounts", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/deletedstorage",
    validator: validate_GetDeletedStorageAccounts_564437, base: "",
    url: url_GetDeletedStorageAccounts_564438, schemes: {Scheme.Https})
type
  Call_GetDeletedStorageAccount_564444 = ref object of OpenApiRestCall_563565
proc url_GetDeletedStorageAccount_564446(protocol: Scheme; host: string;
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

proc validate_GetDeletedStorageAccount_564445(path: JsonNode; query: JsonNode;
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
  var valid_564447 = path.getOrDefault("storage-account-name")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "storage-account-name", valid_564447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564448 = query.getOrDefault("api-version")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "api-version", valid_564448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564449: Call_GetDeletedStorageAccount_564444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Storage Account operation returns the specified deleted storage account along with its attributes. This operation requires the storage/get permission.
  ## 
  let valid = call_564449.validator(path, query, header, formData, body)
  let scheme = call_564449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564449.url(scheme.get, call_564449.host, call_564449.base,
                         call_564449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564449, url, valid)

proc call*(call_564450: Call_GetDeletedStorageAccount_564444; apiVersion: string;
          storageAccountName: string): Recallable =
  ## getDeletedStorageAccount
  ## The Get Deleted Storage Account operation returns the specified deleted storage account along with its attributes. This operation requires the storage/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_564451 = newJObject()
  var query_564452 = newJObject()
  add(query_564452, "api-version", newJString(apiVersion))
  add(path_564451, "storage-account-name", newJString(storageAccountName))
  result = call_564450.call(path_564451, query_564452, nil, nil, nil)

var getDeletedStorageAccount* = Call_GetDeletedStorageAccount_564444(
    name: "getDeletedStorageAccount", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedstorage/{storage-account-name}",
    validator: validate_GetDeletedStorageAccount_564445, base: "",
    url: url_GetDeletedStorageAccount_564446, schemes: {Scheme.Https})
type
  Call_PurgeDeletedStorageAccount_564453 = ref object of OpenApiRestCall_563565
proc url_PurgeDeletedStorageAccount_564455(protocol: Scheme; host: string;
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

proc validate_PurgeDeletedStorageAccount_564454(path: JsonNode; query: JsonNode;
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
  var valid_564456 = path.getOrDefault("storage-account-name")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "storage-account-name", valid_564456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564457 = query.getOrDefault("api-version")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "api-version", valid_564457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564458: Call_PurgeDeletedStorageAccount_564453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The purge deleted storage account operation removes the secret permanently, without the possibility of recovery. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/purge permission.
  ## 
  let valid = call_564458.validator(path, query, header, formData, body)
  let scheme = call_564458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564458.url(scheme.get, call_564458.host, call_564458.base,
                         call_564458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564458, url, valid)

proc call*(call_564459: Call_PurgeDeletedStorageAccount_564453; apiVersion: string;
          storageAccountName: string): Recallable =
  ## purgeDeletedStorageAccount
  ## The purge deleted storage account operation removes the secret permanently, without the possibility of recovery. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_564460 = newJObject()
  var query_564461 = newJObject()
  add(query_564461, "api-version", newJString(apiVersion))
  add(path_564460, "storage-account-name", newJString(storageAccountName))
  result = call_564459.call(path_564460, query_564461, nil, nil, nil)

var purgeDeletedStorageAccount* = Call_PurgeDeletedStorageAccount_564453(
    name: "purgeDeletedStorageAccount", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/deletedstorage/{storage-account-name}",
    validator: validate_PurgeDeletedStorageAccount_564454, base: "",
    url: url_PurgeDeletedStorageAccount_564455, schemes: {Scheme.Https})
type
  Call_RecoverDeletedStorageAccount_564462 = ref object of OpenApiRestCall_563565
proc url_RecoverDeletedStorageAccount_564464(protocol: Scheme; host: string;
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

proc validate_RecoverDeletedStorageAccount_564463(path: JsonNode; query: JsonNode;
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
  var valid_564465 = path.getOrDefault("storage-account-name")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "storage-account-name", valid_564465
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564466 = query.getOrDefault("api-version")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "api-version", valid_564466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564467: Call_RecoverDeletedStorageAccount_564462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recovers the deleted storage account in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ## 
  let valid = call_564467.validator(path, query, header, formData, body)
  let scheme = call_564467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564467.url(scheme.get, call_564467.host, call_564467.base,
                         call_564467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564467, url, valid)

proc call*(call_564468: Call_RecoverDeletedStorageAccount_564462;
          apiVersion: string; storageAccountName: string): Recallable =
  ## recoverDeletedStorageAccount
  ## Recovers the deleted storage account in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_564469 = newJObject()
  var query_564470 = newJObject()
  add(query_564470, "api-version", newJString(apiVersion))
  add(path_564469, "storage-account-name", newJString(storageAccountName))
  result = call_564468.call(path_564469, query_564470, nil, nil, nil)

var recoverDeletedStorageAccount* = Call_RecoverDeletedStorageAccount_564462(
    name: "recoverDeletedStorageAccount", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/deletedstorage/{storage-account-name}/recover",
    validator: validate_RecoverDeletedStorageAccount_564463, base: "",
    url: url_RecoverDeletedStorageAccount_564464, schemes: {Scheme.Https})
type
  Call_GetDeletedSasDefinitions_564471 = ref object of OpenApiRestCall_563565
proc url_GetDeletedSasDefinitions_564473(protocol: Scheme; host: string;
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

proc validate_GetDeletedSasDefinitions_564472(path: JsonNode; query: JsonNode;
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
  var valid_564474 = path.getOrDefault("storage-account-name")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "storage-account-name", valid_564474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564475 = query.getOrDefault("api-version")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "api-version", valid_564475
  var valid_564476 = query.getOrDefault("maxresults")
  valid_564476 = validateParameter(valid_564476, JInt, required = false, default = nil)
  if valid_564476 != nil:
    section.add "maxresults", valid_564476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564477: Call_GetDeletedSasDefinitions_564471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Sas Definitions operation returns the SAS definitions that have been deleted for a vault enabled for soft-delete. This operation requires the storage/listsas permission.
  ## 
  let valid = call_564477.validator(path, query, header, formData, body)
  let scheme = call_564477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564477.url(scheme.get, call_564477.host, call_564477.base,
                         call_564477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564477, url, valid)

proc call*(call_564478: Call_GetDeletedSasDefinitions_564471; apiVersion: string;
          storageAccountName: string; maxresults: int = 0): Recallable =
  ## getDeletedSasDefinitions
  ## The Get Deleted Sas Definitions operation returns the SAS definitions that have been deleted for a vault enabled for soft-delete. This operation requires the storage/listsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var path_564479 = newJObject()
  var query_564480 = newJObject()
  add(query_564480, "api-version", newJString(apiVersion))
  add(path_564479, "storage-account-name", newJString(storageAccountName))
  add(query_564480, "maxresults", newJInt(maxresults))
  result = call_564478.call(path_564479, query_564480, nil, nil, nil)

var getDeletedSasDefinitions* = Call_GetDeletedSasDefinitions_564471(
    name: "getDeletedSasDefinitions", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedstorage/{storage-account-name}/sas",
    validator: validate_GetDeletedSasDefinitions_564472, base: "",
    url: url_GetDeletedSasDefinitions_564473, schemes: {Scheme.Https})
type
  Call_GetDeletedSasDefinition_564481 = ref object of OpenApiRestCall_563565
proc url_GetDeletedSasDefinition_564483(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedSasDefinition_564482(path: JsonNode; query: JsonNode;
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
  var valid_564484 = path.getOrDefault("storage-account-name")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "storage-account-name", valid_564484
  var valid_564485 = path.getOrDefault("sas-definition-name")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "sas-definition-name", valid_564485
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564486 = query.getOrDefault("api-version")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "api-version", valid_564486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564487: Call_GetDeletedSasDefinition_564481; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted SAS Definition operation returns the specified deleted SAS definition along with its attributes. This operation requires the storage/getsas permission.
  ## 
  let valid = call_564487.validator(path, query, header, formData, body)
  let scheme = call_564487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564487.url(scheme.get, call_564487.host, call_564487.base,
                         call_564487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564487, url, valid)

proc call*(call_564488: Call_GetDeletedSasDefinition_564481; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## getDeletedSasDefinition
  ## The Get Deleted SAS Definition operation returns the specified deleted SAS definition along with its attributes. This operation requires the storage/getsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_564489 = newJObject()
  var query_564490 = newJObject()
  add(query_564490, "api-version", newJString(apiVersion))
  add(path_564489, "storage-account-name", newJString(storageAccountName))
  add(path_564489, "sas-definition-name", newJString(sasDefinitionName))
  result = call_564488.call(path_564489, query_564490, nil, nil, nil)

var getDeletedSasDefinition* = Call_GetDeletedSasDefinition_564481(
    name: "getDeletedSasDefinition", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedstorage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_GetDeletedSasDefinition_564482, base: "",
    url: url_GetDeletedSasDefinition_564483, schemes: {Scheme.Https})
type
  Call_RecoverDeletedSasDefinition_564491 = ref object of OpenApiRestCall_563565
proc url_RecoverDeletedSasDefinition_564493(protocol: Scheme; host: string;
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

proc validate_RecoverDeletedSasDefinition_564492(path: JsonNode; query: JsonNode;
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
  var valid_564494 = path.getOrDefault("storage-account-name")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "storage-account-name", valid_564494
  var valid_564495 = path.getOrDefault("sas-definition-name")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "sas-definition-name", valid_564495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564496 = query.getOrDefault("api-version")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "api-version", valid_564496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564497: Call_RecoverDeletedSasDefinition_564491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recovers the deleted SAS definition for the specified storage account. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ## 
  let valid = call_564497.validator(path, query, header, formData, body)
  let scheme = call_564497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564497.url(scheme.get, call_564497.host, call_564497.base,
                         call_564497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564497, url, valid)

proc call*(call_564498: Call_RecoverDeletedSasDefinition_564491;
          apiVersion: string; storageAccountName: string; sasDefinitionName: string): Recallable =
  ## recoverDeletedSasDefinition
  ## Recovers the deleted SAS definition for the specified storage account. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_564499 = newJObject()
  var query_564500 = newJObject()
  add(query_564500, "api-version", newJString(apiVersion))
  add(path_564499, "storage-account-name", newJString(storageAccountName))
  add(path_564499, "sas-definition-name", newJString(sasDefinitionName))
  result = call_564498.call(path_564499, query_564500, nil, nil, nil)

var recoverDeletedSasDefinition* = Call_RecoverDeletedSasDefinition_564491(
    name: "recoverDeletedSasDefinition", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/deletedstorage/{storage-account-name}/sas/{sas-definition-name}/recover",
    validator: validate_RecoverDeletedSasDefinition_564492, base: "",
    url: url_RecoverDeletedSasDefinition_564493, schemes: {Scheme.Https})
type
  Call_GetKeys_564501 = ref object of OpenApiRestCall_563565
proc url_GetKeys_564503(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetKeys_564502(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564504 = query.getOrDefault("api-version")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "api-version", valid_564504
  var valid_564505 = query.getOrDefault("maxresults")
  valid_564505 = validateParameter(valid_564505, JInt, required = false, default = nil)
  if valid_564505 != nil:
    section.add "maxresults", valid_564505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564506: Call_GetKeys_564501; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a stored key. The LIST operation is applicable to all key types, however only the base key identifier, attributes, and tags are provided in the response. Individual versions of a key are not listed in the response. This operation requires the keys/list permission.
  ## 
  let valid = call_564506.validator(path, query, header, formData, body)
  let scheme = call_564506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564506.url(scheme.get, call_564506.host, call_564506.base,
                         call_564506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564506, url, valid)

proc call*(call_564507: Call_GetKeys_564501; apiVersion: string; maxresults: int = 0): Recallable =
  ## getKeys
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a stored key. The LIST operation is applicable to all key types, however only the base key identifier, attributes, and tags are provided in the response. Individual versions of a key are not listed in the response. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564508 = newJObject()
  add(query_564508, "api-version", newJString(apiVersion))
  add(query_564508, "maxresults", newJInt(maxresults))
  result = call_564507.call(nil, query_564508, nil, nil, nil)

var getKeys* = Call_GetKeys_564501(name: "getKeys", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/keys",
                                validator: validate_GetKeys_564502, base: "",
                                url: url_GetKeys_564503, schemes: {Scheme.Https})
type
  Call_RestoreKey_564509 = ref object of OpenApiRestCall_563565
proc url_RestoreKey_564511(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreKey_564510(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564512 = query.getOrDefault("api-version")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "api-version", valid_564512
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

proc call*(call_564514: Call_RestoreKey_564509; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a previously backed up key into Azure Key Vault, restoring the key, its key identifier, attributes and access control policies. The RESTORE operation may be used to import a previously backed up key. Individual versions of a key cannot be restored. The key is restored in its entirety with the same key name as it had when it was backed up. If the key name is not available in the target Key Vault, the RESTORE operation will be rejected. While the key name is retained during restore, the final key identifier will change if the key is restored to a different vault. Restore will restore all versions and preserve version identifiers. The RESTORE operation is subject to security constraints: The target Key Vault must be owned by the same Microsoft Azure Subscription as the source Key Vault The user must have RESTORE permission in the target Key Vault. This operation requires the keys/restore permission.
  ## 
  let valid = call_564514.validator(path, query, header, formData, body)
  let scheme = call_564514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564514.url(scheme.get, call_564514.host, call_564514.base,
                         call_564514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564514, url, valid)

proc call*(call_564515: Call_RestoreKey_564509; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreKey
  ## Imports a previously backed up key into Azure Key Vault, restoring the key, its key identifier, attributes and access control policies. The RESTORE operation may be used to import a previously backed up key. Individual versions of a key cannot be restored. The key is restored in its entirety with the same key name as it had when it was backed up. If the key name is not available in the target Key Vault, the RESTORE operation will be rejected. While the key name is retained during restore, the final key identifier will change if the key is restored to a different vault. Restore will restore all versions and preserve version identifiers. The RESTORE operation is subject to security constraints: The target Key Vault must be owned by the same Microsoft Azure Subscription as the source Key Vault The user must have RESTORE permission in the target Key Vault. This operation requires the keys/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the key.
  var query_564516 = newJObject()
  var body_564517 = newJObject()
  add(query_564516, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564517 = parameters
  result = call_564515.call(nil, query_564516, nil, nil, body_564517)

var restoreKey* = Call_RestoreKey_564509(name: "restoreKey",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/keys/restore",
                                      validator: validate_RestoreKey_564510,
                                      base: "", url: url_RestoreKey_564511,
                                      schemes: {Scheme.Https})
type
  Call_ImportKey_564518 = ref object of OpenApiRestCall_563565
proc url_ImportKey_564520(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImportKey_564519(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564521 = path.getOrDefault("key-name")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "key-name", valid_564521
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564522 = query.getOrDefault("api-version")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "api-version", valid_564522
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

proc call*(call_564524: Call_ImportKey_564518; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The import key operation may be used to import any key type into an Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. This operation requires the keys/import permission.
  ## 
  let valid = call_564524.validator(path, query, header, formData, body)
  let scheme = call_564524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564524.url(scheme.get, call_564524.host, call_564524.base,
                         call_564524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564524, url, valid)

proc call*(call_564525: Call_ImportKey_564518; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## importKey
  ## The import key operation may be used to import any key type into an Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. This operation requires the keys/import permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to import a key.
  ##   keyName: string (required)
  ##          : Name for the imported key.
  var path_564526 = newJObject()
  var query_564527 = newJObject()
  var body_564528 = newJObject()
  add(query_564527, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564528 = parameters
  add(path_564526, "key-name", newJString(keyName))
  result = call_564525.call(path_564526, query_564527, nil, nil, body_564528)

var importKey* = Call_ImportKey_564518(name: "importKey", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_ImportKey_564519,
                                    base: "", url: url_ImportKey_564520,
                                    schemes: {Scheme.Https})
type
  Call_DeleteKey_564529 = ref object of OpenApiRestCall_563565
proc url_DeleteKey_564531(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DeleteKey_564530(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564532 = path.getOrDefault("key-name")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "key-name", valid_564532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564533 = query.getOrDefault("api-version")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "api-version", valid_564533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564534: Call_DeleteKey_564529; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete key operation cannot be used to remove individual versions of a key. This operation removes the cryptographic material associated with the key, which means the key is not usable for Sign/Verify, Wrap/Unwrap or Encrypt/Decrypt operations. This operation requires the keys/delete permission.
  ## 
  let valid = call_564534.validator(path, query, header, formData, body)
  let scheme = call_564534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564534.url(scheme.get, call_564534.host, call_564534.base,
                         call_564534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564534, url, valid)

proc call*(call_564535: Call_DeleteKey_564529; apiVersion: string; keyName: string): Recallable =
  ## deleteKey
  ## The delete key operation cannot be used to remove individual versions of a key. This operation removes the cryptographic material associated with the key, which means the key is not usable for Sign/Verify, Wrap/Unwrap or Encrypt/Decrypt operations. This operation requires the keys/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key to delete.
  var path_564536 = newJObject()
  var query_564537 = newJObject()
  add(query_564537, "api-version", newJString(apiVersion))
  add(path_564536, "key-name", newJString(keyName))
  result = call_564535.call(path_564536, query_564537, nil, nil, nil)

var deleteKey* = Call_DeleteKey_564529(name: "deleteKey",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_DeleteKey_564530,
                                    base: "", url: url_DeleteKey_564531,
                                    schemes: {Scheme.Https})
type
  Call_BackupKey_564538 = ref object of OpenApiRestCall_563565
proc url_BackupKey_564540(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BackupKey_564539(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564541 = path.getOrDefault("key-name")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "key-name", valid_564541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564542 = query.getOrDefault("api-version")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "api-version", valid_564542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564543: Call_BackupKey_564538; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Key Backup operation exports a key from Azure Key Vault in a protected form. Note that this operation does NOT return key material in a form that can be used outside the Azure Key Vault system, the returned key material is either protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of this operation is to allow a client to GENERATE a key in one Azure Key Vault instance, BACKUP the key, and then RESTORE it into another Azure Key Vault instance. The BACKUP operation may be used to export, in protected form, any key type from Azure Key Vault. Individual versions of a key cannot be backed up. BACKUP / RESTORE can be performed within geographical boundaries only; meaning that a BACKUP from one geographical area cannot be restored to another geographical area. For example, a backup from the US geographical area cannot be restored in an EU geographical area. This operation requires the key/backup permission.
  ## 
  let valid = call_564543.validator(path, query, header, formData, body)
  let scheme = call_564543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564543.url(scheme.get, call_564543.host, call_564543.base,
                         call_564543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564543, url, valid)

proc call*(call_564544: Call_BackupKey_564538; apiVersion: string; keyName: string): Recallable =
  ## backupKey
  ## The Key Backup operation exports a key from Azure Key Vault in a protected form. Note that this operation does NOT return key material in a form that can be used outside the Azure Key Vault system, the returned key material is either protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of this operation is to allow a client to GENERATE a key in one Azure Key Vault instance, BACKUP the key, and then RESTORE it into another Azure Key Vault instance. The BACKUP operation may be used to export, in protected form, any key type from Azure Key Vault. Individual versions of a key cannot be backed up. BACKUP / RESTORE can be performed within geographical boundaries only; meaning that a BACKUP from one geographical area cannot be restored to another geographical area. For example, a backup from the US geographical area cannot be restored in an EU geographical area. This operation requires the key/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_564545 = newJObject()
  var query_564546 = newJObject()
  add(query_564546, "api-version", newJString(apiVersion))
  add(path_564545, "key-name", newJString(keyName))
  result = call_564544.call(path_564545, query_564546, nil, nil, nil)

var backupKey* = Call_BackupKey_564538(name: "backupKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/backup",
                                    validator: validate_BackupKey_564539,
                                    base: "", url: url_BackupKey_564540,
                                    schemes: {Scheme.Https})
type
  Call_CreateKey_564547 = ref object of OpenApiRestCall_563565
proc url_CreateKey_564549(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CreateKey_564548(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564560 = path.getOrDefault("key-name")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "key-name", valid_564560
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564561 = query.getOrDefault("api-version")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "api-version", valid_564561
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

proc call*(call_564563: Call_CreateKey_564547; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The create key operation can be used to create any key type in Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. It requires the keys/create permission.
  ## 
  let valid = call_564563.validator(path, query, header, formData, body)
  let scheme = call_564563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564563.url(scheme.get, call_564563.host, call_564563.base,
                         call_564563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564563, url, valid)

proc call*(call_564564: Call_CreateKey_564547; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## createKey
  ## The create key operation can be used to create any key type in Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. It requires the keys/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to create a key.
  ##   keyName: string (required)
  ##          : The name for the new key. The system will generate the version name for the new key.
  var path_564565 = newJObject()
  var query_564566 = newJObject()
  var body_564567 = newJObject()
  add(query_564566, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564567 = parameters
  add(path_564565, "key-name", newJString(keyName))
  result = call_564564.call(path_564565, query_564566, nil, nil, body_564567)

var createKey* = Call_CreateKey_564547(name: "createKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/create",
                                    validator: validate_CreateKey_564548,
                                    base: "", url: url_CreateKey_564549,
                                    schemes: {Scheme.Https})
type
  Call_GetKeyVersions_564568 = ref object of OpenApiRestCall_563565
proc url_GetKeyVersions_564570(protocol: Scheme; host: string; base: string;
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

proc validate_GetKeyVersions_564569(path: JsonNode; query: JsonNode;
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
  var valid_564571 = path.getOrDefault("key-name")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "key-name", valid_564571
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564572 = query.getOrDefault("api-version")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "api-version", valid_564572
  var valid_564573 = query.getOrDefault("maxresults")
  valid_564573 = validateParameter(valid_564573, JInt, required = false, default = nil)
  if valid_564573 != nil:
    section.add "maxresults", valid_564573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564574: Call_GetKeyVersions_564568; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The full key identifier, attributes, and tags are provided in the response. This operation requires the keys/list permission.
  ## 
  let valid = call_564574.validator(path, query, header, formData, body)
  let scheme = call_564574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564574.url(scheme.get, call_564574.host, call_564574.base,
                         call_564574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564574, url, valid)

proc call*(call_564575: Call_GetKeyVersions_564568; apiVersion: string;
          keyName: string; maxresults: int = 0): Recallable =
  ## getKeyVersions
  ## The full key identifier, attributes, and tags are provided in the response. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_564576 = newJObject()
  var query_564577 = newJObject()
  add(query_564577, "api-version", newJString(apiVersion))
  add(query_564577, "maxresults", newJInt(maxresults))
  add(path_564576, "key-name", newJString(keyName))
  result = call_564575.call(path_564576, query_564577, nil, nil, nil)

var getKeyVersions* = Call_GetKeyVersions_564568(name: "getKeyVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/keys/{key-name}/versions", validator: validate_GetKeyVersions_564569,
    base: "", url: url_GetKeyVersions_564570, schemes: {Scheme.Https})
type
  Call_GetKey_564578 = ref object of OpenApiRestCall_563565
proc url_GetKey_564580(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetKey_564579(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564581 = path.getOrDefault("key-version")
  valid_564581 = validateParameter(valid_564581, JString, required = true,
                                 default = nil)
  if valid_564581 != nil:
    section.add "key-version", valid_564581
  var valid_564582 = path.getOrDefault("key-name")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "key-name", valid_564582
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564583 = query.getOrDefault("api-version")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "api-version", valid_564583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564584: Call_GetKey_564578; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The get key operation is applicable to all key types. If the requested key is symmetric, then no key material is released in the response. This operation requires the keys/get permission.
  ## 
  let valid = call_564584.validator(path, query, header, formData, body)
  let scheme = call_564584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564584.url(scheme.get, call_564584.host, call_564584.base,
                         call_564584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564584, url, valid)

proc call*(call_564585: Call_GetKey_564578; apiVersion: string; keyVersion: string;
          keyName: string): Recallable =
  ## getKey
  ## The get key operation is applicable to all key types. If the requested key is symmetric, then no key material is released in the response. This operation requires the keys/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyVersion: string (required)
  ##             : Adding the version parameter retrieves a specific version of a key.
  ##   keyName: string (required)
  ##          : The name of the key to get.
  var path_564586 = newJObject()
  var query_564587 = newJObject()
  add(query_564587, "api-version", newJString(apiVersion))
  add(path_564586, "key-version", newJString(keyVersion))
  add(path_564586, "key-name", newJString(keyName))
  result = call_564585.call(path_564586, query_564587, nil, nil, nil)

var getKey* = Call_GetKey_564578(name: "getKey", meth: HttpMethod.HttpGet,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}",
                              validator: validate_GetKey_564579, base: "",
                              url: url_GetKey_564580, schemes: {Scheme.Https})
type
  Call_UpdateKey_564588 = ref object of OpenApiRestCall_563565
proc url_UpdateKey_564590(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UpdateKey_564589(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564591 = path.getOrDefault("key-version")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "key-version", valid_564591
  var valid_564592 = path.getOrDefault("key-name")
  valid_564592 = validateParameter(valid_564592, JString, required = true,
                                 default = nil)
  if valid_564592 != nil:
    section.add "key-name", valid_564592
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564593 = query.getOrDefault("api-version")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "api-version", valid_564593
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

proc call*(call_564595: Call_UpdateKey_564588; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## In order to perform this operation, the key must already exist in the Key Vault. Note: The cryptographic material of a key itself cannot be changed. This operation requires the keys/update permission.
  ## 
  let valid = call_564595.validator(path, query, header, formData, body)
  let scheme = call_564595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564595.url(scheme.get, call_564595.host, call_564595.base,
                         call_564595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564595, url, valid)

proc call*(call_564596: Call_UpdateKey_564588; apiVersion: string;
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
  var path_564597 = newJObject()
  var query_564598 = newJObject()
  var body_564599 = newJObject()
  add(query_564598, "api-version", newJString(apiVersion))
  add(path_564597, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564599 = parameters
  add(path_564597, "key-name", newJString(keyName))
  result = call_564596.call(path_564597, query_564598, nil, nil, body_564599)

var updateKey* = Call_UpdateKey_564588(name: "updateKey", meth: HttpMethod.HttpPatch,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/{key-version}",
                                    validator: validate_UpdateKey_564589,
                                    base: "", url: url_UpdateKey_564590,
                                    schemes: {Scheme.Https})
type
  Call_Decrypt_564600 = ref object of OpenApiRestCall_563565
proc url_Decrypt_564602(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Decrypt_564601(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564603 = path.getOrDefault("key-version")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "key-version", valid_564603
  var valid_564604 = path.getOrDefault("key-name")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = nil)
  if valid_564604 != nil:
    section.add "key-name", valid_564604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564605 = query.getOrDefault("api-version")
  valid_564605 = validateParameter(valid_564605, JString, required = true,
                                 default = nil)
  if valid_564605 != nil:
    section.add "api-version", valid_564605
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

proc call*(call_564607: Call_Decrypt_564600; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DECRYPT operation decrypts a well-formed block of ciphertext using the target encryption key and specified algorithm. This operation is the reverse of the ENCRYPT operation; only a single block of data may be decrypted, the size of this block is dependent on the target key and the algorithm to be used. The DECRYPT operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/decrypt permission.
  ## 
  let valid = call_564607.validator(path, query, header, formData, body)
  let scheme = call_564607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564607.url(scheme.get, call_564607.host, call_564607.base,
                         call_564607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564607, url, valid)

proc call*(call_564608: Call_Decrypt_564600; apiVersion: string; keyVersion: string;
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
  var path_564609 = newJObject()
  var query_564610 = newJObject()
  var body_564611 = newJObject()
  add(query_564610, "api-version", newJString(apiVersion))
  add(path_564609, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564611 = parameters
  add(path_564609, "key-name", newJString(keyName))
  result = call_564608.call(path_564609, query_564610, nil, nil, body_564611)

var decrypt* = Call_Decrypt_564600(name: "decrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/decrypt",
                                validator: validate_Decrypt_564601, base: "",
                                url: url_Decrypt_564602, schemes: {Scheme.Https})
type
  Call_Encrypt_564612 = ref object of OpenApiRestCall_563565
proc url_Encrypt_564614(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Encrypt_564613(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564615 = path.getOrDefault("key-version")
  valid_564615 = validateParameter(valid_564615, JString, required = true,
                                 default = nil)
  if valid_564615 != nil:
    section.add "key-version", valid_564615
  var valid_564616 = path.getOrDefault("key-name")
  valid_564616 = validateParameter(valid_564616, JString, required = true,
                                 default = nil)
  if valid_564616 != nil:
    section.add "key-name", valid_564616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564617 = query.getOrDefault("api-version")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "api-version", valid_564617
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

proc call*(call_564619: Call_Encrypt_564612; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The ENCRYPT operation encrypts an arbitrary sequence of bytes using an encryption key that is stored in Azure Key Vault. Note that the ENCRYPT operation only supports a single block of data, the size of which is dependent on the target key and the encryption algorithm to be used. The ENCRYPT operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/encrypt permission.
  ## 
  let valid = call_564619.validator(path, query, header, formData, body)
  let scheme = call_564619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564619.url(scheme.get, call_564619.host, call_564619.base,
                         call_564619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564619, url, valid)

proc call*(call_564620: Call_Encrypt_564612; apiVersion: string; keyVersion: string;
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
  var path_564621 = newJObject()
  var query_564622 = newJObject()
  var body_564623 = newJObject()
  add(query_564622, "api-version", newJString(apiVersion))
  add(path_564621, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564623 = parameters
  add(path_564621, "key-name", newJString(keyName))
  result = call_564620.call(path_564621, query_564622, nil, nil, body_564623)

var encrypt* = Call_Encrypt_564612(name: "encrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/encrypt",
                                validator: validate_Encrypt_564613, base: "",
                                url: url_Encrypt_564614, schemes: {Scheme.Https})
type
  Call_Sign_564624 = ref object of OpenApiRestCall_563565
proc url_Sign_564626(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Sign_564625(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564627 = path.getOrDefault("key-version")
  valid_564627 = validateParameter(valid_564627, JString, required = true,
                                 default = nil)
  if valid_564627 != nil:
    section.add "key-version", valid_564627
  var valid_564628 = path.getOrDefault("key-name")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "key-name", valid_564628
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564629 = query.getOrDefault("api-version")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "api-version", valid_564629
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

proc call*(call_564631: Call_Sign_564624; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The SIGN operation is applicable to asymmetric and symmetric keys stored in Azure Key Vault since this operation uses the private portion of the key. This operation requires the keys/sign permission.
  ## 
  let valid = call_564631.validator(path, query, header, formData, body)
  let scheme = call_564631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564631.url(scheme.get, call_564631.host, call_564631.base,
                         call_564631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564631, url, valid)

proc call*(call_564632: Call_Sign_564624; apiVersion: string; keyVersion: string;
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
  var path_564633 = newJObject()
  var query_564634 = newJObject()
  var body_564635 = newJObject()
  add(query_564634, "api-version", newJString(apiVersion))
  add(path_564633, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564635 = parameters
  add(path_564633, "key-name", newJString(keyName))
  result = call_564632.call(path_564633, query_564634, nil, nil, body_564635)

var sign* = Call_Sign_564624(name: "sign", meth: HttpMethod.HttpPost,
                          host: "azure.local",
                          route: "/keys/{key-name}/{key-version}/sign",
                          validator: validate_Sign_564625, base: "", url: url_Sign_564626,
                          schemes: {Scheme.Https})
type
  Call_UnwrapKey_564636 = ref object of OpenApiRestCall_563565
proc url_UnwrapKey_564638(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UnwrapKey_564637(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564639 = path.getOrDefault("key-version")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = nil)
  if valid_564639 != nil:
    section.add "key-version", valid_564639
  var valid_564640 = path.getOrDefault("key-name")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "key-name", valid_564640
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564641 = query.getOrDefault("api-version")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "api-version", valid_564641
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

proc call*(call_564643: Call_UnwrapKey_564636; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UNWRAP operation supports decryption of a symmetric key using the target key encryption key. This operation is the reverse of the WRAP operation. The UNWRAP operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/unwrapKey permission.
  ## 
  let valid = call_564643.validator(path, query, header, formData, body)
  let scheme = call_564643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564643.url(scheme.get, call_564643.host, call_564643.base,
                         call_564643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564643, url, valid)

proc call*(call_564644: Call_UnwrapKey_564636; apiVersion: string;
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
  var path_564645 = newJObject()
  var query_564646 = newJObject()
  var body_564647 = newJObject()
  add(query_564646, "api-version", newJString(apiVersion))
  add(path_564645, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564647 = parameters
  add(path_564645, "key-name", newJString(keyName))
  result = call_564644.call(path_564645, query_564646, nil, nil, body_564647)

var unwrapKey* = Call_UnwrapKey_564636(name: "unwrapKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/keys/{key-name}/{key-version}/unwrapkey",
                                    validator: validate_UnwrapKey_564637,
                                    base: "", url: url_UnwrapKey_564638,
                                    schemes: {Scheme.Https})
type
  Call_Verify_564648 = ref object of OpenApiRestCall_563565
proc url_Verify_564650(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Verify_564649(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564651 = path.getOrDefault("key-version")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "key-version", valid_564651
  var valid_564652 = path.getOrDefault("key-name")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "key-name", valid_564652
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564653 = query.getOrDefault("api-version")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "api-version", valid_564653
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

proc call*(call_564655: Call_Verify_564648; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The VERIFY operation is applicable to symmetric keys stored in Azure Key Vault. VERIFY is not strictly necessary for asymmetric keys stored in Azure Key Vault since signature verification can be performed using the public portion of the key but this operation is supported as a convenience for callers that only have a key-reference and not the public portion of the key. This operation requires the keys/verify permission.
  ## 
  let valid = call_564655.validator(path, query, header, formData, body)
  let scheme = call_564655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564655.url(scheme.get, call_564655.host, call_564655.base,
                         call_564655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564655, url, valid)

proc call*(call_564656: Call_Verify_564648; apiVersion: string; keyVersion: string;
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
  var path_564657 = newJObject()
  var query_564658 = newJObject()
  var body_564659 = newJObject()
  add(query_564658, "api-version", newJString(apiVersion))
  add(path_564657, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564659 = parameters
  add(path_564657, "key-name", newJString(keyName))
  result = call_564656.call(path_564657, query_564658, nil, nil, body_564659)

var verify* = Call_Verify_564648(name: "verify", meth: HttpMethod.HttpPost,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}/verify",
                              validator: validate_Verify_564649, base: "",
                              url: url_Verify_564650, schemes: {Scheme.Https})
type
  Call_WrapKey_564660 = ref object of OpenApiRestCall_563565
proc url_WrapKey_564662(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_WrapKey_564661(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564663 = path.getOrDefault("key-version")
  valid_564663 = validateParameter(valid_564663, JString, required = true,
                                 default = nil)
  if valid_564663 != nil:
    section.add "key-version", valid_564663
  var valid_564664 = path.getOrDefault("key-name")
  valid_564664 = validateParameter(valid_564664, JString, required = true,
                                 default = nil)
  if valid_564664 != nil:
    section.add "key-name", valid_564664
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564665 = query.getOrDefault("api-version")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "api-version", valid_564665
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

proc call*(call_564667: Call_WrapKey_564660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The WRAP operation supports encryption of a symmetric key using a key encryption key that has previously been stored in an Azure Key Vault. The WRAP operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using the public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/wrapKey permission.
  ## 
  let valid = call_564667.validator(path, query, header, formData, body)
  let scheme = call_564667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564667.url(scheme.get, call_564667.host, call_564667.base,
                         call_564667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564667, url, valid)

proc call*(call_564668: Call_WrapKey_564660; apiVersion: string; keyVersion: string;
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
  var path_564669 = newJObject()
  var query_564670 = newJObject()
  var body_564671 = newJObject()
  add(query_564670, "api-version", newJString(apiVersion))
  add(path_564669, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564671 = parameters
  add(path_564669, "key-name", newJString(keyName))
  result = call_564668.call(path_564669, query_564670, nil, nil, body_564671)

var wrapKey* = Call_WrapKey_564660(name: "wrapKey", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/wrapkey",
                                validator: validate_WrapKey_564661, base: "",
                                url: url_WrapKey_564662, schemes: {Scheme.Https})
type
  Call_GetSecrets_564672 = ref object of OpenApiRestCall_563565
proc url_GetSecrets_564674(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetSecrets_564673(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564675 = query.getOrDefault("api-version")
  valid_564675 = validateParameter(valid_564675, JString, required = true,
                                 default = nil)
  if valid_564675 != nil:
    section.add "api-version", valid_564675
  var valid_564676 = query.getOrDefault("maxresults")
  valid_564676 = validateParameter(valid_564676, JInt, required = false, default = nil)
  if valid_564676 != nil:
    section.add "maxresults", valid_564676
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564677: Call_GetSecrets_564672; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Secrets operation is applicable to the entire vault. However, only the base secret identifier and its attributes are provided in the response. Individual secret versions are not listed in the response. This operation requires the secrets/list permission.
  ## 
  let valid = call_564677.validator(path, query, header, formData, body)
  let scheme = call_564677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564677.url(scheme.get, call_564677.host, call_564677.base,
                         call_564677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564677, url, valid)

proc call*(call_564678: Call_GetSecrets_564672; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getSecrets
  ## The Get Secrets operation is applicable to the entire vault. However, only the base secret identifier and its attributes are provided in the response. Individual secret versions are not listed in the response. This operation requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  var query_564679 = newJObject()
  add(query_564679, "api-version", newJString(apiVersion))
  add(query_564679, "maxresults", newJInt(maxresults))
  result = call_564678.call(nil, query_564679, nil, nil, nil)

var getSecrets* = Call_GetSecrets_564672(name: "getSecrets",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/secrets",
                                      validator: validate_GetSecrets_564673,
                                      base: "", url: url_GetSecrets_564674,
                                      schemes: {Scheme.Https})
type
  Call_RestoreSecret_564680 = ref object of OpenApiRestCall_563565
proc url_RestoreSecret_564682(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreSecret_564681(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564683 = query.getOrDefault("api-version")
  valid_564683 = validateParameter(valid_564683, JString, required = true,
                                 default = nil)
  if valid_564683 != nil:
    section.add "api-version", valid_564683
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

proc call*(call_564685: Call_RestoreSecret_564680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backed up secret, and all its versions, to a vault. This operation requires the secrets/restore permission.
  ## 
  let valid = call_564685.validator(path, query, header, formData, body)
  let scheme = call_564685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564685.url(scheme.get, call_564685.host, call_564685.base,
                         call_564685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564685, url, valid)

proc call*(call_564686: Call_RestoreSecret_564680; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreSecret
  ## Restores a backed up secret, and all its versions, to a vault. This operation requires the secrets/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the secret.
  var query_564687 = newJObject()
  var body_564688 = newJObject()
  add(query_564687, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564688 = parameters
  result = call_564686.call(nil, query_564687, nil, nil, body_564688)

var restoreSecret* = Call_RestoreSecret_564680(name: "restoreSecret",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/secrets/restore",
    validator: validate_RestoreSecret_564681, base: "", url: url_RestoreSecret_564682,
    schemes: {Scheme.Https})
type
  Call_SetSecret_564689 = ref object of OpenApiRestCall_563565
proc url_SetSecret_564691(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SetSecret_564690(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564692 = path.getOrDefault("secret-name")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "secret-name", valid_564692
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564693 = query.getOrDefault("api-version")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "api-version", valid_564693
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

proc call*(call_564695: Call_SetSecret_564689; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ##  The SET operation adds a secret to the Azure Key Vault. If the named secret already exists, Azure Key Vault creates a new version of that secret. This operation requires the secrets/set permission.
  ## 
  let valid = call_564695.validator(path, query, header, formData, body)
  let scheme = call_564695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564695.url(scheme.get, call_564695.host, call_564695.base,
                         call_564695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564695, url, valid)

proc call*(call_564696: Call_SetSecret_564689; apiVersion: string;
          secretName: string; parameters: JsonNode): Recallable =
  ## setSecret
  ##  The SET operation adds a secret to the Azure Key Vault. If the named secret already exists, Azure Key Vault creates a new version of that secret. This operation requires the secrets/set permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  ##   parameters: JObject (required)
  ##             : The parameters for setting the secret.
  var path_564697 = newJObject()
  var query_564698 = newJObject()
  var body_564699 = newJObject()
  add(query_564698, "api-version", newJString(apiVersion))
  add(path_564697, "secret-name", newJString(secretName))
  if parameters != nil:
    body_564699 = parameters
  result = call_564696.call(path_564697, query_564698, nil, nil, body_564699)

var setSecret* = Call_SetSecret_564689(name: "setSecret", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/secrets/{secret-name}",
                                    validator: validate_SetSecret_564690,
                                    base: "", url: url_SetSecret_564691,
                                    schemes: {Scheme.Https})
type
  Call_DeleteSecret_564700 = ref object of OpenApiRestCall_563565
proc url_DeleteSecret_564702(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteSecret_564701(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564703 = path.getOrDefault("secret-name")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "secret-name", valid_564703
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564704 = query.getOrDefault("api-version")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "api-version", valid_564704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564705: Call_DeleteSecret_564700; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DELETE operation applies to any secret stored in Azure Key Vault. DELETE cannot be applied to an individual version of a secret. This operation requires the secrets/delete permission.
  ## 
  let valid = call_564705.validator(path, query, header, formData, body)
  let scheme = call_564705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564705.url(scheme.get, call_564705.host, call_564705.base,
                         call_564705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564705, url, valid)

proc call*(call_564706: Call_DeleteSecret_564700; apiVersion: string;
          secretName: string): Recallable =
  ## deleteSecret
  ## The DELETE operation applies to any secret stored in Azure Key Vault. DELETE cannot be applied to an individual version of a secret. This operation requires the secrets/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_564707 = newJObject()
  var query_564708 = newJObject()
  add(query_564708, "api-version", newJString(apiVersion))
  add(path_564707, "secret-name", newJString(secretName))
  result = call_564706.call(path_564707, query_564708, nil, nil, nil)

var deleteSecret* = Call_DeleteSecret_564700(name: "deleteSecret",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/secrets/{secret-name}", validator: validate_DeleteSecret_564701,
    base: "", url: url_DeleteSecret_564702, schemes: {Scheme.Https})
type
  Call_BackupSecret_564709 = ref object of OpenApiRestCall_563565
proc url_BackupSecret_564711(protocol: Scheme; host: string; base: string;
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

proc validate_BackupSecret_564710(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564712 = path.getOrDefault("secret-name")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "secret-name", valid_564712
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564713 = query.getOrDefault("api-version")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "api-version", valid_564713
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564714: Call_BackupSecret_564709; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified secret be downloaded to the client. All versions of the secret will be downloaded. This operation requires the secrets/backup permission.
  ## 
  let valid = call_564714.validator(path, query, header, formData, body)
  let scheme = call_564714.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564714.url(scheme.get, call_564714.host, call_564714.base,
                         call_564714.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564714, url, valid)

proc call*(call_564715: Call_BackupSecret_564709; apiVersion: string;
          secretName: string): Recallable =
  ## backupSecret
  ## Requests that a backup of the specified secret be downloaded to the client. All versions of the secret will be downloaded. This operation requires the secrets/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_564716 = newJObject()
  var query_564717 = newJObject()
  add(query_564717, "api-version", newJString(apiVersion))
  add(path_564716, "secret-name", newJString(secretName))
  result = call_564715.call(path_564716, query_564717, nil, nil, nil)

var backupSecret* = Call_BackupSecret_564709(name: "backupSecret",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/secrets/{secret-name}/backup", validator: validate_BackupSecret_564710,
    base: "", url: url_BackupSecret_564711, schemes: {Scheme.Https})
type
  Call_GetSecretVersions_564718 = ref object of OpenApiRestCall_563565
proc url_GetSecretVersions_564720(protocol: Scheme; host: string; base: string;
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

proc validate_GetSecretVersions_564719(path: JsonNode; query: JsonNode;
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
  var valid_564721 = path.getOrDefault("secret-name")
  valid_564721 = validateParameter(valid_564721, JString, required = true,
                                 default = nil)
  if valid_564721 != nil:
    section.add "secret-name", valid_564721
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564722 = query.getOrDefault("api-version")
  valid_564722 = validateParameter(valid_564722, JString, required = true,
                                 default = nil)
  if valid_564722 != nil:
    section.add "api-version", valid_564722
  var valid_564723 = query.getOrDefault("maxresults")
  valid_564723 = validateParameter(valid_564723, JInt, required = false, default = nil)
  if valid_564723 != nil:
    section.add "maxresults", valid_564723
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564724: Call_GetSecretVersions_564718; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The full secret identifier and attributes are provided in the response. No values are returned for the secrets. This operations requires the secrets/list permission.
  ## 
  let valid = call_564724.validator(path, query, header, formData, body)
  let scheme = call_564724.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564724.url(scheme.get, call_564724.host, call_564724.base,
                         call_564724.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564724, url, valid)

proc call*(call_564725: Call_GetSecretVersions_564718; apiVersion: string;
          secretName: string; maxresults: int = 0): Recallable =
  ## getSecretVersions
  ## The full secret identifier and attributes are provided in the response. No values are returned for the secrets. This operations requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  var path_564726 = newJObject()
  var query_564727 = newJObject()
  add(query_564727, "api-version", newJString(apiVersion))
  add(path_564726, "secret-name", newJString(secretName))
  add(query_564727, "maxresults", newJInt(maxresults))
  result = call_564725.call(path_564726, query_564727, nil, nil, nil)

var getSecretVersions* = Call_GetSecretVersions_564718(name: "getSecretVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/secrets/{secret-name}/versions",
    validator: validate_GetSecretVersions_564719, base: "",
    url: url_GetSecretVersions_564720, schemes: {Scheme.Https})
type
  Call_GetSecret_564728 = ref object of OpenApiRestCall_563565
proc url_GetSecret_564730(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetSecret_564729(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564731 = path.getOrDefault("secret-version")
  valid_564731 = validateParameter(valid_564731, JString, required = true,
                                 default = nil)
  if valid_564731 != nil:
    section.add "secret-version", valid_564731
  var valid_564732 = path.getOrDefault("secret-name")
  valid_564732 = validateParameter(valid_564732, JString, required = true,
                                 default = nil)
  if valid_564732 != nil:
    section.add "secret-name", valid_564732
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564733 = query.getOrDefault("api-version")
  valid_564733 = validateParameter(valid_564733, JString, required = true,
                                 default = nil)
  if valid_564733 != nil:
    section.add "api-version", valid_564733
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564734: Call_GetSecret_564728; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GET operation is applicable to any secret stored in Azure Key Vault. This operation requires the secrets/get permission.
  ## 
  let valid = call_564734.validator(path, query, header, formData, body)
  let scheme = call_564734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564734.url(scheme.get, call_564734.host, call_564734.base,
                         call_564734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564734, url, valid)

proc call*(call_564735: Call_GetSecret_564728; apiVersion: string;
          secretVersion: string; secretName: string): Recallable =
  ## getSecret
  ## The GET operation is applicable to any secret stored in Azure Key Vault. This operation requires the secrets/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretVersion: string (required)
  ##                : The version of the secret.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_564736 = newJObject()
  var query_564737 = newJObject()
  add(query_564737, "api-version", newJString(apiVersion))
  add(path_564736, "secret-version", newJString(secretVersion))
  add(path_564736, "secret-name", newJString(secretName))
  result = call_564735.call(path_564736, query_564737, nil, nil, nil)

var getSecret* = Call_GetSecret_564728(name: "getSecret", meth: HttpMethod.HttpGet,
                                    host: "azure.local", route: "/secrets/{secret-name}/{secret-version}",
                                    validator: validate_GetSecret_564729,
                                    base: "", url: url_GetSecret_564730,
                                    schemes: {Scheme.Https})
type
  Call_UpdateSecret_564738 = ref object of OpenApiRestCall_563565
proc url_UpdateSecret_564740(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateSecret_564739(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564741 = path.getOrDefault("secret-version")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "secret-version", valid_564741
  var valid_564742 = path.getOrDefault("secret-name")
  valid_564742 = validateParameter(valid_564742, JString, required = true,
                                 default = nil)
  if valid_564742 != nil:
    section.add "secret-name", valid_564742
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564743 = query.getOrDefault("api-version")
  valid_564743 = validateParameter(valid_564743, JString, required = true,
                                 default = nil)
  if valid_564743 != nil:
    section.add "api-version", valid_564743
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

proc call*(call_564745: Call_UpdateSecret_564738; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UPDATE operation changes specified attributes of an existing stored secret. Attributes that are not specified in the request are left unchanged. The value of a secret itself cannot be changed. This operation requires the secrets/set permission.
  ## 
  let valid = call_564745.validator(path, query, header, formData, body)
  let scheme = call_564745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564745.url(scheme.get, call_564745.host, call_564745.base,
                         call_564745.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564745, url, valid)

proc call*(call_564746: Call_UpdateSecret_564738; apiVersion: string;
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
  var path_564747 = newJObject()
  var query_564748 = newJObject()
  var body_564749 = newJObject()
  add(query_564748, "api-version", newJString(apiVersion))
  add(path_564747, "secret-version", newJString(secretVersion))
  add(path_564747, "secret-name", newJString(secretName))
  if parameters != nil:
    body_564749 = parameters
  result = call_564746.call(path_564747, query_564748, nil, nil, body_564749)

var updateSecret* = Call_UpdateSecret_564738(name: "updateSecret",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/secrets/{secret-name}/{secret-version}",
    validator: validate_UpdateSecret_564739, base: "", url: url_UpdateSecret_564740,
    schemes: {Scheme.Https})
type
  Call_GetStorageAccounts_564750 = ref object of OpenApiRestCall_563565
proc url_GetStorageAccounts_564752(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetStorageAccounts_564751(path: JsonNode; query: JsonNode;
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
  var valid_564753 = query.getOrDefault("api-version")
  valid_564753 = validateParameter(valid_564753, JString, required = true,
                                 default = nil)
  if valid_564753 != nil:
    section.add "api-version", valid_564753
  var valid_564754 = query.getOrDefault("maxresults")
  valid_564754 = validateParameter(valid_564754, JInt, required = false, default = nil)
  if valid_564754 != nil:
    section.add "maxresults", valid_564754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564755: Call_GetStorageAccounts_564750; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List storage accounts managed by the specified key vault. This operation requires the storage/list permission.
  ## 
  let valid = call_564755.validator(path, query, header, formData, body)
  let scheme = call_564755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564755.url(scheme.get, call_564755.host, call_564755.base,
                         call_564755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564755, url, valid)

proc call*(call_564756: Call_GetStorageAccounts_564750; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getStorageAccounts
  ## List storage accounts managed by the specified key vault. This operation requires the storage/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564757 = newJObject()
  add(query_564757, "api-version", newJString(apiVersion))
  add(query_564757, "maxresults", newJInt(maxresults))
  result = call_564756.call(nil, query_564757, nil, nil, nil)

var getStorageAccounts* = Call_GetStorageAccounts_564750(
    name: "getStorageAccounts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage", validator: validate_GetStorageAccounts_564751, base: "",
    url: url_GetStorageAccounts_564752, schemes: {Scheme.Https})
type
  Call_RestoreStorageAccount_564758 = ref object of OpenApiRestCall_563565
proc url_RestoreStorageAccount_564760(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreStorageAccount_564759(path: JsonNode; query: JsonNode;
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
  var valid_564761 = query.getOrDefault("api-version")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = nil)
  if valid_564761 != nil:
    section.add "api-version", valid_564761
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

proc call*(call_564763: Call_RestoreStorageAccount_564758; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backed up storage account to a vault. This operation requires the storage/restore permission.
  ## 
  let valid = call_564763.validator(path, query, header, formData, body)
  let scheme = call_564763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564763.url(scheme.get, call_564763.host, call_564763.base,
                         call_564763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564763, url, valid)

proc call*(call_564764: Call_RestoreStorageAccount_564758; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreStorageAccount
  ## Restores a backed up storage account to a vault. This operation requires the storage/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the storage account.
  var query_564765 = newJObject()
  var body_564766 = newJObject()
  add(query_564765, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564766 = parameters
  result = call_564764.call(nil, query_564765, nil, nil, body_564766)

var restoreStorageAccount* = Call_RestoreStorageAccount_564758(
    name: "restoreStorageAccount", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/storage/restore", validator: validate_RestoreStorageAccount_564759,
    base: "", url: url_RestoreStorageAccount_564760, schemes: {Scheme.Https})
type
  Call_SetStorageAccount_564776 = ref object of OpenApiRestCall_563565
proc url_SetStorageAccount_564778(protocol: Scheme; host: string; base: string;
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

proc validate_SetStorageAccount_564777(path: JsonNode; query: JsonNode;
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
  var valid_564779 = path.getOrDefault("storage-account-name")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "storage-account-name", valid_564779
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564780 = query.getOrDefault("api-version")
  valid_564780 = validateParameter(valid_564780, JString, required = true,
                                 default = nil)
  if valid_564780 != nil:
    section.add "api-version", valid_564780
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

proc call*(call_564782: Call_SetStorageAccount_564776; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new storage account. This operation requires the storage/set permission.
  ## 
  let valid = call_564782.validator(path, query, header, formData, body)
  let scheme = call_564782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564782.url(scheme.get, call_564782.host, call_564782.base,
                         call_564782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564782, url, valid)

proc call*(call_564783: Call_SetStorageAccount_564776; apiVersion: string;
          storageAccountName: string; parameters: JsonNode): Recallable =
  ## setStorageAccount
  ## Creates or updates a new storage account. This operation requires the storage/set permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to create a storage account.
  var path_564784 = newJObject()
  var query_564785 = newJObject()
  var body_564786 = newJObject()
  add(query_564785, "api-version", newJString(apiVersion))
  add(path_564784, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_564786 = parameters
  result = call_564783.call(path_564784, query_564785, nil, nil, body_564786)

var setStorageAccount* = Call_SetStorageAccount_564776(name: "setStorageAccount",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_SetStorageAccount_564777, base: "",
    url: url_SetStorageAccount_564778, schemes: {Scheme.Https})
type
  Call_GetStorageAccount_564767 = ref object of OpenApiRestCall_563565
proc url_GetStorageAccount_564769(protocol: Scheme; host: string; base: string;
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

proc validate_GetStorageAccount_564768(path: JsonNode; query: JsonNode;
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
  var valid_564770 = path.getOrDefault("storage-account-name")
  valid_564770 = validateParameter(valid_564770, JString, required = true,
                                 default = nil)
  if valid_564770 != nil:
    section.add "storage-account-name", valid_564770
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564771 = query.getOrDefault("api-version")
  valid_564771 = validateParameter(valid_564771, JString, required = true,
                                 default = nil)
  if valid_564771 != nil:
    section.add "api-version", valid_564771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564772: Call_GetStorageAccount_564767; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specified storage account. This operation requires the storage/get permission.
  ## 
  let valid = call_564772.validator(path, query, header, formData, body)
  let scheme = call_564772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564772.url(scheme.get, call_564772.host, call_564772.base,
                         call_564772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564772, url, valid)

proc call*(call_564773: Call_GetStorageAccount_564767; apiVersion: string;
          storageAccountName: string): Recallable =
  ## getStorageAccount
  ## Gets information about a specified storage account. This operation requires the storage/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_564774 = newJObject()
  var query_564775 = newJObject()
  add(query_564775, "api-version", newJString(apiVersion))
  add(path_564774, "storage-account-name", newJString(storageAccountName))
  result = call_564773.call(path_564774, query_564775, nil, nil, nil)

var getStorageAccount* = Call_GetStorageAccount_564767(name: "getStorageAccount",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_GetStorageAccount_564768, base: "",
    url: url_GetStorageAccount_564769, schemes: {Scheme.Https})
type
  Call_UpdateStorageAccount_564796 = ref object of OpenApiRestCall_563565
proc url_UpdateStorageAccount_564798(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateStorageAccount_564797(path: JsonNode; query: JsonNode;
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
  var valid_564799 = path.getOrDefault("storage-account-name")
  valid_564799 = validateParameter(valid_564799, JString, required = true,
                                 default = nil)
  if valid_564799 != nil:
    section.add "storage-account-name", valid_564799
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564800 = query.getOrDefault("api-version")
  valid_564800 = validateParameter(valid_564800, JString, required = true,
                                 default = nil)
  if valid_564800 != nil:
    section.add "api-version", valid_564800
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

proc call*(call_564802: Call_UpdateStorageAccount_564796; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified attributes associated with the given storage account. This operation requires the storage/set/update permission.
  ## 
  let valid = call_564802.validator(path, query, header, formData, body)
  let scheme = call_564802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564802.url(scheme.get, call_564802.host, call_564802.base,
                         call_564802.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564802, url, valid)

proc call*(call_564803: Call_UpdateStorageAccount_564796; apiVersion: string;
          storageAccountName: string; parameters: JsonNode): Recallable =
  ## updateStorageAccount
  ## Updates the specified attributes associated with the given storage account. This operation requires the storage/set/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to update a storage account.
  var path_564804 = newJObject()
  var query_564805 = newJObject()
  var body_564806 = newJObject()
  add(query_564805, "api-version", newJString(apiVersion))
  add(path_564804, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_564806 = parameters
  result = call_564803.call(path_564804, query_564805, nil, nil, body_564806)

var updateStorageAccount* = Call_UpdateStorageAccount_564796(
    name: "updateStorageAccount", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_UpdateStorageAccount_564797, base: "",
    url: url_UpdateStorageAccount_564798, schemes: {Scheme.Https})
type
  Call_DeleteStorageAccount_564787 = ref object of OpenApiRestCall_563565
proc url_DeleteStorageAccount_564789(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteStorageAccount_564788(path: JsonNode; query: JsonNode;
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
  var valid_564790 = path.getOrDefault("storage-account-name")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = nil)
  if valid_564790 != nil:
    section.add "storage-account-name", valid_564790
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564791 = query.getOrDefault("api-version")
  valid_564791 = validateParameter(valid_564791, JString, required = true,
                                 default = nil)
  if valid_564791 != nil:
    section.add "api-version", valid_564791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564792: Call_DeleteStorageAccount_564787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a storage account. This operation requires the storage/delete permission.
  ## 
  let valid = call_564792.validator(path, query, header, formData, body)
  let scheme = call_564792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564792.url(scheme.get, call_564792.host, call_564792.base,
                         call_564792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564792, url, valid)

proc call*(call_564793: Call_DeleteStorageAccount_564787; apiVersion: string;
          storageAccountName: string): Recallable =
  ## deleteStorageAccount
  ## Deletes a storage account. This operation requires the storage/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_564794 = newJObject()
  var query_564795 = newJObject()
  add(query_564795, "api-version", newJString(apiVersion))
  add(path_564794, "storage-account-name", newJString(storageAccountName))
  result = call_564793.call(path_564794, query_564795, nil, nil, nil)

var deleteStorageAccount* = Call_DeleteStorageAccount_564787(
    name: "deleteStorageAccount", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_DeleteStorageAccount_564788, base: "",
    url: url_DeleteStorageAccount_564789, schemes: {Scheme.Https})
type
  Call_BackupStorageAccount_564807 = ref object of OpenApiRestCall_563565
proc url_BackupStorageAccount_564809(protocol: Scheme; host: string; base: string;
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

proc validate_BackupStorageAccount_564808(path: JsonNode; query: JsonNode;
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
  var valid_564810 = path.getOrDefault("storage-account-name")
  valid_564810 = validateParameter(valid_564810, JString, required = true,
                                 default = nil)
  if valid_564810 != nil:
    section.add "storage-account-name", valid_564810
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564811 = query.getOrDefault("api-version")
  valid_564811 = validateParameter(valid_564811, JString, required = true,
                                 default = nil)
  if valid_564811 != nil:
    section.add "api-version", valid_564811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564812: Call_BackupStorageAccount_564807; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified storage account be downloaded to the client. This operation requires the storage/backup permission.
  ## 
  let valid = call_564812.validator(path, query, header, formData, body)
  let scheme = call_564812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564812.url(scheme.get, call_564812.host, call_564812.base,
                         call_564812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564812, url, valid)

proc call*(call_564813: Call_BackupStorageAccount_564807; apiVersion: string;
          storageAccountName: string): Recallable =
  ## backupStorageAccount
  ## Requests that a backup of the specified storage account be downloaded to the client. This operation requires the storage/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_564814 = newJObject()
  var query_564815 = newJObject()
  add(query_564815, "api-version", newJString(apiVersion))
  add(path_564814, "storage-account-name", newJString(storageAccountName))
  result = call_564813.call(path_564814, query_564815, nil, nil, nil)

var backupStorageAccount* = Call_BackupStorageAccount_564807(
    name: "backupStorageAccount", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/storage/{storage-account-name}/backup",
    validator: validate_BackupStorageAccount_564808, base: "",
    url: url_BackupStorageAccount_564809, schemes: {Scheme.Https})
type
  Call_RegenerateStorageAccountKey_564816 = ref object of OpenApiRestCall_563565
proc url_RegenerateStorageAccountKey_564818(protocol: Scheme; host: string;
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

proc validate_RegenerateStorageAccountKey_564817(path: JsonNode; query: JsonNode;
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
  var valid_564819 = path.getOrDefault("storage-account-name")
  valid_564819 = validateParameter(valid_564819, JString, required = true,
                                 default = nil)
  if valid_564819 != nil:
    section.add "storage-account-name", valid_564819
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564820 = query.getOrDefault("api-version")
  valid_564820 = validateParameter(valid_564820, JString, required = true,
                                 default = nil)
  if valid_564820 != nil:
    section.add "api-version", valid_564820
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

proc call*(call_564822: Call_RegenerateStorageAccountKey_564816; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the specified key value for the given storage account. This operation requires the storage/regeneratekey permission.
  ## 
  let valid = call_564822.validator(path, query, header, formData, body)
  let scheme = call_564822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564822.url(scheme.get, call_564822.host, call_564822.base,
                         call_564822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564822, url, valid)

proc call*(call_564823: Call_RegenerateStorageAccountKey_564816;
          apiVersion: string; storageAccountName: string; parameters: JsonNode): Recallable =
  ## regenerateStorageAccountKey
  ## Regenerates the specified key value for the given storage account. This operation requires the storage/regeneratekey permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to regenerate storage account key.
  var path_564824 = newJObject()
  var query_564825 = newJObject()
  var body_564826 = newJObject()
  add(query_564825, "api-version", newJString(apiVersion))
  add(path_564824, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_564826 = parameters
  result = call_564823.call(path_564824, query_564825, nil, nil, body_564826)

var regenerateStorageAccountKey* = Call_RegenerateStorageAccountKey_564816(
    name: "regenerateStorageAccountKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/storage/{storage-account-name}/regeneratekey",
    validator: validate_RegenerateStorageAccountKey_564817, base: "",
    url: url_RegenerateStorageAccountKey_564818, schemes: {Scheme.Https})
type
  Call_GetSasDefinitions_564827 = ref object of OpenApiRestCall_563565
proc url_GetSasDefinitions_564829(protocol: Scheme; host: string; base: string;
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

proc validate_GetSasDefinitions_564828(path: JsonNode; query: JsonNode;
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
  var valid_564830 = path.getOrDefault("storage-account-name")
  valid_564830 = validateParameter(valid_564830, JString, required = true,
                                 default = nil)
  if valid_564830 != nil:
    section.add "storage-account-name", valid_564830
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564831 = query.getOrDefault("api-version")
  valid_564831 = validateParameter(valid_564831, JString, required = true,
                                 default = nil)
  if valid_564831 != nil:
    section.add "api-version", valid_564831
  var valid_564832 = query.getOrDefault("maxresults")
  valid_564832 = validateParameter(valid_564832, JInt, required = false, default = nil)
  if valid_564832 != nil:
    section.add "maxresults", valid_564832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564833: Call_GetSasDefinitions_564827; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List storage SAS definitions for the given storage account. This operation requires the storage/listsas permission.
  ## 
  let valid = call_564833.validator(path, query, header, formData, body)
  let scheme = call_564833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564833.url(scheme.get, call_564833.host, call_564833.base,
                         call_564833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564833, url, valid)

proc call*(call_564834: Call_GetSasDefinitions_564827; apiVersion: string;
          storageAccountName: string; maxresults: int = 0): Recallable =
  ## getSasDefinitions
  ## List storage SAS definitions for the given storage account. This operation requires the storage/listsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var path_564835 = newJObject()
  var query_564836 = newJObject()
  add(query_564836, "api-version", newJString(apiVersion))
  add(path_564835, "storage-account-name", newJString(storageAccountName))
  add(query_564836, "maxresults", newJInt(maxresults))
  result = call_564834.call(path_564835, query_564836, nil, nil, nil)

var getSasDefinitions* = Call_GetSasDefinitions_564827(name: "getSasDefinitions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}/sas",
    validator: validate_GetSasDefinitions_564828, base: "",
    url: url_GetSasDefinitions_564829, schemes: {Scheme.Https})
type
  Call_SetSasDefinition_564847 = ref object of OpenApiRestCall_563565
proc url_SetSasDefinition_564849(protocol: Scheme; host: string; base: string;
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

proc validate_SetSasDefinition_564848(path: JsonNode; query: JsonNode;
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
  var valid_564850 = path.getOrDefault("storage-account-name")
  valid_564850 = validateParameter(valid_564850, JString, required = true,
                                 default = nil)
  if valid_564850 != nil:
    section.add "storage-account-name", valid_564850
  var valid_564851 = path.getOrDefault("sas-definition-name")
  valid_564851 = validateParameter(valid_564851, JString, required = true,
                                 default = nil)
  if valid_564851 != nil:
    section.add "sas-definition-name", valid_564851
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564852 = query.getOrDefault("api-version")
  valid_564852 = validateParameter(valid_564852, JString, required = true,
                                 default = nil)
  if valid_564852 != nil:
    section.add "api-version", valid_564852
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

proc call*(call_564854: Call_SetSasDefinition_564847; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new SAS definition for the specified storage account. This operation requires the storage/setsas permission.
  ## 
  let valid = call_564854.validator(path, query, header, formData, body)
  let scheme = call_564854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564854.url(scheme.get, call_564854.host, call_564854.base,
                         call_564854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564854, url, valid)

proc call*(call_564855: Call_SetSasDefinition_564847; apiVersion: string;
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
  var path_564856 = newJObject()
  var query_564857 = newJObject()
  var body_564858 = newJObject()
  add(query_564857, "api-version", newJString(apiVersion))
  add(path_564856, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_564858 = parameters
  add(path_564856, "sas-definition-name", newJString(sasDefinitionName))
  result = call_564855.call(path_564856, query_564857, nil, nil, body_564858)

var setSasDefinition* = Call_SetSasDefinition_564847(name: "setSasDefinition",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_SetSasDefinition_564848, base: "",
    url: url_SetSasDefinition_564849, schemes: {Scheme.Https})
type
  Call_GetSasDefinition_564837 = ref object of OpenApiRestCall_563565
proc url_GetSasDefinition_564839(protocol: Scheme; host: string; base: string;
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

proc validate_GetSasDefinition_564838(path: JsonNode; query: JsonNode;
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
  var valid_564840 = path.getOrDefault("storage-account-name")
  valid_564840 = validateParameter(valid_564840, JString, required = true,
                                 default = nil)
  if valid_564840 != nil:
    section.add "storage-account-name", valid_564840
  var valid_564841 = path.getOrDefault("sas-definition-name")
  valid_564841 = validateParameter(valid_564841, JString, required = true,
                                 default = nil)
  if valid_564841 != nil:
    section.add "sas-definition-name", valid_564841
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564842 = query.getOrDefault("api-version")
  valid_564842 = validateParameter(valid_564842, JString, required = true,
                                 default = nil)
  if valid_564842 != nil:
    section.add "api-version", valid_564842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564843: Call_GetSasDefinition_564837; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a SAS definition for the specified storage account. This operation requires the storage/getsas permission.
  ## 
  let valid = call_564843.validator(path, query, header, formData, body)
  let scheme = call_564843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564843.url(scheme.get, call_564843.host, call_564843.base,
                         call_564843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564843, url, valid)

proc call*(call_564844: Call_GetSasDefinition_564837; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## getSasDefinition
  ## Gets information about a SAS definition for the specified storage account. This operation requires the storage/getsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_564845 = newJObject()
  var query_564846 = newJObject()
  add(query_564846, "api-version", newJString(apiVersion))
  add(path_564845, "storage-account-name", newJString(storageAccountName))
  add(path_564845, "sas-definition-name", newJString(sasDefinitionName))
  result = call_564844.call(path_564845, query_564846, nil, nil, nil)

var getSasDefinition* = Call_GetSasDefinition_564837(name: "getSasDefinition",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_GetSasDefinition_564838, base: "",
    url: url_GetSasDefinition_564839, schemes: {Scheme.Https})
type
  Call_UpdateSasDefinition_564869 = ref object of OpenApiRestCall_563565
proc url_UpdateSasDefinition_564871(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateSasDefinition_564870(path: JsonNode; query: JsonNode;
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
  var valid_564872 = path.getOrDefault("storage-account-name")
  valid_564872 = validateParameter(valid_564872, JString, required = true,
                                 default = nil)
  if valid_564872 != nil:
    section.add "storage-account-name", valid_564872
  var valid_564873 = path.getOrDefault("sas-definition-name")
  valid_564873 = validateParameter(valid_564873, JString, required = true,
                                 default = nil)
  if valid_564873 != nil:
    section.add "sas-definition-name", valid_564873
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564874 = query.getOrDefault("api-version")
  valid_564874 = validateParameter(valid_564874, JString, required = true,
                                 default = nil)
  if valid_564874 != nil:
    section.add "api-version", valid_564874
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

proc call*(call_564876: Call_UpdateSasDefinition_564869; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified attributes associated with the given SAS definition. This operation requires the storage/setsas permission.
  ## 
  let valid = call_564876.validator(path, query, header, formData, body)
  let scheme = call_564876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564876.url(scheme.get, call_564876.host, call_564876.base,
                         call_564876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564876, url, valid)

proc call*(call_564877: Call_UpdateSasDefinition_564869; apiVersion: string;
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
  var path_564878 = newJObject()
  var query_564879 = newJObject()
  var body_564880 = newJObject()
  add(query_564879, "api-version", newJString(apiVersion))
  add(path_564878, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_564880 = parameters
  add(path_564878, "sas-definition-name", newJString(sasDefinitionName))
  result = call_564877.call(path_564878, query_564879, nil, nil, body_564880)

var updateSasDefinition* = Call_UpdateSasDefinition_564869(
    name: "updateSasDefinition", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_UpdateSasDefinition_564870, base: "",
    url: url_UpdateSasDefinition_564871, schemes: {Scheme.Https})
type
  Call_DeleteSasDefinition_564859 = ref object of OpenApiRestCall_563565
proc url_DeleteSasDefinition_564861(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteSasDefinition_564860(path: JsonNode; query: JsonNode;
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
  var valid_564862 = path.getOrDefault("storage-account-name")
  valid_564862 = validateParameter(valid_564862, JString, required = true,
                                 default = nil)
  if valid_564862 != nil:
    section.add "storage-account-name", valid_564862
  var valid_564863 = path.getOrDefault("sas-definition-name")
  valid_564863 = validateParameter(valid_564863, JString, required = true,
                                 default = nil)
  if valid_564863 != nil:
    section.add "sas-definition-name", valid_564863
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564864 = query.getOrDefault("api-version")
  valid_564864 = validateParameter(valid_564864, JString, required = true,
                                 default = nil)
  if valid_564864 != nil:
    section.add "api-version", valid_564864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564865: Call_DeleteSasDefinition_564859; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SAS definition from a specified storage account. This operation requires the storage/deletesas permission.
  ## 
  let valid = call_564865.validator(path, query, header, formData, body)
  let scheme = call_564865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564865.url(scheme.get, call_564865.host, call_564865.base,
                         call_564865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564865, url, valid)

proc call*(call_564866: Call_DeleteSasDefinition_564859; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## deleteSasDefinition
  ## Deletes a SAS definition from a specified storage account. This operation requires the storage/deletesas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_564867 = newJObject()
  var query_564868 = newJObject()
  add(query_564868, "api-version", newJString(apiVersion))
  add(path_564867, "storage-account-name", newJString(storageAccountName))
  add(path_564867, "sas-definition-name", newJString(sasDefinitionName))
  result = call_564866.call(path_564867, query_564868, nil, nil, nil)

var deleteSasDefinition* = Call_DeleteSasDefinition_564859(
    name: "deleteSasDefinition", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_DeleteSasDefinition_564860, base: "",
    url: url_DeleteSasDefinition_564861, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
