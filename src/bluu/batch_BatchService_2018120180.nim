
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  macServiceName = "batch-BatchService"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApplicationList_563787 = ref object of OpenApiRestCall_563565
proc url_ApplicationList_563789(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationList_563788(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## This operation returns only applications and versions that are available for use on compute nodes; that is, that can be used in an application package reference. For administrator information about applications and versions that are not yet available to compute nodes, use the Azure portal or the Azure Resource Manager API.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 applications can be returned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563950 = query.getOrDefault("api-version")
  valid_563950 = validateParameter(valid_563950, JString, required = true,
                                 default = nil)
  if valid_563950 != nil:
    section.add "api-version", valid_563950
  var valid_563965 = query.getOrDefault("timeout")
  valid_563965 = validateParameter(valid_563965, JInt, required = false,
                                 default = newJInt(30))
  if valid_563965 != nil:
    section.add "timeout", valid_563965
  var valid_563966 = query.getOrDefault("maxresults")
  valid_563966 = validateParameter(valid_563966, JInt, required = false,
                                 default = newJInt(1000))
  if valid_563966 != nil:
    section.add "maxresults", valid_563966
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_563967 = header.getOrDefault("return-client-request-id")
  valid_563967 = validateParameter(valid_563967, JBool, required = false,
                                 default = newJBool(false))
  if valid_563967 != nil:
    section.add "return-client-request-id", valid_563967
  var valid_563968 = header.getOrDefault("client-request-id")
  valid_563968 = validateParameter(valid_563968, JString, required = false,
                                 default = nil)
  if valid_563968 != nil:
    section.add "client-request-id", valid_563968
  var valid_563969 = header.getOrDefault("ocp-date")
  valid_563969 = validateParameter(valid_563969, JString, required = false,
                                 default = nil)
  if valid_563969 != nil:
    section.add "ocp-date", valid_563969
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563992: Call_ApplicationList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation returns only applications and versions that are available for use on compute nodes; that is, that can be used in an application package reference. For administrator information about applications and versions that are not yet available to compute nodes, use the Azure portal or the Azure Resource Manager API.
  ## 
  let valid = call_563992.validator(path, query, header, formData, body)
  let scheme = call_563992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563992.url(scheme.get, call_563992.host, call_563992.base,
                         call_563992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563992, url, valid)

proc call*(call_564063: Call_ApplicationList_563787; apiVersion: string;
          timeout: int = 30; maxresults: int = 1000): Recallable =
  ## applicationList
  ## This operation returns only applications and versions that are available for use on compute nodes; that is, that can be used in an application package reference. For administrator information about applications and versions that are not yet available to compute nodes, use the Azure portal or the Azure Resource Manager API.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 applications can be returned.
  var query_564064 = newJObject()
  add(query_564064, "api-version", newJString(apiVersion))
  add(query_564064, "timeout", newJInt(timeout))
  add(query_564064, "maxresults", newJInt(maxresults))
  result = call_564063.call(nil, query_564064, nil, nil, nil)

var applicationList* = Call_ApplicationList_563787(name: "applicationList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/applications",
    validator: validate_ApplicationList_563788, base: "", url: url_ApplicationList_563789,
    schemes: {Scheme.Https})
type
  Call_ApplicationGet_564104 = ref object of OpenApiRestCall_563565
proc url_ApplicationGet_564106(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGet_564105(path: JsonNode; query: JsonNode;
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
  var valid_564121 = path.getOrDefault("applicationId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "applicationId", valid_564121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564122 = query.getOrDefault("api-version")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "api-version", valid_564122
  var valid_564123 = query.getOrDefault("timeout")
  valid_564123 = validateParameter(valid_564123, JInt, required = false,
                                 default = newJInt(30))
  if valid_564123 != nil:
    section.add "timeout", valid_564123
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564124 = header.getOrDefault("return-client-request-id")
  valid_564124 = validateParameter(valid_564124, JBool, required = false,
                                 default = newJBool(false))
  if valid_564124 != nil:
    section.add "return-client-request-id", valid_564124
  var valid_564125 = header.getOrDefault("client-request-id")
  valid_564125 = validateParameter(valid_564125, JString, required = false,
                                 default = nil)
  if valid_564125 != nil:
    section.add "client-request-id", valid_564125
  var valid_564126 = header.getOrDefault("ocp-date")
  valid_564126 = validateParameter(valid_564126, JString, required = false,
                                 default = nil)
  if valid_564126 != nil:
    section.add "ocp-date", valid_564126
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564127: Call_ApplicationGet_564104; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation returns only applications and versions that are available for use on compute nodes; that is, that can be used in an application package reference. For administrator information about applications and versions that are not yet available to compute nodes, use the Azure portal or the Azure Resource Manager API.
  ## 
  let valid = call_564127.validator(path, query, header, formData, body)
  let scheme = call_564127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564127.url(scheme.get, call_564127.host, call_564127.base,
                         call_564127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564127, url, valid)

proc call*(call_564128: Call_ApplicationGet_564104; apiVersion: string;
          applicationId: string; timeout: int = 30): Recallable =
  ## applicationGet
  ## This operation returns only applications and versions that are available for use on compute nodes; that is, that can be used in an application package reference. For administrator information about applications and versions that are not yet available to compute nodes, use the Azure portal or the Azure Resource Manager API.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   applicationId: string (required)
  ##                : The ID of the application.
  var path_564129 = newJObject()
  var query_564130 = newJObject()
  add(query_564130, "api-version", newJString(apiVersion))
  add(query_564130, "timeout", newJInt(timeout))
  add(path_564129, "applicationId", newJString(applicationId))
  result = call_564128.call(path_564129, query_564130, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_564104(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/applications/{applicationId}", validator: validate_ApplicationGet_564105,
    base: "", url: url_ApplicationGet_564106, schemes: {Scheme.Https})
type
  Call_CertificateAdd_564146 = ref object of OpenApiRestCall_563565
proc url_CertificateAdd_564148(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CertificateAdd_564147(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  var valid_564167 = query.getOrDefault("timeout")
  valid_564167 = validateParameter(valid_564167, JInt, required = false,
                                 default = newJInt(30))
  if valid_564167 != nil:
    section.add "timeout", valid_564167
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564168 = header.getOrDefault("return-client-request-id")
  valid_564168 = validateParameter(valid_564168, JBool, required = false,
                                 default = newJBool(false))
  if valid_564168 != nil:
    section.add "return-client-request-id", valid_564168
  var valid_564169 = header.getOrDefault("client-request-id")
  valid_564169 = validateParameter(valid_564169, JString, required = false,
                                 default = nil)
  if valid_564169 != nil:
    section.add "client-request-id", valid_564169
  var valid_564170 = header.getOrDefault("ocp-date")
  valid_564170 = validateParameter(valid_564170, JString, required = false,
                                 default = nil)
  if valid_564170 != nil:
    section.add "ocp-date", valid_564170
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

proc call*(call_564172: Call_CertificateAdd_564146; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564172.validator(path, query, header, formData, body)
  let scheme = call_564172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564172.url(scheme.get, call_564172.host, call_564172.base,
                         call_564172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564172, url, valid)

proc call*(call_564173: Call_CertificateAdd_564146; apiVersion: string;
          certificate: JsonNode; timeout: int = 30): Recallable =
  ## certificateAdd
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   certificate: JObject (required)
  ##              : The certificate to be added.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var query_564174 = newJObject()
  var body_564175 = newJObject()
  add(query_564174, "api-version", newJString(apiVersion))
  if certificate != nil:
    body_564175 = certificate
  add(query_564174, "timeout", newJInt(timeout))
  result = call_564173.call(nil, query_564174, nil, nil, body_564175)

var certificateAdd* = Call_CertificateAdd_564146(name: "certificateAdd",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/certificates",
    validator: validate_CertificateAdd_564147, base: "", url: url_CertificateAdd_564148,
    schemes: {Scheme.Https})
type
  Call_CertificateList_564131 = ref object of OpenApiRestCall_563565
proc url_CertificateList_564133(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CertificateList_564132(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 certificates can be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-certificates.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
  var valid_564136 = query.getOrDefault("$select")
  valid_564136 = validateParameter(valid_564136, JString, required = false,
                                 default = nil)
  if valid_564136 != nil:
    section.add "$select", valid_564136
  var valid_564137 = query.getOrDefault("timeout")
  valid_564137 = validateParameter(valid_564137, JInt, required = false,
                                 default = newJInt(30))
  if valid_564137 != nil:
    section.add "timeout", valid_564137
  var valid_564138 = query.getOrDefault("maxresults")
  valid_564138 = validateParameter(valid_564138, JInt, required = false,
                                 default = newJInt(1000))
  if valid_564138 != nil:
    section.add "maxresults", valid_564138
  var valid_564139 = query.getOrDefault("$filter")
  valid_564139 = validateParameter(valid_564139, JString, required = false,
                                 default = nil)
  if valid_564139 != nil:
    section.add "$filter", valid_564139
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564140 = header.getOrDefault("return-client-request-id")
  valid_564140 = validateParameter(valid_564140, JBool, required = false,
                                 default = newJBool(false))
  if valid_564140 != nil:
    section.add "return-client-request-id", valid_564140
  var valid_564141 = header.getOrDefault("client-request-id")
  valid_564141 = validateParameter(valid_564141, JString, required = false,
                                 default = nil)
  if valid_564141 != nil:
    section.add "client-request-id", valid_564141
  var valid_564142 = header.getOrDefault("ocp-date")
  valid_564142 = validateParameter(valid_564142, JString, required = false,
                                 default = nil)
  if valid_564142 != nil:
    section.add "ocp-date", valid_564142
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564143: Call_CertificateList_564131; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564143.validator(path, query, header, formData, body)
  let scheme = call_564143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564143.url(scheme.get, call_564143.host, call_564143.base,
                         call_564143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564143, url, valid)

proc call*(call_564144: Call_CertificateList_564131; apiVersion: string;
          Select: string = ""; timeout: int = 30; maxresults: int = 1000;
          Filter: string = ""): Recallable =
  ## certificateList
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 certificates can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-certificates.
  var query_564145 = newJObject()
  add(query_564145, "api-version", newJString(apiVersion))
  add(query_564145, "$select", newJString(Select))
  add(query_564145, "timeout", newJInt(timeout))
  add(query_564145, "maxresults", newJInt(maxresults))
  add(query_564145, "$filter", newJString(Filter))
  result = call_564144.call(nil, query_564145, nil, nil, nil)

var certificateList* = Call_CertificateList_564131(name: "certificateList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates",
    validator: validate_CertificateList_564132, base: "", url: url_CertificateList_564133,
    schemes: {Scheme.Https})
type
  Call_CertificateGet_564176 = ref object of OpenApiRestCall_563565
proc url_CertificateGet_564178(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateGet_564177(path: JsonNode; query: JsonNode;
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
  var valid_564179 = path.getOrDefault("thumbprintAlgorithm")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "thumbprintAlgorithm", valid_564179
  var valid_564180 = path.getOrDefault("thumbprint")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "thumbprint", valid_564180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564181 = query.getOrDefault("api-version")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "api-version", valid_564181
  var valid_564182 = query.getOrDefault("$select")
  valid_564182 = validateParameter(valid_564182, JString, required = false,
                                 default = nil)
  if valid_564182 != nil:
    section.add "$select", valid_564182
  var valid_564183 = query.getOrDefault("timeout")
  valid_564183 = validateParameter(valid_564183, JInt, required = false,
                                 default = newJInt(30))
  if valid_564183 != nil:
    section.add "timeout", valid_564183
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564184 = header.getOrDefault("return-client-request-id")
  valid_564184 = validateParameter(valid_564184, JBool, required = false,
                                 default = newJBool(false))
  if valid_564184 != nil:
    section.add "return-client-request-id", valid_564184
  var valid_564185 = header.getOrDefault("client-request-id")
  valid_564185 = validateParameter(valid_564185, JString, required = false,
                                 default = nil)
  if valid_564185 != nil:
    section.add "client-request-id", valid_564185
  var valid_564186 = header.getOrDefault("ocp-date")
  valid_564186 = validateParameter(valid_564186, JString, required = false,
                                 default = nil)
  if valid_564186 != nil:
    section.add "ocp-date", valid_564186
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564187: Call_CertificateGet_564176; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified certificate.
  ## 
  let valid = call_564187.validator(path, query, header, formData, body)
  let scheme = call_564187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564187.url(scheme.get, call_564187.host, call_564187.base,
                         call_564187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564187, url, valid)

proc call*(call_564188: Call_CertificateGet_564176; apiVersion: string;
          thumbprintAlgorithm: string; thumbprint: string; Select: string = "";
          timeout: int = 30): Recallable =
  ## certificateGet
  ## Gets information about the specified certificate.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   thumbprintAlgorithm: string (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: string (required)
  ##             : The thumbprint of the certificate to get.
  var path_564189 = newJObject()
  var query_564190 = newJObject()
  add(query_564190, "api-version", newJString(apiVersion))
  add(query_564190, "$select", newJString(Select))
  add(query_564190, "timeout", newJInt(timeout))
  add(path_564189, "thumbprintAlgorithm", newJString(thumbprintAlgorithm))
  add(path_564189, "thumbprint", newJString(thumbprint))
  result = call_564188.call(path_564189, query_564190, nil, nil, nil)

var certificateGet* = Call_CertificateGet_564176(name: "certificateGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})",
    validator: validate_CertificateGet_564177, base: "", url: url_CertificateGet_564178,
    schemes: {Scheme.Https})
type
  Call_CertificateDelete_564191 = ref object of OpenApiRestCall_563565
proc url_CertificateDelete_564193(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateDelete_564192(path: JsonNode; query: JsonNode;
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
  var valid_564194 = path.getOrDefault("thumbprintAlgorithm")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "thumbprintAlgorithm", valid_564194
  var valid_564195 = path.getOrDefault("thumbprint")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "thumbprint", valid_564195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564196 = query.getOrDefault("api-version")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "api-version", valid_564196
  var valid_564197 = query.getOrDefault("timeout")
  valid_564197 = validateParameter(valid_564197, JInt, required = false,
                                 default = newJInt(30))
  if valid_564197 != nil:
    section.add "timeout", valid_564197
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564198 = header.getOrDefault("return-client-request-id")
  valid_564198 = validateParameter(valid_564198, JBool, required = false,
                                 default = newJBool(false))
  if valid_564198 != nil:
    section.add "return-client-request-id", valid_564198
  var valid_564199 = header.getOrDefault("client-request-id")
  valid_564199 = validateParameter(valid_564199, JString, required = false,
                                 default = nil)
  if valid_564199 != nil:
    section.add "client-request-id", valid_564199
  var valid_564200 = header.getOrDefault("ocp-date")
  valid_564200 = validateParameter(valid_564200, JString, required = false,
                                 default = nil)
  if valid_564200 != nil:
    section.add "ocp-date", valid_564200
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564201: Call_CertificateDelete_564191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You cannot delete a certificate if a resource (pool or compute node) is using it. Before you can delete a certificate, you must therefore make sure that the certificate is not associated with any existing pools, the certificate is not installed on any compute nodes (even if you remove a certificate from a pool, it is not removed from existing compute nodes in that pool until they restart), and no running tasks depend on the certificate. If you try to delete a certificate that is in use, the deletion fails. The certificate status changes to deleteFailed. You can use Cancel Delete Certificate to set the status back to active if you decide that you want to continue using the certificate.
  ## 
  let valid = call_564201.validator(path, query, header, formData, body)
  let scheme = call_564201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564201.url(scheme.get, call_564201.host, call_564201.base,
                         call_564201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564201, url, valid)

proc call*(call_564202: Call_CertificateDelete_564191; apiVersion: string;
          thumbprintAlgorithm: string; thumbprint: string; timeout: int = 30): Recallable =
  ## certificateDelete
  ## You cannot delete a certificate if a resource (pool or compute node) is using it. Before you can delete a certificate, you must therefore make sure that the certificate is not associated with any existing pools, the certificate is not installed on any compute nodes (even if you remove a certificate from a pool, it is not removed from existing compute nodes in that pool until they restart), and no running tasks depend on the certificate. If you try to delete a certificate that is in use, the deletion fails. The certificate status changes to deleteFailed. You can use Cancel Delete Certificate to set the status back to active if you decide that you want to continue using the certificate.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   thumbprintAlgorithm: string (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: string (required)
  ##             : The thumbprint of the certificate to be deleted.
  var path_564203 = newJObject()
  var query_564204 = newJObject()
  add(query_564204, "api-version", newJString(apiVersion))
  add(query_564204, "timeout", newJInt(timeout))
  add(path_564203, "thumbprintAlgorithm", newJString(thumbprintAlgorithm))
  add(path_564203, "thumbprint", newJString(thumbprint))
  result = call_564202.call(path_564203, query_564204, nil, nil, nil)

var certificateDelete* = Call_CertificateDelete_564191(name: "certificateDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})",
    validator: validate_CertificateDelete_564192, base: "",
    url: url_CertificateDelete_564193, schemes: {Scheme.Https})
type
  Call_CertificateCancelDeletion_564205 = ref object of OpenApiRestCall_563565
proc url_CertificateCancelDeletion_564207(protocol: Scheme; host: string;
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

proc validate_CertificateCancelDeletion_564206(path: JsonNode; query: JsonNode;
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
  var valid_564208 = path.getOrDefault("thumbprintAlgorithm")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "thumbprintAlgorithm", valid_564208
  var valid_564209 = path.getOrDefault("thumbprint")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "thumbprint", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "api-version", valid_564210
  var valid_564211 = query.getOrDefault("timeout")
  valid_564211 = validateParameter(valid_564211, JInt, required = false,
                                 default = newJInt(30))
  if valid_564211 != nil:
    section.add "timeout", valid_564211
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564212 = header.getOrDefault("return-client-request-id")
  valid_564212 = validateParameter(valid_564212, JBool, required = false,
                                 default = newJBool(false))
  if valid_564212 != nil:
    section.add "return-client-request-id", valid_564212
  var valid_564213 = header.getOrDefault("client-request-id")
  valid_564213 = validateParameter(valid_564213, JString, required = false,
                                 default = nil)
  if valid_564213 != nil:
    section.add "client-request-id", valid_564213
  var valid_564214 = header.getOrDefault("ocp-date")
  valid_564214 = validateParameter(valid_564214, JString, required = false,
                                 default = nil)
  if valid_564214 != nil:
    section.add "ocp-date", valid_564214
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564215: Call_CertificateCancelDeletion_564205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If you try to delete a certificate that is being used by a pool or compute node, the status of the certificate changes to deleteFailed. If you decide that you want to continue using the certificate, you can use this operation to set the status of the certificate back to active. If you intend to delete the certificate, you do not need to run this operation after the deletion failed. You must make sure that the certificate is not being used by any resources, and then you can try again to delete the certificate.
  ## 
  let valid = call_564215.validator(path, query, header, formData, body)
  let scheme = call_564215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564215.url(scheme.get, call_564215.host, call_564215.base,
                         call_564215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564215, url, valid)

proc call*(call_564216: Call_CertificateCancelDeletion_564205; apiVersion: string;
          thumbprintAlgorithm: string; thumbprint: string; timeout: int = 30): Recallable =
  ## certificateCancelDeletion
  ## If you try to delete a certificate that is being used by a pool or compute node, the status of the certificate changes to deleteFailed. If you decide that you want to continue using the certificate, you can use this operation to set the status of the certificate back to active. If you intend to delete the certificate, you do not need to run this operation after the deletion failed. You must make sure that the certificate is not being used by any resources, and then you can try again to delete the certificate.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   thumbprintAlgorithm: string (required)
  ##                      : The algorithm used to derive the thumbprint parameter. This must be sha1.
  ##   thumbprint: string (required)
  ##             : The thumbprint of the certificate being deleted.
  var path_564217 = newJObject()
  var query_564218 = newJObject()
  add(query_564218, "api-version", newJString(apiVersion))
  add(query_564218, "timeout", newJInt(timeout))
  add(path_564217, "thumbprintAlgorithm", newJString(thumbprintAlgorithm))
  add(path_564217, "thumbprint", newJString(thumbprint))
  result = call_564216.call(path_564217, query_564218, nil, nil, nil)

var certificateCancelDeletion* = Call_CertificateCancelDeletion_564205(
    name: "certificateCancelDeletion", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})/canceldelete",
    validator: validate_CertificateCancelDeletion_564206, base: "",
    url: url_CertificateCancelDeletion_564207, schemes: {Scheme.Https})
type
  Call_JobAdd_564234 = ref object of OpenApiRestCall_563565
proc url_JobAdd_564236(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobAdd_564235(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## The Batch service supports two ways to control the work done as part of a job. In the first approach, the user specifies a Job Manager task. The Batch service launches this task when it is ready to start the job. The Job Manager task controls all other tasks that run under this job, by using the Task APIs. In the second approach, the user directly controls the execution of tasks under an active job, by using the Task APIs. Also note: when naming jobs, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564237 = query.getOrDefault("api-version")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "api-version", valid_564237
  var valid_564238 = query.getOrDefault("timeout")
  valid_564238 = validateParameter(valid_564238, JInt, required = false,
                                 default = newJInt(30))
  if valid_564238 != nil:
    section.add "timeout", valid_564238
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564239 = header.getOrDefault("return-client-request-id")
  valid_564239 = validateParameter(valid_564239, JBool, required = false,
                                 default = newJBool(false))
  if valid_564239 != nil:
    section.add "return-client-request-id", valid_564239
  var valid_564240 = header.getOrDefault("client-request-id")
  valid_564240 = validateParameter(valid_564240, JString, required = false,
                                 default = nil)
  if valid_564240 != nil:
    section.add "client-request-id", valid_564240
  var valid_564241 = header.getOrDefault("ocp-date")
  valid_564241 = validateParameter(valid_564241, JString, required = false,
                                 default = nil)
  if valid_564241 != nil:
    section.add "ocp-date", valid_564241
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

proc call*(call_564243: Call_JobAdd_564234; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Batch service supports two ways to control the work done as part of a job. In the first approach, the user specifies a Job Manager task. The Batch service launches this task when it is ready to start the job. The Job Manager task controls all other tasks that run under this job, by using the Task APIs. In the second approach, the user directly controls the execution of tasks under an active job, by using the Task APIs. Also note: when naming jobs, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ## 
  let valid = call_564243.validator(path, query, header, formData, body)
  let scheme = call_564243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564243.url(scheme.get, call_564243.host, call_564243.base,
                         call_564243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564243, url, valid)

proc call*(call_564244: Call_JobAdd_564234; apiVersion: string; job: JsonNode;
          timeout: int = 30): Recallable =
  ## jobAdd
  ## The Batch service supports two ways to control the work done as part of a job. In the first approach, the user specifies a Job Manager task. The Batch service launches this task when it is ready to start the job. The Job Manager task controls all other tasks that run under this job, by using the Task APIs. In the second approach, the user directly controls the execution of tasks under an active job, by using the Task APIs. Also note: when naming jobs, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   job: JObject (required)
  ##      : The job to be added.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var query_564245 = newJObject()
  var body_564246 = newJObject()
  add(query_564245, "api-version", newJString(apiVersion))
  if job != nil:
    body_564246 = job
  add(query_564245, "timeout", newJInt(timeout))
  result = call_564244.call(nil, query_564245, nil, nil, body_564246)

var jobAdd* = Call_JobAdd_564234(name: "jobAdd", meth: HttpMethod.HttpPost,
                              host: "azure.local", route: "/jobs",
                              validator: validate_JobAdd_564235, base: "",
                              url: url_JobAdd_564236, schemes: {Scheme.Https})
type
  Call_JobList_564219 = ref object of OpenApiRestCall_563565
proc url_JobList_564221(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobList_564220(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 jobs can be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564222 = query.getOrDefault("api-version")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "api-version", valid_564222
  var valid_564223 = query.getOrDefault("$select")
  valid_564223 = validateParameter(valid_564223, JString, required = false,
                                 default = nil)
  if valid_564223 != nil:
    section.add "$select", valid_564223
  var valid_564224 = query.getOrDefault("$expand")
  valid_564224 = validateParameter(valid_564224, JString, required = false,
                                 default = nil)
  if valid_564224 != nil:
    section.add "$expand", valid_564224
  var valid_564225 = query.getOrDefault("timeout")
  valid_564225 = validateParameter(valid_564225, JInt, required = false,
                                 default = newJInt(30))
  if valid_564225 != nil:
    section.add "timeout", valid_564225
  var valid_564226 = query.getOrDefault("maxresults")
  valid_564226 = validateParameter(valid_564226, JInt, required = false,
                                 default = newJInt(1000))
  if valid_564226 != nil:
    section.add "maxresults", valid_564226
  var valid_564227 = query.getOrDefault("$filter")
  valid_564227 = validateParameter(valid_564227, JString, required = false,
                                 default = nil)
  if valid_564227 != nil:
    section.add "$filter", valid_564227
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564228 = header.getOrDefault("return-client-request-id")
  valid_564228 = validateParameter(valid_564228, JBool, required = false,
                                 default = newJBool(false))
  if valid_564228 != nil:
    section.add "return-client-request-id", valid_564228
  var valid_564229 = header.getOrDefault("client-request-id")
  valid_564229 = validateParameter(valid_564229, JString, required = false,
                                 default = nil)
  if valid_564229 != nil:
    section.add "client-request-id", valid_564229
  var valid_564230 = header.getOrDefault("ocp-date")
  valid_564230 = validateParameter(valid_564230, JString, required = false,
                                 default = nil)
  if valid_564230 != nil:
    section.add "ocp-date", valid_564230
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564231: Call_JobList_564219; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_JobList_564219; apiVersion: string; Select: string = "";
          Expand: string = ""; timeout: int = 30; maxresults: int = 1000;
          Filter: string = ""): Recallable =
  ## jobList
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 jobs can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs.
  var query_564233 = newJObject()
  add(query_564233, "api-version", newJString(apiVersion))
  add(query_564233, "$select", newJString(Select))
  add(query_564233, "$expand", newJString(Expand))
  add(query_564233, "timeout", newJInt(timeout))
  add(query_564233, "maxresults", newJInt(maxresults))
  add(query_564233, "$filter", newJString(Filter))
  result = call_564232.call(nil, query_564233, nil, nil, nil)

var jobList* = Call_JobList_564219(name: "jobList", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/jobs",
                                validator: validate_JobList_564220, base: "",
                                url: url_JobList_564221, schemes: {Scheme.Https})
type
  Call_JobUpdate_564266 = ref object of OpenApiRestCall_563565
proc url_JobUpdate_564268(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobUpdate_564267(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564269 = path.getOrDefault("jobId")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "jobId", valid_564269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564270 = query.getOrDefault("api-version")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "api-version", valid_564270
  var valid_564271 = query.getOrDefault("timeout")
  valid_564271 = validateParameter(valid_564271, JInt, required = false,
                                 default = newJInt(30))
  if valid_564271 != nil:
    section.add "timeout", valid_564271
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564272 = header.getOrDefault("return-client-request-id")
  valid_564272 = validateParameter(valid_564272, JBool, required = false,
                                 default = newJBool(false))
  if valid_564272 != nil:
    section.add "return-client-request-id", valid_564272
  var valid_564273 = header.getOrDefault("If-Unmodified-Since")
  valid_564273 = validateParameter(valid_564273, JString, required = false,
                                 default = nil)
  if valid_564273 != nil:
    section.add "If-Unmodified-Since", valid_564273
  var valid_564274 = header.getOrDefault("client-request-id")
  valid_564274 = validateParameter(valid_564274, JString, required = false,
                                 default = nil)
  if valid_564274 != nil:
    section.add "client-request-id", valid_564274
  var valid_564275 = header.getOrDefault("If-Modified-Since")
  valid_564275 = validateParameter(valid_564275, JString, required = false,
                                 default = nil)
  if valid_564275 != nil:
    section.add "If-Modified-Since", valid_564275
  var valid_564276 = header.getOrDefault("If-None-Match")
  valid_564276 = validateParameter(valid_564276, JString, required = false,
                                 default = nil)
  if valid_564276 != nil:
    section.add "If-None-Match", valid_564276
  var valid_564277 = header.getOrDefault("ocp-date")
  valid_564277 = validateParameter(valid_564277, JString, required = false,
                                 default = nil)
  if valid_564277 != nil:
    section.add "ocp-date", valid_564277
  var valid_564278 = header.getOrDefault("If-Match")
  valid_564278 = validateParameter(valid_564278, JString, required = false,
                                 default = nil)
  if valid_564278 != nil:
    section.add "If-Match", valid_564278
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

proc call*(call_564280: Call_JobUpdate_564266; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This fully replaces all the updatable properties of the job. For example, if the job has constraints associated with it and if constraints is not specified with this request, then the Batch service will remove the existing constraints.
  ## 
  let valid = call_564280.validator(path, query, header, formData, body)
  let scheme = call_564280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564280.url(scheme.get, call_564280.host, call_564280.base,
                         call_564280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564280, url, valid)

proc call*(call_564281: Call_JobUpdate_564266; jobId: string; apiVersion: string;
          jobUpdateParameter: JsonNode; timeout: int = 30): Recallable =
  ## jobUpdate
  ## This fully replaces all the updatable properties of the job. For example, if the job has constraints associated with it and if constraints is not specified with this request, then the Batch service will remove the existing constraints.
  ##   jobId: string (required)
  ##        : The ID of the job whose properties you want to update.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobUpdateParameter: JObject (required)
  ##                     : The parameters for the request.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564282 = newJObject()
  var query_564283 = newJObject()
  var body_564284 = newJObject()
  add(path_564282, "jobId", newJString(jobId))
  add(query_564283, "api-version", newJString(apiVersion))
  if jobUpdateParameter != nil:
    body_564284 = jobUpdateParameter
  add(query_564283, "timeout", newJInt(timeout))
  result = call_564281.call(path_564282, query_564283, nil, nil, body_564284)

var jobUpdate* = Call_JobUpdate_564266(name: "jobUpdate", meth: HttpMethod.HttpPut,
                                    host: "azure.local", route: "/jobs/{jobId}",
                                    validator: validate_JobUpdate_564267,
                                    base: "", url: url_JobUpdate_564268,
                                    schemes: {Scheme.Https})
type
  Call_JobGet_564247 = ref object of OpenApiRestCall_563565
proc url_JobGet_564249(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobGet_564248(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_564250 = path.getOrDefault("jobId")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "jobId", valid_564250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564251 = query.getOrDefault("api-version")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "api-version", valid_564251
  var valid_564252 = query.getOrDefault("$select")
  valid_564252 = validateParameter(valid_564252, JString, required = false,
                                 default = nil)
  if valid_564252 != nil:
    section.add "$select", valid_564252
  var valid_564253 = query.getOrDefault("$expand")
  valid_564253 = validateParameter(valid_564253, JString, required = false,
                                 default = nil)
  if valid_564253 != nil:
    section.add "$expand", valid_564253
  var valid_564254 = query.getOrDefault("timeout")
  valid_564254 = validateParameter(valid_564254, JInt, required = false,
                                 default = newJInt(30))
  if valid_564254 != nil:
    section.add "timeout", valid_564254
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564255 = header.getOrDefault("return-client-request-id")
  valid_564255 = validateParameter(valid_564255, JBool, required = false,
                                 default = newJBool(false))
  if valid_564255 != nil:
    section.add "return-client-request-id", valid_564255
  var valid_564256 = header.getOrDefault("If-Unmodified-Since")
  valid_564256 = validateParameter(valid_564256, JString, required = false,
                                 default = nil)
  if valid_564256 != nil:
    section.add "If-Unmodified-Since", valid_564256
  var valid_564257 = header.getOrDefault("client-request-id")
  valid_564257 = validateParameter(valid_564257, JString, required = false,
                                 default = nil)
  if valid_564257 != nil:
    section.add "client-request-id", valid_564257
  var valid_564258 = header.getOrDefault("If-Modified-Since")
  valid_564258 = validateParameter(valid_564258, JString, required = false,
                                 default = nil)
  if valid_564258 != nil:
    section.add "If-Modified-Since", valid_564258
  var valid_564259 = header.getOrDefault("If-None-Match")
  valid_564259 = validateParameter(valid_564259, JString, required = false,
                                 default = nil)
  if valid_564259 != nil:
    section.add "If-None-Match", valid_564259
  var valid_564260 = header.getOrDefault("ocp-date")
  valid_564260 = validateParameter(valid_564260, JString, required = false,
                                 default = nil)
  if valid_564260 != nil:
    section.add "ocp-date", valid_564260
  var valid_564261 = header.getOrDefault("If-Match")
  valid_564261 = validateParameter(valid_564261, JString, required = false,
                                 default = nil)
  if valid_564261 != nil:
    section.add "If-Match", valid_564261
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564262: Call_JobGet_564247; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_JobGet_564247; jobId: string; apiVersion: string;
          Select: string = ""; Expand: string = ""; timeout: int = 30): Recallable =
  ## jobGet
  ##   jobId: string (required)
  ##        : The ID of the job.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  add(path_564264, "jobId", newJString(jobId))
  add(query_564265, "api-version", newJString(apiVersion))
  add(query_564265, "$select", newJString(Select))
  add(query_564265, "$expand", newJString(Expand))
  add(query_564265, "timeout", newJInt(timeout))
  result = call_564263.call(path_564264, query_564265, nil, nil, nil)

var jobGet* = Call_JobGet_564247(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "azure.local", route: "/jobs/{jobId}",
                              validator: validate_JobGet_564248, base: "",
                              url: url_JobGet_564249, schemes: {Scheme.Https})
type
  Call_JobPatch_564302 = ref object of OpenApiRestCall_563565
proc url_JobPatch_564304(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobPatch_564303(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564305 = path.getOrDefault("jobId")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "jobId", valid_564305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564306 = query.getOrDefault("api-version")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "api-version", valid_564306
  var valid_564307 = query.getOrDefault("timeout")
  valid_564307 = validateParameter(valid_564307, JInt, required = false,
                                 default = newJInt(30))
  if valid_564307 != nil:
    section.add "timeout", valid_564307
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564308 = header.getOrDefault("return-client-request-id")
  valid_564308 = validateParameter(valid_564308, JBool, required = false,
                                 default = newJBool(false))
  if valid_564308 != nil:
    section.add "return-client-request-id", valid_564308
  var valid_564309 = header.getOrDefault("If-Unmodified-Since")
  valid_564309 = validateParameter(valid_564309, JString, required = false,
                                 default = nil)
  if valid_564309 != nil:
    section.add "If-Unmodified-Since", valid_564309
  var valid_564310 = header.getOrDefault("client-request-id")
  valid_564310 = validateParameter(valid_564310, JString, required = false,
                                 default = nil)
  if valid_564310 != nil:
    section.add "client-request-id", valid_564310
  var valid_564311 = header.getOrDefault("If-Modified-Since")
  valid_564311 = validateParameter(valid_564311, JString, required = false,
                                 default = nil)
  if valid_564311 != nil:
    section.add "If-Modified-Since", valid_564311
  var valid_564312 = header.getOrDefault("If-None-Match")
  valid_564312 = validateParameter(valid_564312, JString, required = false,
                                 default = nil)
  if valid_564312 != nil:
    section.add "If-None-Match", valid_564312
  var valid_564313 = header.getOrDefault("ocp-date")
  valid_564313 = validateParameter(valid_564313, JString, required = false,
                                 default = nil)
  if valid_564313 != nil:
    section.add "ocp-date", valid_564313
  var valid_564314 = header.getOrDefault("If-Match")
  valid_564314 = validateParameter(valid_564314, JString, required = false,
                                 default = nil)
  if valid_564314 != nil:
    section.add "If-Match", valid_564314
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

proc call*(call_564316: Call_JobPatch_564302; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This replaces only the job properties specified in the request. For example, if the job has constraints, and a request does not specify the constraints element, then the job keeps the existing constraints.
  ## 
  let valid = call_564316.validator(path, query, header, formData, body)
  let scheme = call_564316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564316.url(scheme.get, call_564316.host, call_564316.base,
                         call_564316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564316, url, valid)

proc call*(call_564317: Call_JobPatch_564302; jobId: string;
          jobPatchParameter: JsonNode; apiVersion: string; timeout: int = 30): Recallable =
  ## jobPatch
  ## This replaces only the job properties specified in the request. For example, if the job has constraints, and a request does not specify the constraints element, then the job keeps the existing constraints.
  ##   jobId: string (required)
  ##        : The ID of the job whose properties you want to update.
  ##   jobPatchParameter: JObject (required)
  ##                    : The parameters for the request.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564318 = newJObject()
  var query_564319 = newJObject()
  var body_564320 = newJObject()
  add(path_564318, "jobId", newJString(jobId))
  if jobPatchParameter != nil:
    body_564320 = jobPatchParameter
  add(query_564319, "api-version", newJString(apiVersion))
  add(query_564319, "timeout", newJInt(timeout))
  result = call_564317.call(path_564318, query_564319, nil, nil, body_564320)

var jobPatch* = Call_JobPatch_564302(name: "jobPatch", meth: HttpMethod.HttpPatch,
                                  host: "azure.local", route: "/jobs/{jobId}",
                                  validator: validate_JobPatch_564303, base: "",
                                  url: url_JobPatch_564304,
                                  schemes: {Scheme.Https})
type
  Call_JobDelete_564285 = ref object of OpenApiRestCall_563565
proc url_JobDelete_564287(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobDelete_564286(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564288 = path.getOrDefault("jobId")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "jobId", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564289 = query.getOrDefault("api-version")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "api-version", valid_564289
  var valid_564290 = query.getOrDefault("timeout")
  valid_564290 = validateParameter(valid_564290, JInt, required = false,
                                 default = newJInt(30))
  if valid_564290 != nil:
    section.add "timeout", valid_564290
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564291 = header.getOrDefault("return-client-request-id")
  valid_564291 = validateParameter(valid_564291, JBool, required = false,
                                 default = newJBool(false))
  if valid_564291 != nil:
    section.add "return-client-request-id", valid_564291
  var valid_564292 = header.getOrDefault("If-Unmodified-Since")
  valid_564292 = validateParameter(valid_564292, JString, required = false,
                                 default = nil)
  if valid_564292 != nil:
    section.add "If-Unmodified-Since", valid_564292
  var valid_564293 = header.getOrDefault("client-request-id")
  valid_564293 = validateParameter(valid_564293, JString, required = false,
                                 default = nil)
  if valid_564293 != nil:
    section.add "client-request-id", valid_564293
  var valid_564294 = header.getOrDefault("If-Modified-Since")
  valid_564294 = validateParameter(valid_564294, JString, required = false,
                                 default = nil)
  if valid_564294 != nil:
    section.add "If-Modified-Since", valid_564294
  var valid_564295 = header.getOrDefault("If-None-Match")
  valid_564295 = validateParameter(valid_564295, JString, required = false,
                                 default = nil)
  if valid_564295 != nil:
    section.add "If-None-Match", valid_564295
  var valid_564296 = header.getOrDefault("ocp-date")
  valid_564296 = validateParameter(valid_564296, JString, required = false,
                                 default = nil)
  if valid_564296 != nil:
    section.add "ocp-date", valid_564296
  var valid_564297 = header.getOrDefault("If-Match")
  valid_564297 = validateParameter(valid_564297, JString, required = false,
                                 default = nil)
  if valid_564297 != nil:
    section.add "If-Match", valid_564297
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564298: Call_JobDelete_564285; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deleting a job also deletes all tasks that are part of that job, and all job statistics. This also overrides the retention period for task data; that is, if the job contains tasks which are still retained on compute nodes, the Batch services deletes those tasks' working directories and all their contents.  When a Delete Job request is received, the Batch service sets the job to the deleting state. All update operations on a job that is in deleting state will fail with status code 409 (Conflict), with additional information indicating that the job is being deleted.
  ## 
  let valid = call_564298.validator(path, query, header, formData, body)
  let scheme = call_564298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564298.url(scheme.get, call_564298.host, call_564298.base,
                         call_564298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564298, url, valid)

proc call*(call_564299: Call_JobDelete_564285; jobId: string; apiVersion: string;
          timeout: int = 30): Recallable =
  ## jobDelete
  ## Deleting a job also deletes all tasks that are part of that job, and all job statistics. This also overrides the retention period for task data; that is, if the job contains tasks which are still retained on compute nodes, the Batch services deletes those tasks' working directories and all their contents.  When a Delete Job request is received, the Batch service sets the job to the deleting state. All update operations on a job that is in deleting state will fail with status code 409 (Conflict), with additional information indicating that the job is being deleted.
  ##   jobId: string (required)
  ##        : The ID of the job to delete.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564300 = newJObject()
  var query_564301 = newJObject()
  add(path_564300, "jobId", newJString(jobId))
  add(query_564301, "api-version", newJString(apiVersion))
  add(query_564301, "timeout", newJInt(timeout))
  result = call_564299.call(path_564300, query_564301, nil, nil, nil)

var jobDelete* = Call_JobDelete_564285(name: "jobDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local", route: "/jobs/{jobId}",
                                    validator: validate_JobDelete_564286,
                                    base: "", url: url_JobDelete_564287,
                                    schemes: {Scheme.Https})
type
  Call_TaskAddCollection_564321 = ref object of OpenApiRestCall_563565
proc url_TaskAddCollection_564323(protocol: Scheme; host: string; base: string;
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

proc validate_TaskAddCollection_564322(path: JsonNode; query: JsonNode;
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
  var valid_564334 = path.getOrDefault("jobId")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "jobId", valid_564334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564335 = query.getOrDefault("api-version")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "api-version", valid_564335
  var valid_564336 = query.getOrDefault("timeout")
  valid_564336 = validateParameter(valid_564336, JInt, required = false,
                                 default = newJInt(30))
  if valid_564336 != nil:
    section.add "timeout", valid_564336
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564337 = header.getOrDefault("return-client-request-id")
  valid_564337 = validateParameter(valid_564337, JBool, required = false,
                                 default = newJBool(false))
  if valid_564337 != nil:
    section.add "return-client-request-id", valid_564337
  var valid_564338 = header.getOrDefault("client-request-id")
  valid_564338 = validateParameter(valid_564338, JString, required = false,
                                 default = nil)
  if valid_564338 != nil:
    section.add "client-request-id", valid_564338
  var valid_564339 = header.getOrDefault("ocp-date")
  valid_564339 = validateParameter(valid_564339, JString, required = false,
                                 default = nil)
  if valid_564339 != nil:
    section.add "ocp-date", valid_564339
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

proc call*(call_564341: Call_TaskAddCollection_564321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Note that each task must have a unique ID. The Batch service may not return the results for each task in the same order the tasks were submitted in this request. If the server times out or the connection is closed during the request, the request may have been partially or fully processed, or not at all. In such cases, the user should re-issue the request. Note that it is up to the user to correctly handle failures when re-issuing a request. For example, you should use the same task IDs during a retry so that if the prior operation succeeded, the retry will not create extra tasks unexpectedly. If the response contains any tasks which failed to add, a client can retry the request. In a retry, it is most efficient to resubmit only tasks that failed to add, and to omit tasks that were successfully added on the first attempt. The maximum lifetime of a task from addition to completion is 180 days. If a task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ## 
  let valid = call_564341.validator(path, query, header, formData, body)
  let scheme = call_564341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564341.url(scheme.get, call_564341.host, call_564341.base,
                         call_564341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564341, url, valid)

proc call*(call_564342: Call_TaskAddCollection_564321; jobId: string;
          apiVersion: string; taskCollection: JsonNode; timeout: int = 30): Recallable =
  ## taskAddCollection
  ## Note that each task must have a unique ID. The Batch service may not return the results for each task in the same order the tasks were submitted in this request. If the server times out or the connection is closed during the request, the request may have been partially or fully processed, or not at all. In such cases, the user should re-issue the request. Note that it is up to the user to correctly handle failures when re-issuing a request. For example, you should use the same task IDs during a retry so that if the prior operation succeeded, the retry will not create extra tasks unexpectedly. If the response contains any tasks which failed to add, a client can retry the request. In a retry, it is most efficient to resubmit only tasks that failed to add, and to omit tasks that were successfully added on the first attempt. The maximum lifetime of a task from addition to completion is 180 days. If a task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ##   jobId: string (required)
  ##        : The ID of the job to which the task collection is to be added.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   taskCollection: JObject (required)
  ##                 : The tasks to be added.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564343 = newJObject()
  var query_564344 = newJObject()
  var body_564345 = newJObject()
  add(path_564343, "jobId", newJString(jobId))
  add(query_564344, "api-version", newJString(apiVersion))
  if taskCollection != nil:
    body_564345 = taskCollection
  add(query_564344, "timeout", newJInt(timeout))
  result = call_564342.call(path_564343, query_564344, nil, nil, body_564345)

var taskAddCollection* = Call_TaskAddCollection_564321(name: "taskAddCollection",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/addtaskcollection",
    validator: validate_TaskAddCollection_564322, base: "",
    url: url_TaskAddCollection_564323, schemes: {Scheme.Https})
type
  Call_JobDisable_564346 = ref object of OpenApiRestCall_563565
proc url_JobDisable_564348(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobDisable_564347(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564349 = path.getOrDefault("jobId")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "jobId", valid_564349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564350 = query.getOrDefault("api-version")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "api-version", valid_564350
  var valid_564351 = query.getOrDefault("timeout")
  valid_564351 = validateParameter(valid_564351, JInt, required = false,
                                 default = newJInt(30))
  if valid_564351 != nil:
    section.add "timeout", valid_564351
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564352 = header.getOrDefault("return-client-request-id")
  valid_564352 = validateParameter(valid_564352, JBool, required = false,
                                 default = newJBool(false))
  if valid_564352 != nil:
    section.add "return-client-request-id", valid_564352
  var valid_564353 = header.getOrDefault("If-Unmodified-Since")
  valid_564353 = validateParameter(valid_564353, JString, required = false,
                                 default = nil)
  if valid_564353 != nil:
    section.add "If-Unmodified-Since", valid_564353
  var valid_564354 = header.getOrDefault("client-request-id")
  valid_564354 = validateParameter(valid_564354, JString, required = false,
                                 default = nil)
  if valid_564354 != nil:
    section.add "client-request-id", valid_564354
  var valid_564355 = header.getOrDefault("If-Modified-Since")
  valid_564355 = validateParameter(valid_564355, JString, required = false,
                                 default = nil)
  if valid_564355 != nil:
    section.add "If-Modified-Since", valid_564355
  var valid_564356 = header.getOrDefault("If-None-Match")
  valid_564356 = validateParameter(valid_564356, JString, required = false,
                                 default = nil)
  if valid_564356 != nil:
    section.add "If-None-Match", valid_564356
  var valid_564357 = header.getOrDefault("ocp-date")
  valid_564357 = validateParameter(valid_564357, JString, required = false,
                                 default = nil)
  if valid_564357 != nil:
    section.add "ocp-date", valid_564357
  var valid_564358 = header.getOrDefault("If-Match")
  valid_564358 = validateParameter(valid_564358, JString, required = false,
                                 default = nil)
  if valid_564358 != nil:
    section.add "If-Match", valid_564358
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

proc call*(call_564360: Call_JobDisable_564346; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Batch Service immediately moves the job to the disabling state. Batch then uses the disableTasks parameter to determine what to do with the currently running tasks of the job. The job remains in the disabling state until the disable operation is completed and all tasks have been dealt with according to the disableTasks option; the job then moves to the disabled state. No new tasks are started under the job until it moves back to active state. If you try to disable a job that is in any state other than active, disabling, or disabled, the request fails with status code 409.
  ## 
  let valid = call_564360.validator(path, query, header, formData, body)
  let scheme = call_564360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564360.url(scheme.get, call_564360.host, call_564360.base,
                         call_564360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564360, url, valid)

proc call*(call_564361: Call_JobDisable_564346; jobId: string; apiVersion: string;
          jobDisableParameter: JsonNode; timeout: int = 30): Recallable =
  ## jobDisable
  ## The Batch Service immediately moves the job to the disabling state. Batch then uses the disableTasks parameter to determine what to do with the currently running tasks of the job. The job remains in the disabling state until the disable operation is completed and all tasks have been dealt with according to the disableTasks option; the job then moves to the disabled state. No new tasks are started under the job until it moves back to active state. If you try to disable a job that is in any state other than active, disabling, or disabled, the request fails with status code 409.
  ##   jobId: string (required)
  ##        : The ID of the job to disable.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobDisableParameter: JObject (required)
  ##                      : The parameters for the request.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564362 = newJObject()
  var query_564363 = newJObject()
  var body_564364 = newJObject()
  add(path_564362, "jobId", newJString(jobId))
  add(query_564363, "api-version", newJString(apiVersion))
  if jobDisableParameter != nil:
    body_564364 = jobDisableParameter
  add(query_564363, "timeout", newJInt(timeout))
  result = call_564361.call(path_564362, query_564363, nil, nil, body_564364)

var jobDisable* = Call_JobDisable_564346(name: "jobDisable",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local",
                                      route: "/jobs/{jobId}/disable",
                                      validator: validate_JobDisable_564347,
                                      base: "", url: url_JobDisable_564348,
                                      schemes: {Scheme.Https})
type
  Call_JobEnable_564365 = ref object of OpenApiRestCall_563565
proc url_JobEnable_564367(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobEnable_564366(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564368 = path.getOrDefault("jobId")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "jobId", valid_564368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564369 = query.getOrDefault("api-version")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "api-version", valid_564369
  var valid_564370 = query.getOrDefault("timeout")
  valid_564370 = validateParameter(valid_564370, JInt, required = false,
                                 default = newJInt(30))
  if valid_564370 != nil:
    section.add "timeout", valid_564370
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564371 = header.getOrDefault("return-client-request-id")
  valid_564371 = validateParameter(valid_564371, JBool, required = false,
                                 default = newJBool(false))
  if valid_564371 != nil:
    section.add "return-client-request-id", valid_564371
  var valid_564372 = header.getOrDefault("If-Unmodified-Since")
  valid_564372 = validateParameter(valid_564372, JString, required = false,
                                 default = nil)
  if valid_564372 != nil:
    section.add "If-Unmodified-Since", valid_564372
  var valid_564373 = header.getOrDefault("client-request-id")
  valid_564373 = validateParameter(valid_564373, JString, required = false,
                                 default = nil)
  if valid_564373 != nil:
    section.add "client-request-id", valid_564373
  var valid_564374 = header.getOrDefault("If-Modified-Since")
  valid_564374 = validateParameter(valid_564374, JString, required = false,
                                 default = nil)
  if valid_564374 != nil:
    section.add "If-Modified-Since", valid_564374
  var valid_564375 = header.getOrDefault("If-None-Match")
  valid_564375 = validateParameter(valid_564375, JString, required = false,
                                 default = nil)
  if valid_564375 != nil:
    section.add "If-None-Match", valid_564375
  var valid_564376 = header.getOrDefault("ocp-date")
  valid_564376 = validateParameter(valid_564376, JString, required = false,
                                 default = nil)
  if valid_564376 != nil:
    section.add "ocp-date", valid_564376
  var valid_564377 = header.getOrDefault("If-Match")
  valid_564377 = validateParameter(valid_564377, JString, required = false,
                                 default = nil)
  if valid_564377 != nil:
    section.add "If-Match", valid_564377
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564378: Call_JobEnable_564365; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you call this API, the Batch service sets a disabled job to the enabling state. After the this operation is completed, the job moves to the active state, and scheduling of new tasks under the job resumes. The Batch service does not allow a task to remain in the active state for more than 180 days. Therefore, if you enable a job containing active tasks which were added more than 180 days ago, those tasks will not run.
  ## 
  let valid = call_564378.validator(path, query, header, formData, body)
  let scheme = call_564378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564378.url(scheme.get, call_564378.host, call_564378.base,
                         call_564378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564378, url, valid)

proc call*(call_564379: Call_JobEnable_564365; jobId: string; apiVersion: string;
          timeout: int = 30): Recallable =
  ## jobEnable
  ## When you call this API, the Batch service sets a disabled job to the enabling state. After the this operation is completed, the job moves to the active state, and scheduling of new tasks under the job resumes. The Batch service does not allow a task to remain in the active state for more than 180 days. Therefore, if you enable a job containing active tasks which were added more than 180 days ago, those tasks will not run.
  ##   jobId: string (required)
  ##        : The ID of the job to enable.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564380 = newJObject()
  var query_564381 = newJObject()
  add(path_564380, "jobId", newJString(jobId))
  add(query_564381, "api-version", newJString(apiVersion))
  add(query_564381, "timeout", newJInt(timeout))
  result = call_564379.call(path_564380, query_564381, nil, nil, nil)

var jobEnable* = Call_JobEnable_564365(name: "jobEnable", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/jobs/{jobId}/enable",
                                    validator: validate_JobEnable_564366,
                                    base: "", url: url_JobEnable_564367,
                                    schemes: {Scheme.Https})
type
  Call_JobListPreparationAndReleaseTaskStatus_564382 = ref object of OpenApiRestCall_563565
proc url_JobListPreparationAndReleaseTaskStatus_564384(protocol: Scheme;
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

proc validate_JobListPreparationAndReleaseTaskStatus_564383(path: JsonNode;
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
  var valid_564385 = path.getOrDefault("jobId")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "jobId", valid_564385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 tasks can be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-preparation-and-release-status.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564386 = query.getOrDefault("api-version")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "api-version", valid_564386
  var valid_564387 = query.getOrDefault("$select")
  valid_564387 = validateParameter(valid_564387, JString, required = false,
                                 default = nil)
  if valid_564387 != nil:
    section.add "$select", valid_564387
  var valid_564388 = query.getOrDefault("timeout")
  valid_564388 = validateParameter(valid_564388, JInt, required = false,
                                 default = newJInt(30))
  if valid_564388 != nil:
    section.add "timeout", valid_564388
  var valid_564389 = query.getOrDefault("maxresults")
  valid_564389 = validateParameter(valid_564389, JInt, required = false,
                                 default = newJInt(1000))
  if valid_564389 != nil:
    section.add "maxresults", valid_564389
  var valid_564390 = query.getOrDefault("$filter")
  valid_564390 = validateParameter(valid_564390, JString, required = false,
                                 default = nil)
  if valid_564390 != nil:
    section.add "$filter", valid_564390
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564391 = header.getOrDefault("return-client-request-id")
  valid_564391 = validateParameter(valid_564391, JBool, required = false,
                                 default = newJBool(false))
  if valid_564391 != nil:
    section.add "return-client-request-id", valid_564391
  var valid_564392 = header.getOrDefault("client-request-id")
  valid_564392 = validateParameter(valid_564392, JString, required = false,
                                 default = nil)
  if valid_564392 != nil:
    section.add "client-request-id", valid_564392
  var valid_564393 = header.getOrDefault("ocp-date")
  valid_564393 = validateParameter(valid_564393, JString, required = false,
                                 default = nil)
  if valid_564393 != nil:
    section.add "ocp-date", valid_564393
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564394: Call_JobListPreparationAndReleaseTaskStatus_564382;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This API returns the Job Preparation and Job Release task status on all compute nodes that have run the Job Preparation or Job Release task. This includes nodes which have since been removed from the pool. If this API is invoked on a job which has no Job Preparation or Job Release task, the Batch service returns HTTP status code 409 (Conflict) with an error code of JobPreparationTaskNotSpecified.
  ## 
  let valid = call_564394.validator(path, query, header, formData, body)
  let scheme = call_564394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564394.url(scheme.get, call_564394.host, call_564394.base,
                         call_564394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564394, url, valid)

proc call*(call_564395: Call_JobListPreparationAndReleaseTaskStatus_564382;
          jobId: string; apiVersion: string; Select: string = ""; timeout: int = 30;
          maxresults: int = 1000; Filter: string = ""): Recallable =
  ## jobListPreparationAndReleaseTaskStatus
  ## This API returns the Job Preparation and Job Release task status on all compute nodes that have run the Job Preparation or Job Release task. This includes nodes which have since been removed from the pool. If this API is invoked on a job which has no Job Preparation or Job Release task, the Batch service returns HTTP status code 409 (Conflict) with an error code of JobPreparationTaskNotSpecified.
  ##   jobId: string (required)
  ##        : The ID of the job.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 tasks can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-preparation-and-release-status.
  var path_564396 = newJObject()
  var query_564397 = newJObject()
  add(path_564396, "jobId", newJString(jobId))
  add(query_564397, "api-version", newJString(apiVersion))
  add(query_564397, "$select", newJString(Select))
  add(query_564397, "timeout", newJInt(timeout))
  add(query_564397, "maxresults", newJInt(maxresults))
  add(query_564397, "$filter", newJString(Filter))
  result = call_564395.call(path_564396, query_564397, nil, nil, nil)

var jobListPreparationAndReleaseTaskStatus* = Call_JobListPreparationAndReleaseTaskStatus_564382(
    name: "jobListPreparationAndReleaseTaskStatus", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/jobs/{jobId}/jobpreparationandreleasetaskstatus",
    validator: validate_JobListPreparationAndReleaseTaskStatus_564383, base: "",
    url: url_JobListPreparationAndReleaseTaskStatus_564384,
    schemes: {Scheme.Https})
type
  Call_JobGetTaskCounts_564398 = ref object of OpenApiRestCall_563565
proc url_JobGetTaskCounts_564400(protocol: Scheme; host: string; base: string;
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

proc validate_JobGetTaskCounts_564399(path: JsonNode; query: JsonNode;
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
  var valid_564401 = path.getOrDefault("jobId")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "jobId", valid_564401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564402 = query.getOrDefault("api-version")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "api-version", valid_564402
  var valid_564403 = query.getOrDefault("timeout")
  valid_564403 = validateParameter(valid_564403, JInt, required = false,
                                 default = newJInt(30))
  if valid_564403 != nil:
    section.add "timeout", valid_564403
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564404 = header.getOrDefault("return-client-request-id")
  valid_564404 = validateParameter(valid_564404, JBool, required = false,
                                 default = newJBool(false))
  if valid_564404 != nil:
    section.add "return-client-request-id", valid_564404
  var valid_564405 = header.getOrDefault("client-request-id")
  valid_564405 = validateParameter(valid_564405, JString, required = false,
                                 default = nil)
  if valid_564405 != nil:
    section.add "client-request-id", valid_564405
  var valid_564406 = header.getOrDefault("ocp-date")
  valid_564406 = validateParameter(valid_564406, JString, required = false,
                                 default = nil)
  if valid_564406 != nil:
    section.add "ocp-date", valid_564406
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564407: Call_JobGetTaskCounts_564398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Task counts provide a count of the tasks by active, running or completed task state, and a count of tasks which succeeded or failed. Tasks in the preparing state are counted as running.
  ## 
  let valid = call_564407.validator(path, query, header, formData, body)
  let scheme = call_564407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564407.url(scheme.get, call_564407.host, call_564407.base,
                         call_564407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564407, url, valid)

proc call*(call_564408: Call_JobGetTaskCounts_564398; jobId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobGetTaskCounts
  ## Task counts provide a count of the tasks by active, running or completed task state, and a count of tasks which succeeded or failed. Tasks in the preparing state are counted as running.
  ##   jobId: string (required)
  ##        : The ID of the job.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564409 = newJObject()
  var query_564410 = newJObject()
  add(path_564409, "jobId", newJString(jobId))
  add(query_564410, "api-version", newJString(apiVersion))
  add(query_564410, "timeout", newJInt(timeout))
  result = call_564408.call(path_564409, query_564410, nil, nil, nil)

var jobGetTaskCounts* = Call_JobGetTaskCounts_564398(name: "jobGetTaskCounts",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/taskcounts", validator: validate_JobGetTaskCounts_564399,
    base: "", url: url_JobGetTaskCounts_564400, schemes: {Scheme.Https})
type
  Call_TaskAdd_564428 = ref object of OpenApiRestCall_563565
proc url_TaskAdd_564430(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskAdd_564429(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564431 = path.getOrDefault("jobId")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "jobId", valid_564431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564432 = query.getOrDefault("api-version")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "api-version", valid_564432
  var valid_564433 = query.getOrDefault("timeout")
  valid_564433 = validateParameter(valid_564433, JInt, required = false,
                                 default = newJInt(30))
  if valid_564433 != nil:
    section.add "timeout", valid_564433
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564434 = header.getOrDefault("return-client-request-id")
  valid_564434 = validateParameter(valid_564434, JBool, required = false,
                                 default = newJBool(false))
  if valid_564434 != nil:
    section.add "return-client-request-id", valid_564434
  var valid_564435 = header.getOrDefault("client-request-id")
  valid_564435 = validateParameter(valid_564435, JString, required = false,
                                 default = nil)
  if valid_564435 != nil:
    section.add "client-request-id", valid_564435
  var valid_564436 = header.getOrDefault("ocp-date")
  valid_564436 = validateParameter(valid_564436, JString, required = false,
                                 default = nil)
  if valid_564436 != nil:
    section.add "ocp-date", valid_564436
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

proc call*(call_564438: Call_TaskAdd_564428; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The maximum lifetime of a task from addition to completion is 180 days. If a task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ## 
  let valid = call_564438.validator(path, query, header, formData, body)
  let scheme = call_564438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564438.url(scheme.get, call_564438.host, call_564438.base,
                         call_564438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564438, url, valid)

proc call*(call_564439: Call_TaskAdd_564428; jobId: string; apiVersion: string;
          task: JsonNode; timeout: int = 30): Recallable =
  ## taskAdd
  ## The maximum lifetime of a task from addition to completion is 180 days. If a task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ##   jobId: string (required)
  ##        : The ID of the job to which the task is to be added.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   task: JObject (required)
  ##       : The task to be added.
  var path_564440 = newJObject()
  var query_564441 = newJObject()
  var body_564442 = newJObject()
  add(path_564440, "jobId", newJString(jobId))
  add(query_564441, "api-version", newJString(apiVersion))
  add(query_564441, "timeout", newJInt(timeout))
  if task != nil:
    body_564442 = task
  result = call_564439.call(path_564440, query_564441, nil, nil, body_564442)

var taskAdd* = Call_TaskAdd_564428(name: "taskAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/jobs/{jobId}/tasks",
                                validator: validate_TaskAdd_564429, base: "",
                                url: url_TaskAdd_564430, schemes: {Scheme.Https})
type
  Call_TaskList_564411 = ref object of OpenApiRestCall_563565
proc url_TaskList_564413(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskList_564412(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564414 = path.getOrDefault("jobId")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "jobId", valid_564414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 tasks can be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-tasks.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564415 = query.getOrDefault("api-version")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "api-version", valid_564415
  var valid_564416 = query.getOrDefault("$select")
  valid_564416 = validateParameter(valid_564416, JString, required = false,
                                 default = nil)
  if valid_564416 != nil:
    section.add "$select", valid_564416
  var valid_564417 = query.getOrDefault("$expand")
  valid_564417 = validateParameter(valid_564417, JString, required = false,
                                 default = nil)
  if valid_564417 != nil:
    section.add "$expand", valid_564417
  var valid_564418 = query.getOrDefault("timeout")
  valid_564418 = validateParameter(valid_564418, JInt, required = false,
                                 default = newJInt(30))
  if valid_564418 != nil:
    section.add "timeout", valid_564418
  var valid_564419 = query.getOrDefault("maxresults")
  valid_564419 = validateParameter(valid_564419, JInt, required = false,
                                 default = newJInt(1000))
  if valid_564419 != nil:
    section.add "maxresults", valid_564419
  var valid_564420 = query.getOrDefault("$filter")
  valid_564420 = validateParameter(valid_564420, JString, required = false,
                                 default = nil)
  if valid_564420 != nil:
    section.add "$filter", valid_564420
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564421 = header.getOrDefault("return-client-request-id")
  valid_564421 = validateParameter(valid_564421, JBool, required = false,
                                 default = newJBool(false))
  if valid_564421 != nil:
    section.add "return-client-request-id", valid_564421
  var valid_564422 = header.getOrDefault("client-request-id")
  valid_564422 = validateParameter(valid_564422, JString, required = false,
                                 default = nil)
  if valid_564422 != nil:
    section.add "client-request-id", valid_564422
  var valid_564423 = header.getOrDefault("ocp-date")
  valid_564423 = validateParameter(valid_564423, JString, required = false,
                                 default = nil)
  if valid_564423 != nil:
    section.add "ocp-date", valid_564423
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564424: Call_TaskList_564411; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## For multi-instance tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary task. Use the list subtasks API to retrieve information about subtasks.
  ## 
  let valid = call_564424.validator(path, query, header, formData, body)
  let scheme = call_564424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564424.url(scheme.get, call_564424.host, call_564424.base,
                         call_564424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564424, url, valid)

proc call*(call_564425: Call_TaskList_564411; jobId: string; apiVersion: string;
          Select: string = ""; Expand: string = ""; timeout: int = 30;
          maxresults: int = 1000; Filter: string = ""): Recallable =
  ## taskList
  ## For multi-instance tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary task. Use the list subtasks API to retrieve information about subtasks.
  ##   jobId: string (required)
  ##        : The ID of the job.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 tasks can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-tasks.
  var path_564426 = newJObject()
  var query_564427 = newJObject()
  add(path_564426, "jobId", newJString(jobId))
  add(query_564427, "api-version", newJString(apiVersion))
  add(query_564427, "$select", newJString(Select))
  add(query_564427, "$expand", newJString(Expand))
  add(query_564427, "timeout", newJInt(timeout))
  add(query_564427, "maxresults", newJInt(maxresults))
  add(query_564427, "$filter", newJString(Filter))
  result = call_564425.call(path_564426, query_564427, nil, nil, nil)

var taskList* = Call_TaskList_564411(name: "taskList", meth: HttpMethod.HttpGet,
                                  host: "azure.local",
                                  route: "/jobs/{jobId}/tasks",
                                  validator: validate_TaskList_564412, base: "",
                                  url: url_TaskList_564413,
                                  schemes: {Scheme.Https})
type
  Call_TaskUpdate_564463 = ref object of OpenApiRestCall_563565
proc url_TaskUpdate_564465(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskUpdate_564464(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564466 = path.getOrDefault("jobId")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "jobId", valid_564466
  var valid_564467 = path.getOrDefault("taskId")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "taskId", valid_564467
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564468 = query.getOrDefault("api-version")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "api-version", valid_564468
  var valid_564469 = query.getOrDefault("timeout")
  valid_564469 = validateParameter(valid_564469, JInt, required = false,
                                 default = newJInt(30))
  if valid_564469 != nil:
    section.add "timeout", valid_564469
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564470 = header.getOrDefault("return-client-request-id")
  valid_564470 = validateParameter(valid_564470, JBool, required = false,
                                 default = newJBool(false))
  if valid_564470 != nil:
    section.add "return-client-request-id", valid_564470
  var valid_564471 = header.getOrDefault("If-Unmodified-Since")
  valid_564471 = validateParameter(valid_564471, JString, required = false,
                                 default = nil)
  if valid_564471 != nil:
    section.add "If-Unmodified-Since", valid_564471
  var valid_564472 = header.getOrDefault("client-request-id")
  valid_564472 = validateParameter(valid_564472, JString, required = false,
                                 default = nil)
  if valid_564472 != nil:
    section.add "client-request-id", valid_564472
  var valid_564473 = header.getOrDefault("If-Modified-Since")
  valid_564473 = validateParameter(valid_564473, JString, required = false,
                                 default = nil)
  if valid_564473 != nil:
    section.add "If-Modified-Since", valid_564473
  var valid_564474 = header.getOrDefault("If-None-Match")
  valid_564474 = validateParameter(valid_564474, JString, required = false,
                                 default = nil)
  if valid_564474 != nil:
    section.add "If-None-Match", valid_564474
  var valid_564475 = header.getOrDefault("ocp-date")
  valid_564475 = validateParameter(valid_564475, JString, required = false,
                                 default = nil)
  if valid_564475 != nil:
    section.add "ocp-date", valid_564475
  var valid_564476 = header.getOrDefault("If-Match")
  valid_564476 = validateParameter(valid_564476, JString, required = false,
                                 default = nil)
  if valid_564476 != nil:
    section.add "If-Match", valid_564476
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

proc call*(call_564478: Call_TaskUpdate_564463; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of the specified task.
  ## 
  let valid = call_564478.validator(path, query, header, formData, body)
  let scheme = call_564478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564478.url(scheme.get, call_564478.host, call_564478.base,
                         call_564478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564478, url, valid)

proc call*(call_564479: Call_TaskUpdate_564463; jobId: string;
          taskUpdateParameter: JsonNode; apiVersion: string; taskId: string;
          timeout: int = 30): Recallable =
  ## taskUpdate
  ## Updates the properties of the specified task.
  ##   jobId: string (required)
  ##        : The ID of the job containing the task.
  ##   taskUpdateParameter: JObject (required)
  ##                      : The parameters for the request.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   taskId: string (required)
  ##         : The ID of the task to update.
  var path_564480 = newJObject()
  var query_564481 = newJObject()
  var body_564482 = newJObject()
  add(path_564480, "jobId", newJString(jobId))
  if taskUpdateParameter != nil:
    body_564482 = taskUpdateParameter
  add(query_564481, "api-version", newJString(apiVersion))
  add(query_564481, "timeout", newJInt(timeout))
  add(path_564480, "taskId", newJString(taskId))
  result = call_564479.call(path_564480, query_564481, nil, nil, body_564482)

var taskUpdate* = Call_TaskUpdate_564463(name: "taskUpdate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local",
                                      route: "/jobs/{jobId}/tasks/{taskId}",
                                      validator: validate_TaskUpdate_564464,
                                      base: "", url: url_TaskUpdate_564465,
                                      schemes: {Scheme.Https})
type
  Call_TaskGet_564443 = ref object of OpenApiRestCall_563565
proc url_TaskGet_564445(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskGet_564444(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564446 = path.getOrDefault("jobId")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "jobId", valid_564446
  var valid_564447 = path.getOrDefault("taskId")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "taskId", valid_564447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564448 = query.getOrDefault("api-version")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "api-version", valid_564448
  var valid_564449 = query.getOrDefault("$select")
  valid_564449 = validateParameter(valid_564449, JString, required = false,
                                 default = nil)
  if valid_564449 != nil:
    section.add "$select", valid_564449
  var valid_564450 = query.getOrDefault("$expand")
  valid_564450 = validateParameter(valid_564450, JString, required = false,
                                 default = nil)
  if valid_564450 != nil:
    section.add "$expand", valid_564450
  var valid_564451 = query.getOrDefault("timeout")
  valid_564451 = validateParameter(valid_564451, JInt, required = false,
                                 default = newJInt(30))
  if valid_564451 != nil:
    section.add "timeout", valid_564451
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564452 = header.getOrDefault("return-client-request-id")
  valid_564452 = validateParameter(valid_564452, JBool, required = false,
                                 default = newJBool(false))
  if valid_564452 != nil:
    section.add "return-client-request-id", valid_564452
  var valid_564453 = header.getOrDefault("If-Unmodified-Since")
  valid_564453 = validateParameter(valid_564453, JString, required = false,
                                 default = nil)
  if valid_564453 != nil:
    section.add "If-Unmodified-Since", valid_564453
  var valid_564454 = header.getOrDefault("client-request-id")
  valid_564454 = validateParameter(valid_564454, JString, required = false,
                                 default = nil)
  if valid_564454 != nil:
    section.add "client-request-id", valid_564454
  var valid_564455 = header.getOrDefault("If-Modified-Since")
  valid_564455 = validateParameter(valid_564455, JString, required = false,
                                 default = nil)
  if valid_564455 != nil:
    section.add "If-Modified-Since", valid_564455
  var valid_564456 = header.getOrDefault("If-None-Match")
  valid_564456 = validateParameter(valid_564456, JString, required = false,
                                 default = nil)
  if valid_564456 != nil:
    section.add "If-None-Match", valid_564456
  var valid_564457 = header.getOrDefault("ocp-date")
  valid_564457 = validateParameter(valid_564457, JString, required = false,
                                 default = nil)
  if valid_564457 != nil:
    section.add "ocp-date", valid_564457
  var valid_564458 = header.getOrDefault("If-Match")
  valid_564458 = validateParameter(valid_564458, JString, required = false,
                                 default = nil)
  if valid_564458 != nil:
    section.add "If-Match", valid_564458
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564459: Call_TaskGet_564443; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## For multi-instance tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary task. Use the list subtasks API to retrieve information about subtasks.
  ## 
  let valid = call_564459.validator(path, query, header, formData, body)
  let scheme = call_564459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564459.url(scheme.get, call_564459.host, call_564459.base,
                         call_564459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564459, url, valid)

proc call*(call_564460: Call_TaskGet_564443; jobId: string; apiVersion: string;
          taskId: string; Select: string = ""; Expand: string = ""; timeout: int = 30): Recallable =
  ## taskGet
  ## For multi-instance tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary task. Use the list subtasks API to retrieve information about subtasks.
  ##   jobId: string (required)
  ##        : The ID of the job that contains the task.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   taskId: string (required)
  ##         : The ID of the task to get information about.
  var path_564461 = newJObject()
  var query_564462 = newJObject()
  add(path_564461, "jobId", newJString(jobId))
  add(query_564462, "api-version", newJString(apiVersion))
  add(query_564462, "$select", newJString(Select))
  add(query_564462, "$expand", newJString(Expand))
  add(query_564462, "timeout", newJInt(timeout))
  add(path_564461, "taskId", newJString(taskId))
  result = call_564460.call(path_564461, query_564462, nil, nil, nil)

var taskGet* = Call_TaskGet_564443(name: "taskGet", meth: HttpMethod.HttpGet,
                                host: "azure.local",
                                route: "/jobs/{jobId}/tasks/{taskId}",
                                validator: validate_TaskGet_564444, base: "",
                                url: url_TaskGet_564445, schemes: {Scheme.Https})
type
  Call_TaskDelete_564483 = ref object of OpenApiRestCall_563565
proc url_TaskDelete_564485(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskDelete_564484(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564486 = path.getOrDefault("jobId")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "jobId", valid_564486
  var valid_564487 = path.getOrDefault("taskId")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "taskId", valid_564487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564488 = query.getOrDefault("api-version")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "api-version", valid_564488
  var valid_564489 = query.getOrDefault("timeout")
  valid_564489 = validateParameter(valid_564489, JInt, required = false,
                                 default = newJInt(30))
  if valid_564489 != nil:
    section.add "timeout", valid_564489
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564490 = header.getOrDefault("return-client-request-id")
  valid_564490 = validateParameter(valid_564490, JBool, required = false,
                                 default = newJBool(false))
  if valid_564490 != nil:
    section.add "return-client-request-id", valid_564490
  var valid_564491 = header.getOrDefault("If-Unmodified-Since")
  valid_564491 = validateParameter(valid_564491, JString, required = false,
                                 default = nil)
  if valid_564491 != nil:
    section.add "If-Unmodified-Since", valid_564491
  var valid_564492 = header.getOrDefault("client-request-id")
  valid_564492 = validateParameter(valid_564492, JString, required = false,
                                 default = nil)
  if valid_564492 != nil:
    section.add "client-request-id", valid_564492
  var valid_564493 = header.getOrDefault("If-Modified-Since")
  valid_564493 = validateParameter(valid_564493, JString, required = false,
                                 default = nil)
  if valid_564493 != nil:
    section.add "If-Modified-Since", valid_564493
  var valid_564494 = header.getOrDefault("If-None-Match")
  valid_564494 = validateParameter(valid_564494, JString, required = false,
                                 default = nil)
  if valid_564494 != nil:
    section.add "If-None-Match", valid_564494
  var valid_564495 = header.getOrDefault("ocp-date")
  valid_564495 = validateParameter(valid_564495, JString, required = false,
                                 default = nil)
  if valid_564495 != nil:
    section.add "ocp-date", valid_564495
  var valid_564496 = header.getOrDefault("If-Match")
  valid_564496 = validateParameter(valid_564496, JString, required = false,
                                 default = nil)
  if valid_564496 != nil:
    section.add "If-Match", valid_564496
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564497: Call_TaskDelete_564483; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When a task is deleted, all of the files in its directory on the compute node where it ran are also deleted (regardless of the retention time). For multi-instance tasks, the delete task operation applies synchronously to the primary task; subtasks and their files are then deleted asynchronously in the background.
  ## 
  let valid = call_564497.validator(path, query, header, formData, body)
  let scheme = call_564497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564497.url(scheme.get, call_564497.host, call_564497.base,
                         call_564497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564497, url, valid)

proc call*(call_564498: Call_TaskDelete_564483; jobId: string; apiVersion: string;
          taskId: string; timeout: int = 30): Recallable =
  ## taskDelete
  ## When a task is deleted, all of the files in its directory on the compute node where it ran are also deleted (regardless of the retention time). For multi-instance tasks, the delete task operation applies synchronously to the primary task; subtasks and their files are then deleted asynchronously in the background.
  ##   jobId: string (required)
  ##        : The ID of the job from which to delete the task.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   taskId: string (required)
  ##         : The ID of the task to delete.
  var path_564499 = newJObject()
  var query_564500 = newJObject()
  add(path_564499, "jobId", newJString(jobId))
  add(query_564500, "api-version", newJString(apiVersion))
  add(query_564500, "timeout", newJInt(timeout))
  add(path_564499, "taskId", newJString(taskId))
  result = call_564498.call(path_564499, query_564500, nil, nil, nil)

var taskDelete* = Call_TaskDelete_564483(name: "taskDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/jobs/{jobId}/tasks/{taskId}",
                                      validator: validate_TaskDelete_564484,
                                      base: "", url: url_TaskDelete_564485,
                                      schemes: {Scheme.Https})
type
  Call_FileListFromTask_564501 = ref object of OpenApiRestCall_563565
proc url_FileListFromTask_564503(protocol: Scheme; host: string; base: string;
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

proc validate_FileListFromTask_564502(path: JsonNode; query: JsonNode;
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
  var valid_564504 = path.getOrDefault("jobId")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "jobId", valid_564504
  var valid_564505 = path.getOrDefault("taskId")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "taskId", valid_564505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   recursive: JBool
  ##            : Whether to list children of the task directory. This parameter can be used in combination with the filter parameter to list specific type of files.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-task-files.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564506 = query.getOrDefault("api-version")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "api-version", valid_564506
  var valid_564507 = query.getOrDefault("recursive")
  valid_564507 = validateParameter(valid_564507, JBool, required = false, default = nil)
  if valid_564507 != nil:
    section.add "recursive", valid_564507
  var valid_564508 = query.getOrDefault("timeout")
  valid_564508 = validateParameter(valid_564508, JInt, required = false,
                                 default = newJInt(30))
  if valid_564508 != nil:
    section.add "timeout", valid_564508
  var valid_564509 = query.getOrDefault("maxresults")
  valid_564509 = validateParameter(valid_564509, JInt, required = false,
                                 default = newJInt(1000))
  if valid_564509 != nil:
    section.add "maxresults", valid_564509
  var valid_564510 = query.getOrDefault("$filter")
  valid_564510 = validateParameter(valid_564510, JString, required = false,
                                 default = nil)
  if valid_564510 != nil:
    section.add "$filter", valid_564510
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564511 = header.getOrDefault("return-client-request-id")
  valid_564511 = validateParameter(valid_564511, JBool, required = false,
                                 default = newJBool(false))
  if valid_564511 != nil:
    section.add "return-client-request-id", valid_564511
  var valid_564512 = header.getOrDefault("client-request-id")
  valid_564512 = validateParameter(valid_564512, JString, required = false,
                                 default = nil)
  if valid_564512 != nil:
    section.add "client-request-id", valid_564512
  var valid_564513 = header.getOrDefault("ocp-date")
  valid_564513 = validateParameter(valid_564513, JString, required = false,
                                 default = nil)
  if valid_564513 != nil:
    section.add "ocp-date", valid_564513
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564514: Call_FileListFromTask_564501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564514.validator(path, query, header, formData, body)
  let scheme = call_564514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564514.url(scheme.get, call_564514.host, call_564514.base,
                         call_564514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564514, url, valid)

proc call*(call_564515: Call_FileListFromTask_564501; jobId: string;
          apiVersion: string; taskId: string; recursive: bool = false;
          timeout: int = 30; maxresults: int = 1000; Filter: string = ""): Recallable =
  ## fileListFromTask
  ##   jobId: string (required)
  ##        : The ID of the job that contains the task.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   recursive: bool
  ##            : Whether to list children of the task directory. This parameter can be used in combination with the filter parameter to list specific type of files.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-task-files.
  ##   taskId: string (required)
  ##         : The ID of the task whose files you want to list.
  var path_564516 = newJObject()
  var query_564517 = newJObject()
  add(path_564516, "jobId", newJString(jobId))
  add(query_564517, "api-version", newJString(apiVersion))
  add(query_564517, "recursive", newJBool(recursive))
  add(query_564517, "timeout", newJInt(timeout))
  add(query_564517, "maxresults", newJInt(maxresults))
  add(query_564517, "$filter", newJString(Filter))
  add(path_564516, "taskId", newJString(taskId))
  result = call_564515.call(path_564516, query_564517, nil, nil, nil)

var fileListFromTask* = Call_FileListFromTask_564501(name: "fileListFromTask",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/files",
    validator: validate_FileListFromTask_564502, base: "",
    url: url_FileListFromTask_564503, schemes: {Scheme.Https})
type
  Call_FileGetPropertiesFromTask_564552 = ref object of OpenApiRestCall_563565
proc url_FileGetPropertiesFromTask_564554(protocol: Scheme; host: string;
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

proc validate_FileGetPropertiesFromTask_564553(path: JsonNode; query: JsonNode;
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
  var valid_564555 = path.getOrDefault("jobId")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "jobId", valid_564555
  var valid_564556 = path.getOrDefault("filePath")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "filePath", valid_564556
  var valid_564557 = path.getOrDefault("taskId")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "taskId", valid_564557
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564558 = query.getOrDefault("api-version")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "api-version", valid_564558
  var valid_564559 = query.getOrDefault("timeout")
  valid_564559 = validateParameter(valid_564559, JInt, required = false,
                                 default = newJInt(30))
  if valid_564559 != nil:
    section.add "timeout", valid_564559
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564560 = header.getOrDefault("return-client-request-id")
  valid_564560 = validateParameter(valid_564560, JBool, required = false,
                                 default = newJBool(false))
  if valid_564560 != nil:
    section.add "return-client-request-id", valid_564560
  var valid_564561 = header.getOrDefault("If-Unmodified-Since")
  valid_564561 = validateParameter(valid_564561, JString, required = false,
                                 default = nil)
  if valid_564561 != nil:
    section.add "If-Unmodified-Since", valid_564561
  var valid_564562 = header.getOrDefault("client-request-id")
  valid_564562 = validateParameter(valid_564562, JString, required = false,
                                 default = nil)
  if valid_564562 != nil:
    section.add "client-request-id", valid_564562
  var valid_564563 = header.getOrDefault("If-Modified-Since")
  valid_564563 = validateParameter(valid_564563, JString, required = false,
                                 default = nil)
  if valid_564563 != nil:
    section.add "If-Modified-Since", valid_564563
  var valid_564564 = header.getOrDefault("ocp-date")
  valid_564564 = validateParameter(valid_564564, JString, required = false,
                                 default = nil)
  if valid_564564 != nil:
    section.add "ocp-date", valid_564564
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564565: Call_FileGetPropertiesFromTask_564552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified task file.
  ## 
  let valid = call_564565.validator(path, query, header, formData, body)
  let scheme = call_564565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564565.url(scheme.get, call_564565.host, call_564565.base,
                         call_564565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564565, url, valid)

proc call*(call_564566: Call_FileGetPropertiesFromTask_564552; jobId: string;
          apiVersion: string; filePath: string; taskId: string; timeout: int = 30): Recallable =
  ## fileGetPropertiesFromTask
  ## Gets the properties of the specified task file.
  ##   jobId: string (required)
  ##        : The ID of the job that contains the task.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   filePath: string (required)
  ##           : The path to the task file that you want to get the properties of.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   taskId: string (required)
  ##         : The ID of the task whose file you want to get the properties of.
  var path_564567 = newJObject()
  var query_564568 = newJObject()
  add(path_564567, "jobId", newJString(jobId))
  add(query_564568, "api-version", newJString(apiVersion))
  add(path_564567, "filePath", newJString(filePath))
  add(query_564568, "timeout", newJInt(timeout))
  add(path_564567, "taskId", newJString(taskId))
  result = call_564566.call(path_564567, query_564568, nil, nil, nil)

var fileGetPropertiesFromTask* = Call_FileGetPropertiesFromTask_564552(
    name: "fileGetPropertiesFromTask", meth: HttpMethod.HttpHead,
    host: "azure.local", route: "/jobs/{jobId}/tasks/{taskId}/files/{filePath}",
    validator: validate_FileGetPropertiesFromTask_564553, base: "",
    url: url_FileGetPropertiesFromTask_564554, schemes: {Scheme.Https})
type
  Call_FileGetFromTask_564518 = ref object of OpenApiRestCall_563565
proc url_FileGetFromTask_564520(protocol: Scheme; host: string; base: string;
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

proc validate_FileGetFromTask_564519(path: JsonNode; query: JsonNode;
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
  var valid_564521 = path.getOrDefault("jobId")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "jobId", valid_564521
  var valid_564522 = path.getOrDefault("filePath")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "filePath", valid_564522
  var valid_564523 = path.getOrDefault("taskId")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = nil)
  if valid_564523 != nil:
    section.add "taskId", valid_564523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564524 = query.getOrDefault("api-version")
  valid_564524 = validateParameter(valid_564524, JString, required = true,
                                 default = nil)
  if valid_564524 != nil:
    section.add "api-version", valid_564524
  var valid_564525 = query.getOrDefault("timeout")
  valid_564525 = validateParameter(valid_564525, JInt, required = false,
                                 default = newJInt(30))
  if valid_564525 != nil:
    section.add "timeout", valid_564525
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   ocp-range: JString
  ##            : The byte range to be retrieved. The default is to retrieve the entire file. The format is bytes=startRange-endRange.
  section = newJObject()
  var valid_564526 = header.getOrDefault("return-client-request-id")
  valid_564526 = validateParameter(valid_564526, JBool, required = false,
                                 default = newJBool(false))
  if valid_564526 != nil:
    section.add "return-client-request-id", valid_564526
  var valid_564527 = header.getOrDefault("If-Unmodified-Since")
  valid_564527 = validateParameter(valid_564527, JString, required = false,
                                 default = nil)
  if valid_564527 != nil:
    section.add "If-Unmodified-Since", valid_564527
  var valid_564528 = header.getOrDefault("client-request-id")
  valid_564528 = validateParameter(valid_564528, JString, required = false,
                                 default = nil)
  if valid_564528 != nil:
    section.add "client-request-id", valid_564528
  var valid_564529 = header.getOrDefault("If-Modified-Since")
  valid_564529 = validateParameter(valid_564529, JString, required = false,
                                 default = nil)
  if valid_564529 != nil:
    section.add "If-Modified-Since", valid_564529
  var valid_564530 = header.getOrDefault("ocp-date")
  valid_564530 = validateParameter(valid_564530, JString, required = false,
                                 default = nil)
  if valid_564530 != nil:
    section.add "ocp-date", valid_564530
  var valid_564531 = header.getOrDefault("ocp-range")
  valid_564531 = validateParameter(valid_564531, JString, required = false,
                                 default = nil)
  if valid_564531 != nil:
    section.add "ocp-range", valid_564531
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564532: Call_FileGetFromTask_564518; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the content of the specified task file.
  ## 
  let valid = call_564532.validator(path, query, header, formData, body)
  let scheme = call_564532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564532.url(scheme.get, call_564532.host, call_564532.base,
                         call_564532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564532, url, valid)

proc call*(call_564533: Call_FileGetFromTask_564518; jobId: string;
          apiVersion: string; filePath: string; taskId: string; timeout: int = 30): Recallable =
  ## fileGetFromTask
  ## Returns the content of the specified task file.
  ##   jobId: string (required)
  ##        : The ID of the job that contains the task.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   filePath: string (required)
  ##           : The path to the task file that you want to get the content of.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   taskId: string (required)
  ##         : The ID of the task whose file you want to retrieve.
  var path_564534 = newJObject()
  var query_564535 = newJObject()
  add(path_564534, "jobId", newJString(jobId))
  add(query_564535, "api-version", newJString(apiVersion))
  add(path_564534, "filePath", newJString(filePath))
  add(query_564535, "timeout", newJInt(timeout))
  add(path_564534, "taskId", newJString(taskId))
  result = call_564533.call(path_564534, query_564535, nil, nil, nil)

var fileGetFromTask* = Call_FileGetFromTask_564518(name: "fileGetFromTask",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/files/{filePath}",
    validator: validate_FileGetFromTask_564519, base: "", url: url_FileGetFromTask_564520,
    schemes: {Scheme.Https})
type
  Call_FileDeleteFromTask_564536 = ref object of OpenApiRestCall_563565
proc url_FileDeleteFromTask_564538(protocol: Scheme; host: string; base: string;
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

proc validate_FileDeleteFromTask_564537(path: JsonNode; query: JsonNode;
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
  var valid_564539 = path.getOrDefault("jobId")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "jobId", valid_564539
  var valid_564540 = path.getOrDefault("filePath")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "filePath", valid_564540
  var valid_564541 = path.getOrDefault("taskId")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "taskId", valid_564541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   recursive: JBool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564542 = query.getOrDefault("api-version")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "api-version", valid_564542
  var valid_564543 = query.getOrDefault("recursive")
  valid_564543 = validateParameter(valid_564543, JBool, required = false, default = nil)
  if valid_564543 != nil:
    section.add "recursive", valid_564543
  var valid_564544 = query.getOrDefault("timeout")
  valid_564544 = validateParameter(valid_564544, JInt, required = false,
                                 default = newJInt(30))
  if valid_564544 != nil:
    section.add "timeout", valid_564544
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564545 = header.getOrDefault("return-client-request-id")
  valid_564545 = validateParameter(valid_564545, JBool, required = false,
                                 default = newJBool(false))
  if valid_564545 != nil:
    section.add "return-client-request-id", valid_564545
  var valid_564546 = header.getOrDefault("client-request-id")
  valid_564546 = validateParameter(valid_564546, JString, required = false,
                                 default = nil)
  if valid_564546 != nil:
    section.add "client-request-id", valid_564546
  var valid_564547 = header.getOrDefault("ocp-date")
  valid_564547 = validateParameter(valid_564547, JString, required = false,
                                 default = nil)
  if valid_564547 != nil:
    section.add "ocp-date", valid_564547
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564548: Call_FileDeleteFromTask_564536; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564548.validator(path, query, header, formData, body)
  let scheme = call_564548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564548.url(scheme.get, call_564548.host, call_564548.base,
                         call_564548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564548, url, valid)

proc call*(call_564549: Call_FileDeleteFromTask_564536; jobId: string;
          apiVersion: string; filePath: string; taskId: string;
          recursive: bool = false; timeout: int = 30): Recallable =
  ## fileDeleteFromTask
  ##   jobId: string (required)
  ##        : The ID of the job that contains the task.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   recursive: bool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  ##   filePath: string (required)
  ##           : The path to the task file or directory that you want to delete.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   taskId: string (required)
  ##         : The ID of the task whose file you want to delete.
  var path_564550 = newJObject()
  var query_564551 = newJObject()
  add(path_564550, "jobId", newJString(jobId))
  add(query_564551, "api-version", newJString(apiVersion))
  add(query_564551, "recursive", newJBool(recursive))
  add(path_564550, "filePath", newJString(filePath))
  add(query_564551, "timeout", newJInt(timeout))
  add(path_564550, "taskId", newJString(taskId))
  result = call_564549.call(path_564550, query_564551, nil, nil, nil)

var fileDeleteFromTask* = Call_FileDeleteFromTask_564536(
    name: "fileDeleteFromTask", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/files/{filePath}",
    validator: validate_FileDeleteFromTask_564537, base: "",
    url: url_FileDeleteFromTask_564538, schemes: {Scheme.Https})
type
  Call_TaskReactivate_564569 = ref object of OpenApiRestCall_563565
proc url_TaskReactivate_564571(protocol: Scheme; host: string; base: string;
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

proc validate_TaskReactivate_564570(path: JsonNode; query: JsonNode;
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
  var valid_564572 = path.getOrDefault("jobId")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "jobId", valid_564572
  var valid_564573 = path.getOrDefault("taskId")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "taskId", valid_564573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564574 = query.getOrDefault("api-version")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "api-version", valid_564574
  var valid_564575 = query.getOrDefault("timeout")
  valid_564575 = validateParameter(valid_564575, JInt, required = false,
                                 default = newJInt(30))
  if valid_564575 != nil:
    section.add "timeout", valid_564575
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564576 = header.getOrDefault("return-client-request-id")
  valid_564576 = validateParameter(valid_564576, JBool, required = false,
                                 default = newJBool(false))
  if valid_564576 != nil:
    section.add "return-client-request-id", valid_564576
  var valid_564577 = header.getOrDefault("If-Unmodified-Since")
  valid_564577 = validateParameter(valid_564577, JString, required = false,
                                 default = nil)
  if valid_564577 != nil:
    section.add "If-Unmodified-Since", valid_564577
  var valid_564578 = header.getOrDefault("client-request-id")
  valid_564578 = validateParameter(valid_564578, JString, required = false,
                                 default = nil)
  if valid_564578 != nil:
    section.add "client-request-id", valid_564578
  var valid_564579 = header.getOrDefault("If-Modified-Since")
  valid_564579 = validateParameter(valid_564579, JString, required = false,
                                 default = nil)
  if valid_564579 != nil:
    section.add "If-Modified-Since", valid_564579
  var valid_564580 = header.getOrDefault("If-None-Match")
  valid_564580 = validateParameter(valid_564580, JString, required = false,
                                 default = nil)
  if valid_564580 != nil:
    section.add "If-None-Match", valid_564580
  var valid_564581 = header.getOrDefault("ocp-date")
  valid_564581 = validateParameter(valid_564581, JString, required = false,
                                 default = nil)
  if valid_564581 != nil:
    section.add "ocp-date", valid_564581
  var valid_564582 = header.getOrDefault("If-Match")
  valid_564582 = validateParameter(valid_564582, JString, required = false,
                                 default = nil)
  if valid_564582 != nil:
    section.add "If-Match", valid_564582
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564583: Call_TaskReactivate_564569; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reactivation makes a task eligible to be retried again up to its maximum retry count. The task's state is changed to active. As the task is no longer in the completed state, any previous exit code or failure information is no longer available after reactivation. Each time a task is reactivated, its retry count is reset to 0. Reactivation will fail for tasks that are not completed or that previously completed successfully (with an exit code of 0). Additionally, it will fail if the job has completed (or is terminating or deleting).
  ## 
  let valid = call_564583.validator(path, query, header, formData, body)
  let scheme = call_564583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564583.url(scheme.get, call_564583.host, call_564583.base,
                         call_564583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564583, url, valid)

proc call*(call_564584: Call_TaskReactivate_564569; jobId: string;
          apiVersion: string; taskId: string; timeout: int = 30): Recallable =
  ## taskReactivate
  ## Reactivation makes a task eligible to be retried again up to its maximum retry count. The task's state is changed to active. As the task is no longer in the completed state, any previous exit code or failure information is no longer available after reactivation. Each time a task is reactivated, its retry count is reset to 0. Reactivation will fail for tasks that are not completed or that previously completed successfully (with an exit code of 0). Additionally, it will fail if the job has completed (or is terminating or deleting).
  ##   jobId: string (required)
  ##        : The ID of the job containing the task.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   taskId: string (required)
  ##         : The ID of the task to reactivate.
  var path_564585 = newJObject()
  var query_564586 = newJObject()
  add(path_564585, "jobId", newJString(jobId))
  add(query_564586, "api-version", newJString(apiVersion))
  add(query_564586, "timeout", newJInt(timeout))
  add(path_564585, "taskId", newJString(taskId))
  result = call_564584.call(path_564585, query_564586, nil, nil, nil)

var taskReactivate* = Call_TaskReactivate_564569(name: "taskReactivate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/reactivate",
    validator: validate_TaskReactivate_564570, base: "", url: url_TaskReactivate_564571,
    schemes: {Scheme.Https})
type
  Call_TaskListSubtasks_564587 = ref object of OpenApiRestCall_563565
proc url_TaskListSubtasks_564589(protocol: Scheme; host: string; base: string;
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

proc validate_TaskListSubtasks_564588(path: JsonNode; query: JsonNode;
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
  var valid_564590 = path.getOrDefault("jobId")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "jobId", valid_564590
  var valid_564591 = path.getOrDefault("taskId")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "taskId", valid_564591
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564592 = query.getOrDefault("api-version")
  valid_564592 = validateParameter(valid_564592, JString, required = true,
                                 default = nil)
  if valid_564592 != nil:
    section.add "api-version", valid_564592
  var valid_564593 = query.getOrDefault("$select")
  valid_564593 = validateParameter(valid_564593, JString, required = false,
                                 default = nil)
  if valid_564593 != nil:
    section.add "$select", valid_564593
  var valid_564594 = query.getOrDefault("timeout")
  valid_564594 = validateParameter(valid_564594, JInt, required = false,
                                 default = newJInt(30))
  if valid_564594 != nil:
    section.add "timeout", valid_564594
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564595 = header.getOrDefault("return-client-request-id")
  valid_564595 = validateParameter(valid_564595, JBool, required = false,
                                 default = newJBool(false))
  if valid_564595 != nil:
    section.add "return-client-request-id", valid_564595
  var valid_564596 = header.getOrDefault("client-request-id")
  valid_564596 = validateParameter(valid_564596, JString, required = false,
                                 default = nil)
  if valid_564596 != nil:
    section.add "client-request-id", valid_564596
  var valid_564597 = header.getOrDefault("ocp-date")
  valid_564597 = validateParameter(valid_564597, JString, required = false,
                                 default = nil)
  if valid_564597 != nil:
    section.add "ocp-date", valid_564597
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564598: Call_TaskListSubtasks_564587; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If the task is not a multi-instance task then this returns an empty collection.
  ## 
  let valid = call_564598.validator(path, query, header, formData, body)
  let scheme = call_564598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564598.url(scheme.get, call_564598.host, call_564598.base,
                         call_564598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564598, url, valid)

proc call*(call_564599: Call_TaskListSubtasks_564587; jobId: string;
          apiVersion: string; taskId: string; Select: string = ""; timeout: int = 30): Recallable =
  ## taskListSubtasks
  ## If the task is not a multi-instance task then this returns an empty collection.
  ##   jobId: string (required)
  ##        : The ID of the job.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   taskId: string (required)
  ##         : The ID of the task.
  var path_564600 = newJObject()
  var query_564601 = newJObject()
  add(path_564600, "jobId", newJString(jobId))
  add(query_564601, "api-version", newJString(apiVersion))
  add(query_564601, "$select", newJString(Select))
  add(query_564601, "timeout", newJInt(timeout))
  add(path_564600, "taskId", newJString(taskId))
  result = call_564599.call(path_564600, query_564601, nil, nil, nil)

var taskListSubtasks* = Call_TaskListSubtasks_564587(name: "taskListSubtasks",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/subtasksinfo",
    validator: validate_TaskListSubtasks_564588, base: "",
    url: url_TaskListSubtasks_564589, schemes: {Scheme.Https})
type
  Call_TaskTerminate_564602 = ref object of OpenApiRestCall_563565
proc url_TaskTerminate_564604(protocol: Scheme; host: string; base: string;
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

proc validate_TaskTerminate_564603(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564605 = path.getOrDefault("jobId")
  valid_564605 = validateParameter(valid_564605, JString, required = true,
                                 default = nil)
  if valid_564605 != nil:
    section.add "jobId", valid_564605
  var valid_564606 = path.getOrDefault("taskId")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "taskId", valid_564606
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564607 = query.getOrDefault("api-version")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "api-version", valid_564607
  var valid_564608 = query.getOrDefault("timeout")
  valid_564608 = validateParameter(valid_564608, JInt, required = false,
                                 default = newJInt(30))
  if valid_564608 != nil:
    section.add "timeout", valid_564608
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564609 = header.getOrDefault("return-client-request-id")
  valid_564609 = validateParameter(valid_564609, JBool, required = false,
                                 default = newJBool(false))
  if valid_564609 != nil:
    section.add "return-client-request-id", valid_564609
  var valid_564610 = header.getOrDefault("If-Unmodified-Since")
  valid_564610 = validateParameter(valid_564610, JString, required = false,
                                 default = nil)
  if valid_564610 != nil:
    section.add "If-Unmodified-Since", valid_564610
  var valid_564611 = header.getOrDefault("client-request-id")
  valid_564611 = validateParameter(valid_564611, JString, required = false,
                                 default = nil)
  if valid_564611 != nil:
    section.add "client-request-id", valid_564611
  var valid_564612 = header.getOrDefault("If-Modified-Since")
  valid_564612 = validateParameter(valid_564612, JString, required = false,
                                 default = nil)
  if valid_564612 != nil:
    section.add "If-Modified-Since", valid_564612
  var valid_564613 = header.getOrDefault("If-None-Match")
  valid_564613 = validateParameter(valid_564613, JString, required = false,
                                 default = nil)
  if valid_564613 != nil:
    section.add "If-None-Match", valid_564613
  var valid_564614 = header.getOrDefault("ocp-date")
  valid_564614 = validateParameter(valid_564614, JString, required = false,
                                 default = nil)
  if valid_564614 != nil:
    section.add "ocp-date", valid_564614
  var valid_564615 = header.getOrDefault("If-Match")
  valid_564615 = validateParameter(valid_564615, JString, required = false,
                                 default = nil)
  if valid_564615 != nil:
    section.add "If-Match", valid_564615
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564616: Call_TaskTerminate_564602; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When the task has been terminated, it moves to the completed state. For multi-instance tasks, the terminate task operation applies synchronously to the primary task; subtasks are then terminated asynchronously in the background.
  ## 
  let valid = call_564616.validator(path, query, header, formData, body)
  let scheme = call_564616.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564616.url(scheme.get, call_564616.host, call_564616.base,
                         call_564616.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564616, url, valid)

proc call*(call_564617: Call_TaskTerminate_564602; jobId: string; apiVersion: string;
          taskId: string; timeout: int = 30): Recallable =
  ## taskTerminate
  ## When the task has been terminated, it moves to the completed state. For multi-instance tasks, the terminate task operation applies synchronously to the primary task; subtasks are then terminated asynchronously in the background.
  ##   jobId: string (required)
  ##        : The ID of the job containing the task.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   taskId: string (required)
  ##         : The ID of the task to terminate.
  var path_564618 = newJObject()
  var query_564619 = newJObject()
  add(path_564618, "jobId", newJString(jobId))
  add(query_564619, "api-version", newJString(apiVersion))
  add(query_564619, "timeout", newJInt(timeout))
  add(path_564618, "taskId", newJString(taskId))
  result = call_564617.call(path_564618, query_564619, nil, nil, nil)

var taskTerminate* = Call_TaskTerminate_564602(name: "taskTerminate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/terminate",
    validator: validate_TaskTerminate_564603, base: "", url: url_TaskTerminate_564604,
    schemes: {Scheme.Https})
type
  Call_JobTerminate_564620 = ref object of OpenApiRestCall_563565
proc url_JobTerminate_564622(protocol: Scheme; host: string; base: string;
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

proc validate_JobTerminate_564621(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564623 = path.getOrDefault("jobId")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "jobId", valid_564623
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564624 = query.getOrDefault("api-version")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "api-version", valid_564624
  var valid_564625 = query.getOrDefault("timeout")
  valid_564625 = validateParameter(valid_564625, JInt, required = false,
                                 default = newJInt(30))
  if valid_564625 != nil:
    section.add "timeout", valid_564625
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564626 = header.getOrDefault("return-client-request-id")
  valid_564626 = validateParameter(valid_564626, JBool, required = false,
                                 default = newJBool(false))
  if valid_564626 != nil:
    section.add "return-client-request-id", valid_564626
  var valid_564627 = header.getOrDefault("If-Unmodified-Since")
  valid_564627 = validateParameter(valid_564627, JString, required = false,
                                 default = nil)
  if valid_564627 != nil:
    section.add "If-Unmodified-Since", valid_564627
  var valid_564628 = header.getOrDefault("client-request-id")
  valid_564628 = validateParameter(valid_564628, JString, required = false,
                                 default = nil)
  if valid_564628 != nil:
    section.add "client-request-id", valid_564628
  var valid_564629 = header.getOrDefault("If-Modified-Since")
  valid_564629 = validateParameter(valid_564629, JString, required = false,
                                 default = nil)
  if valid_564629 != nil:
    section.add "If-Modified-Since", valid_564629
  var valid_564630 = header.getOrDefault("If-None-Match")
  valid_564630 = validateParameter(valid_564630, JString, required = false,
                                 default = nil)
  if valid_564630 != nil:
    section.add "If-None-Match", valid_564630
  var valid_564631 = header.getOrDefault("ocp-date")
  valid_564631 = validateParameter(valid_564631, JString, required = false,
                                 default = nil)
  if valid_564631 != nil:
    section.add "ocp-date", valid_564631
  var valid_564632 = header.getOrDefault("If-Match")
  valid_564632 = validateParameter(valid_564632, JString, required = false,
                                 default = nil)
  if valid_564632 != nil:
    section.add "If-Match", valid_564632
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobTerminateParameter: JObject
  ##                        : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564634: Call_JobTerminate_564620; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When a Terminate Job request is received, the Batch service sets the job to the terminating state. The Batch service then terminates any running tasks associated with the job and runs any required job release tasks. Then the job moves into the completed state. If there are any tasks in the job in the active state, they will remain in the active state. Once a job is terminated, new tasks cannot be added and any remaining active tasks will not be scheduled.
  ## 
  let valid = call_564634.validator(path, query, header, formData, body)
  let scheme = call_564634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564634.url(scheme.get, call_564634.host, call_564634.base,
                         call_564634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564634, url, valid)

proc call*(call_564635: Call_JobTerminate_564620; jobId: string; apiVersion: string;
          timeout: int = 30; jobTerminateParameter: JsonNode = nil): Recallable =
  ## jobTerminate
  ## When a Terminate Job request is received, the Batch service sets the job to the terminating state. The Batch service then terminates any running tasks associated with the job and runs any required job release tasks. Then the job moves into the completed state. If there are any tasks in the job in the active state, they will remain in the active state. Once a job is terminated, new tasks cannot be added and any remaining active tasks will not be scheduled.
  ##   jobId: string (required)
  ##        : The ID of the job to terminate.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobTerminateParameter: JObject
  ##                        : The parameters for the request.
  var path_564636 = newJObject()
  var query_564637 = newJObject()
  var body_564638 = newJObject()
  add(path_564636, "jobId", newJString(jobId))
  add(query_564637, "api-version", newJString(apiVersion))
  add(query_564637, "timeout", newJInt(timeout))
  if jobTerminateParameter != nil:
    body_564638 = jobTerminateParameter
  result = call_564635.call(path_564636, query_564637, nil, nil, body_564638)

var jobTerminate* = Call_JobTerminate_564620(name: "jobTerminate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/terminate", validator: validate_JobTerminate_564621,
    base: "", url: url_JobTerminate_564622, schemes: {Scheme.Https})
type
  Call_JobScheduleAdd_564654 = ref object of OpenApiRestCall_563565
proc url_JobScheduleAdd_564656(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobScheduleAdd_564655(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564657 = query.getOrDefault("api-version")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "api-version", valid_564657
  var valid_564658 = query.getOrDefault("timeout")
  valid_564658 = validateParameter(valid_564658, JInt, required = false,
                                 default = newJInt(30))
  if valid_564658 != nil:
    section.add "timeout", valid_564658
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564659 = header.getOrDefault("return-client-request-id")
  valid_564659 = validateParameter(valid_564659, JBool, required = false,
                                 default = newJBool(false))
  if valid_564659 != nil:
    section.add "return-client-request-id", valid_564659
  var valid_564660 = header.getOrDefault("client-request-id")
  valid_564660 = validateParameter(valid_564660, JString, required = false,
                                 default = nil)
  if valid_564660 != nil:
    section.add "client-request-id", valid_564660
  var valid_564661 = header.getOrDefault("ocp-date")
  valid_564661 = validateParameter(valid_564661, JString, required = false,
                                 default = nil)
  if valid_564661 != nil:
    section.add "ocp-date", valid_564661
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

proc call*(call_564663: Call_JobScheduleAdd_564654; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564663.validator(path, query, header, formData, body)
  let scheme = call_564663.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564663.url(scheme.get, call_564663.host, call_564663.base,
                         call_564663.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564663, url, valid)

proc call*(call_564664: Call_JobScheduleAdd_564654; apiVersion: string;
          cloudJobSchedule: JsonNode; timeout: int = 30): Recallable =
  ## jobScheduleAdd
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   cloudJobSchedule: JObject (required)
  ##                   : The job schedule to be added.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var query_564665 = newJObject()
  var body_564666 = newJObject()
  add(query_564665, "api-version", newJString(apiVersion))
  if cloudJobSchedule != nil:
    body_564666 = cloudJobSchedule
  add(query_564665, "timeout", newJInt(timeout))
  result = call_564664.call(nil, query_564665, nil, nil, body_564666)

var jobScheduleAdd* = Call_JobScheduleAdd_564654(name: "jobScheduleAdd",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/jobschedules",
    validator: validate_JobScheduleAdd_564655, base: "", url: url_JobScheduleAdd_564656,
    schemes: {Scheme.Https})
type
  Call_JobScheduleList_564639 = ref object of OpenApiRestCall_563565
proc url_JobScheduleList_564641(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobScheduleList_564640(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 job schedules can be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-schedules.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564642 = query.getOrDefault("api-version")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "api-version", valid_564642
  var valid_564643 = query.getOrDefault("$select")
  valid_564643 = validateParameter(valid_564643, JString, required = false,
                                 default = nil)
  if valid_564643 != nil:
    section.add "$select", valid_564643
  var valid_564644 = query.getOrDefault("$expand")
  valid_564644 = validateParameter(valid_564644, JString, required = false,
                                 default = nil)
  if valid_564644 != nil:
    section.add "$expand", valid_564644
  var valid_564645 = query.getOrDefault("timeout")
  valid_564645 = validateParameter(valid_564645, JInt, required = false,
                                 default = newJInt(30))
  if valid_564645 != nil:
    section.add "timeout", valid_564645
  var valid_564646 = query.getOrDefault("maxresults")
  valid_564646 = validateParameter(valid_564646, JInt, required = false,
                                 default = newJInt(1000))
  if valid_564646 != nil:
    section.add "maxresults", valid_564646
  var valid_564647 = query.getOrDefault("$filter")
  valid_564647 = validateParameter(valid_564647, JString, required = false,
                                 default = nil)
  if valid_564647 != nil:
    section.add "$filter", valid_564647
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564648 = header.getOrDefault("return-client-request-id")
  valid_564648 = validateParameter(valid_564648, JBool, required = false,
                                 default = newJBool(false))
  if valid_564648 != nil:
    section.add "return-client-request-id", valid_564648
  var valid_564649 = header.getOrDefault("client-request-id")
  valid_564649 = validateParameter(valid_564649, JString, required = false,
                                 default = nil)
  if valid_564649 != nil:
    section.add "client-request-id", valid_564649
  var valid_564650 = header.getOrDefault("ocp-date")
  valid_564650 = validateParameter(valid_564650, JString, required = false,
                                 default = nil)
  if valid_564650 != nil:
    section.add "ocp-date", valid_564650
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564651: Call_JobScheduleList_564639; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564651.validator(path, query, header, formData, body)
  let scheme = call_564651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564651.url(scheme.get, call_564651.host, call_564651.base,
                         call_564651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564651, url, valid)

proc call*(call_564652: Call_JobScheduleList_564639; apiVersion: string;
          Select: string = ""; Expand: string = ""; timeout: int = 30;
          maxresults: int = 1000; Filter: string = ""): Recallable =
  ## jobScheduleList
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 job schedules can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-schedules.
  var query_564653 = newJObject()
  add(query_564653, "api-version", newJString(apiVersion))
  add(query_564653, "$select", newJString(Select))
  add(query_564653, "$expand", newJString(Expand))
  add(query_564653, "timeout", newJInt(timeout))
  add(query_564653, "maxresults", newJInt(maxresults))
  add(query_564653, "$filter", newJString(Filter))
  result = call_564652.call(nil, query_564653, nil, nil, nil)

var jobScheduleList* = Call_JobScheduleList_564639(name: "jobScheduleList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/jobschedules",
    validator: validate_JobScheduleList_564640, base: "", url: url_JobScheduleList_564641,
    schemes: {Scheme.Https})
type
  Call_JobScheduleUpdate_564686 = ref object of OpenApiRestCall_563565
proc url_JobScheduleUpdate_564688(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleUpdate_564687(path: JsonNode; query: JsonNode;
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
  var valid_564689 = path.getOrDefault("jobScheduleId")
  valid_564689 = validateParameter(valid_564689, JString, required = true,
                                 default = nil)
  if valid_564689 != nil:
    section.add "jobScheduleId", valid_564689
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564690 = query.getOrDefault("api-version")
  valid_564690 = validateParameter(valid_564690, JString, required = true,
                                 default = nil)
  if valid_564690 != nil:
    section.add "api-version", valid_564690
  var valid_564691 = query.getOrDefault("timeout")
  valid_564691 = validateParameter(valid_564691, JInt, required = false,
                                 default = newJInt(30))
  if valid_564691 != nil:
    section.add "timeout", valid_564691
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564692 = header.getOrDefault("return-client-request-id")
  valid_564692 = validateParameter(valid_564692, JBool, required = false,
                                 default = newJBool(false))
  if valid_564692 != nil:
    section.add "return-client-request-id", valid_564692
  var valid_564693 = header.getOrDefault("If-Unmodified-Since")
  valid_564693 = validateParameter(valid_564693, JString, required = false,
                                 default = nil)
  if valid_564693 != nil:
    section.add "If-Unmodified-Since", valid_564693
  var valid_564694 = header.getOrDefault("client-request-id")
  valid_564694 = validateParameter(valid_564694, JString, required = false,
                                 default = nil)
  if valid_564694 != nil:
    section.add "client-request-id", valid_564694
  var valid_564695 = header.getOrDefault("If-Modified-Since")
  valid_564695 = validateParameter(valid_564695, JString, required = false,
                                 default = nil)
  if valid_564695 != nil:
    section.add "If-Modified-Since", valid_564695
  var valid_564696 = header.getOrDefault("If-None-Match")
  valid_564696 = validateParameter(valid_564696, JString, required = false,
                                 default = nil)
  if valid_564696 != nil:
    section.add "If-None-Match", valid_564696
  var valid_564697 = header.getOrDefault("ocp-date")
  valid_564697 = validateParameter(valid_564697, JString, required = false,
                                 default = nil)
  if valid_564697 != nil:
    section.add "ocp-date", valid_564697
  var valid_564698 = header.getOrDefault("If-Match")
  valid_564698 = validateParameter(valid_564698, JString, required = false,
                                 default = nil)
  if valid_564698 != nil:
    section.add "If-Match", valid_564698
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

proc call*(call_564700: Call_JobScheduleUpdate_564686; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This fully replaces all the updatable properties of the job schedule. For example, if the schedule property is not specified with this request, then the Batch service will remove the existing schedule. Changes to a job schedule only impact jobs created by the schedule after the update has taken place; currently running jobs are unaffected.
  ## 
  let valid = call_564700.validator(path, query, header, formData, body)
  let scheme = call_564700.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564700.url(scheme.get, call_564700.host, call_564700.base,
                         call_564700.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564700, url, valid)

proc call*(call_564701: Call_JobScheduleUpdate_564686; apiVersion: string;
          jobScheduleId: string; jobScheduleUpdateParameter: JsonNode;
          timeout: int = 30): Recallable =
  ## jobScheduleUpdate
  ## This fully replaces all the updatable properties of the job schedule. For example, if the schedule property is not specified with this request, then the Batch service will remove the existing schedule. Changes to a job schedule only impact jobs created by the schedule after the update has taken place; currently running jobs are unaffected.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to update.
  ##   jobScheduleUpdateParameter: JObject (required)
  ##                             : The parameters for the request.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564702 = newJObject()
  var query_564703 = newJObject()
  var body_564704 = newJObject()
  add(query_564703, "api-version", newJString(apiVersion))
  add(path_564702, "jobScheduleId", newJString(jobScheduleId))
  if jobScheduleUpdateParameter != nil:
    body_564704 = jobScheduleUpdateParameter
  add(query_564703, "timeout", newJInt(timeout))
  result = call_564701.call(path_564702, query_564703, nil, nil, body_564704)

var jobScheduleUpdate* = Call_JobScheduleUpdate_564686(name: "jobScheduleUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleUpdate_564687,
    base: "", url: url_JobScheduleUpdate_564688, schemes: {Scheme.Https})
type
  Call_JobScheduleExists_564722 = ref object of OpenApiRestCall_563565
proc url_JobScheduleExists_564724(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleExists_564723(path: JsonNode; query: JsonNode;
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
  var valid_564725 = path.getOrDefault("jobScheduleId")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "jobScheduleId", valid_564725
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564726 = query.getOrDefault("api-version")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "api-version", valid_564726
  var valid_564727 = query.getOrDefault("timeout")
  valid_564727 = validateParameter(valid_564727, JInt, required = false,
                                 default = newJInt(30))
  if valid_564727 != nil:
    section.add "timeout", valid_564727
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564728 = header.getOrDefault("return-client-request-id")
  valid_564728 = validateParameter(valid_564728, JBool, required = false,
                                 default = newJBool(false))
  if valid_564728 != nil:
    section.add "return-client-request-id", valid_564728
  var valid_564729 = header.getOrDefault("If-Unmodified-Since")
  valid_564729 = validateParameter(valid_564729, JString, required = false,
                                 default = nil)
  if valid_564729 != nil:
    section.add "If-Unmodified-Since", valid_564729
  var valid_564730 = header.getOrDefault("client-request-id")
  valid_564730 = validateParameter(valid_564730, JString, required = false,
                                 default = nil)
  if valid_564730 != nil:
    section.add "client-request-id", valid_564730
  var valid_564731 = header.getOrDefault("If-Modified-Since")
  valid_564731 = validateParameter(valid_564731, JString, required = false,
                                 default = nil)
  if valid_564731 != nil:
    section.add "If-Modified-Since", valid_564731
  var valid_564732 = header.getOrDefault("If-None-Match")
  valid_564732 = validateParameter(valid_564732, JString, required = false,
                                 default = nil)
  if valid_564732 != nil:
    section.add "If-None-Match", valid_564732
  var valid_564733 = header.getOrDefault("ocp-date")
  valid_564733 = validateParameter(valid_564733, JString, required = false,
                                 default = nil)
  if valid_564733 != nil:
    section.add "ocp-date", valid_564733
  var valid_564734 = header.getOrDefault("If-Match")
  valid_564734 = validateParameter(valid_564734, JString, required = false,
                                 default = nil)
  if valid_564734 != nil:
    section.add "If-Match", valid_564734
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564735: Call_JobScheduleExists_564722; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564735.validator(path, query, header, formData, body)
  let scheme = call_564735.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564735.url(scheme.get, call_564735.host, call_564735.base,
                         call_564735.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564735, url, valid)

proc call*(call_564736: Call_JobScheduleExists_564722; apiVersion: string;
          jobScheduleId: string; timeout: int = 30): Recallable =
  ## jobScheduleExists
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule which you want to check.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564737 = newJObject()
  var query_564738 = newJObject()
  add(query_564738, "api-version", newJString(apiVersion))
  add(path_564737, "jobScheduleId", newJString(jobScheduleId))
  add(query_564738, "timeout", newJInt(timeout))
  result = call_564736.call(path_564737, query_564738, nil, nil, nil)

var jobScheduleExists* = Call_JobScheduleExists_564722(name: "jobScheduleExists",
    meth: HttpMethod.HttpHead, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleExists_564723,
    base: "", url: url_JobScheduleExists_564724, schemes: {Scheme.Https})
type
  Call_JobScheduleGet_564667 = ref object of OpenApiRestCall_563565
proc url_JobScheduleGet_564669(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleGet_564668(path: JsonNode; query: JsonNode;
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
  var valid_564670 = path.getOrDefault("jobScheduleId")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "jobScheduleId", valid_564670
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564671 = query.getOrDefault("api-version")
  valid_564671 = validateParameter(valid_564671, JString, required = true,
                                 default = nil)
  if valid_564671 != nil:
    section.add "api-version", valid_564671
  var valid_564672 = query.getOrDefault("$select")
  valid_564672 = validateParameter(valid_564672, JString, required = false,
                                 default = nil)
  if valid_564672 != nil:
    section.add "$select", valid_564672
  var valid_564673 = query.getOrDefault("$expand")
  valid_564673 = validateParameter(valid_564673, JString, required = false,
                                 default = nil)
  if valid_564673 != nil:
    section.add "$expand", valid_564673
  var valid_564674 = query.getOrDefault("timeout")
  valid_564674 = validateParameter(valid_564674, JInt, required = false,
                                 default = newJInt(30))
  if valid_564674 != nil:
    section.add "timeout", valid_564674
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564675 = header.getOrDefault("return-client-request-id")
  valid_564675 = validateParameter(valid_564675, JBool, required = false,
                                 default = newJBool(false))
  if valid_564675 != nil:
    section.add "return-client-request-id", valid_564675
  var valid_564676 = header.getOrDefault("If-Unmodified-Since")
  valid_564676 = validateParameter(valid_564676, JString, required = false,
                                 default = nil)
  if valid_564676 != nil:
    section.add "If-Unmodified-Since", valid_564676
  var valid_564677 = header.getOrDefault("client-request-id")
  valid_564677 = validateParameter(valid_564677, JString, required = false,
                                 default = nil)
  if valid_564677 != nil:
    section.add "client-request-id", valid_564677
  var valid_564678 = header.getOrDefault("If-Modified-Since")
  valid_564678 = validateParameter(valid_564678, JString, required = false,
                                 default = nil)
  if valid_564678 != nil:
    section.add "If-Modified-Since", valid_564678
  var valid_564679 = header.getOrDefault("If-None-Match")
  valid_564679 = validateParameter(valid_564679, JString, required = false,
                                 default = nil)
  if valid_564679 != nil:
    section.add "If-None-Match", valid_564679
  var valid_564680 = header.getOrDefault("ocp-date")
  valid_564680 = validateParameter(valid_564680, JString, required = false,
                                 default = nil)
  if valid_564680 != nil:
    section.add "ocp-date", valid_564680
  var valid_564681 = header.getOrDefault("If-Match")
  valid_564681 = validateParameter(valid_564681, JString, required = false,
                                 default = nil)
  if valid_564681 != nil:
    section.add "If-Match", valid_564681
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564682: Call_JobScheduleGet_564667; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified job schedule.
  ## 
  let valid = call_564682.validator(path, query, header, formData, body)
  let scheme = call_564682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564682.url(scheme.get, call_564682.host, call_564682.base,
                         call_564682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564682, url, valid)

proc call*(call_564683: Call_JobScheduleGet_564667; apiVersion: string;
          jobScheduleId: string; Select: string = ""; Expand: string = "";
          timeout: int = 30): Recallable =
  ## jobScheduleGet
  ## Gets information about the specified job schedule.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to get.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564684 = newJObject()
  var query_564685 = newJObject()
  add(query_564685, "api-version", newJString(apiVersion))
  add(query_564685, "$select", newJString(Select))
  add(query_564685, "$expand", newJString(Expand))
  add(path_564684, "jobScheduleId", newJString(jobScheduleId))
  add(query_564685, "timeout", newJInt(timeout))
  result = call_564683.call(path_564684, query_564685, nil, nil, nil)

var jobScheduleGet* = Call_JobScheduleGet_564667(name: "jobScheduleGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleGet_564668,
    base: "", url: url_JobScheduleGet_564669, schemes: {Scheme.Https})
type
  Call_JobSchedulePatch_564739 = ref object of OpenApiRestCall_563565
proc url_JobSchedulePatch_564741(protocol: Scheme; host: string; base: string;
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

proc validate_JobSchedulePatch_564740(path: JsonNode; query: JsonNode;
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
  var valid_564742 = path.getOrDefault("jobScheduleId")
  valid_564742 = validateParameter(valid_564742, JString, required = true,
                                 default = nil)
  if valid_564742 != nil:
    section.add "jobScheduleId", valid_564742
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564743 = query.getOrDefault("api-version")
  valid_564743 = validateParameter(valid_564743, JString, required = true,
                                 default = nil)
  if valid_564743 != nil:
    section.add "api-version", valid_564743
  var valid_564744 = query.getOrDefault("timeout")
  valid_564744 = validateParameter(valid_564744, JInt, required = false,
                                 default = newJInt(30))
  if valid_564744 != nil:
    section.add "timeout", valid_564744
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564745 = header.getOrDefault("return-client-request-id")
  valid_564745 = validateParameter(valid_564745, JBool, required = false,
                                 default = newJBool(false))
  if valid_564745 != nil:
    section.add "return-client-request-id", valid_564745
  var valid_564746 = header.getOrDefault("If-Unmodified-Since")
  valid_564746 = validateParameter(valid_564746, JString, required = false,
                                 default = nil)
  if valid_564746 != nil:
    section.add "If-Unmodified-Since", valid_564746
  var valid_564747 = header.getOrDefault("client-request-id")
  valid_564747 = validateParameter(valid_564747, JString, required = false,
                                 default = nil)
  if valid_564747 != nil:
    section.add "client-request-id", valid_564747
  var valid_564748 = header.getOrDefault("If-Modified-Since")
  valid_564748 = validateParameter(valid_564748, JString, required = false,
                                 default = nil)
  if valid_564748 != nil:
    section.add "If-Modified-Since", valid_564748
  var valid_564749 = header.getOrDefault("If-None-Match")
  valid_564749 = validateParameter(valid_564749, JString, required = false,
                                 default = nil)
  if valid_564749 != nil:
    section.add "If-None-Match", valid_564749
  var valid_564750 = header.getOrDefault("ocp-date")
  valid_564750 = validateParameter(valid_564750, JString, required = false,
                                 default = nil)
  if valid_564750 != nil:
    section.add "ocp-date", valid_564750
  var valid_564751 = header.getOrDefault("If-Match")
  valid_564751 = validateParameter(valid_564751, JString, required = false,
                                 default = nil)
  if valid_564751 != nil:
    section.add "If-Match", valid_564751
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

proc call*(call_564753: Call_JobSchedulePatch_564739; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This replaces only the job schedule properties specified in the request. For example, if the schedule property is not specified with this request, then the Batch service will keep the existing schedule. Changes to a job schedule only impact jobs created by the schedule after the update has taken place; currently running jobs are unaffected.
  ## 
  let valid = call_564753.validator(path, query, header, formData, body)
  let scheme = call_564753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564753.url(scheme.get, call_564753.host, call_564753.base,
                         call_564753.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564753, url, valid)

proc call*(call_564754: Call_JobSchedulePatch_564739; apiVersion: string;
          jobScheduleId: string; jobSchedulePatchParameter: JsonNode;
          timeout: int = 30): Recallable =
  ## jobSchedulePatch
  ## This replaces only the job schedule properties specified in the request. For example, if the schedule property is not specified with this request, then the Batch service will keep the existing schedule. Changes to a job schedule only impact jobs created by the schedule after the update has taken place; currently running jobs are unaffected.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to update.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobSchedulePatchParameter: JObject (required)
  ##                            : The parameters for the request.
  var path_564755 = newJObject()
  var query_564756 = newJObject()
  var body_564757 = newJObject()
  add(query_564756, "api-version", newJString(apiVersion))
  add(path_564755, "jobScheduleId", newJString(jobScheduleId))
  add(query_564756, "timeout", newJInt(timeout))
  if jobSchedulePatchParameter != nil:
    body_564757 = jobSchedulePatchParameter
  result = call_564754.call(path_564755, query_564756, nil, nil, body_564757)

var jobSchedulePatch* = Call_JobSchedulePatch_564739(name: "jobSchedulePatch",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobSchedulePatch_564740,
    base: "", url: url_JobSchedulePatch_564741, schemes: {Scheme.Https})
type
  Call_JobScheduleDelete_564705 = ref object of OpenApiRestCall_563565
proc url_JobScheduleDelete_564707(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleDelete_564706(path: JsonNode; query: JsonNode;
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
  var valid_564708 = path.getOrDefault("jobScheduleId")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "jobScheduleId", valid_564708
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564709 = query.getOrDefault("api-version")
  valid_564709 = validateParameter(valid_564709, JString, required = true,
                                 default = nil)
  if valid_564709 != nil:
    section.add "api-version", valid_564709
  var valid_564710 = query.getOrDefault("timeout")
  valid_564710 = validateParameter(valid_564710, JInt, required = false,
                                 default = newJInt(30))
  if valid_564710 != nil:
    section.add "timeout", valid_564710
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564711 = header.getOrDefault("return-client-request-id")
  valid_564711 = validateParameter(valid_564711, JBool, required = false,
                                 default = newJBool(false))
  if valid_564711 != nil:
    section.add "return-client-request-id", valid_564711
  var valid_564712 = header.getOrDefault("If-Unmodified-Since")
  valid_564712 = validateParameter(valid_564712, JString, required = false,
                                 default = nil)
  if valid_564712 != nil:
    section.add "If-Unmodified-Since", valid_564712
  var valid_564713 = header.getOrDefault("client-request-id")
  valid_564713 = validateParameter(valid_564713, JString, required = false,
                                 default = nil)
  if valid_564713 != nil:
    section.add "client-request-id", valid_564713
  var valid_564714 = header.getOrDefault("If-Modified-Since")
  valid_564714 = validateParameter(valid_564714, JString, required = false,
                                 default = nil)
  if valid_564714 != nil:
    section.add "If-Modified-Since", valid_564714
  var valid_564715 = header.getOrDefault("If-None-Match")
  valid_564715 = validateParameter(valid_564715, JString, required = false,
                                 default = nil)
  if valid_564715 != nil:
    section.add "If-None-Match", valid_564715
  var valid_564716 = header.getOrDefault("ocp-date")
  valid_564716 = validateParameter(valid_564716, JString, required = false,
                                 default = nil)
  if valid_564716 != nil:
    section.add "ocp-date", valid_564716
  var valid_564717 = header.getOrDefault("If-Match")
  valid_564717 = validateParameter(valid_564717, JString, required = false,
                                 default = nil)
  if valid_564717 != nil:
    section.add "If-Match", valid_564717
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564718: Call_JobScheduleDelete_564705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you delete a job schedule, this also deletes all jobs and tasks under that schedule. When tasks are deleted, all the files in their working directories on the compute nodes are also deleted (the retention period is ignored). The job schedule statistics are no longer accessible once the job schedule is deleted, though they are still counted towards account lifetime statistics.
  ## 
  let valid = call_564718.validator(path, query, header, formData, body)
  let scheme = call_564718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564718.url(scheme.get, call_564718.host, call_564718.base,
                         call_564718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564718, url, valid)

proc call*(call_564719: Call_JobScheduleDelete_564705; apiVersion: string;
          jobScheduleId: string; timeout: int = 30): Recallable =
  ## jobScheduleDelete
  ## When you delete a job schedule, this also deletes all jobs and tasks under that schedule. When tasks are deleted, all the files in their working directories on the compute nodes are also deleted (the retention period is ignored). The job schedule statistics are no longer accessible once the job schedule is deleted, though they are still counted towards account lifetime statistics.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to delete.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564720 = newJObject()
  var query_564721 = newJObject()
  add(query_564721, "api-version", newJString(apiVersion))
  add(path_564720, "jobScheduleId", newJString(jobScheduleId))
  add(query_564721, "timeout", newJInt(timeout))
  result = call_564719.call(path_564720, query_564721, nil, nil, nil)

var jobScheduleDelete* = Call_JobScheduleDelete_564705(name: "jobScheduleDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleDelete_564706,
    base: "", url: url_JobScheduleDelete_564707, schemes: {Scheme.Https})
type
  Call_JobScheduleDisable_564758 = ref object of OpenApiRestCall_563565
proc url_JobScheduleDisable_564760(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleDisable_564759(path: JsonNode; query: JsonNode;
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
  var valid_564761 = path.getOrDefault("jobScheduleId")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = nil)
  if valid_564761 != nil:
    section.add "jobScheduleId", valid_564761
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564762 = query.getOrDefault("api-version")
  valid_564762 = validateParameter(valid_564762, JString, required = true,
                                 default = nil)
  if valid_564762 != nil:
    section.add "api-version", valid_564762
  var valid_564763 = query.getOrDefault("timeout")
  valid_564763 = validateParameter(valid_564763, JInt, required = false,
                                 default = newJInt(30))
  if valid_564763 != nil:
    section.add "timeout", valid_564763
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564764 = header.getOrDefault("return-client-request-id")
  valid_564764 = validateParameter(valid_564764, JBool, required = false,
                                 default = newJBool(false))
  if valid_564764 != nil:
    section.add "return-client-request-id", valid_564764
  var valid_564765 = header.getOrDefault("If-Unmodified-Since")
  valid_564765 = validateParameter(valid_564765, JString, required = false,
                                 default = nil)
  if valid_564765 != nil:
    section.add "If-Unmodified-Since", valid_564765
  var valid_564766 = header.getOrDefault("client-request-id")
  valid_564766 = validateParameter(valid_564766, JString, required = false,
                                 default = nil)
  if valid_564766 != nil:
    section.add "client-request-id", valid_564766
  var valid_564767 = header.getOrDefault("If-Modified-Since")
  valid_564767 = validateParameter(valid_564767, JString, required = false,
                                 default = nil)
  if valid_564767 != nil:
    section.add "If-Modified-Since", valid_564767
  var valid_564768 = header.getOrDefault("If-None-Match")
  valid_564768 = validateParameter(valid_564768, JString, required = false,
                                 default = nil)
  if valid_564768 != nil:
    section.add "If-None-Match", valid_564768
  var valid_564769 = header.getOrDefault("ocp-date")
  valid_564769 = validateParameter(valid_564769, JString, required = false,
                                 default = nil)
  if valid_564769 != nil:
    section.add "ocp-date", valid_564769
  var valid_564770 = header.getOrDefault("If-Match")
  valid_564770 = validateParameter(valid_564770, JString, required = false,
                                 default = nil)
  if valid_564770 != nil:
    section.add "If-Match", valid_564770
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564771: Call_JobScheduleDisable_564758; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## No new jobs will be created until the job schedule is enabled again.
  ## 
  let valid = call_564771.validator(path, query, header, formData, body)
  let scheme = call_564771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564771.url(scheme.get, call_564771.host, call_564771.base,
                         call_564771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564771, url, valid)

proc call*(call_564772: Call_JobScheduleDisable_564758; apiVersion: string;
          jobScheduleId: string; timeout: int = 30): Recallable =
  ## jobScheduleDisable
  ## No new jobs will be created until the job schedule is enabled again.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to disable.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564773 = newJObject()
  var query_564774 = newJObject()
  add(query_564774, "api-version", newJString(apiVersion))
  add(path_564773, "jobScheduleId", newJString(jobScheduleId))
  add(query_564774, "timeout", newJInt(timeout))
  result = call_564772.call(path_564773, query_564774, nil, nil, nil)

var jobScheduleDisable* = Call_JobScheduleDisable_564758(
    name: "jobScheduleDisable", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/disable",
    validator: validate_JobScheduleDisable_564759, base: "",
    url: url_JobScheduleDisable_564760, schemes: {Scheme.Https})
type
  Call_JobScheduleEnable_564775 = ref object of OpenApiRestCall_563565
proc url_JobScheduleEnable_564777(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleEnable_564776(path: JsonNode; query: JsonNode;
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
  var valid_564778 = path.getOrDefault("jobScheduleId")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "jobScheduleId", valid_564778
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564779 = query.getOrDefault("api-version")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "api-version", valid_564779
  var valid_564780 = query.getOrDefault("timeout")
  valid_564780 = validateParameter(valid_564780, JInt, required = false,
                                 default = newJInt(30))
  if valid_564780 != nil:
    section.add "timeout", valid_564780
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564781 = header.getOrDefault("return-client-request-id")
  valid_564781 = validateParameter(valid_564781, JBool, required = false,
                                 default = newJBool(false))
  if valid_564781 != nil:
    section.add "return-client-request-id", valid_564781
  var valid_564782 = header.getOrDefault("If-Unmodified-Since")
  valid_564782 = validateParameter(valid_564782, JString, required = false,
                                 default = nil)
  if valid_564782 != nil:
    section.add "If-Unmodified-Since", valid_564782
  var valid_564783 = header.getOrDefault("client-request-id")
  valid_564783 = validateParameter(valid_564783, JString, required = false,
                                 default = nil)
  if valid_564783 != nil:
    section.add "client-request-id", valid_564783
  var valid_564784 = header.getOrDefault("If-Modified-Since")
  valid_564784 = validateParameter(valid_564784, JString, required = false,
                                 default = nil)
  if valid_564784 != nil:
    section.add "If-Modified-Since", valid_564784
  var valid_564785 = header.getOrDefault("If-None-Match")
  valid_564785 = validateParameter(valid_564785, JString, required = false,
                                 default = nil)
  if valid_564785 != nil:
    section.add "If-None-Match", valid_564785
  var valid_564786 = header.getOrDefault("ocp-date")
  valid_564786 = validateParameter(valid_564786, JString, required = false,
                                 default = nil)
  if valid_564786 != nil:
    section.add "ocp-date", valid_564786
  var valid_564787 = header.getOrDefault("If-Match")
  valid_564787 = validateParameter(valid_564787, JString, required = false,
                                 default = nil)
  if valid_564787 != nil:
    section.add "If-Match", valid_564787
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564788: Call_JobScheduleEnable_564775; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564788.validator(path, query, header, formData, body)
  let scheme = call_564788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564788.url(scheme.get, call_564788.host, call_564788.base,
                         call_564788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564788, url, valid)

proc call*(call_564789: Call_JobScheduleEnable_564775; apiVersion: string;
          jobScheduleId: string; timeout: int = 30): Recallable =
  ## jobScheduleEnable
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to enable.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564790 = newJObject()
  var query_564791 = newJObject()
  add(query_564791, "api-version", newJString(apiVersion))
  add(path_564790, "jobScheduleId", newJString(jobScheduleId))
  add(query_564791, "timeout", newJInt(timeout))
  result = call_564789.call(path_564790, query_564791, nil, nil, nil)

var jobScheduleEnable* = Call_JobScheduleEnable_564775(name: "jobScheduleEnable",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/enable",
    validator: validate_JobScheduleEnable_564776, base: "",
    url: url_JobScheduleEnable_564777, schemes: {Scheme.Https})
type
  Call_JobListFromJobSchedule_564792 = ref object of OpenApiRestCall_563565
proc url_JobListFromJobSchedule_564794(protocol: Scheme; host: string; base: string;
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

proc validate_JobListFromJobSchedule_564793(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the job schedule from which you want to get a list of jobs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_564795 = path.getOrDefault("jobScheduleId")
  valid_564795 = validateParameter(valid_564795, JString, required = true,
                                 default = nil)
  if valid_564795 != nil:
    section.add "jobScheduleId", valid_564795
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 jobs can be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs-in-a-job-schedule.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564796 = query.getOrDefault("api-version")
  valid_564796 = validateParameter(valid_564796, JString, required = true,
                                 default = nil)
  if valid_564796 != nil:
    section.add "api-version", valid_564796
  var valid_564797 = query.getOrDefault("$select")
  valid_564797 = validateParameter(valid_564797, JString, required = false,
                                 default = nil)
  if valid_564797 != nil:
    section.add "$select", valid_564797
  var valid_564798 = query.getOrDefault("$expand")
  valid_564798 = validateParameter(valid_564798, JString, required = false,
                                 default = nil)
  if valid_564798 != nil:
    section.add "$expand", valid_564798
  var valid_564799 = query.getOrDefault("timeout")
  valid_564799 = validateParameter(valid_564799, JInt, required = false,
                                 default = newJInt(30))
  if valid_564799 != nil:
    section.add "timeout", valid_564799
  var valid_564800 = query.getOrDefault("maxresults")
  valid_564800 = validateParameter(valid_564800, JInt, required = false,
                                 default = newJInt(1000))
  if valid_564800 != nil:
    section.add "maxresults", valid_564800
  var valid_564801 = query.getOrDefault("$filter")
  valid_564801 = validateParameter(valid_564801, JString, required = false,
                                 default = nil)
  if valid_564801 != nil:
    section.add "$filter", valid_564801
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564802 = header.getOrDefault("return-client-request-id")
  valid_564802 = validateParameter(valid_564802, JBool, required = false,
                                 default = newJBool(false))
  if valid_564802 != nil:
    section.add "return-client-request-id", valid_564802
  var valid_564803 = header.getOrDefault("client-request-id")
  valid_564803 = validateParameter(valid_564803, JString, required = false,
                                 default = nil)
  if valid_564803 != nil:
    section.add "client-request-id", valid_564803
  var valid_564804 = header.getOrDefault("ocp-date")
  valid_564804 = validateParameter(valid_564804, JString, required = false,
                                 default = nil)
  if valid_564804 != nil:
    section.add "ocp-date", valid_564804
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564805: Call_JobListFromJobSchedule_564792; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564805.validator(path, query, header, formData, body)
  let scheme = call_564805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564805.url(scheme.get, call_564805.host, call_564805.base,
                         call_564805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564805, url, valid)

proc call*(call_564806: Call_JobListFromJobSchedule_564792; apiVersion: string;
          jobScheduleId: string; Select: string = ""; Expand: string = "";
          timeout: int = 30; maxresults: int = 1000; Filter: string = ""): Recallable =
  ## jobListFromJobSchedule
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule from which you want to get a list of jobs.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 jobs can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs-in-a-job-schedule.
  var path_564807 = newJObject()
  var query_564808 = newJObject()
  add(query_564808, "api-version", newJString(apiVersion))
  add(query_564808, "$select", newJString(Select))
  add(query_564808, "$expand", newJString(Expand))
  add(path_564807, "jobScheduleId", newJString(jobScheduleId))
  add(query_564808, "timeout", newJInt(timeout))
  add(query_564808, "maxresults", newJInt(maxresults))
  add(query_564808, "$filter", newJString(Filter))
  result = call_564806.call(path_564807, query_564808, nil, nil, nil)

var jobListFromJobSchedule* = Call_JobListFromJobSchedule_564792(
    name: "jobListFromJobSchedule", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/jobs",
    validator: validate_JobListFromJobSchedule_564793, base: "",
    url: url_JobListFromJobSchedule_564794, schemes: {Scheme.Https})
type
  Call_JobScheduleTerminate_564809 = ref object of OpenApiRestCall_563565
proc url_JobScheduleTerminate_564811(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleTerminate_564810(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the job schedule to terminates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_564812 = path.getOrDefault("jobScheduleId")
  valid_564812 = validateParameter(valid_564812, JString, required = true,
                                 default = nil)
  if valid_564812 != nil:
    section.add "jobScheduleId", valid_564812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564813 = query.getOrDefault("api-version")
  valid_564813 = validateParameter(valid_564813, JString, required = true,
                                 default = nil)
  if valid_564813 != nil:
    section.add "api-version", valid_564813
  var valid_564814 = query.getOrDefault("timeout")
  valid_564814 = validateParameter(valid_564814, JInt, required = false,
                                 default = newJInt(30))
  if valid_564814 != nil:
    section.add "timeout", valid_564814
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564815 = header.getOrDefault("return-client-request-id")
  valid_564815 = validateParameter(valid_564815, JBool, required = false,
                                 default = newJBool(false))
  if valid_564815 != nil:
    section.add "return-client-request-id", valid_564815
  var valid_564816 = header.getOrDefault("If-Unmodified-Since")
  valid_564816 = validateParameter(valid_564816, JString, required = false,
                                 default = nil)
  if valid_564816 != nil:
    section.add "If-Unmodified-Since", valid_564816
  var valid_564817 = header.getOrDefault("client-request-id")
  valid_564817 = validateParameter(valid_564817, JString, required = false,
                                 default = nil)
  if valid_564817 != nil:
    section.add "client-request-id", valid_564817
  var valid_564818 = header.getOrDefault("If-Modified-Since")
  valid_564818 = validateParameter(valid_564818, JString, required = false,
                                 default = nil)
  if valid_564818 != nil:
    section.add "If-Modified-Since", valid_564818
  var valid_564819 = header.getOrDefault("If-None-Match")
  valid_564819 = validateParameter(valid_564819, JString, required = false,
                                 default = nil)
  if valid_564819 != nil:
    section.add "If-None-Match", valid_564819
  var valid_564820 = header.getOrDefault("ocp-date")
  valid_564820 = validateParameter(valid_564820, JString, required = false,
                                 default = nil)
  if valid_564820 != nil:
    section.add "ocp-date", valid_564820
  var valid_564821 = header.getOrDefault("If-Match")
  valid_564821 = validateParameter(valid_564821, JString, required = false,
                                 default = nil)
  if valid_564821 != nil:
    section.add "If-Match", valid_564821
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564822: Call_JobScheduleTerminate_564809; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564822.validator(path, query, header, formData, body)
  let scheme = call_564822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564822.url(scheme.get, call_564822.host, call_564822.base,
                         call_564822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564822, url, valid)

proc call*(call_564823: Call_JobScheduleTerminate_564809; apiVersion: string;
          jobScheduleId: string; timeout: int = 30): Recallable =
  ## jobScheduleTerminate
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobScheduleId: string (required)
  ##                : The ID of the job schedule to terminates.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564824 = newJObject()
  var query_564825 = newJObject()
  add(query_564825, "api-version", newJString(apiVersion))
  add(path_564824, "jobScheduleId", newJString(jobScheduleId))
  add(query_564825, "timeout", newJInt(timeout))
  result = call_564823.call(path_564824, query_564825, nil, nil, nil)

var jobScheduleTerminate* = Call_JobScheduleTerminate_564809(
    name: "jobScheduleTerminate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/terminate",
    validator: validate_JobScheduleTerminate_564810, base: "",
    url: url_JobScheduleTerminate_564811, schemes: {Scheme.Https})
type
  Call_JobGetAllLifetimeStatistics_564826 = ref object of OpenApiRestCall_563565
proc url_JobGetAllLifetimeStatistics_564828(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobGetAllLifetimeStatistics_564827(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Statistics are aggregated across all jobs that have ever existed in the account, from account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564829 = query.getOrDefault("api-version")
  valid_564829 = validateParameter(valid_564829, JString, required = true,
                                 default = nil)
  if valid_564829 != nil:
    section.add "api-version", valid_564829
  var valid_564830 = query.getOrDefault("timeout")
  valid_564830 = validateParameter(valid_564830, JInt, required = false,
                                 default = newJInt(30))
  if valid_564830 != nil:
    section.add "timeout", valid_564830
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564831 = header.getOrDefault("return-client-request-id")
  valid_564831 = validateParameter(valid_564831, JBool, required = false,
                                 default = newJBool(false))
  if valid_564831 != nil:
    section.add "return-client-request-id", valid_564831
  var valid_564832 = header.getOrDefault("client-request-id")
  valid_564832 = validateParameter(valid_564832, JString, required = false,
                                 default = nil)
  if valid_564832 != nil:
    section.add "client-request-id", valid_564832
  var valid_564833 = header.getOrDefault("ocp-date")
  valid_564833 = validateParameter(valid_564833, JString, required = false,
                                 default = nil)
  if valid_564833 != nil:
    section.add "ocp-date", valid_564833
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564834: Call_JobGetAllLifetimeStatistics_564826; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Statistics are aggregated across all jobs that have ever existed in the account, from account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ## 
  let valid = call_564834.validator(path, query, header, formData, body)
  let scheme = call_564834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564834.url(scheme.get, call_564834.host, call_564834.base,
                         call_564834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564834, url, valid)

proc call*(call_564835: Call_JobGetAllLifetimeStatistics_564826;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobGetAllLifetimeStatistics
  ## Statistics are aggregated across all jobs that have ever existed in the account, from account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var query_564836 = newJObject()
  add(query_564836, "api-version", newJString(apiVersion))
  add(query_564836, "timeout", newJInt(timeout))
  result = call_564835.call(nil, query_564836, nil, nil, nil)

var jobGetAllLifetimeStatistics* = Call_JobGetAllLifetimeStatistics_564826(
    name: "jobGetAllLifetimeStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/lifetimejobstats",
    validator: validate_JobGetAllLifetimeStatistics_564827, base: "",
    url: url_JobGetAllLifetimeStatistics_564828, schemes: {Scheme.Https})
type
  Call_PoolGetAllLifetimeStatistics_564837 = ref object of OpenApiRestCall_563565
proc url_PoolGetAllLifetimeStatistics_564839(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolGetAllLifetimeStatistics_564838(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Statistics are aggregated across all pools that have ever existed in the account, from account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564840 = query.getOrDefault("api-version")
  valid_564840 = validateParameter(valid_564840, JString, required = true,
                                 default = nil)
  if valid_564840 != nil:
    section.add "api-version", valid_564840
  var valid_564841 = query.getOrDefault("timeout")
  valid_564841 = validateParameter(valid_564841, JInt, required = false,
                                 default = newJInt(30))
  if valid_564841 != nil:
    section.add "timeout", valid_564841
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564842 = header.getOrDefault("return-client-request-id")
  valid_564842 = validateParameter(valid_564842, JBool, required = false,
                                 default = newJBool(false))
  if valid_564842 != nil:
    section.add "return-client-request-id", valid_564842
  var valid_564843 = header.getOrDefault("client-request-id")
  valid_564843 = validateParameter(valid_564843, JString, required = false,
                                 default = nil)
  if valid_564843 != nil:
    section.add "client-request-id", valid_564843
  var valid_564844 = header.getOrDefault("ocp-date")
  valid_564844 = validateParameter(valid_564844, JString, required = false,
                                 default = nil)
  if valid_564844 != nil:
    section.add "ocp-date", valid_564844
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564845: Call_PoolGetAllLifetimeStatistics_564837; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Statistics are aggregated across all pools that have ever existed in the account, from account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ## 
  let valid = call_564845.validator(path, query, header, formData, body)
  let scheme = call_564845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564845.url(scheme.get, call_564845.host, call_564845.base,
                         call_564845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564845, url, valid)

proc call*(call_564846: Call_PoolGetAllLifetimeStatistics_564837;
          apiVersion: string; timeout: int = 30): Recallable =
  ## poolGetAllLifetimeStatistics
  ## Statistics are aggregated across all pools that have ever existed in the account, from account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var query_564847 = newJObject()
  add(query_564847, "api-version", newJString(apiVersion))
  add(query_564847, "timeout", newJInt(timeout))
  result = call_564846.call(nil, query_564847, nil, nil, nil)

var poolGetAllLifetimeStatistics* = Call_PoolGetAllLifetimeStatistics_564837(
    name: "poolGetAllLifetimeStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/lifetimepoolstats",
    validator: validate_PoolGetAllLifetimeStatistics_564838, base: "",
    url: url_PoolGetAllLifetimeStatistics_564839, schemes: {Scheme.Https})
type
  Call_AccountListNodeAgentSkus_564848 = ref object of OpenApiRestCall_563565
proc url_AccountListNodeAgentSkus_564850(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccountListNodeAgentSkus_564849(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 results will be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-node-agent-skus.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564851 = query.getOrDefault("api-version")
  valid_564851 = validateParameter(valid_564851, JString, required = true,
                                 default = nil)
  if valid_564851 != nil:
    section.add "api-version", valid_564851
  var valid_564852 = query.getOrDefault("timeout")
  valid_564852 = validateParameter(valid_564852, JInt, required = false,
                                 default = newJInt(30))
  if valid_564852 != nil:
    section.add "timeout", valid_564852
  var valid_564853 = query.getOrDefault("maxresults")
  valid_564853 = validateParameter(valid_564853, JInt, required = false,
                                 default = newJInt(1000))
  if valid_564853 != nil:
    section.add "maxresults", valid_564853
  var valid_564854 = query.getOrDefault("$filter")
  valid_564854 = validateParameter(valid_564854, JString, required = false,
                                 default = nil)
  if valid_564854 != nil:
    section.add "$filter", valid_564854
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564855 = header.getOrDefault("return-client-request-id")
  valid_564855 = validateParameter(valid_564855, JBool, required = false,
                                 default = newJBool(false))
  if valid_564855 != nil:
    section.add "return-client-request-id", valid_564855
  var valid_564856 = header.getOrDefault("client-request-id")
  valid_564856 = validateParameter(valid_564856, JString, required = false,
                                 default = nil)
  if valid_564856 != nil:
    section.add "client-request-id", valid_564856
  var valid_564857 = header.getOrDefault("ocp-date")
  valid_564857 = validateParameter(valid_564857, JString, required = false,
                                 default = nil)
  if valid_564857 != nil:
    section.add "ocp-date", valid_564857
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564858: Call_AccountListNodeAgentSkus_564848; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564858.validator(path, query, header, formData, body)
  let scheme = call_564858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564858.url(scheme.get, call_564858.host, call_564858.base,
                         call_564858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564858, url, valid)

proc call*(call_564859: Call_AccountListNodeAgentSkus_564848; apiVersion: string;
          timeout: int = 30; maxresults: int = 1000; Filter: string = ""): Recallable =
  ## accountListNodeAgentSkus
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 results will be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-node-agent-skus.
  var query_564860 = newJObject()
  add(query_564860, "api-version", newJString(apiVersion))
  add(query_564860, "timeout", newJInt(timeout))
  add(query_564860, "maxresults", newJInt(maxresults))
  add(query_564860, "$filter", newJString(Filter))
  result = call_564859.call(nil, query_564860, nil, nil, nil)

var accountListNodeAgentSkus* = Call_AccountListNodeAgentSkus_564848(
    name: "accountListNodeAgentSkus", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/nodeagentskus", validator: validate_AccountListNodeAgentSkus_564849,
    base: "", url: url_AccountListNodeAgentSkus_564850, schemes: {Scheme.Https})
type
  Call_AccountListPoolNodeCounts_564861 = ref object of OpenApiRestCall_563565
proc url_AccountListPoolNodeCounts_564863(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccountListPoolNodeCounts_564862(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the number of nodes in each state, grouped by pool.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564864 = query.getOrDefault("api-version")
  valid_564864 = validateParameter(valid_564864, JString, required = true,
                                 default = nil)
  if valid_564864 != nil:
    section.add "api-version", valid_564864
  var valid_564865 = query.getOrDefault("timeout")
  valid_564865 = validateParameter(valid_564865, JInt, required = false,
                                 default = newJInt(30))
  if valid_564865 != nil:
    section.add "timeout", valid_564865
  var valid_564866 = query.getOrDefault("maxresults")
  valid_564866 = validateParameter(valid_564866, JInt, required = false,
                                 default = newJInt(10))
  if valid_564866 != nil:
    section.add "maxresults", valid_564866
  var valid_564867 = query.getOrDefault("$filter")
  valid_564867 = validateParameter(valid_564867, JString, required = false,
                                 default = nil)
  if valid_564867 != nil:
    section.add "$filter", valid_564867
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564868 = header.getOrDefault("return-client-request-id")
  valid_564868 = validateParameter(valid_564868, JBool, required = false,
                                 default = newJBool(false))
  if valid_564868 != nil:
    section.add "return-client-request-id", valid_564868
  var valid_564869 = header.getOrDefault("client-request-id")
  valid_564869 = validateParameter(valid_564869, JString, required = false,
                                 default = nil)
  if valid_564869 != nil:
    section.add "client-request-id", valid_564869
  var valid_564870 = header.getOrDefault("ocp-date")
  valid_564870 = validateParameter(valid_564870, JString, required = false,
                                 default = nil)
  if valid_564870 != nil:
    section.add "ocp-date", valid_564870
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564871: Call_AccountListPoolNodeCounts_564861; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the number of nodes in each state, grouped by pool.
  ## 
  let valid = call_564871.validator(path, query, header, formData, body)
  let scheme = call_564871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564871.url(scheme.get, call_564871.host, call_564871.base,
                         call_564871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564871, url, valid)

proc call*(call_564872: Call_AccountListPoolNodeCounts_564861; apiVersion: string;
          timeout: int = 30; maxresults: int = 10; Filter: string = ""): Recallable =
  ## accountListPoolNodeCounts
  ## Gets the number of nodes in each state, grouped by pool.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch.
  var query_564873 = newJObject()
  add(query_564873, "api-version", newJString(apiVersion))
  add(query_564873, "timeout", newJInt(timeout))
  add(query_564873, "maxresults", newJInt(maxresults))
  add(query_564873, "$filter", newJString(Filter))
  result = call_564872.call(nil, query_564873, nil, nil, nil)

var accountListPoolNodeCounts* = Call_AccountListPoolNodeCounts_564861(
    name: "accountListPoolNodeCounts", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/nodecounts",
    validator: validate_AccountListPoolNodeCounts_564862, base: "",
    url: url_AccountListPoolNodeCounts_564863, schemes: {Scheme.Https})
type
  Call_PoolAdd_564889 = ref object of OpenApiRestCall_563565
proc url_PoolAdd_564891(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolAdd_564890(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## When naming pools, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564892 = query.getOrDefault("api-version")
  valid_564892 = validateParameter(valid_564892, JString, required = true,
                                 default = nil)
  if valid_564892 != nil:
    section.add "api-version", valid_564892
  var valid_564893 = query.getOrDefault("timeout")
  valid_564893 = validateParameter(valid_564893, JInt, required = false,
                                 default = newJInt(30))
  if valid_564893 != nil:
    section.add "timeout", valid_564893
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564894 = header.getOrDefault("return-client-request-id")
  valid_564894 = validateParameter(valid_564894, JBool, required = false,
                                 default = newJBool(false))
  if valid_564894 != nil:
    section.add "return-client-request-id", valid_564894
  var valid_564895 = header.getOrDefault("client-request-id")
  valid_564895 = validateParameter(valid_564895, JString, required = false,
                                 default = nil)
  if valid_564895 != nil:
    section.add "client-request-id", valid_564895
  var valid_564896 = header.getOrDefault("ocp-date")
  valid_564896 = validateParameter(valid_564896, JString, required = false,
                                 default = nil)
  if valid_564896 != nil:
    section.add "ocp-date", valid_564896
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

proc call*(call_564898: Call_PoolAdd_564889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When naming pools, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ## 
  let valid = call_564898.validator(path, query, header, formData, body)
  let scheme = call_564898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564898.url(scheme.get, call_564898.host, call_564898.base,
                         call_564898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564898, url, valid)

proc call*(call_564899: Call_PoolAdd_564889; apiVersion: string; pool: JsonNode;
          timeout: int = 30): Recallable =
  ## poolAdd
  ## When naming pools, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   pool: JObject (required)
  ##       : The pool to be added.
  var query_564900 = newJObject()
  var body_564901 = newJObject()
  add(query_564900, "api-version", newJString(apiVersion))
  add(query_564900, "timeout", newJInt(timeout))
  if pool != nil:
    body_564901 = pool
  result = call_564899.call(nil, query_564900, nil, nil, body_564901)

var poolAdd* = Call_PoolAdd_564889(name: "poolAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/pools",
                                validator: validate_PoolAdd_564890, base: "",
                                url: url_PoolAdd_564891, schemes: {Scheme.Https})
type
  Call_PoolList_564874 = ref object of OpenApiRestCall_563565
proc url_PoolList_564876(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolList_564875(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 pools can be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-pools.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564877 = query.getOrDefault("api-version")
  valid_564877 = validateParameter(valid_564877, JString, required = true,
                                 default = nil)
  if valid_564877 != nil:
    section.add "api-version", valid_564877
  var valid_564878 = query.getOrDefault("$select")
  valid_564878 = validateParameter(valid_564878, JString, required = false,
                                 default = nil)
  if valid_564878 != nil:
    section.add "$select", valid_564878
  var valid_564879 = query.getOrDefault("$expand")
  valid_564879 = validateParameter(valid_564879, JString, required = false,
                                 default = nil)
  if valid_564879 != nil:
    section.add "$expand", valid_564879
  var valid_564880 = query.getOrDefault("timeout")
  valid_564880 = validateParameter(valid_564880, JInt, required = false,
                                 default = newJInt(30))
  if valid_564880 != nil:
    section.add "timeout", valid_564880
  var valid_564881 = query.getOrDefault("maxresults")
  valid_564881 = validateParameter(valid_564881, JInt, required = false,
                                 default = newJInt(1000))
  if valid_564881 != nil:
    section.add "maxresults", valid_564881
  var valid_564882 = query.getOrDefault("$filter")
  valid_564882 = validateParameter(valid_564882, JString, required = false,
                                 default = nil)
  if valid_564882 != nil:
    section.add "$filter", valid_564882
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564883 = header.getOrDefault("return-client-request-id")
  valid_564883 = validateParameter(valid_564883, JBool, required = false,
                                 default = newJBool(false))
  if valid_564883 != nil:
    section.add "return-client-request-id", valid_564883
  var valid_564884 = header.getOrDefault("client-request-id")
  valid_564884 = validateParameter(valid_564884, JString, required = false,
                                 default = nil)
  if valid_564884 != nil:
    section.add "client-request-id", valid_564884
  var valid_564885 = header.getOrDefault("ocp-date")
  valid_564885 = validateParameter(valid_564885, JString, required = false,
                                 default = nil)
  if valid_564885 != nil:
    section.add "ocp-date", valid_564885
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564886: Call_PoolList_564874; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564886.validator(path, query, header, formData, body)
  let scheme = call_564886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564886.url(scheme.get, call_564886.host, call_564886.base,
                         call_564886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564886, url, valid)

proc call*(call_564887: Call_PoolList_564874; apiVersion: string;
          Select: string = ""; Expand: string = ""; timeout: int = 30;
          maxresults: int = 1000; Filter: string = ""): Recallable =
  ## poolList
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 pools can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-pools.
  var query_564888 = newJObject()
  add(query_564888, "api-version", newJString(apiVersion))
  add(query_564888, "$select", newJString(Select))
  add(query_564888, "$expand", newJString(Expand))
  add(query_564888, "timeout", newJInt(timeout))
  add(query_564888, "maxresults", newJInt(maxresults))
  add(query_564888, "$filter", newJString(Filter))
  result = call_564887.call(nil, query_564888, nil, nil, nil)

var poolList* = Call_PoolList_564874(name: "poolList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/pools",
                                  validator: validate_PoolList_564875, base: "",
                                  url: url_PoolList_564876,
                                  schemes: {Scheme.Https})
type
  Call_PoolExists_564938 = ref object of OpenApiRestCall_563565
proc url_PoolExists_564940(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolExists_564939(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564941 = path.getOrDefault("poolId")
  valid_564941 = validateParameter(valid_564941, JString, required = true,
                                 default = nil)
  if valid_564941 != nil:
    section.add "poolId", valid_564941
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564942 = query.getOrDefault("api-version")
  valid_564942 = validateParameter(valid_564942, JString, required = true,
                                 default = nil)
  if valid_564942 != nil:
    section.add "api-version", valid_564942
  var valid_564943 = query.getOrDefault("timeout")
  valid_564943 = validateParameter(valid_564943, JInt, required = false,
                                 default = newJInt(30))
  if valid_564943 != nil:
    section.add "timeout", valid_564943
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564944 = header.getOrDefault("return-client-request-id")
  valid_564944 = validateParameter(valid_564944, JBool, required = false,
                                 default = newJBool(false))
  if valid_564944 != nil:
    section.add "return-client-request-id", valid_564944
  var valid_564945 = header.getOrDefault("If-Unmodified-Since")
  valid_564945 = validateParameter(valid_564945, JString, required = false,
                                 default = nil)
  if valid_564945 != nil:
    section.add "If-Unmodified-Since", valid_564945
  var valid_564946 = header.getOrDefault("client-request-id")
  valid_564946 = validateParameter(valid_564946, JString, required = false,
                                 default = nil)
  if valid_564946 != nil:
    section.add "client-request-id", valid_564946
  var valid_564947 = header.getOrDefault("If-Modified-Since")
  valid_564947 = validateParameter(valid_564947, JString, required = false,
                                 default = nil)
  if valid_564947 != nil:
    section.add "If-Modified-Since", valid_564947
  var valid_564948 = header.getOrDefault("If-None-Match")
  valid_564948 = validateParameter(valid_564948, JString, required = false,
                                 default = nil)
  if valid_564948 != nil:
    section.add "If-None-Match", valid_564948
  var valid_564949 = header.getOrDefault("ocp-date")
  valid_564949 = validateParameter(valid_564949, JString, required = false,
                                 default = nil)
  if valid_564949 != nil:
    section.add "ocp-date", valid_564949
  var valid_564950 = header.getOrDefault("If-Match")
  valid_564950 = validateParameter(valid_564950, JString, required = false,
                                 default = nil)
  if valid_564950 != nil:
    section.add "If-Match", valid_564950
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564951: Call_PoolExists_564938; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets basic properties of a pool.
  ## 
  let valid = call_564951.validator(path, query, header, formData, body)
  let scheme = call_564951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564951.url(scheme.get, call_564951.host, call_564951.base,
                         call_564951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564951, url, valid)

proc call*(call_564952: Call_PoolExists_564938; apiVersion: string; poolId: string;
          timeout: int = 30): Recallable =
  ## poolExists
  ## Gets basic properties of a pool.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool to get.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564953 = newJObject()
  var query_564954 = newJObject()
  add(query_564954, "api-version", newJString(apiVersion))
  add(path_564953, "poolId", newJString(poolId))
  add(query_564954, "timeout", newJInt(timeout))
  result = call_564952.call(path_564953, query_564954, nil, nil, nil)

var poolExists* = Call_PoolExists_564938(name: "poolExists",
                                      meth: HttpMethod.HttpHead,
                                      host: "azure.local",
                                      route: "/pools/{poolId}",
                                      validator: validate_PoolExists_564939,
                                      base: "", url: url_PoolExists_564940,
                                      schemes: {Scheme.Https})
type
  Call_PoolGet_564902 = ref object of OpenApiRestCall_563565
proc url_PoolGet_564904(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolGet_564903(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564905 = path.getOrDefault("poolId")
  valid_564905 = validateParameter(valid_564905, JString, required = true,
                                 default = nil)
  if valid_564905 != nil:
    section.add "poolId", valid_564905
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   $expand: JString
  ##          : An OData $expand clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564906 = query.getOrDefault("api-version")
  valid_564906 = validateParameter(valid_564906, JString, required = true,
                                 default = nil)
  if valid_564906 != nil:
    section.add "api-version", valid_564906
  var valid_564907 = query.getOrDefault("$select")
  valid_564907 = validateParameter(valid_564907, JString, required = false,
                                 default = nil)
  if valid_564907 != nil:
    section.add "$select", valid_564907
  var valid_564908 = query.getOrDefault("$expand")
  valid_564908 = validateParameter(valid_564908, JString, required = false,
                                 default = nil)
  if valid_564908 != nil:
    section.add "$expand", valid_564908
  var valid_564909 = query.getOrDefault("timeout")
  valid_564909 = validateParameter(valid_564909, JInt, required = false,
                                 default = newJInt(30))
  if valid_564909 != nil:
    section.add "timeout", valid_564909
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564910 = header.getOrDefault("return-client-request-id")
  valid_564910 = validateParameter(valid_564910, JBool, required = false,
                                 default = newJBool(false))
  if valid_564910 != nil:
    section.add "return-client-request-id", valid_564910
  var valid_564911 = header.getOrDefault("If-Unmodified-Since")
  valid_564911 = validateParameter(valid_564911, JString, required = false,
                                 default = nil)
  if valid_564911 != nil:
    section.add "If-Unmodified-Since", valid_564911
  var valid_564912 = header.getOrDefault("client-request-id")
  valid_564912 = validateParameter(valid_564912, JString, required = false,
                                 default = nil)
  if valid_564912 != nil:
    section.add "client-request-id", valid_564912
  var valid_564913 = header.getOrDefault("If-Modified-Since")
  valid_564913 = validateParameter(valid_564913, JString, required = false,
                                 default = nil)
  if valid_564913 != nil:
    section.add "If-Modified-Since", valid_564913
  var valid_564914 = header.getOrDefault("If-None-Match")
  valid_564914 = validateParameter(valid_564914, JString, required = false,
                                 default = nil)
  if valid_564914 != nil:
    section.add "If-None-Match", valid_564914
  var valid_564915 = header.getOrDefault("ocp-date")
  valid_564915 = validateParameter(valid_564915, JString, required = false,
                                 default = nil)
  if valid_564915 != nil:
    section.add "ocp-date", valid_564915
  var valid_564916 = header.getOrDefault("If-Match")
  valid_564916 = validateParameter(valid_564916, JString, required = false,
                                 default = nil)
  if valid_564916 != nil:
    section.add "If-Match", valid_564916
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564917: Call_PoolGet_564902; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified pool.
  ## 
  let valid = call_564917.validator(path, query, header, formData, body)
  let scheme = call_564917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564917.url(scheme.get, call_564917.host, call_564917.base,
                         call_564917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564917, url, valid)

proc call*(call_564918: Call_PoolGet_564902; apiVersion: string; poolId: string;
          Select: string = ""; Expand: string = ""; timeout: int = 30): Recallable =
  ## poolGet
  ## Gets information about the specified pool.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool to get.
  ##   Select: string
  ##         : An OData $select clause.
  ##   Expand: string
  ##         : An OData $expand clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564919 = newJObject()
  var query_564920 = newJObject()
  add(query_564920, "api-version", newJString(apiVersion))
  add(path_564919, "poolId", newJString(poolId))
  add(query_564920, "$select", newJString(Select))
  add(query_564920, "$expand", newJString(Expand))
  add(query_564920, "timeout", newJInt(timeout))
  result = call_564918.call(path_564919, query_564920, nil, nil, nil)

var poolGet* = Call_PoolGet_564902(name: "poolGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/pools/{poolId}",
                                validator: validate_PoolGet_564903, base: "",
                                url: url_PoolGet_564904, schemes: {Scheme.Https})
type
  Call_PoolPatch_564955 = ref object of OpenApiRestCall_563565
proc url_PoolPatch_564957(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolPatch_564956(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564958 = path.getOrDefault("poolId")
  valid_564958 = validateParameter(valid_564958, JString, required = true,
                                 default = nil)
  if valid_564958 != nil:
    section.add "poolId", valid_564958
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564959 = query.getOrDefault("api-version")
  valid_564959 = validateParameter(valid_564959, JString, required = true,
                                 default = nil)
  if valid_564959 != nil:
    section.add "api-version", valid_564959
  var valid_564960 = query.getOrDefault("timeout")
  valid_564960 = validateParameter(valid_564960, JInt, required = false,
                                 default = newJInt(30))
  if valid_564960 != nil:
    section.add "timeout", valid_564960
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564961 = header.getOrDefault("return-client-request-id")
  valid_564961 = validateParameter(valid_564961, JBool, required = false,
                                 default = newJBool(false))
  if valid_564961 != nil:
    section.add "return-client-request-id", valid_564961
  var valid_564962 = header.getOrDefault("If-Unmodified-Since")
  valid_564962 = validateParameter(valid_564962, JString, required = false,
                                 default = nil)
  if valid_564962 != nil:
    section.add "If-Unmodified-Since", valid_564962
  var valid_564963 = header.getOrDefault("client-request-id")
  valid_564963 = validateParameter(valid_564963, JString, required = false,
                                 default = nil)
  if valid_564963 != nil:
    section.add "client-request-id", valid_564963
  var valid_564964 = header.getOrDefault("If-Modified-Since")
  valid_564964 = validateParameter(valid_564964, JString, required = false,
                                 default = nil)
  if valid_564964 != nil:
    section.add "If-Modified-Since", valid_564964
  var valid_564965 = header.getOrDefault("If-None-Match")
  valid_564965 = validateParameter(valid_564965, JString, required = false,
                                 default = nil)
  if valid_564965 != nil:
    section.add "If-None-Match", valid_564965
  var valid_564966 = header.getOrDefault("ocp-date")
  valid_564966 = validateParameter(valid_564966, JString, required = false,
                                 default = nil)
  if valid_564966 != nil:
    section.add "ocp-date", valid_564966
  var valid_564967 = header.getOrDefault("If-Match")
  valid_564967 = validateParameter(valid_564967, JString, required = false,
                                 default = nil)
  if valid_564967 != nil:
    section.add "If-Match", valid_564967
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

proc call*(call_564969: Call_PoolPatch_564955; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This only replaces the pool properties specified in the request. For example, if the pool has a start task associated with it, and a request does not specify a start task element, then the pool keeps the existing start task.
  ## 
  let valid = call_564969.validator(path, query, header, formData, body)
  let scheme = call_564969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564969.url(scheme.get, call_564969.host, call_564969.base,
                         call_564969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564969, url, valid)

proc call*(call_564970: Call_PoolPatch_564955; apiVersion: string;
          poolPatchParameter: JsonNode; poolId: string; timeout: int = 30): Recallable =
  ## poolPatch
  ## This only replaces the pool properties specified in the request. For example, if the pool has a start task associated with it, and a request does not specify a start task element, then the pool keeps the existing start task.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolPatchParameter: JObject (required)
  ##                     : The parameters for the request.
  ##   poolId: string (required)
  ##         : The ID of the pool to update.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564971 = newJObject()
  var query_564972 = newJObject()
  var body_564973 = newJObject()
  add(query_564972, "api-version", newJString(apiVersion))
  if poolPatchParameter != nil:
    body_564973 = poolPatchParameter
  add(path_564971, "poolId", newJString(poolId))
  add(query_564972, "timeout", newJInt(timeout))
  result = call_564970.call(path_564971, query_564972, nil, nil, body_564973)

var poolPatch* = Call_PoolPatch_564955(name: "poolPatch", meth: HttpMethod.HttpPatch,
                                    host: "azure.local", route: "/pools/{poolId}",
                                    validator: validate_PoolPatch_564956,
                                    base: "", url: url_PoolPatch_564957,
                                    schemes: {Scheme.Https})
type
  Call_PoolDelete_564921 = ref object of OpenApiRestCall_563565
proc url_PoolDelete_564923(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolDelete_564922(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564924 = path.getOrDefault("poolId")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "poolId", valid_564924
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564925 = query.getOrDefault("api-version")
  valid_564925 = validateParameter(valid_564925, JString, required = true,
                                 default = nil)
  if valid_564925 != nil:
    section.add "api-version", valid_564925
  var valid_564926 = query.getOrDefault("timeout")
  valid_564926 = validateParameter(valid_564926, JInt, required = false,
                                 default = newJInt(30))
  if valid_564926 != nil:
    section.add "timeout", valid_564926
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564927 = header.getOrDefault("return-client-request-id")
  valid_564927 = validateParameter(valid_564927, JBool, required = false,
                                 default = newJBool(false))
  if valid_564927 != nil:
    section.add "return-client-request-id", valid_564927
  var valid_564928 = header.getOrDefault("If-Unmodified-Since")
  valid_564928 = validateParameter(valid_564928, JString, required = false,
                                 default = nil)
  if valid_564928 != nil:
    section.add "If-Unmodified-Since", valid_564928
  var valid_564929 = header.getOrDefault("client-request-id")
  valid_564929 = validateParameter(valid_564929, JString, required = false,
                                 default = nil)
  if valid_564929 != nil:
    section.add "client-request-id", valid_564929
  var valid_564930 = header.getOrDefault("If-Modified-Since")
  valid_564930 = validateParameter(valid_564930, JString, required = false,
                                 default = nil)
  if valid_564930 != nil:
    section.add "If-Modified-Since", valid_564930
  var valid_564931 = header.getOrDefault("If-None-Match")
  valid_564931 = validateParameter(valid_564931, JString, required = false,
                                 default = nil)
  if valid_564931 != nil:
    section.add "If-None-Match", valid_564931
  var valid_564932 = header.getOrDefault("ocp-date")
  valid_564932 = validateParameter(valid_564932, JString, required = false,
                                 default = nil)
  if valid_564932 != nil:
    section.add "ocp-date", valid_564932
  var valid_564933 = header.getOrDefault("If-Match")
  valid_564933 = validateParameter(valid_564933, JString, required = false,
                                 default = nil)
  if valid_564933 != nil:
    section.add "If-Match", valid_564933
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564934: Call_PoolDelete_564921; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you request that a pool be deleted, the following actions occur: the pool state is set to deleting; any ongoing resize operation on the pool are stopped; the Batch service starts resizing the pool to zero nodes; any tasks running on existing nodes are terminated and requeued (as if a resize pool operation had been requested with the default requeue option); finally, the pool is removed from the system. Because running tasks are requeued, the user can rerun these tasks by updating their job to target a different pool. The tasks can then run on the new pool. If you want to override the requeue behavior, then you should call resize pool explicitly to shrink the pool to zero size before deleting the pool. If you call an Update, Patch or Delete API on a pool in the deleting state, it will fail with HTTP status code 409 with error code PoolBeingDeleted.
  ## 
  let valid = call_564934.validator(path, query, header, formData, body)
  let scheme = call_564934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564934.url(scheme.get, call_564934.host, call_564934.base,
                         call_564934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564934, url, valid)

proc call*(call_564935: Call_PoolDelete_564921; apiVersion: string; poolId: string;
          timeout: int = 30): Recallable =
  ## poolDelete
  ## When you request that a pool be deleted, the following actions occur: the pool state is set to deleting; any ongoing resize operation on the pool are stopped; the Batch service starts resizing the pool to zero nodes; any tasks running on existing nodes are terminated and requeued (as if a resize pool operation had been requested with the default requeue option); finally, the pool is removed from the system. Because running tasks are requeued, the user can rerun these tasks by updating their job to target a different pool. The tasks can then run on the new pool. If you want to override the requeue behavior, then you should call resize pool explicitly to shrink the pool to zero size before deleting the pool. If you call an Update, Patch or Delete API on a pool in the deleting state, it will fail with HTTP status code 409 with error code PoolBeingDeleted.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool to delete.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564936 = newJObject()
  var query_564937 = newJObject()
  add(query_564937, "api-version", newJString(apiVersion))
  add(path_564936, "poolId", newJString(poolId))
  add(query_564937, "timeout", newJInt(timeout))
  result = call_564935.call(path_564936, query_564937, nil, nil, nil)

var poolDelete* = Call_PoolDelete_564921(name: "poolDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/pools/{poolId}",
                                      validator: validate_PoolDelete_564922,
                                      base: "", url: url_PoolDelete_564923,
                                      schemes: {Scheme.Https})
type
  Call_PoolDisableAutoScale_564974 = ref object of OpenApiRestCall_563565
proc url_PoolDisableAutoScale_564976(protocol: Scheme; host: string; base: string;
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

proc validate_PoolDisableAutoScale_564975(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool on which to disable automatic scaling.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_564977 = path.getOrDefault("poolId")
  valid_564977 = validateParameter(valid_564977, JString, required = true,
                                 default = nil)
  if valid_564977 != nil:
    section.add "poolId", valid_564977
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564978 = query.getOrDefault("api-version")
  valid_564978 = validateParameter(valid_564978, JString, required = true,
                                 default = nil)
  if valid_564978 != nil:
    section.add "api-version", valid_564978
  var valid_564979 = query.getOrDefault("timeout")
  valid_564979 = validateParameter(valid_564979, JInt, required = false,
                                 default = newJInt(30))
  if valid_564979 != nil:
    section.add "timeout", valid_564979
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_564980 = header.getOrDefault("return-client-request-id")
  valid_564980 = validateParameter(valid_564980, JBool, required = false,
                                 default = newJBool(false))
  if valid_564980 != nil:
    section.add "return-client-request-id", valid_564980
  var valid_564981 = header.getOrDefault("client-request-id")
  valid_564981 = validateParameter(valid_564981, JString, required = false,
                                 default = nil)
  if valid_564981 != nil:
    section.add "client-request-id", valid_564981
  var valid_564982 = header.getOrDefault("ocp-date")
  valid_564982 = validateParameter(valid_564982, JString, required = false,
                                 default = nil)
  if valid_564982 != nil:
    section.add "ocp-date", valid_564982
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564983: Call_PoolDisableAutoScale_564974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564983.validator(path, query, header, formData, body)
  let scheme = call_564983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564983.url(scheme.get, call_564983.host, call_564983.base,
                         call_564983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564983, url, valid)

proc call*(call_564984: Call_PoolDisableAutoScale_564974; apiVersion: string;
          poolId: string; timeout: int = 30): Recallable =
  ## poolDisableAutoScale
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool on which to disable automatic scaling.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_564985 = newJObject()
  var query_564986 = newJObject()
  add(query_564986, "api-version", newJString(apiVersion))
  add(path_564985, "poolId", newJString(poolId))
  add(query_564986, "timeout", newJInt(timeout))
  result = call_564984.call(path_564985, query_564986, nil, nil, nil)

var poolDisableAutoScale* = Call_PoolDisableAutoScale_564974(
    name: "poolDisableAutoScale", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/disableautoscale",
    validator: validate_PoolDisableAutoScale_564975, base: "",
    url: url_PoolDisableAutoScale_564976, schemes: {Scheme.Https})
type
  Call_PoolEnableAutoScale_564987 = ref object of OpenApiRestCall_563565
proc url_PoolEnableAutoScale_564989(protocol: Scheme; host: string; base: string;
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

proc validate_PoolEnableAutoScale_564988(path: JsonNode; query: JsonNode;
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
  var valid_564990 = path.getOrDefault("poolId")
  valid_564990 = validateParameter(valid_564990, JString, required = true,
                                 default = nil)
  if valid_564990 != nil:
    section.add "poolId", valid_564990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564991 = query.getOrDefault("api-version")
  valid_564991 = validateParameter(valid_564991, JString, required = true,
                                 default = nil)
  if valid_564991 != nil:
    section.add "api-version", valid_564991
  var valid_564992 = query.getOrDefault("timeout")
  valid_564992 = validateParameter(valid_564992, JInt, required = false,
                                 default = newJInt(30))
  if valid_564992 != nil:
    section.add "timeout", valid_564992
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_564993 = header.getOrDefault("return-client-request-id")
  valid_564993 = validateParameter(valid_564993, JBool, required = false,
                                 default = newJBool(false))
  if valid_564993 != nil:
    section.add "return-client-request-id", valid_564993
  var valid_564994 = header.getOrDefault("If-Unmodified-Since")
  valid_564994 = validateParameter(valid_564994, JString, required = false,
                                 default = nil)
  if valid_564994 != nil:
    section.add "If-Unmodified-Since", valid_564994
  var valid_564995 = header.getOrDefault("client-request-id")
  valid_564995 = validateParameter(valid_564995, JString, required = false,
                                 default = nil)
  if valid_564995 != nil:
    section.add "client-request-id", valid_564995
  var valid_564996 = header.getOrDefault("If-Modified-Since")
  valid_564996 = validateParameter(valid_564996, JString, required = false,
                                 default = nil)
  if valid_564996 != nil:
    section.add "If-Modified-Since", valid_564996
  var valid_564997 = header.getOrDefault("If-None-Match")
  valid_564997 = validateParameter(valid_564997, JString, required = false,
                                 default = nil)
  if valid_564997 != nil:
    section.add "If-None-Match", valid_564997
  var valid_564998 = header.getOrDefault("ocp-date")
  valid_564998 = validateParameter(valid_564998, JString, required = false,
                                 default = nil)
  if valid_564998 != nil:
    section.add "ocp-date", valid_564998
  var valid_564999 = header.getOrDefault("If-Match")
  valid_564999 = validateParameter(valid_564999, JString, required = false,
                                 default = nil)
  if valid_564999 != nil:
    section.add "If-Match", valid_564999
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

proc call*(call_565001: Call_PoolEnableAutoScale_564987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You cannot enable automatic scaling on a pool if a resize operation is in progress on the pool. If automatic scaling of the pool is currently disabled, you must specify a valid autoscale formula as part of the request. If automatic scaling of the pool is already enabled, you may specify a new autoscale formula and/or a new evaluation interval. You cannot call this API for the same pool more than once every 30 seconds.
  ## 
  let valid = call_565001.validator(path, query, header, formData, body)
  let scheme = call_565001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565001.url(scheme.get, call_565001.host, call_565001.base,
                         call_565001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565001, url, valid)

proc call*(call_565002: Call_PoolEnableAutoScale_564987; apiVersion: string;
          poolId: string; poolEnableAutoScaleParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolEnableAutoScale
  ## You cannot enable automatic scaling on a pool if a resize operation is in progress on the pool. If automatic scaling of the pool is currently disabled, you must specify a valid autoscale formula as part of the request. If automatic scaling of the pool is already enabled, you may specify a new autoscale formula and/or a new evaluation interval. You cannot call this API for the same pool more than once every 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool on which to enable automatic scaling.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   poolEnableAutoScaleParameter: JObject (required)
  ##                               : The parameters for the request.
  var path_565003 = newJObject()
  var query_565004 = newJObject()
  var body_565005 = newJObject()
  add(query_565004, "api-version", newJString(apiVersion))
  add(path_565003, "poolId", newJString(poolId))
  add(query_565004, "timeout", newJInt(timeout))
  if poolEnableAutoScaleParameter != nil:
    body_565005 = poolEnableAutoScaleParameter
  result = call_565002.call(path_565003, query_565004, nil, nil, body_565005)

var poolEnableAutoScale* = Call_PoolEnableAutoScale_564987(
    name: "poolEnableAutoScale", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/enableautoscale",
    validator: validate_PoolEnableAutoScale_564988, base: "",
    url: url_PoolEnableAutoScale_564989, schemes: {Scheme.Https})
type
  Call_PoolEvaluateAutoScale_565006 = ref object of OpenApiRestCall_563565
proc url_PoolEvaluateAutoScale_565008(protocol: Scheme; host: string; base: string;
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

proc validate_PoolEvaluateAutoScale_565007(path: JsonNode; query: JsonNode;
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
  var valid_565009 = path.getOrDefault("poolId")
  valid_565009 = validateParameter(valid_565009, JString, required = true,
                                 default = nil)
  if valid_565009 != nil:
    section.add "poolId", valid_565009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565010 = query.getOrDefault("api-version")
  valid_565010 = validateParameter(valid_565010, JString, required = true,
                                 default = nil)
  if valid_565010 != nil:
    section.add "api-version", valid_565010
  var valid_565011 = query.getOrDefault("timeout")
  valid_565011 = validateParameter(valid_565011, JInt, required = false,
                                 default = newJInt(30))
  if valid_565011 != nil:
    section.add "timeout", valid_565011
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565012 = header.getOrDefault("return-client-request-id")
  valid_565012 = validateParameter(valid_565012, JBool, required = false,
                                 default = newJBool(false))
  if valid_565012 != nil:
    section.add "return-client-request-id", valid_565012
  var valid_565013 = header.getOrDefault("client-request-id")
  valid_565013 = validateParameter(valid_565013, JString, required = false,
                                 default = nil)
  if valid_565013 != nil:
    section.add "client-request-id", valid_565013
  var valid_565014 = header.getOrDefault("ocp-date")
  valid_565014 = validateParameter(valid_565014, JString, required = false,
                                 default = nil)
  if valid_565014 != nil:
    section.add "ocp-date", valid_565014
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

proc call*(call_565016: Call_PoolEvaluateAutoScale_565006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API is primarily for validating an autoscale formula, as it simply returns the result without applying the formula to the pool. The pool must have auto scaling enabled in order to evaluate a formula.
  ## 
  let valid = call_565016.validator(path, query, header, formData, body)
  let scheme = call_565016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565016.url(scheme.get, call_565016.host, call_565016.base,
                         call_565016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565016, url, valid)

proc call*(call_565017: Call_PoolEvaluateAutoScale_565006;
          poolEvaluateAutoScaleParameter: JsonNode; apiVersion: string;
          poolId: string; timeout: int = 30): Recallable =
  ## poolEvaluateAutoScale
  ## This API is primarily for validating an autoscale formula, as it simply returns the result without applying the formula to the pool. The pool must have auto scaling enabled in order to evaluate a formula.
  ##   poolEvaluateAutoScaleParameter: JObject (required)
  ##                                 : The parameters for the request.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool on which to evaluate the automatic scaling formula.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_565018 = newJObject()
  var query_565019 = newJObject()
  var body_565020 = newJObject()
  if poolEvaluateAutoScaleParameter != nil:
    body_565020 = poolEvaluateAutoScaleParameter
  add(query_565019, "api-version", newJString(apiVersion))
  add(path_565018, "poolId", newJString(poolId))
  add(query_565019, "timeout", newJInt(timeout))
  result = call_565017.call(path_565018, query_565019, nil, nil, body_565020)

var poolEvaluateAutoScale* = Call_PoolEvaluateAutoScale_565006(
    name: "poolEvaluateAutoScale", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/evaluateautoscale",
    validator: validate_PoolEvaluateAutoScale_565007, base: "",
    url: url_PoolEvaluateAutoScale_565008, schemes: {Scheme.Https})
type
  Call_ComputeNodeList_565021 = ref object of OpenApiRestCall_563565
proc url_ComputeNodeList_565023(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeList_565022(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool from which you want to list nodes.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_565024 = path.getOrDefault("poolId")
  valid_565024 = validateParameter(valid_565024, JString, required = true,
                                 default = nil)
  if valid_565024 != nil:
    section.add "poolId", valid_565024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 nodes can be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-nodes-in-a-pool.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565025 = query.getOrDefault("api-version")
  valid_565025 = validateParameter(valid_565025, JString, required = true,
                                 default = nil)
  if valid_565025 != nil:
    section.add "api-version", valid_565025
  var valid_565026 = query.getOrDefault("$select")
  valid_565026 = validateParameter(valid_565026, JString, required = false,
                                 default = nil)
  if valid_565026 != nil:
    section.add "$select", valid_565026
  var valid_565027 = query.getOrDefault("timeout")
  valid_565027 = validateParameter(valid_565027, JInt, required = false,
                                 default = newJInt(30))
  if valid_565027 != nil:
    section.add "timeout", valid_565027
  var valid_565028 = query.getOrDefault("maxresults")
  valid_565028 = validateParameter(valid_565028, JInt, required = false,
                                 default = newJInt(1000))
  if valid_565028 != nil:
    section.add "maxresults", valid_565028
  var valid_565029 = query.getOrDefault("$filter")
  valid_565029 = validateParameter(valid_565029, JString, required = false,
                                 default = nil)
  if valid_565029 != nil:
    section.add "$filter", valid_565029
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565030 = header.getOrDefault("return-client-request-id")
  valid_565030 = validateParameter(valid_565030, JBool, required = false,
                                 default = newJBool(false))
  if valid_565030 != nil:
    section.add "return-client-request-id", valid_565030
  var valid_565031 = header.getOrDefault("client-request-id")
  valid_565031 = validateParameter(valid_565031, JString, required = false,
                                 default = nil)
  if valid_565031 != nil:
    section.add "client-request-id", valid_565031
  var valid_565032 = header.getOrDefault("ocp-date")
  valid_565032 = validateParameter(valid_565032, JString, required = false,
                                 default = nil)
  if valid_565032 != nil:
    section.add "ocp-date", valid_565032
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565033: Call_ComputeNodeList_565021; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565033.validator(path, query, header, formData, body)
  let scheme = call_565033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565033.url(scheme.get, call_565033.host, call_565033.base,
                         call_565033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565033, url, valid)

proc call*(call_565034: Call_ComputeNodeList_565021; apiVersion: string;
          poolId: string; Select: string = ""; timeout: int = 30; maxresults: int = 1000;
          Filter: string = ""): Recallable =
  ## computeNodeList
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool from which you want to list nodes.
  ##   Select: string
  ##         : An OData $select clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 nodes can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-nodes-in-a-pool.
  var path_565035 = newJObject()
  var query_565036 = newJObject()
  add(query_565036, "api-version", newJString(apiVersion))
  add(path_565035, "poolId", newJString(poolId))
  add(query_565036, "$select", newJString(Select))
  add(query_565036, "timeout", newJInt(timeout))
  add(query_565036, "maxresults", newJInt(maxresults))
  add(query_565036, "$filter", newJString(Filter))
  result = call_565034.call(path_565035, query_565036, nil, nil, nil)

var computeNodeList* = Call_ComputeNodeList_565021(name: "computeNodeList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/pools/{poolId}/nodes",
    validator: validate_ComputeNodeList_565022, base: "", url: url_ComputeNodeList_565023,
    schemes: {Scheme.Https})
type
  Call_ComputeNodeGet_565037 = ref object of OpenApiRestCall_563565
proc url_ComputeNodeGet_565039(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeGet_565038(path: JsonNode; query: JsonNode;
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
  var valid_565040 = path.getOrDefault("poolId")
  valid_565040 = validateParameter(valid_565040, JString, required = true,
                                 default = nil)
  if valid_565040 != nil:
    section.add "poolId", valid_565040
  var valid_565041 = path.getOrDefault("nodeId")
  valid_565041 = validateParameter(valid_565041, JString, required = true,
                                 default = nil)
  if valid_565041 != nil:
    section.add "nodeId", valid_565041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565042 = query.getOrDefault("api-version")
  valid_565042 = validateParameter(valid_565042, JString, required = true,
                                 default = nil)
  if valid_565042 != nil:
    section.add "api-version", valid_565042
  var valid_565043 = query.getOrDefault("$select")
  valid_565043 = validateParameter(valid_565043, JString, required = false,
                                 default = nil)
  if valid_565043 != nil:
    section.add "$select", valid_565043
  var valid_565044 = query.getOrDefault("timeout")
  valid_565044 = validateParameter(valid_565044, JInt, required = false,
                                 default = newJInt(30))
  if valid_565044 != nil:
    section.add "timeout", valid_565044
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565045 = header.getOrDefault("return-client-request-id")
  valid_565045 = validateParameter(valid_565045, JBool, required = false,
                                 default = newJBool(false))
  if valid_565045 != nil:
    section.add "return-client-request-id", valid_565045
  var valid_565046 = header.getOrDefault("client-request-id")
  valid_565046 = validateParameter(valid_565046, JString, required = false,
                                 default = nil)
  if valid_565046 != nil:
    section.add "client-request-id", valid_565046
  var valid_565047 = header.getOrDefault("ocp-date")
  valid_565047 = validateParameter(valid_565047, JString, required = false,
                                 default = nil)
  if valid_565047 != nil:
    section.add "ocp-date", valid_565047
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565048: Call_ComputeNodeGet_565037; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565048.validator(path, query, header, formData, body)
  let scheme = call_565048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565048.url(scheme.get, call_565048.host, call_565048.base,
                         call_565048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565048, url, valid)

proc call*(call_565049: Call_ComputeNodeGet_565037; apiVersion: string;
          poolId: string; nodeId: string; Select: string = ""; timeout: int = 30): Recallable =
  ## computeNodeGet
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   Select: string
  ##         : An OData $select clause.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   nodeId: string (required)
  ##         : The ID of the compute node that you want to get information about.
  var path_565050 = newJObject()
  var query_565051 = newJObject()
  add(query_565051, "api-version", newJString(apiVersion))
  add(path_565050, "poolId", newJString(poolId))
  add(query_565051, "$select", newJString(Select))
  add(query_565051, "timeout", newJInt(timeout))
  add(path_565050, "nodeId", newJString(nodeId))
  result = call_565049.call(path_565050, query_565051, nil, nil, nil)

var computeNodeGet* = Call_ComputeNodeGet_565037(name: "computeNodeGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}", validator: validate_ComputeNodeGet_565038,
    base: "", url: url_ComputeNodeGet_565039, schemes: {Scheme.Https})
type
  Call_ComputeNodeDisableScheduling_565052 = ref object of OpenApiRestCall_563565
proc url_ComputeNodeDisableScheduling_565054(protocol: Scheme; host: string;
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

proc validate_ComputeNodeDisableScheduling_565053(path: JsonNode; query: JsonNode;
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
  var valid_565055 = path.getOrDefault("poolId")
  valid_565055 = validateParameter(valid_565055, JString, required = true,
                                 default = nil)
  if valid_565055 != nil:
    section.add "poolId", valid_565055
  var valid_565056 = path.getOrDefault("nodeId")
  valid_565056 = validateParameter(valid_565056, JString, required = true,
                                 default = nil)
  if valid_565056 != nil:
    section.add "nodeId", valid_565056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565057 = query.getOrDefault("api-version")
  valid_565057 = validateParameter(valid_565057, JString, required = true,
                                 default = nil)
  if valid_565057 != nil:
    section.add "api-version", valid_565057
  var valid_565058 = query.getOrDefault("timeout")
  valid_565058 = validateParameter(valid_565058, JInt, required = false,
                                 default = newJInt(30))
  if valid_565058 != nil:
    section.add "timeout", valid_565058
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565059 = header.getOrDefault("return-client-request-id")
  valid_565059 = validateParameter(valid_565059, JBool, required = false,
                                 default = newJBool(false))
  if valid_565059 != nil:
    section.add "return-client-request-id", valid_565059
  var valid_565060 = header.getOrDefault("client-request-id")
  valid_565060 = validateParameter(valid_565060, JString, required = false,
                                 default = nil)
  if valid_565060 != nil:
    section.add "client-request-id", valid_565060
  var valid_565061 = header.getOrDefault("ocp-date")
  valid_565061 = validateParameter(valid_565061, JString, required = false,
                                 default = nil)
  if valid_565061 != nil:
    section.add "ocp-date", valid_565061
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeDisableSchedulingParameter: JObject
  ##                                 : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565063: Call_ComputeNodeDisableScheduling_565052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can disable task scheduling on a node only if its current scheduling state is enabled.
  ## 
  let valid = call_565063.validator(path, query, header, formData, body)
  let scheme = call_565063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565063.url(scheme.get, call_565063.host, call_565063.base,
                         call_565063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565063, url, valid)

proc call*(call_565064: Call_ComputeNodeDisableScheduling_565052;
          apiVersion: string; poolId: string; nodeId: string; timeout: int = 30;
          nodeDisableSchedulingParameter: JsonNode = nil): Recallable =
  ## computeNodeDisableScheduling
  ## You can disable task scheduling on a node only if its current scheduling state is enabled.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   nodeDisableSchedulingParameter: JObject
  ##                                 : The parameters for the request.
  ##   nodeId: string (required)
  ##         : The ID of the compute node on which you want to disable task scheduling.
  var path_565065 = newJObject()
  var query_565066 = newJObject()
  var body_565067 = newJObject()
  add(query_565066, "api-version", newJString(apiVersion))
  add(path_565065, "poolId", newJString(poolId))
  add(query_565066, "timeout", newJInt(timeout))
  if nodeDisableSchedulingParameter != nil:
    body_565067 = nodeDisableSchedulingParameter
  add(path_565065, "nodeId", newJString(nodeId))
  result = call_565064.call(path_565065, query_565066, nil, nil, body_565067)

var computeNodeDisableScheduling* = Call_ComputeNodeDisableScheduling_565052(
    name: "computeNodeDisableScheduling", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/disablescheduling",
    validator: validate_ComputeNodeDisableScheduling_565053, base: "",
    url: url_ComputeNodeDisableScheduling_565054, schemes: {Scheme.Https})
type
  Call_ComputeNodeEnableScheduling_565068 = ref object of OpenApiRestCall_563565
proc url_ComputeNodeEnableScheduling_565070(protocol: Scheme; host: string;
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

proc validate_ComputeNodeEnableScheduling_565069(path: JsonNode; query: JsonNode;
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
  var valid_565071 = path.getOrDefault("poolId")
  valid_565071 = validateParameter(valid_565071, JString, required = true,
                                 default = nil)
  if valid_565071 != nil:
    section.add "poolId", valid_565071
  var valid_565072 = path.getOrDefault("nodeId")
  valid_565072 = validateParameter(valid_565072, JString, required = true,
                                 default = nil)
  if valid_565072 != nil:
    section.add "nodeId", valid_565072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565073 = query.getOrDefault("api-version")
  valid_565073 = validateParameter(valid_565073, JString, required = true,
                                 default = nil)
  if valid_565073 != nil:
    section.add "api-version", valid_565073
  var valid_565074 = query.getOrDefault("timeout")
  valid_565074 = validateParameter(valid_565074, JInt, required = false,
                                 default = newJInt(30))
  if valid_565074 != nil:
    section.add "timeout", valid_565074
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565075 = header.getOrDefault("return-client-request-id")
  valid_565075 = validateParameter(valid_565075, JBool, required = false,
                                 default = newJBool(false))
  if valid_565075 != nil:
    section.add "return-client-request-id", valid_565075
  var valid_565076 = header.getOrDefault("client-request-id")
  valid_565076 = validateParameter(valid_565076, JString, required = false,
                                 default = nil)
  if valid_565076 != nil:
    section.add "client-request-id", valid_565076
  var valid_565077 = header.getOrDefault("ocp-date")
  valid_565077 = validateParameter(valid_565077, JString, required = false,
                                 default = nil)
  if valid_565077 != nil:
    section.add "ocp-date", valid_565077
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565078: Call_ComputeNodeEnableScheduling_565068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can enable task scheduling on a node only if its current scheduling state is disabled
  ## 
  let valid = call_565078.validator(path, query, header, formData, body)
  let scheme = call_565078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565078.url(scheme.get, call_565078.host, call_565078.base,
                         call_565078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565078, url, valid)

proc call*(call_565079: Call_ComputeNodeEnableScheduling_565068;
          apiVersion: string; poolId: string; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeEnableScheduling
  ## You can enable task scheduling on a node only if its current scheduling state is disabled
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   nodeId: string (required)
  ##         : The ID of the compute node on which you want to enable task scheduling.
  var path_565080 = newJObject()
  var query_565081 = newJObject()
  add(query_565081, "api-version", newJString(apiVersion))
  add(path_565080, "poolId", newJString(poolId))
  add(query_565081, "timeout", newJInt(timeout))
  add(path_565080, "nodeId", newJString(nodeId))
  result = call_565079.call(path_565080, query_565081, nil, nil, nil)

var computeNodeEnableScheduling* = Call_ComputeNodeEnableScheduling_565068(
    name: "computeNodeEnableScheduling", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/enablescheduling",
    validator: validate_ComputeNodeEnableScheduling_565069, base: "",
    url: url_ComputeNodeEnableScheduling_565070, schemes: {Scheme.Https})
type
  Call_FileListFromComputeNode_565082 = ref object of OpenApiRestCall_563565
proc url_FileListFromComputeNode_565084(protocol: Scheme; host: string; base: string;
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

proc validate_FileListFromComputeNode_565083(path: JsonNode; query: JsonNode;
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
  var valid_565085 = path.getOrDefault("poolId")
  valid_565085 = validateParameter(valid_565085, JString, required = true,
                                 default = nil)
  if valid_565085 != nil:
    section.add "poolId", valid_565085
  var valid_565086 = path.getOrDefault("nodeId")
  valid_565086 = validateParameter(valid_565086, JString, required = true,
                                 default = nil)
  if valid_565086 != nil:
    section.add "nodeId", valid_565086
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   recursive: JBool
  ##            : Whether to list children of a directory.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-compute-node-files.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565087 = query.getOrDefault("api-version")
  valid_565087 = validateParameter(valid_565087, JString, required = true,
                                 default = nil)
  if valid_565087 != nil:
    section.add "api-version", valid_565087
  var valid_565088 = query.getOrDefault("recursive")
  valid_565088 = validateParameter(valid_565088, JBool, required = false, default = nil)
  if valid_565088 != nil:
    section.add "recursive", valid_565088
  var valid_565089 = query.getOrDefault("timeout")
  valid_565089 = validateParameter(valid_565089, JInt, required = false,
                                 default = newJInt(30))
  if valid_565089 != nil:
    section.add "timeout", valid_565089
  var valid_565090 = query.getOrDefault("maxresults")
  valid_565090 = validateParameter(valid_565090, JInt, required = false,
                                 default = newJInt(1000))
  if valid_565090 != nil:
    section.add "maxresults", valid_565090
  var valid_565091 = query.getOrDefault("$filter")
  valid_565091 = validateParameter(valid_565091, JString, required = false,
                                 default = nil)
  if valid_565091 != nil:
    section.add "$filter", valid_565091
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565092 = header.getOrDefault("return-client-request-id")
  valid_565092 = validateParameter(valid_565092, JBool, required = false,
                                 default = newJBool(false))
  if valid_565092 != nil:
    section.add "return-client-request-id", valid_565092
  var valid_565093 = header.getOrDefault("client-request-id")
  valid_565093 = validateParameter(valid_565093, JString, required = false,
                                 default = nil)
  if valid_565093 != nil:
    section.add "client-request-id", valid_565093
  var valid_565094 = header.getOrDefault("ocp-date")
  valid_565094 = validateParameter(valid_565094, JString, required = false,
                                 default = nil)
  if valid_565094 != nil:
    section.add "ocp-date", valid_565094
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565095: Call_FileListFromComputeNode_565082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565095.validator(path, query, header, formData, body)
  let scheme = call_565095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565095.url(scheme.get, call_565095.host, call_565095.base,
                         call_565095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565095, url, valid)

proc call*(call_565096: Call_FileListFromComputeNode_565082; apiVersion: string;
          poolId: string; nodeId: string; recursive: bool = false; timeout: int = 30;
          maxresults: int = 1000; Filter: string = ""): Recallable =
  ## fileListFromComputeNode
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   recursive: bool
  ##            : Whether to list children of a directory.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 files can be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-compute-node-files.
  ##   nodeId: string (required)
  ##         : The ID of the compute node whose files you want to list.
  var path_565097 = newJObject()
  var query_565098 = newJObject()
  add(query_565098, "api-version", newJString(apiVersion))
  add(path_565097, "poolId", newJString(poolId))
  add(query_565098, "recursive", newJBool(recursive))
  add(query_565098, "timeout", newJInt(timeout))
  add(query_565098, "maxresults", newJInt(maxresults))
  add(query_565098, "$filter", newJString(Filter))
  add(path_565097, "nodeId", newJString(nodeId))
  result = call_565096.call(path_565097, query_565098, nil, nil, nil)

var fileListFromComputeNode* = Call_FileListFromComputeNode_565082(
    name: "fileListFromComputeNode", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/files",
    validator: validate_FileListFromComputeNode_565083, base: "",
    url: url_FileListFromComputeNode_565084, schemes: {Scheme.Https})
type
  Call_FileGetPropertiesFromComputeNode_565133 = ref object of OpenApiRestCall_563565
proc url_FileGetPropertiesFromComputeNode_565135(protocol: Scheme; host: string;
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

proc validate_FileGetPropertiesFromComputeNode_565134(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified compute node file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   filePath: JString (required)
  ##           : The path to the compute node file that you want to get the properties of.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node that contains the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_565136 = path.getOrDefault("poolId")
  valid_565136 = validateParameter(valid_565136, JString, required = true,
                                 default = nil)
  if valid_565136 != nil:
    section.add "poolId", valid_565136
  var valid_565137 = path.getOrDefault("filePath")
  valid_565137 = validateParameter(valid_565137, JString, required = true,
                                 default = nil)
  if valid_565137 != nil:
    section.add "filePath", valid_565137
  var valid_565138 = path.getOrDefault("nodeId")
  valid_565138 = validateParameter(valid_565138, JString, required = true,
                                 default = nil)
  if valid_565138 != nil:
    section.add "nodeId", valid_565138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565139 = query.getOrDefault("api-version")
  valid_565139 = validateParameter(valid_565139, JString, required = true,
                                 default = nil)
  if valid_565139 != nil:
    section.add "api-version", valid_565139
  var valid_565140 = query.getOrDefault("timeout")
  valid_565140 = validateParameter(valid_565140, JInt, required = false,
                                 default = newJInt(30))
  if valid_565140 != nil:
    section.add "timeout", valid_565140
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565141 = header.getOrDefault("return-client-request-id")
  valid_565141 = validateParameter(valid_565141, JBool, required = false,
                                 default = newJBool(false))
  if valid_565141 != nil:
    section.add "return-client-request-id", valid_565141
  var valid_565142 = header.getOrDefault("If-Unmodified-Since")
  valid_565142 = validateParameter(valid_565142, JString, required = false,
                                 default = nil)
  if valid_565142 != nil:
    section.add "If-Unmodified-Since", valid_565142
  var valid_565143 = header.getOrDefault("client-request-id")
  valid_565143 = validateParameter(valid_565143, JString, required = false,
                                 default = nil)
  if valid_565143 != nil:
    section.add "client-request-id", valid_565143
  var valid_565144 = header.getOrDefault("If-Modified-Since")
  valid_565144 = validateParameter(valid_565144, JString, required = false,
                                 default = nil)
  if valid_565144 != nil:
    section.add "If-Modified-Since", valid_565144
  var valid_565145 = header.getOrDefault("ocp-date")
  valid_565145 = validateParameter(valid_565145, JString, required = false,
                                 default = nil)
  if valid_565145 != nil:
    section.add "ocp-date", valid_565145
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565146: Call_FileGetPropertiesFromComputeNode_565133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the properties of the specified compute node file.
  ## 
  let valid = call_565146.validator(path, query, header, formData, body)
  let scheme = call_565146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565146.url(scheme.get, call_565146.host, call_565146.base,
                         call_565146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565146, url, valid)

proc call*(call_565147: Call_FileGetPropertiesFromComputeNode_565133;
          apiVersion: string; poolId: string; filePath: string; nodeId: string;
          timeout: int = 30): Recallable =
  ## fileGetPropertiesFromComputeNode
  ## Gets the properties of the specified compute node file.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   filePath: string (required)
  ##           : The path to the compute node file that you want to get the properties of.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   nodeId: string (required)
  ##         : The ID of the compute node that contains the file.
  var path_565148 = newJObject()
  var query_565149 = newJObject()
  add(query_565149, "api-version", newJString(apiVersion))
  add(path_565148, "poolId", newJString(poolId))
  add(path_565148, "filePath", newJString(filePath))
  add(query_565149, "timeout", newJInt(timeout))
  add(path_565148, "nodeId", newJString(nodeId))
  result = call_565147.call(path_565148, query_565149, nil, nil, nil)

var fileGetPropertiesFromComputeNode* = Call_FileGetPropertiesFromComputeNode_565133(
    name: "fileGetPropertiesFromComputeNode", meth: HttpMethod.HttpHead,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/files/{filePath}",
    validator: validate_FileGetPropertiesFromComputeNode_565134, base: "",
    url: url_FileGetPropertiesFromComputeNode_565135, schemes: {Scheme.Https})
type
  Call_FileGetFromComputeNode_565099 = ref object of OpenApiRestCall_563565
proc url_FileGetFromComputeNode_565101(protocol: Scheme; host: string; base: string;
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

proc validate_FileGetFromComputeNode_565100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the content of the specified compute node file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   filePath: JString (required)
  ##           : The path to the compute node file that you want to get the content of.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node that contains the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_565102 = path.getOrDefault("poolId")
  valid_565102 = validateParameter(valid_565102, JString, required = true,
                                 default = nil)
  if valid_565102 != nil:
    section.add "poolId", valid_565102
  var valid_565103 = path.getOrDefault("filePath")
  valid_565103 = validateParameter(valid_565103, JString, required = true,
                                 default = nil)
  if valid_565103 != nil:
    section.add "filePath", valid_565103
  var valid_565104 = path.getOrDefault("nodeId")
  valid_565104 = validateParameter(valid_565104, JString, required = true,
                                 default = nil)
  if valid_565104 != nil:
    section.add "nodeId", valid_565104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565105 = query.getOrDefault("api-version")
  valid_565105 = validateParameter(valid_565105, JString, required = true,
                                 default = nil)
  if valid_565105 != nil:
    section.add "api-version", valid_565105
  var valid_565106 = query.getOrDefault("timeout")
  valid_565106 = validateParameter(valid_565106, JInt, required = false,
                                 default = newJInt(30))
  if valid_565106 != nil:
    section.add "timeout", valid_565106
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   ocp-range: JString
  ##            : The byte range to be retrieved. The default is to retrieve the entire file. The format is bytes=startRange-endRange.
  section = newJObject()
  var valid_565107 = header.getOrDefault("return-client-request-id")
  valid_565107 = validateParameter(valid_565107, JBool, required = false,
                                 default = newJBool(false))
  if valid_565107 != nil:
    section.add "return-client-request-id", valid_565107
  var valid_565108 = header.getOrDefault("If-Unmodified-Since")
  valid_565108 = validateParameter(valid_565108, JString, required = false,
                                 default = nil)
  if valid_565108 != nil:
    section.add "If-Unmodified-Since", valid_565108
  var valid_565109 = header.getOrDefault("client-request-id")
  valid_565109 = validateParameter(valid_565109, JString, required = false,
                                 default = nil)
  if valid_565109 != nil:
    section.add "client-request-id", valid_565109
  var valid_565110 = header.getOrDefault("If-Modified-Since")
  valid_565110 = validateParameter(valid_565110, JString, required = false,
                                 default = nil)
  if valid_565110 != nil:
    section.add "If-Modified-Since", valid_565110
  var valid_565111 = header.getOrDefault("ocp-date")
  valid_565111 = validateParameter(valid_565111, JString, required = false,
                                 default = nil)
  if valid_565111 != nil:
    section.add "ocp-date", valid_565111
  var valid_565112 = header.getOrDefault("ocp-range")
  valid_565112 = validateParameter(valid_565112, JString, required = false,
                                 default = nil)
  if valid_565112 != nil:
    section.add "ocp-range", valid_565112
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565113: Call_FileGetFromComputeNode_565099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the content of the specified compute node file.
  ## 
  let valid = call_565113.validator(path, query, header, formData, body)
  let scheme = call_565113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565113.url(scheme.get, call_565113.host, call_565113.base,
                         call_565113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565113, url, valid)

proc call*(call_565114: Call_FileGetFromComputeNode_565099; apiVersion: string;
          poolId: string; filePath: string; nodeId: string; timeout: int = 30): Recallable =
  ## fileGetFromComputeNode
  ## Returns the content of the specified compute node file.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   filePath: string (required)
  ##           : The path to the compute node file that you want to get the content of.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   nodeId: string (required)
  ##         : The ID of the compute node that contains the file.
  var path_565115 = newJObject()
  var query_565116 = newJObject()
  add(query_565116, "api-version", newJString(apiVersion))
  add(path_565115, "poolId", newJString(poolId))
  add(path_565115, "filePath", newJString(filePath))
  add(query_565116, "timeout", newJInt(timeout))
  add(path_565115, "nodeId", newJString(nodeId))
  result = call_565114.call(path_565115, query_565116, nil, nil, nil)

var fileGetFromComputeNode* = Call_FileGetFromComputeNode_565099(
    name: "fileGetFromComputeNode", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/files/{filePath}",
    validator: validate_FileGetFromComputeNode_565100, base: "",
    url: url_FileGetFromComputeNode_565101, schemes: {Scheme.Https})
type
  Call_FileDeleteFromComputeNode_565117 = ref object of OpenApiRestCall_563565
proc url_FileDeleteFromComputeNode_565119(protocol: Scheme; host: string;
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

proc validate_FileDeleteFromComputeNode_565118(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   filePath: JString (required)
  ##           : The path to the file or directory that you want to delete.
  ##   nodeId: JString (required)
  ##         : The ID of the compute node from which you want to delete the file.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_565120 = path.getOrDefault("poolId")
  valid_565120 = validateParameter(valid_565120, JString, required = true,
                                 default = nil)
  if valid_565120 != nil:
    section.add "poolId", valid_565120
  var valid_565121 = path.getOrDefault("filePath")
  valid_565121 = validateParameter(valid_565121, JString, required = true,
                                 default = nil)
  if valid_565121 != nil:
    section.add "filePath", valid_565121
  var valid_565122 = path.getOrDefault("nodeId")
  valid_565122 = validateParameter(valid_565122, JString, required = true,
                                 default = nil)
  if valid_565122 != nil:
    section.add "nodeId", valid_565122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   recursive: JBool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565123 = query.getOrDefault("api-version")
  valid_565123 = validateParameter(valid_565123, JString, required = true,
                                 default = nil)
  if valid_565123 != nil:
    section.add "api-version", valid_565123
  var valid_565124 = query.getOrDefault("recursive")
  valid_565124 = validateParameter(valid_565124, JBool, required = false, default = nil)
  if valid_565124 != nil:
    section.add "recursive", valid_565124
  var valid_565125 = query.getOrDefault("timeout")
  valid_565125 = validateParameter(valid_565125, JInt, required = false,
                                 default = newJInt(30))
  if valid_565125 != nil:
    section.add "timeout", valid_565125
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565126 = header.getOrDefault("return-client-request-id")
  valid_565126 = validateParameter(valid_565126, JBool, required = false,
                                 default = newJBool(false))
  if valid_565126 != nil:
    section.add "return-client-request-id", valid_565126
  var valid_565127 = header.getOrDefault("client-request-id")
  valid_565127 = validateParameter(valid_565127, JString, required = false,
                                 default = nil)
  if valid_565127 != nil:
    section.add "client-request-id", valid_565127
  var valid_565128 = header.getOrDefault("ocp-date")
  valid_565128 = validateParameter(valid_565128, JString, required = false,
                                 default = nil)
  if valid_565128 != nil:
    section.add "ocp-date", valid_565128
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565129: Call_FileDeleteFromComputeNode_565117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565129.validator(path, query, header, formData, body)
  let scheme = call_565129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565129.url(scheme.get, call_565129.host, call_565129.base,
                         call_565129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565129, url, valid)

proc call*(call_565130: Call_FileDeleteFromComputeNode_565117; apiVersion: string;
          poolId: string; filePath: string; nodeId: string; recursive: bool = false;
          timeout: int = 30): Recallable =
  ## fileDeleteFromComputeNode
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   recursive: bool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  ##   filePath: string (required)
  ##           : The path to the file or directory that you want to delete.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   nodeId: string (required)
  ##         : The ID of the compute node from which you want to delete the file.
  var path_565131 = newJObject()
  var query_565132 = newJObject()
  add(query_565132, "api-version", newJString(apiVersion))
  add(path_565131, "poolId", newJString(poolId))
  add(query_565132, "recursive", newJBool(recursive))
  add(path_565131, "filePath", newJString(filePath))
  add(query_565132, "timeout", newJInt(timeout))
  add(path_565131, "nodeId", newJString(nodeId))
  result = call_565130.call(path_565131, query_565132, nil, nil, nil)

var fileDeleteFromComputeNode* = Call_FileDeleteFromComputeNode_565117(
    name: "fileDeleteFromComputeNode", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/files/{filePath}",
    validator: validate_FileDeleteFromComputeNode_565118, base: "",
    url: url_FileDeleteFromComputeNode_565119, schemes: {Scheme.Https})
type
  Call_ComputeNodeGetRemoteDesktop_565150 = ref object of OpenApiRestCall_563565
proc url_ComputeNodeGetRemoteDesktop_565152(protocol: Scheme; host: string;
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

proc validate_ComputeNodeGetRemoteDesktop_565151(path: JsonNode; query: JsonNode;
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
  var valid_565153 = path.getOrDefault("poolId")
  valid_565153 = validateParameter(valid_565153, JString, required = true,
                                 default = nil)
  if valid_565153 != nil:
    section.add "poolId", valid_565153
  var valid_565154 = path.getOrDefault("nodeId")
  valid_565154 = validateParameter(valid_565154, JString, required = true,
                                 default = nil)
  if valid_565154 != nil:
    section.add "nodeId", valid_565154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565155 = query.getOrDefault("api-version")
  valid_565155 = validateParameter(valid_565155, JString, required = true,
                                 default = nil)
  if valid_565155 != nil:
    section.add "api-version", valid_565155
  var valid_565156 = query.getOrDefault("timeout")
  valid_565156 = validateParameter(valid_565156, JInt, required = false,
                                 default = newJInt(30))
  if valid_565156 != nil:
    section.add "timeout", valid_565156
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565157 = header.getOrDefault("return-client-request-id")
  valid_565157 = validateParameter(valid_565157, JBool, required = false,
                                 default = newJBool(false))
  if valid_565157 != nil:
    section.add "return-client-request-id", valid_565157
  var valid_565158 = header.getOrDefault("client-request-id")
  valid_565158 = validateParameter(valid_565158, JString, required = false,
                                 default = nil)
  if valid_565158 != nil:
    section.add "client-request-id", valid_565158
  var valid_565159 = header.getOrDefault("ocp-date")
  valid_565159 = validateParameter(valid_565159, JString, required = false,
                                 default = nil)
  if valid_565159 != nil:
    section.add "ocp-date", valid_565159
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565160: Call_ComputeNodeGetRemoteDesktop_565150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Before you can access a node by using the RDP file, you must create a user account on the node. This API can only be invoked on pools created with a cloud service configuration. For pools created with a virtual machine configuration, see the GetRemoteLoginSettings API.
  ## 
  let valid = call_565160.validator(path, query, header, formData, body)
  let scheme = call_565160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565160.url(scheme.get, call_565160.host, call_565160.base,
                         call_565160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565160, url, valid)

proc call*(call_565161: Call_ComputeNodeGetRemoteDesktop_565150;
          apiVersion: string; poolId: string; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeGetRemoteDesktop
  ## Before you can access a node by using the RDP file, you must create a user account on the node. This API can only be invoked on pools created with a cloud service configuration. For pools created with a virtual machine configuration, see the GetRemoteLoginSettings API.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   nodeId: string (required)
  ##         : The ID of the compute node for which you want to get the Remote Desktop Protocol file.
  var path_565162 = newJObject()
  var query_565163 = newJObject()
  add(query_565163, "api-version", newJString(apiVersion))
  add(path_565162, "poolId", newJString(poolId))
  add(query_565163, "timeout", newJInt(timeout))
  add(path_565162, "nodeId", newJString(nodeId))
  result = call_565161.call(path_565162, query_565163, nil, nil, nil)

var computeNodeGetRemoteDesktop* = Call_ComputeNodeGetRemoteDesktop_565150(
    name: "computeNodeGetRemoteDesktop", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/rdp",
    validator: validate_ComputeNodeGetRemoteDesktop_565151, base: "",
    url: url_ComputeNodeGetRemoteDesktop_565152, schemes: {Scheme.Https})
type
  Call_ComputeNodeReboot_565164 = ref object of OpenApiRestCall_563565
proc url_ComputeNodeReboot_565166(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeReboot_565165(path: JsonNode; query: JsonNode;
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
  var valid_565167 = path.getOrDefault("poolId")
  valid_565167 = validateParameter(valid_565167, JString, required = true,
                                 default = nil)
  if valid_565167 != nil:
    section.add "poolId", valid_565167
  var valid_565168 = path.getOrDefault("nodeId")
  valid_565168 = validateParameter(valid_565168, JString, required = true,
                                 default = nil)
  if valid_565168 != nil:
    section.add "nodeId", valid_565168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565169 = query.getOrDefault("api-version")
  valid_565169 = validateParameter(valid_565169, JString, required = true,
                                 default = nil)
  if valid_565169 != nil:
    section.add "api-version", valid_565169
  var valid_565170 = query.getOrDefault("timeout")
  valid_565170 = validateParameter(valid_565170, JInt, required = false,
                                 default = newJInt(30))
  if valid_565170 != nil:
    section.add "timeout", valid_565170
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565171 = header.getOrDefault("return-client-request-id")
  valid_565171 = validateParameter(valid_565171, JBool, required = false,
                                 default = newJBool(false))
  if valid_565171 != nil:
    section.add "return-client-request-id", valid_565171
  var valid_565172 = header.getOrDefault("client-request-id")
  valid_565172 = validateParameter(valid_565172, JString, required = false,
                                 default = nil)
  if valid_565172 != nil:
    section.add "client-request-id", valid_565172
  var valid_565173 = header.getOrDefault("ocp-date")
  valid_565173 = validateParameter(valid_565173, JString, required = false,
                                 default = nil)
  if valid_565173 != nil:
    section.add "ocp-date", valid_565173
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeRebootParameter: JObject
  ##                      : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565175: Call_ComputeNodeReboot_565164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can restart a node only if it is in an idle or running state.
  ## 
  let valid = call_565175.validator(path, query, header, formData, body)
  let scheme = call_565175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565175.url(scheme.get, call_565175.host, call_565175.base,
                         call_565175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565175, url, valid)

proc call*(call_565176: Call_ComputeNodeReboot_565164; apiVersion: string;
          poolId: string; nodeId: string; timeout: int = 30;
          nodeRebootParameter: JsonNode = nil): Recallable =
  ## computeNodeReboot
  ## You can restart a node only if it is in an idle or running state.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   nodeRebootParameter: JObject
  ##                      : The parameters for the request.
  ##   nodeId: string (required)
  ##         : The ID of the compute node that you want to restart.
  var path_565177 = newJObject()
  var query_565178 = newJObject()
  var body_565179 = newJObject()
  add(query_565178, "api-version", newJString(apiVersion))
  add(path_565177, "poolId", newJString(poolId))
  add(query_565178, "timeout", newJInt(timeout))
  if nodeRebootParameter != nil:
    body_565179 = nodeRebootParameter
  add(path_565177, "nodeId", newJString(nodeId))
  result = call_565176.call(path_565177, query_565178, nil, nil, body_565179)

var computeNodeReboot* = Call_ComputeNodeReboot_565164(name: "computeNodeReboot",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/reboot",
    validator: validate_ComputeNodeReboot_565165, base: "",
    url: url_ComputeNodeReboot_565166, schemes: {Scheme.Https})
type
  Call_ComputeNodeReimage_565180 = ref object of OpenApiRestCall_563565
proc url_ComputeNodeReimage_565182(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeReimage_565181(path: JsonNode; query: JsonNode;
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
  var valid_565183 = path.getOrDefault("poolId")
  valid_565183 = validateParameter(valid_565183, JString, required = true,
                                 default = nil)
  if valid_565183 != nil:
    section.add "poolId", valid_565183
  var valid_565184 = path.getOrDefault("nodeId")
  valid_565184 = validateParameter(valid_565184, JString, required = true,
                                 default = nil)
  if valid_565184 != nil:
    section.add "nodeId", valid_565184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565185 = query.getOrDefault("api-version")
  valid_565185 = validateParameter(valid_565185, JString, required = true,
                                 default = nil)
  if valid_565185 != nil:
    section.add "api-version", valid_565185
  var valid_565186 = query.getOrDefault("timeout")
  valid_565186 = validateParameter(valid_565186, JInt, required = false,
                                 default = newJInt(30))
  if valid_565186 != nil:
    section.add "timeout", valid_565186
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565187 = header.getOrDefault("return-client-request-id")
  valid_565187 = validateParameter(valid_565187, JBool, required = false,
                                 default = newJBool(false))
  if valid_565187 != nil:
    section.add "return-client-request-id", valid_565187
  var valid_565188 = header.getOrDefault("client-request-id")
  valid_565188 = validateParameter(valid_565188, JString, required = false,
                                 default = nil)
  if valid_565188 != nil:
    section.add "client-request-id", valid_565188
  var valid_565189 = header.getOrDefault("ocp-date")
  valid_565189 = validateParameter(valid_565189, JString, required = false,
                                 default = nil)
  if valid_565189 != nil:
    section.add "ocp-date", valid_565189
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeReimageParameter: JObject
  ##                       : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565191: Call_ComputeNodeReimage_565180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can reinstall the operating system on a node only if it is in an idle or running state. This API can be invoked only on pools created with the cloud service configuration property.
  ## 
  let valid = call_565191.validator(path, query, header, formData, body)
  let scheme = call_565191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565191.url(scheme.get, call_565191.host, call_565191.base,
                         call_565191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565191, url, valid)

proc call*(call_565192: Call_ComputeNodeReimage_565180; apiVersion: string;
          poolId: string; nodeId: string; timeout: int = 30;
          nodeReimageParameter: JsonNode = nil): Recallable =
  ## computeNodeReimage
  ## You can reinstall the operating system on a node only if it is in an idle or running state. This API can be invoked only on pools created with the cloud service configuration property.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   nodeReimageParameter: JObject
  ##                       : The parameters for the request.
  ##   nodeId: string (required)
  ##         : The ID of the compute node that you want to restart.
  var path_565193 = newJObject()
  var query_565194 = newJObject()
  var body_565195 = newJObject()
  add(query_565194, "api-version", newJString(apiVersion))
  add(path_565193, "poolId", newJString(poolId))
  add(query_565194, "timeout", newJInt(timeout))
  if nodeReimageParameter != nil:
    body_565195 = nodeReimageParameter
  add(path_565193, "nodeId", newJString(nodeId))
  result = call_565192.call(path_565193, query_565194, nil, nil, body_565195)

var computeNodeReimage* = Call_ComputeNodeReimage_565180(
    name: "computeNodeReimage", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/reimage",
    validator: validate_ComputeNodeReimage_565181, base: "",
    url: url_ComputeNodeReimage_565182, schemes: {Scheme.Https})
type
  Call_ComputeNodeGetRemoteLoginSettings_565196 = ref object of OpenApiRestCall_563565
proc url_ComputeNodeGetRemoteLoginSettings_565198(protocol: Scheme; host: string;
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

proc validate_ComputeNodeGetRemoteLoginSettings_565197(path: JsonNode;
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
  var valid_565199 = path.getOrDefault("poolId")
  valid_565199 = validateParameter(valid_565199, JString, required = true,
                                 default = nil)
  if valid_565199 != nil:
    section.add "poolId", valid_565199
  var valid_565200 = path.getOrDefault("nodeId")
  valid_565200 = validateParameter(valid_565200, JString, required = true,
                                 default = nil)
  if valid_565200 != nil:
    section.add "nodeId", valid_565200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565201 = query.getOrDefault("api-version")
  valid_565201 = validateParameter(valid_565201, JString, required = true,
                                 default = nil)
  if valid_565201 != nil:
    section.add "api-version", valid_565201
  var valid_565202 = query.getOrDefault("timeout")
  valid_565202 = validateParameter(valid_565202, JInt, required = false,
                                 default = newJInt(30))
  if valid_565202 != nil:
    section.add "timeout", valid_565202
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565203 = header.getOrDefault("return-client-request-id")
  valid_565203 = validateParameter(valid_565203, JBool, required = false,
                                 default = newJBool(false))
  if valid_565203 != nil:
    section.add "return-client-request-id", valid_565203
  var valid_565204 = header.getOrDefault("client-request-id")
  valid_565204 = validateParameter(valid_565204, JString, required = false,
                                 default = nil)
  if valid_565204 != nil:
    section.add "client-request-id", valid_565204
  var valid_565205 = header.getOrDefault("ocp-date")
  valid_565205 = validateParameter(valid_565205, JString, required = false,
                                 default = nil)
  if valid_565205 != nil:
    section.add "ocp-date", valid_565205
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565206: Call_ComputeNodeGetRemoteLoginSettings_565196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Before you can remotely login to a node using the remote login settings, you must create a user account on the node. This API can be invoked only on pools created with the virtual machine configuration property. For pools created with a cloud service configuration, see the GetRemoteDesktop API.
  ## 
  let valid = call_565206.validator(path, query, header, formData, body)
  let scheme = call_565206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565206.url(scheme.get, call_565206.host, call_565206.base,
                         call_565206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565206, url, valid)

proc call*(call_565207: Call_ComputeNodeGetRemoteLoginSettings_565196;
          apiVersion: string; poolId: string; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeGetRemoteLoginSettings
  ## Before you can remotely login to a node using the remote login settings, you must create a user account on the node. This API can be invoked only on pools created with the virtual machine configuration property. For pools created with a cloud service configuration, see the GetRemoteDesktop API.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   nodeId: string (required)
  ##         : The ID of the compute node for which to obtain the remote login settings.
  var path_565208 = newJObject()
  var query_565209 = newJObject()
  add(query_565209, "api-version", newJString(apiVersion))
  add(path_565208, "poolId", newJString(poolId))
  add(query_565209, "timeout", newJInt(timeout))
  add(path_565208, "nodeId", newJString(nodeId))
  result = call_565207.call(path_565208, query_565209, nil, nil, nil)

var computeNodeGetRemoteLoginSettings* = Call_ComputeNodeGetRemoteLoginSettings_565196(
    name: "computeNodeGetRemoteLoginSettings", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/remoteloginsettings",
    validator: validate_ComputeNodeGetRemoteLoginSettings_565197, base: "",
    url: url_ComputeNodeGetRemoteLoginSettings_565198, schemes: {Scheme.Https})
type
  Call_ComputeNodeUploadBatchServiceLogs_565210 = ref object of OpenApiRestCall_563565
proc url_ComputeNodeUploadBatchServiceLogs_565212(protocol: Scheme; host: string;
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

proc validate_ComputeNodeUploadBatchServiceLogs_565211(path: JsonNode;
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
  var valid_565213 = path.getOrDefault("poolId")
  valid_565213 = validateParameter(valid_565213, JString, required = true,
                                 default = nil)
  if valid_565213 != nil:
    section.add "poolId", valid_565213
  var valid_565214 = path.getOrDefault("nodeId")
  valid_565214 = validateParameter(valid_565214, JString, required = true,
                                 default = nil)
  if valid_565214 != nil:
    section.add "nodeId", valid_565214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565215 = query.getOrDefault("api-version")
  valid_565215 = validateParameter(valid_565215, JString, required = true,
                                 default = nil)
  if valid_565215 != nil:
    section.add "api-version", valid_565215
  var valid_565216 = query.getOrDefault("timeout")
  valid_565216 = validateParameter(valid_565216, JInt, required = false,
                                 default = newJInt(30))
  if valid_565216 != nil:
    section.add "timeout", valid_565216
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565217 = header.getOrDefault("return-client-request-id")
  valid_565217 = validateParameter(valid_565217, JBool, required = false,
                                 default = newJBool(false))
  if valid_565217 != nil:
    section.add "return-client-request-id", valid_565217
  var valid_565218 = header.getOrDefault("client-request-id")
  valid_565218 = validateParameter(valid_565218, JString, required = false,
                                 default = nil)
  if valid_565218 != nil:
    section.add "client-request-id", valid_565218
  var valid_565219 = header.getOrDefault("ocp-date")
  valid_565219 = validateParameter(valid_565219, JString, required = false,
                                 default = nil)
  if valid_565219 != nil:
    section.add "ocp-date", valid_565219
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

proc call*(call_565221: Call_ComputeNodeUploadBatchServiceLogs_565210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This is for gathering Azure Batch service log files in an automated fashion from nodes if you are experiencing an error and wish to escalate to Azure support. The Azure Batch service log files should be shared with Azure support to aid in debugging issues with the Batch service.
  ## 
  let valid = call_565221.validator(path, query, header, formData, body)
  let scheme = call_565221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565221.url(scheme.get, call_565221.host, call_565221.base,
                         call_565221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565221, url, valid)

proc call*(call_565222: Call_ComputeNodeUploadBatchServiceLogs_565210;
          apiVersion: string; poolId: string;
          uploadBatchServiceLogsConfiguration: JsonNode; nodeId: string;
          timeout: int = 30): Recallable =
  ## computeNodeUploadBatchServiceLogs
  ## This is for gathering Azure Batch service log files in an automated fashion from nodes if you are experiencing an error and wish to escalate to Azure support. The Azure Batch service log files should be shared with Azure support to aid in debugging issues with the Batch service.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   uploadBatchServiceLogsConfiguration: JObject (required)
  ##                                      : The Azure Batch service log files upload configuration.
  ##   nodeId: string (required)
  ##         : The ID of the compute node from which you want to upload the Azure Batch service log files.
  var path_565223 = newJObject()
  var query_565224 = newJObject()
  var body_565225 = newJObject()
  add(query_565224, "api-version", newJString(apiVersion))
  add(path_565223, "poolId", newJString(poolId))
  add(query_565224, "timeout", newJInt(timeout))
  if uploadBatchServiceLogsConfiguration != nil:
    body_565225 = uploadBatchServiceLogsConfiguration
  add(path_565223, "nodeId", newJString(nodeId))
  result = call_565222.call(path_565223, query_565224, nil, nil, body_565225)

var computeNodeUploadBatchServiceLogs* = Call_ComputeNodeUploadBatchServiceLogs_565210(
    name: "computeNodeUploadBatchServiceLogs", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/uploadbatchservicelogs",
    validator: validate_ComputeNodeUploadBatchServiceLogs_565211, base: "",
    url: url_ComputeNodeUploadBatchServiceLogs_565212, schemes: {Scheme.Https})
type
  Call_ComputeNodeAddUser_565226 = ref object of OpenApiRestCall_563565
proc url_ComputeNodeAddUser_565228(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeAddUser_565227(path: JsonNode; query: JsonNode;
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
  var valid_565229 = path.getOrDefault("poolId")
  valid_565229 = validateParameter(valid_565229, JString, required = true,
                                 default = nil)
  if valid_565229 != nil:
    section.add "poolId", valid_565229
  var valid_565230 = path.getOrDefault("nodeId")
  valid_565230 = validateParameter(valid_565230, JString, required = true,
                                 default = nil)
  if valid_565230 != nil:
    section.add "nodeId", valid_565230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565231 = query.getOrDefault("api-version")
  valid_565231 = validateParameter(valid_565231, JString, required = true,
                                 default = nil)
  if valid_565231 != nil:
    section.add "api-version", valid_565231
  var valid_565232 = query.getOrDefault("timeout")
  valid_565232 = validateParameter(valid_565232, JInt, required = false,
                                 default = newJInt(30))
  if valid_565232 != nil:
    section.add "timeout", valid_565232
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565233 = header.getOrDefault("return-client-request-id")
  valid_565233 = validateParameter(valid_565233, JBool, required = false,
                                 default = newJBool(false))
  if valid_565233 != nil:
    section.add "return-client-request-id", valid_565233
  var valid_565234 = header.getOrDefault("client-request-id")
  valid_565234 = validateParameter(valid_565234, JString, required = false,
                                 default = nil)
  if valid_565234 != nil:
    section.add "client-request-id", valid_565234
  var valid_565235 = header.getOrDefault("ocp-date")
  valid_565235 = validateParameter(valid_565235, JString, required = false,
                                 default = nil)
  if valid_565235 != nil:
    section.add "ocp-date", valid_565235
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

proc call*(call_565237: Call_ComputeNodeAddUser_565226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can add a user account to a node only when it is in the idle or running state.
  ## 
  let valid = call_565237.validator(path, query, header, formData, body)
  let scheme = call_565237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565237.url(scheme.get, call_565237.host, call_565237.base,
                         call_565237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565237, url, valid)

proc call*(call_565238: Call_ComputeNodeAddUser_565226; apiVersion: string;
          poolId: string; user: JsonNode; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeAddUser
  ## You can add a user account to a node only when it is in the idle or running state.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   user: JObject (required)
  ##       : The user account to be created.
  ##   nodeId: string (required)
  ##         : The ID of the machine on which you want to create a user account.
  var path_565239 = newJObject()
  var query_565240 = newJObject()
  var body_565241 = newJObject()
  add(query_565240, "api-version", newJString(apiVersion))
  add(path_565239, "poolId", newJString(poolId))
  add(query_565240, "timeout", newJInt(timeout))
  if user != nil:
    body_565241 = user
  add(path_565239, "nodeId", newJString(nodeId))
  result = call_565238.call(path_565239, query_565240, nil, nil, body_565241)

var computeNodeAddUser* = Call_ComputeNodeAddUser_565226(
    name: "computeNodeAddUser", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/users",
    validator: validate_ComputeNodeAddUser_565227, base: "",
    url: url_ComputeNodeAddUser_565228, schemes: {Scheme.Https})
type
  Call_ComputeNodeUpdateUser_565242 = ref object of OpenApiRestCall_563565
proc url_ComputeNodeUpdateUser_565244(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeUpdateUser_565243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation replaces of all the updatable properties of the account. For example, if the expiryTime element is not specified, the current value is replaced with the default value, not left unmodified. You can update a user account on a node only when it is in the idle or running state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   userName: JString (required)
  ##           : The name of the user account to update.
  ##   nodeId: JString (required)
  ##         : The ID of the machine on which you want to update a user account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_565245 = path.getOrDefault("poolId")
  valid_565245 = validateParameter(valid_565245, JString, required = true,
                                 default = nil)
  if valid_565245 != nil:
    section.add "poolId", valid_565245
  var valid_565246 = path.getOrDefault("userName")
  valid_565246 = validateParameter(valid_565246, JString, required = true,
                                 default = nil)
  if valid_565246 != nil:
    section.add "userName", valid_565246
  var valid_565247 = path.getOrDefault("nodeId")
  valid_565247 = validateParameter(valid_565247, JString, required = true,
                                 default = nil)
  if valid_565247 != nil:
    section.add "nodeId", valid_565247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565248 = query.getOrDefault("api-version")
  valid_565248 = validateParameter(valid_565248, JString, required = true,
                                 default = nil)
  if valid_565248 != nil:
    section.add "api-version", valid_565248
  var valid_565249 = query.getOrDefault("timeout")
  valid_565249 = validateParameter(valid_565249, JInt, required = false,
                                 default = newJInt(30))
  if valid_565249 != nil:
    section.add "timeout", valid_565249
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565250 = header.getOrDefault("return-client-request-id")
  valid_565250 = validateParameter(valid_565250, JBool, required = false,
                                 default = newJBool(false))
  if valid_565250 != nil:
    section.add "return-client-request-id", valid_565250
  var valid_565251 = header.getOrDefault("client-request-id")
  valid_565251 = validateParameter(valid_565251, JString, required = false,
                                 default = nil)
  if valid_565251 != nil:
    section.add "client-request-id", valid_565251
  var valid_565252 = header.getOrDefault("ocp-date")
  valid_565252 = validateParameter(valid_565252, JString, required = false,
                                 default = nil)
  if valid_565252 != nil:
    section.add "ocp-date", valid_565252
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

proc call*(call_565254: Call_ComputeNodeUpdateUser_565242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation replaces of all the updatable properties of the account. For example, if the expiryTime element is not specified, the current value is replaced with the default value, not left unmodified. You can update a user account on a node only when it is in the idle or running state.
  ## 
  let valid = call_565254.validator(path, query, header, formData, body)
  let scheme = call_565254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565254.url(scheme.get, call_565254.host, call_565254.base,
                         call_565254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565254, url, valid)

proc call*(call_565255: Call_ComputeNodeUpdateUser_565242; apiVersion: string;
          poolId: string; nodeUpdateUserParameter: JsonNode; userName: string;
          nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeUpdateUser
  ## This operation replaces of all the updatable properties of the account. For example, if the expiryTime element is not specified, the current value is replaced with the default value, not left unmodified. You can update a user account on a node only when it is in the idle or running state.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   nodeUpdateUserParameter: JObject (required)
  ##                          : The parameters for the request.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   userName: string (required)
  ##           : The name of the user account to update.
  ##   nodeId: string (required)
  ##         : The ID of the machine on which you want to update a user account.
  var path_565256 = newJObject()
  var query_565257 = newJObject()
  var body_565258 = newJObject()
  add(query_565257, "api-version", newJString(apiVersion))
  add(path_565256, "poolId", newJString(poolId))
  if nodeUpdateUserParameter != nil:
    body_565258 = nodeUpdateUserParameter
  add(query_565257, "timeout", newJInt(timeout))
  add(path_565256, "userName", newJString(userName))
  add(path_565256, "nodeId", newJString(nodeId))
  result = call_565255.call(path_565256, query_565257, nil, nil, body_565258)

var computeNodeUpdateUser* = Call_ComputeNodeUpdateUser_565242(
    name: "computeNodeUpdateUser", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/users/{userName}",
    validator: validate_ComputeNodeUpdateUser_565243, base: "",
    url: url_ComputeNodeUpdateUser_565244, schemes: {Scheme.Https})
type
  Call_ComputeNodeDeleteUser_565259 = ref object of OpenApiRestCall_563565
proc url_ComputeNodeDeleteUser_565261(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeDeleteUser_565260(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can delete a user account to a node only when it is in the idle or running state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the pool that contains the compute node.
  ##   userName: JString (required)
  ##           : The name of the user account to delete.
  ##   nodeId: JString (required)
  ##         : The ID of the machine on which you want to delete a user account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_565262 = path.getOrDefault("poolId")
  valid_565262 = validateParameter(valid_565262, JString, required = true,
                                 default = nil)
  if valid_565262 != nil:
    section.add "poolId", valid_565262
  var valid_565263 = path.getOrDefault("userName")
  valid_565263 = validateParameter(valid_565263, JString, required = true,
                                 default = nil)
  if valid_565263 != nil:
    section.add "userName", valid_565263
  var valid_565264 = path.getOrDefault("nodeId")
  valid_565264 = validateParameter(valid_565264, JString, required = true,
                                 default = nil)
  if valid_565264 != nil:
    section.add "nodeId", valid_565264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565265 = query.getOrDefault("api-version")
  valid_565265 = validateParameter(valid_565265, JString, required = true,
                                 default = nil)
  if valid_565265 != nil:
    section.add "api-version", valid_565265
  var valid_565266 = query.getOrDefault("timeout")
  valid_565266 = validateParameter(valid_565266, JInt, required = false,
                                 default = newJInt(30))
  if valid_565266 != nil:
    section.add "timeout", valid_565266
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565267 = header.getOrDefault("return-client-request-id")
  valid_565267 = validateParameter(valid_565267, JBool, required = false,
                                 default = newJBool(false))
  if valid_565267 != nil:
    section.add "return-client-request-id", valid_565267
  var valid_565268 = header.getOrDefault("client-request-id")
  valid_565268 = validateParameter(valid_565268, JString, required = false,
                                 default = nil)
  if valid_565268 != nil:
    section.add "client-request-id", valid_565268
  var valid_565269 = header.getOrDefault("ocp-date")
  valid_565269 = validateParameter(valid_565269, JString, required = false,
                                 default = nil)
  if valid_565269 != nil:
    section.add "ocp-date", valid_565269
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565270: Call_ComputeNodeDeleteUser_565259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can delete a user account to a node only when it is in the idle or running state.
  ## 
  let valid = call_565270.validator(path, query, header, formData, body)
  let scheme = call_565270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565270.url(scheme.get, call_565270.host, call_565270.base,
                         call_565270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565270, url, valid)

proc call*(call_565271: Call_ComputeNodeDeleteUser_565259; apiVersion: string;
          poolId: string; userName: string; nodeId: string; timeout: int = 30): Recallable =
  ## computeNodeDeleteUser
  ## You can delete a user account to a node only when it is in the idle or running state.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool that contains the compute node.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   userName: string (required)
  ##           : The name of the user account to delete.
  ##   nodeId: string (required)
  ##         : The ID of the machine on which you want to delete a user account.
  var path_565272 = newJObject()
  var query_565273 = newJObject()
  add(query_565273, "api-version", newJString(apiVersion))
  add(path_565272, "poolId", newJString(poolId))
  add(query_565273, "timeout", newJInt(timeout))
  add(path_565272, "userName", newJString(userName))
  add(path_565272, "nodeId", newJString(nodeId))
  result = call_565271.call(path_565272, query_565273, nil, nil, nil)

var computeNodeDeleteUser* = Call_ComputeNodeDeleteUser_565259(
    name: "computeNodeDeleteUser", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/users/{userName}",
    validator: validate_ComputeNodeDeleteUser_565260, base: "",
    url: url_ComputeNodeDeleteUser_565261, schemes: {Scheme.Https})
type
  Call_PoolRemoveNodes_565274 = ref object of OpenApiRestCall_563565
proc url_PoolRemoveNodes_565276(protocol: Scheme; host: string; base: string;
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

proc validate_PoolRemoveNodes_565275(path: JsonNode; query: JsonNode;
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
  var valid_565277 = path.getOrDefault("poolId")
  valid_565277 = validateParameter(valid_565277, JString, required = true,
                                 default = nil)
  if valid_565277 != nil:
    section.add "poolId", valid_565277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565278 = query.getOrDefault("api-version")
  valid_565278 = validateParameter(valid_565278, JString, required = true,
                                 default = nil)
  if valid_565278 != nil:
    section.add "api-version", valid_565278
  var valid_565279 = query.getOrDefault("timeout")
  valid_565279 = validateParameter(valid_565279, JInt, required = false,
                                 default = newJInt(30))
  if valid_565279 != nil:
    section.add "timeout", valid_565279
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_565280 = header.getOrDefault("return-client-request-id")
  valid_565280 = validateParameter(valid_565280, JBool, required = false,
                                 default = newJBool(false))
  if valid_565280 != nil:
    section.add "return-client-request-id", valid_565280
  var valid_565281 = header.getOrDefault("If-Unmodified-Since")
  valid_565281 = validateParameter(valid_565281, JString, required = false,
                                 default = nil)
  if valid_565281 != nil:
    section.add "If-Unmodified-Since", valid_565281
  var valid_565282 = header.getOrDefault("client-request-id")
  valid_565282 = validateParameter(valid_565282, JString, required = false,
                                 default = nil)
  if valid_565282 != nil:
    section.add "client-request-id", valid_565282
  var valid_565283 = header.getOrDefault("If-Modified-Since")
  valid_565283 = validateParameter(valid_565283, JString, required = false,
                                 default = nil)
  if valid_565283 != nil:
    section.add "If-Modified-Since", valid_565283
  var valid_565284 = header.getOrDefault("If-None-Match")
  valid_565284 = validateParameter(valid_565284, JString, required = false,
                                 default = nil)
  if valid_565284 != nil:
    section.add "If-None-Match", valid_565284
  var valid_565285 = header.getOrDefault("ocp-date")
  valid_565285 = validateParameter(valid_565285, JString, required = false,
                                 default = nil)
  if valid_565285 != nil:
    section.add "ocp-date", valid_565285
  var valid_565286 = header.getOrDefault("If-Match")
  valid_565286 = validateParameter(valid_565286, JString, required = false,
                                 default = nil)
  if valid_565286 != nil:
    section.add "If-Match", valid_565286
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

proc call*(call_565288: Call_PoolRemoveNodes_565274; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation can only run when the allocation state of the pool is steady. When this operation runs, the allocation state changes from steady to resizing.
  ## 
  let valid = call_565288.validator(path, query, header, formData, body)
  let scheme = call_565288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565288.url(scheme.get, call_565288.host, call_565288.base,
                         call_565288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565288, url, valid)

proc call*(call_565289: Call_PoolRemoveNodes_565274; apiVersion: string;
          poolId: string; nodeRemoveParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolRemoveNodes
  ## This operation can only run when the allocation state of the pool is steady. When this operation runs, the allocation state changes from steady to resizing.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool from which you want to remove nodes.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   nodeRemoveParameter: JObject (required)
  ##                      : The parameters for the request.
  var path_565290 = newJObject()
  var query_565291 = newJObject()
  var body_565292 = newJObject()
  add(query_565291, "api-version", newJString(apiVersion))
  add(path_565290, "poolId", newJString(poolId))
  add(query_565291, "timeout", newJInt(timeout))
  if nodeRemoveParameter != nil:
    body_565292 = nodeRemoveParameter
  result = call_565289.call(path_565290, query_565291, nil, nil, body_565292)

var poolRemoveNodes* = Call_PoolRemoveNodes_565274(name: "poolRemoveNodes",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/removenodes", validator: validate_PoolRemoveNodes_565275,
    base: "", url: url_PoolRemoveNodes_565276, schemes: {Scheme.Https})
type
  Call_PoolResize_565293 = ref object of OpenApiRestCall_563565
proc url_PoolResize_565295(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolResize_565294(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_565296 = path.getOrDefault("poolId")
  valid_565296 = validateParameter(valid_565296, JString, required = true,
                                 default = nil)
  if valid_565296 != nil:
    section.add "poolId", valid_565296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565297 = query.getOrDefault("api-version")
  valid_565297 = validateParameter(valid_565297, JString, required = true,
                                 default = nil)
  if valid_565297 != nil:
    section.add "api-version", valid_565297
  var valid_565298 = query.getOrDefault("timeout")
  valid_565298 = validateParameter(valid_565298, JInt, required = false,
                                 default = newJInt(30))
  if valid_565298 != nil:
    section.add "timeout", valid_565298
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_565299 = header.getOrDefault("return-client-request-id")
  valid_565299 = validateParameter(valid_565299, JBool, required = false,
                                 default = newJBool(false))
  if valid_565299 != nil:
    section.add "return-client-request-id", valid_565299
  var valid_565300 = header.getOrDefault("If-Unmodified-Since")
  valid_565300 = validateParameter(valid_565300, JString, required = false,
                                 default = nil)
  if valid_565300 != nil:
    section.add "If-Unmodified-Since", valid_565300
  var valid_565301 = header.getOrDefault("client-request-id")
  valid_565301 = validateParameter(valid_565301, JString, required = false,
                                 default = nil)
  if valid_565301 != nil:
    section.add "client-request-id", valid_565301
  var valid_565302 = header.getOrDefault("If-Modified-Since")
  valid_565302 = validateParameter(valid_565302, JString, required = false,
                                 default = nil)
  if valid_565302 != nil:
    section.add "If-Modified-Since", valid_565302
  var valid_565303 = header.getOrDefault("If-None-Match")
  valid_565303 = validateParameter(valid_565303, JString, required = false,
                                 default = nil)
  if valid_565303 != nil:
    section.add "If-None-Match", valid_565303
  var valid_565304 = header.getOrDefault("ocp-date")
  valid_565304 = validateParameter(valid_565304, JString, required = false,
                                 default = nil)
  if valid_565304 != nil:
    section.add "ocp-date", valid_565304
  var valid_565305 = header.getOrDefault("If-Match")
  valid_565305 = validateParameter(valid_565305, JString, required = false,
                                 default = nil)
  if valid_565305 != nil:
    section.add "If-Match", valid_565305
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

proc call*(call_565307: Call_PoolResize_565293; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can only resize a pool when its allocation state is steady. If the pool is already resizing, the request fails with status code 409. When you resize a pool, the pool's allocation state changes from steady to resizing. You cannot resize pools which are configured for automatic scaling. If you try to do this, the Batch service returns an error 409. If you resize a pool downwards, the Batch service chooses which nodes to remove. To remove specific nodes, use the pool remove nodes API instead.
  ## 
  let valid = call_565307.validator(path, query, header, formData, body)
  let scheme = call_565307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565307.url(scheme.get, call_565307.host, call_565307.base,
                         call_565307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565307, url, valid)

proc call*(call_565308: Call_PoolResize_565293; apiVersion: string; poolId: string;
          poolResizeParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolResize
  ## You can only resize a pool when its allocation state is steady. If the pool is already resizing, the request fails with status code 409. When you resize a pool, the pool's allocation state changes from steady to resizing. You cannot resize pools which are configured for automatic scaling. If you try to do this, the Batch service returns an error 409. If you resize a pool downwards, the Batch service chooses which nodes to remove. To remove specific nodes, use the pool remove nodes API instead.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool to resize.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   poolResizeParameter: JObject (required)
  ##                      : The parameters for the request.
  var path_565309 = newJObject()
  var query_565310 = newJObject()
  var body_565311 = newJObject()
  add(query_565310, "api-version", newJString(apiVersion))
  add(path_565309, "poolId", newJString(poolId))
  add(query_565310, "timeout", newJInt(timeout))
  if poolResizeParameter != nil:
    body_565311 = poolResizeParameter
  result = call_565308.call(path_565309, query_565310, nil, nil, body_565311)

var poolResize* = Call_PoolResize_565293(name: "poolResize",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local",
                                      route: "/pools/{poolId}/resize",
                                      validator: validate_PoolResize_565294,
                                      base: "", url: url_PoolResize_565295,
                                      schemes: {Scheme.Https})
type
  Call_PoolStopResize_565312 = ref object of OpenApiRestCall_563565
proc url_PoolStopResize_565314(protocol: Scheme; host: string; base: string;
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

proc validate_PoolStopResize_565313(path: JsonNode; query: JsonNode;
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
  var valid_565315 = path.getOrDefault("poolId")
  valid_565315 = validateParameter(valid_565315, JString, required = true,
                                 default = nil)
  if valid_565315 != nil:
    section.add "poolId", valid_565315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565316 = query.getOrDefault("api-version")
  valid_565316 = validateParameter(valid_565316, JString, required = true,
                                 default = nil)
  if valid_565316 != nil:
    section.add "api-version", valid_565316
  var valid_565317 = query.getOrDefault("timeout")
  valid_565317 = validateParameter(valid_565317, JInt, required = false,
                                 default = newJInt(30))
  if valid_565317 != nil:
    section.add "timeout", valid_565317
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   If-Unmodified-Since: JString
  ##                      : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has not been modified since the specified time.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   If-Modified-Since: JString
  ##                    : A timestamp indicating the last modified time of the resource known to the client. The operation will be performed only if the resource on the service has been modified since the specified time.
  ##   If-None-Match: JString
  ##                : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service does not match the value specified by the client.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   If-Match: JString
  ##           : An ETag value associated with the version of the resource known to the client. The operation will be performed only if the resource's current ETag on the service exactly matches the value specified by the client.
  section = newJObject()
  var valid_565318 = header.getOrDefault("return-client-request-id")
  valid_565318 = validateParameter(valid_565318, JBool, required = false,
                                 default = newJBool(false))
  if valid_565318 != nil:
    section.add "return-client-request-id", valid_565318
  var valid_565319 = header.getOrDefault("If-Unmodified-Since")
  valid_565319 = validateParameter(valid_565319, JString, required = false,
                                 default = nil)
  if valid_565319 != nil:
    section.add "If-Unmodified-Since", valid_565319
  var valid_565320 = header.getOrDefault("client-request-id")
  valid_565320 = validateParameter(valid_565320, JString, required = false,
                                 default = nil)
  if valid_565320 != nil:
    section.add "client-request-id", valid_565320
  var valid_565321 = header.getOrDefault("If-Modified-Since")
  valid_565321 = validateParameter(valid_565321, JString, required = false,
                                 default = nil)
  if valid_565321 != nil:
    section.add "If-Modified-Since", valid_565321
  var valid_565322 = header.getOrDefault("If-None-Match")
  valid_565322 = validateParameter(valid_565322, JString, required = false,
                                 default = nil)
  if valid_565322 != nil:
    section.add "If-None-Match", valid_565322
  var valid_565323 = header.getOrDefault("ocp-date")
  valid_565323 = validateParameter(valid_565323, JString, required = false,
                                 default = nil)
  if valid_565323 != nil:
    section.add "ocp-date", valid_565323
  var valid_565324 = header.getOrDefault("If-Match")
  valid_565324 = validateParameter(valid_565324, JString, required = false,
                                 default = nil)
  if valid_565324 != nil:
    section.add "If-Match", valid_565324
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565325: Call_PoolStopResize_565312; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This does not restore the pool to its previous state before the resize operation: it only stops any further changes being made, and the pool maintains its current state. After stopping, the pool stabilizes at the number of nodes it was at when the stop operation was done. During the stop operation, the pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize pool request; this API can also be used to halt the initial sizing of the pool when it is created.
  ## 
  let valid = call_565325.validator(path, query, header, formData, body)
  let scheme = call_565325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565325.url(scheme.get, call_565325.host, call_565325.base,
                         call_565325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565325, url, valid)

proc call*(call_565326: Call_PoolStopResize_565312; apiVersion: string;
          poolId: string; timeout: int = 30): Recallable =
  ## poolStopResize
  ## This does not restore the pool to its previous state before the resize operation: it only stops any further changes being made, and the pool maintains its current state. After stopping, the pool stabilizes at the number of nodes it was at when the stop operation was done. During the stop operation, the pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize pool request; this API can also be used to halt the initial sizing of the pool when it is created.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool whose resizing you want to stop.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_565327 = newJObject()
  var query_565328 = newJObject()
  add(query_565328, "api-version", newJString(apiVersion))
  add(path_565327, "poolId", newJString(poolId))
  add(query_565328, "timeout", newJInt(timeout))
  result = call_565326.call(path_565327, query_565328, nil, nil, nil)

var poolStopResize* = Call_PoolStopResize_565312(name: "poolStopResize",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/stopresize", validator: validate_PoolStopResize_565313,
    base: "", url: url_PoolStopResize_565314, schemes: {Scheme.Https})
type
  Call_PoolUpdateProperties_565329 = ref object of OpenApiRestCall_563565
proc url_PoolUpdateProperties_565331(protocol: Scheme; host: string; base: string;
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

proc validate_PoolUpdateProperties_565330(path: JsonNode; query: JsonNode;
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
  var valid_565332 = path.getOrDefault("poolId")
  valid_565332 = validateParameter(valid_565332, JString, required = true,
                                 default = nil)
  if valid_565332 != nil:
    section.add "poolId", valid_565332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565333 = query.getOrDefault("api-version")
  valid_565333 = validateParameter(valid_565333, JString, required = true,
                                 default = nil)
  if valid_565333 != nil:
    section.add "api-version", valid_565333
  var valid_565334 = query.getOrDefault("timeout")
  valid_565334 = validateParameter(valid_565334, JInt, required = false,
                                 default = newJInt(30))
  if valid_565334 != nil:
    section.add "timeout", valid_565334
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565335 = header.getOrDefault("return-client-request-id")
  valid_565335 = validateParameter(valid_565335, JBool, required = false,
                                 default = newJBool(false))
  if valid_565335 != nil:
    section.add "return-client-request-id", valid_565335
  var valid_565336 = header.getOrDefault("client-request-id")
  valid_565336 = validateParameter(valid_565336, JString, required = false,
                                 default = nil)
  if valid_565336 != nil:
    section.add "client-request-id", valid_565336
  var valid_565337 = header.getOrDefault("ocp-date")
  valid_565337 = validateParameter(valid_565337, JString, required = false,
                                 default = nil)
  if valid_565337 != nil:
    section.add "ocp-date", valid_565337
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

proc call*(call_565339: Call_PoolUpdateProperties_565329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This fully replaces all the updatable properties of the pool. For example, if the pool has a start task associated with it and if start task is not specified with this request, then the Batch service will remove the existing start task.
  ## 
  let valid = call_565339.validator(path, query, header, formData, body)
  let scheme = call_565339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565339.url(scheme.get, call_565339.host, call_565339.base,
                         call_565339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565339, url, valid)

proc call*(call_565340: Call_PoolUpdateProperties_565329; apiVersion: string;
          poolId: string; poolUpdatePropertiesParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolUpdateProperties
  ## This fully replaces all the updatable properties of the pool. For example, if the pool has a start task associated with it and if start task is not specified with this request, then the Batch service will remove the existing start task.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the pool to update.
  ##   poolUpdatePropertiesParameter: JObject (required)
  ##                                : The parameters for the request.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  var path_565341 = newJObject()
  var query_565342 = newJObject()
  var body_565343 = newJObject()
  add(query_565342, "api-version", newJString(apiVersion))
  add(path_565341, "poolId", newJString(poolId))
  if poolUpdatePropertiesParameter != nil:
    body_565343 = poolUpdatePropertiesParameter
  add(query_565342, "timeout", newJInt(timeout))
  result = call_565340.call(path_565341, query_565342, nil, nil, body_565343)

var poolUpdateProperties* = Call_PoolUpdateProperties_565329(
    name: "poolUpdateProperties", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/updateproperties",
    validator: validate_PoolUpdateProperties_565330, base: "",
    url: url_PoolUpdateProperties_565331, schemes: {Scheme.Https})
type
  Call_PoolListUsageMetrics_565344 = ref object of OpenApiRestCall_563565
proc url_PoolListUsageMetrics_565346(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolListUsageMetrics_565345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## If you do not specify a $filter clause including a poolId, the response includes all pools that existed in the account in the time range of the returned aggregation intervals. If you do not specify a $filter clause including a startTime or endTime these filters default to the start and end times of the last aggregation interval currently available; that is, only the last aggregation interval is returned.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   starttime: JString
  ##            : The earliest time from which to include metrics. This must be at least two and a half hours before the current time. If not specified this defaults to the start time of the last aggregation interval currently available.
  ##   endtime: JString
  ##          : The latest time from which to include metrics. This must be at least two hours before the current time. If not specified this defaults to the end time of the last aggregation interval currently available.
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: JInt
  ##             : The maximum number of items to return in the response. A maximum of 1000 results will be returned.
  ##   $filter: JString
  ##          : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-account-usage-metrics.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565347 = query.getOrDefault("api-version")
  valid_565347 = validateParameter(valid_565347, JString, required = true,
                                 default = nil)
  if valid_565347 != nil:
    section.add "api-version", valid_565347
  var valid_565348 = query.getOrDefault("starttime")
  valid_565348 = validateParameter(valid_565348, JString, required = false,
                                 default = nil)
  if valid_565348 != nil:
    section.add "starttime", valid_565348
  var valid_565349 = query.getOrDefault("endtime")
  valid_565349 = validateParameter(valid_565349, JString, required = false,
                                 default = nil)
  if valid_565349 != nil:
    section.add "endtime", valid_565349
  var valid_565350 = query.getOrDefault("timeout")
  valid_565350 = validateParameter(valid_565350, JInt, required = false,
                                 default = newJInt(30))
  if valid_565350 != nil:
    section.add "timeout", valid_565350
  var valid_565351 = query.getOrDefault("maxresults")
  valid_565351 = validateParameter(valid_565351, JInt, required = false,
                                 default = newJInt(1000))
  if valid_565351 != nil:
    section.add "maxresults", valid_565351
  var valid_565352 = query.getOrDefault("$filter")
  valid_565352 = validateParameter(valid_565352, JString, required = false,
                                 default = nil)
  if valid_565352 != nil:
    section.add "$filter", valid_565352
  result.add "query", section
  ## parameters in `header` object:
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  section = newJObject()
  var valid_565353 = header.getOrDefault("return-client-request-id")
  valid_565353 = validateParameter(valid_565353, JBool, required = false,
                                 default = newJBool(false))
  if valid_565353 != nil:
    section.add "return-client-request-id", valid_565353
  var valid_565354 = header.getOrDefault("client-request-id")
  valid_565354 = validateParameter(valid_565354, JString, required = false,
                                 default = nil)
  if valid_565354 != nil:
    section.add "client-request-id", valid_565354
  var valid_565355 = header.getOrDefault("ocp-date")
  valid_565355 = validateParameter(valid_565355, JString, required = false,
                                 default = nil)
  if valid_565355 != nil:
    section.add "ocp-date", valid_565355
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565356: Call_PoolListUsageMetrics_565344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If you do not specify a $filter clause including a poolId, the response includes all pools that existed in the account in the time range of the returned aggregation intervals. If you do not specify a $filter clause including a startTime or endTime these filters default to the start and end times of the last aggregation interval currently available; that is, only the last aggregation interval is returned.
  ## 
  let valid = call_565356.validator(path, query, header, formData, body)
  let scheme = call_565356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565356.url(scheme.get, call_565356.host, call_565356.base,
                         call_565356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565356, url, valid)

proc call*(call_565357: Call_PoolListUsageMetrics_565344; apiVersion: string;
          starttime: string = ""; endtime: string = ""; timeout: int = 30;
          maxresults: int = 1000; Filter: string = ""): Recallable =
  ## poolListUsageMetrics
  ## If you do not specify a $filter clause including a poolId, the response includes all pools that existed in the account in the time range of the returned aggregation intervals. If you do not specify a $filter clause including a startTime or endTime these filters default to the start and end times of the last aggregation interval currently available; that is, only the last aggregation interval is returned.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   starttime: string
  ##            : The earliest time from which to include metrics. This must be at least two and a half hours before the current time. If not specified this defaults to the start time of the last aggregation interval currently available.
  ##   endtime: string
  ##          : The latest time from which to include metrics. This must be at least two hours before the current time. If not specified this defaults to the end time of the last aggregation interval currently available.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 results will be returned.
  ##   Filter: string
  ##         : An OData $filter clause. For more information on constructing this filter, see 
  ## https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-account-usage-metrics.
  var query_565358 = newJObject()
  add(query_565358, "api-version", newJString(apiVersion))
  add(query_565358, "starttime", newJString(starttime))
  add(query_565358, "endtime", newJString(endtime))
  add(query_565358, "timeout", newJInt(timeout))
  add(query_565358, "maxresults", newJInt(maxresults))
  add(query_565358, "$filter", newJString(Filter))
  result = call_565357.call(nil, query_565358, nil, nil, nil)

var poolListUsageMetrics* = Call_PoolListUsageMetrics_565344(
    name: "poolListUsageMetrics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/poolusagemetrics", validator: validate_PoolListUsageMetrics_565345,
    base: "", url: url_PoolListUsageMetrics_565346, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
