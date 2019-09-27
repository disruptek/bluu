
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_GetCertificates_593660 = ref object of OpenApiRestCall_593438
proc url_GetCertificates_593662(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificates_593661(path: JsonNode; query: JsonNode;
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
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "api-version", valid_593821
  var valid_593822 = query.getOrDefault("maxresults")
  valid_593822 = validateParameter(valid_593822, JInt, required = false, default = nil)
  if valid_593822 != nil:
    section.add "maxresults", valid_593822
  var valid_593823 = query.getOrDefault("includePending")
  valid_593823 = validateParameter(valid_593823, JBool, required = false, default = nil)
  if valid_593823 != nil:
    section.add "includePending", valid_593823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593846: Call_GetCertificates_593660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificates operation returns the set of certificates resources in the specified key vault. This operation requires the certificates/list permission.
  ## 
  let valid = call_593846.validator(path, query, header, formData, body)
  let scheme = call_593846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593846.url(scheme.get, call_593846.host, call_593846.base,
                         call_593846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593846, url, valid)

proc call*(call_593917: Call_GetCertificates_593660; apiVersion: string;
          maxresults: int = 0; includePending: bool = false): Recallable =
  ## getCertificates
  ## The GetCertificates operation returns the set of certificates resources in the specified key vault. This operation requires the certificates/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   includePending: bool
  ##                 : Specifies whether to include certificates which are not completely provisioned.
  var query_593918 = newJObject()
  add(query_593918, "api-version", newJString(apiVersion))
  add(query_593918, "maxresults", newJInt(maxresults))
  add(query_593918, "includePending", newJBool(includePending))
  result = call_593917.call(nil, query_593918, nil, nil, nil)

var getCertificates* = Call_GetCertificates_593660(name: "getCertificates",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates",
    validator: validate_GetCertificates_593661, base: "", url: url_GetCertificates_593662,
    schemes: {Scheme.Https})
type
  Call_SetCertificateContacts_593965 = ref object of OpenApiRestCall_593438
proc url_SetCertificateContacts_593967(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SetCertificateContacts_593966(path: JsonNode; query: JsonNode;
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
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
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

proc call*(call_593987: Call_SetCertificateContacts_593965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the certificate contacts for the specified key vault. This operation requires the certificates/managecontacts permission.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_SetCertificateContacts_593965; apiVersion: string;
          contacts: JsonNode): Recallable =
  ## setCertificateContacts
  ## Sets the certificate contacts for the specified key vault. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   contacts: JObject (required)
  ##           : The contacts for the key vault certificate.
  var query_593989 = newJObject()
  var body_593990 = newJObject()
  add(query_593989, "api-version", newJString(apiVersion))
  if contacts != nil:
    body_593990 = contacts
  result = call_593988.call(nil, query_593989, nil, nil, body_593990)

var setCertificateContacts* = Call_SetCertificateContacts_593965(
    name: "setCertificateContacts", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/certificates/contacts", validator: validate_SetCertificateContacts_593966,
    base: "", url: url_SetCertificateContacts_593967, schemes: {Scheme.Https})
type
  Call_GetCertificateContacts_593958 = ref object of OpenApiRestCall_593438
proc url_GetCertificateContacts_593960(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificateContacts_593959(path: JsonNode; query: JsonNode;
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
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_GetCertificateContacts_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificateContacts operation returns the set of certificate contact resources in the specified key vault. This operation requires the certificates/managecontacts permission.
  ## 
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_GetCertificateContacts_593958; apiVersion: string): Recallable =
  ## getCertificateContacts
  ## The GetCertificateContacts operation returns the set of certificate contact resources in the specified key vault. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_593964 = newJObject()
  add(query_593964, "api-version", newJString(apiVersion))
  result = call_593963.call(nil, query_593964, nil, nil, nil)

var getCertificateContacts* = Call_GetCertificateContacts_593958(
    name: "getCertificateContacts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/contacts", validator: validate_GetCertificateContacts_593959,
    base: "", url: url_GetCertificateContacts_593960, schemes: {Scheme.Https})
type
  Call_DeleteCertificateContacts_593991 = ref object of OpenApiRestCall_593438
proc url_DeleteCertificateContacts_593993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeleteCertificateContacts_593992(path: JsonNode; query: JsonNode;
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
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "api-version", valid_593994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593995: Call_DeleteCertificateContacts_593991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the certificate contacts for a specified key vault certificate. This operation requires the certificates/managecontacts permission.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_DeleteCertificateContacts_593991; apiVersion: string): Recallable =
  ## deleteCertificateContacts
  ## Deletes the certificate contacts for a specified key vault certificate. This operation requires the certificates/managecontacts permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_593997 = newJObject()
  add(query_593997, "api-version", newJString(apiVersion))
  result = call_593996.call(nil, query_593997, nil, nil, nil)

var deleteCertificateContacts* = Call_DeleteCertificateContacts_593991(
    name: "deleteCertificateContacts", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/contacts",
    validator: validate_DeleteCertificateContacts_593992, base: "",
    url: url_DeleteCertificateContacts_593993, schemes: {Scheme.Https})
type
  Call_GetCertificateIssuers_593998 = ref object of OpenApiRestCall_593438
proc url_GetCertificateIssuers_594000(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCertificateIssuers_593999(path: JsonNode; query: JsonNode;
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
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  var valid_594002 = query.getOrDefault("maxresults")
  valid_594002 = validateParameter(valid_594002, JInt, required = false, default = nil)
  if valid_594002 != nil:
    section.add "maxresults", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_GetCertificateIssuers_593998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificateIssuers operation returns the set of certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_GetCertificateIssuers_593998; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getCertificateIssuers
  ## The GetCertificateIssuers operation returns the set of certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_594005 = newJObject()
  add(query_594005, "api-version", newJString(apiVersion))
  add(query_594005, "maxresults", newJInt(maxresults))
  result = call_594004.call(nil, query_594005, nil, nil, nil)

var getCertificateIssuers* = Call_GetCertificateIssuers_593998(
    name: "getCertificateIssuers", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/issuers", validator: validate_GetCertificateIssuers_593999,
    base: "", url: url_GetCertificateIssuers_594000, schemes: {Scheme.Https})
type
  Call_SetCertificateIssuer_594029 = ref object of OpenApiRestCall_593438
proc url_SetCertificateIssuer_594031(protocol: Scheme; host: string; base: string;
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

proc validate_SetCertificateIssuer_594030(path: JsonNode; query: JsonNode;
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
  var valid_594032 = path.getOrDefault("issuer-name")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "issuer-name", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
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

proc call*(call_594035: Call_SetCertificateIssuer_594029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The SetCertificateIssuer operation adds or updates the specified certificate issuer. This operation requires the certificates/setissuers permission.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_SetCertificateIssuer_594029; apiVersion: string;
          parameter: JsonNode; issuerName: string): Recallable =
  ## setCertificateIssuer
  ## The SetCertificateIssuer operation adds or updates the specified certificate issuer. This operation requires the certificates/setissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameter: JObject (required)
  ##            : Certificate issuer set parameter.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  var body_594039 = newJObject()
  add(query_594038, "api-version", newJString(apiVersion))
  if parameter != nil:
    body_594039 = parameter
  add(path_594037, "issuer-name", newJString(issuerName))
  result = call_594036.call(path_594037, query_594038, nil, nil, body_594039)

var setCertificateIssuer* = Call_SetCertificateIssuer_594029(
    name: "setCertificateIssuer", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/certificates/issuers/{issuer-name}",
    validator: validate_SetCertificateIssuer_594030, base: "",
    url: url_SetCertificateIssuer_594031, schemes: {Scheme.Https})
type
  Call_GetCertificateIssuer_594006 = ref object of OpenApiRestCall_593438
proc url_GetCertificateIssuer_594008(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificateIssuer_594007(path: JsonNode; query: JsonNode;
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
  var valid_594023 = path.getOrDefault("issuer-name")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "issuer-name", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594025: Call_GetCertificateIssuer_594006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificateIssuer operation returns the specified certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_GetCertificateIssuer_594006; apiVersion: string;
          issuerName: string): Recallable =
  ## getCertificateIssuer
  ## The GetCertificateIssuer operation returns the specified certificate issuer resources in the specified key vault. This operation requires the certificates/manageissuers/getissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "issuer-name", newJString(issuerName))
  result = call_594026.call(path_594027, query_594028, nil, nil, nil)

var getCertificateIssuer* = Call_GetCertificateIssuer_594006(
    name: "getCertificateIssuer", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/issuers/{issuer-name}",
    validator: validate_GetCertificateIssuer_594007, base: "",
    url: url_GetCertificateIssuer_594008, schemes: {Scheme.Https})
type
  Call_UpdateCertificateIssuer_594049 = ref object of OpenApiRestCall_593438
proc url_UpdateCertificateIssuer_594051(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCertificateIssuer_594050(path: JsonNode; query: JsonNode;
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
  var valid_594052 = path.getOrDefault("issuer-name")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "issuer-name", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594053 = query.getOrDefault("api-version")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "api-version", valid_594053
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

proc call*(call_594055: Call_UpdateCertificateIssuer_594049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UpdateCertificateIssuer operation performs an update on the specified certificate issuer entity. This operation requires the certificates/setissuers permission.
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_UpdateCertificateIssuer_594049; apiVersion: string;
          parameter: JsonNode; issuerName: string): Recallable =
  ## updateCertificateIssuer
  ## The UpdateCertificateIssuer operation performs an update on the specified certificate issuer entity. This operation requires the certificates/setissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameter: JObject (required)
  ##            : Certificate issuer update parameter.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  var body_594059 = newJObject()
  add(query_594058, "api-version", newJString(apiVersion))
  if parameter != nil:
    body_594059 = parameter
  add(path_594057, "issuer-name", newJString(issuerName))
  result = call_594056.call(path_594057, query_594058, nil, nil, body_594059)

var updateCertificateIssuer* = Call_UpdateCertificateIssuer_594049(
    name: "updateCertificateIssuer", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/issuers/{issuer-name}",
    validator: validate_UpdateCertificateIssuer_594050, base: "",
    url: url_UpdateCertificateIssuer_594051, schemes: {Scheme.Https})
type
  Call_DeleteCertificateIssuer_594040 = ref object of OpenApiRestCall_593438
proc url_DeleteCertificateIssuer_594042(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteCertificateIssuer_594041(path: JsonNode; query: JsonNode;
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
  var valid_594043 = path.getOrDefault("issuer-name")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "issuer-name", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594044 = query.getOrDefault("api-version")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "api-version", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_DeleteCertificateIssuer_594040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DeleteCertificateIssuer operation permanently removes the specified certificate issuer from the vault. This operation requires the certificates/manageissuers/deleteissuers permission.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_DeleteCertificateIssuer_594040; apiVersion: string;
          issuerName: string): Recallable =
  ## deleteCertificateIssuer
  ## The DeleteCertificateIssuer operation permanently removes the specified certificate issuer from the vault. This operation requires the certificates/manageissuers/deleteissuers permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   issuerName: string (required)
  ##             : The name of the issuer.
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(query_594048, "api-version", newJString(apiVersion))
  add(path_594047, "issuer-name", newJString(issuerName))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var deleteCertificateIssuer* = Call_DeleteCertificateIssuer_594040(
    name: "deleteCertificateIssuer", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/issuers/{issuer-name}",
    validator: validate_DeleteCertificateIssuer_594041, base: "",
    url: url_DeleteCertificateIssuer_594042, schemes: {Scheme.Https})
type
  Call_RestoreCertificate_594060 = ref object of OpenApiRestCall_593438
proc url_RestoreCertificate_594062(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreCertificate_594061(path: JsonNode; query: JsonNode;
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
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
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

proc call*(call_594065: Call_RestoreCertificate_594060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backed up certificate, and all its versions, to a vault. This operation requires the certificates/restore permission.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_RestoreCertificate_594060; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreCertificate
  ## Restores a backed up certificate, and all its versions, to a vault. This operation requires the certificates/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the certificate.
  var query_594067 = newJObject()
  var body_594068 = newJObject()
  add(query_594067, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594068 = parameters
  result = call_594066.call(nil, query_594067, nil, nil, body_594068)

var restoreCertificate* = Call_RestoreCertificate_594060(
    name: "restoreCertificate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/restore", validator: validate_RestoreCertificate_594061,
    base: "", url: url_RestoreCertificate_594062, schemes: {Scheme.Https})
type
  Call_DeleteCertificate_594069 = ref object of OpenApiRestCall_593438
proc url_DeleteCertificate_594071(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteCertificate_594070(path: JsonNode; query: JsonNode;
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
  var valid_594072 = path.getOrDefault("certificate-name")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "certificate-name", valid_594072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594073 = query.getOrDefault("api-version")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "api-version", valid_594073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_DeleteCertificate_594069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all versions of a certificate object along with its associated policy. Delete certificate cannot be used to remove individual versions of a certificate object. This operation requires the certificates/delete permission.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_DeleteCertificate_594069; apiVersion: string;
          certificateName: string): Recallable =
  ## deleteCertificate
  ## Deletes all versions of a certificate object along with its associated policy. Delete certificate cannot be used to remove individual versions of a certificate object. This operation requires the certificates/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "certificate-name", newJString(certificateName))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var deleteCertificate* = Call_DeleteCertificate_594069(name: "deleteCertificate",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/certificates/{certificate-name}",
    validator: validate_DeleteCertificate_594070, base: "",
    url: url_DeleteCertificate_594071, schemes: {Scheme.Https})
type
  Call_BackupCertificate_594078 = ref object of OpenApiRestCall_593438
proc url_BackupCertificate_594080(protocol: Scheme; host: string; base: string;
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

proc validate_BackupCertificate_594079(path: JsonNode; query: JsonNode;
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
  var valid_594081 = path.getOrDefault("certificate-name")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "certificate-name", valid_594081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594082 = query.getOrDefault("api-version")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "api-version", valid_594082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594083: Call_BackupCertificate_594078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified certificate be downloaded to the client. All versions of the certificate will be downloaded. This operation requires the certificates/backup permission.
  ## 
  let valid = call_594083.validator(path, query, header, formData, body)
  let scheme = call_594083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594083.url(scheme.get, call_594083.host, call_594083.base,
                         call_594083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594083, url, valid)

proc call*(call_594084: Call_BackupCertificate_594078; apiVersion: string;
          certificateName: string): Recallable =
  ## backupCertificate
  ## Requests that a backup of the specified certificate be downloaded to the client. All versions of the certificate will be downloaded. This operation requires the certificates/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_594085 = newJObject()
  var query_594086 = newJObject()
  add(query_594086, "api-version", newJString(apiVersion))
  add(path_594085, "certificate-name", newJString(certificateName))
  result = call_594084.call(path_594085, query_594086, nil, nil, nil)

var backupCertificate* = Call_BackupCertificate_594078(name: "backupCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/backup",
    validator: validate_BackupCertificate_594079, base: "",
    url: url_BackupCertificate_594080, schemes: {Scheme.Https})
type
  Call_CreateCertificate_594087 = ref object of OpenApiRestCall_593438
proc url_CreateCertificate_594089(protocol: Scheme; host: string; base: string;
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

proc validate_CreateCertificate_594088(path: JsonNode; query: JsonNode;
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
  var valid_594090 = path.getOrDefault("certificate-name")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "certificate-name", valid_594090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594091 = query.getOrDefault("api-version")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "api-version", valid_594091
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

proc call*(call_594093: Call_CreateCertificate_594087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If this is the first version, the certificate resource is created. This operation requires the certificates/create permission.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_CreateCertificate_594087; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## createCertificate
  ## If this is the first version, the certificate resource is created. This operation requires the certificates/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to create a certificate.
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  var body_594097 = newJObject()
  add(query_594096, "api-version", newJString(apiVersion))
  add(path_594095, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_594097 = parameters
  result = call_594094.call(path_594095, query_594096, nil, nil, body_594097)

var createCertificate* = Call_CreateCertificate_594087(name: "createCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/create",
    validator: validate_CreateCertificate_594088, base: "",
    url: url_CreateCertificate_594089, schemes: {Scheme.Https})
type
  Call_ImportCertificate_594098 = ref object of OpenApiRestCall_593438
proc url_ImportCertificate_594100(protocol: Scheme; host: string; base: string;
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

proc validate_ImportCertificate_594099(path: JsonNode; query: JsonNode;
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
  var valid_594101 = path.getOrDefault("certificate-name")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "certificate-name", valid_594101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594102 = query.getOrDefault("api-version")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "api-version", valid_594102
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

proc call*(call_594104: Call_ImportCertificate_594098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an existing valid certificate, containing a private key, into Azure Key Vault. The certificate to be imported can be in either PFX or PEM format. If the certificate is in PEM format the PEM file must contain the key as well as x509 certificates. This operation requires the certificates/import permission.
  ## 
  let valid = call_594104.validator(path, query, header, formData, body)
  let scheme = call_594104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594104.url(scheme.get, call_594104.host, call_594104.base,
                         call_594104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594104, url, valid)

proc call*(call_594105: Call_ImportCertificate_594098; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## importCertificate
  ## Imports an existing valid certificate, containing a private key, into Azure Key Vault. The certificate to be imported can be in either PFX or PEM format. If the certificate is in PEM format the PEM file must contain the key as well as x509 certificates. This operation requires the certificates/import permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to import the certificate.
  var path_594106 = newJObject()
  var query_594107 = newJObject()
  var body_594108 = newJObject()
  add(query_594107, "api-version", newJString(apiVersion))
  add(path_594106, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_594108 = parameters
  result = call_594105.call(path_594106, query_594107, nil, nil, body_594108)

var importCertificate* = Call_ImportCertificate_594098(name: "importCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/import",
    validator: validate_ImportCertificate_594099, base: "",
    url: url_ImportCertificate_594100, schemes: {Scheme.Https})
type
  Call_GetCertificateOperation_594109 = ref object of OpenApiRestCall_593438
proc url_GetCertificateOperation_594111(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificateOperation_594110(path: JsonNode; query: JsonNode;
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
  var valid_594112 = path.getOrDefault("certificate-name")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "certificate-name", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594114: Call_GetCertificateOperation_594109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the creation operation associated with a specified certificate. This operation requires the certificates/get permission.
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_GetCertificateOperation_594109; apiVersion: string;
          certificateName: string): Recallable =
  ## getCertificateOperation
  ## Gets the creation operation associated with a specified certificate. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  add(query_594117, "api-version", newJString(apiVersion))
  add(path_594116, "certificate-name", newJString(certificateName))
  result = call_594115.call(path_594116, query_594117, nil, nil, nil)

var getCertificateOperation* = Call_GetCertificateOperation_594109(
    name: "getCertificateOperation", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/pending",
    validator: validate_GetCertificateOperation_594110, base: "",
    url: url_GetCertificateOperation_594111, schemes: {Scheme.Https})
type
  Call_UpdateCertificateOperation_594127 = ref object of OpenApiRestCall_593438
proc url_UpdateCertificateOperation_594129(protocol: Scheme; host: string;
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

proc validate_UpdateCertificateOperation_594128(path: JsonNode; query: JsonNode;
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
  var valid_594130 = path.getOrDefault("certificate-name")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "certificate-name", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594131 = query.getOrDefault("api-version")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "api-version", valid_594131
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

proc call*(call_594133: Call_UpdateCertificateOperation_594127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a certificate creation operation that is already in progress. This operation requires the certificates/update permission.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_UpdateCertificateOperation_594127; apiVersion: string;
          certificateName: string; certificateOperation: JsonNode): Recallable =
  ## updateCertificateOperation
  ## Updates a certificate creation operation that is already in progress. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   certificateOperation: JObject (required)
  ##                       : The certificate operation response.
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  var body_594137 = newJObject()
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "certificate-name", newJString(certificateName))
  if certificateOperation != nil:
    body_594137 = certificateOperation
  result = call_594134.call(path_594135, query_594136, nil, nil, body_594137)

var updateCertificateOperation* = Call_UpdateCertificateOperation_594127(
    name: "updateCertificateOperation", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/{certificate-name}/pending",
    validator: validate_UpdateCertificateOperation_594128, base: "",
    url: url_UpdateCertificateOperation_594129, schemes: {Scheme.Https})
type
  Call_DeleteCertificateOperation_594118 = ref object of OpenApiRestCall_593438
proc url_DeleteCertificateOperation_594120(protocol: Scheme; host: string;
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

proc validate_DeleteCertificateOperation_594119(path: JsonNode; query: JsonNode;
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
  var valid_594121 = path.getOrDefault("certificate-name")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "certificate-name", valid_594121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594122 = query.getOrDefault("api-version")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "api-version", valid_594122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594123: Call_DeleteCertificateOperation_594118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the creation operation for a specified certificate that is in the process of being created. The certificate is no longer created. This operation requires the certificates/update permission.
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_DeleteCertificateOperation_594118; apiVersion: string;
          certificateName: string): Recallable =
  ## deleteCertificateOperation
  ## Deletes the creation operation for a specified certificate that is in the process of being created. The certificate is no longer created. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  var path_594125 = newJObject()
  var query_594126 = newJObject()
  add(query_594126, "api-version", newJString(apiVersion))
  add(path_594125, "certificate-name", newJString(certificateName))
  result = call_594124.call(path_594125, query_594126, nil, nil, nil)

var deleteCertificateOperation* = Call_DeleteCertificateOperation_594118(
    name: "deleteCertificateOperation", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/certificates/{certificate-name}/pending",
    validator: validate_DeleteCertificateOperation_594119, base: "",
    url: url_DeleteCertificateOperation_594120, schemes: {Scheme.Https})
type
  Call_MergeCertificate_594138 = ref object of OpenApiRestCall_593438
proc url_MergeCertificate_594140(protocol: Scheme; host: string; base: string;
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

proc validate_MergeCertificate_594139(path: JsonNode; query: JsonNode;
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
  var valid_594141 = path.getOrDefault("certificate-name")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "certificate-name", valid_594141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594142 = query.getOrDefault("api-version")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "api-version", valid_594142
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

proc call*(call_594144: Call_MergeCertificate_594138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The MergeCertificate operation performs the merging of a certificate or certificate chain with a key pair currently available in the service. This operation requires the certificates/create permission.
  ## 
  let valid = call_594144.validator(path, query, header, formData, body)
  let scheme = call_594144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594144.url(scheme.get, call_594144.host, call_594144.base,
                         call_594144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594144, url, valid)

proc call*(call_594145: Call_MergeCertificate_594138; apiVersion: string;
          certificateName: string; parameters: JsonNode): Recallable =
  ## mergeCertificate
  ## The MergeCertificate operation performs the merging of a certificate or certificate chain with a key pair currently available in the service. This operation requires the certificates/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   parameters: JObject (required)
  ##             : The parameters to merge certificate.
  var path_594146 = newJObject()
  var query_594147 = newJObject()
  var body_594148 = newJObject()
  add(query_594147, "api-version", newJString(apiVersion))
  add(path_594146, "certificate-name", newJString(certificateName))
  if parameters != nil:
    body_594148 = parameters
  result = call_594145.call(path_594146, query_594147, nil, nil, body_594148)

var mergeCertificate* = Call_MergeCertificate_594138(name: "mergeCertificate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/certificates/{certificate-name}/pending/merge",
    validator: validate_MergeCertificate_594139, base: "",
    url: url_MergeCertificate_594140, schemes: {Scheme.Https})
type
  Call_GetCertificatePolicy_594149 = ref object of OpenApiRestCall_593438
proc url_GetCertificatePolicy_594151(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificatePolicy_594150(path: JsonNode; query: JsonNode;
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
  var valid_594152 = path.getOrDefault("certificate-name")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "certificate-name", valid_594152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594153 = query.getOrDefault("api-version")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "api-version", valid_594153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594154: Call_GetCertificatePolicy_594149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificatePolicy operation returns the specified certificate policy resources in the specified key vault. This operation requires the certificates/get permission.
  ## 
  let valid = call_594154.validator(path, query, header, formData, body)
  let scheme = call_594154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594154.url(scheme.get, call_594154.host, call_594154.base,
                         call_594154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594154, url, valid)

proc call*(call_594155: Call_GetCertificatePolicy_594149; apiVersion: string;
          certificateName: string): Recallable =
  ## getCertificatePolicy
  ## The GetCertificatePolicy operation returns the specified certificate policy resources in the specified key vault. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in a given key vault.
  var path_594156 = newJObject()
  var query_594157 = newJObject()
  add(query_594157, "api-version", newJString(apiVersion))
  add(path_594156, "certificate-name", newJString(certificateName))
  result = call_594155.call(path_594156, query_594157, nil, nil, nil)

var getCertificatePolicy* = Call_GetCertificatePolicy_594149(
    name: "getCertificatePolicy", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/policy",
    validator: validate_GetCertificatePolicy_594150, base: "",
    url: url_GetCertificatePolicy_594151, schemes: {Scheme.Https})
type
  Call_UpdateCertificatePolicy_594158 = ref object of OpenApiRestCall_593438
proc url_UpdateCertificatePolicy_594160(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCertificatePolicy_594159(path: JsonNode; query: JsonNode;
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
  var valid_594161 = path.getOrDefault("certificate-name")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "certificate-name", valid_594161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594162 = query.getOrDefault("api-version")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "api-version", valid_594162
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

proc call*(call_594164: Call_UpdateCertificatePolicy_594158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set specified members in the certificate policy. Leave others as null. This operation requires the certificates/update permission.
  ## 
  let valid = call_594164.validator(path, query, header, formData, body)
  let scheme = call_594164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594164.url(scheme.get, call_594164.host, call_594164.base,
                         call_594164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594164, url, valid)

proc call*(call_594165: Call_UpdateCertificatePolicy_594158; apiVersion: string;
          certificateName: string; certificatePolicy: JsonNode): Recallable =
  ## updateCertificatePolicy
  ## Set specified members in the certificate policy. Leave others as null. This operation requires the certificates/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault.
  ##   certificatePolicy: JObject (required)
  ##                    : The policy for the certificate.
  var path_594166 = newJObject()
  var query_594167 = newJObject()
  var body_594168 = newJObject()
  add(query_594167, "api-version", newJString(apiVersion))
  add(path_594166, "certificate-name", newJString(certificateName))
  if certificatePolicy != nil:
    body_594168 = certificatePolicy
  result = call_594165.call(path_594166, query_594167, nil, nil, body_594168)

var updateCertificatePolicy* = Call_UpdateCertificatePolicy_594158(
    name: "updateCertificatePolicy", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/certificates/{certificate-name}/policy",
    validator: validate_UpdateCertificatePolicy_594159, base: "",
    url: url_UpdateCertificatePolicy_594160, schemes: {Scheme.Https})
type
  Call_GetCertificateVersions_594169 = ref object of OpenApiRestCall_593438
proc url_GetCertificateVersions_594171(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificateVersions_594170(path: JsonNode; query: JsonNode;
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
  var valid_594172 = path.getOrDefault("certificate-name")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "certificate-name", valid_594172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594173 = query.getOrDefault("api-version")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "api-version", valid_594173
  var valid_594174 = query.getOrDefault("maxresults")
  valid_594174 = validateParameter(valid_594174, JInt, required = false, default = nil)
  if valid_594174 != nil:
    section.add "maxresults", valid_594174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594175: Call_GetCertificateVersions_594169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetCertificateVersions operation returns the versions of a certificate in the specified key vault. This operation requires the certificates/list permission.
  ## 
  let valid = call_594175.validator(path, query, header, formData, body)
  let scheme = call_594175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594175.url(scheme.get, call_594175.host, call_594175.base,
                         call_594175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594175, url, valid)

proc call*(call_594176: Call_GetCertificateVersions_594169; apiVersion: string;
          certificateName: string; maxresults: int = 0): Recallable =
  ## getCertificateVersions
  ## The GetCertificateVersions operation returns the versions of a certificate in the specified key vault. This operation requires the certificates/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var path_594177 = newJObject()
  var query_594178 = newJObject()
  add(query_594178, "api-version", newJString(apiVersion))
  add(path_594177, "certificate-name", newJString(certificateName))
  add(query_594178, "maxresults", newJInt(maxresults))
  result = call_594176.call(path_594177, query_594178, nil, nil, nil)

var getCertificateVersions* = Call_GetCertificateVersions_594169(
    name: "getCertificateVersions", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/versions",
    validator: validate_GetCertificateVersions_594170, base: "",
    url: url_GetCertificateVersions_594171, schemes: {Scheme.Https})
type
  Call_GetCertificate_594179 = ref object of OpenApiRestCall_593438
proc url_GetCertificate_594181(protocol: Scheme; host: string; base: string;
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

proc validate_GetCertificate_594180(path: JsonNode; query: JsonNode;
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
  var valid_594182 = path.getOrDefault("certificate-name")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "certificate-name", valid_594182
  var valid_594183 = path.getOrDefault("certificate-version")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "certificate-version", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594184 = query.getOrDefault("api-version")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "api-version", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_GetCertificate_594179; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific certificate. This operation requires the certificates/get permission.
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_GetCertificate_594179; apiVersion: string;
          certificateName: string; certificateVersion: string): Recallable =
  ## getCertificate
  ## Gets information about a specific certificate. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate in the given vault.
  ##   certificateVersion: string (required)
  ##                     : The version of the certificate.
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(query_594188, "api-version", newJString(apiVersion))
  add(path_594187, "certificate-name", newJString(certificateName))
  add(path_594187, "certificate-version", newJString(certificateVersion))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var getCertificate* = Call_GetCertificate_594179(name: "getCertificate",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificate-name}/{certificate-version}",
    validator: validate_GetCertificate_594180, base: "", url: url_GetCertificate_594181,
    schemes: {Scheme.Https})
type
  Call_UpdateCertificate_594189 = ref object of OpenApiRestCall_593438
proc url_UpdateCertificate_594191(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateCertificate_594190(path: JsonNode; query: JsonNode;
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
  var valid_594192 = path.getOrDefault("certificate-name")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "certificate-name", valid_594192
  var valid_594193 = path.getOrDefault("certificate-version")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "certificate-version", valid_594193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594194 = query.getOrDefault("api-version")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "api-version", valid_594194
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

proc call*(call_594196: Call_UpdateCertificate_594189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UpdateCertificate operation applies the specified update on the given certificate; the only elements updated are the certificate's attributes. This operation requires the certificates/update permission.
  ## 
  let valid = call_594196.validator(path, query, header, formData, body)
  let scheme = call_594196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594196.url(scheme.get, call_594196.host, call_594196.base,
                         call_594196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594196, url, valid)

proc call*(call_594197: Call_UpdateCertificate_594189; apiVersion: string;
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
  var path_594198 = newJObject()
  var query_594199 = newJObject()
  var body_594200 = newJObject()
  add(query_594199, "api-version", newJString(apiVersion))
  add(path_594198, "certificate-name", newJString(certificateName))
  add(path_594198, "certificate-version", newJString(certificateVersion))
  if parameters != nil:
    body_594200 = parameters
  result = call_594197.call(path_594198, query_594199, nil, nil, body_594200)

var updateCertificate* = Call_UpdateCertificate_594189(name: "updateCertificate",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/certificates/{certificate-name}/{certificate-version}",
    validator: validate_UpdateCertificate_594190, base: "",
    url: url_UpdateCertificate_594191, schemes: {Scheme.Https})
type
  Call_GetDeletedCertificates_594201 = ref object of OpenApiRestCall_593438
proc url_GetDeletedCertificates_594203(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedCertificates_594202(path: JsonNode; query: JsonNode;
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
  var valid_594204 = query.getOrDefault("api-version")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "api-version", valid_594204
  var valid_594205 = query.getOrDefault("maxresults")
  valid_594205 = validateParameter(valid_594205, JInt, required = false, default = nil)
  if valid_594205 != nil:
    section.add "maxresults", valid_594205
  var valid_594206 = query.getOrDefault("includePending")
  valid_594206 = validateParameter(valid_594206, JBool, required = false, default = nil)
  if valid_594206 != nil:
    section.add "includePending", valid_594206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594207: Call_GetDeletedCertificates_594201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetDeletedCertificates operation retrieves the certificates in the current vault which are in a deleted state and ready for recovery or purging. This operation includes deletion-specific information. This operation requires the certificates/get/list permission. This operation can only be enabled on soft-delete enabled vaults.
  ## 
  let valid = call_594207.validator(path, query, header, formData, body)
  let scheme = call_594207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594207.url(scheme.get, call_594207.host, call_594207.base,
                         call_594207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594207, url, valid)

proc call*(call_594208: Call_GetDeletedCertificates_594201; apiVersion: string;
          maxresults: int = 0; includePending: bool = false): Recallable =
  ## getDeletedCertificates
  ## The GetDeletedCertificates operation retrieves the certificates in the current vault which are in a deleted state and ready for recovery or purging. This operation includes deletion-specific information. This operation requires the certificates/get/list permission. This operation can only be enabled on soft-delete enabled vaults.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   includePending: bool
  ##                 : Specifies whether to include certificates which are not completely provisioned.
  var query_594209 = newJObject()
  add(query_594209, "api-version", newJString(apiVersion))
  add(query_594209, "maxresults", newJInt(maxresults))
  add(query_594209, "includePending", newJBool(includePending))
  result = call_594208.call(nil, query_594209, nil, nil, nil)

var getDeletedCertificates* = Call_GetDeletedCertificates_594201(
    name: "getDeletedCertificates", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedcertificates", validator: validate_GetDeletedCertificates_594202,
    base: "", url: url_GetDeletedCertificates_594203, schemes: {Scheme.Https})
type
  Call_GetDeletedCertificate_594210 = ref object of OpenApiRestCall_593438
proc url_GetDeletedCertificate_594212(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedCertificate_594211(path: JsonNode; query: JsonNode;
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
  var valid_594213 = path.getOrDefault("certificate-name")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "certificate-name", valid_594213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594214 = query.getOrDefault("api-version")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "api-version", valid_594214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594215: Call_GetDeletedCertificate_594210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetDeletedCertificate operation retrieves the deleted certificate information plus its attributes, such as retention interval, scheduled permanent deletion and the current deletion recovery level. This operation requires the certificates/get permission.
  ## 
  let valid = call_594215.validator(path, query, header, formData, body)
  let scheme = call_594215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594215.url(scheme.get, call_594215.host, call_594215.base,
                         call_594215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594215, url, valid)

proc call*(call_594216: Call_GetDeletedCertificate_594210; apiVersion: string;
          certificateName: string): Recallable =
  ## getDeletedCertificate
  ## The GetDeletedCertificate operation retrieves the deleted certificate information plus its attributes, such as retention interval, scheduled permanent deletion and the current deletion recovery level. This operation requires the certificates/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_594217 = newJObject()
  var query_594218 = newJObject()
  add(query_594218, "api-version", newJString(apiVersion))
  add(path_594217, "certificate-name", newJString(certificateName))
  result = call_594216.call(path_594217, query_594218, nil, nil, nil)

var getDeletedCertificate* = Call_GetDeletedCertificate_594210(
    name: "getDeletedCertificate", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedcertificates/{certificate-name}",
    validator: validate_GetDeletedCertificate_594211, base: "",
    url: url_GetDeletedCertificate_594212, schemes: {Scheme.Https})
type
  Call_PurgeDeletedCertificate_594219 = ref object of OpenApiRestCall_593438
proc url_PurgeDeletedCertificate_594221(protocol: Scheme; host: string; base: string;
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

proc validate_PurgeDeletedCertificate_594220(path: JsonNode; query: JsonNode;
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
  var valid_594222 = path.getOrDefault("certificate-name")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "certificate-name", valid_594222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594223 = query.getOrDefault("api-version")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "api-version", valid_594223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594224: Call_PurgeDeletedCertificate_594219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The PurgeDeletedCertificate operation performs an irreversible deletion of the specified certificate, without possibility for recovery. The operation is not available if the recovery level does not specify 'Purgeable'. This operation requires the certificate/purge permission.
  ## 
  let valid = call_594224.validator(path, query, header, formData, body)
  let scheme = call_594224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594224.url(scheme.get, call_594224.host, call_594224.base,
                         call_594224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594224, url, valid)

proc call*(call_594225: Call_PurgeDeletedCertificate_594219; apiVersion: string;
          certificateName: string): Recallable =
  ## purgeDeletedCertificate
  ## The PurgeDeletedCertificate operation performs an irreversible deletion of the specified certificate, without possibility for recovery. The operation is not available if the recovery level does not specify 'Purgeable'. This operation requires the certificate/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the certificate
  var path_594226 = newJObject()
  var query_594227 = newJObject()
  add(query_594227, "api-version", newJString(apiVersion))
  add(path_594226, "certificate-name", newJString(certificateName))
  result = call_594225.call(path_594226, query_594227, nil, nil, nil)

var purgeDeletedCertificate* = Call_PurgeDeletedCertificate_594219(
    name: "purgeDeletedCertificate", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/deletedcertificates/{certificate-name}",
    validator: validate_PurgeDeletedCertificate_594220, base: "",
    url: url_PurgeDeletedCertificate_594221, schemes: {Scheme.Https})
type
  Call_RecoverDeletedCertificate_594228 = ref object of OpenApiRestCall_593438
proc url_RecoverDeletedCertificate_594230(protocol: Scheme; host: string;
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

proc validate_RecoverDeletedCertificate_594229(path: JsonNode; query: JsonNode;
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
  var valid_594231 = path.getOrDefault("certificate-name")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "certificate-name", valid_594231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594232 = query.getOrDefault("api-version")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "api-version", valid_594232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594233: Call_RecoverDeletedCertificate_594228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The RecoverDeletedCertificate operation performs the reversal of the Delete operation. The operation is applicable in vaults enabled for soft-delete, and must be issued during the retention interval (available in the deleted certificate's attributes). This operation requires the certificates/recover permission.
  ## 
  let valid = call_594233.validator(path, query, header, formData, body)
  let scheme = call_594233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594233.url(scheme.get, call_594233.host, call_594233.base,
                         call_594233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594233, url, valid)

proc call*(call_594234: Call_RecoverDeletedCertificate_594228; apiVersion: string;
          certificateName: string): Recallable =
  ## recoverDeletedCertificate
  ## The RecoverDeletedCertificate operation performs the reversal of the Delete operation. The operation is applicable in vaults enabled for soft-delete, and must be issued during the retention interval (available in the deleted certificate's attributes). This operation requires the certificates/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   certificateName: string (required)
  ##                  : The name of the deleted certificate
  var path_594235 = newJObject()
  var query_594236 = newJObject()
  add(query_594236, "api-version", newJString(apiVersion))
  add(path_594235, "certificate-name", newJString(certificateName))
  result = call_594234.call(path_594235, query_594236, nil, nil, nil)

var recoverDeletedCertificate* = Call_RecoverDeletedCertificate_594228(
    name: "recoverDeletedCertificate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/deletedcertificates/{certificate-name}/recover",
    validator: validate_RecoverDeletedCertificate_594229, base: "",
    url: url_RecoverDeletedCertificate_594230, schemes: {Scheme.Https})
type
  Call_GetDeletedKeys_594237 = ref object of OpenApiRestCall_593438
proc url_GetDeletedKeys_594239(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedKeys_594238(path: JsonNode; query: JsonNode;
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
  var valid_594240 = query.getOrDefault("api-version")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "api-version", valid_594240
  var valid_594241 = query.getOrDefault("maxresults")
  valid_594241 = validateParameter(valid_594241, JInt, required = false, default = nil)
  if valid_594241 != nil:
    section.add "maxresults", valid_594241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594242: Call_GetDeletedKeys_594237; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a deleted key. This operation includes deletion-specific information. The Get Deleted Keys operation is applicable for vaults enabled for soft-delete. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/list permission.
  ## 
  let valid = call_594242.validator(path, query, header, formData, body)
  let scheme = call_594242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594242.url(scheme.get, call_594242.host, call_594242.base,
                         call_594242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594242, url, valid)

proc call*(call_594243: Call_GetDeletedKeys_594237; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedKeys
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a deleted key. This operation includes deletion-specific information. The Get Deleted Keys operation is applicable for vaults enabled for soft-delete. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_594244 = newJObject()
  add(query_594244, "api-version", newJString(apiVersion))
  add(query_594244, "maxresults", newJInt(maxresults))
  result = call_594243.call(nil, query_594244, nil, nil, nil)

var getDeletedKeys* = Call_GetDeletedKeys_594237(name: "getDeletedKeys",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedkeys",
    validator: validate_GetDeletedKeys_594238, base: "", url: url_GetDeletedKeys_594239,
    schemes: {Scheme.Https})
type
  Call_GetDeletedKey_594245 = ref object of OpenApiRestCall_593438
proc url_GetDeletedKey_594247(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedKey_594246(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594248 = path.getOrDefault("key-name")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "key-name", valid_594248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594249 = query.getOrDefault("api-version")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "api-version", valid_594249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594250: Call_GetDeletedKey_594245; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/get permission. 
  ## 
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_GetDeletedKey_594245; apiVersion: string;
          keyName: string): Recallable =
  ## getDeletedKey
  ## The Get Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/get permission. 
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_594252 = newJObject()
  var query_594253 = newJObject()
  add(query_594253, "api-version", newJString(apiVersion))
  add(path_594252, "key-name", newJString(keyName))
  result = call_594251.call(path_594252, query_594253, nil, nil, nil)

var getDeletedKey* = Call_GetDeletedKey_594245(name: "getDeletedKey",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedkeys/{key-name}",
    validator: validate_GetDeletedKey_594246, base: "", url: url_GetDeletedKey_594247,
    schemes: {Scheme.Https})
type
  Call_PurgeDeletedKey_594254 = ref object of OpenApiRestCall_593438
proc url_PurgeDeletedKey_594256(protocol: Scheme; host: string; base: string;
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

proc validate_PurgeDeletedKey_594255(path: JsonNode; query: JsonNode;
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
  var valid_594257 = path.getOrDefault("key-name")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "key-name", valid_594257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594258 = query.getOrDefault("api-version")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "api-version", valid_594258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594259: Call_PurgeDeletedKey_594254; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Purge Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/purge permission.
  ## 
  let valid = call_594259.validator(path, query, header, formData, body)
  let scheme = call_594259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594259.url(scheme.get, call_594259.host, call_594259.base,
                         call_594259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594259, url, valid)

proc call*(call_594260: Call_PurgeDeletedKey_594254; apiVersion: string;
          keyName: string): Recallable =
  ## purgeDeletedKey
  ## The Purge Deleted Key operation is applicable for soft-delete enabled vaults. While the operation can be invoked on any vault, it will return an error if invoked on a non soft-delete enabled vault. This operation requires the keys/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key
  var path_594261 = newJObject()
  var query_594262 = newJObject()
  add(query_594262, "api-version", newJString(apiVersion))
  add(path_594261, "key-name", newJString(keyName))
  result = call_594260.call(path_594261, query_594262, nil, nil, nil)

var purgeDeletedKey* = Call_PurgeDeletedKey_594254(name: "purgeDeletedKey",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/deletedkeys/{key-name}", validator: validate_PurgeDeletedKey_594255,
    base: "", url: url_PurgeDeletedKey_594256, schemes: {Scheme.Https})
type
  Call_RecoverDeletedKey_594263 = ref object of OpenApiRestCall_593438
proc url_RecoverDeletedKey_594265(protocol: Scheme; host: string; base: string;
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

proc validate_RecoverDeletedKey_594264(path: JsonNode; query: JsonNode;
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
  var valid_594266 = path.getOrDefault("key-name")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "key-name", valid_594266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594267 = query.getOrDefault("api-version")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "api-version", valid_594267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594268: Call_RecoverDeletedKey_594263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Recover Deleted Key operation is applicable for deleted keys in soft-delete enabled vaults. It recovers the deleted key back to its latest version under /keys. An attempt to recover an non-deleted key will return an error. Consider this the inverse of the delete operation on soft-delete enabled vaults. This operation requires the keys/recover permission.
  ## 
  let valid = call_594268.validator(path, query, header, formData, body)
  let scheme = call_594268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594268.url(scheme.get, call_594268.host, call_594268.base,
                         call_594268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594268, url, valid)

proc call*(call_594269: Call_RecoverDeletedKey_594263; apiVersion: string;
          keyName: string): Recallable =
  ## recoverDeletedKey
  ## The Recover Deleted Key operation is applicable for deleted keys in soft-delete enabled vaults. It recovers the deleted key back to its latest version under /keys. An attempt to recover an non-deleted key will return an error. Consider this the inverse of the delete operation on soft-delete enabled vaults. This operation requires the keys/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the deleted key.
  var path_594270 = newJObject()
  var query_594271 = newJObject()
  add(query_594271, "api-version", newJString(apiVersion))
  add(path_594270, "key-name", newJString(keyName))
  result = call_594269.call(path_594270, query_594271, nil, nil, nil)

var recoverDeletedKey* = Call_RecoverDeletedKey_594263(name: "recoverDeletedKey",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/deletedkeys/{key-name}/recover",
    validator: validate_RecoverDeletedKey_594264, base: "",
    url: url_RecoverDeletedKey_594265, schemes: {Scheme.Https})
type
  Call_GetDeletedSecrets_594272 = ref object of OpenApiRestCall_593438
proc url_GetDeletedSecrets_594274(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedSecrets_594273(path: JsonNode; query: JsonNode;
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
  var valid_594275 = query.getOrDefault("api-version")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "api-version", valid_594275
  var valid_594276 = query.getOrDefault("maxresults")
  valid_594276 = validateParameter(valid_594276, JInt, required = false, default = nil)
  if valid_594276 != nil:
    section.add "maxresults", valid_594276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594277: Call_GetDeletedSecrets_594272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Secrets operation returns the secrets that have been deleted for a vault enabled for soft-delete. This operation requires the secrets/list permission.
  ## 
  let valid = call_594277.validator(path, query, header, formData, body)
  let scheme = call_594277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594277.url(scheme.get, call_594277.host, call_594277.base,
                         call_594277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594277, url, valid)

proc call*(call_594278: Call_GetDeletedSecrets_594272; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedSecrets
  ## The Get Deleted Secrets operation returns the secrets that have been deleted for a vault enabled for soft-delete. This operation requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_594279 = newJObject()
  add(query_594279, "api-version", newJString(apiVersion))
  add(query_594279, "maxresults", newJInt(maxresults))
  result = call_594278.call(nil, query_594279, nil, nil, nil)

var getDeletedSecrets* = Call_GetDeletedSecrets_594272(name: "getDeletedSecrets",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/deletedsecrets",
    validator: validate_GetDeletedSecrets_594273, base: "",
    url: url_GetDeletedSecrets_594274, schemes: {Scheme.Https})
type
  Call_GetDeletedSecret_594280 = ref object of OpenApiRestCall_593438
proc url_GetDeletedSecret_594282(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedSecret_594281(path: JsonNode; query: JsonNode;
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
  var valid_594283 = path.getOrDefault("secret-name")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "secret-name", valid_594283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594284 = query.getOrDefault("api-version")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "api-version", valid_594284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594285: Call_GetDeletedSecret_594280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Secret operation returns the specified deleted secret along with its attributes. This operation requires the secrets/get permission.
  ## 
  let valid = call_594285.validator(path, query, header, formData, body)
  let scheme = call_594285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594285.url(scheme.get, call_594285.host, call_594285.base,
                         call_594285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594285, url, valid)

proc call*(call_594286: Call_GetDeletedSecret_594280; apiVersion: string;
          secretName: string): Recallable =
  ## getDeletedSecret
  ## The Get Deleted Secret operation returns the specified deleted secret along with its attributes. This operation requires the secrets/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_594287 = newJObject()
  var query_594288 = newJObject()
  add(query_594288, "api-version", newJString(apiVersion))
  add(path_594287, "secret-name", newJString(secretName))
  result = call_594286.call(path_594287, query_594288, nil, nil, nil)

var getDeletedSecret* = Call_GetDeletedSecret_594280(name: "getDeletedSecret",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedsecrets/{secret-name}", validator: validate_GetDeletedSecret_594281,
    base: "", url: url_GetDeletedSecret_594282, schemes: {Scheme.Https})
type
  Call_PurgeDeletedSecret_594289 = ref object of OpenApiRestCall_593438
proc url_PurgeDeletedSecret_594291(protocol: Scheme; host: string; base: string;
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

proc validate_PurgeDeletedSecret_594290(path: JsonNode; query: JsonNode;
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
  var valid_594292 = path.getOrDefault("secret-name")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "secret-name", valid_594292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594293 = query.getOrDefault("api-version")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "api-version", valid_594293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594294: Call_PurgeDeletedSecret_594289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The purge deleted secret operation removes the secret permanently, without the possibility of recovery. This operation can only be enabled on a soft-delete enabled vault. This operation requires the secrets/purge permission.
  ## 
  let valid = call_594294.validator(path, query, header, formData, body)
  let scheme = call_594294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594294.url(scheme.get, call_594294.host, call_594294.base,
                         call_594294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594294, url, valid)

proc call*(call_594295: Call_PurgeDeletedSecret_594289; apiVersion: string;
          secretName: string): Recallable =
  ## purgeDeletedSecret
  ## The purge deleted secret operation removes the secret permanently, without the possibility of recovery. This operation can only be enabled on a soft-delete enabled vault. This operation requires the secrets/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_594296 = newJObject()
  var query_594297 = newJObject()
  add(query_594297, "api-version", newJString(apiVersion))
  add(path_594296, "secret-name", newJString(secretName))
  result = call_594295.call(path_594296, query_594297, nil, nil, nil)

var purgeDeletedSecret* = Call_PurgeDeletedSecret_594289(
    name: "purgeDeletedSecret", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/deletedsecrets/{secret-name}",
    validator: validate_PurgeDeletedSecret_594290, base: "",
    url: url_PurgeDeletedSecret_594291, schemes: {Scheme.Https})
type
  Call_RecoverDeletedSecret_594298 = ref object of OpenApiRestCall_593438
proc url_RecoverDeletedSecret_594300(protocol: Scheme; host: string; base: string;
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

proc validate_RecoverDeletedSecret_594299(path: JsonNode; query: JsonNode;
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
  var valid_594301 = path.getOrDefault("secret-name")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "secret-name", valid_594301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594302 = query.getOrDefault("api-version")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "api-version", valid_594302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594303: Call_RecoverDeletedSecret_594298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recovers the deleted secret in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the secrets/recover permission.
  ## 
  let valid = call_594303.validator(path, query, header, formData, body)
  let scheme = call_594303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594303.url(scheme.get, call_594303.host, call_594303.base,
                         call_594303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594303, url, valid)

proc call*(call_594304: Call_RecoverDeletedSecret_594298; apiVersion: string;
          secretName: string): Recallable =
  ## recoverDeletedSecret
  ## Recovers the deleted secret in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the secrets/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the deleted secret.
  var path_594305 = newJObject()
  var query_594306 = newJObject()
  add(query_594306, "api-version", newJString(apiVersion))
  add(path_594305, "secret-name", newJString(secretName))
  result = call_594304.call(path_594305, query_594306, nil, nil, nil)

var recoverDeletedSecret* = Call_RecoverDeletedSecret_594298(
    name: "recoverDeletedSecret", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/deletedsecrets/{secret-name}/recover",
    validator: validate_RecoverDeletedSecret_594299, base: "",
    url: url_RecoverDeletedSecret_594300, schemes: {Scheme.Https})
type
  Call_GetDeletedStorageAccounts_594307 = ref object of OpenApiRestCall_593438
proc url_GetDeletedStorageAccounts_594309(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDeletedStorageAccounts_594308(path: JsonNode; query: JsonNode;
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
  var valid_594310 = query.getOrDefault("api-version")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "api-version", valid_594310
  var valid_594311 = query.getOrDefault("maxresults")
  valid_594311 = validateParameter(valid_594311, JInt, required = false, default = nil)
  if valid_594311 != nil:
    section.add "maxresults", valid_594311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594312: Call_GetDeletedStorageAccounts_594307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Storage Accounts operation returns the storage accounts that have been deleted for a vault enabled for soft-delete. This operation requires the storage/list permission.
  ## 
  let valid = call_594312.validator(path, query, header, formData, body)
  let scheme = call_594312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594312.url(scheme.get, call_594312.host, call_594312.base,
                         call_594312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594312, url, valid)

proc call*(call_594313: Call_GetDeletedStorageAccounts_594307; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getDeletedStorageAccounts
  ## The Get Deleted Storage Accounts operation returns the storage accounts that have been deleted for a vault enabled for soft-delete. This operation requires the storage/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_594314 = newJObject()
  add(query_594314, "api-version", newJString(apiVersion))
  add(query_594314, "maxresults", newJInt(maxresults))
  result = call_594313.call(nil, query_594314, nil, nil, nil)

var getDeletedStorageAccounts* = Call_GetDeletedStorageAccounts_594307(
    name: "getDeletedStorageAccounts", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/deletedstorage",
    validator: validate_GetDeletedStorageAccounts_594308, base: "",
    url: url_GetDeletedStorageAccounts_594309, schemes: {Scheme.Https})
type
  Call_GetDeletedStorageAccount_594315 = ref object of OpenApiRestCall_593438
proc url_GetDeletedStorageAccount_594317(protocol: Scheme; host: string;
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

proc validate_GetDeletedStorageAccount_594316(path: JsonNode; query: JsonNode;
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
  var valid_594318 = path.getOrDefault("storage-account-name")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "storage-account-name", valid_594318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594319 = query.getOrDefault("api-version")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "api-version", valid_594319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594320: Call_GetDeletedStorageAccount_594315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Storage Account operation returns the specified deleted storage account along with its attributes. This operation requires the storage/get permission.
  ## 
  let valid = call_594320.validator(path, query, header, formData, body)
  let scheme = call_594320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594320.url(scheme.get, call_594320.host, call_594320.base,
                         call_594320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594320, url, valid)

proc call*(call_594321: Call_GetDeletedStorageAccount_594315; apiVersion: string;
          storageAccountName: string): Recallable =
  ## getDeletedStorageAccount
  ## The Get Deleted Storage Account operation returns the specified deleted storage account along with its attributes. This operation requires the storage/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_594322 = newJObject()
  var query_594323 = newJObject()
  add(query_594323, "api-version", newJString(apiVersion))
  add(path_594322, "storage-account-name", newJString(storageAccountName))
  result = call_594321.call(path_594322, query_594323, nil, nil, nil)

var getDeletedStorageAccount* = Call_GetDeletedStorageAccount_594315(
    name: "getDeletedStorageAccount", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedstorage/{storage-account-name}",
    validator: validate_GetDeletedStorageAccount_594316, base: "",
    url: url_GetDeletedStorageAccount_594317, schemes: {Scheme.Https})
type
  Call_PurgeDeletedStorageAccount_594324 = ref object of OpenApiRestCall_593438
proc url_PurgeDeletedStorageAccount_594326(protocol: Scheme; host: string;
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

proc validate_PurgeDeletedStorageAccount_594325(path: JsonNode; query: JsonNode;
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
  var valid_594327 = path.getOrDefault("storage-account-name")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "storage-account-name", valid_594327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594328 = query.getOrDefault("api-version")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "api-version", valid_594328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594329: Call_PurgeDeletedStorageAccount_594324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The purge deleted storage account operation removes the secret permanently, without the possibility of recovery. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/purge permission.
  ## 
  let valid = call_594329.validator(path, query, header, formData, body)
  let scheme = call_594329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594329.url(scheme.get, call_594329.host, call_594329.base,
                         call_594329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594329, url, valid)

proc call*(call_594330: Call_PurgeDeletedStorageAccount_594324; apiVersion: string;
          storageAccountName: string): Recallable =
  ## purgeDeletedStorageAccount
  ## The purge deleted storage account operation removes the secret permanently, without the possibility of recovery. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/purge permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_594331 = newJObject()
  var query_594332 = newJObject()
  add(query_594332, "api-version", newJString(apiVersion))
  add(path_594331, "storage-account-name", newJString(storageAccountName))
  result = call_594330.call(path_594331, query_594332, nil, nil, nil)

var purgeDeletedStorageAccount* = Call_PurgeDeletedStorageAccount_594324(
    name: "purgeDeletedStorageAccount", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/deletedstorage/{storage-account-name}",
    validator: validate_PurgeDeletedStorageAccount_594325, base: "",
    url: url_PurgeDeletedStorageAccount_594326, schemes: {Scheme.Https})
type
  Call_RecoverDeletedStorageAccount_594333 = ref object of OpenApiRestCall_593438
proc url_RecoverDeletedStorageAccount_594335(protocol: Scheme; host: string;
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

proc validate_RecoverDeletedStorageAccount_594334(path: JsonNode; query: JsonNode;
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
  var valid_594336 = path.getOrDefault("storage-account-name")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "storage-account-name", valid_594336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594337 = query.getOrDefault("api-version")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "api-version", valid_594337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594338: Call_RecoverDeletedStorageAccount_594333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recovers the deleted storage account in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ## 
  let valid = call_594338.validator(path, query, header, formData, body)
  let scheme = call_594338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594338.url(scheme.get, call_594338.host, call_594338.base,
                         call_594338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594338, url, valid)

proc call*(call_594339: Call_RecoverDeletedStorageAccount_594333;
          apiVersion: string; storageAccountName: string): Recallable =
  ## recoverDeletedStorageAccount
  ## Recovers the deleted storage account in the specified vault. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_594340 = newJObject()
  var query_594341 = newJObject()
  add(query_594341, "api-version", newJString(apiVersion))
  add(path_594340, "storage-account-name", newJString(storageAccountName))
  result = call_594339.call(path_594340, query_594341, nil, nil, nil)

var recoverDeletedStorageAccount* = Call_RecoverDeletedStorageAccount_594333(
    name: "recoverDeletedStorageAccount", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/deletedstorage/{storage-account-name}/recover",
    validator: validate_RecoverDeletedStorageAccount_594334, base: "",
    url: url_RecoverDeletedStorageAccount_594335, schemes: {Scheme.Https})
type
  Call_GetDeletedSasDefinitions_594342 = ref object of OpenApiRestCall_593438
proc url_GetDeletedSasDefinitions_594344(protocol: Scheme; host: string;
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

proc validate_GetDeletedSasDefinitions_594343(path: JsonNode; query: JsonNode;
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
  var valid_594345 = path.getOrDefault("storage-account-name")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "storage-account-name", valid_594345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594346 = query.getOrDefault("api-version")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "api-version", valid_594346
  var valid_594347 = query.getOrDefault("maxresults")
  valid_594347 = validateParameter(valid_594347, JInt, required = false, default = nil)
  if valid_594347 != nil:
    section.add "maxresults", valid_594347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594348: Call_GetDeletedSasDefinitions_594342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted Sas Definitions operation returns the SAS definitions that have been deleted for a vault enabled for soft-delete. This operation requires the storage/listsas permission.
  ## 
  let valid = call_594348.validator(path, query, header, formData, body)
  let scheme = call_594348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594348.url(scheme.get, call_594348.host, call_594348.base,
                         call_594348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594348, url, valid)

proc call*(call_594349: Call_GetDeletedSasDefinitions_594342; apiVersion: string;
          storageAccountName: string; maxresults: int = 0): Recallable =
  ## getDeletedSasDefinitions
  ## The Get Deleted Sas Definitions operation returns the SAS definitions that have been deleted for a vault enabled for soft-delete. This operation requires the storage/listsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_594350 = newJObject()
  var query_594351 = newJObject()
  add(query_594351, "api-version", newJString(apiVersion))
  add(query_594351, "maxresults", newJInt(maxresults))
  add(path_594350, "storage-account-name", newJString(storageAccountName))
  result = call_594349.call(path_594350, query_594351, nil, nil, nil)

var getDeletedSasDefinitions* = Call_GetDeletedSasDefinitions_594342(
    name: "getDeletedSasDefinitions", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedstorage/{storage-account-name}/sas",
    validator: validate_GetDeletedSasDefinitions_594343, base: "",
    url: url_GetDeletedSasDefinitions_594344, schemes: {Scheme.Https})
type
  Call_GetDeletedSasDefinition_594352 = ref object of OpenApiRestCall_593438
proc url_GetDeletedSasDefinition_594354(protocol: Scheme; host: string; base: string;
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

proc validate_GetDeletedSasDefinition_594353(path: JsonNode; query: JsonNode;
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
  var valid_594355 = path.getOrDefault("storage-account-name")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "storage-account-name", valid_594355
  var valid_594356 = path.getOrDefault("sas-definition-name")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "sas-definition-name", valid_594356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594357 = query.getOrDefault("api-version")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "api-version", valid_594357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594358: Call_GetDeletedSasDefinition_594352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Deleted SAS Definition operation returns the specified deleted SAS definition along with its attributes. This operation requires the storage/getsas permission.
  ## 
  let valid = call_594358.validator(path, query, header, formData, body)
  let scheme = call_594358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594358.url(scheme.get, call_594358.host, call_594358.base,
                         call_594358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594358, url, valid)

proc call*(call_594359: Call_GetDeletedSasDefinition_594352; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## getDeletedSasDefinition
  ## The Get Deleted SAS Definition operation returns the specified deleted SAS definition along with its attributes. This operation requires the storage/getsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_594360 = newJObject()
  var query_594361 = newJObject()
  add(query_594361, "api-version", newJString(apiVersion))
  add(path_594360, "storage-account-name", newJString(storageAccountName))
  add(path_594360, "sas-definition-name", newJString(sasDefinitionName))
  result = call_594359.call(path_594360, query_594361, nil, nil, nil)

var getDeletedSasDefinition* = Call_GetDeletedSasDefinition_594352(
    name: "getDeletedSasDefinition", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/deletedstorage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_GetDeletedSasDefinition_594353, base: "",
    url: url_GetDeletedSasDefinition_594354, schemes: {Scheme.Https})
type
  Call_RecoverDeletedSasDefinition_594362 = ref object of OpenApiRestCall_593438
proc url_RecoverDeletedSasDefinition_594364(protocol: Scheme; host: string;
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

proc validate_RecoverDeletedSasDefinition_594363(path: JsonNode; query: JsonNode;
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
  var valid_594365 = path.getOrDefault("storage-account-name")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "storage-account-name", valid_594365
  var valid_594366 = path.getOrDefault("sas-definition-name")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "sas-definition-name", valid_594366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594367 = query.getOrDefault("api-version")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "api-version", valid_594367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594368: Call_RecoverDeletedSasDefinition_594362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recovers the deleted SAS definition for the specified storage account. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ## 
  let valid = call_594368.validator(path, query, header, formData, body)
  let scheme = call_594368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594368.url(scheme.get, call_594368.host, call_594368.base,
                         call_594368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594368, url, valid)

proc call*(call_594369: Call_RecoverDeletedSasDefinition_594362;
          apiVersion: string; storageAccountName: string; sasDefinitionName: string): Recallable =
  ## recoverDeletedSasDefinition
  ## Recovers the deleted SAS definition for the specified storage account. This operation can only be performed on a soft-delete enabled vault. This operation requires the storage/recover permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_594370 = newJObject()
  var query_594371 = newJObject()
  add(query_594371, "api-version", newJString(apiVersion))
  add(path_594370, "storage-account-name", newJString(storageAccountName))
  add(path_594370, "sas-definition-name", newJString(sasDefinitionName))
  result = call_594369.call(path_594370, query_594371, nil, nil, nil)

var recoverDeletedSasDefinition* = Call_RecoverDeletedSasDefinition_594362(
    name: "recoverDeletedSasDefinition", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/deletedstorage/{storage-account-name}/sas/{sas-definition-name}/recover",
    validator: validate_RecoverDeletedSasDefinition_594363, base: "",
    url: url_RecoverDeletedSasDefinition_594364, schemes: {Scheme.Https})
type
  Call_GetKeys_594372 = ref object of OpenApiRestCall_593438
proc url_GetKeys_594374(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetKeys_594373(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594375 = query.getOrDefault("api-version")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "api-version", valid_594375
  var valid_594376 = query.getOrDefault("maxresults")
  valid_594376 = validateParameter(valid_594376, JInt, required = false, default = nil)
  if valid_594376 != nil:
    section.add "maxresults", valid_594376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594377: Call_GetKeys_594372; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a stored key. The LIST operation is applicable to all key types, however only the base key identifier, attributes, and tags are provided in the response. Individual versions of a key are not listed in the response. This operation requires the keys/list permission.
  ## 
  let valid = call_594377.validator(path, query, header, formData, body)
  let scheme = call_594377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594377.url(scheme.get, call_594377.host, call_594377.base,
                         call_594377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594377, url, valid)

proc call*(call_594378: Call_GetKeys_594372; apiVersion: string; maxresults: int = 0): Recallable =
  ## getKeys
  ## Retrieves a list of the keys in the Key Vault as JSON Web Key structures that contain the public part of a stored key. The LIST operation is applicable to all key types, however only the base key identifier, attributes, and tags are provided in the response. Individual versions of a key are not listed in the response. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_594379 = newJObject()
  add(query_594379, "api-version", newJString(apiVersion))
  add(query_594379, "maxresults", newJInt(maxresults))
  result = call_594378.call(nil, query_594379, nil, nil, nil)

var getKeys* = Call_GetKeys_594372(name: "getKeys", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/keys",
                                validator: validate_GetKeys_594373, base: "",
                                url: url_GetKeys_594374, schemes: {Scheme.Https})
type
  Call_RestoreKey_594380 = ref object of OpenApiRestCall_593438
proc url_RestoreKey_594382(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreKey_594381(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594383 = query.getOrDefault("api-version")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "api-version", valid_594383
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

proc call*(call_594385: Call_RestoreKey_594380; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a previously backed up key into Azure Key Vault, restoring the key, its key identifier, attributes and access control policies. The RESTORE operation may be used to import a previously backed up key. Individual versions of a key cannot be restored. The key is restored in its entirety with the same key name as it had when it was backed up. If the key name is not available in the target Key Vault, the RESTORE operation will be rejected. While the key name is retained during restore, the final key identifier will change if the key is restored to a different vault. Restore will restore all versions and preserve version identifiers. The RESTORE operation is subject to security constraints: The target Key Vault must be owned by the same Microsoft Azure Subscription as the source Key Vault The user must have RESTORE permission in the target Key Vault. This operation requires the keys/restore permission.
  ## 
  let valid = call_594385.validator(path, query, header, formData, body)
  let scheme = call_594385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594385.url(scheme.get, call_594385.host, call_594385.base,
                         call_594385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594385, url, valid)

proc call*(call_594386: Call_RestoreKey_594380; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreKey
  ## Imports a previously backed up key into Azure Key Vault, restoring the key, its key identifier, attributes and access control policies. The RESTORE operation may be used to import a previously backed up key. Individual versions of a key cannot be restored. The key is restored in its entirety with the same key name as it had when it was backed up. If the key name is not available in the target Key Vault, the RESTORE operation will be rejected. While the key name is retained during restore, the final key identifier will change if the key is restored to a different vault. Restore will restore all versions and preserve version identifiers. The RESTORE operation is subject to security constraints: The target Key Vault must be owned by the same Microsoft Azure Subscription as the source Key Vault The user must have RESTORE permission in the target Key Vault. This operation requires the keys/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the key.
  var query_594387 = newJObject()
  var body_594388 = newJObject()
  add(query_594387, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594388 = parameters
  result = call_594386.call(nil, query_594387, nil, nil, body_594388)

var restoreKey* = Call_RestoreKey_594380(name: "restoreKey",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/keys/restore",
                                      validator: validate_RestoreKey_594381,
                                      base: "", url: url_RestoreKey_594382,
                                      schemes: {Scheme.Https})
type
  Call_ImportKey_594389 = ref object of OpenApiRestCall_593438
proc url_ImportKey_594391(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImportKey_594390(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594392 = path.getOrDefault("key-name")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "key-name", valid_594392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594393 = query.getOrDefault("api-version")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "api-version", valid_594393
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

proc call*(call_594395: Call_ImportKey_594389; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The import key operation may be used to import any key type into an Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. This operation requires the keys/import permission.
  ## 
  let valid = call_594395.validator(path, query, header, formData, body)
  let scheme = call_594395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594395.url(scheme.get, call_594395.host, call_594395.base,
                         call_594395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594395, url, valid)

proc call*(call_594396: Call_ImportKey_594389; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## importKey
  ## The import key operation may be used to import any key type into an Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. This operation requires the keys/import permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to import a key.
  ##   keyName: string (required)
  ##          : Name for the imported key.
  var path_594397 = newJObject()
  var query_594398 = newJObject()
  var body_594399 = newJObject()
  add(query_594398, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594399 = parameters
  add(path_594397, "key-name", newJString(keyName))
  result = call_594396.call(path_594397, query_594398, nil, nil, body_594399)

var importKey* = Call_ImportKey_594389(name: "importKey", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_ImportKey_594390,
                                    base: "", url: url_ImportKey_594391,
                                    schemes: {Scheme.Https})
type
  Call_DeleteKey_594400 = ref object of OpenApiRestCall_593438
proc url_DeleteKey_594402(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DeleteKey_594401(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594403 = path.getOrDefault("key-name")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "key-name", valid_594403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594404 = query.getOrDefault("api-version")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "api-version", valid_594404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594405: Call_DeleteKey_594400; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The delete key operation cannot be used to remove individual versions of a key. This operation removes the cryptographic material associated with the key, which means the key is not usable for Sign/Verify, Wrap/Unwrap or Encrypt/Decrypt operations. This operation requires the keys/delete permission.
  ## 
  let valid = call_594405.validator(path, query, header, formData, body)
  let scheme = call_594405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594405.url(scheme.get, call_594405.host, call_594405.base,
                         call_594405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594405, url, valid)

proc call*(call_594406: Call_DeleteKey_594400; apiVersion: string; keyName: string): Recallable =
  ## deleteKey
  ## The delete key operation cannot be used to remove individual versions of a key. This operation removes the cryptographic material associated with the key, which means the key is not usable for Sign/Verify, Wrap/Unwrap or Encrypt/Decrypt operations. This operation requires the keys/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key to delete.
  var path_594407 = newJObject()
  var query_594408 = newJObject()
  add(query_594408, "api-version", newJString(apiVersion))
  add(path_594407, "key-name", newJString(keyName))
  result = call_594406.call(path_594407, query_594408, nil, nil, nil)

var deleteKey* = Call_DeleteKey_594400(name: "deleteKey",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local",
                                    route: "/keys/{key-name}",
                                    validator: validate_DeleteKey_594401,
                                    base: "", url: url_DeleteKey_594402,
                                    schemes: {Scheme.Https})
type
  Call_BackupKey_594409 = ref object of OpenApiRestCall_593438
proc url_BackupKey_594411(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_BackupKey_594410(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594412 = path.getOrDefault("key-name")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "key-name", valid_594412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594413 = query.getOrDefault("api-version")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "api-version", valid_594413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594414: Call_BackupKey_594409; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Key Backup operation exports a key from Azure Key Vault in a protected form. Note that this operation does NOT return key material in a form that can be used outside the Azure Key Vault system, the returned key material is either protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of this operation is to allow a client to GENERATE a key in one Azure Key Vault instance, BACKUP the key, and then RESTORE it into another Azure Key Vault instance. The BACKUP operation may be used to export, in protected form, any key type from Azure Key Vault. Individual versions of a key cannot be backed up. BACKUP / RESTORE can be performed within geographical boundaries only; meaning that a BACKUP from one geographical area cannot be restored to another geographical area. For example, a backup from the US geographical area cannot be restored in an EU geographical area. This operation requires the key/backup permission.
  ## 
  let valid = call_594414.validator(path, query, header, formData, body)
  let scheme = call_594414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594414.url(scheme.get, call_594414.host, call_594414.base,
                         call_594414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594414, url, valid)

proc call*(call_594415: Call_BackupKey_594409; apiVersion: string; keyName: string): Recallable =
  ## backupKey
  ## The Key Backup operation exports a key from Azure Key Vault in a protected form. Note that this operation does NOT return key material in a form that can be used outside the Azure Key Vault system, the returned key material is either protected to a Azure Key Vault HSM or to Azure Key Vault itself. The intent of this operation is to allow a client to GENERATE a key in one Azure Key Vault instance, BACKUP the key, and then RESTORE it into another Azure Key Vault instance. The BACKUP operation may be used to export, in protected form, any key type from Azure Key Vault. Individual versions of a key cannot be backed up. BACKUP / RESTORE can be performed within geographical boundaries only; meaning that a BACKUP from one geographical area cannot be restored to another geographical area. For example, a backup from the US geographical area cannot be restored in an EU geographical area. This operation requires the key/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_594416 = newJObject()
  var query_594417 = newJObject()
  add(query_594417, "api-version", newJString(apiVersion))
  add(path_594416, "key-name", newJString(keyName))
  result = call_594415.call(path_594416, query_594417, nil, nil, nil)

var backupKey* = Call_BackupKey_594409(name: "backupKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/backup",
                                    validator: validate_BackupKey_594410,
                                    base: "", url: url_BackupKey_594411,
                                    schemes: {Scheme.Https})
type
  Call_CreateKey_594418 = ref object of OpenApiRestCall_593438
proc url_CreateKey_594420(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CreateKey_594419(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594431 = path.getOrDefault("key-name")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "key-name", valid_594431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594432 = query.getOrDefault("api-version")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "api-version", valid_594432
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

proc call*(call_594434: Call_CreateKey_594418; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The create key operation can be used to create any key type in Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. It requires the keys/create permission.
  ## 
  let valid = call_594434.validator(path, query, header, formData, body)
  let scheme = call_594434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594434.url(scheme.get, call_594434.host, call_594434.base,
                         call_594434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594434, url, valid)

proc call*(call_594435: Call_CreateKey_594418; apiVersion: string;
          parameters: JsonNode; keyName: string): Recallable =
  ## createKey
  ## The create key operation can be used to create any key type in Azure Key Vault. If the named key already exists, Azure Key Vault creates a new version of the key. It requires the keys/create permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to create a key.
  ##   keyName: string (required)
  ##          : The name for the new key. The system will generate the version name for the new key.
  var path_594436 = newJObject()
  var query_594437 = newJObject()
  var body_594438 = newJObject()
  add(query_594437, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594438 = parameters
  add(path_594436, "key-name", newJString(keyName))
  result = call_594435.call(path_594436, query_594437, nil, nil, body_594438)

var createKey* = Call_CreateKey_594418(name: "createKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/create",
                                    validator: validate_CreateKey_594419,
                                    base: "", url: url_CreateKey_594420,
                                    schemes: {Scheme.Https})
type
  Call_GetKeyVersions_594439 = ref object of OpenApiRestCall_593438
proc url_GetKeyVersions_594441(protocol: Scheme; host: string; base: string;
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

proc validate_GetKeyVersions_594440(path: JsonNode; query: JsonNode;
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
  var valid_594442 = path.getOrDefault("key-name")
  valid_594442 = validateParameter(valid_594442, JString, required = true,
                                 default = nil)
  if valid_594442 != nil:
    section.add "key-name", valid_594442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594443 = query.getOrDefault("api-version")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "api-version", valid_594443
  var valid_594444 = query.getOrDefault("maxresults")
  valid_594444 = validateParameter(valid_594444, JInt, required = false, default = nil)
  if valid_594444 != nil:
    section.add "maxresults", valid_594444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594445: Call_GetKeyVersions_594439; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The full key identifier, attributes, and tags are provided in the response. This operation requires the keys/list permission.
  ## 
  let valid = call_594445.validator(path, query, header, formData, body)
  let scheme = call_594445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594445.url(scheme.get, call_594445.host, call_594445.base,
                         call_594445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594445, url, valid)

proc call*(call_594446: Call_GetKeyVersions_594439; apiVersion: string;
          keyName: string; maxresults: int = 0): Recallable =
  ## getKeyVersions
  ## The full key identifier, attributes, and tags are provided in the response. This operation requires the keys/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   keyName: string (required)
  ##          : The name of the key.
  var path_594447 = newJObject()
  var query_594448 = newJObject()
  add(query_594448, "api-version", newJString(apiVersion))
  add(query_594448, "maxresults", newJInt(maxresults))
  add(path_594447, "key-name", newJString(keyName))
  result = call_594446.call(path_594447, query_594448, nil, nil, nil)

var getKeyVersions* = Call_GetKeyVersions_594439(name: "getKeyVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/keys/{key-name}/versions", validator: validate_GetKeyVersions_594440,
    base: "", url: url_GetKeyVersions_594441, schemes: {Scheme.Https})
type
  Call_GetKey_594449 = ref object of OpenApiRestCall_593438
proc url_GetKey_594451(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetKey_594450(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594452 = path.getOrDefault("key-version")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "key-version", valid_594452
  var valid_594453 = path.getOrDefault("key-name")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "key-name", valid_594453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594454 = query.getOrDefault("api-version")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "api-version", valid_594454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594455: Call_GetKey_594449; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The get key operation is applicable to all key types. If the requested key is symmetric, then no key material is released in the response. This operation requires the keys/get permission.
  ## 
  let valid = call_594455.validator(path, query, header, formData, body)
  let scheme = call_594455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594455.url(scheme.get, call_594455.host, call_594455.base,
                         call_594455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594455, url, valid)

proc call*(call_594456: Call_GetKey_594449; apiVersion: string; keyVersion: string;
          keyName: string): Recallable =
  ## getKey
  ## The get key operation is applicable to all key types. If the requested key is symmetric, then no key material is released in the response. This operation requires the keys/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   keyVersion: string (required)
  ##             : Adding the version parameter retrieves a specific version of a key.
  ##   keyName: string (required)
  ##          : The name of the key to get.
  var path_594457 = newJObject()
  var query_594458 = newJObject()
  add(query_594458, "api-version", newJString(apiVersion))
  add(path_594457, "key-version", newJString(keyVersion))
  add(path_594457, "key-name", newJString(keyName))
  result = call_594456.call(path_594457, query_594458, nil, nil, nil)

var getKey* = Call_GetKey_594449(name: "getKey", meth: HttpMethod.HttpGet,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}",
                              validator: validate_GetKey_594450, base: "",
                              url: url_GetKey_594451, schemes: {Scheme.Https})
type
  Call_UpdateKey_594459 = ref object of OpenApiRestCall_593438
proc url_UpdateKey_594461(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UpdateKey_594460(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594462 = path.getOrDefault("key-version")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "key-version", valid_594462
  var valid_594463 = path.getOrDefault("key-name")
  valid_594463 = validateParameter(valid_594463, JString, required = true,
                                 default = nil)
  if valid_594463 != nil:
    section.add "key-name", valid_594463
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594464 = query.getOrDefault("api-version")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "api-version", valid_594464
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

proc call*(call_594466: Call_UpdateKey_594459; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## In order to perform this operation, the key must already exist in the Key Vault. Note: The cryptographic material of a key itself cannot be changed. This operation requires the keys/update permission.
  ## 
  let valid = call_594466.validator(path, query, header, formData, body)
  let scheme = call_594466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594466.url(scheme.get, call_594466.host, call_594466.base,
                         call_594466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594466, url, valid)

proc call*(call_594467: Call_UpdateKey_594459; apiVersion: string;
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
  var path_594468 = newJObject()
  var query_594469 = newJObject()
  var body_594470 = newJObject()
  add(query_594469, "api-version", newJString(apiVersion))
  add(path_594468, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_594470 = parameters
  add(path_594468, "key-name", newJString(keyName))
  result = call_594467.call(path_594468, query_594469, nil, nil, body_594470)

var updateKey* = Call_UpdateKey_594459(name: "updateKey", meth: HttpMethod.HttpPatch,
                                    host: "azure.local",
                                    route: "/keys/{key-name}/{key-version}",
                                    validator: validate_UpdateKey_594460,
                                    base: "", url: url_UpdateKey_594461,
                                    schemes: {Scheme.Https})
type
  Call_Decrypt_594471 = ref object of OpenApiRestCall_593438
proc url_Decrypt_594473(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Decrypt_594472(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594474 = path.getOrDefault("key-version")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "key-version", valid_594474
  var valid_594475 = path.getOrDefault("key-name")
  valid_594475 = validateParameter(valid_594475, JString, required = true,
                                 default = nil)
  if valid_594475 != nil:
    section.add "key-name", valid_594475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594476 = query.getOrDefault("api-version")
  valid_594476 = validateParameter(valid_594476, JString, required = true,
                                 default = nil)
  if valid_594476 != nil:
    section.add "api-version", valid_594476
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

proc call*(call_594478: Call_Decrypt_594471; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DECRYPT operation decrypts a well-formed block of ciphertext using the target encryption key and specified algorithm. This operation is the reverse of the ENCRYPT operation; only a single block of data may be decrypted, the size of this block is dependent on the target key and the algorithm to be used. The DECRYPT operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/decrypt permission.
  ## 
  let valid = call_594478.validator(path, query, header, formData, body)
  let scheme = call_594478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594478.url(scheme.get, call_594478.host, call_594478.base,
                         call_594478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594478, url, valid)

proc call*(call_594479: Call_Decrypt_594471; apiVersion: string; keyVersion: string;
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
  var path_594480 = newJObject()
  var query_594481 = newJObject()
  var body_594482 = newJObject()
  add(query_594481, "api-version", newJString(apiVersion))
  add(path_594480, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_594482 = parameters
  add(path_594480, "key-name", newJString(keyName))
  result = call_594479.call(path_594480, query_594481, nil, nil, body_594482)

var decrypt* = Call_Decrypt_594471(name: "decrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/decrypt",
                                validator: validate_Decrypt_594472, base: "",
                                url: url_Decrypt_594473, schemes: {Scheme.Https})
type
  Call_Encrypt_594483 = ref object of OpenApiRestCall_593438
proc url_Encrypt_594485(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Encrypt_594484(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594486 = path.getOrDefault("key-version")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "key-version", valid_594486
  var valid_594487 = path.getOrDefault("key-name")
  valid_594487 = validateParameter(valid_594487, JString, required = true,
                                 default = nil)
  if valid_594487 != nil:
    section.add "key-name", valid_594487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594488 = query.getOrDefault("api-version")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "api-version", valid_594488
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

proc call*(call_594490: Call_Encrypt_594483; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The ENCRYPT operation encrypts an arbitrary sequence of bytes using an encryption key that is stored in Azure Key Vault. Note that the ENCRYPT operation only supports a single block of data, the size of which is dependent on the target key and the encryption algorithm to be used. The ENCRYPT operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/encrypt permission.
  ## 
  let valid = call_594490.validator(path, query, header, formData, body)
  let scheme = call_594490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594490.url(scheme.get, call_594490.host, call_594490.base,
                         call_594490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594490, url, valid)

proc call*(call_594491: Call_Encrypt_594483; apiVersion: string; keyVersion: string;
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
  var path_594492 = newJObject()
  var query_594493 = newJObject()
  var body_594494 = newJObject()
  add(query_594493, "api-version", newJString(apiVersion))
  add(path_594492, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_594494 = parameters
  add(path_594492, "key-name", newJString(keyName))
  result = call_594491.call(path_594492, query_594493, nil, nil, body_594494)

var encrypt* = Call_Encrypt_594483(name: "encrypt", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/encrypt",
                                validator: validate_Encrypt_594484, base: "",
                                url: url_Encrypt_594485, schemes: {Scheme.Https})
type
  Call_Sign_594495 = ref object of OpenApiRestCall_593438
proc url_Sign_594497(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Sign_594496(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594498 = path.getOrDefault("key-version")
  valid_594498 = validateParameter(valid_594498, JString, required = true,
                                 default = nil)
  if valid_594498 != nil:
    section.add "key-version", valid_594498
  var valid_594499 = path.getOrDefault("key-name")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "key-name", valid_594499
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594500 = query.getOrDefault("api-version")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "api-version", valid_594500
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

proc call*(call_594502: Call_Sign_594495; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The SIGN operation is applicable to asymmetric and symmetric keys stored in Azure Key Vault since this operation uses the private portion of the key. This operation requires the keys/sign permission.
  ## 
  let valid = call_594502.validator(path, query, header, formData, body)
  let scheme = call_594502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594502.url(scheme.get, call_594502.host, call_594502.base,
                         call_594502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594502, url, valid)

proc call*(call_594503: Call_Sign_594495; apiVersion: string; keyVersion: string;
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
  var path_594504 = newJObject()
  var query_594505 = newJObject()
  var body_594506 = newJObject()
  add(query_594505, "api-version", newJString(apiVersion))
  add(path_594504, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_594506 = parameters
  add(path_594504, "key-name", newJString(keyName))
  result = call_594503.call(path_594504, query_594505, nil, nil, body_594506)

var sign* = Call_Sign_594495(name: "sign", meth: HttpMethod.HttpPost,
                          host: "azure.local",
                          route: "/keys/{key-name}/{key-version}/sign",
                          validator: validate_Sign_594496, base: "", url: url_Sign_594497,
                          schemes: {Scheme.Https})
type
  Call_UnwrapKey_594507 = ref object of OpenApiRestCall_593438
proc url_UnwrapKey_594509(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UnwrapKey_594508(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594510 = path.getOrDefault("key-version")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "key-version", valid_594510
  var valid_594511 = path.getOrDefault("key-name")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "key-name", valid_594511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594512 = query.getOrDefault("api-version")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "api-version", valid_594512
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

proc call*(call_594514: Call_UnwrapKey_594507; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UNWRAP operation supports decryption of a symmetric key using the target key encryption key. This operation is the reverse of the WRAP operation. The UNWRAP operation applies to asymmetric and symmetric keys stored in Azure Key Vault since it uses the private portion of the key. This operation requires the keys/unwrapKey permission.
  ## 
  let valid = call_594514.validator(path, query, header, formData, body)
  let scheme = call_594514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594514.url(scheme.get, call_594514.host, call_594514.base,
                         call_594514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594514, url, valid)

proc call*(call_594515: Call_UnwrapKey_594507; apiVersion: string;
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
  var path_594516 = newJObject()
  var query_594517 = newJObject()
  var body_594518 = newJObject()
  add(query_594517, "api-version", newJString(apiVersion))
  add(path_594516, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_594518 = parameters
  add(path_594516, "key-name", newJString(keyName))
  result = call_594515.call(path_594516, query_594517, nil, nil, body_594518)

var unwrapKey* = Call_UnwrapKey_594507(name: "unwrapKey", meth: HttpMethod.HttpPost,
                                    host: "azure.local", route: "/keys/{key-name}/{key-version}/unwrapkey",
                                    validator: validate_UnwrapKey_594508,
                                    base: "", url: url_UnwrapKey_594509,
                                    schemes: {Scheme.Https})
type
  Call_Verify_594519 = ref object of OpenApiRestCall_593438
proc url_Verify_594521(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_Verify_594520(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594522 = path.getOrDefault("key-version")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "key-version", valid_594522
  var valid_594523 = path.getOrDefault("key-name")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "key-name", valid_594523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594524 = query.getOrDefault("api-version")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "api-version", valid_594524
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

proc call*(call_594526: Call_Verify_594519; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The VERIFY operation is applicable to symmetric keys stored in Azure Key Vault. VERIFY is not strictly necessary for asymmetric keys stored in Azure Key Vault since signature verification can be performed using the public portion of the key but this operation is supported as a convenience for callers that only have a key-reference and not the public portion of the key. This operation requires the keys/verify permission.
  ## 
  let valid = call_594526.validator(path, query, header, formData, body)
  let scheme = call_594526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594526.url(scheme.get, call_594526.host, call_594526.base,
                         call_594526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594526, url, valid)

proc call*(call_594527: Call_Verify_594519; apiVersion: string; keyVersion: string;
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
  var path_594528 = newJObject()
  var query_594529 = newJObject()
  var body_594530 = newJObject()
  add(query_594529, "api-version", newJString(apiVersion))
  add(path_594528, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_594530 = parameters
  add(path_594528, "key-name", newJString(keyName))
  result = call_594527.call(path_594528, query_594529, nil, nil, body_594530)

var verify* = Call_Verify_594519(name: "verify", meth: HttpMethod.HttpPost,
                              host: "azure.local",
                              route: "/keys/{key-name}/{key-version}/verify",
                              validator: validate_Verify_594520, base: "",
                              url: url_Verify_594521, schemes: {Scheme.Https})
type
  Call_WrapKey_594531 = ref object of OpenApiRestCall_593438
proc url_WrapKey_594533(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_WrapKey_594532(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594534 = path.getOrDefault("key-version")
  valid_594534 = validateParameter(valid_594534, JString, required = true,
                                 default = nil)
  if valid_594534 != nil:
    section.add "key-version", valid_594534
  var valid_594535 = path.getOrDefault("key-name")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "key-name", valid_594535
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594536 = query.getOrDefault("api-version")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "api-version", valid_594536
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

proc call*(call_594538: Call_WrapKey_594531; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The WRAP operation supports encryption of a symmetric key using a key encryption key that has previously been stored in an Azure Key Vault. The WRAP operation is only strictly necessary for symmetric keys stored in Azure Key Vault since protection with an asymmetric key can be performed using the public portion of the key. This operation is supported for asymmetric keys as a convenience for callers that have a key-reference but do not have access to the public key material. This operation requires the keys/wrapKey permission.
  ## 
  let valid = call_594538.validator(path, query, header, formData, body)
  let scheme = call_594538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594538.url(scheme.get, call_594538.host, call_594538.base,
                         call_594538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594538, url, valid)

proc call*(call_594539: Call_WrapKey_594531; apiVersion: string; keyVersion: string;
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
  var path_594540 = newJObject()
  var query_594541 = newJObject()
  var body_594542 = newJObject()
  add(query_594541, "api-version", newJString(apiVersion))
  add(path_594540, "key-version", newJString(keyVersion))
  if parameters != nil:
    body_594542 = parameters
  add(path_594540, "key-name", newJString(keyName))
  result = call_594539.call(path_594540, query_594541, nil, nil, body_594542)

var wrapKey* = Call_WrapKey_594531(name: "wrapKey", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/keys/{key-name}/{key-version}/wrapkey",
                                validator: validate_WrapKey_594532, base: "",
                                url: url_WrapKey_594533, schemes: {Scheme.Https})
type
  Call_GetSecrets_594543 = ref object of OpenApiRestCall_593438
proc url_GetSecrets_594545(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetSecrets_594544(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594546 = query.getOrDefault("api-version")
  valid_594546 = validateParameter(valid_594546, JString, required = true,
                                 default = nil)
  if valid_594546 != nil:
    section.add "api-version", valid_594546
  var valid_594547 = query.getOrDefault("maxresults")
  valid_594547 = validateParameter(valid_594547, JInt, required = false, default = nil)
  if valid_594547 != nil:
    section.add "maxresults", valid_594547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594548: Call_GetSecrets_594543; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Secrets operation is applicable to the entire vault. However, only the base secret identifier and its attributes are provided in the response. Individual secret versions are not listed in the response. This operation requires the secrets/list permission.
  ## 
  let valid = call_594548.validator(path, query, header, formData, body)
  let scheme = call_594548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594548.url(scheme.get, call_594548.host, call_594548.base,
                         call_594548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594548, url, valid)

proc call*(call_594549: Call_GetSecrets_594543; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getSecrets
  ## The Get Secrets operation is applicable to the entire vault. However, only the base secret identifier and its attributes are provided in the response. Individual secret versions are not listed in the response. This operation requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  var query_594550 = newJObject()
  add(query_594550, "api-version", newJString(apiVersion))
  add(query_594550, "maxresults", newJInt(maxresults))
  result = call_594549.call(nil, query_594550, nil, nil, nil)

var getSecrets* = Call_GetSecrets_594543(name: "getSecrets",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/secrets",
                                      validator: validate_GetSecrets_594544,
                                      base: "", url: url_GetSecrets_594545,
                                      schemes: {Scheme.Https})
type
  Call_RestoreSecret_594551 = ref object of OpenApiRestCall_593438
proc url_RestoreSecret_594553(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreSecret_594552(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594554 = query.getOrDefault("api-version")
  valid_594554 = validateParameter(valid_594554, JString, required = true,
                                 default = nil)
  if valid_594554 != nil:
    section.add "api-version", valid_594554
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

proc call*(call_594556: Call_RestoreSecret_594551; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backed up secret, and all its versions, to a vault. This operation requires the secrets/restore permission.
  ## 
  let valid = call_594556.validator(path, query, header, formData, body)
  let scheme = call_594556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594556.url(scheme.get, call_594556.host, call_594556.base,
                         call_594556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594556, url, valid)

proc call*(call_594557: Call_RestoreSecret_594551; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreSecret
  ## Restores a backed up secret, and all its versions, to a vault. This operation requires the secrets/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the secret.
  var query_594558 = newJObject()
  var body_594559 = newJObject()
  add(query_594558, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594559 = parameters
  result = call_594557.call(nil, query_594558, nil, nil, body_594559)

var restoreSecret* = Call_RestoreSecret_594551(name: "restoreSecret",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/secrets/restore",
    validator: validate_RestoreSecret_594552, base: "", url: url_RestoreSecret_594553,
    schemes: {Scheme.Https})
type
  Call_SetSecret_594560 = ref object of OpenApiRestCall_593438
proc url_SetSecret_594562(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SetSecret_594561(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594563 = path.getOrDefault("secret-name")
  valid_594563 = validateParameter(valid_594563, JString, required = true,
                                 default = nil)
  if valid_594563 != nil:
    section.add "secret-name", valid_594563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594564 = query.getOrDefault("api-version")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "api-version", valid_594564
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

proc call*(call_594566: Call_SetSecret_594560; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ##  The SET operation adds a secret to the Azure Key Vault. If the named secret already exists, Azure Key Vault creates a new version of that secret. This operation requires the secrets/set permission.
  ## 
  let valid = call_594566.validator(path, query, header, formData, body)
  let scheme = call_594566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594566.url(scheme.get, call_594566.host, call_594566.base,
                         call_594566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594566, url, valid)

proc call*(call_594567: Call_SetSecret_594560; apiVersion: string;
          secretName: string; parameters: JsonNode): Recallable =
  ## setSecret
  ##  The SET operation adds a secret to the Azure Key Vault. If the named secret already exists, Azure Key Vault creates a new version of that secret. This operation requires the secrets/set permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  ##   parameters: JObject (required)
  ##             : The parameters for setting the secret.
  var path_594568 = newJObject()
  var query_594569 = newJObject()
  var body_594570 = newJObject()
  add(query_594569, "api-version", newJString(apiVersion))
  add(path_594568, "secret-name", newJString(secretName))
  if parameters != nil:
    body_594570 = parameters
  result = call_594567.call(path_594568, query_594569, nil, nil, body_594570)

var setSecret* = Call_SetSecret_594560(name: "setSecret", meth: HttpMethod.HttpPut,
                                    host: "azure.local",
                                    route: "/secrets/{secret-name}",
                                    validator: validate_SetSecret_594561,
                                    base: "", url: url_SetSecret_594562,
                                    schemes: {Scheme.Https})
type
  Call_DeleteSecret_594571 = ref object of OpenApiRestCall_593438
proc url_DeleteSecret_594573(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteSecret_594572(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594574 = path.getOrDefault("secret-name")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "secret-name", valid_594574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594575 = query.getOrDefault("api-version")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "api-version", valid_594575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594576: Call_DeleteSecret_594571; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The DELETE operation applies to any secret stored in Azure Key Vault. DELETE cannot be applied to an individual version of a secret. This operation requires the secrets/delete permission.
  ## 
  let valid = call_594576.validator(path, query, header, formData, body)
  let scheme = call_594576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594576.url(scheme.get, call_594576.host, call_594576.base,
                         call_594576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594576, url, valid)

proc call*(call_594577: Call_DeleteSecret_594571; apiVersion: string;
          secretName: string): Recallable =
  ## deleteSecret
  ## The DELETE operation applies to any secret stored in Azure Key Vault. DELETE cannot be applied to an individual version of a secret. This operation requires the secrets/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_594578 = newJObject()
  var query_594579 = newJObject()
  add(query_594579, "api-version", newJString(apiVersion))
  add(path_594578, "secret-name", newJString(secretName))
  result = call_594577.call(path_594578, query_594579, nil, nil, nil)

var deleteSecret* = Call_DeleteSecret_594571(name: "deleteSecret",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/secrets/{secret-name}", validator: validate_DeleteSecret_594572,
    base: "", url: url_DeleteSecret_594573, schemes: {Scheme.Https})
type
  Call_BackupSecret_594580 = ref object of OpenApiRestCall_593438
proc url_BackupSecret_594582(protocol: Scheme; host: string; base: string;
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

proc validate_BackupSecret_594581(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594583 = path.getOrDefault("secret-name")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "secret-name", valid_594583
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594584 = query.getOrDefault("api-version")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "api-version", valid_594584
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594585: Call_BackupSecret_594580; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified secret be downloaded to the client. All versions of the secret will be downloaded. This operation requires the secrets/backup permission.
  ## 
  let valid = call_594585.validator(path, query, header, formData, body)
  let scheme = call_594585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594585.url(scheme.get, call_594585.host, call_594585.base,
                         call_594585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594585, url, valid)

proc call*(call_594586: Call_BackupSecret_594580; apiVersion: string;
          secretName: string): Recallable =
  ## backupSecret
  ## Requests that a backup of the specified secret be downloaded to the client. All versions of the secret will be downloaded. This operation requires the secrets/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_594587 = newJObject()
  var query_594588 = newJObject()
  add(query_594588, "api-version", newJString(apiVersion))
  add(path_594587, "secret-name", newJString(secretName))
  result = call_594586.call(path_594587, query_594588, nil, nil, nil)

var backupSecret* = Call_BackupSecret_594580(name: "backupSecret",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/secrets/{secret-name}/backup", validator: validate_BackupSecret_594581,
    base: "", url: url_BackupSecret_594582, schemes: {Scheme.Https})
type
  Call_GetSecretVersions_594589 = ref object of OpenApiRestCall_593438
proc url_GetSecretVersions_594591(protocol: Scheme; host: string; base: string;
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

proc validate_GetSecretVersions_594590(path: JsonNode; query: JsonNode;
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
  var valid_594592 = path.getOrDefault("secret-name")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = nil)
  if valid_594592 != nil:
    section.add "secret-name", valid_594592
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594593 = query.getOrDefault("api-version")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "api-version", valid_594593
  var valid_594594 = query.getOrDefault("maxresults")
  valid_594594 = validateParameter(valid_594594, JInt, required = false, default = nil)
  if valid_594594 != nil:
    section.add "maxresults", valid_594594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594595: Call_GetSecretVersions_594589; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The full secret identifier and attributes are provided in the response. No values are returned for the secrets. This operations requires the secrets/list permission.
  ## 
  let valid = call_594595.validator(path, query, header, formData, body)
  let scheme = call_594595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594595.url(scheme.get, call_594595.host, call_594595.base,
                         call_594595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594595, url, valid)

proc call*(call_594596: Call_GetSecretVersions_594589; apiVersion: string;
          secretName: string; maxresults: int = 0): Recallable =
  ## getSecretVersions
  ## The full secret identifier and attributes are provided in the response. No values are returned for the secrets. This operations requires the secrets/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified, the service will return up to 25 results.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_594597 = newJObject()
  var query_594598 = newJObject()
  add(query_594598, "api-version", newJString(apiVersion))
  add(query_594598, "maxresults", newJInt(maxresults))
  add(path_594597, "secret-name", newJString(secretName))
  result = call_594596.call(path_594597, query_594598, nil, nil, nil)

var getSecretVersions* = Call_GetSecretVersions_594589(name: "getSecretVersions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/secrets/{secret-name}/versions",
    validator: validate_GetSecretVersions_594590, base: "",
    url: url_GetSecretVersions_594591, schemes: {Scheme.Https})
type
  Call_GetSecret_594599 = ref object of OpenApiRestCall_593438
proc url_GetSecret_594601(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetSecret_594600(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594602 = path.getOrDefault("secret-version")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = nil)
  if valid_594602 != nil:
    section.add "secret-version", valid_594602
  var valid_594603 = path.getOrDefault("secret-name")
  valid_594603 = validateParameter(valid_594603, JString, required = true,
                                 default = nil)
  if valid_594603 != nil:
    section.add "secret-name", valid_594603
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594604 = query.getOrDefault("api-version")
  valid_594604 = validateParameter(valid_594604, JString, required = true,
                                 default = nil)
  if valid_594604 != nil:
    section.add "api-version", valid_594604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594605: Call_GetSecret_594599; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GET operation is applicable to any secret stored in Azure Key Vault. This operation requires the secrets/get permission.
  ## 
  let valid = call_594605.validator(path, query, header, formData, body)
  let scheme = call_594605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594605.url(scheme.get, call_594605.host, call_594605.base,
                         call_594605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594605, url, valid)

proc call*(call_594606: Call_GetSecret_594599; apiVersion: string;
          secretVersion: string; secretName: string): Recallable =
  ## getSecret
  ## The GET operation is applicable to any secret stored in Azure Key Vault. This operation requires the secrets/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   secretVersion: string (required)
  ##                : The version of the secret.
  ##   secretName: string (required)
  ##             : The name of the secret.
  var path_594607 = newJObject()
  var query_594608 = newJObject()
  add(query_594608, "api-version", newJString(apiVersion))
  add(path_594607, "secret-version", newJString(secretVersion))
  add(path_594607, "secret-name", newJString(secretName))
  result = call_594606.call(path_594607, query_594608, nil, nil, nil)

var getSecret* = Call_GetSecret_594599(name: "getSecret", meth: HttpMethod.HttpGet,
                                    host: "azure.local", route: "/secrets/{secret-name}/{secret-version}",
                                    validator: validate_GetSecret_594600,
                                    base: "", url: url_GetSecret_594601,
                                    schemes: {Scheme.Https})
type
  Call_UpdateSecret_594609 = ref object of OpenApiRestCall_593438
proc url_UpdateSecret_594611(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateSecret_594610(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594612 = path.getOrDefault("secret-version")
  valid_594612 = validateParameter(valid_594612, JString, required = true,
                                 default = nil)
  if valid_594612 != nil:
    section.add "secret-version", valid_594612
  var valid_594613 = path.getOrDefault("secret-name")
  valid_594613 = validateParameter(valid_594613, JString, required = true,
                                 default = nil)
  if valid_594613 != nil:
    section.add "secret-name", valid_594613
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594614 = query.getOrDefault("api-version")
  valid_594614 = validateParameter(valid_594614, JString, required = true,
                                 default = nil)
  if valid_594614 != nil:
    section.add "api-version", valid_594614
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

proc call*(call_594616: Call_UpdateSecret_594609; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The UPDATE operation changes specified attributes of an existing stored secret. Attributes that are not specified in the request are left unchanged. The value of a secret itself cannot be changed. This operation requires the secrets/set permission.
  ## 
  let valid = call_594616.validator(path, query, header, formData, body)
  let scheme = call_594616.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594616.url(scheme.get, call_594616.host, call_594616.base,
                         call_594616.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594616, url, valid)

proc call*(call_594617: Call_UpdateSecret_594609; apiVersion: string;
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
  var path_594618 = newJObject()
  var query_594619 = newJObject()
  var body_594620 = newJObject()
  add(query_594619, "api-version", newJString(apiVersion))
  add(path_594618, "secret-version", newJString(secretVersion))
  add(path_594618, "secret-name", newJString(secretName))
  if parameters != nil:
    body_594620 = parameters
  result = call_594617.call(path_594618, query_594619, nil, nil, body_594620)

var updateSecret* = Call_UpdateSecret_594609(name: "updateSecret",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/secrets/{secret-name}/{secret-version}",
    validator: validate_UpdateSecret_594610, base: "", url: url_UpdateSecret_594611,
    schemes: {Scheme.Https})
type
  Call_GetStorageAccounts_594621 = ref object of OpenApiRestCall_593438
proc url_GetStorageAccounts_594623(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetStorageAccounts_594622(path: JsonNode; query: JsonNode;
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
  var valid_594624 = query.getOrDefault("api-version")
  valid_594624 = validateParameter(valid_594624, JString, required = true,
                                 default = nil)
  if valid_594624 != nil:
    section.add "api-version", valid_594624
  var valid_594625 = query.getOrDefault("maxresults")
  valid_594625 = validateParameter(valid_594625, JInt, required = false, default = nil)
  if valid_594625 != nil:
    section.add "maxresults", valid_594625
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594626: Call_GetStorageAccounts_594621; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List storage accounts managed by the specified key vault. This operation requires the storage/list permission.
  ## 
  let valid = call_594626.validator(path, query, header, formData, body)
  let scheme = call_594626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594626.url(scheme.get, call_594626.host, call_594626.base,
                         call_594626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594626, url, valid)

proc call*(call_594627: Call_GetStorageAccounts_594621; apiVersion: string;
          maxresults: int = 0): Recallable =
  ## getStorageAccounts
  ## List storage accounts managed by the specified key vault. This operation requires the storage/list permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  var query_594628 = newJObject()
  add(query_594628, "api-version", newJString(apiVersion))
  add(query_594628, "maxresults", newJInt(maxresults))
  result = call_594627.call(nil, query_594628, nil, nil, nil)

var getStorageAccounts* = Call_GetStorageAccounts_594621(
    name: "getStorageAccounts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage", validator: validate_GetStorageAccounts_594622, base: "",
    url: url_GetStorageAccounts_594623, schemes: {Scheme.Https})
type
  Call_RestoreStorageAccount_594629 = ref object of OpenApiRestCall_593438
proc url_RestoreStorageAccount_594631(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RestoreStorageAccount_594630(path: JsonNode; query: JsonNode;
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
  var valid_594632 = query.getOrDefault("api-version")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = nil)
  if valid_594632 != nil:
    section.add "api-version", valid_594632
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

proc call*(call_594634: Call_RestoreStorageAccount_594629; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backed up storage account to a vault. This operation requires the storage/restore permission.
  ## 
  let valid = call_594634.validator(path, query, header, formData, body)
  let scheme = call_594634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594634.url(scheme.get, call_594634.host, call_594634.base,
                         call_594634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594634, url, valid)

proc call*(call_594635: Call_RestoreStorageAccount_594629; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## restoreStorageAccount
  ## Restores a backed up storage account to a vault. This operation requires the storage/restore permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   parameters: JObject (required)
  ##             : The parameters to restore the storage account.
  var query_594636 = newJObject()
  var body_594637 = newJObject()
  add(query_594636, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594637 = parameters
  result = call_594635.call(nil, query_594636, nil, nil, body_594637)

var restoreStorageAccount* = Call_RestoreStorageAccount_594629(
    name: "restoreStorageAccount", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/storage/restore", validator: validate_RestoreStorageAccount_594630,
    base: "", url: url_RestoreStorageAccount_594631, schemes: {Scheme.Https})
type
  Call_SetStorageAccount_594647 = ref object of OpenApiRestCall_593438
proc url_SetStorageAccount_594649(protocol: Scheme; host: string; base: string;
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

proc validate_SetStorageAccount_594648(path: JsonNode; query: JsonNode;
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
  var valid_594650 = path.getOrDefault("storage-account-name")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "storage-account-name", valid_594650
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594651 = query.getOrDefault("api-version")
  valid_594651 = validateParameter(valid_594651, JString, required = true,
                                 default = nil)
  if valid_594651 != nil:
    section.add "api-version", valid_594651
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

proc call*(call_594653: Call_SetStorageAccount_594647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new storage account. This operation requires the storage/set permission.
  ## 
  let valid = call_594653.validator(path, query, header, formData, body)
  let scheme = call_594653.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594653.url(scheme.get, call_594653.host, call_594653.base,
                         call_594653.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594653, url, valid)

proc call*(call_594654: Call_SetStorageAccount_594647; apiVersion: string;
          storageAccountName: string; parameters: JsonNode): Recallable =
  ## setStorageAccount
  ## Creates or updates a new storage account. This operation requires the storage/set permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to create a storage account.
  var path_594655 = newJObject()
  var query_594656 = newJObject()
  var body_594657 = newJObject()
  add(query_594656, "api-version", newJString(apiVersion))
  add(path_594655, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_594657 = parameters
  result = call_594654.call(path_594655, query_594656, nil, nil, body_594657)

var setStorageAccount* = Call_SetStorageAccount_594647(name: "setStorageAccount",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_SetStorageAccount_594648, base: "",
    url: url_SetStorageAccount_594649, schemes: {Scheme.Https})
type
  Call_GetStorageAccount_594638 = ref object of OpenApiRestCall_593438
proc url_GetStorageAccount_594640(protocol: Scheme; host: string; base: string;
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

proc validate_GetStorageAccount_594639(path: JsonNode; query: JsonNode;
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
  var valid_594641 = path.getOrDefault("storage-account-name")
  valid_594641 = validateParameter(valid_594641, JString, required = true,
                                 default = nil)
  if valid_594641 != nil:
    section.add "storage-account-name", valid_594641
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594642 = query.getOrDefault("api-version")
  valid_594642 = validateParameter(valid_594642, JString, required = true,
                                 default = nil)
  if valid_594642 != nil:
    section.add "api-version", valid_594642
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594643: Call_GetStorageAccount_594638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specified storage account. This operation requires the storage/get permission.
  ## 
  let valid = call_594643.validator(path, query, header, formData, body)
  let scheme = call_594643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594643.url(scheme.get, call_594643.host, call_594643.base,
                         call_594643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594643, url, valid)

proc call*(call_594644: Call_GetStorageAccount_594638; apiVersion: string;
          storageAccountName: string): Recallable =
  ## getStorageAccount
  ## Gets information about a specified storage account. This operation requires the storage/get permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_594645 = newJObject()
  var query_594646 = newJObject()
  add(query_594646, "api-version", newJString(apiVersion))
  add(path_594645, "storage-account-name", newJString(storageAccountName))
  result = call_594644.call(path_594645, query_594646, nil, nil, nil)

var getStorageAccount* = Call_GetStorageAccount_594638(name: "getStorageAccount",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_GetStorageAccount_594639, base: "",
    url: url_GetStorageAccount_594640, schemes: {Scheme.Https})
type
  Call_UpdateStorageAccount_594667 = ref object of OpenApiRestCall_593438
proc url_UpdateStorageAccount_594669(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateStorageAccount_594668(path: JsonNode; query: JsonNode;
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
  var valid_594670 = path.getOrDefault("storage-account-name")
  valid_594670 = validateParameter(valid_594670, JString, required = true,
                                 default = nil)
  if valid_594670 != nil:
    section.add "storage-account-name", valid_594670
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594671 = query.getOrDefault("api-version")
  valid_594671 = validateParameter(valid_594671, JString, required = true,
                                 default = nil)
  if valid_594671 != nil:
    section.add "api-version", valid_594671
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

proc call*(call_594673: Call_UpdateStorageAccount_594667; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified attributes associated with the given storage account. This operation requires the storage/set/update permission.
  ## 
  let valid = call_594673.validator(path, query, header, formData, body)
  let scheme = call_594673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594673.url(scheme.get, call_594673.host, call_594673.base,
                         call_594673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594673, url, valid)

proc call*(call_594674: Call_UpdateStorageAccount_594667; apiVersion: string;
          storageAccountName: string; parameters: JsonNode): Recallable =
  ## updateStorageAccount
  ## Updates the specified attributes associated with the given storage account. This operation requires the storage/set/update permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to update a storage account.
  var path_594675 = newJObject()
  var query_594676 = newJObject()
  var body_594677 = newJObject()
  add(query_594676, "api-version", newJString(apiVersion))
  add(path_594675, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_594677 = parameters
  result = call_594674.call(path_594675, query_594676, nil, nil, body_594677)

var updateStorageAccount* = Call_UpdateStorageAccount_594667(
    name: "updateStorageAccount", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_UpdateStorageAccount_594668, base: "",
    url: url_UpdateStorageAccount_594669, schemes: {Scheme.Https})
type
  Call_DeleteStorageAccount_594658 = ref object of OpenApiRestCall_593438
proc url_DeleteStorageAccount_594660(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteStorageAccount_594659(path: JsonNode; query: JsonNode;
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
  var valid_594661 = path.getOrDefault("storage-account-name")
  valid_594661 = validateParameter(valid_594661, JString, required = true,
                                 default = nil)
  if valid_594661 != nil:
    section.add "storage-account-name", valid_594661
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594662 = query.getOrDefault("api-version")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = nil)
  if valid_594662 != nil:
    section.add "api-version", valid_594662
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594663: Call_DeleteStorageAccount_594658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a storage account. This operation requires the storage/delete permission.
  ## 
  let valid = call_594663.validator(path, query, header, formData, body)
  let scheme = call_594663.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594663.url(scheme.get, call_594663.host, call_594663.base,
                         call_594663.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594663, url, valid)

proc call*(call_594664: Call_DeleteStorageAccount_594658; apiVersion: string;
          storageAccountName: string): Recallable =
  ## deleteStorageAccount
  ## Deletes a storage account. This operation requires the storage/delete permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_594665 = newJObject()
  var query_594666 = newJObject()
  add(query_594666, "api-version", newJString(apiVersion))
  add(path_594665, "storage-account-name", newJString(storageAccountName))
  result = call_594664.call(path_594665, query_594666, nil, nil, nil)

var deleteStorageAccount* = Call_DeleteStorageAccount_594658(
    name: "deleteStorageAccount", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/storage/{storage-account-name}",
    validator: validate_DeleteStorageAccount_594659, base: "",
    url: url_DeleteStorageAccount_594660, schemes: {Scheme.Https})
type
  Call_BackupStorageAccount_594678 = ref object of OpenApiRestCall_593438
proc url_BackupStorageAccount_594680(protocol: Scheme; host: string; base: string;
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

proc validate_BackupStorageAccount_594679(path: JsonNode; query: JsonNode;
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
  var valid_594681 = path.getOrDefault("storage-account-name")
  valid_594681 = validateParameter(valid_594681, JString, required = true,
                                 default = nil)
  if valid_594681 != nil:
    section.add "storage-account-name", valid_594681
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594682 = query.getOrDefault("api-version")
  valid_594682 = validateParameter(valid_594682, JString, required = true,
                                 default = nil)
  if valid_594682 != nil:
    section.add "api-version", valid_594682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594683: Call_BackupStorageAccount_594678; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a backup of the specified storage account be downloaded to the client. This operation requires the storage/backup permission.
  ## 
  let valid = call_594683.validator(path, query, header, formData, body)
  let scheme = call_594683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594683.url(scheme.get, call_594683.host, call_594683.base,
                         call_594683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594683, url, valid)

proc call*(call_594684: Call_BackupStorageAccount_594678; apiVersion: string;
          storageAccountName: string): Recallable =
  ## backupStorageAccount
  ## Requests that a backup of the specified storage account be downloaded to the client. This operation requires the storage/backup permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_594685 = newJObject()
  var query_594686 = newJObject()
  add(query_594686, "api-version", newJString(apiVersion))
  add(path_594685, "storage-account-name", newJString(storageAccountName))
  result = call_594684.call(path_594685, query_594686, nil, nil, nil)

var backupStorageAccount* = Call_BackupStorageAccount_594678(
    name: "backupStorageAccount", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/storage/{storage-account-name}/backup",
    validator: validate_BackupStorageAccount_594679, base: "",
    url: url_BackupStorageAccount_594680, schemes: {Scheme.Https})
type
  Call_RegenerateStorageAccountKey_594687 = ref object of OpenApiRestCall_593438
proc url_RegenerateStorageAccountKey_594689(protocol: Scheme; host: string;
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

proc validate_RegenerateStorageAccountKey_594688(path: JsonNode; query: JsonNode;
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
  var valid_594690 = path.getOrDefault("storage-account-name")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = nil)
  if valid_594690 != nil:
    section.add "storage-account-name", valid_594690
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594691 = query.getOrDefault("api-version")
  valid_594691 = validateParameter(valid_594691, JString, required = true,
                                 default = nil)
  if valid_594691 != nil:
    section.add "api-version", valid_594691
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

proc call*(call_594693: Call_RegenerateStorageAccountKey_594687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the specified key value for the given storage account. This operation requires the storage/regeneratekey permission.
  ## 
  let valid = call_594693.validator(path, query, header, formData, body)
  let scheme = call_594693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594693.url(scheme.get, call_594693.host, call_594693.base,
                         call_594693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594693, url, valid)

proc call*(call_594694: Call_RegenerateStorageAccountKey_594687;
          apiVersion: string; storageAccountName: string; parameters: JsonNode): Recallable =
  ## regenerateStorageAccountKey
  ## Regenerates the specified key value for the given storage account. This operation requires the storage/regeneratekey permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   parameters: JObject (required)
  ##             : The parameters to regenerate storage account key.
  var path_594695 = newJObject()
  var query_594696 = newJObject()
  var body_594697 = newJObject()
  add(query_594696, "api-version", newJString(apiVersion))
  add(path_594695, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_594697 = parameters
  result = call_594694.call(path_594695, query_594696, nil, nil, body_594697)

var regenerateStorageAccountKey* = Call_RegenerateStorageAccountKey_594687(
    name: "regenerateStorageAccountKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/storage/{storage-account-name}/regeneratekey",
    validator: validate_RegenerateStorageAccountKey_594688, base: "",
    url: url_RegenerateStorageAccountKey_594689, schemes: {Scheme.Https})
type
  Call_GetSasDefinitions_594698 = ref object of OpenApiRestCall_593438
proc url_GetSasDefinitions_594700(protocol: Scheme; host: string; base: string;
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

proc validate_GetSasDefinitions_594699(path: JsonNode; query: JsonNode;
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
  var valid_594701 = path.getOrDefault("storage-account-name")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = nil)
  if valid_594701 != nil:
    section.add "storage-account-name", valid_594701
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   maxresults: JInt
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594702 = query.getOrDefault("api-version")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "api-version", valid_594702
  var valid_594703 = query.getOrDefault("maxresults")
  valid_594703 = validateParameter(valid_594703, JInt, required = false, default = nil)
  if valid_594703 != nil:
    section.add "maxresults", valid_594703
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594704: Call_GetSasDefinitions_594698; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List storage SAS definitions for the given storage account. This operation requires the storage/listsas permission.
  ## 
  let valid = call_594704.validator(path, query, header, formData, body)
  let scheme = call_594704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594704.url(scheme.get, call_594704.host, call_594704.base,
                         call_594704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594704, url, valid)

proc call*(call_594705: Call_GetSasDefinitions_594698; apiVersion: string;
          storageAccountName: string; maxresults: int = 0): Recallable =
  ## getSasDefinitions
  ## List storage SAS definitions for the given storage account. This operation requires the storage/listsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   maxresults: int
  ##             : Maximum number of results to return in a page. If not specified the service will return up to 25 results.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  var path_594706 = newJObject()
  var query_594707 = newJObject()
  add(query_594707, "api-version", newJString(apiVersion))
  add(query_594707, "maxresults", newJInt(maxresults))
  add(path_594706, "storage-account-name", newJString(storageAccountName))
  result = call_594705.call(path_594706, query_594707, nil, nil, nil)

var getSasDefinitions* = Call_GetSasDefinitions_594698(name: "getSasDefinitions",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}/sas",
    validator: validate_GetSasDefinitions_594699, base: "",
    url: url_GetSasDefinitions_594700, schemes: {Scheme.Https})
type
  Call_SetSasDefinition_594718 = ref object of OpenApiRestCall_593438
proc url_SetSasDefinition_594720(protocol: Scheme; host: string; base: string;
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

proc validate_SetSasDefinition_594719(path: JsonNode; query: JsonNode;
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
  var valid_594721 = path.getOrDefault("storage-account-name")
  valid_594721 = validateParameter(valid_594721, JString, required = true,
                                 default = nil)
  if valid_594721 != nil:
    section.add "storage-account-name", valid_594721
  var valid_594722 = path.getOrDefault("sas-definition-name")
  valid_594722 = validateParameter(valid_594722, JString, required = true,
                                 default = nil)
  if valid_594722 != nil:
    section.add "sas-definition-name", valid_594722
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594723 = query.getOrDefault("api-version")
  valid_594723 = validateParameter(valid_594723, JString, required = true,
                                 default = nil)
  if valid_594723 != nil:
    section.add "api-version", valid_594723
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

proc call*(call_594725: Call_SetSasDefinition_594718; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new SAS definition for the specified storage account. This operation requires the storage/setsas permission.
  ## 
  let valid = call_594725.validator(path, query, header, formData, body)
  let scheme = call_594725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594725.url(scheme.get, call_594725.host, call_594725.base,
                         call_594725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594725, url, valid)

proc call*(call_594726: Call_SetSasDefinition_594718; apiVersion: string;
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
  var path_594727 = newJObject()
  var query_594728 = newJObject()
  var body_594729 = newJObject()
  add(query_594728, "api-version", newJString(apiVersion))
  add(path_594727, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_594729 = parameters
  add(path_594727, "sas-definition-name", newJString(sasDefinitionName))
  result = call_594726.call(path_594727, query_594728, nil, nil, body_594729)

var setSasDefinition* = Call_SetSasDefinition_594718(name: "setSasDefinition",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_SetSasDefinition_594719, base: "",
    url: url_SetSasDefinition_594720, schemes: {Scheme.Https})
type
  Call_GetSasDefinition_594708 = ref object of OpenApiRestCall_593438
proc url_GetSasDefinition_594710(protocol: Scheme; host: string; base: string;
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

proc validate_GetSasDefinition_594709(path: JsonNode; query: JsonNode;
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
  var valid_594711 = path.getOrDefault("storage-account-name")
  valid_594711 = validateParameter(valid_594711, JString, required = true,
                                 default = nil)
  if valid_594711 != nil:
    section.add "storage-account-name", valid_594711
  var valid_594712 = path.getOrDefault("sas-definition-name")
  valid_594712 = validateParameter(valid_594712, JString, required = true,
                                 default = nil)
  if valid_594712 != nil:
    section.add "sas-definition-name", valid_594712
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594713 = query.getOrDefault("api-version")
  valid_594713 = validateParameter(valid_594713, JString, required = true,
                                 default = nil)
  if valid_594713 != nil:
    section.add "api-version", valid_594713
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594714: Call_GetSasDefinition_594708; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a SAS definition for the specified storage account. This operation requires the storage/getsas permission.
  ## 
  let valid = call_594714.validator(path, query, header, formData, body)
  let scheme = call_594714.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594714.url(scheme.get, call_594714.host, call_594714.base,
                         call_594714.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594714, url, valid)

proc call*(call_594715: Call_GetSasDefinition_594708; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## getSasDefinition
  ## Gets information about a SAS definition for the specified storage account. This operation requires the storage/getsas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_594716 = newJObject()
  var query_594717 = newJObject()
  add(query_594717, "api-version", newJString(apiVersion))
  add(path_594716, "storage-account-name", newJString(storageAccountName))
  add(path_594716, "sas-definition-name", newJString(sasDefinitionName))
  result = call_594715.call(path_594716, query_594717, nil, nil, nil)

var getSasDefinition* = Call_GetSasDefinition_594708(name: "getSasDefinition",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_GetSasDefinition_594709, base: "",
    url: url_GetSasDefinition_594710, schemes: {Scheme.Https})
type
  Call_UpdateSasDefinition_594740 = ref object of OpenApiRestCall_593438
proc url_UpdateSasDefinition_594742(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateSasDefinition_594741(path: JsonNode; query: JsonNode;
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
  var valid_594743 = path.getOrDefault("storage-account-name")
  valid_594743 = validateParameter(valid_594743, JString, required = true,
                                 default = nil)
  if valid_594743 != nil:
    section.add "storage-account-name", valid_594743
  var valid_594744 = path.getOrDefault("sas-definition-name")
  valid_594744 = validateParameter(valid_594744, JString, required = true,
                                 default = nil)
  if valid_594744 != nil:
    section.add "sas-definition-name", valid_594744
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594745 = query.getOrDefault("api-version")
  valid_594745 = validateParameter(valid_594745, JString, required = true,
                                 default = nil)
  if valid_594745 != nil:
    section.add "api-version", valid_594745
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

proc call*(call_594747: Call_UpdateSasDefinition_594740; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified attributes associated with the given SAS definition. This operation requires the storage/setsas permission.
  ## 
  let valid = call_594747.validator(path, query, header, formData, body)
  let scheme = call_594747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594747.url(scheme.get, call_594747.host, call_594747.base,
                         call_594747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594747, url, valid)

proc call*(call_594748: Call_UpdateSasDefinition_594740; apiVersion: string;
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
  var path_594749 = newJObject()
  var query_594750 = newJObject()
  var body_594751 = newJObject()
  add(query_594750, "api-version", newJString(apiVersion))
  add(path_594749, "storage-account-name", newJString(storageAccountName))
  if parameters != nil:
    body_594751 = parameters
  add(path_594749, "sas-definition-name", newJString(sasDefinitionName))
  result = call_594748.call(path_594749, query_594750, nil, nil, body_594751)

var updateSasDefinition* = Call_UpdateSasDefinition_594740(
    name: "updateSasDefinition", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_UpdateSasDefinition_594741, base: "",
    url: url_UpdateSasDefinition_594742, schemes: {Scheme.Https})
type
  Call_DeleteSasDefinition_594730 = ref object of OpenApiRestCall_593438
proc url_DeleteSasDefinition_594732(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteSasDefinition_594731(path: JsonNode; query: JsonNode;
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
  var valid_594733 = path.getOrDefault("storage-account-name")
  valid_594733 = validateParameter(valid_594733, JString, required = true,
                                 default = nil)
  if valid_594733 != nil:
    section.add "storage-account-name", valid_594733
  var valid_594734 = path.getOrDefault("sas-definition-name")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "sas-definition-name", valid_594734
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594735 = query.getOrDefault("api-version")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "api-version", valid_594735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594736: Call_DeleteSasDefinition_594730; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SAS definition from a specified storage account. This operation requires the storage/deletesas permission.
  ## 
  let valid = call_594736.validator(path, query, header, formData, body)
  let scheme = call_594736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594736.url(scheme.get, call_594736.host, call_594736.base,
                         call_594736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594736, url, valid)

proc call*(call_594737: Call_DeleteSasDefinition_594730; apiVersion: string;
          storageAccountName: string; sasDefinitionName: string): Recallable =
  ## deleteSasDefinition
  ## Deletes a SAS definition from a specified storage account. This operation requires the storage/deletesas permission.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   storageAccountName: string (required)
  ##                     : The name of the storage account.
  ##   sasDefinitionName: string (required)
  ##                    : The name of the SAS definition.
  var path_594738 = newJObject()
  var query_594739 = newJObject()
  add(query_594739, "api-version", newJString(apiVersion))
  add(path_594738, "storage-account-name", newJString(storageAccountName))
  add(path_594738, "sas-definition-name", newJString(sasDefinitionName))
  result = call_594737.call(path_594738, query_594739, nil, nil, nil)

var deleteSasDefinition* = Call_DeleteSasDefinition_594730(
    name: "deleteSasDefinition", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/storage/{storage-account-name}/sas/{sas-definition-name}",
    validator: validate_DeleteSasDefinition_594731, base: "",
    url: url_DeleteSasDefinition_594732, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
