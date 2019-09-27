
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BatchService
## version: 2019-06-01.9.0
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
  macServiceName = "batch-BatchService"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApplicationList_593660 = ref object of OpenApiRestCall_593438
proc url_ApplicationList_593662(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationList_593661(path: JsonNode; query: JsonNode;
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
  var valid_593835 = query.getOrDefault("timeout")
  valid_593835 = validateParameter(valid_593835, JInt, required = false,
                                 default = newJInt(30))
  if valid_593835 != nil:
    section.add "timeout", valid_593835
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593836 = query.getOrDefault("api-version")
  valid_593836 = validateParameter(valid_593836, JString, required = true,
                                 default = nil)
  if valid_593836 != nil:
    section.add "api-version", valid_593836
  var valid_593837 = query.getOrDefault("maxresults")
  valid_593837 = validateParameter(valid_593837, JInt, required = false,
                                 default = newJInt(1000))
  if valid_593837 != nil:
    section.add "maxresults", valid_593837
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_593838 = header.getOrDefault("client-request-id")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "client-request-id", valid_593838
  var valid_593839 = header.getOrDefault("ocp-date")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "ocp-date", valid_593839
  var valid_593840 = header.getOrDefault("return-client-request-id")
  valid_593840 = validateParameter(valid_593840, JBool, required = false,
                                 default = newJBool(false))
  if valid_593840 != nil:
    section.add "return-client-request-id", valid_593840
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593863: Call_ApplicationList_593660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation returns only Applications and versions that are available for use on Compute Nodes; that is, that can be used in an Package reference. For administrator information about applications and versions that are not yet available to Compute Nodes, use the Azure portal or the Azure Resource Manager API.
  ## 
  let valid = call_593863.validator(path, query, header, formData, body)
  let scheme = call_593863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593863.url(scheme.get, call_593863.host, call_593863.base,
                         call_593863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593863, url, valid)

proc call*(call_593934: Call_ApplicationList_593660; apiVersion: string;
          timeout: int = 30; maxresults: int = 1000): Recallable =
  ## applicationList
  ## This operation returns only Applications and versions that are available for use on Compute Nodes; that is, that can be used in an Package reference. For administrator information about applications and versions that are not yet available to Compute Nodes, use the Azure portal or the Azure Resource Manager API.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   maxresults: int
  ##             : The maximum number of items to return in the response. A maximum of 1000 applications can be returned.
  var query_593935 = newJObject()
  add(query_593935, "timeout", newJInt(timeout))
  add(query_593935, "api-version", newJString(apiVersion))
  add(query_593935, "maxresults", newJInt(maxresults))
  result = call_593934.call(nil, query_593935, nil, nil, nil)

var applicationList* = Call_ApplicationList_593660(name: "applicationList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/applications",
    validator: validate_ApplicationList_593661, base: "", url: url_ApplicationList_593662,
    schemes: {Scheme.Https})
type
  Call_ApplicationGet_593975 = ref object of OpenApiRestCall_593438
proc url_ApplicationGet_593977(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGet_593976(path: JsonNode; query: JsonNode;
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
  var valid_593992 = path.getOrDefault("applicationId")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "applicationId", valid_593992
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_593993 = query.getOrDefault("timeout")
  valid_593993 = validateParameter(valid_593993, JInt, required = false,
                                 default = newJInt(30))
  if valid_593993 != nil:
    section.add "timeout", valid_593993
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "api-version", valid_593994
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_593995 = header.getOrDefault("client-request-id")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "client-request-id", valid_593995
  var valid_593996 = header.getOrDefault("ocp-date")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "ocp-date", valid_593996
  var valid_593997 = header.getOrDefault("return-client-request-id")
  valid_593997 = validateParameter(valid_593997, JBool, required = false,
                                 default = newJBool(false))
  if valid_593997 != nil:
    section.add "return-client-request-id", valid_593997
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_ApplicationGet_593975; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation returns only Applications and versions that are available for use on Compute Nodes; that is, that can be used in an Package reference. For administrator information about Applications and versions that are not yet available to Compute Nodes, use the Azure portal or the Azure Resource Manager API.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_ApplicationGet_593975; apiVersion: string;
          applicationId: string; timeout: int = 30): Recallable =
  ## applicationGet
  ## This operation returns only Applications and versions that are available for use on Compute Nodes; that is, that can be used in an Package reference. For administrator information about Applications and versions that are not yet available to Compute Nodes, use the Azure portal or the Azure Resource Manager API.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   applicationId: string (required)
  ##                : The ID of the Application.
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(query_594001, "timeout", newJInt(timeout))
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "applicationId", newJString(applicationId))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_593975(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/applications/{applicationId}", validator: validate_ApplicationGet_593976,
    base: "", url: url_ApplicationGet_593977, schemes: {Scheme.Https})
type
  Call_CertificateAdd_594017 = ref object of OpenApiRestCall_593438
proc url_CertificateAdd_594019(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CertificateAdd_594018(path: JsonNode; query: JsonNode;
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
  var valid_594037 = query.getOrDefault("timeout")
  valid_594037 = validateParameter(valid_594037, JInt, required = false,
                                 default = newJInt(30))
  if valid_594037 != nil:
    section.add "timeout", valid_594037
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594038 = query.getOrDefault("api-version")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "api-version", valid_594038
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594039 = header.getOrDefault("client-request-id")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "client-request-id", valid_594039
  var valid_594040 = header.getOrDefault("ocp-date")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "ocp-date", valid_594040
  var valid_594041 = header.getOrDefault("return-client-request-id")
  valid_594041 = validateParameter(valid_594041, JBool, required = false,
                                 default = newJBool(false))
  if valid_594041 != nil:
    section.add "return-client-request-id", valid_594041
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

proc call*(call_594043: Call_CertificateAdd_594017; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_CertificateAdd_594017; apiVersion: string;
          certificate: JsonNode; timeout: int = 30): Recallable =
  ## certificateAdd
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   certificate: JObject (required)
  ##              : The Certificate to be added.
  var query_594045 = newJObject()
  var body_594046 = newJObject()
  add(query_594045, "timeout", newJInt(timeout))
  add(query_594045, "api-version", newJString(apiVersion))
  if certificate != nil:
    body_594046 = certificate
  result = call_594044.call(nil, query_594045, nil, nil, body_594046)

var certificateAdd* = Call_CertificateAdd_594017(name: "certificateAdd",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/certificates",
    validator: validate_CertificateAdd_594018, base: "", url: url_CertificateAdd_594019,
    schemes: {Scheme.Https})
type
  Call_CertificateList_594002 = ref object of OpenApiRestCall_593438
proc url_CertificateList_594004(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CertificateList_594003(path: JsonNode; query: JsonNode;
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
  var valid_594006 = query.getOrDefault("timeout")
  valid_594006 = validateParameter(valid_594006, JInt, required = false,
                                 default = newJInt(30))
  if valid_594006 != nil:
    section.add "timeout", valid_594006
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  var valid_594008 = query.getOrDefault("maxresults")
  valid_594008 = validateParameter(valid_594008, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594008 != nil:
    section.add "maxresults", valid_594008
  var valid_594009 = query.getOrDefault("$select")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "$select", valid_594009
  var valid_594010 = query.getOrDefault("$filter")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "$filter", valid_594010
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594011 = header.getOrDefault("client-request-id")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "client-request-id", valid_594011
  var valid_594012 = header.getOrDefault("ocp-date")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "ocp-date", valid_594012
  var valid_594013 = header.getOrDefault("return-client-request-id")
  valid_594013 = validateParameter(valid_594013, JBool, required = false,
                                 default = newJBool(false))
  if valid_594013 != nil:
    section.add "return-client-request-id", valid_594013
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_CertificateList_594002; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_CertificateList_594002; apiVersion: string;
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
  var query_594016 = newJObject()
  add(query_594016, "timeout", newJInt(timeout))
  add(query_594016, "api-version", newJString(apiVersion))
  add(query_594016, "maxresults", newJInt(maxresults))
  add(query_594016, "$select", newJString(Select))
  add(query_594016, "$filter", newJString(Filter))
  result = call_594015.call(nil, query_594016, nil, nil, nil)

var certificateList* = Call_CertificateList_594002(name: "certificateList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates",
    validator: validate_CertificateList_594003, base: "", url: url_CertificateList_594004,
    schemes: {Scheme.Https})
type
  Call_CertificateGet_594047 = ref object of OpenApiRestCall_593438
proc url_CertificateGet_594049(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateGet_594048(path: JsonNode; query: JsonNode;
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
  var valid_594050 = path.getOrDefault("thumbprintAlgorithm")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "thumbprintAlgorithm", valid_594050
  var valid_594051 = path.getOrDefault("thumbprint")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "thumbprint", valid_594051
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_594052 = query.getOrDefault("timeout")
  valid_594052 = validateParameter(valid_594052, JInt, required = false,
                                 default = newJInt(30))
  if valid_594052 != nil:
    section.add "timeout", valid_594052
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594053 = query.getOrDefault("api-version")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "api-version", valid_594053
  var valid_594054 = query.getOrDefault("$select")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "$select", valid_594054
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594055 = header.getOrDefault("client-request-id")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "client-request-id", valid_594055
  var valid_594056 = header.getOrDefault("ocp-date")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "ocp-date", valid_594056
  var valid_594057 = header.getOrDefault("return-client-request-id")
  valid_594057 = validateParameter(valid_594057, JBool, required = false,
                                 default = newJBool(false))
  if valid_594057 != nil:
    section.add "return-client-request-id", valid_594057
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594058: Call_CertificateGet_594047; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Certificate.
  ## 
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_CertificateGet_594047; apiVersion: string;
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
  var path_594060 = newJObject()
  var query_594061 = newJObject()
  add(query_594061, "timeout", newJInt(timeout))
  add(query_594061, "api-version", newJString(apiVersion))
  add(path_594060, "thumbprintAlgorithm", newJString(thumbprintAlgorithm))
  add(query_594061, "$select", newJString(Select))
  add(path_594060, "thumbprint", newJString(thumbprint))
  result = call_594059.call(path_594060, query_594061, nil, nil, nil)

var certificateGet* = Call_CertificateGet_594047(name: "certificateGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})",
    validator: validate_CertificateGet_594048, base: "", url: url_CertificateGet_594049,
    schemes: {Scheme.Https})
type
  Call_CertificateDelete_594062 = ref object of OpenApiRestCall_593438
proc url_CertificateDelete_594064(protocol: Scheme; host: string; base: string;
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

proc validate_CertificateDelete_594063(path: JsonNode; query: JsonNode;
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
  var valid_594065 = path.getOrDefault("thumbprintAlgorithm")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "thumbprintAlgorithm", valid_594065
  var valid_594066 = path.getOrDefault("thumbprint")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "thumbprint", valid_594066
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594067 = query.getOrDefault("timeout")
  valid_594067 = validateParameter(valid_594067, JInt, required = false,
                                 default = newJInt(30))
  if valid_594067 != nil:
    section.add "timeout", valid_594067
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594068 = query.getOrDefault("api-version")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "api-version", valid_594068
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594069 = header.getOrDefault("client-request-id")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "client-request-id", valid_594069
  var valid_594070 = header.getOrDefault("ocp-date")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "ocp-date", valid_594070
  var valid_594071 = header.getOrDefault("return-client-request-id")
  valid_594071 = validateParameter(valid_594071, JBool, required = false,
                                 default = newJBool(false))
  if valid_594071 != nil:
    section.add "return-client-request-id", valid_594071
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594072: Call_CertificateDelete_594062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You cannot delete a Certificate if a resource (Pool or Compute Node) is using it. Before you can delete a Certificate, you must therefore make sure that the Certificate is not associated with any existing Pools, the Certificate is not installed on any Nodes (even if you remove a Certificate from a Pool, it is not removed from existing Compute Nodes in that Pool until they restart), and no running Tasks depend on the Certificate. If you try to delete a Certificate that is in use, the deletion fails. The Certificate status changes to deleteFailed. You can use Cancel Delete Certificate to set the status back to active if you decide that you want to continue using the Certificate.
  ## 
  let valid = call_594072.validator(path, query, header, formData, body)
  let scheme = call_594072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594072.url(scheme.get, call_594072.host, call_594072.base,
                         call_594072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594072, url, valid)

proc call*(call_594073: Call_CertificateDelete_594062; apiVersion: string;
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
  var path_594074 = newJObject()
  var query_594075 = newJObject()
  add(query_594075, "timeout", newJInt(timeout))
  add(query_594075, "api-version", newJString(apiVersion))
  add(path_594074, "thumbprintAlgorithm", newJString(thumbprintAlgorithm))
  add(path_594074, "thumbprint", newJString(thumbprint))
  result = call_594073.call(path_594074, query_594075, nil, nil, nil)

var certificateDelete* = Call_CertificateDelete_594062(name: "certificateDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})",
    validator: validate_CertificateDelete_594063, base: "",
    url: url_CertificateDelete_594064, schemes: {Scheme.Https})
type
  Call_CertificateCancelDeletion_594076 = ref object of OpenApiRestCall_593438
proc url_CertificateCancelDeletion_594078(protocol: Scheme; host: string;
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

proc validate_CertificateCancelDeletion_594077(path: JsonNode; query: JsonNode;
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
  var valid_594079 = path.getOrDefault("thumbprintAlgorithm")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "thumbprintAlgorithm", valid_594079
  var valid_594080 = path.getOrDefault("thumbprint")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "thumbprint", valid_594080
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594081 = query.getOrDefault("timeout")
  valid_594081 = validateParameter(valid_594081, JInt, required = false,
                                 default = newJInt(30))
  if valid_594081 != nil:
    section.add "timeout", valid_594081
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594082 = query.getOrDefault("api-version")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "api-version", valid_594082
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594083 = header.getOrDefault("client-request-id")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "client-request-id", valid_594083
  var valid_594084 = header.getOrDefault("ocp-date")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "ocp-date", valid_594084
  var valid_594085 = header.getOrDefault("return-client-request-id")
  valid_594085 = validateParameter(valid_594085, JBool, required = false,
                                 default = newJBool(false))
  if valid_594085 != nil:
    section.add "return-client-request-id", valid_594085
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_CertificateCancelDeletion_594076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If you try to delete a Certificate that is being used by a Pool or Compute Node, the status of the Certificate changes to deleteFailed. If you decide that you want to continue using the Certificate, you can use this operation to set the status of the Certificate back to active. If you intend to delete the Certificate, you do not need to run this operation after the deletion failed. You must make sure that the Certificate is not being used by any resources, and then you can try again to delete the Certificate.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_CertificateCancelDeletion_594076; apiVersion: string;
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
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(query_594089, "timeout", newJInt(timeout))
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "thumbprintAlgorithm", newJString(thumbprintAlgorithm))
  add(path_594088, "thumbprint", newJString(thumbprint))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var certificateCancelDeletion* = Call_CertificateCancelDeletion_594076(
    name: "certificateCancelDeletion", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})/canceldelete",
    validator: validate_CertificateCancelDeletion_594077, base: "",
    url: url_CertificateCancelDeletion_594078, schemes: {Scheme.Https})
type
  Call_JobAdd_594105 = ref object of OpenApiRestCall_593438
proc url_JobAdd_594107(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobAdd_594106(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594108 = query.getOrDefault("timeout")
  valid_594108 = validateParameter(valid_594108, JInt, required = false,
                                 default = newJInt(30))
  if valid_594108 != nil:
    section.add "timeout", valid_594108
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594109 = query.getOrDefault("api-version")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "api-version", valid_594109
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594110 = header.getOrDefault("client-request-id")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "client-request-id", valid_594110
  var valid_594111 = header.getOrDefault("ocp-date")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "ocp-date", valid_594111
  var valid_594112 = header.getOrDefault("return-client-request-id")
  valid_594112 = validateParameter(valid_594112, JBool, required = false,
                                 default = newJBool(false))
  if valid_594112 != nil:
    section.add "return-client-request-id", valid_594112
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

proc call*(call_594114: Call_JobAdd_594105; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Batch service supports two ways to control the work done as part of a Job. In the first approach, the user specifies a Job Manager Task. The Batch service launches this Task when it is ready to start the Job. The Job Manager Task controls all other Tasks that run under this Job, by using the Task APIs. In the second approach, the user directly controls the execution of Tasks under an active Job, by using the Task APIs. Also note: when naming Jobs, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_JobAdd_594105; apiVersion: string; job: JsonNode;
          timeout: int = 30): Recallable =
  ## jobAdd
  ## The Batch service supports two ways to control the work done as part of a Job. In the first approach, the user specifies a Job Manager Task. The Batch service launches this Task when it is ready to start the Job. The Job Manager Task controls all other Tasks that run under this Job, by using the Task APIs. In the second approach, the user directly controls the execution of Tasks under an active Job, by using the Task APIs. Also note: when naming Jobs, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   job: JObject (required)
  ##      : The Job to be added.
  var query_594116 = newJObject()
  var body_594117 = newJObject()
  add(query_594116, "timeout", newJInt(timeout))
  add(query_594116, "api-version", newJString(apiVersion))
  if job != nil:
    body_594117 = job
  result = call_594115.call(nil, query_594116, nil, nil, body_594117)

var jobAdd* = Call_JobAdd_594105(name: "jobAdd", meth: HttpMethod.HttpPost,
                              host: "azure.local", route: "/jobs",
                              validator: validate_JobAdd_594106, base: "",
                              url: url_JobAdd_594107, schemes: {Scheme.Https})
type
  Call_JobList_594090 = ref object of OpenApiRestCall_593438
proc url_JobList_594092(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobList_594091(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594093 = query.getOrDefault("timeout")
  valid_594093 = validateParameter(valid_594093, JInt, required = false,
                                 default = newJInt(30))
  if valid_594093 != nil:
    section.add "timeout", valid_594093
  var valid_594094 = query.getOrDefault("$expand")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "$expand", valid_594094
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594095 = query.getOrDefault("api-version")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "api-version", valid_594095
  var valid_594096 = query.getOrDefault("maxresults")
  valid_594096 = validateParameter(valid_594096, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594096 != nil:
    section.add "maxresults", valid_594096
  var valid_594097 = query.getOrDefault("$select")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "$select", valid_594097
  var valid_594098 = query.getOrDefault("$filter")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "$filter", valid_594098
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594099 = header.getOrDefault("client-request-id")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "client-request-id", valid_594099
  var valid_594100 = header.getOrDefault("ocp-date")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "ocp-date", valid_594100
  var valid_594101 = header.getOrDefault("return-client-request-id")
  valid_594101 = validateParameter(valid_594101, JBool, required = false,
                                 default = newJBool(false))
  if valid_594101 != nil:
    section.add "return-client-request-id", valid_594101
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_JobList_594090; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_JobList_594090; apiVersion: string; timeout: int = 30;
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
  var query_594104 = newJObject()
  add(query_594104, "timeout", newJInt(timeout))
  add(query_594104, "$expand", newJString(Expand))
  add(query_594104, "api-version", newJString(apiVersion))
  add(query_594104, "maxresults", newJInt(maxresults))
  add(query_594104, "$select", newJString(Select))
  add(query_594104, "$filter", newJString(Filter))
  result = call_594103.call(nil, query_594104, nil, nil, nil)

var jobList* = Call_JobList_594090(name: "jobList", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/jobs",
                                validator: validate_JobList_594091, base: "",
                                url: url_JobList_594092, schemes: {Scheme.Https})
type
  Call_JobUpdate_594137 = ref object of OpenApiRestCall_593438
proc url_JobUpdate_594139(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobUpdate_594138(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594140 = path.getOrDefault("jobId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "jobId", valid_594140
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594141 = query.getOrDefault("timeout")
  valid_594141 = validateParameter(valid_594141, JInt, required = false,
                                 default = newJInt(30))
  if valid_594141 != nil:
    section.add "timeout", valid_594141
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594142 = query.getOrDefault("api-version")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "api-version", valid_594142
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
  var valid_594143 = header.getOrDefault("If-Match")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "If-Match", valid_594143
  var valid_594144 = header.getOrDefault("client-request-id")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "client-request-id", valid_594144
  var valid_594145 = header.getOrDefault("ocp-date")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "ocp-date", valid_594145
  var valid_594146 = header.getOrDefault("If-Unmodified-Since")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "If-Unmodified-Since", valid_594146
  var valid_594147 = header.getOrDefault("If-None-Match")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "If-None-Match", valid_594147
  var valid_594148 = header.getOrDefault("If-Modified-Since")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "If-Modified-Since", valid_594148
  var valid_594149 = header.getOrDefault("return-client-request-id")
  valid_594149 = validateParameter(valid_594149, JBool, required = false,
                                 default = newJBool(false))
  if valid_594149 != nil:
    section.add "return-client-request-id", valid_594149
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

proc call*(call_594151: Call_JobUpdate_594137; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This fully replaces all the updatable properties of the Job. For example, if the Job has constraints associated with it and if constraints is not specified with this request, then the Batch service will remove the existing constraints.
  ## 
  let valid = call_594151.validator(path, query, header, formData, body)
  let scheme = call_594151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594151.url(scheme.get, call_594151.host, call_594151.base,
                         call_594151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594151, url, valid)

proc call*(call_594152: Call_JobUpdate_594137; jobUpdateParameter: JsonNode;
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
  var path_594153 = newJObject()
  var query_594154 = newJObject()
  var body_594155 = newJObject()
  add(query_594154, "timeout", newJInt(timeout))
  if jobUpdateParameter != nil:
    body_594155 = jobUpdateParameter
  add(query_594154, "api-version", newJString(apiVersion))
  add(path_594153, "jobId", newJString(jobId))
  result = call_594152.call(path_594153, query_594154, nil, nil, body_594155)

var jobUpdate* = Call_JobUpdate_594137(name: "jobUpdate", meth: HttpMethod.HttpPut,
                                    host: "azure.local", route: "/jobs/{jobId}",
                                    validator: validate_JobUpdate_594138,
                                    base: "", url: url_JobUpdate_594139,
                                    schemes: {Scheme.Https})
type
  Call_JobGet_594118 = ref object of OpenApiRestCall_593438
proc url_JobGet_594120(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobGet_594119(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the Job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_594121 = path.getOrDefault("jobId")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "jobId", valid_594121
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
  var valid_594122 = query.getOrDefault("timeout")
  valid_594122 = validateParameter(valid_594122, JInt, required = false,
                                 default = newJInt(30))
  if valid_594122 != nil:
    section.add "timeout", valid_594122
  var valid_594123 = query.getOrDefault("$expand")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "$expand", valid_594123
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594124 = query.getOrDefault("api-version")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "api-version", valid_594124
  var valid_594125 = query.getOrDefault("$select")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "$select", valid_594125
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
  var valid_594126 = header.getOrDefault("If-Match")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "If-Match", valid_594126
  var valid_594127 = header.getOrDefault("client-request-id")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "client-request-id", valid_594127
  var valid_594128 = header.getOrDefault("ocp-date")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "ocp-date", valid_594128
  var valid_594129 = header.getOrDefault("If-Unmodified-Since")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "If-Unmodified-Since", valid_594129
  var valid_594130 = header.getOrDefault("If-None-Match")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "If-None-Match", valid_594130
  var valid_594131 = header.getOrDefault("If-Modified-Since")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "If-Modified-Since", valid_594131
  var valid_594132 = header.getOrDefault("return-client-request-id")
  valid_594132 = validateParameter(valid_594132, JBool, required = false,
                                 default = newJBool(false))
  if valid_594132 != nil:
    section.add "return-client-request-id", valid_594132
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_JobGet_594118; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_JobGet_594118; apiVersion: string; jobId: string;
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
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  add(query_594136, "timeout", newJInt(timeout))
  add(query_594136, "$expand", newJString(Expand))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "jobId", newJString(jobId))
  add(query_594136, "$select", newJString(Select))
  result = call_594134.call(path_594135, query_594136, nil, nil, nil)

var jobGet* = Call_JobGet_594118(name: "jobGet", meth: HttpMethod.HttpGet,
                              host: "azure.local", route: "/jobs/{jobId}",
                              validator: validate_JobGet_594119, base: "",
                              url: url_JobGet_594120, schemes: {Scheme.Https})
type
  Call_JobPatch_594173 = ref object of OpenApiRestCall_593438
proc url_JobPatch_594175(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobPatch_594174(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594176 = path.getOrDefault("jobId")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "jobId", valid_594176
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594177 = query.getOrDefault("timeout")
  valid_594177 = validateParameter(valid_594177, JInt, required = false,
                                 default = newJInt(30))
  if valid_594177 != nil:
    section.add "timeout", valid_594177
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594178 = query.getOrDefault("api-version")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "api-version", valid_594178
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
  var valid_594179 = header.getOrDefault("If-Match")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "If-Match", valid_594179
  var valid_594180 = header.getOrDefault("client-request-id")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "client-request-id", valid_594180
  var valid_594181 = header.getOrDefault("ocp-date")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "ocp-date", valid_594181
  var valid_594182 = header.getOrDefault("If-Unmodified-Since")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "If-Unmodified-Since", valid_594182
  var valid_594183 = header.getOrDefault("If-None-Match")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "If-None-Match", valid_594183
  var valid_594184 = header.getOrDefault("If-Modified-Since")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "If-Modified-Since", valid_594184
  var valid_594185 = header.getOrDefault("return-client-request-id")
  valid_594185 = validateParameter(valid_594185, JBool, required = false,
                                 default = newJBool(false))
  if valid_594185 != nil:
    section.add "return-client-request-id", valid_594185
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

proc call*(call_594187: Call_JobPatch_594173; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This replaces only the Job properties specified in the request. For example, if the Job has constraints, and a request does not specify the constraints element, then the Job keeps the existing constraints.
  ## 
  let valid = call_594187.validator(path, query, header, formData, body)
  let scheme = call_594187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594187.url(scheme.get, call_594187.host, call_594187.base,
                         call_594187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594187, url, valid)

proc call*(call_594188: Call_JobPatch_594173; apiVersion: string; jobId: string;
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
  var path_594189 = newJObject()
  var query_594190 = newJObject()
  var body_594191 = newJObject()
  add(query_594190, "timeout", newJInt(timeout))
  add(query_594190, "api-version", newJString(apiVersion))
  add(path_594189, "jobId", newJString(jobId))
  if jobPatchParameter != nil:
    body_594191 = jobPatchParameter
  result = call_594188.call(path_594189, query_594190, nil, nil, body_594191)

var jobPatch* = Call_JobPatch_594173(name: "jobPatch", meth: HttpMethod.HttpPatch,
                                  host: "azure.local", route: "/jobs/{jobId}",
                                  validator: validate_JobPatch_594174, base: "",
                                  url: url_JobPatch_594175,
                                  schemes: {Scheme.Https})
type
  Call_JobDelete_594156 = ref object of OpenApiRestCall_593438
proc url_JobDelete_594158(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobDelete_594157(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594159 = path.getOrDefault("jobId")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "jobId", valid_594159
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594160 = query.getOrDefault("timeout")
  valid_594160 = validateParameter(valid_594160, JInt, required = false,
                                 default = newJInt(30))
  if valid_594160 != nil:
    section.add "timeout", valid_594160
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594161 = query.getOrDefault("api-version")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "api-version", valid_594161
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
  var valid_594162 = header.getOrDefault("If-Match")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "If-Match", valid_594162
  var valid_594163 = header.getOrDefault("client-request-id")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "client-request-id", valid_594163
  var valid_594164 = header.getOrDefault("ocp-date")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "ocp-date", valid_594164
  var valid_594165 = header.getOrDefault("If-Unmodified-Since")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "If-Unmodified-Since", valid_594165
  var valid_594166 = header.getOrDefault("If-None-Match")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "If-None-Match", valid_594166
  var valid_594167 = header.getOrDefault("If-Modified-Since")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "If-Modified-Since", valid_594167
  var valid_594168 = header.getOrDefault("return-client-request-id")
  valid_594168 = validateParameter(valid_594168, JBool, required = false,
                                 default = newJBool(false))
  if valid_594168 != nil:
    section.add "return-client-request-id", valid_594168
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594169: Call_JobDelete_594156; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deleting a Job also deletes all Tasks that are part of that Job, and all Job statistics. This also overrides the retention period for Task data; that is, if the Job contains Tasks which are still retained on Compute Nodes, the Batch services deletes those Tasks' working directories and all their contents.  When a Delete Job request is received, the Batch service sets the Job to the deleting state. All update operations on a Job that is in deleting state will fail with status code 409 (Conflict), with additional information indicating that the Job is being deleted.
  ## 
  let valid = call_594169.validator(path, query, header, formData, body)
  let scheme = call_594169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594169.url(scheme.get, call_594169.host, call_594169.base,
                         call_594169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594169, url, valid)

proc call*(call_594170: Call_JobDelete_594156; apiVersion: string; jobId: string;
          timeout: int = 30): Recallable =
  ## jobDelete
  ## Deleting a Job also deletes all Tasks that are part of that Job, and all Job statistics. This also overrides the retention period for Task data; that is, if the Job contains Tasks which are still retained on Compute Nodes, the Batch services deletes those Tasks' working directories and all their contents.  When a Delete Job request is received, the Batch service sets the Job to the deleting state. All update operations on a Job that is in deleting state will fail with status code 409 (Conflict), with additional information indicating that the Job is being deleted.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job to delete.
  var path_594171 = newJObject()
  var query_594172 = newJObject()
  add(query_594172, "timeout", newJInt(timeout))
  add(query_594172, "api-version", newJString(apiVersion))
  add(path_594171, "jobId", newJString(jobId))
  result = call_594170.call(path_594171, query_594172, nil, nil, nil)

var jobDelete* = Call_JobDelete_594156(name: "jobDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local", route: "/jobs/{jobId}",
                                    validator: validate_JobDelete_594157,
                                    base: "", url: url_JobDelete_594158,
                                    schemes: {Scheme.Https})
type
  Call_TaskAddCollection_594192 = ref object of OpenApiRestCall_593438
proc url_TaskAddCollection_594194(protocol: Scheme; host: string; base: string;
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

proc validate_TaskAddCollection_594193(path: JsonNode; query: JsonNode;
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
  var valid_594205 = path.getOrDefault("jobId")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "jobId", valid_594205
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594206 = query.getOrDefault("timeout")
  valid_594206 = validateParameter(valid_594206, JInt, required = false,
                                 default = newJInt(30))
  if valid_594206 != nil:
    section.add "timeout", valid_594206
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594207 = query.getOrDefault("api-version")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "api-version", valid_594207
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594208 = header.getOrDefault("client-request-id")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "client-request-id", valid_594208
  var valid_594209 = header.getOrDefault("ocp-date")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "ocp-date", valid_594209
  var valid_594210 = header.getOrDefault("return-client-request-id")
  valid_594210 = validateParameter(valid_594210, JBool, required = false,
                                 default = newJBool(false))
  if valid_594210 != nil:
    section.add "return-client-request-id", valid_594210
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

proc call*(call_594212: Call_TaskAddCollection_594192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Note that each Task must have a unique ID. The Batch service may not return the results for each Task in the same order the Tasks were submitted in this request. If the server times out or the connection is closed during the request, the request may have been partially or fully processed, or not at all. In such cases, the user should re-issue the request. Note that it is up to the user to correctly handle failures when re-issuing a request. For example, you should use the same Task IDs during a retry so that if the prior operation succeeded, the retry will not create extra Tasks unexpectedly. If the response contains any Tasks which failed to add, a client can retry the request. In a retry, it is most efficient to resubmit only Tasks that failed to add, and to omit Tasks that were successfully added on the first attempt. The maximum lifetime of a Task from addition to completion is 180 days. If a Task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ## 
  let valid = call_594212.validator(path, query, header, formData, body)
  let scheme = call_594212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594212.url(scheme.get, call_594212.host, call_594212.base,
                         call_594212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594212, url, valid)

proc call*(call_594213: Call_TaskAddCollection_594192; apiVersion: string;
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
  var path_594214 = newJObject()
  var query_594215 = newJObject()
  var body_594216 = newJObject()
  add(query_594215, "timeout", newJInt(timeout))
  add(query_594215, "api-version", newJString(apiVersion))
  add(path_594214, "jobId", newJString(jobId))
  if taskCollection != nil:
    body_594216 = taskCollection
  result = call_594213.call(path_594214, query_594215, nil, nil, body_594216)

var taskAddCollection* = Call_TaskAddCollection_594192(name: "taskAddCollection",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/addtaskcollection",
    validator: validate_TaskAddCollection_594193, base: "",
    url: url_TaskAddCollection_594194, schemes: {Scheme.Https})
type
  Call_JobDisable_594217 = ref object of OpenApiRestCall_593438
proc url_JobDisable_594219(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobDisable_594218(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594220 = path.getOrDefault("jobId")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "jobId", valid_594220
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594221 = query.getOrDefault("timeout")
  valid_594221 = validateParameter(valid_594221, JInt, required = false,
                                 default = newJInt(30))
  if valid_594221 != nil:
    section.add "timeout", valid_594221
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594222 = query.getOrDefault("api-version")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "api-version", valid_594222
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
  var valid_594223 = header.getOrDefault("If-Match")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "If-Match", valid_594223
  var valid_594224 = header.getOrDefault("client-request-id")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "client-request-id", valid_594224
  var valid_594225 = header.getOrDefault("ocp-date")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = nil)
  if valid_594225 != nil:
    section.add "ocp-date", valid_594225
  var valid_594226 = header.getOrDefault("If-Unmodified-Since")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "If-Unmodified-Since", valid_594226
  var valid_594227 = header.getOrDefault("If-None-Match")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "If-None-Match", valid_594227
  var valid_594228 = header.getOrDefault("If-Modified-Since")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = nil)
  if valid_594228 != nil:
    section.add "If-Modified-Since", valid_594228
  var valid_594229 = header.getOrDefault("return-client-request-id")
  valid_594229 = validateParameter(valid_594229, JBool, required = false,
                                 default = newJBool(false))
  if valid_594229 != nil:
    section.add "return-client-request-id", valid_594229
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

proc call*(call_594231: Call_JobDisable_594217; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Batch Service immediately moves the Job to the disabling state. Batch then uses the disableTasks parameter to determine what to do with the currently running Tasks of the Job. The Job remains in the disabling state until the disable operation is completed and all Tasks have been dealt with according to the disableTasks option; the Job then moves to the disabled state. No new Tasks are started under the Job until it moves back to active state. If you try to disable a Job that is in any state other than active, disabling, or disabled, the request fails with status code 409.
  ## 
  let valid = call_594231.validator(path, query, header, formData, body)
  let scheme = call_594231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594231.url(scheme.get, call_594231.host, call_594231.base,
                         call_594231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594231, url, valid)

proc call*(call_594232: Call_JobDisable_594217; apiVersion: string; jobId: string;
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
  var path_594233 = newJObject()
  var query_594234 = newJObject()
  var body_594235 = newJObject()
  add(query_594234, "timeout", newJInt(timeout))
  add(query_594234, "api-version", newJString(apiVersion))
  add(path_594233, "jobId", newJString(jobId))
  if jobDisableParameter != nil:
    body_594235 = jobDisableParameter
  result = call_594232.call(path_594233, query_594234, nil, nil, body_594235)

var jobDisable* = Call_JobDisable_594217(name: "jobDisable",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local",
                                      route: "/jobs/{jobId}/disable",
                                      validator: validate_JobDisable_594218,
                                      base: "", url: url_JobDisable_594219,
                                      schemes: {Scheme.Https})
type
  Call_JobEnable_594236 = ref object of OpenApiRestCall_593438
proc url_JobEnable_594238(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobEnable_594237(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594239 = path.getOrDefault("jobId")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "jobId", valid_594239
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594240 = query.getOrDefault("timeout")
  valid_594240 = validateParameter(valid_594240, JInt, required = false,
                                 default = newJInt(30))
  if valid_594240 != nil:
    section.add "timeout", valid_594240
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594241 = query.getOrDefault("api-version")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "api-version", valid_594241
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
  var valid_594242 = header.getOrDefault("If-Match")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "If-Match", valid_594242
  var valid_594243 = header.getOrDefault("client-request-id")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "client-request-id", valid_594243
  var valid_594244 = header.getOrDefault("ocp-date")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "ocp-date", valid_594244
  var valid_594245 = header.getOrDefault("If-Unmodified-Since")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "If-Unmodified-Since", valid_594245
  var valid_594246 = header.getOrDefault("If-None-Match")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "If-None-Match", valid_594246
  var valid_594247 = header.getOrDefault("If-Modified-Since")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "If-Modified-Since", valid_594247
  var valid_594248 = header.getOrDefault("return-client-request-id")
  valid_594248 = validateParameter(valid_594248, JBool, required = false,
                                 default = newJBool(false))
  if valid_594248 != nil:
    section.add "return-client-request-id", valid_594248
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594249: Call_JobEnable_594236; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you call this API, the Batch service sets a disabled Job to the enabling state. After the this operation is completed, the Job moves to the active state, and scheduling of new Tasks under the Job resumes. The Batch service does not allow a Task to remain in the active state for more than 180 days. Therefore, if you enable a Job containing active Tasks which were added more than 180 days ago, those Tasks will not run.
  ## 
  let valid = call_594249.validator(path, query, header, formData, body)
  let scheme = call_594249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594249.url(scheme.get, call_594249.host, call_594249.base,
                         call_594249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594249, url, valid)

proc call*(call_594250: Call_JobEnable_594236; apiVersion: string; jobId: string;
          timeout: int = 30): Recallable =
  ## jobEnable
  ## When you call this API, the Batch service sets a disabled Job to the enabling state. After the this operation is completed, the Job moves to the active state, and scheduling of new Tasks under the Job resumes. The Batch service does not allow a Task to remain in the active state for more than 180 days. Therefore, if you enable a Job containing active Tasks which were added more than 180 days ago, those Tasks will not run.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job to enable.
  var path_594251 = newJObject()
  var query_594252 = newJObject()
  add(query_594252, "timeout", newJInt(timeout))
  add(query_594252, "api-version", newJString(apiVersion))
  add(path_594251, "jobId", newJString(jobId))
  result = call_594250.call(path_594251, query_594252, nil, nil, nil)

var jobEnable* = Call_JobEnable_594236(name: "jobEnable", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/jobs/{jobId}/enable",
                                    validator: validate_JobEnable_594237,
                                    base: "", url: url_JobEnable_594238,
                                    schemes: {Scheme.Https})
type
  Call_JobListPreparationAndReleaseTaskStatus_594253 = ref object of OpenApiRestCall_593438
proc url_JobListPreparationAndReleaseTaskStatus_594255(protocol: Scheme;
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

proc validate_JobListPreparationAndReleaseTaskStatus_594254(path: JsonNode;
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
  var valid_594256 = path.getOrDefault("jobId")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "jobId", valid_594256
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
  var valid_594257 = query.getOrDefault("timeout")
  valid_594257 = validateParameter(valid_594257, JInt, required = false,
                                 default = newJInt(30))
  if valid_594257 != nil:
    section.add "timeout", valid_594257
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594258 = query.getOrDefault("api-version")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "api-version", valid_594258
  var valid_594259 = query.getOrDefault("maxresults")
  valid_594259 = validateParameter(valid_594259, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594259 != nil:
    section.add "maxresults", valid_594259
  var valid_594260 = query.getOrDefault("$select")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "$select", valid_594260
  var valid_594261 = query.getOrDefault("$filter")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "$filter", valid_594261
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594262 = header.getOrDefault("client-request-id")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "client-request-id", valid_594262
  var valid_594263 = header.getOrDefault("ocp-date")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "ocp-date", valid_594263
  var valid_594264 = header.getOrDefault("return-client-request-id")
  valid_594264 = validateParameter(valid_594264, JBool, required = false,
                                 default = newJBool(false))
  if valid_594264 != nil:
    section.add "return-client-request-id", valid_594264
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594265: Call_JobListPreparationAndReleaseTaskStatus_594253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This API returns the Job Preparation and Job Release Task status on all Compute Nodes that have run the Job Preparation or Job Release Task. This includes Compute Nodes which have since been removed from the Pool. If this API is invoked on a Job which has no Job Preparation or Job Release Task, the Batch service returns HTTP status code 409 (Conflict) with an error code of JobPreparationTaskNotSpecified.
  ## 
  let valid = call_594265.validator(path, query, header, formData, body)
  let scheme = call_594265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594265.url(scheme.get, call_594265.host, call_594265.base,
                         call_594265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594265, url, valid)

proc call*(call_594266: Call_JobListPreparationAndReleaseTaskStatus_594253;
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
  var path_594267 = newJObject()
  var query_594268 = newJObject()
  add(query_594268, "timeout", newJInt(timeout))
  add(query_594268, "api-version", newJString(apiVersion))
  add(path_594267, "jobId", newJString(jobId))
  add(query_594268, "maxresults", newJInt(maxresults))
  add(query_594268, "$select", newJString(Select))
  add(query_594268, "$filter", newJString(Filter))
  result = call_594266.call(path_594267, query_594268, nil, nil, nil)

var jobListPreparationAndReleaseTaskStatus* = Call_JobListPreparationAndReleaseTaskStatus_594253(
    name: "jobListPreparationAndReleaseTaskStatus", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/jobs/{jobId}/jobpreparationandreleasetaskstatus",
    validator: validate_JobListPreparationAndReleaseTaskStatus_594254, base: "",
    url: url_JobListPreparationAndReleaseTaskStatus_594255,
    schemes: {Scheme.Https})
type
  Call_JobGetTaskCounts_594269 = ref object of OpenApiRestCall_593438
proc url_JobGetTaskCounts_594271(protocol: Scheme; host: string; base: string;
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

proc validate_JobGetTaskCounts_594270(path: JsonNode; query: JsonNode;
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
  var valid_594272 = path.getOrDefault("jobId")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "jobId", valid_594272
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594273 = query.getOrDefault("timeout")
  valid_594273 = validateParameter(valid_594273, JInt, required = false,
                                 default = newJInt(30))
  if valid_594273 != nil:
    section.add "timeout", valid_594273
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594274 = query.getOrDefault("api-version")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "api-version", valid_594274
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594275 = header.getOrDefault("client-request-id")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "client-request-id", valid_594275
  var valid_594276 = header.getOrDefault("ocp-date")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "ocp-date", valid_594276
  var valid_594277 = header.getOrDefault("return-client-request-id")
  valid_594277 = validateParameter(valid_594277, JBool, required = false,
                                 default = newJBool(false))
  if valid_594277 != nil:
    section.add "return-client-request-id", valid_594277
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594278: Call_JobGetTaskCounts_594269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Task counts provide a count of the Tasks by active, running or completed Task state, and a count of Tasks which succeeded or failed. Tasks in the preparing state are counted as running.
  ## 
  let valid = call_594278.validator(path, query, header, formData, body)
  let scheme = call_594278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594278.url(scheme.get, call_594278.host, call_594278.base,
                         call_594278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594278, url, valid)

proc call*(call_594279: Call_JobGetTaskCounts_594269; apiVersion: string;
          jobId: string; timeout: int = 30): Recallable =
  ## jobGetTaskCounts
  ## Task counts provide a count of the Tasks by active, running or completed Task state, and a count of Tasks which succeeded or failed. Tasks in the preparing state are counted as running.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   jobId: string (required)
  ##        : The ID of the Job.
  var path_594280 = newJObject()
  var query_594281 = newJObject()
  add(query_594281, "timeout", newJInt(timeout))
  add(query_594281, "api-version", newJString(apiVersion))
  add(path_594280, "jobId", newJString(jobId))
  result = call_594279.call(path_594280, query_594281, nil, nil, nil)

var jobGetTaskCounts* = Call_JobGetTaskCounts_594269(name: "jobGetTaskCounts",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/taskcounts", validator: validate_JobGetTaskCounts_594270,
    base: "", url: url_JobGetTaskCounts_594271, schemes: {Scheme.Https})
type
  Call_TaskAdd_594299 = ref object of OpenApiRestCall_593438
proc url_TaskAdd_594301(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskAdd_594300(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594302 = path.getOrDefault("jobId")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "jobId", valid_594302
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594303 = query.getOrDefault("timeout")
  valid_594303 = validateParameter(valid_594303, JInt, required = false,
                                 default = newJInt(30))
  if valid_594303 != nil:
    section.add "timeout", valid_594303
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594304 = query.getOrDefault("api-version")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "api-version", valid_594304
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594305 = header.getOrDefault("client-request-id")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "client-request-id", valid_594305
  var valid_594306 = header.getOrDefault("ocp-date")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "ocp-date", valid_594306
  var valid_594307 = header.getOrDefault("return-client-request-id")
  valid_594307 = validateParameter(valid_594307, JBool, required = false,
                                 default = newJBool(false))
  if valid_594307 != nil:
    section.add "return-client-request-id", valid_594307
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

proc call*(call_594309: Call_TaskAdd_594299; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The maximum lifetime of a Task from addition to completion is 180 days. If a Task has not completed within 180 days of being added it will be terminated by the Batch service and left in whatever state it was in at that time.
  ## 
  let valid = call_594309.validator(path, query, header, formData, body)
  let scheme = call_594309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594309.url(scheme.get, call_594309.host, call_594309.base,
                         call_594309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594309, url, valid)

proc call*(call_594310: Call_TaskAdd_594299; apiVersion: string; jobId: string;
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
  var path_594311 = newJObject()
  var query_594312 = newJObject()
  var body_594313 = newJObject()
  add(query_594312, "timeout", newJInt(timeout))
  add(query_594312, "api-version", newJString(apiVersion))
  add(path_594311, "jobId", newJString(jobId))
  if task != nil:
    body_594313 = task
  result = call_594310.call(path_594311, query_594312, nil, nil, body_594313)

var taskAdd* = Call_TaskAdd_594299(name: "taskAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/jobs/{jobId}/tasks",
                                validator: validate_TaskAdd_594300, base: "",
                                url: url_TaskAdd_594301, schemes: {Scheme.Https})
type
  Call_TaskList_594282 = ref object of OpenApiRestCall_593438
proc url_TaskList_594284(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskList_594283(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594285 = path.getOrDefault("jobId")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "jobId", valid_594285
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
  var valid_594286 = query.getOrDefault("timeout")
  valid_594286 = validateParameter(valid_594286, JInt, required = false,
                                 default = newJInt(30))
  if valid_594286 != nil:
    section.add "timeout", valid_594286
  var valid_594287 = query.getOrDefault("$expand")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "$expand", valid_594287
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594288 = query.getOrDefault("api-version")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "api-version", valid_594288
  var valid_594289 = query.getOrDefault("maxresults")
  valid_594289 = validateParameter(valid_594289, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594289 != nil:
    section.add "maxresults", valid_594289
  var valid_594290 = query.getOrDefault("$select")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "$select", valid_594290
  var valid_594291 = query.getOrDefault("$filter")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "$filter", valid_594291
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594292 = header.getOrDefault("client-request-id")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = nil)
  if valid_594292 != nil:
    section.add "client-request-id", valid_594292
  var valid_594293 = header.getOrDefault("ocp-date")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "ocp-date", valid_594293
  var valid_594294 = header.getOrDefault("return-client-request-id")
  valid_594294 = validateParameter(valid_594294, JBool, required = false,
                                 default = newJBool(false))
  if valid_594294 != nil:
    section.add "return-client-request-id", valid_594294
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594295: Call_TaskList_594282; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## For multi-instance Tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary Task. Use the list subtasks API to retrieve information about subtasks.
  ## 
  let valid = call_594295.validator(path, query, header, formData, body)
  let scheme = call_594295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594295.url(scheme.get, call_594295.host, call_594295.base,
                         call_594295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594295, url, valid)

proc call*(call_594296: Call_TaskList_594282; apiVersion: string; jobId: string;
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
  var path_594297 = newJObject()
  var query_594298 = newJObject()
  add(query_594298, "timeout", newJInt(timeout))
  add(query_594298, "$expand", newJString(Expand))
  add(query_594298, "api-version", newJString(apiVersion))
  add(path_594297, "jobId", newJString(jobId))
  add(query_594298, "maxresults", newJInt(maxresults))
  add(query_594298, "$select", newJString(Select))
  add(query_594298, "$filter", newJString(Filter))
  result = call_594296.call(path_594297, query_594298, nil, nil, nil)

var taskList* = Call_TaskList_594282(name: "taskList", meth: HttpMethod.HttpGet,
                                  host: "azure.local",
                                  route: "/jobs/{jobId}/tasks",
                                  validator: validate_TaskList_594283, base: "",
                                  url: url_TaskList_594284,
                                  schemes: {Scheme.Https})
type
  Call_TaskUpdate_594334 = ref object of OpenApiRestCall_593438
proc url_TaskUpdate_594336(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskUpdate_594335(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594337 = path.getOrDefault("jobId")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "jobId", valid_594337
  var valid_594338 = path.getOrDefault("taskId")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "taskId", valid_594338
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594339 = query.getOrDefault("timeout")
  valid_594339 = validateParameter(valid_594339, JInt, required = false,
                                 default = newJInt(30))
  if valid_594339 != nil:
    section.add "timeout", valid_594339
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594340 = query.getOrDefault("api-version")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "api-version", valid_594340
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
  var valid_594341 = header.getOrDefault("If-Match")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "If-Match", valid_594341
  var valid_594342 = header.getOrDefault("client-request-id")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "client-request-id", valid_594342
  var valid_594343 = header.getOrDefault("ocp-date")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "ocp-date", valid_594343
  var valid_594344 = header.getOrDefault("If-Unmodified-Since")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "If-Unmodified-Since", valid_594344
  var valid_594345 = header.getOrDefault("If-None-Match")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "If-None-Match", valid_594345
  var valid_594346 = header.getOrDefault("If-Modified-Since")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = nil)
  if valid_594346 != nil:
    section.add "If-Modified-Since", valid_594346
  var valid_594347 = header.getOrDefault("return-client-request-id")
  valid_594347 = validateParameter(valid_594347, JBool, required = false,
                                 default = newJBool(false))
  if valid_594347 != nil:
    section.add "return-client-request-id", valid_594347
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

proc call*(call_594349: Call_TaskUpdate_594334; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of the specified Task.
  ## 
  let valid = call_594349.validator(path, query, header, formData, body)
  let scheme = call_594349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594349.url(scheme.get, call_594349.host, call_594349.base,
                         call_594349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594349, url, valid)

proc call*(call_594350: Call_TaskUpdate_594334; apiVersion: string; jobId: string;
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
  var path_594351 = newJObject()
  var query_594352 = newJObject()
  var body_594353 = newJObject()
  add(query_594352, "timeout", newJInt(timeout))
  add(query_594352, "api-version", newJString(apiVersion))
  add(path_594351, "jobId", newJString(jobId))
  if taskUpdateParameter != nil:
    body_594353 = taskUpdateParameter
  add(path_594351, "taskId", newJString(taskId))
  result = call_594350.call(path_594351, query_594352, nil, nil, body_594353)

var taskUpdate* = Call_TaskUpdate_594334(name: "taskUpdate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local",
                                      route: "/jobs/{jobId}/tasks/{taskId}",
                                      validator: validate_TaskUpdate_594335,
                                      base: "", url: url_TaskUpdate_594336,
                                      schemes: {Scheme.Https})
type
  Call_TaskGet_594314 = ref object of OpenApiRestCall_593438
proc url_TaskGet_594316(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskGet_594315(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594317 = path.getOrDefault("jobId")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "jobId", valid_594317
  var valid_594318 = path.getOrDefault("taskId")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "taskId", valid_594318
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
  var valid_594319 = query.getOrDefault("timeout")
  valid_594319 = validateParameter(valid_594319, JInt, required = false,
                                 default = newJInt(30))
  if valid_594319 != nil:
    section.add "timeout", valid_594319
  var valid_594320 = query.getOrDefault("$expand")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "$expand", valid_594320
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594321 = query.getOrDefault("api-version")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "api-version", valid_594321
  var valid_594322 = query.getOrDefault("$select")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = nil)
  if valid_594322 != nil:
    section.add "$select", valid_594322
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
  var valid_594323 = header.getOrDefault("If-Match")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "If-Match", valid_594323
  var valid_594324 = header.getOrDefault("client-request-id")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "client-request-id", valid_594324
  var valid_594325 = header.getOrDefault("ocp-date")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = nil)
  if valid_594325 != nil:
    section.add "ocp-date", valid_594325
  var valid_594326 = header.getOrDefault("If-Unmodified-Since")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "If-Unmodified-Since", valid_594326
  var valid_594327 = header.getOrDefault("If-None-Match")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = nil)
  if valid_594327 != nil:
    section.add "If-None-Match", valid_594327
  var valid_594328 = header.getOrDefault("If-Modified-Since")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "If-Modified-Since", valid_594328
  var valid_594329 = header.getOrDefault("return-client-request-id")
  valid_594329 = validateParameter(valid_594329, JBool, required = false,
                                 default = newJBool(false))
  if valid_594329 != nil:
    section.add "return-client-request-id", valid_594329
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594330: Call_TaskGet_594314; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## For multi-instance Tasks, information such as affinityId, executionInfo and nodeInfo refer to the primary Task. Use the list subtasks API to retrieve information about subtasks.
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_TaskGet_594314; apiVersion: string; jobId: string;
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
  var path_594332 = newJObject()
  var query_594333 = newJObject()
  add(query_594333, "timeout", newJInt(timeout))
  add(query_594333, "$expand", newJString(Expand))
  add(query_594333, "api-version", newJString(apiVersion))
  add(path_594332, "jobId", newJString(jobId))
  add(query_594333, "$select", newJString(Select))
  add(path_594332, "taskId", newJString(taskId))
  result = call_594331.call(path_594332, query_594333, nil, nil, nil)

var taskGet* = Call_TaskGet_594314(name: "taskGet", meth: HttpMethod.HttpGet,
                                host: "azure.local",
                                route: "/jobs/{jobId}/tasks/{taskId}",
                                validator: validate_TaskGet_594315, base: "",
                                url: url_TaskGet_594316, schemes: {Scheme.Https})
type
  Call_TaskDelete_594354 = ref object of OpenApiRestCall_593438
proc url_TaskDelete_594356(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TaskDelete_594355(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594357 = path.getOrDefault("jobId")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "jobId", valid_594357
  var valid_594358 = path.getOrDefault("taskId")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "taskId", valid_594358
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594359 = query.getOrDefault("timeout")
  valid_594359 = validateParameter(valid_594359, JInt, required = false,
                                 default = newJInt(30))
  if valid_594359 != nil:
    section.add "timeout", valid_594359
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594360 = query.getOrDefault("api-version")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "api-version", valid_594360
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
  var valid_594361 = header.getOrDefault("If-Match")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "If-Match", valid_594361
  var valid_594362 = header.getOrDefault("client-request-id")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "client-request-id", valid_594362
  var valid_594363 = header.getOrDefault("ocp-date")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "ocp-date", valid_594363
  var valid_594364 = header.getOrDefault("If-Unmodified-Since")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "If-Unmodified-Since", valid_594364
  var valid_594365 = header.getOrDefault("If-None-Match")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "If-None-Match", valid_594365
  var valid_594366 = header.getOrDefault("If-Modified-Since")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "If-Modified-Since", valid_594366
  var valid_594367 = header.getOrDefault("return-client-request-id")
  valid_594367 = validateParameter(valid_594367, JBool, required = false,
                                 default = newJBool(false))
  if valid_594367 != nil:
    section.add "return-client-request-id", valid_594367
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594368: Call_TaskDelete_594354; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When a Task is deleted, all of the files in its directory on the Compute Node where it ran are also deleted (regardless of the retention time). For multi-instance Tasks, the delete Task operation applies synchronously to the primary task; subtasks and their files are then deleted asynchronously in the background.
  ## 
  let valid = call_594368.validator(path, query, header, formData, body)
  let scheme = call_594368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594368.url(scheme.get, call_594368.host, call_594368.base,
                         call_594368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594368, url, valid)

proc call*(call_594369: Call_TaskDelete_594354; apiVersion: string; jobId: string;
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
  var path_594370 = newJObject()
  var query_594371 = newJObject()
  add(query_594371, "timeout", newJInt(timeout))
  add(query_594371, "api-version", newJString(apiVersion))
  add(path_594370, "jobId", newJString(jobId))
  add(path_594370, "taskId", newJString(taskId))
  result = call_594369.call(path_594370, query_594371, nil, nil, nil)

var taskDelete* = Call_TaskDelete_594354(name: "taskDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/jobs/{jobId}/tasks/{taskId}",
                                      validator: validate_TaskDelete_594355,
                                      base: "", url: url_TaskDelete_594356,
                                      schemes: {Scheme.Https})
type
  Call_FileListFromTask_594372 = ref object of OpenApiRestCall_593438
proc url_FileListFromTask_594374(protocol: Scheme; host: string; base: string;
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

proc validate_FileListFromTask_594373(path: JsonNode; query: JsonNode;
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
  var valid_594375 = path.getOrDefault("jobId")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "jobId", valid_594375
  var valid_594376 = path.getOrDefault("taskId")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "taskId", valid_594376
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
  var valid_594377 = query.getOrDefault("timeout")
  valid_594377 = validateParameter(valid_594377, JInt, required = false,
                                 default = newJInt(30))
  if valid_594377 != nil:
    section.add "timeout", valid_594377
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594378 = query.getOrDefault("api-version")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "api-version", valid_594378
  var valid_594379 = query.getOrDefault("maxresults")
  valid_594379 = validateParameter(valid_594379, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594379 != nil:
    section.add "maxresults", valid_594379
  var valid_594380 = query.getOrDefault("$filter")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = nil)
  if valid_594380 != nil:
    section.add "$filter", valid_594380
  var valid_594381 = query.getOrDefault("recursive")
  valid_594381 = validateParameter(valid_594381, JBool, required = false, default = nil)
  if valid_594381 != nil:
    section.add "recursive", valid_594381
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594382 = header.getOrDefault("client-request-id")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "client-request-id", valid_594382
  var valid_594383 = header.getOrDefault("ocp-date")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "ocp-date", valid_594383
  var valid_594384 = header.getOrDefault("return-client-request-id")
  valid_594384 = validateParameter(valid_594384, JBool, required = false,
                                 default = newJBool(false))
  if valid_594384 != nil:
    section.add "return-client-request-id", valid_594384
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594385: Call_FileListFromTask_594372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594385.validator(path, query, header, formData, body)
  let scheme = call_594385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594385.url(scheme.get, call_594385.host, call_594385.base,
                         call_594385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594385, url, valid)

proc call*(call_594386: Call_FileListFromTask_594372; apiVersion: string;
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
  var path_594387 = newJObject()
  var query_594388 = newJObject()
  add(query_594388, "timeout", newJInt(timeout))
  add(query_594388, "api-version", newJString(apiVersion))
  add(path_594387, "jobId", newJString(jobId))
  add(query_594388, "maxresults", newJInt(maxresults))
  add(query_594388, "$filter", newJString(Filter))
  add(query_594388, "recursive", newJBool(recursive))
  add(path_594387, "taskId", newJString(taskId))
  result = call_594386.call(path_594387, query_594388, nil, nil, nil)

var fileListFromTask* = Call_FileListFromTask_594372(name: "fileListFromTask",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/files",
    validator: validate_FileListFromTask_594373, base: "",
    url: url_FileListFromTask_594374, schemes: {Scheme.Https})
type
  Call_FileGetPropertiesFromTask_594423 = ref object of OpenApiRestCall_593438
proc url_FileGetPropertiesFromTask_594425(protocol: Scheme; host: string;
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

proc validate_FileGetPropertiesFromTask_594424(path: JsonNode; query: JsonNode;
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
  var valid_594426 = path.getOrDefault("jobId")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "jobId", valid_594426
  var valid_594427 = path.getOrDefault("filePath")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "filePath", valid_594427
  var valid_594428 = path.getOrDefault("taskId")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "taskId", valid_594428
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594429 = query.getOrDefault("timeout")
  valid_594429 = validateParameter(valid_594429, JInt, required = false,
                                 default = newJInt(30))
  if valid_594429 != nil:
    section.add "timeout", valid_594429
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594430 = query.getOrDefault("api-version")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "api-version", valid_594430
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
  var valid_594431 = header.getOrDefault("client-request-id")
  valid_594431 = validateParameter(valid_594431, JString, required = false,
                                 default = nil)
  if valid_594431 != nil:
    section.add "client-request-id", valid_594431
  var valid_594432 = header.getOrDefault("ocp-date")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = nil)
  if valid_594432 != nil:
    section.add "ocp-date", valid_594432
  var valid_594433 = header.getOrDefault("If-Unmodified-Since")
  valid_594433 = validateParameter(valid_594433, JString, required = false,
                                 default = nil)
  if valid_594433 != nil:
    section.add "If-Unmodified-Since", valid_594433
  var valid_594434 = header.getOrDefault("If-Modified-Since")
  valid_594434 = validateParameter(valid_594434, JString, required = false,
                                 default = nil)
  if valid_594434 != nil:
    section.add "If-Modified-Since", valid_594434
  var valid_594435 = header.getOrDefault("return-client-request-id")
  valid_594435 = validateParameter(valid_594435, JBool, required = false,
                                 default = newJBool(false))
  if valid_594435 != nil:
    section.add "return-client-request-id", valid_594435
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594436: Call_FileGetPropertiesFromTask_594423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified Task file.
  ## 
  let valid = call_594436.validator(path, query, header, formData, body)
  let scheme = call_594436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594436.url(scheme.get, call_594436.host, call_594436.base,
                         call_594436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594436, url, valid)

proc call*(call_594437: Call_FileGetPropertiesFromTask_594423; apiVersion: string;
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
  var path_594438 = newJObject()
  var query_594439 = newJObject()
  add(query_594439, "timeout", newJInt(timeout))
  add(query_594439, "api-version", newJString(apiVersion))
  add(path_594438, "jobId", newJString(jobId))
  add(path_594438, "filePath", newJString(filePath))
  add(path_594438, "taskId", newJString(taskId))
  result = call_594437.call(path_594438, query_594439, nil, nil, nil)

var fileGetPropertiesFromTask* = Call_FileGetPropertiesFromTask_594423(
    name: "fileGetPropertiesFromTask", meth: HttpMethod.HttpHead,
    host: "azure.local", route: "/jobs/{jobId}/tasks/{taskId}/files/{filePath}",
    validator: validate_FileGetPropertiesFromTask_594424, base: "",
    url: url_FileGetPropertiesFromTask_594425, schemes: {Scheme.Https})
type
  Call_FileGetFromTask_594389 = ref object of OpenApiRestCall_593438
proc url_FileGetFromTask_594391(protocol: Scheme; host: string; base: string;
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

proc validate_FileGetFromTask_594390(path: JsonNode; query: JsonNode;
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
  var valid_594392 = path.getOrDefault("jobId")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "jobId", valid_594392
  var valid_594393 = path.getOrDefault("filePath")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "filePath", valid_594393
  var valid_594394 = path.getOrDefault("taskId")
  valid_594394 = validateParameter(valid_594394, JString, required = true,
                                 default = nil)
  if valid_594394 != nil:
    section.add "taskId", valid_594394
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594395 = query.getOrDefault("timeout")
  valid_594395 = validateParameter(valid_594395, JInt, required = false,
                                 default = newJInt(30))
  if valid_594395 != nil:
    section.add "timeout", valid_594395
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594396 = query.getOrDefault("api-version")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "api-version", valid_594396
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
  var valid_594397 = header.getOrDefault("client-request-id")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = nil)
  if valid_594397 != nil:
    section.add "client-request-id", valid_594397
  var valid_594398 = header.getOrDefault("ocp-date")
  valid_594398 = validateParameter(valid_594398, JString, required = false,
                                 default = nil)
  if valid_594398 != nil:
    section.add "ocp-date", valid_594398
  var valid_594399 = header.getOrDefault("If-Unmodified-Since")
  valid_594399 = validateParameter(valid_594399, JString, required = false,
                                 default = nil)
  if valid_594399 != nil:
    section.add "If-Unmodified-Since", valid_594399
  var valid_594400 = header.getOrDefault("ocp-range")
  valid_594400 = validateParameter(valid_594400, JString, required = false,
                                 default = nil)
  if valid_594400 != nil:
    section.add "ocp-range", valid_594400
  var valid_594401 = header.getOrDefault("If-Modified-Since")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "If-Modified-Since", valid_594401
  var valid_594402 = header.getOrDefault("return-client-request-id")
  valid_594402 = validateParameter(valid_594402, JBool, required = false,
                                 default = newJBool(false))
  if valid_594402 != nil:
    section.add "return-client-request-id", valid_594402
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594403: Call_FileGetFromTask_594389; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the content of the specified Task file.
  ## 
  let valid = call_594403.validator(path, query, header, formData, body)
  let scheme = call_594403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594403.url(scheme.get, call_594403.host, call_594403.base,
                         call_594403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594403, url, valid)

proc call*(call_594404: Call_FileGetFromTask_594389; apiVersion: string;
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
  var path_594405 = newJObject()
  var query_594406 = newJObject()
  add(query_594406, "timeout", newJInt(timeout))
  add(query_594406, "api-version", newJString(apiVersion))
  add(path_594405, "jobId", newJString(jobId))
  add(path_594405, "filePath", newJString(filePath))
  add(path_594405, "taskId", newJString(taskId))
  result = call_594404.call(path_594405, query_594406, nil, nil, nil)

var fileGetFromTask* = Call_FileGetFromTask_594389(name: "fileGetFromTask",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/files/{filePath}",
    validator: validate_FileGetFromTask_594390, base: "", url: url_FileGetFromTask_594391,
    schemes: {Scheme.Https})
type
  Call_FileDeleteFromTask_594407 = ref object of OpenApiRestCall_593438
proc url_FileDeleteFromTask_594409(protocol: Scheme; host: string; base: string;
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

proc validate_FileDeleteFromTask_594408(path: JsonNode; query: JsonNode;
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
  var valid_594410 = path.getOrDefault("jobId")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "jobId", valid_594410
  var valid_594411 = path.getOrDefault("filePath")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "filePath", valid_594411
  var valid_594412 = path.getOrDefault("taskId")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "taskId", valid_594412
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   recursive: JBool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  section = newJObject()
  var valid_594413 = query.getOrDefault("timeout")
  valid_594413 = validateParameter(valid_594413, JInt, required = false,
                                 default = newJInt(30))
  if valid_594413 != nil:
    section.add "timeout", valid_594413
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594414 = query.getOrDefault("api-version")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "api-version", valid_594414
  var valid_594415 = query.getOrDefault("recursive")
  valid_594415 = validateParameter(valid_594415, JBool, required = false, default = nil)
  if valid_594415 != nil:
    section.add "recursive", valid_594415
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594416 = header.getOrDefault("client-request-id")
  valid_594416 = validateParameter(valid_594416, JString, required = false,
                                 default = nil)
  if valid_594416 != nil:
    section.add "client-request-id", valid_594416
  var valid_594417 = header.getOrDefault("ocp-date")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "ocp-date", valid_594417
  var valid_594418 = header.getOrDefault("return-client-request-id")
  valid_594418 = validateParameter(valid_594418, JBool, required = false,
                                 default = newJBool(false))
  if valid_594418 != nil:
    section.add "return-client-request-id", valid_594418
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594419: Call_FileDeleteFromTask_594407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594419.validator(path, query, header, formData, body)
  let scheme = call_594419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594419.url(scheme.get, call_594419.host, call_594419.base,
                         call_594419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594419, url, valid)

proc call*(call_594420: Call_FileDeleteFromTask_594407; apiVersion: string;
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
  var path_594421 = newJObject()
  var query_594422 = newJObject()
  add(query_594422, "timeout", newJInt(timeout))
  add(query_594422, "api-version", newJString(apiVersion))
  add(path_594421, "jobId", newJString(jobId))
  add(path_594421, "filePath", newJString(filePath))
  add(query_594422, "recursive", newJBool(recursive))
  add(path_594421, "taskId", newJString(taskId))
  result = call_594420.call(path_594421, query_594422, nil, nil, nil)

var fileDeleteFromTask* = Call_FileDeleteFromTask_594407(
    name: "fileDeleteFromTask", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/files/{filePath}",
    validator: validate_FileDeleteFromTask_594408, base: "",
    url: url_FileDeleteFromTask_594409, schemes: {Scheme.Https})
type
  Call_TaskReactivate_594440 = ref object of OpenApiRestCall_593438
proc url_TaskReactivate_594442(protocol: Scheme; host: string; base: string;
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

proc validate_TaskReactivate_594441(path: JsonNode; query: JsonNode;
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
  var valid_594443 = path.getOrDefault("jobId")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "jobId", valid_594443
  var valid_594444 = path.getOrDefault("taskId")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "taskId", valid_594444
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594445 = query.getOrDefault("timeout")
  valid_594445 = validateParameter(valid_594445, JInt, required = false,
                                 default = newJInt(30))
  if valid_594445 != nil:
    section.add "timeout", valid_594445
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594446 = query.getOrDefault("api-version")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "api-version", valid_594446
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
  var valid_594447 = header.getOrDefault("If-Match")
  valid_594447 = validateParameter(valid_594447, JString, required = false,
                                 default = nil)
  if valid_594447 != nil:
    section.add "If-Match", valid_594447
  var valid_594448 = header.getOrDefault("client-request-id")
  valid_594448 = validateParameter(valid_594448, JString, required = false,
                                 default = nil)
  if valid_594448 != nil:
    section.add "client-request-id", valid_594448
  var valid_594449 = header.getOrDefault("ocp-date")
  valid_594449 = validateParameter(valid_594449, JString, required = false,
                                 default = nil)
  if valid_594449 != nil:
    section.add "ocp-date", valid_594449
  var valid_594450 = header.getOrDefault("If-Unmodified-Since")
  valid_594450 = validateParameter(valid_594450, JString, required = false,
                                 default = nil)
  if valid_594450 != nil:
    section.add "If-Unmodified-Since", valid_594450
  var valid_594451 = header.getOrDefault("If-None-Match")
  valid_594451 = validateParameter(valid_594451, JString, required = false,
                                 default = nil)
  if valid_594451 != nil:
    section.add "If-None-Match", valid_594451
  var valid_594452 = header.getOrDefault("If-Modified-Since")
  valid_594452 = validateParameter(valid_594452, JString, required = false,
                                 default = nil)
  if valid_594452 != nil:
    section.add "If-Modified-Since", valid_594452
  var valid_594453 = header.getOrDefault("return-client-request-id")
  valid_594453 = validateParameter(valid_594453, JBool, required = false,
                                 default = newJBool(false))
  if valid_594453 != nil:
    section.add "return-client-request-id", valid_594453
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594454: Call_TaskReactivate_594440; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reactivation makes a Task eligible to be retried again up to its maximum retry count. The Task's state is changed to active. As the Task is no longer in the completed state, any previous exit code or failure information is no longer available after reactivation. Each time a Task is reactivated, its retry count is reset to 0. Reactivation will fail for Tasks that are not completed or that previously completed successfully (with an exit code of 0). Additionally, it will fail if the Job has completed (or is terminating or deleting).
  ## 
  let valid = call_594454.validator(path, query, header, formData, body)
  let scheme = call_594454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594454.url(scheme.get, call_594454.host, call_594454.base,
                         call_594454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594454, url, valid)

proc call*(call_594455: Call_TaskReactivate_594440; apiVersion: string;
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
  var path_594456 = newJObject()
  var query_594457 = newJObject()
  add(query_594457, "timeout", newJInt(timeout))
  add(query_594457, "api-version", newJString(apiVersion))
  add(path_594456, "jobId", newJString(jobId))
  add(path_594456, "taskId", newJString(taskId))
  result = call_594455.call(path_594456, query_594457, nil, nil, nil)

var taskReactivate* = Call_TaskReactivate_594440(name: "taskReactivate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/reactivate",
    validator: validate_TaskReactivate_594441, base: "", url: url_TaskReactivate_594442,
    schemes: {Scheme.Https})
type
  Call_TaskListSubtasks_594458 = ref object of OpenApiRestCall_593438
proc url_TaskListSubtasks_594460(protocol: Scheme; host: string; base: string;
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

proc validate_TaskListSubtasks_594459(path: JsonNode; query: JsonNode;
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
  var valid_594461 = path.getOrDefault("jobId")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "jobId", valid_594461
  var valid_594462 = path.getOrDefault("taskId")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "taskId", valid_594462
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_594463 = query.getOrDefault("timeout")
  valid_594463 = validateParameter(valid_594463, JInt, required = false,
                                 default = newJInt(30))
  if valid_594463 != nil:
    section.add "timeout", valid_594463
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594464 = query.getOrDefault("api-version")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "api-version", valid_594464
  var valid_594465 = query.getOrDefault("$select")
  valid_594465 = validateParameter(valid_594465, JString, required = false,
                                 default = nil)
  if valid_594465 != nil:
    section.add "$select", valid_594465
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594466 = header.getOrDefault("client-request-id")
  valid_594466 = validateParameter(valid_594466, JString, required = false,
                                 default = nil)
  if valid_594466 != nil:
    section.add "client-request-id", valid_594466
  var valid_594467 = header.getOrDefault("ocp-date")
  valid_594467 = validateParameter(valid_594467, JString, required = false,
                                 default = nil)
  if valid_594467 != nil:
    section.add "ocp-date", valid_594467
  var valid_594468 = header.getOrDefault("return-client-request-id")
  valid_594468 = validateParameter(valid_594468, JBool, required = false,
                                 default = newJBool(false))
  if valid_594468 != nil:
    section.add "return-client-request-id", valid_594468
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594469: Call_TaskListSubtasks_594458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If the Task is not a multi-instance Task then this returns an empty collection.
  ## 
  let valid = call_594469.validator(path, query, header, formData, body)
  let scheme = call_594469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594469.url(scheme.get, call_594469.host, call_594469.base,
                         call_594469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594469, url, valid)

proc call*(call_594470: Call_TaskListSubtasks_594458; apiVersion: string;
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
  var path_594471 = newJObject()
  var query_594472 = newJObject()
  add(query_594472, "timeout", newJInt(timeout))
  add(query_594472, "api-version", newJString(apiVersion))
  add(path_594471, "jobId", newJString(jobId))
  add(query_594472, "$select", newJString(Select))
  add(path_594471, "taskId", newJString(taskId))
  result = call_594470.call(path_594471, query_594472, nil, nil, nil)

var taskListSubtasks* = Call_TaskListSubtasks_594458(name: "taskListSubtasks",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/subtasksinfo",
    validator: validate_TaskListSubtasks_594459, base: "",
    url: url_TaskListSubtasks_594460, schemes: {Scheme.Https})
type
  Call_TaskTerminate_594473 = ref object of OpenApiRestCall_593438
proc url_TaskTerminate_594475(protocol: Scheme; host: string; base: string;
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

proc validate_TaskTerminate_594474(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594476 = path.getOrDefault("jobId")
  valid_594476 = validateParameter(valid_594476, JString, required = true,
                                 default = nil)
  if valid_594476 != nil:
    section.add "jobId", valid_594476
  var valid_594477 = path.getOrDefault("taskId")
  valid_594477 = validateParameter(valid_594477, JString, required = true,
                                 default = nil)
  if valid_594477 != nil:
    section.add "taskId", valid_594477
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594478 = query.getOrDefault("timeout")
  valid_594478 = validateParameter(valid_594478, JInt, required = false,
                                 default = newJInt(30))
  if valid_594478 != nil:
    section.add "timeout", valid_594478
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594479 = query.getOrDefault("api-version")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "api-version", valid_594479
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
  var valid_594480 = header.getOrDefault("If-Match")
  valid_594480 = validateParameter(valid_594480, JString, required = false,
                                 default = nil)
  if valid_594480 != nil:
    section.add "If-Match", valid_594480
  var valid_594481 = header.getOrDefault("client-request-id")
  valid_594481 = validateParameter(valid_594481, JString, required = false,
                                 default = nil)
  if valid_594481 != nil:
    section.add "client-request-id", valid_594481
  var valid_594482 = header.getOrDefault("ocp-date")
  valid_594482 = validateParameter(valid_594482, JString, required = false,
                                 default = nil)
  if valid_594482 != nil:
    section.add "ocp-date", valid_594482
  var valid_594483 = header.getOrDefault("If-Unmodified-Since")
  valid_594483 = validateParameter(valid_594483, JString, required = false,
                                 default = nil)
  if valid_594483 != nil:
    section.add "If-Unmodified-Since", valid_594483
  var valid_594484 = header.getOrDefault("If-None-Match")
  valid_594484 = validateParameter(valid_594484, JString, required = false,
                                 default = nil)
  if valid_594484 != nil:
    section.add "If-None-Match", valid_594484
  var valid_594485 = header.getOrDefault("If-Modified-Since")
  valid_594485 = validateParameter(valid_594485, JString, required = false,
                                 default = nil)
  if valid_594485 != nil:
    section.add "If-Modified-Since", valid_594485
  var valid_594486 = header.getOrDefault("return-client-request-id")
  valid_594486 = validateParameter(valid_594486, JBool, required = false,
                                 default = newJBool(false))
  if valid_594486 != nil:
    section.add "return-client-request-id", valid_594486
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594487: Call_TaskTerminate_594473; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When the Task has been terminated, it moves to the completed state. For multi-instance Tasks, the terminate Task operation applies synchronously to the primary task; subtasks are then terminated asynchronously in the background.
  ## 
  let valid = call_594487.validator(path, query, header, formData, body)
  let scheme = call_594487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594487.url(scheme.get, call_594487.host, call_594487.base,
                         call_594487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594487, url, valid)

proc call*(call_594488: Call_TaskTerminate_594473; apiVersion: string; jobId: string;
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
  var path_594489 = newJObject()
  var query_594490 = newJObject()
  add(query_594490, "timeout", newJInt(timeout))
  add(query_594490, "api-version", newJString(apiVersion))
  add(path_594489, "jobId", newJString(jobId))
  add(path_594489, "taskId", newJString(taskId))
  result = call_594488.call(path_594489, query_594490, nil, nil, nil)

var taskTerminate* = Call_TaskTerminate_594473(name: "taskTerminate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/tasks/{taskId}/terminate",
    validator: validate_TaskTerminate_594474, base: "", url: url_TaskTerminate_594475,
    schemes: {Scheme.Https})
type
  Call_JobTerminate_594491 = ref object of OpenApiRestCall_593438
proc url_JobTerminate_594493(protocol: Scheme; host: string; base: string;
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

proc validate_JobTerminate_594492(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594494 = path.getOrDefault("jobId")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "jobId", valid_594494
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594495 = query.getOrDefault("timeout")
  valid_594495 = validateParameter(valid_594495, JInt, required = false,
                                 default = newJInt(30))
  if valid_594495 != nil:
    section.add "timeout", valid_594495
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594496 = query.getOrDefault("api-version")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "api-version", valid_594496
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
  var valid_594497 = header.getOrDefault("If-Match")
  valid_594497 = validateParameter(valid_594497, JString, required = false,
                                 default = nil)
  if valid_594497 != nil:
    section.add "If-Match", valid_594497
  var valid_594498 = header.getOrDefault("client-request-id")
  valid_594498 = validateParameter(valid_594498, JString, required = false,
                                 default = nil)
  if valid_594498 != nil:
    section.add "client-request-id", valid_594498
  var valid_594499 = header.getOrDefault("ocp-date")
  valid_594499 = validateParameter(valid_594499, JString, required = false,
                                 default = nil)
  if valid_594499 != nil:
    section.add "ocp-date", valid_594499
  var valid_594500 = header.getOrDefault("If-Unmodified-Since")
  valid_594500 = validateParameter(valid_594500, JString, required = false,
                                 default = nil)
  if valid_594500 != nil:
    section.add "If-Unmodified-Since", valid_594500
  var valid_594501 = header.getOrDefault("If-None-Match")
  valid_594501 = validateParameter(valid_594501, JString, required = false,
                                 default = nil)
  if valid_594501 != nil:
    section.add "If-None-Match", valid_594501
  var valid_594502 = header.getOrDefault("If-Modified-Since")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = nil)
  if valid_594502 != nil:
    section.add "If-Modified-Since", valid_594502
  var valid_594503 = header.getOrDefault("return-client-request-id")
  valid_594503 = validateParameter(valid_594503, JBool, required = false,
                                 default = newJBool(false))
  if valid_594503 != nil:
    section.add "return-client-request-id", valid_594503
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobTerminateParameter: JObject
  ##                        : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594505: Call_JobTerminate_594491; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When a Terminate Job request is received, the Batch service sets the Job to the terminating state. The Batch service then terminates any running Tasks associated with the Job and runs any required Job release Tasks. Then the Job moves into the completed state. If there are any Tasks in the Job in the active state, they will remain in the active state. Once a Job is terminated, new Tasks cannot be added and any remaining active Tasks will not be scheduled.
  ## 
  let valid = call_594505.validator(path, query, header, formData, body)
  let scheme = call_594505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594505.url(scheme.get, call_594505.host, call_594505.base,
                         call_594505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594505, url, valid)

proc call*(call_594506: Call_JobTerminate_594491; apiVersion: string; jobId: string;
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
  var path_594507 = newJObject()
  var query_594508 = newJObject()
  var body_594509 = newJObject()
  add(query_594508, "timeout", newJInt(timeout))
  add(query_594508, "api-version", newJString(apiVersion))
  add(path_594507, "jobId", newJString(jobId))
  if jobTerminateParameter != nil:
    body_594509 = jobTerminateParameter
  result = call_594506.call(path_594507, query_594508, nil, nil, body_594509)

var jobTerminate* = Call_JobTerminate_594491(name: "jobTerminate",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobs/{jobId}/terminate", validator: validate_JobTerminate_594492,
    base: "", url: url_JobTerminate_594493, schemes: {Scheme.Https})
type
  Call_JobScheduleAdd_594525 = ref object of OpenApiRestCall_593438
proc url_JobScheduleAdd_594527(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobScheduleAdd_594526(path: JsonNode; query: JsonNode;
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
  var valid_594528 = query.getOrDefault("timeout")
  valid_594528 = validateParameter(valid_594528, JInt, required = false,
                                 default = newJInt(30))
  if valid_594528 != nil:
    section.add "timeout", valid_594528
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594529 = query.getOrDefault("api-version")
  valid_594529 = validateParameter(valid_594529, JString, required = true,
                                 default = nil)
  if valid_594529 != nil:
    section.add "api-version", valid_594529
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594530 = header.getOrDefault("client-request-id")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = nil)
  if valid_594530 != nil:
    section.add "client-request-id", valid_594530
  var valid_594531 = header.getOrDefault("ocp-date")
  valid_594531 = validateParameter(valid_594531, JString, required = false,
                                 default = nil)
  if valid_594531 != nil:
    section.add "ocp-date", valid_594531
  var valid_594532 = header.getOrDefault("return-client-request-id")
  valid_594532 = validateParameter(valid_594532, JBool, required = false,
                                 default = newJBool(false))
  if valid_594532 != nil:
    section.add "return-client-request-id", valid_594532
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

proc call*(call_594534: Call_JobScheduleAdd_594525; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594534.validator(path, query, header, formData, body)
  let scheme = call_594534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594534.url(scheme.get, call_594534.host, call_594534.base,
                         call_594534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594534, url, valid)

proc call*(call_594535: Call_JobScheduleAdd_594525; apiVersion: string;
          cloudJobSchedule: JsonNode; timeout: int = 30): Recallable =
  ## jobScheduleAdd
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   cloudJobSchedule: JObject (required)
  ##                   : The Job Schedule to be added.
  var query_594536 = newJObject()
  var body_594537 = newJObject()
  add(query_594536, "timeout", newJInt(timeout))
  add(query_594536, "api-version", newJString(apiVersion))
  if cloudJobSchedule != nil:
    body_594537 = cloudJobSchedule
  result = call_594535.call(nil, query_594536, nil, nil, body_594537)

var jobScheduleAdd* = Call_JobScheduleAdd_594525(name: "jobScheduleAdd",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/jobschedules",
    validator: validate_JobScheduleAdd_594526, base: "", url: url_JobScheduleAdd_594527,
    schemes: {Scheme.Https})
type
  Call_JobScheduleList_594510 = ref object of OpenApiRestCall_593438
proc url_JobScheduleList_594512(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobScheduleList_594511(path: JsonNode; query: JsonNode;
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
  var valid_594513 = query.getOrDefault("timeout")
  valid_594513 = validateParameter(valid_594513, JInt, required = false,
                                 default = newJInt(30))
  if valid_594513 != nil:
    section.add "timeout", valid_594513
  var valid_594514 = query.getOrDefault("$expand")
  valid_594514 = validateParameter(valid_594514, JString, required = false,
                                 default = nil)
  if valid_594514 != nil:
    section.add "$expand", valid_594514
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594515 = query.getOrDefault("api-version")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = nil)
  if valid_594515 != nil:
    section.add "api-version", valid_594515
  var valid_594516 = query.getOrDefault("maxresults")
  valid_594516 = validateParameter(valid_594516, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594516 != nil:
    section.add "maxresults", valid_594516
  var valid_594517 = query.getOrDefault("$select")
  valid_594517 = validateParameter(valid_594517, JString, required = false,
                                 default = nil)
  if valid_594517 != nil:
    section.add "$select", valid_594517
  var valid_594518 = query.getOrDefault("$filter")
  valid_594518 = validateParameter(valid_594518, JString, required = false,
                                 default = nil)
  if valid_594518 != nil:
    section.add "$filter", valid_594518
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594519 = header.getOrDefault("client-request-id")
  valid_594519 = validateParameter(valid_594519, JString, required = false,
                                 default = nil)
  if valid_594519 != nil:
    section.add "client-request-id", valid_594519
  var valid_594520 = header.getOrDefault("ocp-date")
  valid_594520 = validateParameter(valid_594520, JString, required = false,
                                 default = nil)
  if valid_594520 != nil:
    section.add "ocp-date", valid_594520
  var valid_594521 = header.getOrDefault("return-client-request-id")
  valid_594521 = validateParameter(valid_594521, JBool, required = false,
                                 default = newJBool(false))
  if valid_594521 != nil:
    section.add "return-client-request-id", valid_594521
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594522: Call_JobScheduleList_594510; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594522.validator(path, query, header, formData, body)
  let scheme = call_594522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594522.url(scheme.get, call_594522.host, call_594522.base,
                         call_594522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594522, url, valid)

proc call*(call_594523: Call_JobScheduleList_594510; apiVersion: string;
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
  var query_594524 = newJObject()
  add(query_594524, "timeout", newJInt(timeout))
  add(query_594524, "$expand", newJString(Expand))
  add(query_594524, "api-version", newJString(apiVersion))
  add(query_594524, "maxresults", newJInt(maxresults))
  add(query_594524, "$select", newJString(Select))
  add(query_594524, "$filter", newJString(Filter))
  result = call_594523.call(nil, query_594524, nil, nil, nil)

var jobScheduleList* = Call_JobScheduleList_594510(name: "jobScheduleList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/jobschedules",
    validator: validate_JobScheduleList_594511, base: "", url: url_JobScheduleList_594512,
    schemes: {Scheme.Https})
type
  Call_JobScheduleUpdate_594557 = ref object of OpenApiRestCall_593438
proc url_JobScheduleUpdate_594559(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleUpdate_594558(path: JsonNode; query: JsonNode;
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
  var valid_594560 = path.getOrDefault("jobScheduleId")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "jobScheduleId", valid_594560
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594561 = query.getOrDefault("timeout")
  valid_594561 = validateParameter(valid_594561, JInt, required = false,
                                 default = newJInt(30))
  if valid_594561 != nil:
    section.add "timeout", valid_594561
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594562 = query.getOrDefault("api-version")
  valid_594562 = validateParameter(valid_594562, JString, required = true,
                                 default = nil)
  if valid_594562 != nil:
    section.add "api-version", valid_594562
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
  var valid_594563 = header.getOrDefault("If-Match")
  valid_594563 = validateParameter(valid_594563, JString, required = false,
                                 default = nil)
  if valid_594563 != nil:
    section.add "If-Match", valid_594563
  var valid_594564 = header.getOrDefault("client-request-id")
  valid_594564 = validateParameter(valid_594564, JString, required = false,
                                 default = nil)
  if valid_594564 != nil:
    section.add "client-request-id", valid_594564
  var valid_594565 = header.getOrDefault("ocp-date")
  valid_594565 = validateParameter(valid_594565, JString, required = false,
                                 default = nil)
  if valid_594565 != nil:
    section.add "ocp-date", valid_594565
  var valid_594566 = header.getOrDefault("If-Unmodified-Since")
  valid_594566 = validateParameter(valid_594566, JString, required = false,
                                 default = nil)
  if valid_594566 != nil:
    section.add "If-Unmodified-Since", valid_594566
  var valid_594567 = header.getOrDefault("If-None-Match")
  valid_594567 = validateParameter(valid_594567, JString, required = false,
                                 default = nil)
  if valid_594567 != nil:
    section.add "If-None-Match", valid_594567
  var valid_594568 = header.getOrDefault("If-Modified-Since")
  valid_594568 = validateParameter(valid_594568, JString, required = false,
                                 default = nil)
  if valid_594568 != nil:
    section.add "If-Modified-Since", valid_594568
  var valid_594569 = header.getOrDefault("return-client-request-id")
  valid_594569 = validateParameter(valid_594569, JBool, required = false,
                                 default = newJBool(false))
  if valid_594569 != nil:
    section.add "return-client-request-id", valid_594569
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

proc call*(call_594571: Call_JobScheduleUpdate_594557; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This fully replaces all the updatable properties of the Job Schedule. For example, if the schedule property is not specified with this request, then the Batch service will remove the existing schedule. Changes to a Job Schedule only impact Jobs created by the schedule after the update has taken place; currently running Jobs are unaffected.
  ## 
  let valid = call_594571.validator(path, query, header, formData, body)
  let scheme = call_594571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594571.url(scheme.get, call_594571.host, call_594571.base,
                         call_594571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594571, url, valid)

proc call*(call_594572: Call_JobScheduleUpdate_594557; jobScheduleId: string;
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
  var path_594573 = newJObject()
  var query_594574 = newJObject()
  var body_594575 = newJObject()
  add(query_594574, "timeout", newJInt(timeout))
  add(path_594573, "jobScheduleId", newJString(jobScheduleId))
  add(query_594574, "api-version", newJString(apiVersion))
  if jobScheduleUpdateParameter != nil:
    body_594575 = jobScheduleUpdateParameter
  result = call_594572.call(path_594573, query_594574, nil, nil, body_594575)

var jobScheduleUpdate* = Call_JobScheduleUpdate_594557(name: "jobScheduleUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleUpdate_594558,
    base: "", url: url_JobScheduleUpdate_594559, schemes: {Scheme.Https})
type
  Call_JobScheduleExists_594593 = ref object of OpenApiRestCall_593438
proc url_JobScheduleExists_594595(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleExists_594594(path: JsonNode; query: JsonNode;
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
  var valid_594596 = path.getOrDefault("jobScheduleId")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "jobScheduleId", valid_594596
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594597 = query.getOrDefault("timeout")
  valid_594597 = validateParameter(valid_594597, JInt, required = false,
                                 default = newJInt(30))
  if valid_594597 != nil:
    section.add "timeout", valid_594597
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594598 = query.getOrDefault("api-version")
  valid_594598 = validateParameter(valid_594598, JString, required = true,
                                 default = nil)
  if valid_594598 != nil:
    section.add "api-version", valid_594598
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
  var valid_594599 = header.getOrDefault("If-Match")
  valid_594599 = validateParameter(valid_594599, JString, required = false,
                                 default = nil)
  if valid_594599 != nil:
    section.add "If-Match", valid_594599
  var valid_594600 = header.getOrDefault("client-request-id")
  valid_594600 = validateParameter(valid_594600, JString, required = false,
                                 default = nil)
  if valid_594600 != nil:
    section.add "client-request-id", valid_594600
  var valid_594601 = header.getOrDefault("ocp-date")
  valid_594601 = validateParameter(valid_594601, JString, required = false,
                                 default = nil)
  if valid_594601 != nil:
    section.add "ocp-date", valid_594601
  var valid_594602 = header.getOrDefault("If-Unmodified-Since")
  valid_594602 = validateParameter(valid_594602, JString, required = false,
                                 default = nil)
  if valid_594602 != nil:
    section.add "If-Unmodified-Since", valid_594602
  var valid_594603 = header.getOrDefault("If-None-Match")
  valid_594603 = validateParameter(valid_594603, JString, required = false,
                                 default = nil)
  if valid_594603 != nil:
    section.add "If-None-Match", valid_594603
  var valid_594604 = header.getOrDefault("If-Modified-Since")
  valid_594604 = validateParameter(valid_594604, JString, required = false,
                                 default = nil)
  if valid_594604 != nil:
    section.add "If-Modified-Since", valid_594604
  var valid_594605 = header.getOrDefault("return-client-request-id")
  valid_594605 = validateParameter(valid_594605, JBool, required = false,
                                 default = newJBool(false))
  if valid_594605 != nil:
    section.add "return-client-request-id", valid_594605
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594606: Call_JobScheduleExists_594593; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594606.validator(path, query, header, formData, body)
  let scheme = call_594606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594606.url(scheme.get, call_594606.host, call_594606.base,
                         call_594606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594606, url, valid)

proc call*(call_594607: Call_JobScheduleExists_594593; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleExists
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule which you want to check.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_594608 = newJObject()
  var query_594609 = newJObject()
  add(query_594609, "timeout", newJInt(timeout))
  add(path_594608, "jobScheduleId", newJString(jobScheduleId))
  add(query_594609, "api-version", newJString(apiVersion))
  result = call_594607.call(path_594608, query_594609, nil, nil, nil)

var jobScheduleExists* = Call_JobScheduleExists_594593(name: "jobScheduleExists",
    meth: HttpMethod.HttpHead, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleExists_594594,
    base: "", url: url_JobScheduleExists_594595, schemes: {Scheme.Https})
type
  Call_JobScheduleGet_594538 = ref object of OpenApiRestCall_593438
proc url_JobScheduleGet_594540(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleGet_594539(path: JsonNode; query: JsonNode;
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
  var valid_594541 = path.getOrDefault("jobScheduleId")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "jobScheduleId", valid_594541
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
  var valid_594542 = query.getOrDefault("timeout")
  valid_594542 = validateParameter(valid_594542, JInt, required = false,
                                 default = newJInt(30))
  if valid_594542 != nil:
    section.add "timeout", valid_594542
  var valid_594543 = query.getOrDefault("$expand")
  valid_594543 = validateParameter(valid_594543, JString, required = false,
                                 default = nil)
  if valid_594543 != nil:
    section.add "$expand", valid_594543
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594544 = query.getOrDefault("api-version")
  valid_594544 = validateParameter(valid_594544, JString, required = true,
                                 default = nil)
  if valid_594544 != nil:
    section.add "api-version", valid_594544
  var valid_594545 = query.getOrDefault("$select")
  valid_594545 = validateParameter(valid_594545, JString, required = false,
                                 default = nil)
  if valid_594545 != nil:
    section.add "$select", valid_594545
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
  var valid_594546 = header.getOrDefault("If-Match")
  valid_594546 = validateParameter(valid_594546, JString, required = false,
                                 default = nil)
  if valid_594546 != nil:
    section.add "If-Match", valid_594546
  var valid_594547 = header.getOrDefault("client-request-id")
  valid_594547 = validateParameter(valid_594547, JString, required = false,
                                 default = nil)
  if valid_594547 != nil:
    section.add "client-request-id", valid_594547
  var valid_594548 = header.getOrDefault("ocp-date")
  valid_594548 = validateParameter(valid_594548, JString, required = false,
                                 default = nil)
  if valid_594548 != nil:
    section.add "ocp-date", valid_594548
  var valid_594549 = header.getOrDefault("If-Unmodified-Since")
  valid_594549 = validateParameter(valid_594549, JString, required = false,
                                 default = nil)
  if valid_594549 != nil:
    section.add "If-Unmodified-Since", valid_594549
  var valid_594550 = header.getOrDefault("If-None-Match")
  valid_594550 = validateParameter(valid_594550, JString, required = false,
                                 default = nil)
  if valid_594550 != nil:
    section.add "If-None-Match", valid_594550
  var valid_594551 = header.getOrDefault("If-Modified-Since")
  valid_594551 = validateParameter(valid_594551, JString, required = false,
                                 default = nil)
  if valid_594551 != nil:
    section.add "If-Modified-Since", valid_594551
  var valid_594552 = header.getOrDefault("return-client-request-id")
  valid_594552 = validateParameter(valid_594552, JBool, required = false,
                                 default = newJBool(false))
  if valid_594552 != nil:
    section.add "return-client-request-id", valid_594552
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594553: Call_JobScheduleGet_594538; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Job Schedule.
  ## 
  let valid = call_594553.validator(path, query, header, formData, body)
  let scheme = call_594553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594553.url(scheme.get, call_594553.host, call_594553.base,
                         call_594553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594553, url, valid)

proc call*(call_594554: Call_JobScheduleGet_594538; jobScheduleId: string;
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
  var path_594555 = newJObject()
  var query_594556 = newJObject()
  add(query_594556, "timeout", newJInt(timeout))
  add(path_594555, "jobScheduleId", newJString(jobScheduleId))
  add(query_594556, "$expand", newJString(Expand))
  add(query_594556, "api-version", newJString(apiVersion))
  add(query_594556, "$select", newJString(Select))
  result = call_594554.call(path_594555, query_594556, nil, nil, nil)

var jobScheduleGet* = Call_JobScheduleGet_594538(name: "jobScheduleGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleGet_594539,
    base: "", url: url_JobScheduleGet_594540, schemes: {Scheme.Https})
type
  Call_JobSchedulePatch_594610 = ref object of OpenApiRestCall_593438
proc url_JobSchedulePatch_594612(protocol: Scheme; host: string; base: string;
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

proc validate_JobSchedulePatch_594611(path: JsonNode; query: JsonNode;
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
  var valid_594613 = path.getOrDefault("jobScheduleId")
  valid_594613 = validateParameter(valid_594613, JString, required = true,
                                 default = nil)
  if valid_594613 != nil:
    section.add "jobScheduleId", valid_594613
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594614 = query.getOrDefault("timeout")
  valid_594614 = validateParameter(valid_594614, JInt, required = false,
                                 default = newJInt(30))
  if valid_594614 != nil:
    section.add "timeout", valid_594614
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594615 = query.getOrDefault("api-version")
  valid_594615 = validateParameter(valid_594615, JString, required = true,
                                 default = nil)
  if valid_594615 != nil:
    section.add "api-version", valid_594615
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
  var valid_594616 = header.getOrDefault("If-Match")
  valid_594616 = validateParameter(valid_594616, JString, required = false,
                                 default = nil)
  if valid_594616 != nil:
    section.add "If-Match", valid_594616
  var valid_594617 = header.getOrDefault("client-request-id")
  valid_594617 = validateParameter(valid_594617, JString, required = false,
                                 default = nil)
  if valid_594617 != nil:
    section.add "client-request-id", valid_594617
  var valid_594618 = header.getOrDefault("ocp-date")
  valid_594618 = validateParameter(valid_594618, JString, required = false,
                                 default = nil)
  if valid_594618 != nil:
    section.add "ocp-date", valid_594618
  var valid_594619 = header.getOrDefault("If-Unmodified-Since")
  valid_594619 = validateParameter(valid_594619, JString, required = false,
                                 default = nil)
  if valid_594619 != nil:
    section.add "If-Unmodified-Since", valid_594619
  var valid_594620 = header.getOrDefault("If-None-Match")
  valid_594620 = validateParameter(valid_594620, JString, required = false,
                                 default = nil)
  if valid_594620 != nil:
    section.add "If-None-Match", valid_594620
  var valid_594621 = header.getOrDefault("If-Modified-Since")
  valid_594621 = validateParameter(valid_594621, JString, required = false,
                                 default = nil)
  if valid_594621 != nil:
    section.add "If-Modified-Since", valid_594621
  var valid_594622 = header.getOrDefault("return-client-request-id")
  valid_594622 = validateParameter(valid_594622, JBool, required = false,
                                 default = newJBool(false))
  if valid_594622 != nil:
    section.add "return-client-request-id", valid_594622
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

proc call*(call_594624: Call_JobSchedulePatch_594610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This replaces only the Job Schedule properties specified in the request. For example, if the schedule property is not specified with this request, then the Batch service will keep the existing schedule. Changes to a Job Schedule only impact Jobs created by the schedule after the update has taken place; currently running Jobs are unaffected.
  ## 
  let valid = call_594624.validator(path, query, header, formData, body)
  let scheme = call_594624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594624.url(scheme.get, call_594624.host, call_594624.base,
                         call_594624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594624, url, valid)

proc call*(call_594625: Call_JobSchedulePatch_594610; jobScheduleId: string;
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
  var path_594626 = newJObject()
  var query_594627 = newJObject()
  var body_594628 = newJObject()
  add(query_594627, "timeout", newJInt(timeout))
  add(path_594626, "jobScheduleId", newJString(jobScheduleId))
  add(query_594627, "api-version", newJString(apiVersion))
  if jobSchedulePatchParameter != nil:
    body_594628 = jobSchedulePatchParameter
  result = call_594625.call(path_594626, query_594627, nil, nil, body_594628)

var jobSchedulePatch* = Call_JobSchedulePatch_594610(name: "jobSchedulePatch",
    meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobSchedulePatch_594611,
    base: "", url: url_JobSchedulePatch_594612, schemes: {Scheme.Https})
type
  Call_JobScheduleDelete_594576 = ref object of OpenApiRestCall_593438
proc url_JobScheduleDelete_594578(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleDelete_594577(path: JsonNode; query: JsonNode;
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
  var valid_594579 = path.getOrDefault("jobScheduleId")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "jobScheduleId", valid_594579
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594580 = query.getOrDefault("timeout")
  valid_594580 = validateParameter(valid_594580, JInt, required = false,
                                 default = newJInt(30))
  if valid_594580 != nil:
    section.add "timeout", valid_594580
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594581 = query.getOrDefault("api-version")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "api-version", valid_594581
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
  var valid_594582 = header.getOrDefault("If-Match")
  valid_594582 = validateParameter(valid_594582, JString, required = false,
                                 default = nil)
  if valid_594582 != nil:
    section.add "If-Match", valid_594582
  var valid_594583 = header.getOrDefault("client-request-id")
  valid_594583 = validateParameter(valid_594583, JString, required = false,
                                 default = nil)
  if valid_594583 != nil:
    section.add "client-request-id", valid_594583
  var valid_594584 = header.getOrDefault("ocp-date")
  valid_594584 = validateParameter(valid_594584, JString, required = false,
                                 default = nil)
  if valid_594584 != nil:
    section.add "ocp-date", valid_594584
  var valid_594585 = header.getOrDefault("If-Unmodified-Since")
  valid_594585 = validateParameter(valid_594585, JString, required = false,
                                 default = nil)
  if valid_594585 != nil:
    section.add "If-Unmodified-Since", valid_594585
  var valid_594586 = header.getOrDefault("If-None-Match")
  valid_594586 = validateParameter(valid_594586, JString, required = false,
                                 default = nil)
  if valid_594586 != nil:
    section.add "If-None-Match", valid_594586
  var valid_594587 = header.getOrDefault("If-Modified-Since")
  valid_594587 = validateParameter(valid_594587, JString, required = false,
                                 default = nil)
  if valid_594587 != nil:
    section.add "If-Modified-Since", valid_594587
  var valid_594588 = header.getOrDefault("return-client-request-id")
  valid_594588 = validateParameter(valid_594588, JBool, required = false,
                                 default = newJBool(false))
  if valid_594588 != nil:
    section.add "return-client-request-id", valid_594588
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594589: Call_JobScheduleDelete_594576; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you delete a Job Schedule, this also deletes all Jobs and Tasks under that schedule. When Tasks are deleted, all the files in their working directories on the Compute Nodes are also deleted (the retention period is ignored). The Job Schedule statistics are no longer accessible once the Job Schedule is deleted, though they are still counted towards Account lifetime statistics.
  ## 
  let valid = call_594589.validator(path, query, header, formData, body)
  let scheme = call_594589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594589.url(scheme.get, call_594589.host, call_594589.base,
                         call_594589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594589, url, valid)

proc call*(call_594590: Call_JobScheduleDelete_594576; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleDelete
  ## When you delete a Job Schedule, this also deletes all Jobs and Tasks under that schedule. When Tasks are deleted, all the files in their working directories on the Compute Nodes are also deleted (the retention period is ignored). The Job Schedule statistics are no longer accessible once the Job Schedule is deleted, though they are still counted towards Account lifetime statistics.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule to delete.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_594591 = newJObject()
  var query_594592 = newJObject()
  add(query_594592, "timeout", newJInt(timeout))
  add(path_594591, "jobScheduleId", newJString(jobScheduleId))
  add(query_594592, "api-version", newJString(apiVersion))
  result = call_594590.call(path_594591, query_594592, nil, nil, nil)

var jobScheduleDelete* = Call_JobScheduleDelete_594576(name: "jobScheduleDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}", validator: validate_JobScheduleDelete_594577,
    base: "", url: url_JobScheduleDelete_594578, schemes: {Scheme.Https})
type
  Call_JobScheduleDisable_594629 = ref object of OpenApiRestCall_593438
proc url_JobScheduleDisable_594631(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleDisable_594630(path: JsonNode; query: JsonNode;
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
  var valid_594632 = path.getOrDefault("jobScheduleId")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = nil)
  if valid_594632 != nil:
    section.add "jobScheduleId", valid_594632
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594633 = query.getOrDefault("timeout")
  valid_594633 = validateParameter(valid_594633, JInt, required = false,
                                 default = newJInt(30))
  if valid_594633 != nil:
    section.add "timeout", valid_594633
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594634 = query.getOrDefault("api-version")
  valid_594634 = validateParameter(valid_594634, JString, required = true,
                                 default = nil)
  if valid_594634 != nil:
    section.add "api-version", valid_594634
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
  var valid_594635 = header.getOrDefault("If-Match")
  valid_594635 = validateParameter(valid_594635, JString, required = false,
                                 default = nil)
  if valid_594635 != nil:
    section.add "If-Match", valid_594635
  var valid_594636 = header.getOrDefault("client-request-id")
  valid_594636 = validateParameter(valid_594636, JString, required = false,
                                 default = nil)
  if valid_594636 != nil:
    section.add "client-request-id", valid_594636
  var valid_594637 = header.getOrDefault("ocp-date")
  valid_594637 = validateParameter(valid_594637, JString, required = false,
                                 default = nil)
  if valid_594637 != nil:
    section.add "ocp-date", valid_594637
  var valid_594638 = header.getOrDefault("If-Unmodified-Since")
  valid_594638 = validateParameter(valid_594638, JString, required = false,
                                 default = nil)
  if valid_594638 != nil:
    section.add "If-Unmodified-Since", valid_594638
  var valid_594639 = header.getOrDefault("If-None-Match")
  valid_594639 = validateParameter(valid_594639, JString, required = false,
                                 default = nil)
  if valid_594639 != nil:
    section.add "If-None-Match", valid_594639
  var valid_594640 = header.getOrDefault("If-Modified-Since")
  valid_594640 = validateParameter(valid_594640, JString, required = false,
                                 default = nil)
  if valid_594640 != nil:
    section.add "If-Modified-Since", valid_594640
  var valid_594641 = header.getOrDefault("return-client-request-id")
  valid_594641 = validateParameter(valid_594641, JBool, required = false,
                                 default = newJBool(false))
  if valid_594641 != nil:
    section.add "return-client-request-id", valid_594641
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594642: Call_JobScheduleDisable_594629; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## No new Jobs will be created until the Job Schedule is enabled again.
  ## 
  let valid = call_594642.validator(path, query, header, formData, body)
  let scheme = call_594642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594642.url(scheme.get, call_594642.host, call_594642.base,
                         call_594642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594642, url, valid)

proc call*(call_594643: Call_JobScheduleDisable_594629; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleDisable
  ## No new Jobs will be created until the Job Schedule is enabled again.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule to disable.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_594644 = newJObject()
  var query_594645 = newJObject()
  add(query_594645, "timeout", newJInt(timeout))
  add(path_594644, "jobScheduleId", newJString(jobScheduleId))
  add(query_594645, "api-version", newJString(apiVersion))
  result = call_594643.call(path_594644, query_594645, nil, nil, nil)

var jobScheduleDisable* = Call_JobScheduleDisable_594629(
    name: "jobScheduleDisable", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/disable",
    validator: validate_JobScheduleDisable_594630, base: "",
    url: url_JobScheduleDisable_594631, schemes: {Scheme.Https})
type
  Call_JobScheduleEnable_594646 = ref object of OpenApiRestCall_593438
proc url_JobScheduleEnable_594648(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleEnable_594647(path: JsonNode; query: JsonNode;
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
  var valid_594649 = path.getOrDefault("jobScheduleId")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "jobScheduleId", valid_594649
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594650 = query.getOrDefault("timeout")
  valid_594650 = validateParameter(valid_594650, JInt, required = false,
                                 default = newJInt(30))
  if valid_594650 != nil:
    section.add "timeout", valid_594650
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594651 = query.getOrDefault("api-version")
  valid_594651 = validateParameter(valid_594651, JString, required = true,
                                 default = nil)
  if valid_594651 != nil:
    section.add "api-version", valid_594651
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
  var valid_594652 = header.getOrDefault("If-Match")
  valid_594652 = validateParameter(valid_594652, JString, required = false,
                                 default = nil)
  if valid_594652 != nil:
    section.add "If-Match", valid_594652
  var valid_594653 = header.getOrDefault("client-request-id")
  valid_594653 = validateParameter(valid_594653, JString, required = false,
                                 default = nil)
  if valid_594653 != nil:
    section.add "client-request-id", valid_594653
  var valid_594654 = header.getOrDefault("ocp-date")
  valid_594654 = validateParameter(valid_594654, JString, required = false,
                                 default = nil)
  if valid_594654 != nil:
    section.add "ocp-date", valid_594654
  var valid_594655 = header.getOrDefault("If-Unmodified-Since")
  valid_594655 = validateParameter(valid_594655, JString, required = false,
                                 default = nil)
  if valid_594655 != nil:
    section.add "If-Unmodified-Since", valid_594655
  var valid_594656 = header.getOrDefault("If-None-Match")
  valid_594656 = validateParameter(valid_594656, JString, required = false,
                                 default = nil)
  if valid_594656 != nil:
    section.add "If-None-Match", valid_594656
  var valid_594657 = header.getOrDefault("If-Modified-Since")
  valid_594657 = validateParameter(valid_594657, JString, required = false,
                                 default = nil)
  if valid_594657 != nil:
    section.add "If-Modified-Since", valid_594657
  var valid_594658 = header.getOrDefault("return-client-request-id")
  valid_594658 = validateParameter(valid_594658, JBool, required = false,
                                 default = newJBool(false))
  if valid_594658 != nil:
    section.add "return-client-request-id", valid_594658
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594659: Call_JobScheduleEnable_594646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594659.validator(path, query, header, formData, body)
  let scheme = call_594659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594659.url(scheme.get, call_594659.host, call_594659.base,
                         call_594659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594659, url, valid)

proc call*(call_594660: Call_JobScheduleEnable_594646; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleEnable
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule to enable.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_594661 = newJObject()
  var query_594662 = newJObject()
  add(query_594662, "timeout", newJInt(timeout))
  add(path_594661, "jobScheduleId", newJString(jobScheduleId))
  add(query_594662, "api-version", newJString(apiVersion))
  result = call_594660.call(path_594661, query_594662, nil, nil, nil)

var jobScheduleEnable* = Call_JobScheduleEnable_594646(name: "jobScheduleEnable",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/enable",
    validator: validate_JobScheduleEnable_594647, base: "",
    url: url_JobScheduleEnable_594648, schemes: {Scheme.Https})
type
  Call_JobListFromJobSchedule_594663 = ref object of OpenApiRestCall_593438
proc url_JobListFromJobSchedule_594665(protocol: Scheme; host: string; base: string;
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

proc validate_JobListFromJobSchedule_594664(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the Job Schedule from which you want to get a list of Jobs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_594666 = path.getOrDefault("jobScheduleId")
  valid_594666 = validateParameter(valid_594666, JString, required = true,
                                 default = nil)
  if valid_594666 != nil:
    section.add "jobScheduleId", valid_594666
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
  var valid_594667 = query.getOrDefault("timeout")
  valid_594667 = validateParameter(valid_594667, JInt, required = false,
                                 default = newJInt(30))
  if valid_594667 != nil:
    section.add "timeout", valid_594667
  var valid_594668 = query.getOrDefault("$expand")
  valid_594668 = validateParameter(valid_594668, JString, required = false,
                                 default = nil)
  if valid_594668 != nil:
    section.add "$expand", valid_594668
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594669 = query.getOrDefault("api-version")
  valid_594669 = validateParameter(valid_594669, JString, required = true,
                                 default = nil)
  if valid_594669 != nil:
    section.add "api-version", valid_594669
  var valid_594670 = query.getOrDefault("maxresults")
  valid_594670 = validateParameter(valid_594670, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594670 != nil:
    section.add "maxresults", valid_594670
  var valid_594671 = query.getOrDefault("$select")
  valid_594671 = validateParameter(valid_594671, JString, required = false,
                                 default = nil)
  if valid_594671 != nil:
    section.add "$select", valid_594671
  var valid_594672 = query.getOrDefault("$filter")
  valid_594672 = validateParameter(valid_594672, JString, required = false,
                                 default = nil)
  if valid_594672 != nil:
    section.add "$filter", valid_594672
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594673 = header.getOrDefault("client-request-id")
  valid_594673 = validateParameter(valid_594673, JString, required = false,
                                 default = nil)
  if valid_594673 != nil:
    section.add "client-request-id", valid_594673
  var valid_594674 = header.getOrDefault("ocp-date")
  valid_594674 = validateParameter(valid_594674, JString, required = false,
                                 default = nil)
  if valid_594674 != nil:
    section.add "ocp-date", valid_594674
  var valid_594675 = header.getOrDefault("return-client-request-id")
  valid_594675 = validateParameter(valid_594675, JBool, required = false,
                                 default = newJBool(false))
  if valid_594675 != nil:
    section.add "return-client-request-id", valid_594675
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594676: Call_JobListFromJobSchedule_594663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594676.validator(path, query, header, formData, body)
  let scheme = call_594676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594676.url(scheme.get, call_594676.host, call_594676.base,
                         call_594676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594676, url, valid)

proc call*(call_594677: Call_JobListFromJobSchedule_594663; jobScheduleId: string;
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
  var path_594678 = newJObject()
  var query_594679 = newJObject()
  add(query_594679, "timeout", newJInt(timeout))
  add(path_594678, "jobScheduleId", newJString(jobScheduleId))
  add(query_594679, "$expand", newJString(Expand))
  add(query_594679, "api-version", newJString(apiVersion))
  add(query_594679, "maxresults", newJInt(maxresults))
  add(query_594679, "$select", newJString(Select))
  add(query_594679, "$filter", newJString(Filter))
  result = call_594677.call(path_594678, query_594679, nil, nil, nil)

var jobListFromJobSchedule* = Call_JobListFromJobSchedule_594663(
    name: "jobListFromJobSchedule", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/jobs",
    validator: validate_JobListFromJobSchedule_594664, base: "",
    url: url_JobListFromJobSchedule_594665, schemes: {Scheme.Https})
type
  Call_JobScheduleTerminate_594680 = ref object of OpenApiRestCall_593438
proc url_JobScheduleTerminate_594682(protocol: Scheme; host: string; base: string;
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

proc validate_JobScheduleTerminate_594681(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobScheduleId: JString (required)
  ##                : The ID of the Job Schedule to terminates.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `jobScheduleId` field"
  var valid_594683 = path.getOrDefault("jobScheduleId")
  valid_594683 = validateParameter(valid_594683, JString, required = true,
                                 default = nil)
  if valid_594683 != nil:
    section.add "jobScheduleId", valid_594683
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594684 = query.getOrDefault("timeout")
  valid_594684 = validateParameter(valid_594684, JInt, required = false,
                                 default = newJInt(30))
  if valid_594684 != nil:
    section.add "timeout", valid_594684
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594685 = query.getOrDefault("api-version")
  valid_594685 = validateParameter(valid_594685, JString, required = true,
                                 default = nil)
  if valid_594685 != nil:
    section.add "api-version", valid_594685
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
  var valid_594686 = header.getOrDefault("If-Match")
  valid_594686 = validateParameter(valid_594686, JString, required = false,
                                 default = nil)
  if valid_594686 != nil:
    section.add "If-Match", valid_594686
  var valid_594687 = header.getOrDefault("client-request-id")
  valid_594687 = validateParameter(valid_594687, JString, required = false,
                                 default = nil)
  if valid_594687 != nil:
    section.add "client-request-id", valid_594687
  var valid_594688 = header.getOrDefault("ocp-date")
  valid_594688 = validateParameter(valid_594688, JString, required = false,
                                 default = nil)
  if valid_594688 != nil:
    section.add "ocp-date", valid_594688
  var valid_594689 = header.getOrDefault("If-Unmodified-Since")
  valid_594689 = validateParameter(valid_594689, JString, required = false,
                                 default = nil)
  if valid_594689 != nil:
    section.add "If-Unmodified-Since", valid_594689
  var valid_594690 = header.getOrDefault("If-None-Match")
  valid_594690 = validateParameter(valid_594690, JString, required = false,
                                 default = nil)
  if valid_594690 != nil:
    section.add "If-None-Match", valid_594690
  var valid_594691 = header.getOrDefault("If-Modified-Since")
  valid_594691 = validateParameter(valid_594691, JString, required = false,
                                 default = nil)
  if valid_594691 != nil:
    section.add "If-Modified-Since", valid_594691
  var valid_594692 = header.getOrDefault("return-client-request-id")
  valid_594692 = validateParameter(valid_594692, JBool, required = false,
                                 default = newJBool(false))
  if valid_594692 != nil:
    section.add "return-client-request-id", valid_594692
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594693: Call_JobScheduleTerminate_594680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594693.validator(path, query, header, formData, body)
  let scheme = call_594693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594693.url(scheme.get, call_594693.host, call_594693.base,
                         call_594693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594693, url, valid)

proc call*(call_594694: Call_JobScheduleTerminate_594680; jobScheduleId: string;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobScheduleTerminate
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   jobScheduleId: string (required)
  ##                : The ID of the Job Schedule to terminates.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var path_594695 = newJObject()
  var query_594696 = newJObject()
  add(query_594696, "timeout", newJInt(timeout))
  add(path_594695, "jobScheduleId", newJString(jobScheduleId))
  add(query_594696, "api-version", newJString(apiVersion))
  result = call_594694.call(path_594695, query_594696, nil, nil, nil)

var jobScheduleTerminate* = Call_JobScheduleTerminate_594680(
    name: "jobScheduleTerminate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/jobschedules/{jobScheduleId}/terminate",
    validator: validate_JobScheduleTerminate_594681, base: "",
    url: url_JobScheduleTerminate_594682, schemes: {Scheme.Https})
type
  Call_JobGetAllLifetimeStatistics_594697 = ref object of OpenApiRestCall_593438
proc url_JobGetAllLifetimeStatistics_594699(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_JobGetAllLifetimeStatistics_594698(path: JsonNode; query: JsonNode;
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
  var valid_594700 = query.getOrDefault("timeout")
  valid_594700 = validateParameter(valid_594700, JInt, required = false,
                                 default = newJInt(30))
  if valid_594700 != nil:
    section.add "timeout", valid_594700
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594701 = query.getOrDefault("api-version")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = nil)
  if valid_594701 != nil:
    section.add "api-version", valid_594701
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594702 = header.getOrDefault("client-request-id")
  valid_594702 = validateParameter(valid_594702, JString, required = false,
                                 default = nil)
  if valid_594702 != nil:
    section.add "client-request-id", valid_594702
  var valid_594703 = header.getOrDefault("ocp-date")
  valid_594703 = validateParameter(valid_594703, JString, required = false,
                                 default = nil)
  if valid_594703 != nil:
    section.add "ocp-date", valid_594703
  var valid_594704 = header.getOrDefault("return-client-request-id")
  valid_594704 = validateParameter(valid_594704, JBool, required = false,
                                 default = newJBool(false))
  if valid_594704 != nil:
    section.add "return-client-request-id", valid_594704
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594705: Call_JobGetAllLifetimeStatistics_594697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Statistics are aggregated across all Jobs that have ever existed in the Account, from Account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ## 
  let valid = call_594705.validator(path, query, header, formData, body)
  let scheme = call_594705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594705.url(scheme.get, call_594705.host, call_594705.base,
                         call_594705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594705, url, valid)

proc call*(call_594706: Call_JobGetAllLifetimeStatistics_594697;
          apiVersion: string; timeout: int = 30): Recallable =
  ## jobGetAllLifetimeStatistics
  ## Statistics are aggregated across all Jobs that have ever existed in the Account, from Account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_594707 = newJObject()
  add(query_594707, "timeout", newJInt(timeout))
  add(query_594707, "api-version", newJString(apiVersion))
  result = call_594706.call(nil, query_594707, nil, nil, nil)

var jobGetAllLifetimeStatistics* = Call_JobGetAllLifetimeStatistics_594697(
    name: "jobGetAllLifetimeStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/lifetimejobstats",
    validator: validate_JobGetAllLifetimeStatistics_594698, base: "",
    url: url_JobGetAllLifetimeStatistics_594699, schemes: {Scheme.Https})
type
  Call_PoolGetAllLifetimeStatistics_594708 = ref object of OpenApiRestCall_593438
proc url_PoolGetAllLifetimeStatistics_594710(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolGetAllLifetimeStatistics_594709(path: JsonNode; query: JsonNode;
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
  var valid_594711 = query.getOrDefault("timeout")
  valid_594711 = validateParameter(valid_594711, JInt, required = false,
                                 default = newJInt(30))
  if valid_594711 != nil:
    section.add "timeout", valid_594711
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594712 = query.getOrDefault("api-version")
  valid_594712 = validateParameter(valid_594712, JString, required = true,
                                 default = nil)
  if valid_594712 != nil:
    section.add "api-version", valid_594712
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594713 = header.getOrDefault("client-request-id")
  valid_594713 = validateParameter(valid_594713, JString, required = false,
                                 default = nil)
  if valid_594713 != nil:
    section.add "client-request-id", valid_594713
  var valid_594714 = header.getOrDefault("ocp-date")
  valid_594714 = validateParameter(valid_594714, JString, required = false,
                                 default = nil)
  if valid_594714 != nil:
    section.add "ocp-date", valid_594714
  var valid_594715 = header.getOrDefault("return-client-request-id")
  valid_594715 = validateParameter(valid_594715, JBool, required = false,
                                 default = newJBool(false))
  if valid_594715 != nil:
    section.add "return-client-request-id", valid_594715
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594716: Call_PoolGetAllLifetimeStatistics_594708; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Statistics are aggregated across all Pools that have ever existed in the Account, from Account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ## 
  let valid = call_594716.validator(path, query, header, formData, body)
  let scheme = call_594716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594716.url(scheme.get, call_594716.host, call_594716.base,
                         call_594716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594716, url, valid)

proc call*(call_594717: Call_PoolGetAllLifetimeStatistics_594708;
          apiVersion: string; timeout: int = 30): Recallable =
  ## poolGetAllLifetimeStatistics
  ## Statistics are aggregated across all Pools that have ever existed in the Account, from Account creation to the last update time of the statistics. The statistics may not be immediately available. The Batch service performs periodic roll-up of statistics. The typical delay is about 30 minutes.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_594718 = newJObject()
  add(query_594718, "timeout", newJInt(timeout))
  add(query_594718, "api-version", newJString(apiVersion))
  result = call_594717.call(nil, query_594718, nil, nil, nil)

var poolGetAllLifetimeStatistics* = Call_PoolGetAllLifetimeStatistics_594708(
    name: "poolGetAllLifetimeStatistics", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/lifetimepoolstats",
    validator: validate_PoolGetAllLifetimeStatistics_594709, base: "",
    url: url_PoolGetAllLifetimeStatistics_594710, schemes: {Scheme.Https})
type
  Call_AccountListPoolNodeCounts_594719 = ref object of OpenApiRestCall_593438
proc url_AccountListPoolNodeCounts_594721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccountListPoolNodeCounts_594720(path: JsonNode; query: JsonNode;
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
  var valid_594722 = query.getOrDefault("timeout")
  valid_594722 = validateParameter(valid_594722, JInt, required = false,
                                 default = newJInt(30))
  if valid_594722 != nil:
    section.add "timeout", valid_594722
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594723 = query.getOrDefault("api-version")
  valid_594723 = validateParameter(valid_594723, JString, required = true,
                                 default = nil)
  if valid_594723 != nil:
    section.add "api-version", valid_594723
  var valid_594724 = query.getOrDefault("maxresults")
  valid_594724 = validateParameter(valid_594724, JInt, required = false,
                                 default = newJInt(10))
  if valid_594724 != nil:
    section.add "maxresults", valid_594724
  var valid_594725 = query.getOrDefault("$filter")
  valid_594725 = validateParameter(valid_594725, JString, required = false,
                                 default = nil)
  if valid_594725 != nil:
    section.add "$filter", valid_594725
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594726 = header.getOrDefault("client-request-id")
  valid_594726 = validateParameter(valid_594726, JString, required = false,
                                 default = nil)
  if valid_594726 != nil:
    section.add "client-request-id", valid_594726
  var valid_594727 = header.getOrDefault("ocp-date")
  valid_594727 = validateParameter(valid_594727, JString, required = false,
                                 default = nil)
  if valid_594727 != nil:
    section.add "ocp-date", valid_594727
  var valid_594728 = header.getOrDefault("return-client-request-id")
  valid_594728 = validateParameter(valid_594728, JBool, required = false,
                                 default = newJBool(false))
  if valid_594728 != nil:
    section.add "return-client-request-id", valid_594728
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594729: Call_AccountListPoolNodeCounts_594719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the number of Compute Nodes in each state, grouped by Pool.
  ## 
  let valid = call_594729.validator(path, query, header, formData, body)
  let scheme = call_594729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594729.url(scheme.get, call_594729.host, call_594729.base,
                         call_594729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594729, url, valid)

proc call*(call_594730: Call_AccountListPoolNodeCounts_594719; apiVersion: string;
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
  var query_594731 = newJObject()
  add(query_594731, "timeout", newJInt(timeout))
  add(query_594731, "api-version", newJString(apiVersion))
  add(query_594731, "maxresults", newJInt(maxresults))
  add(query_594731, "$filter", newJString(Filter))
  result = call_594730.call(nil, query_594731, nil, nil, nil)

var accountListPoolNodeCounts* = Call_AccountListPoolNodeCounts_594719(
    name: "accountListPoolNodeCounts", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/nodecounts",
    validator: validate_AccountListPoolNodeCounts_594720, base: "",
    url: url_AccountListPoolNodeCounts_594721, schemes: {Scheme.Https})
type
  Call_PoolAdd_594747 = ref object of OpenApiRestCall_593438
proc url_PoolAdd_594749(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolAdd_594748(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594750 = query.getOrDefault("timeout")
  valid_594750 = validateParameter(valid_594750, JInt, required = false,
                                 default = newJInt(30))
  if valid_594750 != nil:
    section.add "timeout", valid_594750
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594751 = query.getOrDefault("api-version")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "api-version", valid_594751
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594752 = header.getOrDefault("client-request-id")
  valid_594752 = validateParameter(valid_594752, JString, required = false,
                                 default = nil)
  if valid_594752 != nil:
    section.add "client-request-id", valid_594752
  var valid_594753 = header.getOrDefault("ocp-date")
  valid_594753 = validateParameter(valid_594753, JString, required = false,
                                 default = nil)
  if valid_594753 != nil:
    section.add "ocp-date", valid_594753
  var valid_594754 = header.getOrDefault("return-client-request-id")
  valid_594754 = validateParameter(valid_594754, JBool, required = false,
                                 default = newJBool(false))
  if valid_594754 != nil:
    section.add "return-client-request-id", valid_594754
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

proc call*(call_594756: Call_PoolAdd_594747; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When naming Pools, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ## 
  let valid = call_594756.validator(path, query, header, formData, body)
  let scheme = call_594756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594756.url(scheme.get, call_594756.host, call_594756.base,
                         call_594756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594756, url, valid)

proc call*(call_594757: Call_PoolAdd_594747; pool: JsonNode; apiVersion: string;
          timeout: int = 30): Recallable =
  ## poolAdd
  ## When naming Pools, avoid including sensitive information such as user names or secret project names. This information may appear in telemetry logs accessible to Microsoft Support engineers.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   pool: JObject (required)
  ##       : The Pool to be added.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_594758 = newJObject()
  var body_594759 = newJObject()
  add(query_594758, "timeout", newJInt(timeout))
  if pool != nil:
    body_594759 = pool
  add(query_594758, "api-version", newJString(apiVersion))
  result = call_594757.call(nil, query_594758, nil, nil, body_594759)

var poolAdd* = Call_PoolAdd_594747(name: "poolAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/pools",
                                validator: validate_PoolAdd_594748, base: "",
                                url: url_PoolAdd_594749, schemes: {Scheme.Https})
type
  Call_PoolList_594732 = ref object of OpenApiRestCall_593438
proc url_PoolList_594734(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolList_594733(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594735 = query.getOrDefault("timeout")
  valid_594735 = validateParameter(valid_594735, JInt, required = false,
                                 default = newJInt(30))
  if valid_594735 != nil:
    section.add "timeout", valid_594735
  var valid_594736 = query.getOrDefault("$expand")
  valid_594736 = validateParameter(valid_594736, JString, required = false,
                                 default = nil)
  if valid_594736 != nil:
    section.add "$expand", valid_594736
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594737 = query.getOrDefault("api-version")
  valid_594737 = validateParameter(valid_594737, JString, required = true,
                                 default = nil)
  if valid_594737 != nil:
    section.add "api-version", valid_594737
  var valid_594738 = query.getOrDefault("maxresults")
  valid_594738 = validateParameter(valid_594738, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594738 != nil:
    section.add "maxresults", valid_594738
  var valid_594739 = query.getOrDefault("$select")
  valid_594739 = validateParameter(valid_594739, JString, required = false,
                                 default = nil)
  if valid_594739 != nil:
    section.add "$select", valid_594739
  var valid_594740 = query.getOrDefault("$filter")
  valid_594740 = validateParameter(valid_594740, JString, required = false,
                                 default = nil)
  if valid_594740 != nil:
    section.add "$filter", valid_594740
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594741 = header.getOrDefault("client-request-id")
  valid_594741 = validateParameter(valid_594741, JString, required = false,
                                 default = nil)
  if valid_594741 != nil:
    section.add "client-request-id", valid_594741
  var valid_594742 = header.getOrDefault("ocp-date")
  valid_594742 = validateParameter(valid_594742, JString, required = false,
                                 default = nil)
  if valid_594742 != nil:
    section.add "ocp-date", valid_594742
  var valid_594743 = header.getOrDefault("return-client-request-id")
  valid_594743 = validateParameter(valid_594743, JBool, required = false,
                                 default = newJBool(false))
  if valid_594743 != nil:
    section.add "return-client-request-id", valid_594743
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594744: Call_PoolList_594732; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594744.validator(path, query, header, formData, body)
  let scheme = call_594744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594744.url(scheme.get, call_594744.host, call_594744.base,
                         call_594744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594744, url, valid)

proc call*(call_594745: Call_PoolList_594732; apiVersion: string; timeout: int = 30;
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
  var query_594746 = newJObject()
  add(query_594746, "timeout", newJInt(timeout))
  add(query_594746, "$expand", newJString(Expand))
  add(query_594746, "api-version", newJString(apiVersion))
  add(query_594746, "maxresults", newJInt(maxresults))
  add(query_594746, "$select", newJString(Select))
  add(query_594746, "$filter", newJString(Filter))
  result = call_594745.call(nil, query_594746, nil, nil, nil)

var poolList* = Call_PoolList_594732(name: "poolList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/pools",
                                  validator: validate_PoolList_594733, base: "",
                                  url: url_PoolList_594734,
                                  schemes: {Scheme.Https})
type
  Call_PoolExists_594796 = ref object of OpenApiRestCall_593438
proc url_PoolExists_594798(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolExists_594797(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594799 = path.getOrDefault("poolId")
  valid_594799 = validateParameter(valid_594799, JString, required = true,
                                 default = nil)
  if valid_594799 != nil:
    section.add "poolId", valid_594799
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594800 = query.getOrDefault("timeout")
  valid_594800 = validateParameter(valid_594800, JInt, required = false,
                                 default = newJInt(30))
  if valid_594800 != nil:
    section.add "timeout", valid_594800
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594801 = query.getOrDefault("api-version")
  valid_594801 = validateParameter(valid_594801, JString, required = true,
                                 default = nil)
  if valid_594801 != nil:
    section.add "api-version", valid_594801
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
  var valid_594802 = header.getOrDefault("If-Match")
  valid_594802 = validateParameter(valid_594802, JString, required = false,
                                 default = nil)
  if valid_594802 != nil:
    section.add "If-Match", valid_594802
  var valid_594803 = header.getOrDefault("client-request-id")
  valid_594803 = validateParameter(valid_594803, JString, required = false,
                                 default = nil)
  if valid_594803 != nil:
    section.add "client-request-id", valid_594803
  var valid_594804 = header.getOrDefault("ocp-date")
  valid_594804 = validateParameter(valid_594804, JString, required = false,
                                 default = nil)
  if valid_594804 != nil:
    section.add "ocp-date", valid_594804
  var valid_594805 = header.getOrDefault("If-Unmodified-Since")
  valid_594805 = validateParameter(valid_594805, JString, required = false,
                                 default = nil)
  if valid_594805 != nil:
    section.add "If-Unmodified-Since", valid_594805
  var valid_594806 = header.getOrDefault("If-None-Match")
  valid_594806 = validateParameter(valid_594806, JString, required = false,
                                 default = nil)
  if valid_594806 != nil:
    section.add "If-None-Match", valid_594806
  var valid_594807 = header.getOrDefault("If-Modified-Since")
  valid_594807 = validateParameter(valid_594807, JString, required = false,
                                 default = nil)
  if valid_594807 != nil:
    section.add "If-Modified-Since", valid_594807
  var valid_594808 = header.getOrDefault("return-client-request-id")
  valid_594808 = validateParameter(valid_594808, JBool, required = false,
                                 default = newJBool(false))
  if valid_594808 != nil:
    section.add "return-client-request-id", valid_594808
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594809: Call_PoolExists_594796; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets basic properties of a Pool.
  ## 
  let valid = call_594809.validator(path, query, header, formData, body)
  let scheme = call_594809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594809.url(scheme.get, call_594809.host, call_594809.base,
                         call_594809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594809, url, valid)

proc call*(call_594810: Call_PoolExists_594796; apiVersion: string; poolId: string;
          timeout: int = 30): Recallable =
  ## poolExists
  ## Gets basic properties of a Pool.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool to get.
  var path_594811 = newJObject()
  var query_594812 = newJObject()
  add(query_594812, "timeout", newJInt(timeout))
  add(query_594812, "api-version", newJString(apiVersion))
  add(path_594811, "poolId", newJString(poolId))
  result = call_594810.call(path_594811, query_594812, nil, nil, nil)

var poolExists* = Call_PoolExists_594796(name: "poolExists",
                                      meth: HttpMethod.HttpHead,
                                      host: "azure.local",
                                      route: "/pools/{poolId}",
                                      validator: validate_PoolExists_594797,
                                      base: "", url: url_PoolExists_594798,
                                      schemes: {Scheme.Https})
type
  Call_PoolGet_594760 = ref object of OpenApiRestCall_593438
proc url_PoolGet_594762(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolGet_594761(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594763 = path.getOrDefault("poolId")
  valid_594763 = validateParameter(valid_594763, JString, required = true,
                                 default = nil)
  if valid_594763 != nil:
    section.add "poolId", valid_594763
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
  var valid_594764 = query.getOrDefault("timeout")
  valid_594764 = validateParameter(valid_594764, JInt, required = false,
                                 default = newJInt(30))
  if valid_594764 != nil:
    section.add "timeout", valid_594764
  var valid_594765 = query.getOrDefault("$expand")
  valid_594765 = validateParameter(valid_594765, JString, required = false,
                                 default = nil)
  if valid_594765 != nil:
    section.add "$expand", valid_594765
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594766 = query.getOrDefault("api-version")
  valid_594766 = validateParameter(valid_594766, JString, required = true,
                                 default = nil)
  if valid_594766 != nil:
    section.add "api-version", valid_594766
  var valid_594767 = query.getOrDefault("$select")
  valid_594767 = validateParameter(valid_594767, JString, required = false,
                                 default = nil)
  if valid_594767 != nil:
    section.add "$select", valid_594767
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
  var valid_594768 = header.getOrDefault("If-Match")
  valid_594768 = validateParameter(valid_594768, JString, required = false,
                                 default = nil)
  if valid_594768 != nil:
    section.add "If-Match", valid_594768
  var valid_594769 = header.getOrDefault("client-request-id")
  valid_594769 = validateParameter(valid_594769, JString, required = false,
                                 default = nil)
  if valid_594769 != nil:
    section.add "client-request-id", valid_594769
  var valid_594770 = header.getOrDefault("ocp-date")
  valid_594770 = validateParameter(valid_594770, JString, required = false,
                                 default = nil)
  if valid_594770 != nil:
    section.add "ocp-date", valid_594770
  var valid_594771 = header.getOrDefault("If-Unmodified-Since")
  valid_594771 = validateParameter(valid_594771, JString, required = false,
                                 default = nil)
  if valid_594771 != nil:
    section.add "If-Unmodified-Since", valid_594771
  var valid_594772 = header.getOrDefault("If-None-Match")
  valid_594772 = validateParameter(valid_594772, JString, required = false,
                                 default = nil)
  if valid_594772 != nil:
    section.add "If-None-Match", valid_594772
  var valid_594773 = header.getOrDefault("If-Modified-Since")
  valid_594773 = validateParameter(valid_594773, JString, required = false,
                                 default = nil)
  if valid_594773 != nil:
    section.add "If-Modified-Since", valid_594773
  var valid_594774 = header.getOrDefault("return-client-request-id")
  valid_594774 = validateParameter(valid_594774, JBool, required = false,
                                 default = newJBool(false))
  if valid_594774 != nil:
    section.add "return-client-request-id", valid_594774
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594775: Call_PoolGet_594760; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified Pool.
  ## 
  let valid = call_594775.validator(path, query, header, formData, body)
  let scheme = call_594775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594775.url(scheme.get, call_594775.host, call_594775.base,
                         call_594775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594775, url, valid)

proc call*(call_594776: Call_PoolGet_594760; apiVersion: string; poolId: string;
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
  var path_594777 = newJObject()
  var query_594778 = newJObject()
  add(query_594778, "timeout", newJInt(timeout))
  add(query_594778, "$expand", newJString(Expand))
  add(query_594778, "api-version", newJString(apiVersion))
  add(path_594777, "poolId", newJString(poolId))
  add(query_594778, "$select", newJString(Select))
  result = call_594776.call(path_594777, query_594778, nil, nil, nil)

var poolGet* = Call_PoolGet_594760(name: "poolGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/pools/{poolId}",
                                validator: validate_PoolGet_594761, base: "",
                                url: url_PoolGet_594762, schemes: {Scheme.Https})
type
  Call_PoolPatch_594813 = ref object of OpenApiRestCall_593438
proc url_PoolPatch_594815(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolPatch_594814(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## This only replaces the Pool properties specified in the request. For example, if the Pool has a start Task associated with it, and a request does not specify a start Task element, then the Pool keeps the existing start Task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_594816 = path.getOrDefault("poolId")
  valid_594816 = validateParameter(valid_594816, JString, required = true,
                                 default = nil)
  if valid_594816 != nil:
    section.add "poolId", valid_594816
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594817 = query.getOrDefault("timeout")
  valid_594817 = validateParameter(valid_594817, JInt, required = false,
                                 default = newJInt(30))
  if valid_594817 != nil:
    section.add "timeout", valid_594817
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594818 = query.getOrDefault("api-version")
  valid_594818 = validateParameter(valid_594818, JString, required = true,
                                 default = nil)
  if valid_594818 != nil:
    section.add "api-version", valid_594818
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
  var valid_594819 = header.getOrDefault("If-Match")
  valid_594819 = validateParameter(valid_594819, JString, required = false,
                                 default = nil)
  if valid_594819 != nil:
    section.add "If-Match", valid_594819
  var valid_594820 = header.getOrDefault("client-request-id")
  valid_594820 = validateParameter(valid_594820, JString, required = false,
                                 default = nil)
  if valid_594820 != nil:
    section.add "client-request-id", valid_594820
  var valid_594821 = header.getOrDefault("ocp-date")
  valid_594821 = validateParameter(valid_594821, JString, required = false,
                                 default = nil)
  if valid_594821 != nil:
    section.add "ocp-date", valid_594821
  var valid_594822 = header.getOrDefault("If-Unmodified-Since")
  valid_594822 = validateParameter(valid_594822, JString, required = false,
                                 default = nil)
  if valid_594822 != nil:
    section.add "If-Unmodified-Since", valid_594822
  var valid_594823 = header.getOrDefault("If-None-Match")
  valid_594823 = validateParameter(valid_594823, JString, required = false,
                                 default = nil)
  if valid_594823 != nil:
    section.add "If-None-Match", valid_594823
  var valid_594824 = header.getOrDefault("If-Modified-Since")
  valid_594824 = validateParameter(valid_594824, JString, required = false,
                                 default = nil)
  if valid_594824 != nil:
    section.add "If-Modified-Since", valid_594824
  var valid_594825 = header.getOrDefault("return-client-request-id")
  valid_594825 = validateParameter(valid_594825, JBool, required = false,
                                 default = newJBool(false))
  if valid_594825 != nil:
    section.add "return-client-request-id", valid_594825
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

proc call*(call_594827: Call_PoolPatch_594813; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This only replaces the Pool properties specified in the request. For example, if the Pool has a start Task associated with it, and a request does not specify a start Task element, then the Pool keeps the existing start Task.
  ## 
  let valid = call_594827.validator(path, query, header, formData, body)
  let scheme = call_594827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594827.url(scheme.get, call_594827.host, call_594827.base,
                         call_594827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594827, url, valid)

proc call*(call_594828: Call_PoolPatch_594813; apiVersion: string; poolId: string;
          poolPatchParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolPatch
  ## This only replaces the Pool properties specified in the request. For example, if the Pool has a start Task associated with it, and a request does not specify a start Task element, then the Pool keeps the existing start Task.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool to update.
  ##   poolPatchParameter: JObject (required)
  ##                     : The parameters for the request.
  var path_594829 = newJObject()
  var query_594830 = newJObject()
  var body_594831 = newJObject()
  add(query_594830, "timeout", newJInt(timeout))
  add(query_594830, "api-version", newJString(apiVersion))
  add(path_594829, "poolId", newJString(poolId))
  if poolPatchParameter != nil:
    body_594831 = poolPatchParameter
  result = call_594828.call(path_594829, query_594830, nil, nil, body_594831)

var poolPatch* = Call_PoolPatch_594813(name: "poolPatch", meth: HttpMethod.HttpPatch,
                                    host: "azure.local", route: "/pools/{poolId}",
                                    validator: validate_PoolPatch_594814,
                                    base: "", url: url_PoolPatch_594815,
                                    schemes: {Scheme.Https})
type
  Call_PoolDelete_594779 = ref object of OpenApiRestCall_593438
proc url_PoolDelete_594781(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolDelete_594780(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594782 = path.getOrDefault("poolId")
  valid_594782 = validateParameter(valid_594782, JString, required = true,
                                 default = nil)
  if valid_594782 != nil:
    section.add "poolId", valid_594782
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594783 = query.getOrDefault("timeout")
  valid_594783 = validateParameter(valid_594783, JInt, required = false,
                                 default = newJInt(30))
  if valid_594783 != nil:
    section.add "timeout", valid_594783
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594784 = query.getOrDefault("api-version")
  valid_594784 = validateParameter(valid_594784, JString, required = true,
                                 default = nil)
  if valid_594784 != nil:
    section.add "api-version", valid_594784
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
  var valid_594785 = header.getOrDefault("If-Match")
  valid_594785 = validateParameter(valid_594785, JString, required = false,
                                 default = nil)
  if valid_594785 != nil:
    section.add "If-Match", valid_594785
  var valid_594786 = header.getOrDefault("client-request-id")
  valid_594786 = validateParameter(valid_594786, JString, required = false,
                                 default = nil)
  if valid_594786 != nil:
    section.add "client-request-id", valid_594786
  var valid_594787 = header.getOrDefault("ocp-date")
  valid_594787 = validateParameter(valid_594787, JString, required = false,
                                 default = nil)
  if valid_594787 != nil:
    section.add "ocp-date", valid_594787
  var valid_594788 = header.getOrDefault("If-Unmodified-Since")
  valid_594788 = validateParameter(valid_594788, JString, required = false,
                                 default = nil)
  if valid_594788 != nil:
    section.add "If-Unmodified-Since", valid_594788
  var valid_594789 = header.getOrDefault("If-None-Match")
  valid_594789 = validateParameter(valid_594789, JString, required = false,
                                 default = nil)
  if valid_594789 != nil:
    section.add "If-None-Match", valid_594789
  var valid_594790 = header.getOrDefault("If-Modified-Since")
  valid_594790 = validateParameter(valid_594790, JString, required = false,
                                 default = nil)
  if valid_594790 != nil:
    section.add "If-Modified-Since", valid_594790
  var valid_594791 = header.getOrDefault("return-client-request-id")
  valid_594791 = validateParameter(valid_594791, JBool, required = false,
                                 default = newJBool(false))
  if valid_594791 != nil:
    section.add "return-client-request-id", valid_594791
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594792: Call_PoolDelete_594779; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you request that a Pool be deleted, the following actions occur: the Pool state is set to deleting; any ongoing resize operation on the Pool are stopped; the Batch service starts resizing the Pool to zero Compute Nodes; any Tasks running on existing Compute Nodes are terminated and requeued (as if a resize Pool operation had been requested with the default requeue option); finally, the Pool is removed from the system. Because running Tasks are requeued, the user can rerun these Tasks by updating their Job to target a different Pool. The Tasks can then run on the new Pool. If you want to override the requeue behavior, then you should call resize Pool explicitly to shrink the Pool to zero size before deleting the Pool. If you call an Update, Patch or Delete API on a Pool in the deleting state, it will fail with HTTP status code 409 with error code PoolBeingDeleted.
  ## 
  let valid = call_594792.validator(path, query, header, formData, body)
  let scheme = call_594792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594792.url(scheme.get, call_594792.host, call_594792.base,
                         call_594792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594792, url, valid)

proc call*(call_594793: Call_PoolDelete_594779; apiVersion: string; poolId: string;
          timeout: int = 30): Recallable =
  ## poolDelete
  ## When you request that a Pool be deleted, the following actions occur: the Pool state is set to deleting; any ongoing resize operation on the Pool are stopped; the Batch service starts resizing the Pool to zero Compute Nodes; any Tasks running on existing Compute Nodes are terminated and requeued (as if a resize Pool operation had been requested with the default requeue option); finally, the Pool is removed from the system. Because running Tasks are requeued, the user can rerun these Tasks by updating their Job to target a different Pool. The Tasks can then run on the new Pool. If you want to override the requeue behavior, then you should call resize Pool explicitly to shrink the Pool to zero size before deleting the Pool. If you call an Update, Patch or Delete API on a Pool in the deleting state, it will fail with HTTP status code 409 with error code PoolBeingDeleted.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool to delete.
  var path_594794 = newJObject()
  var query_594795 = newJObject()
  add(query_594795, "timeout", newJInt(timeout))
  add(query_594795, "api-version", newJString(apiVersion))
  add(path_594794, "poolId", newJString(poolId))
  result = call_594793.call(path_594794, query_594795, nil, nil, nil)

var poolDelete* = Call_PoolDelete_594779(name: "poolDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/pools/{poolId}",
                                      validator: validate_PoolDelete_594780,
                                      base: "", url: url_PoolDelete_594781,
                                      schemes: {Scheme.Https})
type
  Call_PoolDisableAutoScale_594832 = ref object of OpenApiRestCall_593438
proc url_PoolDisableAutoScale_594834(protocol: Scheme; host: string; base: string;
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

proc validate_PoolDisableAutoScale_594833(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool on which to disable automatic scaling.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_594835 = path.getOrDefault("poolId")
  valid_594835 = validateParameter(valid_594835, JString, required = true,
                                 default = nil)
  if valid_594835 != nil:
    section.add "poolId", valid_594835
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594836 = query.getOrDefault("timeout")
  valid_594836 = validateParameter(valid_594836, JInt, required = false,
                                 default = newJInt(30))
  if valid_594836 != nil:
    section.add "timeout", valid_594836
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594837 = query.getOrDefault("api-version")
  valid_594837 = validateParameter(valid_594837, JString, required = true,
                                 default = nil)
  if valid_594837 != nil:
    section.add "api-version", valid_594837
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594838 = header.getOrDefault("client-request-id")
  valid_594838 = validateParameter(valid_594838, JString, required = false,
                                 default = nil)
  if valid_594838 != nil:
    section.add "client-request-id", valid_594838
  var valid_594839 = header.getOrDefault("ocp-date")
  valid_594839 = validateParameter(valid_594839, JString, required = false,
                                 default = nil)
  if valid_594839 != nil:
    section.add "ocp-date", valid_594839
  var valid_594840 = header.getOrDefault("return-client-request-id")
  valid_594840 = validateParameter(valid_594840, JBool, required = false,
                                 default = newJBool(false))
  if valid_594840 != nil:
    section.add "return-client-request-id", valid_594840
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594841: Call_PoolDisableAutoScale_594832; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594841.validator(path, query, header, formData, body)
  let scheme = call_594841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594841.url(scheme.get, call_594841.host, call_594841.base,
                         call_594841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594841, url, valid)

proc call*(call_594842: Call_PoolDisableAutoScale_594832; apiVersion: string;
          poolId: string; timeout: int = 30): Recallable =
  ## poolDisableAutoScale
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool on which to disable automatic scaling.
  var path_594843 = newJObject()
  var query_594844 = newJObject()
  add(query_594844, "timeout", newJInt(timeout))
  add(query_594844, "api-version", newJString(apiVersion))
  add(path_594843, "poolId", newJString(poolId))
  result = call_594842.call(path_594843, query_594844, nil, nil, nil)

var poolDisableAutoScale* = Call_PoolDisableAutoScale_594832(
    name: "poolDisableAutoScale", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/disableautoscale",
    validator: validate_PoolDisableAutoScale_594833, base: "",
    url: url_PoolDisableAutoScale_594834, schemes: {Scheme.Https})
type
  Call_PoolEnableAutoScale_594845 = ref object of OpenApiRestCall_593438
proc url_PoolEnableAutoScale_594847(protocol: Scheme; host: string; base: string;
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

proc validate_PoolEnableAutoScale_594846(path: JsonNode; query: JsonNode;
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
  var valid_594848 = path.getOrDefault("poolId")
  valid_594848 = validateParameter(valid_594848, JString, required = true,
                                 default = nil)
  if valid_594848 != nil:
    section.add "poolId", valid_594848
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594849 = query.getOrDefault("timeout")
  valid_594849 = validateParameter(valid_594849, JInt, required = false,
                                 default = newJInt(30))
  if valid_594849 != nil:
    section.add "timeout", valid_594849
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594850 = query.getOrDefault("api-version")
  valid_594850 = validateParameter(valid_594850, JString, required = true,
                                 default = nil)
  if valid_594850 != nil:
    section.add "api-version", valid_594850
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
  var valid_594851 = header.getOrDefault("If-Match")
  valid_594851 = validateParameter(valid_594851, JString, required = false,
                                 default = nil)
  if valid_594851 != nil:
    section.add "If-Match", valid_594851
  var valid_594852 = header.getOrDefault("client-request-id")
  valid_594852 = validateParameter(valid_594852, JString, required = false,
                                 default = nil)
  if valid_594852 != nil:
    section.add "client-request-id", valid_594852
  var valid_594853 = header.getOrDefault("ocp-date")
  valid_594853 = validateParameter(valid_594853, JString, required = false,
                                 default = nil)
  if valid_594853 != nil:
    section.add "ocp-date", valid_594853
  var valid_594854 = header.getOrDefault("If-Unmodified-Since")
  valid_594854 = validateParameter(valid_594854, JString, required = false,
                                 default = nil)
  if valid_594854 != nil:
    section.add "If-Unmodified-Since", valid_594854
  var valid_594855 = header.getOrDefault("If-None-Match")
  valid_594855 = validateParameter(valid_594855, JString, required = false,
                                 default = nil)
  if valid_594855 != nil:
    section.add "If-None-Match", valid_594855
  var valid_594856 = header.getOrDefault("If-Modified-Since")
  valid_594856 = validateParameter(valid_594856, JString, required = false,
                                 default = nil)
  if valid_594856 != nil:
    section.add "If-Modified-Since", valid_594856
  var valid_594857 = header.getOrDefault("return-client-request-id")
  valid_594857 = validateParameter(valid_594857, JBool, required = false,
                                 default = newJBool(false))
  if valid_594857 != nil:
    section.add "return-client-request-id", valid_594857
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

proc call*(call_594859: Call_PoolEnableAutoScale_594845; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You cannot enable automatic scaling on a Pool if a resize operation is in progress on the Pool. If automatic scaling of the Pool is currently disabled, you must specify a valid autoscale formula as part of the request. If automatic scaling of the Pool is already enabled, you may specify a new autoscale formula and/or a new evaluation interval. You cannot call this API for the same Pool more than once every 30 seconds.
  ## 
  let valid = call_594859.validator(path, query, header, formData, body)
  let scheme = call_594859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594859.url(scheme.get, call_594859.host, call_594859.base,
                         call_594859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594859, url, valid)

proc call*(call_594860: Call_PoolEnableAutoScale_594845; apiVersion: string;
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
  var path_594861 = newJObject()
  var query_594862 = newJObject()
  var body_594863 = newJObject()
  add(query_594862, "timeout", newJInt(timeout))
  add(query_594862, "api-version", newJString(apiVersion))
  add(path_594861, "poolId", newJString(poolId))
  if poolEnableAutoScaleParameter != nil:
    body_594863 = poolEnableAutoScaleParameter
  result = call_594860.call(path_594861, query_594862, nil, nil, body_594863)

var poolEnableAutoScale* = Call_PoolEnableAutoScale_594845(
    name: "poolEnableAutoScale", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/enableautoscale",
    validator: validate_PoolEnableAutoScale_594846, base: "",
    url: url_PoolEnableAutoScale_594847, schemes: {Scheme.Https})
type
  Call_PoolEvaluateAutoScale_594864 = ref object of OpenApiRestCall_593438
proc url_PoolEvaluateAutoScale_594866(protocol: Scheme; host: string; base: string;
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

proc validate_PoolEvaluateAutoScale_594865(path: JsonNode; query: JsonNode;
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
  var valid_594867 = path.getOrDefault("poolId")
  valid_594867 = validateParameter(valid_594867, JString, required = true,
                                 default = nil)
  if valid_594867 != nil:
    section.add "poolId", valid_594867
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594868 = query.getOrDefault("timeout")
  valid_594868 = validateParameter(valid_594868, JInt, required = false,
                                 default = newJInt(30))
  if valid_594868 != nil:
    section.add "timeout", valid_594868
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594869 = query.getOrDefault("api-version")
  valid_594869 = validateParameter(valid_594869, JString, required = true,
                                 default = nil)
  if valid_594869 != nil:
    section.add "api-version", valid_594869
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594870 = header.getOrDefault("client-request-id")
  valid_594870 = validateParameter(valid_594870, JString, required = false,
                                 default = nil)
  if valid_594870 != nil:
    section.add "client-request-id", valid_594870
  var valid_594871 = header.getOrDefault("ocp-date")
  valid_594871 = validateParameter(valid_594871, JString, required = false,
                                 default = nil)
  if valid_594871 != nil:
    section.add "ocp-date", valid_594871
  var valid_594872 = header.getOrDefault("return-client-request-id")
  valid_594872 = validateParameter(valid_594872, JBool, required = false,
                                 default = newJBool(false))
  if valid_594872 != nil:
    section.add "return-client-request-id", valid_594872
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

proc call*(call_594874: Call_PoolEvaluateAutoScale_594864; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API is primarily for validating an autoscale formula, as it simply returns the result without applying the formula to the Pool. The Pool must have auto scaling enabled in order to evaluate a formula.
  ## 
  let valid = call_594874.validator(path, query, header, formData, body)
  let scheme = call_594874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594874.url(scheme.get, call_594874.host, call_594874.base,
                         call_594874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594874, url, valid)

proc call*(call_594875: Call_PoolEvaluateAutoScale_594864; apiVersion: string;
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
  var path_594876 = newJObject()
  var query_594877 = newJObject()
  var body_594878 = newJObject()
  add(query_594877, "timeout", newJInt(timeout))
  add(query_594877, "api-version", newJString(apiVersion))
  if poolEvaluateAutoScaleParameter != nil:
    body_594878 = poolEvaluateAutoScaleParameter
  add(path_594876, "poolId", newJString(poolId))
  result = call_594875.call(path_594876, query_594877, nil, nil, body_594878)

var poolEvaluateAutoScale* = Call_PoolEvaluateAutoScale_594864(
    name: "poolEvaluateAutoScale", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/evaluateautoscale",
    validator: validate_PoolEvaluateAutoScale_594865, base: "",
    url: url_PoolEvaluateAutoScale_594866, schemes: {Scheme.Https})
type
  Call_ComputeNodeList_594879 = ref object of OpenApiRestCall_593438
proc url_ComputeNodeList_594881(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeList_594880(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool from which you want to list Compute Nodes.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_594882 = path.getOrDefault("poolId")
  valid_594882 = validateParameter(valid_594882, JString, required = true,
                                 default = nil)
  if valid_594882 != nil:
    section.add "poolId", valid_594882
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
  var valid_594883 = query.getOrDefault("timeout")
  valid_594883 = validateParameter(valid_594883, JInt, required = false,
                                 default = newJInt(30))
  if valid_594883 != nil:
    section.add "timeout", valid_594883
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594884 = query.getOrDefault("api-version")
  valid_594884 = validateParameter(valid_594884, JString, required = true,
                                 default = nil)
  if valid_594884 != nil:
    section.add "api-version", valid_594884
  var valid_594885 = query.getOrDefault("maxresults")
  valid_594885 = validateParameter(valid_594885, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594885 != nil:
    section.add "maxresults", valid_594885
  var valid_594886 = query.getOrDefault("$select")
  valid_594886 = validateParameter(valid_594886, JString, required = false,
                                 default = nil)
  if valid_594886 != nil:
    section.add "$select", valid_594886
  var valid_594887 = query.getOrDefault("$filter")
  valid_594887 = validateParameter(valid_594887, JString, required = false,
                                 default = nil)
  if valid_594887 != nil:
    section.add "$filter", valid_594887
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594888 = header.getOrDefault("client-request-id")
  valid_594888 = validateParameter(valid_594888, JString, required = false,
                                 default = nil)
  if valid_594888 != nil:
    section.add "client-request-id", valid_594888
  var valid_594889 = header.getOrDefault("ocp-date")
  valid_594889 = validateParameter(valid_594889, JString, required = false,
                                 default = nil)
  if valid_594889 != nil:
    section.add "ocp-date", valid_594889
  var valid_594890 = header.getOrDefault("return-client-request-id")
  valid_594890 = validateParameter(valid_594890, JBool, required = false,
                                 default = newJBool(false))
  if valid_594890 != nil:
    section.add "return-client-request-id", valid_594890
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594891: Call_ComputeNodeList_594879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594891.validator(path, query, header, formData, body)
  let scheme = call_594891.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594891.url(scheme.get, call_594891.host, call_594891.base,
                         call_594891.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594891, url, valid)

proc call*(call_594892: Call_ComputeNodeList_594879; apiVersion: string;
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
  var path_594893 = newJObject()
  var query_594894 = newJObject()
  add(query_594894, "timeout", newJInt(timeout))
  add(query_594894, "api-version", newJString(apiVersion))
  add(path_594893, "poolId", newJString(poolId))
  add(query_594894, "maxresults", newJInt(maxresults))
  add(query_594894, "$select", newJString(Select))
  add(query_594894, "$filter", newJString(Filter))
  result = call_594892.call(path_594893, query_594894, nil, nil, nil)

var computeNodeList* = Call_ComputeNodeList_594879(name: "computeNodeList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/pools/{poolId}/nodes",
    validator: validate_ComputeNodeList_594880, base: "", url: url_ComputeNodeList_594881,
    schemes: {Scheme.Https})
type
  Call_ComputeNodeGet_594895 = ref object of OpenApiRestCall_593438
proc url_ComputeNodeGet_594897(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeGet_594896(path: JsonNode; query: JsonNode;
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
  var valid_594898 = path.getOrDefault("poolId")
  valid_594898 = validateParameter(valid_594898, JString, required = true,
                                 default = nil)
  if valid_594898 != nil:
    section.add "poolId", valid_594898
  var valid_594899 = path.getOrDefault("nodeId")
  valid_594899 = validateParameter(valid_594899, JString, required = true,
                                 default = nil)
  if valid_594899 != nil:
    section.add "nodeId", valid_594899
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $select: JString
  ##          : An OData $select clause.
  section = newJObject()
  var valid_594900 = query.getOrDefault("timeout")
  valid_594900 = validateParameter(valid_594900, JInt, required = false,
                                 default = newJInt(30))
  if valid_594900 != nil:
    section.add "timeout", valid_594900
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594901 = query.getOrDefault("api-version")
  valid_594901 = validateParameter(valid_594901, JString, required = true,
                                 default = nil)
  if valid_594901 != nil:
    section.add "api-version", valid_594901
  var valid_594902 = query.getOrDefault("$select")
  valid_594902 = validateParameter(valid_594902, JString, required = false,
                                 default = nil)
  if valid_594902 != nil:
    section.add "$select", valid_594902
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594903 = header.getOrDefault("client-request-id")
  valid_594903 = validateParameter(valid_594903, JString, required = false,
                                 default = nil)
  if valid_594903 != nil:
    section.add "client-request-id", valid_594903
  var valid_594904 = header.getOrDefault("ocp-date")
  valid_594904 = validateParameter(valid_594904, JString, required = false,
                                 default = nil)
  if valid_594904 != nil:
    section.add "ocp-date", valid_594904
  var valid_594905 = header.getOrDefault("return-client-request-id")
  valid_594905 = validateParameter(valid_594905, JBool, required = false,
                                 default = newJBool(false))
  if valid_594905 != nil:
    section.add "return-client-request-id", valid_594905
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594906: Call_ComputeNodeGet_594895; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594906.validator(path, query, header, formData, body)
  let scheme = call_594906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594906.url(scheme.get, call_594906.host, call_594906.base,
                         call_594906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594906, url, valid)

proc call*(call_594907: Call_ComputeNodeGet_594895; apiVersion: string;
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
  var path_594908 = newJObject()
  var query_594909 = newJObject()
  add(query_594909, "timeout", newJInt(timeout))
  add(query_594909, "api-version", newJString(apiVersion))
  add(path_594908, "poolId", newJString(poolId))
  add(path_594908, "nodeId", newJString(nodeId))
  add(query_594909, "$select", newJString(Select))
  result = call_594907.call(path_594908, query_594909, nil, nil, nil)

var computeNodeGet* = Call_ComputeNodeGet_594895(name: "computeNodeGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}", validator: validate_ComputeNodeGet_594896,
    base: "", url: url_ComputeNodeGet_594897, schemes: {Scheme.Https})
type
  Call_ComputeNodeDisableScheduling_594910 = ref object of OpenApiRestCall_593438
proc url_ComputeNodeDisableScheduling_594912(protocol: Scheme; host: string;
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

proc validate_ComputeNodeDisableScheduling_594911(path: JsonNode; query: JsonNode;
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
  var valid_594913 = path.getOrDefault("poolId")
  valid_594913 = validateParameter(valid_594913, JString, required = true,
                                 default = nil)
  if valid_594913 != nil:
    section.add "poolId", valid_594913
  var valid_594914 = path.getOrDefault("nodeId")
  valid_594914 = validateParameter(valid_594914, JString, required = true,
                                 default = nil)
  if valid_594914 != nil:
    section.add "nodeId", valid_594914
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594915 = query.getOrDefault("timeout")
  valid_594915 = validateParameter(valid_594915, JInt, required = false,
                                 default = newJInt(30))
  if valid_594915 != nil:
    section.add "timeout", valid_594915
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594916 = query.getOrDefault("api-version")
  valid_594916 = validateParameter(valid_594916, JString, required = true,
                                 default = nil)
  if valid_594916 != nil:
    section.add "api-version", valid_594916
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594917 = header.getOrDefault("client-request-id")
  valid_594917 = validateParameter(valid_594917, JString, required = false,
                                 default = nil)
  if valid_594917 != nil:
    section.add "client-request-id", valid_594917
  var valid_594918 = header.getOrDefault("ocp-date")
  valid_594918 = validateParameter(valid_594918, JString, required = false,
                                 default = nil)
  if valid_594918 != nil:
    section.add "ocp-date", valid_594918
  var valid_594919 = header.getOrDefault("return-client-request-id")
  valid_594919 = validateParameter(valid_594919, JBool, required = false,
                                 default = newJBool(false))
  if valid_594919 != nil:
    section.add "return-client-request-id", valid_594919
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeDisableSchedulingParameter: JObject
  ##                                 : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594921: Call_ComputeNodeDisableScheduling_594910; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can disable Task scheduling on a Compute Node only if its current scheduling state is enabled.
  ## 
  let valid = call_594921.validator(path, query, header, formData, body)
  let scheme = call_594921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594921.url(scheme.get, call_594921.host, call_594921.base,
                         call_594921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594921, url, valid)

proc call*(call_594922: Call_ComputeNodeDisableScheduling_594910;
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
  var path_594923 = newJObject()
  var query_594924 = newJObject()
  var body_594925 = newJObject()
  add(query_594924, "timeout", newJInt(timeout))
  add(query_594924, "api-version", newJString(apiVersion))
  add(path_594923, "poolId", newJString(poolId))
  add(path_594923, "nodeId", newJString(nodeId))
  if nodeDisableSchedulingParameter != nil:
    body_594925 = nodeDisableSchedulingParameter
  result = call_594922.call(path_594923, query_594924, nil, nil, body_594925)

var computeNodeDisableScheduling* = Call_ComputeNodeDisableScheduling_594910(
    name: "computeNodeDisableScheduling", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/disablescheduling",
    validator: validate_ComputeNodeDisableScheduling_594911, base: "",
    url: url_ComputeNodeDisableScheduling_594912, schemes: {Scheme.Https})
type
  Call_ComputeNodeEnableScheduling_594926 = ref object of OpenApiRestCall_593438
proc url_ComputeNodeEnableScheduling_594928(protocol: Scheme; host: string;
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

proc validate_ComputeNodeEnableScheduling_594927(path: JsonNode; query: JsonNode;
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
  var valid_594929 = path.getOrDefault("poolId")
  valid_594929 = validateParameter(valid_594929, JString, required = true,
                                 default = nil)
  if valid_594929 != nil:
    section.add "poolId", valid_594929
  var valid_594930 = path.getOrDefault("nodeId")
  valid_594930 = validateParameter(valid_594930, JString, required = true,
                                 default = nil)
  if valid_594930 != nil:
    section.add "nodeId", valid_594930
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594931 = query.getOrDefault("timeout")
  valid_594931 = validateParameter(valid_594931, JInt, required = false,
                                 default = newJInt(30))
  if valid_594931 != nil:
    section.add "timeout", valid_594931
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594932 = query.getOrDefault("api-version")
  valid_594932 = validateParameter(valid_594932, JString, required = true,
                                 default = nil)
  if valid_594932 != nil:
    section.add "api-version", valid_594932
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594933 = header.getOrDefault("client-request-id")
  valid_594933 = validateParameter(valid_594933, JString, required = false,
                                 default = nil)
  if valid_594933 != nil:
    section.add "client-request-id", valid_594933
  var valid_594934 = header.getOrDefault("ocp-date")
  valid_594934 = validateParameter(valid_594934, JString, required = false,
                                 default = nil)
  if valid_594934 != nil:
    section.add "ocp-date", valid_594934
  var valid_594935 = header.getOrDefault("return-client-request-id")
  valid_594935 = validateParameter(valid_594935, JBool, required = false,
                                 default = newJBool(false))
  if valid_594935 != nil:
    section.add "return-client-request-id", valid_594935
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594936: Call_ComputeNodeEnableScheduling_594926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can enable Task scheduling on a Compute Node only if its current scheduling state is disabled
  ## 
  let valid = call_594936.validator(path, query, header, formData, body)
  let scheme = call_594936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594936.url(scheme.get, call_594936.host, call_594936.base,
                         call_594936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594936, url, valid)

proc call*(call_594937: Call_ComputeNodeEnableScheduling_594926;
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
  var path_594938 = newJObject()
  var query_594939 = newJObject()
  add(query_594939, "timeout", newJInt(timeout))
  add(query_594939, "api-version", newJString(apiVersion))
  add(path_594938, "poolId", newJString(poolId))
  add(path_594938, "nodeId", newJString(nodeId))
  result = call_594937.call(path_594938, query_594939, nil, nil, nil)

var computeNodeEnableScheduling* = Call_ComputeNodeEnableScheduling_594926(
    name: "computeNodeEnableScheduling", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/enablescheduling",
    validator: validate_ComputeNodeEnableScheduling_594927, base: "",
    url: url_ComputeNodeEnableScheduling_594928, schemes: {Scheme.Https})
type
  Call_FileListFromComputeNode_594940 = ref object of OpenApiRestCall_593438
proc url_FileListFromComputeNode_594942(protocol: Scheme; host: string; base: string;
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

proc validate_FileListFromComputeNode_594941(path: JsonNode; query: JsonNode;
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
  var valid_594943 = path.getOrDefault("poolId")
  valid_594943 = validateParameter(valid_594943, JString, required = true,
                                 default = nil)
  if valid_594943 != nil:
    section.add "poolId", valid_594943
  var valid_594944 = path.getOrDefault("nodeId")
  valid_594944 = validateParameter(valid_594944, JString, required = true,
                                 default = nil)
  if valid_594944 != nil:
    section.add "nodeId", valid_594944
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
  var valid_594945 = query.getOrDefault("timeout")
  valid_594945 = validateParameter(valid_594945, JInt, required = false,
                                 default = newJInt(30))
  if valid_594945 != nil:
    section.add "timeout", valid_594945
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594946 = query.getOrDefault("api-version")
  valid_594946 = validateParameter(valid_594946, JString, required = true,
                                 default = nil)
  if valid_594946 != nil:
    section.add "api-version", valid_594946
  var valid_594947 = query.getOrDefault("maxresults")
  valid_594947 = validateParameter(valid_594947, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594947 != nil:
    section.add "maxresults", valid_594947
  var valid_594948 = query.getOrDefault("$filter")
  valid_594948 = validateParameter(valid_594948, JString, required = false,
                                 default = nil)
  if valid_594948 != nil:
    section.add "$filter", valid_594948
  var valid_594949 = query.getOrDefault("recursive")
  valid_594949 = validateParameter(valid_594949, JBool, required = false, default = nil)
  if valid_594949 != nil:
    section.add "recursive", valid_594949
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594950 = header.getOrDefault("client-request-id")
  valid_594950 = validateParameter(valid_594950, JString, required = false,
                                 default = nil)
  if valid_594950 != nil:
    section.add "client-request-id", valid_594950
  var valid_594951 = header.getOrDefault("ocp-date")
  valid_594951 = validateParameter(valid_594951, JString, required = false,
                                 default = nil)
  if valid_594951 != nil:
    section.add "ocp-date", valid_594951
  var valid_594952 = header.getOrDefault("return-client-request-id")
  valid_594952 = validateParameter(valid_594952, JBool, required = false,
                                 default = newJBool(false))
  if valid_594952 != nil:
    section.add "return-client-request-id", valid_594952
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594953: Call_FileListFromComputeNode_594940; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594953.validator(path, query, header, formData, body)
  let scheme = call_594953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594953.url(scheme.get, call_594953.host, call_594953.base,
                         call_594953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594953, url, valid)

proc call*(call_594954: Call_FileListFromComputeNode_594940; apiVersion: string;
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
  var path_594955 = newJObject()
  var query_594956 = newJObject()
  add(query_594956, "timeout", newJInt(timeout))
  add(query_594956, "api-version", newJString(apiVersion))
  add(path_594955, "poolId", newJString(poolId))
  add(path_594955, "nodeId", newJString(nodeId))
  add(query_594956, "maxresults", newJInt(maxresults))
  add(query_594956, "$filter", newJString(Filter))
  add(query_594956, "recursive", newJBool(recursive))
  result = call_594954.call(path_594955, query_594956, nil, nil, nil)

var fileListFromComputeNode* = Call_FileListFromComputeNode_594940(
    name: "fileListFromComputeNode", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/files",
    validator: validate_FileListFromComputeNode_594941, base: "",
    url: url_FileListFromComputeNode_594942, schemes: {Scheme.Https})
type
  Call_FileGetPropertiesFromComputeNode_594991 = ref object of OpenApiRestCall_593438
proc url_FileGetPropertiesFromComputeNode_594993(protocol: Scheme; host: string;
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

proc validate_FileGetPropertiesFromComputeNode_594992(path: JsonNode;
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
  var valid_594994 = path.getOrDefault("poolId")
  valid_594994 = validateParameter(valid_594994, JString, required = true,
                                 default = nil)
  if valid_594994 != nil:
    section.add "poolId", valid_594994
  var valid_594995 = path.getOrDefault("nodeId")
  valid_594995 = validateParameter(valid_594995, JString, required = true,
                                 default = nil)
  if valid_594995 != nil:
    section.add "nodeId", valid_594995
  var valid_594996 = path.getOrDefault("filePath")
  valid_594996 = validateParameter(valid_594996, JString, required = true,
                                 default = nil)
  if valid_594996 != nil:
    section.add "filePath", valid_594996
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594997 = query.getOrDefault("timeout")
  valid_594997 = validateParameter(valid_594997, JInt, required = false,
                                 default = newJInt(30))
  if valid_594997 != nil:
    section.add "timeout", valid_594997
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594998 = query.getOrDefault("api-version")
  valid_594998 = validateParameter(valid_594998, JString, required = true,
                                 default = nil)
  if valid_594998 != nil:
    section.add "api-version", valid_594998
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
  var valid_594999 = header.getOrDefault("client-request-id")
  valid_594999 = validateParameter(valid_594999, JString, required = false,
                                 default = nil)
  if valid_594999 != nil:
    section.add "client-request-id", valid_594999
  var valid_595000 = header.getOrDefault("ocp-date")
  valid_595000 = validateParameter(valid_595000, JString, required = false,
                                 default = nil)
  if valid_595000 != nil:
    section.add "ocp-date", valid_595000
  var valid_595001 = header.getOrDefault("If-Unmodified-Since")
  valid_595001 = validateParameter(valid_595001, JString, required = false,
                                 default = nil)
  if valid_595001 != nil:
    section.add "If-Unmodified-Since", valid_595001
  var valid_595002 = header.getOrDefault("If-Modified-Since")
  valid_595002 = validateParameter(valid_595002, JString, required = false,
                                 default = nil)
  if valid_595002 != nil:
    section.add "If-Modified-Since", valid_595002
  var valid_595003 = header.getOrDefault("return-client-request-id")
  valid_595003 = validateParameter(valid_595003, JBool, required = false,
                                 default = newJBool(false))
  if valid_595003 != nil:
    section.add "return-client-request-id", valid_595003
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595004: Call_FileGetPropertiesFromComputeNode_594991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the properties of the specified Compute Node file.
  ## 
  let valid = call_595004.validator(path, query, header, formData, body)
  let scheme = call_595004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595004.url(scheme.get, call_595004.host, call_595004.base,
                         call_595004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595004, url, valid)

proc call*(call_595005: Call_FileGetPropertiesFromComputeNode_594991;
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
  var path_595006 = newJObject()
  var query_595007 = newJObject()
  add(query_595007, "timeout", newJInt(timeout))
  add(query_595007, "api-version", newJString(apiVersion))
  add(path_595006, "poolId", newJString(poolId))
  add(path_595006, "nodeId", newJString(nodeId))
  add(path_595006, "filePath", newJString(filePath))
  result = call_595005.call(path_595006, query_595007, nil, nil, nil)

var fileGetPropertiesFromComputeNode* = Call_FileGetPropertiesFromComputeNode_594991(
    name: "fileGetPropertiesFromComputeNode", meth: HttpMethod.HttpHead,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/files/{filePath}",
    validator: validate_FileGetPropertiesFromComputeNode_594992, base: "",
    url: url_FileGetPropertiesFromComputeNode_594993, schemes: {Scheme.Https})
type
  Call_FileGetFromComputeNode_594957 = ref object of OpenApiRestCall_593438
proc url_FileGetFromComputeNode_594959(protocol: Scheme; host: string; base: string;
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

proc validate_FileGetFromComputeNode_594958(path: JsonNode; query: JsonNode;
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
  var valid_594960 = path.getOrDefault("poolId")
  valid_594960 = validateParameter(valid_594960, JString, required = true,
                                 default = nil)
  if valid_594960 != nil:
    section.add "poolId", valid_594960
  var valid_594961 = path.getOrDefault("nodeId")
  valid_594961 = validateParameter(valid_594961, JString, required = true,
                                 default = nil)
  if valid_594961 != nil:
    section.add "nodeId", valid_594961
  var valid_594962 = path.getOrDefault("filePath")
  valid_594962 = validateParameter(valid_594962, JString, required = true,
                                 default = nil)
  if valid_594962 != nil:
    section.add "filePath", valid_594962
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_594963 = query.getOrDefault("timeout")
  valid_594963 = validateParameter(valid_594963, JInt, required = false,
                                 default = newJInt(30))
  if valid_594963 != nil:
    section.add "timeout", valid_594963
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594964 = query.getOrDefault("api-version")
  valid_594964 = validateParameter(valid_594964, JString, required = true,
                                 default = nil)
  if valid_594964 != nil:
    section.add "api-version", valid_594964
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
  var valid_594965 = header.getOrDefault("client-request-id")
  valid_594965 = validateParameter(valid_594965, JString, required = false,
                                 default = nil)
  if valid_594965 != nil:
    section.add "client-request-id", valid_594965
  var valid_594966 = header.getOrDefault("ocp-date")
  valid_594966 = validateParameter(valid_594966, JString, required = false,
                                 default = nil)
  if valid_594966 != nil:
    section.add "ocp-date", valid_594966
  var valid_594967 = header.getOrDefault("If-Unmodified-Since")
  valid_594967 = validateParameter(valid_594967, JString, required = false,
                                 default = nil)
  if valid_594967 != nil:
    section.add "If-Unmodified-Since", valid_594967
  var valid_594968 = header.getOrDefault("ocp-range")
  valid_594968 = validateParameter(valid_594968, JString, required = false,
                                 default = nil)
  if valid_594968 != nil:
    section.add "ocp-range", valid_594968
  var valid_594969 = header.getOrDefault("If-Modified-Since")
  valid_594969 = validateParameter(valid_594969, JString, required = false,
                                 default = nil)
  if valid_594969 != nil:
    section.add "If-Modified-Since", valid_594969
  var valid_594970 = header.getOrDefault("return-client-request-id")
  valid_594970 = validateParameter(valid_594970, JBool, required = false,
                                 default = newJBool(false))
  if valid_594970 != nil:
    section.add "return-client-request-id", valid_594970
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594971: Call_FileGetFromComputeNode_594957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the content of the specified Compute Node file.
  ## 
  let valid = call_594971.validator(path, query, header, formData, body)
  let scheme = call_594971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594971.url(scheme.get, call_594971.host, call_594971.base,
                         call_594971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594971, url, valid)

proc call*(call_594972: Call_FileGetFromComputeNode_594957; apiVersion: string;
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
  var path_594973 = newJObject()
  var query_594974 = newJObject()
  add(query_594974, "timeout", newJInt(timeout))
  add(query_594974, "api-version", newJString(apiVersion))
  add(path_594973, "poolId", newJString(poolId))
  add(path_594973, "nodeId", newJString(nodeId))
  add(path_594973, "filePath", newJString(filePath))
  result = call_594972.call(path_594973, query_594974, nil, nil, nil)

var fileGetFromComputeNode* = Call_FileGetFromComputeNode_594957(
    name: "fileGetFromComputeNode", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/files/{filePath}",
    validator: validate_FileGetFromComputeNode_594958, base: "",
    url: url_FileGetFromComputeNode_594959, schemes: {Scheme.Https})
type
  Call_FileDeleteFromComputeNode_594975 = ref object of OpenApiRestCall_593438
proc url_FileDeleteFromComputeNode_594977(protocol: Scheme; host: string;
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

proc validate_FileDeleteFromComputeNode_594976(path: JsonNode; query: JsonNode;
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
  var valid_594978 = path.getOrDefault("poolId")
  valid_594978 = validateParameter(valid_594978, JString, required = true,
                                 default = nil)
  if valid_594978 != nil:
    section.add "poolId", valid_594978
  var valid_594979 = path.getOrDefault("nodeId")
  valid_594979 = validateParameter(valid_594979, JString, required = true,
                                 default = nil)
  if valid_594979 != nil:
    section.add "nodeId", valid_594979
  var valid_594980 = path.getOrDefault("filePath")
  valid_594980 = validateParameter(valid_594980, JString, required = true,
                                 default = nil)
  if valid_594980 != nil:
    section.add "filePath", valid_594980
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   recursive: JBool
  ##            : Whether to delete children of a directory. If the filePath parameter represents a directory instead of a file, you can set recursive to true to delete the directory and all of the files and subdirectories in it. If recursive is false then the directory must be empty or deletion will fail.
  section = newJObject()
  var valid_594981 = query.getOrDefault("timeout")
  valid_594981 = validateParameter(valid_594981, JInt, required = false,
                                 default = newJInt(30))
  if valid_594981 != nil:
    section.add "timeout", valid_594981
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594982 = query.getOrDefault("api-version")
  valid_594982 = validateParameter(valid_594982, JString, required = true,
                                 default = nil)
  if valid_594982 != nil:
    section.add "api-version", valid_594982
  var valid_594983 = query.getOrDefault("recursive")
  valid_594983 = validateParameter(valid_594983, JBool, required = false, default = nil)
  if valid_594983 != nil:
    section.add "recursive", valid_594983
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_594984 = header.getOrDefault("client-request-id")
  valid_594984 = validateParameter(valid_594984, JString, required = false,
                                 default = nil)
  if valid_594984 != nil:
    section.add "client-request-id", valid_594984
  var valid_594985 = header.getOrDefault("ocp-date")
  valid_594985 = validateParameter(valid_594985, JString, required = false,
                                 default = nil)
  if valid_594985 != nil:
    section.add "ocp-date", valid_594985
  var valid_594986 = header.getOrDefault("return-client-request-id")
  valid_594986 = validateParameter(valid_594986, JBool, required = false,
                                 default = newJBool(false))
  if valid_594986 != nil:
    section.add "return-client-request-id", valid_594986
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594987: Call_FileDeleteFromComputeNode_594975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594987.validator(path, query, header, formData, body)
  let scheme = call_594987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594987.url(scheme.get, call_594987.host, call_594987.base,
                         call_594987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594987, url, valid)

proc call*(call_594988: Call_FileDeleteFromComputeNode_594975; apiVersion: string;
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
  var path_594989 = newJObject()
  var query_594990 = newJObject()
  add(query_594990, "timeout", newJInt(timeout))
  add(query_594990, "api-version", newJString(apiVersion))
  add(path_594989, "poolId", newJString(poolId))
  add(path_594989, "nodeId", newJString(nodeId))
  add(path_594989, "filePath", newJString(filePath))
  add(query_594990, "recursive", newJBool(recursive))
  result = call_594988.call(path_594989, query_594990, nil, nil, nil)

var fileDeleteFromComputeNode* = Call_FileDeleteFromComputeNode_594975(
    name: "fileDeleteFromComputeNode", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/files/{filePath}",
    validator: validate_FileDeleteFromComputeNode_594976, base: "",
    url: url_FileDeleteFromComputeNode_594977, schemes: {Scheme.Https})
type
  Call_ComputeNodeGetRemoteDesktop_595008 = ref object of OpenApiRestCall_593438
proc url_ComputeNodeGetRemoteDesktop_595010(protocol: Scheme; host: string;
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

proc validate_ComputeNodeGetRemoteDesktop_595009(path: JsonNode; query: JsonNode;
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
  var valid_595011 = path.getOrDefault("poolId")
  valid_595011 = validateParameter(valid_595011, JString, required = true,
                                 default = nil)
  if valid_595011 != nil:
    section.add "poolId", valid_595011
  var valid_595012 = path.getOrDefault("nodeId")
  valid_595012 = validateParameter(valid_595012, JString, required = true,
                                 default = nil)
  if valid_595012 != nil:
    section.add "nodeId", valid_595012
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_595013 = query.getOrDefault("timeout")
  valid_595013 = validateParameter(valid_595013, JInt, required = false,
                                 default = newJInt(30))
  if valid_595013 != nil:
    section.add "timeout", valid_595013
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595014 = query.getOrDefault("api-version")
  valid_595014 = validateParameter(valid_595014, JString, required = true,
                                 default = nil)
  if valid_595014 != nil:
    section.add "api-version", valid_595014
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_595015 = header.getOrDefault("client-request-id")
  valid_595015 = validateParameter(valid_595015, JString, required = false,
                                 default = nil)
  if valid_595015 != nil:
    section.add "client-request-id", valid_595015
  var valid_595016 = header.getOrDefault("ocp-date")
  valid_595016 = validateParameter(valid_595016, JString, required = false,
                                 default = nil)
  if valid_595016 != nil:
    section.add "ocp-date", valid_595016
  var valid_595017 = header.getOrDefault("return-client-request-id")
  valid_595017 = validateParameter(valid_595017, JBool, required = false,
                                 default = newJBool(false))
  if valid_595017 != nil:
    section.add "return-client-request-id", valid_595017
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595018: Call_ComputeNodeGetRemoteDesktop_595008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Before you can access a Compute Node by using the RDP file, you must create a user Account on the Compute Node. This API can only be invoked on Pools created with a cloud service configuration. For Pools created with a virtual machine configuration, see the GetRemoteLoginSettings API.
  ## 
  let valid = call_595018.validator(path, query, header, formData, body)
  let scheme = call_595018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595018.url(scheme.get, call_595018.host, call_595018.base,
                         call_595018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595018, url, valid)

proc call*(call_595019: Call_ComputeNodeGetRemoteDesktop_595008;
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
  var path_595020 = newJObject()
  var query_595021 = newJObject()
  add(query_595021, "timeout", newJInt(timeout))
  add(query_595021, "api-version", newJString(apiVersion))
  add(path_595020, "poolId", newJString(poolId))
  add(path_595020, "nodeId", newJString(nodeId))
  result = call_595019.call(path_595020, query_595021, nil, nil, nil)

var computeNodeGetRemoteDesktop* = Call_ComputeNodeGetRemoteDesktop_595008(
    name: "computeNodeGetRemoteDesktop", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/pools/{poolId}/nodes/{nodeId}/rdp",
    validator: validate_ComputeNodeGetRemoteDesktop_595009, base: "",
    url: url_ComputeNodeGetRemoteDesktop_595010, schemes: {Scheme.Https})
type
  Call_ComputeNodeReboot_595022 = ref object of OpenApiRestCall_593438
proc url_ComputeNodeReboot_595024(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeReboot_595023(path: JsonNode; query: JsonNode;
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
  var valid_595025 = path.getOrDefault("poolId")
  valid_595025 = validateParameter(valid_595025, JString, required = true,
                                 default = nil)
  if valid_595025 != nil:
    section.add "poolId", valid_595025
  var valid_595026 = path.getOrDefault("nodeId")
  valid_595026 = validateParameter(valid_595026, JString, required = true,
                                 default = nil)
  if valid_595026 != nil:
    section.add "nodeId", valid_595026
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_595027 = query.getOrDefault("timeout")
  valid_595027 = validateParameter(valid_595027, JInt, required = false,
                                 default = newJInt(30))
  if valid_595027 != nil:
    section.add "timeout", valid_595027
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595028 = query.getOrDefault("api-version")
  valid_595028 = validateParameter(valid_595028, JString, required = true,
                                 default = nil)
  if valid_595028 != nil:
    section.add "api-version", valid_595028
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_595029 = header.getOrDefault("client-request-id")
  valid_595029 = validateParameter(valid_595029, JString, required = false,
                                 default = nil)
  if valid_595029 != nil:
    section.add "client-request-id", valid_595029
  var valid_595030 = header.getOrDefault("ocp-date")
  valid_595030 = validateParameter(valid_595030, JString, required = false,
                                 default = nil)
  if valid_595030 != nil:
    section.add "ocp-date", valid_595030
  var valid_595031 = header.getOrDefault("return-client-request-id")
  valid_595031 = validateParameter(valid_595031, JBool, required = false,
                                 default = newJBool(false))
  if valid_595031 != nil:
    section.add "return-client-request-id", valid_595031
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeRebootParameter: JObject
  ##                      : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595033: Call_ComputeNodeReboot_595022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can restart a Compute Node only if it is in an idle or running state.
  ## 
  let valid = call_595033.validator(path, query, header, formData, body)
  let scheme = call_595033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595033.url(scheme.get, call_595033.host, call_595033.base,
                         call_595033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595033, url, valid)

proc call*(call_595034: Call_ComputeNodeReboot_595022; apiVersion: string;
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
  var path_595035 = newJObject()
  var query_595036 = newJObject()
  var body_595037 = newJObject()
  add(query_595036, "timeout", newJInt(timeout))
  add(query_595036, "api-version", newJString(apiVersion))
  if nodeRebootParameter != nil:
    body_595037 = nodeRebootParameter
  add(path_595035, "poolId", newJString(poolId))
  add(path_595035, "nodeId", newJString(nodeId))
  result = call_595034.call(path_595035, query_595036, nil, nil, body_595037)

var computeNodeReboot* = Call_ComputeNodeReboot_595022(name: "computeNodeReboot",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/reboot",
    validator: validate_ComputeNodeReboot_595023, base: "",
    url: url_ComputeNodeReboot_595024, schemes: {Scheme.Https})
type
  Call_ComputeNodeReimage_595038 = ref object of OpenApiRestCall_593438
proc url_ComputeNodeReimage_595040(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeReimage_595039(path: JsonNode; query: JsonNode;
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
  var valid_595041 = path.getOrDefault("poolId")
  valid_595041 = validateParameter(valid_595041, JString, required = true,
                                 default = nil)
  if valid_595041 != nil:
    section.add "poolId", valid_595041
  var valid_595042 = path.getOrDefault("nodeId")
  valid_595042 = validateParameter(valid_595042, JString, required = true,
                                 default = nil)
  if valid_595042 != nil:
    section.add "nodeId", valid_595042
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_595043 = query.getOrDefault("timeout")
  valid_595043 = validateParameter(valid_595043, JInt, required = false,
                                 default = newJInt(30))
  if valid_595043 != nil:
    section.add "timeout", valid_595043
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595044 = query.getOrDefault("api-version")
  valid_595044 = validateParameter(valid_595044, JString, required = true,
                                 default = nil)
  if valid_595044 != nil:
    section.add "api-version", valid_595044
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_595045 = header.getOrDefault("client-request-id")
  valid_595045 = validateParameter(valid_595045, JString, required = false,
                                 default = nil)
  if valid_595045 != nil:
    section.add "client-request-id", valid_595045
  var valid_595046 = header.getOrDefault("ocp-date")
  valid_595046 = validateParameter(valid_595046, JString, required = false,
                                 default = nil)
  if valid_595046 != nil:
    section.add "ocp-date", valid_595046
  var valid_595047 = header.getOrDefault("return-client-request-id")
  valid_595047 = validateParameter(valid_595047, JBool, required = false,
                                 default = newJBool(false))
  if valid_595047 != nil:
    section.add "return-client-request-id", valid_595047
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeReimageParameter: JObject
  ##                       : The parameters for the request.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595049: Call_ComputeNodeReimage_595038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can reinstall the operating system on a Compute Node only if it is in an idle or running state. This API can be invoked only on Pools created with the cloud service configuration property.
  ## 
  let valid = call_595049.validator(path, query, header, formData, body)
  let scheme = call_595049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595049.url(scheme.get, call_595049.host, call_595049.base,
                         call_595049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595049, url, valid)

proc call*(call_595050: Call_ComputeNodeReimage_595038; apiVersion: string;
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
  var path_595051 = newJObject()
  var query_595052 = newJObject()
  var body_595053 = newJObject()
  add(query_595052, "timeout", newJInt(timeout))
  add(query_595052, "api-version", newJString(apiVersion))
  add(path_595051, "poolId", newJString(poolId))
  add(path_595051, "nodeId", newJString(nodeId))
  if nodeReimageParameter != nil:
    body_595053 = nodeReimageParameter
  result = call_595050.call(path_595051, query_595052, nil, nil, body_595053)

var computeNodeReimage* = Call_ComputeNodeReimage_595038(
    name: "computeNodeReimage", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/reimage",
    validator: validate_ComputeNodeReimage_595039, base: "",
    url: url_ComputeNodeReimage_595040, schemes: {Scheme.Https})
type
  Call_ComputeNodeGetRemoteLoginSettings_595054 = ref object of OpenApiRestCall_593438
proc url_ComputeNodeGetRemoteLoginSettings_595056(protocol: Scheme; host: string;
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

proc validate_ComputeNodeGetRemoteLoginSettings_595055(path: JsonNode;
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
  var valid_595057 = path.getOrDefault("poolId")
  valid_595057 = validateParameter(valid_595057, JString, required = true,
                                 default = nil)
  if valid_595057 != nil:
    section.add "poolId", valid_595057
  var valid_595058 = path.getOrDefault("nodeId")
  valid_595058 = validateParameter(valid_595058, JString, required = true,
                                 default = nil)
  if valid_595058 != nil:
    section.add "nodeId", valid_595058
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_595059 = query.getOrDefault("timeout")
  valid_595059 = validateParameter(valid_595059, JInt, required = false,
                                 default = newJInt(30))
  if valid_595059 != nil:
    section.add "timeout", valid_595059
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595060 = query.getOrDefault("api-version")
  valid_595060 = validateParameter(valid_595060, JString, required = true,
                                 default = nil)
  if valid_595060 != nil:
    section.add "api-version", valid_595060
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_595061 = header.getOrDefault("client-request-id")
  valid_595061 = validateParameter(valid_595061, JString, required = false,
                                 default = nil)
  if valid_595061 != nil:
    section.add "client-request-id", valid_595061
  var valid_595062 = header.getOrDefault("ocp-date")
  valid_595062 = validateParameter(valid_595062, JString, required = false,
                                 default = nil)
  if valid_595062 != nil:
    section.add "ocp-date", valid_595062
  var valid_595063 = header.getOrDefault("return-client-request-id")
  valid_595063 = validateParameter(valid_595063, JBool, required = false,
                                 default = newJBool(false))
  if valid_595063 != nil:
    section.add "return-client-request-id", valid_595063
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595064: Call_ComputeNodeGetRemoteLoginSettings_595054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Before you can remotely login to a Compute Node using the remote login settings, you must create a user Account on the Compute Node. This API can be invoked only on Pools created with the virtual machine configuration property. For Pools created with a cloud service configuration, see the GetRemoteDesktop API.
  ## 
  let valid = call_595064.validator(path, query, header, formData, body)
  let scheme = call_595064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595064.url(scheme.get, call_595064.host, call_595064.base,
                         call_595064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595064, url, valid)

proc call*(call_595065: Call_ComputeNodeGetRemoteLoginSettings_595054;
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
  var path_595066 = newJObject()
  var query_595067 = newJObject()
  add(query_595067, "timeout", newJInt(timeout))
  add(query_595067, "api-version", newJString(apiVersion))
  add(path_595066, "poolId", newJString(poolId))
  add(path_595066, "nodeId", newJString(nodeId))
  result = call_595065.call(path_595066, query_595067, nil, nil, nil)

var computeNodeGetRemoteLoginSettings* = Call_ComputeNodeGetRemoteLoginSettings_595054(
    name: "computeNodeGetRemoteLoginSettings", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/remoteloginsettings",
    validator: validate_ComputeNodeGetRemoteLoginSettings_595055, base: "",
    url: url_ComputeNodeGetRemoteLoginSettings_595056, schemes: {Scheme.Https})
type
  Call_ComputeNodeUploadBatchServiceLogs_595068 = ref object of OpenApiRestCall_593438
proc url_ComputeNodeUploadBatchServiceLogs_595070(protocol: Scheme; host: string;
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

proc validate_ComputeNodeUploadBatchServiceLogs_595069(path: JsonNode;
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
  var valid_595071 = path.getOrDefault("poolId")
  valid_595071 = validateParameter(valid_595071, JString, required = true,
                                 default = nil)
  if valid_595071 != nil:
    section.add "poolId", valid_595071
  var valid_595072 = path.getOrDefault("nodeId")
  valid_595072 = validateParameter(valid_595072, JString, required = true,
                                 default = nil)
  if valid_595072 != nil:
    section.add "nodeId", valid_595072
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_595073 = query.getOrDefault("timeout")
  valid_595073 = validateParameter(valid_595073, JInt, required = false,
                                 default = newJInt(30))
  if valid_595073 != nil:
    section.add "timeout", valid_595073
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595074 = query.getOrDefault("api-version")
  valid_595074 = validateParameter(valid_595074, JString, required = true,
                                 default = nil)
  if valid_595074 != nil:
    section.add "api-version", valid_595074
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_595075 = header.getOrDefault("client-request-id")
  valid_595075 = validateParameter(valid_595075, JString, required = false,
                                 default = nil)
  if valid_595075 != nil:
    section.add "client-request-id", valid_595075
  var valid_595076 = header.getOrDefault("ocp-date")
  valid_595076 = validateParameter(valid_595076, JString, required = false,
                                 default = nil)
  if valid_595076 != nil:
    section.add "ocp-date", valid_595076
  var valid_595077 = header.getOrDefault("return-client-request-id")
  valid_595077 = validateParameter(valid_595077, JBool, required = false,
                                 default = newJBool(false))
  if valid_595077 != nil:
    section.add "return-client-request-id", valid_595077
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

proc call*(call_595079: Call_ComputeNodeUploadBatchServiceLogs_595068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This is for gathering Azure Batch service log files in an automated fashion from Compute Nodes if you are experiencing an error and wish to escalate to Azure support. The Azure Batch service log files should be shared with Azure support to aid in debugging issues with the Batch service.
  ## 
  let valid = call_595079.validator(path, query, header, formData, body)
  let scheme = call_595079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595079.url(scheme.get, call_595079.host, call_595079.base,
                         call_595079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595079, url, valid)

proc call*(call_595080: Call_ComputeNodeUploadBatchServiceLogs_595068;
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
  var path_595081 = newJObject()
  var query_595082 = newJObject()
  var body_595083 = newJObject()
  add(query_595082, "timeout", newJInt(timeout))
  add(query_595082, "api-version", newJString(apiVersion))
  add(path_595081, "poolId", newJString(poolId))
  add(path_595081, "nodeId", newJString(nodeId))
  if uploadBatchServiceLogsConfiguration != nil:
    body_595083 = uploadBatchServiceLogsConfiguration
  result = call_595080.call(path_595081, query_595082, nil, nil, body_595083)

var computeNodeUploadBatchServiceLogs* = Call_ComputeNodeUploadBatchServiceLogs_595068(
    name: "computeNodeUploadBatchServiceLogs", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/uploadbatchservicelogs",
    validator: validate_ComputeNodeUploadBatchServiceLogs_595069, base: "",
    url: url_ComputeNodeUploadBatchServiceLogs_595070, schemes: {Scheme.Https})
type
  Call_ComputeNodeAddUser_595084 = ref object of OpenApiRestCall_593438
proc url_ComputeNodeAddUser_595086(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeAddUser_595085(path: JsonNode; query: JsonNode;
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
  var valid_595087 = path.getOrDefault("poolId")
  valid_595087 = validateParameter(valid_595087, JString, required = true,
                                 default = nil)
  if valid_595087 != nil:
    section.add "poolId", valid_595087
  var valid_595088 = path.getOrDefault("nodeId")
  valid_595088 = validateParameter(valid_595088, JString, required = true,
                                 default = nil)
  if valid_595088 != nil:
    section.add "nodeId", valid_595088
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_595089 = query.getOrDefault("timeout")
  valid_595089 = validateParameter(valid_595089, JInt, required = false,
                                 default = newJInt(30))
  if valid_595089 != nil:
    section.add "timeout", valid_595089
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595090 = query.getOrDefault("api-version")
  valid_595090 = validateParameter(valid_595090, JString, required = true,
                                 default = nil)
  if valid_595090 != nil:
    section.add "api-version", valid_595090
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_595091 = header.getOrDefault("client-request-id")
  valid_595091 = validateParameter(valid_595091, JString, required = false,
                                 default = nil)
  if valid_595091 != nil:
    section.add "client-request-id", valid_595091
  var valid_595092 = header.getOrDefault("ocp-date")
  valid_595092 = validateParameter(valid_595092, JString, required = false,
                                 default = nil)
  if valid_595092 != nil:
    section.add "ocp-date", valid_595092
  var valid_595093 = header.getOrDefault("return-client-request-id")
  valid_595093 = validateParameter(valid_595093, JBool, required = false,
                                 default = newJBool(false))
  if valid_595093 != nil:
    section.add "return-client-request-id", valid_595093
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

proc call*(call_595095: Call_ComputeNodeAddUser_595084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can add a user Account to a Compute Node only when it is in the idle or running state.
  ## 
  let valid = call_595095.validator(path, query, header, formData, body)
  let scheme = call_595095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595095.url(scheme.get, call_595095.host, call_595095.base,
                         call_595095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595095, url, valid)

proc call*(call_595096: Call_ComputeNodeAddUser_595084; apiVersion: string;
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
  var path_595097 = newJObject()
  var query_595098 = newJObject()
  var body_595099 = newJObject()
  add(query_595098, "timeout", newJInt(timeout))
  add(query_595098, "api-version", newJString(apiVersion))
  if user != nil:
    body_595099 = user
  add(path_595097, "poolId", newJString(poolId))
  add(path_595097, "nodeId", newJString(nodeId))
  result = call_595096.call(path_595097, query_595098, nil, nil, body_595099)

var computeNodeAddUser* = Call_ComputeNodeAddUser_595084(
    name: "computeNodeAddUser", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/users",
    validator: validate_ComputeNodeAddUser_595085, base: "",
    url: url_ComputeNodeAddUser_595086, schemes: {Scheme.Https})
type
  Call_ComputeNodeUpdateUser_595100 = ref object of OpenApiRestCall_593438
proc url_ComputeNodeUpdateUser_595102(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeUpdateUser_595101(path: JsonNode; query: JsonNode;
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
  var valid_595103 = path.getOrDefault("poolId")
  valid_595103 = validateParameter(valid_595103, JString, required = true,
                                 default = nil)
  if valid_595103 != nil:
    section.add "poolId", valid_595103
  var valid_595104 = path.getOrDefault("nodeId")
  valid_595104 = validateParameter(valid_595104, JString, required = true,
                                 default = nil)
  if valid_595104 != nil:
    section.add "nodeId", valid_595104
  var valid_595105 = path.getOrDefault("userName")
  valid_595105 = validateParameter(valid_595105, JString, required = true,
                                 default = nil)
  if valid_595105 != nil:
    section.add "userName", valid_595105
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_595106 = query.getOrDefault("timeout")
  valid_595106 = validateParameter(valid_595106, JInt, required = false,
                                 default = newJInt(30))
  if valid_595106 != nil:
    section.add "timeout", valid_595106
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595107 = query.getOrDefault("api-version")
  valid_595107 = validateParameter(valid_595107, JString, required = true,
                                 default = nil)
  if valid_595107 != nil:
    section.add "api-version", valid_595107
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_595108 = header.getOrDefault("client-request-id")
  valid_595108 = validateParameter(valid_595108, JString, required = false,
                                 default = nil)
  if valid_595108 != nil:
    section.add "client-request-id", valid_595108
  var valid_595109 = header.getOrDefault("ocp-date")
  valid_595109 = validateParameter(valid_595109, JString, required = false,
                                 default = nil)
  if valid_595109 != nil:
    section.add "ocp-date", valid_595109
  var valid_595110 = header.getOrDefault("return-client-request-id")
  valid_595110 = validateParameter(valid_595110, JBool, required = false,
                                 default = newJBool(false))
  if valid_595110 != nil:
    section.add "return-client-request-id", valid_595110
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

proc call*(call_595112: Call_ComputeNodeUpdateUser_595100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation replaces of all the updatable properties of the Account. For example, if the expiryTime element is not specified, the current value is replaced with the default value, not left unmodified. You can update a user Account on a Compute Node only when it is in the idle or running state.
  ## 
  let valid = call_595112.validator(path, query, header, formData, body)
  let scheme = call_595112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595112.url(scheme.get, call_595112.host, call_595112.base,
                         call_595112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595112, url, valid)

proc call*(call_595113: Call_ComputeNodeUpdateUser_595100; apiVersion: string;
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
  var path_595114 = newJObject()
  var query_595115 = newJObject()
  var body_595116 = newJObject()
  add(query_595115, "timeout", newJInt(timeout))
  add(query_595115, "api-version", newJString(apiVersion))
  add(path_595114, "poolId", newJString(poolId))
  add(path_595114, "nodeId", newJString(nodeId))
  if nodeUpdateUserParameter != nil:
    body_595116 = nodeUpdateUserParameter
  add(path_595114, "userName", newJString(userName))
  result = call_595113.call(path_595114, query_595115, nil, nil, body_595116)

var computeNodeUpdateUser* = Call_ComputeNodeUpdateUser_595100(
    name: "computeNodeUpdateUser", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/users/{userName}",
    validator: validate_ComputeNodeUpdateUser_595101, base: "",
    url: url_ComputeNodeUpdateUser_595102, schemes: {Scheme.Https})
type
  Call_ComputeNodeDeleteUser_595117 = ref object of OpenApiRestCall_593438
proc url_ComputeNodeDeleteUser_595119(protocol: Scheme; host: string; base: string;
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

proc validate_ComputeNodeDeleteUser_595118(path: JsonNode; query: JsonNode;
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
  var valid_595120 = path.getOrDefault("poolId")
  valid_595120 = validateParameter(valid_595120, JString, required = true,
                                 default = nil)
  if valid_595120 != nil:
    section.add "poolId", valid_595120
  var valid_595121 = path.getOrDefault("nodeId")
  valid_595121 = validateParameter(valid_595121, JString, required = true,
                                 default = nil)
  if valid_595121 != nil:
    section.add "nodeId", valid_595121
  var valid_595122 = path.getOrDefault("userName")
  valid_595122 = validateParameter(valid_595122, JString, required = true,
                                 default = nil)
  if valid_595122 != nil:
    section.add "userName", valid_595122
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_595123 = query.getOrDefault("timeout")
  valid_595123 = validateParameter(valid_595123, JInt, required = false,
                                 default = newJInt(30))
  if valid_595123 != nil:
    section.add "timeout", valid_595123
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595124 = query.getOrDefault("api-version")
  valid_595124 = validateParameter(valid_595124, JString, required = true,
                                 default = nil)
  if valid_595124 != nil:
    section.add "api-version", valid_595124
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_595125 = header.getOrDefault("client-request-id")
  valid_595125 = validateParameter(valid_595125, JString, required = false,
                                 default = nil)
  if valid_595125 != nil:
    section.add "client-request-id", valid_595125
  var valid_595126 = header.getOrDefault("ocp-date")
  valid_595126 = validateParameter(valid_595126, JString, required = false,
                                 default = nil)
  if valid_595126 != nil:
    section.add "ocp-date", valid_595126
  var valid_595127 = header.getOrDefault("return-client-request-id")
  valid_595127 = validateParameter(valid_595127, JBool, required = false,
                                 default = newJBool(false))
  if valid_595127 != nil:
    section.add "return-client-request-id", valid_595127
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595128: Call_ComputeNodeDeleteUser_595117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can delete a user Account to a Compute Node only when it is in the idle or running state.
  ## 
  let valid = call_595128.validator(path, query, header, formData, body)
  let scheme = call_595128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595128.url(scheme.get, call_595128.host, call_595128.base,
                         call_595128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595128, url, valid)

proc call*(call_595129: Call_ComputeNodeDeleteUser_595117; apiVersion: string;
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
  var path_595130 = newJObject()
  var query_595131 = newJObject()
  add(query_595131, "timeout", newJInt(timeout))
  add(query_595131, "api-version", newJString(apiVersion))
  add(path_595130, "poolId", newJString(poolId))
  add(path_595130, "nodeId", newJString(nodeId))
  add(path_595130, "userName", newJString(userName))
  result = call_595129.call(path_595130, query_595131, nil, nil, nil)

var computeNodeDeleteUser* = Call_ComputeNodeDeleteUser_595117(
    name: "computeNodeDeleteUser", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/pools/{poolId}/nodes/{nodeId}/users/{userName}",
    validator: validate_ComputeNodeDeleteUser_595118, base: "",
    url: url_ComputeNodeDeleteUser_595119, schemes: {Scheme.Https})
type
  Call_PoolRemoveNodes_595132 = ref object of OpenApiRestCall_593438
proc url_PoolRemoveNodes_595134(protocol: Scheme; host: string; base: string;
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

proc validate_PoolRemoveNodes_595133(path: JsonNode; query: JsonNode;
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
  var valid_595135 = path.getOrDefault("poolId")
  valid_595135 = validateParameter(valid_595135, JString, required = true,
                                 default = nil)
  if valid_595135 != nil:
    section.add "poolId", valid_595135
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_595136 = query.getOrDefault("timeout")
  valid_595136 = validateParameter(valid_595136, JInt, required = false,
                                 default = newJInt(30))
  if valid_595136 != nil:
    section.add "timeout", valid_595136
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595137 = query.getOrDefault("api-version")
  valid_595137 = validateParameter(valid_595137, JString, required = true,
                                 default = nil)
  if valid_595137 != nil:
    section.add "api-version", valid_595137
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
  var valid_595138 = header.getOrDefault("If-Match")
  valid_595138 = validateParameter(valid_595138, JString, required = false,
                                 default = nil)
  if valid_595138 != nil:
    section.add "If-Match", valid_595138
  var valid_595139 = header.getOrDefault("client-request-id")
  valid_595139 = validateParameter(valid_595139, JString, required = false,
                                 default = nil)
  if valid_595139 != nil:
    section.add "client-request-id", valid_595139
  var valid_595140 = header.getOrDefault("ocp-date")
  valid_595140 = validateParameter(valid_595140, JString, required = false,
                                 default = nil)
  if valid_595140 != nil:
    section.add "ocp-date", valid_595140
  var valid_595141 = header.getOrDefault("If-Unmodified-Since")
  valid_595141 = validateParameter(valid_595141, JString, required = false,
                                 default = nil)
  if valid_595141 != nil:
    section.add "If-Unmodified-Since", valid_595141
  var valid_595142 = header.getOrDefault("If-None-Match")
  valid_595142 = validateParameter(valid_595142, JString, required = false,
                                 default = nil)
  if valid_595142 != nil:
    section.add "If-None-Match", valid_595142
  var valid_595143 = header.getOrDefault("If-Modified-Since")
  valid_595143 = validateParameter(valid_595143, JString, required = false,
                                 default = nil)
  if valid_595143 != nil:
    section.add "If-Modified-Since", valid_595143
  var valid_595144 = header.getOrDefault("return-client-request-id")
  valid_595144 = validateParameter(valid_595144, JBool, required = false,
                                 default = newJBool(false))
  if valid_595144 != nil:
    section.add "return-client-request-id", valid_595144
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

proc call*(call_595146: Call_PoolRemoveNodes_595132; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation can only run when the allocation state of the Pool is steady. When this operation runs, the allocation state changes from steady to resizing.
  ## 
  let valid = call_595146.validator(path, query, header, formData, body)
  let scheme = call_595146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595146.url(scheme.get, call_595146.host, call_595146.base,
                         call_595146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595146, url, valid)

proc call*(call_595147: Call_PoolRemoveNodes_595132; apiVersion: string;
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
  var path_595148 = newJObject()
  var query_595149 = newJObject()
  var body_595150 = newJObject()
  add(query_595149, "timeout", newJInt(timeout))
  add(query_595149, "api-version", newJString(apiVersion))
  add(path_595148, "poolId", newJString(poolId))
  if nodeRemoveParameter != nil:
    body_595150 = nodeRemoveParameter
  result = call_595147.call(path_595148, query_595149, nil, nil, body_595150)

var poolRemoveNodes* = Call_PoolRemoveNodes_595132(name: "poolRemoveNodes",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/removenodes", validator: validate_PoolRemoveNodes_595133,
    base: "", url: url_PoolRemoveNodes_595134, schemes: {Scheme.Https})
type
  Call_PoolResize_595151 = ref object of OpenApiRestCall_593438
proc url_PoolResize_595153(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PoolResize_595152(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_595154 = path.getOrDefault("poolId")
  valid_595154 = validateParameter(valid_595154, JString, required = true,
                                 default = nil)
  if valid_595154 != nil:
    section.add "poolId", valid_595154
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_595155 = query.getOrDefault("timeout")
  valid_595155 = validateParameter(valid_595155, JInt, required = false,
                                 default = newJInt(30))
  if valid_595155 != nil:
    section.add "timeout", valid_595155
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595156 = query.getOrDefault("api-version")
  valid_595156 = validateParameter(valid_595156, JString, required = true,
                                 default = nil)
  if valid_595156 != nil:
    section.add "api-version", valid_595156
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
  var valid_595157 = header.getOrDefault("If-Match")
  valid_595157 = validateParameter(valid_595157, JString, required = false,
                                 default = nil)
  if valid_595157 != nil:
    section.add "If-Match", valid_595157
  var valid_595158 = header.getOrDefault("client-request-id")
  valid_595158 = validateParameter(valid_595158, JString, required = false,
                                 default = nil)
  if valid_595158 != nil:
    section.add "client-request-id", valid_595158
  var valid_595159 = header.getOrDefault("ocp-date")
  valid_595159 = validateParameter(valid_595159, JString, required = false,
                                 default = nil)
  if valid_595159 != nil:
    section.add "ocp-date", valid_595159
  var valid_595160 = header.getOrDefault("If-Unmodified-Since")
  valid_595160 = validateParameter(valid_595160, JString, required = false,
                                 default = nil)
  if valid_595160 != nil:
    section.add "If-Unmodified-Since", valid_595160
  var valid_595161 = header.getOrDefault("If-None-Match")
  valid_595161 = validateParameter(valid_595161, JString, required = false,
                                 default = nil)
  if valid_595161 != nil:
    section.add "If-None-Match", valid_595161
  var valid_595162 = header.getOrDefault("If-Modified-Since")
  valid_595162 = validateParameter(valid_595162, JString, required = false,
                                 default = nil)
  if valid_595162 != nil:
    section.add "If-Modified-Since", valid_595162
  var valid_595163 = header.getOrDefault("return-client-request-id")
  valid_595163 = validateParameter(valid_595163, JBool, required = false,
                                 default = newJBool(false))
  if valid_595163 != nil:
    section.add "return-client-request-id", valid_595163
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

proc call*(call_595165: Call_PoolResize_595151; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can only resize a Pool when its allocation state is steady. If the Pool is already resizing, the request fails with status code 409. When you resize a Pool, the Pool's allocation state changes from steady to resizing. You cannot resize Pools which are configured for automatic scaling. If you try to do this, the Batch service returns an error 409. If you resize a Pool downwards, the Batch service chooses which Compute Nodes to remove. To remove specific Compute Nodes, use the Pool remove Compute Nodes API instead.
  ## 
  let valid = call_595165.validator(path, query, header, formData, body)
  let scheme = call_595165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595165.url(scheme.get, call_595165.host, call_595165.base,
                         call_595165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595165, url, valid)

proc call*(call_595166: Call_PoolResize_595151; apiVersion: string; poolId: string;
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
  var path_595167 = newJObject()
  var query_595168 = newJObject()
  var body_595169 = newJObject()
  add(query_595168, "timeout", newJInt(timeout))
  add(query_595168, "api-version", newJString(apiVersion))
  add(path_595167, "poolId", newJString(poolId))
  if poolResizeParameter != nil:
    body_595169 = poolResizeParameter
  result = call_595166.call(path_595167, query_595168, nil, nil, body_595169)

var poolResize* = Call_PoolResize_595151(name: "poolResize",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local",
                                      route: "/pools/{poolId}/resize",
                                      validator: validate_PoolResize_595152,
                                      base: "", url: url_PoolResize_595153,
                                      schemes: {Scheme.Https})
type
  Call_PoolStopResize_595170 = ref object of OpenApiRestCall_593438
proc url_PoolStopResize_595172(protocol: Scheme; host: string; base: string;
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

proc validate_PoolStopResize_595171(path: JsonNode; query: JsonNode;
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
  var valid_595173 = path.getOrDefault("poolId")
  valid_595173 = validateParameter(valid_595173, JString, required = true,
                                 default = nil)
  if valid_595173 != nil:
    section.add "poolId", valid_595173
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_595174 = query.getOrDefault("timeout")
  valid_595174 = validateParameter(valid_595174, JInt, required = false,
                                 default = newJInt(30))
  if valid_595174 != nil:
    section.add "timeout", valid_595174
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595175 = query.getOrDefault("api-version")
  valid_595175 = validateParameter(valid_595175, JString, required = true,
                                 default = nil)
  if valid_595175 != nil:
    section.add "api-version", valid_595175
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
  var valid_595176 = header.getOrDefault("If-Match")
  valid_595176 = validateParameter(valid_595176, JString, required = false,
                                 default = nil)
  if valid_595176 != nil:
    section.add "If-Match", valid_595176
  var valid_595177 = header.getOrDefault("client-request-id")
  valid_595177 = validateParameter(valid_595177, JString, required = false,
                                 default = nil)
  if valid_595177 != nil:
    section.add "client-request-id", valid_595177
  var valid_595178 = header.getOrDefault("ocp-date")
  valid_595178 = validateParameter(valid_595178, JString, required = false,
                                 default = nil)
  if valid_595178 != nil:
    section.add "ocp-date", valid_595178
  var valid_595179 = header.getOrDefault("If-Unmodified-Since")
  valid_595179 = validateParameter(valid_595179, JString, required = false,
                                 default = nil)
  if valid_595179 != nil:
    section.add "If-Unmodified-Since", valid_595179
  var valid_595180 = header.getOrDefault("If-None-Match")
  valid_595180 = validateParameter(valid_595180, JString, required = false,
                                 default = nil)
  if valid_595180 != nil:
    section.add "If-None-Match", valid_595180
  var valid_595181 = header.getOrDefault("If-Modified-Since")
  valid_595181 = validateParameter(valid_595181, JString, required = false,
                                 default = nil)
  if valid_595181 != nil:
    section.add "If-Modified-Since", valid_595181
  var valid_595182 = header.getOrDefault("return-client-request-id")
  valid_595182 = validateParameter(valid_595182, JBool, required = false,
                                 default = newJBool(false))
  if valid_595182 != nil:
    section.add "return-client-request-id", valid_595182
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595183: Call_PoolStopResize_595170; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This does not restore the Pool to its previous state before the resize operation: it only stops any further changes being made, and the Pool maintains its current state. After stopping, the Pool stabilizes at the number of Compute Nodes it was at when the stop operation was done. During the stop operation, the Pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize Pool request; this API can also be used to halt the initial sizing of the Pool when it is created.
  ## 
  let valid = call_595183.validator(path, query, header, formData, body)
  let scheme = call_595183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595183.url(scheme.get, call_595183.host, call_595183.base,
                         call_595183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595183, url, valid)

proc call*(call_595184: Call_PoolStopResize_595170; apiVersion: string;
          poolId: string; timeout: int = 30): Recallable =
  ## poolStopResize
  ## This does not restore the Pool to its previous state before the resize operation: it only stops any further changes being made, and the Pool maintains its current state. After stopping, the Pool stabilizes at the number of Compute Nodes it was at when the stop operation was done. During the stop operation, the Pool allocation state changes first to stopping and then to steady. A resize operation need not be an explicit resize Pool request; this API can also be used to halt the initial sizing of the Pool when it is created.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool whose resizing you want to stop.
  var path_595185 = newJObject()
  var query_595186 = newJObject()
  add(query_595186, "timeout", newJInt(timeout))
  add(query_595186, "api-version", newJString(apiVersion))
  add(path_595185, "poolId", newJString(poolId))
  result = call_595184.call(path_595185, query_595186, nil, nil, nil)

var poolStopResize* = Call_PoolStopResize_595170(name: "poolStopResize",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/stopresize", validator: validate_PoolStopResize_595171,
    base: "", url: url_PoolStopResize_595172, schemes: {Scheme.Https})
type
  Call_PoolUpdateProperties_595187 = ref object of OpenApiRestCall_593438
proc url_PoolUpdateProperties_595189(protocol: Scheme; host: string; base: string;
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

proc validate_PoolUpdateProperties_595188(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This fully replaces all the updatable properties of the Pool. For example, if the Pool has a start Task associated with it and if start Task is not specified with this request, then the Batch service will remove the existing start Task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolId: JString (required)
  ##         : The ID of the Pool to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolId` field"
  var valid_595190 = path.getOrDefault("poolId")
  valid_595190 = validateParameter(valid_595190, JString, required = true,
                                 default = nil)
  if valid_595190 != nil:
    section.add "poolId", valid_595190
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  var valid_595191 = query.getOrDefault("timeout")
  valid_595191 = validateParameter(valid_595191, JInt, required = false,
                                 default = newJInt(30))
  if valid_595191 != nil:
    section.add "timeout", valid_595191
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595192 = query.getOrDefault("api-version")
  valid_595192 = validateParameter(valid_595192, JString, required = true,
                                 default = nil)
  if valid_595192 != nil:
    section.add "api-version", valid_595192
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_595193 = header.getOrDefault("client-request-id")
  valid_595193 = validateParameter(valid_595193, JString, required = false,
                                 default = nil)
  if valid_595193 != nil:
    section.add "client-request-id", valid_595193
  var valid_595194 = header.getOrDefault("ocp-date")
  valid_595194 = validateParameter(valid_595194, JString, required = false,
                                 default = nil)
  if valid_595194 != nil:
    section.add "ocp-date", valid_595194
  var valid_595195 = header.getOrDefault("return-client-request-id")
  valid_595195 = validateParameter(valid_595195, JBool, required = false,
                                 default = newJBool(false))
  if valid_595195 != nil:
    section.add "return-client-request-id", valid_595195
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

proc call*(call_595197: Call_PoolUpdateProperties_595187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This fully replaces all the updatable properties of the Pool. For example, if the Pool has a start Task associated with it and if start Task is not specified with this request, then the Batch service will remove the existing start Task.
  ## 
  let valid = call_595197.validator(path, query, header, formData, body)
  let scheme = call_595197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595197.url(scheme.get, call_595197.host, call_595197.base,
                         call_595197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595197, url, valid)

proc call*(call_595198: Call_PoolUpdateProperties_595187; apiVersion: string;
          poolId: string; poolUpdatePropertiesParameter: JsonNode; timeout: int = 30): Recallable =
  ## poolUpdateProperties
  ## This fully replaces all the updatable properties of the Pool. For example, if the Pool has a start Task associated with it and if start Task is not specified with this request, then the Batch service will remove the existing start Task.
  ##   timeout: int
  ##          : The maximum time that the server can spend processing the request, in seconds. The default is 30 seconds.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   poolId: string (required)
  ##         : The ID of the Pool to update.
  ##   poolUpdatePropertiesParameter: JObject (required)
  ##                                : The parameters for the request.
  var path_595199 = newJObject()
  var query_595200 = newJObject()
  var body_595201 = newJObject()
  add(query_595200, "timeout", newJInt(timeout))
  add(query_595200, "api-version", newJString(apiVersion))
  add(path_595199, "poolId", newJString(poolId))
  if poolUpdatePropertiesParameter != nil:
    body_595201 = poolUpdatePropertiesParameter
  result = call_595198.call(path_595199, query_595200, nil, nil, body_595201)

var poolUpdateProperties* = Call_PoolUpdateProperties_595187(
    name: "poolUpdateProperties", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/pools/{poolId}/updateproperties",
    validator: validate_PoolUpdateProperties_595188, base: "",
    url: url_PoolUpdateProperties_595189, schemes: {Scheme.Https})
type
  Call_PoolListUsageMetrics_595202 = ref object of OpenApiRestCall_593438
proc url_PoolListUsageMetrics_595204(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PoolListUsageMetrics_595203(path: JsonNode; query: JsonNode;
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
  var valid_595205 = query.getOrDefault("timeout")
  valid_595205 = validateParameter(valid_595205, JInt, required = false,
                                 default = newJInt(30))
  if valid_595205 != nil:
    section.add "timeout", valid_595205
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595206 = query.getOrDefault("api-version")
  valid_595206 = validateParameter(valid_595206, JString, required = true,
                                 default = nil)
  if valid_595206 != nil:
    section.add "api-version", valid_595206
  var valid_595207 = query.getOrDefault("endtime")
  valid_595207 = validateParameter(valid_595207, JString, required = false,
                                 default = nil)
  if valid_595207 != nil:
    section.add "endtime", valid_595207
  var valid_595208 = query.getOrDefault("maxresults")
  valid_595208 = validateParameter(valid_595208, JInt, required = false,
                                 default = newJInt(1000))
  if valid_595208 != nil:
    section.add "maxresults", valid_595208
  var valid_595209 = query.getOrDefault("starttime")
  valid_595209 = validateParameter(valid_595209, JString, required = false,
                                 default = nil)
  if valid_595209 != nil:
    section.add "starttime", valid_595209
  var valid_595210 = query.getOrDefault("$filter")
  valid_595210 = validateParameter(valid_595210, JString, required = false,
                                 default = nil)
  if valid_595210 != nil:
    section.add "$filter", valid_595210
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_595211 = header.getOrDefault("client-request-id")
  valid_595211 = validateParameter(valid_595211, JString, required = false,
                                 default = nil)
  if valid_595211 != nil:
    section.add "client-request-id", valid_595211
  var valid_595212 = header.getOrDefault("ocp-date")
  valid_595212 = validateParameter(valid_595212, JString, required = false,
                                 default = nil)
  if valid_595212 != nil:
    section.add "ocp-date", valid_595212
  var valid_595213 = header.getOrDefault("return-client-request-id")
  valid_595213 = validateParameter(valid_595213, JBool, required = false,
                                 default = newJBool(false))
  if valid_595213 != nil:
    section.add "return-client-request-id", valid_595213
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595214: Call_PoolListUsageMetrics_595202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If you do not specify a $filter clause including a poolId, the response includes all Pools that existed in the Account in the time range of the returned aggregation intervals. If you do not specify a $filter clause including a startTime or endTime these filters default to the start and end times of the last aggregation interval currently available; that is, only the last aggregation interval is returned.
  ## 
  let valid = call_595214.validator(path, query, header, formData, body)
  let scheme = call_595214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595214.url(scheme.get, call_595214.host, call_595214.base,
                         call_595214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595214, url, valid)

proc call*(call_595215: Call_PoolListUsageMetrics_595202; apiVersion: string;
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
  var query_595216 = newJObject()
  add(query_595216, "timeout", newJInt(timeout))
  add(query_595216, "api-version", newJString(apiVersion))
  add(query_595216, "endtime", newJString(endtime))
  add(query_595216, "maxresults", newJInt(maxresults))
  add(query_595216, "starttime", newJString(starttime))
  add(query_595216, "$filter", newJString(Filter))
  result = call_595215.call(nil, query_595216, nil, nil, nil)

var poolListUsageMetrics* = Call_PoolListUsageMetrics_595202(
    name: "poolListUsageMetrics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/poolusagemetrics", validator: validate_PoolListUsageMetrics_595203,
    base: "", url: url_PoolListUsageMetrics_595204, schemes: {Scheme.Https})
type
  Call_AccountListSupportedImages_595217 = ref object of OpenApiRestCall_593438
proc url_AccountListSupportedImages_595219(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccountListSupportedImages_595218(path: JsonNode; query: JsonNode;
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
  var valid_595220 = query.getOrDefault("timeout")
  valid_595220 = validateParameter(valid_595220, JInt, required = false,
                                 default = newJInt(30))
  if valid_595220 != nil:
    section.add "timeout", valid_595220
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595221 = query.getOrDefault("api-version")
  valid_595221 = validateParameter(valid_595221, JString, required = true,
                                 default = nil)
  if valid_595221 != nil:
    section.add "api-version", valid_595221
  var valid_595222 = query.getOrDefault("maxresults")
  valid_595222 = validateParameter(valid_595222, JInt, required = false,
                                 default = newJInt(1000))
  if valid_595222 != nil:
    section.add "maxresults", valid_595222
  var valid_595223 = query.getOrDefault("$filter")
  valid_595223 = validateParameter(valid_595223, JString, required = false,
                                 default = nil)
  if valid_595223 != nil:
    section.add "$filter", valid_595223
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The caller-generated request identity, in the form of a GUID with no decoration such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
  ##   ocp-date: JString
  ##           : The time the request was issued. Client libraries typically set this to the current system clock time; set it explicitly if you are calling the REST API directly.
  ##   return-client-request-id: JBool
  ##                           : Whether the server should return the client-request-id in the response.
  section = newJObject()
  var valid_595224 = header.getOrDefault("client-request-id")
  valid_595224 = validateParameter(valid_595224, JString, required = false,
                                 default = nil)
  if valid_595224 != nil:
    section.add "client-request-id", valid_595224
  var valid_595225 = header.getOrDefault("ocp-date")
  valid_595225 = validateParameter(valid_595225, JString, required = false,
                                 default = nil)
  if valid_595225 != nil:
    section.add "ocp-date", valid_595225
  var valid_595226 = header.getOrDefault("return-client-request-id")
  valid_595226 = validateParameter(valid_595226, JBool, required = false,
                                 default = newJBool(false))
  if valid_595226 != nil:
    section.add "return-client-request-id", valid_595226
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595227: Call_AccountListSupportedImages_595217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595227.validator(path, query, header, formData, body)
  let scheme = call_595227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595227.url(scheme.get, call_595227.host, call_595227.base,
                         call_595227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595227, url, valid)

proc call*(call_595228: Call_AccountListSupportedImages_595217; apiVersion: string;
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
  var query_595229 = newJObject()
  add(query_595229, "timeout", newJInt(timeout))
  add(query_595229, "api-version", newJString(apiVersion))
  add(query_595229, "maxresults", newJInt(maxresults))
  add(query_595229, "$filter", newJString(Filter))
  result = call_595228.call(nil, query_595229, nil, nil, nil)

var accountListSupportedImages* = Call_AccountListSupportedImages_595217(
    name: "accountListSupportedImages", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/supportedimages",
    validator: validate_AccountListSupportedImages_595218, base: "",
    url: url_AccountListSupportedImages_595219, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
