
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Diagnostics API Client
## version: 2018-02-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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
  macServiceName = "web-Diagnostics"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DiagnosticsListHostingEnvironmentDetectorResponses_563777 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsListHostingEnvironmentDetectorResponses_563779(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/detectors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsListHostingEnvironmentDetectorResponses_563778(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List Hosting Environment Detector Responses
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Site Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_563954 = path.getOrDefault("name")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "name", valid_563954
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  var valid_563956 = path.getOrDefault("resourceGroupName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "resourceGroupName", valid_563956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563957 = query.getOrDefault("api-version")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "api-version", valid_563957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563980: Call_DiagnosticsListHostingEnvironmentDetectorResponses_563777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Hosting Environment Detector Responses
  ## 
  let valid = call_563980.validator(path, query, header, formData, body)
  let scheme = call_563980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563980.url(scheme.get, call_563980.host, call_563980.base,
                         call_563980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563980, url, valid)

proc call*(call_564051: Call_DiagnosticsListHostingEnvironmentDetectorResponses_563777;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## diagnosticsListHostingEnvironmentDetectorResponses
  ## List Hosting Environment Detector Responses
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Site Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564052 = newJObject()
  var query_564054 = newJObject()
  add(query_564054, "api-version", newJString(apiVersion))
  add(path_564052, "name", newJString(name))
  add(path_564052, "subscriptionId", newJString(subscriptionId))
  add(path_564052, "resourceGroupName", newJString(resourceGroupName))
  result = call_564051.call(path_564052, query_564054, nil, nil, nil)

var diagnosticsListHostingEnvironmentDetectorResponses* = Call_DiagnosticsListHostingEnvironmentDetectorResponses_563777(
    name: "diagnosticsListHostingEnvironmentDetectorResponses",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/detectors",
    validator: validate_DiagnosticsListHostingEnvironmentDetectorResponses_563778,
    base: "", url: url_DiagnosticsListHostingEnvironmentDetectorResponses_563779,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsGetHostingEnvironmentDetectorResponse_564093 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsGetHostingEnvironmentDetectorResponse_564095(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  assert "detectorName" in path, "`detectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Web/hostingEnvironments/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/detectors/"),
               (kind: VariableSegment, value: "detectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsGetHostingEnvironmentDetectorResponse_564094(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get Hosting Environment Detector Response
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : App Service Environment Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   detectorName: JString (required)
  ##               : Detector Resource Name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564096 = path.getOrDefault("name")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "name", valid_564096
  var valid_564097 = path.getOrDefault("subscriptionId")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "subscriptionId", valid_564097
  var valid_564098 = path.getOrDefault("resourceGroupName")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "resourceGroupName", valid_564098
  var valid_564099 = path.getOrDefault("detectorName")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "detectorName", valid_564099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   startTime: JString
  ##            : Start Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   endTime: JString
  ##          : End Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564100 = query.getOrDefault("api-version")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "api-version", valid_564100
  var valid_564101 = query.getOrDefault("startTime")
  valid_564101 = validateParameter(valid_564101, JString, required = false,
                                 default = nil)
  if valid_564101 != nil:
    section.add "startTime", valid_564101
  var valid_564102 = query.getOrDefault("timeGrain")
  valid_564102 = validateParameter(valid_564102, JString, required = false,
                                 default = nil)
  if valid_564102 != nil:
    section.add "timeGrain", valid_564102
  var valid_564103 = query.getOrDefault("endTime")
  valid_564103 = validateParameter(valid_564103, JString, required = false,
                                 default = nil)
  if valid_564103 != nil:
    section.add "endTime", valid_564103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564104: Call_DiagnosticsGetHostingEnvironmentDetectorResponse_564093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Hosting Environment Detector Response
  ## 
  let valid = call_564104.validator(path, query, header, formData, body)
  let scheme = call_564104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564104.url(scheme.get, call_564104.host, call_564104.base,
                         call_564104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564104, url, valid)

proc call*(call_564105: Call_DiagnosticsGetHostingEnvironmentDetectorResponse_564093;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string; detectorName: string; startTime: string = "";
          timeGrain: string = ""; endTime: string = ""): Recallable =
  ## diagnosticsGetHostingEnvironmentDetectorResponse
  ## Get Hosting Environment Detector Response
  ##   apiVersion: string (required)
  ##             : API Version
  ##   startTime: string
  ##            : Start Time
  ##   name: string (required)
  ##       : App Service Environment Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   timeGrain: string
  ##            : Time Grain
  ##   detectorName: string (required)
  ##               : Detector Resource Name
  ##   endTime: string
  ##          : End Time
  var path_564106 = newJObject()
  var query_564107 = newJObject()
  add(query_564107, "api-version", newJString(apiVersion))
  add(query_564107, "startTime", newJString(startTime))
  add(path_564106, "name", newJString(name))
  add(path_564106, "subscriptionId", newJString(subscriptionId))
  add(path_564106, "resourceGroupName", newJString(resourceGroupName))
  add(query_564107, "timeGrain", newJString(timeGrain))
  add(path_564106, "detectorName", newJString(detectorName))
  add(query_564107, "endTime", newJString(endTime))
  result = call_564105.call(path_564106, query_564107, nil, nil, nil)

var diagnosticsGetHostingEnvironmentDetectorResponse* = Call_DiagnosticsGetHostingEnvironmentDetectorResponse_564093(
    name: "diagnosticsGetHostingEnvironmentDetectorResponse",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetHostingEnvironmentDetectorResponse_564094,
    base: "", url: url_DiagnosticsGetHostingEnvironmentDetectorResponse_564095,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDetectorResponses_564108 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsListSiteDetectorResponses_564110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/detectors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsListSiteDetectorResponses_564109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Site Detector Responses
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564111 = path.getOrDefault("siteName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "siteName", valid_564111
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  var valid_564113 = path.getOrDefault("resourceGroupName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "resourceGroupName", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
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
  if body != nil:
    result.add "body", body

proc call*(call_564115: Call_DiagnosticsListSiteDetectorResponses_564108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Site Detector Responses
  ## 
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_DiagnosticsListSiteDetectorResponses_564108;
          siteName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## diagnosticsListSiteDetectorResponses
  ## List Site Detector Responses
  ##   siteName: string (required)
  ##           : Site Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564117 = newJObject()
  var query_564118 = newJObject()
  add(path_564117, "siteName", newJString(siteName))
  add(query_564118, "api-version", newJString(apiVersion))
  add(path_564117, "subscriptionId", newJString(subscriptionId))
  add(path_564117, "resourceGroupName", newJString(resourceGroupName))
  result = call_564116.call(path_564117, query_564118, nil, nil, nil)

var diagnosticsListSiteDetectorResponses* = Call_DiagnosticsListSiteDetectorResponses_564108(
    name: "diagnosticsListSiteDetectorResponses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/detectors",
    validator: validate_DiagnosticsListSiteDetectorResponses_564109, base: "",
    url: url_DiagnosticsListSiteDetectorResponses_564110, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDetectorResponse_564119 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsGetSiteDetectorResponse_564121(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "detectorName" in path, "`detectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/detectors/"),
               (kind: VariableSegment, value: "detectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsGetSiteDetectorResponse_564120(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get site detector response
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   detectorName: JString (required)
  ##               : Detector Resource Name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564122 = path.getOrDefault("siteName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "siteName", valid_564122
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  var valid_564124 = path.getOrDefault("resourceGroupName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "resourceGroupName", valid_564124
  var valid_564125 = path.getOrDefault("detectorName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "detectorName", valid_564125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   startTime: JString
  ##            : Start Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   endTime: JString
  ##          : End Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564126 = query.getOrDefault("api-version")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "api-version", valid_564126
  var valid_564127 = query.getOrDefault("startTime")
  valid_564127 = validateParameter(valid_564127, JString, required = false,
                                 default = nil)
  if valid_564127 != nil:
    section.add "startTime", valid_564127
  var valid_564128 = query.getOrDefault("timeGrain")
  valid_564128 = validateParameter(valid_564128, JString, required = false,
                                 default = nil)
  if valid_564128 != nil:
    section.add "timeGrain", valid_564128
  var valid_564129 = query.getOrDefault("endTime")
  valid_564129 = validateParameter(valid_564129, JString, required = false,
                                 default = nil)
  if valid_564129 != nil:
    section.add "endTime", valid_564129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564130: Call_DiagnosticsGetSiteDetectorResponse_564119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get site detector response
  ## 
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_DiagnosticsGetSiteDetectorResponse_564119;
          siteName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; detectorName: string; startTime: string = "";
          timeGrain: string = ""; endTime: string = ""): Recallable =
  ## diagnosticsGetSiteDetectorResponse
  ## Get site detector response
  ##   siteName: string (required)
  ##           : Site Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   startTime: string
  ##            : Start Time
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   timeGrain: string
  ##            : Time Grain
  ##   detectorName: string (required)
  ##               : Detector Resource Name
  ##   endTime: string
  ##          : End Time
  var path_564132 = newJObject()
  var query_564133 = newJObject()
  add(path_564132, "siteName", newJString(siteName))
  add(query_564133, "api-version", newJString(apiVersion))
  add(query_564133, "startTime", newJString(startTime))
  add(path_564132, "subscriptionId", newJString(subscriptionId))
  add(path_564132, "resourceGroupName", newJString(resourceGroupName))
  add(query_564133, "timeGrain", newJString(timeGrain))
  add(path_564132, "detectorName", newJString(detectorName))
  add(query_564133, "endTime", newJString(endTime))
  result = call_564131.call(path_564132, query_564133, nil, nil, nil)

var diagnosticsGetSiteDetectorResponse* = Call_DiagnosticsGetSiteDetectorResponse_564119(
    name: "diagnosticsGetSiteDetectorResponse", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetSiteDetectorResponse_564120, base: "",
    url: url_DiagnosticsGetSiteDetectorResponse_564121, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDiagnosticCategories_564134 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsListSiteDiagnosticCategories_564136(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/diagnostics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsListSiteDiagnosticCategories_564135(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Diagnostics Categories
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564137 = path.getOrDefault("siteName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "siteName", valid_564137
  var valid_564138 = path.getOrDefault("subscriptionId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "subscriptionId", valid_564138
  var valid_564139 = path.getOrDefault("resourceGroupName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "resourceGroupName", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564141: Call_DiagnosticsListSiteDiagnosticCategories_564134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Diagnostics Categories
  ## 
  let valid = call_564141.validator(path, query, header, formData, body)
  let scheme = call_564141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564141.url(scheme.get, call_564141.host, call_564141.base,
                         call_564141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564141, url, valid)

proc call*(call_564142: Call_DiagnosticsListSiteDiagnosticCategories_564134;
          siteName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## diagnosticsListSiteDiagnosticCategories
  ## Get Diagnostics Categories
  ##   siteName: string (required)
  ##           : Site Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564143 = newJObject()
  var query_564144 = newJObject()
  add(path_564143, "siteName", newJString(siteName))
  add(query_564144, "api-version", newJString(apiVersion))
  add(path_564143, "subscriptionId", newJString(subscriptionId))
  add(path_564143, "resourceGroupName", newJString(resourceGroupName))
  result = call_564142.call(path_564143, query_564144, nil, nil, nil)

var diagnosticsListSiteDiagnosticCategories* = Call_DiagnosticsListSiteDiagnosticCategories_564134(
    name: "diagnosticsListSiteDiagnosticCategories", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics",
    validator: validate_DiagnosticsListSiteDiagnosticCategories_564135, base: "",
    url: url_DiagnosticsListSiteDiagnosticCategories_564136,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDiagnosticCategory_564145 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsGetSiteDiagnosticCategory_564147(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsGetSiteDiagnosticCategory_564146(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Diagnostics Category
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564148 = path.getOrDefault("siteName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "siteName", valid_564148
  var valid_564149 = path.getOrDefault("diagnosticCategory")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "diagnosticCategory", valid_564149
  var valid_564150 = path.getOrDefault("subscriptionId")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "subscriptionId", valid_564150
  var valid_564151 = path.getOrDefault("resourceGroupName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "resourceGroupName", valid_564151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564152 = query.getOrDefault("api-version")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "api-version", valid_564152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_DiagnosticsGetSiteDiagnosticCategory_564145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Diagnostics Category
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_DiagnosticsGetSiteDiagnosticCategory_564145;
          siteName: string; apiVersion: string; diagnosticCategory: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## diagnosticsGetSiteDiagnosticCategory
  ## Get Diagnostics Category
  ##   siteName: string (required)
  ##           : Site Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  add(path_564155, "siteName", newJString(siteName))
  add(query_564156, "api-version", newJString(apiVersion))
  add(path_564155, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564155, "subscriptionId", newJString(subscriptionId))
  add(path_564155, "resourceGroupName", newJString(resourceGroupName))
  result = call_564154.call(path_564155, query_564156, nil, nil, nil)

var diagnosticsGetSiteDiagnosticCategory* = Call_DiagnosticsGetSiteDiagnosticCategory_564145(
    name: "diagnosticsGetSiteDiagnosticCategory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}",
    validator: validate_DiagnosticsGetSiteDiagnosticCategory_564146, base: "",
    url: url_DiagnosticsGetSiteDiagnosticCategory_564147, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteAnalyses_564157 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsListSiteAnalyses_564159(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory"),
               (kind: ConstantSegment, value: "/analyses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsListSiteAnalyses_564158(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Site Analyses
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564160 = path.getOrDefault("siteName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "siteName", valid_564160
  var valid_564161 = path.getOrDefault("diagnosticCategory")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "diagnosticCategory", valid_564161
  var valid_564162 = path.getOrDefault("subscriptionId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "subscriptionId", valid_564162
  var valid_564163 = path.getOrDefault("resourceGroupName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "resourceGroupName", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_DiagnosticsListSiteAnalyses_564157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Site Analyses
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_DiagnosticsListSiteAnalyses_564157; siteName: string;
          apiVersion: string; diagnosticCategory: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## diagnosticsListSiteAnalyses
  ## Get Site Analyses
  ##   siteName: string (required)
  ##           : Site Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(path_564167, "siteName", newJString(siteName))
  add(query_564168, "api-version", newJString(apiVersion))
  add(path_564167, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  add(path_564167, "resourceGroupName", newJString(resourceGroupName))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var diagnosticsListSiteAnalyses* = Call_DiagnosticsListSiteAnalyses_564157(
    name: "diagnosticsListSiteAnalyses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/analyses",
    validator: validate_DiagnosticsListSiteAnalyses_564158, base: "",
    url: url_DiagnosticsListSiteAnalyses_564159, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteAnalysis_564169 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsGetSiteAnalysis_564171(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  assert "analysisName" in path, "`analysisName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory"),
               (kind: ConstantSegment, value: "/analyses/"),
               (kind: VariableSegment, value: "analysisName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsGetSiteAnalysis_564170(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Site Analysis
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   analysisName: JString (required)
  ##               : Analysis Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564172 = path.getOrDefault("siteName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "siteName", valid_564172
  var valid_564173 = path.getOrDefault("diagnosticCategory")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "diagnosticCategory", valid_564173
  var valid_564174 = path.getOrDefault("subscriptionId")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "subscriptionId", valid_564174
  var valid_564175 = path.getOrDefault("analysisName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "analysisName", valid_564175
  var valid_564176 = path.getOrDefault("resourceGroupName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "resourceGroupName", valid_564176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564177 = query.getOrDefault("api-version")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "api-version", valid_564177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564178: Call_DiagnosticsGetSiteAnalysis_564169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Site Analysis
  ## 
  let valid = call_564178.validator(path, query, header, formData, body)
  let scheme = call_564178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564178.url(scheme.get, call_564178.host, call_564178.base,
                         call_564178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564178, url, valid)

proc call*(call_564179: Call_DiagnosticsGetSiteAnalysis_564169; siteName: string;
          apiVersion: string; diagnosticCategory: string; subscriptionId: string;
          analysisName: string; resourceGroupName: string): Recallable =
  ## diagnosticsGetSiteAnalysis
  ## Get Site Analysis
  ##   siteName: string (required)
  ##           : Site Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   analysisName: string (required)
  ##               : Analysis Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564180 = newJObject()
  var query_564181 = newJObject()
  add(path_564180, "siteName", newJString(siteName))
  add(query_564181, "api-version", newJString(apiVersion))
  add(path_564180, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564180, "subscriptionId", newJString(subscriptionId))
  add(path_564180, "analysisName", newJString(analysisName))
  add(path_564180, "resourceGroupName", newJString(resourceGroupName))
  result = call_564179.call(path_564180, query_564181, nil, nil, nil)

var diagnosticsGetSiteAnalysis* = Call_DiagnosticsGetSiteAnalysis_564169(
    name: "diagnosticsGetSiteAnalysis", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/analyses/{analysisName}",
    validator: validate_DiagnosticsGetSiteAnalysis_564170, base: "",
    url: url_DiagnosticsGetSiteAnalysis_564171, schemes: {Scheme.Https})
type
  Call_DiagnosticsExecuteSiteAnalysis_564182 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsExecuteSiteAnalysis_564184(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  assert "analysisName" in path, "`analysisName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory"),
               (kind: ConstantSegment, value: "/analyses/"),
               (kind: VariableSegment, value: "analysisName"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsExecuteSiteAnalysis_564183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute Analysis
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Category Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   analysisName: JString (required)
  ##               : Analysis Resource Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564185 = path.getOrDefault("siteName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "siteName", valid_564185
  var valid_564186 = path.getOrDefault("diagnosticCategory")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "diagnosticCategory", valid_564186
  var valid_564187 = path.getOrDefault("subscriptionId")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "subscriptionId", valid_564187
  var valid_564188 = path.getOrDefault("analysisName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "analysisName", valid_564188
  var valid_564189 = path.getOrDefault("resourceGroupName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "resourceGroupName", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   startTime: JString
  ##            : Start Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   endTime: JString
  ##          : End Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564190 = query.getOrDefault("api-version")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "api-version", valid_564190
  var valid_564191 = query.getOrDefault("startTime")
  valid_564191 = validateParameter(valid_564191, JString, required = false,
                                 default = nil)
  if valid_564191 != nil:
    section.add "startTime", valid_564191
  var valid_564192 = query.getOrDefault("timeGrain")
  valid_564192 = validateParameter(valid_564192, JString, required = false,
                                 default = nil)
  if valid_564192 != nil:
    section.add "timeGrain", valid_564192
  var valid_564193 = query.getOrDefault("endTime")
  valid_564193 = validateParameter(valid_564193, JString, required = false,
                                 default = nil)
  if valid_564193 != nil:
    section.add "endTime", valid_564193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564194: Call_DiagnosticsExecuteSiteAnalysis_564182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute Analysis
  ## 
  let valid = call_564194.validator(path, query, header, formData, body)
  let scheme = call_564194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564194.url(scheme.get, call_564194.host, call_564194.base,
                         call_564194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564194, url, valid)

proc call*(call_564195: Call_DiagnosticsExecuteSiteAnalysis_564182;
          siteName: string; apiVersion: string; diagnosticCategory: string;
          subscriptionId: string; analysisName: string; resourceGroupName: string;
          startTime: string = ""; timeGrain: string = ""; endTime: string = ""): Recallable =
  ## diagnosticsExecuteSiteAnalysis
  ## Execute Analysis
  ##   siteName: string (required)
  ##           : Site Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   startTime: string
  ##            : Start Time
  ##   diagnosticCategory: string (required)
  ##                     : Category Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   analysisName: string (required)
  ##               : Analysis Resource Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   timeGrain: string
  ##            : Time Grain
  ##   endTime: string
  ##          : End Time
  var path_564196 = newJObject()
  var query_564197 = newJObject()
  add(path_564196, "siteName", newJString(siteName))
  add(query_564197, "api-version", newJString(apiVersion))
  add(query_564197, "startTime", newJString(startTime))
  add(path_564196, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564196, "subscriptionId", newJString(subscriptionId))
  add(path_564196, "analysisName", newJString(analysisName))
  add(path_564196, "resourceGroupName", newJString(resourceGroupName))
  add(query_564197, "timeGrain", newJString(timeGrain))
  add(query_564197, "endTime", newJString(endTime))
  result = call_564195.call(path_564196, query_564197, nil, nil, nil)

var diagnosticsExecuteSiteAnalysis* = Call_DiagnosticsExecuteSiteAnalysis_564182(
    name: "diagnosticsExecuteSiteAnalysis", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/analyses/{analysisName}/execute",
    validator: validate_DiagnosticsExecuteSiteAnalysis_564183, base: "",
    url: url_DiagnosticsExecuteSiteAnalysis_564184, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDetectors_564198 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsListSiteDetectors_564200(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory"),
               (kind: ConstantSegment, value: "/detectors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsListSiteDetectors_564199(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Detectors
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564201 = path.getOrDefault("siteName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "siteName", valid_564201
  var valid_564202 = path.getOrDefault("diagnosticCategory")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "diagnosticCategory", valid_564202
  var valid_564203 = path.getOrDefault("subscriptionId")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "subscriptionId", valid_564203
  var valid_564204 = path.getOrDefault("resourceGroupName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "resourceGroupName", valid_564204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564205 = query.getOrDefault("api-version")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "api-version", valid_564205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564206: Call_DiagnosticsListSiteDetectors_564198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Detectors
  ## 
  let valid = call_564206.validator(path, query, header, formData, body)
  let scheme = call_564206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564206.url(scheme.get, call_564206.host, call_564206.base,
                         call_564206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564206, url, valid)

proc call*(call_564207: Call_DiagnosticsListSiteDetectors_564198; siteName: string;
          apiVersion: string; diagnosticCategory: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## diagnosticsListSiteDetectors
  ## Get Detectors
  ##   siteName: string (required)
  ##           : Site Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564208 = newJObject()
  var query_564209 = newJObject()
  add(path_564208, "siteName", newJString(siteName))
  add(query_564209, "api-version", newJString(apiVersion))
  add(path_564208, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564208, "subscriptionId", newJString(subscriptionId))
  add(path_564208, "resourceGroupName", newJString(resourceGroupName))
  result = call_564207.call(path_564208, query_564209, nil, nil, nil)

var diagnosticsListSiteDetectors* = Call_DiagnosticsListSiteDetectors_564198(
    name: "diagnosticsListSiteDetectors", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/detectors",
    validator: validate_DiagnosticsListSiteDetectors_564199, base: "",
    url: url_DiagnosticsListSiteDetectors_564200, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDetector_564210 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsGetSiteDetector_564212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  assert "detectorName" in path, "`detectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory"),
               (kind: ConstantSegment, value: "/detectors/"),
               (kind: VariableSegment, value: "detectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsGetSiteDetector_564211(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Detector
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   detectorName: JString (required)
  ##               : Detector Name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564213 = path.getOrDefault("siteName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "siteName", valid_564213
  var valid_564214 = path.getOrDefault("diagnosticCategory")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "diagnosticCategory", valid_564214
  var valid_564215 = path.getOrDefault("subscriptionId")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "subscriptionId", valid_564215
  var valid_564216 = path.getOrDefault("resourceGroupName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "resourceGroupName", valid_564216
  var valid_564217 = path.getOrDefault("detectorName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "detectorName", valid_564217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564218 = query.getOrDefault("api-version")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "api-version", valid_564218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564219: Call_DiagnosticsGetSiteDetector_564210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Detector
  ## 
  let valid = call_564219.validator(path, query, header, formData, body)
  let scheme = call_564219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564219.url(scheme.get, call_564219.host, call_564219.base,
                         call_564219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564219, url, valid)

proc call*(call_564220: Call_DiagnosticsGetSiteDetector_564210; siteName: string;
          apiVersion: string; diagnosticCategory: string; subscriptionId: string;
          resourceGroupName: string; detectorName: string): Recallable =
  ## diagnosticsGetSiteDetector
  ## Get Detector
  ##   siteName: string (required)
  ##           : Site Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   detectorName: string (required)
  ##               : Detector Name
  var path_564221 = newJObject()
  var query_564222 = newJObject()
  add(path_564221, "siteName", newJString(siteName))
  add(query_564222, "api-version", newJString(apiVersion))
  add(path_564221, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564221, "subscriptionId", newJString(subscriptionId))
  add(path_564221, "resourceGroupName", newJString(resourceGroupName))
  add(path_564221, "detectorName", newJString(detectorName))
  result = call_564220.call(path_564221, query_564222, nil, nil, nil)

var diagnosticsGetSiteDetector* = Call_DiagnosticsGetSiteDetector_564210(
    name: "diagnosticsGetSiteDetector", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetSiteDetector_564211, base: "",
    url: url_DiagnosticsGetSiteDetector_564212, schemes: {Scheme.Https})
type
  Call_DiagnosticsExecuteSiteDetector_564223 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsExecuteSiteDetector_564225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  assert "detectorName" in path, "`detectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory"),
               (kind: ConstantSegment, value: "/detectors/"),
               (kind: VariableSegment, value: "detectorName"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsExecuteSiteDetector_564224(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute Detector
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Category Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   detectorName: JString (required)
  ##               : Detector Resource Name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564226 = path.getOrDefault("siteName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "siteName", valid_564226
  var valid_564227 = path.getOrDefault("diagnosticCategory")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "diagnosticCategory", valid_564227
  var valid_564228 = path.getOrDefault("subscriptionId")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "subscriptionId", valid_564228
  var valid_564229 = path.getOrDefault("resourceGroupName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceGroupName", valid_564229
  var valid_564230 = path.getOrDefault("detectorName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "detectorName", valid_564230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   startTime: JString
  ##            : Start Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   endTime: JString
  ##          : End Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564231 = query.getOrDefault("api-version")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "api-version", valid_564231
  var valid_564232 = query.getOrDefault("startTime")
  valid_564232 = validateParameter(valid_564232, JString, required = false,
                                 default = nil)
  if valid_564232 != nil:
    section.add "startTime", valid_564232
  var valid_564233 = query.getOrDefault("timeGrain")
  valid_564233 = validateParameter(valid_564233, JString, required = false,
                                 default = nil)
  if valid_564233 != nil:
    section.add "timeGrain", valid_564233
  var valid_564234 = query.getOrDefault("endTime")
  valid_564234 = validateParameter(valid_564234, JString, required = false,
                                 default = nil)
  if valid_564234 != nil:
    section.add "endTime", valid_564234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564235: Call_DiagnosticsExecuteSiteDetector_564223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute Detector
  ## 
  let valid = call_564235.validator(path, query, header, formData, body)
  let scheme = call_564235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564235.url(scheme.get, call_564235.host, call_564235.base,
                         call_564235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564235, url, valid)

proc call*(call_564236: Call_DiagnosticsExecuteSiteDetector_564223;
          siteName: string; apiVersion: string; diagnosticCategory: string;
          subscriptionId: string; resourceGroupName: string; detectorName: string;
          startTime: string = ""; timeGrain: string = ""; endTime: string = ""): Recallable =
  ## diagnosticsExecuteSiteDetector
  ## Execute Detector
  ##   siteName: string (required)
  ##           : Site Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   startTime: string
  ##            : Start Time
  ##   diagnosticCategory: string (required)
  ##                     : Category Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   timeGrain: string
  ##            : Time Grain
  ##   detectorName: string (required)
  ##               : Detector Resource Name
  ##   endTime: string
  ##          : End Time
  var path_564237 = newJObject()
  var query_564238 = newJObject()
  add(path_564237, "siteName", newJString(siteName))
  add(query_564238, "api-version", newJString(apiVersion))
  add(query_564238, "startTime", newJString(startTime))
  add(path_564237, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564237, "subscriptionId", newJString(subscriptionId))
  add(path_564237, "resourceGroupName", newJString(resourceGroupName))
  add(query_564238, "timeGrain", newJString(timeGrain))
  add(path_564237, "detectorName", newJString(detectorName))
  add(query_564238, "endTime", newJString(endTime))
  result = call_564236.call(path_564237, query_564238, nil, nil, nil)

var diagnosticsExecuteSiteDetector* = Call_DiagnosticsExecuteSiteDetector_564223(
    name: "diagnosticsExecuteSiteDetector", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/detectors/{detectorName}/execute",
    validator: validate_DiagnosticsExecuteSiteDetector_564224, base: "",
    url: url_DiagnosticsExecuteSiteDetector_564225, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDetectorResponsesSlot_564239 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsListSiteDetectorResponsesSlot_564241(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "slot" in path, "`slot` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/slots/"),
               (kind: VariableSegment, value: "slot"),
               (kind: ConstantSegment, value: "/detectors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsListSiteDetectorResponsesSlot_564240(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Site Detector Responses
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564242 = path.getOrDefault("siteName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "siteName", valid_564242
  var valid_564243 = path.getOrDefault("slot")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "slot", valid_564243
  var valid_564244 = path.getOrDefault("subscriptionId")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "subscriptionId", valid_564244
  var valid_564245 = path.getOrDefault("resourceGroupName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "resourceGroupName", valid_564245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564246 = query.getOrDefault("api-version")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "api-version", valid_564246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564247: Call_DiagnosticsListSiteDetectorResponsesSlot_564239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Site Detector Responses
  ## 
  let valid = call_564247.validator(path, query, header, formData, body)
  let scheme = call_564247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564247.url(scheme.get, call_564247.host, call_564247.base,
                         call_564247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564247, url, valid)

proc call*(call_564248: Call_DiagnosticsListSiteDetectorResponsesSlot_564239;
          siteName: string; slot: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## diagnosticsListSiteDetectorResponsesSlot
  ## List Site Detector Responses
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564249 = newJObject()
  var query_564250 = newJObject()
  add(path_564249, "siteName", newJString(siteName))
  add(path_564249, "slot", newJString(slot))
  add(query_564250, "api-version", newJString(apiVersion))
  add(path_564249, "subscriptionId", newJString(subscriptionId))
  add(path_564249, "resourceGroupName", newJString(resourceGroupName))
  result = call_564248.call(path_564249, query_564250, nil, nil, nil)

var diagnosticsListSiteDetectorResponsesSlot* = Call_DiagnosticsListSiteDetectorResponsesSlot_564239(
    name: "diagnosticsListSiteDetectorResponsesSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/detectors",
    validator: validate_DiagnosticsListSiteDetectorResponsesSlot_564240, base: "",
    url: url_DiagnosticsListSiteDetectorResponsesSlot_564241,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDetectorResponseSlot_564251 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsGetSiteDetectorResponseSlot_564253(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "slot" in path, "`slot` is a required path parameter"
  assert "detectorName" in path, "`detectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/slots/"),
               (kind: VariableSegment, value: "slot"),
               (kind: ConstantSegment, value: "/detectors/"),
               (kind: VariableSegment, value: "detectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsGetSiteDetectorResponseSlot_564252(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get site detector response
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   detectorName: JString (required)
  ##               : Detector Resource Name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564254 = path.getOrDefault("siteName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "siteName", valid_564254
  var valid_564255 = path.getOrDefault("slot")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "slot", valid_564255
  var valid_564256 = path.getOrDefault("subscriptionId")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "subscriptionId", valid_564256
  var valid_564257 = path.getOrDefault("resourceGroupName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "resourceGroupName", valid_564257
  var valid_564258 = path.getOrDefault("detectorName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "detectorName", valid_564258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   startTime: JString
  ##            : Start Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   endTime: JString
  ##          : End Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564259 = query.getOrDefault("api-version")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "api-version", valid_564259
  var valid_564260 = query.getOrDefault("startTime")
  valid_564260 = validateParameter(valid_564260, JString, required = false,
                                 default = nil)
  if valid_564260 != nil:
    section.add "startTime", valid_564260
  var valid_564261 = query.getOrDefault("timeGrain")
  valid_564261 = validateParameter(valid_564261, JString, required = false,
                                 default = nil)
  if valid_564261 != nil:
    section.add "timeGrain", valid_564261
  var valid_564262 = query.getOrDefault("endTime")
  valid_564262 = validateParameter(valid_564262, JString, required = false,
                                 default = nil)
  if valid_564262 != nil:
    section.add "endTime", valid_564262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564263: Call_DiagnosticsGetSiteDetectorResponseSlot_564251;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get site detector response
  ## 
  let valid = call_564263.validator(path, query, header, formData, body)
  let scheme = call_564263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564263.url(scheme.get, call_564263.host, call_564263.base,
                         call_564263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564263, url, valid)

proc call*(call_564264: Call_DiagnosticsGetSiteDetectorResponseSlot_564251;
          siteName: string; slot: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; detectorName: string; startTime: string = "";
          timeGrain: string = ""; endTime: string = ""): Recallable =
  ## diagnosticsGetSiteDetectorResponseSlot
  ## Get site detector response
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   startTime: string
  ##            : Start Time
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   timeGrain: string
  ##            : Time Grain
  ##   detectorName: string (required)
  ##               : Detector Resource Name
  ##   endTime: string
  ##          : End Time
  var path_564265 = newJObject()
  var query_564266 = newJObject()
  add(path_564265, "siteName", newJString(siteName))
  add(path_564265, "slot", newJString(slot))
  add(query_564266, "api-version", newJString(apiVersion))
  add(query_564266, "startTime", newJString(startTime))
  add(path_564265, "subscriptionId", newJString(subscriptionId))
  add(path_564265, "resourceGroupName", newJString(resourceGroupName))
  add(query_564266, "timeGrain", newJString(timeGrain))
  add(path_564265, "detectorName", newJString(detectorName))
  add(query_564266, "endTime", newJString(endTime))
  result = call_564264.call(path_564265, query_564266, nil, nil, nil)

var diagnosticsGetSiteDetectorResponseSlot* = Call_DiagnosticsGetSiteDetectorResponseSlot_564251(
    name: "diagnosticsGetSiteDetectorResponseSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetSiteDetectorResponseSlot_564252, base: "",
    url: url_DiagnosticsGetSiteDetectorResponseSlot_564253,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDiagnosticCategoriesSlot_564267 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsListSiteDiagnosticCategoriesSlot_564269(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "slot" in path, "`slot` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/slots/"),
               (kind: VariableSegment, value: "slot"),
               (kind: ConstantSegment, value: "/diagnostics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsListSiteDiagnosticCategoriesSlot_564268(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Diagnostics Categories
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564270 = path.getOrDefault("siteName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "siteName", valid_564270
  var valid_564271 = path.getOrDefault("slot")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "slot", valid_564271
  var valid_564272 = path.getOrDefault("subscriptionId")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "subscriptionId", valid_564272
  var valid_564273 = path.getOrDefault("resourceGroupName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "resourceGroupName", valid_564273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564274 = query.getOrDefault("api-version")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "api-version", valid_564274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564275: Call_DiagnosticsListSiteDiagnosticCategoriesSlot_564267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Diagnostics Categories
  ## 
  let valid = call_564275.validator(path, query, header, formData, body)
  let scheme = call_564275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564275.url(scheme.get, call_564275.host, call_564275.base,
                         call_564275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564275, url, valid)

proc call*(call_564276: Call_DiagnosticsListSiteDiagnosticCategoriesSlot_564267;
          siteName: string; slot: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## diagnosticsListSiteDiagnosticCategoriesSlot
  ## Get Diagnostics Categories
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564277 = newJObject()
  var query_564278 = newJObject()
  add(path_564277, "siteName", newJString(siteName))
  add(path_564277, "slot", newJString(slot))
  add(query_564278, "api-version", newJString(apiVersion))
  add(path_564277, "subscriptionId", newJString(subscriptionId))
  add(path_564277, "resourceGroupName", newJString(resourceGroupName))
  result = call_564276.call(path_564277, query_564278, nil, nil, nil)

var diagnosticsListSiteDiagnosticCategoriesSlot* = Call_DiagnosticsListSiteDiagnosticCategoriesSlot_564267(
    name: "diagnosticsListSiteDiagnosticCategoriesSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics",
    validator: validate_DiagnosticsListSiteDiagnosticCategoriesSlot_564268,
    base: "", url: url_DiagnosticsListSiteDiagnosticCategoriesSlot_564269,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDiagnosticCategorySlot_564279 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsGetSiteDiagnosticCategorySlot_564281(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "slot" in path, "`slot` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/slots/"),
               (kind: VariableSegment, value: "slot"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsGetSiteDiagnosticCategorySlot_564280(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Diagnostics Category
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564282 = path.getOrDefault("siteName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "siteName", valid_564282
  var valid_564283 = path.getOrDefault("slot")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "slot", valid_564283
  var valid_564284 = path.getOrDefault("diagnosticCategory")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "diagnosticCategory", valid_564284
  var valid_564285 = path.getOrDefault("subscriptionId")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "subscriptionId", valid_564285
  var valid_564286 = path.getOrDefault("resourceGroupName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "resourceGroupName", valid_564286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564287 = query.getOrDefault("api-version")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "api-version", valid_564287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_DiagnosticsGetSiteDiagnosticCategorySlot_564279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Diagnostics Category
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_DiagnosticsGetSiteDiagnosticCategorySlot_564279;
          siteName: string; slot: string; apiVersion: string;
          diagnosticCategory: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## diagnosticsGetSiteDiagnosticCategorySlot
  ## Get Diagnostics Category
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  add(path_564290, "siteName", newJString(siteName))
  add(path_564290, "slot", newJString(slot))
  add(query_564291, "api-version", newJString(apiVersion))
  add(path_564290, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564290, "subscriptionId", newJString(subscriptionId))
  add(path_564290, "resourceGroupName", newJString(resourceGroupName))
  result = call_564289.call(path_564290, query_564291, nil, nil, nil)

var diagnosticsGetSiteDiagnosticCategorySlot* = Call_DiagnosticsGetSiteDiagnosticCategorySlot_564279(
    name: "diagnosticsGetSiteDiagnosticCategorySlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}",
    validator: validate_DiagnosticsGetSiteDiagnosticCategorySlot_564280, base: "",
    url: url_DiagnosticsGetSiteDiagnosticCategorySlot_564281,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteAnalysesSlot_564292 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsListSiteAnalysesSlot_564294(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "slot" in path, "`slot` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/slots/"),
               (kind: VariableSegment, value: "slot"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory"),
               (kind: ConstantSegment, value: "/analyses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsListSiteAnalysesSlot_564293(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Site Analyses
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564295 = path.getOrDefault("siteName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "siteName", valid_564295
  var valid_564296 = path.getOrDefault("slot")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "slot", valid_564296
  var valid_564297 = path.getOrDefault("diagnosticCategory")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "diagnosticCategory", valid_564297
  var valid_564298 = path.getOrDefault("subscriptionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "subscriptionId", valid_564298
  var valid_564299 = path.getOrDefault("resourceGroupName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "resourceGroupName", valid_564299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564300 = query.getOrDefault("api-version")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "api-version", valid_564300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564301: Call_DiagnosticsListSiteAnalysesSlot_564292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Site Analyses
  ## 
  let valid = call_564301.validator(path, query, header, formData, body)
  let scheme = call_564301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564301.url(scheme.get, call_564301.host, call_564301.base,
                         call_564301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564301, url, valid)

proc call*(call_564302: Call_DiagnosticsListSiteAnalysesSlot_564292;
          siteName: string; slot: string; apiVersion: string;
          diagnosticCategory: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## diagnosticsListSiteAnalysesSlot
  ## Get Site Analyses
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564303 = newJObject()
  var query_564304 = newJObject()
  add(path_564303, "siteName", newJString(siteName))
  add(path_564303, "slot", newJString(slot))
  add(query_564304, "api-version", newJString(apiVersion))
  add(path_564303, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564303, "subscriptionId", newJString(subscriptionId))
  add(path_564303, "resourceGroupName", newJString(resourceGroupName))
  result = call_564302.call(path_564303, query_564304, nil, nil, nil)

var diagnosticsListSiteAnalysesSlot* = Call_DiagnosticsListSiteAnalysesSlot_564292(
    name: "diagnosticsListSiteAnalysesSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/analyses",
    validator: validate_DiagnosticsListSiteAnalysesSlot_564293, base: "",
    url: url_DiagnosticsListSiteAnalysesSlot_564294, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteAnalysisSlot_564305 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsGetSiteAnalysisSlot_564307(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "slot" in path, "`slot` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  assert "analysisName" in path, "`analysisName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/slots/"),
               (kind: VariableSegment, value: "slot"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory"),
               (kind: ConstantSegment, value: "/analyses/"),
               (kind: VariableSegment, value: "analysisName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsGetSiteAnalysisSlot_564306(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Site Analysis
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot - optional
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   analysisName: JString (required)
  ##               : Analysis Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564308 = path.getOrDefault("siteName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "siteName", valid_564308
  var valid_564309 = path.getOrDefault("slot")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "slot", valid_564309
  var valid_564310 = path.getOrDefault("diagnosticCategory")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "diagnosticCategory", valid_564310
  var valid_564311 = path.getOrDefault("subscriptionId")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "subscriptionId", valid_564311
  var valid_564312 = path.getOrDefault("analysisName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "analysisName", valid_564312
  var valid_564313 = path.getOrDefault("resourceGroupName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "resourceGroupName", valid_564313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564314 = query.getOrDefault("api-version")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "api-version", valid_564314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564315: Call_DiagnosticsGetSiteAnalysisSlot_564305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Site Analysis
  ## 
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_DiagnosticsGetSiteAnalysisSlot_564305;
          siteName: string; slot: string; apiVersion: string;
          diagnosticCategory: string; subscriptionId: string; analysisName: string;
          resourceGroupName: string): Recallable =
  ## diagnosticsGetSiteAnalysisSlot
  ## Get Site Analysis
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot - optional
  ##   apiVersion: string (required)
  ##             : API Version
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   analysisName: string (required)
  ##               : Analysis Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564317 = newJObject()
  var query_564318 = newJObject()
  add(path_564317, "siteName", newJString(siteName))
  add(path_564317, "slot", newJString(slot))
  add(query_564318, "api-version", newJString(apiVersion))
  add(path_564317, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564317, "subscriptionId", newJString(subscriptionId))
  add(path_564317, "analysisName", newJString(analysisName))
  add(path_564317, "resourceGroupName", newJString(resourceGroupName))
  result = call_564316.call(path_564317, query_564318, nil, nil, nil)

var diagnosticsGetSiteAnalysisSlot* = Call_DiagnosticsGetSiteAnalysisSlot_564305(
    name: "diagnosticsGetSiteAnalysisSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/analyses/{analysisName}",
    validator: validate_DiagnosticsGetSiteAnalysisSlot_564306, base: "",
    url: url_DiagnosticsGetSiteAnalysisSlot_564307, schemes: {Scheme.Https})
type
  Call_DiagnosticsExecuteSiteAnalysisSlot_564319 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsExecuteSiteAnalysisSlot_564321(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "slot" in path, "`slot` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  assert "analysisName" in path, "`analysisName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/slots/"),
               (kind: VariableSegment, value: "slot"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory"),
               (kind: ConstantSegment, value: "/analyses/"),
               (kind: VariableSegment, value: "analysisName"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsExecuteSiteAnalysisSlot_564320(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute Analysis
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   diagnosticCategory: JString (required)
  ##                     : Category Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   analysisName: JString (required)
  ##               : Analysis Resource Name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564322 = path.getOrDefault("siteName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "siteName", valid_564322
  var valid_564323 = path.getOrDefault("slot")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "slot", valid_564323
  var valid_564324 = path.getOrDefault("diagnosticCategory")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "diagnosticCategory", valid_564324
  var valid_564325 = path.getOrDefault("subscriptionId")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "subscriptionId", valid_564325
  var valid_564326 = path.getOrDefault("analysisName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "analysisName", valid_564326
  var valid_564327 = path.getOrDefault("resourceGroupName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "resourceGroupName", valid_564327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   startTime: JString
  ##            : Start Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   endTime: JString
  ##          : End Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564328 = query.getOrDefault("api-version")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "api-version", valid_564328
  var valid_564329 = query.getOrDefault("startTime")
  valid_564329 = validateParameter(valid_564329, JString, required = false,
                                 default = nil)
  if valid_564329 != nil:
    section.add "startTime", valid_564329
  var valid_564330 = query.getOrDefault("timeGrain")
  valid_564330 = validateParameter(valid_564330, JString, required = false,
                                 default = nil)
  if valid_564330 != nil:
    section.add "timeGrain", valid_564330
  var valid_564331 = query.getOrDefault("endTime")
  valid_564331 = validateParameter(valid_564331, JString, required = false,
                                 default = nil)
  if valid_564331 != nil:
    section.add "endTime", valid_564331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564332: Call_DiagnosticsExecuteSiteAnalysisSlot_564319;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Execute Analysis
  ## 
  let valid = call_564332.validator(path, query, header, formData, body)
  let scheme = call_564332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564332.url(scheme.get, call_564332.host, call_564332.base,
                         call_564332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564332, url, valid)

proc call*(call_564333: Call_DiagnosticsExecuteSiteAnalysisSlot_564319;
          siteName: string; slot: string; apiVersion: string;
          diagnosticCategory: string; subscriptionId: string; analysisName: string;
          resourceGroupName: string; startTime: string = ""; timeGrain: string = "";
          endTime: string = ""): Recallable =
  ## diagnosticsExecuteSiteAnalysisSlot
  ## Execute Analysis
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   startTime: string
  ##            : Start Time
  ##   diagnosticCategory: string (required)
  ##                     : Category Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   analysisName: string (required)
  ##               : Analysis Resource Name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   timeGrain: string
  ##            : Time Grain
  ##   endTime: string
  ##          : End Time
  var path_564334 = newJObject()
  var query_564335 = newJObject()
  add(path_564334, "siteName", newJString(siteName))
  add(path_564334, "slot", newJString(slot))
  add(query_564335, "api-version", newJString(apiVersion))
  add(query_564335, "startTime", newJString(startTime))
  add(path_564334, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564334, "subscriptionId", newJString(subscriptionId))
  add(path_564334, "analysisName", newJString(analysisName))
  add(path_564334, "resourceGroupName", newJString(resourceGroupName))
  add(query_564335, "timeGrain", newJString(timeGrain))
  add(query_564335, "endTime", newJString(endTime))
  result = call_564333.call(path_564334, query_564335, nil, nil, nil)

var diagnosticsExecuteSiteAnalysisSlot* = Call_DiagnosticsExecuteSiteAnalysisSlot_564319(
    name: "diagnosticsExecuteSiteAnalysisSlot", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/analyses/{analysisName}/execute",
    validator: validate_DiagnosticsExecuteSiteAnalysisSlot_564320, base: "",
    url: url_DiagnosticsExecuteSiteAnalysisSlot_564321, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDetectorsSlot_564336 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsListSiteDetectorsSlot_564338(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "slot" in path, "`slot` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/slots/"),
               (kind: VariableSegment, value: "slot"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory"),
               (kind: ConstantSegment, value: "/detectors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsListSiteDetectorsSlot_564337(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Detectors
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564339 = path.getOrDefault("siteName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "siteName", valid_564339
  var valid_564340 = path.getOrDefault("slot")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "slot", valid_564340
  var valid_564341 = path.getOrDefault("diagnosticCategory")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "diagnosticCategory", valid_564341
  var valid_564342 = path.getOrDefault("subscriptionId")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "subscriptionId", valid_564342
  var valid_564343 = path.getOrDefault("resourceGroupName")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "resourceGroupName", valid_564343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564344 = query.getOrDefault("api-version")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "api-version", valid_564344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564345: Call_DiagnosticsListSiteDetectorsSlot_564336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Detectors
  ## 
  let valid = call_564345.validator(path, query, header, formData, body)
  let scheme = call_564345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564345.url(scheme.get, call_564345.host, call_564345.base,
                         call_564345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564345, url, valid)

proc call*(call_564346: Call_DiagnosticsListSiteDetectorsSlot_564336;
          siteName: string; slot: string; apiVersion: string;
          diagnosticCategory: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## diagnosticsListSiteDetectorsSlot
  ## Get Detectors
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  var path_564347 = newJObject()
  var query_564348 = newJObject()
  add(path_564347, "siteName", newJString(siteName))
  add(path_564347, "slot", newJString(slot))
  add(query_564348, "api-version", newJString(apiVersion))
  add(path_564347, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564347, "subscriptionId", newJString(subscriptionId))
  add(path_564347, "resourceGroupName", newJString(resourceGroupName))
  result = call_564346.call(path_564347, query_564348, nil, nil, nil)

var diagnosticsListSiteDetectorsSlot* = Call_DiagnosticsListSiteDetectorsSlot_564336(
    name: "diagnosticsListSiteDetectorsSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/detectors",
    validator: validate_DiagnosticsListSiteDetectorsSlot_564337, base: "",
    url: url_DiagnosticsListSiteDetectorsSlot_564338, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDetectorSlot_564349 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsGetSiteDetectorSlot_564351(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "slot" in path, "`slot` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  assert "detectorName" in path, "`detectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/slots/"),
               (kind: VariableSegment, value: "slot"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory"),
               (kind: ConstantSegment, value: "/detectors/"),
               (kind: VariableSegment, value: "detectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsGetSiteDetectorSlot_564350(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Detector
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   detectorName: JString (required)
  ##               : Detector Name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564352 = path.getOrDefault("siteName")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "siteName", valid_564352
  var valid_564353 = path.getOrDefault("slot")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "slot", valid_564353
  var valid_564354 = path.getOrDefault("diagnosticCategory")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "diagnosticCategory", valid_564354
  var valid_564355 = path.getOrDefault("subscriptionId")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "subscriptionId", valid_564355
  var valid_564356 = path.getOrDefault("resourceGroupName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "resourceGroupName", valid_564356
  var valid_564357 = path.getOrDefault("detectorName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "detectorName", valid_564357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564358 = query.getOrDefault("api-version")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "api-version", valid_564358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564359: Call_DiagnosticsGetSiteDetectorSlot_564349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Detector
  ## 
  let valid = call_564359.validator(path, query, header, formData, body)
  let scheme = call_564359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564359.url(scheme.get, call_564359.host, call_564359.base,
                         call_564359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564359, url, valid)

proc call*(call_564360: Call_DiagnosticsGetSiteDetectorSlot_564349;
          siteName: string; slot: string; apiVersion: string;
          diagnosticCategory: string; subscriptionId: string;
          resourceGroupName: string; detectorName: string): Recallable =
  ## diagnosticsGetSiteDetectorSlot
  ## Get Detector
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   detectorName: string (required)
  ##               : Detector Name
  var path_564361 = newJObject()
  var query_564362 = newJObject()
  add(path_564361, "siteName", newJString(siteName))
  add(path_564361, "slot", newJString(slot))
  add(query_564362, "api-version", newJString(apiVersion))
  add(path_564361, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564361, "subscriptionId", newJString(subscriptionId))
  add(path_564361, "resourceGroupName", newJString(resourceGroupName))
  add(path_564361, "detectorName", newJString(detectorName))
  result = call_564360.call(path_564361, query_564362, nil, nil, nil)

var diagnosticsGetSiteDetectorSlot* = Call_DiagnosticsGetSiteDetectorSlot_564349(
    name: "diagnosticsGetSiteDetectorSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetSiteDetectorSlot_564350, base: "",
    url: url_DiagnosticsGetSiteDetectorSlot_564351, schemes: {Scheme.Https})
type
  Call_DiagnosticsExecuteSiteDetectorSlot_564363 = ref object of OpenApiRestCall_563555
proc url_DiagnosticsExecuteSiteDetectorSlot_564365(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "siteName" in path, "`siteName` is a required path parameter"
  assert "slot" in path, "`slot` is a required path parameter"
  assert "diagnosticCategory" in path,
        "`diagnosticCategory` is a required path parameter"
  assert "detectorName" in path, "`detectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/sites/"),
               (kind: VariableSegment, value: "siteName"),
               (kind: ConstantSegment, value: "/slots/"),
               (kind: VariableSegment, value: "slot"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticCategory"),
               (kind: ConstantSegment, value: "/detectors/"),
               (kind: VariableSegment, value: "detectorName"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticsExecuteSiteDetectorSlot_564364(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute Detector
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   diagnosticCategory: JString (required)
  ##                     : Category Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   detectorName: JString (required)
  ##               : Detector Resource Name
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `siteName` field"
  var valid_564366 = path.getOrDefault("siteName")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "siteName", valid_564366
  var valid_564367 = path.getOrDefault("slot")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "slot", valid_564367
  var valid_564368 = path.getOrDefault("diagnosticCategory")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "diagnosticCategory", valid_564368
  var valid_564369 = path.getOrDefault("subscriptionId")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "subscriptionId", valid_564369
  var valid_564370 = path.getOrDefault("resourceGroupName")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "resourceGroupName", valid_564370
  var valid_564371 = path.getOrDefault("detectorName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "detectorName", valid_564371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   startTime: JString
  ##            : Start Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   endTime: JString
  ##          : End Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564372 = query.getOrDefault("api-version")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "api-version", valid_564372
  var valid_564373 = query.getOrDefault("startTime")
  valid_564373 = validateParameter(valid_564373, JString, required = false,
                                 default = nil)
  if valid_564373 != nil:
    section.add "startTime", valid_564373
  var valid_564374 = query.getOrDefault("timeGrain")
  valid_564374 = validateParameter(valid_564374, JString, required = false,
                                 default = nil)
  if valid_564374 != nil:
    section.add "timeGrain", valid_564374
  var valid_564375 = query.getOrDefault("endTime")
  valid_564375 = validateParameter(valid_564375, JString, required = false,
                                 default = nil)
  if valid_564375 != nil:
    section.add "endTime", valid_564375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564376: Call_DiagnosticsExecuteSiteDetectorSlot_564363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Execute Detector
  ## 
  let valid = call_564376.validator(path, query, header, formData, body)
  let scheme = call_564376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564376.url(scheme.get, call_564376.host, call_564376.base,
                         call_564376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564376, url, valid)

proc call*(call_564377: Call_DiagnosticsExecuteSiteDetectorSlot_564363;
          siteName: string; slot: string; apiVersion: string;
          diagnosticCategory: string; subscriptionId: string;
          resourceGroupName: string; detectorName: string; startTime: string = "";
          timeGrain: string = ""; endTime: string = ""): Recallable =
  ## diagnosticsExecuteSiteDetectorSlot
  ## Execute Detector
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   apiVersion: string (required)
  ##             : API Version
  ##   startTime: string
  ##            : Start Time
  ##   diagnosticCategory: string (required)
  ##                     : Category Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   timeGrain: string
  ##            : Time Grain
  ##   detectorName: string (required)
  ##               : Detector Resource Name
  ##   endTime: string
  ##          : End Time
  var path_564378 = newJObject()
  var query_564379 = newJObject()
  add(path_564378, "siteName", newJString(siteName))
  add(path_564378, "slot", newJString(slot))
  add(query_564379, "api-version", newJString(apiVersion))
  add(query_564379, "startTime", newJString(startTime))
  add(path_564378, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_564378, "subscriptionId", newJString(subscriptionId))
  add(path_564378, "resourceGroupName", newJString(resourceGroupName))
  add(query_564379, "timeGrain", newJString(timeGrain))
  add(path_564378, "detectorName", newJString(detectorName))
  add(query_564379, "endTime", newJString(endTime))
  result = call_564377.call(path_564378, query_564379, nil, nil, nil)

var diagnosticsExecuteSiteDetectorSlot* = Call_DiagnosticsExecuteSiteDetectorSlot_564363(
    name: "diagnosticsExecuteSiteDetectorSlot", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/detectors/{detectorName}/execute",
    validator: validate_DiagnosticsExecuteSiteDetectorSlot_564364, base: "",
    url: url_DiagnosticsExecuteSiteDetectorSlot_564365, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
