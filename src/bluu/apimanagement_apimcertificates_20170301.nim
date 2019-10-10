
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Certificate entity in your Azure API Management deployment. Certificates can be used to setup mutual authentication with your Backend in API Management. For more information refer to [How to secure backend using Mutual Auth Certificate](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-mutual-certificates).
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimcertificates"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CertificateList_573879 = ref object of OpenApiRestCall_573657
proc url_CertificateList_573881(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CertificateList_573880(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists a collection of all certificates in the specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field          | Supported operators    | Supported functions                         |
  ## 
  ## |----------------|------------------------|---------------------------------------------|
  ## | id             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | subject        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | thumbprint     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | expirationDate | ge, le, eq, ne, gt, lt | N/A                                         |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574028 = query.getOrDefault("api-version")
  valid_574028 = validateParameter(valid_574028, JString, required = true,
                                 default = nil)
  if valid_574028 != nil:
    section.add "api-version", valid_574028
  var valid_574029 = query.getOrDefault("$top")
  valid_574029 = validateParameter(valid_574029, JInt, required = false, default = nil)
  if valid_574029 != nil:
    section.add "$top", valid_574029
  var valid_574030 = query.getOrDefault("$skip")
  valid_574030 = validateParameter(valid_574030, JInt, required = false, default = nil)
  if valid_574030 != nil:
    section.add "$skip", valid_574030
  var valid_574031 = query.getOrDefault("$filter")
  valid_574031 = validateParameter(valid_574031, JString, required = false,
                                 default = nil)
  if valid_574031 != nil:
    section.add "$filter", valid_574031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574058: Call_CertificateList_573879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of all certificates in the specified service instance.
  ## 
  let valid = call_574058.validator(path, query, header, formData, body)
  let scheme = call_574058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574058.url(scheme.get, call_574058.host, call_574058.base,
                         call_574058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574058, url, valid)

proc call*(call_574129: Call_CertificateList_573879; apiVersion: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## certificateList
  ## Lists a collection of all certificates in the specified service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field          | Supported operators    | Supported functions                         |
  ## 
  ## |----------------|------------------------|---------------------------------------------|
  ## | id             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | subject        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | thumbprint     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | expirationDate | ge, le, eq, ne, gt, lt | N/A                                         |
  var query_574130 = newJObject()
  add(query_574130, "api-version", newJString(apiVersion))
  add(query_574130, "$top", newJInt(Top))
  add(query_574130, "$skip", newJInt(Skip))
  add(query_574130, "$filter", newJString(Filter))
  result = call_574129.call(nil, query_574130, nil, nil, nil)

var certificateList* = Call_CertificateList_573879(name: "certificateList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates",
    validator: validate_CertificateList_573880, base: "", url: url_CertificateList_573881,
    schemes: {Scheme.Https})
type
  Call_CertificateCreateOrUpdate_574202 = ref object of OpenApiRestCall_573657
proc url_CertificateCreateOrUpdate_574204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificateId" in path, "`certificateId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificateCreateOrUpdate_574203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the certificate being used for authentication with the backend.
  ## 
  ## How to secure back-end services using client certificate authentication in Azure API Management
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-howto-mutual-certificates/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateId: JString (required)
  ##                : Identifier of the certificate entity. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificateId` field"
  var valid_574222 = path.getOrDefault("certificateId")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "certificateId", valid_574222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574223 = query.getOrDefault("api-version")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "api-version", valid_574223
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (Etag) version of the certificate to update. A value of "*" can be used for If-Match to unconditionally apply the operation..
  section = newJObject()
  var valid_574224 = header.getOrDefault("If-Match")
  valid_574224 = validateParameter(valid_574224, JString, required = false,
                                 default = nil)
  if valid_574224 != nil:
    section.add "If-Match", valid_574224
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574226: Call_CertificateCreateOrUpdate_574202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the certificate being used for authentication with the backend.
  ## 
  ## How to secure back-end services using client certificate authentication in Azure API Management
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-howto-mutual-certificates/
  let valid = call_574226.validator(path, query, header, formData, body)
  let scheme = call_574226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574226.url(scheme.get, call_574226.host, call_574226.base,
                         call_574226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574226, url, valid)

proc call*(call_574227: Call_CertificateCreateOrUpdate_574202; apiVersion: string;
          certificateId: string; parameters: JsonNode): Recallable =
  ## certificateCreateOrUpdate
  ## Creates or updates the certificate being used for authentication with the backend.
  ## How to secure back-end services using client certificate authentication in Azure API Management
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-howto-mutual-certificates/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   certificateId: string (required)
  ##                : Identifier of the certificate entity. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : Create or Update parameters.
  var path_574228 = newJObject()
  var query_574229 = newJObject()
  var body_574230 = newJObject()
  add(query_574229, "api-version", newJString(apiVersion))
  add(path_574228, "certificateId", newJString(certificateId))
  if parameters != nil:
    body_574230 = parameters
  result = call_574227.call(path_574228, query_574229, nil, nil, body_574230)

var certificateCreateOrUpdate* = Call_CertificateCreateOrUpdate_574202(
    name: "certificateCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/certificates/{certificateId}",
    validator: validate_CertificateCreateOrUpdate_574203, base: "",
    url: url_CertificateCreateOrUpdate_574204, schemes: {Scheme.Https})
type
  Call_CertificateGet_574170 = ref object of OpenApiRestCall_573657
proc url_CertificateGet_574172(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificateId" in path, "`certificateId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificateGet_574171(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the details of the certificate specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateId: JString (required)
  ##                : Identifier of the certificate entity. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificateId` field"
  var valid_574196 = path.getOrDefault("certificateId")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "certificateId", valid_574196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574197 = query.getOrDefault("api-version")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "api-version", valid_574197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574198: Call_CertificateGet_574170; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the certificate specified by its identifier.
  ## 
  let valid = call_574198.validator(path, query, header, formData, body)
  let scheme = call_574198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574198.url(scheme.get, call_574198.host, call_574198.base,
                         call_574198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574198, url, valid)

proc call*(call_574199: Call_CertificateGet_574170; apiVersion: string;
          certificateId: string): Recallable =
  ## certificateGet
  ## Gets the details of the certificate specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   certificateId: string (required)
  ##                : Identifier of the certificate entity. Must be unique in the current API Management service instance.
  var path_574200 = newJObject()
  var query_574201 = newJObject()
  add(query_574201, "api-version", newJString(apiVersion))
  add(path_574200, "certificateId", newJString(certificateId))
  result = call_574199.call(path_574200, query_574201, nil, nil, nil)

var certificateGet* = Call_CertificateGet_574170(name: "certificateGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificateId}", validator: validate_CertificateGet_574171,
    base: "", url: url_CertificateGet_574172, schemes: {Scheme.Https})
type
  Call_CertificateDelete_574231 = ref object of OpenApiRestCall_573657
proc url_CertificateDelete_574233(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "certificateId" in path, "`certificateId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificateDelete_574232(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes specific certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateId: JString (required)
  ##                : Identifier of the certificate entity. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `certificateId` field"
  var valid_574234 = path.getOrDefault("certificateId")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "certificateId", valid_574234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574235 = query.getOrDefault("api-version")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "api-version", valid_574235
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the certificate to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574236 = header.getOrDefault("If-Match")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "If-Match", valid_574236
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574237: Call_CertificateDelete_574231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific certificate.
  ## 
  let valid = call_574237.validator(path, query, header, formData, body)
  let scheme = call_574237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574237.url(scheme.get, call_574237.host, call_574237.base,
                         call_574237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574237, url, valid)

proc call*(call_574238: Call_CertificateDelete_574231; apiVersion: string;
          certificateId: string): Recallable =
  ## certificateDelete
  ## Deletes specific certificate.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   certificateId: string (required)
  ##                : Identifier of the certificate entity. Must be unique in the current API Management service instance.
  var path_574239 = newJObject()
  var query_574240 = newJObject()
  add(query_574240, "api-version", newJString(apiVersion))
  add(path_574239, "certificateId", newJString(certificateId))
  result = call_574238.call(path_574239, query_574240, nil, nil, nil)

var certificateDelete* = Call_CertificateDelete_574231(name: "certificateDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/certificates/{certificateId}", validator: validate_CertificateDelete_574232,
    base: "", url: url_CertificateDelete_574233, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
