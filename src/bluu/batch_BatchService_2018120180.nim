
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BatchService
## version: 2018-12-01.8.0
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
  macServiceName = "batch-BatchService"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApplicationList_567889 = ref object of OpenApiRestCall_567667
proc url_ApplicationList_567891(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationList_567890(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## This operation returns only applications and versions that are available for use on compute nodes; that is, that can be used in an application package reference. For administrator information about applications and versions that are not yet available to compute nodes, use the Azure portal or the Azure Resource Manager API.
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
  var valid_568064 = query.getOrDefault("timeout")
  valid_568064 = validateParameter(valid_568064, JInt, required = false,
                                 default = newJInt(30))
  if valid_568064 != nil:
    section.add "timeout", valid_568064
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568065 = query.getOrDefault("api-version")
  valid_568065 = validateParameter(valid_568065, JString, required = true,
                                 default = nil)
  if valid_568065 != nil:
    section.add "api-version", valid_568065
  var valid_568066 = query.getOrDefault("maxresults")
  valid_568066 = validateParameter(valid_568066, JInt, required = false,
                                 default = newJInt(1000))
  if valid_568066 != nil:
    section.add "maxresults", valid_568066
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568067 = header.getOrDefault("client-request-id")
  valid_568067 = validateParameter(valid_568067, JString, required = false,
                                 default = nil)
  if valid_568067 != nil:
    section.add "client-request-id", valid_568067
  var valid_568068 = header.getOrDefault("ocp-date")
  valid_568068 = validateParameter(valid_568068, JString, required = false,
                                 default = nil)
  if valid_568068 != nil:
    section.add "ocp-date", valid_568068
  var valid_568069 = header.getOrDefault("return-client-request-id")
  valid_568069 = validateParameter(valid_568069, JBool, required = false,
                                 default = newJBool(false))
  if valid_568069 != nil:
    section.add "return-client-request-id", valid_568069
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568092: Call_ApplicationList_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation returns only applications and versions that are available for use on compute nodes; that is, that can be used in an application package reference. For administrator information about applications and versions that are not yet available to compute nodes, use the Azure portal or the Azure Resource Manager API.
  ## 
  let valid = call_568092.validator(path, query, header, formData, body)
  let scheme = call_568092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568092.url(scheme.get, call_568092.host, call_568092.base,
                         call_568092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568092, url, valid)

proc call*(call_568163: Call_ApplicationList_567889; apiVersion: string;
          timeout: int = 30; maxresults: int = 1000): Recallable =
  ## applicationList
  ## This operation returns only applications and versions that are available for use on compute nodes; that is, that can be used in an application package reference. For administrator information about applications and versions that are not yet available to compute nodes, use the Azure portal or the Azure Resource Manager API.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 applications can be returned.
  var query_568164 = newJObject()
  add(query_568164, "timeout", newJInt(timeout))
  add(query_568164, "api-version", newJString(apiVersion))
  add(query_568164, "maxresults", newJInt(maxresults))
  result = call_568163.call(nil, query_568164, nil, nil, nil)

var applicationList* = Call_ApplicationList_567889(name: "applicationList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/applications",
    validator: validate_ApplicationList_567890, base: "", url: url_ApplicationList_567891,
    schemes: {Scheme.Https})
type
  Call_ApplicationGet_568204 = ref object of OpenApiRestCall_567667
proc url_ApplicationGet_568206(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGet_568205(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## This operation returns only applications and versions that are available for use on compute nodes; that is, that can be used in an application package reference. For administrator information about applications and versions that are not yet available to compute nodes, use the Azure portal or the Azure Resource Manager API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The ID of the application.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_568221 = path.getOrDefault("applicationId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "applicationId", valid_568221
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568222 = query.getOrDefault("timeout")
  valid_568222 = validateParameter(valid_568222, JInt, required = false,
                                 default = newJInt(30))
  if valid_568222 != nil:
    section.add "timeout", valid_568222
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568224 = header.getOrDefault("client-request-id")
  valid_568224 = validateParameter(valid_568224, JString, required = false,
                                 default = nil)
  if valid_568224 != nil:
    section.add "client-request-id", valid_568224
  var valid_568225 = header.getOrDefault("ocp-date")
  valid_568225 = validateParameter(valid_568225, JString, required = false,
                                 default = nil)
  if valid_568225 != nil:
    section.add "ocp-date", valid_568225
  var valid_568226 = header.getOrDefault("return-client-request-id")
  valid_568226 = validateParameter(valid_568226, JBool, required = false,
                                 default = newJBool(false))
  if valid_568226 != nil:
    section.add "return-client-request-id", valid_568226
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568227: Call_ApplicationGet_568204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation returns only applications and versions that are available for use on compute nodes; that is, that can be used in an application package reference. For administrator information about applications and versions that are not yet available to compute nodes, use the Azure portal or the Azure Resource Manager API.
  ## 
  let valid = call_568227.validator(path, query, header, formData, body)
  let scheme = call_568227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568227.url(scheme.get, call_568227.host, call_568227.base,
                         call_568227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568227, url, valid)

proc call*(call_568228: Call_ApplicationGet_568204; apiVersion: string;
          applicationId: string; timeout: int = 30): Recallable =
  ## applicationGet
  ## This operation returns only applications and versions that are available for use on compute nodes; that is, that can be used in an application package reference. For administrator information about applications and versions that are not yet available to compute nodes, use the Azure portal or the Azure Resource Manager API.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   applicationId: string (required)
  ##                : The ID of the application.
  var path_568229 = newJObject()
  var query_568230 = newJObject()
  add(query_568230, "timeout", newJInt(timeout))
  add(query_568230, "api-version", newJString(apiVersion))
  add(path_568229, "applicationId", newJString(applicationId))
  result = call_568228.call(path_568229, query_568230, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_568204(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/applications/{applicationId}", validator: validate_ApplicationGet_568205,
    base: "", url: url_ApplicationGet_568206, schemes: {Scheme.Https})
type
  Call_CertificateAdd_568246 = ref object of OpenApiRestCall_567667
proc url_CertificateAdd_568248(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CertificateAdd_568247(path: JsonNode; query: JsonNode;
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
  var valid_568266 = query.getOrDefault("timeout")
  valid_568266 = validateParameter(valid_568266, JInt, required = false,
                                 default = newJInt(30))
  if valid_568266 != nil:
    section.add "timeout", valid_568266
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568267 = query.getOrDefault("api-version")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "api-version", valid_568267
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568268 = header.getOrDefault("client-request-id")
  valid_568268 = validateParameter(valid_568268, JString, required = false,
                                 default = nil)
  if valid_568268 != nil:
    section.add "client-request-id", valid_568268
  var valid_568269 = header.getOrDefault("ocp-date")
  valid_568269 = validateParameter(valid_568269, JString, required = false,
                                 default = nil)
  if valid_568269 != nil:
    section.add "ocp-date", valid_568269
  var valid_568270 = header.getOrDefault("return-client-request-id")
  valid_568270 = validateParameter(valid_568270, JBool, required = false,
                                 default = newJBool(false))
  if valid_568270 != nil:
    section.add "return-client-request-id", valid_568270
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   certificate: JObject (required)
  ##              : The certificate to be added.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568272: Call_CertificateAdd_568246; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568272.validator(path, query, header, formData, body)
  let scheme = call_568272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568272.url(scheme.get, call_568272.host, call_568272.base,
                         call_568272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568272, url, valid)

proc call*(call_568273: Call_CertificateAdd_568246; apiVersion: string;
          certificate: JsonNode; timeout: int = 30): Recallable =
  ## certificateAdd
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   certificate: JObject (required)
  ##              : The certificate to be added.
  var query_568274 = newJObject()
  var body_568275 = newJObject()
  add(query_568274, "timeout", newJInt(timeout))
  add(query_568274, "api-version", newJString(apiVersion))
  if certificate != nil:
    body_568275 = certificate
  result = call_568273.call(nil, query_568274, nil, nil, body_568275)

var certificateAdd* = Call_CertificateAdd_568246(name: "certificateAdd",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/certificates",
    validator: validate_CertificateAdd_568247, base: "", url: url_CertificateAdd_568248,
    schemes: {Scheme.Https})
type
  Call_CertificateList_568231 = ref object of OpenApiRestCall_567667
proc url_CertificateList_568233(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CertificateList_568232(path: JsonNode; query: JsonNode;
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
  ##             : The maximum number of items to return in the response. A maximum of 1000 certificates can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-certificates.
  section = newJObject()
  var valid_568235 = query.getOrDefault("timeout")
  valid_568235 = validateParameter(valid_568235, JInt, required = false,
                                 default = newJInt(30))
  if valid_568235 != nil:
    section.add "timeout", valid_568235
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  var valid_568237 = query.getOrDefault("maxresults")
  valid_568237 = validateParameter(valid_568237, JInt, required = false,
                                 default = newJInt(1000))
  if valid_568237 != nil:
    section.add "maxresults", valid_568237
  var valid_568238 = query.getOrDefault("$select")
  valid_568238 = validateParameter(valid_568238, JString, required = false,
                                 default = nil)
  if valid_568238 != nil:
    section.add "$select", valid_568238
  var valid_568239 = query.getOrDefault("$filter")
  valid_568239 = validateParameter(valid_568239, JString, required = false,
                                 default = nil)
  if valid_568239 != nil:
    section.add "$filter", valid_568239
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568240 = header.getOrDefault("client-request-id")
  valid_568240 = validateParameter(valid_568240, JString, required = false,
                                 default = nil)
  if valid_568240 != nil:
    section.add "client-request-id", valid_568240
  var valid_568241 = header.getOrDefault("ocp-date")
  valid_568241 = validateParameter(valid_568241, JString, required = false,
                                 default = nil)
  if valid_568241 != nil:
    section.add "ocp-date", valid_568241
  var valid_568242 = header.getOrDefault("return-client-request-id")
  valid_568242 = validateParameter(valid_568242, JBool, required = false,
                                 default = newJBool(false))
  if valid_568242 != nil:
    section.add "return-client-request-id", valid_568242
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_CertificateList_568231; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_CertificateList_568231; apiVersion: string;
          timeout: int = 30; maxresults: int = 1000; Select: string = "";
          Filter: string = ""): Recallable =
  ## certificateList
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 certificates can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-certificates.
  var query_568245 = newJObject()
  add(query_568245, "timeout", newJInt(timeout))
  add(query_568245, "api-version", newJString(apiVersion))
  add(query_568245, "maxresults", newJInt(maxresults))
  add(query_568245, "$select", newJString(Select))
  add(query_568245, "$filter", newJString(Filter))
  result = call_568244.call(nil, query_568245, nil, nil, nil)

var certificateList* = Call_CertificateList_568231(name: "certificateList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates",
    validator: validate_CertificateList_568232, base: "", url: url_CertificateList_568233,
    schemes: {Scheme.Https})
type
  Call_CertificateGet_568276 = ref object of OpenApiRestCall_567667
proc url_CertificateGet_568278(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateGet_568277(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the specified certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thumbprintAlgorithm: JString (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: JString (required)
  ##             : The thumbprint of the certificate to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `thumbprintAlgorithm` field"
  var valid_568279 = path.getOrDefault("thumbprintAlgorithm")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "thumbprintAlgorithm", valid_568279
  var valid_568280 = path.getOrDefault("thumbprint")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "thumbprint", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_568281 = query.getOrDefault("timeout")
  valid_568281 = validateParameter(valid_568281, JInt, required = false,
                                 default = newJInt(30))
  if valid_568281 != nil:
    section.add "timeout", valid_568281
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  var valid_568283 = query.getOrDefault("$select")
  valid_568283 = validateParameter(valid_568283, JString, required = false,
                                 default = nil)
  if valid_568283 != nil:
    section.add "$select", valid_568283
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568284 = header.getOrDefault("client-request-id")
  valid_568284 = validateParameter(valid_568284, JString, required = false,
                                 default = nil)
  if valid_568284 != nil:
    section.add "client-request-id", valid_568284
  var valid_568285 = header.getOrDefault("ocp-date")
  valid_568285 = validateParameter(valid_568285, JString, required = false,
                                 default = nil)
  if valid_568285 != nil:
    section.add "ocp-date", valid_568285
  var valid_568286 = header.getOrDefault("return-client-request-id")
  valid_568286 = validateParameter(valid_568286, JBool, required = false,
                                 default = newJBool(false))
  if valid_568286 != nil:
    section.add "return-client-request-id", valid_568286
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568287: Call_CertificateGet_568276; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified certificate.
  ## 
  let valid = call_568287.validator(path, query, header, formData, body)
  let scheme = call_568287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568287.url(scheme.get, call_568287.host, call_568287.base,
                         call_568287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568287, url, valid)

proc call*(call_568288: Call_CertificateGet_568276; apiVersion: string;
          thumbprintAlgorithm: string; thumbprint: string; timeout: int = 30;
          Select: string = ""): Recallable =
  ## certificateGet
  ## Gets information about the specified certificate.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   thumbprintAlgorithm: string (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   Select: string
  ##         : An OData $select clause.
  ##   thumbprint: string (required)
  ##             : The thumbprint of the certificate to get.
  var path_568289 = newJObject()
  var query_568290 = newJObject()
  add(query_568290, "timeout", newJInt(timeout))
  add(query_568290, "api-version", newJString(apiVersion))
  add(path_568289, "thumbprintAlgorithm", newJString(thumbprintAlgorithm))
  add(query_568290, "$select", newJString(Select))
  add(path_568289, "thumbprint", newJString(thumbprint))
  result = call_568288.call(path_568289, query_568290, nil, nil, nil)

var certificateGet* = Call_CertificateGet_568276(name: "certificateGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})",
    validator: validate_CertificateGet_568277, base: "", url: url_CertificateGet_568278,
    schemes: {Scheme.Https})
type
  Call_CertificateDelete_568291 = ref object of OpenApiRestCall_567667
proc url_CertificateDelete_568293(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateDelete_568292(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## You cannot delete a certificate if a resource (pool or compute node) is using it. Before you can delete a certificate, you must therefore make sure that the certificate is not associated with any existing pools, the certificate is not installed on any compute nodes (even if you remove a certificate from a pool, it is not removed from existing compute nodes in that pool until they restart), and no running tasks depend on the certificate. If you try to delete a certificate that is in use, the deletion fails. The certificate status changes to deleteFailed. You can use Cancel Delete Certificate to set the status back to active if you decide that you want to continue using the certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thumbprintAlgorithm: JString (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: JString (required)
  ##             : The thumbprint of the certificate to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `thumbprintAlgorithm` field"
  var valid_568294 = path.getOrDefault("thumbprintAlgorithm")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "thumbprintAlgorithm", valid_568294
  var valid_568295 = path.getOrDefault("thumbprint")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "thumbprint", valid_568295
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568296 = query.getOrDefault("timeout")
  valid_568296 = validateParameter(valid_568296, JInt, required = false,
                                 default = newJInt(30))
  if valid_568296 != nil:
    section.add "timeout", valid_568296
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568298 = header.getOrDefault("client-request-id")
  valid_568298 = validateParameter(valid_568298, JString, required = false,
                                 default = nil)
  if valid_568298 != nil:
    section.add "client-request-id", valid_568298
  var valid_568299 = header.getOrDefault("ocp-date")
  valid_568299 = validateParameter(valid_568299, JString, required = false,
                                 default = nil)
  if valid_568299 != nil:
    section.add "ocp-date", valid_568299
  var valid_568300 = header.getOrDefault("return-client-request-id")
  valid_568300 = validateParameter(valid_568300, JBool, required = false,
                                 default = newJBool(false))
  if valid_568300 != nil:
    section.add "return-client-request-id", valid_568300
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568301: Call_CertificateDelete_568291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You cannot delete a certificate if a resource (pool or compute node) is using it. Before you can delete a certificate, you must therefore make sure that the certificate is not associated with any existing pools, the certificate is not installed on any compute nodes (even if you remove a certificate from a pool, it is not removed from existing compute nodes in that pool until they restart), and no running tasks depend on the certificate. If you try to delete a certificate that is in use, the deletion fails. The certificate status changes to deleteFailed. You can use Cancel Delete Certificate to set the status back to active if you decide that you want to continue using the certificate.
  ## 
  let valid = call_568301.validator(path, query, header, formData, body)
  let scheme = call_568301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568301.url(scheme.get, call_568301.host, call_568301.base,
                         call_568301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568301, url, valid)

proc call*(call_568302: Call_CertificateDelete_568291; apiVersion: string;
          thumbprintAlgorithm: string; thumbprint: string; timeout: int = 30): Recallable =
  ## certificateDelete
  ## You cannot delete a certificate if a resource (pool or compute node) is using it. Before you can delete a certificate, you must therefore make sure that the certificate is not associated with any existing pools, the certificate is not installed on any compute nodes (even if you remove a certificate from a pool, it is not removed from existing compute nodes in that pool until they restart), and no running tasks depend on the certificate. If you try to delete a certificate that is in use, the deletion fails. The certificate status changes to deleteFailed. You can use Cancel Delete Certificate to set the status back to active if you decide that you want to continue using the certificate.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   thumbprintAlgorithm: string (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: string (required)
  ##             : The thumbprint of the certificate to be deleted.
  var path_568303 = newJObject()
  var query_568304 = newJObject()
  add(query_568304, "timeout", newJInt(timeout))
  add(query_568304, "api-version", newJString(apiVersion))
  add(path_568303, "thumbprintAlgorithm", newJString(thumbprintAlgorithm))
  add(path_568303, "thumbprint", newJString(thumbprint))
  result = call_568302.call(path_568303, query_568304, nil, nil, nil)

var certificateDelete* = Call_CertificateDelete_568291(name: "certificateDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})",
    validator: validate_CertificateDelete_568292, base: "",
    url: url_CertificateDelete_568293, schemes: {Scheme.Https})
type
  Call_CertificateCancelDeletion_568305 = ref object of OpenApiRestCall_567667
proc url_CertificateCancelDeletion_568307(protocol: Scheme; host: string;
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

proc validate_CertificateCancelDeletion_568306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## If you try to delete a certificate that is being used by a pool or compute node, the status of the certificate changes to deleteFailed. If you decide that you want to continue using the certificate, you can use this operation to set the status of the certificate back to active. If you intend to delete the certificate, you do not need to run this operation after the deletion failed. You must make sure that the certificate is not being used by any resources, and then you can try again to delete the certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   thumbprintAlgorithm: JString (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: JString (required)
  ##             : The thumbprint of the certificate being deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `thumbprintAlgorithm` field"
  var valid_568308 = path.getOrDefault("thumbprintAlgorithm")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "thumbprintAlgorithm", valid_568308
  var valid_568309 = path.getOrDefault("thumbprint")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "thumbprint", valid_568309
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568310 = query.getOrDefault("timeout")
  valid_568310 = validateParameter(valid_568310, JInt, required = false,
                                 default = newJInt(30))
  if valid_568310 != nil:
    section.add "timeout", valid_568310
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568311 = query.getOrDefault("api-version")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "api-version", valid_568311
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568312 = header.getOrDefault("client-request-id")
  valid_568312 = validateParameter(valid_568312, JString, required = false,
                                 default = nil)
  if valid_568312 != nil:
    section.add "client-request-id", valid_568312
  var valid_568313 = header.getOrDefault("ocp-date")
  valid_568313 = validateParameter(valid_568313, JString, required = false,
                                 default = nil)
  if valid_568313 != nil:
    section.add "ocp-date", valid_568313
  var valid_568314 = header.getOrDefault("return-client-request-id")
  valid_568314 = validateParameter(valid_568314, JBool, required = false,
                                 default = newJBool(false))
  if valid_568314 != nil:
    section.add "return-client-request-id", valid_568314
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568315: Call_CertificateCancelDeletion_568305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If you try to delete a certificate that is being used by a pool or compute node, the status of the certificate changes to deleteFailed. If you decide that you want to continue using the certificate, you can use this operation to set the status of the certificate back to active. If you intend to delete the certificate, you do not need to run this operation after the deletion failed. You must make sure that the certificate is not being used by any resources, and then you can try again to delete the certificate.
  ## 
  let valid = call_568315.validator(path, query, header, formData, body)
  let scheme = call_568315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568315.url(scheme.get, call_568315.host, call_568315.base,
                         call_568315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568315, url, valid)

proc call*(call_568316: Call_CertificateCancelDeletion_568305; apiVersion: string;
          thumbprintAlgorithm: string; thumbprint: string; timeout: int = 30): Recallable =
  ## certificateCancelDeletion
  ## If you try to delete a certificate that is being used by a pool or compute node, the status of the certificate changes to deleteFailed. If you decide that you want to continue using the certificate, you can use this operation to set the status of the certificate back to active. If you intend to delete the certificate, you do not need to run this operation after the deletion failed. You must make sure that the certificate is not being used by any resources, and then you can try again to delete the certificate.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   thumbprintAlgorithm: string (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: string (required)
  ##             : The thumbprint of the certificate being deleted.
  var path_568317 = newJObject()
  var query_568318 = newJObject()
  add(query_568318, "timeout", newJInt(timeout))
  add(query_568318, "api-version", newJString(apiVersion))
  add(path_568317, "thumbprintAlgorithm", newJString(thumbprintAlgorithm))
  add(path_568317, "thumbprint", newJString(thumbprint))
  result = call_568316.call(path_568317, query_568318, nil, nil, nil)

var certificateCancelDeletion* = Call_CertificateCancelDeletion_568305(
    name: "certificateCancelDeletion", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})/canceldelete",
    validator: validate_CertificateCancelDeletion_568306, base: "",
    url: url_CertificateCancelDeletion_568307, schemes: {Scheme.Https})
type
  Call_JobAdd_568334 = ref object of OpenApiRestCall_567667
proc url_JobAdd_568336(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobAdd_568335(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## The Batch service supports two ways to control the work done as part of a job. In the first approach, the user specifies a Job Manager task. The Batch service launches this task when it is ready to start the job. The Job Manager task controls all other tasks that run under this job, by using the Task APIs. In the second approach, the user directly controls the execution of tasks under an active job, by using the Task APIs. Also note: when naming jobs, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
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
  var valid_568337 = query.getOrDefault("timeout")
  valid_568337 = validateParameter(valid_568337, JInt, required = false,
                                 default = newJInt(30))
  if valid_568337 != nil:
    section.add "timeout", valid_568337
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568338 = query.getOrDefault("api-version")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "api-version", valid_568338
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568339 = header.getOrDefault("client-request-id")
  valid_568339 = validateParameter(valid_568339, JString, required = false,
                                 default = nil)
  if valid_568339 != nil:
    section.add "client-request-id", valid_568339
  var valid_568340 = header.getOrDefault("ocp-date")
  valid_568340 = validateParameter(valid_568340, JString, required = false,
                                 default = nil)
  if valid_568340 != nil:
    section.add "ocp-date", valid_568340
  var valid_568341 = header.getOrDefault("return-client-request-id")
  valid_568341 = validateParameter(valid_568341, JBool, required = false,
                                 default = newJBool(false))
  if valid_568341 != nil:
    section.add "return-client-request-id", valid_568341
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   job: JObject (required)
  ##      : The job to be added.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568343: Call_JobAdd_568334; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Batch service supports two ways to control the work done as part of a job. In the first approach, the user specifies a Job Manager task. The Batch service launches this task when it is ready to start the job. The Job Manager task controls all other tasks that run under this job, by using the Task APIs. In the second approach, the user directly controls the execution of tasks under an active job, by using the Task APIs. Also note: when naming jobs, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ## 
  let valid = call_568343.validator(path, query, header, formData, body)
  let scheme = call_568343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568343.url(scheme.get, call_568343.host, call_568343.base,
                         call_568343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568343, url, valid)

proc call*(call_568344: Call_JobAdd_568334; apiVersion: string; job: JsonNode;
          timeout: int = 30): Recallable =
  ## jobAdd
  ## The Batch service supports two ways to control the work done as part of a job. In the first approach, the user specifies a Job Manager task. The Batch service launches this task when it is ready to start the job. The Job Manager task controls all other tasks that run under this job, by using the Task APIs. In the second approach, the user directly controls the execution of tasks under an active job, by using the Task APIs. Also note: when naming jobs, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   job: JObject (required)
  ##      : The job to be added.
  var query_568345 = newJObject()
  var body_568346 = newJObject()
  add(query_568345, "timeout", newJInt(timeout))
  add(query_568345, "api-version", newJString(apiVersion))
  if job != nil:
    body_568346 = job
  result = call_568344.call(nil, query_568345, nil, nil, body_568346)

var jobAdd* = Call_JobAdd_568334(name: "jobAdd", meth: HttpMethod.HttpPost,
                              host: "azure.local", route: "/jobs",
                              validator: validate_JobAdd_568335, base: "",
                              url: url_JobAdd_568336, schemes: {Scheme.Https})
type
  Call_JobList_568319 = ref object of OpenApiRestCall_567667
proc url_JobList_568321(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobList_568320(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##             : The maximum number of items to return in the response. A maximum of 1000 jobs can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs.
  section = newJObject()
  var valid_568322 = query.getOrDefault("timeout")
  valid_568322 = validateParameter(valid_568322, JInt, required = false,
                                 default = newJInt(30))
  if valid_568322 != nil:
    section.add "timeout", valid_568322
  var valid_568323 = query.getOrDefault("$expand")
  valid_568323 = validateParameter(valid_568323, JString, required = false,
                                 default = nil)
  if valid_568323 != nil:
    section.add "$expand", valid_568323
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568324 = query.getOrDefault("api-version")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "api-version", valid_568324
  var valid_568325 = query.getOrDefault("maxresults")
  valid_568325 = validateParameter(valid_568325, JInt, required = false,
                                 default = newJInt(1000))
  if valid_568325 != nil:
    section.add "maxresults", valid_568325
  var valid_568326 = query.getOrDefault("$select")
  valid_568326 = validateParameter(valid_568326, JString, required = false,
                                 default = nil)
  if valid_568326 != nil:
    section.add "$select", valid_568326
  var valid_568327 = query.getOrDefault("$filter")
  valid_568327 = validateParameter(valid_568327, JString, required = false,
                                 default = nil)
  if valid_568327 != nil:
    section.add "$filter", valid_568327
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568328 = header.getOrDefault("client-request-id")
  valid_568328 = validateParameter(valid_568328, JString, required = false,
                                 default = nil)
  if valid_568328 != nil:
    section.add "client-request-id", valid_568328
  var valid_568329 = header.getOrDefault("ocp-date")
  valid_568329 = validateParameter(valid_568329, JString, required = false,
                                 default = nil)
  if valid_568329 != nil:
    section.add "ocp-date", valid_568329
  var valid_568330 = header.getOrDefault("return-client-request-id")
  valid_568330 = validateParameter(valid_568330, JBool, required = false,
                                 default = newJBool(false))
  if valid_568330 != nil:
    section.add "return-client-request-id", valid_568330
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_JobList_568319; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_JobList_568319; apiVersion: string; timeout: int = 30;
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
  ##             : The maximum number of items to return in the response. A maximum of 1000 jobs can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs.
  var query_568333 = newJObject()
  add(query_568333, "timeout", newJInt(timeout))
  add(query_568333, "$expand", newJString(Expand))
  add(query_568333, "api-version", newJString(apiVersion))
  add(query_568333, "maxresults", newJInt(maxresults))
  add(query_568333, "$select", newJString(Select))
  add(query_568333, "$filter", newJString(Filter))
  result = call_568332.call(nil, query_568333, nil, nil, nil)

var jobList* = Call_JobList_568319(name: "jobList", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/jobs",
                                validator: validate_JobList_568320, base: "",
                                url: url_JobList_568321, schemes: {Scheme.Https})
type
  Call_JobUpdate_568366 = ref object of OpenApiRestCall_567667
proc url_JobUpdate_568368(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobUpdate_568367(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## This fully replaces all the updatable properties of the job. For example, if the job has constraints associated with it and if constraints is not specified with this request, then the Batch service will remove the existing constraints.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job whose properties you want to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568369 = path.getOrDefault("jobId")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "jobId", valid_568369
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568370 = query.getOrDefault("timeout")
  valid_568370 = validateParameter(valid_568370, JInt, required = false,
                                 default = newJInt(30))
  if valid_568370 != nil:
    section.add "timeout", valid_568370
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568371 = query.getOrDefault("api-version")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "api-version", valid_568371
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
  var valid_568372 = header.getOrDefault("If-Match")
  valid_568372 = validateParameter(valid_568372, JString, required = false,
                                 default = nil)
  if valid_568372 != nil:
    section.add "If-Match", valid_568372
  var valid_568373 = header.getOrDefault("client-request-id")
  valid_568373 = validateParameter(valid_568373, JString, required = false,
                                 default = nil)
  if valid_568373 != nil:
    section.add "client-request-id", valid_568373
  var valid_568374 = header.getOrDefault("ocp-date")
  valid_568374 = validateParameter(valid_568374, JString, required = false,
                                 default = nil)
  if valid_568374 != nil:
    section.add "ocp-date", valid_568374
  var valid_568375 = header.getOrDefault("If-Unmodified-Since")
  valid_568375 = validateParameter(valid_568375, JString, required = false,
                                 default = nil)
  if valid_568375 != nil:
    section.add "If-Unmodified-Since", valid_568375
  var valid_568376 = header.getOrDefault("If-None-Match")
  valid_568376 = validateParameter(valid_568376, JString, required = false,
                                 default = nil)
  if valid_568376 != nil:
    section.add "If-None-Match", valid_568376
  var valid_568377 = header.getOrDefault("If-Modified-Since")
  valid_568377 = validateParameter(valid_568377, JString, required = false,
                                 default = nil)
  if valid_568377 != nil:
    section.add "If-Modified-Since", valid_568377
  var valid_568378 = header.getOrDefault("return-client-request-id")
  valid_568378 = validateParameter(valid_568378, JBool, required = false,
                                 default = newJBool(false))
  if valid_568378 != nil:
    section.add "return-client-request-id", valid_568378
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

proc call*(call_568380: Call_JobUpdate_568366; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This fully replaces all the updatable properties of the job. For example, if the job has constraints associated with it and if constraints is not specified with this request, then the Batch service will remove the existing constraints.
  ## 
  let valid = call_568380.validator(path, query, header, formData, body)
  let scheme = call_568380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568380.url(scheme.get, call_568380.host, call_568380.base,
                         call_568380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568380, url, valid)

proc call*(call_568381: Call_JobUpdate_568366; jobUpdateParameter: JsonNode;
          apiVersion: string; jobId: string; timeout: int = 30): Recallable =
  ## jobUpdate
  ## This fully replaces all the updatable properties of the job. For example, if the job has constraints associated with it and if constraints is not specified with this request, then the Batch service will remove the existing constraints.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobUpdateParameter: JObject (required)
  ##                     : The parameters for the request.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job whose properties you want to update.
  var path_568382 = newJObject()
  var query_568383 = newJObject()
  var body_568384 = newJObject()
  add(query_568383, "timeout", newJInt(timeout))
  if jobUpdateParameter != nil:
    body_568384 = jobUpdateParameter
  add(query_568383, "api-version", newJString(apiVersion))
  add(path_568382, "jobId", newJString(jobId))
  result = call_568381.call(path_568382, query_568383, nil, nil, body_568384)

var jobUpdate* = Call_JobUpdate_568366(name: "jobUpdate", meth: HttpMethod.HttpPut,
                                    host: "azure.local", route: "/jobs/{jobId}",
                                    validator: validate_JobUpdate_568367,
                                    base: "", url: url_JobUpdate_568368,
                                    schemes: {Scheme.Https})
type
  Call_JobGet_568347 = ref object of OpenApiRestCall_567667
proc url_JobGet_568349(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobGet_568348(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568350 = path.getOrDefault("jobId")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "jobId", valid_568350
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
  var valid_568351 = query.getOrDefault("timeout")
  valid_568351 = validateParameter(valid_568351, JInt, required = false,
                                 default = newJInt(30))
  if valid_568351 != nil:
    section.add "timeout", valid_568351
  var valid_568352 = query.getOrDefault("$expand")
  valid_568352 = validateParameter(valid_568352, JString, required = false,
                                 default = nil)
  if valid_568352 != nil:
    section.add "$expand", valid_568352
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568353 = query.getOrDefault("api-version")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "api-version", valid_568353
  var valid_568354 = query.getOrDefault("$select")
  valid_568354 = validateParameter(valid_568354, JString, required = false,
                                 default = nil)
  if valid_568354 != nil:
    section.add "$select", valid_568354
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
  var valid_568355 = header.getOrDefault("If-Match")
  valid_568355 = validateParameter(valid_568355, JString, required = false,
                                 default = nil)
  if valid_568355 != nil:
    section.add "If-Match", valid_568355
  var valid_568356 = header.getOrDefault("client-request-id")
  valid_568356 = validateParameter(valid_568356, JString, required = false,
                                 default = nil)
  if valid_568356 != nil:
    section.add "client-request-id", valid_568356
  var valid_568357 = header.getOrDefault("ocp-date")
  valid_568357 = validateParameter(valid_568357, JString, required = false,
                                 default = nil)
  if valid_568357 != nil:
    section.add "ocp-date", valid_568357
  var valid_568358 = header.getOrDefault("If-Unmodified-Since")
  valid_568358 = validateParameter(valid_568358, JString, required = false,
                                 default = nil)
  if valid_568358 != nil:
    section.add "If-Unmodified-Since", valid_568358
  var valid_568359 = header.getOrDefault("If-None-Match")
  valid_568359 = validateParameter(valid_568359, JString, required = false,
                                 default = nil)
  if valid_568359 != nil:
    section.add "If-None-Match", valid_568359
  var valid_568360 = header.getOrDefault("If-Modified-Since")
  valid_568360 = validateParameter(valid_568360, JString, required = false,
                                 default = nil)
  if valid_568360 != nil:
    section.add "If-Modified-Since", valid_568360
  var valid_568361 = header.getOrDefault("return-client-request-id")
  valid_568361 = validateParameter(valid_568361, JBool, required = false,
                                 default = newJBool(false))
  if valid_568361 != nil:
    section.add "return-client-request-id", valid_568361
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568362: Call_JobGet_568347; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_JobGet_568347; apiVersion: string; jobId: string;
          timeout: int = 30; Expand: string = ""; Select: string = ""): Recallable =
  ## jobGet
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job.
  ##   Select: string
  ##         : An OData $select clause.
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  add(query_568365, "timeout", newJInt(timeout))
  add(query_568365, "$expand", newJString(Expand))
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "jobId", newJString(jobId))
  add(query_568365, "$select", newJString(Select))
  result = call_568363.call(path_568364, query_568365, nil, nil, nil)

var jobGet* = Call_JobGet_568347(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "azure.local", route: "/jobs/{jobId}",
                              validator: validate_JobGet_568348, base: "",
                              url: url_JobGet_568349, schemes: {Scheme.Https})
type
  Call_JobPatch_568402 = ref object of OpenApiRestCall_567667
proc url_JobPatch_568404(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobPatch_568403(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## This replaces only the job properties specified in the request. For example, if the job has constraints, and a request does not specify the constraints element, then the job keeps the existing constraints.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job whose properties you want to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568405 = path.getOrDefault("jobId")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "jobId", valid_568405
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568406 = query.getOrDefault("timeout")
  valid_568406 = validateParameter(valid_568406, JInt, required = false,
                                 default = newJInt(30))
  if valid_568406 != nil:
    section.add "timeout", valid_568406
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568407 = query.getOrDefault("api-version")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "api-version", valid_568407
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
  var valid_568408 = header.getOrDefault("If-Match")
  valid_568408 = validateParameter(valid_568408, JString, required = false,
                                 default = nil)
  if valid_568408 != nil:
    section.add "If-Match", valid_568408
  var valid_568409 = header.getOrDefault("client-request-id")
  valid_568409 = validateParameter(valid_568409, JString, required = false,
                                 default = nil)
  if valid_568409 != nil:
    section.add "client-request-id", valid_568409
  var valid_568410 = header.getOrDefault("ocp-date")
  valid_568410 = validateParameter(valid_568410, JString, required = false,
                                 default = nil)
  if valid_568410 != nil:
    section.add "ocp-date", valid_568410
  var valid_568411 = header.getOrDefault("If-Unmodified-Since")
  valid_568411 = validateParameter(valid_568411, JString, required = false,
                                 default = nil)
  if valid_568411 != nil:
    section.add "If-Unmodified-Since", valid_568411
  var valid_568412 = header.getOrDefault("If-None-Match")
  valid_568412 = validateParameter(valid_568412, JString, required = false,
                                 default = nil)
  if valid_568412 != nil:
    section.add "If-None-Match", valid_568412
  var valid_568413 = header.getOrDefault("If-Modified-Since")
  valid_568413 = validateParameter(valid_568413, JString, required = false,
                                 default = nil)
  if valid_568413 != nil:
    section.add "If-Modified-Since", valid_568413
  var valid_568414 = header.getOrDefault("return-client-request-id")
  valid_568414 = validateParameter(valid_568414, JBool, required = false,
                                 default = newJBool(false))
  if valid_568414 != nil:
    section.add "return-client-request-id", valid_568414
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

proc call*(call_568416: Call_JobPatch_568402; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This replaces only the job properties specified in the request. For example, if the job has constraints, and a request does not specify the constraints element, then the job keeps the existing constraints.
  ## 
  let valid = call_568416.validator(path, query, header, formData, body)
  let scheme = call_568416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568416.url(scheme.get, call_568416.host, call_568416.base,
                         call_568416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568416, url, valid)

proc call*(call_568417: Call_JobPatch_568402; apiVersion: string; jobId: string;
          jobPatchParameter: JsonNode; timeout: int = 30): Recallable =
  ## jobPatch
  ## This replaces only the job properties specified in the request. For example, if the job has constraints, and a request does not specify the constraints element, then the job keeps the existing constraints.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job whose properties you want to update.
  ##   jobPatchParameter: JObject (required)
  ##                    : The parameters for the request.
  var path_568418 = newJObject()
  var query_568419 = newJObject()
  var body_568420 = newJObject()
  add(query_568419, "timeout", newJInt(timeout))
  add(query_568419, "api-version", newJString(apiVersion))
  add(path_568418, "jobId", newJString(jobId))
  if jobPatchParameter != nil:
    body_568420 = jobPatchParameter
  result = call_568417.call(path_568418, query_568419, nil, nil, body_568420)

var jobPatch* = Call_JobPatch_568402(name: "jobPatch", meth: HttpMethod.HttpPatch,
                                  host: "azure.local", route: "/jobs/{jobId}",
                                  validator: validate_JobPatch_568403, base: "",
                                  url: url_JobPatch_568404,
                                  schemes: {Scheme.Https})
type
  Call_JobDelete_568385 = ref object of OpenApiRestCall_567667
proc url_JobDelete_568387(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobDelete_568386(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Deleting a job also deletes all tasks that are part of that job, and all job statistics. This also overrides the retention period for task data; that is, if the job contains tasks which are still retained on compute nodes, the Batch services deletes those tasks' working directories and all their contents.  When a Delete Job request is received, the Batch service sets the job to the deleting state. All update operations on a job that is in deleting state will fail with status code 409 (Conflict), with additional information indicating that the job is being deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568388 = path.getOrDefault("jobId")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "jobId", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568389 = query.getOrDefault("timeout")
  valid_568389 = validateParameter(valid_568389, JInt, required = false,
                                 default = newJInt(30))
  if valid_568389 != nil:
    section.add "timeout", valid_568389
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568390 = query.getOrDefault("api-version")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "api-version", valid_568390
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
  var valid_568391 = header.getOrDefault("If-Match")
  valid_568391 = validateParameter(valid_568391, JString, required = false,
                                 default = nil)
  if valid_568391 != nil:
    section.add "If-Match", valid_568391
  var valid_568392 = header.getOrDefault("client-request-id")
  valid_568392 = validateParameter(valid_568392, JString, required = false,
                                 default = nil)
  if valid_568392 != nil:
    section.add "client-request-id", valid_568392
  var valid_568393 = header.getOrDefault("ocp-date")
  valid_568393 = validateParameter(valid_568393, JString, required = false,
                                 default = nil)
  if valid_568393 != nil:
    section.add "ocp-date", valid_568393
  var valid_568394 = header.getOrDefault("If-Unmodified-Since")
  valid_568394 = validateParameter(valid_568394, JString, required = false,
                                 default = nil)
  if valid_568394 != nil:
    section.add "If-Unmodified-Since", valid_568394
  var valid_568395 = header.getOrDefault("If-None-Match")
  valid_568395 = validateParameter(valid_568395, JString, required = false,
                                 default = nil)
  if valid_568395 != nil:
    section.add "If-None-Match", valid_568395
  var valid_568396 = header.getOrDefault("If-Modified-Since")
  valid_568396 = validateParameter(valid_568396, JString, required = false,
                                 default = nil)
  if valid_568396 != nil:
    section.add "If-Modified-Since", valid_568396
  var valid_568397 = header.getOrDefault("return-client-request-id")
  valid_568397 = validateParameter(valid_568397, JBool, required = false,
                                 default = newJBool(false))
  if valid_568397 != nil:
    section.add "return-client-request-id", valid_568397
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568398: Call_JobDelete_568385; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deleting a job also deletes all tasks that are part of that job, and all job statistics. This also overrides the retention period for task data; that is, if the job contains tasks which are still retained on compute nodes, the Batch services deletes those tasks' working directories and all their contents.  When a Delete Job request is received, the Batch service sets the job to the deleting state. All update operations on a job that is in deleting state will fail with status code 409 (Conflict), with additional information indicating that the job is being deleted.
  ## 
  let valid = call_568398.validator(path, query, header, formData, body)
  let scheme = call_568398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568398.url(scheme.get, call_568398.host, call_568398.base,
                         call_568398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568398, url, valid)

proc call*(call_568399: Call_JobDelete_568385; apiVersion: string; jobId: string;
          timeout: int = 30): Recallable =
  ## jobDelete
  ## Deleting a job also deletes all tasks that are part of that job, and all job statistics. This also overrides the retention period for task data; that is, if the job contains tasks which are still retained on compute nodes, the Batch services deletes those tasks' working directories and all their contents.  When a Delete Job request is received, the Batch service sets the job to the deleting state. All update operations on a job that is in deleting state will fail with status code 409 (Conflict), with additional information indicating that the job is being deleted.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job to delete.
  var path_568400 = newJObject()
  var query_568401 = newJObject()
  add(query_568401, "timeout", newJInt(timeout))
  add(query_568401, "api-version", newJString(apiVersion))
  add(path_568400, "jobId", newJString(jobId))
  result = call_568399.call(path_568400, query_568401, nil, nil, nil)

var jobDelete* = Call_JobDelete_568385(name: "jobDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local", route: "/jobs/{jobId}",
                                    validator: validate_JobDelete_568386,
                                    base: "", url: url_JobDelete_568387,
                                    schemes: {Scheme.Https})
type
  Call_TaskAddCollection_568421 = ref object of OpenApiRestCall_567667
proc url_TaskAddCollection_568423(protocol: Scheme; host: string; base: string;
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

proc validate_TaskAddCollection_568422(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Note that each task must have a unique ID. The Batch service may not return the results for each task in the same order the tasks were submitted in this request. If the server times out or the connection is closed during the request, the request may have been partially or fully processed, or not at all. In such cases, the user should re-issue the request. Note that it is up to the user to correctly handle failures when re-issuing a request. For example, you should use the same task IDs during a retry so that if the prior operation succeeded, the retry will not create extra tasks unexpectedly. If the response contains any tasks which failed to add, a client can retry the request. In a retry, it is most efficient to resubmit only tasks that failed to add, and to omit tasks that were successfully added on the first attempt. The maximum lifetime of a task from addition to completion is 180 days. If a task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job to which the task collection is to be added.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568434 = path.getOrDefault("jobId")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "jobId", valid_568434
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568435 = query.getOrDefault("timeout")
  valid_568435 = validateParameter(valid_568435, JInt, required = false,
                                 default = newJInt(30))
  if valid_568435 != nil:
    section.add "timeout", valid_568435
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568436 = query.getOrDefault("api-version")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "api-version", valid_568436
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568437 = header.getOrDefault("client-request-id")
  valid_568437 = validateParameter(valid_568437, JString, required = false,
                                 default = nil)
  if valid_568437 != nil:
    section.add "client-request-id", valid_568437
  var valid_568438 = header.getOrDefault("ocp-date")
  valid_568438 = validateParameter(valid_568438, JString, required = false,
                                 default = nil)
  if valid_568438 != nil:
    section.add "ocp-date", valid_568438
  var valid_568439 = header.getOrDefault("return-client-request-id")
  valid_568439 = validateParameter(valid_568439, JBool, required = false,
                                 default = newJBool(false))
  if valid_568439 != nil:
    section.add "return-client-request-id", valid_568439
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   taskCollection: JObject (required)
  ##                 : The tasks to be added.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568441: Call_TaskAddCollection_568421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Note that each task must have a unique ID. The Batch service may not return the results for each task in the same order the tasks were submitted in this request. If the server times out or the connection is closed during the request, the request may have been partially or fully processed, or not at all. In such cases, the user should re-issue the request. Note that it is up to the user to correctly handle failures when re-issuing a request. For example, you should use the same task IDs during a retry so that if the prior operation succeeded, the retry will not create extra tasks unexpectedly. If the response contains any tasks which failed to add, a client can retry the request. In a retry, it is most efficient to resubmit only tasks that failed to add, and to omit tasks that were successfully added on the first attempt. The maximum lifetime of a task from addition to completion is 180 days. If a task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ## 
  let valid = call_568441.validator(path, query, header, formData, body)
  let scheme = call_568441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568441.url(scheme.get, call_568441.host, call_568441.base,
                         call_568441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568441, url, valid)

proc call*(call_568442: Call_TaskAddCollection_568421; apiVersion: string;
          jobId: string; taskCollection: JsonNode; timeout: int = 30): Recallable =
  ## taskAddCollection
  ## Note that each task must have a unique ID. The Batch service may not return the results for each task in the same order the tasks were submitted in this request. If the server times out or the connection is closed during the request, the request may have been partially or fully processed, or not at all. In such cases, the user should re-issue the request. Note that it is up to the user to correctly handle failures when re-issuing a request. For example, you should use the same task IDs during a retry so that if the prior operation succeeded, the retry will not create extra tasks unexpectedly. If the response contains any tasks which failed to add, a client can retry the request. In a retry, it is most efficient to resubmit only tasks that failed to add, and to omit tasks that were successfully added on the first attempt. The maximum lifetime of a task from addition to completion is 180 days. If a task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job to which the task collection is to be added.
  ##   taskCollection: JObject (required)
  ##                 : The tasks to be added.
  var path_568443 = newJObject()
  var query_568444 = newJObject()
  var body_568445 = newJObject()
  add(query_568444, "timeout", newJInt(timeout))
  add(query_568444, "api-version", newJString(apiVersion))
  add(path_568443, "jobId", newJString(jobId))
  if taskCollection != nil:
    body_568445 = taskCollection
  result = call_568442.call(path_568443, query_568444, nil, nil, body_568445)

var taskAddCollection* = Call_TaskAddCollection_568421(name: "taskAddCollection",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/addtaskcollection",
    validator: validate_TaskAddCollection_568422, base: "",
    url: url_TaskAddCollection_568423, schemes: {Scheme.Https})
type
  Call_JobDisable_568446 = ref object of OpenApiRestCall_567667
proc url_JobDisable_568448(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobDisable_568447(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The Batch Service immediately moves the job to the disabling state. Batch then uses the disableTasks parameter to determine what to do with the currently running tasks of the job. The job remains in the disabling state until the disable operation is completed and all tasks have been dealt with according to the disableTasks option; the job then moves to the disabled state. No new tasks are started under the job until it moves back to active state. If you try to disable a job that is in any state other than active, disabling, or disabled, the request fails with status code 409.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job to disable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568449 = path.getOrDefault("jobId")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "jobId", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568450 = query.getOrDefault("timeout")
  valid_568450 = validateParameter(valid_568450, JInt, required = false,
                                 default = newJInt(30))
  if valid_568450 != nil:
    section.add "timeout", valid_568450
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568451 = query.getOrDefault("api-version")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "api-version", valid_568451
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
  var valid_568452 = header.getOrDefault("If-Match")
  valid_568452 = validateParameter(valid_568452, JString, required = false,
                                 default = nil)
  if valid_568452 != nil:
    section.add "If-Match", valid_568452
  var valid_568453 = header.getOrDefault("client-request-id")
  valid_568453 = validateParameter(valid_568453, JString, required = false,
                                 default = nil)
  if valid_568453 != nil:
    section.add "client-request-id", valid_568453
  var valid_568454 = header.getOrDefault("ocp-date")
  valid_568454 = validateParameter(valid_568454, JString, required = false,
                                 default = nil)
  if valid_568454 != nil:
    section.add "ocp-date", valid_568454
  var valid_568455 = header.getOrDefault("If-Unmodified-Since")
  valid_568455 = validateParameter(valid_568455, JString, required = false,
                                 default = nil)
  if valid_568455 != nil:
    section.add "If-Unmodified-Since", valid_568455
  var valid_568456 = header.getOrDefault("If-None-Match")
  valid_568456 = validateParameter(valid_568456, JString, required = false,
                                 default = nil)
  if valid_568456 != nil:
    section.add "If-None-Match", valid_568456
  var valid_568457 = header.getOrDefault("If-Modified-Since")
  valid_568457 = validateParameter(valid_568457, JString, required = false,
                                 default = nil)
  if valid_568457 != nil:
    section.add "If-Modified-Since", valid_568457
  var valid_568458 = header.getOrDefault("return-client-request-id")
  valid_568458 = validateParameter(valid_568458, JBool, required = false,
                                 default = newJBool(false))
  if valid_568458 != nil:
    section.add "return-client-request-id", valid_568458
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

proc call*(call_568460: Call_JobDisable_568446; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Batch Service immediately moves the job to the disabling state. Batch then uses the disableTasks parameter to determine what to do with the currently running tasks of the job. The job remains in the disabling state until the disable operation is completed and all tasks have been dealt with according to the disableTasks option; the job then moves to the disabled state. No new tasks are started under the job until it moves back to active state. If you try to disable a job that is in any state other than active, disabling, or disabled, the request fails with status code 409.
  ## 
  let valid = call_568460.validator(path, query, header, formData, body)
  let scheme = call_568460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568460.url(scheme.get, call_568460.host, call_568460.base,
                         call_568460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568460, url, valid)

proc call*(call_568461: Call_JobDisable_568446; apiVersion: string; jobId: string;
          jobDisableParameter: JsonNode; timeout: int = 30): Recallable =
  ## jobDisable
  ## The Batch Service immediately moves the job to the disabling state. Batch then uses the disableTasks parameter to determine what to do with the currently running tasks of the job. The job remains in the disabling state until the disable operation is completed and all tasks have been dealt with according to the disableTasks option; the job then moves to the disabled state. No new tasks are started under the job until it moves back to active state. If you try to disable a job that is in any state other than active, disabling, or disabled, the request fails with status code 409.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job to disable.
  ##   jobDisableParameter: JObject (required)
  ##                      : The parameters for the request.
  var path_568462 = newJObject()
  var query_568463 = newJObject()
  var body_568464 = newJObject()
  add(query_568463, "timeout", newJInt(timeout))
  add(query_568463, "api-version", newJString(apiVersion))
  add(path_568462, "jobId", newJString(jobId))
  if jobDisableParameter != nil:
    body_568464 = jobDisableParameter
  result = call_568461.call(path_568462, query_568463, nil, nil, body_568464)

var jobDisable* = Call_JobDisable_568446(name: "jobDisable",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local",
                                      route: "/jobs/{jobId}/disable",
                                      validator: validate_JobDisable_568447,
                                      base: "", url: url_JobDisable_568448,
                                      schemes: {Scheme.Https})
type
  Call_JobEnable_568465 = ref object of OpenApiRestCall_567667
proc url_JobEnable_568467(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobEnable_568466(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## When you call this API, the Batch service sets a disabled job to the enabling state. After the this operation is completed, the job moves to the active state, and scheduling of new tasks under the job resumes. The Batch service does not allow a task to remain in the active state for more than 180 days. Therefore, if you enable a job containing active tasks which were added more than 180 days ago, those tasks will not run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job to enable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568468 = path.getOrDefault("jobId")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "jobId", valid_568468
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568469 = query.getOrDefault("timeout")
  valid_568469 = validateParameter(valid_568469, JInt, required = false,
                                 default = newJInt(30))
  if valid_568469 != nil:
    section.add "timeout", valid_568469
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568470 = query.getOrDefault("api-version")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "api-version", valid_568470
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
  var valid_568471 = header.getOrDefault("If-Match")
  valid_568471 = validateParameter(valid_568471, JString, required = false,
                                 default = nil)
  if valid_568471 != nil:
    section.add "If-Match", valid_568471
  var valid_568472 = header.getOrDefault("client-request-id")
  valid_568472 = validateParameter(valid_568472, JString, required = false,
                                 default = nil)
  if valid_568472 != nil:
    section.add "client-request-id", valid_568472
  var valid_568473 = header.getOrDefault("ocp-date")
  valid_568473 = validateParameter(valid_568473, JString, required = false,
                                 default = nil)
  if valid_568473 != nil:
    section.add "ocp-date", valid_568473
  var valid_568474 = header.getOrDefault("If-Unmodified-Since")
  valid_568474 = validateParameter(valid_568474, JString, required = false,
                                 default = nil)
  if valid_568474 != nil:
    section.add "If-Unmodified-Since", valid_568474
  var valid_568475 = header.getOrDefault("If-None-Match")
  valid_568475 = validateParameter(valid_568475, JString, required = false,
                                 default = nil)
  if valid_568475 != nil:
    section.add "If-None-Match", valid_568475
  var valid_568476 = header.getOrDefault("If-Modified-Since")
  valid_568476 = validateParameter(valid_568476, JString, required = false,
                                 default = nil)
  if valid_568476 != nil:
    section.add "If-Modified-Since", valid_568476
  var valid_568477 = header.getOrDefault("return-client-request-id")
  valid_568477 = validateParameter(valid_568477, JBool, required = false,
                                 default = newJBool(false))
  if valid_568477 != nil:
    section.add "return-client-request-id", valid_568477
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568478: Call_JobEnable_568465; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you call this API, the Batch service sets a disabled job to the enabling state. After the this operation is completed, the job moves to the active state, and scheduling of new tasks under the job resumes. The Batch service does not allow a task to remain in the active state for more than 180 days. Therefore, if you enable a job containing active tasks which were added more than 180 days ago, those tasks will not run.
  ## 
  let valid = call_568478.validator(path, query, header, formData, body)
  let scheme = call_568478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568478.url(scheme.get, call_568478.host, call_568478.base,
                         call_568478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568478, url, valid)

proc call*(call_568479: Call_JobEnable_568465; apiVersion: string; jobId: string;
          timeout: int = 30): Recallable =
  ## jobEnable
  ## When you call this API, the Batch service sets a disabled job to the enabling state. After the this operation is completed, the job moves to the active state, and scheduling of new tasks under the job resumes. The Batch service does not allow a task to remain in the active state for more than 180 days. Therefore, if you enable a job containing active tasks which were added more than 180 days ago, those tasks will not run.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job to enable.
  var path_568480 = newJObject()
  var query_568481 = newJObject()
  add(query_568481, "timeout", newJInt(timeout))
  add(query_568481, "api-version", newJString(apiVersion))
  add(path_568480, "jobId", newJString(jobId))
  result = call_568479.call(path_568480, query_568481, nil, nil, nil)

var jobEnable* = Call_JobEnable_568465(name: "jobEnable", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/jobs/{jobId}/enable",
                                    validator: validate_JobEnable_568466,
                                    base: "", url: url_JobEnable_568467,
                                    schemes: {Scheme.Https})
type
  Call_JobListPreparationAndReleaseTaskStatus_568482 = ref object of OpenApiRestCall_567667
proc url_JobListPreparationAndReleaseTaskStatus_568484(protocol: Scheme;
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

proc validate_JobListPreparationAndReleaseTaskStatus_568483(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This API returns the Job Preparation and Job Release task status on all compute nodes that have run the Job Preparation or Job Release task. This includes nodes which have since been removed from the pool. If this API is invoked on a job which has no Job Preparation or Job Release task, the Batch service returns HTTP status code 409 (Conflict) with an error code of JobPreparationTaskNotSpecified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568485 = path.getOrDefault("jobId")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "jobId", valid_568485
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 tasks can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-preparation-and-release-status.
  section = newJObject()
  var valid_568486 = query.getOrDefault("timeout")
  valid_568486 = validateParameter(valid_568486, JInt, required = false,
                                 default = newJInt(30))
  if valid_568486 != nil:
    section.add "timeout", valid_568486
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568487 = query.getOrDefault("api-version")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "api-version", valid_568487
  var valid_568488 = query.getOrDefault("maxresults")
  valid_568488 = validateParameter(valid_568488, JInt, required = false,
                                 default = newJInt(1000))
  if valid_568488 != nil:
    section.add "maxresults", valid_568488
  var valid_568489 = query.getOrDefault("$select")
  valid_568489 = validateParameter(valid_568489, JString, required = false,
                                 default = nil)
  if valid_568489 != nil:
    section.add "$select", valid_568489
  var valid_568490 = query.getOrDefault("$filter")
  valid_568490 = validateParameter(valid_568490, JString, required = false,
                                 default = nil)
  if valid_568490 != nil:
    section.add "$filter", valid_568490
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568491 = header.getOrDefault("client-request-id")
  valid_568491 = validateParameter(valid_568491, JString, required = false,
                                 default = nil)
  if valid_568491 != nil:
    section.add "client-request-id", valid_568491
  var valid_568492 = header.getOrDefault("ocp-date")
  valid_568492 = validateParameter(valid_568492, JString, required = false,
                                 default = nil)
  if valid_568492 != nil:
    section.add "ocp-date", valid_568492
  var valid_568493 = header.getOrDefault("return-client-request-id")
  valid_568493 = validateParameter(valid_568493, JBool, required = false,
                                 default = newJBool(false))
  if valid_568493 != nil:
    section.add "return-client-request-id", valid_568493
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568494: Call_JobListPreparationAndReleaseTaskStatus_568482;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This API returns the Job Preparation and Job Release task status on all compute nodes that have run the Job Preparation or Job Release task. This includes nodes which have since been removed from the pool. If this API is invoked on a job which has no Job Preparation or Job Release task, the Batch service returns HTTP status code 409 (Conflict) with an error code of JobPreparationTaskNotSpecified.
  ## 
  let valid = call_568494.validator(path, query, header, formData, body)
  let scheme = call_568494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568494.url(scheme.get, call_568494.host, call_568494.base,
                         call_568494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568494, url, valid)

proc call*(call_568495: Call_JobListPreparationAndReleaseTaskStatus_568482;
          apiVersion: string; jobId: string; timeout: int = 30; maxresults: int = 1000;
          Select: string = ""; Filter: string = ""): Recallable =
  ## jobListPreparationAndReleaseTaskStatus
  ## This API returns the Job Preparation and Job Release task status on all compute nodes that have run the Job Preparation or Job Release task. This includes nodes which have since been removed from the pool. If this API is invoked on a job which has no Job Preparation or Job Release task, the Batch service returns HTTP status code 409 (Conflict) with an error code of JobPreparationTaskNotSpecified.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 tasks can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-preparation-and-release-status.
  var path_568496 = newJObject()
  var query_568497 = newJObject()
  add(query_568497, "timeout", newJInt(timeout))
  add(query_568497, "api-version", newJString(apiVersion))
  add(path_568496, "jobId", newJString(jobId))
  add(query_568497, "maxresults", newJInt(maxresults))
  add(query_568497, "$select", newJString(Select))
  add(query_568497, "$filter", newJString(Filter))
  result = call_568495.call(path_568496, query_568497, nil, nil, nil)

var jobListPreparationAndReleaseTaskStatus* = Call_JobListPreparationAndReleaseTaskStatus_568482(
    name: "jobListPreparationAndReleaseTaskStatus", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/jobs/{jobId}/jobpreparationandreleasetaskstatus",
    validator: validate_JobListPreparationAndReleaseTaskStatus_568483, base: "",
    url: url_JobListPreparationAndReleaseTaskStatus_568484,
    schemes: {Scheme.Https})
type
  Call_JobGetTaskCounts_568498 = ref object of OpenApiRestCall_567667
proc url_JobGetTaskCounts_568500(protocol: Scheme; host: string; base: string;
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

proc validate_JobGetTaskCounts_568499(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Task counts provide a count of the tasks by active, running or completed task state, and a count of tasks which succeeded or failed. Tasks in the preparing state are counted as running.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568501 = path.getOrDefault("jobId")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "jobId", valid_568501
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568502 = query.getOrDefault("timeout")
  valid_568502 = validateParameter(valid_568502, JInt, required = false,
                                 default = newJInt(30))
  if valid_568502 != nil:
    section.add "timeout", valid_568502
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568503 = query.getOrDefault("api-version")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "api-version", valid_568503
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568504 = header.getOrDefault("client-request-id")
  valid_568504 = validateParameter(valid_568504, JString, required = false,
                                 default = nil)
  if valid_568504 != nil:
    section.add "client-request-id", valid_568504
  var valid_568505 = header.getOrDefault("ocp-date")
  valid_568505 = validateParameter(valid_568505, JString, required = false,
                                 default = nil)
  if valid_568505 != nil:
    section.add "ocp-date", valid_568505
  var valid_568506 = header.getOrDefault("return-client-request-id")
  valid_568506 = validateParameter(valid_568506, JBool, required = false,
                                 default = newJBool(false))
  if valid_568506 != nil:
    section.add "return-client-request-id", valid_568506
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568507: Call_JobGetTaskCounts_568498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Task counts provide a count of the tasks by active, running or completed task state, and a count of tasks which succeeded or failed. Tasks in the preparing state are counted as running.
  ## 
  let valid = call_568507.validator(path, query, header, formData, body)
  let scheme = call_568507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568507.url(scheme.get, call_568507.host, call_568507.base,
                         call_568507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568507, url, valid)

proc call*(call_568508: Call_JobGetTaskCounts_568498; apiVersion: string;
          jobId: string; timeout: int = 30): Recallable =
  ## jobGetTaskCounts
  ## Task counts provide a count of the tasks by active, running or completed task state, and a count of tasks which succeeded or failed. Tasks in the preparing state are counted as running.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job.
  var path_568509 = newJObject()
  var query_568510 = newJObject()
  add(query_568510, "timeout", newJInt(timeout))
  add(query_568510, "api-version", newJString(apiVersion))
  add(path_568509, "jobId", newJString(jobId))
  result = call_568508.call(path_568509, query_568510, nil, nil, nil)

var jobGetTaskCounts* = Call_JobGetTaskCounts_568498(name: "jobGetTaskCounts",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/taskcounts", validator: validate_JobGetTaskCounts_568499,
    base: "", url: url_JobGetTaskCounts_568500, schemes: {Scheme.Https})
type
  Call_TaskAdd_568528 = ref object of OpenApiRestCall_567667
proc url_TaskAdd_568530(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskAdd_568529(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## The maximum lifetime of a task from addition to completion is 180 days. If a task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job to which the task is to be added.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568531 = path.getOrDefault("jobId")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "jobId", valid_568531
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568532 = query.getOrDefault("timeout")
  valid_568532 = validateParameter(valid_568532, JInt, required = false,
                                 default = newJInt(30))
  if valid_568532 != nil:
    section.add "timeout", valid_568532
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568533 = query.getOrDefault("api-version")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "api-version", valid_568533
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568534 = header.getOrDefault("client-request-id")
  valid_568534 = validateParameter(valid_568534, JString, required = false,
                                 default = nil)
  if valid_568534 != nil:
    section.add "client-request-id", valid_568534
  var valid_568535 = header.getOrDefault("ocp-date")
  valid_568535 = validateParameter(valid_568535, JString, required = false,
                                 default = nil)
  if valid_568535 != nil:
    section.add "ocp-date", valid_568535
  var valid_568536 = header.getOrDefault("return-client-request-id")
  valid_568536 = validateParameter(valid_568536, JBool, required = false,
                                 default = newJBool(false))
  if valid_568536 != nil:
    section.add "return-client-request-id", valid_568536
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   task: JObject (required)
  ##       : The task to be added.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568538: Call_TaskAdd_568528; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The maximum lifetime of a task from addition to completion is 180 days. If a task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ## 
  let valid = call_568538.validator(path, query, header, formData, body)
  let scheme = call_568538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568538.url(scheme.get, call_568538.host, call_568538.base,
                         call_568538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568538, url, valid)

proc call*(call_568539: Call_TaskAdd_568528; apiVersion: string; jobId: string;
          task: JsonNode; timeout: int = 30): Recallable =
  ## taskAdd
  ## The maximum lifetime of a task from addition to completion is 180 days. If a task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job to which the task is to be added.
  ##   task: JObject (required)
  ##       : The task to be added.
  var path_568540 = newJObject()
  var query_568541 = newJObject()
  var body_568542 = newJObject()
  add(query_568541, "timeout", newJInt(timeout))
  add(query_568541, "api-version", newJString(apiVersion))
  add(path_568540, "jobId", newJString(jobId))
  if task != nil:
    body_568542 = task
  result = call_568539.call(path_568540, query_568541, nil, nil, body_568542)

var taskAdd* = Call_TaskAdd_568528(name: "taskAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/jobs/{jobId}/tasks",
                                validator: validate_TaskAdd_568529, base: "",
                                url: url_TaskAdd_568530, schemes: {Scheme.Https})
type
  Call_TaskList_568511 = ref object of OpenApiRestCall_567667
proc url_TaskList_568513(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskList_568512(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## For multi-instance tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary task. Use the list subtasks API to retrieve information about subtasks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568514 = path.getOrDefault("jobId")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "jobId", valid_568514
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 tasks can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-tasks.
  section = newJObject()
  var valid_568515 = query.getOrDefault("timeout")
  valid_568515 = validateParameter(valid_568515, JInt, required = false,
                                 default = newJInt(30))
  if valid_568515 != nil:
    section.add "timeout", valid_568515
  var valid_568516 = query.getOrDefault("$expand")
  valid_568516 = validateParameter(valid_568516, JString, required = false,
                                 default = nil)
  if valid_568516 != nil:
    section.add "$expand", valid_568516
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568517 = query.getOrDefault("api-version")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "api-version", valid_568517
  var valid_568518 = query.getOrDefault("maxresults")
  valid_568518 = validateParameter(valid_568518, JInt, required = false,
                                 default = newJInt(1000))
  if valid_568518 != nil:
    section.add "maxresults", valid_568518
  var valid_568519 = query.getOrDefault("$select")
  valid_568519 = validateParameter(valid_568519, JString, required = false,
                                 default = nil)
  if valid_568519 != nil:
    section.add "$select", valid_568519
  var valid_568520 = query.getOrDefault("$filter")
  valid_568520 = validateParameter(valid_568520, JString, required = false,
                                 default = nil)
  if valid_568520 != nil:
    section.add "$filter", valid_568520
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568521 = header.getOrDefault("client-request-id")
  valid_568521 = validateParameter(valid_568521, JString, required = false,
                                 default = nil)
  if valid_568521 != nil:
    section.add "client-request-id", valid_568521
  var valid_568522 = header.getOrDefault("ocp-date")
  valid_568522 = validateParameter(valid_568522, JString, required = false,
                                 default = nil)
  if valid_568522 != nil:
    section.add "ocp-date", valid_568522
  var valid_568523 = header.getOrDefault("return-client-request-id")
  valid_568523 = validateParameter(valid_568523, JBool, required = false,
                                 default = newJBool(false))
  if valid_568523 != nil:
    section.add "return-client-request-id", valid_568523
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568524: Call_TaskList_568511; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## For multi-instance tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary task. Use the list subtasks API to retrieve information about subtasks.
  ## 
  let valid = call_568524.validator(path, query, header, formData, body)
  let scheme = call_568524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568524.url(scheme.get, call_568524.host, call_568524.base,
                         call_568524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568524, url, valid)

proc call*(call_568525: Call_TaskList_568511; apiVersion: string; jobId: string;
          timeout: int = 30; Expand: string = ""; maxresults: int = 1000;
          Select: string = ""; Filter: string = ""): Recallable =
  ## taskList
  ## For multi-instance tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary task. Use the list subtasks API to retrieve information about subtasks.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 tasks can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-tasks.
  var path_568526 = newJObject()
  var query_568527 = newJObject()
  add(query_568527, "timeout", newJInt(timeout))
  add(query_568527, "$expand", newJString(Expand))
  add(query_568527, "api-version", newJString(apiVersion))
  add(path_568526, "jobId", newJString(jobId))
  add(query_568527, "maxresults", newJInt(maxresults))
  add(query_568527, "$select", newJString(Select))
  add(query_568527, "$filter", newJString(Filter))
  result = call_568525.call(path_568526, query_568527, nil, nil, nil)

var taskList* = Call_TaskList_568511(name: "taskList", meth: HttpMethod.HttpGet,
                                  host: "azure.local",
                                  route: "/jobs/{jobId}/tasks",
                                  validator: validate_TaskList_568512, base: "",
                                  url: url_TaskList_568513,
                                  schemes: {Scheme.Https})
type
  Call_TaskUpdate_568563 = ref object of OpenApiRestCall_567667
proc url_TaskUpdate_568565(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskUpdate_568564(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the properties of the specified task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job containing the task.
  ##   taskId: JString (required)
  ##         : The ID of the task to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568566 = path.getOrDefault("jobId")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "jobId", valid_568566
  var valid_568567 = path.getOrDefault("taskId")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "taskId", valid_568567
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568568 = query.getOrDefault("timeout")
  valid_568568 = validateParameter(valid_568568, JInt, required = false,
                                 default = newJInt(30))
  if valid_568568 != nil:
    section.add "timeout", valid_568568
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568569 = query.getOrDefault("api-version")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "api-version", valid_568569
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
  var valid_568570 = header.getOrDefault("If-Match")
  valid_568570 = validateParameter(valid_568570, JString, required = false,
                                 default = nil)
  if valid_568570 != nil:
    section.add "If-Match", valid_568570
  var valid_568571 = header.getOrDefault("client-request-id")
  valid_568571 = validateParameter(valid_568571, JString, required = false,
                                 default = nil)
  if valid_568571 != nil:
    section.add "client-request-id", valid_568571
  var valid_568572 = header.getOrDefault("ocp-date")
  valid_568572 = validateParameter(valid_568572, JString, required = false,
                                 default = nil)
  if valid_568572 != nil:
    section.add "ocp-date", valid_568572
  var valid_568573 = header.getOrDefault("If-Unmodified-Since")
  valid_568573 = validateParameter(valid_568573, JString, required = false,
                                 default = nil)
  if valid_568573 != nil:
    section.add "If-Unmodified-Since", valid_568573
  var valid_568574 = header.getOrDefault("If-None-Match")
  valid_568574 = validateParameter(valid_568574, JString, required = false,
                                 default = nil)
  if valid_568574 != nil:
    section.add "If-None-Match", valid_568574
  var valid_568575 = header.getOrDefault("If-Modified-Since")
  valid_568575 = validateParameter(valid_568575, JString, required = false,
                                 default = nil)
  if valid_568575 != nil:
    section.add "If-Modified-Since", valid_568575
  var valid_568576 = header.getOrDefault("return-client-request-id")
  valid_568576 = validateParameter(valid_568576, JBool, required = false,
                                 default = newJBool(false))
  if valid_568576 != nil:
    section.add "return-client-request-id", valid_568576
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

proc call*(call_568578: Call_TaskUpdate_568563; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of the specified task.
  ## 
  let valid = call_568578.validator(path, query, header, formData, body)
  let scheme = call_568578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568578.url(scheme.get, call_568578.host, call_568578.base,
                         call_568578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568578, url, valid)

proc call*(call_568579: Call_TaskUpdate_568563; apiVersion: string; jobId: string;
          taskUpdateParameter: JsonNode; taskId: string; timeout: int = 30): Recallable =
  ## taskUpdate
  ## Updates the properties of the specified task.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job containing the task.
  ##   taskUpdateParameter: JObject (required)
  ##                      : The parameters for the request.
  ##   taskId: string (required)
  ##         : The ID of the task to update.
  var path_568580 = newJObject()
  var query_568581 = newJObject()
  var body_568582 = newJObject()
  add(query_568581, "timeout", newJInt(timeout))
  add(query_568581, "api-version", newJString(apiVersion))
  add(path_568580, "jobId", newJString(jobId))
  if taskUpdateParameter != nil:
    body_568582 = taskUpdateParameter
  add(path_568580, "taskId", newJString(taskId))
  result = call_568579.call(path_568580, query_568581, nil, nil, body_568582)

var taskUpdate* = Call_TaskUpdate_568563(name: "taskUpdate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local",
                                      route: "/jobs/{jobId}/tasks/{taskId}",
                                      validator: validate_TaskUpdate_568564,
                                      base: "", url: url_TaskUpdate_568565,
                                      schemes: {Scheme.Https})
type
  Call_TaskGet_568543 = ref object of OpenApiRestCall_567667
proc url_TaskGet_568545(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskGet_568544(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## For multi-instance tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary task. Use the list subtasks API to retrieve information about subtasks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job that contains the task.
  ##   taskId: JString (required)
  ##         : The ID of the task to get information about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568546 = path.getOrDefault("jobId")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "jobId", valid_568546
  var valid_568547 = path.getOrDefault("taskId")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "taskId", valid_568547
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
  var valid_568548 = query.getOrDefault("timeout")
  valid_568548 = validateParameter(valid_568548, JInt, required = false,
                                 default = newJInt(30))
  if valid_568548 != nil:
    section.add "timeout", valid_568548
  var valid_568549 = query.getOrDefault("$expand")
  valid_568549 = validateParameter(valid_568549, JString, required = false,
                                 default = nil)
  if valid_568549 != nil:
    section.add "$expand", valid_568549
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568550 = query.getOrDefault("api-version")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "api-version", valid_568550
  var valid_568551 = query.getOrDefault("$select")
  valid_568551 = validateParameter(valid_568551, JString, required = false,
                                 default = nil)
  if valid_568551 != nil:
    section.add "$select", valid_568551
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
  var valid_568552 = header.getOrDefault("If-Match")
  valid_568552 = validateParameter(valid_568552, JString, required = false,
                                 default = nil)
  if valid_568552 != nil:
    section.add "If-Match", valid_568552
  var valid_568553 = header.getOrDefault("client-request-id")
  valid_568553 = validateParameter(valid_568553, JString, required = false,
                                 default = nil)
  if valid_568553 != nil:
    section.add "client-request-id", valid_568553
  var valid_568554 = header.getOrDefault("ocp-date")
  valid_568554 = validateParameter(valid_568554, JString, required = false,
                                 default = nil)
  if valid_568554 != nil:
    section.add "ocp-date", valid_568554
  var valid_568555 = header.getOrDefault("If-Unmodified-Since")
  valid_568555 = validateParameter(valid_568555, JString, required = false,
                                 default = nil)
  if valid_568555 != nil:
    section.add "If-Unmodified-Since", valid_568555
  var valid_568556 = header.getOrDefault("If-None-Match")
  valid_568556 = validateParameter(valid_568556, JString, required = false,
                                 default = nil)
  if valid_568556 != nil:
    section.add "If-None-Match", valid_568556
  var valid_568557 = header.getOrDefault("If-Modified-Since")
  valid_568557 = validateParameter(valid_568557, JString, required = false,
                                 default = nil)
  if valid_568557 != nil:
    section.add "If-Modified-Since", valid_568557
  var valid_568558 = header.getOrDefault("return-client-request-id")
  valid_568558 = validateParameter(valid_568558, JBool, required = false,
                                 default = newJBool(false))
  if valid_568558 != nil:
    section.add "return-client-request-id", valid_568558
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568559: Call_TaskGet_568543; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## For multi-instance tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary task. Use the list subtasks API to retrieve information about subtasks.
  ## 
  let valid = call_568559.validator(path, query, header, formData, body)
  let scheme = call_568559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568559.url(scheme.get, call_568559.host, call_568559.base,
                         call_568559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568559, url, valid)

proc call*(call_568560: Call_TaskGet_568543; apiVersion: string; jobId: string;
          taskId: string; timeout: int = 30; Expand: string = ""; Select: string = ""): Recallable =
  ## taskGet
  ## For multi-instance tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary task. Use the list subtasks API to retrieve information about subtasks.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job that contains the task.
  ##   Select: string
  ##         : An OData $select clause.
  ##   taskId: string (required)
  ##         : The ID of the task to get information about.
  var path_568561 = newJObject()
  var query_568562 = newJObject()
  add(query_568562, "timeout", newJInt(timeout))
  add(query_568562, "$expand", newJString(Expand))
  add(query_568562, "api-version", newJString(apiVersion))
  add(path_568561, "jobId", newJString(jobId))
  add(query_568562, "$select", newJString(Select))
  add(path_568561, "taskId", newJString(taskId))
  result = call_568560.call(path_568561, query_568562, nil, nil, nil)

var taskGet* = Call_TaskGet_568543(name: "taskGet", meth: HttpMethod.HttpGet,
                                host: "azure.local",
                                route: "/jobs/{jobId}/tasks/{taskId}",
                                validator: validate_TaskGet_568544, base: "",
                                url: url_TaskGet_568545, schemes: {Scheme.Https})
type
  Call_TaskDelete_568583 = ref object of OpenApiRestCall_567667
proc url_TaskDelete_568585(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskDelete_568584(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## When a task is deleted, all of the files in its directory on the compute node where it ran are also deleted (regardless of the retention time). For multi-instance tasks, the delete task operation applies synchronously to the primary task; subtasks and their files are then deleted asynchronously in the background.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job from which to delete the task.
  ##   taskId: JString (required)
  ##         : The ID of the task to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568586 = path.getOrDefault("jobId")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "jobId", valid_568586
  var valid_568587 = path.getOrDefault("taskId")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "taskId", valid_568587
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568588 = query.getOrDefault("timeout")
  valid_568588 = validateParameter(valid_568588, JInt, required = false,
                                 default = newJInt(30))
  if valid_568588 != nil:
    section.add "timeout", valid_568588
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568589 = query.getOrDefault("api-version")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "api-version", valid_568589
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
  var valid_568590 = header.getOrDefault("If-Match")
  valid_568590 = validateParameter(valid_568590, JString, required = false,
                                 default = nil)
  if valid_568590 != nil:
    section.add "If-Match", valid_568590
  var valid_568591 = header.getOrDefault("client-request-id")
  valid_568591 = validateParameter(valid_568591, JString, required = false,
                                 default = nil)
  if valid_568591 != nil:
    section.add "client-request-id", valid_568591
  var valid_568592 = header.getOrDefault("ocp-date")
  valid_568592 = validateParameter(valid_568592, JString, required = false,
                                 default = nil)
  if valid_568592 != nil:
    section.add "ocp-date", valid_568592
  var valid_568593 = header.getOrDefault("If-Unmodified-Since")
  valid_568593 = validateParameter(valid_568593, JString, required = false,
                                 default = nil)
  if valid_568593 != nil:
    section.add "If-Unmodified-Since", valid_568593
  var valid_568594 = header.getOrDefault("If-None-Match")
  valid_568594 = validateParameter(valid_568594, JString, required = false,
                                 default = nil)
  if valid_568594 != nil:
    section.add "If-None-Match", valid_568594
  var valid_568595 = header.getOrDefault("If-Modified-Since")
  valid_568595 = validateParameter(valid_568595, JString, required = false,
                                 default = nil)
  if valid_568595 != nil:
    section.add "If-Modified-Since", valid_568595
  var valid_568596 = header.getOrDefault("return-client-request-id")
  valid_568596 = validateParameter(valid_568596, JBool, required = false,
                                 default = newJBool(false))
  if valid_568596 != nil:
    section.add "return-client-request-id", valid_568596
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568597: Call_TaskDelete_568583; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When a task is deleted, all of the files in its directory on the compute node where it ran are also deleted (regardless of the retention time). For multi-instance tasks, the delete task operation applies synchronously to the primary task; subtasks and their files are then deleted asynchronously in the background.
  ## 
  let valid = call_568597.validator(path, query, header, formData, body)
  let scheme = call_568597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568597.url(scheme.get, call_568597.host, call_568597.base,
                         call_568597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568597, url, valid)

proc call*(call_568598: Call_TaskDelete_568583; apiVersion: string; jobId: string;
          taskId: string; timeout: int = 30): Recallable =
  ## taskDelete
  ## When a task is deleted, all of the files in its directory on the compute node where it ran are also deleted (regardless of the retention time). For multi-instance tasks, the delete task operation applies synchronously to the primary task; subtasks and their files are then deleted asynchronously in the background.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job from which to delete the task.
  ##   taskId: string (required)
  ##         : The ID of the task to delete.
  var path_568599 = newJObject()
  var query_568600 = newJObject()
  add(query_568600, "timeout", newJInt(timeout))
  add(query_568600, "api-version", newJString(apiVersion))
  add(path_568599, "jobId", newJString(jobId))
  add(path_568599, "taskId", newJString(taskId))
  result = call_568598.call(path_568599, query_568600, nil, nil, nil)

var taskDelete* = Call_TaskDelete_568583(name: "taskDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/jobs/{jobId}/tasks/{taskId}",
                                      validator: validate_TaskDelete_568584,
                                      base: "", url: url_TaskDelete_568585,
                                      schemes: {Scheme.Https})
type
  Call_FileListFromTask_568601 = ref object of OpenApiRestCall_567667
proc url_FileListFromTask_568603(protocol: Scheme; host: string; base: string;
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

proc validate_FileListFromTask_568602(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job that contains the task.
  ##   taskId: JString (required)
  ##         : The ID of the task whose files you want to list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568604 = path.getOrDefault("jobId")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "jobId", valid_568604
  var valid_568605 = path.getOrDefault("taskId")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "taskId", valid_568605
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
  ##            : Whether to list children of the task directory. This parameter can be used in combination with the filter parameter to list specific type of files.
  section = newJObject()
  var valid_568606 = query.getOrDefault("timeout")
  valid_568606 = validateParameter(valid_568606, JInt, required = false,
                                 default = newJInt(30))
  if valid_568606 != nil:
    section.add "timeout", valid_568606
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568607 = query.getOrDefault("api-version")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "api-version", valid_568607
  var valid_568608 = query.getOrDefault("maxresults")
  valid_568608 = validateParameter(valid_568608, JInt, required = false,
                                 default = newJInt(1000))
  if valid_568608 != nil:
    section.add "maxresults", valid_568608
  var valid_568609 = query.getOrDefault("$filter")
  valid_568609 = validateParameter(valid_568609, JString, required = false,
                                 default = nil)
  if valid_568609 != nil:
    section.add "$filter", valid_568609
  var valid_568610 = query.getOrDefault("recursive")
  valid_568610 = validateParameter(valid_568610, JBool, required = false, default = nil)
  if valid_568610 != nil:
    section.add "recursive", valid_568610
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568611 = header.getOrDefault("client-request-id")
  valid_568611 = validateParameter(valid_568611, JString, required = false,
                                 default = nil)
  if valid_568611 != nil:
    section.add "client-request-id", valid_568611
  var valid_568612 = header.getOrDefault("ocp-date")
  valid_568612 = validateParameter(valid_568612, JString, required = false,
                                 default = nil)
  if valid_568612 != nil:
    section.add "ocp-date", valid_568612
  var valid_568613 = header.getOrDefault("return-client-request-id")
  valid_568613 = validateParameter(valid_568613, JBool, required = false,
                                 default = newJBool(false))
  if valid_568613 != nil:
    section.add "return-client-request-id", valid_568613
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568614: Call_FileListFromTask_568601; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568614.validator(path, query, header, formData, body)
  let scheme = call_568614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568614.url(scheme.get, call_568614.host, call_568614.base,
                         call_568614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568614, url, valid)

proc call*(call_568615: Call_FileListFromTask_568601; apiVersion: string;
          jobId: string; taskId: string; timeout: int = 30; maxresults: int = 1000;
          Filter: string = ""; recursive: bool = false): Recallable =
  ## fileListFromTask
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job that contains the task.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-task-files.
  ##   recursive: bool
  ##            : Whether to list children of the task directory. This parameter can be used in combination with the filter parameter to list specific type of files.
  ##   taskId: string (required)
  ##         : The ID of the task whose files you want to list.
  var path_568616 = newJObject()
  var query_568617 = newJObject()
  add(query_568617, "timeout", newJInt(timeout))
  add(query_568617, "api-version", newJString(apiVersion))
  add(path_568616, "jobId", newJString(jobId))
  add(query_568617, "maxresults", newJInt(maxresults))
  add(query_568617, "$filter", newJString(Filter))
  add(query_568617, "recursive", newJBool(recursive))
  add(path_568616, "taskId", newJString(taskId))
  result = call_568615.call(path_568616, query_568617, nil, nil, nil)

var fileListFromTask* = Call_FileListFromTask_568601(name: "fileListFromTask",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/files",
    validator: validate_FileListFromTask_568602, base: "",
    url: url_FileListFromTask_568603, schemes: {Scheme.Https})
type
  Call_FileGetPropertiesFromTask_568652 = ref object of OpenApiRestCall_567667
proc url_FileGetPropertiesFromTask_568654(protocol: Scheme; host: string;
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

proc validate_FileGetPropertiesFromTask_568653(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified task file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job that contains the task.
  ##   filePath: JString (required)
  ##           : The path to the task file that you want to get the properties of.
  ##   taskId: JString (required)
  ##         : The ID of the task whose file you want to get the properties of.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568655 = path.getOrDefault("jobId")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "jobId", valid_568655
  var valid_568656 = path.getOrDefault("filePath")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "filePath", valid_568656
  var valid_568657 = path.getOrDefault("taskId")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "taskId", valid_568657
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568658 = query.getOrDefault("timeout")
  valid_568658 = validateParameter(valid_568658, JInt, required = false,
                                 default = newJInt(30))
  if valid_568658 != nil:
    section.add "timeout", valid_568658
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568659 = query.getOrDefault("api-version")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "api-version", valid_568659
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
  var valid_568660 = header.getOrDefault("client-request-id")
  valid_568660 = validateParameter(valid_568660, JString, required = false,
                                 default = nil)
  if valid_568660 != nil:
    section.add "client-request-id", valid_568660
  var valid_568661 = header.getOrDefault("ocp-date")
  valid_568661 = validateParameter(valid_568661, JString, required = false,
                                 default = nil)
  if valid_568661 != nil:
    section.add "ocp-date", valid_568661
  var valid_568662 = header.getOrDefault("If-Unmodified-Since")
  valid_568662 = validateParameter(valid_568662, JString, required = false,
                                 default = nil)
  if valid_568662 != nil:
    section.add "If-Unmodified-Since", valid_568662
  var valid_568663 = header.getOrDefault("If-Modified-Since")
  valid_568663 = validateParameter(valid_568663, JString, required = false,
                                 default = nil)
  if valid_568663 != nil:
    section.add "If-Modified-Since", valid_568663
  var valid_568664 = header.getOrDefault("return-client-request-id")
  valid_568664 = validateParameter(valid_568664, JBool, required = false,
                                 default = newJBool(false))
  if valid_568664 != nil:
    section.add "return-client-request-id", valid_568664
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568665: Call_FileGetPropertiesFromTask_568652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified task file.
  ## 
  let valid = call_568665.validator(path, query, header, formData, body)
  let scheme = call_568665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568665.url(scheme.get, call_568665.host, call_568665.base,
                         call_568665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568665, url, valid)

proc call*(call_568666: Call_FileGetPropertiesFromTask_568652; apiVersion: string;
          jobId: string; filePath: string; taskId: string; timeout: int = 30): Recallable =
  ## fileGetPropertiesFromTask
  ## Gets the properties of the specified task file.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job that contains the task.
  ##   filePath: string (required)
  ##           : The path to the task file that you want to get the properties of.
  ##   taskId: string (required)
  ##         : The ID of the task whose file you want to get the properties of.
  var path_568667 = newJObject()
  var query_568668 = newJObject()
  add(query_568668, "timeout", newJInt(timeout))
  add(query_568668, "api-version", newJString(apiVersion))
  add(path_568667, "jobId", newJString(jobId))
  add(path_568667, "filePath", newJString(filePath))
  add(path_568667, "taskId", newJString(taskId))
  result = call_568666.call(path_568667, query_568668, nil, nil, nil)

var fileGetPropertiesFromTask* = Call_FileGetPropertiesFromTask_568652(
    name: "fileGetPropertiesFromTask", meth: HttpMethod.HttpHead,
    host: "azure.local", route: "/jobs/{jobId}/tasks/{taskId}/files/{filePath}",
    validator: validate_FileGetPropertiesFromTask_568653, base: "",
    url: url_FileGetPropertiesFromTask_568654, schemes: {Scheme.Https})
type
  Call_FileGetFromTask_568618 = ref object of OpenApiRestCall_567667
proc url_FileGetFromTask_568620(protocol: Scheme; host: string; base: string;
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

proc validate_FileGetFromTask_568619(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns the content of the specified task file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job that contains the task.
  ##   filePath: JString (required)
  ##           : The path to the task file that you want to get the content of.
  ##   taskId: JString (required)
  ##         : The ID of the task whose file you want to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568621 = path.getOrDefault("jobId")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "jobId", valid_568621
  var valid_568622 = path.getOrDefault("filePath")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "filePath", valid_568622
  var valid_568623 = path.getOrDefault("taskId")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "taskId", valid_568623
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568624 = query.getOrDefault("timeout")
  valid_568624 = validateParameter(valid_568624, JInt, required = false,
                                 default = newJInt(30))
  if valid_568624 != nil:
    section.add "timeout", valid_568624
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568625 = query.getOrDefault("api-version")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "api-version", valid_568625
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
  var valid_568626 = header.getOrDefault("client-request-id")
  valid_568626 = validateParameter(valid_568626, JString, required = false,
                                 default = nil)
  if valid_568626 != nil:
    section.add "client-request-id", valid_568626
  var valid_568627 = header.getOrDefault("ocp-date")
  valid_568627 = validateParameter(valid_568627, JString, required = false,
                                 default = nil)
  if valid_568627 != nil:
    section.add "ocp-date", valid_568627
  var valid_568628 = header.getOrDefault("If-Unmodified-Since")
  valid_568628 = validateParameter(valid_568628, JString, required = false,
                                 default = nil)
  if valid_568628 != nil:
    section.add "If-Unmodified-Since", valid_568628
  var valid_568629 = header.getOrDefault("ocp-range")
  valid_568629 = validateParameter(valid_568629, JString, required = false,
                                 default = nil)
  if valid_568629 != nil:
    section.add "ocp-range", valid_568629
  var valid_568630 = header.getOrDefault("If-Modified-Since")
  valid_568630 = validateParameter(valid_568630, JString, required = false,
                                 default = nil)
  if valid_568630 != nil:
    section.add "If-Modified-Since", valid_568630
  var valid_568631 = header.getOrDefault("return-client-request-id")
  valid_568631 = validateParameter(valid_568631, JBool, required = false,
                                 default = newJBool(false))
  if valid_568631 != nil:
    section.add "return-client-request-id", valid_568631
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568632: Call_FileGetFromTask_568618; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the content of the specified task file.
  ## 
  let valid = call_568632.validator(path, query, header, formData, body)
  let scheme = call_568632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568632.url(scheme.get, call_568632.host, call_568632.base,
                         call_568632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568632, url, valid)

proc call*(call_568633: Call_FileGetFromTask_568618; apiVersion: string;
          jobId: string; filePath: string; taskId: string; timeout: int = 30): Recallable =
  ## fileGetFromTask
  ## Returns the content of the specified task file.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job that contains the task.
  ##   filePath: string (required)
  ##           : The path to the task file that you want to get the content of.
  ##   taskId: string (required)
  ##         : The ID of the task whose file you want to retrieve.
  var path_568634 = newJObject()
  var query_568635 = newJObject()
  add(query_568635, "timeout", newJInt(timeout))
  add(query_568635, "api-version", newJString(apiVersion))
  add(path_568634, "jobId", newJString(jobId))
  add(path_568634, "filePath", newJString(filePath))
  add(path_568634, "taskId", newJString(taskId))
  result = call_568633.call(path_568634, query_568635, nil, nil, nil)

var fileGetFromTask* = Call_FileGetFromTask_568618(name: "fileGetFromTask",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/files/{filePath}",
    validator: validate_FileGetFromTask_568619, base: "", url: url_FileGetFromTask_568620,
    schemes: {Scheme.Https})
type
  Call_FileDeleteFromTask_568636 = ref object of OpenApiRestCall_567667
proc url_FileDeleteFromTask_568638(protocol: Scheme; host: string; base: string;
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

proc validate_FileDeleteFromTask_568637(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job that contains the task.
  ##   filePath: JString (required)
  ##           : The path to the task file or directory that you want to delete.
  ##   taskId: JString (required)
  ##         : The ID of the task whose file you want to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568639 = path.getOrDefault("jobId")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "jobId", valid_568639
  var valid_568640 = path.getOrDefault("filePath")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "filePath", valid_568640
  var valid_568641 = path.getOrDefault("taskId")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "taskId", valid_568641
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   recursive: JBool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  section = newJObject()
  var valid_568642 = query.getOrDefault("timeout")
  valid_568642 = validateParameter(valid_568642, JInt, required = false,
                                 default = newJInt(30))
  if valid_568642 != nil:
    section.add "timeout", valid_568642
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568643 = query.getOrDefault("api-version")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "api-version", valid_568643
  var valid_568644 = query.getOrDefault("recursive")
  valid_568644 = validateParameter(valid_568644, JBool, required = false, default = nil)
  if valid_568644 != nil:
    section.add "recursive", valid_568644
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568645 = header.getOrDefault("client-request-id")
  valid_568645 = validateParameter(valid_568645, JString, required = false,
                                 default = nil)
  if valid_568645 != nil:
    section.add "client-request-id", valid_568645
  var valid_568646 = header.getOrDefault("ocp-date")
  valid_568646 = validateParameter(valid_568646, JString, required = false,
                                 default = nil)
  if valid_568646 != nil:
    section.add "ocp-date", valid_568646
  var valid_568647 = header.getOrDefault("return-client-request-id")
  valid_568647 = validateParameter(valid_568647, JBool, required = false,
                                 default = newJBool(false))
  if valid_568647 != nil:
    section.add "return-client-request-id", valid_568647
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568648: Call_FileDeleteFromTask_568636; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568648.validator(path, query, header, formData, body)
  let scheme = call_568648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568648.url(scheme.get, call_568648.host, call_568648.base,
                         call_568648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568648, url, valid)

proc call*(call_568649: Call_FileDeleteFromTask_568636; apiVersion: string;
          jobId: string; filePath: string; taskId: string; timeout: int = 30;
          recursive: bool = false): Recallable =
  ## fileDeleteFromTask
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job that contains the task.
  ##   filePath: string (required)
  ##           : The path to the task file or directory that you want to delete.
  ##   recursive: bool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  ##   taskId: string (required)
  ##         : The ID of the task whose file you want to delete.
  var path_568650 = newJObject()
  var query_568651 = newJObject()
  add(query_568651, "timeout", newJInt(timeout))
  add(query_568651, "api-version", newJString(apiVersion))
  add(path_568650, "jobId", newJString(jobId))
  add(path_568650, "filePath", newJString(filePath))
  add(query_568651, "recursive", newJBool(recursive))
  add(path_568650, "taskId", newJString(taskId))
  result = call_568649.call(path_568650, query_568651, nil, nil, nil)

var fileDeleteFromTask* = Call_FileDeleteFromTask_568636(
    name: "fileDeleteFromTask", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/files/{filePath}",
    validator: validate_FileDeleteFromTask_568637, base: "",
    url: url_FileDeleteFromTask_568638, schemes: {Scheme.Https})
type
  Call_TaskReactivate_568669 = ref object of OpenApiRestCall_567667
proc url_TaskReactivate_568671(protocol: Scheme; host: string; base: string;
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

proc validate_TaskReactivate_568670(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Reactivation makes a task eligible to be retried again up to its maximum retry count. The task's state is changed to active. As the task is no longer in the completed state, any previous exit code or failure information is no longer available after reactivation. Each time a task is reactivated, its retry count is reset to 0. Reactivation will fail for tasks that are not completed or that previously completed successfully (with an exit code of 0). Additionally, it will fail if the job has completed (or is terminating or deleting).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job containing the task.
  ##   taskId: JString (required)
  ##         : The ID of the task to reactivate.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568672 = path.getOrDefault("jobId")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "jobId", valid_568672
  var valid_568673 = path.getOrDefault("taskId")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "taskId", valid_568673
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568674 = query.getOrDefault("timeout")
  valid_568674 = validateParameter(valid_568674, JInt, required = false,
                                 default = newJInt(30))
  if valid_568674 != nil:
    section.add "timeout", valid_568674
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568675 = query.getOrDefault("api-version")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "api-version", valid_568675
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
  var valid_568676 = header.getOrDefault("If-Match")
  valid_568676 = validateParameter(valid_568676, JString, required = false,
                                 default = nil)
  if valid_568676 != nil:
    section.add "If-Match", valid_568676
  var valid_568677 = header.getOrDefault("client-request-id")
  valid_568677 = validateParameter(valid_568677, JString, required = false,
                                 default = nil)
  if valid_568677 != nil:
    section.add "client-request-id", valid_568677
  var valid_568678 = header.getOrDefault("ocp-date")
  valid_568678 = validateParameter(valid_568678, JString, required = false,
                                 default = nil)
  if valid_568678 != nil:
    section.add "ocp-date", valid_568678
  var valid_568679 = header.getOrDefault("If-Unmodified-Since")
  valid_568679 = validateParameter(valid_568679, JString, required = false,
                                 default = nil)
  if valid_568679 != nil:
    section.add "If-Unmodified-Since", valid_568679
  var valid_568680 = header.getOrDefault("If-None-Match")
  valid_568680 = validateParameter(valid_568680, JString, required = false,
                                 default = nil)
  if valid_568680 != nil:
    section.add "If-None-Match", valid_568680
  var valid_568681 = header.getOrDefault("If-Modified-Since")
  valid_568681 = validateParameter(valid_568681, JString, required = false,
                                 default = nil)
  if valid_568681 != nil:
    section.add "If-Modified-Since", valid_568681
  var valid_568682 = header.getOrDefault("return-client-request-id")
  valid_568682 = validateParameter(valid_568682, JBool, required = false,
                                 default = newJBool(false))
  if valid_568682 != nil:
    section.add "return-client-request-id", valid_568682
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568683: Call_TaskReactivate_568669; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reactivation makes a task eligible to be retried again up to its maximum retry count. The task's state is changed to active. As the task is no longer in the completed state, any previous exit code or failure information is no longer available after reactivation. Each time a task is reactivated, its retry count is reset to 0. Reactivation will fail for tasks that are not completed or that previously completed successfully (with an exit code of 0). Additionally, it will fail if the job has completed (or is terminating or deleting).
  ## 
  let valid = call_568683.validator(path, query, header, formData, body)
  let scheme = call_568683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568683.url(scheme.get, call_568683.host, call_568683.base,
                         call_568683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568683, url, valid)

proc call*(call_568684: Call_TaskReactivate_568669; apiVersion: string;
          jobId: string; taskId: string; timeout: int = 30): Recallable =
  ## taskReactivate
  ## Reactivation makes a task eligible to be retried again up to its maximum retry count. The task's state is changed to active. As the task is no longer in the completed state, any previous exit code or failure information is no longer available after reactivation. Each time a task is reactivated, its retry count is reset to 0. Reactivation will fail for tasks that are not completed or that previously completed successfully (with an exit code of 0). Additionally, it will fail if the job has completed (or is terminating or deleting).
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job containing the task.
  ##   taskId: string (required)
  ##         : The ID of the task to reactivate.
  var path_568685 = newJObject()
  var query_568686 = newJObject()
  add(query_568686, "timeout", newJInt(timeout))
  add(query_568686, "api-version", newJString(apiVersion))
  add(path_568685, "jobId", newJString(jobId))
  add(path_568685, "taskId", newJString(taskId))
  result = call_568684.call(path_568685, query_568686, nil, nil, nil)

var taskReactivate* = Call_TaskReactivate_568669(name: "taskReactivate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/reactivate",
    validator: validate_TaskReactivate_568670, base: "", url: url_TaskReactivate_568671,
    schemes: {Scheme.Https})
type
  Call_TaskListSubtasks_568687 = ref object of OpenApiRestCall_567667
proc url_TaskListSubtasks_568689(protocol: Scheme; host: string; base: string;
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

proc validate_TaskListSubtasks_568688(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## If the task is not a multi-instance task then this returns an empty collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job.
  ##   taskId: JString (required)
  ##         : The ID of the task.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568690 = path.getOrDefault("jobId")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "jobId", valid_568690
  var valid_568691 = path.getOrDefault("taskId")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "taskId", valid_568691
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_568692 = query.getOrDefault("timeout")
  valid_568692 = validateParameter(valid_568692, JInt, required = false,
                                 default = newJInt(30))
  if valid_568692 != nil:
    section.add "timeout", valid_568692
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568693 = query.getOrDefault("api-version")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "api-version", valid_568693
  var valid_568694 = query.getOrDefault("$select")
  valid_568694 = validateParameter(valid_568694, JString, required = false,
                                 default = nil)
  if valid_568694 != nil:
    section.add "$select", valid_568694
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568695 = header.getOrDefault("client-request-id")
  valid_568695 = validateParameter(valid_568695, JString, required = false,
                                 default = nil)
  if valid_568695 != nil:
    section.add "client-request-id", valid_568695
  var valid_568696 = header.getOrDefault("ocp-date")
  valid_568696 = validateParameter(valid_568696, JString, required = false,
                                 default = nil)
  if valid_568696 != nil:
    section.add "ocp-date", valid_568696
  var valid_568697 = header.getOrDefault("return-client-request-id")
  valid_568697 = validateParameter(valid_568697, JBool, required = false,
                                 default = newJBool(false))
  if valid_568697 != nil:
    section.add "return-client-request-id", valid_568697
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568698: Call_TaskListSubtasks_568687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If the task is not a multi-instance task then this returns an empty collection.
  ## 
  let valid = call_568698.validator(path, query, header, formData, body)
  let scheme = call_568698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568698.url(scheme.get, call_568698.host, call_568698.base,
                         call_568698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568698, url, valid)

proc call*(call_568699: Call_TaskListSubtasks_568687; apiVersion: string;
          jobId: string; taskId: string; timeout: int = 30; Select: string = ""): Recallable =
  ## taskListSubtasks
  ## If the task is not a multi-instance task then this returns an empty collection.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job.
  ##   Select: string
  ##         : An OData $select clause.
  ##   taskId: string (required)
  ##         : The ID of the task.
  var path_568700 = newJObject()
  var query_568701 = newJObject()
  add(query_568701, "timeout", newJInt(timeout))
  add(query_568701, "api-version", newJString(apiVersion))
  add(path_568700, "jobId", newJString(jobId))
  add(query_568701, "$select", newJString(Select))
  add(path_568700, "taskId", newJString(taskId))
  result = call_568699.call(path_568700, query_568701, nil, nil, nil)

var taskListSubtasks* = Call_TaskListSubtasks_568687(name: "taskListSubtasks",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/subtasksinfo",
    validator: validate_TaskListSubtasks_568688, base: "",
    url: url_TaskListSubtasks_568689, schemes: {Scheme.Https})
type
  Call_TaskTerminate_568702 = ref object of OpenApiRestCall_567667
proc url_TaskTerminate_568704(protocol: Scheme; host: string; base: string;
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

proc validate_TaskTerminate_568703(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## When the task has been terminated, it moves to the completed state. For multi-instance tasks, the terminate task operation applies synchronously to the primary task; subtasks are then terminated asynchronously in the background.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job containing the task.
  ##   taskId: JString (required)
  ##         : The ID of the task to terminate.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568705 = path.getOrDefault("jobId")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "jobId", valid_568705
  var valid_568706 = path.getOrDefault("taskId")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "taskId", valid_568706
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568707 = query.getOrDefault("timeout")
  valid_568707 = validateParameter(valid_568707, JInt, required = false,
                                 default = newJInt(30))
  if valid_568707 != nil:
    section.add "timeout", valid_568707
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568708 = query.getOrDefault("api-version")
  valid_568708 = validateParameter(valid_568708, JString, required = true,
                                 default = nil)
  if valid_568708 != nil:
    section.add "api-version", valid_568708
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
  var valid_568709 = header.getOrDefault("If-Match")
  valid_568709 = validateParameter(valid_568709, JString, required = false,
                                 default = nil)
  if valid_568709 != nil:
    section.add "If-Match", valid_568709
  var valid_568710 = header.getOrDefault("client-request-id")
  valid_568710 = validateParameter(valid_568710, JString, required = false,
                                 default = nil)
  if valid_568710 != nil:
    section.add "client-request-id", valid_568710
  var valid_568711 = header.getOrDefault("ocp-date")
  valid_568711 = validateParameter(valid_568711, JString, required = false,
                                 default = nil)
  if valid_568711 != nil:
    section.add "ocp-date", valid_568711
  var valid_568712 = header.getOrDefault("If-Unmodified-Since")
  valid_568712 = validateParameter(valid_568712, JString, required = false,
                                 default = nil)
  if valid_568712 != nil:
    section.add "If-Unmodified-Since", valid_568712
  var valid_568713 = header.getOrDefault("If-None-Match")
  valid_568713 = validateParameter(valid_568713, JString, required = false,
                                 default = nil)
  if valid_568713 != nil:
    section.add "If-None-Match", valid_568713
  var valid_568714 = header.getOrDefault("If-Modified-Since")
  valid_568714 = validateParameter(valid_568714, JString, required = false,
                                 default = nil)
  if valid_568714 != nil:
    section.add "If-Modified-Since", valid_568714
  var valid_568715 = header.getOrDefault("return-client-request-id")
  valid_568715 = validateParameter(valid_568715, JBool, required = false,
                                 default = newJBool(false))
  if valid_568715 != nil:
    section.add "return-client-request-id", valid_568715
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568716: Call_TaskTerminate_568702; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When the task has been terminated, it moves to the completed state. For multi-instance tasks, the terminate task operation applies synchronously to the primary task; subtasks are then terminated asynchronously in the background.
  ## 
  let valid = call_568716.validator(path, query, header, formData, body)
  let scheme = call_568716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568716.url(scheme.get, call_568716.host, call_568716.base,
                         call_568716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568716, url, valid)

proc call*(call_568717: Call_TaskTerminate_568702; apiVersion: string; jobId: string;
          taskId: string; timeout: int = 30): Recallable =
  ## taskTerminate
  ## When the task has been terminated, it moves to the completed state. For multi-instance tasks, the terminate task operation applies synchronously to the primary task; subtasks are then terminated asynchronously in the background.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job containing the task.
  ##   taskId: string (required)
  ##         : The ID of the task to terminate.
  var path_568718 = newJObject()
  var query_568719 = newJObject()
  add(query_568719, "timeout", newJInt(timeout))
  add(query_568719, "api-version", newJString(apiVersion))
  add(path_568718, "jobId", newJString(jobId))
  add(path_568718, "taskId", newJString(taskId))
  result = call_568717.call(path_568718, query_568719, nil, nil, nil)

var taskTerminate* = Call_TaskTerminate_568702(name: "taskTerminate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/terminate",
    validator: validate_TaskTerminate_568703, base: "", url: url_TaskTerminate_568704,
    schemes: {Scheme.Https})
type
  Call_JobTerminate_568720 = ref object of OpenApiRestCall_567667
proc url_JobTerminate_568722(protocol: Scheme; host: string; base: string;
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

proc validate_JobTerminate_568721(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## When a Terminate Job request is received, the Batch service sets the job to the terminating state. The Batch service then terminates any running tasks associated with the job and runs any required job release tasks. Then the job moves into the completed state. If there are any tasks in the job in the active state, they will remain in the active state. Once a job is terminated, new tasks cannot be added and any remaining active tasks will not be scheduled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job to terminate.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_568723 = path.getOrDefault("jobId")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "jobId", valid_568723
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568724 = query.getOrDefault("timeout")
  valid_568724 = validateParameter(valid_568724, JInt, required = false,
                                 default = newJInt(30))
  if valid_568724 != nil:
    section.add "timeout", valid_568724
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568725 = query.getOrDefault("api-version")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "api-version", valid_568725
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
  var valid_568726 = header.getOrDefault("If-Match")
  valid_568726 = validateParameter(valid_568726, JString, required = false,
                                 default = nil)
  if valid_568726 != nil:
    section.add "If-Match", valid_568726
  var valid_568727 = header.getOrDefault("client-request-id")
  valid_568727 = validateParameter(valid_568727, JString, required = false,
                                 default = nil)
  if valid_568727 != nil:
    section.add "client-request-id", valid_568727
  var valid_568728 = header.getOrDefault("ocp-date")
  valid_568728 = validateParameter(valid_568728, JString, required = false,
                                 default = nil)
  if valid_568728 != nil:
    section.add "ocp-date", valid_568728
  var valid_568729 = header.getOrDefault("If-Unmodified-Since")
  valid_568729 = validateParameter(valid_568729, JString, required = false,
                                 default = nil)
  if valid_568729 != nil:
    section.add "If-Unmodified-Since", valid_568729
  var valid_568730 = header.getOrDefault("If-None-Match")
  valid_568730 = validateParameter(valid_568730, JString, required = false,
                                 default = nil)
  if valid_568730 != nil:
    section.add "If-None-Match", valid_568730
  var valid_568731 = header.getOrDefault("If-Modified-Since")
  valid_568731 = validateParameter(valid_568731, JString, required = false,
                                 default = nil)
  if valid_568731 != nil:
    section.add "If-Modified-Since", valid_568731
  var valid_568732 = header.getOrDefault("return-client-request-id")
  valid_568732 = validateParameter(valid_568732, JBool, required = false,
                                 default = newJBool(false))
  if valid_568732 != nil:
    section.add "return-client-request-id", valid_568732
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobTerminateParameter: JObject
  ##                        : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568734: Call_JobTerminate_568720; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When a Terminate Job request is received, the Batch service sets the job to the terminating state. The Batch service then terminates any running tasks associated with the job and runs any required job release tasks. Then the job moves into the completed state. If there are any tasks in the job in the active state, they will remain in the active state. Once a job is terminated, new tasks cannot be added and any remaining active tasks will not be scheduled.
  ## 
  let valid = call_568734.validator(path, query, header, formData, body)
  let scheme = call_568734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568734.url(scheme.get, call_568734.host, call_568734.base,
                         call_568734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568734, url, valid)

proc call*(call_568735: Call_JobTerminate_568720; apiVersion: string; jobId: string;
          timeout: int = 30; jobTerminateParameter: JsonNode = nil): Recallable =
  ## jobTerminate
  ## When a Terminate Job request is received, the Batch service sets the job to the terminating state. The Batch service then terminates any running tasks associated with the job and runs any required job release tasks. Then the job moves into the completed state. If there are any tasks in the job in the active state, they will remain in the active state. Once a job is terminated, new tasks cannot be added and any remaining active tasks will not be scheduled.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the job to terminate.
  ##   jobTerminateParameter: JObject
  ##                        : The parameters for the request.
  var path_568736 = newJObject()
  var query_568737 = newJObject()
  var body_568738 = newJObject()
  add(query_568737, "timeout", newJInt(timeout))
  add(query_568737, "api-version", newJString(apiVersion))
  add(path_568736, "jobId", newJString(jobId))
  if jobTerminateParameter != nil:
    body_568738 = jobTerminateParameter
  result = call_568735.call(path_568736, query_568737, nil, nil, body_568738)

var jobTerminate* = Call_JobTerminate_568720(name: "jobTerminate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/terminate", validator: validate_JobTerminate_568721,
    base: "", url: url_JobTerminate_568722, schemes: {Scheme.Https})
type
  Call_JobScheduleAdd_568754 = ref object of OpenApiRestCall_567667
proc url_JobScheduleAdd_568756(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobScheduleAdd_568755(path: JsonNode; query: JsonNode;
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
  var valid_568757 = query.getOrDefault("timeout")
  valid_568757 = validateParameter(valid_568757, JInt, required = false,
                                 default = newJInt(30))
  if valid_568757 != nil:
    section.add "timeout", valid_568757
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568758 = query.getOrDefault("api-version")
  valid_568758 = validateParameter(valid_568758, JString, required = true,
                                 default = nil)
  if valid_568758 != nil:
    section.add "api-version", valid_568758
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568759 = header.getOrDefault("client-request-id")
  valid_568759 = validateParameter(valid_568759, JString, required = false,
                                 default = nil)
  if valid_568759 != nil:
    section.add "client-request-id", valid_568759
  var valid_568760 = header.getOrDefault("ocp-date")
  valid_568760 = validateParameter(valid_568760, JString, required = false,
                                 default = nil)
  if valid_568760 != nil:
    section.add "ocp-date", valid_568760
  var valid_568761 = header.getOrDefault("return-client-request-id")
  valid_568761 = validateParameter(valid_568761, JBool, required = false,
                                 default = newJBool(false))
  if valid_568761 != nil:
    section.add "return-client-request-id", valid_568761
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   cloudJobSchedule: JObject (required)
  ##                   : The job schedule to be added.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568763: Call_JobScheduleAdd_568754; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568763.validator(path, query, header, formData, body)
  let scheme = call_568763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568763.url(scheme.get, call_568763.host, call_568763.base,
                         call_568763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568763, url, valid)

proc call*(call_568764: Call_JobScheduleAdd_568754; apiVersion: string;
          cloudJobSchedule: JsonNode; timeout: int = 30): Recallable =
  ## jobScheduleAdd
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   cloudJobSchedule: JObject (required)
  ##                   : The job schedule to be added.
  var query_568765 = newJObject()
  var body_568766 = newJObject()
  add(query_568765, "timeout", newJInt(timeout))
  add(query_568765, "api-version", newJString(apiVersion))
  if cloudJobSchedule != nil:
    body_568766 = cloudJobSchedule
  result = call_568764.call(nil, query_568765, nil, nil, body_568766)

var jobScheduleAdd* = Call_JobScheduleAdd_568754(name: "jobScheduleAdd",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/jobschedules",
    validator: validate_JobScheduleAdd_568755, base: "", url: url_JobScheduleAdd_568756,
    schemes: {Scheme.Https})
type
  Call_JobScheduleList_568739 = ref object of OpenApiRestCall_567667
proc url_JobScheduleList_568741(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobScheduleList_568740(path: JsonNode; query: JsonNode;
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
  ##             : The maximum number of items to return in the response. A maximum of 1000 job schedules can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-schedules.
  section = newJObject()
  var valid_568742 = query.getOrDefault("timeout")
  valid_568742 = validateParameter(valid_568742, JInt, required = false,
                                 default = newJInt(30))
  if valid_568742 != nil:
    section.add "timeout", valid_568742
  var valid_568743 = query.getOrDefault("$expand")
  valid_568743 = validateParameter(valid_568743, JString, required = false,
                                 default = nil)
  if valid_568743 != nil:
    section.add "$expand", valid_568743
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568744 = query.getOrDefault("api-version")
  valid_568744 = validateParameter(valid_568744, JString, required = true,
                                 default = nil)
  if valid_568744 != nil:
    section.add "api-version", valid_568744
  var valid_568745 = query.getOrDefault("maxresults")
  valid_568745 = validateParameter(valid_568745, JInt, required = false,
                                 default = newJInt(1000))
  if valid_568745 != nil:
    section.add "maxresults", valid_568745
  var valid_568746 = query.getOrDefault("$select")
  valid_568746 = validateParameter(valid_568746, JString, required = false,
                                 default = nil)
  if valid_568746 != nil:
    section.add "$select", valid_568746
  var valid_568747 = query.getOrDefault("$filter")
  valid_568747 = validateParameter(valid_568747, JString, required = false,
                                 default = nil)
  if valid_568747 != nil:
    section.add "$filter", valid_568747
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568748 = header.getOrDefault("client-request-id")
  valid_568748 = validateParameter(valid_568748, JString, required = false,
                                 default = nil)
  if valid_568748 != nil:
    section.add "client-request-id", valid_568748
  var valid_568749 = header.getOrDefault("ocp-date")
  valid_568749 = validateParameter(valid_568749, JString, required = false,
                                 default = nil)
  if valid_568749 != nil:
    section.add "ocp-date", valid_568749
  var valid_568750 = header.getOrDefault("return-client-request-id")
  valid_568750 = validateParameter(valid_568750, JBool, required = false,
                                 default = newJBool(false))
  if valid_568750 != nil:
    section.add "return-client-request-id", valid_568750
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568751: Call_JobScheduleList_568739; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568751.validator(path, query, header, formData, body)
  let scheme = call_568751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568751.url(scheme.get, call_568751.host, call_568751.base,
                         call_568751.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568751, url, valid)

proc call*(call_568752: Call_JobScheduleList_568739; apiVersion: string;
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
  ##             : The maximum number of items to return in the response. A maximum of 1000 job schedules can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-schedules.
  var query_568753 = newJObject()
  add(query_568753, "timeout", newJInt(timeout))
  add(query_568753, "$expand", newJString(Expand))
  add(query_568753, "api-version", newJString(apiVersion))
  add(query_568753, "maxresults", newJInt(maxresults))
  add(query_568753, "$select", newJString(Select))
  add(query_568753, "$filter", newJString(Filter))
  result = call_568752.call(nil, query_568753, nil, nil, nil)

var jobScheduleList* = Call_JobScheduleList_568739(name: "jobScheduleList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/jobschedules",
    validator: validate_JobScheduleList_568740, base: "", url: url_JobScheduleList_568741,
    schemes: {Scheme.Https})
type
  Call_JobScheduleUpdate_568786 = ref object of OpenApiRestCall_567667
proc url_JobScheduleUpdate_568788(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleUpdate_568787(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## This fully replaces all the updatable properties of the job schedule. For example, if the schedule property is not specified with this request, then the Batch service will remove the existing schedule. Changes to a job schedule only impact jobs created by the schedule after the update has taken place; currently running jobs are unaffected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the job schedule to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_568789 = path.getOrDefault("jobScheduleId")
  valid_568789 = validateParameter(valid_568789, JString, required = true,
                                 default = nil)
  if valid_568789 != nil:
    section.add "jobScheduleId", valid_568789
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568790 = query.getOrDefault("timeout")
  valid_568790 = validateParameter(valid_568790, JInt, required = false,
                                 default = newJInt(30))
  if valid_568790 != nil:
    section.add "timeout", valid_568790
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568791 = query.getOrDefault("api-version")
  valid_568791 = validateParameter(valid_568791, JString, required = true,
                                 default = nil)
  if valid_568791 != nil:
    section.add "api-version", valid_568791
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
  var valid_568792 = header.getOrDefault("If-Match")
  valid_568792 = validateParameter(valid_568792, JString, required = false,
                                 default = nil)
  if valid_568792 != nil:
    section.add "If-Match", valid_568792
  var valid_568793 = header.getOrDefault("client-request-id")
  valid_568793 = validateParameter(valid_568793, JString, required = false,
                                 default = nil)
  if valid_568793 != nil:
    section.add "client-request-id", valid_568793
  var valid_568794 = header.getOrDefault("ocp-date")
  valid_568794 = validateParameter(valid_568794, JString, required = false,
                                 default = nil)
  if valid_568794 != nil:
    section.add "ocp-date", valid_568794
  var valid_568795 = header.getOrDefault("If-Unmodified-Since")
  valid_568795 = validateParameter(valid_568795, JString, required = false,
                                 default = nil)
  if valid_568795 != nil:
    section.add "If-Unmodified-Since", valid_568795
  var valid_568796 = header.getOrDefault("If-None-Match")
  valid_568796 = validateParameter(valid_568796, JString, required = false,
                                 default = nil)
  if valid_568796 != nil:
    section.add "If-None-Match", valid_568796
  var valid_568797 = header.getOrDefault("If-Modified-Since")
  valid_568797 = validateParameter(valid_568797, JString, required = false,
                                 default = nil)
  if valid_568797 != nil:
    section.add "If-Modified-Since", valid_568797
  var valid_568798 = header.getOrDefault("return-client-request-id")
  valid_568798 = validateParameter(valid_568798, JBool, required = false,
                                 default = newJBool(false))
  if valid_568798 != nil:
    section.add "return-client-request-id", valid_568798
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

proc call*(call_568800: Call_JobScheduleUpdate_568786; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This fully replaces all the updatable properties of the job schedule. For example, if the schedule property is not specified with this request, then the Batch service will remove the existing schedule. Changes to a job schedule only impact jobs created by the schedule after the update has taken place; currently running jobs are unaffected.
  ## 
  let valid = call_568800.validator(path, query, header, formData, body)
  let scheme = call_568800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568800.url(scheme.get, call_568800.host, call_568800.base,
                         call_568800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568800, url, valid)

proc call*(call_568801: Call_JobScheduleUpdate_568786; jobScheduleId: string;
          apiVersion: string; jobScheduleUpdateParameter: JsonNode;
          timeout: int = 30): Recallable =
  ## jobScheduleUpdate
  ## This fully replaces all the updatable properties of the job schedule. For example, if the schedule property is not specified with this request, then the Batch service will remove the existing schedule. Changes to a job schedule only impact jobs created by the schedule after the update has taken place; currently running jobs are unaffected.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to update.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobScheduleUpdateParameter: JObject (required)
  ##                             : The parameters for the request.
  var path_568802 = newJObject()
  var query_568803 = newJObject()
  var body_568804 = newJObject()
  add(query_568803, "timeout", newJInt(timeout))
  add(path_568802, "jobScheduleId", newJString(jobScheduleId))
  add(query_568803, "api-version", newJString(apiVersion))
  if jobScheduleUpdateParameter != nil:
    body_568804 = jobScheduleUpdateParameter
  result = call_568801.call(path_568802, query_568803, nil, nil, body_568804)

var jobScheduleUpdate* = Call_JobScheduleUpdate_568786(name: "jobScheduleUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleUpdate_568787,
    base: "", url: url_JobScheduleUpdate_568788, schemes: {Scheme.Https})
type
  Call_JobScheduleExists_568822 = ref object of OpenApiRestCall_567667
proc url_JobScheduleExists_568824(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleExists_568823(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the job schedule which you want to check.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_568825 = path.getOrDefault("jobScheduleId")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "jobScheduleId", valid_568825
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568826 = query.getOrDefault("timeout")
  valid_568826 = validateParameter(valid_568826, JInt, required = false,
                                 default = newJInt(30))
  if valid_568826 != nil:
    section.add "timeout", valid_568826
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568827 = query.getOrDefault("api-version")
  valid_568827 = validateParameter(valid_568827, JString, required = true,
                                 default = nil)
  if valid_568827 != nil:
    section.add "api-version", valid_568827
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
  var valid_568828 = header.getOrDefault("If-Match")
  valid_568828 = validateParameter(valid_568828, JString, required = false,
                                 default = nil)
  if valid_568828 != nil:
    section.add "If-Match", valid_568828
  var valid_568829 = header.getOrDefault("client-request-id")
  valid_568829 = validateParameter(valid_568829, JString, required = false,
                                 default = nil)
  if valid_568829 != nil:
    section.add "client-request-id", valid_568829
  var valid_568830 = header.getOrDefault("ocp-date")
  valid_568830 = validateParameter(valid_568830, JString, required = false,
                                 default = nil)
  if valid_568830 != nil:
    section.add "ocp-date", valid_568830
  var valid_568831 = header.getOrDefault("If-Unmodified-Since")
  valid_568831 = validateParameter(valid_568831, JString, required = false,
                                 default = nil)
  if valid_568831 != nil:
    section.add "If-Unmodified-Since", valid_568831
  var valid_568832 = header.getOrDefault("If-None-Match")
  valid_568832 = validateParameter(valid_568832, JString, required = false,
                                 default = nil)
  if valid_568832 != nil:
    section.add "If-None-Match", valid_568832
  var valid_568833 = header.getOrDefault("If-Modified-Since")
  valid_568833 = validateParameter(valid_568833, JString, required = false,
                                 default = nil)
  if valid_568833 != nil:
    section.add "If-Modified-Since", valid_568833
  var valid_568834 = header.getOrDefault("return-client-request-id")
  valid_568834 = validateParameter(valid_568834, JBool, required = false,
                                 default = newJBool(false))
  if valid_568834 != nil:
    section.add "return-client-request-id", valid_568834
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568835: Call_JobScheduleExists_568822; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568835.validator(path, query, header, formData, body)
  let scheme = call_568835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568835.url(scheme.get, call_568835.host, call_568835.base,
                         call_568835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568835, url, valid)

proc call*(call_568836: Call_JobScheduleExists_568822; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleExists
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule which you want to check.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_568837 = newJObject()
  var query_568838 = newJObject()
  add(query_568838, "timeout", newJInt(timeout))
  add(path_568837, "jobScheduleId", newJString(jobScheduleId))
  add(query_568838, "api-version", newJString(apiVersion))
  result = call_568836.call(path_568837, query_568838, nil, nil, nil)

var jobScheduleExists* = Call_JobScheduleExists_568822(name: "jobScheduleExists",
    meth: HttpMethod.HttpHead, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleExists_568823,
    base: "", url: url_JobScheduleExists_568824, schemes: {Scheme.Https})
type
  Call_JobScheduleGet_568767 = ref object of OpenApiRestCall_567667
proc url_JobScheduleGet_568769(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleGet_568768(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the specified job schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the job schedule to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_568770 = path.getOrDefault("jobScheduleId")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "jobScheduleId", valid_568770
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
  var valid_568771 = query.getOrDefault("timeout")
  valid_568771 = validateParameter(valid_568771, JInt, required = false,
                                 default = newJInt(30))
  if valid_568771 != nil:
    section.add "timeout", valid_568771
  var valid_568772 = query.getOrDefault("$expand")
  valid_568772 = validateParameter(valid_568772, JString, required = false,
                                 default = nil)
  if valid_568772 != nil:
    section.add "$expand", valid_568772
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568773 = query.getOrDefault("api-version")
  valid_568773 = validateParameter(valid_568773, JString, required = true,
                                 default = nil)
  if valid_568773 != nil:
    section.add "api-version", valid_568773
  var valid_568774 = query.getOrDefault("$select")
  valid_568774 = validateParameter(valid_568774, JString, required = false,
                                 default = nil)
  if valid_568774 != nil:
    section.add "$select", valid_568774
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
  var valid_568775 = header.getOrDefault("If-Match")
  valid_568775 = validateParameter(valid_568775, JString, required = false,
                                 default = nil)
  if valid_568775 != nil:
    section.add "If-Match", valid_568775
  var valid_568776 = header.getOrDefault("client-request-id")
  valid_568776 = validateParameter(valid_568776, JString, required = false,
                                 default = nil)
  if valid_568776 != nil:
    section.add "client-request-id", valid_568776
  var valid_568777 = header.getOrDefault("ocp-date")
  valid_568777 = validateParameter(valid_568777, JString, required = false,
                                 default = nil)
  if valid_568777 != nil:
    section.add "ocp-date", valid_568777
  var valid_568778 = header.getOrDefault("If-Unmodified-Since")
  valid_568778 = validateParameter(valid_568778, JString, required = false,
                                 default = nil)
  if valid_568778 != nil:
    section.add "If-Unmodified-Since", valid_568778
  var valid_568779 = header.getOrDefault("If-None-Match")
  valid_568779 = validateParameter(valid_568779, JString, required = false,
                                 default = nil)
  if valid_568779 != nil:
    section.add "If-None-Match", valid_568779
  var valid_568780 = header.getOrDefault("If-Modified-Since")
  valid_568780 = validateParameter(valid_568780, JString, required = false,
                                 default = nil)
  if valid_568780 != nil:
    section.add "If-Modified-Since", valid_568780
  var valid_568781 = header.getOrDefault("return-client-request-id")
  valid_568781 = validateParameter(valid_568781, JBool, required = false,
                                 default = newJBool(false))
  if valid_568781 != nil:
    section.add "return-client-request-id", valid_568781
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568782: Call_JobScheduleGet_568767; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified job schedule.
  ## 
  let valid = call_568782.validator(path, query, header, formData, body)
  let scheme = call_568782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568782.url(scheme.get, call_568782.host, call_568782.base,
                         call_568782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568782, url, valid)

proc call*(call_568783: Call_JobScheduleGet_568767; jobScheduleId: string;
          apiVersion: string; timeout: int = 30; Expand: string = ""; Select: string = ""): Recallable =
  ## jobScheduleGet
  ## Gets information about the specified job schedule.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to get.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  var path_568784 = newJObject()
  var query_568785 = newJObject()
  add(query_568785, "timeout", newJInt(timeout))
  add(path_568784, "jobScheduleId", newJString(jobScheduleId))
  add(query_568785, "$expand", newJString(Expand))
  add(query_568785, "api-version", newJString(apiVersion))
  add(query_568785, "$select", newJString(Select))
  result = call_568783.call(path_568784, query_568785, nil, nil, nil)

var jobScheduleGet* = Call_JobScheduleGet_568767(name: "jobScheduleGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleGet_568768,
    base: "", url: url_JobScheduleGet_568769, schemes: {Scheme.Https})
type
  Call_JobSchedulePatch_568839 = ref object of OpenApiRestCall_567667
proc url_JobSchedulePatch_568841(protocol: Scheme; host: string; base: string;
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

proc validate_JobSchedulePatch_568840(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## This replaces only the job schedule properties specified in the request. For example, if the schedule property is not specified with this request, then the Batch service will keep the existing schedule. Changes to a job schedule only impact jobs created by the schedule after the update has taken place; currently running jobs are unaffected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the job schedule to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_568842 = path.getOrDefault("jobScheduleId")
  valid_568842 = validateParameter(valid_568842, JString, required = true,
                                 default = nil)
  if valid_568842 != nil:
    section.add "jobScheduleId", valid_568842
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568843 = query.getOrDefault("timeout")
  valid_568843 = validateParameter(valid_568843, JInt, required = false,
                                 default = newJInt(30))
  if valid_568843 != nil:
    section.add "timeout", valid_568843
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568844 = query.getOrDefault("api-version")
  valid_568844 = validateParameter(valid_568844, JString, required = true,
                                 default = nil)
  if valid_568844 != nil:
    section.add "api-version", valid_568844
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
  var valid_568845 = header.getOrDefault("If-Match")
  valid_568845 = validateParameter(valid_568845, JString, required = false,
                                 default = nil)
  if valid_568845 != nil:
    section.add "If-Match", valid_568845
  var valid_568846 = header.getOrDefault("client-request-id")
  valid_568846 = validateParameter(valid_568846, JString, required = false,
                                 default = nil)
  if valid_568846 != nil:
    section.add "client-request-id", valid_568846
  var valid_568847 = header.getOrDefault("ocp-date")
  valid_568847 = validateParameter(valid_568847, JString, required = false,
                                 default = nil)
  if valid_568847 != nil:
    section.add "ocp-date", valid_568847
  var valid_568848 = header.getOrDefault("If-Unmodified-Since")
  valid_568848 = validateParameter(valid_568848, JString, required = false,
                                 default = nil)
  if valid_568848 != nil:
    section.add "If-Unmodified-Since", valid_568848
  var valid_568849 = header.getOrDefault("If-None-Match")
  valid_568849 = validateParameter(valid_568849, JString, required = false,
                                 default = nil)
  if valid_568849 != nil:
    section.add "If-None-Match", valid_568849
  var valid_568850 = header.getOrDefault("If-Modified-Since")
  valid_568850 = validateParameter(valid_568850, JString, required = false,
                                 default = nil)
  if valid_568850 != nil:
    section.add "If-Modified-Since", valid_568850
  var valid_568851 = header.getOrDefault("return-client-request-id")
  valid_568851 = validateParameter(valid_568851, JBool, required = false,
                                 default = newJBool(false))
  if valid_568851 != nil:
    section.add "return-client-request-id", valid_568851
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

proc call*(call_568853: Call_JobSchedulePatch_568839; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This replaces only the job schedule properties specified in the request. For example, if the schedule property is not specified with this request, then the Batch service will keep the existing schedule. Changes to a job schedule only impact jobs created by the schedule after the update has taken place; currently running jobs are unaffected.
  ## 
  let valid = call_568853.validator(path, query, header, formData, body)
  let scheme = call_568853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568853.url(scheme.get, call_568853.host, call_568853.base,
                         call_568853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568853, url, valid)

proc call*(call_568854: Call_JobSchedulePatch_568839; jobScheduleId: string;
          apiVersion: string; jobSchedulePatchParameter: JsonNode; timeout: int = 30): Recallable =
  ## jobSchedulePatch
  ## This replaces only the job schedule properties specified in the request. For example, if the schedule property is not specified with this request, then the Batch service will keep the existing schedule. Changes to a job schedule only impact jobs created by the schedule after the update has taken place; currently running jobs are unaffected.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to update.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobSchedulePatchParameter: JObject (required)
  ##                            : The parameters for the request.
  var path_568855 = newJObject()
  var query_568856 = newJObject()
  var body_568857 = newJObject()
  add(query_568856, "timeout", newJInt(timeout))
  add(path_568855, "jobScheduleId", newJString(jobScheduleId))
  add(query_568856, "api-version", newJString(apiVersion))
  if jobSchedulePatchParameter != nil:
    body_568857 = jobSchedulePatchParameter
  result = call_568854.call(path_568855, query_568856, nil, nil, body_568857)

var jobSchedulePatch* = Call_JobSchedulePatch_568839(name: "jobSchedulePatch",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobSchedulePatch_568840,
    base: "", url: url_JobSchedulePatch_568841, schemes: {Scheme.Https})
type
  Call_JobScheduleDelete_568805 = ref object of OpenApiRestCall_567667
proc url_JobScheduleDelete_568807(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleDelete_568806(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## When you delete a job schedule, this also deletes all jobs and tasks under that schedule. When tasks are deleted, all the files in their working directories on the compute nodes are also deleted (the retention period is ignored). The job schedule statistics are no longer accessible once the job schedule is deleted, though they are still counted towards account lifetime statistics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the job schedule to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_568808 = path.getOrDefault("jobScheduleId")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = nil)
  if valid_568808 != nil:
    section.add "jobScheduleId", valid_568808
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568809 = query.getOrDefault("timeout")
  valid_568809 = validateParameter(valid_568809, JInt, required = false,
                                 default = newJInt(30))
  if valid_568809 != nil:
    section.add "timeout", valid_568809
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568810 = query.getOrDefault("api-version")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "api-version", valid_568810
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
  var valid_568811 = header.getOrDefault("If-Match")
  valid_568811 = validateParameter(valid_568811, JString, required = false,
                                 default = nil)
  if valid_568811 != nil:
    section.add "If-Match", valid_568811
  var valid_568812 = header.getOrDefault("client-request-id")
  valid_568812 = validateParameter(valid_568812, JString, required = false,
                                 default = nil)
  if valid_568812 != nil:
    section.add "client-request-id", valid_568812
  var valid_568813 = header.getOrDefault("ocp-date")
  valid_568813 = validateParameter(valid_568813, JString, required = false,
                                 default = nil)
  if valid_568813 != nil:
    section.add "ocp-date", valid_568813
  var valid_568814 = header.getOrDefault("If-Unmodified-Since")
  valid_568814 = validateParameter(valid_568814, JString, required = false,
                                 default = nil)
  if valid_568814 != nil:
    section.add "If-Unmodified-Since", valid_568814
  var valid_568815 = header.getOrDefault("If-None-Match")
  valid_568815 = validateParameter(valid_568815, JString, required = false,
                                 default = nil)
  if valid_568815 != nil:
    section.add "If-None-Match", valid_568815
  var valid_568816 = header.getOrDefault("If-Modified-Since")
  valid_568816 = validateParameter(valid_568816, JString, required = false,
                                 default = nil)
  if valid_568816 != nil:
    section.add "If-Modified-Since", valid_568816
  var valid_568817 = header.getOrDefault("return-client-request-id")
  valid_568817 = validateParameter(valid_568817, JBool, required = false,
                                 default = newJBool(false))
  if valid_568817 != nil:
    section.add "return-client-request-id", valid_568817
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568818: Call_JobScheduleDelete_568805; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you delete a job schedule, this also deletes all jobs and tasks under that schedule. When tasks are deleted, all the files in their working directories on the compute nodes are also deleted (the retention period is ignored). The job schedule statistics are no longer accessible once the job schedule is deleted, though they are still counted towards account lifetime statistics.
  ## 
  let valid = call_568818.validator(path, query, header, formData, body)
  let scheme = call_568818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568818.url(scheme.get, call_568818.host, call_568818.base,
                         call_568818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568818, url, valid)

proc call*(call_568819: Call_JobScheduleDelete_568805; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleDelete
  ## When you delete a job schedule, this also deletes all jobs and tasks under that schedule. When tasks are deleted, all the files in their working directories on the compute nodes are also deleted (the retention period is ignored). The job schedule statistics are no longer accessible once the job schedule is deleted, though they are still counted towards account lifetime statistics.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to delete.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_568820 = newJObject()
  var query_568821 = newJObject()
  add(query_568821, "timeout", newJInt(timeout))
  add(path_568820, "jobScheduleId", newJString(jobScheduleId))
  add(query_568821, "api-version", newJString(apiVersion))
  result = call_568819.call(path_568820, query_568821, nil, nil, nil)

var jobScheduleDelete* = Call_JobScheduleDelete_568805(name: "jobScheduleDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleDelete_568806,
    base: "", url: url_JobScheduleDelete_568807, schemes: {Scheme.Https})
type
  Call_JobScheduleDisable_568858 = ref object of OpenApiRestCall_567667
proc url_JobScheduleDisable_568860(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleDisable_568859(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## No new jobs will be created until the job schedule is enabled again.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the job schedule to disable.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_568861 = path.getOrDefault("jobScheduleId")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "jobScheduleId", valid_568861
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568862 = query.getOrDefault("timeout")
  valid_568862 = validateParameter(valid_568862, JInt, required = false,
                                 default = newJInt(30))
  if valid_568862 != nil:
    section.add "timeout", valid_568862
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568863 = query.getOrDefault("api-version")
  valid_568863 = validateParameter(valid_568863, JString, required = true,
                                 default = nil)
  if valid_568863 != nil:
    section.add "api-version", valid_568863
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
  var valid_568864 = header.getOrDefault("If-Match")
  valid_568864 = validateParameter(valid_568864, JString, required = false,
                                 default = nil)
  if valid_568864 != nil:
    section.add "If-Match", valid_568864
  var valid_568865 = header.getOrDefault("client-request-id")
  valid_568865 = validateParameter(valid_568865, JString, required = false,
                                 default = nil)
  if valid_568865 != nil:
    section.add "client-request-id", valid_568865
  var valid_568866 = header.getOrDefault("ocp-date")
  valid_568866 = validateParameter(valid_568866, JString, required = false,
                                 default = nil)
  if valid_568866 != nil:
    section.add "ocp-date", valid_568866
  var valid_568867 = header.getOrDefault("If-Unmodified-Since")
  valid_568867 = validateParameter(valid_568867, JString, required = false,
                                 default = nil)
  if valid_568867 != nil:
    section.add "If-Unmodified-Since", valid_568867
  var valid_568868 = header.getOrDefault("If-None-Match")
  valid_568868 = validateParameter(valid_568868, JString, required = false,
                                 default = nil)
  if valid_568868 != nil:
    section.add "If-None-Match", valid_568868
  var valid_568869 = header.getOrDefault("If-Modified-Since")
  valid_568869 = validateParameter(valid_568869, JString, required = false,
                                 default = nil)
  if valid_568869 != nil:
    section.add "If-Modified-Since", valid_568869
  var valid_568870 = header.getOrDefault("return-client-request-id")
  valid_568870 = validateParameter(valid_568870, JBool, required = false,
                                 default = newJBool(false))
  if valid_568870 != nil:
    section.add "return-client-request-id", valid_568870
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568871: Call_JobScheduleDisable_568858; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## No new jobs will be created until the job schedule is enabled again.
  ## 
  let valid = call_568871.validator(path, query, header, formData, body)
  let scheme = call_568871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568871.url(scheme.get, call_568871.host, call_568871.base,
                         call_568871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568871, url, valid)

proc call*(call_568872: Call_JobScheduleDisable_568858; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleDisable
  ## No new jobs will be created until the job schedule is enabled again.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to disable.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_568873 = newJObject()
  var query_568874 = newJObject()
  add(query_568874, "timeout", newJInt(timeout))
  add(path_568873, "jobScheduleId", newJString(jobScheduleId))
  add(query_568874, "api-version", newJString(apiVersion))
  result = call_568872.call(path_568873, query_568874, nil, nil, nil)

var jobScheduleDisable* = Call_JobScheduleDisable_568858(
    name: "jobScheduleDisable", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/disable",
    validator: validate_JobScheduleDisable_568859, base: "",
    url: url_JobScheduleDisable_568860, schemes: {Scheme.Https})
type
  Call_JobScheduleEnable_568875 = ref object of OpenApiRestCall_567667
proc url_JobScheduleEnable_568877(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleEnable_568876(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the job schedule to enable.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_568878 = path.getOrDefault("jobScheduleId")
  valid_568878 = validateParameter(valid_568878, JString, required = true,
                                 default = nil)
  if valid_568878 != nil:
    section.add "jobScheduleId", valid_568878
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568879 = query.getOrDefault("timeout")
  valid_568879 = validateParameter(valid_568879, JInt, required = false,
                                 default = newJInt(30))
  if valid_568879 != nil:
    section.add "timeout", valid_568879
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568880 = query.getOrDefault("api-version")
  valid_568880 = validateParameter(valid_568880, JString, required = true,
                                 default = nil)
  if valid_568880 != nil:
    section.add "api-version", valid_568880
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
  var valid_568881 = header.getOrDefault("If-Match")
  valid_568881 = validateParameter(valid_568881, JString, required = false,
                                 default = nil)
  if valid_568881 != nil:
    section.add "If-Match", valid_568881
  var valid_568882 = header.getOrDefault("client-request-id")
  valid_568882 = validateParameter(valid_568882, JString, required = false,
                                 default = nil)
  if valid_568882 != nil:
    section.add "client-request-id", valid_568882
  var valid_568883 = header.getOrDefault("ocp-date")
  valid_568883 = validateParameter(valid_568883, JString, required = false,
                                 default = nil)
  if valid_568883 != nil:
    section.add "ocp-date", valid_568883
  var valid_568884 = header.getOrDefault("If-Unmodified-Since")
  valid_568884 = validateParameter(valid_568884, JString, required = false,
                                 default = nil)
  if valid_568884 != nil:
    section.add "If-Unmodified-Since", valid_568884
  var valid_568885 = header.getOrDefault("If-None-Match")
  valid_568885 = validateParameter(valid_568885, JString, required = false,
                                 default = nil)
  if valid_568885 != nil:
    section.add "If-None-Match", valid_568885
  var valid_568886 = header.getOrDefault("If-Modified-Since")
  valid_568886 = validateParameter(valid_568886, JString, required = false,
                                 default = nil)
  if valid_568886 != nil:
    section.add "If-Modified-Since", valid_568886
  var valid_568887 = header.getOrDefault("return-client-request-id")
  valid_568887 = validateParameter(valid_568887, JBool, required = false,
                                 default = newJBool(false))
  if valid_568887 != nil:
    section.add "return-client-request-id", valid_568887
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568888: Call_JobScheduleEnable_568875; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568888.validator(path, query, header, formData, body)
  let scheme = call_568888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568888.url(scheme.get, call_568888.host, call_568888.base,
                         call_568888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568888, url, valid)

proc call*(call_568889: Call_JobScheduleEnable_568875; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleEnable
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to enable.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_568890 = newJObject()
  var query_568891 = newJObject()
  add(query_568891, "timeout", newJInt(timeout))
  add(path_568890, "jobScheduleId", newJString(jobScheduleId))
  add(query_568891, "api-version", newJString(apiVersion))
  result = call_568889.call(path_568890, query_568891, nil, nil, nil)

var jobScheduleEnable* = Call_JobScheduleEnable_568875(name: "jobScheduleEnable",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/enable",
    validator: validate_JobScheduleEnable_568876, base: "",
    url: url_JobScheduleEnable_568877, schemes: {Scheme.Https})
type
  Call_JobListFromJobSchedule_568892 = ref object of OpenApiRestCall_567667
proc url_JobListFromJobSchedule_568894(protocol: Scheme; host: string; base: string;
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

proc validate_JobListFromJobSchedule_568893(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the job schedule from which you want to get a list of jobs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_568895 = path.getOrDefault("jobScheduleId")
  valid_568895 = validateParameter(valid_568895, JString, required = true,
                                 default = nil)
  if valid_568895 != nil:
    section.add "jobScheduleId", valid_568895
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 jobs can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs-in-a-job-schedule.
  section = newJObject()
  var valid_568896 = query.getOrDefault("timeout")
  valid_568896 = validateParameter(valid_568896, JInt, required = false,
                                 default = newJInt(30))
  if valid_568896 != nil:
    section.add "timeout", valid_568896
  var valid_568897 = query.getOrDefault("$expand")
  valid_568897 = validateParameter(valid_568897, JString, required = false,
                                 default = nil)
  if valid_568897 != nil:
    section.add "$expand", valid_568897
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568898 = query.getOrDefault("api-version")
  valid_568898 = validateParameter(valid_568898, JString, required = true,
                                 default = nil)
  if valid_568898 != nil:
    section.add "api-version", valid_568898
  var valid_568899 = query.getOrDefault("maxresults")
  valid_568899 = validateParameter(valid_568899, JInt, required = false,
                                 default = newJInt(1000))
  if valid_568899 != nil:
    section.add "maxresults", valid_568899
  var valid_568900 = query.getOrDefault("$select")
  valid_568900 = validateParameter(valid_568900, JString, required = false,
                                 default = nil)
  if valid_568900 != nil:
    section.add "$select", valid_568900
  var valid_568901 = query.getOrDefault("$filter")
  valid_568901 = validateParameter(valid_568901, JString, required = false,
                                 default = nil)
  if valid_568901 != nil:
    section.add "$filter", valid_568901
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568902 = header.getOrDefault("client-request-id")
  valid_568902 = validateParameter(valid_568902, JString, required = false,
                                 default = nil)
  if valid_568902 != nil:
    section.add "client-request-id", valid_568902
  var valid_568903 = header.getOrDefault("ocp-date")
  valid_568903 = validateParameter(valid_568903, JString, required = false,
                                 default = nil)
  if valid_568903 != nil:
    section.add "ocp-date", valid_568903
  var valid_568904 = header.getOrDefault("return-client-request-id")
  valid_568904 = validateParameter(valid_568904, JBool, required = false,
                                 default = newJBool(false))
  if valid_568904 != nil:
    section.add "return-client-request-id", valid_568904
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568905: Call_JobListFromJobSchedule_568892; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568905.validator(path, query, header, formData, body)
  let scheme = call_568905.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568905.url(scheme.get, call_568905.host, call_568905.base,
                         call_568905.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568905, url, valid)

proc call*(call_568906: Call_JobListFromJobSchedule_568892; jobScheduleId: string;
          apiVersion: string; timeout: int = 30; Expand: string = "";
          maxresults: int = 1000; Select: string = ""; Filter: string = ""): Recallable =
  ## jobListFromJobSchedule
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule from which you want to get a list of jobs.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 jobs can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs-in-a-job-schedule.
  var path_568907 = newJObject()
  var query_568908 = newJObject()
  add(query_568908, "timeout", newJInt(timeout))
  add(path_568907, "jobScheduleId", newJString(jobScheduleId))
  add(query_568908, "$expand", newJString(Expand))
  add(query_568908, "api-version", newJString(apiVersion))
  add(query_568908, "maxresults", newJInt(maxresults))
  add(query_568908, "$select", newJString(Select))
  add(query_568908, "$filter", newJString(Filter))
  result = call_568906.call(path_568907, query_568908, nil, nil, nil)

var jobListFromJobSchedule* = Call_JobListFromJobSchedule_568892(
    name: "jobListFromJobSchedule", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/jobs",
    validator: validate_JobListFromJobSchedule_568893, base: "",
    url: url_JobListFromJobSchedule_568894, schemes: {Scheme.Https})
type
  Call_JobScheduleTerminate_568909 = ref object of OpenApiRestCall_567667
proc url_JobScheduleTerminate_568911(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleTerminate_568910(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the job schedule to terminates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_568912 = path.getOrDefault("jobScheduleId")
  valid_568912 = validateParameter(valid_568912, JString, required = true,
                                 default = nil)
  if valid_568912 != nil:
    section.add "jobScheduleId", valid_568912
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_568913 = query.getOrDefault("timeout")
  valid_568913 = validateParameter(valid_568913, JInt, required = false,
                                 default = newJInt(30))
  if valid_568913 != nil:
    section.add "timeout", valid_568913
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568914 = query.getOrDefault("api-version")
  valid_568914 = validateParameter(valid_568914, JString, required = true,
                                 default = nil)
  if valid_568914 != nil:
    section.add "api-version", valid_568914
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
  var valid_568915 = header.getOrDefault("If-Match")
  valid_568915 = validateParameter(valid_568915, JString, required = false,
                                 default = nil)
  if valid_568915 != nil:
    section.add "If-Match", valid_568915
  var valid_568916 = header.getOrDefault("client-request-id")
  valid_568916 = validateParameter(valid_568916, JString, required = false,
                                 default = nil)
  if valid_568916 != nil:
    section.add "client-request-id", valid_568916
  var valid_568917 = header.getOrDefault("ocp-date")
  valid_568917 = validateParameter(valid_568917, JString, required = false,
                                 default = nil)
  if valid_568917 != nil:
    section.add "ocp-date", valid_568917
  var valid_568918 = header.getOrDefault("If-Unmodified-Since")
  valid_568918 = validateParameter(valid_568918, JString, required = false,
                                 default = nil)
  if valid_568918 != nil:
    section.add "If-Unmodified-Since", valid_568918
  var valid_568919 = header.getOrDefault("If-None-Match")
  valid_568919 = validateParameter(valid_568919, JString, required = false,
                                 default = nil)
  if valid_568919 != nil:
    section.add "If-None-Match", valid_568919
  var valid_568920 = header.getOrDefault("If-Modified-Since")
  valid_568920 = validateParameter(valid_568920, JString, required = false,
                                 default = nil)
  if valid_568920 != nil:
    section.add "If-Modified-Since", valid_568920
  var valid_568921 = header.getOrDefault("return-client-request-id")
  valid_568921 = validateParameter(valid_568921, JBool, required = false,
                                 default = newJBool(false))
  if valid_568921 != nil:
    section.add "return-client-request-id", valid_568921
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568922: Call_JobScheduleTerminate_568909; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568922.validator(path, query, header, formData, body)
  let scheme = call_568922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568922.url(scheme.get, call_568922.host, call_568922.base,
                         call_568922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568922, url, valid)

proc call*(call_568923: Call_JobScheduleTerminate_568909; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleTerminate
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to terminates.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_568924 = newJObject()
  var query_568925 = newJObject()
  add(query_568925, "timeout", newJInt(timeout))
  add(path_568924, "jobScheduleId", newJString(jobScheduleId))
  add(query_568925, "api-version", newJString(apiVersion))
  result = call_568923.call(path_568924, query_568925, nil, nil, nil)

var jobScheduleTerminate* = Call_JobScheduleTerminate_568909(
    name: "jobScheduleTerminate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/terminate",
    validator: validate_JobScheduleTerminate_568910, base: "",
    url: url_JobScheduleTerminate_568911, schemes: {Scheme.Https})
type
  Call_JobGetAllLifetimeStatistics_568926 = ref object of OpenApiRestCall_567667
proc url_JobGetAllLifetimeStatistics_568928(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobGetAllLifetimeStatistics_568927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Statistics are aggregated across all jobs that have ever existed in the account, from account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
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
  var valid_568929 = query.getOrDefault("timeout")
  valid_568929 = validateParameter(valid_568929, JInt, required = false,
                                 default = newJInt(30))
  if valid_568929 != nil:
    section.add "timeout", valid_568929
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568930 = query.getOrDefault("api-version")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = nil)
  if valid_568930 != nil:
    section.add "api-version", valid_568930
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568931 = header.getOrDefault("client-request-id")
  valid_568931 = validateParameter(valid_568931, JString, required = false,
                                 default = nil)
  if valid_568931 != nil:
    section.add "client-request-id", valid_568931
  var valid_568932 = header.getOrDefault("ocp-date")
  valid_568932 = validateParameter(valid_568932, JString, required = false,
                                 default = nil)
  if valid_568932 != nil:
    section.add "ocp-date", valid_568932
  var valid_568933 = header.getOrDefault("return-client-request-id")
  valid_568933 = validateParameter(valid_568933, JBool, required = false,
                                 default = newJBool(false))
  if valid_568933 != nil:
    section.add "return-client-request-id", valid_568933
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568934: Call_JobGetAllLifetimeStatistics_568926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Statistics are aggregated across all jobs that have ever existed in the account, from account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ## 
  let valid = call_568934.validator(path, query, header, formData, body)
  let scheme = call_568934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568934.url(scheme.get, call_568934.host, call_568934.base,
                         call_568934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568934, url, valid)

proc call*(call_568935: Call_JobGetAllLifetimeStatistics_568926;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobGetAllLifetimeStatistics
  ## Statistics are aggregated across all jobs that have ever existed in the account, from account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_568936 = newJObject()
  add(query_568936, "timeout", newJInt(timeout))
  add(query_568936, "api-version", newJString(apiVersion))
  result = call_568935.call(nil, query_568936, nil, nil, nil)

var jobGetAllLifetimeStatistics* = Call_JobGetAllLifetimeStatistics_568926(
    name: "jobGetAllLifetimeStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/lifetimejobstats",
    validator: validate_JobGetAllLifetimeStatistics_568927, base: "",
    url: url_JobGetAllLifetimeStatistics_568928, schemes: {Scheme.Https})
type
  Call_PoolGetAllLifetimeStatistics_568937 = ref object of OpenApiRestCall_567667
proc url_PoolGetAllLifetimeStatistics_568939(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolGetAllLifetimeStatistics_568938(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Statistics are aggregated across all pools that have ever existed in the account, from account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
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
  var valid_568940 = query.getOrDefault("timeout")
  valid_568940 = validateParameter(valid_568940, JInt, required = false,
                                 default = newJInt(30))
  if valid_568940 != nil:
    section.add "timeout", valid_568940
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568941 = query.getOrDefault("api-version")
  valid_568941 = validateParameter(valid_568941, JString, required = true,
                                 default = nil)
  if valid_568941 != nil:
    section.add "api-version", valid_568941
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568942 = header.getOrDefault("client-request-id")
  valid_568942 = validateParameter(valid_568942, JString, required = false,
                                 default = nil)
  if valid_568942 != nil:
    section.add "client-request-id", valid_568942
  var valid_568943 = header.getOrDefault("ocp-date")
  valid_568943 = validateParameter(valid_568943, JString, required = false,
                                 default = nil)
  if valid_568943 != nil:
    section.add "ocp-date", valid_568943
  var valid_568944 = header.getOrDefault("return-client-request-id")
  valid_568944 = validateParameter(valid_568944, JBool, required = false,
                                 default = newJBool(false))
  if valid_568944 != nil:
    section.add "return-client-request-id", valid_568944
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568945: Call_PoolGetAllLifetimeStatistics_568937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Statistics are aggregated across all pools that have ever existed in the account, from account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ## 
  let valid = call_568945.validator(path, query, header, formData, body)
  let scheme = call_568945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568945.url(scheme.get, call_568945.host, call_568945.base,
                         call_568945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568945, url, valid)

proc call*(call_568946: Call_PoolGetAllLifetimeStatistics_568937;
          apiVersion: string; timeout: int = 30): Recallable =
  ## poolGetAllLifetimeStatistics
  ## Statistics are aggregated across all pools that have ever existed in the account, from account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_568947 = newJObject()
  add(query_568947, "timeout", newJInt(timeout))
  add(query_568947, "api-version", newJString(apiVersion))
  result = call_568946.call(nil, query_568947, nil, nil, nil)

var poolGetAllLifetimeStatistics* = Call_PoolGetAllLifetimeStatistics_568937(
    name: "poolGetAllLifetimeStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/lifetimepoolstats",
    validator: validate_PoolGetAllLifetimeStatistics_568938, base: "",
    url: url_PoolGetAllLifetimeStatistics_568939, schemes: {Scheme.Https})
type
  Call_AccountListNodeAgentSkus_568948 = ref object of OpenApiRestCall_567667
proc url_AccountListNodeAgentSkus_568950(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccountListNodeAgentSkus_568949(path: JsonNode; query: JsonNode;
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
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-node-agent-skus.
  section = newJObject()
  var valid_568951 = query.getOrDefault("timeout")
  valid_568951 = validateParameter(valid_568951, JInt, required = false,
                                 default = newJInt(30))
  if valid_568951 != nil:
    section.add "timeout", valid_568951
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568952 = query.getOrDefault("api-version")
  valid_568952 = validateParameter(valid_568952, JString, required = true,
                                 default = nil)
  if valid_568952 != nil:
    section.add "api-version", valid_568952
  var valid_568953 = query.getOrDefault("maxresults")
  valid_568953 = validateParameter(valid_568953, JInt, required = false,
                                 default = newJInt(1000))
  if valid_568953 != nil:
    section.add "maxresults", valid_568953
  var valid_568954 = query.getOrDefault("$filter")
  valid_568954 = validateParameter(valid_568954, JString, required = false,
                                 default = nil)
  if valid_568954 != nil:
    section.add "$filter", valid_568954
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568955 = header.getOrDefault("client-request-id")
  valid_568955 = validateParameter(valid_568955, JString, required = false,
                                 default = nil)
  if valid_568955 != nil:
    section.add "client-request-id", valid_568955
  var valid_568956 = header.getOrDefault("ocp-date")
  valid_568956 = validateParameter(valid_568956, JString, required = false,
                                 default = nil)
  if valid_568956 != nil:
    section.add "ocp-date", valid_568956
  var valid_568957 = header.getOrDefault("return-client-request-id")
  valid_568957 = validateParameter(valid_568957, JBool, required = false,
                                 default = newJBool(false))
  if valid_568957 != nil:
    section.add "return-client-request-id", valid_568957
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568958: Call_AccountListNodeAgentSkus_568948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568958.validator(path, query, header, formData, body)
  let scheme = call_568958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568958.url(scheme.get, call_568958.host, call_568958.base,
                         call_568958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568958, url, valid)

proc call*(call_568959: Call_AccountListNodeAgentSkus_568948; apiVersion: string;
          timeout: int = 30; maxresults: int = 1000; Filter: string = ""): Recallable =
  ## accountListNodeAgentSkus
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 results will be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-node-agent-skus.
  var query_568960 = newJObject()
  add(query_568960, "timeout", newJInt(timeout))
  add(query_568960, "api-version", newJString(apiVersion))
  add(query_568960, "maxresults", newJInt(maxresults))
  add(query_568960, "$filter", newJString(Filter))
  result = call_568959.call(nil, query_568960, nil, nil, nil)

var accountListNodeAgentSkus* = Call_AccountListNodeAgentSkus_568948(
    name: "accountListNodeAgentSkus", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/nodeagentskus", validator: validate_AccountListNodeAgentSkus_568949,
    base: "", url: url_AccountListNodeAgentSkus_568950, schemes: {Scheme.Https})
type
  Call_AccountListPoolNodeCounts_568961 = ref object of OpenApiRestCall_567667
proc url_AccountListPoolNodeCounts_568963(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccountListPoolNodeCounts_568962(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the number of nodes in each state, grouped by pool.
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
  var valid_568964 = query.getOrDefault("timeout")
  valid_568964 = validateParameter(valid_568964, JInt, required = false,
                                 default = newJInt(30))
  if valid_568964 != nil:
    section.add "timeout", valid_568964
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568965 = query.getOrDefault("api-version")
  valid_568965 = validateParameter(valid_568965, JString, required = true,
                                 default = nil)
  if valid_568965 != nil:
    section.add "api-version", valid_568965
  var valid_568966 = query.getOrDefault("maxresults")
  valid_568966 = validateParameter(valid_568966, JInt, required = false,
                                 default = newJInt(10))
  if valid_568966 != nil:
    section.add "maxresults", valid_568966
  var valid_568967 = query.getOrDefault("$filter")
  valid_568967 = validateParameter(valid_568967, JString, required = false,
                                 default = nil)
  if valid_568967 != nil:
    section.add "$filter", valid_568967
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568968 = header.getOrDefault("client-request-id")
  valid_568968 = validateParameter(valid_568968, JString, required = false,
                                 default = nil)
  if valid_568968 != nil:
    section.add "client-request-id", valid_568968
  var valid_568969 = header.getOrDefault("ocp-date")
  valid_568969 = validateParameter(valid_568969, JString, required = false,
                                 default = nil)
  if valid_568969 != nil:
    section.add "ocp-date", valid_568969
  var valid_568970 = header.getOrDefault("return-client-request-id")
  valid_568970 = validateParameter(valid_568970, JBool, required = false,
                                 default = newJBool(false))
  if valid_568970 != nil:
    section.add "return-client-request-id", valid_568970
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568971: Call_AccountListPoolNodeCounts_568961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the number of nodes in each state, grouped by pool.
  ## 
  let valid = call_568971.validator(path, query, header, formData, body)
  let scheme = call_568971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568971.url(scheme.get, call_568971.host, call_568971.base,
                         call_568971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568971, url, valid)

proc call*(call_568972: Call_AccountListPoolNodeCounts_568961; apiVersion: string;
          timeout: int = 30; maxresults: int = 10; Filter: string = ""): Recallable =
  ## accountListPoolNodeCounts
  ## Gets the number of nodes in each state, grouped by pool.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch.
  var query_568973 = newJObject()
  add(query_568973, "timeout", newJInt(timeout))
  add(query_568973, "api-version", newJString(apiVersion))
  add(query_568973, "maxresults", newJInt(maxresults))
  add(query_568973, "$filter", newJString(Filter))
  result = call_568972.call(nil, query_568973, nil, nil, nil)

var accountListPoolNodeCounts* = Call_AccountListPoolNodeCounts_568961(
    name: "accountListPoolNodeCounts", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/nodecounts",
    validator: validate_AccountListPoolNodeCounts_568962, base: "",
    url: url_AccountListPoolNodeCounts_568963, schemes: {Scheme.Https})
type
  Call_PoolAdd_568989 = ref object of OpenApiRestCall_567667
proc url_PoolAdd_568991(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolAdd_568990(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## When naming pools, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
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
  var valid_568992 = query.getOrDefault("timeout")
  valid_568992 = validateParameter(valid_568992, JInt, required = false,
                                 default = newJInt(30))
  if valid_568992 != nil:
    section.add "timeout", valid_568992
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568993 = query.getOrDefault("api-version")
  valid_568993 = validateParameter(valid_568993, JString, required = true,
                                 default = nil)
  if valid_568993 != nil:
    section.add "api-version", valid_568993
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568994 = header.getOrDefault("client-request-id")
  valid_568994 = validateParameter(valid_568994, JString, required = false,
                                 default = nil)
  if valid_568994 != nil:
    section.add "client-request-id", valid_568994
  var valid_568995 = header.getOrDefault("ocp-date")
  valid_568995 = validateParameter(valid_568995, JString, required = false,
                                 default = nil)
  if valid_568995 != nil:
    section.add "ocp-date", valid_568995
  var valid_568996 = header.getOrDefault("return-client-request-id")
  valid_568996 = validateParameter(valid_568996, JBool, required = false,
                                 default = newJBool(false))
  if valid_568996 != nil:
    section.add "return-client-request-id", valid_568996
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pool: JObject (required)
  ##       : The pool to be added.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568998: Call_PoolAdd_568989; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When naming pools, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ## 
  let valid = call_568998.validator(path, query, header, formData, body)
  let scheme = call_568998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568998.url(scheme.get, call_568998.host, call_568998.base,
                         call_568998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568998, url, valid)

proc call*(call_568999: Call_PoolAdd_568989; pool: JsonNode; apiVersion: string;
          timeout: int = 30): Recallable =
  ## poolAdd
  ## When naming pools, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   pool: JObject (required)
  ##       : The pool to be added.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_569000 = newJObject()
  var body_569001 = newJObject()
  add(query_569000, "timeout", newJInt(timeout))
  if pool != nil:
    body_569001 = pool
  add(query_569000, "api-version", newJString(apiVersion))
  result = call_568999.call(nil, query_569000, nil, nil, body_569001)

var poolAdd* = Call_PoolAdd_568989(name: "poolAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/pools",
                                validator: validate_PoolAdd_568990, base: "",
                                url: url_PoolAdd_568991, schemes: {Scheme.Https})
type
  Call_PoolList_568974 = ref object of OpenApiRestCall_567667
proc url_PoolList_568976(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolList_568975(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##             : The maximum number of items to return in the response. A maximum of 1000 pools can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-pools.
  section = newJObject()
  var valid_568977 = query.getOrDefault("timeout")
  valid_568977 = validateParameter(valid_568977, JInt, required = false,
                                 default = newJInt(30))
  if valid_568977 != nil:
    section.add "timeout", valid_568977
  var valid_568978 = query.getOrDefault("$expand")
  valid_568978 = validateParameter(valid_568978, JString, required = false,
                                 default = nil)
  if valid_568978 != nil:
    section.add "$expand", valid_568978
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568979 = query.getOrDefault("api-version")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "api-version", valid_568979
  var valid_568980 = query.getOrDefault("maxresults")
  valid_568980 = validateParameter(valid_568980, JInt, required = false,
                                 default = newJInt(1000))
  if valid_568980 != nil:
    section.add "maxresults", valid_568980
  var valid_568981 = query.getOrDefault("$select")
  valid_568981 = validateParameter(valid_568981, JString, required = false,
                                 default = nil)
  if valid_568981 != nil:
    section.add "$select", valid_568981
  var valid_568982 = query.getOrDefault("$filter")
  valid_568982 = validateParameter(valid_568982, JString, required = false,
                                 default = nil)
  if valid_568982 != nil:
    section.add "$filter", valid_568982
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_568983 = header.getOrDefault("client-request-id")
  valid_568983 = validateParameter(valid_568983, JString, required = false,
                                 default = nil)
  if valid_568983 != nil:
    section.add "client-request-id", valid_568983
  var valid_568984 = header.getOrDefault("ocp-date")
  valid_568984 = validateParameter(valid_568984, JString, required = false,
                                 default = nil)
  if valid_568984 != nil:
    section.add "ocp-date", valid_568984
  var valid_568985 = header.getOrDefault("return-client-request-id")
  valid_568985 = validateParameter(valid_568985, JBool, required = false,
                                 default = newJBool(false))
  if valid_568985 != nil:
    section.add "return-client-request-id", valid_568985
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568986: Call_PoolList_568974; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568986.validator(path, query, header, formData, body)
  let scheme = call_568986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568986.url(scheme.get, call_568986.host, call_568986.base,
                         call_568986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568986, url, valid)

proc call*(call_568987: Call_PoolList_568974; apiVersion: string; timeout: int = 30;
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
  ##             : The maximum number of items to return in the response. A maximum of 1000 pools can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-pools.
  var query_568988 = newJObject()
  add(query_568988, "timeout", newJInt(timeout))
  add(query_568988, "$expand", newJString(Expand))
  add(query_568988, "api-version", newJString(apiVersion))
  add(query_568988, "maxresults", newJInt(maxresults))
  add(query_568988, "$select", newJString(Select))
  add(query_568988, "$filter", newJString(Filter))
  result = call_568987.call(nil, query_568988, nil, nil, nil)

var poolList* = Call_PoolList_568974(name: "poolList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/pools",
                                  validator: validate_PoolList_568975, base: "",
                                  url: url_PoolList_568976,
                                  schemes: {Scheme.Https})
type
  Call_PoolExists_569038 = ref object of OpenApiRestCall_567667
proc url_PoolExists_569040(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolExists_569039(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets basic properties of a pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569041 = path.getOrDefault("poolId")
  valid_569041 = validateParameter(valid_569041, JString, required = true,
                                 default = nil)
  if valid_569041 != nil:
    section.add "poolId", valid_569041
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569042 = query.getOrDefault("timeout")
  valid_569042 = validateParameter(valid_569042, JInt, required = false,
                                 default = newJInt(30))
  if valid_569042 != nil:
    section.add "timeout", valid_569042
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569043 = query.getOrDefault("api-version")
  valid_569043 = validateParameter(valid_569043, JString, required = true,
                                 default = nil)
  if valid_569043 != nil:
    section.add "api-version", valid_569043
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
  var valid_569044 = header.getOrDefault("If-Match")
  valid_569044 = validateParameter(valid_569044, JString, required = false,
                                 default = nil)
  if valid_569044 != nil:
    section.add "If-Match", valid_569044
  var valid_569045 = header.getOrDefault("client-request-id")
  valid_569045 = validateParameter(valid_569045, JString, required = false,
                                 default = nil)
  if valid_569045 != nil:
    section.add "client-request-id", valid_569045
  var valid_569046 = header.getOrDefault("ocp-date")
  valid_569046 = validateParameter(valid_569046, JString, required = false,
                                 default = nil)
  if valid_569046 != nil:
    section.add "ocp-date", valid_569046
  var valid_569047 = header.getOrDefault("If-Unmodified-Since")
  valid_569047 = validateParameter(valid_569047, JString, required = false,
                                 default = nil)
  if valid_569047 != nil:
    section.add "If-Unmodified-Since", valid_569047
  var valid_569048 = header.getOrDefault("If-None-Match")
  valid_569048 = validateParameter(valid_569048, JString, required = false,
                                 default = nil)
  if valid_569048 != nil:
    section.add "If-None-Match", valid_569048
  var valid_569049 = header.getOrDefault("If-Modified-Since")
  valid_569049 = validateParameter(valid_569049, JString, required = false,
                                 default = nil)
  if valid_569049 != nil:
    section.add "If-Modified-Since", valid_569049
  var valid_569050 = header.getOrDefault("return-client-request-id")
  valid_569050 = validateParameter(valid_569050, JBool, required = false,
                                 default = newJBool(false))
  if valid_569050 != nil:
    section.add "return-client-request-id", valid_569050
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569051: Call_PoolExists_569038; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets basic properties of a pool.
  ## 
  let valid = call_569051.validator(path, query, header, formData, body)
  let scheme = call_569051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569051.url(scheme.get, call_569051.host, call_569051.base,
                         call_569051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569051, url, valid)

proc call*(call_569052: Call_PoolExists_569038; apiVersion: string; poolId: string;
          timeout: int = 30): Recallable =
  ## poolExists
  ## Gets basic properties of a pool.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool to get.
  var path_569053 = newJObject()
  var query_569054 = newJObject()
  add(query_569054, "timeout", newJInt(timeout))
  add(query_569054, "api-version", newJString(apiVersion))
  add(path_569053, "poolId", newJString(poolId))
  result = call_569052.call(path_569053, query_569054, nil, nil, nil)

var poolExists* = Call_PoolExists_569038(name: "poolExists",
                                      meth: HttpMethod.HttpHead,
                                      host: "azure.local",
                                      route: "/pools/{poolId}",
                                      validator: validate_PoolExists_569039,
                                      base: "", url: url_PoolExists_569040,
                                      schemes: {Scheme.Https})
type
  Call_PoolGet_569002 = ref object of OpenApiRestCall_567667
proc url_PoolGet_569004(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolGet_569003(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569005 = path.getOrDefault("poolId")
  valid_569005 = validateParameter(valid_569005, JString, required = true,
                                 default = nil)
  if valid_569005 != nil:
    section.add "poolId", valid_569005
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
  var valid_569006 = query.getOrDefault("timeout")
  valid_569006 = validateParameter(valid_569006, JInt, required = false,
                                 default = newJInt(30))
  if valid_569006 != nil:
    section.add "timeout", valid_569006
  var valid_569007 = query.getOrDefault("$expand")
  valid_569007 = validateParameter(valid_569007, JString, required = false,
                                 default = nil)
  if valid_569007 != nil:
    section.add "$expand", valid_569007
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569008 = query.getOrDefault("api-version")
  valid_569008 = validateParameter(valid_569008, JString, required = true,
                                 default = nil)
  if valid_569008 != nil:
    section.add "api-version", valid_569008
  var valid_569009 = query.getOrDefault("$select")
  valid_569009 = validateParameter(valid_569009, JString, required = false,
                                 default = nil)
  if valid_569009 != nil:
    section.add "$select", valid_569009
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
  var valid_569010 = header.getOrDefault("If-Match")
  valid_569010 = validateParameter(valid_569010, JString, required = false,
                                 default = nil)
  if valid_569010 != nil:
    section.add "If-Match", valid_569010
  var valid_569011 = header.getOrDefault("client-request-id")
  valid_569011 = validateParameter(valid_569011, JString, required = false,
                                 default = nil)
  if valid_569011 != nil:
    section.add "client-request-id", valid_569011
  var valid_569012 = header.getOrDefault("ocp-date")
  valid_569012 = validateParameter(valid_569012, JString, required = false,
                                 default = nil)
  if valid_569012 != nil:
    section.add "ocp-date", valid_569012
  var valid_569013 = header.getOrDefault("If-Unmodified-Since")
  valid_569013 = validateParameter(valid_569013, JString, required = false,
                                 default = nil)
  if valid_569013 != nil:
    section.add "If-Unmodified-Since", valid_569013
  var valid_569014 = header.getOrDefault("If-None-Match")
  valid_569014 = validateParameter(valid_569014, JString, required = false,
                                 default = nil)
  if valid_569014 != nil:
    section.add "If-None-Match", valid_569014
  var valid_569015 = header.getOrDefault("If-Modified-Since")
  valid_569015 = validateParameter(valid_569015, JString, required = false,
                                 default = nil)
  if valid_569015 != nil:
    section.add "If-Modified-Since", valid_569015
  var valid_569016 = header.getOrDefault("return-client-request-id")
  valid_569016 = validateParameter(valid_569016, JBool, required = false,
                                 default = newJBool(false))
  if valid_569016 != nil:
    section.add "return-client-request-id", valid_569016
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569017: Call_PoolGet_569002; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified pool.
  ## 
  let valid = call_569017.validator(path, query, header, formData, body)
  let scheme = call_569017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569017.url(scheme.get, call_569017.host, call_569017.base,
                         call_569017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569017, url, valid)

proc call*(call_569018: Call_PoolGet_569002; apiVersion: string; poolId: string;
          timeout: int = 30; Expand: string = ""; Select: string = ""): Recallable =
  ## poolGet
  ## Gets information about the specified pool.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool to get.
  ##   Select: string
  ##         : An OData $select clause.
  var path_569019 = newJObject()
  var query_569020 = newJObject()
  add(query_569020, "timeout", newJInt(timeout))
  add(query_569020, "$expand", newJString(Expand))
  add(query_569020, "api-version", newJString(apiVersion))
  add(path_569019, "poolId", newJString(poolId))
  add(query_569020, "$select", newJString(Select))
  result = call_569018.call(path_569019, query_569020, nil, nil, nil)

var poolGet* = Call_PoolGet_569002(name: "poolGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/pools/{poolId}",
                                validator: validate_PoolGet_569003, base: "",
                                url: url_PoolGet_569004, schemes: {Scheme.Https})
type
  Call_PoolPatch_569055 = ref object of OpenApiRestCall_567667
proc url_PoolPatch_569057(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolPatch_569056(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## This only replaces the pool properties specified in the request. For example, if the pool has a start task associated with it, and a request does not specify a start task element, then the pool keeps the existing start task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569058 = path.getOrDefault("poolId")
  valid_569058 = validateParameter(valid_569058, JString, required = true,
                                 default = nil)
  if valid_569058 != nil:
    section.add "poolId", valid_569058
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569059 = query.getOrDefault("timeout")
  valid_569059 = validateParameter(valid_569059, JInt, required = false,
                                 default = newJInt(30))
  if valid_569059 != nil:
    section.add "timeout", valid_569059
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569060 = query.getOrDefault("api-version")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "api-version", valid_569060
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
  var valid_569061 = header.getOrDefault("If-Match")
  valid_569061 = validateParameter(valid_569061, JString, required = false,
                                 default = nil)
  if valid_569061 != nil:
    section.add "If-Match", valid_569061
  var valid_569062 = header.getOrDefault("client-request-id")
  valid_569062 = validateParameter(valid_569062, JString, required = false,
                                 default = nil)
  if valid_569062 != nil:
    section.add "client-request-id", valid_569062
  var valid_569063 = header.getOrDefault("ocp-date")
  valid_569063 = validateParameter(valid_569063, JString, required = false,
                                 default = nil)
  if valid_569063 != nil:
    section.add "ocp-date", valid_569063
  var valid_569064 = header.getOrDefault("If-Unmodified-Since")
  valid_569064 = validateParameter(valid_569064, JString, required = false,
                                 default = nil)
  if valid_569064 != nil:
    section.add "If-Unmodified-Since", valid_569064
  var valid_569065 = header.getOrDefault("If-None-Match")
  valid_569065 = validateParameter(valid_569065, JString, required = false,
                                 default = nil)
  if valid_569065 != nil:
    section.add "If-None-Match", valid_569065
  var valid_569066 = header.getOrDefault("If-Modified-Since")
  valid_569066 = validateParameter(valid_569066, JString, required = false,
                                 default = nil)
  if valid_569066 != nil:
    section.add "If-Modified-Since", valid_569066
  var valid_569067 = header.getOrDefault("return-client-request-id")
  valid_569067 = validateParameter(valid_569067, JBool, required = false,
                                 default = newJBool(false))
  if valid_569067 != nil:
    section.add "return-client-request-id", valid_569067
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

proc call*(call_569069: Call_PoolPatch_569055; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This only replaces the pool properties specified in the request. For example, if the pool has a start task associated with it, and a request does not specify a start task element, then the pool keeps the existing start task.
  ## 
  let valid = call_569069.validator(path, query, header, formData, body)
  let scheme = call_569069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569069.url(scheme.get, call_569069.host, call_569069.base,
                         call_569069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569069, url, valid)

proc call*(call_569070: Call_PoolPatch_569055; apiVersion: string; poolId: string;
          poolPatchParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolPatch
  ## This only replaces the pool properties specified in the request. For example, if the pool has a start task associated with it, and a request does not specify a start task element, then the pool keeps the existing start task.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool to update.
  ##   poolPatchParameter: JObject (required)
  ##                     : The parameters for the request.
  var path_569071 = newJObject()
  var query_569072 = newJObject()
  var body_569073 = newJObject()
  add(query_569072, "timeout", newJInt(timeout))
  add(query_569072, "api-version", newJString(apiVersion))
  add(path_569071, "poolId", newJString(poolId))
  if poolPatchParameter != nil:
    body_569073 = poolPatchParameter
  result = call_569070.call(path_569071, query_569072, nil, nil, body_569073)

var poolPatch* = Call_PoolPatch_569055(name: "poolPatch", meth: HttpMethod.HttpPatch,
                                    host: "azure.local", route: "/pools/{poolId}",
                                    validator: validate_PoolPatch_569056,
                                    base: "", url: url_PoolPatch_569057,
                                    schemes: {Scheme.Https})
type
  Call_PoolDelete_569021 = ref object of OpenApiRestCall_567667
proc url_PoolDelete_569023(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolDelete_569022(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## When you request that a pool be deleted, the following actions occur: the pool state is set to deleting; any ongoing resize operation on the pool are stopped; the Batch service starts resizing the pool to zero nodes; any tasks running on existing nodes are terminated and requeued (as if a resize pool operation had been requested with the default requeue option); finally, the pool is removed from the system. Because running tasks are requeued, the user can rerun these tasks by updating their job to target a different pool. The tasks can then run on the new pool. If you want to override the requeue behavior, then you should call resize pool explicitly to shrink the pool to zero size before deleting the pool. If you call an Update, Patch or Delete API on a pool in the deleting state, it will fail with HTTP status code 409 with error code PoolBeingDeleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569024 = path.getOrDefault("poolId")
  valid_569024 = validateParameter(valid_569024, JString, required = true,
                                 default = nil)
  if valid_569024 != nil:
    section.add "poolId", valid_569024
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569025 = query.getOrDefault("timeout")
  valid_569025 = validateParameter(valid_569025, JInt, required = false,
                                 default = newJInt(30))
  if valid_569025 != nil:
    section.add "timeout", valid_569025
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569026 = query.getOrDefault("api-version")
  valid_569026 = validateParameter(valid_569026, JString, required = true,
                                 default = nil)
  if valid_569026 != nil:
    section.add "api-version", valid_569026
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
  var valid_569027 = header.getOrDefault("If-Match")
  valid_569027 = validateParameter(valid_569027, JString, required = false,
                                 default = nil)
  if valid_569027 != nil:
    section.add "If-Match", valid_569027
  var valid_569028 = header.getOrDefault("client-request-id")
  valid_569028 = validateParameter(valid_569028, JString, required = false,
                                 default = nil)
  if valid_569028 != nil:
    section.add "client-request-id", valid_569028
  var valid_569029 = header.getOrDefault("ocp-date")
  valid_569029 = validateParameter(valid_569029, JString, required = false,
                                 default = nil)
  if valid_569029 != nil:
    section.add "ocp-date", valid_569029
  var valid_569030 = header.getOrDefault("If-Unmodified-Since")
  valid_569030 = validateParameter(valid_569030, JString, required = false,
                                 default = nil)
  if valid_569030 != nil:
    section.add "If-Unmodified-Since", valid_569030
  var valid_569031 = header.getOrDefault("If-None-Match")
  valid_569031 = validateParameter(valid_569031, JString, required = false,
                                 default = nil)
  if valid_569031 != nil:
    section.add "If-None-Match", valid_569031
  var valid_569032 = header.getOrDefault("If-Modified-Since")
  valid_569032 = validateParameter(valid_569032, JString, required = false,
                                 default = nil)
  if valid_569032 != nil:
    section.add "If-Modified-Since", valid_569032
  var valid_569033 = header.getOrDefault("return-client-request-id")
  valid_569033 = validateParameter(valid_569033, JBool, required = false,
                                 default = newJBool(false))
  if valid_569033 != nil:
    section.add "return-client-request-id", valid_569033
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569034: Call_PoolDelete_569021; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you request that a pool be deleted, the following actions occur: the pool state is set to deleting; any ongoing resize operation on the pool are stopped; the Batch service starts resizing the pool to zero nodes; any tasks running on existing nodes are terminated and requeued (as if a resize pool operation had been requested with the default requeue option); finally, the pool is removed from the system. Because running tasks are requeued, the user can rerun these tasks by updating their job to target a different pool. The tasks can then run on the new pool. If you want to override the requeue behavior, then you should call resize pool explicitly to shrink the pool to zero size before deleting the pool. If you call an Update, Patch or Delete API on a pool in the deleting state, it will fail with HTTP status code 409 with error code PoolBeingDeleted.
  ## 
  let valid = call_569034.validator(path, query, header, formData, body)
  let scheme = call_569034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569034.url(scheme.get, call_569034.host, call_569034.base,
                         call_569034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569034, url, valid)

proc call*(call_569035: Call_PoolDelete_569021; apiVersion: string; poolId: string;
          timeout: int = 30): Recallable =
  ## poolDelete
  ## When you request that a pool be deleted, the following actions occur: the pool state is set to deleting; any ongoing resize operation on the pool are stopped; the Batch service starts resizing the pool to zero nodes; any tasks running on existing nodes are terminated and requeued (as if a resize pool operation had been requested with the default requeue option); finally, the pool is removed from the system. Because running tasks are requeued, the user can rerun these tasks by updating their job to target a different pool. The tasks can then run on the new pool. If you want to override the requeue behavior, then you should call resize pool explicitly to shrink the pool to zero size before deleting the pool. If you call an Update, Patch or Delete API on a pool in the deleting state, it will fail with HTTP status code 409 with error code PoolBeingDeleted.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool to delete.
  var path_569036 = newJObject()
  var query_569037 = newJObject()
  add(query_569037, "timeout", newJInt(timeout))
  add(query_569037, "api-version", newJString(apiVersion))
  add(path_569036, "poolId", newJString(poolId))
  result = call_569035.call(path_569036, query_569037, nil, nil, nil)

var poolDelete* = Call_PoolDelete_569021(name: "poolDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/pools/{poolId}",
                                      validator: validate_PoolDelete_569022,
                                      base: "", url: url_PoolDelete_569023,
                                      schemes: {Scheme.Https})
type
  Call_PoolDisableAutoScale_569074 = ref object of OpenApiRestCall_567667
proc url_PoolDisableAutoScale_569076(protocol: Scheme; host: string; base: string;
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

proc validate_PoolDisableAutoScale_569075(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool on which to disable automatic scaling.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569077 = path.getOrDefault("poolId")
  valid_569077 = validateParameter(valid_569077, JString, required = true,
                                 default = nil)
  if valid_569077 != nil:
    section.add "poolId", valid_569077
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569078 = query.getOrDefault("timeout")
  valid_569078 = validateParameter(valid_569078, JInt, required = false,
                                 default = newJInt(30))
  if valid_569078 != nil:
    section.add "timeout", valid_569078
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569079 = query.getOrDefault("api-version")
  valid_569079 = validateParameter(valid_569079, JString, required = true,
                                 default = nil)
  if valid_569079 != nil:
    section.add "api-version", valid_569079
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569080 = header.getOrDefault("client-request-id")
  valid_569080 = validateParameter(valid_569080, JString, required = false,
                                 default = nil)
  if valid_569080 != nil:
    section.add "client-request-id", valid_569080
  var valid_569081 = header.getOrDefault("ocp-date")
  valid_569081 = validateParameter(valid_569081, JString, required = false,
                                 default = nil)
  if valid_569081 != nil:
    section.add "ocp-date", valid_569081
  var valid_569082 = header.getOrDefault("return-client-request-id")
  valid_569082 = validateParameter(valid_569082, JBool, required = false,
                                 default = newJBool(false))
  if valid_569082 != nil:
    section.add "return-client-request-id", valid_569082
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569083: Call_PoolDisableAutoScale_569074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569083.validator(path, query, header, formData, body)
  let scheme = call_569083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569083.url(scheme.get, call_569083.host, call_569083.base,
                         call_569083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569083, url, valid)

proc call*(call_569084: Call_PoolDisableAutoScale_569074; apiVersion: string;
          poolId: string; timeout: int = 30): Recallable =
  ## poolDisableAutoScale
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool on which to disable automatic scaling.
  var path_569085 = newJObject()
  var query_569086 = newJObject()
  add(query_569086, "timeout", newJInt(timeout))
  add(query_569086, "api-version", newJString(apiVersion))
  add(path_569085, "poolId", newJString(poolId))
  result = call_569084.call(path_569085, query_569086, nil, nil, nil)

var poolDisableAutoScale* = Call_PoolDisableAutoScale_569074(
    name: "poolDisableAutoScale", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/disableautoscale",
    validator: validate_PoolDisableAutoScale_569075, base: "",
    url: url_PoolDisableAutoScale_569076, schemes: {Scheme.Https})
type
  Call_PoolEnableAutoScale_569087 = ref object of OpenApiRestCall_567667
proc url_PoolEnableAutoScale_569089(protocol: Scheme; host: string; base: string;
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

proc validate_PoolEnableAutoScale_569088(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## You cannot enable automatic scaling on a pool if a resize operation is in progress on the pool. If automatic scaling of the pool is currently disabled, you must specify a valid autoscale formula as part of the request. If automatic scaling of the pool is already enabled, you may specify a new autoscale formula and/or a new evaluation interval. You cannot call this API for the same pool more than once every 30 seconds.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool on which to enable automatic scaling.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569090 = path.getOrDefault("poolId")
  valid_569090 = validateParameter(valid_569090, JString, required = true,
                                 default = nil)
  if valid_569090 != nil:
    section.add "poolId", valid_569090
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569091 = query.getOrDefault("timeout")
  valid_569091 = validateParameter(valid_569091, JInt, required = false,
                                 default = newJInt(30))
  if valid_569091 != nil:
    section.add "timeout", valid_569091
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569092 = query.getOrDefault("api-version")
  valid_569092 = validateParameter(valid_569092, JString, required = true,
                                 default = nil)
  if valid_569092 != nil:
    section.add "api-version", valid_569092
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
  var valid_569093 = header.getOrDefault("If-Match")
  valid_569093 = validateParameter(valid_569093, JString, required = false,
                                 default = nil)
  if valid_569093 != nil:
    section.add "If-Match", valid_569093
  var valid_569094 = header.getOrDefault("client-request-id")
  valid_569094 = validateParameter(valid_569094, JString, required = false,
                                 default = nil)
  if valid_569094 != nil:
    section.add "client-request-id", valid_569094
  var valid_569095 = header.getOrDefault("ocp-date")
  valid_569095 = validateParameter(valid_569095, JString, required = false,
                                 default = nil)
  if valid_569095 != nil:
    section.add "ocp-date", valid_569095
  var valid_569096 = header.getOrDefault("If-Unmodified-Since")
  valid_569096 = validateParameter(valid_569096, JString, required = false,
                                 default = nil)
  if valid_569096 != nil:
    section.add "If-Unmodified-Since", valid_569096
  var valid_569097 = header.getOrDefault("If-None-Match")
  valid_569097 = validateParameter(valid_569097, JString, required = false,
                                 default = nil)
  if valid_569097 != nil:
    section.add "If-None-Match", valid_569097
  var valid_569098 = header.getOrDefault("If-Modified-Since")
  valid_569098 = validateParameter(valid_569098, JString, required = false,
                                 default = nil)
  if valid_569098 != nil:
    section.add "If-Modified-Since", valid_569098
  var valid_569099 = header.getOrDefault("return-client-request-id")
  valid_569099 = validateParameter(valid_569099, JBool, required = false,
                                 default = newJBool(false))
  if valid_569099 != nil:
    section.add "return-client-request-id", valid_569099
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

proc call*(call_569101: Call_PoolEnableAutoScale_569087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You cannot enable automatic scaling on a pool if a resize operation is in progress on the pool. If automatic scaling of the pool is currently disabled, you must specify a valid autoscale formula as part of the request. If automatic scaling of the pool is already enabled, you may specify a new autoscale formula and/or a new evaluation interval. You cannot call this API for the same pool more than once every 30 seconds.
  ## 
  let valid = call_569101.validator(path, query, header, formData, body)
  let scheme = call_569101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569101.url(scheme.get, call_569101.host, call_569101.base,
                         call_569101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569101, url, valid)

proc call*(call_569102: Call_PoolEnableAutoScale_569087; apiVersion: string;
          poolId: string; poolEnableAutoScaleParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolEnableAutoScale
  ## You cannot enable automatic scaling on a pool if a resize operation is in progress on the pool. If automatic scaling of the pool is currently disabled, you must specify a valid autoscale formula as part of the request. If automatic scaling of the pool is already enabled, you may specify a new autoscale formula and/or a new evaluation interval. You cannot call this API for the same pool more than once every 30 seconds.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool on which to enable automatic scaling.
  ##   poolEnableAutoScaleParameter: JObject (required)
  ##                               : The parameters for the request.
  var path_569103 = newJObject()
  var query_569104 = newJObject()
  var body_569105 = newJObject()
  add(query_569104, "timeout", newJInt(timeout))
  add(query_569104, "api-version", newJString(apiVersion))
  add(path_569103, "poolId", newJString(poolId))
  if poolEnableAutoScaleParameter != nil:
    body_569105 = poolEnableAutoScaleParameter
  result = call_569102.call(path_569103, query_569104, nil, nil, body_569105)

var poolEnableAutoScale* = Call_PoolEnableAutoScale_569087(
    name: "poolEnableAutoScale", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/enableautoscale",
    validator: validate_PoolEnableAutoScale_569088, base: "",
    url: url_PoolEnableAutoScale_569089, schemes: {Scheme.Https})
type
  Call_PoolEvaluateAutoScale_569106 = ref object of OpenApiRestCall_567667
proc url_PoolEvaluateAutoScale_569108(protocol: Scheme; host: string; base: string;
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

proc validate_PoolEvaluateAutoScale_569107(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This API is primarily for validating an autoscale formula, as it simply returns the result without applying the formula to the pool. The pool must have auto scaling enabled in order to evaluate a formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool on which to evaluate the automatic scaling formula.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569109 = path.getOrDefault("poolId")
  valid_569109 = validateParameter(valid_569109, JString, required = true,
                                 default = nil)
  if valid_569109 != nil:
    section.add "poolId", valid_569109
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569110 = query.getOrDefault("timeout")
  valid_569110 = validateParameter(valid_569110, JInt, required = false,
                                 default = newJInt(30))
  if valid_569110 != nil:
    section.add "timeout", valid_569110
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569111 = query.getOrDefault("api-version")
  valid_569111 = validateParameter(valid_569111, JString, required = true,
                                 default = nil)
  if valid_569111 != nil:
    section.add "api-version", valid_569111
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569112 = header.getOrDefault("client-request-id")
  valid_569112 = validateParameter(valid_569112, JString, required = false,
                                 default = nil)
  if valid_569112 != nil:
    section.add "client-request-id", valid_569112
  var valid_569113 = header.getOrDefault("ocp-date")
  valid_569113 = validateParameter(valid_569113, JString, required = false,
                                 default = nil)
  if valid_569113 != nil:
    section.add "ocp-date", valid_569113
  var valid_569114 = header.getOrDefault("return-client-request-id")
  valid_569114 = validateParameter(valid_569114, JBool, required = false,
                                 default = newJBool(false))
  if valid_569114 != nil:
    section.add "return-client-request-id", valid_569114
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

proc call*(call_569116: Call_PoolEvaluateAutoScale_569106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API is primarily for validating an autoscale formula, as it simply returns the result without applying the formula to the pool. The pool must have auto scaling enabled in order to evaluate a formula.
  ## 
  let valid = call_569116.validator(path, query, header, formData, body)
  let scheme = call_569116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569116.url(scheme.get, call_569116.host, call_569116.base,
                         call_569116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569116, url, valid)

proc call*(call_569117: Call_PoolEvaluateAutoScale_569106; apiVersion: string;
          poolEvaluateAutoScaleParameter: JsonNode; poolId: string;
          timeout: int = 30): Recallable =
  ## poolEvaluateAutoScale
  ## This API is primarily for validating an autoscale formula, as it simply returns the result without applying the formula to the pool. The pool must have auto scaling enabled in order to evaluate a formula.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolEvaluateAutoScaleParameter: JObject (required)
  ##                                 : The parameters for the request.
  ##   poolId: string (required)
  ##         : The ID of the pool on which to evaluate the automatic scaling formula.
  var path_569118 = newJObject()
  var query_569119 = newJObject()
  var body_569120 = newJObject()
  add(query_569119, "timeout", newJInt(timeout))
  add(query_569119, "api-version", newJString(apiVersion))
  if poolEvaluateAutoScaleParameter != nil:
    body_569120 = poolEvaluateAutoScaleParameter
  add(path_569118, "poolId", newJString(poolId))
  result = call_569117.call(path_569118, query_569119, nil, nil, body_569120)

var poolEvaluateAutoScale* = Call_PoolEvaluateAutoScale_569106(
    name: "poolEvaluateAutoScale", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/evaluateautoscale",
    validator: validate_PoolEvaluateAutoScale_569107, base: "",
    url: url_PoolEvaluateAutoScale_569108, schemes: {Scheme.Https})
type
  Call_ComputeNodeList_569121 = ref object of OpenApiRestCall_567667
proc url_ComputeNodeList_569123(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeList_569122(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool from which you want to list nodes.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569124 = path.getOrDefault("poolId")
  valid_569124 = validateParameter(valid_569124, JString, required = true,
                                 default = nil)
  if valid_569124 != nil:
    section.add "poolId", valid_569124
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 nodes can be returned.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-nodes-in-a-pool.
  section = newJObject()
  var valid_569125 = query.getOrDefault("timeout")
  valid_569125 = validateParameter(valid_569125, JInt, required = false,
                                 default = newJInt(30))
  if valid_569125 != nil:
    section.add "timeout", valid_569125
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569126 = query.getOrDefault("api-version")
  valid_569126 = validateParameter(valid_569126, JString, required = true,
                                 default = nil)
  if valid_569126 != nil:
    section.add "api-version", valid_569126
  var valid_569127 = query.getOrDefault("maxresults")
  valid_569127 = validateParameter(valid_569127, JInt, required = false,
                                 default = newJInt(1000))
  if valid_569127 != nil:
    section.add "maxresults", valid_569127
  var valid_569128 = query.getOrDefault("$select")
  valid_569128 = validateParameter(valid_569128, JString, required = false,
                                 default = nil)
  if valid_569128 != nil:
    section.add "$select", valid_569128
  var valid_569129 = query.getOrDefault("$filter")
  valid_569129 = validateParameter(valid_569129, JString, required = false,
                                 default = nil)
  if valid_569129 != nil:
    section.add "$filter", valid_569129
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569130 = header.getOrDefault("client-request-id")
  valid_569130 = validateParameter(valid_569130, JString, required = false,
                                 default = nil)
  if valid_569130 != nil:
    section.add "client-request-id", valid_569130
  var valid_569131 = header.getOrDefault("ocp-date")
  valid_569131 = validateParameter(valid_569131, JString, required = false,
                                 default = nil)
  if valid_569131 != nil:
    section.add "ocp-date", valid_569131
  var valid_569132 = header.getOrDefault("return-client-request-id")
  valid_569132 = validateParameter(valid_569132, JBool, required = false,
                                 default = newJBool(false))
  if valid_569132 != nil:
    section.add "return-client-request-id", valid_569132
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569133: Call_ComputeNodeList_569121; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569133.validator(path, query, header, formData, body)
  let scheme = call_569133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569133.url(scheme.get, call_569133.host, call_569133.base,
                         call_569133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569133, url, valid)

proc call*(call_569134: Call_ComputeNodeList_569121; apiVersion: string;
          poolId: string; timeout: int = 30; maxresults: int = 1000; Select: string = "";
          Filter: string = ""): Recallable =
  ## computeNodeList
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool from which you want to list nodes.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 nodes can be returned.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-nodes-in-a-pool.
  var path_569135 = newJObject()
  var query_569136 = newJObject()
  add(query_569136, "timeout", newJInt(timeout))
  add(query_569136, "api-version", newJString(apiVersion))
  add(path_569135, "poolId", newJString(poolId))
  add(query_569136, "maxresults", newJInt(maxresults))
  add(query_569136, "$select", newJString(Select))
  add(query_569136, "$filter", newJString(Filter))
  result = call_569134.call(path_569135, query_569136, nil, nil, nil)

var computeNodeList* = Call_ComputeNodeList_569121(name: "computeNodeList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/pools/{poolId}/nodes",
    validator: validate_ComputeNodeList_569122, base: "", url: url_ComputeNodeList_569123,
    schemes: {Scheme.Https})
type
  Call_ComputeNodeGet_569137 = ref object of OpenApiRestCall_567667
proc url_ComputeNodeGet_569139(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeGet_569138(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node that you want to get information about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569140 = path.getOrDefault("poolId")
  valid_569140 = validateParameter(valid_569140, JString, required = true,
                                 default = nil)
  if valid_569140 != nil:
    section.add "poolId", valid_569140
  var valid_569141 = path.getOrDefault("nodeId")
  valid_569141 = validateParameter(valid_569141, JString, required = true,
                                 default = nil)
  if valid_569141 != nil:
    section.add "nodeId", valid_569141
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_569142 = query.getOrDefault("timeout")
  valid_569142 = validateParameter(valid_569142, JInt, required = false,
                                 default = newJInt(30))
  if valid_569142 != nil:
    section.add "timeout", valid_569142
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569143 = query.getOrDefault("api-version")
  valid_569143 = validateParameter(valid_569143, JString, required = true,
                                 default = nil)
  if valid_569143 != nil:
    section.add "api-version", valid_569143
  var valid_569144 = query.getOrDefault("$select")
  valid_569144 = validateParameter(valid_569144, JString, required = false,
                                 default = nil)
  if valid_569144 != nil:
    section.add "$select", valid_569144
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569145 = header.getOrDefault("client-request-id")
  valid_569145 = validateParameter(valid_569145, JString, required = false,
                                 default = nil)
  if valid_569145 != nil:
    section.add "client-request-id", valid_569145
  var valid_569146 = header.getOrDefault("ocp-date")
  valid_569146 = validateParameter(valid_569146, JString, required = false,
                                 default = nil)
  if valid_569146 != nil:
    section.add "ocp-date", valid_569146
  var valid_569147 = header.getOrDefault("return-client-request-id")
  valid_569147 = validateParameter(valid_569147, JBool, required = false,
                                 default = newJBool(false))
  if valid_569147 != nil:
    section.add "return-client-request-id", valid_569147
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569148: Call_ComputeNodeGet_569137; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569148.validator(path, query, header, formData, body)
  let scheme = call_569148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569148.url(scheme.get, call_569148.host, call_569148.base,
                         call_569148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569148, url, valid)

proc call*(call_569149: Call_ComputeNodeGet_569137; apiVersion: string;
          poolId: string; nodeId: string; timeout: int = 30; Select: string = ""): Recallable =
  ## computeNodeGet
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the compute node that you want to get information about.
  ##   Select: string
  ##         : An OData $select clause.
  var path_569150 = newJObject()
  var query_569151 = newJObject()
  add(query_569151, "timeout", newJInt(timeout))
  add(query_569151, "api-version", newJString(apiVersion))
  add(path_569150, "poolId", newJString(poolId))
  add(path_569150, "nodeId", newJString(nodeId))
  add(query_569151, "$select", newJString(Select))
  result = call_569149.call(path_569150, query_569151, nil, nil, nil)

var computeNodeGet* = Call_ComputeNodeGet_569137(name: "computeNodeGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}", validator: validate_ComputeNodeGet_569138,
    base: "", url: url_ComputeNodeGet_569139, schemes: {Scheme.Https})
type
  Call_ComputeNodeDisableScheduling_569152 = ref object of OpenApiRestCall_567667
proc url_ComputeNodeDisableScheduling_569154(protocol: Scheme; host: string;
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

proc validate_ComputeNodeDisableScheduling_569153(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can disable task scheduling on a node only if its current scheduling state is enabled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node on which you want to disable task scheduling.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569155 = path.getOrDefault("poolId")
  valid_569155 = validateParameter(valid_569155, JString, required = true,
                                 default = nil)
  if valid_569155 != nil:
    section.add "poolId", valid_569155
  var valid_569156 = path.getOrDefault("nodeId")
  valid_569156 = validateParameter(valid_569156, JString, required = true,
                                 default = nil)
  if valid_569156 != nil:
    section.add "nodeId", valid_569156
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569157 = query.getOrDefault("timeout")
  valid_569157 = validateParameter(valid_569157, JInt, required = false,
                                 default = newJInt(30))
  if valid_569157 != nil:
    section.add "timeout", valid_569157
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569158 = query.getOrDefault("api-version")
  valid_569158 = validateParameter(valid_569158, JString, required = true,
                                 default = nil)
  if valid_569158 != nil:
    section.add "api-version", valid_569158
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569159 = header.getOrDefault("client-request-id")
  valid_569159 = validateParameter(valid_569159, JString, required = false,
                                 default = nil)
  if valid_569159 != nil:
    section.add "client-request-id", valid_569159
  var valid_569160 = header.getOrDefault("ocp-date")
  valid_569160 = validateParameter(valid_569160, JString, required = false,
                                 default = nil)
  if valid_569160 != nil:
    section.add "ocp-date", valid_569160
  var valid_569161 = header.getOrDefault("return-client-request-id")
  valid_569161 = validateParameter(valid_569161, JBool, required = false,
                                 default = newJBool(false))
  if valid_569161 != nil:
    section.add "return-client-request-id", valid_569161
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeDisableSchedulingParameter: JObject
  ##                                 : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569163: Call_ComputeNodeDisableScheduling_569152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can disable task scheduling on a node only if its current scheduling state is enabled.
  ## 
  let valid = call_569163.validator(path, query, header, formData, body)
  let scheme = call_569163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569163.url(scheme.get, call_569163.host, call_569163.base,
                         call_569163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569163, url, valid)

proc call*(call_569164: Call_ComputeNodeDisableScheduling_569152;
          apiVersion: string; poolId: string; nodeId: string; timeout: int = 30;
          nodeDisableSchedulingParameter: JsonNode = nil): Recallable =
  ## computeNodeDisableScheduling
  ## You can disable task scheduling on a node only if its current scheduling state is enabled.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the compute node on which you want to disable task scheduling.
  ##   nodeDisableSchedulingParameter: JObject
  ##                                 : The parameters for the request.
  var path_569165 = newJObject()
  var query_569166 = newJObject()
  var body_569167 = newJObject()
  add(query_569166, "timeout", newJInt(timeout))
  add(query_569166, "api-version", newJString(apiVersion))
  add(path_569165, "poolId", newJString(poolId))
  add(path_569165, "nodeId", newJString(nodeId))
  if nodeDisableSchedulingParameter != nil:
    body_569167 = nodeDisableSchedulingParameter
  result = call_569164.call(path_569165, query_569166, nil, nil, body_569167)

var computeNodeDisableScheduling* = Call_ComputeNodeDisableScheduling_569152(
    name: "computeNodeDisableScheduling", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/disablescheduling",
    validator: validate_ComputeNodeDisableScheduling_569153, base: "",
    url: url_ComputeNodeDisableScheduling_569154, schemes: {Scheme.Https})
type
  Call_ComputeNodeEnableScheduling_569168 = ref object of OpenApiRestCall_567667
proc url_ComputeNodeEnableScheduling_569170(protocol: Scheme; host: string;
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

proc validate_ComputeNodeEnableScheduling_569169(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can enable task scheduling on a node only if its current scheduling state is disabled
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node on which you want to enable task scheduling.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569171 = path.getOrDefault("poolId")
  valid_569171 = validateParameter(valid_569171, JString, required = true,
                                 default = nil)
  if valid_569171 != nil:
    section.add "poolId", valid_569171
  var valid_569172 = path.getOrDefault("nodeId")
  valid_569172 = validateParameter(valid_569172, JString, required = true,
                                 default = nil)
  if valid_569172 != nil:
    section.add "nodeId", valid_569172
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569173 = query.getOrDefault("timeout")
  valid_569173 = validateParameter(valid_569173, JInt, required = false,
                                 default = newJInt(30))
  if valid_569173 != nil:
    section.add "timeout", valid_569173
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569174 = query.getOrDefault("api-version")
  valid_569174 = validateParameter(valid_569174, JString, required = true,
                                 default = nil)
  if valid_569174 != nil:
    section.add "api-version", valid_569174
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569175 = header.getOrDefault("client-request-id")
  valid_569175 = validateParameter(valid_569175, JString, required = false,
                                 default = nil)
  if valid_569175 != nil:
    section.add "client-request-id", valid_569175
  var valid_569176 = header.getOrDefault("ocp-date")
  valid_569176 = validateParameter(valid_569176, JString, required = false,
                                 default = nil)
  if valid_569176 != nil:
    section.add "ocp-date", valid_569176
  var valid_569177 = header.getOrDefault("return-client-request-id")
  valid_569177 = validateParameter(valid_569177, JBool, required = false,
                                 default = newJBool(false))
  if valid_569177 != nil:
    section.add "return-client-request-id", valid_569177
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569178: Call_ComputeNodeEnableScheduling_569168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can enable task scheduling on a node only if its current scheduling state is disabled
  ## 
  let valid = call_569178.validator(path, query, header, formData, body)
  let scheme = call_569178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569178.url(scheme.get, call_569178.host, call_569178.base,
                         call_569178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569178, url, valid)

proc call*(call_569179: Call_ComputeNodeEnableScheduling_569168;
          apiVersion: string; poolId: string; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeEnableScheduling
  ## You can enable task scheduling on a node only if its current scheduling state is disabled
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the compute node on which you want to enable task scheduling.
  var path_569180 = newJObject()
  var query_569181 = newJObject()
  add(query_569181, "timeout", newJInt(timeout))
  add(query_569181, "api-version", newJString(apiVersion))
  add(path_569180, "poolId", newJString(poolId))
  add(path_569180, "nodeId", newJString(nodeId))
  result = call_569179.call(path_569180, query_569181, nil, nil, nil)

var computeNodeEnableScheduling* = Call_ComputeNodeEnableScheduling_569168(
    name: "computeNodeEnableScheduling", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/enablescheduling",
    validator: validate_ComputeNodeEnableScheduling_569169, base: "",
    url: url_ComputeNodeEnableScheduling_569170, schemes: {Scheme.Https})
type
  Call_FileListFromComputeNode_569182 = ref object of OpenApiRestCall_567667
proc url_FileListFromComputeNode_569184(protocol: Scheme; host: string; base: string;
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

proc validate_FileListFromComputeNode_569183(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node whose files you want to list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569185 = path.getOrDefault("poolId")
  valid_569185 = validateParameter(valid_569185, JString, required = true,
                                 default = nil)
  if valid_569185 != nil:
    section.add "poolId", valid_569185
  var valid_569186 = path.getOrDefault("nodeId")
  valid_569186 = validateParameter(valid_569186, JString, required = true,
                                 default = nil)
  if valid_569186 != nil:
    section.add "nodeId", valid_569186
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
  var valid_569187 = query.getOrDefault("timeout")
  valid_569187 = validateParameter(valid_569187, JInt, required = false,
                                 default = newJInt(30))
  if valid_569187 != nil:
    section.add "timeout", valid_569187
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569188 = query.getOrDefault("api-version")
  valid_569188 = validateParameter(valid_569188, JString, required = true,
                                 default = nil)
  if valid_569188 != nil:
    section.add "api-version", valid_569188
  var valid_569189 = query.getOrDefault("maxresults")
  valid_569189 = validateParameter(valid_569189, JInt, required = false,
                                 default = newJInt(1000))
  if valid_569189 != nil:
    section.add "maxresults", valid_569189
  var valid_569190 = query.getOrDefault("$filter")
  valid_569190 = validateParameter(valid_569190, JString, required = false,
                                 default = nil)
  if valid_569190 != nil:
    section.add "$filter", valid_569190
  var valid_569191 = query.getOrDefault("recursive")
  valid_569191 = validateParameter(valid_569191, JBool, required = false, default = nil)
  if valid_569191 != nil:
    section.add "recursive", valid_569191
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569192 = header.getOrDefault("client-request-id")
  valid_569192 = validateParameter(valid_569192, JString, required = false,
                                 default = nil)
  if valid_569192 != nil:
    section.add "client-request-id", valid_569192
  var valid_569193 = header.getOrDefault("ocp-date")
  valid_569193 = validateParameter(valid_569193, JString, required = false,
                                 default = nil)
  if valid_569193 != nil:
    section.add "ocp-date", valid_569193
  var valid_569194 = header.getOrDefault("return-client-request-id")
  valid_569194 = validateParameter(valid_569194, JBool, required = false,
                                 default = newJBool(false))
  if valid_569194 != nil:
    section.add "return-client-request-id", valid_569194
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569195: Call_FileListFromComputeNode_569182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569195.validator(path, query, header, formData, body)
  let scheme = call_569195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569195.url(scheme.get, call_569195.host, call_569195.base,
                         call_569195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569195, url, valid)

proc call*(call_569196: Call_FileListFromComputeNode_569182; apiVersion: string;
          poolId: string; nodeId: string; timeout: int = 30; maxresults: int = 1000;
          Filter: string = ""; recursive: bool = false): Recallable =
  ## fileListFromComputeNode
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the compute node whose files you want to list.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-compute-node-files.
  ##   recursive: bool
  ##            : Whether to list children of a directory.
  var path_569197 = newJObject()
  var query_569198 = newJObject()
  add(query_569198, "timeout", newJInt(timeout))
  add(query_569198, "api-version", newJString(apiVersion))
  add(path_569197, "poolId", newJString(poolId))
  add(path_569197, "nodeId", newJString(nodeId))
  add(query_569198, "maxresults", newJInt(maxresults))
  add(query_569198, "$filter", newJString(Filter))
  add(query_569198, "recursive", newJBool(recursive))
  result = call_569196.call(path_569197, query_569198, nil, nil, nil)

var fileListFromComputeNode* = Call_FileListFromComputeNode_569182(
    name: "fileListFromComputeNode", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/files",
    validator: validate_FileListFromComputeNode_569183, base: "",
    url: url_FileListFromComputeNode_569184, schemes: {Scheme.Https})
type
  Call_FileGetPropertiesFromComputeNode_569233 = ref object of OpenApiRestCall_567667
proc url_FileGetPropertiesFromComputeNode_569235(protocol: Scheme; host: string;
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

proc validate_FileGetPropertiesFromComputeNode_569234(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified compute node file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node that contains the file.
  ##   filePath: JString (required)
  ##           : The path to the compute node file that you want to get the properties of.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569236 = path.getOrDefault("poolId")
  valid_569236 = validateParameter(valid_569236, JString, required = true,
                                 default = nil)
  if valid_569236 != nil:
    section.add "poolId", valid_569236
  var valid_569237 = path.getOrDefault("nodeId")
  valid_569237 = validateParameter(valid_569237, JString, required = true,
                                 default = nil)
  if valid_569237 != nil:
    section.add "nodeId", valid_569237
  var valid_569238 = path.getOrDefault("filePath")
  valid_569238 = validateParameter(valid_569238, JString, required = true,
                                 default = nil)
  if valid_569238 != nil:
    section.add "filePath", valid_569238
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569239 = query.getOrDefault("timeout")
  valid_569239 = validateParameter(valid_569239, JInt, required = false,
                                 default = newJInt(30))
  if valid_569239 != nil:
    section.add "timeout", valid_569239
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569240 = query.getOrDefault("api-version")
  valid_569240 = validateParameter(valid_569240, JString, required = true,
                                 default = nil)
  if valid_569240 != nil:
    section.add "api-version", valid_569240
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
  var valid_569241 = header.getOrDefault("client-request-id")
  valid_569241 = validateParameter(valid_569241, JString, required = false,
                                 default = nil)
  if valid_569241 != nil:
    section.add "client-request-id", valid_569241
  var valid_569242 = header.getOrDefault("ocp-date")
  valid_569242 = validateParameter(valid_569242, JString, required = false,
                                 default = nil)
  if valid_569242 != nil:
    section.add "ocp-date", valid_569242
  var valid_569243 = header.getOrDefault("If-Unmodified-Since")
  valid_569243 = validateParameter(valid_569243, JString, required = false,
                                 default = nil)
  if valid_569243 != nil:
    section.add "If-Unmodified-Since", valid_569243
  var valid_569244 = header.getOrDefault("If-Modified-Since")
  valid_569244 = validateParameter(valid_569244, JString, required = false,
                                 default = nil)
  if valid_569244 != nil:
    section.add "If-Modified-Since", valid_569244
  var valid_569245 = header.getOrDefault("return-client-request-id")
  valid_569245 = validateParameter(valid_569245, JBool, required = false,
                                 default = newJBool(false))
  if valid_569245 != nil:
    section.add "return-client-request-id", valid_569245
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569246: Call_FileGetPropertiesFromComputeNode_569233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the properties of the specified compute node file.
  ## 
  let valid = call_569246.validator(path, query, header, formData, body)
  let scheme = call_569246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569246.url(scheme.get, call_569246.host, call_569246.base,
                         call_569246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569246, url, valid)

proc call*(call_569247: Call_FileGetPropertiesFromComputeNode_569233;
          apiVersion: string; poolId: string; nodeId: string; filePath: string;
          timeout: int = 30): Recallable =
  ## fileGetPropertiesFromComputeNode
  ## Gets the properties of the specified compute node file.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the compute node that contains the file.
  ##   filePath: string (required)
  ##           : The path to the compute node file that you want to get the properties of.
  var path_569248 = newJObject()
  var query_569249 = newJObject()
  add(query_569249, "timeout", newJInt(timeout))
  add(query_569249, "api-version", newJString(apiVersion))
  add(path_569248, "poolId", newJString(poolId))
  add(path_569248, "nodeId", newJString(nodeId))
  add(path_569248, "filePath", newJString(filePath))
  result = call_569247.call(path_569248, query_569249, nil, nil, nil)

var fileGetPropertiesFromComputeNode* = Call_FileGetPropertiesFromComputeNode_569233(
    name: "fileGetPropertiesFromComputeNode", meth: HttpMethod.HttpHead,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/files/{filePath}",
    validator: validate_FileGetPropertiesFromComputeNode_569234, base: "",
    url: url_FileGetPropertiesFromComputeNode_569235, schemes: {Scheme.Https})
type
  Call_FileGetFromComputeNode_569199 = ref object of OpenApiRestCall_567667
proc url_FileGetFromComputeNode_569201(protocol: Scheme; host: string; base: string;
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

proc validate_FileGetFromComputeNode_569200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the content of the specified compute node file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node that contains the file.
  ##   filePath: JString (required)
  ##           : The path to the compute node file that you want to get the content of.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569202 = path.getOrDefault("poolId")
  valid_569202 = validateParameter(valid_569202, JString, required = true,
                                 default = nil)
  if valid_569202 != nil:
    section.add "poolId", valid_569202
  var valid_569203 = path.getOrDefault("nodeId")
  valid_569203 = validateParameter(valid_569203, JString, required = true,
                                 default = nil)
  if valid_569203 != nil:
    section.add "nodeId", valid_569203
  var valid_569204 = path.getOrDefault("filePath")
  valid_569204 = validateParameter(valid_569204, JString, required = true,
                                 default = nil)
  if valid_569204 != nil:
    section.add "filePath", valid_569204
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569205 = query.getOrDefault("timeout")
  valid_569205 = validateParameter(valid_569205, JInt, required = false,
                                 default = newJInt(30))
  if valid_569205 != nil:
    section.add "timeout", valid_569205
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569206 = query.getOrDefault("api-version")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = nil)
  if valid_569206 != nil:
    section.add "api-version", valid_569206
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
  var valid_569207 = header.getOrDefault("client-request-id")
  valid_569207 = validateParameter(valid_569207, JString, required = false,
                                 default = nil)
  if valid_569207 != nil:
    section.add "client-request-id", valid_569207
  var valid_569208 = header.getOrDefault("ocp-date")
  valid_569208 = validateParameter(valid_569208, JString, required = false,
                                 default = nil)
  if valid_569208 != nil:
    section.add "ocp-date", valid_569208
  var valid_569209 = header.getOrDefault("If-Unmodified-Since")
  valid_569209 = validateParameter(valid_569209, JString, required = false,
                                 default = nil)
  if valid_569209 != nil:
    section.add "If-Unmodified-Since", valid_569209
  var valid_569210 = header.getOrDefault("ocp-range")
  valid_569210 = validateParameter(valid_569210, JString, required = false,
                                 default = nil)
  if valid_569210 != nil:
    section.add "ocp-range", valid_569210
  var valid_569211 = header.getOrDefault("If-Modified-Since")
  valid_569211 = validateParameter(valid_569211, JString, required = false,
                                 default = nil)
  if valid_569211 != nil:
    section.add "If-Modified-Since", valid_569211
  var valid_569212 = header.getOrDefault("return-client-request-id")
  valid_569212 = validateParameter(valid_569212, JBool, required = false,
                                 default = newJBool(false))
  if valid_569212 != nil:
    section.add "return-client-request-id", valid_569212
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569213: Call_FileGetFromComputeNode_569199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the content of the specified compute node file.
  ## 
  let valid = call_569213.validator(path, query, header, formData, body)
  let scheme = call_569213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569213.url(scheme.get, call_569213.host, call_569213.base,
                         call_569213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569213, url, valid)

proc call*(call_569214: Call_FileGetFromComputeNode_569199; apiVersion: string;
          poolId: string; nodeId: string; filePath: string; timeout: int = 30): Recallable =
  ## fileGetFromComputeNode
  ## Returns the content of the specified compute node file.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the compute node that contains the file.
  ##   filePath: string (required)
  ##           : The path to the compute node file that you want to get the content of.
  var path_569215 = newJObject()
  var query_569216 = newJObject()
  add(query_569216, "timeout", newJInt(timeout))
  add(query_569216, "api-version", newJString(apiVersion))
  add(path_569215, "poolId", newJString(poolId))
  add(path_569215, "nodeId", newJString(nodeId))
  add(path_569215, "filePath", newJString(filePath))
  result = call_569214.call(path_569215, query_569216, nil, nil, nil)

var fileGetFromComputeNode* = Call_FileGetFromComputeNode_569199(
    name: "fileGetFromComputeNode", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/files/{filePath}",
    validator: validate_FileGetFromComputeNode_569200, base: "",
    url: url_FileGetFromComputeNode_569201, schemes: {Scheme.Https})
type
  Call_FileDeleteFromComputeNode_569217 = ref object of OpenApiRestCall_567667
proc url_FileDeleteFromComputeNode_569219(protocol: Scheme; host: string;
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

proc validate_FileDeleteFromComputeNode_569218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node from which you want to delete the file.
  ##   filePath: JString (required)
  ##           : The path to the file or directory that you want to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569220 = path.getOrDefault("poolId")
  valid_569220 = validateParameter(valid_569220, JString, required = true,
                                 default = nil)
  if valid_569220 != nil:
    section.add "poolId", valid_569220
  var valid_569221 = path.getOrDefault("nodeId")
  valid_569221 = validateParameter(valid_569221, JString, required = true,
                                 default = nil)
  if valid_569221 != nil:
    section.add "nodeId", valid_569221
  var valid_569222 = path.getOrDefault("filePath")
  valid_569222 = validateParameter(valid_569222, JString, required = true,
                                 default = nil)
  if valid_569222 != nil:
    section.add "filePath", valid_569222
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   recursive: JBool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  section = newJObject()
  var valid_569223 = query.getOrDefault("timeout")
  valid_569223 = validateParameter(valid_569223, JInt, required = false,
                                 default = newJInt(30))
  if valid_569223 != nil:
    section.add "timeout", valid_569223
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569224 = query.getOrDefault("api-version")
  valid_569224 = validateParameter(valid_569224, JString, required = true,
                                 default = nil)
  if valid_569224 != nil:
    section.add "api-version", valid_569224
  var valid_569225 = query.getOrDefault("recursive")
  valid_569225 = validateParameter(valid_569225, JBool, required = false, default = nil)
  if valid_569225 != nil:
    section.add "recursive", valid_569225
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569226 = header.getOrDefault("client-request-id")
  valid_569226 = validateParameter(valid_569226, JString, required = false,
                                 default = nil)
  if valid_569226 != nil:
    section.add "client-request-id", valid_569226
  var valid_569227 = header.getOrDefault("ocp-date")
  valid_569227 = validateParameter(valid_569227, JString, required = false,
                                 default = nil)
  if valid_569227 != nil:
    section.add "ocp-date", valid_569227
  var valid_569228 = header.getOrDefault("return-client-request-id")
  valid_569228 = validateParameter(valid_569228, JBool, required = false,
                                 default = newJBool(false))
  if valid_569228 != nil:
    section.add "return-client-request-id", valid_569228
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569229: Call_FileDeleteFromComputeNode_569217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569229.validator(path, query, header, formData, body)
  let scheme = call_569229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569229.url(scheme.get, call_569229.host, call_569229.base,
                         call_569229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569229, url, valid)

proc call*(call_569230: Call_FileDeleteFromComputeNode_569217; apiVersion: string;
          poolId: string; nodeId: string; filePath: string; timeout: int = 30;
          recursive: bool = false): Recallable =
  ## fileDeleteFromComputeNode
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the compute node from which you want to delete the file.
  ##   filePath: string (required)
  ##           : The path to the file or directory that you want to delete.
  ##   recursive: bool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  var path_569231 = newJObject()
  var query_569232 = newJObject()
  add(query_569232, "timeout", newJInt(timeout))
  add(query_569232, "api-version", newJString(apiVersion))
  add(path_569231, "poolId", newJString(poolId))
  add(path_569231, "nodeId", newJString(nodeId))
  add(path_569231, "filePath", newJString(filePath))
  add(query_569232, "recursive", newJBool(recursive))
  result = call_569230.call(path_569231, query_569232, nil, nil, nil)

var fileDeleteFromComputeNode* = Call_FileDeleteFromComputeNode_569217(
    name: "fileDeleteFromComputeNode", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/files/{filePath}",
    validator: validate_FileDeleteFromComputeNode_569218, base: "",
    url: url_FileDeleteFromComputeNode_569219, schemes: {Scheme.Https})
type
  Call_ComputeNodeGetRemoteDesktop_569250 = ref object of OpenApiRestCall_567667
proc url_ComputeNodeGetRemoteDesktop_569252(protocol: Scheme; host: string;
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

proc validate_ComputeNodeGetRemoteDesktop_569251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Before you can access a node by using the RDP file, you must create a user account on the node. This API can only be invoked on pools created with a cloud service configuration. For pools created with a virtual machine configuration, see the GetRemoteLoginSettings API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node for which you want to get the Remote Desktop Protocol file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569253 = path.getOrDefault("poolId")
  valid_569253 = validateParameter(valid_569253, JString, required = true,
                                 default = nil)
  if valid_569253 != nil:
    section.add "poolId", valid_569253
  var valid_569254 = path.getOrDefault("nodeId")
  valid_569254 = validateParameter(valid_569254, JString, required = true,
                                 default = nil)
  if valid_569254 != nil:
    section.add "nodeId", valid_569254
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569255 = query.getOrDefault("timeout")
  valid_569255 = validateParameter(valid_569255, JInt, required = false,
                                 default = newJInt(30))
  if valid_569255 != nil:
    section.add "timeout", valid_569255
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569256 = query.getOrDefault("api-version")
  valid_569256 = validateParameter(valid_569256, JString, required = true,
                                 default = nil)
  if valid_569256 != nil:
    section.add "api-version", valid_569256
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569257 = header.getOrDefault("client-request-id")
  valid_569257 = validateParameter(valid_569257, JString, required = false,
                                 default = nil)
  if valid_569257 != nil:
    section.add "client-request-id", valid_569257
  var valid_569258 = header.getOrDefault("ocp-date")
  valid_569258 = validateParameter(valid_569258, JString, required = false,
                                 default = nil)
  if valid_569258 != nil:
    section.add "ocp-date", valid_569258
  var valid_569259 = header.getOrDefault("return-client-request-id")
  valid_569259 = validateParameter(valid_569259, JBool, required = false,
                                 default = newJBool(false))
  if valid_569259 != nil:
    section.add "return-client-request-id", valid_569259
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569260: Call_ComputeNodeGetRemoteDesktop_569250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Before you can access a node by using the RDP file, you must create a user account on the node. This API can only be invoked on pools created with a cloud service configuration. For pools created with a virtual machine configuration, see the GetRemoteLoginSettings API.
  ## 
  let valid = call_569260.validator(path, query, header, formData, body)
  let scheme = call_569260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569260.url(scheme.get, call_569260.host, call_569260.base,
                         call_569260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569260, url, valid)

proc call*(call_569261: Call_ComputeNodeGetRemoteDesktop_569250;
          apiVersion: string; poolId: string; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeGetRemoteDesktop
  ## Before you can access a node by using the RDP file, you must create a user account on the node. This API can only be invoked on pools created with a cloud service configuration. For pools created with a virtual machine configuration, see the GetRemoteLoginSettings API.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the compute node for which you want to get the Remote Desktop Protocol file.
  var path_569262 = newJObject()
  var query_569263 = newJObject()
  add(query_569263, "timeout", newJInt(timeout))
  add(query_569263, "api-version", newJString(apiVersion))
  add(path_569262, "poolId", newJString(poolId))
  add(path_569262, "nodeId", newJString(nodeId))
  result = call_569261.call(path_569262, query_569263, nil, nil, nil)

var computeNodeGetRemoteDesktop* = Call_ComputeNodeGetRemoteDesktop_569250(
    name: "computeNodeGetRemoteDesktop", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/rdp",
    validator: validate_ComputeNodeGetRemoteDesktop_569251, base: "",
    url: url_ComputeNodeGetRemoteDesktop_569252, schemes: {Scheme.Https})
type
  Call_ComputeNodeReboot_569264 = ref object of OpenApiRestCall_567667
proc url_ComputeNodeReboot_569266(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeReboot_569265(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## You can restart a node only if it is in an idle or running state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node that you want to restart.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569267 = path.getOrDefault("poolId")
  valid_569267 = validateParameter(valid_569267, JString, required = true,
                                 default = nil)
  if valid_569267 != nil:
    section.add "poolId", valid_569267
  var valid_569268 = path.getOrDefault("nodeId")
  valid_569268 = validateParameter(valid_569268, JString, required = true,
                                 default = nil)
  if valid_569268 != nil:
    section.add "nodeId", valid_569268
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569269 = query.getOrDefault("timeout")
  valid_569269 = validateParameter(valid_569269, JInt, required = false,
                                 default = newJInt(30))
  if valid_569269 != nil:
    section.add "timeout", valid_569269
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569270 = query.getOrDefault("api-version")
  valid_569270 = validateParameter(valid_569270, JString, required = true,
                                 default = nil)
  if valid_569270 != nil:
    section.add "api-version", valid_569270
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569271 = header.getOrDefault("client-request-id")
  valid_569271 = validateParameter(valid_569271, JString, required = false,
                                 default = nil)
  if valid_569271 != nil:
    section.add "client-request-id", valid_569271
  var valid_569272 = header.getOrDefault("ocp-date")
  valid_569272 = validateParameter(valid_569272, JString, required = false,
                                 default = nil)
  if valid_569272 != nil:
    section.add "ocp-date", valid_569272
  var valid_569273 = header.getOrDefault("return-client-request-id")
  valid_569273 = validateParameter(valid_569273, JBool, required = false,
                                 default = newJBool(false))
  if valid_569273 != nil:
    section.add "return-client-request-id", valid_569273
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeRebootParameter: JObject
  ##                      : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569275: Call_ComputeNodeReboot_569264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can restart a node only if it is in an idle or running state.
  ## 
  let valid = call_569275.validator(path, query, header, formData, body)
  let scheme = call_569275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569275.url(scheme.get, call_569275.host, call_569275.base,
                         call_569275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569275, url, valid)

proc call*(call_569276: Call_ComputeNodeReboot_569264; apiVersion: string;
          poolId: string; nodeId: string; timeout: int = 30;
          nodeRebootParameter: JsonNode = nil): Recallable =
  ## computeNodeReboot
  ## You can restart a node only if it is in an idle or running state.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   nodeRebootParameter: JObject
  ##                      : The parameters for the request.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the compute node that you want to restart.
  var path_569277 = newJObject()
  var query_569278 = newJObject()
  var body_569279 = newJObject()
  add(query_569278, "timeout", newJInt(timeout))
  add(query_569278, "api-version", newJString(apiVersion))
  if nodeRebootParameter != nil:
    body_569279 = nodeRebootParameter
  add(path_569277, "poolId", newJString(poolId))
  add(path_569277, "nodeId", newJString(nodeId))
  result = call_569276.call(path_569277, query_569278, nil, nil, body_569279)

var computeNodeReboot* = Call_ComputeNodeReboot_569264(name: "computeNodeReboot",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/reboot",
    validator: validate_ComputeNodeReboot_569265, base: "",
    url: url_ComputeNodeReboot_569266, schemes: {Scheme.Https})
type
  Call_ComputeNodeReimage_569280 = ref object of OpenApiRestCall_567667
proc url_ComputeNodeReimage_569282(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeReimage_569281(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## You can reinstall the operating system on a node only if it is in an idle or running state. This API can be invoked only on pools created with the cloud service configuration property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node that you want to restart.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569283 = path.getOrDefault("poolId")
  valid_569283 = validateParameter(valid_569283, JString, required = true,
                                 default = nil)
  if valid_569283 != nil:
    section.add "poolId", valid_569283
  var valid_569284 = path.getOrDefault("nodeId")
  valid_569284 = validateParameter(valid_569284, JString, required = true,
                                 default = nil)
  if valid_569284 != nil:
    section.add "nodeId", valid_569284
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569285 = query.getOrDefault("timeout")
  valid_569285 = validateParameter(valid_569285, JInt, required = false,
                                 default = newJInt(30))
  if valid_569285 != nil:
    section.add "timeout", valid_569285
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569286 = query.getOrDefault("api-version")
  valid_569286 = validateParameter(valid_569286, JString, required = true,
                                 default = nil)
  if valid_569286 != nil:
    section.add "api-version", valid_569286
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569287 = header.getOrDefault("client-request-id")
  valid_569287 = validateParameter(valid_569287, JString, required = false,
                                 default = nil)
  if valid_569287 != nil:
    section.add "client-request-id", valid_569287
  var valid_569288 = header.getOrDefault("ocp-date")
  valid_569288 = validateParameter(valid_569288, JString, required = false,
                                 default = nil)
  if valid_569288 != nil:
    section.add "ocp-date", valid_569288
  var valid_569289 = header.getOrDefault("return-client-request-id")
  valid_569289 = validateParameter(valid_569289, JBool, required = false,
                                 default = newJBool(false))
  if valid_569289 != nil:
    section.add "return-client-request-id", valid_569289
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeReimageParameter: JObject
  ##                       : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569291: Call_ComputeNodeReimage_569280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can reinstall the operating system on a node only if it is in an idle or running state. This API can be invoked only on pools created with the cloud service configuration property.
  ## 
  let valid = call_569291.validator(path, query, header, formData, body)
  let scheme = call_569291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569291.url(scheme.get, call_569291.host, call_569291.base,
                         call_569291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569291, url, valid)

proc call*(call_569292: Call_ComputeNodeReimage_569280; apiVersion: string;
          poolId: string; nodeId: string; timeout: int = 30;
          nodeReimageParameter: JsonNode = nil): Recallable =
  ## computeNodeReimage
  ## You can reinstall the operating system on a node only if it is in an idle or running state. This API can be invoked only on pools created with the cloud service configuration property.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the compute node that you want to restart.
  ##   nodeReimageParameter: JObject
  ##                       : The parameters for the request.
  var path_569293 = newJObject()
  var query_569294 = newJObject()
  var body_569295 = newJObject()
  add(query_569294, "timeout", newJInt(timeout))
  add(query_569294, "api-version", newJString(apiVersion))
  add(path_569293, "poolId", newJString(poolId))
  add(path_569293, "nodeId", newJString(nodeId))
  if nodeReimageParameter != nil:
    body_569295 = nodeReimageParameter
  result = call_569292.call(path_569293, query_569294, nil, nil, body_569295)

var computeNodeReimage* = Call_ComputeNodeReimage_569280(
    name: "computeNodeReimage", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/reimage",
    validator: validate_ComputeNodeReimage_569281, base: "",
    url: url_ComputeNodeReimage_569282, schemes: {Scheme.Https})
type
  Call_ComputeNodeGetRemoteLoginSettings_569296 = ref object of OpenApiRestCall_567667
proc url_ComputeNodeGetRemoteLoginSettings_569298(protocol: Scheme; host: string;
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

proc validate_ComputeNodeGetRemoteLoginSettings_569297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Before you can remotely login to a node using the remote login settings, you must create a user account on the node. This API can be invoked only on pools created with the virtual machine configuration property. For pools created with a cloud service configuration, see the GetRemoteDesktop API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node for which to obtain the remote login settings.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569299 = path.getOrDefault("poolId")
  valid_569299 = validateParameter(valid_569299, JString, required = true,
                                 default = nil)
  if valid_569299 != nil:
    section.add "poolId", valid_569299
  var valid_569300 = path.getOrDefault("nodeId")
  valid_569300 = validateParameter(valid_569300, JString, required = true,
                                 default = nil)
  if valid_569300 != nil:
    section.add "nodeId", valid_569300
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569301 = query.getOrDefault("timeout")
  valid_569301 = validateParameter(valid_569301, JInt, required = false,
                                 default = newJInt(30))
  if valid_569301 != nil:
    section.add "timeout", valid_569301
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569302 = query.getOrDefault("api-version")
  valid_569302 = validateParameter(valid_569302, JString, required = true,
                                 default = nil)
  if valid_569302 != nil:
    section.add "api-version", valid_569302
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569303 = header.getOrDefault("client-request-id")
  valid_569303 = validateParameter(valid_569303, JString, required = false,
                                 default = nil)
  if valid_569303 != nil:
    section.add "client-request-id", valid_569303
  var valid_569304 = header.getOrDefault("ocp-date")
  valid_569304 = validateParameter(valid_569304, JString, required = false,
                                 default = nil)
  if valid_569304 != nil:
    section.add "ocp-date", valid_569304
  var valid_569305 = header.getOrDefault("return-client-request-id")
  valid_569305 = validateParameter(valid_569305, JBool, required = false,
                                 default = newJBool(false))
  if valid_569305 != nil:
    section.add "return-client-request-id", valid_569305
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569306: Call_ComputeNodeGetRemoteLoginSettings_569296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Before you can remotely login to a node using the remote login settings, you must create a user account on the node. This API can be invoked only on pools created with the virtual machine configuration property. For pools created with a cloud service configuration, see the GetRemoteDesktop API.
  ## 
  let valid = call_569306.validator(path, query, header, formData, body)
  let scheme = call_569306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569306.url(scheme.get, call_569306.host, call_569306.base,
                         call_569306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569306, url, valid)

proc call*(call_569307: Call_ComputeNodeGetRemoteLoginSettings_569296;
          apiVersion: string; poolId: string; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeGetRemoteLoginSettings
  ## Before you can remotely login to a node using the remote login settings, you must create a user account on the node. This API can be invoked only on pools created with the virtual machine configuration property. For pools created with a cloud service configuration, see the GetRemoteDesktop API.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the compute node for which to obtain the remote login settings.
  var path_569308 = newJObject()
  var query_569309 = newJObject()
  add(query_569309, "timeout", newJInt(timeout))
  add(query_569309, "api-version", newJString(apiVersion))
  add(path_569308, "poolId", newJString(poolId))
  add(path_569308, "nodeId", newJString(nodeId))
  result = call_569307.call(path_569308, query_569309, nil, nil, nil)

var computeNodeGetRemoteLoginSettings* = Call_ComputeNodeGetRemoteLoginSettings_569296(
    name: "computeNodeGetRemoteLoginSettings", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/remoteloginsettings",
    validator: validate_ComputeNodeGetRemoteLoginSettings_569297, base: "",
    url: url_ComputeNodeGetRemoteLoginSettings_569298, schemes: {Scheme.Https})
type
  Call_ComputeNodeUploadBatchServiceLogs_569310 = ref object of OpenApiRestCall_567667
proc url_ComputeNodeUploadBatchServiceLogs_569312(protocol: Scheme; host: string;
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

proc validate_ComputeNodeUploadBatchServiceLogs_569311(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This is for gathering Azure Batch service log files in an automated fashion from nodes if you are experiencing an error and wish to escalate to Azure support. The Azure Batch service log files should be shared with Azure support to aid in debugging issues with the Batch service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node from which you want to upload the Azure Batch service log files.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569313 = path.getOrDefault("poolId")
  valid_569313 = validateParameter(valid_569313, JString, required = true,
                                 default = nil)
  if valid_569313 != nil:
    section.add "poolId", valid_569313
  var valid_569314 = path.getOrDefault("nodeId")
  valid_569314 = validateParameter(valid_569314, JString, required = true,
                                 default = nil)
  if valid_569314 != nil:
    section.add "nodeId", valid_569314
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569315 = query.getOrDefault("timeout")
  valid_569315 = validateParameter(valid_569315, JInt, required = false,
                                 default = newJInt(30))
  if valid_569315 != nil:
    section.add "timeout", valid_569315
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569316 = query.getOrDefault("api-version")
  valid_569316 = validateParameter(valid_569316, JString, required = true,
                                 default = nil)
  if valid_569316 != nil:
    section.add "api-version", valid_569316
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569317 = header.getOrDefault("client-request-id")
  valid_569317 = validateParameter(valid_569317, JString, required = false,
                                 default = nil)
  if valid_569317 != nil:
    section.add "client-request-id", valid_569317
  var valid_569318 = header.getOrDefault("ocp-date")
  valid_569318 = validateParameter(valid_569318, JString, required = false,
                                 default = nil)
  if valid_569318 != nil:
    section.add "ocp-date", valid_569318
  var valid_569319 = header.getOrDefault("return-client-request-id")
  valid_569319 = validateParameter(valid_569319, JBool, required = false,
                                 default = newJBool(false))
  if valid_569319 != nil:
    section.add "return-client-request-id", valid_569319
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

proc call*(call_569321: Call_ComputeNodeUploadBatchServiceLogs_569310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This is for gathering Azure Batch service log files in an automated fashion from nodes if you are experiencing an error and wish to escalate to Azure support. The Azure Batch service log files should be shared with Azure support to aid in debugging issues with the Batch service.
  ## 
  let valid = call_569321.validator(path, query, header, formData, body)
  let scheme = call_569321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569321.url(scheme.get, call_569321.host, call_569321.base,
                         call_569321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569321, url, valid)

proc call*(call_569322: Call_ComputeNodeUploadBatchServiceLogs_569310;
          apiVersion: string; poolId: string; nodeId: string;
          uploadBatchServiceLogsConfiguration: JsonNode; timeout: int = 30): Recallable =
  ## computeNodeUploadBatchServiceLogs
  ## This is for gathering Azure Batch service log files in an automated fashion from nodes if you are experiencing an error and wish to escalate to Azure support. The Azure Batch service log files should be shared with Azure support to aid in debugging issues with the Batch service.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the compute node from which you want to upload the Azure Batch service log files.
  ##   uploadBatchServiceLogsConfiguration: JObject (required)
  ##                                      : The Azure Batch service log files upload configuration.
  var path_569323 = newJObject()
  var query_569324 = newJObject()
  var body_569325 = newJObject()
  add(query_569324, "timeout", newJInt(timeout))
  add(query_569324, "api-version", newJString(apiVersion))
  add(path_569323, "poolId", newJString(poolId))
  add(path_569323, "nodeId", newJString(nodeId))
  if uploadBatchServiceLogsConfiguration != nil:
    body_569325 = uploadBatchServiceLogsConfiguration
  result = call_569322.call(path_569323, query_569324, nil, nil, body_569325)

var computeNodeUploadBatchServiceLogs* = Call_ComputeNodeUploadBatchServiceLogs_569310(
    name: "computeNodeUploadBatchServiceLogs", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/uploadbatchservicelogs",
    validator: validate_ComputeNodeUploadBatchServiceLogs_569311, base: "",
    url: url_ComputeNodeUploadBatchServiceLogs_569312, schemes: {Scheme.Https})
type
  Call_ComputeNodeAddUser_569326 = ref object of OpenApiRestCall_567667
proc url_ComputeNodeAddUser_569328(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeAddUser_569327(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## You can add a user account to a node only when it is in the idle or running state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the machine on which you want to create a user account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569329 = path.getOrDefault("poolId")
  valid_569329 = validateParameter(valid_569329, JString, required = true,
                                 default = nil)
  if valid_569329 != nil:
    section.add "poolId", valid_569329
  var valid_569330 = path.getOrDefault("nodeId")
  valid_569330 = validateParameter(valid_569330, JString, required = true,
                                 default = nil)
  if valid_569330 != nil:
    section.add "nodeId", valid_569330
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569331 = query.getOrDefault("timeout")
  valid_569331 = validateParameter(valid_569331, JInt, required = false,
                                 default = newJInt(30))
  if valid_569331 != nil:
    section.add "timeout", valid_569331
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569332 = query.getOrDefault("api-version")
  valid_569332 = validateParameter(valid_569332, JString, required = true,
                                 default = nil)
  if valid_569332 != nil:
    section.add "api-version", valid_569332
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569333 = header.getOrDefault("client-request-id")
  valid_569333 = validateParameter(valid_569333, JString, required = false,
                                 default = nil)
  if valid_569333 != nil:
    section.add "client-request-id", valid_569333
  var valid_569334 = header.getOrDefault("ocp-date")
  valid_569334 = validateParameter(valid_569334, JString, required = false,
                                 default = nil)
  if valid_569334 != nil:
    section.add "ocp-date", valid_569334
  var valid_569335 = header.getOrDefault("return-client-request-id")
  valid_569335 = validateParameter(valid_569335, JBool, required = false,
                                 default = newJBool(false))
  if valid_569335 != nil:
    section.add "return-client-request-id", valid_569335
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   user: JObject (required)
  ##       : The user account to be created.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569337: Call_ComputeNodeAddUser_569326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can add a user account to a node only when it is in the idle or running state.
  ## 
  let valid = call_569337.validator(path, query, header, formData, body)
  let scheme = call_569337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569337.url(scheme.get, call_569337.host, call_569337.base,
                         call_569337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569337, url, valid)

proc call*(call_569338: Call_ComputeNodeAddUser_569326; apiVersion: string;
          user: JsonNode; poolId: string; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeAddUser
  ## You can add a user account to a node only when it is in the idle or running state.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   user: JObject (required)
  ##       : The user account to be created.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the machine on which you want to create a user account.
  var path_569339 = newJObject()
  var query_569340 = newJObject()
  var body_569341 = newJObject()
  add(query_569340, "timeout", newJInt(timeout))
  add(query_569340, "api-version", newJString(apiVersion))
  if user != nil:
    body_569341 = user
  add(path_569339, "poolId", newJString(poolId))
  add(path_569339, "nodeId", newJString(nodeId))
  result = call_569338.call(path_569339, query_569340, nil, nil, body_569341)

var computeNodeAddUser* = Call_ComputeNodeAddUser_569326(
    name: "computeNodeAddUser", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/users",
    validator: validate_ComputeNodeAddUser_569327, base: "",
    url: url_ComputeNodeAddUser_569328, schemes: {Scheme.Https})
type
  Call_ComputeNodeUpdateUser_569342 = ref object of OpenApiRestCall_567667
proc url_ComputeNodeUpdateUser_569344(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeUpdateUser_569343(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation replaces of all the updatable properties of the account. For example, if the expiryTime element is not specified, the current value is replaced with the default value, not left unmodified. You can update a user account on a node only when it is in the idle or running state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the machine on which you want to update a user account.
  ##   userName: JString (required)
  ##           : The name of the user account to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569345 = path.getOrDefault("poolId")
  valid_569345 = validateParameter(valid_569345, JString, required = true,
                                 default = nil)
  if valid_569345 != nil:
    section.add "poolId", valid_569345
  var valid_569346 = path.getOrDefault("nodeId")
  valid_569346 = validateParameter(valid_569346, JString, required = true,
                                 default = nil)
  if valid_569346 != nil:
    section.add "nodeId", valid_569346
  var valid_569347 = path.getOrDefault("userName")
  valid_569347 = validateParameter(valid_569347, JString, required = true,
                                 default = nil)
  if valid_569347 != nil:
    section.add "userName", valid_569347
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569348 = query.getOrDefault("timeout")
  valid_569348 = validateParameter(valid_569348, JInt, required = false,
                                 default = newJInt(30))
  if valid_569348 != nil:
    section.add "timeout", valid_569348
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569349 = query.getOrDefault("api-version")
  valid_569349 = validateParameter(valid_569349, JString, required = true,
                                 default = nil)
  if valid_569349 != nil:
    section.add "api-version", valid_569349
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569350 = header.getOrDefault("client-request-id")
  valid_569350 = validateParameter(valid_569350, JString, required = false,
                                 default = nil)
  if valid_569350 != nil:
    section.add "client-request-id", valid_569350
  var valid_569351 = header.getOrDefault("ocp-date")
  valid_569351 = validateParameter(valid_569351, JString, required = false,
                                 default = nil)
  if valid_569351 != nil:
    section.add "ocp-date", valid_569351
  var valid_569352 = header.getOrDefault("return-client-request-id")
  valid_569352 = validateParameter(valid_569352, JBool, required = false,
                                 default = newJBool(false))
  if valid_569352 != nil:
    section.add "return-client-request-id", valid_569352
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

proc call*(call_569354: Call_ComputeNodeUpdateUser_569342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation replaces of all the updatable properties of the account. For example, if the expiryTime element is not specified, the current value is replaced with the default value, not left unmodified. You can update a user account on a node only when it is in the idle or running state.
  ## 
  let valid = call_569354.validator(path, query, header, formData, body)
  let scheme = call_569354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569354.url(scheme.get, call_569354.host, call_569354.base,
                         call_569354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569354, url, valid)

proc call*(call_569355: Call_ComputeNodeUpdateUser_569342; apiVersion: string;
          poolId: string; nodeId: string; nodeUpdateUserParameter: JsonNode;
          userName: string; timeout: int = 30): Recallable =
  ## computeNodeUpdateUser
  ## This operation replaces of all the updatable properties of the account. For example, if the expiryTime element is not specified, the current value is replaced with the default value, not left unmodified. You can update a user account on a node only when it is in the idle or running state.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the machine on which you want to update a user account.
  ##   nodeUpdateUserParameter: JObject (required)
  ##                          : The parameters for the request.
  ##   userName: string (required)
  ##           : The name of the user account to update.
  var path_569356 = newJObject()
  var query_569357 = newJObject()
  var body_569358 = newJObject()
  add(query_569357, "timeout", newJInt(timeout))
  add(query_569357, "api-version", newJString(apiVersion))
  add(path_569356, "poolId", newJString(poolId))
  add(path_569356, "nodeId", newJString(nodeId))
  if nodeUpdateUserParameter != nil:
    body_569358 = nodeUpdateUserParameter
  add(path_569356, "userName", newJString(userName))
  result = call_569355.call(path_569356, query_569357, nil, nil, body_569358)

var computeNodeUpdateUser* = Call_ComputeNodeUpdateUser_569342(
    name: "computeNodeUpdateUser", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/users/{userName}",
    validator: validate_ComputeNodeUpdateUser_569343, base: "",
    url: url_ComputeNodeUpdateUser_569344, schemes: {Scheme.Https})
type
  Call_ComputeNodeDeleteUser_569359 = ref object of OpenApiRestCall_567667
proc url_ComputeNodeDeleteUser_569361(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeDeleteUser_569360(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can delete a user account to a node only when it is in the idle or running state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: JString (required)
  ##         : The ID of the machine on which you want to delete a user account.
  ##   userName: JString (required)
  ##           : The name of the user account to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569362 = path.getOrDefault("poolId")
  valid_569362 = validateParameter(valid_569362, JString, required = true,
                                 default = nil)
  if valid_569362 != nil:
    section.add "poolId", valid_569362
  var valid_569363 = path.getOrDefault("nodeId")
  valid_569363 = validateParameter(valid_569363, JString, required = true,
                                 default = nil)
  if valid_569363 != nil:
    section.add "nodeId", valid_569363
  var valid_569364 = path.getOrDefault("userName")
  valid_569364 = validateParameter(valid_569364, JString, required = true,
                                 default = nil)
  if valid_569364 != nil:
    section.add "userName", valid_569364
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569365 = query.getOrDefault("timeout")
  valid_569365 = validateParameter(valid_569365, JInt, required = false,
                                 default = newJInt(30))
  if valid_569365 != nil:
    section.add "timeout", valid_569365
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569366 = query.getOrDefault("api-version")
  valid_569366 = validateParameter(valid_569366, JString, required = true,
                                 default = nil)
  if valid_569366 != nil:
    section.add "api-version", valid_569366
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569367 = header.getOrDefault("client-request-id")
  valid_569367 = validateParameter(valid_569367, JString, required = false,
                                 default = nil)
  if valid_569367 != nil:
    section.add "client-request-id", valid_569367
  var valid_569368 = header.getOrDefault("ocp-date")
  valid_569368 = validateParameter(valid_569368, JString, required = false,
                                 default = nil)
  if valid_569368 != nil:
    section.add "ocp-date", valid_569368
  var valid_569369 = header.getOrDefault("return-client-request-id")
  valid_569369 = validateParameter(valid_569369, JBool, required = false,
                                 default = newJBool(false))
  if valid_569369 != nil:
    section.add "return-client-request-id", valid_569369
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569370: Call_ComputeNodeDeleteUser_569359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can delete a user account to a node only when it is in the idle or running state.
  ## 
  let valid = call_569370.validator(path, query, header, formData, body)
  let scheme = call_569370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569370.url(scheme.get, call_569370.host, call_569370.base,
                         call_569370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569370, url, valid)

proc call*(call_569371: Call_ComputeNodeDeleteUser_569359; apiVersion: string;
          poolId: string; nodeId: string; userName: string; timeout: int = 30): Recallable =
  ## computeNodeDeleteUser
  ## You can delete a user account to a node only when it is in the idle or running state.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeId: string (required)
  ##         : The ID of the machine on which you want to delete a user account.
  ##   userName: string (required)
  ##           : The name of the user account to delete.
  var path_569372 = newJObject()
  var query_569373 = newJObject()
  add(query_569373, "timeout", newJInt(timeout))
  add(query_569373, "api-version", newJString(apiVersion))
  add(path_569372, "poolId", newJString(poolId))
  add(path_569372, "nodeId", newJString(nodeId))
  add(path_569372, "userName", newJString(userName))
  result = call_569371.call(path_569372, query_569373, nil, nil, nil)

var computeNodeDeleteUser* = Call_ComputeNodeDeleteUser_569359(
    name: "computeNodeDeleteUser", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/users/{userName}",
    validator: validate_ComputeNodeDeleteUser_569360, base: "",
    url: url_ComputeNodeDeleteUser_569361, schemes: {Scheme.Https})
type
  Call_PoolRemoveNodes_569374 = ref object of OpenApiRestCall_567667
proc url_PoolRemoveNodes_569376(protocol: Scheme; host: string; base: string;
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

proc validate_PoolRemoveNodes_569375(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## This operation can only run when the allocation state of the pool is steady. When this operation runs, the allocation state changes from steady to resizing.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool from which you want to remove nodes.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569377 = path.getOrDefault("poolId")
  valid_569377 = validateParameter(valid_569377, JString, required = true,
                                 default = nil)
  if valid_569377 != nil:
    section.add "poolId", valid_569377
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569378 = query.getOrDefault("timeout")
  valid_569378 = validateParameter(valid_569378, JInt, required = false,
                                 default = newJInt(30))
  if valid_569378 != nil:
    section.add "timeout", valid_569378
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569379 = query.getOrDefault("api-version")
  valid_569379 = validateParameter(valid_569379, JString, required = true,
                                 default = nil)
  if valid_569379 != nil:
    section.add "api-version", valid_569379
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
  var valid_569380 = header.getOrDefault("If-Match")
  valid_569380 = validateParameter(valid_569380, JString, required = false,
                                 default = nil)
  if valid_569380 != nil:
    section.add "If-Match", valid_569380
  var valid_569381 = header.getOrDefault("client-request-id")
  valid_569381 = validateParameter(valid_569381, JString, required = false,
                                 default = nil)
  if valid_569381 != nil:
    section.add "client-request-id", valid_569381
  var valid_569382 = header.getOrDefault("ocp-date")
  valid_569382 = validateParameter(valid_569382, JString, required = false,
                                 default = nil)
  if valid_569382 != nil:
    section.add "ocp-date", valid_569382
  var valid_569383 = header.getOrDefault("If-Unmodified-Since")
  valid_569383 = validateParameter(valid_569383, JString, required = false,
                                 default = nil)
  if valid_569383 != nil:
    section.add "If-Unmodified-Since", valid_569383
  var valid_569384 = header.getOrDefault("If-None-Match")
  valid_569384 = validateParameter(valid_569384, JString, required = false,
                                 default = nil)
  if valid_569384 != nil:
    section.add "If-None-Match", valid_569384
  var valid_569385 = header.getOrDefault("If-Modified-Since")
  valid_569385 = validateParameter(valid_569385, JString, required = false,
                                 default = nil)
  if valid_569385 != nil:
    section.add "If-Modified-Since", valid_569385
  var valid_569386 = header.getOrDefault("return-client-request-id")
  valid_569386 = validateParameter(valid_569386, JBool, required = false,
                                 default = newJBool(false))
  if valid_569386 != nil:
    section.add "return-client-request-id", valid_569386
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

proc call*(call_569388: Call_PoolRemoveNodes_569374; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation can only run when the allocation state of the pool is steady. When this operation runs, the allocation state changes from steady to resizing.
  ## 
  let valid = call_569388.validator(path, query, header, formData, body)
  let scheme = call_569388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569388.url(scheme.get, call_569388.host, call_569388.base,
                         call_569388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569388, url, valid)

proc call*(call_569389: Call_PoolRemoveNodes_569374; apiVersion: string;
          poolId: string; nodeRemoveParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolRemoveNodes
  ## This operation can only run when the allocation state of the pool is steady. When this operation runs, the allocation state changes from steady to resizing.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool from which you want to remove nodes.
  ##   nodeRemoveParameter: JObject (required)
  ##                      : The parameters for the request.
  var path_569390 = newJObject()
  var query_569391 = newJObject()
  var body_569392 = newJObject()
  add(query_569391, "timeout", newJInt(timeout))
  add(query_569391, "api-version", newJString(apiVersion))
  add(path_569390, "poolId", newJString(poolId))
  if nodeRemoveParameter != nil:
    body_569392 = nodeRemoveParameter
  result = call_569389.call(path_569390, query_569391, nil, nil, body_569392)

var poolRemoveNodes* = Call_PoolRemoveNodes_569374(name: "poolRemoveNodes",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/removenodes", validator: validate_PoolRemoveNodes_569375,
    base: "", url: url_PoolRemoveNodes_569376, schemes: {Scheme.Https})
type
  Call_PoolResize_569393 = ref object of OpenApiRestCall_567667
proc url_PoolResize_569395(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolResize_569394(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## You can only resize a pool when its allocation state is steady. If the pool is already resizing, the request fails with status code 409. When you resize a pool, the pool's allocation state changes from steady to resizing. You cannot resize pools which are configured for automatic scaling. If you try to do this, the Batch service returns an error 409. If you resize a pool downwards, the Batch service chooses which nodes to remove. To remove specific nodes, use the pool remove nodes API instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool to resize.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569396 = path.getOrDefault("poolId")
  valid_569396 = validateParameter(valid_569396, JString, required = true,
                                 default = nil)
  if valid_569396 != nil:
    section.add "poolId", valid_569396
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569397 = query.getOrDefault("timeout")
  valid_569397 = validateParameter(valid_569397, JInt, required = false,
                                 default = newJInt(30))
  if valid_569397 != nil:
    section.add "timeout", valid_569397
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569398 = query.getOrDefault("api-version")
  valid_569398 = validateParameter(valid_569398, JString, required = true,
                                 default = nil)
  if valid_569398 != nil:
    section.add "api-version", valid_569398
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
  var valid_569399 = header.getOrDefault("If-Match")
  valid_569399 = validateParameter(valid_569399, JString, required = false,
                                 default = nil)
  if valid_569399 != nil:
    section.add "If-Match", valid_569399
  var valid_569400 = header.getOrDefault("client-request-id")
  valid_569400 = validateParameter(valid_569400, JString, required = false,
                                 default = nil)
  if valid_569400 != nil:
    section.add "client-request-id", valid_569400
  var valid_569401 = header.getOrDefault("ocp-date")
  valid_569401 = validateParameter(valid_569401, JString, required = false,
                                 default = nil)
  if valid_569401 != nil:
    section.add "ocp-date", valid_569401
  var valid_569402 = header.getOrDefault("If-Unmodified-Since")
  valid_569402 = validateParameter(valid_569402, JString, required = false,
                                 default = nil)
  if valid_569402 != nil:
    section.add "If-Unmodified-Since", valid_569402
  var valid_569403 = header.getOrDefault("If-None-Match")
  valid_569403 = validateParameter(valid_569403, JString, required = false,
                                 default = nil)
  if valid_569403 != nil:
    section.add "If-None-Match", valid_569403
  var valid_569404 = header.getOrDefault("If-Modified-Since")
  valid_569404 = validateParameter(valid_569404, JString, required = false,
                                 default = nil)
  if valid_569404 != nil:
    section.add "If-Modified-Since", valid_569404
  var valid_569405 = header.getOrDefault("return-client-request-id")
  valid_569405 = validateParameter(valid_569405, JBool, required = false,
                                 default = newJBool(false))
  if valid_569405 != nil:
    section.add "return-client-request-id", valid_569405
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

proc call*(call_569407: Call_PoolResize_569393; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can only resize a pool when its allocation state is steady. If the pool is already resizing, the request fails with status code 409. When you resize a pool, the pool's allocation state changes from steady to resizing. You cannot resize pools which are configured for automatic scaling. If you try to do this, the Batch service returns an error 409. If you resize a pool downwards, the Batch service chooses which nodes to remove. To remove specific nodes, use the pool remove nodes API instead.
  ## 
  let valid = call_569407.validator(path, query, header, formData, body)
  let scheme = call_569407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569407.url(scheme.get, call_569407.host, call_569407.base,
                         call_569407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569407, url, valid)

proc call*(call_569408: Call_PoolResize_569393; apiVersion: string; poolId: string;
          poolResizeParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolResize
  ## You can only resize a pool when its allocation state is steady. If the pool is already resizing, the request fails with status code 409. When you resize a pool, the pool's allocation state changes from steady to resizing. You cannot resize pools which are configured for automatic scaling. If you try to do this, the Batch service returns an error 409. If you resize a pool downwards, the Batch service chooses which nodes to remove. To remove specific nodes, use the pool remove nodes API instead.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool to resize.
  ##   poolResizeParameter: JObject (required)
  ##                      : The parameters for the request.
  var path_569409 = newJObject()
  var query_569410 = newJObject()
  var body_569411 = newJObject()
  add(query_569410, "timeout", newJInt(timeout))
  add(query_569410, "api-version", newJString(apiVersion))
  add(path_569409, "poolId", newJString(poolId))
  if poolResizeParameter != nil:
    body_569411 = poolResizeParameter
  result = call_569408.call(path_569409, query_569410, nil, nil, body_569411)

var poolResize* = Call_PoolResize_569393(name: "poolResize",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local",
                                      route: "/pools/{poolId}/resize",
                                      validator: validate_PoolResize_569394,
                                      base: "", url: url_PoolResize_569395,
                                      schemes: {Scheme.Https})
type
  Call_PoolStopResize_569412 = ref object of OpenApiRestCall_567667
proc url_PoolStopResize_569414(protocol: Scheme; host: string; base: string;
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

proc validate_PoolStopResize_569413(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## This does not restore the pool to its previous state before the resize operation: it only stops any further changes being made, and the pool maintains its current state. After stopping, the pool stabilizes at the number of nodes it was at when the stop operation was done. During the stop operation, the pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize pool request; this API can also be used to halt the initial sizing of the pool when it is created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool whose resizing you want to stop.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569415 = path.getOrDefault("poolId")
  valid_569415 = validateParameter(valid_569415, JString, required = true,
                                 default = nil)
  if valid_569415 != nil:
    section.add "poolId", valid_569415
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569416 = query.getOrDefault("timeout")
  valid_569416 = validateParameter(valid_569416, JInt, required = false,
                                 default = newJInt(30))
  if valid_569416 != nil:
    section.add "timeout", valid_569416
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569417 = query.getOrDefault("api-version")
  valid_569417 = validateParameter(valid_569417, JString, required = true,
                                 default = nil)
  if valid_569417 != nil:
    section.add "api-version", valid_569417
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
  var valid_569418 = header.getOrDefault("If-Match")
  valid_569418 = validateParameter(valid_569418, JString, required = false,
                                 default = nil)
  if valid_569418 != nil:
    section.add "If-Match", valid_569418
  var valid_569419 = header.getOrDefault("client-request-id")
  valid_569419 = validateParameter(valid_569419, JString, required = false,
                                 default = nil)
  if valid_569419 != nil:
    section.add "client-request-id", valid_569419
  var valid_569420 = header.getOrDefault("ocp-date")
  valid_569420 = validateParameter(valid_569420, JString, required = false,
                                 default = nil)
  if valid_569420 != nil:
    section.add "ocp-date", valid_569420
  var valid_569421 = header.getOrDefault("If-Unmodified-Since")
  valid_569421 = validateParameter(valid_569421, JString, required = false,
                                 default = nil)
  if valid_569421 != nil:
    section.add "If-Unmodified-Since", valid_569421
  var valid_569422 = header.getOrDefault("If-None-Match")
  valid_569422 = validateParameter(valid_569422, JString, required = false,
                                 default = nil)
  if valid_569422 != nil:
    section.add "If-None-Match", valid_569422
  var valid_569423 = header.getOrDefault("If-Modified-Since")
  valid_569423 = validateParameter(valid_569423, JString, required = false,
                                 default = nil)
  if valid_569423 != nil:
    section.add "If-Modified-Since", valid_569423
  var valid_569424 = header.getOrDefault("return-client-request-id")
  valid_569424 = validateParameter(valid_569424, JBool, required = false,
                                 default = newJBool(false))
  if valid_569424 != nil:
    section.add "return-client-request-id", valid_569424
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569425: Call_PoolStopResize_569412; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This does not restore the pool to its previous state before the resize operation: it only stops any further changes being made, and the pool maintains its current state. After stopping, the pool stabilizes at the number of nodes it was at when the stop operation was done. During the stop operation, the pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize pool request; this API can also be used to halt the initial sizing of the pool when it is created.
  ## 
  let valid = call_569425.validator(path, query, header, formData, body)
  let scheme = call_569425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569425.url(scheme.get, call_569425.host, call_569425.base,
                         call_569425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569425, url, valid)

proc call*(call_569426: Call_PoolStopResize_569412; apiVersion: string;
          poolId: string; timeout: int = 30): Recallable =
  ## poolStopResize
  ## This does not restore the pool to its previous state before the resize operation: it only stops any further changes being made, and the pool maintains its current state. After stopping, the pool stabilizes at the number of nodes it was at when the stop operation was done. During the stop operation, the pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize pool request; this API can also be used to halt the initial sizing of the pool when it is created.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool whose resizing you want to stop.
  var path_569427 = newJObject()
  var query_569428 = newJObject()
  add(query_569428, "timeout", newJInt(timeout))
  add(query_569428, "api-version", newJString(apiVersion))
  add(path_569427, "poolId", newJString(poolId))
  result = call_569426.call(path_569427, query_569428, nil, nil, nil)

var poolStopResize* = Call_PoolStopResize_569412(name: "poolStopResize",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/stopresize", validator: validate_PoolStopResize_569413,
    base: "", url: url_PoolStopResize_569414, schemes: {Scheme.Https})
type
  Call_PoolUpdateProperties_569429 = ref object of OpenApiRestCall_567667
proc url_PoolUpdateProperties_569431(protocol: Scheme; host: string; base: string;
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

proc validate_PoolUpdateProperties_569430(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This fully replaces all the updatable properties of the pool. For example, if the pool has a start task associated with it and if start task is not specified with this request, then the Batch service will remove the existing start task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_569432 = path.getOrDefault("poolId")
  valid_569432 = validateParameter(valid_569432, JString, required = true,
                                 default = nil)
  if valid_569432 != nil:
    section.add "poolId", valid_569432
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_569433 = query.getOrDefault("timeout")
  valid_569433 = validateParameter(valid_569433, JInt, required = false,
                                 default = newJInt(30))
  if valid_569433 != nil:
    section.add "timeout", valid_569433
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569434 = query.getOrDefault("api-version")
  valid_569434 = validateParameter(valid_569434, JString, required = true,
                                 default = nil)
  if valid_569434 != nil:
    section.add "api-version", valid_569434
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569435 = header.getOrDefault("client-request-id")
  valid_569435 = validateParameter(valid_569435, JString, required = false,
                                 default = nil)
  if valid_569435 != nil:
    section.add "client-request-id", valid_569435
  var valid_569436 = header.getOrDefault("ocp-date")
  valid_569436 = validateParameter(valid_569436, JString, required = false,
                                 default = nil)
  if valid_569436 != nil:
    section.add "ocp-date", valid_569436
  var valid_569437 = header.getOrDefault("return-client-request-id")
  valid_569437 = validateParameter(valid_569437, JBool, required = false,
                                 default = newJBool(false))
  if valid_569437 != nil:
    section.add "return-client-request-id", valid_569437
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

proc call*(call_569439: Call_PoolUpdateProperties_569429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This fully replaces all the updatable properties of the pool. For example, if the pool has a start task associated with it and if start task is not specified with this request, then the Batch service will remove the existing start task.
  ## 
  let valid = call_569439.validator(path, query, header, formData, body)
  let scheme = call_569439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569439.url(scheme.get, call_569439.host, call_569439.base,
                         call_569439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569439, url, valid)

proc call*(call_569440: Call_PoolUpdateProperties_569429; apiVersion: string;
          poolId: string; poolUpdatePropertiesParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolUpdateProperties
  ## This fully replaces all the updatable properties of the pool. For example, if the pool has a start task associated with it and if start task is not specified with this request, then the Batch service will remove the existing start task.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool to update.
  ##   poolUpdatePropertiesParameter: JObject (required)
  ##                                : The parameters for the request.
  var path_569441 = newJObject()
  var query_569442 = newJObject()
  var body_569443 = newJObject()
  add(query_569442, "timeout", newJInt(timeout))
  add(query_569442, "api-version", newJString(apiVersion))
  add(path_569441, "poolId", newJString(poolId))
  if poolUpdatePropertiesParameter != nil:
    body_569443 = poolUpdatePropertiesParameter
  result = call_569440.call(path_569441, query_569442, nil, nil, body_569443)

var poolUpdateProperties* = Call_PoolUpdateProperties_569429(
    name: "poolUpdateProperties", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/updateproperties",
    validator: validate_PoolUpdateProperties_569430, base: "",
    url: url_PoolUpdateProperties_569431, schemes: {Scheme.Https})
type
  Call_PoolListUsageMetrics_569444 = ref object of OpenApiRestCall_567667
proc url_PoolListUsageMetrics_569446(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolListUsageMetrics_569445(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## If you do not specify a $filter clause including a poolId, the response includes all pools that existed in the account in the time range of the returned aggregation intervals. If you do not specify a $filter clause including a startTime or endTime these filters default to the start and end times of the last aggregation interval currently available; that is, only the last aggregation interval is returned.
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
  var valid_569447 = query.getOrDefault("timeout")
  valid_569447 = validateParameter(valid_569447, JInt, required = false,
                                 default = newJInt(30))
  if valid_569447 != nil:
    section.add "timeout", valid_569447
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569448 = query.getOrDefault("api-version")
  valid_569448 = validateParameter(valid_569448, JString, required = true,
                                 default = nil)
  if valid_569448 != nil:
    section.add "api-version", valid_569448
  var valid_569449 = query.getOrDefault("endtime")
  valid_569449 = validateParameter(valid_569449, JString, required = false,
                                 default = nil)
  if valid_569449 != nil:
    section.add "endtime", valid_569449
  var valid_569450 = query.getOrDefault("maxresults")
  valid_569450 = validateParameter(valid_569450, JInt, required = false,
                                 default = newJInt(1000))
  if valid_569450 != nil:
    section.add "maxresults", valid_569450
  var valid_569451 = query.getOrDefault("starttime")
  valid_569451 = validateParameter(valid_569451, JString, required = false,
                                 default = nil)
  if valid_569451 != nil:
    section.add "starttime", valid_569451
  var valid_569452 = query.getOrDefault("$filter")
  valid_569452 = validateParameter(valid_569452, JString, required = false,
                                 default = nil)
  if valid_569452 != nil:
    section.add "$filter", valid_569452
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_569453 = header.getOrDefault("client-request-id")
  valid_569453 = validateParameter(valid_569453, JString, required = false,
                                 default = nil)
  if valid_569453 != nil:
    section.add "client-request-id", valid_569453
  var valid_569454 = header.getOrDefault("ocp-date")
  valid_569454 = validateParameter(valid_569454, JString, required = false,
                                 default = nil)
  if valid_569454 != nil:
    section.add "ocp-date", valid_569454
  var valid_569455 = header.getOrDefault("return-client-request-id")
  valid_569455 = validateParameter(valid_569455, JBool, required = false,
                                 default = newJBool(false))
  if valid_569455 != nil:
    section.add "return-client-request-id", valid_569455
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569456: Call_PoolListUsageMetrics_569444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If you do not specify a $filter clause including a poolId, the response includes all pools that existed in the account in the time range of the returned aggregation intervals. If you do not specify a $filter clause including a startTime or endTime these filters default to the start and end times of the last aggregation interval currently available; that is, only the last aggregation interval is returned.
  ## 
  let valid = call_569456.validator(path, query, header, formData, body)
  let scheme = call_569456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569456.url(scheme.get, call_569456.host, call_569456.base,
                         call_569456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569456, url, valid)

proc call*(call_569457: Call_PoolListUsageMetrics_569444; apiVersion: string;
          timeout: int = 30; endtime: string = ""; maxresults: int = 1000;
          starttime: string = ""; Filter: string = ""): Recallable =
  ## poolListUsageMetrics
  ## If you do not specify a $filter clause including a poolId, the response includes all pools that existed in the account in the time range of the returned aggregation intervals. If you do not specify a $filter clause including a startTime or endTime these filters default to the start and end times of the last aggregation interval currently available; that is, only the last aggregation interval is returned.
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
  var query_569458 = newJObject()
  add(query_569458, "timeout", newJInt(timeout))
  add(query_569458, "api-version", newJString(apiVersion))
  add(query_569458, "endtime", newJString(endtime))
  add(query_569458, "maxresults", newJInt(maxresults))
  add(query_569458, "starttime", newJString(starttime))
  add(query_569458, "$filter", newJString(Filter))
  result = call_569457.call(nil, query_569458, nil, nil, nil)

var poolListUsageMetrics* = Call_PoolListUsageMetrics_569444(
    name: "poolListUsageMetrics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/poolusagemetrics", validator: validate_PoolListUsageMetrics_569445,
    base: "", url: url_PoolListUsageMetrics_569446, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
