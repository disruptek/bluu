
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: BatchService
## version: 2019-08-01.10.0
## termsOfService: (not provided)
## license: (not provided)
## 
## A client for issuing REST requests to the Azure Batch service.
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

  OpenApiRestCall_573667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573667): Option[Scheme] {.used.} =
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
  macServiceName = "batch-BatchService"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApplicationList_573889 = ref object of OpenApiRestCall_573667
proc url_ApplicationList_573891(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationList_573890(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## This operation returns only Applications and versions that are available for use on Compute Nodes; that is, that can be used in an Package reference. For administrator information about applications and versions that are not yet available to Compute Nodes, use the Azure portal or the Azure Resource Manager API.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 applications can be returned.
  section = newJObject()
  var valid_574064 = query.getOrDefault("timeout")
  valid_574064 = validateParameter(valid_574064, JInt, required = false,
                                 default = newJInt(30))
  if valid_574064 != nil:
    section.add "timeout", valid_574064
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574065 = query.getOrDefault("api-version")
  valid_574065 = validateParameter(valid_574065, JString, required = true,
                                 default = nil)
  if valid_574065 != nil:
    section.add "api-version", valid_574065
  var valid_574066 = query.getOrDefault("maxresults")
  valid_574066 = validateParameter(valid_574066, JInt, required = false,
                                 default = newJInt(1000))
  if valid_574066 != nil:
    section.add "maxresults", valid_574066
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574067 = header.getOrDefault("client-request-id")
  valid_574067 = validateParameter(valid_574067, JString, required = false,
                                 default = nil)
  if valid_574067 != nil:
    section.add "client-request-id", valid_574067
  var valid_574068 = header.getOrDefault("ocp-date")
  valid_574068 = validateParameter(valid_574068, JString, required = false,
                                 default = nil)
  if valid_574068 != nil:
    section.add "ocp-date", valid_574068
  var valid_574069 = header.getOrDefault("return-client-request-id")
  valid_574069 = validateParameter(valid_574069, JBool, required = false,
                                 default = newJBool(false))
  if valid_574069 != nil:
    section.add "return-client-request-id", valid_574069
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574092: Call_ApplicationList_573889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation returns only Applications and versions that are available for use on Compute Nodes; that is, that can be used in an Package reference. For administrator information about applications and versions that are not yet available to Compute Nodes, use the Azure portal or the Azure Resource Manager API.
  ## 
  let valid = call_574092.validator(path, query, header, formData, body)
  let scheme = call_574092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574092.url(scheme.get, call_574092.host, call_574092.base,
                         call_574092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574092, url, valid)

proc call*(call_574163: Call_ApplicationList_573889; apiVersion: string;
          timeout: int = 30; maxresults: int = 1000): Recallable =
  ## applicationList
  ## This operation returns only Applications and versions that are available for use on Compute Nodes; that is, that can be used in an Package reference. For administrator information about applications and versions that are not yet available to Compute Nodes, use the Azure portal or the Azure Resource Manager API.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 applications can be returned.
  var query_574164 = newJObject()
  add(query_574164, "timeout", newJInt(timeout))
  add(query_574164, "api-version", newJString(apiVersion))
  add(query_574164, "maxresults", newJInt(maxresults))
  result = call_574163.call(nil, query_574164, nil, nil, nil)

var applicationList* = Call_ApplicationList_573889(name: "applicationList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/applications",
    validator: validate_ApplicationList_573890, base: "", url: url_ApplicationList_573891,
    schemes: {Scheme.Https})
type
  Call_ApplicationGet_574204 = ref object of OpenApiRestCall_573667
proc url_ApplicationGet_574206(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGet_574205(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## This operation returns only Applications and versions that are available for use on Compute Nodes; that is, that can be used in an Package reference. For administrator information about Applications and versions that are not yet available to Compute Nodes, use the Azure portal or the Azure Resource Manager API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The ID of the Application.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_574221 = path.getOrDefault("applicationId")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "applicationId", valid_574221
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574222 = query.getOrDefault("timeout")
  valid_574222 = validateParameter(valid_574222, JInt, required = false,
                                 default = newJInt(30))
  if valid_574222 != nil:
    section.add "timeout", valid_574222
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574223 = query.getOrDefault("api-version")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "api-version", valid_574223
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574224 = header.getOrDefault("client-request-id")
  valid_574224 = validateParameter(valid_574224, JString, required = false,
                                 default = nil)
  if valid_574224 != nil:
    section.add "client-request-id", valid_574224
  var valid_574225 = header.getOrDefault("ocp-date")
  valid_574225 = validateParameter(valid_574225, JString, required = false,
                                 default = nil)
  if valid_574225 != nil:
    section.add "ocp-date", valid_574225
  var valid_574226 = header.getOrDefault("return-client-request-id")
  valid_574226 = validateParameter(valid_574226, JBool, required = false,
                                 default = newJBool(false))
  if valid_574226 != nil:
    section.add "return-client-request-id", valid_574226
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574227: Call_ApplicationGet_574204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation returns only Applications and versions that are available for use on Compute Nodes; that is, that can be used in an Package reference. For administrator information about Applications and versions that are not yet available to Compute Nodes, use the Azure portal or the Azure Resource Manager API.
  ## 
  let valid = call_574227.validator(path, query, header, formData, body)
  let scheme = call_574227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574227.url(scheme.get, call_574227.host, call_574227.base,
                         call_574227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574227, url, valid)

proc call*(call_574228: Call_ApplicationGet_574204; apiVersion: string;
          applicationId: string; timeout: int = 30): Recallable =
  ## applicationGet
  ## This operation returns only Applications and versions that are available for use on Compute Nodes; that is, that can be used in an Package reference. For administrator information about Applications and versions that are not yet available to Compute Nodes, use the Azure portal or the Azure Resource Manager API.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   applicationId: string (required)
  ##                : The ID of the Application.
  var path_574229 = newJObject()
  var query_574230 = newJObject()
  add(query_574230, "timeout", newJInt(timeout))
  add(query_574230, "api-version", newJString(apiVersion))
  add(path_574229, "applicationId", newJString(applicationId))
  result = call_574228.call(path_574229, query_574230, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_574204(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/applications/{applicationId}", validator: validate_ApplicationGet_574205,
    base: "", url: url_ApplicationGet_574206, schemes: {Scheme.Https})
type
  Call_CertificateAdd_574246 = ref object of OpenApiRestCall_573667
proc url_CertificateAdd_574248(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CertificateAdd_574247(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574266 = query.getOrDefault("timeout")
  valid_574266 = validateParameter(valid_574266, JInt, required = false,
                                 default = newJInt(30))
  if valid_574266 != nil:
    section.add "timeout", valid_574266
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574267 = query.getOrDefault("api-version")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "api-version", valid_574267
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574268 = header.getOrDefault("client-request-id")
  valid_574268 = validateParameter(valid_574268, JString, required = false,
                                 default = nil)
  if valid_574268 != nil:
    section.add "client-request-id", valid_574268
  var valid_574269 = header.getOrDefault("ocp-date")
  valid_574269 = validateParameter(valid_574269, JString, required = false,
                                 default = nil)
  if valid_574269 != nil:
    section.add "ocp-date", valid_574269
  var valid_574270 = header.getOrDefault("return-client-request-id")
  valid_574270 = validateParameter(valid_574270, JBool, required = false,
                                 default = newJBool(false))
  if valid_574270 != nil:
    section.add "return-client-request-id", valid_574270
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   certificate: JObject (required)
  ##              : The Certificate to be added.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574272: Call_CertificateAdd_574246; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574272.validator(path, query, header, formData, body)
  let scheme = call_574272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574272.url(scheme.get, call_574272.host, call_574272.base,
                         call_574272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574272, url, valid)

proc call*(call_574273: Call_CertificateAdd_574246; apiVersion: string;
          certificate: JsonNode; timeout: int = 30): Recallable =
  ## certificateAdd
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   certificate: JObject (required)
  ##              : The Certificate to be added.
  var query_574274 = newJObject()
  var body_574275 = newJObject()
  add(query_574274, "timeout", newJInt(timeout))
  add(query_574274, "api-version", newJString(apiVersion))
  if certificate != nil:
    body_574275 = certificate
  result = call_574273.call(nil, query_574274, nil, nil, body_574275)

var certificateAdd* = Call_CertificateAdd_574246(name: "certificateAdd",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/certificates",
    validator: validate_CertificateAdd_574247, base: "", url: url_CertificateAdd_574248,
    schemes: {Scheme.Https})
type
  Call_CertificateList_574231 = ref object of OpenApiRestCall_573667
proc url_CertificateList_574233(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CertificateList_574232(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 Certificates can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-certificates.
  section = newJObject()
  var valid_574235 = query.getOrDefault("timeout")
  valid_574235 = validateParameter(valid_574235, JInt, required = false,
                                 default = newJInt(30))
  if valid_574235 != nil:
    section.add "timeout", valid_574235
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574236 = query.getOrDefault("api-version")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "api-version", valid_574236
  var valid_574237 = query.getOrDefault("maxresults")
  valid_574237 = validateParameter(valid_574237, JInt, required = false,
                                 default = newJInt(1000))
  if valid_574237 != nil:
    section.add "maxresults", valid_574237
  var valid_574238 = query.getOrDefault("$select")
  valid_574238 = validateParameter(valid_574238, JString, required = false,
                                 default = nil)
  if valid_574238 != nil:
    section.add "$select", valid_574238
  var valid_574239 = query.getOrDefault("$filter")
  valid_574239 = validateParameter(valid_574239, JString, required = false,
                                 default = nil)
  if valid_574239 != nil:
    section.add "$filter", valid_574239
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574240 = header.getOrDefault("client-request-id")
  valid_574240 = validateParameter(valid_574240, JString, required = false,
                                 default = nil)
  if valid_574240 != nil:
    section.add "client-request-id", valid_574240
  var valid_574241 = header.getOrDefault("ocp-date")
  valid_574241 = validateParameter(valid_574241, JString, required = false,
                                 default = nil)
  if valid_574241 != nil:
    section.add "ocp-date", valid_574241
  var valid_574242 = header.getOrDefault("return-client-request-id")
  valid_574242 = validateParameter(valid_574242, JBool, required = false,
                                 default = newJBool(false))
  if valid_574242 != nil:
    section.add "return-client-request-id", valid_574242
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574243: Call_CertificateList_574231; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574243.validator(path, query, header, formData, body)
  let scheme = call_574243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574243.url(scheme.get, call_574243.host, call_574243.base,
                         call_574243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574243, url, valid)

proc call*(call_574244: Call_CertificateList_574231; apiVersion: string;
          timeout: int = 30; maxresults: int = 1000; Select: string = "";
          Filter: string = ""): Recallable =
  ## certificateList
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 Certificates can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-certificates.
  var query_574245 = newJObject()
  add(query_574245, "timeout", newJInt(timeout))
  add(query_574245, "api-version", newJString(apiVersion))
  add(query_574245, "maxresults", newJInt(maxresults))
  add(query_574245, "$select", newJString(Select))
  add(query_574245, "$filter", newJString(Filter))
  result = call_574244.call(nil, query_574245, nil, nil, nil)

var certificateList* = Call_CertificateList_574231(name: "certificateList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates",
    validator: validate_CertificateList_574232, base: "", url: url_CertificateList_574233,
    schemes: {Scheme.Https})
type
  Call_CertificateGet_574276 = ref object of OpenApiRestCall_573667
proc url_CertificateGet_574278(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thumbprintAlgorithm" in path,
        "`thumbprintAlgorithm` is a required path parameter"
  assert "thumbprint" in path, "`thumbprint` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates(thumbprintAlgorithm="),
               (kind: VariableSegment, value: "thumbprintAlgorithm"),
               (kind: ConstantSegment, value: ",thumbprint="),
               (kind: VariableSegment, value: "thumbprint"),
               (kind: ConstantSegment, value: ")")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificateGet_574277(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the specified Certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thumbprintAlgorithm: JString (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: JString (required)
  ##             : The thumbprint of the Certificate to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `thumbprintAlgorithm` field"
  var valid_574279 = path.getOrDefault("thumbprintAlgorithm")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "thumbprintAlgorithm", valid_574279
  var valid_574280 = path.getOrDefault("thumbprint")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "thumbprint", valid_574280
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_574281 = query.getOrDefault("timeout")
  valid_574281 = validateParameter(valid_574281, JInt, required = false,
                                 default = newJInt(30))
  if valid_574281 != nil:
    section.add "timeout", valid_574281
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574282 = query.getOrDefault("api-version")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "api-version", valid_574282
  var valid_574283 = query.getOrDefault("$select")
  valid_574283 = validateParameter(valid_574283, JString, required = false,
                                 default = nil)
  if valid_574283 != nil:
    section.add "$select", valid_574283
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574284 = header.getOrDefault("client-request-id")
  valid_574284 = validateParameter(valid_574284, JString, required = false,
                                 default = nil)
  if valid_574284 != nil:
    section.add "client-request-id", valid_574284
  var valid_574285 = header.getOrDefault("ocp-date")
  valid_574285 = validateParameter(valid_574285, JString, required = false,
                                 default = nil)
  if valid_574285 != nil:
    section.add "ocp-date", valid_574285
  var valid_574286 = header.getOrDefault("return-client-request-id")
  valid_574286 = validateParameter(valid_574286, JBool, required = false,
                                 default = newJBool(false))
  if valid_574286 != nil:
    section.add "return-client-request-id", valid_574286
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574287: Call_CertificateGet_574276; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Certificate.
  ## 
  let valid = call_574287.validator(path, query, header, formData, body)
  let scheme = call_574287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574287.url(scheme.get, call_574287.host, call_574287.base,
                         call_574287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574287, url, valid)

proc call*(call_574288: Call_CertificateGet_574276; apiVersion: string;
          thumbprintAlgorithm: string; thumbprint: string; timeout: int = 30;
          Select: string = ""): Recallable =
  ## certificateGet
  ## Gets information about the specified Certificate.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   thumbprintAlgorithm: string (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   Select: string
  ##         : An OData $select clause.
  ##   thumbprint: string (required)
  ##             : The thumbprint of the Certificate to get.
  var path_574289 = newJObject()
  var query_574290 = newJObject()
  add(query_574290, "timeout", newJInt(timeout))
  add(query_574290, "api-version", newJString(apiVersion))
  add(path_574289, "thumbprintAlgorithm", newJString(thumbprintAlgorithm))
  add(query_574290, "$select", newJString(Select))
  add(path_574289, "thumbprint", newJString(thumbprint))
  result = call_574288.call(path_574289, query_574290, nil, nil, nil)

var certificateGet* = Call_CertificateGet_574276(name: "certificateGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})",
    validator: validate_CertificateGet_574277, base: "", url: url_CertificateGet_574278,
    schemes: {Scheme.Https})
type
  Call_CertificateDelete_574291 = ref object of OpenApiRestCall_573667
proc url_CertificateDelete_574293(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thumbprintAlgorithm" in path,
        "`thumbprintAlgorithm` is a required path parameter"
  assert "thumbprint" in path, "`thumbprint` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates(thumbprintAlgorithm="),
               (kind: VariableSegment, value: "thumbprintAlgorithm"),
               (kind: ConstantSegment, value: ",thumbprint="),
               (kind: VariableSegment, value: "thumbprint"),
               (kind: ConstantSegment, value: ")")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificateDelete_574292(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## You cannot delete a Certificate if a resource (Pool or Compute Node) is using it. Before you can delete a Certificate, you must therefore make sure that the Certificate is not associated with any existing Pools, the Certificate is not installed on any Nodes (even if you remove a Certificate from a Pool, it is not removed from existing Compute Nodes in that Pool until they restart), and no running Tasks depend on the Certificate. If you try to delete a Certificate that is in use, the deletion fails. The Certificate status changes to deleteFailed. You can use Cancel Delete Certificate to set the status back to active if you decide that you want to continue using the Certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thumbprintAlgorithm: JString (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: JString (required)
  ##             : The thumbprint of the Certificate to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `thumbprintAlgorithm` field"
  var valid_574294 = path.getOrDefault("thumbprintAlgorithm")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "thumbprintAlgorithm", valid_574294
  var valid_574295 = path.getOrDefault("thumbprint")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "thumbprint", valid_574295
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574296 = query.getOrDefault("timeout")
  valid_574296 = validateParameter(valid_574296, JInt, required = false,
                                 default = newJInt(30))
  if valid_574296 != nil:
    section.add "timeout", valid_574296
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574297 = query.getOrDefault("api-version")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "api-version", valid_574297
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574298 = header.getOrDefault("client-request-id")
  valid_574298 = validateParameter(valid_574298, JString, required = false,
                                 default = nil)
  if valid_574298 != nil:
    section.add "client-request-id", valid_574298
  var valid_574299 = header.getOrDefault("ocp-date")
  valid_574299 = validateParameter(valid_574299, JString, required = false,
                                 default = nil)
  if valid_574299 != nil:
    section.add "ocp-date", valid_574299
  var valid_574300 = header.getOrDefault("return-client-request-id")
  valid_574300 = validateParameter(valid_574300, JBool, required = false,
                                 default = newJBool(false))
  if valid_574300 != nil:
    section.add "return-client-request-id", valid_574300
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574301: Call_CertificateDelete_574291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You cannot delete a Certificate if a resource (Pool or Compute Node) is using it. Before you can delete a Certificate, you must therefore make sure that the Certificate is not associated with any existing Pools, the Certificate is not installed on any Nodes (even if you remove a Certificate from a Pool, it is not removed from existing Compute Nodes in that Pool until they restart), and no running Tasks depend on the Certificate. If you try to delete a Certificate that is in use, the deletion fails. The Certificate status changes to deleteFailed. You can use Cancel Delete Certificate to set the status back to active if you decide that you want to continue using the Certificate.
  ## 
  let valid = call_574301.validator(path, query, header, formData, body)
  let scheme = call_574301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574301.url(scheme.get, call_574301.host, call_574301.base,
                         call_574301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574301, url, valid)

proc call*(call_574302: Call_CertificateDelete_574291; apiVersion: string;
          thumbprintAlgorithm: string; thumbprint: string; timeout: int = 30): Recallable =
  ## certificateDelete
  ## You cannot delete a Certificate if a resource (Pool or Compute Node) is using it. Before you can delete a Certificate, you must therefore make sure that the Certificate is not associated with any existing Pools, the Certificate is not installed on any Nodes (even if you remove a Certificate from a Pool, it is not removed from existing Compute Nodes in that Pool until they restart), and no running Tasks depend on the Certificate. If you try to delete a Certificate that is in use, the deletion fails. The Certificate status changes to deleteFailed. You can use Cancel Delete Certificate to set the status back to active if you decide that you want to continue using the Certificate.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   thumbprintAlgorithm: string (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: string (required)
  ##             : The thumbprint of the Certificate to be deleted.
  var path_574303 = newJObject()
  var query_574304 = newJObject()
  add(query_574304, "timeout", newJInt(timeout))
  add(query_574304, "api-version", newJString(apiVersion))
  add(path_574303, "thumbprintAlgorithm", newJString(thumbprintAlgorithm))
  add(path_574303, "thumbprint", newJString(thumbprint))
  result = call_574302.call(path_574303, query_574304, nil, nil, nil)

var certificateDelete* = Call_CertificateDelete_574291(name: "certificateDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})",
    validator: validate_CertificateDelete_574292, base: "",
    url: url_CertificateDelete_574293, schemes: {Scheme.Https})
type
  Call_CertificateCancelDeletion_574305 = ref object of OpenApiRestCall_573667
proc url_CertificateCancelDeletion_574307(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "thumbprintAlgorithm" in path,
        "`thumbprintAlgorithm` is a required path parameter"
  assert "thumbprint" in path, "`thumbprint` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/certificates(thumbprintAlgorithm="),
               (kind: VariableSegment, value: "thumbprintAlgorithm"),
               (kind: ConstantSegment, value: ",thumbprint="),
               (kind: VariableSegment, value: "thumbprint"),
               (kind: ConstantSegment, value: ")/canceldelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificateCancelDeletion_574306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## If you try to delete a Certificate that is being used by a Pool or Compute Node, the status of the Certificate changes to deleteFailed. If you decide that you want to continue using the Certificate, you can use this operation to set the status of the Certificate back to active. If you intend to delete the Certificate, you do not need to run this operation after the deletion failed. You must make sure that the Certificate is not being used by any resources, and then you can try again to delete the Certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thumbprintAlgorithm: JString (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: JString (required)
  ##             : The thumbprint of the Certificate being deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `thumbprintAlgorithm` field"
  var valid_574308 = path.getOrDefault("thumbprintAlgorithm")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "thumbprintAlgorithm", valid_574308
  var valid_574309 = path.getOrDefault("thumbprint")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "thumbprint", valid_574309
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574310 = query.getOrDefault("timeout")
  valid_574310 = validateParameter(valid_574310, JInt, required = false,
                                 default = newJInt(30))
  if valid_574310 != nil:
    section.add "timeout", valid_574310
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574311 = query.getOrDefault("api-version")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "api-version", valid_574311
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574312 = header.getOrDefault("client-request-id")
  valid_574312 = validateParameter(valid_574312, JString, required = false,
                                 default = nil)
  if valid_574312 != nil:
    section.add "client-request-id", valid_574312
  var valid_574313 = header.getOrDefault("ocp-date")
  valid_574313 = validateParameter(valid_574313, JString, required = false,
                                 default = nil)
  if valid_574313 != nil:
    section.add "ocp-date", valid_574313
  var valid_574314 = header.getOrDefault("return-client-request-id")
  valid_574314 = validateParameter(valid_574314, JBool, required = false,
                                 default = newJBool(false))
  if valid_574314 != nil:
    section.add "return-client-request-id", valid_574314
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574315: Call_CertificateCancelDeletion_574305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If you try to delete a Certificate that is being used by a Pool or Compute Node, the status of the Certificate changes to deleteFailed. If you decide that you want to continue using the Certificate, you can use this operation to set the status of the Certificate back to active. If you intend to delete the Certificate, you do not need to run this operation after the deletion failed. You must make sure that the Certificate is not being used by any resources, and then you can try again to delete the Certificate.
  ## 
  let valid = call_574315.validator(path, query, header, formData, body)
  let scheme = call_574315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574315.url(scheme.get, call_574315.host, call_574315.base,
                         call_574315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574315, url, valid)

proc call*(call_574316: Call_CertificateCancelDeletion_574305; apiVersion: string;
          thumbprintAlgorithm: string; thumbprint: string; timeout: int = 30): Recallable =
  ## certificateCancelDeletion
  ## If you try to delete a Certificate that is being used by a Pool or Compute Node, the status of the Certificate changes to deleteFailed. If you decide that you want to continue using the Certificate, you can use this operation to set the status of the Certificate back to active. If you intend to delete the Certificate, you do not need to run this operation after the deletion failed. You must make sure that the Certificate is not being used by any resources, and then you can try again to delete the Certificate.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   thumbprintAlgorithm: string (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: string (required)
  ##             : The thumbprint of the Certificate being deleted.
  var path_574317 = newJObject()
  var query_574318 = newJObject()
  add(query_574318, "timeout", newJInt(timeout))
  add(query_574318, "api-version", newJString(apiVersion))
  add(path_574317, "thumbprintAlgorithm", newJString(thumbprintAlgorithm))
  add(path_574317, "thumbprint", newJString(thumbprint))
  result = call_574316.call(path_574317, query_574318, nil, nil, nil)

var certificateCancelDeletion* = Call_CertificateCancelDeletion_574305(
    name: "certificateCancelDeletion", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})/canceldelete",
    validator: validate_CertificateCancelDeletion_574306, base: "",
    url: url_CertificateCancelDeletion_574307, schemes: {Scheme.Https})
type
  Call_JobAdd_574334 = ref object of OpenApiRestCall_573667
proc url_JobAdd_574336(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobAdd_574335(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## The Batch service supports two ways to control the work done as part of a Job. In the first approach, the user specifies a Job Manager Task. The Batch service launches this Task when it is ready to start the Job. The Job Manager Task controls all other Tasks that run under this Job, by using the Task APIs. In the second approach, the user directly controls the execution of Tasks under an active Job, by using the Task APIs. Also note: when naming Jobs, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574337 = query.getOrDefault("timeout")
  valid_574337 = validateParameter(valid_574337, JInt, required = false,
                                 default = newJInt(30))
  if valid_574337 != nil:
    section.add "timeout", valid_574337
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574338 = query.getOrDefault("api-version")
  valid_574338 = validateParameter(valid_574338, JString, required = true,
                                 default = nil)
  if valid_574338 != nil:
    section.add "api-version", valid_574338
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574339 = header.getOrDefault("client-request-id")
  valid_574339 = validateParameter(valid_574339, JString, required = false,
                                 default = nil)
  if valid_574339 != nil:
    section.add "client-request-id", valid_574339
  var valid_574340 = header.getOrDefault("ocp-date")
  valid_574340 = validateParameter(valid_574340, JString, required = false,
                                 default = nil)
  if valid_574340 != nil:
    section.add "ocp-date", valid_574340
  var valid_574341 = header.getOrDefault("return-client-request-id")
  valid_574341 = validateParameter(valid_574341, JBool, required = false,
                                 default = newJBool(false))
  if valid_574341 != nil:
    section.add "return-client-request-id", valid_574341
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   job: JObject (required)
  ##      : The Job to be added.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574343: Call_JobAdd_574334; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Batch service supports two ways to control the work done as part of a Job. In the first approach, the user specifies a Job Manager Task. The Batch service launches this Task when it is ready to start the Job. The Job Manager Task controls all other Tasks that run under this Job, by using the Task APIs. In the second approach, the user directly controls the execution of Tasks under an active Job, by using the Task APIs. Also note: when naming Jobs, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ## 
  let valid = call_574343.validator(path, query, header, formData, body)
  let scheme = call_574343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574343.url(scheme.get, call_574343.host, call_574343.base,
                         call_574343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574343, url, valid)

proc call*(call_574344: Call_JobAdd_574334; apiVersion: string; job: JsonNode;
          timeout: int = 30): Recallable =
  ## jobAdd
  ## The Batch service supports two ways to control the work done as part of a Job. In the first approach, the user specifies a Job Manager Task. The Batch service launches this Task when it is ready to start the Job. The Job Manager Task controls all other Tasks that run under this Job, by using the Task APIs. In the second approach, the user directly controls the execution of Tasks under an active Job, by using the Task APIs. Also note: when naming Jobs, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   job: JObject (required)
  ##      : The Job to be added.
  var query_574345 = newJObject()
  var body_574346 = newJObject()
  add(query_574345, "timeout", newJInt(timeout))
  add(query_574345, "api-version", newJString(apiVersion))
  if job != nil:
    body_574346 = job
  result = call_574344.call(nil, query_574345, nil, nil, body_574346)

var jobAdd* = Call_JobAdd_574334(name: "jobAdd", meth: HttpMethod.HttpPost,
                              host: "azure.local", route: "/jobs",
                              validator: validate_JobAdd_574335, base: "",
                              url: url_JobAdd_574336, schemes: {Scheme.Https})
type
  Call_JobList_574319 = ref object of OpenApiRestCall_573667
proc url_JobList_574321(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobList_574320(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 Jobs can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs.
  section = newJObject()
  var valid_574322 = query.getOrDefault("timeout")
  valid_574322 = validateParameter(valid_574322, JInt, required = false,
                                 default = newJInt(30))
  if valid_574322 != nil:
    section.add "timeout", valid_574322
  var valid_574323 = query.getOrDefault("$expand")
  valid_574323 = validateParameter(valid_574323, JString, required = false,
                                 default = nil)
  if valid_574323 != nil:
    section.add "$expand", valid_574323
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574324 = query.getOrDefault("api-version")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "api-version", valid_574324
  var valid_574325 = query.getOrDefault("maxresults")
  valid_574325 = validateParameter(valid_574325, JInt, required = false,
                                 default = newJInt(1000))
  if valid_574325 != nil:
    section.add "maxresults", valid_574325
  var valid_574326 = query.getOrDefault("$select")
  valid_574326 = validateParameter(valid_574326, JString, required = false,
                                 default = nil)
  if valid_574326 != nil:
    section.add "$select", valid_574326
  var valid_574327 = query.getOrDefault("$filter")
  valid_574327 = validateParameter(valid_574327, JString, required = false,
                                 default = nil)
  if valid_574327 != nil:
    section.add "$filter", valid_574327
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574328 = header.getOrDefault("client-request-id")
  valid_574328 = validateParameter(valid_574328, JString, required = false,
                                 default = nil)
  if valid_574328 != nil:
    section.add "client-request-id", valid_574328
  var valid_574329 = header.getOrDefault("ocp-date")
  valid_574329 = validateParameter(valid_574329, JString, required = false,
                                 default = nil)
  if valid_574329 != nil:
    section.add "ocp-date", valid_574329
  var valid_574330 = header.getOrDefault("return-client-request-id")
  valid_574330 = validateParameter(valid_574330, JBool, required = false,
                                 default = newJBool(false))
  if valid_574330 != nil:
    section.add "return-client-request-id", valid_574330
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574331: Call_JobList_574319; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574331.validator(path, query, header, formData, body)
  let scheme = call_574331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574331.url(scheme.get, call_574331.host, call_574331.base,
                         call_574331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574331, url, valid)

proc call*(call_574332: Call_JobList_574319; apiVersion: string; timeout: int = 30;
          Expand: string = ""; maxresults: int = 1000; Select: string = "";
          Filter: string = ""): Recallable =
  ## jobList
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 Jobs can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs.
  var query_574333 = newJObject()
  add(query_574333, "timeout", newJInt(timeout))
  add(query_574333, "$expand", newJString(Expand))
  add(query_574333, "api-version", newJString(apiVersion))
  add(query_574333, "maxresults", newJInt(maxresults))
  add(query_574333, "$select", newJString(Select))
  add(query_574333, "$filter", newJString(Filter))
  result = call_574332.call(nil, query_574333, nil, nil, nil)

var jobList* = Call_JobList_574319(name: "jobList", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/jobs",
                                validator: validate_JobList_574320, base: "",
                                url: url_JobList_574321, schemes: {Scheme.Https})
type
  Call_JobUpdate_574366 = ref object of OpenApiRestCall_573667
proc url_JobUpdate_574368(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobUpdate_574367(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## This fully replaces all the updatable properties of the Job. For example, if the Job has constraints associated with it and if constraints is not specified with this request, then the Batch service will remove the existing constraints.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job whose properties you want to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574369 = path.getOrDefault("jobId")
  valid_574369 = validateParameter(valid_574369, JString, required = true,
                                 default = nil)
  if valid_574369 != nil:
    section.add "jobId", valid_574369
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574370 = query.getOrDefault("timeout")
  valid_574370 = validateParameter(valid_574370, JInt, required = false,
                                 default = newJInt(30))
  if valid_574370 != nil:
    section.add "timeout", valid_574370
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574371 = query.getOrDefault("api-version")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "api-version", valid_574371
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574372 = header.getOrDefault("If-Match")
  valid_574372 = validateParameter(valid_574372, JString, required = false,
                                 default = nil)
  if valid_574372 != nil:
    section.add "If-Match", valid_574372
  var valid_574373 = header.getOrDefault("client-request-id")
  valid_574373 = validateParameter(valid_574373, JString, required = false,
                                 default = nil)
  if valid_574373 != nil:
    section.add "client-request-id", valid_574373
  var valid_574374 = header.getOrDefault("ocp-date")
  valid_574374 = validateParameter(valid_574374, JString, required = false,
                                 default = nil)
  if valid_574374 != nil:
    section.add "ocp-date", valid_574374
  var valid_574375 = header.getOrDefault("If-Unmodified-Since")
  valid_574375 = validateParameter(valid_574375, JString, required = false,
                                 default = nil)
  if valid_574375 != nil:
    section.add "If-Unmodified-Since", valid_574375
  var valid_574376 = header.getOrDefault("If-None-Match")
  valid_574376 = validateParameter(valid_574376, JString, required = false,
                                 default = nil)
  if valid_574376 != nil:
    section.add "If-None-Match", valid_574376
  var valid_574377 = header.getOrDefault("If-Modified-Since")
  valid_574377 = validateParameter(valid_574377, JString, required = false,
                                 default = nil)
  if valid_574377 != nil:
    section.add "If-Modified-Since", valid_574377
  var valid_574378 = header.getOrDefault("return-client-request-id")
  valid_574378 = validateParameter(valid_574378, JBool, required = false,
                                 default = newJBool(false))
  if valid_574378 != nil:
    section.add "return-client-request-id", valid_574378
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobUpdateParameter: JObject (required)
  ##                     : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574380: Call_JobUpdate_574366; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This fully replaces all the updatable properties of the Job. For example, if the Job has constraints associated with it and if constraints is not specified with this request, then the Batch service will remove the existing constraints.
  ## 
  let valid = call_574380.validator(path, query, header, formData, body)
  let scheme = call_574380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574380.url(scheme.get, call_574380.host, call_574380.base,
                         call_574380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574380, url, valid)

proc call*(call_574381: Call_JobUpdate_574366; jobUpdateParameter: JsonNode;
          apiVersion: string; jobId: string; timeout: int = 30): Recallable =
  ## jobUpdate
  ## This fully replaces all the updatable properties of the Job. For example, if the Job has constraints associated with it and if constraints is not specified with this request, then the Batch service will remove the existing constraints.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobUpdateParameter: JObject (required)
  ##                     : The parameters for the request.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job whose properties you want to update.
  var path_574382 = newJObject()
  var query_574383 = newJObject()
  var body_574384 = newJObject()
  add(query_574383, "timeout", newJInt(timeout))
  if jobUpdateParameter != nil:
    body_574384 = jobUpdateParameter
  add(query_574383, "api-version", newJString(apiVersion))
  add(path_574382, "jobId", newJString(jobId))
  result = call_574381.call(path_574382, query_574383, nil, nil, body_574384)

var jobUpdate* = Call_JobUpdate_574366(name: "jobUpdate", meth: HttpMethod.HttpPut,
                                    host: "azure.local", route: "/jobs/{jobId}",
                                    validator: validate_JobUpdate_574367,
                                    base: "", url: url_JobUpdate_574368,
                                    schemes: {Scheme.Https})
type
  Call_JobGet_574347 = ref object of OpenApiRestCall_573667
proc url_JobGet_574349(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGet_574348(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574350 = path.getOrDefault("jobId")
  valid_574350 = validateParameter(valid_574350, JString, required = true,
                                 default = nil)
  if valid_574350 != nil:
    section.add "jobId", valid_574350
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_574351 = query.getOrDefault("timeout")
  valid_574351 = validateParameter(valid_574351, JInt, required = false,
                                 default = newJInt(30))
  if valid_574351 != nil:
    section.add "timeout", valid_574351
  var valid_574352 = query.getOrDefault("$expand")
  valid_574352 = validateParameter(valid_574352, JString, required = false,
                                 default = nil)
  if valid_574352 != nil:
    section.add "$expand", valid_574352
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574353 = query.getOrDefault("api-version")
  valid_574353 = validateParameter(valid_574353, JString, required = true,
                                 default = nil)
  if valid_574353 != nil:
    section.add "api-version", valid_574353
  var valid_574354 = query.getOrDefault("$select")
  valid_574354 = validateParameter(valid_574354, JString, required = false,
                                 default = nil)
  if valid_574354 != nil:
    section.add "$select", valid_574354
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574355 = header.getOrDefault("If-Match")
  valid_574355 = validateParameter(valid_574355, JString, required = false,
                                 default = nil)
  if valid_574355 != nil:
    section.add "If-Match", valid_574355
  var valid_574356 = header.getOrDefault("client-request-id")
  valid_574356 = validateParameter(valid_574356, JString, required = false,
                                 default = nil)
  if valid_574356 != nil:
    section.add "client-request-id", valid_574356
  var valid_574357 = header.getOrDefault("ocp-date")
  valid_574357 = validateParameter(valid_574357, JString, required = false,
                                 default = nil)
  if valid_574357 != nil:
    section.add "ocp-date", valid_574357
  var valid_574358 = header.getOrDefault("If-Unmodified-Since")
  valid_574358 = validateParameter(valid_574358, JString, required = false,
                                 default = nil)
  if valid_574358 != nil:
    section.add "If-Unmodified-Since", valid_574358
  var valid_574359 = header.getOrDefault("If-None-Match")
  valid_574359 = validateParameter(valid_574359, JString, required = false,
                                 default = nil)
  if valid_574359 != nil:
    section.add "If-None-Match", valid_574359
  var valid_574360 = header.getOrDefault("If-Modified-Since")
  valid_574360 = validateParameter(valid_574360, JString, required = false,
                                 default = nil)
  if valid_574360 != nil:
    section.add "If-Modified-Since", valid_574360
  var valid_574361 = header.getOrDefault("return-client-request-id")
  valid_574361 = validateParameter(valid_574361, JBool, required = false,
                                 default = newJBool(false))
  if valid_574361 != nil:
    section.add "return-client-request-id", valid_574361
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574362: Call_JobGet_574347; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574362.validator(path, query, header, formData, body)
  let scheme = call_574362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574362.url(scheme.get, call_574362.host, call_574362.base,
                         call_574362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574362, url, valid)

proc call*(call_574363: Call_JobGet_574347; apiVersion: string; jobId: string;
          timeout: int = 30; Expand: string = ""; Select: string = ""): Recallable =
  ## jobGet
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job.
  ##   Select: string
  ##         : An OData $select clause.
  var path_574364 = newJObject()
  var query_574365 = newJObject()
  add(query_574365, "timeout", newJInt(timeout))
  add(query_574365, "$expand", newJString(Expand))
  add(query_574365, "api-version", newJString(apiVersion))
  add(path_574364, "jobId", newJString(jobId))
  add(query_574365, "$select", newJString(Select))
  result = call_574363.call(path_574364, query_574365, nil, nil, nil)

var jobGet* = Call_JobGet_574347(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "azure.local", route: "/jobs/{jobId}",
                              validator: validate_JobGet_574348, base: "",
                              url: url_JobGet_574349, schemes: {Scheme.Https})
type
  Call_JobPatch_574402 = ref object of OpenApiRestCall_573667
proc url_JobPatch_574404(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobPatch_574403(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## This replaces only the Job properties specified in the request. For example, if the Job has constraints, and a request does not specify the constraints element, then the Job keeps the existing constraints.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job whose properties you want to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574405 = path.getOrDefault("jobId")
  valid_574405 = validateParameter(valid_574405, JString, required = true,
                                 default = nil)
  if valid_574405 != nil:
    section.add "jobId", valid_574405
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574406 = query.getOrDefault("timeout")
  valid_574406 = validateParameter(valid_574406, JInt, required = false,
                                 default = newJInt(30))
  if valid_574406 != nil:
    section.add "timeout", valid_574406
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574407 = query.getOrDefault("api-version")
  valid_574407 = validateParameter(valid_574407, JString, required = true,
                                 default = nil)
  if valid_574407 != nil:
    section.add "api-version", valid_574407
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574408 = header.getOrDefault("If-Match")
  valid_574408 = validateParameter(valid_574408, JString, required = false,
                                 default = nil)
  if valid_574408 != nil:
    section.add "If-Match", valid_574408
  var valid_574409 = header.getOrDefault("client-request-id")
  valid_574409 = validateParameter(valid_574409, JString, required = false,
                                 default = nil)
  if valid_574409 != nil:
    section.add "client-request-id", valid_574409
  var valid_574410 = header.getOrDefault("ocp-date")
  valid_574410 = validateParameter(valid_574410, JString, required = false,
                                 default = nil)
  if valid_574410 != nil:
    section.add "ocp-date", valid_574410
  var valid_574411 = header.getOrDefault("If-Unmodified-Since")
  valid_574411 = validateParameter(valid_574411, JString, required = false,
                                 default = nil)
  if valid_574411 != nil:
    section.add "If-Unmodified-Since", valid_574411
  var valid_574412 = header.getOrDefault("If-None-Match")
  valid_574412 = validateParameter(valid_574412, JString, required = false,
                                 default = nil)
  if valid_574412 != nil:
    section.add "If-None-Match", valid_574412
  var valid_574413 = header.getOrDefault("If-Modified-Since")
  valid_574413 = validateParameter(valid_574413, JString, required = false,
                                 default = nil)
  if valid_574413 != nil:
    section.add "If-Modified-Since", valid_574413
  var valid_574414 = header.getOrDefault("return-client-request-id")
  valid_574414 = validateParameter(valid_574414, JBool, required = false,
                                 default = newJBool(false))
  if valid_574414 != nil:
    section.add "return-client-request-id", valid_574414
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobPatchParameter: JObject (required)
  ##                    : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574416: Call_JobPatch_574402; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This replaces only the Job properties specified in the request. For example, if the Job has constraints, and a request does not specify the constraints element, then the Job keeps the existing constraints.
  ## 
  let valid = call_574416.validator(path, query, header, formData, body)
  let scheme = call_574416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574416.url(scheme.get, call_574416.host, call_574416.base,
                         call_574416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574416, url, valid)

proc call*(call_574417: Call_JobPatch_574402; apiVersion: string; jobId: string;
          jobPatchParameter: JsonNode; timeout: int = 30): Recallable =
  ## jobPatch
  ## This replaces only the Job properties specified in the request. For example, if the Job has constraints, and a request does not specify the constraints element, then the Job keeps the existing constraints.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job whose properties you want to update.
  ##   jobPatchParameter: JObject (required)
  ##                    : The parameters for the request.
  var path_574418 = newJObject()
  var query_574419 = newJObject()
  var body_574420 = newJObject()
  add(query_574419, "timeout", newJInt(timeout))
  add(query_574419, "api-version", newJString(apiVersion))
  add(path_574418, "jobId", newJString(jobId))
  if jobPatchParameter != nil:
    body_574420 = jobPatchParameter
  result = call_574417.call(path_574418, query_574419, nil, nil, body_574420)

var jobPatch* = Call_JobPatch_574402(name: "jobPatch", meth: HttpMethod.HttpPatch,
                                  host: "azure.local", route: "/jobs/{jobId}",
                                  validator: validate_JobPatch_574403, base: "",
                                  url: url_JobPatch_574404,
                                  schemes: {Scheme.Https})
type
  Call_JobDelete_574385 = ref object of OpenApiRestCall_573667
proc url_JobDelete_574387(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobDelete_574386(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Deleting a Job also deletes all Tasks that are part of that Job, and all Job statistics. This also overrides the retention period for Task data; that is, if the Job contains Tasks which are still retained on Compute Nodes, the Batch services deletes those Tasks' working directories and all their contents.  When a Delete Job request is received, the Batch service sets the Job to the deleting state. All update operations on a Job that is in deleting state will fail with status code 409 (Conflict), with additional information indicating that the Job is being deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574388 = path.getOrDefault("jobId")
  valid_574388 = validateParameter(valid_574388, JString, required = true,
                                 default = nil)
  if valid_574388 != nil:
    section.add "jobId", valid_574388
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574389 = query.getOrDefault("timeout")
  valid_574389 = validateParameter(valid_574389, JInt, required = false,
                                 default = newJInt(30))
  if valid_574389 != nil:
    section.add "timeout", valid_574389
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574390 = query.getOrDefault("api-version")
  valid_574390 = validateParameter(valid_574390, JString, required = true,
                                 default = nil)
  if valid_574390 != nil:
    section.add "api-version", valid_574390
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574391 = header.getOrDefault("If-Match")
  valid_574391 = validateParameter(valid_574391, JString, required = false,
                                 default = nil)
  if valid_574391 != nil:
    section.add "If-Match", valid_574391
  var valid_574392 = header.getOrDefault("client-request-id")
  valid_574392 = validateParameter(valid_574392, JString, required = false,
                                 default = nil)
  if valid_574392 != nil:
    section.add "client-request-id", valid_574392
  var valid_574393 = header.getOrDefault("ocp-date")
  valid_574393 = validateParameter(valid_574393, JString, required = false,
                                 default = nil)
  if valid_574393 != nil:
    section.add "ocp-date", valid_574393
  var valid_574394 = header.getOrDefault("If-Unmodified-Since")
  valid_574394 = validateParameter(valid_574394, JString, required = false,
                                 default = nil)
  if valid_574394 != nil:
    section.add "If-Unmodified-Since", valid_574394
  var valid_574395 = header.getOrDefault("If-None-Match")
  valid_574395 = validateParameter(valid_574395, JString, required = false,
                                 default = nil)
  if valid_574395 != nil:
    section.add "If-None-Match", valid_574395
  var valid_574396 = header.getOrDefault("If-Modified-Since")
  valid_574396 = validateParameter(valid_574396, JString, required = false,
                                 default = nil)
  if valid_574396 != nil:
    section.add "If-Modified-Since", valid_574396
  var valid_574397 = header.getOrDefault("return-client-request-id")
  valid_574397 = validateParameter(valid_574397, JBool, required = false,
                                 default = newJBool(false))
  if valid_574397 != nil:
    section.add "return-client-request-id", valid_574397
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574398: Call_JobDelete_574385; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deleting a Job also deletes all Tasks that are part of that Job, and all Job statistics. This also overrides the retention period for Task data; that is, if the Job contains Tasks which are still retained on Compute Nodes, the Batch services deletes those Tasks' working directories and all their contents.  When a Delete Job request is received, the Batch service sets the Job to the deleting state. All update operations on a Job that is in deleting state will fail with status code 409 (Conflict), with additional information indicating that the Job is being deleted.
  ## 
  let valid = call_574398.validator(path, query, header, formData, body)
  let scheme = call_574398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574398.url(scheme.get, call_574398.host, call_574398.base,
                         call_574398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574398, url, valid)

proc call*(call_574399: Call_JobDelete_574385; apiVersion: string; jobId: string;
          timeout: int = 30): Recallable =
  ## jobDelete
  ## Deleting a Job also deletes all Tasks that are part of that Job, and all Job statistics. This also overrides the retention period for Task data; that is, if the Job contains Tasks which are still retained on Compute Nodes, the Batch services deletes those Tasks' working directories and all their contents.  When a Delete Job request is received, the Batch service sets the Job to the deleting state. All update operations on a Job that is in deleting state will fail with status code 409 (Conflict), with additional information indicating that the Job is being deleted.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job to delete.
  var path_574400 = newJObject()
  var query_574401 = newJObject()
  add(query_574401, "timeout", newJInt(timeout))
  add(query_574401, "api-version", newJString(apiVersion))
  add(path_574400, "jobId", newJString(jobId))
  result = call_574399.call(path_574400, query_574401, nil, nil, nil)

var jobDelete* = Call_JobDelete_574385(name: "jobDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local", route: "/jobs/{jobId}",
                                    validator: validate_JobDelete_574386,
                                    base: "", url: url_JobDelete_574387,
                                    schemes: {Scheme.Https})
type
  Call_TaskAddCollection_574421 = ref object of OpenApiRestCall_573667
proc url_TaskAddCollection_574423(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/addtaskcollection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskAddCollection_574422(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Note that each Task must have a unique ID. The Batch service may not return the results for each Task in the same order the Tasks were submitted in this request. If the server times out or the connection is closed during the request, the request may have been partially or fully processed, or not at all. In such cases, the user should re-issue the request. Note that it is up to the user to correctly handle failures when re-issuing a request. For example, you should use the same Task IDs during a retry so that if the prior operation succeeded, the retry will not create extra Tasks unexpectedly. If the response contains any Tasks which failed to add, a client can retry the request. In a retry, it is most efficient to resubmit only Tasks that failed to add, and to omit Tasks that were successfully added on the first attempt. The maximum lifetime of a Task from addition to completion is 180 days. If a Task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job to which the Task collection is to be added.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574434 = path.getOrDefault("jobId")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "jobId", valid_574434
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574435 = query.getOrDefault("timeout")
  valid_574435 = validateParameter(valid_574435, JInt, required = false,
                                 default = newJInt(30))
  if valid_574435 != nil:
    section.add "timeout", valid_574435
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574436 = query.getOrDefault("api-version")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "api-version", valid_574436
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574437 = header.getOrDefault("client-request-id")
  valid_574437 = validateParameter(valid_574437, JString, required = false,
                                 default = nil)
  if valid_574437 != nil:
    section.add "client-request-id", valid_574437
  var valid_574438 = header.getOrDefault("ocp-date")
  valid_574438 = validateParameter(valid_574438, JString, required = false,
                                 default = nil)
  if valid_574438 != nil:
    section.add "ocp-date", valid_574438
  var valid_574439 = header.getOrDefault("return-client-request-id")
  valid_574439 = validateParameter(valid_574439, JBool, required = false,
                                 default = newJBool(false))
  if valid_574439 != nil:
    section.add "return-client-request-id", valid_574439
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   taskCollection: JObject (required)
  ##                 : The Tasks to be added.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574441: Call_TaskAddCollection_574421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Note that each Task must have a unique ID. The Batch service may not return the results for each Task in the same order the Tasks were submitted in this request. If the server times out or the connection is closed during the request, the request may have been partially or fully processed, or not at all. In such cases, the user should re-issue the request. Note that it is up to the user to correctly handle failures when re-issuing a request. For example, you should use the same Task IDs during a retry so that if the prior operation succeeded, the retry will not create extra Tasks unexpectedly. If the response contains any Tasks which failed to add, a client can retry the request. In a retry, it is most efficient to resubmit only Tasks that failed to add, and to omit Tasks that were successfully added on the first attempt. The maximum lifetime of a Task from addition to completion is 180 days. If a Task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ## 
  let valid = call_574441.validator(path, query, header, formData, body)
  let scheme = call_574441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574441.url(scheme.get, call_574441.host, call_574441.base,
                         call_574441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574441, url, valid)

proc call*(call_574442: Call_TaskAddCollection_574421; apiVersion: string;
          jobId: string; taskCollection: JsonNode; timeout: int = 30): Recallable =
  ## taskAddCollection
  ## Note that each Task must have a unique ID. The Batch service may not return the results for each Task in the same order the Tasks were submitted in this request. If the server times out or the connection is closed during the request, the request may have been partially or fully processed, or not at all. In such cases, the user should re-issue the request. Note that it is up to the user to correctly handle failures when re-issuing a request. For example, you should use the same Task IDs during a retry so that if the prior operation succeeded, the retry will not create extra Tasks unexpectedly. If the response contains any Tasks which failed to add, a client can retry the request. In a retry, it is most efficient to resubmit only Tasks that failed to add, and to omit Tasks that were successfully added on the first attempt. The maximum lifetime of a Task from addition to completion is 180 days. If a Task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job to which the Task collection is to be added.
  ##   taskCollection: JObject (required)
  ##                 : The Tasks to be added.
  var path_574443 = newJObject()
  var query_574444 = newJObject()
  var body_574445 = newJObject()
  add(query_574444, "timeout", newJInt(timeout))
  add(query_574444, "api-version", newJString(apiVersion))
  add(path_574443, "jobId", newJString(jobId))
  if taskCollection != nil:
    body_574445 = taskCollection
  result = call_574442.call(path_574443, query_574444, nil, nil, body_574445)

var taskAddCollection* = Call_TaskAddCollection_574421(name: "taskAddCollection",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/addtaskcollection",
    validator: validate_TaskAddCollection_574422, base: "",
    url: url_TaskAddCollection_574423, schemes: {Scheme.Https})
type
  Call_JobDisable_574446 = ref object of OpenApiRestCall_573667
proc url_JobDisable_574448(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobDisable_574447(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The Batch Service immediately moves the Job to the disabling state. Batch then uses the disableTasks parameter to determine what to do with the currently running Tasks of the Job. The Job remains in the disabling state until the disable operation is completed and all Tasks have been dealt with according to the disableTasks option; the Job then moves to the disabled state. No new Tasks are started under the Job until it moves back to active state. If you try to disable a Job that is in any state other than active, disabling, or disabled, the request fails with status code 409.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job to disable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574449 = path.getOrDefault("jobId")
  valid_574449 = validateParameter(valid_574449, JString, required = true,
                                 default = nil)
  if valid_574449 != nil:
    section.add "jobId", valid_574449
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574450 = query.getOrDefault("timeout")
  valid_574450 = validateParameter(valid_574450, JInt, required = false,
                                 default = newJInt(30))
  if valid_574450 != nil:
    section.add "timeout", valid_574450
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574451 = query.getOrDefault("api-version")
  valid_574451 = validateParameter(valid_574451, JString, required = true,
                                 default = nil)
  if valid_574451 != nil:
    section.add "api-version", valid_574451
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574452 = header.getOrDefault("If-Match")
  valid_574452 = validateParameter(valid_574452, JString, required = false,
                                 default = nil)
  if valid_574452 != nil:
    section.add "If-Match", valid_574452
  var valid_574453 = header.getOrDefault("client-request-id")
  valid_574453 = validateParameter(valid_574453, JString, required = false,
                                 default = nil)
  if valid_574453 != nil:
    section.add "client-request-id", valid_574453
  var valid_574454 = header.getOrDefault("ocp-date")
  valid_574454 = validateParameter(valid_574454, JString, required = false,
                                 default = nil)
  if valid_574454 != nil:
    section.add "ocp-date", valid_574454
  var valid_574455 = header.getOrDefault("If-Unmodified-Since")
  valid_574455 = validateParameter(valid_574455, JString, required = false,
                                 default = nil)
  if valid_574455 != nil:
    section.add "If-Unmodified-Since", valid_574455
  var valid_574456 = header.getOrDefault("If-None-Match")
  valid_574456 = validateParameter(valid_574456, JString, required = false,
                                 default = nil)
  if valid_574456 != nil:
    section.add "If-None-Match", valid_574456
  var valid_574457 = header.getOrDefault("If-Modified-Since")
  valid_574457 = validateParameter(valid_574457, JString, required = false,
                                 default = nil)
  if valid_574457 != nil:
    section.add "If-Modified-Since", valid_574457
  var valid_574458 = header.getOrDefault("return-client-request-id")
  valid_574458 = validateParameter(valid_574458, JBool, required = false,
                                 default = newJBool(false))
  if valid_574458 != nil:
    section.add "return-client-request-id", valid_574458
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobDisableParameter: JObject (required)
  ##                      : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574460: Call_JobDisable_574446; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Batch Service immediately moves the Job to the disabling state. Batch then uses the disableTasks parameter to determine what to do with the currently running Tasks of the Job. The Job remains in the disabling state until the disable operation is completed and all Tasks have been dealt with according to the disableTasks option; the Job then moves to the disabled state. No new Tasks are started under the Job until it moves back to active state. If you try to disable a Job that is in any state other than active, disabling, or disabled, the request fails with status code 409.
  ## 
  let valid = call_574460.validator(path, query, header, formData, body)
  let scheme = call_574460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574460.url(scheme.get, call_574460.host, call_574460.base,
                         call_574460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574460, url, valid)

proc call*(call_574461: Call_JobDisable_574446; apiVersion: string; jobId: string;
          jobDisableParameter: JsonNode; timeout: int = 30): Recallable =
  ## jobDisable
  ## The Batch Service immediately moves the Job to the disabling state. Batch then uses the disableTasks parameter to determine what to do with the currently running Tasks of the Job. The Job remains in the disabling state until the disable operation is completed and all Tasks have been dealt with according to the disableTasks option; the Job then moves to the disabled state. No new Tasks are started under the Job until it moves back to active state. If you try to disable a Job that is in any state other than active, disabling, or disabled, the request fails with status code 409.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job to disable.
  ##   jobDisableParameter: JObject (required)
  ##                      : The parameters for the request.
  var path_574462 = newJObject()
  var query_574463 = newJObject()
  var body_574464 = newJObject()
  add(query_574463, "timeout", newJInt(timeout))
  add(query_574463, "api-version", newJString(apiVersion))
  add(path_574462, "jobId", newJString(jobId))
  if jobDisableParameter != nil:
    body_574464 = jobDisableParameter
  result = call_574461.call(path_574462, query_574463, nil, nil, body_574464)

var jobDisable* = Call_JobDisable_574446(name: "jobDisable",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local",
                                      route: "/jobs/{jobId}/disable",
                                      validator: validate_JobDisable_574447,
                                      base: "", url: url_JobDisable_574448,
                                      schemes: {Scheme.Https})
type
  Call_JobEnable_574465 = ref object of OpenApiRestCall_573667
proc url_JobEnable_574467(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/enable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobEnable_574466(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## When you call this API, the Batch service sets a disabled Job to the enabling state. After the this operation is completed, the Job moves to the active state, and scheduling of new Tasks under the Job resumes. The Batch service does not allow a Task to remain in the active state for more than 180 days. Therefore, if you enable a Job containing active Tasks which were added more than 180 days ago, those Tasks will not run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job to enable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574468 = path.getOrDefault("jobId")
  valid_574468 = validateParameter(valid_574468, JString, required = true,
                                 default = nil)
  if valid_574468 != nil:
    section.add "jobId", valid_574468
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574469 = query.getOrDefault("timeout")
  valid_574469 = validateParameter(valid_574469, JInt, required = false,
                                 default = newJInt(30))
  if valid_574469 != nil:
    section.add "timeout", valid_574469
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574470 = query.getOrDefault("api-version")
  valid_574470 = validateParameter(valid_574470, JString, required = true,
                                 default = nil)
  if valid_574470 != nil:
    section.add "api-version", valid_574470
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574471 = header.getOrDefault("If-Match")
  valid_574471 = validateParameter(valid_574471, JString, required = false,
                                 default = nil)
  if valid_574471 != nil:
    section.add "If-Match", valid_574471
  var valid_574472 = header.getOrDefault("client-request-id")
  valid_574472 = validateParameter(valid_574472, JString, required = false,
                                 default = nil)
  if valid_574472 != nil:
    section.add "client-request-id", valid_574472
  var valid_574473 = header.getOrDefault("ocp-date")
  valid_574473 = validateParameter(valid_574473, JString, required = false,
                                 default = nil)
  if valid_574473 != nil:
    section.add "ocp-date", valid_574473
  var valid_574474 = header.getOrDefault("If-Unmodified-Since")
  valid_574474 = validateParameter(valid_574474, JString, required = false,
                                 default = nil)
  if valid_574474 != nil:
    section.add "If-Unmodified-Since", valid_574474
  var valid_574475 = header.getOrDefault("If-None-Match")
  valid_574475 = validateParameter(valid_574475, JString, required = false,
                                 default = nil)
  if valid_574475 != nil:
    section.add "If-None-Match", valid_574475
  var valid_574476 = header.getOrDefault("If-Modified-Since")
  valid_574476 = validateParameter(valid_574476, JString, required = false,
                                 default = nil)
  if valid_574476 != nil:
    section.add "If-Modified-Since", valid_574476
  var valid_574477 = header.getOrDefault("return-client-request-id")
  valid_574477 = validateParameter(valid_574477, JBool, required = false,
                                 default = newJBool(false))
  if valid_574477 != nil:
    section.add "return-client-request-id", valid_574477
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574478: Call_JobEnable_574465; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you call this API, the Batch service sets a disabled Job to the enabling state. After the this operation is completed, the Job moves to the active state, and scheduling of new Tasks under the Job resumes. The Batch service does not allow a Task to remain in the active state for more than 180 days. Therefore, if you enable a Job containing active Tasks which were added more than 180 days ago, those Tasks will not run.
  ## 
  let valid = call_574478.validator(path, query, header, formData, body)
  let scheme = call_574478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574478.url(scheme.get, call_574478.host, call_574478.base,
                         call_574478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574478, url, valid)

proc call*(call_574479: Call_JobEnable_574465; apiVersion: string; jobId: string;
          timeout: int = 30): Recallable =
  ## jobEnable
  ## When you call this API, the Batch service sets a disabled Job to the enabling state. After the this operation is completed, the Job moves to the active state, and scheduling of new Tasks under the Job resumes. The Batch service does not allow a Task to remain in the active state for more than 180 days. Therefore, if you enable a Job containing active Tasks which were added more than 180 days ago, those Tasks will not run.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job to enable.
  var path_574480 = newJObject()
  var query_574481 = newJObject()
  add(query_574481, "timeout", newJInt(timeout))
  add(query_574481, "api-version", newJString(apiVersion))
  add(path_574480, "jobId", newJString(jobId))
  result = call_574479.call(path_574480, query_574481, nil, nil, nil)

var jobEnable* = Call_JobEnable_574465(name: "jobEnable", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/jobs/{jobId}/enable",
                                    validator: validate_JobEnable_574466,
                                    base: "", url: url_JobEnable_574467,
                                    schemes: {Scheme.Https})
type
  Call_JobListPreparationAndReleaseTaskStatus_574482 = ref object of OpenApiRestCall_573667
proc url_JobListPreparationAndReleaseTaskStatus_574484(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"), (kind: ConstantSegment,
        value: "/jobpreparationandreleasetaskstatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobListPreparationAndReleaseTaskStatus_574483(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This API returns the Job Preparation and Job Release Task status on all Compute Nodes that have run the Job Preparation or Job Release Task. This includes Compute Nodes which have since been removed from the Pool. If this API is invoked on a Job which has no Job Preparation or Job Release Task, the Batch service returns HTTP status code 409 (Conflict) with an error code of JobPreparationTaskNotSpecified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574485 = path.getOrDefault("jobId")
  valid_574485 = validateParameter(valid_574485, JString, required = true,
                                 default = nil)
  if valid_574485 != nil:
    section.add "jobId", valid_574485
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 Tasks can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-preparation-and-release-status.
  section = newJObject()
  var valid_574486 = query.getOrDefault("timeout")
  valid_574486 = validateParameter(valid_574486, JInt, required = false,
                                 default = newJInt(30))
  if valid_574486 != nil:
    section.add "timeout", valid_574486
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574487 = query.getOrDefault("api-version")
  valid_574487 = validateParameter(valid_574487, JString, required = true,
                                 default = nil)
  if valid_574487 != nil:
    section.add "api-version", valid_574487
  var valid_574488 = query.getOrDefault("maxresults")
  valid_574488 = validateParameter(valid_574488, JInt, required = false,
                                 default = newJInt(1000))
  if valid_574488 != nil:
    section.add "maxresults", valid_574488
  var valid_574489 = query.getOrDefault("$select")
  valid_574489 = validateParameter(valid_574489, JString, required = false,
                                 default = nil)
  if valid_574489 != nil:
    section.add "$select", valid_574489
  var valid_574490 = query.getOrDefault("$filter")
  valid_574490 = validateParameter(valid_574490, JString, required = false,
                                 default = nil)
  if valid_574490 != nil:
    section.add "$filter", valid_574490
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574491 = header.getOrDefault("client-request-id")
  valid_574491 = validateParameter(valid_574491, JString, required = false,
                                 default = nil)
  if valid_574491 != nil:
    section.add "client-request-id", valid_574491
  var valid_574492 = header.getOrDefault("ocp-date")
  valid_574492 = validateParameter(valid_574492, JString, required = false,
                                 default = nil)
  if valid_574492 != nil:
    section.add "ocp-date", valid_574492
  var valid_574493 = header.getOrDefault("return-client-request-id")
  valid_574493 = validateParameter(valid_574493, JBool, required = false,
                                 default = newJBool(false))
  if valid_574493 != nil:
    section.add "return-client-request-id", valid_574493
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574494: Call_JobListPreparationAndReleaseTaskStatus_574482;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This API returns the Job Preparation and Job Release Task status on all Compute Nodes that have run the Job Preparation or Job Release Task. This includes Compute Nodes which have since been removed from the Pool. If this API is invoked on a Job which has no Job Preparation or Job Release Task, the Batch service returns HTTP status code 409 (Conflict) with an error code of JobPreparationTaskNotSpecified.
  ## 
  let valid = call_574494.validator(path, query, header, formData, body)
  let scheme = call_574494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574494.url(scheme.get, call_574494.host, call_574494.base,
                         call_574494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574494, url, valid)

proc call*(call_574495: Call_JobListPreparationAndReleaseTaskStatus_574482;
          apiVersion: string; jobId: string; timeout: int = 30; maxresults: int = 1000;
          Select: string = ""; Filter: string = ""): Recallable =
  ## jobListPreparationAndReleaseTaskStatus
  ## This API returns the Job Preparation and Job Release Task status on all Compute Nodes that have run the Job Preparation or Job Release Task. This includes Compute Nodes which have since been removed from the Pool. If this API is invoked on a Job which has no Job Preparation or Job Release Task, the Batch service returns HTTP status code 409 (Conflict) with an error code of JobPreparationTaskNotSpecified.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 Tasks can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-preparation-and-release-status.
  var path_574496 = newJObject()
  var query_574497 = newJObject()
  add(query_574497, "timeout", newJInt(timeout))
  add(query_574497, "api-version", newJString(apiVersion))
  add(path_574496, "jobId", newJString(jobId))
  add(query_574497, "maxresults", newJInt(maxresults))
  add(query_574497, "$select", newJString(Select))
  add(query_574497, "$filter", newJString(Filter))
  result = call_574495.call(path_574496, query_574497, nil, nil, nil)

var jobListPreparationAndReleaseTaskStatus* = Call_JobListPreparationAndReleaseTaskStatus_574482(
    name: "jobListPreparationAndReleaseTaskStatus", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/jobs/{jobId}/jobpreparationandreleasetaskstatus",
    validator: validate_JobListPreparationAndReleaseTaskStatus_574483, base: "",
    url: url_JobListPreparationAndReleaseTaskStatus_574484,
    schemes: {Scheme.Https})
type
  Call_JobGetTaskCounts_574498 = ref object of OpenApiRestCall_573667
proc url_JobGetTaskCounts_574500(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/taskcounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobGetTaskCounts_574499(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Task counts provide a count of the Tasks by active, running or completed Task state, and a count of Tasks which succeeded or failed. Tasks in the preparing state are counted as running.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574501 = path.getOrDefault("jobId")
  valid_574501 = validateParameter(valid_574501, JString, required = true,
                                 default = nil)
  if valid_574501 != nil:
    section.add "jobId", valid_574501
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574502 = query.getOrDefault("timeout")
  valid_574502 = validateParameter(valid_574502, JInt, required = false,
                                 default = newJInt(30))
  if valid_574502 != nil:
    section.add "timeout", valid_574502
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574503 = query.getOrDefault("api-version")
  valid_574503 = validateParameter(valid_574503, JString, required = true,
                                 default = nil)
  if valid_574503 != nil:
    section.add "api-version", valid_574503
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574504 = header.getOrDefault("client-request-id")
  valid_574504 = validateParameter(valid_574504, JString, required = false,
                                 default = nil)
  if valid_574504 != nil:
    section.add "client-request-id", valid_574504
  var valid_574505 = header.getOrDefault("ocp-date")
  valid_574505 = validateParameter(valid_574505, JString, required = false,
                                 default = nil)
  if valid_574505 != nil:
    section.add "ocp-date", valid_574505
  var valid_574506 = header.getOrDefault("return-client-request-id")
  valid_574506 = validateParameter(valid_574506, JBool, required = false,
                                 default = newJBool(false))
  if valid_574506 != nil:
    section.add "return-client-request-id", valid_574506
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574507: Call_JobGetTaskCounts_574498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Task counts provide a count of the Tasks by active, running or completed Task state, and a count of Tasks which succeeded or failed. Tasks in the preparing state are counted as running.
  ## 
  let valid = call_574507.validator(path, query, header, formData, body)
  let scheme = call_574507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574507.url(scheme.get, call_574507.host, call_574507.base,
                         call_574507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574507, url, valid)

proc call*(call_574508: Call_JobGetTaskCounts_574498; apiVersion: string;
          jobId: string; timeout: int = 30): Recallable =
  ## jobGetTaskCounts
  ## Task counts provide a count of the Tasks by active, running or completed Task state, and a count of Tasks which succeeded or failed. Tasks in the preparing state are counted as running.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job.
  var path_574509 = newJObject()
  var query_574510 = newJObject()
  add(query_574510, "timeout", newJInt(timeout))
  add(query_574510, "api-version", newJString(apiVersion))
  add(path_574509, "jobId", newJString(jobId))
  result = call_574508.call(path_574509, query_574510, nil, nil, nil)

var jobGetTaskCounts* = Call_JobGetTaskCounts_574498(name: "jobGetTaskCounts",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/taskcounts", validator: validate_JobGetTaskCounts_574499,
    base: "", url: url_JobGetTaskCounts_574500, schemes: {Scheme.Https})
type
  Call_TaskAdd_574528 = ref object of OpenApiRestCall_573667
proc url_TaskAdd_574530(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskAdd_574529(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## The maximum lifetime of a Task from addition to completion is 180 days. If a Task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job to which the Task is to be added.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574531 = path.getOrDefault("jobId")
  valid_574531 = validateParameter(valid_574531, JString, required = true,
                                 default = nil)
  if valid_574531 != nil:
    section.add "jobId", valid_574531
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574532 = query.getOrDefault("timeout")
  valid_574532 = validateParameter(valid_574532, JInt, required = false,
                                 default = newJInt(30))
  if valid_574532 != nil:
    section.add "timeout", valid_574532
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574533 = query.getOrDefault("api-version")
  valid_574533 = validateParameter(valid_574533, JString, required = true,
                                 default = nil)
  if valid_574533 != nil:
    section.add "api-version", valid_574533
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574534 = header.getOrDefault("client-request-id")
  valid_574534 = validateParameter(valid_574534, JString, required = false,
                                 default = nil)
  if valid_574534 != nil:
    section.add "client-request-id", valid_574534
  var valid_574535 = header.getOrDefault("ocp-date")
  valid_574535 = validateParameter(valid_574535, JString, required = false,
                                 default = nil)
  if valid_574535 != nil:
    section.add "ocp-date", valid_574535
  var valid_574536 = header.getOrDefault("return-client-request-id")
  valid_574536 = validateParameter(valid_574536, JBool, required = false,
                                 default = newJBool(false))
  if valid_574536 != nil:
    section.add "return-client-request-id", valid_574536
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   task: JObject (required)
  ##       : The Task to be added.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574538: Call_TaskAdd_574528; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The maximum lifetime of a Task from addition to completion is 180 days. If a Task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ## 
  let valid = call_574538.validator(path, query, header, formData, body)
  let scheme = call_574538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574538.url(scheme.get, call_574538.host, call_574538.base,
                         call_574538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574538, url, valid)

proc call*(call_574539: Call_TaskAdd_574528; apiVersion: string; jobId: string;
          task: JsonNode; timeout: int = 30): Recallable =
  ## taskAdd
  ## The maximum lifetime of a Task from addition to completion is 180 days. If a Task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job to which the Task is to be added.
  ##   task: JObject (required)
  ##       : The Task to be added.
  var path_574540 = newJObject()
  var query_574541 = newJObject()
  var body_574542 = newJObject()
  add(query_574541, "timeout", newJInt(timeout))
  add(query_574541, "api-version", newJString(apiVersion))
  add(path_574540, "jobId", newJString(jobId))
  if task != nil:
    body_574542 = task
  result = call_574539.call(path_574540, query_574541, nil, nil, body_574542)

var taskAdd* = Call_TaskAdd_574528(name: "taskAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/jobs/{jobId}/tasks",
                                validator: validate_TaskAdd_574529, base: "",
                                url: url_TaskAdd_574530, schemes: {Scheme.Https})
type
  Call_TaskList_574511 = ref object of OpenApiRestCall_573667
proc url_TaskList_574513(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskList_574512(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## For multi-instance Tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary Task. Use the list subtasks API to retrieve information about subtasks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574514 = path.getOrDefault("jobId")
  valid_574514 = validateParameter(valid_574514, JString, required = true,
                                 default = nil)
  if valid_574514 != nil:
    section.add "jobId", valid_574514
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 Tasks can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-tasks.
  section = newJObject()
  var valid_574515 = query.getOrDefault("timeout")
  valid_574515 = validateParameter(valid_574515, JInt, required = false,
                                 default = newJInt(30))
  if valid_574515 != nil:
    section.add "timeout", valid_574515
  var valid_574516 = query.getOrDefault("$expand")
  valid_574516 = validateParameter(valid_574516, JString, required = false,
                                 default = nil)
  if valid_574516 != nil:
    section.add "$expand", valid_574516
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574517 = query.getOrDefault("api-version")
  valid_574517 = validateParameter(valid_574517, JString, required = true,
                                 default = nil)
  if valid_574517 != nil:
    section.add "api-version", valid_574517
  var valid_574518 = query.getOrDefault("maxresults")
  valid_574518 = validateParameter(valid_574518, JInt, required = false,
                                 default = newJInt(1000))
  if valid_574518 != nil:
    section.add "maxresults", valid_574518
  var valid_574519 = query.getOrDefault("$select")
  valid_574519 = validateParameter(valid_574519, JString, required = false,
                                 default = nil)
  if valid_574519 != nil:
    section.add "$select", valid_574519
  var valid_574520 = query.getOrDefault("$filter")
  valid_574520 = validateParameter(valid_574520, JString, required = false,
                                 default = nil)
  if valid_574520 != nil:
    section.add "$filter", valid_574520
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574521 = header.getOrDefault("client-request-id")
  valid_574521 = validateParameter(valid_574521, JString, required = false,
                                 default = nil)
  if valid_574521 != nil:
    section.add "client-request-id", valid_574521
  var valid_574522 = header.getOrDefault("ocp-date")
  valid_574522 = validateParameter(valid_574522, JString, required = false,
                                 default = nil)
  if valid_574522 != nil:
    section.add "ocp-date", valid_574522
  var valid_574523 = header.getOrDefault("return-client-request-id")
  valid_574523 = validateParameter(valid_574523, JBool, required = false,
                                 default = newJBool(false))
  if valid_574523 != nil:
    section.add "return-client-request-id", valid_574523
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574524: Call_TaskList_574511; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## For multi-instance Tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary Task. Use the list subtasks API to retrieve information about subtasks.
  ## 
  let valid = call_574524.validator(path, query, header, formData, body)
  let scheme = call_574524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574524.url(scheme.get, call_574524.host, call_574524.base,
                         call_574524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574524, url, valid)

proc call*(call_574525: Call_TaskList_574511; apiVersion: string; jobId: string;
          timeout: int = 30; Expand: string = ""; maxresults: int = 1000;
          Select: string = ""; Filter: string = ""): Recallable =
  ## taskList
  ## For multi-instance Tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary Task. Use the list subtasks API to retrieve information about subtasks.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 Tasks can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-tasks.
  var path_574526 = newJObject()
  var query_574527 = newJObject()
  add(query_574527, "timeout", newJInt(timeout))
  add(query_574527, "$expand", newJString(Expand))
  add(query_574527, "api-version", newJString(apiVersion))
  add(path_574526, "jobId", newJString(jobId))
  add(query_574527, "maxresults", newJInt(maxresults))
  add(query_574527, "$select", newJString(Select))
  add(query_574527, "$filter", newJString(Filter))
  result = call_574525.call(path_574526, query_574527, nil, nil, nil)

var taskList* = Call_TaskList_574511(name: "taskList", meth: HttpMethod.HttpGet,
                                  host: "azure.local",
                                  route: "/jobs/{jobId}/tasks",
                                  validator: validate_TaskList_574512, base: "",
                                  url: url_TaskList_574513,
                                  schemes: {Scheme.Https})
type
  Call_TaskUpdate_574563 = ref object of OpenApiRestCall_573667
proc url_TaskUpdate_574565(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  assert "taskId" in path, "`taskId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskUpdate_574564(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the properties of the specified Task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job containing the Task.
  ##   taskId: JString (required)
  ##         : The ID of the Task to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574566 = path.getOrDefault("jobId")
  valid_574566 = validateParameter(valid_574566, JString, required = true,
                                 default = nil)
  if valid_574566 != nil:
    section.add "jobId", valid_574566
  var valid_574567 = path.getOrDefault("taskId")
  valid_574567 = validateParameter(valid_574567, JString, required = true,
                                 default = nil)
  if valid_574567 != nil:
    section.add "taskId", valid_574567
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574568 = query.getOrDefault("timeout")
  valid_574568 = validateParameter(valid_574568, JInt, required = false,
                                 default = newJInt(30))
  if valid_574568 != nil:
    section.add "timeout", valid_574568
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574569 = query.getOrDefault("api-version")
  valid_574569 = validateParameter(valid_574569, JString, required = true,
                                 default = nil)
  if valid_574569 != nil:
    section.add "api-version", valid_574569
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574570 = header.getOrDefault("If-Match")
  valid_574570 = validateParameter(valid_574570, JString, required = false,
                                 default = nil)
  if valid_574570 != nil:
    section.add "If-Match", valid_574570
  var valid_574571 = header.getOrDefault("client-request-id")
  valid_574571 = validateParameter(valid_574571, JString, required = false,
                                 default = nil)
  if valid_574571 != nil:
    section.add "client-request-id", valid_574571
  var valid_574572 = header.getOrDefault("ocp-date")
  valid_574572 = validateParameter(valid_574572, JString, required = false,
                                 default = nil)
  if valid_574572 != nil:
    section.add "ocp-date", valid_574572
  var valid_574573 = header.getOrDefault("If-Unmodified-Since")
  valid_574573 = validateParameter(valid_574573, JString, required = false,
                                 default = nil)
  if valid_574573 != nil:
    section.add "If-Unmodified-Since", valid_574573
  var valid_574574 = header.getOrDefault("If-None-Match")
  valid_574574 = validateParameter(valid_574574, JString, required = false,
                                 default = nil)
  if valid_574574 != nil:
    section.add "If-None-Match", valid_574574
  var valid_574575 = header.getOrDefault("If-Modified-Since")
  valid_574575 = validateParameter(valid_574575, JString, required = false,
                                 default = nil)
  if valid_574575 != nil:
    section.add "If-Modified-Since", valid_574575
  var valid_574576 = header.getOrDefault("return-client-request-id")
  valid_574576 = validateParameter(valid_574576, JBool, required = false,
                                 default = newJBool(false))
  if valid_574576 != nil:
    section.add "return-client-request-id", valid_574576
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   taskUpdateParameter: JObject (required)
  ##                      : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574578: Call_TaskUpdate_574563; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of the specified Task.
  ## 
  let valid = call_574578.validator(path, query, header, formData, body)
  let scheme = call_574578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574578.url(scheme.get, call_574578.host, call_574578.base,
                         call_574578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574578, url, valid)

proc call*(call_574579: Call_TaskUpdate_574563; apiVersion: string; jobId: string;
          taskUpdateParameter: JsonNode; taskId: string; timeout: int = 30): Recallable =
  ## taskUpdate
  ## Updates the properties of the specified Task.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job containing the Task.
  ##   taskUpdateParameter: JObject (required)
  ##                      : The parameters for the request.
  ##   taskId: string (required)
  ##         : The ID of the Task to update.
  var path_574580 = newJObject()
  var query_574581 = newJObject()
  var body_574582 = newJObject()
  add(query_574581, "timeout", newJInt(timeout))
  add(query_574581, "api-version", newJString(apiVersion))
  add(path_574580, "jobId", newJString(jobId))
  if taskUpdateParameter != nil:
    body_574582 = taskUpdateParameter
  add(path_574580, "taskId", newJString(taskId))
  result = call_574579.call(path_574580, query_574581, nil, nil, body_574582)

var taskUpdate* = Call_TaskUpdate_574563(name: "taskUpdate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local",
                                      route: "/jobs/{jobId}/tasks/{taskId}",
                                      validator: validate_TaskUpdate_574564,
                                      base: "", url: url_TaskUpdate_574565,
                                      schemes: {Scheme.Https})
type
  Call_TaskGet_574543 = ref object of OpenApiRestCall_573667
proc url_TaskGet_574545(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  assert "taskId" in path, "`taskId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskGet_574544(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## For multi-instance Tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary Task. Use the list subtasks API to retrieve information about subtasks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job that contains the Task.
  ##   taskId: JString (required)
  ##         : The ID of the Task to get information about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574546 = path.getOrDefault("jobId")
  valid_574546 = validateParameter(valid_574546, JString, required = true,
                                 default = nil)
  if valid_574546 != nil:
    section.add "jobId", valid_574546
  var valid_574547 = path.getOrDefault("taskId")
  valid_574547 = validateParameter(valid_574547, JString, required = true,
                                 default = nil)
  if valid_574547 != nil:
    section.add "taskId", valid_574547
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_574548 = query.getOrDefault("timeout")
  valid_574548 = validateParameter(valid_574548, JInt, required = false,
                                 default = newJInt(30))
  if valid_574548 != nil:
    section.add "timeout", valid_574548
  var valid_574549 = query.getOrDefault("$expand")
  valid_574549 = validateParameter(valid_574549, JString, required = false,
                                 default = nil)
  if valid_574549 != nil:
    section.add "$expand", valid_574549
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574550 = query.getOrDefault("api-version")
  valid_574550 = validateParameter(valid_574550, JString, required = true,
                                 default = nil)
  if valid_574550 != nil:
    section.add "api-version", valid_574550
  var valid_574551 = query.getOrDefault("$select")
  valid_574551 = validateParameter(valid_574551, JString, required = false,
                                 default = nil)
  if valid_574551 != nil:
    section.add "$select", valid_574551
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574552 = header.getOrDefault("If-Match")
  valid_574552 = validateParameter(valid_574552, JString, required = false,
                                 default = nil)
  if valid_574552 != nil:
    section.add "If-Match", valid_574552
  var valid_574553 = header.getOrDefault("client-request-id")
  valid_574553 = validateParameter(valid_574553, JString, required = false,
                                 default = nil)
  if valid_574553 != nil:
    section.add "client-request-id", valid_574553
  var valid_574554 = header.getOrDefault("ocp-date")
  valid_574554 = validateParameter(valid_574554, JString, required = false,
                                 default = nil)
  if valid_574554 != nil:
    section.add "ocp-date", valid_574554
  var valid_574555 = header.getOrDefault("If-Unmodified-Since")
  valid_574555 = validateParameter(valid_574555, JString, required = false,
                                 default = nil)
  if valid_574555 != nil:
    section.add "If-Unmodified-Since", valid_574555
  var valid_574556 = header.getOrDefault("If-None-Match")
  valid_574556 = validateParameter(valid_574556, JString, required = false,
                                 default = nil)
  if valid_574556 != nil:
    section.add "If-None-Match", valid_574556
  var valid_574557 = header.getOrDefault("If-Modified-Since")
  valid_574557 = validateParameter(valid_574557, JString, required = false,
                                 default = nil)
  if valid_574557 != nil:
    section.add "If-Modified-Since", valid_574557
  var valid_574558 = header.getOrDefault("return-client-request-id")
  valid_574558 = validateParameter(valid_574558, JBool, required = false,
                                 default = newJBool(false))
  if valid_574558 != nil:
    section.add "return-client-request-id", valid_574558
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574559: Call_TaskGet_574543; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## For multi-instance Tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary Task. Use the list subtasks API to retrieve information about subtasks.
  ## 
  let valid = call_574559.validator(path, query, header, formData, body)
  let scheme = call_574559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574559.url(scheme.get, call_574559.host, call_574559.base,
                         call_574559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574559, url, valid)

proc call*(call_574560: Call_TaskGet_574543; apiVersion: string; jobId: string;
          taskId: string; timeout: int = 30; Expand: string = ""; Select: string = ""): Recallable =
  ## taskGet
  ## For multi-instance Tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary Task. Use the list subtasks API to retrieve information about subtasks.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job that contains the Task.
  ##   Select: string
  ##         : An OData $select clause.
  ##   taskId: string (required)
  ##         : The ID of the Task to get information about.
  var path_574561 = newJObject()
  var query_574562 = newJObject()
  add(query_574562, "timeout", newJInt(timeout))
  add(query_574562, "$expand", newJString(Expand))
  add(query_574562, "api-version", newJString(apiVersion))
  add(path_574561, "jobId", newJString(jobId))
  add(query_574562, "$select", newJString(Select))
  add(path_574561, "taskId", newJString(taskId))
  result = call_574560.call(path_574561, query_574562, nil, nil, nil)

var taskGet* = Call_TaskGet_574543(name: "taskGet", meth: HttpMethod.HttpGet,
                                host: "azure.local",
                                route: "/jobs/{jobId}/tasks/{taskId}",
                                validator: validate_TaskGet_574544, base: "",
                                url: url_TaskGet_574545, schemes: {Scheme.Https})
type
  Call_TaskDelete_574583 = ref object of OpenApiRestCall_573667
proc url_TaskDelete_574585(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  assert "taskId" in path, "`taskId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskDelete_574584(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## When a Task is deleted, all of the files in its directory on the Compute Node where it ran are also deleted (regardless of the retention time). For multi-instance Tasks, the delete Task operation applies synchronously to the primary task; subtasks and their files are then deleted asynchronously in the background.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job from which to delete the Task.
  ##   taskId: JString (required)
  ##         : The ID of the Task to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574586 = path.getOrDefault("jobId")
  valid_574586 = validateParameter(valid_574586, JString, required = true,
                                 default = nil)
  if valid_574586 != nil:
    section.add "jobId", valid_574586
  var valid_574587 = path.getOrDefault("taskId")
  valid_574587 = validateParameter(valid_574587, JString, required = true,
                                 default = nil)
  if valid_574587 != nil:
    section.add "taskId", valid_574587
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574588 = query.getOrDefault("timeout")
  valid_574588 = validateParameter(valid_574588, JInt, required = false,
                                 default = newJInt(30))
  if valid_574588 != nil:
    section.add "timeout", valid_574588
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574589 = query.getOrDefault("api-version")
  valid_574589 = validateParameter(valid_574589, JString, required = true,
                                 default = nil)
  if valid_574589 != nil:
    section.add "api-version", valid_574589
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574590 = header.getOrDefault("If-Match")
  valid_574590 = validateParameter(valid_574590, JString, required = false,
                                 default = nil)
  if valid_574590 != nil:
    section.add "If-Match", valid_574590
  var valid_574591 = header.getOrDefault("client-request-id")
  valid_574591 = validateParameter(valid_574591, JString, required = false,
                                 default = nil)
  if valid_574591 != nil:
    section.add "client-request-id", valid_574591
  var valid_574592 = header.getOrDefault("ocp-date")
  valid_574592 = validateParameter(valid_574592, JString, required = false,
                                 default = nil)
  if valid_574592 != nil:
    section.add "ocp-date", valid_574592
  var valid_574593 = header.getOrDefault("If-Unmodified-Since")
  valid_574593 = validateParameter(valid_574593, JString, required = false,
                                 default = nil)
  if valid_574593 != nil:
    section.add "If-Unmodified-Since", valid_574593
  var valid_574594 = header.getOrDefault("If-None-Match")
  valid_574594 = validateParameter(valid_574594, JString, required = false,
                                 default = nil)
  if valid_574594 != nil:
    section.add "If-None-Match", valid_574594
  var valid_574595 = header.getOrDefault("If-Modified-Since")
  valid_574595 = validateParameter(valid_574595, JString, required = false,
                                 default = nil)
  if valid_574595 != nil:
    section.add "If-Modified-Since", valid_574595
  var valid_574596 = header.getOrDefault("return-client-request-id")
  valid_574596 = validateParameter(valid_574596, JBool, required = false,
                                 default = newJBool(false))
  if valid_574596 != nil:
    section.add "return-client-request-id", valid_574596
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574597: Call_TaskDelete_574583; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When a Task is deleted, all of the files in its directory on the Compute Node where it ran are also deleted (regardless of the retention time). For multi-instance Tasks, the delete Task operation applies synchronously to the primary task; subtasks and their files are then deleted asynchronously in the background.
  ## 
  let valid = call_574597.validator(path, query, header, formData, body)
  let scheme = call_574597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574597.url(scheme.get, call_574597.host, call_574597.base,
                         call_574597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574597, url, valid)

proc call*(call_574598: Call_TaskDelete_574583; apiVersion: string; jobId: string;
          taskId: string; timeout: int = 30): Recallable =
  ## taskDelete
  ## When a Task is deleted, all of the files in its directory on the Compute Node where it ran are also deleted (regardless of the retention time). For multi-instance Tasks, the delete Task operation applies synchronously to the primary task; subtasks and their files are then deleted asynchronously in the background.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job from which to delete the Task.
  ##   taskId: string (required)
  ##         : The ID of the Task to delete.
  var path_574599 = newJObject()
  var query_574600 = newJObject()
  add(query_574600, "timeout", newJInt(timeout))
  add(query_574600, "api-version", newJString(apiVersion))
  add(path_574599, "jobId", newJString(jobId))
  add(path_574599, "taskId", newJString(taskId))
  result = call_574598.call(path_574599, query_574600, nil, nil, nil)

var taskDelete* = Call_TaskDelete_574583(name: "taskDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/jobs/{jobId}/tasks/{taskId}",
                                      validator: validate_TaskDelete_574584,
                                      base: "", url: url_TaskDelete_574585,
                                      schemes: {Scheme.Https})
type
  Call_FileListFromTask_574601 = ref object of OpenApiRestCall_573667
proc url_FileListFromTask_574603(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  assert "taskId" in path, "`taskId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskId"),
               (kind: ConstantSegment, value: "/files")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileListFromTask_574602(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job that contains the Task.
  ##   taskId: JString (required)
  ##         : The ID of the Task whose files you want to list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574604 = path.getOrDefault("jobId")
  valid_574604 = validateParameter(valid_574604, JString, required = true,
                                 default = nil)
  if valid_574604 != nil:
    section.add "jobId", valid_574604
  var valid_574605 = path.getOrDefault("taskId")
  valid_574605 = validateParameter(valid_574605, JString, required = true,
                                 default = nil)
  if valid_574605 != nil:
    section.add "taskId", valid_574605
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-task-files.
  ##   recursive: JBool
  ##            : Whether to list children of the Task directory. This parameter can be used in combination with the filter parameter to list specific type of files.
  section = newJObject()
  var valid_574606 = query.getOrDefault("timeout")
  valid_574606 = validateParameter(valid_574606, JInt, required = false,
                                 default = newJInt(30))
  if valid_574606 != nil:
    section.add "timeout", valid_574606
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574607 = query.getOrDefault("api-version")
  valid_574607 = validateParameter(valid_574607, JString, required = true,
                                 default = nil)
  if valid_574607 != nil:
    section.add "api-version", valid_574607
  var valid_574608 = query.getOrDefault("maxresults")
  valid_574608 = validateParameter(valid_574608, JInt, required = false,
                                 default = newJInt(1000))
  if valid_574608 != nil:
    section.add "maxresults", valid_574608
  var valid_574609 = query.getOrDefault("$filter")
  valid_574609 = validateParameter(valid_574609, JString, required = false,
                                 default = nil)
  if valid_574609 != nil:
    section.add "$filter", valid_574609
  var valid_574610 = query.getOrDefault("recursive")
  valid_574610 = validateParameter(valid_574610, JBool, required = false, default = nil)
  if valid_574610 != nil:
    section.add "recursive", valid_574610
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574611 = header.getOrDefault("client-request-id")
  valid_574611 = validateParameter(valid_574611, JString, required = false,
                                 default = nil)
  if valid_574611 != nil:
    section.add "client-request-id", valid_574611
  var valid_574612 = header.getOrDefault("ocp-date")
  valid_574612 = validateParameter(valid_574612, JString, required = false,
                                 default = nil)
  if valid_574612 != nil:
    section.add "ocp-date", valid_574612
  var valid_574613 = header.getOrDefault("return-client-request-id")
  valid_574613 = validateParameter(valid_574613, JBool, required = false,
                                 default = newJBool(false))
  if valid_574613 != nil:
    section.add "return-client-request-id", valid_574613
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574614: Call_FileListFromTask_574601; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574614.validator(path, query, header, formData, body)
  let scheme = call_574614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574614.url(scheme.get, call_574614.host, call_574614.base,
                         call_574614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574614, url, valid)

proc call*(call_574615: Call_FileListFromTask_574601; apiVersion: string;
          jobId: string; taskId: string; timeout: int = 30; maxresults: int = 1000;
          Filter: string = ""; recursive: bool = false): Recallable =
  ## fileListFromTask
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job that contains the Task.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-task-files.
  ##   recursive: bool
  ##            : Whether to list children of the Task directory. This parameter can be used in combination with the filter parameter to list specific type of files.
  ##   taskId: string (required)
  ##         : The ID of the Task whose files you want to list.
  var path_574616 = newJObject()
  var query_574617 = newJObject()
  add(query_574617, "timeout", newJInt(timeout))
  add(query_574617, "api-version", newJString(apiVersion))
  add(path_574616, "jobId", newJString(jobId))
  add(query_574617, "maxresults", newJInt(maxresults))
  add(query_574617, "$filter", newJString(Filter))
  add(query_574617, "recursive", newJBool(recursive))
  add(path_574616, "taskId", newJString(taskId))
  result = call_574615.call(path_574616, query_574617, nil, nil, nil)

var fileListFromTask* = Call_FileListFromTask_574601(name: "fileListFromTask",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/files",
    validator: validate_FileListFromTask_574602, base: "",
    url: url_FileListFromTask_574603, schemes: {Scheme.Https})
type
  Call_FileGetPropertiesFromTask_574652 = ref object of OpenApiRestCall_573667
proc url_FileGetPropertiesFromTask_574654(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  assert "taskId" in path, "`taskId` is a required path parameter"
  assert "filePath" in path, "`filePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskId"),
               (kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "filePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileGetPropertiesFromTask_574653(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified Task file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job that contains the Task.
  ##   filePath: JString (required)
  ##           : The path to the Task file that you want to get the properties of.
  ##   taskId: JString (required)
  ##         : The ID of the Task whose file you want to get the properties of.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574655 = path.getOrDefault("jobId")
  valid_574655 = validateParameter(valid_574655, JString, required = true,
                                 default = nil)
  if valid_574655 != nil:
    section.add "jobId", valid_574655
  var valid_574656 = path.getOrDefault("filePath")
  valid_574656 = validateParameter(valid_574656, JString, required = true,
                                 default = nil)
  if valid_574656 != nil:
    section.add "filePath", valid_574656
  var valid_574657 = path.getOrDefault("taskId")
  valid_574657 = validateParameter(valid_574657, JString, required = true,
                                 default = nil)
  if valid_574657 != nil:
    section.add "taskId", valid_574657
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574658 = query.getOrDefault("timeout")
  valid_574658 = validateParameter(valid_574658, JInt, required = false,
                                 default = newJInt(30))
  if valid_574658 != nil:
    section.add "timeout", valid_574658
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574659 = query.getOrDefault("api-version")
  valid_574659 = validateParameter(valid_574659, JString, required = true,
                                 default = nil)
  if valid_574659 != nil:
    section.add "api-version", valid_574659
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574660 = header.getOrDefault("client-request-id")
  valid_574660 = validateParameter(valid_574660, JString, required = false,
                                 default = nil)
  if valid_574660 != nil:
    section.add "client-request-id", valid_574660
  var valid_574661 = header.getOrDefault("ocp-date")
  valid_574661 = validateParameter(valid_574661, JString, required = false,
                                 default = nil)
  if valid_574661 != nil:
    section.add "ocp-date", valid_574661
  var valid_574662 = header.getOrDefault("If-Unmodified-Since")
  valid_574662 = validateParameter(valid_574662, JString, required = false,
                                 default = nil)
  if valid_574662 != nil:
    section.add "If-Unmodified-Since", valid_574662
  var valid_574663 = header.getOrDefault("If-Modified-Since")
  valid_574663 = validateParameter(valid_574663, JString, required = false,
                                 default = nil)
  if valid_574663 != nil:
    section.add "If-Modified-Since", valid_574663
  var valid_574664 = header.getOrDefault("return-client-request-id")
  valid_574664 = validateParameter(valid_574664, JBool, required = false,
                                 default = newJBool(false))
  if valid_574664 != nil:
    section.add "return-client-request-id", valid_574664
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574665: Call_FileGetPropertiesFromTask_574652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified Task file.
  ## 
  let valid = call_574665.validator(path, query, header, formData, body)
  let scheme = call_574665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574665.url(scheme.get, call_574665.host, call_574665.base,
                         call_574665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574665, url, valid)

proc call*(call_574666: Call_FileGetPropertiesFromTask_574652; apiVersion: string;
          jobId: string; filePath: string; taskId: string; timeout: int = 30): Recallable =
  ## fileGetPropertiesFromTask
  ## Gets the properties of the specified Task file.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job that contains the Task.
  ##   filePath: string (required)
  ##           : The path to the Task file that you want to get the properties of.
  ##   taskId: string (required)
  ##         : The ID of the Task whose file you want to get the properties of.
  var path_574667 = newJObject()
  var query_574668 = newJObject()
  add(query_574668, "timeout", newJInt(timeout))
  add(query_574668, "api-version", newJString(apiVersion))
  add(path_574667, "jobId", newJString(jobId))
  add(path_574667, "filePath", newJString(filePath))
  add(path_574667, "taskId", newJString(taskId))
  result = call_574666.call(path_574667, query_574668, nil, nil, nil)

var fileGetPropertiesFromTask* = Call_FileGetPropertiesFromTask_574652(
    name: "fileGetPropertiesFromTask", meth: HttpMethod.HttpHead,
    host: "azure.local", route: "/jobs/{jobId}/tasks/{taskId}/files/{filePath}",
    validator: validate_FileGetPropertiesFromTask_574653, base: "",
    url: url_FileGetPropertiesFromTask_574654, schemes: {Scheme.Https})
type
  Call_FileGetFromTask_574618 = ref object of OpenApiRestCall_573667
proc url_FileGetFromTask_574620(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  assert "taskId" in path, "`taskId` is a required path parameter"
  assert "filePath" in path, "`filePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskId"),
               (kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "filePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileGetFromTask_574619(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns the content of the specified Task file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job that contains the Task.
  ##   filePath: JString (required)
  ##           : The path to the Task file that you want to get the content of.
  ##   taskId: JString (required)
  ##         : The ID of the Task whose file you want to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574621 = path.getOrDefault("jobId")
  valid_574621 = validateParameter(valid_574621, JString, required = true,
                                 default = nil)
  if valid_574621 != nil:
    section.add "jobId", valid_574621
  var valid_574622 = path.getOrDefault("filePath")
  valid_574622 = validateParameter(valid_574622, JString, required = true,
                                 default = nil)
  if valid_574622 != nil:
    section.add "filePath", valid_574622
  var valid_574623 = path.getOrDefault("taskId")
  valid_574623 = validateParameter(valid_574623, JString, required = true,
                                 default = nil)
  if valid_574623 != nil:
    section.add "taskId", valid_574623
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574624 = query.getOrDefault("timeout")
  valid_574624 = validateParameter(valid_574624, JInt, required = false,
                                 default = newJInt(30))
  if valid_574624 != nil:
    section.add "timeout", valid_574624
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574625 = query.getOrDefault("api-version")
  valid_574625 = validateParameter(valid_574625, JString, required = true,
                                 default = nil)
  if valid_574625 != nil:
    section.add "api-version", valid_574625
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   ocp-range: JString
  ##            : The byte range to be retrieved. The default is to retrieve the entire file. The format is bytes=startRange-endRange.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574626 = header.getOrDefault("client-request-id")
  valid_574626 = validateParameter(valid_574626, JString, required = false,
                                 default = nil)
  if valid_574626 != nil:
    section.add "client-request-id", valid_574626
  var valid_574627 = header.getOrDefault("ocp-date")
  valid_574627 = validateParameter(valid_574627, JString, required = false,
                                 default = nil)
  if valid_574627 != nil:
    section.add "ocp-date", valid_574627
  var valid_574628 = header.getOrDefault("If-Unmodified-Since")
  valid_574628 = validateParameter(valid_574628, JString, required = false,
                                 default = nil)
  if valid_574628 != nil:
    section.add "If-Unmodified-Since", valid_574628
  var valid_574629 = header.getOrDefault("ocp-range")
  valid_574629 = validateParameter(valid_574629, JString, required = false,
                                 default = nil)
  if valid_574629 != nil:
    section.add "ocp-range", valid_574629
  var valid_574630 = header.getOrDefault("If-Modified-Since")
  valid_574630 = validateParameter(valid_574630, JString, required = false,
                                 default = nil)
  if valid_574630 != nil:
    section.add "If-Modified-Since", valid_574630
  var valid_574631 = header.getOrDefault("return-client-request-id")
  valid_574631 = validateParameter(valid_574631, JBool, required = false,
                                 default = newJBool(false))
  if valid_574631 != nil:
    section.add "return-client-request-id", valid_574631
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574632: Call_FileGetFromTask_574618; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the content of the specified Task file.
  ## 
  let valid = call_574632.validator(path, query, header, formData, body)
  let scheme = call_574632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574632.url(scheme.get, call_574632.host, call_574632.base,
                         call_574632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574632, url, valid)

proc call*(call_574633: Call_FileGetFromTask_574618; apiVersion: string;
          jobId: string; filePath: string; taskId: string; timeout: int = 30): Recallable =
  ## fileGetFromTask
  ## Returns the content of the specified Task file.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job that contains the Task.
  ##   filePath: string (required)
  ##           : The path to the Task file that you want to get the content of.
  ##   taskId: string (required)
  ##         : The ID of the Task whose file you want to retrieve.
  var path_574634 = newJObject()
  var query_574635 = newJObject()
  add(query_574635, "timeout", newJInt(timeout))
  add(query_574635, "api-version", newJString(apiVersion))
  add(path_574634, "jobId", newJString(jobId))
  add(path_574634, "filePath", newJString(filePath))
  add(path_574634, "taskId", newJString(taskId))
  result = call_574633.call(path_574634, query_574635, nil, nil, nil)

var fileGetFromTask* = Call_FileGetFromTask_574618(name: "fileGetFromTask",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/files/{filePath}",
    validator: validate_FileGetFromTask_574619, base: "", url: url_FileGetFromTask_574620,
    schemes: {Scheme.Https})
type
  Call_FileDeleteFromTask_574636 = ref object of OpenApiRestCall_573667
proc url_FileDeleteFromTask_574638(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  assert "taskId" in path, "`taskId` is a required path parameter"
  assert "filePath" in path, "`filePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskId"),
               (kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "filePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileDeleteFromTask_574637(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job that contains the Task.
  ##   filePath: JString (required)
  ##           : The path to the Task file or directory that you want to delete.
  ##   taskId: JString (required)
  ##         : The ID of the Task whose file you want to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574639 = path.getOrDefault("jobId")
  valid_574639 = validateParameter(valid_574639, JString, required = true,
                                 default = nil)
  if valid_574639 != nil:
    section.add "jobId", valid_574639
  var valid_574640 = path.getOrDefault("filePath")
  valid_574640 = validateParameter(valid_574640, JString, required = true,
                                 default = nil)
  if valid_574640 != nil:
    section.add "filePath", valid_574640
  var valid_574641 = path.getOrDefault("taskId")
  valid_574641 = validateParameter(valid_574641, JString, required = true,
                                 default = nil)
  if valid_574641 != nil:
    section.add "taskId", valid_574641
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   recursive: JBool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  section = newJObject()
  var valid_574642 = query.getOrDefault("timeout")
  valid_574642 = validateParameter(valid_574642, JInt, required = false,
                                 default = newJInt(30))
  if valid_574642 != nil:
    section.add "timeout", valid_574642
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574643 = query.getOrDefault("api-version")
  valid_574643 = validateParameter(valid_574643, JString, required = true,
                                 default = nil)
  if valid_574643 != nil:
    section.add "api-version", valid_574643
  var valid_574644 = query.getOrDefault("recursive")
  valid_574644 = validateParameter(valid_574644, JBool, required = false, default = nil)
  if valid_574644 != nil:
    section.add "recursive", valid_574644
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574645 = header.getOrDefault("client-request-id")
  valid_574645 = validateParameter(valid_574645, JString, required = false,
                                 default = nil)
  if valid_574645 != nil:
    section.add "client-request-id", valid_574645
  var valid_574646 = header.getOrDefault("ocp-date")
  valid_574646 = validateParameter(valid_574646, JString, required = false,
                                 default = nil)
  if valid_574646 != nil:
    section.add "ocp-date", valid_574646
  var valid_574647 = header.getOrDefault("return-client-request-id")
  valid_574647 = validateParameter(valid_574647, JBool, required = false,
                                 default = newJBool(false))
  if valid_574647 != nil:
    section.add "return-client-request-id", valid_574647
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574648: Call_FileDeleteFromTask_574636; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574648.validator(path, query, header, formData, body)
  let scheme = call_574648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574648.url(scheme.get, call_574648.host, call_574648.base,
                         call_574648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574648, url, valid)

proc call*(call_574649: Call_FileDeleteFromTask_574636; apiVersion: string;
          jobId: string; filePath: string; taskId: string; timeout: int = 30;
          recursive: bool = false): Recallable =
  ## fileDeleteFromTask
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job that contains the Task.
  ##   filePath: string (required)
  ##           : The path to the Task file or directory that you want to delete.
  ##   recursive: bool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  ##   taskId: string (required)
  ##         : The ID of the Task whose file you want to delete.
  var path_574650 = newJObject()
  var query_574651 = newJObject()
  add(query_574651, "timeout", newJInt(timeout))
  add(query_574651, "api-version", newJString(apiVersion))
  add(path_574650, "jobId", newJString(jobId))
  add(path_574650, "filePath", newJString(filePath))
  add(query_574651, "recursive", newJBool(recursive))
  add(path_574650, "taskId", newJString(taskId))
  result = call_574649.call(path_574650, query_574651, nil, nil, nil)

var fileDeleteFromTask* = Call_FileDeleteFromTask_574636(
    name: "fileDeleteFromTask", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/files/{filePath}",
    validator: validate_FileDeleteFromTask_574637, base: "",
    url: url_FileDeleteFromTask_574638, schemes: {Scheme.Https})
type
  Call_TaskReactivate_574669 = ref object of OpenApiRestCall_573667
proc url_TaskReactivate_574671(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  assert "taskId" in path, "`taskId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskId"),
               (kind: ConstantSegment, value: "/reactivate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskReactivate_574670(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Reactivation makes a Task eligible to be retried again up to its maximum retry count. The Task's state is changed to active. As the Task is no longer in the completed state, any previous exit code or failure information is no longer available after reactivation. Each time a Task is reactivated, its retry count is reset to 0. Reactivation will fail for Tasks that are not completed or that previously completed successfully (with an exit code of 0). Additionally, it will fail if the Job has completed (or is terminating or deleting).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job containing the Task.
  ##   taskId: JString (required)
  ##         : The ID of the Task to reactivate.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574672 = path.getOrDefault("jobId")
  valid_574672 = validateParameter(valid_574672, JString, required = true,
                                 default = nil)
  if valid_574672 != nil:
    section.add "jobId", valid_574672
  var valid_574673 = path.getOrDefault("taskId")
  valid_574673 = validateParameter(valid_574673, JString, required = true,
                                 default = nil)
  if valid_574673 != nil:
    section.add "taskId", valid_574673
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574674 = query.getOrDefault("timeout")
  valid_574674 = validateParameter(valid_574674, JInt, required = false,
                                 default = newJInt(30))
  if valid_574674 != nil:
    section.add "timeout", valid_574674
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574675 = query.getOrDefault("api-version")
  valid_574675 = validateParameter(valid_574675, JString, required = true,
                                 default = nil)
  if valid_574675 != nil:
    section.add "api-version", valid_574675
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574676 = header.getOrDefault("If-Match")
  valid_574676 = validateParameter(valid_574676, JString, required = false,
                                 default = nil)
  if valid_574676 != nil:
    section.add "If-Match", valid_574676
  var valid_574677 = header.getOrDefault("client-request-id")
  valid_574677 = validateParameter(valid_574677, JString, required = false,
                                 default = nil)
  if valid_574677 != nil:
    section.add "client-request-id", valid_574677
  var valid_574678 = header.getOrDefault("ocp-date")
  valid_574678 = validateParameter(valid_574678, JString, required = false,
                                 default = nil)
  if valid_574678 != nil:
    section.add "ocp-date", valid_574678
  var valid_574679 = header.getOrDefault("If-Unmodified-Since")
  valid_574679 = validateParameter(valid_574679, JString, required = false,
                                 default = nil)
  if valid_574679 != nil:
    section.add "If-Unmodified-Since", valid_574679
  var valid_574680 = header.getOrDefault("If-None-Match")
  valid_574680 = validateParameter(valid_574680, JString, required = false,
                                 default = nil)
  if valid_574680 != nil:
    section.add "If-None-Match", valid_574680
  var valid_574681 = header.getOrDefault("If-Modified-Since")
  valid_574681 = validateParameter(valid_574681, JString, required = false,
                                 default = nil)
  if valid_574681 != nil:
    section.add "If-Modified-Since", valid_574681
  var valid_574682 = header.getOrDefault("return-client-request-id")
  valid_574682 = validateParameter(valid_574682, JBool, required = false,
                                 default = newJBool(false))
  if valid_574682 != nil:
    section.add "return-client-request-id", valid_574682
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574683: Call_TaskReactivate_574669; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reactivation makes a Task eligible to be retried again up to its maximum retry count. The Task's state is changed to active. As the Task is no longer in the completed state, any previous exit code or failure information is no longer available after reactivation. Each time a Task is reactivated, its retry count is reset to 0. Reactivation will fail for Tasks that are not completed or that previously completed successfully (with an exit code of 0). Additionally, it will fail if the Job has completed (or is terminating or deleting).
  ## 
  let valid = call_574683.validator(path, query, header, formData, body)
  let scheme = call_574683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574683.url(scheme.get, call_574683.host, call_574683.base,
                         call_574683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574683, url, valid)

proc call*(call_574684: Call_TaskReactivate_574669; apiVersion: string;
          jobId: string; taskId: string; timeout: int = 30): Recallable =
  ## taskReactivate
  ## Reactivation makes a Task eligible to be retried again up to its maximum retry count. The Task's state is changed to active. As the Task is no longer in the completed state, any previous exit code or failure information is no longer available after reactivation. Each time a Task is reactivated, its retry count is reset to 0. Reactivation will fail for Tasks that are not completed or that previously completed successfully (with an exit code of 0). Additionally, it will fail if the Job has completed (or is terminating or deleting).
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job containing the Task.
  ##   taskId: string (required)
  ##         : The ID of the Task to reactivate.
  var path_574685 = newJObject()
  var query_574686 = newJObject()
  add(query_574686, "timeout", newJInt(timeout))
  add(query_574686, "api-version", newJString(apiVersion))
  add(path_574685, "jobId", newJString(jobId))
  add(path_574685, "taskId", newJString(taskId))
  result = call_574684.call(path_574685, query_574686, nil, nil, nil)

var taskReactivate* = Call_TaskReactivate_574669(name: "taskReactivate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/reactivate",
    validator: validate_TaskReactivate_574670, base: "", url: url_TaskReactivate_574671,
    schemes: {Scheme.Https})
type
  Call_TaskListSubtasks_574687 = ref object of OpenApiRestCall_573667
proc url_TaskListSubtasks_574689(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  assert "taskId" in path, "`taskId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskId"),
               (kind: ConstantSegment, value: "/subtasksinfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskListSubtasks_574688(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## If the Task is not a multi-instance Task then this returns an empty collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job.
  ##   taskId: JString (required)
  ##         : The ID of the Task.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574690 = path.getOrDefault("jobId")
  valid_574690 = validateParameter(valid_574690, JString, required = true,
                                 default = nil)
  if valid_574690 != nil:
    section.add "jobId", valid_574690
  var valid_574691 = path.getOrDefault("taskId")
  valid_574691 = validateParameter(valid_574691, JString, required = true,
                                 default = nil)
  if valid_574691 != nil:
    section.add "taskId", valid_574691
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_574692 = query.getOrDefault("timeout")
  valid_574692 = validateParameter(valid_574692, JInt, required = false,
                                 default = newJInt(30))
  if valid_574692 != nil:
    section.add "timeout", valid_574692
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574693 = query.getOrDefault("api-version")
  valid_574693 = validateParameter(valid_574693, JString, required = true,
                                 default = nil)
  if valid_574693 != nil:
    section.add "api-version", valid_574693
  var valid_574694 = query.getOrDefault("$select")
  valid_574694 = validateParameter(valid_574694, JString, required = false,
                                 default = nil)
  if valid_574694 != nil:
    section.add "$select", valid_574694
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574695 = header.getOrDefault("client-request-id")
  valid_574695 = validateParameter(valid_574695, JString, required = false,
                                 default = nil)
  if valid_574695 != nil:
    section.add "client-request-id", valid_574695
  var valid_574696 = header.getOrDefault("ocp-date")
  valid_574696 = validateParameter(valid_574696, JString, required = false,
                                 default = nil)
  if valid_574696 != nil:
    section.add "ocp-date", valid_574696
  var valid_574697 = header.getOrDefault("return-client-request-id")
  valid_574697 = validateParameter(valid_574697, JBool, required = false,
                                 default = newJBool(false))
  if valid_574697 != nil:
    section.add "return-client-request-id", valid_574697
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574698: Call_TaskListSubtasks_574687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If the Task is not a multi-instance Task then this returns an empty collection.
  ## 
  let valid = call_574698.validator(path, query, header, formData, body)
  let scheme = call_574698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574698.url(scheme.get, call_574698.host, call_574698.base,
                         call_574698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574698, url, valid)

proc call*(call_574699: Call_TaskListSubtasks_574687; apiVersion: string;
          jobId: string; taskId: string; timeout: int = 30; Select: string = ""): Recallable =
  ## taskListSubtasks
  ## If the Task is not a multi-instance Task then this returns an empty collection.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job.
  ##   Select: string
  ##         : An OData $select clause.
  ##   taskId: string (required)
  ##         : The ID of the Task.
  var path_574700 = newJObject()
  var query_574701 = newJObject()
  add(query_574701, "timeout", newJInt(timeout))
  add(query_574701, "api-version", newJString(apiVersion))
  add(path_574700, "jobId", newJString(jobId))
  add(query_574701, "$select", newJString(Select))
  add(path_574700, "taskId", newJString(taskId))
  result = call_574699.call(path_574700, query_574701, nil, nil, nil)

var taskListSubtasks* = Call_TaskListSubtasks_574687(name: "taskListSubtasks",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/subtasksinfo",
    validator: validate_TaskListSubtasks_574688, base: "",
    url: url_TaskListSubtasks_574689, schemes: {Scheme.Https})
type
  Call_TaskTerminate_574702 = ref object of OpenApiRestCall_573667
proc url_TaskTerminate_574704(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  assert "taskId" in path, "`taskId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskId"),
               (kind: ConstantSegment, value: "/terminate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskTerminate_574703(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## When the Task has been terminated, it moves to the completed state. For multi-instance Tasks, the terminate Task operation applies synchronously to the primary task; subtasks are then terminated asynchronously in the background.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job containing the Task.
  ##   taskId: JString (required)
  ##         : The ID of the Task to terminate.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574705 = path.getOrDefault("jobId")
  valid_574705 = validateParameter(valid_574705, JString, required = true,
                                 default = nil)
  if valid_574705 != nil:
    section.add "jobId", valid_574705
  var valid_574706 = path.getOrDefault("taskId")
  valid_574706 = validateParameter(valid_574706, JString, required = true,
                                 default = nil)
  if valid_574706 != nil:
    section.add "taskId", valid_574706
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574707 = query.getOrDefault("timeout")
  valid_574707 = validateParameter(valid_574707, JInt, required = false,
                                 default = newJInt(30))
  if valid_574707 != nil:
    section.add "timeout", valid_574707
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574708 = query.getOrDefault("api-version")
  valid_574708 = validateParameter(valid_574708, JString, required = true,
                                 default = nil)
  if valid_574708 != nil:
    section.add "api-version", valid_574708
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574709 = header.getOrDefault("If-Match")
  valid_574709 = validateParameter(valid_574709, JString, required = false,
                                 default = nil)
  if valid_574709 != nil:
    section.add "If-Match", valid_574709
  var valid_574710 = header.getOrDefault("client-request-id")
  valid_574710 = validateParameter(valid_574710, JString, required = false,
                                 default = nil)
  if valid_574710 != nil:
    section.add "client-request-id", valid_574710
  var valid_574711 = header.getOrDefault("ocp-date")
  valid_574711 = validateParameter(valid_574711, JString, required = false,
                                 default = nil)
  if valid_574711 != nil:
    section.add "ocp-date", valid_574711
  var valid_574712 = header.getOrDefault("If-Unmodified-Since")
  valid_574712 = validateParameter(valid_574712, JString, required = false,
                                 default = nil)
  if valid_574712 != nil:
    section.add "If-Unmodified-Since", valid_574712
  var valid_574713 = header.getOrDefault("If-None-Match")
  valid_574713 = validateParameter(valid_574713, JString, required = false,
                                 default = nil)
  if valid_574713 != nil:
    section.add "If-None-Match", valid_574713
  var valid_574714 = header.getOrDefault("If-Modified-Since")
  valid_574714 = validateParameter(valid_574714, JString, required = false,
                                 default = nil)
  if valid_574714 != nil:
    section.add "If-Modified-Since", valid_574714
  var valid_574715 = header.getOrDefault("return-client-request-id")
  valid_574715 = validateParameter(valid_574715, JBool, required = false,
                                 default = newJBool(false))
  if valid_574715 != nil:
    section.add "return-client-request-id", valid_574715
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574716: Call_TaskTerminate_574702; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When the Task has been terminated, it moves to the completed state. For multi-instance Tasks, the terminate Task operation applies synchronously to the primary task; subtasks are then terminated asynchronously in the background.
  ## 
  let valid = call_574716.validator(path, query, header, formData, body)
  let scheme = call_574716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574716.url(scheme.get, call_574716.host, call_574716.base,
                         call_574716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574716, url, valid)

proc call*(call_574717: Call_TaskTerminate_574702; apiVersion: string; jobId: string;
          taskId: string; timeout: int = 30): Recallable =
  ## taskTerminate
  ## When the Task has been terminated, it moves to the completed state. For multi-instance Tasks, the terminate Task operation applies synchronously to the primary task; subtasks are then terminated asynchronously in the background.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job containing the Task.
  ##   taskId: string (required)
  ##         : The ID of the Task to terminate.
  var path_574718 = newJObject()
  var query_574719 = newJObject()
  add(query_574719, "timeout", newJInt(timeout))
  add(query_574719, "api-version", newJString(apiVersion))
  add(path_574718, "jobId", newJString(jobId))
  add(path_574718, "taskId", newJString(taskId))
  result = call_574717.call(path_574718, query_574719, nil, nil, nil)

var taskTerminate* = Call_TaskTerminate_574702(name: "taskTerminate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/terminate",
    validator: validate_TaskTerminate_574703, base: "", url: url_TaskTerminate_574704,
    schemes: {Scheme.Https})
type
  Call_JobTerminate_574720 = ref object of OpenApiRestCall_573667
proc url_JobTerminate_574722(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/terminate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobTerminate_574721(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## When a Terminate Job request is received, the Batch service sets the Job to the terminating state. The Batch service then terminates any running Tasks associated with the Job and runs any required Job release Tasks. Then the Job moves into the completed state. If there are any Tasks in the Job in the active state, they will remain in the active state. Once a Job is terminated, new Tasks cannot be added and any remaining active Tasks will not be scheduled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job to terminate.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_574723 = path.getOrDefault("jobId")
  valid_574723 = validateParameter(valid_574723, JString, required = true,
                                 default = nil)
  if valid_574723 != nil:
    section.add "jobId", valid_574723
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574724 = query.getOrDefault("timeout")
  valid_574724 = validateParameter(valid_574724, JInt, required = false,
                                 default = newJInt(30))
  if valid_574724 != nil:
    section.add "timeout", valid_574724
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574725 = query.getOrDefault("api-version")
  valid_574725 = validateParameter(valid_574725, JString, required = true,
                                 default = nil)
  if valid_574725 != nil:
    section.add "api-version", valid_574725
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574726 = header.getOrDefault("If-Match")
  valid_574726 = validateParameter(valid_574726, JString, required = false,
                                 default = nil)
  if valid_574726 != nil:
    section.add "If-Match", valid_574726
  var valid_574727 = header.getOrDefault("client-request-id")
  valid_574727 = validateParameter(valid_574727, JString, required = false,
                                 default = nil)
  if valid_574727 != nil:
    section.add "client-request-id", valid_574727
  var valid_574728 = header.getOrDefault("ocp-date")
  valid_574728 = validateParameter(valid_574728, JString, required = false,
                                 default = nil)
  if valid_574728 != nil:
    section.add "ocp-date", valid_574728
  var valid_574729 = header.getOrDefault("If-Unmodified-Since")
  valid_574729 = validateParameter(valid_574729, JString, required = false,
                                 default = nil)
  if valid_574729 != nil:
    section.add "If-Unmodified-Since", valid_574729
  var valid_574730 = header.getOrDefault("If-None-Match")
  valid_574730 = validateParameter(valid_574730, JString, required = false,
                                 default = nil)
  if valid_574730 != nil:
    section.add "If-None-Match", valid_574730
  var valid_574731 = header.getOrDefault("If-Modified-Since")
  valid_574731 = validateParameter(valid_574731, JString, required = false,
                                 default = nil)
  if valid_574731 != nil:
    section.add "If-Modified-Since", valid_574731
  var valid_574732 = header.getOrDefault("return-client-request-id")
  valid_574732 = validateParameter(valid_574732, JBool, required = false,
                                 default = newJBool(false))
  if valid_574732 != nil:
    section.add "return-client-request-id", valid_574732
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobTerminateParameter: JObject
  ##                        : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574734: Call_JobTerminate_574720; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When a Terminate Job request is received, the Batch service sets the Job to the terminating state. The Batch service then terminates any running Tasks associated with the Job and runs any required Job release Tasks. Then the Job moves into the completed state. If there are any Tasks in the Job in the active state, they will remain in the active state. Once a Job is terminated, new Tasks cannot be added and any remaining active Tasks will not be scheduled.
  ## 
  let valid = call_574734.validator(path, query, header, formData, body)
  let scheme = call_574734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574734.url(scheme.get, call_574734.host, call_574734.base,
                         call_574734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574734, url, valid)

proc call*(call_574735: Call_JobTerminate_574720; apiVersion: string; jobId: string;
          timeout: int = 30; jobTerminateParameter: JsonNode = nil): Recallable =
  ## jobTerminate
  ## When a Terminate Job request is received, the Batch service sets the Job to the terminating state. The Batch service then terminates any running Tasks associated with the Job and runs any required Job release Tasks. Then the Job moves into the completed state. If there are any Tasks in the Job in the active state, they will remain in the active state. Once a Job is terminated, new Tasks cannot be added and any remaining active Tasks will not be scheduled.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job to terminate.
  ##   jobTerminateParameter: JObject
  ##                        : The parameters for the request.
  var path_574736 = newJObject()
  var query_574737 = newJObject()
  var body_574738 = newJObject()
  add(query_574737, "timeout", newJInt(timeout))
  add(query_574737, "api-version", newJString(apiVersion))
  add(path_574736, "jobId", newJString(jobId))
  if jobTerminateParameter != nil:
    body_574738 = jobTerminateParameter
  result = call_574735.call(path_574736, query_574737, nil, nil, body_574738)

var jobTerminate* = Call_JobTerminate_574720(name: "jobTerminate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/terminate", validator: validate_JobTerminate_574721,
    base: "", url: url_JobTerminate_574722, schemes: {Scheme.Https})
type
  Call_JobScheduleAdd_574754 = ref object of OpenApiRestCall_573667
proc url_JobScheduleAdd_574756(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobScheduleAdd_574755(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574757 = query.getOrDefault("timeout")
  valid_574757 = validateParameter(valid_574757, JInt, required = false,
                                 default = newJInt(30))
  if valid_574757 != nil:
    section.add "timeout", valid_574757
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574758 = query.getOrDefault("api-version")
  valid_574758 = validateParameter(valid_574758, JString, required = true,
                                 default = nil)
  if valid_574758 != nil:
    section.add "api-version", valid_574758
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574759 = header.getOrDefault("client-request-id")
  valid_574759 = validateParameter(valid_574759, JString, required = false,
                                 default = nil)
  if valid_574759 != nil:
    section.add "client-request-id", valid_574759
  var valid_574760 = header.getOrDefault("ocp-date")
  valid_574760 = validateParameter(valid_574760, JString, required = false,
                                 default = nil)
  if valid_574760 != nil:
    section.add "ocp-date", valid_574760
  var valid_574761 = header.getOrDefault("return-client-request-id")
  valid_574761 = validateParameter(valid_574761, JBool, required = false,
                                 default = newJBool(false))
  if valid_574761 != nil:
    section.add "return-client-request-id", valid_574761
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   cloudJobSchedule: JObject (required)
  ##                   : The Job Schedule to be added.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574763: Call_JobScheduleAdd_574754; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574763.validator(path, query, header, formData, body)
  let scheme = call_574763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574763.url(scheme.get, call_574763.host, call_574763.base,
                         call_574763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574763, url, valid)

proc call*(call_574764: Call_JobScheduleAdd_574754; apiVersion: string;
          cloudJobSchedule: JsonNode; timeout: int = 30): Recallable =
  ## jobScheduleAdd
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   cloudJobSchedule: JObject (required)
  ##                   : The Job Schedule to be added.
  var query_574765 = newJObject()
  var body_574766 = newJObject()
  add(query_574765, "timeout", newJInt(timeout))
  add(query_574765, "api-version", newJString(apiVersion))
  if cloudJobSchedule != nil:
    body_574766 = cloudJobSchedule
  result = call_574764.call(nil, query_574765, nil, nil, body_574766)

var jobScheduleAdd* = Call_JobScheduleAdd_574754(name: "jobScheduleAdd",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/jobschedules",
    validator: validate_JobScheduleAdd_574755, base: "", url: url_JobScheduleAdd_574756,
    schemes: {Scheme.Https})
type
  Call_JobScheduleList_574739 = ref object of OpenApiRestCall_573667
proc url_JobScheduleList_574741(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobScheduleList_574740(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 Job Schedules can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-schedules.
  section = newJObject()
  var valid_574742 = query.getOrDefault("timeout")
  valid_574742 = validateParameter(valid_574742, JInt, required = false,
                                 default = newJInt(30))
  if valid_574742 != nil:
    section.add "timeout", valid_574742
  var valid_574743 = query.getOrDefault("$expand")
  valid_574743 = validateParameter(valid_574743, JString, required = false,
                                 default = nil)
  if valid_574743 != nil:
    section.add "$expand", valid_574743
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574744 = query.getOrDefault("api-version")
  valid_574744 = validateParameter(valid_574744, JString, required = true,
                                 default = nil)
  if valid_574744 != nil:
    section.add "api-version", valid_574744
  var valid_574745 = query.getOrDefault("maxresults")
  valid_574745 = validateParameter(valid_574745, JInt, required = false,
                                 default = newJInt(1000))
  if valid_574745 != nil:
    section.add "maxresults", valid_574745
  var valid_574746 = query.getOrDefault("$select")
  valid_574746 = validateParameter(valid_574746, JString, required = false,
                                 default = nil)
  if valid_574746 != nil:
    section.add "$select", valid_574746
  var valid_574747 = query.getOrDefault("$filter")
  valid_574747 = validateParameter(valid_574747, JString, required = false,
                                 default = nil)
  if valid_574747 != nil:
    section.add "$filter", valid_574747
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574748 = header.getOrDefault("client-request-id")
  valid_574748 = validateParameter(valid_574748, JString, required = false,
                                 default = nil)
  if valid_574748 != nil:
    section.add "client-request-id", valid_574748
  var valid_574749 = header.getOrDefault("ocp-date")
  valid_574749 = validateParameter(valid_574749, JString, required = false,
                                 default = nil)
  if valid_574749 != nil:
    section.add "ocp-date", valid_574749
  var valid_574750 = header.getOrDefault("return-client-request-id")
  valid_574750 = validateParameter(valid_574750, JBool, required = false,
                                 default = newJBool(false))
  if valid_574750 != nil:
    section.add "return-client-request-id", valid_574750
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574751: Call_JobScheduleList_574739; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574751.validator(path, query, header, formData, body)
  let scheme = call_574751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574751.url(scheme.get, call_574751.host, call_574751.base,
                         call_574751.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574751, url, valid)

proc call*(call_574752: Call_JobScheduleList_574739; apiVersion: string;
          timeout: int = 30; Expand: string = ""; maxresults: int = 1000;
          Select: string = ""; Filter: string = ""): Recallable =
  ## jobScheduleList
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 Job Schedules can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-schedules.
  var query_574753 = newJObject()
  add(query_574753, "timeout", newJInt(timeout))
  add(query_574753, "$expand", newJString(Expand))
  add(query_574753, "api-version", newJString(apiVersion))
  add(query_574753, "maxresults", newJInt(maxresults))
  add(query_574753, "$select", newJString(Select))
  add(query_574753, "$filter", newJString(Filter))
  result = call_574752.call(nil, query_574753, nil, nil, nil)

var jobScheduleList* = Call_JobScheduleList_574739(name: "jobScheduleList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/jobschedules",
    validator: validate_JobScheduleList_574740, base: "", url: url_JobScheduleList_574741,
    schemes: {Scheme.Https})
type
  Call_JobScheduleUpdate_574786 = ref object of OpenApiRestCall_573667
proc url_JobScheduleUpdate_574788(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobScheduleId" in path, "`jobScheduleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobschedules/"),
               (kind: VariableSegment, value: "jobScheduleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobScheduleUpdate_574787(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## This fully replaces all the updatable properties of the Job Schedule. For example, if the schedule property is not specified with this request, then the Batch service will remove the existing schedule. Changes to a Job Schedule only impact Jobs created by the schedule after the update has taken place; currently running Jobs are unaffected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the Job Schedule to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_574789 = path.getOrDefault("jobScheduleId")
  valid_574789 = validateParameter(valid_574789, JString, required = true,
                                 default = nil)
  if valid_574789 != nil:
    section.add "jobScheduleId", valid_574789
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574790 = query.getOrDefault("timeout")
  valid_574790 = validateParameter(valid_574790, JInt, required = false,
                                 default = newJInt(30))
  if valid_574790 != nil:
    section.add "timeout", valid_574790
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574791 = query.getOrDefault("api-version")
  valid_574791 = validateParameter(valid_574791, JString, required = true,
                                 default = nil)
  if valid_574791 != nil:
    section.add "api-version", valid_574791
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574792 = header.getOrDefault("If-Match")
  valid_574792 = validateParameter(valid_574792, JString, required = false,
                                 default = nil)
  if valid_574792 != nil:
    section.add "If-Match", valid_574792
  var valid_574793 = header.getOrDefault("client-request-id")
  valid_574793 = validateParameter(valid_574793, JString, required = false,
                                 default = nil)
  if valid_574793 != nil:
    section.add "client-request-id", valid_574793
  var valid_574794 = header.getOrDefault("ocp-date")
  valid_574794 = validateParameter(valid_574794, JString, required = false,
                                 default = nil)
  if valid_574794 != nil:
    section.add "ocp-date", valid_574794
  var valid_574795 = header.getOrDefault("If-Unmodified-Since")
  valid_574795 = validateParameter(valid_574795, JString, required = false,
                                 default = nil)
  if valid_574795 != nil:
    section.add "If-Unmodified-Since", valid_574795
  var valid_574796 = header.getOrDefault("If-None-Match")
  valid_574796 = validateParameter(valid_574796, JString, required = false,
                                 default = nil)
  if valid_574796 != nil:
    section.add "If-None-Match", valid_574796
  var valid_574797 = header.getOrDefault("If-Modified-Since")
  valid_574797 = validateParameter(valid_574797, JString, required = false,
                                 default = nil)
  if valid_574797 != nil:
    section.add "If-Modified-Since", valid_574797
  var valid_574798 = header.getOrDefault("return-client-request-id")
  valid_574798 = validateParameter(valid_574798, JBool, required = false,
                                 default = newJBool(false))
  if valid_574798 != nil:
    section.add "return-client-request-id", valid_574798
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobScheduleUpdateParameter: JObject (required)
  ##                             : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574800: Call_JobScheduleUpdate_574786; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This fully replaces all the updatable properties of the Job Schedule. For example, if the schedule property is not specified with this request, then the Batch service will remove the existing schedule. Changes to a Job Schedule only impact Jobs created by the schedule after the update has taken place; currently running Jobs are unaffected.
  ## 
  let valid = call_574800.validator(path, query, header, formData, body)
  let scheme = call_574800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574800.url(scheme.get, call_574800.host, call_574800.base,
                         call_574800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574800, url, valid)

proc call*(call_574801: Call_JobScheduleUpdate_574786; jobScheduleId: string;
          apiVersion: string; jobScheduleUpdateParameter: JsonNode;
          timeout: int = 30): Recallable =
  ## jobScheduleUpdate
  ## This fully replaces all the updatable properties of the Job Schedule. For example, if the schedule property is not specified with this request, then the Batch service will remove the existing schedule. Changes to a Job Schedule only impact Jobs created by the schedule after the update has taken place; currently running Jobs are unaffected.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule to update.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobScheduleUpdateParameter: JObject (required)
  ##                             : The parameters for the request.
  var path_574802 = newJObject()
  var query_574803 = newJObject()
  var body_574804 = newJObject()
  add(query_574803, "timeout", newJInt(timeout))
  add(path_574802, "jobScheduleId", newJString(jobScheduleId))
  add(query_574803, "api-version", newJString(apiVersion))
  if jobScheduleUpdateParameter != nil:
    body_574804 = jobScheduleUpdateParameter
  result = call_574801.call(path_574802, query_574803, nil, nil, body_574804)

var jobScheduleUpdate* = Call_JobScheduleUpdate_574786(name: "jobScheduleUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleUpdate_574787,
    base: "", url: url_JobScheduleUpdate_574788, schemes: {Scheme.Https})
type
  Call_JobScheduleExists_574822 = ref object of OpenApiRestCall_573667
proc url_JobScheduleExists_574824(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobScheduleId" in path, "`jobScheduleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobschedules/"),
               (kind: VariableSegment, value: "jobScheduleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobScheduleExists_574823(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the Job Schedule which you want to check.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_574825 = path.getOrDefault("jobScheduleId")
  valid_574825 = validateParameter(valid_574825, JString, required = true,
                                 default = nil)
  if valid_574825 != nil:
    section.add "jobScheduleId", valid_574825
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574826 = query.getOrDefault("timeout")
  valid_574826 = validateParameter(valid_574826, JInt, required = false,
                                 default = newJInt(30))
  if valid_574826 != nil:
    section.add "timeout", valid_574826
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574827 = query.getOrDefault("api-version")
  valid_574827 = validateParameter(valid_574827, JString, required = true,
                                 default = nil)
  if valid_574827 != nil:
    section.add "api-version", valid_574827
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574828 = header.getOrDefault("If-Match")
  valid_574828 = validateParameter(valid_574828, JString, required = false,
                                 default = nil)
  if valid_574828 != nil:
    section.add "If-Match", valid_574828
  var valid_574829 = header.getOrDefault("client-request-id")
  valid_574829 = validateParameter(valid_574829, JString, required = false,
                                 default = nil)
  if valid_574829 != nil:
    section.add "client-request-id", valid_574829
  var valid_574830 = header.getOrDefault("ocp-date")
  valid_574830 = validateParameter(valid_574830, JString, required = false,
                                 default = nil)
  if valid_574830 != nil:
    section.add "ocp-date", valid_574830
  var valid_574831 = header.getOrDefault("If-Unmodified-Since")
  valid_574831 = validateParameter(valid_574831, JString, required = false,
                                 default = nil)
  if valid_574831 != nil:
    section.add "If-Unmodified-Since", valid_574831
  var valid_574832 = header.getOrDefault("If-None-Match")
  valid_574832 = validateParameter(valid_574832, JString, required = false,
                                 default = nil)
  if valid_574832 != nil:
    section.add "If-None-Match", valid_574832
  var valid_574833 = header.getOrDefault("If-Modified-Since")
  valid_574833 = validateParameter(valid_574833, JString, required = false,
                                 default = nil)
  if valid_574833 != nil:
    section.add "If-Modified-Since", valid_574833
  var valid_574834 = header.getOrDefault("return-client-request-id")
  valid_574834 = validateParameter(valid_574834, JBool, required = false,
                                 default = newJBool(false))
  if valid_574834 != nil:
    section.add "return-client-request-id", valid_574834
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574835: Call_JobScheduleExists_574822; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574835.validator(path, query, header, formData, body)
  let scheme = call_574835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574835.url(scheme.get, call_574835.host, call_574835.base,
                         call_574835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574835, url, valid)

proc call*(call_574836: Call_JobScheduleExists_574822; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleExists
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule which you want to check.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_574837 = newJObject()
  var query_574838 = newJObject()
  add(query_574838, "timeout", newJInt(timeout))
  add(path_574837, "jobScheduleId", newJString(jobScheduleId))
  add(query_574838, "api-version", newJString(apiVersion))
  result = call_574836.call(path_574837, query_574838, nil, nil, nil)

var jobScheduleExists* = Call_JobScheduleExists_574822(name: "jobScheduleExists",
    meth: HttpMethod.HttpHead, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleExists_574823,
    base: "", url: url_JobScheduleExists_574824, schemes: {Scheme.Https})
type
  Call_JobScheduleGet_574767 = ref object of OpenApiRestCall_573667
proc url_JobScheduleGet_574769(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobScheduleId" in path, "`jobScheduleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobschedules/"),
               (kind: VariableSegment, value: "jobScheduleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobScheduleGet_574768(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the specified Job Schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the Job Schedule to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_574770 = path.getOrDefault("jobScheduleId")
  valid_574770 = validateParameter(valid_574770, JString, required = true,
                                 default = nil)
  if valid_574770 != nil:
    section.add "jobScheduleId", valid_574770
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_574771 = query.getOrDefault("timeout")
  valid_574771 = validateParameter(valid_574771, JInt, required = false,
                                 default = newJInt(30))
  if valid_574771 != nil:
    section.add "timeout", valid_574771
  var valid_574772 = query.getOrDefault("$expand")
  valid_574772 = validateParameter(valid_574772, JString, required = false,
                                 default = nil)
  if valid_574772 != nil:
    section.add "$expand", valid_574772
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574773 = query.getOrDefault("api-version")
  valid_574773 = validateParameter(valid_574773, JString, required = true,
                                 default = nil)
  if valid_574773 != nil:
    section.add "api-version", valid_574773
  var valid_574774 = query.getOrDefault("$select")
  valid_574774 = validateParameter(valid_574774, JString, required = false,
                                 default = nil)
  if valid_574774 != nil:
    section.add "$select", valid_574774
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574775 = header.getOrDefault("If-Match")
  valid_574775 = validateParameter(valid_574775, JString, required = false,
                                 default = nil)
  if valid_574775 != nil:
    section.add "If-Match", valid_574775
  var valid_574776 = header.getOrDefault("client-request-id")
  valid_574776 = validateParameter(valid_574776, JString, required = false,
                                 default = nil)
  if valid_574776 != nil:
    section.add "client-request-id", valid_574776
  var valid_574777 = header.getOrDefault("ocp-date")
  valid_574777 = validateParameter(valid_574777, JString, required = false,
                                 default = nil)
  if valid_574777 != nil:
    section.add "ocp-date", valid_574777
  var valid_574778 = header.getOrDefault("If-Unmodified-Since")
  valid_574778 = validateParameter(valid_574778, JString, required = false,
                                 default = nil)
  if valid_574778 != nil:
    section.add "If-Unmodified-Since", valid_574778
  var valid_574779 = header.getOrDefault("If-None-Match")
  valid_574779 = validateParameter(valid_574779, JString, required = false,
                                 default = nil)
  if valid_574779 != nil:
    section.add "If-None-Match", valid_574779
  var valid_574780 = header.getOrDefault("If-Modified-Since")
  valid_574780 = validateParameter(valid_574780, JString, required = false,
                                 default = nil)
  if valid_574780 != nil:
    section.add "If-Modified-Since", valid_574780
  var valid_574781 = header.getOrDefault("return-client-request-id")
  valid_574781 = validateParameter(valid_574781, JBool, required = false,
                                 default = newJBool(false))
  if valid_574781 != nil:
    section.add "return-client-request-id", valid_574781
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574782: Call_JobScheduleGet_574767; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Job Schedule.
  ## 
  let valid = call_574782.validator(path, query, header, formData, body)
  let scheme = call_574782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574782.url(scheme.get, call_574782.host, call_574782.base,
                         call_574782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574782, url, valid)

proc call*(call_574783: Call_JobScheduleGet_574767; jobScheduleId: string;
          apiVersion: string; timeout: int = 30; Expand: string = ""; Select: string = ""): Recallable =
  ## jobScheduleGet
  ## Gets information about the specified Job Schedule.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule to get.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  var path_574784 = newJObject()
  var query_574785 = newJObject()
  add(query_574785, "timeout", newJInt(timeout))
  add(path_574784, "jobScheduleId", newJString(jobScheduleId))
  add(query_574785, "$expand", newJString(Expand))
  add(query_574785, "api-version", newJString(apiVersion))
  add(query_574785, "$select", newJString(Select))
  result = call_574783.call(path_574784, query_574785, nil, nil, nil)

var jobScheduleGet* = Call_JobScheduleGet_574767(name: "jobScheduleGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleGet_574768,
    base: "", url: url_JobScheduleGet_574769, schemes: {Scheme.Https})
type
  Call_JobSchedulePatch_574839 = ref object of OpenApiRestCall_573667
proc url_JobSchedulePatch_574841(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobScheduleId" in path, "`jobScheduleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobschedules/"),
               (kind: VariableSegment, value: "jobScheduleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobSchedulePatch_574840(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## This replaces only the Job Schedule properties specified in the request. For example, if the schedule property is not specified with this request, then the Batch service will keep the existing schedule. Changes to a Job Schedule only impact Jobs created by the schedule after the update has taken place; currently running Jobs are unaffected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the Job Schedule to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_574842 = path.getOrDefault("jobScheduleId")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "jobScheduleId", valid_574842
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574843 = query.getOrDefault("timeout")
  valid_574843 = validateParameter(valid_574843, JInt, required = false,
                                 default = newJInt(30))
  if valid_574843 != nil:
    section.add "timeout", valid_574843
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574844 = query.getOrDefault("api-version")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "api-version", valid_574844
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574845 = header.getOrDefault("If-Match")
  valid_574845 = validateParameter(valid_574845, JString, required = false,
                                 default = nil)
  if valid_574845 != nil:
    section.add "If-Match", valid_574845
  var valid_574846 = header.getOrDefault("client-request-id")
  valid_574846 = validateParameter(valid_574846, JString, required = false,
                                 default = nil)
  if valid_574846 != nil:
    section.add "client-request-id", valid_574846
  var valid_574847 = header.getOrDefault("ocp-date")
  valid_574847 = validateParameter(valid_574847, JString, required = false,
                                 default = nil)
  if valid_574847 != nil:
    section.add "ocp-date", valid_574847
  var valid_574848 = header.getOrDefault("If-Unmodified-Since")
  valid_574848 = validateParameter(valid_574848, JString, required = false,
                                 default = nil)
  if valid_574848 != nil:
    section.add "If-Unmodified-Since", valid_574848
  var valid_574849 = header.getOrDefault("If-None-Match")
  valid_574849 = validateParameter(valid_574849, JString, required = false,
                                 default = nil)
  if valid_574849 != nil:
    section.add "If-None-Match", valid_574849
  var valid_574850 = header.getOrDefault("If-Modified-Since")
  valid_574850 = validateParameter(valid_574850, JString, required = false,
                                 default = nil)
  if valid_574850 != nil:
    section.add "If-Modified-Since", valid_574850
  var valid_574851 = header.getOrDefault("return-client-request-id")
  valid_574851 = validateParameter(valid_574851, JBool, required = false,
                                 default = newJBool(false))
  if valid_574851 != nil:
    section.add "return-client-request-id", valid_574851
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobSchedulePatchParameter: JObject (required)
  ##                            : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574853: Call_JobSchedulePatch_574839; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This replaces only the Job Schedule properties specified in the request. For example, if the schedule property is not specified with this request, then the Batch service will keep the existing schedule. Changes to a Job Schedule only impact Jobs created by the schedule after the update has taken place; currently running Jobs are unaffected.
  ## 
  let valid = call_574853.validator(path, query, header, formData, body)
  let scheme = call_574853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574853.url(scheme.get, call_574853.host, call_574853.base,
                         call_574853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574853, url, valid)

proc call*(call_574854: Call_JobSchedulePatch_574839; jobScheduleId: string;
          apiVersion: string; jobSchedulePatchParameter: JsonNode; timeout: int = 30): Recallable =
  ## jobSchedulePatch
  ## This replaces only the Job Schedule properties specified in the request. For example, if the schedule property is not specified with this request, then the Batch service will keep the existing schedule. Changes to a Job Schedule only impact Jobs created by the schedule after the update has taken place; currently running Jobs are unaffected.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule to update.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobSchedulePatchParameter: JObject (required)
  ##                            : The parameters for the request.
  var path_574855 = newJObject()
  var query_574856 = newJObject()
  var body_574857 = newJObject()
  add(query_574856, "timeout", newJInt(timeout))
  add(path_574855, "jobScheduleId", newJString(jobScheduleId))
  add(query_574856, "api-version", newJString(apiVersion))
  if jobSchedulePatchParameter != nil:
    body_574857 = jobSchedulePatchParameter
  result = call_574854.call(path_574855, query_574856, nil, nil, body_574857)

var jobSchedulePatch* = Call_JobSchedulePatch_574839(name: "jobSchedulePatch",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobSchedulePatch_574840,
    base: "", url: url_JobSchedulePatch_574841, schemes: {Scheme.Https})
type
  Call_JobScheduleDelete_574805 = ref object of OpenApiRestCall_573667
proc url_JobScheduleDelete_574807(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobScheduleId" in path, "`jobScheduleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobschedules/"),
               (kind: VariableSegment, value: "jobScheduleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobScheduleDelete_574806(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## When you delete a Job Schedule, this also deletes all Jobs and Tasks under that schedule. When Tasks are deleted, all the files in their working directories on the Compute Nodes are also deleted (the retention period is ignored). The Job Schedule statistics are no longer accessible once the Job Schedule is deleted, though they are still counted towards Account lifetime statistics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the Job Schedule to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_574808 = path.getOrDefault("jobScheduleId")
  valid_574808 = validateParameter(valid_574808, JString, required = true,
                                 default = nil)
  if valid_574808 != nil:
    section.add "jobScheduleId", valid_574808
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574809 = query.getOrDefault("timeout")
  valid_574809 = validateParameter(valid_574809, JInt, required = false,
                                 default = newJInt(30))
  if valid_574809 != nil:
    section.add "timeout", valid_574809
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574810 = query.getOrDefault("api-version")
  valid_574810 = validateParameter(valid_574810, JString, required = true,
                                 default = nil)
  if valid_574810 != nil:
    section.add "api-version", valid_574810
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574811 = header.getOrDefault("If-Match")
  valid_574811 = validateParameter(valid_574811, JString, required = false,
                                 default = nil)
  if valid_574811 != nil:
    section.add "If-Match", valid_574811
  var valid_574812 = header.getOrDefault("client-request-id")
  valid_574812 = validateParameter(valid_574812, JString, required = false,
                                 default = nil)
  if valid_574812 != nil:
    section.add "client-request-id", valid_574812
  var valid_574813 = header.getOrDefault("ocp-date")
  valid_574813 = validateParameter(valid_574813, JString, required = false,
                                 default = nil)
  if valid_574813 != nil:
    section.add "ocp-date", valid_574813
  var valid_574814 = header.getOrDefault("If-Unmodified-Since")
  valid_574814 = validateParameter(valid_574814, JString, required = false,
                                 default = nil)
  if valid_574814 != nil:
    section.add "If-Unmodified-Since", valid_574814
  var valid_574815 = header.getOrDefault("If-None-Match")
  valid_574815 = validateParameter(valid_574815, JString, required = false,
                                 default = nil)
  if valid_574815 != nil:
    section.add "If-None-Match", valid_574815
  var valid_574816 = header.getOrDefault("If-Modified-Since")
  valid_574816 = validateParameter(valid_574816, JString, required = false,
                                 default = nil)
  if valid_574816 != nil:
    section.add "If-Modified-Since", valid_574816
  var valid_574817 = header.getOrDefault("return-client-request-id")
  valid_574817 = validateParameter(valid_574817, JBool, required = false,
                                 default = newJBool(false))
  if valid_574817 != nil:
    section.add "return-client-request-id", valid_574817
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574818: Call_JobScheduleDelete_574805; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you delete a Job Schedule, this also deletes all Jobs and Tasks under that schedule. When Tasks are deleted, all the files in their working directories on the Compute Nodes are also deleted (the retention period is ignored). The Job Schedule statistics are no longer accessible once the Job Schedule is deleted, though they are still counted towards Account lifetime statistics.
  ## 
  let valid = call_574818.validator(path, query, header, formData, body)
  let scheme = call_574818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574818.url(scheme.get, call_574818.host, call_574818.base,
                         call_574818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574818, url, valid)

proc call*(call_574819: Call_JobScheduleDelete_574805; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleDelete
  ## When you delete a Job Schedule, this also deletes all Jobs and Tasks under that schedule. When Tasks are deleted, all the files in their working directories on the Compute Nodes are also deleted (the retention period is ignored). The Job Schedule statistics are no longer accessible once the Job Schedule is deleted, though they are still counted towards Account lifetime statistics.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule to delete.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_574820 = newJObject()
  var query_574821 = newJObject()
  add(query_574821, "timeout", newJInt(timeout))
  add(path_574820, "jobScheduleId", newJString(jobScheduleId))
  add(query_574821, "api-version", newJString(apiVersion))
  result = call_574819.call(path_574820, query_574821, nil, nil, nil)

var jobScheduleDelete* = Call_JobScheduleDelete_574805(name: "jobScheduleDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleDelete_574806,
    base: "", url: url_JobScheduleDelete_574807, schemes: {Scheme.Https})
type
  Call_JobScheduleDisable_574858 = ref object of OpenApiRestCall_573667
proc url_JobScheduleDisable_574860(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobScheduleId" in path, "`jobScheduleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobschedules/"),
               (kind: VariableSegment, value: "jobScheduleId"),
               (kind: ConstantSegment, value: "/disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobScheduleDisable_574859(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## No new Jobs will be created until the Job Schedule is enabled again.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the Job Schedule to disable.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_574861 = path.getOrDefault("jobScheduleId")
  valid_574861 = validateParameter(valid_574861, JString, required = true,
                                 default = nil)
  if valid_574861 != nil:
    section.add "jobScheduleId", valid_574861
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574862 = query.getOrDefault("timeout")
  valid_574862 = validateParameter(valid_574862, JInt, required = false,
                                 default = newJInt(30))
  if valid_574862 != nil:
    section.add "timeout", valid_574862
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574863 = query.getOrDefault("api-version")
  valid_574863 = validateParameter(valid_574863, JString, required = true,
                                 default = nil)
  if valid_574863 != nil:
    section.add "api-version", valid_574863
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574864 = header.getOrDefault("If-Match")
  valid_574864 = validateParameter(valid_574864, JString, required = false,
                                 default = nil)
  if valid_574864 != nil:
    section.add "If-Match", valid_574864
  var valid_574865 = header.getOrDefault("client-request-id")
  valid_574865 = validateParameter(valid_574865, JString, required = false,
                                 default = nil)
  if valid_574865 != nil:
    section.add "client-request-id", valid_574865
  var valid_574866 = header.getOrDefault("ocp-date")
  valid_574866 = validateParameter(valid_574866, JString, required = false,
                                 default = nil)
  if valid_574866 != nil:
    section.add "ocp-date", valid_574866
  var valid_574867 = header.getOrDefault("If-Unmodified-Since")
  valid_574867 = validateParameter(valid_574867, JString, required = false,
                                 default = nil)
  if valid_574867 != nil:
    section.add "If-Unmodified-Since", valid_574867
  var valid_574868 = header.getOrDefault("If-None-Match")
  valid_574868 = validateParameter(valid_574868, JString, required = false,
                                 default = nil)
  if valid_574868 != nil:
    section.add "If-None-Match", valid_574868
  var valid_574869 = header.getOrDefault("If-Modified-Since")
  valid_574869 = validateParameter(valid_574869, JString, required = false,
                                 default = nil)
  if valid_574869 != nil:
    section.add "If-Modified-Since", valid_574869
  var valid_574870 = header.getOrDefault("return-client-request-id")
  valid_574870 = validateParameter(valid_574870, JBool, required = false,
                                 default = newJBool(false))
  if valid_574870 != nil:
    section.add "return-client-request-id", valid_574870
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574871: Call_JobScheduleDisable_574858; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## No new Jobs will be created until the Job Schedule is enabled again.
  ## 
  let valid = call_574871.validator(path, query, header, formData, body)
  let scheme = call_574871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574871.url(scheme.get, call_574871.host, call_574871.base,
                         call_574871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574871, url, valid)

proc call*(call_574872: Call_JobScheduleDisable_574858; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleDisable
  ## No new Jobs will be created until the Job Schedule is enabled again.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule to disable.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_574873 = newJObject()
  var query_574874 = newJObject()
  add(query_574874, "timeout", newJInt(timeout))
  add(path_574873, "jobScheduleId", newJString(jobScheduleId))
  add(query_574874, "api-version", newJString(apiVersion))
  result = call_574872.call(path_574873, query_574874, nil, nil, nil)

var jobScheduleDisable* = Call_JobScheduleDisable_574858(
    name: "jobScheduleDisable", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/disable",
    validator: validate_JobScheduleDisable_574859, base: "",
    url: url_JobScheduleDisable_574860, schemes: {Scheme.Https})
type
  Call_JobScheduleEnable_574875 = ref object of OpenApiRestCall_573667
proc url_JobScheduleEnable_574877(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobScheduleId" in path, "`jobScheduleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobschedules/"),
               (kind: VariableSegment, value: "jobScheduleId"),
               (kind: ConstantSegment, value: "/enable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobScheduleEnable_574876(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the Job Schedule to enable.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_574878 = path.getOrDefault("jobScheduleId")
  valid_574878 = validateParameter(valid_574878, JString, required = true,
                                 default = nil)
  if valid_574878 != nil:
    section.add "jobScheduleId", valid_574878
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574879 = query.getOrDefault("timeout")
  valid_574879 = validateParameter(valid_574879, JInt, required = false,
                                 default = newJInt(30))
  if valid_574879 != nil:
    section.add "timeout", valid_574879
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574880 = query.getOrDefault("api-version")
  valid_574880 = validateParameter(valid_574880, JString, required = true,
                                 default = nil)
  if valid_574880 != nil:
    section.add "api-version", valid_574880
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574881 = header.getOrDefault("If-Match")
  valid_574881 = validateParameter(valid_574881, JString, required = false,
                                 default = nil)
  if valid_574881 != nil:
    section.add "If-Match", valid_574881
  var valid_574882 = header.getOrDefault("client-request-id")
  valid_574882 = validateParameter(valid_574882, JString, required = false,
                                 default = nil)
  if valid_574882 != nil:
    section.add "client-request-id", valid_574882
  var valid_574883 = header.getOrDefault("ocp-date")
  valid_574883 = validateParameter(valid_574883, JString, required = false,
                                 default = nil)
  if valid_574883 != nil:
    section.add "ocp-date", valid_574883
  var valid_574884 = header.getOrDefault("If-Unmodified-Since")
  valid_574884 = validateParameter(valid_574884, JString, required = false,
                                 default = nil)
  if valid_574884 != nil:
    section.add "If-Unmodified-Since", valid_574884
  var valid_574885 = header.getOrDefault("If-None-Match")
  valid_574885 = validateParameter(valid_574885, JString, required = false,
                                 default = nil)
  if valid_574885 != nil:
    section.add "If-None-Match", valid_574885
  var valid_574886 = header.getOrDefault("If-Modified-Since")
  valid_574886 = validateParameter(valid_574886, JString, required = false,
                                 default = nil)
  if valid_574886 != nil:
    section.add "If-Modified-Since", valid_574886
  var valid_574887 = header.getOrDefault("return-client-request-id")
  valid_574887 = validateParameter(valid_574887, JBool, required = false,
                                 default = newJBool(false))
  if valid_574887 != nil:
    section.add "return-client-request-id", valid_574887
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574888: Call_JobScheduleEnable_574875; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574888.validator(path, query, header, formData, body)
  let scheme = call_574888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574888.url(scheme.get, call_574888.host, call_574888.base,
                         call_574888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574888, url, valid)

proc call*(call_574889: Call_JobScheduleEnable_574875; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleEnable
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule to enable.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_574890 = newJObject()
  var query_574891 = newJObject()
  add(query_574891, "timeout", newJInt(timeout))
  add(path_574890, "jobScheduleId", newJString(jobScheduleId))
  add(query_574891, "api-version", newJString(apiVersion))
  result = call_574889.call(path_574890, query_574891, nil, nil, nil)

var jobScheduleEnable* = Call_JobScheduleEnable_574875(name: "jobScheduleEnable",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/enable",
    validator: validate_JobScheduleEnable_574876, base: "",
    url: url_JobScheduleEnable_574877, schemes: {Scheme.Https})
type
  Call_JobListFromJobSchedule_574892 = ref object of OpenApiRestCall_573667
proc url_JobListFromJobSchedule_574894(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobScheduleId" in path, "`jobScheduleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobschedules/"),
               (kind: VariableSegment, value: "jobScheduleId"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobListFromJobSchedule_574893(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the Job Schedule from which you want to get a list of Jobs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_574895 = path.getOrDefault("jobScheduleId")
  valid_574895 = validateParameter(valid_574895, JString, required = true,
                                 default = nil)
  if valid_574895 != nil:
    section.add "jobScheduleId", valid_574895
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 Jobs can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs-in-a-job-schedule.
  section = newJObject()
  var valid_574896 = query.getOrDefault("timeout")
  valid_574896 = validateParameter(valid_574896, JInt, required = false,
                                 default = newJInt(30))
  if valid_574896 != nil:
    section.add "timeout", valid_574896
  var valid_574897 = query.getOrDefault("$expand")
  valid_574897 = validateParameter(valid_574897, JString, required = false,
                                 default = nil)
  if valid_574897 != nil:
    section.add "$expand", valid_574897
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574898 = query.getOrDefault("api-version")
  valid_574898 = validateParameter(valid_574898, JString, required = true,
                                 default = nil)
  if valid_574898 != nil:
    section.add "api-version", valid_574898
  var valid_574899 = query.getOrDefault("maxresults")
  valid_574899 = validateParameter(valid_574899, JInt, required = false,
                                 default = newJInt(1000))
  if valid_574899 != nil:
    section.add "maxresults", valid_574899
  var valid_574900 = query.getOrDefault("$select")
  valid_574900 = validateParameter(valid_574900, JString, required = false,
                                 default = nil)
  if valid_574900 != nil:
    section.add "$select", valid_574900
  var valid_574901 = query.getOrDefault("$filter")
  valid_574901 = validateParameter(valid_574901, JString, required = false,
                                 default = nil)
  if valid_574901 != nil:
    section.add "$filter", valid_574901
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574902 = header.getOrDefault("client-request-id")
  valid_574902 = validateParameter(valid_574902, JString, required = false,
                                 default = nil)
  if valid_574902 != nil:
    section.add "client-request-id", valid_574902
  var valid_574903 = header.getOrDefault("ocp-date")
  valid_574903 = validateParameter(valid_574903, JString, required = false,
                                 default = nil)
  if valid_574903 != nil:
    section.add "ocp-date", valid_574903
  var valid_574904 = header.getOrDefault("return-client-request-id")
  valid_574904 = validateParameter(valid_574904, JBool, required = false,
                                 default = newJBool(false))
  if valid_574904 != nil:
    section.add "return-client-request-id", valid_574904
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574905: Call_JobListFromJobSchedule_574892; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574905.validator(path, query, header, formData, body)
  let scheme = call_574905.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574905.url(scheme.get, call_574905.host, call_574905.base,
                         call_574905.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574905, url, valid)

proc call*(call_574906: Call_JobListFromJobSchedule_574892; jobScheduleId: string;
          apiVersion: string; timeout: int = 30; Expand: string = "";
          maxresults: int = 1000; Select: string = ""; Filter: string = ""): Recallable =
  ## jobListFromJobSchedule
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule from which you want to get a list of Jobs.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 Jobs can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs-in-a-job-schedule.
  var path_574907 = newJObject()
  var query_574908 = newJObject()
  add(query_574908, "timeout", newJInt(timeout))
  add(path_574907, "jobScheduleId", newJString(jobScheduleId))
  add(query_574908, "$expand", newJString(Expand))
  add(query_574908, "api-version", newJString(apiVersion))
  add(query_574908, "maxresults", newJInt(maxresults))
  add(query_574908, "$select", newJString(Select))
  add(query_574908, "$filter", newJString(Filter))
  result = call_574906.call(path_574907, query_574908, nil, nil, nil)

var jobListFromJobSchedule* = Call_JobListFromJobSchedule_574892(
    name: "jobListFromJobSchedule", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/jobs",
    validator: validate_JobListFromJobSchedule_574893, base: "",
    url: url_JobListFromJobSchedule_574894, schemes: {Scheme.Https})
type
  Call_JobScheduleTerminate_574909 = ref object of OpenApiRestCall_573667
proc url_JobScheduleTerminate_574911(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobScheduleId" in path, "`jobScheduleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/jobschedules/"),
               (kind: VariableSegment, value: "jobScheduleId"),
               (kind: ConstantSegment, value: "/terminate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobScheduleTerminate_574910(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the Job Schedule to terminates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_574912 = path.getOrDefault("jobScheduleId")
  valid_574912 = validateParameter(valid_574912, JString, required = true,
                                 default = nil)
  if valid_574912 != nil:
    section.add "jobScheduleId", valid_574912
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574913 = query.getOrDefault("timeout")
  valid_574913 = validateParameter(valid_574913, JInt, required = false,
                                 default = newJInt(30))
  if valid_574913 != nil:
    section.add "timeout", valid_574913
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574914 = query.getOrDefault("api-version")
  valid_574914 = validateParameter(valid_574914, JString, required = true,
                                 default = nil)
  if valid_574914 != nil:
    section.add "api-version", valid_574914
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574915 = header.getOrDefault("If-Match")
  valid_574915 = validateParameter(valid_574915, JString, required = false,
                                 default = nil)
  if valid_574915 != nil:
    section.add "If-Match", valid_574915
  var valid_574916 = header.getOrDefault("client-request-id")
  valid_574916 = validateParameter(valid_574916, JString, required = false,
                                 default = nil)
  if valid_574916 != nil:
    section.add "client-request-id", valid_574916
  var valid_574917 = header.getOrDefault("ocp-date")
  valid_574917 = validateParameter(valid_574917, JString, required = false,
                                 default = nil)
  if valid_574917 != nil:
    section.add "ocp-date", valid_574917
  var valid_574918 = header.getOrDefault("If-Unmodified-Since")
  valid_574918 = validateParameter(valid_574918, JString, required = false,
                                 default = nil)
  if valid_574918 != nil:
    section.add "If-Unmodified-Since", valid_574918
  var valid_574919 = header.getOrDefault("If-None-Match")
  valid_574919 = validateParameter(valid_574919, JString, required = false,
                                 default = nil)
  if valid_574919 != nil:
    section.add "If-None-Match", valid_574919
  var valid_574920 = header.getOrDefault("If-Modified-Since")
  valid_574920 = validateParameter(valid_574920, JString, required = false,
                                 default = nil)
  if valid_574920 != nil:
    section.add "If-Modified-Since", valid_574920
  var valid_574921 = header.getOrDefault("return-client-request-id")
  valid_574921 = validateParameter(valid_574921, JBool, required = false,
                                 default = newJBool(false))
  if valid_574921 != nil:
    section.add "return-client-request-id", valid_574921
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574922: Call_JobScheduleTerminate_574909; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574922.validator(path, query, header, formData, body)
  let scheme = call_574922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574922.url(scheme.get, call_574922.host, call_574922.base,
                         call_574922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574922, url, valid)

proc call*(call_574923: Call_JobScheduleTerminate_574909; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleTerminate
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule to terminates.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_574924 = newJObject()
  var query_574925 = newJObject()
  add(query_574925, "timeout", newJInt(timeout))
  add(path_574924, "jobScheduleId", newJString(jobScheduleId))
  add(query_574925, "api-version", newJString(apiVersion))
  result = call_574923.call(path_574924, query_574925, nil, nil, nil)

var jobScheduleTerminate* = Call_JobScheduleTerminate_574909(
    name: "jobScheduleTerminate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/terminate",
    validator: validate_JobScheduleTerminate_574910, base: "",
    url: url_JobScheduleTerminate_574911, schemes: {Scheme.Https})
type
  Call_JobGetAllLifetimeStatistics_574926 = ref object of OpenApiRestCall_573667
proc url_JobGetAllLifetimeStatistics_574928(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobGetAllLifetimeStatistics_574927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Statistics are aggregated across all Jobs that have ever existed in the Account, from Account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574929 = query.getOrDefault("timeout")
  valid_574929 = validateParameter(valid_574929, JInt, required = false,
                                 default = newJInt(30))
  if valid_574929 != nil:
    section.add "timeout", valid_574929
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574930 = query.getOrDefault("api-version")
  valid_574930 = validateParameter(valid_574930, JString, required = true,
                                 default = nil)
  if valid_574930 != nil:
    section.add "api-version", valid_574930
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574931 = header.getOrDefault("client-request-id")
  valid_574931 = validateParameter(valid_574931, JString, required = false,
                                 default = nil)
  if valid_574931 != nil:
    section.add "client-request-id", valid_574931
  var valid_574932 = header.getOrDefault("ocp-date")
  valid_574932 = validateParameter(valid_574932, JString, required = false,
                                 default = nil)
  if valid_574932 != nil:
    section.add "ocp-date", valid_574932
  var valid_574933 = header.getOrDefault("return-client-request-id")
  valid_574933 = validateParameter(valid_574933, JBool, required = false,
                                 default = newJBool(false))
  if valid_574933 != nil:
    section.add "return-client-request-id", valid_574933
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574934: Call_JobGetAllLifetimeStatistics_574926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Statistics are aggregated across all Jobs that have ever existed in the Account, from Account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ## 
  let valid = call_574934.validator(path, query, header, formData, body)
  let scheme = call_574934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574934.url(scheme.get, call_574934.host, call_574934.base,
                         call_574934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574934, url, valid)

proc call*(call_574935: Call_JobGetAllLifetimeStatistics_574926;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobGetAllLifetimeStatistics
  ## Statistics are aggregated across all Jobs that have ever existed in the Account, from Account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_574936 = newJObject()
  add(query_574936, "timeout", newJInt(timeout))
  add(query_574936, "api-version", newJString(apiVersion))
  result = call_574935.call(nil, query_574936, nil, nil, nil)

var jobGetAllLifetimeStatistics* = Call_JobGetAllLifetimeStatistics_574926(
    name: "jobGetAllLifetimeStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/lifetimejobstats",
    validator: validate_JobGetAllLifetimeStatistics_574927, base: "",
    url: url_JobGetAllLifetimeStatistics_574928, schemes: {Scheme.Https})
type
  Call_PoolGetAllLifetimeStatistics_574937 = ref object of OpenApiRestCall_573667
proc url_PoolGetAllLifetimeStatistics_574939(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolGetAllLifetimeStatistics_574938(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Statistics are aggregated across all Pools that have ever existed in the Account, from Account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574940 = query.getOrDefault("timeout")
  valid_574940 = validateParameter(valid_574940, JInt, required = false,
                                 default = newJInt(30))
  if valid_574940 != nil:
    section.add "timeout", valid_574940
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574941 = query.getOrDefault("api-version")
  valid_574941 = validateParameter(valid_574941, JString, required = true,
                                 default = nil)
  if valid_574941 != nil:
    section.add "api-version", valid_574941
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574942 = header.getOrDefault("client-request-id")
  valid_574942 = validateParameter(valid_574942, JString, required = false,
                                 default = nil)
  if valid_574942 != nil:
    section.add "client-request-id", valid_574942
  var valid_574943 = header.getOrDefault("ocp-date")
  valid_574943 = validateParameter(valid_574943, JString, required = false,
                                 default = nil)
  if valid_574943 != nil:
    section.add "ocp-date", valid_574943
  var valid_574944 = header.getOrDefault("return-client-request-id")
  valid_574944 = validateParameter(valid_574944, JBool, required = false,
                                 default = newJBool(false))
  if valid_574944 != nil:
    section.add "return-client-request-id", valid_574944
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574945: Call_PoolGetAllLifetimeStatistics_574937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Statistics are aggregated across all Pools that have ever existed in the Account, from Account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ## 
  let valid = call_574945.validator(path, query, header, formData, body)
  let scheme = call_574945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574945.url(scheme.get, call_574945.host, call_574945.base,
                         call_574945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574945, url, valid)

proc call*(call_574946: Call_PoolGetAllLifetimeStatistics_574937;
          apiVersion: string; timeout: int = 30): Recallable =
  ## poolGetAllLifetimeStatistics
  ## Statistics are aggregated across all Pools that have ever existed in the Account, from Account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_574947 = newJObject()
  add(query_574947, "timeout", newJInt(timeout))
  add(query_574947, "api-version", newJString(apiVersion))
  result = call_574946.call(nil, query_574947, nil, nil, nil)

var poolGetAllLifetimeStatistics* = Call_PoolGetAllLifetimeStatistics_574937(
    name: "poolGetAllLifetimeStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/lifetimepoolstats",
    validator: validate_PoolGetAllLifetimeStatistics_574938, base: "",
    url: url_PoolGetAllLifetimeStatistics_574939, schemes: {Scheme.Https})
type
  Call_AccountListPoolNodeCounts_574948 = ref object of OpenApiRestCall_573667
proc url_AccountListPoolNodeCounts_574950(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccountListPoolNodeCounts_574949(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the number of Compute Nodes in each state, grouped by Pool.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch.
  section = newJObject()
  var valid_574951 = query.getOrDefault("timeout")
  valid_574951 = validateParameter(valid_574951, JInt, required = false,
                                 default = newJInt(30))
  if valid_574951 != nil:
    section.add "timeout", valid_574951
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574952 = query.getOrDefault("api-version")
  valid_574952 = validateParameter(valid_574952, JString, required = true,
                                 default = nil)
  if valid_574952 != nil:
    section.add "api-version", valid_574952
  var valid_574953 = query.getOrDefault("maxresults")
  valid_574953 = validateParameter(valid_574953, JInt, required = false,
                                 default = newJInt(10))
  if valid_574953 != nil:
    section.add "maxresults", valid_574953
  var valid_574954 = query.getOrDefault("$filter")
  valid_574954 = validateParameter(valid_574954, JString, required = false,
                                 default = nil)
  if valid_574954 != nil:
    section.add "$filter", valid_574954
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574955 = header.getOrDefault("client-request-id")
  valid_574955 = validateParameter(valid_574955, JString, required = false,
                                 default = nil)
  if valid_574955 != nil:
    section.add "client-request-id", valid_574955
  var valid_574956 = header.getOrDefault("ocp-date")
  valid_574956 = validateParameter(valid_574956, JString, required = false,
                                 default = nil)
  if valid_574956 != nil:
    section.add "ocp-date", valid_574956
  var valid_574957 = header.getOrDefault("return-client-request-id")
  valid_574957 = validateParameter(valid_574957, JBool, required = false,
                                 default = newJBool(false))
  if valid_574957 != nil:
    section.add "return-client-request-id", valid_574957
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574958: Call_AccountListPoolNodeCounts_574948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the number of Compute Nodes in each state, grouped by Pool.
  ## 
  let valid = call_574958.validator(path, query, header, formData, body)
  let scheme = call_574958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574958.url(scheme.get, call_574958.host, call_574958.base,
                         call_574958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574958, url, valid)

proc call*(call_574959: Call_AccountListPoolNodeCounts_574948; apiVersion: string;
          timeout: int = 30; maxresults: int = 10; Filter: string = ""): Recallable =
  ## accountListPoolNodeCounts
  ## Gets the number of Compute Nodes in each state, grouped by Pool.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch.
  var query_574960 = newJObject()
  add(query_574960, "timeout", newJInt(timeout))
  add(query_574960, "api-version", newJString(apiVersion))
  add(query_574960, "maxresults", newJInt(maxresults))
  add(query_574960, "$filter", newJString(Filter))
  result = call_574959.call(nil, query_574960, nil, nil, nil)

var accountListPoolNodeCounts* = Call_AccountListPoolNodeCounts_574948(
    name: "accountListPoolNodeCounts", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/nodecounts",
    validator: validate_AccountListPoolNodeCounts_574949, base: "",
    url: url_AccountListPoolNodeCounts_574950, schemes: {Scheme.Https})
type
  Call_PoolAdd_574976 = ref object of OpenApiRestCall_573667
proc url_PoolAdd_574978(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolAdd_574977(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## When naming Pools, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_574979 = query.getOrDefault("timeout")
  valid_574979 = validateParameter(valid_574979, JInt, required = false,
                                 default = newJInt(30))
  if valid_574979 != nil:
    section.add "timeout", valid_574979
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574980 = query.getOrDefault("api-version")
  valid_574980 = validateParameter(valid_574980, JString, required = true,
                                 default = nil)
  if valid_574980 != nil:
    section.add "api-version", valid_574980
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574981 = header.getOrDefault("client-request-id")
  valid_574981 = validateParameter(valid_574981, JString, required = false,
                                 default = nil)
  if valid_574981 != nil:
    section.add "client-request-id", valid_574981
  var valid_574982 = header.getOrDefault("ocp-date")
  valid_574982 = validateParameter(valid_574982, JString, required = false,
                                 default = nil)
  if valid_574982 != nil:
    section.add "ocp-date", valid_574982
  var valid_574983 = header.getOrDefault("return-client-request-id")
  valid_574983 = validateParameter(valid_574983, JBool, required = false,
                                 default = newJBool(false))
  if valid_574983 != nil:
    section.add "return-client-request-id", valid_574983
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pool: JObject (required)
  ##       : The Pool to be added.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574985: Call_PoolAdd_574976; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When naming Pools, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ## 
  let valid = call_574985.validator(path, query, header, formData, body)
  let scheme = call_574985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574985.url(scheme.get, call_574985.host, call_574985.base,
                         call_574985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574985, url, valid)

proc call*(call_574986: Call_PoolAdd_574976; pool: JsonNode; apiVersion: string;
          timeout: int = 30): Recallable =
  ## poolAdd
  ## When naming Pools, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   pool: JObject (required)
  ##       : The Pool to be added.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_574987 = newJObject()
  var body_574988 = newJObject()
  add(query_574987, "timeout", newJInt(timeout))
  if pool != nil:
    body_574988 = pool
  add(query_574987, "api-version", newJString(apiVersion))
  result = call_574986.call(nil, query_574987, nil, nil, body_574988)

var poolAdd* = Call_PoolAdd_574976(name: "poolAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/pools",
                                validator: validate_PoolAdd_574977, base: "",
                                url: url_PoolAdd_574978, schemes: {Scheme.Https})
type
  Call_PoolList_574961 = ref object of OpenApiRestCall_573667
proc url_PoolList_574963(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolList_574962(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 Pools can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-pools.
  section = newJObject()
  var valid_574964 = query.getOrDefault("timeout")
  valid_574964 = validateParameter(valid_574964, JInt, required = false,
                                 default = newJInt(30))
  if valid_574964 != nil:
    section.add "timeout", valid_574964
  var valid_574965 = query.getOrDefault("$expand")
  valid_574965 = validateParameter(valid_574965, JString, required = false,
                                 default = nil)
  if valid_574965 != nil:
    section.add "$expand", valid_574965
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574966 = query.getOrDefault("api-version")
  valid_574966 = validateParameter(valid_574966, JString, required = true,
                                 default = nil)
  if valid_574966 != nil:
    section.add "api-version", valid_574966
  var valid_574967 = query.getOrDefault("maxresults")
  valid_574967 = validateParameter(valid_574967, JInt, required = false,
                                 default = newJInt(1000))
  if valid_574967 != nil:
    section.add "maxresults", valid_574967
  var valid_574968 = query.getOrDefault("$select")
  valid_574968 = validateParameter(valid_574968, JString, required = false,
                                 default = nil)
  if valid_574968 != nil:
    section.add "$select", valid_574968
  var valid_574969 = query.getOrDefault("$filter")
  valid_574969 = validateParameter(valid_574969, JString, required = false,
                                 default = nil)
  if valid_574969 != nil:
    section.add "$filter", valid_574969
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574970 = header.getOrDefault("client-request-id")
  valid_574970 = validateParameter(valid_574970, JString, required = false,
                                 default = nil)
  if valid_574970 != nil:
    section.add "client-request-id", valid_574970
  var valid_574971 = header.getOrDefault("ocp-date")
  valid_574971 = validateParameter(valid_574971, JString, required = false,
                                 default = nil)
  if valid_574971 != nil:
    section.add "ocp-date", valid_574971
  var valid_574972 = header.getOrDefault("return-client-request-id")
  valid_574972 = validateParameter(valid_574972, JBool, required = false,
                                 default = newJBool(false))
  if valid_574972 != nil:
    section.add "return-client-request-id", valid_574972
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574973: Call_PoolList_574961; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574973.validator(path, query, header, formData, body)
  let scheme = call_574973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574973.url(scheme.get, call_574973.host, call_574973.base,
                         call_574973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574973, url, valid)

proc call*(call_574974: Call_PoolList_574961; apiVersion: string; timeout: int = 30;
          Expand: string = ""; maxresults: int = 1000; Select: string = "";
          Filter: string = ""): Recallable =
  ## poolList
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 Pools can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-pools.
  var query_574975 = newJObject()
  add(query_574975, "timeout", newJInt(timeout))
  add(query_574975, "$expand", newJString(Expand))
  add(query_574975, "api-version", newJString(apiVersion))
  add(query_574975, "maxresults", newJInt(maxresults))
  add(query_574975, "$select", newJString(Select))
  add(query_574975, "$filter", newJString(Filter))
  result = call_574974.call(nil, query_574975, nil, nil, nil)

var poolList* = Call_PoolList_574961(name: "poolList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/pools",
                                  validator: validate_PoolList_574962, base: "",
                                  url: url_PoolList_574963,
                                  schemes: {Scheme.Https})
type
  Call_PoolExists_575025 = ref object of OpenApiRestCall_573667
proc url_PoolExists_575027(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolExists_575026(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets basic properties of a Pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575028 = path.getOrDefault("poolId")
  valid_575028 = validateParameter(valid_575028, JString, required = true,
                                 default = nil)
  if valid_575028 != nil:
    section.add "poolId", valid_575028
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575029 = query.getOrDefault("timeout")
  valid_575029 = validateParameter(valid_575029, JInt, required = false,
                                 default = newJInt(30))
  if valid_575029 != nil:
    section.add "timeout", valid_575029
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575030 = query.getOrDefault("api-version")
  valid_575030 = validateParameter(valid_575030, JString, required = true,
                                 default = nil)
  if valid_575030 != nil:
    section.add "api-version", valid_575030
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575031 = header.getOrDefault("If-Match")
  valid_575031 = validateParameter(valid_575031, JString, required = false,
                                 default = nil)
  if valid_575031 != nil:
    section.add "If-Match", valid_575031
  var valid_575032 = header.getOrDefault("client-request-id")
  valid_575032 = validateParameter(valid_575032, JString, required = false,
                                 default = nil)
  if valid_575032 != nil:
    section.add "client-request-id", valid_575032
  var valid_575033 = header.getOrDefault("ocp-date")
  valid_575033 = validateParameter(valid_575033, JString, required = false,
                                 default = nil)
  if valid_575033 != nil:
    section.add "ocp-date", valid_575033
  var valid_575034 = header.getOrDefault("If-Unmodified-Since")
  valid_575034 = validateParameter(valid_575034, JString, required = false,
                                 default = nil)
  if valid_575034 != nil:
    section.add "If-Unmodified-Since", valid_575034
  var valid_575035 = header.getOrDefault("If-None-Match")
  valid_575035 = validateParameter(valid_575035, JString, required = false,
                                 default = nil)
  if valid_575035 != nil:
    section.add "If-None-Match", valid_575035
  var valid_575036 = header.getOrDefault("If-Modified-Since")
  valid_575036 = validateParameter(valid_575036, JString, required = false,
                                 default = nil)
  if valid_575036 != nil:
    section.add "If-Modified-Since", valid_575036
  var valid_575037 = header.getOrDefault("return-client-request-id")
  valid_575037 = validateParameter(valid_575037, JBool, required = false,
                                 default = newJBool(false))
  if valid_575037 != nil:
    section.add "return-client-request-id", valid_575037
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575038: Call_PoolExists_575025; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets basic properties of a Pool.
  ## 
  let valid = call_575038.validator(path, query, header, formData, body)
  let scheme = call_575038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575038.url(scheme.get, call_575038.host, call_575038.base,
                         call_575038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575038, url, valid)

proc call*(call_575039: Call_PoolExists_575025; apiVersion: string; poolId: string;
          timeout: int = 30): Recallable =
  ## poolExists
  ## Gets basic properties of a Pool.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool to get.
  var path_575040 = newJObject()
  var query_575041 = newJObject()
  add(query_575041, "timeout", newJInt(timeout))
  add(query_575041, "api-version", newJString(apiVersion))
  add(path_575040, "poolId", newJString(poolId))
  result = call_575039.call(path_575040, query_575041, nil, nil, nil)

var poolExists* = Call_PoolExists_575025(name: "poolExists",
                                      meth: HttpMethod.HttpHead,
                                      host: "azure.local",
                                      route: "/pools/{poolId}",
                                      validator: validate_PoolExists_575026,
                                      base: "", url: url_PoolExists_575027,
                                      schemes: {Scheme.Https})
type
  Call_PoolGet_574989 = ref object of OpenApiRestCall_573667
proc url_PoolGet_574991(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolGet_574990(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified Pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_574992 = path.getOrDefault("poolId")
  valid_574992 = validateParameter(valid_574992, JString, required = true,
                                 default = nil)
  if valid_574992 != nil:
    section.add "poolId", valid_574992
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_574993 = query.getOrDefault("timeout")
  valid_574993 = validateParameter(valid_574993, JInt, required = false,
                                 default = newJInt(30))
  if valid_574993 != nil:
    section.add "timeout", valid_574993
  var valid_574994 = query.getOrDefault("$expand")
  valid_574994 = validateParameter(valid_574994, JString, required = false,
                                 default = nil)
  if valid_574994 != nil:
    section.add "$expand", valid_574994
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574995 = query.getOrDefault("api-version")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "api-version", valid_574995
  var valid_574996 = query.getOrDefault("$select")
  valid_574996 = validateParameter(valid_574996, JString, required = false,
                                 default = nil)
  if valid_574996 != nil:
    section.add "$select", valid_574996
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_574997 = header.getOrDefault("If-Match")
  valid_574997 = validateParameter(valid_574997, JString, required = false,
                                 default = nil)
  if valid_574997 != nil:
    section.add "If-Match", valid_574997
  var valid_574998 = header.getOrDefault("client-request-id")
  valid_574998 = validateParameter(valid_574998, JString, required = false,
                                 default = nil)
  if valid_574998 != nil:
    section.add "client-request-id", valid_574998
  var valid_574999 = header.getOrDefault("ocp-date")
  valid_574999 = validateParameter(valid_574999, JString, required = false,
                                 default = nil)
  if valid_574999 != nil:
    section.add "ocp-date", valid_574999
  var valid_575000 = header.getOrDefault("If-Unmodified-Since")
  valid_575000 = validateParameter(valid_575000, JString, required = false,
                                 default = nil)
  if valid_575000 != nil:
    section.add "If-Unmodified-Since", valid_575000
  var valid_575001 = header.getOrDefault("If-None-Match")
  valid_575001 = validateParameter(valid_575001, JString, required = false,
                                 default = nil)
  if valid_575001 != nil:
    section.add "If-None-Match", valid_575001
  var valid_575002 = header.getOrDefault("If-Modified-Since")
  valid_575002 = validateParameter(valid_575002, JString, required = false,
                                 default = nil)
  if valid_575002 != nil:
    section.add "If-Modified-Since", valid_575002
  var valid_575003 = header.getOrDefault("return-client-request-id")
  valid_575003 = validateParameter(valid_575003, JBool, required = false,
                                 default = newJBool(false))
  if valid_575003 != nil:
    section.add "return-client-request-id", valid_575003
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575004: Call_PoolGet_574989; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Pool.
  ## 
  let valid = call_575004.validator(path, query, header, formData, body)
  let scheme = call_575004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575004.url(scheme.get, call_575004.host, call_575004.base,
                         call_575004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575004, url, valid)

proc call*(call_575005: Call_PoolGet_574989; apiVersion: string; poolId: string;
          timeout: int = 30; Expand: string = ""; Select: string = ""): Recallable =
  ## poolGet
  ## Gets information about the specified Pool.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool to get.
  ##   Select: string
  ##         : An OData $select clause.
  var path_575006 = newJObject()
  var query_575007 = newJObject()
  add(query_575007, "timeout", newJInt(timeout))
  add(query_575007, "$expand", newJString(Expand))
  add(query_575007, "api-version", newJString(apiVersion))
  add(path_575006, "poolId", newJString(poolId))
  add(query_575007, "$select", newJString(Select))
  result = call_575005.call(path_575006, query_575007, nil, nil, nil)

var poolGet* = Call_PoolGet_574989(name: "poolGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/pools/{poolId}",
                                validator: validate_PoolGet_574990, base: "",
                                url: url_PoolGet_574991, schemes: {Scheme.Https})
type
  Call_PoolPatch_575042 = ref object of OpenApiRestCall_573667
proc url_PoolPatch_575044(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolPatch_575043(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## This only replaces the Pool properties specified in the request. For example, if the Pool has a StartTask associated with it, and a request does not specify a StartTask element, then the Pool keeps the existing StartTask.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575045 = path.getOrDefault("poolId")
  valid_575045 = validateParameter(valid_575045, JString, required = true,
                                 default = nil)
  if valid_575045 != nil:
    section.add "poolId", valid_575045
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575046 = query.getOrDefault("timeout")
  valid_575046 = validateParameter(valid_575046, JInt, required = false,
                                 default = newJInt(30))
  if valid_575046 != nil:
    section.add "timeout", valid_575046
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575047 = query.getOrDefault("api-version")
  valid_575047 = validateParameter(valid_575047, JString, required = true,
                                 default = nil)
  if valid_575047 != nil:
    section.add "api-version", valid_575047
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575048 = header.getOrDefault("If-Match")
  valid_575048 = validateParameter(valid_575048, JString, required = false,
                                 default = nil)
  if valid_575048 != nil:
    section.add "If-Match", valid_575048
  var valid_575049 = header.getOrDefault("client-request-id")
  valid_575049 = validateParameter(valid_575049, JString, required = false,
                                 default = nil)
  if valid_575049 != nil:
    section.add "client-request-id", valid_575049
  var valid_575050 = header.getOrDefault("ocp-date")
  valid_575050 = validateParameter(valid_575050, JString, required = false,
                                 default = nil)
  if valid_575050 != nil:
    section.add "ocp-date", valid_575050
  var valid_575051 = header.getOrDefault("If-Unmodified-Since")
  valid_575051 = validateParameter(valid_575051, JString, required = false,
                                 default = nil)
  if valid_575051 != nil:
    section.add "If-Unmodified-Since", valid_575051
  var valid_575052 = header.getOrDefault("If-None-Match")
  valid_575052 = validateParameter(valid_575052, JString, required = false,
                                 default = nil)
  if valid_575052 != nil:
    section.add "If-None-Match", valid_575052
  var valid_575053 = header.getOrDefault("If-Modified-Since")
  valid_575053 = validateParameter(valid_575053, JString, required = false,
                                 default = nil)
  if valid_575053 != nil:
    section.add "If-Modified-Since", valid_575053
  var valid_575054 = header.getOrDefault("return-client-request-id")
  valid_575054 = validateParameter(valid_575054, JBool, required = false,
                                 default = newJBool(false))
  if valid_575054 != nil:
    section.add "return-client-request-id", valid_575054
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   poolPatchParameter: JObject (required)
  ##                     : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575056: Call_PoolPatch_575042; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This only replaces the Pool properties specified in the request. For example, if the Pool has a StartTask associated with it, and a request does not specify a StartTask element, then the Pool keeps the existing StartTask.
  ## 
  let valid = call_575056.validator(path, query, header, formData, body)
  let scheme = call_575056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575056.url(scheme.get, call_575056.host, call_575056.base,
                         call_575056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575056, url, valid)

proc call*(call_575057: Call_PoolPatch_575042; apiVersion: string; poolId: string;
          poolPatchParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolPatch
  ## This only replaces the Pool properties specified in the request. For example, if the Pool has a StartTask associated with it, and a request does not specify a StartTask element, then the Pool keeps the existing StartTask.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool to update.
  ##   poolPatchParameter: JObject (required)
  ##                     : The parameters for the request.
  var path_575058 = newJObject()
  var query_575059 = newJObject()
  var body_575060 = newJObject()
  add(query_575059, "timeout", newJInt(timeout))
  add(query_575059, "api-version", newJString(apiVersion))
  add(path_575058, "poolId", newJString(poolId))
  if poolPatchParameter != nil:
    body_575060 = poolPatchParameter
  result = call_575057.call(path_575058, query_575059, nil, nil, body_575060)

var poolPatch* = Call_PoolPatch_575042(name: "poolPatch", meth: HttpMethod.HttpPatch,
                                    host: "azure.local", route: "/pools/{poolId}",
                                    validator: validate_PoolPatch_575043,
                                    base: "", url: url_PoolPatch_575044,
                                    schemes: {Scheme.Https})
type
  Call_PoolDelete_575008 = ref object of OpenApiRestCall_573667
proc url_PoolDelete_575010(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolDelete_575009(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## When you request that a Pool be deleted, the following actions occur: the Pool state is set to deleting; any ongoing resize operation on the Pool are stopped; the Batch service starts resizing the Pool to zero Compute Nodes; any Tasks running on existing Compute Nodes are terminated and requeued (as if a resize Pool operation had been requested with the default requeue option); finally, the Pool is removed from the system. Because running Tasks are requeued, the user can rerun these Tasks by updating their Job to target a different Pool. The Tasks can then run on the new Pool. If you want to override the requeue behavior, then you should call resize Pool explicitly to shrink the Pool to zero size before deleting the Pool. If you call an Update, Patch or Delete API on a Pool in the deleting state, it will fail with HTTP status code 409 with error code PoolBeingDeleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575011 = path.getOrDefault("poolId")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "poolId", valid_575011
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575012 = query.getOrDefault("timeout")
  valid_575012 = validateParameter(valid_575012, JInt, required = false,
                                 default = newJInt(30))
  if valid_575012 != nil:
    section.add "timeout", valid_575012
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575013 = query.getOrDefault("api-version")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "api-version", valid_575013
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575014 = header.getOrDefault("If-Match")
  valid_575014 = validateParameter(valid_575014, JString, required = false,
                                 default = nil)
  if valid_575014 != nil:
    section.add "If-Match", valid_575014
  var valid_575015 = header.getOrDefault("client-request-id")
  valid_575015 = validateParameter(valid_575015, JString, required = false,
                                 default = nil)
  if valid_575015 != nil:
    section.add "client-request-id", valid_575015
  var valid_575016 = header.getOrDefault("ocp-date")
  valid_575016 = validateParameter(valid_575016, JString, required = false,
                                 default = nil)
  if valid_575016 != nil:
    section.add "ocp-date", valid_575016
  var valid_575017 = header.getOrDefault("If-Unmodified-Since")
  valid_575017 = validateParameter(valid_575017, JString, required = false,
                                 default = nil)
  if valid_575017 != nil:
    section.add "If-Unmodified-Since", valid_575017
  var valid_575018 = header.getOrDefault("If-None-Match")
  valid_575018 = validateParameter(valid_575018, JString, required = false,
                                 default = nil)
  if valid_575018 != nil:
    section.add "If-None-Match", valid_575018
  var valid_575019 = header.getOrDefault("If-Modified-Since")
  valid_575019 = validateParameter(valid_575019, JString, required = false,
                                 default = nil)
  if valid_575019 != nil:
    section.add "If-Modified-Since", valid_575019
  var valid_575020 = header.getOrDefault("return-client-request-id")
  valid_575020 = validateParameter(valid_575020, JBool, required = false,
                                 default = newJBool(false))
  if valid_575020 != nil:
    section.add "return-client-request-id", valid_575020
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575021: Call_PoolDelete_575008; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you request that a Pool be deleted, the following actions occur: the Pool state is set to deleting; any ongoing resize operation on the Pool are stopped; the Batch service starts resizing the Pool to zero Compute Nodes; any Tasks running on existing Compute Nodes are terminated and requeued (as if a resize Pool operation had been requested with the default requeue option); finally, the Pool is removed from the system. Because running Tasks are requeued, the user can rerun these Tasks by updating their Job to target a different Pool. The Tasks can then run on the new Pool. If you want to override the requeue behavior, then you should call resize Pool explicitly to shrink the Pool to zero size before deleting the Pool. If you call an Update, Patch or Delete API on a Pool in the deleting state, it will fail with HTTP status code 409 with error code PoolBeingDeleted.
  ## 
  let valid = call_575021.validator(path, query, header, formData, body)
  let scheme = call_575021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575021.url(scheme.get, call_575021.host, call_575021.base,
                         call_575021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575021, url, valid)

proc call*(call_575022: Call_PoolDelete_575008; apiVersion: string; poolId: string;
          timeout: int = 30): Recallable =
  ## poolDelete
  ## When you request that a Pool be deleted, the following actions occur: the Pool state is set to deleting; any ongoing resize operation on the Pool are stopped; the Batch service starts resizing the Pool to zero Compute Nodes; any Tasks running on existing Compute Nodes are terminated and requeued (as if a resize Pool operation had been requested with the default requeue option); finally, the Pool is removed from the system. Because running Tasks are requeued, the user can rerun these Tasks by updating their Job to target a different Pool. The Tasks can then run on the new Pool. If you want to override the requeue behavior, then you should call resize Pool explicitly to shrink the Pool to zero size before deleting the Pool. If you call an Update, Patch or Delete API on a Pool in the deleting state, it will fail with HTTP status code 409 with error code PoolBeingDeleted.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool to delete.
  var path_575023 = newJObject()
  var query_575024 = newJObject()
  add(query_575024, "timeout", newJInt(timeout))
  add(query_575024, "api-version", newJString(apiVersion))
  add(path_575023, "poolId", newJString(poolId))
  result = call_575022.call(path_575023, query_575024, nil, nil, nil)

var poolDelete* = Call_PoolDelete_575008(name: "poolDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/pools/{poolId}",
                                      validator: validate_PoolDelete_575009,
                                      base: "", url: url_PoolDelete_575010,
                                      schemes: {Scheme.Https})
type
  Call_PoolDisableAutoScale_575061 = ref object of OpenApiRestCall_573667
proc url_PoolDisableAutoScale_575063(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/disableautoscale")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolDisableAutoScale_575062(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool on which to disable automatic scaling.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575064 = path.getOrDefault("poolId")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "poolId", valid_575064
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575065 = query.getOrDefault("timeout")
  valid_575065 = validateParameter(valid_575065, JInt, required = false,
                                 default = newJInt(30))
  if valid_575065 != nil:
    section.add "timeout", valid_575065
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575066 = query.getOrDefault("api-version")
  valid_575066 = validateParameter(valid_575066, JString, required = true,
                                 default = nil)
  if valid_575066 != nil:
    section.add "api-version", valid_575066
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575067 = header.getOrDefault("client-request-id")
  valid_575067 = validateParameter(valid_575067, JString, required = false,
                                 default = nil)
  if valid_575067 != nil:
    section.add "client-request-id", valid_575067
  var valid_575068 = header.getOrDefault("ocp-date")
  valid_575068 = validateParameter(valid_575068, JString, required = false,
                                 default = nil)
  if valid_575068 != nil:
    section.add "ocp-date", valid_575068
  var valid_575069 = header.getOrDefault("return-client-request-id")
  valid_575069 = validateParameter(valid_575069, JBool, required = false,
                                 default = newJBool(false))
  if valid_575069 != nil:
    section.add "return-client-request-id", valid_575069
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575070: Call_PoolDisableAutoScale_575061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575070.validator(path, query, header, formData, body)
  let scheme = call_575070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575070.url(scheme.get, call_575070.host, call_575070.base,
                         call_575070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575070, url, valid)

proc call*(call_575071: Call_PoolDisableAutoScale_575061; apiVersion: string;
          poolId: string; timeout: int = 30): Recallable =
  ## poolDisableAutoScale
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool on which to disable automatic scaling.
  var path_575072 = newJObject()
  var query_575073 = newJObject()
  add(query_575073, "timeout", newJInt(timeout))
  add(query_575073, "api-version", newJString(apiVersion))
  add(path_575072, "poolId", newJString(poolId))
  result = call_575071.call(path_575072, query_575073, nil, nil, nil)

var poolDisableAutoScale* = Call_PoolDisableAutoScale_575061(
    name: "poolDisableAutoScale", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/disableautoscale",
    validator: validate_PoolDisableAutoScale_575062, base: "",
    url: url_PoolDisableAutoScale_575063, schemes: {Scheme.Https})
type
  Call_PoolEnableAutoScale_575074 = ref object of OpenApiRestCall_573667
proc url_PoolEnableAutoScale_575076(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/enableautoscale")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolEnableAutoScale_575075(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## You cannot enable automatic scaling on a Pool if a resize operation is in progress on the Pool. If automatic scaling of the Pool is currently disabled, you must specify a valid autoscale formula as part of the request. If automatic scaling of the Pool is already enabled, you may specify a new autoscale formula and/or a new evaluation interval. You cannot call this API for the same Pool more than once every 30 seconds.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool on which to enable automatic scaling.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575077 = path.getOrDefault("poolId")
  valid_575077 = validateParameter(valid_575077, JString, required = true,
                                 default = nil)
  if valid_575077 != nil:
    section.add "poolId", valid_575077
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575078 = query.getOrDefault("timeout")
  valid_575078 = validateParameter(valid_575078, JInt, required = false,
                                 default = newJInt(30))
  if valid_575078 != nil:
    section.add "timeout", valid_575078
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575079 = query.getOrDefault("api-version")
  valid_575079 = validateParameter(valid_575079, JString, required = true,
                                 default = nil)
  if valid_575079 != nil:
    section.add "api-version", valid_575079
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575080 = header.getOrDefault("If-Match")
  valid_575080 = validateParameter(valid_575080, JString, required = false,
                                 default = nil)
  if valid_575080 != nil:
    section.add "If-Match", valid_575080
  var valid_575081 = header.getOrDefault("client-request-id")
  valid_575081 = validateParameter(valid_575081, JString, required = false,
                                 default = nil)
  if valid_575081 != nil:
    section.add "client-request-id", valid_575081
  var valid_575082 = header.getOrDefault("ocp-date")
  valid_575082 = validateParameter(valid_575082, JString, required = false,
                                 default = nil)
  if valid_575082 != nil:
    section.add "ocp-date", valid_575082
  var valid_575083 = header.getOrDefault("If-Unmodified-Since")
  valid_575083 = validateParameter(valid_575083, JString, required = false,
                                 default = nil)
  if valid_575083 != nil:
    section.add "If-Unmodified-Since", valid_575083
  var valid_575084 = header.getOrDefault("If-None-Match")
  valid_575084 = validateParameter(valid_575084, JString, required = false,
                                 default = nil)
  if valid_575084 != nil:
    section.add "If-None-Match", valid_575084
  var valid_575085 = header.getOrDefault("If-Modified-Since")
  valid_575085 = validateParameter(valid_575085, JString, required = false,
                                 default = nil)
  if valid_575085 != nil:
    section.add "If-Modified-Since", valid_575085
  var valid_575086 = header.getOrDefault("return-client-request-id")
  valid_575086 = validateParameter(valid_575086, JBool, required = false,
                                 default = newJBool(false))
  if valid_575086 != nil:
    section.add "return-client-request-id", valid_575086
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   poolEnableAutoScaleParameter: JObject (required)
  ##                               : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575088: Call_PoolEnableAutoScale_575074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You cannot enable automatic scaling on a Pool if a resize operation is in progress on the Pool. If automatic scaling of the Pool is currently disabled, you must specify a valid autoscale formula as part of the request. If automatic scaling of the Pool is already enabled, you may specify a new autoscale formula and/or a new evaluation interval. You cannot call this API for the same Pool more than once every 30 seconds.
  ## 
  let valid = call_575088.validator(path, query, header, formData, body)
  let scheme = call_575088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575088.url(scheme.get, call_575088.host, call_575088.base,
                         call_575088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575088, url, valid)

proc call*(call_575089: Call_PoolEnableAutoScale_575074; apiVersion: string;
          poolId: string; poolEnableAutoScaleParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolEnableAutoScale
  ## You cannot enable automatic scaling on a Pool if a resize operation is in progress on the Pool. If automatic scaling of the Pool is currently disabled, you must specify a valid autoscale formula as part of the request. If automatic scaling of the Pool is already enabled, you may specify a new autoscale formula and/or a new evaluation interval. You cannot call this API for the same Pool more than once every 30 seconds.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool on which to enable automatic scaling.
  ##   poolEnableAutoScaleParameter: JObject (required)
  ##                               : The parameters for the request.
  var path_575090 = newJObject()
  var query_575091 = newJObject()
  var body_575092 = newJObject()
  add(query_575091, "timeout", newJInt(timeout))
  add(query_575091, "api-version", newJString(apiVersion))
  add(path_575090, "poolId", newJString(poolId))
  if poolEnableAutoScaleParameter != nil:
    body_575092 = poolEnableAutoScaleParameter
  result = call_575089.call(path_575090, query_575091, nil, nil, body_575092)

var poolEnableAutoScale* = Call_PoolEnableAutoScale_575074(
    name: "poolEnableAutoScale", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/enableautoscale",
    validator: validate_PoolEnableAutoScale_575075, base: "",
    url: url_PoolEnableAutoScale_575076, schemes: {Scheme.Https})
type
  Call_PoolEvaluateAutoScale_575093 = ref object of OpenApiRestCall_573667
proc url_PoolEvaluateAutoScale_575095(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/evaluateautoscale")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolEvaluateAutoScale_575094(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This API is primarily for validating an autoscale formula, as it simply returns the result without applying the formula to the Pool. The Pool must have auto scaling enabled in order to evaluate a formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool on which to evaluate the automatic scaling formula.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575096 = path.getOrDefault("poolId")
  valid_575096 = validateParameter(valid_575096, JString, required = true,
                                 default = nil)
  if valid_575096 != nil:
    section.add "poolId", valid_575096
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575097 = query.getOrDefault("timeout")
  valid_575097 = validateParameter(valid_575097, JInt, required = false,
                                 default = newJInt(30))
  if valid_575097 != nil:
    section.add "timeout", valid_575097
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575098 = query.getOrDefault("api-version")
  valid_575098 = validateParameter(valid_575098, JString, required = true,
                                 default = nil)
  if valid_575098 != nil:
    section.add "api-version", valid_575098
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575099 = header.getOrDefault("client-request-id")
  valid_575099 = validateParameter(valid_575099, JString, required = false,
                                 default = nil)
  if valid_575099 != nil:
    section.add "client-request-id", valid_575099
  var valid_575100 = header.getOrDefault("ocp-date")
  valid_575100 = validateParameter(valid_575100, JString, required = false,
                                 default = nil)
  if valid_575100 != nil:
    section.add "ocp-date", valid_575100
  var valid_575101 = header.getOrDefault("return-client-request-id")
  valid_575101 = validateParameter(valid_575101, JBool, required = false,
                                 default = newJBool(false))
  if valid_575101 != nil:
    section.add "return-client-request-id", valid_575101
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   poolEvaluateAutoScaleParameter: JObject (required)
  ##                                 : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575103: Call_PoolEvaluateAutoScale_575093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API is primarily for validating an autoscale formula, as it simply returns the result without applying the formula to the Pool. The Pool must have auto scaling enabled in order to evaluate a formula.
  ## 
  let valid = call_575103.validator(path, query, header, formData, body)
  let scheme = call_575103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575103.url(scheme.get, call_575103.host, call_575103.base,
                         call_575103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575103, url, valid)

proc call*(call_575104: Call_PoolEvaluateAutoScale_575093; apiVersion: string;
          poolEvaluateAutoScaleParameter: JsonNode; poolId: string;
          timeout: int = 30): Recallable =
  ## poolEvaluateAutoScale
  ## This API is primarily for validating an autoscale formula, as it simply returns the result without applying the formula to the Pool. The Pool must have auto scaling enabled in order to evaluate a formula.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolEvaluateAutoScaleParameter: JObject (required)
  ##                                 : The parameters for the request.
  ##   poolId: string (required)
  ##         : The ID of the Pool on which to evaluate the automatic scaling formula.
  var path_575105 = newJObject()
  var query_575106 = newJObject()
  var body_575107 = newJObject()
  add(query_575106, "timeout", newJInt(timeout))
  add(query_575106, "api-version", newJString(apiVersion))
  if poolEvaluateAutoScaleParameter != nil:
    body_575107 = poolEvaluateAutoScaleParameter
  add(path_575105, "poolId", newJString(poolId))
  result = call_575104.call(path_575105, query_575106, nil, nil, body_575107)

var poolEvaluateAutoScale* = Call_PoolEvaluateAutoScale_575093(
    name: "poolEvaluateAutoScale", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/evaluateautoscale",
    validator: validate_PoolEvaluateAutoScale_575094, base: "",
    url: url_PoolEvaluateAutoScale_575095, schemes: {Scheme.Https})
type
  Call_ComputeNodeList_575108 = ref object of OpenApiRestCall_573667
proc url_ComputeNodeList_575110(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeNodeList_575109(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool from which you want to list Compute Nodes.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575111 = path.getOrDefault("poolId")
  valid_575111 = validateParameter(valid_575111, JString, required = true,
                                 default = nil)
  if valid_575111 != nil:
    section.add "poolId", valid_575111
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 Compute Nodes can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-nodes-in-a-pool.
  section = newJObject()
  var valid_575112 = query.getOrDefault("timeout")
  valid_575112 = validateParameter(valid_575112, JInt, required = false,
                                 default = newJInt(30))
  if valid_575112 != nil:
    section.add "timeout", valid_575112
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575113 = query.getOrDefault("api-version")
  valid_575113 = validateParameter(valid_575113, JString, required = true,
                                 default = nil)
  if valid_575113 != nil:
    section.add "api-version", valid_575113
  var valid_575114 = query.getOrDefault("maxresults")
  valid_575114 = validateParameter(valid_575114, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575114 != nil:
    section.add "maxresults", valid_575114
  var valid_575115 = query.getOrDefault("$select")
  valid_575115 = validateParameter(valid_575115, JString, required = false,
                                 default = nil)
  if valid_575115 != nil:
    section.add "$select", valid_575115
  var valid_575116 = query.getOrDefault("$filter")
  valid_575116 = validateParameter(valid_575116, JString, required = false,
                                 default = nil)
  if valid_575116 != nil:
    section.add "$filter", valid_575116
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575117 = header.getOrDefault("client-request-id")
  valid_575117 = validateParameter(valid_575117, JString, required = false,
                                 default = nil)
  if valid_575117 != nil:
    section.add "client-request-id", valid_575117
  var valid_575118 = header.getOrDefault("ocp-date")
  valid_575118 = validateParameter(valid_575118, JString, required = false,
                                 default = nil)
  if valid_575118 != nil:
    section.add "ocp-date", valid_575118
  var valid_575119 = header.getOrDefault("return-client-request-id")
  valid_575119 = validateParameter(valid_575119, JBool, required = false,
                                 default = newJBool(false))
  if valid_575119 != nil:
    section.add "return-client-request-id", valid_575119
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575120: Call_ComputeNodeList_575108; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575120.validator(path, query, header, formData, body)
  let scheme = call_575120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575120.url(scheme.get, call_575120.host, call_575120.base,
                         call_575120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575120, url, valid)

proc call*(call_575121: Call_ComputeNodeList_575108; apiVersion: string;
          poolId: string; timeout: int = 30; maxresults: int = 1000; Select: string = "";
          Filter: string = ""): Recallable =
  ## computeNodeList
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool from which you want to list Compute Nodes.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 Compute Nodes can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-nodes-in-a-pool.
  var path_575122 = newJObject()
  var query_575123 = newJObject()
  add(query_575123, "timeout", newJInt(timeout))
  add(query_575123, "api-version", newJString(apiVersion))
  add(path_575122, "poolId", newJString(poolId))
  add(query_575123, "maxresults", newJInt(maxresults))
  add(query_575123, "$select", newJString(Select))
  add(query_575123, "$filter", newJString(Filter))
  result = call_575121.call(path_575122, query_575123, nil, nil, nil)

var computeNodeList* = Call_ComputeNodeList_575108(name: "computeNodeList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/pools/{poolId}/nodes",
    validator: validate_ComputeNodeList_575109, base: "", url: url_ComputeNodeList_575110,
    schemes: {Scheme.Https})
type
  Call_ComputeNodeGet_575124 = ref object of OpenApiRestCall_573667
proc url_ComputeNodeGet_575126(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeNodeGet_575125(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the Compute Node that you want to get information about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575127 = path.getOrDefault("poolId")
  valid_575127 = validateParameter(valid_575127, JString, required = true,
                                 default = nil)
  if valid_575127 != nil:
    section.add "poolId", valid_575127
  var valid_575128 = path.getOrDefault("nodeId")
  valid_575128 = validateParameter(valid_575128, JString, required = true,
                                 default = nil)
  if valid_575128 != nil:
    section.add "nodeId", valid_575128
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_575129 = query.getOrDefault("timeout")
  valid_575129 = validateParameter(valid_575129, JInt, required = false,
                                 default = newJInt(30))
  if valid_575129 != nil:
    section.add "timeout", valid_575129
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575130 = query.getOrDefault("api-version")
  valid_575130 = validateParameter(valid_575130, JString, required = true,
                                 default = nil)
  if valid_575130 != nil:
    section.add "api-version", valid_575130
  var valid_575131 = query.getOrDefault("$select")
  valid_575131 = validateParameter(valid_575131, JString, required = false,
                                 default = nil)
  if valid_575131 != nil:
    section.add "$select", valid_575131
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575132 = header.getOrDefault("client-request-id")
  valid_575132 = validateParameter(valid_575132, JString, required = false,
                                 default = nil)
  if valid_575132 != nil:
    section.add "client-request-id", valid_575132
  var valid_575133 = header.getOrDefault("ocp-date")
  valid_575133 = validateParameter(valid_575133, JString, required = false,
                                 default = nil)
  if valid_575133 != nil:
    section.add "ocp-date", valid_575133
  var valid_575134 = header.getOrDefault("return-client-request-id")
  valid_575134 = validateParameter(valid_575134, JBool, required = false,
                                 default = newJBool(false))
  if valid_575134 != nil:
    section.add "return-client-request-id", valid_575134
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575135: Call_ComputeNodeGet_575124; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575135.validator(path, query, header, formData, body)
  let scheme = call_575135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575135.url(scheme.get, call_575135.host, call_575135.base,
                         call_575135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575135, url, valid)

proc call*(call_575136: Call_ComputeNodeGet_575124; apiVersion: string;
          poolId: string; nodeId: string; timeout: int = 30; Select: string = ""): Recallable =
  ## computeNodeGet
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the Compute Node that you want to get information about.
  ##   Select: string
  ##         : An OData $select clause.
  var path_575137 = newJObject()
  var query_575138 = newJObject()
  add(query_575138, "timeout", newJInt(timeout))
  add(query_575138, "api-version", newJString(apiVersion))
  add(path_575137, "poolId", newJString(poolId))
  add(path_575137, "nodeId", newJString(nodeId))
  add(query_575138, "$select", newJString(Select))
  result = call_575136.call(path_575137, query_575138, nil, nil, nil)

var computeNodeGet* = Call_ComputeNodeGet_575124(name: "computeNodeGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}", validator: validate_ComputeNodeGet_575125,
    base: "", url: url_ComputeNodeGet_575126, schemes: {Scheme.Https})
type
  Call_ComputeNodeDisableScheduling_575139 = ref object of OpenApiRestCall_573667
proc url_ComputeNodeDisableScheduling_575141(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/disablescheduling")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeNodeDisableScheduling_575140(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can disable Task scheduling on a Compute Node only if its current scheduling state is enabled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the Compute Node on which you want to disable Task scheduling.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575142 = path.getOrDefault("poolId")
  valid_575142 = validateParameter(valid_575142, JString, required = true,
                                 default = nil)
  if valid_575142 != nil:
    section.add "poolId", valid_575142
  var valid_575143 = path.getOrDefault("nodeId")
  valid_575143 = validateParameter(valid_575143, JString, required = true,
                                 default = nil)
  if valid_575143 != nil:
    section.add "nodeId", valid_575143
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575144 = query.getOrDefault("timeout")
  valid_575144 = validateParameter(valid_575144, JInt, required = false,
                                 default = newJInt(30))
  if valid_575144 != nil:
    section.add "timeout", valid_575144
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575145 = query.getOrDefault("api-version")
  valid_575145 = validateParameter(valid_575145, JString, required = true,
                                 default = nil)
  if valid_575145 != nil:
    section.add "api-version", valid_575145
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575146 = header.getOrDefault("client-request-id")
  valid_575146 = validateParameter(valid_575146, JString, required = false,
                                 default = nil)
  if valid_575146 != nil:
    section.add "client-request-id", valid_575146
  var valid_575147 = header.getOrDefault("ocp-date")
  valid_575147 = validateParameter(valid_575147, JString, required = false,
                                 default = nil)
  if valid_575147 != nil:
    section.add "ocp-date", valid_575147
  var valid_575148 = header.getOrDefault("return-client-request-id")
  valid_575148 = validateParameter(valid_575148, JBool, required = false,
                                 default = newJBool(false))
  if valid_575148 != nil:
    section.add "return-client-request-id", valid_575148
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeDisableSchedulingParameter: JObject
  ##                                 : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575150: Call_ComputeNodeDisableScheduling_575139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can disable Task scheduling on a Compute Node only if its current scheduling state is enabled.
  ## 
  let valid = call_575150.validator(path, query, header, formData, body)
  let scheme = call_575150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575150.url(scheme.get, call_575150.host, call_575150.base,
                         call_575150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575150, url, valid)

proc call*(call_575151: Call_ComputeNodeDisableScheduling_575139;
          apiVersion: string; poolId: string; nodeId: string; timeout: int = 30;
          nodeDisableSchedulingParameter: JsonNode = nil): Recallable =
  ## computeNodeDisableScheduling
  ## You can disable Task scheduling on a Compute Node only if its current scheduling state is enabled.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the Compute Node on which you want to disable Task scheduling.
  ##   nodeDisableSchedulingParameter: JObject
  ##                                 : The parameters for the request.
  var path_575152 = newJObject()
  var query_575153 = newJObject()
  var body_575154 = newJObject()
  add(query_575153, "timeout", newJInt(timeout))
  add(query_575153, "api-version", newJString(apiVersion))
  add(path_575152, "poolId", newJString(poolId))
  add(path_575152, "nodeId", newJString(nodeId))
  if nodeDisableSchedulingParameter != nil:
    body_575154 = nodeDisableSchedulingParameter
  result = call_575151.call(path_575152, query_575153, nil, nil, body_575154)

var computeNodeDisableScheduling* = Call_ComputeNodeDisableScheduling_575139(
    name: "computeNodeDisableScheduling", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/disablescheduling",
    validator: validate_ComputeNodeDisableScheduling_575140, base: "",
    url: url_ComputeNodeDisableScheduling_575141, schemes: {Scheme.Https})
type
  Call_ComputeNodeEnableScheduling_575155 = ref object of OpenApiRestCall_573667
proc url_ComputeNodeEnableScheduling_575157(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/enablescheduling")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeNodeEnableScheduling_575156(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can enable Task scheduling on a Compute Node only if its current scheduling state is disabled
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the Compute Node on which you want to enable Task scheduling.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575158 = path.getOrDefault("poolId")
  valid_575158 = validateParameter(valid_575158, JString, required = true,
                                 default = nil)
  if valid_575158 != nil:
    section.add "poolId", valid_575158
  var valid_575159 = path.getOrDefault("nodeId")
  valid_575159 = validateParameter(valid_575159, JString, required = true,
                                 default = nil)
  if valid_575159 != nil:
    section.add "nodeId", valid_575159
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575160 = query.getOrDefault("timeout")
  valid_575160 = validateParameter(valid_575160, JInt, required = false,
                                 default = newJInt(30))
  if valid_575160 != nil:
    section.add "timeout", valid_575160
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575161 = query.getOrDefault("api-version")
  valid_575161 = validateParameter(valid_575161, JString, required = true,
                                 default = nil)
  if valid_575161 != nil:
    section.add "api-version", valid_575161
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575162 = header.getOrDefault("client-request-id")
  valid_575162 = validateParameter(valid_575162, JString, required = false,
                                 default = nil)
  if valid_575162 != nil:
    section.add "client-request-id", valid_575162
  var valid_575163 = header.getOrDefault("ocp-date")
  valid_575163 = validateParameter(valid_575163, JString, required = false,
                                 default = nil)
  if valid_575163 != nil:
    section.add "ocp-date", valid_575163
  var valid_575164 = header.getOrDefault("return-client-request-id")
  valid_575164 = validateParameter(valid_575164, JBool, required = false,
                                 default = newJBool(false))
  if valid_575164 != nil:
    section.add "return-client-request-id", valid_575164
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575165: Call_ComputeNodeEnableScheduling_575155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can enable Task scheduling on a Compute Node only if its current scheduling state is disabled
  ## 
  let valid = call_575165.validator(path, query, header, formData, body)
  let scheme = call_575165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575165.url(scheme.get, call_575165.host, call_575165.base,
                         call_575165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575165, url, valid)

proc call*(call_575166: Call_ComputeNodeEnableScheduling_575155;
          apiVersion: string; poolId: string; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeEnableScheduling
  ## You can enable Task scheduling on a Compute Node only if its current scheduling state is disabled
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the Compute Node on which you want to enable Task scheduling.
  var path_575167 = newJObject()
  var query_575168 = newJObject()
  add(query_575168, "timeout", newJInt(timeout))
  add(query_575168, "api-version", newJString(apiVersion))
  add(path_575167, "poolId", newJString(poolId))
  add(path_575167, "nodeId", newJString(nodeId))
  result = call_575166.call(path_575167, query_575168, nil, nil, nil)

var computeNodeEnableScheduling* = Call_ComputeNodeEnableScheduling_575155(
    name: "computeNodeEnableScheduling", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/enablescheduling",
    validator: validate_ComputeNodeEnableScheduling_575156, base: "",
    url: url_ComputeNodeEnableScheduling_575157, schemes: {Scheme.Https})
type
  Call_FileListFromComputeNode_575169 = ref object of OpenApiRestCall_573667
proc url_FileListFromComputeNode_575171(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/files")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileListFromComputeNode_575170(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the Compute Node whose files you want to list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575172 = path.getOrDefault("poolId")
  valid_575172 = validateParameter(valid_575172, JString, required = true,
                                 default = nil)
  if valid_575172 != nil:
    section.add "poolId", valid_575172
  var valid_575173 = path.getOrDefault("nodeId")
  valid_575173 = validateParameter(valid_575173, JString, required = true,
                                 default = nil)
  if valid_575173 != nil:
    section.add "nodeId", valid_575173
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-compute-node-files.
  ##   recursive: JBool
  ##            : Whether to list children of a directory.
  section = newJObject()
  var valid_575174 = query.getOrDefault("timeout")
  valid_575174 = validateParameter(valid_575174, JInt, required = false,
                                 default = newJInt(30))
  if valid_575174 != nil:
    section.add "timeout", valid_575174
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575175 = query.getOrDefault("api-version")
  valid_575175 = validateParameter(valid_575175, JString, required = true,
                                 default = nil)
  if valid_575175 != nil:
    section.add "api-version", valid_575175
  var valid_575176 = query.getOrDefault("maxresults")
  valid_575176 = validateParameter(valid_575176, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575176 != nil:
    section.add "maxresults", valid_575176
  var valid_575177 = query.getOrDefault("$filter")
  valid_575177 = validateParameter(valid_575177, JString, required = false,
                                 default = nil)
  if valid_575177 != nil:
    section.add "$filter", valid_575177
  var valid_575178 = query.getOrDefault("recursive")
  valid_575178 = validateParameter(valid_575178, JBool, required = false, default = nil)
  if valid_575178 != nil:
    section.add "recursive", valid_575178
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575179 = header.getOrDefault("client-request-id")
  valid_575179 = validateParameter(valid_575179, JString, required = false,
                                 default = nil)
  if valid_575179 != nil:
    section.add "client-request-id", valid_575179
  var valid_575180 = header.getOrDefault("ocp-date")
  valid_575180 = validateParameter(valid_575180, JString, required = false,
                                 default = nil)
  if valid_575180 != nil:
    section.add "ocp-date", valid_575180
  var valid_575181 = header.getOrDefault("return-client-request-id")
  valid_575181 = validateParameter(valid_575181, JBool, required = false,
                                 default = newJBool(false))
  if valid_575181 != nil:
    section.add "return-client-request-id", valid_575181
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575182: Call_FileListFromComputeNode_575169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575182.validator(path, query, header, formData, body)
  let scheme = call_575182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575182.url(scheme.get, call_575182.host, call_575182.base,
                         call_575182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575182, url, valid)

proc call*(call_575183: Call_FileListFromComputeNode_575169; apiVersion: string;
          poolId: string; nodeId: string; timeout: int = 30; maxresults: int = 1000;
          Filter: string = ""; recursive: bool = false): Recallable =
  ## fileListFromComputeNode
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the Compute Node whose files you want to list.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-compute-node-files.
  ##   recursive: bool
  ##            : Whether to list children of a directory.
  var path_575184 = newJObject()
  var query_575185 = newJObject()
  add(query_575185, "timeout", newJInt(timeout))
  add(query_575185, "api-version", newJString(apiVersion))
  add(path_575184, "poolId", newJString(poolId))
  add(path_575184, "nodeId", newJString(nodeId))
  add(query_575185, "maxresults", newJInt(maxresults))
  add(query_575185, "$filter", newJString(Filter))
  add(query_575185, "recursive", newJBool(recursive))
  result = call_575183.call(path_575184, query_575185, nil, nil, nil)

var fileListFromComputeNode* = Call_FileListFromComputeNode_575169(
    name: "fileListFromComputeNode", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/files",
    validator: validate_FileListFromComputeNode_575170, base: "",
    url: url_FileListFromComputeNode_575171, schemes: {Scheme.Https})
type
  Call_FileGetPropertiesFromComputeNode_575220 = ref object of OpenApiRestCall_573667
proc url_FileGetPropertiesFromComputeNode_575222(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  assert "filePath" in path, "`filePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "filePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileGetPropertiesFromComputeNode_575221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified Compute Node file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the Compute Node that contains the file.
  ##   filePath: JString (required)
  ##           : The path to the Compute Node file that you want to get the properties of.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575223 = path.getOrDefault("poolId")
  valid_575223 = validateParameter(valid_575223, JString, required = true,
                                 default = nil)
  if valid_575223 != nil:
    section.add "poolId", valid_575223
  var valid_575224 = path.getOrDefault("nodeId")
  valid_575224 = validateParameter(valid_575224, JString, required = true,
                                 default = nil)
  if valid_575224 != nil:
    section.add "nodeId", valid_575224
  var valid_575225 = path.getOrDefault("filePath")
  valid_575225 = validateParameter(valid_575225, JString, required = true,
                                 default = nil)
  if valid_575225 != nil:
    section.add "filePath", valid_575225
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575226 = query.getOrDefault("timeout")
  valid_575226 = validateParameter(valid_575226, JInt, required = false,
                                 default = newJInt(30))
  if valid_575226 != nil:
    section.add "timeout", valid_575226
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575227 = query.getOrDefault("api-version")
  valid_575227 = validateParameter(valid_575227, JString, required = true,
                                 default = nil)
  if valid_575227 != nil:
    section.add "api-version", valid_575227
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575228 = header.getOrDefault("client-request-id")
  valid_575228 = validateParameter(valid_575228, JString, required = false,
                                 default = nil)
  if valid_575228 != nil:
    section.add "client-request-id", valid_575228
  var valid_575229 = header.getOrDefault("ocp-date")
  valid_575229 = validateParameter(valid_575229, JString, required = false,
                                 default = nil)
  if valid_575229 != nil:
    section.add "ocp-date", valid_575229
  var valid_575230 = header.getOrDefault("If-Unmodified-Since")
  valid_575230 = validateParameter(valid_575230, JString, required = false,
                                 default = nil)
  if valid_575230 != nil:
    section.add "If-Unmodified-Since", valid_575230
  var valid_575231 = header.getOrDefault("If-Modified-Since")
  valid_575231 = validateParameter(valid_575231, JString, required = false,
                                 default = nil)
  if valid_575231 != nil:
    section.add "If-Modified-Since", valid_575231
  var valid_575232 = header.getOrDefault("return-client-request-id")
  valid_575232 = validateParameter(valid_575232, JBool, required = false,
                                 default = newJBool(false))
  if valid_575232 != nil:
    section.add "return-client-request-id", valid_575232
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575233: Call_FileGetPropertiesFromComputeNode_575220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the properties of the specified Compute Node file.
  ## 
  let valid = call_575233.validator(path, query, header, formData, body)
  let scheme = call_575233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575233.url(scheme.get, call_575233.host, call_575233.base,
                         call_575233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575233, url, valid)

proc call*(call_575234: Call_FileGetPropertiesFromComputeNode_575220;
          apiVersion: string; poolId: string; nodeId: string; filePath: string;
          timeout: int = 30): Recallable =
  ## fileGetPropertiesFromComputeNode
  ## Gets the properties of the specified Compute Node file.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the Compute Node that contains the file.
  ##   filePath: string (required)
  ##           : The path to the Compute Node file that you want to get the properties of.
  var path_575235 = newJObject()
  var query_575236 = newJObject()
  add(query_575236, "timeout", newJInt(timeout))
  add(query_575236, "api-version", newJString(apiVersion))
  add(path_575235, "poolId", newJString(poolId))
  add(path_575235, "nodeId", newJString(nodeId))
  add(path_575235, "filePath", newJString(filePath))
  result = call_575234.call(path_575235, query_575236, nil, nil, nil)

var fileGetPropertiesFromComputeNode* = Call_FileGetPropertiesFromComputeNode_575220(
    name: "fileGetPropertiesFromComputeNode", meth: HttpMethod.HttpHead,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/files/{filePath}",
    validator: validate_FileGetPropertiesFromComputeNode_575221, base: "",
    url: url_FileGetPropertiesFromComputeNode_575222, schemes: {Scheme.Https})
type
  Call_FileGetFromComputeNode_575186 = ref object of OpenApiRestCall_573667
proc url_FileGetFromComputeNode_575188(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  assert "filePath" in path, "`filePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "filePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileGetFromComputeNode_575187(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the content of the specified Compute Node file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the Compute Node that contains the file.
  ##   filePath: JString (required)
  ##           : The path to the Compute Node file that you want to get the content of.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575189 = path.getOrDefault("poolId")
  valid_575189 = validateParameter(valid_575189, JString, required = true,
                                 default = nil)
  if valid_575189 != nil:
    section.add "poolId", valid_575189
  var valid_575190 = path.getOrDefault("nodeId")
  valid_575190 = validateParameter(valid_575190, JString, required = true,
                                 default = nil)
  if valid_575190 != nil:
    section.add "nodeId", valid_575190
  var valid_575191 = path.getOrDefault("filePath")
  valid_575191 = validateParameter(valid_575191, JString, required = true,
                                 default = nil)
  if valid_575191 != nil:
    section.add "filePath", valid_575191
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575192 = query.getOrDefault("timeout")
  valid_575192 = validateParameter(valid_575192, JInt, required = false,
                                 default = newJInt(30))
  if valid_575192 != nil:
    section.add "timeout", valid_575192
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575193 = query.getOrDefault("api-version")
  valid_575193 = validateParameter(valid_575193, JString, required = true,
                                 default = nil)
  if valid_575193 != nil:
    section.add "api-version", valid_575193
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   ocp-range: JString
  ##            : The byte range to be retrieved. The default is to retrieve the entire file. The format is bytes=startRange-endRange.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575194 = header.getOrDefault("client-request-id")
  valid_575194 = validateParameter(valid_575194, JString, required = false,
                                 default = nil)
  if valid_575194 != nil:
    section.add "client-request-id", valid_575194
  var valid_575195 = header.getOrDefault("ocp-date")
  valid_575195 = validateParameter(valid_575195, JString, required = false,
                                 default = nil)
  if valid_575195 != nil:
    section.add "ocp-date", valid_575195
  var valid_575196 = header.getOrDefault("If-Unmodified-Since")
  valid_575196 = validateParameter(valid_575196, JString, required = false,
                                 default = nil)
  if valid_575196 != nil:
    section.add "If-Unmodified-Since", valid_575196
  var valid_575197 = header.getOrDefault("ocp-range")
  valid_575197 = validateParameter(valid_575197, JString, required = false,
                                 default = nil)
  if valid_575197 != nil:
    section.add "ocp-range", valid_575197
  var valid_575198 = header.getOrDefault("If-Modified-Since")
  valid_575198 = validateParameter(valid_575198, JString, required = false,
                                 default = nil)
  if valid_575198 != nil:
    section.add "If-Modified-Since", valid_575198
  var valid_575199 = header.getOrDefault("return-client-request-id")
  valid_575199 = validateParameter(valid_575199, JBool, required = false,
                                 default = newJBool(false))
  if valid_575199 != nil:
    section.add "return-client-request-id", valid_575199
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575200: Call_FileGetFromComputeNode_575186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the content of the specified Compute Node file.
  ## 
  let valid = call_575200.validator(path, query, header, formData, body)
  let scheme = call_575200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575200.url(scheme.get, call_575200.host, call_575200.base,
                         call_575200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575200, url, valid)

proc call*(call_575201: Call_FileGetFromComputeNode_575186; apiVersion: string;
          poolId: string; nodeId: string; filePath: string; timeout: int = 30): Recallable =
  ## fileGetFromComputeNode
  ## Returns the content of the specified Compute Node file.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the Compute Node that contains the file.
  ##   filePath: string (required)
  ##           : The path to the Compute Node file that you want to get the content of.
  var path_575202 = newJObject()
  var query_575203 = newJObject()
  add(query_575203, "timeout", newJInt(timeout))
  add(query_575203, "api-version", newJString(apiVersion))
  add(path_575202, "poolId", newJString(poolId))
  add(path_575202, "nodeId", newJString(nodeId))
  add(path_575202, "filePath", newJString(filePath))
  result = call_575201.call(path_575202, query_575203, nil, nil, nil)

var fileGetFromComputeNode* = Call_FileGetFromComputeNode_575186(
    name: "fileGetFromComputeNode", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/files/{filePath}",
    validator: validate_FileGetFromComputeNode_575187, base: "",
    url: url_FileGetFromComputeNode_575188, schemes: {Scheme.Https})
type
  Call_FileDeleteFromComputeNode_575204 = ref object of OpenApiRestCall_573667
proc url_FileDeleteFromComputeNode_575206(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  assert "filePath" in path, "`filePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "filePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileDeleteFromComputeNode_575205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the Compute Node from which you want to delete the file.
  ##   filePath: JString (required)
  ##           : The path to the file or directory that you want to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575207 = path.getOrDefault("poolId")
  valid_575207 = validateParameter(valid_575207, JString, required = true,
                                 default = nil)
  if valid_575207 != nil:
    section.add "poolId", valid_575207
  var valid_575208 = path.getOrDefault("nodeId")
  valid_575208 = validateParameter(valid_575208, JString, required = true,
                                 default = nil)
  if valid_575208 != nil:
    section.add "nodeId", valid_575208
  var valid_575209 = path.getOrDefault("filePath")
  valid_575209 = validateParameter(valid_575209, JString, required = true,
                                 default = nil)
  if valid_575209 != nil:
    section.add "filePath", valid_575209
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   recursive: JBool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  section = newJObject()
  var valid_575210 = query.getOrDefault("timeout")
  valid_575210 = validateParameter(valid_575210, JInt, required = false,
                                 default = newJInt(30))
  if valid_575210 != nil:
    section.add "timeout", valid_575210
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575211 = query.getOrDefault("api-version")
  valid_575211 = validateParameter(valid_575211, JString, required = true,
                                 default = nil)
  if valid_575211 != nil:
    section.add "api-version", valid_575211
  var valid_575212 = query.getOrDefault("recursive")
  valid_575212 = validateParameter(valid_575212, JBool, required = false, default = nil)
  if valid_575212 != nil:
    section.add "recursive", valid_575212
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575213 = header.getOrDefault("client-request-id")
  valid_575213 = validateParameter(valid_575213, JString, required = false,
                                 default = nil)
  if valid_575213 != nil:
    section.add "client-request-id", valid_575213
  var valid_575214 = header.getOrDefault("ocp-date")
  valid_575214 = validateParameter(valid_575214, JString, required = false,
                                 default = nil)
  if valid_575214 != nil:
    section.add "ocp-date", valid_575214
  var valid_575215 = header.getOrDefault("return-client-request-id")
  valid_575215 = validateParameter(valid_575215, JBool, required = false,
                                 default = newJBool(false))
  if valid_575215 != nil:
    section.add "return-client-request-id", valid_575215
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575216: Call_FileDeleteFromComputeNode_575204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575216.validator(path, query, header, formData, body)
  let scheme = call_575216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575216.url(scheme.get, call_575216.host, call_575216.base,
                         call_575216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575216, url, valid)

proc call*(call_575217: Call_FileDeleteFromComputeNode_575204; apiVersion: string;
          poolId: string; nodeId: string; filePath: string; timeout: int = 30;
          recursive: bool = false): Recallable =
  ## fileDeleteFromComputeNode
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the Compute Node from which you want to delete the file.
  ##   filePath: string (required)
  ##           : The path to the file or directory that you want to delete.
  ##   recursive: bool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  var path_575218 = newJObject()
  var query_575219 = newJObject()
  add(query_575219, "timeout", newJInt(timeout))
  add(query_575219, "api-version", newJString(apiVersion))
  add(path_575218, "poolId", newJString(poolId))
  add(path_575218, "nodeId", newJString(nodeId))
  add(path_575218, "filePath", newJString(filePath))
  add(query_575219, "recursive", newJBool(recursive))
  result = call_575217.call(path_575218, query_575219, nil, nil, nil)

var fileDeleteFromComputeNode* = Call_FileDeleteFromComputeNode_575204(
    name: "fileDeleteFromComputeNode", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/files/{filePath}",
    validator: validate_FileDeleteFromComputeNode_575205, base: "",
    url: url_FileDeleteFromComputeNode_575206, schemes: {Scheme.Https})
type
  Call_ComputeNodeGetRemoteDesktop_575237 = ref object of OpenApiRestCall_573667
proc url_ComputeNodeGetRemoteDesktop_575239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/rdp")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeNodeGetRemoteDesktop_575238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Before you can access a Compute Node by using the RDP file, you must create a user Account on the Compute Node. This API can only be invoked on Pools created with a cloud service configuration. For Pools created with a virtual machine configuration, see the GetRemoteLoginSettings API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the Compute Node for which you want to get the Remote Desktop Protocol file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575240 = path.getOrDefault("poolId")
  valid_575240 = validateParameter(valid_575240, JString, required = true,
                                 default = nil)
  if valid_575240 != nil:
    section.add "poolId", valid_575240
  var valid_575241 = path.getOrDefault("nodeId")
  valid_575241 = validateParameter(valid_575241, JString, required = true,
                                 default = nil)
  if valid_575241 != nil:
    section.add "nodeId", valid_575241
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575242 = query.getOrDefault("timeout")
  valid_575242 = validateParameter(valid_575242, JInt, required = false,
                                 default = newJInt(30))
  if valid_575242 != nil:
    section.add "timeout", valid_575242
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575243 = query.getOrDefault("api-version")
  valid_575243 = validateParameter(valid_575243, JString, required = true,
                                 default = nil)
  if valid_575243 != nil:
    section.add "api-version", valid_575243
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575244 = header.getOrDefault("client-request-id")
  valid_575244 = validateParameter(valid_575244, JString, required = false,
                                 default = nil)
  if valid_575244 != nil:
    section.add "client-request-id", valid_575244
  var valid_575245 = header.getOrDefault("ocp-date")
  valid_575245 = validateParameter(valid_575245, JString, required = false,
                                 default = nil)
  if valid_575245 != nil:
    section.add "ocp-date", valid_575245
  var valid_575246 = header.getOrDefault("return-client-request-id")
  valid_575246 = validateParameter(valid_575246, JBool, required = false,
                                 default = newJBool(false))
  if valid_575246 != nil:
    section.add "return-client-request-id", valid_575246
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575247: Call_ComputeNodeGetRemoteDesktop_575237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Before you can access a Compute Node by using the RDP file, you must create a user Account on the Compute Node. This API can only be invoked on Pools created with a cloud service configuration. For Pools created with a virtual machine configuration, see the GetRemoteLoginSettings API.
  ## 
  let valid = call_575247.validator(path, query, header, formData, body)
  let scheme = call_575247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575247.url(scheme.get, call_575247.host, call_575247.base,
                         call_575247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575247, url, valid)

proc call*(call_575248: Call_ComputeNodeGetRemoteDesktop_575237;
          apiVersion: string; poolId: string; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeGetRemoteDesktop
  ## Before you can access a Compute Node by using the RDP file, you must create a user Account on the Compute Node. This API can only be invoked on Pools created with a cloud service configuration. For Pools created with a virtual machine configuration, see the GetRemoteLoginSettings API.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the Compute Node for which you want to get the Remote Desktop Protocol file.
  var path_575249 = newJObject()
  var query_575250 = newJObject()
  add(query_575250, "timeout", newJInt(timeout))
  add(query_575250, "api-version", newJString(apiVersion))
  add(path_575249, "poolId", newJString(poolId))
  add(path_575249, "nodeId", newJString(nodeId))
  result = call_575248.call(path_575249, query_575250, nil, nil, nil)

var computeNodeGetRemoteDesktop* = Call_ComputeNodeGetRemoteDesktop_575237(
    name: "computeNodeGetRemoteDesktop", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/rdp",
    validator: validate_ComputeNodeGetRemoteDesktop_575238, base: "",
    url: url_ComputeNodeGetRemoteDesktop_575239, schemes: {Scheme.Https})
type
  Call_ComputeNodeReboot_575251 = ref object of OpenApiRestCall_573667
proc url_ComputeNodeReboot_575253(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/reboot")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeNodeReboot_575252(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## You can restart a Compute Node only if it is in an idle or running state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the Compute Node that you want to restart.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575254 = path.getOrDefault("poolId")
  valid_575254 = validateParameter(valid_575254, JString, required = true,
                                 default = nil)
  if valid_575254 != nil:
    section.add "poolId", valid_575254
  var valid_575255 = path.getOrDefault("nodeId")
  valid_575255 = validateParameter(valid_575255, JString, required = true,
                                 default = nil)
  if valid_575255 != nil:
    section.add "nodeId", valid_575255
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575256 = query.getOrDefault("timeout")
  valid_575256 = validateParameter(valid_575256, JInt, required = false,
                                 default = newJInt(30))
  if valid_575256 != nil:
    section.add "timeout", valid_575256
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575257 = query.getOrDefault("api-version")
  valid_575257 = validateParameter(valid_575257, JString, required = true,
                                 default = nil)
  if valid_575257 != nil:
    section.add "api-version", valid_575257
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575258 = header.getOrDefault("client-request-id")
  valid_575258 = validateParameter(valid_575258, JString, required = false,
                                 default = nil)
  if valid_575258 != nil:
    section.add "client-request-id", valid_575258
  var valid_575259 = header.getOrDefault("ocp-date")
  valid_575259 = validateParameter(valid_575259, JString, required = false,
                                 default = nil)
  if valid_575259 != nil:
    section.add "ocp-date", valid_575259
  var valid_575260 = header.getOrDefault("return-client-request-id")
  valid_575260 = validateParameter(valid_575260, JBool, required = false,
                                 default = newJBool(false))
  if valid_575260 != nil:
    section.add "return-client-request-id", valid_575260
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeRebootParameter: JObject
  ##                      : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575262: Call_ComputeNodeReboot_575251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can restart a Compute Node only if it is in an idle or running state.
  ## 
  let valid = call_575262.validator(path, query, header, formData, body)
  let scheme = call_575262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575262.url(scheme.get, call_575262.host, call_575262.base,
                         call_575262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575262, url, valid)

proc call*(call_575263: Call_ComputeNodeReboot_575251; apiVersion: string;
          poolId: string; nodeId: string; timeout: int = 30;
          nodeRebootParameter: JsonNode = nil): Recallable =
  ## computeNodeReboot
  ## You can restart a Compute Node only if it is in an idle or running state.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeRebootParameter: JObject
  ##                      : The parameters for the request.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the Compute Node that you want to restart.
  var path_575264 = newJObject()
  var query_575265 = newJObject()
  var body_575266 = newJObject()
  add(query_575265, "timeout", newJInt(timeout))
  add(query_575265, "api-version", newJString(apiVersion))
  if nodeRebootParameter != nil:
    body_575266 = nodeRebootParameter
  add(path_575264, "poolId", newJString(poolId))
  add(path_575264, "nodeId", newJString(nodeId))
  result = call_575263.call(path_575264, query_575265, nil, nil, body_575266)

var computeNodeReboot* = Call_ComputeNodeReboot_575251(name: "computeNodeReboot",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/reboot",
    validator: validate_ComputeNodeReboot_575252, base: "",
    url: url_ComputeNodeReboot_575253, schemes: {Scheme.Https})
type
  Call_ComputeNodeReimage_575267 = ref object of OpenApiRestCall_573667
proc url_ComputeNodeReimage_575269(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/reimage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeNodeReimage_575268(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## You can reinstall the operating system on a Compute Node only if it is in an idle or running state. This API can be invoked only on Pools created with the cloud service configuration property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the Compute Node that you want to restart.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575270 = path.getOrDefault("poolId")
  valid_575270 = validateParameter(valid_575270, JString, required = true,
                                 default = nil)
  if valid_575270 != nil:
    section.add "poolId", valid_575270
  var valid_575271 = path.getOrDefault("nodeId")
  valid_575271 = validateParameter(valid_575271, JString, required = true,
                                 default = nil)
  if valid_575271 != nil:
    section.add "nodeId", valid_575271
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575272 = query.getOrDefault("timeout")
  valid_575272 = validateParameter(valid_575272, JInt, required = false,
                                 default = newJInt(30))
  if valid_575272 != nil:
    section.add "timeout", valid_575272
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575273 = query.getOrDefault("api-version")
  valid_575273 = validateParameter(valid_575273, JString, required = true,
                                 default = nil)
  if valid_575273 != nil:
    section.add "api-version", valid_575273
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575274 = header.getOrDefault("client-request-id")
  valid_575274 = validateParameter(valid_575274, JString, required = false,
                                 default = nil)
  if valid_575274 != nil:
    section.add "client-request-id", valid_575274
  var valid_575275 = header.getOrDefault("ocp-date")
  valid_575275 = validateParameter(valid_575275, JString, required = false,
                                 default = nil)
  if valid_575275 != nil:
    section.add "ocp-date", valid_575275
  var valid_575276 = header.getOrDefault("return-client-request-id")
  valid_575276 = validateParameter(valid_575276, JBool, required = false,
                                 default = newJBool(false))
  if valid_575276 != nil:
    section.add "return-client-request-id", valid_575276
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeReimageParameter: JObject
  ##                       : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575278: Call_ComputeNodeReimage_575267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can reinstall the operating system on a Compute Node only if it is in an idle or running state. This API can be invoked only on Pools created with the cloud service configuration property.
  ## 
  let valid = call_575278.validator(path, query, header, formData, body)
  let scheme = call_575278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575278.url(scheme.get, call_575278.host, call_575278.base,
                         call_575278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575278, url, valid)

proc call*(call_575279: Call_ComputeNodeReimage_575267; apiVersion: string;
          poolId: string; nodeId: string; timeout: int = 30;
          nodeReimageParameter: JsonNode = nil): Recallable =
  ## computeNodeReimage
  ## You can reinstall the operating system on a Compute Node only if it is in an idle or running state. This API can be invoked only on Pools created with the cloud service configuration property.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the Compute Node that you want to restart.
  ##   nodeReimageParameter: JObject
  ##                       : The parameters for the request.
  var path_575280 = newJObject()
  var query_575281 = newJObject()
  var body_575282 = newJObject()
  add(query_575281, "timeout", newJInt(timeout))
  add(query_575281, "api-version", newJString(apiVersion))
  add(path_575280, "poolId", newJString(poolId))
  add(path_575280, "nodeId", newJString(nodeId))
  if nodeReimageParameter != nil:
    body_575282 = nodeReimageParameter
  result = call_575279.call(path_575280, query_575281, nil, nil, body_575282)

var computeNodeReimage* = Call_ComputeNodeReimage_575267(
    name: "computeNodeReimage", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/reimage",
    validator: validate_ComputeNodeReimage_575268, base: "",
    url: url_ComputeNodeReimage_575269, schemes: {Scheme.Https})
type
  Call_ComputeNodeGetRemoteLoginSettings_575283 = ref object of OpenApiRestCall_573667
proc url_ComputeNodeGetRemoteLoginSettings_575285(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/remoteloginsettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeNodeGetRemoteLoginSettings_575284(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Before you can remotely login to a Compute Node using the remote login settings, you must create a user Account on the Compute Node. This API can be invoked only on Pools created with the virtual machine configuration property. For Pools created with a cloud service configuration, see the GetRemoteDesktop API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the Compute Node for which to obtain the remote login settings.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575286 = path.getOrDefault("poolId")
  valid_575286 = validateParameter(valid_575286, JString, required = true,
                                 default = nil)
  if valid_575286 != nil:
    section.add "poolId", valid_575286
  var valid_575287 = path.getOrDefault("nodeId")
  valid_575287 = validateParameter(valid_575287, JString, required = true,
                                 default = nil)
  if valid_575287 != nil:
    section.add "nodeId", valid_575287
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575288 = query.getOrDefault("timeout")
  valid_575288 = validateParameter(valid_575288, JInt, required = false,
                                 default = newJInt(30))
  if valid_575288 != nil:
    section.add "timeout", valid_575288
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575289 = query.getOrDefault("api-version")
  valid_575289 = validateParameter(valid_575289, JString, required = true,
                                 default = nil)
  if valid_575289 != nil:
    section.add "api-version", valid_575289
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575290 = header.getOrDefault("client-request-id")
  valid_575290 = validateParameter(valid_575290, JString, required = false,
                                 default = nil)
  if valid_575290 != nil:
    section.add "client-request-id", valid_575290
  var valid_575291 = header.getOrDefault("ocp-date")
  valid_575291 = validateParameter(valid_575291, JString, required = false,
                                 default = nil)
  if valid_575291 != nil:
    section.add "ocp-date", valid_575291
  var valid_575292 = header.getOrDefault("return-client-request-id")
  valid_575292 = validateParameter(valid_575292, JBool, required = false,
                                 default = newJBool(false))
  if valid_575292 != nil:
    section.add "return-client-request-id", valid_575292
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575293: Call_ComputeNodeGetRemoteLoginSettings_575283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Before you can remotely login to a Compute Node using the remote login settings, you must create a user Account on the Compute Node. This API can be invoked only on Pools created with the virtual machine configuration property. For Pools created with a cloud service configuration, see the GetRemoteDesktop API.
  ## 
  let valid = call_575293.validator(path, query, header, formData, body)
  let scheme = call_575293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575293.url(scheme.get, call_575293.host, call_575293.base,
                         call_575293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575293, url, valid)

proc call*(call_575294: Call_ComputeNodeGetRemoteLoginSettings_575283;
          apiVersion: string; poolId: string; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeGetRemoteLoginSettings
  ## Before you can remotely login to a Compute Node using the remote login settings, you must create a user Account on the Compute Node. This API can be invoked only on Pools created with the virtual machine configuration property. For Pools created with a cloud service configuration, see the GetRemoteDesktop API.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the Compute Node for which to obtain the remote login settings.
  var path_575295 = newJObject()
  var query_575296 = newJObject()
  add(query_575296, "timeout", newJInt(timeout))
  add(query_575296, "api-version", newJString(apiVersion))
  add(path_575295, "poolId", newJString(poolId))
  add(path_575295, "nodeId", newJString(nodeId))
  result = call_575294.call(path_575295, query_575296, nil, nil, nil)

var computeNodeGetRemoteLoginSettings* = Call_ComputeNodeGetRemoteLoginSettings_575283(
    name: "computeNodeGetRemoteLoginSettings", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/remoteloginsettings",
    validator: validate_ComputeNodeGetRemoteLoginSettings_575284, base: "",
    url: url_ComputeNodeGetRemoteLoginSettings_575285, schemes: {Scheme.Https})
type
  Call_ComputeNodeUploadBatchServiceLogs_575297 = ref object of OpenApiRestCall_573667
proc url_ComputeNodeUploadBatchServiceLogs_575299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/uploadbatchservicelogs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeNodeUploadBatchServiceLogs_575298(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This is for gathering Azure Batch service log files in an automated fashion from Compute Nodes if you are experiencing an error and wish to escalate to Azure support. The Azure Batch service log files should be shared with Azure support to aid in debugging issues with the Batch service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the Compute Node from which you want to upload the Azure Batch service log files.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575300 = path.getOrDefault("poolId")
  valid_575300 = validateParameter(valid_575300, JString, required = true,
                                 default = nil)
  if valid_575300 != nil:
    section.add "poolId", valid_575300
  var valid_575301 = path.getOrDefault("nodeId")
  valid_575301 = validateParameter(valid_575301, JString, required = true,
                                 default = nil)
  if valid_575301 != nil:
    section.add "nodeId", valid_575301
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575302 = query.getOrDefault("timeout")
  valid_575302 = validateParameter(valid_575302, JInt, required = false,
                                 default = newJInt(30))
  if valid_575302 != nil:
    section.add "timeout", valid_575302
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575303 = query.getOrDefault("api-version")
  valid_575303 = validateParameter(valid_575303, JString, required = true,
                                 default = nil)
  if valid_575303 != nil:
    section.add "api-version", valid_575303
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575304 = header.getOrDefault("client-request-id")
  valid_575304 = validateParameter(valid_575304, JString, required = false,
                                 default = nil)
  if valid_575304 != nil:
    section.add "client-request-id", valid_575304
  var valid_575305 = header.getOrDefault("ocp-date")
  valid_575305 = validateParameter(valid_575305, JString, required = false,
                                 default = nil)
  if valid_575305 != nil:
    section.add "ocp-date", valid_575305
  var valid_575306 = header.getOrDefault("return-client-request-id")
  valid_575306 = validateParameter(valid_575306, JBool, required = false,
                                 default = newJBool(false))
  if valid_575306 != nil:
    section.add "return-client-request-id", valid_575306
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   uploadBatchServiceLogsConfiguration: JObject (required)
  ##                                      : The Azure Batch service log files upload configuration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575308: Call_ComputeNodeUploadBatchServiceLogs_575297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This is for gathering Azure Batch service log files in an automated fashion from Compute Nodes if you are experiencing an error and wish to escalate to Azure support. The Azure Batch service log files should be shared with Azure support to aid in debugging issues with the Batch service.
  ## 
  let valid = call_575308.validator(path, query, header, formData, body)
  let scheme = call_575308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575308.url(scheme.get, call_575308.host, call_575308.base,
                         call_575308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575308, url, valid)

proc call*(call_575309: Call_ComputeNodeUploadBatchServiceLogs_575297;
          apiVersion: string; poolId: string; nodeId: string;
          uploadBatchServiceLogsConfiguration: JsonNode; timeout: int = 30): Recallable =
  ## computeNodeUploadBatchServiceLogs
  ## This is for gathering Azure Batch service log files in an automated fashion from Compute Nodes if you are experiencing an error and wish to escalate to Azure support. The Azure Batch service log files should be shared with Azure support to aid in debugging issues with the Batch service.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the Compute Node from which you want to upload the Azure Batch service log files.
  ##   uploadBatchServiceLogsConfiguration: JObject (required)
  ##                                      : The Azure Batch service log files upload configuration.
  var path_575310 = newJObject()
  var query_575311 = newJObject()
  var body_575312 = newJObject()
  add(query_575311, "timeout", newJInt(timeout))
  add(query_575311, "api-version", newJString(apiVersion))
  add(path_575310, "poolId", newJString(poolId))
  add(path_575310, "nodeId", newJString(nodeId))
  if uploadBatchServiceLogsConfiguration != nil:
    body_575312 = uploadBatchServiceLogsConfiguration
  result = call_575309.call(path_575310, query_575311, nil, nil, body_575312)

var computeNodeUploadBatchServiceLogs* = Call_ComputeNodeUploadBatchServiceLogs_575297(
    name: "computeNodeUploadBatchServiceLogs", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/uploadbatchservicelogs",
    validator: validate_ComputeNodeUploadBatchServiceLogs_575298, base: "",
    url: url_ComputeNodeUploadBatchServiceLogs_575299, schemes: {Scheme.Https})
type
  Call_ComputeNodeAddUser_575313 = ref object of OpenApiRestCall_573667
proc url_ComputeNodeAddUser_575315(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeNodeAddUser_575314(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## You can add a user Account to a Compute Node only when it is in the idle or running state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the machine on which you want to create a user Account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575316 = path.getOrDefault("poolId")
  valid_575316 = validateParameter(valid_575316, JString, required = true,
                                 default = nil)
  if valid_575316 != nil:
    section.add "poolId", valid_575316
  var valid_575317 = path.getOrDefault("nodeId")
  valid_575317 = validateParameter(valid_575317, JString, required = true,
                                 default = nil)
  if valid_575317 != nil:
    section.add "nodeId", valid_575317
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575318 = query.getOrDefault("timeout")
  valid_575318 = validateParameter(valid_575318, JInt, required = false,
                                 default = newJInt(30))
  if valid_575318 != nil:
    section.add "timeout", valid_575318
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575319 = query.getOrDefault("api-version")
  valid_575319 = validateParameter(valid_575319, JString, required = true,
                                 default = nil)
  if valid_575319 != nil:
    section.add "api-version", valid_575319
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575320 = header.getOrDefault("client-request-id")
  valid_575320 = validateParameter(valid_575320, JString, required = false,
                                 default = nil)
  if valid_575320 != nil:
    section.add "client-request-id", valid_575320
  var valid_575321 = header.getOrDefault("ocp-date")
  valid_575321 = validateParameter(valid_575321, JString, required = false,
                                 default = nil)
  if valid_575321 != nil:
    section.add "ocp-date", valid_575321
  var valid_575322 = header.getOrDefault("return-client-request-id")
  valid_575322 = validateParameter(valid_575322, JBool, required = false,
                                 default = newJBool(false))
  if valid_575322 != nil:
    section.add "return-client-request-id", valid_575322
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   user: JObject (required)
  ##       : The user Account to be created.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575324: Call_ComputeNodeAddUser_575313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can add a user Account to a Compute Node only when it is in the idle or running state.
  ## 
  let valid = call_575324.validator(path, query, header, formData, body)
  let scheme = call_575324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575324.url(scheme.get, call_575324.host, call_575324.base,
                         call_575324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575324, url, valid)

proc call*(call_575325: Call_ComputeNodeAddUser_575313; apiVersion: string;
          user: JsonNode; poolId: string; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeAddUser
  ## You can add a user Account to a Compute Node only when it is in the idle or running state.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   user: JObject (required)
  ##       : The user Account to be created.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the machine on which you want to create a user Account.
  var path_575326 = newJObject()
  var query_575327 = newJObject()
  var body_575328 = newJObject()
  add(query_575327, "timeout", newJInt(timeout))
  add(query_575327, "api-version", newJString(apiVersion))
  if user != nil:
    body_575328 = user
  add(path_575326, "poolId", newJString(poolId))
  add(path_575326, "nodeId", newJString(nodeId))
  result = call_575325.call(path_575326, query_575327, nil, nil, body_575328)

var computeNodeAddUser* = Call_ComputeNodeAddUser_575313(
    name: "computeNodeAddUser", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/users",
    validator: validate_ComputeNodeAddUser_575314, base: "",
    url: url_ComputeNodeAddUser_575315, schemes: {Scheme.Https})
type
  Call_ComputeNodeUpdateUser_575329 = ref object of OpenApiRestCall_573667
proc url_ComputeNodeUpdateUser_575331(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeNodeUpdateUser_575330(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation replaces of all the updatable properties of the Account. For example, if the expiryTime element is not specified, the current value is replaced with the default value, not left unmodified. You can update a user Account on a Compute Node only when it is in the idle or running state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the machine on which you want to update a user Account.
  ##   userName: JString (required)
  ##           : The name of the user Account to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575332 = path.getOrDefault("poolId")
  valid_575332 = validateParameter(valid_575332, JString, required = true,
                                 default = nil)
  if valid_575332 != nil:
    section.add "poolId", valid_575332
  var valid_575333 = path.getOrDefault("nodeId")
  valid_575333 = validateParameter(valid_575333, JString, required = true,
                                 default = nil)
  if valid_575333 != nil:
    section.add "nodeId", valid_575333
  var valid_575334 = path.getOrDefault("userName")
  valid_575334 = validateParameter(valid_575334, JString, required = true,
                                 default = nil)
  if valid_575334 != nil:
    section.add "userName", valid_575334
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575335 = query.getOrDefault("timeout")
  valid_575335 = validateParameter(valid_575335, JInt, required = false,
                                 default = newJInt(30))
  if valid_575335 != nil:
    section.add "timeout", valid_575335
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575336 = query.getOrDefault("api-version")
  valid_575336 = validateParameter(valid_575336, JString, required = true,
                                 default = nil)
  if valid_575336 != nil:
    section.add "api-version", valid_575336
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575337 = header.getOrDefault("client-request-id")
  valid_575337 = validateParameter(valid_575337, JString, required = false,
                                 default = nil)
  if valid_575337 != nil:
    section.add "client-request-id", valid_575337
  var valid_575338 = header.getOrDefault("ocp-date")
  valid_575338 = validateParameter(valid_575338, JString, required = false,
                                 default = nil)
  if valid_575338 != nil:
    section.add "ocp-date", valid_575338
  var valid_575339 = header.getOrDefault("return-client-request-id")
  valid_575339 = validateParameter(valid_575339, JBool, required = false,
                                 default = newJBool(false))
  if valid_575339 != nil:
    section.add "return-client-request-id", valid_575339
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeUpdateUserParameter: JObject (required)
  ##                          : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575341: Call_ComputeNodeUpdateUser_575329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation replaces of all the updatable properties of the Account. For example, if the expiryTime element is not specified, the current value is replaced with the default value, not left unmodified. You can update a user Account on a Compute Node only when it is in the idle or running state.
  ## 
  let valid = call_575341.validator(path, query, header, formData, body)
  let scheme = call_575341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575341.url(scheme.get, call_575341.host, call_575341.base,
                         call_575341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575341, url, valid)

proc call*(call_575342: Call_ComputeNodeUpdateUser_575329; apiVersion: string;
          poolId: string; nodeId: string; nodeUpdateUserParameter: JsonNode;
          userName: string; timeout: int = 30): Recallable =
  ## computeNodeUpdateUser
  ## This operation replaces of all the updatable properties of the Account. For example, if the expiryTime element is not specified, the current value is replaced with the default value, not left unmodified. You can update a user Account on a Compute Node only when it is in the idle or running state.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the machine on which you want to update a user Account.
  ##   nodeUpdateUserParameter: JObject (required)
  ##                          : The parameters for the request.
  ##   userName: string (required)
  ##           : The name of the user Account to update.
  var path_575343 = newJObject()
  var query_575344 = newJObject()
  var body_575345 = newJObject()
  add(query_575344, "timeout", newJInt(timeout))
  add(query_575344, "api-version", newJString(apiVersion))
  add(path_575343, "poolId", newJString(poolId))
  add(path_575343, "nodeId", newJString(nodeId))
  if nodeUpdateUserParameter != nil:
    body_575345 = nodeUpdateUserParameter
  add(path_575343, "userName", newJString(userName))
  result = call_575342.call(path_575343, query_575344, nil, nil, body_575345)

var computeNodeUpdateUser* = Call_ComputeNodeUpdateUser_575329(
    name: "computeNodeUpdateUser", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/users/{userName}",
    validator: validate_ComputeNodeUpdateUser_575330, base: "",
    url: url_ComputeNodeUpdateUser_575331, schemes: {Scheme.Https})
type
  Call_ComputeNodeDeleteUser_575346 = ref object of OpenApiRestCall_573667
proc url_ComputeNodeDeleteUser_575348(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  assert "nodeId" in path, "`nodeId` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeNodeDeleteUser_575347(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can delete a user Account to a Compute Node only when it is in the idle or running state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: JString (required)
  ##         : The ID of the machine on which you want to delete a user Account.
  ##   userName: JString (required)
  ##           : The name of the user Account to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575349 = path.getOrDefault("poolId")
  valid_575349 = validateParameter(valid_575349, JString, required = true,
                                 default = nil)
  if valid_575349 != nil:
    section.add "poolId", valid_575349
  var valid_575350 = path.getOrDefault("nodeId")
  valid_575350 = validateParameter(valid_575350, JString, required = true,
                                 default = nil)
  if valid_575350 != nil:
    section.add "nodeId", valid_575350
  var valid_575351 = path.getOrDefault("userName")
  valid_575351 = validateParameter(valid_575351, JString, required = true,
                                 default = nil)
  if valid_575351 != nil:
    section.add "userName", valid_575351
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575352 = query.getOrDefault("timeout")
  valid_575352 = validateParameter(valid_575352, JInt, required = false,
                                 default = newJInt(30))
  if valid_575352 != nil:
    section.add "timeout", valid_575352
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575353 = query.getOrDefault("api-version")
  valid_575353 = validateParameter(valid_575353, JString, required = true,
                                 default = nil)
  if valid_575353 != nil:
    section.add "api-version", valid_575353
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575354 = header.getOrDefault("client-request-id")
  valid_575354 = validateParameter(valid_575354, JString, required = false,
                                 default = nil)
  if valid_575354 != nil:
    section.add "client-request-id", valid_575354
  var valid_575355 = header.getOrDefault("ocp-date")
  valid_575355 = validateParameter(valid_575355, JString, required = false,
                                 default = nil)
  if valid_575355 != nil:
    section.add "ocp-date", valid_575355
  var valid_575356 = header.getOrDefault("return-client-request-id")
  valid_575356 = validateParameter(valid_575356, JBool, required = false,
                                 default = newJBool(false))
  if valid_575356 != nil:
    section.add "return-client-request-id", valid_575356
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575357: Call_ComputeNodeDeleteUser_575346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can delete a user Account to a Compute Node only when it is in the idle or running state.
  ## 
  let valid = call_575357.validator(path, query, header, formData, body)
  let scheme = call_575357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575357.url(scheme.get, call_575357.host, call_575357.base,
                         call_575357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575357, url, valid)

proc call*(call_575358: Call_ComputeNodeDeleteUser_575346; apiVersion: string;
          poolId: string; nodeId: string; userName: string; timeout: int = 30): Recallable =
  ## computeNodeDeleteUser
  ## You can delete a user Account to a Compute Node only when it is in the idle or running state.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool that contains the Compute Node.
  ##   nodeId: string (required)
  ##         : The ID of the machine on which you want to delete a user Account.
  ##   userName: string (required)
  ##           : The name of the user Account to delete.
  var path_575359 = newJObject()
  var query_575360 = newJObject()
  add(query_575360, "timeout", newJInt(timeout))
  add(query_575360, "api-version", newJString(apiVersion))
  add(path_575359, "poolId", newJString(poolId))
  add(path_575359, "nodeId", newJString(nodeId))
  add(path_575359, "userName", newJString(userName))
  result = call_575358.call(path_575359, query_575360, nil, nil, nil)

var computeNodeDeleteUser* = Call_ComputeNodeDeleteUser_575346(
    name: "computeNodeDeleteUser", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/users/{userName}",
    validator: validate_ComputeNodeDeleteUser_575347, base: "",
    url: url_ComputeNodeDeleteUser_575348, schemes: {Scheme.Https})
type
  Call_PoolRemoveNodes_575361 = ref object of OpenApiRestCall_573667
proc url_PoolRemoveNodes_575363(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/removenodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolRemoveNodes_575362(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## This operation can only run when the allocation state of the Pool is steady. When this operation runs, the allocation state changes from steady to resizing.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool from which you want to remove Compute Nodes.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575364 = path.getOrDefault("poolId")
  valid_575364 = validateParameter(valid_575364, JString, required = true,
                                 default = nil)
  if valid_575364 != nil:
    section.add "poolId", valid_575364
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575365 = query.getOrDefault("timeout")
  valid_575365 = validateParameter(valid_575365, JInt, required = false,
                                 default = newJInt(30))
  if valid_575365 != nil:
    section.add "timeout", valid_575365
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575366 = query.getOrDefault("api-version")
  valid_575366 = validateParameter(valid_575366, JString, required = true,
                                 default = nil)
  if valid_575366 != nil:
    section.add "api-version", valid_575366
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575367 = header.getOrDefault("If-Match")
  valid_575367 = validateParameter(valid_575367, JString, required = false,
                                 default = nil)
  if valid_575367 != nil:
    section.add "If-Match", valid_575367
  var valid_575368 = header.getOrDefault("client-request-id")
  valid_575368 = validateParameter(valid_575368, JString, required = false,
                                 default = nil)
  if valid_575368 != nil:
    section.add "client-request-id", valid_575368
  var valid_575369 = header.getOrDefault("ocp-date")
  valid_575369 = validateParameter(valid_575369, JString, required = false,
                                 default = nil)
  if valid_575369 != nil:
    section.add "ocp-date", valid_575369
  var valid_575370 = header.getOrDefault("If-Unmodified-Since")
  valid_575370 = validateParameter(valid_575370, JString, required = false,
                                 default = nil)
  if valid_575370 != nil:
    section.add "If-Unmodified-Since", valid_575370
  var valid_575371 = header.getOrDefault("If-None-Match")
  valid_575371 = validateParameter(valid_575371, JString, required = false,
                                 default = nil)
  if valid_575371 != nil:
    section.add "If-None-Match", valid_575371
  var valid_575372 = header.getOrDefault("If-Modified-Since")
  valid_575372 = validateParameter(valid_575372, JString, required = false,
                                 default = nil)
  if valid_575372 != nil:
    section.add "If-Modified-Since", valid_575372
  var valid_575373 = header.getOrDefault("return-client-request-id")
  valid_575373 = validateParameter(valid_575373, JBool, required = false,
                                 default = newJBool(false))
  if valid_575373 != nil:
    section.add "return-client-request-id", valid_575373
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeRemoveParameter: JObject (required)
  ##                      : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575375: Call_PoolRemoveNodes_575361; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation can only run when the allocation state of the Pool is steady. When this operation runs, the allocation state changes from steady to resizing.
  ## 
  let valid = call_575375.validator(path, query, header, formData, body)
  let scheme = call_575375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575375.url(scheme.get, call_575375.host, call_575375.base,
                         call_575375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575375, url, valid)

proc call*(call_575376: Call_PoolRemoveNodes_575361; apiVersion: string;
          poolId: string; nodeRemoveParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolRemoveNodes
  ## This operation can only run when the allocation state of the Pool is steady. When this operation runs, the allocation state changes from steady to resizing.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool from which you want to remove Compute Nodes.
  ##   nodeRemoveParameter: JObject (required)
  ##                      : The parameters for the request.
  var path_575377 = newJObject()
  var query_575378 = newJObject()
  var body_575379 = newJObject()
  add(query_575378, "timeout", newJInt(timeout))
  add(query_575378, "api-version", newJString(apiVersion))
  add(path_575377, "poolId", newJString(poolId))
  if nodeRemoveParameter != nil:
    body_575379 = nodeRemoveParameter
  result = call_575376.call(path_575377, query_575378, nil, nil, body_575379)

var poolRemoveNodes* = Call_PoolRemoveNodes_575361(name: "poolRemoveNodes",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/removenodes", validator: validate_PoolRemoveNodes_575362,
    base: "", url: url_PoolRemoveNodes_575363, schemes: {Scheme.Https})
type
  Call_PoolResize_575380 = ref object of OpenApiRestCall_573667
proc url_PoolResize_575382(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/resize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolResize_575381(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## You can only resize a Pool when its allocation state is steady. If the Pool is already resizing, the request fails with status code 409. When you resize a Pool, the Pool's allocation state changes from steady to resizing. You cannot resize Pools which are configured for automatic scaling. If you try to do this, the Batch service returns an error 409. If you resize a Pool downwards, the Batch service chooses which Compute Nodes to remove. To remove specific Compute Nodes, use the Pool remove Compute Nodes API instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool to resize.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575383 = path.getOrDefault("poolId")
  valid_575383 = validateParameter(valid_575383, JString, required = true,
                                 default = nil)
  if valid_575383 != nil:
    section.add "poolId", valid_575383
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575384 = query.getOrDefault("timeout")
  valid_575384 = validateParameter(valid_575384, JInt, required = false,
                                 default = newJInt(30))
  if valid_575384 != nil:
    section.add "timeout", valid_575384
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575385 = query.getOrDefault("api-version")
  valid_575385 = validateParameter(valid_575385, JString, required = true,
                                 default = nil)
  if valid_575385 != nil:
    section.add "api-version", valid_575385
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575386 = header.getOrDefault("If-Match")
  valid_575386 = validateParameter(valid_575386, JString, required = false,
                                 default = nil)
  if valid_575386 != nil:
    section.add "If-Match", valid_575386
  var valid_575387 = header.getOrDefault("client-request-id")
  valid_575387 = validateParameter(valid_575387, JString, required = false,
                                 default = nil)
  if valid_575387 != nil:
    section.add "client-request-id", valid_575387
  var valid_575388 = header.getOrDefault("ocp-date")
  valid_575388 = validateParameter(valid_575388, JString, required = false,
                                 default = nil)
  if valid_575388 != nil:
    section.add "ocp-date", valid_575388
  var valid_575389 = header.getOrDefault("If-Unmodified-Since")
  valid_575389 = validateParameter(valid_575389, JString, required = false,
                                 default = nil)
  if valid_575389 != nil:
    section.add "If-Unmodified-Since", valid_575389
  var valid_575390 = header.getOrDefault("If-None-Match")
  valid_575390 = validateParameter(valid_575390, JString, required = false,
                                 default = nil)
  if valid_575390 != nil:
    section.add "If-None-Match", valid_575390
  var valid_575391 = header.getOrDefault("If-Modified-Since")
  valid_575391 = validateParameter(valid_575391, JString, required = false,
                                 default = nil)
  if valid_575391 != nil:
    section.add "If-Modified-Since", valid_575391
  var valid_575392 = header.getOrDefault("return-client-request-id")
  valid_575392 = validateParameter(valid_575392, JBool, required = false,
                                 default = newJBool(false))
  if valid_575392 != nil:
    section.add "return-client-request-id", valid_575392
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   poolResizeParameter: JObject (required)
  ##                      : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575394: Call_PoolResize_575380; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can only resize a Pool when its allocation state is steady. If the Pool is already resizing, the request fails with status code 409. When you resize a Pool, the Pool's allocation state changes from steady to resizing. You cannot resize Pools which are configured for automatic scaling. If you try to do this, the Batch service returns an error 409. If you resize a Pool downwards, the Batch service chooses which Compute Nodes to remove. To remove specific Compute Nodes, use the Pool remove Compute Nodes API instead.
  ## 
  let valid = call_575394.validator(path, query, header, formData, body)
  let scheme = call_575394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575394.url(scheme.get, call_575394.host, call_575394.base,
                         call_575394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575394, url, valid)

proc call*(call_575395: Call_PoolResize_575380; apiVersion: string; poolId: string;
          poolResizeParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolResize
  ## You can only resize a Pool when its allocation state is steady. If the Pool is already resizing, the request fails with status code 409. When you resize a Pool, the Pool's allocation state changes from steady to resizing. You cannot resize Pools which are configured for automatic scaling. If you try to do this, the Batch service returns an error 409. If you resize a Pool downwards, the Batch service chooses which Compute Nodes to remove. To remove specific Compute Nodes, use the Pool remove Compute Nodes API instead.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool to resize.
  ##   poolResizeParameter: JObject (required)
  ##                      : The parameters for the request.
  var path_575396 = newJObject()
  var query_575397 = newJObject()
  var body_575398 = newJObject()
  add(query_575397, "timeout", newJInt(timeout))
  add(query_575397, "api-version", newJString(apiVersion))
  add(path_575396, "poolId", newJString(poolId))
  if poolResizeParameter != nil:
    body_575398 = poolResizeParameter
  result = call_575395.call(path_575396, query_575397, nil, nil, body_575398)

var poolResize* = Call_PoolResize_575380(name: "poolResize",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local",
                                      route: "/pools/{poolId}/resize",
                                      validator: validate_PoolResize_575381,
                                      base: "", url: url_PoolResize_575382,
                                      schemes: {Scheme.Https})
type
  Call_PoolStopResize_575399 = ref object of OpenApiRestCall_573667
proc url_PoolStopResize_575401(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/stopresize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolStopResize_575400(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## This does not restore the Pool to its previous state before the resize operation: it only stops any further changes being made, and the Pool maintains its current state. After stopping, the Pool stabilizes at the number of Compute Nodes it was at when the stop operation was done. During the stop operation, the Pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize Pool request; this API can also be used to halt the initial sizing of the Pool when it is created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool whose resizing you want to stop.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575402 = path.getOrDefault("poolId")
  valid_575402 = validateParameter(valid_575402, JString, required = true,
                                 default = nil)
  if valid_575402 != nil:
    section.add "poolId", valid_575402
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575403 = query.getOrDefault("timeout")
  valid_575403 = validateParameter(valid_575403, JInt, required = false,
                                 default = newJInt(30))
  if valid_575403 != nil:
    section.add "timeout", valid_575403
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575404 = query.getOrDefault("api-version")
  valid_575404 = validateParameter(valid_575404, JString, required = true,
                                 default = nil)
  if valid_575404 != nil:
    section.add "api-version", valid_575404
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575405 = header.getOrDefault("If-Match")
  valid_575405 = validateParameter(valid_575405, JString, required = false,
                                 default = nil)
  if valid_575405 != nil:
    section.add "If-Match", valid_575405
  var valid_575406 = header.getOrDefault("client-request-id")
  valid_575406 = validateParameter(valid_575406, JString, required = false,
                                 default = nil)
  if valid_575406 != nil:
    section.add "client-request-id", valid_575406
  var valid_575407 = header.getOrDefault("ocp-date")
  valid_575407 = validateParameter(valid_575407, JString, required = false,
                                 default = nil)
  if valid_575407 != nil:
    section.add "ocp-date", valid_575407
  var valid_575408 = header.getOrDefault("If-Unmodified-Since")
  valid_575408 = validateParameter(valid_575408, JString, required = false,
                                 default = nil)
  if valid_575408 != nil:
    section.add "If-Unmodified-Since", valid_575408
  var valid_575409 = header.getOrDefault("If-None-Match")
  valid_575409 = validateParameter(valid_575409, JString, required = false,
                                 default = nil)
  if valid_575409 != nil:
    section.add "If-None-Match", valid_575409
  var valid_575410 = header.getOrDefault("If-Modified-Since")
  valid_575410 = validateParameter(valid_575410, JString, required = false,
                                 default = nil)
  if valid_575410 != nil:
    section.add "If-Modified-Since", valid_575410
  var valid_575411 = header.getOrDefault("return-client-request-id")
  valid_575411 = validateParameter(valid_575411, JBool, required = false,
                                 default = newJBool(false))
  if valid_575411 != nil:
    section.add "return-client-request-id", valid_575411
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575412: Call_PoolStopResize_575399; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This does not restore the Pool to its previous state before the resize operation: it only stops any further changes being made, and the Pool maintains its current state. After stopping, the Pool stabilizes at the number of Compute Nodes it was at when the stop operation was done. During the stop operation, the Pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize Pool request; this API can also be used to halt the initial sizing of the Pool when it is created.
  ## 
  let valid = call_575412.validator(path, query, header, formData, body)
  let scheme = call_575412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575412.url(scheme.get, call_575412.host, call_575412.base,
                         call_575412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575412, url, valid)

proc call*(call_575413: Call_PoolStopResize_575399; apiVersion: string;
          poolId: string; timeout: int = 30): Recallable =
  ## poolStopResize
  ## This does not restore the Pool to its previous state before the resize operation: it only stops any further changes being made, and the Pool maintains its current state. After stopping, the Pool stabilizes at the number of Compute Nodes it was at when the stop operation was done. During the stop operation, the Pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize Pool request; this API can also be used to halt the initial sizing of the Pool when it is created.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool whose resizing you want to stop.
  var path_575414 = newJObject()
  var query_575415 = newJObject()
  add(query_575415, "timeout", newJInt(timeout))
  add(query_575415, "api-version", newJString(apiVersion))
  add(path_575414, "poolId", newJString(poolId))
  result = call_575413.call(path_575414, query_575415, nil, nil, nil)

var poolStopResize* = Call_PoolStopResize_575399(name: "poolStopResize",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/stopresize", validator: validate_PoolStopResize_575400,
    base: "", url: url_PoolStopResize_575401, schemes: {Scheme.Https})
type
  Call_PoolUpdateProperties_575416 = ref object of OpenApiRestCall_573667
proc url_PoolUpdateProperties_575418(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "poolId" in path, "`poolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolId"),
               (kind: ConstantSegment, value: "/updateproperties")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoolUpdateProperties_575417(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This fully replaces all the updatable properties of the Pool. For example, if the Pool has a StartTask associated with it and if StartTask is not specified with this request, then the Batch service will remove the existing StartTask.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_575419 = path.getOrDefault("poolId")
  valid_575419 = validateParameter(valid_575419, JString, required = true,
                                 default = nil)
  if valid_575419 != nil:
    section.add "poolId", valid_575419
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_575420 = query.getOrDefault("timeout")
  valid_575420 = validateParameter(valid_575420, JInt, required = false,
                                 default = newJInt(30))
  if valid_575420 != nil:
    section.add "timeout", valid_575420
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575421 = query.getOrDefault("api-version")
  valid_575421 = validateParameter(valid_575421, JString, required = true,
                                 default = nil)
  if valid_575421 != nil:
    section.add "api-version", valid_575421
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575422 = header.getOrDefault("client-request-id")
  valid_575422 = validateParameter(valid_575422, JString, required = false,
                                 default = nil)
  if valid_575422 != nil:
    section.add "client-request-id", valid_575422
  var valid_575423 = header.getOrDefault("ocp-date")
  valid_575423 = validateParameter(valid_575423, JString, required = false,
                                 default = nil)
  if valid_575423 != nil:
    section.add "ocp-date", valid_575423
  var valid_575424 = header.getOrDefault("return-client-request-id")
  valid_575424 = validateParameter(valid_575424, JBool, required = false,
                                 default = newJBool(false))
  if valid_575424 != nil:
    section.add "return-client-request-id", valid_575424
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   poolUpdatePropertiesParameter: JObject (required)
  ##                                : The parameters for the request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575426: Call_PoolUpdateProperties_575416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This fully replaces all the updatable properties of the Pool. For example, if the Pool has a StartTask associated with it and if StartTask is not specified with this request, then the Batch service will remove the existing StartTask.
  ## 
  let valid = call_575426.validator(path, query, header, formData, body)
  let scheme = call_575426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575426.url(scheme.get, call_575426.host, call_575426.base,
                         call_575426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575426, url, valid)

proc call*(call_575427: Call_PoolUpdateProperties_575416; apiVersion: string;
          poolId: string; poolUpdatePropertiesParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolUpdateProperties
  ## This fully replaces all the updatable properties of the Pool. For example, if the Pool has a StartTask associated with it and if StartTask is not specified with this request, then the Batch service will remove the existing StartTask.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool to update.
  ##   poolUpdatePropertiesParameter: JObject (required)
  ##                                : The parameters for the request.
  var path_575428 = newJObject()
  var query_575429 = newJObject()
  var body_575430 = newJObject()
  add(query_575429, "timeout", newJInt(timeout))
  add(query_575429, "api-version", newJString(apiVersion))
  add(path_575428, "poolId", newJString(poolId))
  if poolUpdatePropertiesParameter != nil:
    body_575430 = poolUpdatePropertiesParameter
  result = call_575427.call(path_575428, query_575429, nil, nil, body_575430)

var poolUpdateProperties* = Call_PoolUpdateProperties_575416(
    name: "poolUpdateProperties", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/updateproperties",
    validator: validate_PoolUpdateProperties_575417, base: "",
    url: url_PoolUpdateProperties_575418, schemes: {Scheme.Https})
type
  Call_PoolListUsageMetrics_575431 = ref object of OpenApiRestCall_573667
proc url_PoolListUsageMetrics_575433(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolListUsageMetrics_575432(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## If you do not specify a $filter clause including a poolId, the response includes all Pools that existed in the Account in the time range of the returned aggregation intervals. If you do not specify a $filter clause including a startTime or endTime these filters default to the start and end times of the last aggregation interval currently available; that is, only the last aggregation interval is returned.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   endtime: JString
  ##          : The latest time from which to include metrics. This must be at least two hours before the current time. If not specified this defaults to the end time of the last aggregation interval currently available.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 results will be returned.
  ##   starttime: JString
  ##            : The earliest time from which to include metrics. This must be at least two and a half hours before the current time. If not specified this defaults to the start time of the last aggregation interval currently available.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-account-usage-metrics.
  section = newJObject()
  var valid_575434 = query.getOrDefault("timeout")
  valid_575434 = validateParameter(valid_575434, JInt, required = false,
                                 default = newJInt(30))
  if valid_575434 != nil:
    section.add "timeout", valid_575434
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575435 = query.getOrDefault("api-version")
  valid_575435 = validateParameter(valid_575435, JString, required = true,
                                 default = nil)
  if valid_575435 != nil:
    section.add "api-version", valid_575435
  var valid_575436 = query.getOrDefault("endtime")
  valid_575436 = validateParameter(valid_575436, JString, required = false,
                                 default = nil)
  if valid_575436 != nil:
    section.add "endtime", valid_575436
  var valid_575437 = query.getOrDefault("maxresults")
  valid_575437 = validateParameter(valid_575437, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575437 != nil:
    section.add "maxresults", valid_575437
  var valid_575438 = query.getOrDefault("starttime")
  valid_575438 = validateParameter(valid_575438, JString, required = false,
                                 default = nil)
  if valid_575438 != nil:
    section.add "starttime", valid_575438
  var valid_575439 = query.getOrDefault("$filter")
  valid_575439 = validateParameter(valid_575439, JString, required = false,
                                 default = nil)
  if valid_575439 != nil:
    section.add "$filter", valid_575439
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575440 = header.getOrDefault("client-request-id")
  valid_575440 = validateParameter(valid_575440, JString, required = false,
                                 default = nil)
  if valid_575440 != nil:
    section.add "client-request-id", valid_575440
  var valid_575441 = header.getOrDefault("ocp-date")
  valid_575441 = validateParameter(valid_575441, JString, required = false,
                                 default = nil)
  if valid_575441 != nil:
    section.add "ocp-date", valid_575441
  var valid_575442 = header.getOrDefault("return-client-request-id")
  valid_575442 = validateParameter(valid_575442, JBool, required = false,
                                 default = newJBool(false))
  if valid_575442 != nil:
    section.add "return-client-request-id", valid_575442
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575443: Call_PoolListUsageMetrics_575431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If you do not specify a $filter clause including a poolId, the response includes all Pools that existed in the Account in the time range of the returned aggregation intervals. If you do not specify a $filter clause including a startTime or endTime these filters default to the start and end times of the last aggregation interval currently available; that is, only the last aggregation interval is returned.
  ## 
  let valid = call_575443.validator(path, query, header, formData, body)
  let scheme = call_575443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575443.url(scheme.get, call_575443.host, call_575443.base,
                         call_575443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575443, url, valid)

proc call*(call_575444: Call_PoolListUsageMetrics_575431; apiVersion: string;
          timeout: int = 30; endtime: string = ""; maxresults: int = 1000;
          starttime: string = ""; Filter: string = ""): Recallable =
  ## poolListUsageMetrics
  ## If you do not specify a $filter clause including a poolId, the response includes all Pools that existed in the Account in the time range of the returned aggregation intervals. If you do not specify a $filter clause including a startTime or endTime these filters default to the start and end times of the last aggregation interval currently available; that is, only the last aggregation interval is returned.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   endtime: string
  ##          : The latest time from which to include metrics. This must be at least two hours before the current time. If not specified this defaults to the end time of the last aggregation interval currently available.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 results will be returned.
  ##   starttime: string
  ##            : The earliest time from which to include metrics. This must be at least two and a half hours before the current time. If not specified this defaults to the start time of the last aggregation interval currently available.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-account-usage-metrics.
  var query_575445 = newJObject()
  add(query_575445, "timeout", newJInt(timeout))
  add(query_575445, "api-version", newJString(apiVersion))
  add(query_575445, "endtime", newJString(endtime))
  add(query_575445, "maxresults", newJInt(maxresults))
  add(query_575445, "starttime", newJString(starttime))
  add(query_575445, "$filter", newJString(Filter))
  result = call_575444.call(nil, query_575445, nil, nil, nil)

var poolListUsageMetrics* = Call_PoolListUsageMetrics_575431(
    name: "poolListUsageMetrics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/poolusagemetrics", validator: validate_PoolListUsageMetrics_575432,
    base: "", url: url_PoolListUsageMetrics_575433, schemes: {Scheme.Https})
type
  Call_AccountListSupportedImages_575446 = ref object of OpenApiRestCall_573667
proc url_AccountListSupportedImages_575448(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccountListSupportedImages_575447(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 results will be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-support-images.
  section = newJObject()
  var valid_575449 = query.getOrDefault("timeout")
  valid_575449 = validateParameter(valid_575449, JInt, required = false,
                                 default = newJInt(30))
  if valid_575449 != nil:
    section.add "timeout", valid_575449
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575450 = query.getOrDefault("api-version")
  valid_575450 = validateParameter(valid_575450, JString, required = true,
                                 default = nil)
  if valid_575450 != nil:
    section.add "api-version", valid_575450
  var valid_575451 = query.getOrDefault("maxresults")
  valid_575451 = validateParameter(valid_575451, JInt, required = false,
                                 default = newJInt(1000))
  if valid_575451 != nil:
    section.add "maxresults", valid_575451
  var valid_575452 = query.getOrDefault("$filter")
  valid_575452 = validateParameter(valid_575452, JString, required = false,
                                 default = nil)
  if valid_575452 != nil:
    section.add "$filter", valid_575452
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_575453 = header.getOrDefault("client-request-id")
  valid_575453 = validateParameter(valid_575453, JString, required = false,
                                 default = nil)
  if valid_575453 != nil:
    section.add "client-request-id", valid_575453
  var valid_575454 = header.getOrDefault("ocp-date")
  valid_575454 = validateParameter(valid_575454, JString, required = false,
                                 default = nil)
  if valid_575454 != nil:
    section.add "ocp-date", valid_575454
  var valid_575455 = header.getOrDefault("return-client-request-id")
  valid_575455 = validateParameter(valid_575455, JBool, required = false,
                                 default = newJBool(false))
  if valid_575455 != nil:
    section.add "return-client-request-id", valid_575455
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575456: Call_AccountListSupportedImages_575446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575456.validator(path, query, header, formData, body)
  let scheme = call_575456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575456.url(scheme.get, call_575456.host, call_575456.base,
                         call_575456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575456, url, valid)

proc call*(call_575457: Call_AccountListSupportedImages_575446; apiVersion: string;
          timeout: int = 30; maxresults: int = 1000; Filter: string = ""): Recallable =
  ## accountListSupportedImages
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 results will be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-support-images.
  var query_575458 = newJObject()
  add(query_575458, "timeout", newJInt(timeout))
  add(query_575458, "api-version", newJString(apiVersion))
  add(query_575458, "maxresults", newJInt(maxresults))
  add(query_575458, "$filter", newJString(Filter))
  result = call_575457.call(nil, query_575458, nil, nil, nil)

var accountListSupportedImages* = Call_AccountListSupportedImages_575446(
    name: "accountListSupportedImages", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/supportedimages",
    validator: validate_AccountListSupportedImages_575447, base: "",
    url: url_AccountListSupportedImages_575448, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
