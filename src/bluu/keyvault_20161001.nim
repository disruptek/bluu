
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
  ## The GetCertificates operation returns the set of certificates resources in the specified key vault. This operation requires the certificates/list permission.
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
  ## The GetCertificates operation returns the set of certificates resources in the specified key vault. This operation requires the certificates/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  ##           : The contacts for the key vault certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564114: Call_SetCertificateContacts_564092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the certificate contacts for the specified key vault. This operation requires the certificates/managecontacts permission.
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
  ## Sets the certificate contacts for the specified key vault. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   contacts: JObject (required)
  ##           : The contacts for the key vault certificate.
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
  ## The GetCertificateContacts operation returns the set of certificate contact resources in the specified key vault. This operation requires the certificates/managecontacts permission.
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
  ## The GetCertificateContacts operation returns the set of certificate contact resources in the specified key vault. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  ## Deletes the certificate contacts for a specified key vault certificate. This operation requires the certificates/managecontacts permission.
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
  ## Deletes the certificate contacts for a specified key vault certificate. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  ## The GetCertificateIssuers operation returns the set of certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
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
  ## The GetCertificateIssuers operation returns the set of certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  var valid_564159 = path.getOrDefault("issuer-name")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "issuer-name", valid_564159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## The SetCertificateIssuer operation adds or updates the specified certificate issuer. This operation requires the certificates/setissuers permission.
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
  ## The SetCertificateIssuer operation adds or updates the specified certificate issuer. This operation requires the certificates/setissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  var valid_564150 = path.getOrDefault("issuer-name")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "issuer-name", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## The GetCertificateIssuer operation returns the specified certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
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
  ## The GetCertificateIssuer operation returns the specified certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  var valid_564179 = path.getOrDefault("issuer-name")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "issuer-name", valid_564179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## The UpdateCertificateIssuer operation performs an update on the specified certificate issuer entity. This operation requires the certificates/setissuers permission.
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
  ## The UpdateCertificateIssuer operation performs an update on the specified certificate issuer entity. This operation requires the certificates/setissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  var valid_564170 = path.getOrDefault("issuer-name")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "issuer-name", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## The DeleteCertificateIssuer operation permanently removes the specified certificate issuer from the vault. This operation requires the certificates/manageissuers/deleteissuers permission.
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
  ## The DeleteCertificateIssuer operation permanently removes the specified certificate issuer from the vault. This operation requires the certificates/manageissuers/deleteissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  var valid_564190 = path.getOrDefault("certificate-name")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "certificate-name", valid_564190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## Deletes all versions of a certificate object along with its associated policy. Delete certificate cannot be used to remove individual versions of a certificate object. This operation requires the certificates/delete permission.
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
  ## Deletes all versions of a certificate object along with its associated policy. Delete certificate cannot be used to remove individual versions of a certificate object. This operation requires the certificates/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
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
  var valid_564199 = path.getOrDefault("certificate-name")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "certificate-name", valid_564199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ##             : The parameters to create a certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564202: Call_CreateCertificate_564196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If this is the first version, the certificate resource is created. This operation requires the certificates/create permission.
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
  ## If this is the first version, the certificate resource is created. This operation requires the certificates/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to create a certificate.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to import the certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564213: Call_ImportCertificate_564207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an existing valid certificate, containing a private key, into Azure Key Vault. The certificate to be imported can be in either PFX or PEM format. If the certificate is in PEM format the PEM file must contain the key as well as x509 certificates. This operation requires the certificates/import permission.
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
  ## Imports an existing valid certificate, containing a private key, into Azure Key Vault. The certificate to be imported can be in either PFX or PEM format. If the certificate is in PEM format the PEM file must contain the key as well as x509 certificates. This operation requires the certificates/import permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to import the certificate.
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
  var valid_564221 = path.getOrDefault("certificate-name")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "certificate-name", valid_564221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## Gets the creation operation associated with a specified certificate. This operation requires the certificates/get permission.
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
  ## Gets the creation operation associated with a specified certificate. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
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
  var valid_564239 = path.getOrDefault("certificate-name")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "certificate-name", valid_564239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## Updates a certificate creation operation that is already in progress. This operation requires the certificates/update permission.
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
  ## Updates a certificate creation operation that is already in progress. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateOperation: JObject (required)
  ##                       : The certificate operation response.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
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
  if body != nil:
    result.add "body", body

