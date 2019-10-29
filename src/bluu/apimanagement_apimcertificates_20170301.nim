
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimcertificates"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CertificateList_563777 = ref object of OpenApiRestCall_563555
proc url_CertificateList_563779(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CertificateList_563778(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists a collection of all certificates in the specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Number of records to return.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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
  var valid_563928 = query.getOrDefault("$top")
  valid_563928 = validateParameter(valid_563928, JInt, required = false, default = nil)
  if valid_563928 != nil:
    section.add "$top", valid_563928
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563929 = query.getOrDefault("api-version")
  valid_563929 = validateParameter(valid_563929, JString, required = true,
                                 default = nil)
  if valid_563929 != nil:
    section.add "api-version", valid_563929
  var valid_563930 = query.getOrDefault("$skip")
  valid_563930 = validateParameter(valid_563930, JInt, required = false, default = nil)
  if valid_563930 != nil:
    section.add "$skip", valid_563930
  var valid_563931 = query.getOrDefault("$filter")
  valid_563931 = validateParameter(valid_563931, JString, required = false,
                                 default = nil)
  if valid_563931 != nil:
    section.add "$filter", valid_563931
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563958: Call_CertificateList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of all certificates in the specified service instance.
  ## 
  let valid = call_563958.validator(path, query, header, formData, body)
  let scheme = call_563958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563958.url(scheme.get, call_563958.host, call_563958.base,
                         call_563958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563958, url, valid)

proc call*(call_564029: Call_CertificateList_563777; apiVersion: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## certificateList
  ## Lists a collection of all certificates in the specified service instance.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
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
  var query_564030 = newJObject()
  add(query_564030, "$top", newJInt(Top))
  add(query_564030, "api-version", newJString(apiVersion))
  add(query_564030, "$skip", newJInt(Skip))
  add(query_564030, "$filter", newJString(Filter))
  result = call_564029.call(nil, query_564030, nil, nil, nil)

var certificateList* = Call_CertificateList_563777(name: "certificateList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates",
    validator: validate_CertificateList_563778, base: "", url: url_CertificateList_563779,
    schemes: {Scheme.Https})
type
  Call_CertificateCreateOrUpdate_564102 = ref object of OpenApiRestCall_563555
proc url_CertificateCreateOrUpdate_564104(protocol: Scheme; host: string;
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

proc validate_CertificateCreateOrUpdate_564103(path: JsonNode; query: JsonNode;
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
  var valid_564122 = path.getOrDefault("certificateId")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "certificateId", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (Etag) version of the certificate to update. A value of "*" can be used for If-Match to unconditionally apply the operation..
  section = newJObject()
  var valid_564124 = header.getOrDefault("If-Match")
  valid_564124 = validateParameter(valid_564124, JString, required = false,
                                 default = nil)
  if valid_564124 != nil:
    section.add "If-Match", valid_564124
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

proc call*(call_564126: Call_CertificateCreateOrUpdate_564102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the certificate being used for authentication with the backend.
  ## 
  ## How to secure back-end services using client certificate authentication in Azure API Management
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-howto-mutual-certificates/
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_CertificateCreateOrUpdate_564102; apiVersion: string;
          parameters: JsonNode; certificateId: string): Recallable =
  ## certificateCreateOrUpdate
  ## Creates or updates the certificate being used for authentication with the backend.
  ## How to secure back-end services using client certificate authentication in Azure API Management
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-howto-mutual-certificates/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Create or Update parameters.
  ##   certificateId: string (required)
  ##                : Identifier of the certificate entity. Must be unique in the current API Management service instance.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  var body_564130 = newJObject()
  add(query_564129, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564130 = parameters
  add(path_564128, "certificateId", newJString(certificateId))
  result = call_564127.call(path_564128, query_564129, nil, nil, body_564130)

var certificateCreateOrUpdate* = Call_CertificateCreateOrUpdate_564102(
    name: "certificateCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/certificates/{certificateId}",
    validator: validate_CertificateCreateOrUpdate_564103, base: "",
    url: url_CertificateCreateOrUpdate_564104, schemes: {Scheme.Https})
type
  Call_CertificateGet_564070 = ref object of OpenApiRestCall_563555
proc url_CertificateGet_564072(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateGet_564071(path: JsonNode; query: JsonNode;
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
  var valid_564096 = path.getOrDefault("certificateId")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "certificateId", valid_564096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564097 = query.getOrDefault("api-version")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "api-version", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_CertificateGet_564070; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the certificate specified by its identifier.
  ## 
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_CertificateGet_564070; apiVersion: string;
          certificateId: string): Recallable =
  ## certificateGet
  ## Gets the details of the certificate specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   certificateId: string (required)
  ##                : Identifier of the certificate entity. Must be unique in the current API Management service instance.
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  add(path_564100, "certificateId", newJString(certificateId))
  result = call_564099.call(path_564100, query_564101, nil, nil, nil)

var certificateGet* = Call_CertificateGet_564070(name: "certificateGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/certificates/{certificateId}", validator: validate_CertificateGet_564071,
    base: "", url: url_CertificateGet_564072, schemes: {Scheme.Https})
type
  Call_CertificateDelete_564131 = ref object of OpenApiRestCall_563555
proc url_CertificateDelete_564133(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateDelete_564132(path: JsonNode; query: JsonNode;
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
  var valid_564134 = path.getOrDefault("certificateId")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "certificateId", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the certificate to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564136 = header.getOrDefault("If-Match")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "If-Match", valid_564136
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564137: Call_CertificateDelete_564131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific certificate.
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_CertificateDelete_564131; apiVersion: string;
          certificateId: string): Recallable =
  ## certificateDelete
  ## Deletes specific certificate.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   certificateId: string (required)
  ##                : Identifier of the certificate entity. Must be unique in the current API Management service instance.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "certificateId", newJString(certificateId))
  result = call_564138.call(path_564139, query_564140, nil, nil, nil)

var certificateDelete* = Call_CertificateDelete_564131(name: "certificateDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/certificates/{certificateId}", validator: validate_CertificateDelete_564132,
    base: "", url: url_CertificateDelete_564133, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