proc call*(call_564232: Call_DeleteCertificateOperation_564227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the creation operation for a specified certificate that is in the process of being created. The certificate is no longer created. This operation requires the certificates/update permission.
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
  ## Deletes the creation operation for a specified certificate that is in the process of being created. The certificate is no longer created. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to merge certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564253: Call_MergeCertificate_564247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The MergeCertificate operation performs the merging of a certificate or certificate chain with a key pair currently available in the service. This operation requires the certificates/create permission.
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
  ## The MergeCertificate operation performs the merging of a certificate or certificate chain with a key pair currently available in the service. This operation requires the certificates/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
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
  var valid_564261 = path.getOrDefault("certificate-name")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "certificate-name", valid_564261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## The GetCertificatePolicy operation returns the specified certificate policy resources in the specified key vault. This operation requires the certificates/get permission.
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
  ## The GetCertificatePolicy operation returns the specified certificate policy resources in the specified key vault. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in a given key vault.
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
  ##   certificatePolicy: JObject (required)
  ##                    : The policy for the certificate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564273: Call_UpdateCertificatePolicy_564267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set specified members in the certificate policy. Leave others as null. This operation requires the certificates/update permission.
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
  ## Set specified members in the certificate policy. Leave others as null. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
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
  var valid_564281 = path.getOrDefault("certificate-name")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "certificate-name", valid_564281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## The GetCertificateVersions operation returns the versions of a certificate in the specified key vault. This operation requires the certificates/list permission.
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
  ## The GetCertificateVersions operation returns the versions of a certificate in the specified key vault. This operation requires the certificates/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
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
  ##              : Client API version.
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
  ## Gets information about a specific certificate. This operation requires the certificates/get permission.
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
  ## Gets information about a specific certificate. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateVersion: string (required)
  ##                     : The version of the certificate.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault.
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
  ##              : Client API version.
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
  ##             : The parameters for certificate update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564305: Call_UpdateCertificate_564298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UpdateCertificate operation applies the specified update on the given certificate; the only elements updated are the certificate's attributes. This operation requires the certificates/update permission.
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
  ## The UpdateCertificate operation applies the specified update on the given certificate; the only elements updated are the certificate's attributes. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateVersion: string (required)
  ##                     : The version of the certificate.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given key vault.
  ##   parameters: JObject (required)
  ##             : The parameters for certificate update.
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
  Call_GetDeletedCertificates_564310 = ref object of OpenApiRestCall_563564
proc url_GetDeletedCertificates_564312(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedCertificates_564311(path: JsonNode; query: JsonNode;
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

proc call*(call_564315: Call_GetDeletedCertificates_564310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetDeletedCertificates operation retrieves the certificates in the current vault which are in a deleted state and ready for recovery or purging. This operation includes deletion-specific information. This operation requires the certificates/get/list permission. This operation can only be enabled on soft-delete enabled vaults.
  ## 
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_GetDeletedCertificates_564310; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedCertificates
  ## The GetDeletedCertificates operation retrieves the certificates in the current vault which are in a deleted state and ready for recovery or purging. This operation includes deletion-specific information. This operation requires the certificates/get/list permission. This operation can only be enabled on soft-delete enabled vaults.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564317 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(query_564317, "maxresults", newJInt(maxresults))
  result = call_564316.call(nil, query_564317, nil, nil, nil)

var getDeletedCertificates* = Call_GetDeletedCertificates_564310(
    name: "getDeletedCertificates", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedcertificates", validator: validate_GetDeletedCertificates_564311,
    base: "", url: url_GetDeletedCertificates_564312, schemes: {Scheme.Https})
type
  Call_GetDeletedCertificate_564318 = ref object of OpenApiRestCall_563564
proc url_GetDeletedCertificate_564320(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedCertificate_564319(path: JsonNode; query: JsonNode;
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
  var valid_564321 = path.getOrDefault("certificate-name")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "certificate-name", valid_564321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564322 = query.getOrDefault("api-version")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "api-version", valid_564322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564323: Call_GetDeletedCertificate_564318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetDeletedCertificate operation retrieves the deleted certificate information plus its attributes, such as retention interval, scheduled permanent deletion and the current deletion recovery level. This operation requires the certificates/get permission.
  ## 
  let valid = call_564323.validator(path, query, header, formData, body)
  let scheme = call_564323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564323.url(scheme.get, call_564323.host, call_564323.base,
                         call_564323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564323, url, valid)

proc call*(call_564324: Call_GetDeletedCertificate_564318; apiVersion: string;
          certificateName: string): Recallable =
  ## getDeletedCertificate
  ## The GetDeletedCertificate operation retrieves the deleted certificate information plus its attributes, such as retention interval, scheduled permanent deletion and the current deletion recovery level. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_564325 = newJObject()
  var query_564326 = newJObject()
  add(query_564326, "api-version", newJString(apiVersion))
  add(path_564325, "certificate-name", newJString(certificateName))
  result = call_564324.call(path_564325, query_564326, nil, nil, nil)

var getDeletedCertificate* = Call_GetDeletedCertificate_564318(
    name: "getDeletedCertificate", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedcertificates/{certificate-name}",
    validator: validate_GetDeletedCertificate_564319, base: "",
    url: url_GetDeletedCertificate_564320, schemes: {Scheme.Https})
type
  Call_PurgeDeletedCertificate_564327 = ref object of OpenApiRestCall_563564
proc url_PurgeDeletedCertificate_564329(protocol: Scheme; host: string; base: string;
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

proc validate_PurgeDeletedCertificate_564328(path: JsonNode; query: JsonNode;
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
  var valid_564330 = path.getOrDefault("certificate-name")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "certificate-name", valid_564330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_564332: Call_PurgeDeletedCertificate_564327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The PurgeDeletedCertificate operation performs an irreversible deletion of the specified certificate, without possibility for recovery. The operation is not available if the recovery level does not specify 'Purgeable'. This operation requires the certificate/purge permission.
  ## 
  let valid = call_564332.validator(path, query, header, formData, body)
  let scheme = call_564332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564332.url(scheme.get, call_564332.host, call_564332.base,
                         call_564332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564332, url, valid)

proc call*(call_564333: Call_PurgeDeletedCertificate_564327; apiVersion: string;
          certificateName: string): Recallable =
  ## purgeDeletedCertificate
  ## The PurgeDeletedCertificate operation performs an irreversible deletion of the specified certificate, without possibility for recovery. The operation is not available if the recovery level does not specify 'Purgeable'. This operation requires the certificate/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_564334 = newJObject()
  var query_564335 = newJObject()
  add(query_564335, "api-version", newJString(apiVersion))
  add(path_564334, "certificate-name", newJString(certificateName))
  result = call_564333.call(path_564334, query_564335, nil, nil, nil)

var purgeDeletedCertificate* = Call_PurgeDeletedCertificate_564327(
    name: "purgeDeletedCertificate", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/deletedcertificates/{certificate-name}",
    validator: validate_PurgeDeletedCertificate_564328, base: "",
    url: url_PurgeDeletedCertificate_564329, schemes: {Scheme.Https})
type
  Call_RecoverDeletedCertificate_564336 = ref object of OpenApiRestCall_563564
proc url_RecoverDeletedCertificate_564338(protocol: Scheme; host: string;
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

proc validate_RecoverDeletedCertificate_564337(path: JsonNode; query: JsonNode;
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
  var valid_564339 = path.getOrDefault("certificate-name")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "certificate-name", valid_564339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564340 = query.getOrDefault("api-version")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "api-version", valid_564340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564341: Call_RecoverDeletedCertificate_564336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RecoverDeletedCertificate operation performs the reversal of the Delete operation. The operation is applicable in vaults enabled for soft-delete, and must be issued during the retention interval (available in the deleted certificate's attributes). This operation requires the certificates/recover permission.
  ## 
  let valid = call_564341.validator(path, query, header, formData, body)
  let scheme = call_564341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564341.url(scheme.get, call_564341.host, call_564341.base,
                         call_564341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564341, url, valid)

proc call*(call_564342: Call_RecoverDeletedCertificate_564336; apiVersion: string;
          certificateName: string): Recallable =
  ## recoverDeletedCertificate
  ## The RecoverDeletedCertificate operation performs the reversal of the Delete operation. The operation is applicable in vaults enabled for soft-delete, and must be issued during the retention interval (available in the deleted certificate's attributes). This operation requires the certificates/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the deleted certificate
  var path_564343 = newJObject()
  var query_564344 = newJObject()
  add(query_564344, "api-version", newJString(apiVersion))
  add(path_564343, "certificate-name", newJString(certificateName))
  result = call_564342.call(path_564343, query_564344, nil, nil, nil)

var recoverDeletedCertificate* = Call_RecoverDeletedCertificate_564336(
    name: "recoverDeletedCertificate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/deletedcertificates/{certificate-name}/recover",
    validator: validate_RecoverDeletedCertificate_564337, base: "",
    url: url_RecoverDeletedCertificate_564338, schemes: {Scheme.Https})
type
  Call_GetDeletedKeys_564345 = ref object of OpenApiRestCall_563564
proc url_GetDeletedKeys_564347(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedKeys_564346(path: JsonNode; query: JsonNode;
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
  var valid_564348 = query.getOrDefault("api-version")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "api-version", valid_564348
  var valid_564349 = query.getOrDefault("maxresults")
  valid_564349 = validateParameter(valid_564349, JInt, required = false, default = nil)
  if valid_564349 != nil:
    section.add "maxresults", valid_564349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564350: Call_GetDeletedKeys_564345; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a deleted key. This operation includes deletion-specific information. The Get Deleted Keys operation is applicable for vaults enabled for soft-delete. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/list permission.
  ## 
  let valid = call_564350.validator(path, query, header, formData, body)
  let scheme = call_564350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564350.url(scheme.get, call_564350.host, call_564350.base,
                         call_564350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564350, url, valid)

proc call*(call_564351: Call_GetDeletedKeys_564345; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedKeys
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a deleted key. This operation includes deletion-specific information. The Get Deleted Keys operation is applicable for vaults enabled for soft-delete. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564352 = newJObject()
  add(query_564352, "api-version", newJString(apiVersion))
  add(query_564352, "maxresults", newJInt(maxresults))
  result = call_564351.call(nil, query_564352, nil, nil, nil)

var getDeletedKeys* = Call_GetDeletedKeys_564345(name: "getDeletedKeys",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedkeys",
    validator: validate_GetDeletedKeys_564346, base: "", url: url_GetDeletedKeys_564347,
    schemes: {Scheme.Https})
type
  Call_GetDeletedKey_564353 = ref object of OpenApiRestCall_563564
proc url_GetDeletedKey_564355(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedKey_564354(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564356 = path.getOrDefault("key-name")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "key-name", valid_564356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564357 = query.getOrDefault("api-version")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "api-version", valid_564357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564358: Call_GetDeletedKey_564353; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/get permission. 
  ## 
  let valid = call_564358.validator(path, query, header, formData, body)
  let scheme = call_564358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564358.url(scheme.get, call_564358.host, call_564358.base,
                         call_564358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564358, url, valid)

proc call*(call_564359: Call_GetDeletedKey_564353; apiVersion: string;
          keyName: string): Recallable =
  ## getDeletedKey
  ## The Get Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/get permission. 
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_564360 = newJObject()
  var query_564361 = newJObject()
  add(query_564361, "api-version", newJString(apiVersion))
  add(path_564360, "key-name", newJString(keyName))
  result = call_564359.call(path_564360, query_564361, nil, nil, nil)

var getDeletedKey* = Call_GetDeletedKey_564353(name: "getDeletedKey",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedkeys/{key-name}",
    validator: validate_GetDeletedKey_564354, base: "", url: url_GetDeletedKey_564355,
    schemes: {Scheme.Https})
type
  Call_PurgeDeletedKey_564362 = ref object of OpenApiRestCall_563564
proc url_PurgeDeletedKey_564364(protocol: Scheme; host: string; base: string;
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

proc validate_PurgeDeletedKey_564363(path: JsonNode; query: JsonNode;
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
  var valid_564365 = path.getOrDefault("key-name")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "key-name", valid_564365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564366 = query.getOrDefault("api-version")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "api-version", valid_564366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564367: Call_PurgeDeletedKey_564362; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Purge Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/purge permission.
  ## 
  let valid = call_564367.validator(path, query, header, formData, body)
  let scheme = call_564367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564367.url(scheme.get, call_564367.host, call_564367.base,
                         call_564367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564367, url, valid)

proc call*(call_564368: Call_PurgeDeletedKey_564362; apiVersion: string;
          keyName: string): Recallable =
  ## purgeDeletedKey
  ## The Purge Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_564369 = newJObject()
  var query_564370 = newJObject()
  add(query_564370, "api-version", newJString(apiVersion))
  add(path_564369, "key-name", newJString(keyName))
  result = call_564368.call(path_564369, query_564370, nil, nil, nil)

var purgeDeletedKey* = Call_PurgeDeletedKey_564362(name: "purgeDeletedKey",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/deletedkeys/{key-name}", validator: validate_PurgeDeletedKey_564363,
    base: "", url: url_PurgeDeletedKey_564364, schemes: {Scheme.Https})
type
  Call_RecoverDeletedKey_564371 = ref object of OpenApiRestCall_563564
proc url_RecoverDeletedKey_564373(protocol: Scheme; host: string; base: string;
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

proc validate_RecoverDeletedKey_564372(path: JsonNode; query: JsonNode;
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
  var valid_564374 = path.getOrDefault("key-name")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "key-name", valid_564374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564375 = query.getOrDefault("api-version")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "api-version", valid_564375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564376: Call_RecoverDeletedKey_564371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Recover Deleted Key operation is applicable for deleted keys in soft-delete enabled vaults. It recovers the deleted key back to its latest version under /keys. An attempt to recover an non-deleted key will return an error. Consider this the inverse of the delete operation on soft-delete enabled vaults. This operation requires the keys/recover permission.
  ## 
  let valid = call_564376.validator(path, query, header, formData, body)
  let scheme = call_564376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564376.url(scheme.get, call_564376.host, call_564376.base,
                         call_564376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564376, url, valid)

proc call*(call_564377: Call_RecoverDeletedKey_564371; apiVersion: string;
          keyName: string): Recallable =
  ## recoverDeletedKey
  ## The Recover Deleted Key operation is applicable for deleted keys in soft-delete enabled vaults. It recovers the deleted key back to its latest version under /keys. An attempt to recover an non-deleted key will return an error. Consider this the inverse of the delete operation on soft-delete enabled vaults. This operation requires the keys/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the deleted key.
  var path_564378 = newJObject()
  var query_564379 = newJObject()
  add(query_564379, "api-version", newJString(apiVersion))
  add(path_564378, "key-name", newJString(keyName))
  result = call_564377.call(path_564378, query_564379, nil, nil, nil)

var recoverDeletedKey* = Call_RecoverDeletedKey_564371(name: "recoverDeletedKey",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/deletedkeys/{key-name}/recover",
    validator: validate_RecoverDeletedKey_564372, base: "",
    url: url_RecoverDeletedKey_564373, schemes: {Scheme.Https})
type
  Call_GetDeletedSecrets_564380 = ref object of OpenApiRestCall_563564
proc url_GetDeletedSecrets_564382(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedSecrets_564381(path: JsonNode; query: JsonNode;
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
  var valid_564383 = query.getOrDefault("api-version")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "api-version", valid_564383
  var valid_564384 = query.getOrDefault("maxresults")
  valid_564384 = validateParameter(valid_564384, JInt, required = false, default = nil)
  if valid_564384 != nil:
    section.add "maxresults", valid_564384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564385: Call_GetDeletedSecrets_564380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Secrets operation returns the secrets that have been deleted for a vault enabled for soft-delete. This operation requires the secrets/list permission.
  ## 
  let valid = call_564385.validator(path, query, header, formData, body)
  let scheme = call_564385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564385.url(scheme.get, call_564385.host, call_564385.base,
                         call_564385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564385, url, valid)

proc call*(call_564386: Call_GetDeletedSecrets_564380; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedSecrets
  ## The Get Deleted Secrets operation returns the secrets that have been deleted for a vault enabled for soft-delete. This operation requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564387 = newJObject()
  add(query_564387, "api-version", newJString(apiVersion))
  add(query_564387, "maxresults", newJInt(maxresults))
  result = call_564386.call(nil, query_564387, nil, nil, nil)

var getDeletedSecrets* = Call_GetDeletedSecrets_564380(name: "getDeletedSecrets",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedsecrets",
    validator: validate_GetDeletedSecrets_564381, base: "",
    url: url_GetDeletedSecrets_564382, schemes: {Scheme.Https})
type
  Call_GetDeletedSecret_564388 = ref object of OpenApiRestCall_563564
proc url_GetDeletedSecret_564390(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedSecret_564389(path: JsonNode; query: JsonNode;
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
  var valid_564391 = path.getOrDefault("secret-name")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "secret-name", valid_564391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_564393: Call_GetDeletedSecret_564388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Secret operation returns the specified deleted secret along with its attributes. This operation requires the secrets/get permission.
  ## 
  let valid = call_564393.validator(path, query, header, formData, body)
  let scheme = call_564393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564393.url(scheme.get, call_564393.host, call_564393.base,
                         call_564393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564393, url, valid)

proc call*(call_564394: Call_GetDeletedSecret_564388; apiVersion: string;
          secretName: string): Recallable =
  ## getDeletedSecret
  ## The Get Deleted Secret operation returns the specified deleted secret along with its attributes. This operation requires the secrets/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_564395 = newJObject()
  var query_564396 = newJObject()
  add(query_564396, "api-version", newJString(apiVersion))
  add(path_564395, "secret-name", newJString(secretName))
  result = call_564394.call(path_564395, query_564396, nil, nil, nil)

var getDeletedSecret* = Call_GetDeletedSecret_564388(name: "getDeletedSecret",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedsecrets/{secret-name}", validator: validate_GetDeletedSecret_564389,
    base: "", url: url_GetDeletedSecret_564390, schemes: {Scheme.Https})
type
  Call_PurgeDeletedSecret_564397 = ref object of OpenApiRestCall_563564
proc url_PurgeDeletedSecret_564399(protocol: Scheme; host: string; base: string;
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

proc validate_PurgeDeletedSecret_564398(path: JsonNode; query: JsonNode;
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
  var valid_564400 = path.getOrDefault("secret-name")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "secret-name", valid_564400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564401 = query.getOrDefault("api-version")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "api-version", valid_564401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564402: Call_PurgeDeletedSecret_564397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The purge deleted secret operation removes the secret permanently, without the possibility of recovery. This operation can only be enabled on a soft-delete enabled vault. This operation requires the secrets/purge permission.
  ## 
  let valid = call_564402.validator(path, query, header, formData, body)
  let scheme = call_564402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564402.url(scheme.get, call_564402.host, call_564402.base,
                         call_564402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564402, url, valid)

proc call*(call_564403: Call_PurgeDeletedSecret_564397; apiVersion: string;
          secretName: string): Recallable =
  ## purgeDeletedSecret
  ## The purge deleted secret operation removes the secret permanently, without the possibility of recovery. This operation can only be enabled on a soft-delete enabled vault. This operation requires the secrets/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_564404 = newJObject()
  var query_564405 = newJObject()
  add(query_564405, "api-version", newJString(apiVersion))
  add(path_564404, "secret-name", newJString(secretName))
  result = call_564403.call(path_564404, query_564405, nil, nil, nil)

var purgeDeletedSecret* = Call_PurgeDeletedSecret_564397(
    name: "purgeDeletedSecret", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/deletedsecrets/{secret-name}",
    validator: validate_PurgeDeletedSecret_564398, base: "",
    url: url_PurgeDeletedSecret_564399, schemes: {Scheme.Https})
type
  Call_RecoverDeletedSecret_564406 = ref object of OpenApiRestCall_563564
proc url_RecoverDeletedSecret_564408(protocol: Scheme; host: string; base: string;
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

proc validate_RecoverDeletedSecret_564407(path: JsonNode; query: JsonNode;
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
  var valid_564409 = path.getOrDefault("secret-name")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "secret-name", valid_564409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564410 = query.getOrDefault("api-version")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "api-version", valid_564410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564411: Call_RecoverDeletedSecret_564406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recovers the deleted secret in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the secrets/recover permission.
  ## 
  let valid = call_564411.validator(path, query, header, formData, body)
  let scheme = call_564411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564411.url(scheme.get, call_564411.host, call_564411.base,
                         call_564411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564411, url, valid)

proc call*(call_564412: Call_RecoverDeletedSecret_564406; apiVersion: string;
          secretName: string): Recallable =
  ## recoverDeletedSecret
  ## Recovers the deleted secret in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the secrets/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the deleted secret.
  var path_564413 = newJObject()
  var query_564414 = newJObject()
  add(query_564414, "api-version", newJString(apiVersion))
  add(path_564413, "secret-name", newJString(secretName))
  result = call_564412.call(path_564413, query_564414, nil, nil, nil)

var recoverDeletedSecret* = Call_RecoverDeletedSecret_564406(
    name: "recoverDeletedSecret", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/deletedsecrets/{secret-name}/recover",
    validator: validate_RecoverDeletedSecret_564407, base: "",
    url: url_RecoverDeletedSecret_564408, schemes: {Scheme.Https})
type
  Call_GetKeys_564415 = ref object of OpenApiRestCall_563564
proc url_GetKeys_564417(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetKeys_564416(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564418 = query.getOrDefault("api-version")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "api-version", valid_564418
  var valid_564419 = query.getOrDefault("maxresults")
  valid_564419 = validateParameter(valid_564419, JInt, required = false, default = nil)
  if valid_564419 != nil:
    section.add "maxresults", valid_564419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564420: Call_GetKeys_564415; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a stored key. The LIST operation is applicable to all key types, however only the base key identifier, attributes, and tags are provided in the response. Individual versions of a key are not listed in the response. This operation requires the keys/list permission.
  ## 
  let valid = call_564420.validator(path, query, header, formData, body)
  let scheme = call_564420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564420.url(scheme.get, call_564420.host, call_564420.base,
                         call_564420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564420, url, valid)

proc call*(call_564421: Call_GetKeys_564415; apiVersion: string; maxresults: int = 0): Recallable =
  ## getKeys
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a stored key. The LIST operation is applicable to all key types, however only the base key identifier, attributes, and tags are provided in the response. Individual versions of a key are not listed in the response. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564422 = newJObject()
  add(query_564422, "api-version", newJString(apiVersion))
  add(query_564422, "maxresults", newJInt(maxresults))
  result = call_564421.call(nil, query_564422, nil, nil, nil)

var getKeys* = Call_GetKeys_564415(name: "getKeys", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/keys",
                                validator: validate_GetKeys_564416, base: "",
                                url: url_GetKeys_564417, schemes: {Scheme.Https})
type
  Call_RestoreKey_564423 = ref object of OpenApiRestCall_563564
proc url_RestoreKey_564425(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreKey_564424(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##             : The parameters to restore the key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564428: Call_RestoreKey_564423; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a previously backed up key into Azure Key Vault, restoring the key, its key identifier, attributes and access control policies. The RESTORE operation may be used to import a previously backed up key. Individual versions of a key cannot be restored. The key is restored in its entirety with the same key name as it had when it was backed up. If the key name is not available in the target Key Vault, the RESTORE operation will be rejected. While the key name is retained during restore, the final key identifier will change if the key is restored to a different vault. Restore will restore all versions and preserve version identifiers. The RESTORE operation is subject to security constraints: The target Key Vault must be owned by the same Microsoft Azure Subscription as the source Key Vault The user must have RESTORE permission in the target Key Vault. This operation requires the keys/restore permission.
  ## 
  let valid = call_564428.validator(path, query, header, formData, body)
  let scheme = call_564428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564428.url(scheme.get, call_564428.host, call_564428.base,
                         call_564428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564428, url, valid)

proc call*(call_564429: Call_RestoreKey_564423; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreKey
  ## Imports a previously backed up key into Azure Key Vault, restoring the key, its key identifier, attributes and access control policies. The RESTORE operation may be used to import a previously backed up key. Individual versions of a key cannot be restored. The key is restored in its entirety with the same key name as it had when it was backed up. If the key name is not available in the target Key Vault, the RESTORE operation will be rejected. While the key name is retained during restore, the final key identifier will change if the key is restored to a different vault. Restore will restore all versions and preserve version identifiers. The RESTORE operation is subject to security constraints: The target Key Vault must be owned by the same Microsoft Azure Subscription as the source Key Vault The user must have RESTORE permission in the target Key Vault. This operation requires the keys/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the key.
  var query_564430 = newJObject()
  var body_564431 = newJObject()
  add(query_564430, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564431 = parameters
  result = call_564429.call(nil, query_564430, nil, nil, body_564431)

var restoreKey* = Call_RestoreKey_564423(name: "restoreKey",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/keys/restore",
                                      validator: validate_RestoreKey_564424,
                                      base: "", url: url_RestoreKey_564425,
                                      schemes: {Scheme.Https})
type
  Call_ImportKey_564432 = ref object of OpenApiRestCall_563564
proc url_ImportKey_564434(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImportKey_564433(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564435 = path.getOrDefault("key-name")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "key-name", valid_564435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564436 = query.getOrDefault("api-version")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "api-version", valid_564436
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

proc call*(call_564438: Call_ImportKey_564432; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The import key operation may be used to import any key type into an Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. This operation requires the keys/import permission.
  ## 
  let valid = call_564438.validator(path, query, header, formData, body)
  let scheme = call_564438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564438.url(scheme.get, call_564438.host, call_564438.base,
                         call_564438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564438, url, valid)

proc call*(call_564439: Call_ImportKey_564432; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## importKey
  ## The import key operation may be used to import any key type into an Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. This operation requires the keys/import permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to import a key.
  ##   keyName: string (required)
  ##          : Name for the imported key.
  var path_564440 = newJObject()
  var query_564441 = newJObject()
  var body_564442 = newJObject()
  add(query_564441, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564442 = parameters
  add(path_564440, "key-name", newJString(keyName))
  result = call_564439.call(path_564440, query_564441, nil, nil, body_564442)

var importKey* = Call_ImportKey_564432(name: "importKey", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_ImportKey_564433,
                                    base: "", url: url_ImportKey_564434,
                                    schemes: {Scheme.Https})
type
  Call_DeleteKey_564443 = ref object of OpenApiRestCall_563564
proc url_DeleteKey_564445(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DeleteKey_564444(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564446 = path.getOrDefault("key-name")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "key-name", valid_564446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564447 = query.getOrDefault("api-version")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "api-version", valid_564447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564448: Call_DeleteKey_564443; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete key operation cannot be used to remove individual versions of a key. This operation removes the cryptographic material associated with the key, which means the key is not usable for Sign/Verify, Wrap/Unwrap or Encrypt/Decrypt operations. This operation requires the keys/delete permission.
  ## 
  let valid = call_564448.validator(path, query, header, formData, body)
  let scheme = call_564448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564448.url(scheme.get, call_564448.host, call_564448.base,
                         call_564448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564448, url, valid)

proc call*(call_564449: Call_DeleteKey_564443; apiVersion: string; keyName: string): Recallable =
  ## deleteKey
  ## The delete key operation cannot be used to remove individual versions of a key. This operation removes the cryptographic material associated with the key, which means the key is not usable for Sign/Verify, Wrap/Unwrap or Encrypt/Decrypt operations. This operation requires the keys/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key to delete.
  var path_564450 = newJObject()
  var query_564451 = newJObject()
  add(query_564451, "api-version", newJString(apiVersion))
  add(path_564450, "key-name", newJString(keyName))
  result = call_564449.call(path_564450, query_564451, nil, nil, nil)

var deleteKey* = Call_DeleteKey_564443(name: "deleteKey",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_DeleteKey_564444,
                                    base: "", url: url_DeleteKey_564445,
                                    schemes: {Scheme.Https})
type
  Call_BackupKey_564452 = ref object of OpenApiRestCall_563564
proc url_BackupKey_564454(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BackupKey_564453(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564455 = path.getOrDefault("key-name")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "key-name", valid_564455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564456 = query.getOrDefault("api-version")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "api-version", valid_564456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564457: Call_BackupKey_564452; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Key Backup operation exports a key from Azure Key Vault in a protected form. Note that this operation does NOT return key material in a form that can be used outside the Azure Key Vault system, the returned key material is either protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of this operation is to allow a client to GENERATE a key in one Azure Key Vault instance, BACKUP the key, and then RESTORE it into another Azure Key Vault instance. The BACKUP operation may be used to export, in protected form, any key type from Azure Key Vault. Individual versions of a key cannot be backed up. BACKUP / RESTORE can be performed within geographical boundaries only; meaning that a BACKUP from one geographical area cannot be restored to another geographical area. For example, a backup from the US geographical area cannot be restored in an EU geographical area. This operation requires the key/backup permission.
  ## 
  let valid = call_564457.validator(path, query, header, formData, body)
  let scheme = call_564457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564457.url(scheme.get, call_564457.host, call_564457.base,
                         call_564457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564457, url, valid)

proc call*(call_564458: Call_BackupKey_564452; apiVersion: string; keyName: string): Recallable =
  ## backupKey
  ## The Key Backup operation exports a key from Azure Key Vault in a protected form. Note that this operation does NOT return key material in a form that can be used outside the Azure Key Vault system, the returned key material is either protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of this operation is to allow a client to GENERATE a key in one Azure Key Vault instance, BACKUP the key, and then RESTORE it into another Azure Key Vault instance. The BACKUP operation may be used to export, in protected form, any key type from Azure Key Vault. Individual versions of a key cannot be backed up. BACKUP / RESTORE can be performed within geographical boundaries only; meaning that a BACKUP from one geographical area cannot be restored to another geographical area. For example, a backup from the US geographical area cannot be restored in an EU geographical area. This operation requires the key/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_564459 = newJObject()
  var query_564460 = newJObject()
  add(query_564460, "api-version", newJString(apiVersion))
  add(path_564459, "key-name", newJString(keyName))
  result = call_564458.call(path_564459, query_564460, nil, nil, nil)

var backupKey* = Call_BackupKey_564452(name: "backupKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/backup",
                                    validator: validate_BackupKey_564453,
                                    base: "", url: url_BackupKey_564454,
                                    schemes: {Scheme.Https})
type
  Call_CreateKey_564461 = ref object of OpenApiRestCall_563564
proc url_CreateKey_564463(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CreateKey_564462(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564474 = path.getOrDefault("key-name")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "key-name", valid_564474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564475 = query.getOrDefault("api-version")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "api-version", valid_564475
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

proc call*(call_564477: Call_CreateKey_564461; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The create key operation can be used to create any key type in Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. It requires the keys/create permission.
  ## 
  let valid = call_564477.validator(path, query, header, formData, body)
  let scheme = call_564477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564477.url(scheme.get, call_564477.host, call_564477.base,
                         call_564477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564477, url, valid)

proc call*(call_564478: Call_CreateKey_564461; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## createKey
  ## The create key operation can be used to create any key type in Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. It requires the keys/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to create a key.
  ##   keyName: string (required)
  ##          : The name for the new key. The system will generate the version name for the new key.
  var path_564479 = newJObject()
  var query_564480 = newJObject()
  var body_564481 = newJObject()
  add(query_564480, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564481 = parameters
  add(path_564479, "key-name", newJString(keyName))
  result = call_564478.call(path_564479, query_564480, nil, nil, body_564481)

var createKey* = Call_CreateKey_564461(name: "createKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/create",
                                    validator: validate_CreateKey_564462,
                                    base: "", url: url_CreateKey_564463,
                                    schemes: {Scheme.Https})
type
  Call_GetKeyVersions_564482 = ref object of OpenApiRestCall_563564
proc url_GetKeyVersions_564484(protocol: Scheme; host: string; base: string;
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

proc validate_GetKeyVersions_564483(path: JsonNode; query: JsonNode;
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
  var valid_564485 = path.getOrDefault("key-name")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "key-name", valid_564485
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564486 = query.getOrDefault("api-version")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "api-version", valid_564486
  var valid_564487 = query.getOrDefault("maxresults")
  valid_564487 = validateParameter(valid_564487, JInt, required = false, default = nil)
  if valid_564487 != nil:
    section.add "maxresults", valid_564487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564488: Call_GetKeyVersions_564482; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The full key identifier, attributes, and tags are provided in the response. This operation requires the keys/list permission.
  ## 
  let valid = call_564488.validator(path, query, header, formData, body)
  let scheme = call_564488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564488.url(scheme.get, call_564488.host, call_564488.base,
                         call_564488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564488, url, valid)

proc call*(call_564489: Call_GetKeyVersions_564482; apiVersion: string;
          keyName: string; maxresults: int = 0): Recallable =
  ## getKeyVersions
  ## The full key identifier, attributes, and tags are provided in the response. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_564490 = newJObject()
  var query_564491 = newJObject()
  add(query_564491, "api-version", newJString(apiVersion))
  add(query_564491, "maxresults", newJInt(maxresults))
  add(path_564490, "key-name", newJString(keyName))
  result = call_564489.call(path_564490, query_564491, nil, nil, nil)

var getKeyVersions* = Call_GetKeyVersions_564482(name: "getKeyVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/keys/{key-name}/versions", validator: validate_GetKeyVersions_564483,
    base: "", url: url_GetKeyVersions_564484, schemes: {Scheme.Https})
type
  Call_GetKey_564492 = ref object of OpenApiRestCall_563564
proc url_GetKey_564494(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetKey_564493(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564495 = path.getOrDefault("key-version")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "key-version", valid_564495
  var valid_564496 = path.getOrDefault("key-name")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "key-name", valid_564496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564497 = query.getOrDefault("api-version")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "api-version", valid_564497
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564498: Call_GetKey_564492; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The get key operation is applicable to all key types. If the requested key is symmetric, then no key material is released in the response. This operation requires the keys/get permission.
  ## 
  let valid = call_564498.validator(path, query, header, formData, body)
  let scheme = call_564498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564498.url(scheme.get, call_564498.host, call_564498.base,
                         call_564498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564498, url, valid)

proc call*(call_564499: Call_GetKey_564492; apiVersion: string; keyVersion: string;
          keyName: string): Recallable =
  ## getKey
  ## The get key operation is applicable to all key types. If the requested key is symmetric, then no key material is released in the response. This operation requires the keys/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyVersion: string (required)
  ##             : Adding the version parameter retrieves a specific version of a key.
  ##   keyName: string (required)
  ##          : The name of the key to get.
  var path_564500 = newJObject()
  var query_564501 = newJObject()
  add(query_564501, "api-version", newJString(apiVersion))
  add(path_564500, "key-version", newJString(keyVersion))
  add(path_564500, "key-name", newJString(keyName))
  result = call_564499.call(path_564500, query_564501, nil, nil, nil)

var getKey* = Call_GetKey_564492(name: "getKey", meth: HttpMethod.HttpGet,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}",
                              validator: validate_GetKey_564493, base: "",
                              url: url_GetKey_564494, schemes: {Scheme.Https})
type
  Call_UpdateKey_564502 = ref object of OpenApiRestCall_563564
proc url_UpdateKey_564504(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UpdateKey_564503(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564505 = path.getOrDefault("key-version")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "key-version", valid_564505
  var valid_564506 = path.getOrDefault("key-name")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "key-name", valid_564506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564507 = query.getOrDefault("api-version")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "api-version", valid_564507
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

proc call*(call_564509: Call_UpdateKey_564502; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## In order to perform this operation, the key must already exist in the Key Vault. Note: The cryptographic material of a key itself cannot be changed. This operation requires the keys/update permission.
  ## 
  let valid = call_564509.validator(path, query, header, formData, body)
  let scheme = call_564509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564509.url(scheme.get, call_564509.host, call_564509.base,
                         call_564509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564509, url, valid)

proc call*(call_564510: Call_UpdateKey_564502; apiVersion: string;
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
  var path_564511 = newJObject()
  var query_564512 = newJObject()
  var body_564513 = newJObject()
  add(query_564512, "api-version", newJString(apiVersion))
  add(path_564511, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564513 = parameters
  add(path_564511, "key-name", newJString(keyName))
  result = call_564510.call(path_564511, query_564512, nil, nil, body_564513)

var updateKey* = Call_UpdateKey_564502(name: "updateKey", meth: HttpMethod.HttpPatch,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/{key-version}",
                                    validator: validate_UpdateKey_564503,
                                    base: "", url: url_UpdateKey_564504,
                                    schemes: {Scheme.Https})
type
  Call_Decrypt_564514 = ref object of OpenApiRestCall_563564
proc url_Decrypt_564516(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Decrypt_564515(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564517 = path.getOrDefault("key-version")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "key-version", valid_564517
  var valid_564518 = path.getOrDefault("key-name")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "key-name", valid_564518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564519 = query.getOrDefault("api-version")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "api-version", valid_564519
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

proc call*(call_564521: Call_Decrypt_564514; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DECRYPT operation decrypts a well-formed block of ciphertext using the target encryption key and specified algorithm. This operation is the reverse of the ENCRYPT operation; only a single block of data may be decrypted, the size of this block is dependent on the target key and the algorithm to be used. The DECRYPT operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/decrypt permission.
  ## 
  let valid = call_564521.validator(path, query, header, formData, body)
  let scheme = call_564521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564521.url(scheme.get, call_564521.host, call_564521.base,
                         call_564521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564521, url, valid)

proc call*(call_564522: Call_Decrypt_564514; apiVersion: string; keyVersion: string;
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
  var path_564523 = newJObject()
  var query_564524 = newJObject()
  var body_564525 = newJObject()
  add(query_564524, "api-version", newJString(apiVersion))
  add(path_564523, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564525 = parameters
  add(path_564523, "key-name", newJString(keyName))
  result = call_564522.call(path_564523, query_564524, nil, nil, body_564525)

var decrypt* = Call_Decrypt_564514(name: "decrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/decrypt",
                                validator: validate_Decrypt_564515, base: "",
                                url: url_Decrypt_564516, schemes: {Scheme.Https})
type
  Call_Encrypt_564526 = ref object of OpenApiRestCall_563564
proc url_Encrypt_564528(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Encrypt_564527(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564529 = path.getOrDefault("key-version")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "key-version", valid_564529
  var valid_564530 = path.getOrDefault("key-name")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "key-name", valid_564530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564531 = query.getOrDefault("api-version")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "api-version", valid_564531
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

proc call*(call_564533: Call_Encrypt_564526; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The ENCRYPT operation encrypts an arbitrary sequence of bytes using an encryption key that is stored in Azure Key Vault. Note that the ENCRYPT operation only supports a single block of data, the size of which is dependent on the target key and the encryption algorithm to be used. The ENCRYPT operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/encrypt permission.
  ## 
  let valid = call_564533.validator(path, query, header, formData, body)
  let scheme = call_564533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564533.url(scheme.get, call_564533.host, call_564533.base,
                         call_564533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564533, url, valid)

proc call*(call_564534: Call_Encrypt_564526; apiVersion: string; keyVersion: string;
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
  var path_564535 = newJObject()
  var query_564536 = newJObject()
  var body_564537 = newJObject()
  add(query_564536, "api-version", newJString(apiVersion))
  add(path_564535, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564537 = parameters
  add(path_564535, "key-name", newJString(keyName))
  result = call_564534.call(path_564535, query_564536, nil, nil, body_564537)

var encrypt* = Call_Encrypt_564526(name: "encrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/encrypt",
                                validator: validate_Encrypt_564527, base: "",
                                url: url_Encrypt_564528, schemes: {Scheme.Https})
type
  Call_Sign_564538 = ref object of OpenApiRestCall_563564
proc url_Sign_564540(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Sign_564539(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564541 = path.getOrDefault("key-version")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "key-version", valid_564541
  var valid_564542 = path.getOrDefault("key-name")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "key-name", valid_564542
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564543 = query.getOrDefault("api-version")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "api-version", valid_564543
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

proc call*(call_564545: Call_Sign_564538; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The SIGN operation is applicable to asymmetric and symmetric keys stored in Azure Key Vault since this operation uses the private portion of the key. This operation requires the keys/sign permission.
  ## 
  let valid = call_564545.validator(path, query, header, formData, body)
  let scheme = call_564545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564545.url(scheme.get, call_564545.host, call_564545.base,
                         call_564545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564545, url, valid)

proc call*(call_564546: Call_Sign_564538; apiVersion: string; keyVersion: string;
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
  var path_564547 = newJObject()
  var query_564548 = newJObject()
  var body_564549 = newJObject()
  add(query_564548, "api-version", newJString(apiVersion))
  add(path_564547, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564549 = parameters
  add(path_564547, "key-name", newJString(keyName))
  result = call_564546.call(path_564547, query_564548, nil, nil, body_564549)

var sign* = Call_Sign_564538(name: "sign", meth: HttpMethod.HttpPost,
                          host: "azure.local",
                          route: "/keys/{key-name}/{key-version}/sign",
                          validator: validate_Sign_564539, base: "", url: url_Sign_564540,
                          schemes: {Scheme.Https})
type
  Call_UnwrapKey_564550 = ref object of OpenApiRestCall_563564
proc url_UnwrapKey_564552(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UnwrapKey_564551(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564553 = path.getOrDefault("key-version")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "key-version", valid_564553
  var valid_564554 = path.getOrDefault("key-name")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "key-name", valid_564554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564555 = query.getOrDefault("api-version")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "api-version", valid_564555
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

proc call*(call_564557: Call_UnwrapKey_564550; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UNWRAP operation supports decryption of a symmetric key using the target key encryption key. This operation is the reverse of the WRAP operation. The UNWRAP operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/unwrapKey permission.
  ## 
  let valid = call_564557.validator(path, query, header, formData, body)
  let scheme = call_564557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564557.url(scheme.get, call_564557.host, call_564557.base,
                         call_564557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564557, url, valid)

proc call*(call_564558: Call_UnwrapKey_564550; apiVersion: string;
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
  var path_564559 = newJObject()
  var query_564560 = newJObject()
  var body_564561 = newJObject()
  add(query_564560, "api-version", newJString(apiVersion))
  add(path_564559, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564561 = parameters
  add(path_564559, "key-name", newJString(keyName))
  result = call_564558.call(path_564559, query_564560, nil, nil, body_564561)

var unwrapKey* = Call_UnwrapKey_564550(name: "unwrapKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/keys/{key-name}/{key-version}/unwrapkey",
                                    validator: validate_UnwrapKey_564551,
                                    base: "", url: url_UnwrapKey_564552,
                                    schemes: {Scheme.Https})
type
  Call_Verify_564562 = ref object of OpenApiRestCall_563564
proc url_Verify_564564(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Verify_564563(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564565 = path.getOrDefault("key-version")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "key-version", valid_564565
  var valid_564566 = path.getOrDefault("key-name")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "key-name", valid_564566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564567 = query.getOrDefault("api-version")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "api-version", valid_564567
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

proc call*(call_564569: Call_Verify_564562; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The VERIFY operation is applicable to symmetric keys stored in Azure Key Vault. VERIFY is not strictly necessary for asymmetric keys stored in Azure Key Vault since signature verification can be performed using the public portion of the key but this operation is supported as a convenience for callers that only have a key-reference and not the public portion of the key. This operation requires the keys/verify permission.
  ## 
  let valid = call_564569.validator(path, query, header, formData, body)
  let scheme = call_564569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564569.url(scheme.get, call_564569.host, call_564569.base,
                         call_564569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564569, url, valid)

proc call*(call_564570: Call_Verify_564562; apiVersion: string; keyVersion: string;
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
  var path_564571 = newJObject()
  var query_564572 = newJObject()
  var body_564573 = newJObject()
  add(query_564572, "api-version", newJString(apiVersion))
  add(path_564571, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564573 = parameters
  add(path_564571, "key-name", newJString(keyName))
  result = call_564570.call(path_564571, query_564572, nil, nil, body_564573)

var verify* = Call_Verify_564562(name: "verify", meth: HttpMethod.HttpPost,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}/verify",
                              validator: validate_Verify_564563, base: "",
                              url: url_Verify_564564, schemes: {Scheme.Https})
type
  Call_WrapKey_564574 = ref object of OpenApiRestCall_563564
proc url_WrapKey_564576(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_WrapKey_564575(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564577 = path.getOrDefault("key-version")
  valid_564577 = validateParameter(valid_564577, JString, required = true,
                                 default = nil)
  if valid_564577 != nil:
    section.add "key-version", valid_564577
  var valid_564578 = path.getOrDefault("key-name")
  valid_564578 = validateParameter(valid_564578, JString, required = true,
                                 default = nil)
  if valid_564578 != nil:
    section.add "key-name", valid_564578
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564579 = query.getOrDefault("api-version")
  valid_564579 = validateParameter(valid_564579, JString, required = true,
                                 default = nil)
  if valid_564579 != nil:
    section.add "api-version", valid_564579
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

proc call*(call_564581: Call_WrapKey_564574; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The WRAP operation supports encryption of a symmetric key using a key encryption key that has previously been stored in an Azure Key Vault. The WRAP operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using the public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/wrapKey permission.
  ## 
  let valid = call_564581.validator(path, query, header, formData, body)
  let scheme = call_564581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564581.url(scheme.get, call_564581.host, call_564581.base,
                         call_564581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564581, url, valid)

proc call*(call_564582: Call_WrapKey_564574; apiVersion: string; keyVersion: string;
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
  var path_564583 = newJObject()
  var query_564584 = newJObject()
  var body_564585 = newJObject()
  add(query_564584, "api-version", newJString(apiVersion))
  add(path_564583, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_564585 = parameters
  add(path_564583, "key-name", newJString(keyName))
  result = call_564582.call(path_564583, query_564584, nil, nil, body_564585)

var wrapKey* = Call_WrapKey_564574(name: "wrapKey", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/wrapkey",
                                validator: validate_WrapKey_564575, base: "",
                                url: url_WrapKey_564576, schemes: {Scheme.Https})
type
  Call_GetSecrets_564586 = ref object of OpenApiRestCall_563564
proc url_GetSecrets_564588(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetSecrets_564587(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564589 = query.getOrDefault("api-version")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "api-version", valid_564589
  var valid_564590 = query.getOrDefault("maxresults")
  valid_564590 = validateParameter(valid_564590, JInt, required = false, default = nil)
  if valid_564590 != nil:
    section.add "maxresults", valid_564590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564591: Call_GetSecrets_564586; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Secrets operation is applicable to the entire vault. However, only the base secret identifier and its attributes are provided in the response. Individual secret versions are not listed in the response. This operation requires the secrets/list permission.
  ## 
  let valid = call_564591.validator(path, query, header, formData, body)
  let scheme = call_564591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564591.url(scheme.get, call_564591.host, call_564591.base,
                         call_564591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564591, url, valid)

proc call*(call_564592: Call_GetSecrets_564586; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getSecrets
  ## The Get Secrets operation is applicable to the entire vault. However, only the base secret identifier and its attributes are provided in the response. Individual secret versions are not listed in the response. This operation requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  var query_564593 = newJObject()
  add(query_564593, "api-version", newJString(apiVersion))
  add(query_564593, "maxresults", newJInt(maxresults))
  result = call_564592.call(nil, query_564593, nil, nil, nil)

var getSecrets* = Call_GetSecrets_564586(name: "getSecrets",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/secrets",
                                      validator: validate_GetSecrets_564587,
                                      base: "", url: url_GetSecrets_564588,
                                      schemes: {Scheme.Https})
type
  Call_RestoreSecret_564594 = ref object of OpenApiRestCall_563564
proc url_RestoreSecret_564596(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreSecret_564595(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564597 = query.getOrDefault("api-version")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "api-version", valid_564597
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

proc call*(call_564599: Call_RestoreSecret_564594; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backed up secret, and all its versions, to a vault. This operation requires the secrets/restore permission.
  ## 
  let valid = call_564599.validator(path, query, header, formData, body)
  let scheme = call_564599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564599.url(scheme.get, call_564599.host, call_564599.base,
                         call_564599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564599, url, valid)

proc call*(call_564600: Call_RestoreSecret_564594; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreSecret
  ## Restores a backed up secret, and all its versions, to a vault. This operation requires the secrets/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the secret.
  var query_564601 = newJObject()
  var body_564602 = newJObject()
  add(query_564601, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564602 = parameters
  result = call_564600.call(nil, query_564601, nil, nil, body_564602)

var restoreSecret* = Call_RestoreSecret_564594(name: "restoreSecret",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/secrets/restore",
    validator: validate_RestoreSecret_564595, base: "", url: url_RestoreSecret_564596,
    schemes: {Scheme.Https})
type
  Call_SetSecret_564603 = ref object of OpenApiRestCall_563564
proc url_SetSecret_564605(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SetSecret_564604(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564606 = path.getOrDefault("secret-name")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "secret-name", valid_564606
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564607 = query.getOrDefault("api-version")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "api-version", valid_564607
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

proc call*(call_564609: Call_SetSecret_564603; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ##  The SET operation adds a secret to the Azure Key Vault. If the named secret already exists, Azure Key Vault creates a new version of that secret. This operation requires the secrets/set permission.
  ## 
  let valid = call_564609.validator(path, query, header, formData, body)
  let scheme = call_564609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564609.url(scheme.get, call_564609.host, call_564609.base,
                         call_564609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564609, url, valid)

proc call*(call_564610: Call_SetSecret_564603; apiVersion: string;
          secretName: string; parameters: JsonNode): Recallable =
  ## setSecret
  ##  The SET operation adds a secret to the Azure Key Vault. If the named secret already exists, Azure Key Vault creates a new version of that secret. This operation requires the secrets/set permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  ##   parameters: JObject (required)
  ##             : The parameters for setting the secret.
  var path_564611 = newJObject()
  var query_564612 = newJObject()
  var body_564613 = newJObject()
  add(query_564612, "api-version", newJString(apiVersion))
  add(path_564611, "secret-name", newJString(secretName))
  if parameters != nil:
    body_564613 = parameters
  result = call_564610.call(path_564611, query_564612, nil, nil, body_564613)

var setSecret* = Call_SetSecret_564603(name: "setSecret", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/secrets/{secret-name}",
                                    validator: validate_SetSecret_564604,
                                    base: "", url: url_SetSecret_564605,
                                    schemes: {Scheme.Https})
type
  Call_DeleteSecret_564614 = ref object of OpenApiRestCall_563564
proc url_DeleteSecret_564616(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteSecret_564615(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564617 = path.getOrDefault("secret-name")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "secret-name", valid_564617
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564618 = query.getOrDefault("api-version")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = nil)
  if valid_564618 != nil:
    section.add "api-version", valid_564618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564619: Call_DeleteSecret_564614; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DELETE operation applies to any secret stored in Azure Key Vault. DELETE cannot be applied to an individual version of a secret. This operation requires the secrets/delete permission.
  ## 
  let valid = call_564619.validator(path, query, header, formData, body)
  let scheme = call_564619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564619.url(scheme.get, call_564619.host, call_564619.base,
                         call_564619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564619, url, valid)

proc call*(call_564620: Call_DeleteSecret_564614; apiVersion: string;
          secretName: string): Recallable =
  ## deleteSecret
  ## The DELETE operation applies to any secret stored in Azure Key Vault. DELETE cannot be applied to an individual version of a secret. This operation requires the secrets/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_564621 = newJObject()
  var query_564622 = newJObject()
  add(query_564622, "api-version", newJString(apiVersion))
  add(path_564621, "secret-name", newJString(secretName))
  result = call_564620.call(path_564621, query_564622, nil, nil, nil)

var deleteSecret* = Call_DeleteSecret_564614(name: "deleteSecret",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/secrets/{secret-name}", validator: validate_DeleteSecret_564615,
    base: "", url: url_DeleteSecret_564616, schemes: {Scheme.Https})
type
  Call_BackupSecret_564623 = ref object of OpenApiRestCall_563564
proc url_BackupSecret_564625(protocol: Scheme; host: string; base: string;
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

proc validate_BackupSecret_564624(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564626 = path.getOrDefault("secret-name")
  valid_564626 = validateParameter(valid_564626, JString, required = true,
                                 default = nil)
  if valid_564626 != nil:
    section.add "secret-name", valid_564626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564627 = query.getOrDefault("api-version")
  valid_564627 = validateParameter(valid_564627, JString, required = true,
                                 default = nil)
  if valid_564627 != nil:
    section.add "api-version", valid_564627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564628: Call_BackupSecret_564623; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified secret be downloaded to the client. All versions of the secret will be downloaded. This operation requires the secrets/backup permission.
  ## 
  let valid = call_564628.validator(path, query, header, formData, body)
  let scheme = call_564628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564628.url(scheme.get, call_564628.host, call_564628.base,
                         call_564628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564628, url, valid)

proc call*(call_564629: Call_BackupSecret_564623; apiVersion: string;
          secretName: string): Recallable =
  ## backupSecret
  ## Requests that a backup of the specified secret be downloaded to the client. All versions of the secret will be downloaded. This operation requires the secrets/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_564630 = newJObject()
  var query_564631 = newJObject()
  add(query_564631, "api-version", newJString(apiVersion))
  add(path_564630, "secret-name", newJString(secretName))
  result = call_564629.call(path_564630, query_564631, nil, nil, nil)

var backupSecret* = Call_BackupSecret_564623(name: "backupSecret",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/secrets/{secret-name}/backup", validator: validate_BackupSecret_564624,
    base: "", url: url_BackupSecret_564625, schemes: {Scheme.Https})
type
  Call_GetSecretVersions_564632 = ref object of OpenApiRestCall_563564
proc url_GetSecretVersions_564634(protocol: Scheme; host: string; base: string;
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

proc validate_GetSecretVersions_564633(path: JsonNode; query: JsonNode;
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
  var valid_564635 = path.getOrDefault("secret-name")
  valid_564635 = validateParameter(valid_564635, JString, required = true,
                                 default = nil)
  if valid_564635 != nil:
    section.add "secret-name", valid_564635
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564636 = query.getOrDefault("api-version")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "api-version", valid_564636
  var valid_564637 = query.getOrDefault("maxresults")
  valid_564637 = validateParameter(valid_564637, JInt, required = false, default = nil)
  if valid_564637 != nil:
    section.add "maxresults", valid_564637
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564638: Call_GetSecretVersions_564632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The full secret identifier and attributes are provided in the response. No values are returned for the secrets. This operations requires the secrets/list permission.
  ## 
  let valid = call_564638.validator(path, query, header, formData, body)
  let scheme = call_564638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564638.url(scheme.get, call_564638.host, call_564638.base,
                         call_564638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564638, url, valid)

proc call*(call_564639: Call_GetSecretVersions_564632; apiVersion: string;
          secretName: string; maxresults: int = 0): Recallable =
  ## getSecretVersions
  ## The full secret identifier and attributes are provided in the response. No values are returned for the secrets. This operations requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  var path_564640 = newJObject()
  var query_564641 = newJObject()
  add(query_564641, "api-version", newJString(apiVersion))
  add(path_564640, "secret-name", newJString(secretName))
  add(query_564641, "maxresults", newJInt(maxresults))
  result = call_564639.call(path_564640, query_564641, nil, nil, nil)

var getSecretVersions* = Call_GetSecretVersions_564632(name: "getSecretVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/secrets/{secret-name}/versions",
    validator: validate_GetSecretVersions_564633, base: "",
    url: url_GetSecretVersions_564634, schemes: {Scheme.Https})
type
  Call_GetSecret_564642 = ref object of OpenApiRestCall_563564
proc url_GetSecret_564644(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetSecret_564643(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564645 = path.getOrDefault("secret-version")
  valid_564645 = validateParameter(valid_564645, JString, required = true,
                                 default = nil)
  if valid_564645 != nil:
    section.add "secret-version", valid_564645
  var valid_564646 = path.getOrDefault("secret-name")
  valid_564646 = validateParameter(valid_564646, JString, required = true,
                                 default = nil)
  if valid_564646 != nil:
    section.add "secret-name", valid_564646
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564647 = query.getOrDefault("api-version")
  valid_564647 = validateParameter(valid_564647, JString, required = true,
                                 default = nil)
  if valid_564647 != nil:
    section.add "api-version", valid_564647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564648: Call_GetSecret_564642; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GET operation is applicable to any secret stored in Azure Key Vault. This operation requires the secrets/get permission.
  ## 
  let valid = call_564648.validator(path, query, header, formData, body)
  let scheme = call_564648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564648.url(scheme.get, call_564648.host, call_564648.base,
                         call_564648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564648, url, valid)

proc call*(call_564649: Call_GetSecret_564642; apiVersion: string;
          secretVersion: string; secretName: string): Recallable =
  ## getSecret
  ## The GET operation is applicable to any secret stored in Azure Key Vault. This operation requires the secrets/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretVersion: string (required)
  ##                : The version of the secret.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_564650 = newJObject()
  var query_564651 = newJObject()
  add(query_564651, "api-version", newJString(apiVersion))
  add(path_564650, "secret-version", newJString(secretVersion))
  add(path_564650, "secret-name", newJString(secretName))
  result = call_564649.call(path_564650, query_564651, nil, nil, nil)

var getSecret* = Call_GetSecret_564642(name: "getSecret", meth: HttpMethod.HttpGet,
                                    host: "azure.local", route: "/secrets/{secret-name}/{secret-version}",
                                    validator: validate_GetSecret_564643,
                                    base: "", url: url_GetSecret_564644,
                                    schemes: {Scheme.Https})
type
  Call_UpdateSecret_564652 = ref object of OpenApiRestCall_563564
proc url_UpdateSecret_564654(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateSecret_564653(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564655 = path.getOrDefault("secret-version")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "secret-version", valid_564655
  var valid_564656 = path.getOrDefault("secret-name")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "secret-name", valid_564656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564657 = query.getOrDefault("api-version")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "api-version", valid_564657
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

proc call*(call_564659: Call_UpdateSecret_564652; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UPDATE operation changes specified attributes of an existing stored secret. Attributes that are not specified in the request are left unchanged. The value of a secret itself cannot be changed. This operation requires the secrets/set permission.
  ## 
  let valid = call_564659.validator(path, query, header, formData, body)
  let scheme = call_564659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564659.url(scheme.get, call_564659.host, call_564659.base,
                         call_564659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564659, url, valid)

proc call*(call_564660: Call_UpdateSecret_564652; apiVersion: string;
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
  var path_564661 = newJObject()
  var query_564662 = newJObject()
  var body_564663 = newJObject()
  add(query_564662, "api-version", newJString(apiVersion))
  add(path_564661, "secret-version", newJString(secretVersion))
  add(path_564661, "secret-name", newJString(secretName))
  if parameters != nil:
    body_564663 = parameters
  result = call_564660.call(path_564661, query_564662, nil, nil, body_564663)

var updateSecret* = Call_UpdateSecret_564652(name: "updateSecret",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/secrets/{secret-name}/{secret-version}",
    validator: validate_UpdateSecret_564653, base: "", url: url_UpdateSecret_564654,
    schemes: {Scheme.Https})
type
  Call_GetStorageAccounts_564664 = ref object of OpenApiRestCall_563564
proc url_GetStorageAccounts_564666(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetStorageAccounts_564665(path: JsonNode; query: JsonNode;
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
  var valid_564667 = query.getOrDefault("api-version")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "api-version", valid_564667
  var valid_564668 = query.getOrDefault("maxresults")
  valid_564668 = validateParameter(valid_564668, JInt, required = false, default = nil)
  if valid_564668 != nil:
    section.add "maxresults", valid_564668
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564669: Call_GetStorageAccounts_564664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List storage accounts managed by the specified key vault. This operation requires the storage/list permission.
  ## 
  let valid = call_564669.validator(path, query, header, formData, body)
  let scheme = call_564669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564669.url(scheme.get, call_564669.host, call_564669.base,
                         call_564669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564669, url, valid)

proc call*(call_564670: Call_GetStorageAccounts_564664; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getStorageAccounts
  ## List storage accounts managed by the specified key vault. This operation requires the storage/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_564671 = newJObject()
  add(query_564671, "api-version", newJString(apiVersion))
  add(query_564671, "maxresults", newJInt(maxresults))
  result = call_564670.call(nil, query_564671, nil, nil, nil)

var getStorageAccounts* = Call_GetStorageAccounts_564664(
    name: "getStorageAccounts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage", validator: validate_GetStorageAccounts_564665, base: "",
    url: url_GetStorageAccounts_564666, schemes: {Scheme.Https})
type
  Call_SetStorageAccount_564681 = ref object of OpenApiRestCall_563564
proc url_SetStorageAccount_564683(protocol: Scheme; host: string; base: string;
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

proc validate_SetStorageAccount_564682(path: JsonNode; query: JsonNode;
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
  var valid_564684 = path.getOrDefault("storage-account-name")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = nil)
  if valid_564684 != nil:
    section.add "storage-account-name", valid_564684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564685 = query.getOrDefault("api-version")
  valid_564685 = validateParameter(valid_564685, JString, required = true,
                                 default = nil)
  if valid_564685 != nil:
    section.add "api-version", valid_564685
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

proc call*(call_564687: Call_SetStorageAccount_564681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new storage account. This operation requires the storage/set permission.
  ## 
  let valid = call_564687.validator(path, query, header, formData, body)
  let scheme = call_564687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564687.url(scheme.get, call_564687.host, call_564687.base,
                         call_564687.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564687, url, valid)

proc call*(call_564688: Call_SetStorageAccount_564681; apiVersion: string;
          storageAccountName: string; parameters: JsonNode): Recallable =
  ## setStorageAccount
  ## Creates or updates a new storage account. This operation requires the storage/set permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to create a storage account.
  var path_564689 = newJObject()
  var query_564690 = newJObject()
  var body_564691 = newJObject()
  add(query_564690, "api-version", newJString(apiVersion))
  add(path_564689, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_564691 = parameters
  result = call_564688.call(path_564689, query_564690, nil, nil, body_564691)

var setStorageAccount* = Call_SetStorageAccount_564681(name: "setStorageAccount",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_SetStorageAccount_564682, base: "",
    url: url_SetStorageAccount_564683, schemes: {Scheme.Https})
type
  Call_GetStorageAccount_564672 = ref object of OpenApiRestCall_563564
proc url_GetStorageAccount_564674(protocol: Scheme; host: string; base: string;
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

proc validate_GetStorageAccount_564673(path: JsonNode; query: JsonNode;
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
  var valid_564675 = path.getOrDefault("storage-account-name")
  valid_564675 = validateParameter(valid_564675, JString, required = true,
                                 default = nil)
  if valid_564675 != nil:
    section.add "storage-account-name", valid_564675
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564676 = query.getOrDefault("api-version")
  valid_564676 = validateParameter(valid_564676, JString, required = true,
                                 default = nil)
  if valid_564676 != nil:
    section.add "api-version", valid_564676
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564677: Call_GetStorageAccount_564672; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specified storage account. This operation requires the storage/get permission.
  ## 
  let valid = call_564677.validator(path, query, header, formData, body)
  let scheme = call_564677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564677.url(scheme.get, call_564677.host, call_564677.base,
                         call_564677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564677, url, valid)

proc call*(call_564678: Call_GetStorageAccount_564672; apiVersion: string;
          storageAccountName: string): Recallable =
  ## getStorageAccount
  ## Gets information about a specified storage account. This operation requires the storage/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_564679 = newJObject()
  var query_564680 = newJObject()
  add(query_564680, "api-version", newJString(apiVersion))
  add(path_564679, "storage-account-name", newJString(storageAccountName))
  result = call_564678.call(path_564679, query_564680, nil, nil, nil)

var getStorageAccount* = Call_GetStorageAccount_564672(name: "getStorageAccount",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_GetStorageAccount_564673, base: "",
    url: url_GetStorageAccount_564674, schemes: {Scheme.Https})
type
  Call_UpdateStorageAccount_564701 = ref object of OpenApiRestCall_563564
proc url_UpdateStorageAccount_564703(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateStorageAccount_564702(path: JsonNode; query: JsonNode;
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
  var valid_564704 = path.getOrDefault("storage-account-name")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "storage-account-name", valid_564704
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564705 = query.getOrDefault("api-version")
  valid_564705 = validateParameter(valid_564705, JString, required = true,
                                 default = nil)
  if valid_564705 != nil:
    section.add "api-version", valid_564705
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

proc call*(call_564707: Call_UpdateStorageAccount_564701; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified attributes associated with the given storage account. This operation requires the storage/set/update permission.
  ## 
  let valid = call_564707.validator(path, query, header, formData, body)
  let scheme = call_564707.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564707.url(scheme.get, call_564707.host, call_564707.base,
                         call_564707.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564707, url, valid)

proc call*(call_564708: Call_UpdateStorageAccount_564701; apiVersion: string;
          storageAccountName: string; parameters: JsonNode): Recallable =
  ## updateStorageAccount
  ## Updates the specified attributes associated with the given storage account. This operation requires the storage/set/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to update a storage account.
  var path_564709 = newJObject()
  var query_564710 = newJObject()
  var body_564711 = newJObject()
  add(query_564710, "api-version", newJString(apiVersion))
  add(path_564709, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_564711 = parameters
  result = call_564708.call(path_564709, query_564710, nil, nil, body_564711)

var updateStorageAccount* = Call_UpdateStorageAccount_564701(
    name: "updateStorageAccount", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_UpdateStorageAccount_564702, base: "",
    url: url_UpdateStorageAccount_564703, schemes: {Scheme.Https})
type
  Call_DeleteStorageAccount_564692 = ref object of OpenApiRestCall_563564
proc url_DeleteStorageAccount_564694(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteStorageAccount_564693(path: JsonNode; query: JsonNode;
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
  var valid_564695 = path.getOrDefault("storage-account-name")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "storage-account-name", valid_564695
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564696 = query.getOrDefault("api-version")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "api-version", valid_564696
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564697: Call_DeleteStorageAccount_564692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a storage account. This operation requires the storage/delete permission.
  ## 
  let valid = call_564697.validator(path, query, header, formData, body)
  let scheme = call_564697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564697.url(scheme.get, call_564697.host, call_564697.base,
                         call_564697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564697, url, valid)

proc call*(call_564698: Call_DeleteStorageAccount_564692; apiVersion: string;
          storageAccountName: string): Recallable =
  ## deleteStorageAccount
  ## Deletes a storage account. This operation requires the storage/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_564699 = newJObject()
  var query_564700 = newJObject()
  add(query_564700, "api-version", newJString(apiVersion))
  add(path_564699, "storage-account-name", newJString(storageAccountName))
  result = call_564698.call(path_564699, query_564700, nil, nil, nil)

var deleteStorageAccount* = Call_DeleteStorageAccount_564692(
    name: "deleteStorageAccount", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_DeleteStorageAccount_564693, base: "",
    url: url_DeleteStorageAccount_564694, schemes: {Scheme.Https})
type
  Call_RegenerateStorageAccountKey_564712 = ref object of OpenApiRestCall_563564
proc url_RegenerateStorageAccountKey_564714(protocol: Scheme; host: string;
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

proc validate_RegenerateStorageAccountKey_564713(path: JsonNode; query: JsonNode;
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
  var valid_564715 = path.getOrDefault("storage-account-name")
  valid_564715 = validateParameter(valid_564715, JString, required = true,
                                 default = nil)
  if valid_564715 != nil:
    section.add "storage-account-name", valid_564715
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564716 = query.getOrDefault("api-version")
  valid_564716 = validateParameter(valid_564716, JString, required = true,
                                 default = nil)
  if valid_564716 != nil:
    section.add "api-version", valid_564716
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

proc call*(call_564718: Call_RegenerateStorageAccountKey_564712; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the specified key value for the given storage account. This operation requires the storage/regeneratekey permission.
  ## 
  let valid = call_564718.validator(path, query, header, formData, body)
  let scheme = call_564718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564718.url(scheme.get, call_564718.host, call_564718.base,
                         call_564718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564718, url, valid)

proc call*(call_564719: Call_RegenerateStorageAccountKey_564712;
          apiVersion: string; storageAccountName: string; parameters: JsonNode): Recallable =
  ## regenerateStorageAccountKey
  ## Regenerates the specified key value for the given storage account. This operation requires the storage/regeneratekey permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to regenerate storage account key.
  var path_564720 = newJObject()
  var query_564721 = newJObject()
  var body_564722 = newJObject()
  add(query_564721, "api-version", newJString(apiVersion))
  add(path_564720, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_564722 = parameters
  result = call_564719.call(path_564720, query_564721, nil, nil, body_564722)

var regenerateStorageAccountKey* = Call_RegenerateStorageAccountKey_564712(
    name: "regenerateStorageAccountKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/storage/{storage-account-name}/regeneratekey",
    validator: validate_RegenerateStorageAccountKey_564713, base: "",
    url: url_RegenerateStorageAccountKey_564714, schemes: {Scheme.Https})
type
  Call_GetSasDefinitions_564723 = ref object of OpenApiRestCall_563564
proc url_GetSasDefinitions_564725(protocol: Scheme; host: string; base: string;
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

proc validate_GetSasDefinitions_564724(path: JsonNode; query: JsonNode;
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
  var valid_564726 = path.getOrDefault("storage-account-name")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "storage-account-name", valid_564726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564727 = query.getOrDefault("api-version")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "api-version", valid_564727
  var valid_564728 = query.getOrDefault("maxresults")
  valid_564728 = validateParameter(valid_564728, JInt, required = false, default = nil)
  if valid_564728 != nil:
    section.add "maxresults", valid_564728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564729: Call_GetSasDefinitions_564723; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List storage SAS definitions for the given storage account. This operation requires the storage/listsas permission.
  ## 
  let valid = call_564729.validator(path, query, header, formData, body)
  let scheme = call_564729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564729.url(scheme.get, call_564729.host, call_564729.base,
                         call_564729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564729, url, valid)

proc call*(call_564730: Call_GetSasDefinitions_564723; apiVersion: string;
          storageAccountName: string; maxresults: int = 0): Recallable =
  ## getSasDefinitions
  ## List storage SAS definitions for the given storage account. This operation requires the storage/listsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var path_564731 = newJObject()
  var query_564732 = newJObject()
  add(query_564732, "api-version", newJString(apiVersion))
  add(path_564731, "storage-account-name", newJString(storageAccountName))
  add(query_564732, "maxresults", newJInt(maxresults))
  result = call_564730.call(path_564731, query_564732, nil, nil, nil)

var getSasDefinitions* = Call_GetSasDefinitions_564723(name: "getSasDefinitions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}/sas",
    validator: validate_GetSasDefinitions_564724, base: "",
    url: url_GetSasDefinitions_564725, schemes: {Scheme.Https})
type
  Call_SetSasDefinition_564743 = ref object of OpenApiRestCall_563564
proc url_SetSasDefinition_564745(protocol: Scheme; host: string; base: string;
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

proc validate_SetSasDefinition_564744(path: JsonNode; query: JsonNode;
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
  var valid_564746 = path.getOrDefault("storage-account-name")
  valid_564746 = validateParameter(valid_564746, JString, required = true,
                                 default = nil)
  if valid_564746 != nil:
    section.add "storage-account-name", valid_564746
  var valid_564747 = path.getOrDefault("sas-definition-name")
  valid_564747 = validateParameter(valid_564747, JString, required = true,
                                 default = nil)
  if valid_564747 != nil:
    section.add "sas-definition-name", valid_564747
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564748 = query.getOrDefault("api-version")
  valid_564748 = validateParameter(valid_564748, JString, required = true,
                                 default = nil)
  if valid_564748 != nil:
    section.add "api-version", valid_564748
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

proc call*(call_564750: Call_SetSasDefinition_564743; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new SAS definition for the specified storage account. This operation requires the storage/setsas permission.
  ## 
  let valid = call_564750.validator(path, query, header, formData, body)
  let scheme = call_564750.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564750.url(scheme.get, call_564750.host, call_564750.base,
                         call_564750.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564750, url, valid)

proc call*(call_564751: Call_SetSasDefinition_564743; apiVersion: string;
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
  var path_564752 = newJObject()
  var query_564753 = newJObject()
  var body_564754 = newJObject()
  add(query_564753, "api-version", newJString(apiVersion))
  add(path_564752, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_564754 = parameters
  add(path_564752, "sas-definition-name", newJString(sasDefinitionName))
  result = call_564751.call(path_564752, query_564753, nil, nil, body_564754)

var setSasDefinition* = Call_SetSasDefinition_564743(name: "setSasDefinition",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_SetSasDefinition_564744, base: "",
    url: url_SetSasDefinition_564745, schemes: {Scheme.Https})
type
  Call_GetSasDefinition_564733 = ref object of OpenApiRestCall_563564
proc url_GetSasDefinition_564735(protocol: Scheme; host: string; base: string;
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

proc validate_GetSasDefinition_564734(path: JsonNode; query: JsonNode;
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
  var valid_564736 = path.getOrDefault("storage-account-name")
  valid_564736 = validateParameter(valid_564736, JString, required = true,
                                 default = nil)
  if valid_564736 != nil:
    section.add "storage-account-name", valid_564736
  var valid_564737 = path.getOrDefault("sas-definition-name")
  valid_564737 = validateParameter(valid_564737, JString, required = true,
                                 default = nil)
  if valid_564737 != nil:
    section.add "sas-definition-name", valid_564737
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564738 = query.getOrDefault("api-version")
  valid_564738 = validateParameter(valid_564738, JString, required = true,
                                 default = nil)
  if valid_564738 != nil:
    section.add "api-version", valid_564738
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564739: Call_GetSasDefinition_564733; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a SAS definition for the specified storage account. This operation requires the storage/getsas permission.
  ## 
  let valid = call_564739.validator(path, query, header, formData, body)
  let scheme = call_564739.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564739.url(scheme.get, call_564739.host, call_564739.base,
                         call_564739.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564739, url, valid)

proc call*(call_564740: Call_GetSasDefinition_564733; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## getSasDefinition
  ## Gets information about a SAS definition for the specified storage account. This operation requires the storage/getsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_564741 = newJObject()
  var query_564742 = newJObject()
  add(query_564742, "api-version", newJString(apiVersion))
  add(path_564741, "storage-account-name", newJString(storageAccountName))
  add(path_564741, "sas-definition-name", newJString(sasDefinitionName))
  result = call_564740.call(path_564741, query_564742, nil, nil, nil)

var getSasDefinition* = Call_GetSasDefinition_564733(name: "getSasDefinition",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_GetSasDefinition_564734, base: "",
    url: url_GetSasDefinition_564735, schemes: {Scheme.Https})
type
  Call_UpdateSasDefinition_564765 = ref object of OpenApiRestCall_563564
proc url_UpdateSasDefinition_564767(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateSasDefinition_564766(path: JsonNode; query: JsonNode;
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
  var valid_564768 = path.getOrDefault("storage-account-name")
  valid_564768 = validateParameter(valid_564768, JString, required = true,
                                 default = nil)
  if valid_564768 != nil:
    section.add "storage-account-name", valid_564768
  var valid_564769 = path.getOrDefault("sas-definition-name")
  valid_564769 = validateParameter(valid_564769, JString, required = true,
                                 default = nil)
  if valid_564769 != nil:
    section.add "sas-definition-name", valid_564769
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564770 = query.getOrDefault("api-version")
  valid_564770 = validateParameter(valid_564770, JString, required = true,
                                 default = nil)
  if valid_564770 != nil:
    section.add "api-version", valid_564770
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

proc call*(call_564772: Call_UpdateSasDefinition_564765; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified attributes associated with the given SAS definition. This operation requires the storage/setsas permission.
  ## 
  let valid = call_564772.validator(path, query, header, formData, body)
  let scheme = call_564772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564772.url(scheme.get, call_564772.host, call_564772.base,
                         call_564772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564772, url, valid)

proc call*(call_564773: Call_UpdateSasDefinition_564765; apiVersion: string;
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
  var path_564774 = newJObject()
  var query_564775 = newJObject()
  var body_564776 = newJObject()
  add(query_564775, "api-version", newJString(apiVersion))
  add(path_564774, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_564776 = parameters
  add(path_564774, "sas-definition-name", newJString(sasDefinitionName))
  result = call_564773.call(path_564774, query_564775, nil, nil, body_564776)

var updateSasDefinition* = Call_UpdateSasDefinition_564765(
    name: "updateSasDefinition", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_UpdateSasDefinition_564766, base: "",
    url: url_UpdateSasDefinition_564767, schemes: {Scheme.Https})
type
  Call_DeleteSasDefinition_564755 = ref object of OpenApiRestCall_563564
proc url_DeleteSasDefinition_564757(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteSasDefinition_564756(path: JsonNode; query: JsonNode;
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
  var valid_564758 = path.getOrDefault("storage-account-name")
  valid_564758 = validateParameter(valid_564758, JString, required = true,
                                 default = nil)
  if valid_564758 != nil:
    section.add "storage-account-name", valid_564758
  var valid_564759 = path.getOrDefault("sas-definition-name")
  valid_564759 = validateParameter(valid_564759, JString, required = true,
                                 default = nil)
  if valid_564759 != nil:
    section.add "sas-definition-name", valid_564759
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564760 = query.getOrDefault("api-version")
  valid_564760 = validateParameter(valid_564760, JString, required = true,
                                 default = nil)
  if valid_564760 != nil:
    section.add "api-version", valid_564760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564761: Call_DeleteSasDefinition_564755; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SAS definition from a specified storage account. This operation requires the storage/deletesas permission.
  ## 
  let valid = call_564761.validator(path, query, header, formData, body)
  let scheme = call_564761.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564761.url(scheme.get, call_564761.host, call_564761.base,
                         call_564761.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564761, url, valid)

proc call*(call_564762: Call_DeleteSasDefinition_564755; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## deleteSasDefinition
  ## Deletes a SAS definition from a specified storage account. This operation requires the storage/deletesas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_564763 = newJObject()
  var query_564764 = newJObject()
  add(query_564764, "api-version", newJString(apiVersion))
  add(path_564763, "storage-account-name", newJString(storageAccountName))
  add(path_564763, "sas-definition-name", newJString(sasDefinitionName))
  result = call_564762.call(path_564763, query_564764, nil, nil, nil)

var deleteSasDefinition* = Call_DeleteSasDefinition_564755(
    name: "deleteSasDefinition", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_DeleteSasDefinition_564756, base: "",
    url: url_DeleteSasDefinition_564757, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
