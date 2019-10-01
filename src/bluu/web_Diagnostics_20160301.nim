
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Diagnostics API Client
## version: 2016-03-01
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "web-Diagnostics"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DiagnosticsListHostingEnvironmentDetectorResponses_567879 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsListHostingEnvironmentDetectorResponses_567881(
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

proc validate_DiagnosticsListHostingEnvironmentDetectorResponses_567880(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List Hosting Environment Detector Responses
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Site Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568054 = path.getOrDefault("resourceGroupName")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "resourceGroupName", valid_568054
  var valid_568055 = path.getOrDefault("name")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "name", valid_568055
  var valid_568056 = path.getOrDefault("subscriptionId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "subscriptionId", valid_568056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568057 = query.getOrDefault("api-version")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "api-version", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_DiagnosticsListHostingEnvironmentDetectorResponses_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Hosting Environment Detector Responses
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_DiagnosticsListHostingEnvironmentDetectorResponses_567879;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## diagnosticsListHostingEnvironmentDetectorResponses
  ## List Hosting Environment Detector Responses
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Site Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(path_568152, "resourceGroupName", newJString(resourceGroupName))
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "name", newJString(name))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var diagnosticsListHostingEnvironmentDetectorResponses* = Call_DiagnosticsListHostingEnvironmentDetectorResponses_567879(
    name: "diagnosticsListHostingEnvironmentDetectorResponses",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/detectors",
    validator: validate_DiagnosticsListHostingEnvironmentDetectorResponses_567880,
    base: "", url: url_DiagnosticsListHostingEnvironmentDetectorResponses_567881,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsGetHostingEnvironmentDetectorResponse_568193 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsGetHostingEnvironmentDetectorResponse_568195(
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

proc validate_DiagnosticsGetHostingEnvironmentDetectorResponse_568194(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get Hosting Environment Detector Response
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : App Service Environment Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   detectorName: JString (required)
  ##               : Detector Resource Name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568196 = path.getOrDefault("resourceGroupName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "resourceGroupName", valid_568196
  var valid_568197 = path.getOrDefault("name")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "name", valid_568197
  var valid_568198 = path.getOrDefault("subscriptionId")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "subscriptionId", valid_568198
  var valid_568199 = path.getOrDefault("detectorName")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "detectorName", valid_568199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   endTime: JString
  ##          : End Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   startTime: JString
  ##            : Start Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568200 = query.getOrDefault("api-version")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "api-version", valid_568200
  var valid_568201 = query.getOrDefault("endTime")
  valid_568201 = validateParameter(valid_568201, JString, required = false,
                                 default = nil)
  if valid_568201 != nil:
    section.add "endTime", valid_568201
  var valid_568202 = query.getOrDefault("timeGrain")
  valid_568202 = validateParameter(valid_568202, JString, required = false,
                                 default = nil)
  if valid_568202 != nil:
    section.add "timeGrain", valid_568202
  var valid_568203 = query.getOrDefault("startTime")
  valid_568203 = validateParameter(valid_568203, JString, required = false,
                                 default = nil)
  if valid_568203 != nil:
    section.add "startTime", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_DiagnosticsGetHostingEnvironmentDetectorResponse_568193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Hosting Environment Detector Response
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_DiagnosticsGetHostingEnvironmentDetectorResponse_568193;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; detectorName: string; endTime: string = "";
          timeGrain: string = ""; startTime: string = ""): Recallable =
  ## diagnosticsGetHostingEnvironmentDetectorResponse
  ## Get Hosting Environment Detector Response
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : App Service Environment Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   endTime: string
  ##          : End Time
  ##   timeGrain: string
  ##            : Time Grain
  ##   detectorName: string (required)
  ##               : Detector Resource Name
  ##   startTime: string
  ##            : Start Time
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(path_568206, "resourceGroupName", newJString(resourceGroupName))
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "name", newJString(name))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  add(query_568207, "endTime", newJString(endTime))
  add(query_568207, "timeGrain", newJString(timeGrain))
  add(path_568206, "detectorName", newJString(detectorName))
  add(query_568207, "startTime", newJString(startTime))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var diagnosticsGetHostingEnvironmentDetectorResponse* = Call_DiagnosticsGetHostingEnvironmentDetectorResponse_568193(
    name: "diagnosticsGetHostingEnvironmentDetectorResponse",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetHostingEnvironmentDetectorResponse_568194,
    base: "", url: url_DiagnosticsGetHostingEnvironmentDetectorResponse_568195,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDetectorResponses_568208 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsListSiteDetectorResponses_568210(protocol: Scheme;
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

proc validate_DiagnosticsListSiteDetectorResponses_568209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Site Detector Responses
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568211 = path.getOrDefault("resourceGroupName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "resourceGroupName", valid_568211
  var valid_568212 = path.getOrDefault("siteName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "siteName", valid_568212
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_DiagnosticsListSiteDetectorResponses_568208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Site Detector Responses
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_DiagnosticsListSiteDetectorResponses_568208;
          resourceGroupName: string; apiVersion: string; siteName: string;
          subscriptionId: string): Recallable =
  ## diagnosticsListSiteDetectorResponses
  ## List Site Detector Responses
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(path_568217, "resourceGroupName", newJString(resourceGroupName))
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "siteName", newJString(siteName))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var diagnosticsListSiteDetectorResponses* = Call_DiagnosticsListSiteDetectorResponses_568208(
    name: "diagnosticsListSiteDetectorResponses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/detectors",
    validator: validate_DiagnosticsListSiteDetectorResponses_568209, base: "",
    url: url_DiagnosticsListSiteDetectorResponses_568210, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDetectorResponse_568219 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsGetSiteDetectorResponse_568221(protocol: Scheme; host: string;
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

proc validate_DiagnosticsGetSiteDetectorResponse_568220(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get site detector response
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   detectorName: JString (required)
  ##               : Detector Resource Name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568222 = path.getOrDefault("resourceGroupName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "resourceGroupName", valid_568222
  var valid_568223 = path.getOrDefault("siteName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "siteName", valid_568223
  var valid_568224 = path.getOrDefault("subscriptionId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "subscriptionId", valid_568224
  var valid_568225 = path.getOrDefault("detectorName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "detectorName", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   endTime: JString
  ##          : End Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   startTime: JString
  ##            : Start Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  var valid_568227 = query.getOrDefault("endTime")
  valid_568227 = validateParameter(valid_568227, JString, required = false,
                                 default = nil)
  if valid_568227 != nil:
    section.add "endTime", valid_568227
  var valid_568228 = query.getOrDefault("timeGrain")
  valid_568228 = validateParameter(valid_568228, JString, required = false,
                                 default = nil)
  if valid_568228 != nil:
    section.add "timeGrain", valid_568228
  var valid_568229 = query.getOrDefault("startTime")
  valid_568229 = validateParameter(valid_568229, JString, required = false,
                                 default = nil)
  if valid_568229 != nil:
    section.add "startTime", valid_568229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568230: Call_DiagnosticsGetSiteDetectorResponse_568219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get site detector response
  ## 
  let valid = call_568230.validator(path, query, header, formData, body)
  let scheme = call_568230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568230.url(scheme.get, call_568230.host, call_568230.base,
                         call_568230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568230, url, valid)

proc call*(call_568231: Call_DiagnosticsGetSiteDetectorResponse_568219;
          resourceGroupName: string; apiVersion: string; siteName: string;
          subscriptionId: string; detectorName: string; endTime: string = "";
          timeGrain: string = ""; startTime: string = ""): Recallable =
  ## diagnosticsGetSiteDetectorResponse
  ## Get site detector response
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   endTime: string
  ##          : End Time
  ##   timeGrain: string
  ##            : Time Grain
  ##   detectorName: string (required)
  ##               : Detector Resource Name
  ##   startTime: string
  ##            : Start Time
  var path_568232 = newJObject()
  var query_568233 = newJObject()
  add(path_568232, "resourceGroupName", newJString(resourceGroupName))
  add(query_568233, "api-version", newJString(apiVersion))
  add(path_568232, "siteName", newJString(siteName))
  add(path_568232, "subscriptionId", newJString(subscriptionId))
  add(query_568233, "endTime", newJString(endTime))
  add(query_568233, "timeGrain", newJString(timeGrain))
  add(path_568232, "detectorName", newJString(detectorName))
  add(query_568233, "startTime", newJString(startTime))
  result = call_568231.call(path_568232, query_568233, nil, nil, nil)

var diagnosticsGetSiteDetectorResponse* = Call_DiagnosticsGetSiteDetectorResponse_568219(
    name: "diagnosticsGetSiteDetectorResponse", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetSiteDetectorResponse_568220, base: "",
    url: url_DiagnosticsGetSiteDetectorResponse_568221, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDiagnosticCategories_568234 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsListSiteDiagnosticCategories_568236(protocol: Scheme;
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

proc validate_DiagnosticsListSiteDiagnosticCategories_568235(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Diagnostics Categories
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568237 = path.getOrDefault("resourceGroupName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "resourceGroupName", valid_568237
  var valid_568238 = path.getOrDefault("siteName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "siteName", valid_568238
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568240 = query.getOrDefault("api-version")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "api-version", valid_568240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568241: Call_DiagnosticsListSiteDiagnosticCategories_568234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Diagnostics Categories
  ## 
  let valid = call_568241.validator(path, query, header, formData, body)
  let scheme = call_568241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568241.url(scheme.get, call_568241.host, call_568241.base,
                         call_568241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568241, url, valid)

proc call*(call_568242: Call_DiagnosticsListSiteDiagnosticCategories_568234;
          resourceGroupName: string; apiVersion: string; siteName: string;
          subscriptionId: string): Recallable =
  ## diagnosticsListSiteDiagnosticCategories
  ## Get Diagnostics Categories
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568243 = newJObject()
  var query_568244 = newJObject()
  add(path_568243, "resourceGroupName", newJString(resourceGroupName))
  add(query_568244, "api-version", newJString(apiVersion))
  add(path_568243, "siteName", newJString(siteName))
  add(path_568243, "subscriptionId", newJString(subscriptionId))
  result = call_568242.call(path_568243, query_568244, nil, nil, nil)

var diagnosticsListSiteDiagnosticCategories* = Call_DiagnosticsListSiteDiagnosticCategories_568234(
    name: "diagnosticsListSiteDiagnosticCategories", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics",
    validator: validate_DiagnosticsListSiteDiagnosticCategories_568235, base: "",
    url: url_DiagnosticsListSiteDiagnosticCategories_568236,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDiagnosticCategory_568245 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsGetSiteDiagnosticCategory_568247(protocol: Scheme;
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

proc validate_DiagnosticsGetSiteDiagnosticCategory_568246(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Diagnostics Category
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568248 = path.getOrDefault("resourceGroupName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "resourceGroupName", valid_568248
  var valid_568249 = path.getOrDefault("siteName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "siteName", valid_568249
  var valid_568250 = path.getOrDefault("diagnosticCategory")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "diagnosticCategory", valid_568250
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "api-version", valid_568252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568253: Call_DiagnosticsGetSiteDiagnosticCategory_568245;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Diagnostics Category
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_DiagnosticsGetSiteDiagnosticCategory_568245;
          resourceGroupName: string; apiVersion: string; siteName: string;
          diagnosticCategory: string; subscriptionId: string): Recallable =
  ## diagnosticsGetSiteDiagnosticCategory
  ## Get Diagnostics Category
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  add(path_568255, "resourceGroupName", newJString(resourceGroupName))
  add(query_568256, "api-version", newJString(apiVersion))
  add(path_568255, "siteName", newJString(siteName))
  add(path_568255, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  result = call_568254.call(path_568255, query_568256, nil, nil, nil)

var diagnosticsGetSiteDiagnosticCategory* = Call_DiagnosticsGetSiteDiagnosticCategory_568245(
    name: "diagnosticsGetSiteDiagnosticCategory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}",
    validator: validate_DiagnosticsGetSiteDiagnosticCategory_568246, base: "",
    url: url_DiagnosticsGetSiteDiagnosticCategory_568247, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteAnalyses_568257 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsListSiteAnalyses_568259(protocol: Scheme; host: string;
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

proc validate_DiagnosticsListSiteAnalyses_568258(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Site Analyses
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568260 = path.getOrDefault("resourceGroupName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "resourceGroupName", valid_568260
  var valid_568261 = path.getOrDefault("siteName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "siteName", valid_568261
  var valid_568262 = path.getOrDefault("diagnosticCategory")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "diagnosticCategory", valid_568262
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568264 = query.getOrDefault("api-version")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "api-version", valid_568264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568265: Call_DiagnosticsListSiteAnalyses_568257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Site Analyses
  ## 
  let valid = call_568265.validator(path, query, header, formData, body)
  let scheme = call_568265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568265.url(scheme.get, call_568265.host, call_568265.base,
                         call_568265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568265, url, valid)

proc call*(call_568266: Call_DiagnosticsListSiteAnalyses_568257;
          resourceGroupName: string; apiVersion: string; siteName: string;
          diagnosticCategory: string; subscriptionId: string): Recallable =
  ## diagnosticsListSiteAnalyses
  ## Get Site Analyses
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568267 = newJObject()
  var query_568268 = newJObject()
  add(path_568267, "resourceGroupName", newJString(resourceGroupName))
  add(query_568268, "api-version", newJString(apiVersion))
  add(path_568267, "siteName", newJString(siteName))
  add(path_568267, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568267, "subscriptionId", newJString(subscriptionId))
  result = call_568266.call(path_568267, query_568268, nil, nil, nil)

var diagnosticsListSiteAnalyses* = Call_DiagnosticsListSiteAnalyses_568257(
    name: "diagnosticsListSiteAnalyses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/analyses",
    validator: validate_DiagnosticsListSiteAnalyses_568258, base: "",
    url: url_DiagnosticsListSiteAnalyses_568259, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteAnalysis_568269 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsGetSiteAnalysis_568271(protocol: Scheme; host: string;
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

proc validate_DiagnosticsGetSiteAnalysis_568270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Site Analysis
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   analysisName: JString (required)
  ##               : Analysis Name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568272 = path.getOrDefault("resourceGroupName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "resourceGroupName", valid_568272
  var valid_568273 = path.getOrDefault("siteName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "siteName", valid_568273
  var valid_568274 = path.getOrDefault("diagnosticCategory")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "diagnosticCategory", valid_568274
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
  var valid_568276 = path.getOrDefault("analysisName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "analysisName", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_DiagnosticsGetSiteAnalysis_568269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Site Analysis
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_DiagnosticsGetSiteAnalysis_568269;
          resourceGroupName: string; apiVersion: string; siteName: string;
          diagnosticCategory: string; subscriptionId: string; analysisName: string): Recallable =
  ## diagnosticsGetSiteAnalysis
  ## Get Site Analysis
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   analysisName: string (required)
  ##               : Analysis Name
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  add(path_568280, "resourceGroupName", newJString(resourceGroupName))
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "siteName", newJString(siteName))
  add(path_568280, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568280, "subscriptionId", newJString(subscriptionId))
  add(path_568280, "analysisName", newJString(analysisName))
  result = call_568279.call(path_568280, query_568281, nil, nil, nil)

var diagnosticsGetSiteAnalysis* = Call_DiagnosticsGetSiteAnalysis_568269(
    name: "diagnosticsGetSiteAnalysis", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/analyses/{analysisName}",
    validator: validate_DiagnosticsGetSiteAnalysis_568270, base: "",
    url: url_DiagnosticsGetSiteAnalysis_568271, schemes: {Scheme.Https})
type
  Call_DiagnosticsExecuteSiteAnalysis_568282 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsExecuteSiteAnalysis_568284(protocol: Scheme; host: string;
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

proc validate_DiagnosticsExecuteSiteAnalysis_568283(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute Analysis
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Category Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   analysisName: JString (required)
  ##               : Analysis Resource Name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568285 = path.getOrDefault("resourceGroupName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "resourceGroupName", valid_568285
  var valid_568286 = path.getOrDefault("siteName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "siteName", valid_568286
  var valid_568287 = path.getOrDefault("diagnosticCategory")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "diagnosticCategory", valid_568287
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  var valid_568289 = path.getOrDefault("analysisName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "analysisName", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   endTime: JString
  ##          : End Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   startTime: JString
  ##            : Start Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "api-version", valid_568290
  var valid_568291 = query.getOrDefault("endTime")
  valid_568291 = validateParameter(valid_568291, JString, required = false,
                                 default = nil)
  if valid_568291 != nil:
    section.add "endTime", valid_568291
  var valid_568292 = query.getOrDefault("timeGrain")
  valid_568292 = validateParameter(valid_568292, JString, required = false,
                                 default = nil)
  if valid_568292 != nil:
    section.add "timeGrain", valid_568292
  var valid_568293 = query.getOrDefault("startTime")
  valid_568293 = validateParameter(valid_568293, JString, required = false,
                                 default = nil)
  if valid_568293 != nil:
    section.add "startTime", valid_568293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_DiagnosticsExecuteSiteAnalysis_568282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute Analysis
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_DiagnosticsExecuteSiteAnalysis_568282;
          resourceGroupName: string; apiVersion: string; siteName: string;
          diagnosticCategory: string; subscriptionId: string; analysisName: string;
          endTime: string = ""; timeGrain: string = ""; startTime: string = ""): Recallable =
  ## diagnosticsExecuteSiteAnalysis
  ## Execute Analysis
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   diagnosticCategory: string (required)
  ##                     : Category Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   endTime: string
  ##          : End Time
  ##   timeGrain: string
  ##            : Time Grain
  ##   analysisName: string (required)
  ##               : Analysis Resource Name
  ##   startTime: string
  ##            : Start Time
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "siteName", newJString(siteName))
  add(path_568296, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  add(query_568297, "endTime", newJString(endTime))
  add(query_568297, "timeGrain", newJString(timeGrain))
  add(path_568296, "analysisName", newJString(analysisName))
  add(query_568297, "startTime", newJString(startTime))
  result = call_568295.call(path_568296, query_568297, nil, nil, nil)

var diagnosticsExecuteSiteAnalysis* = Call_DiagnosticsExecuteSiteAnalysis_568282(
    name: "diagnosticsExecuteSiteAnalysis", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/analyses/{analysisName}/execute",
    validator: validate_DiagnosticsExecuteSiteAnalysis_568283, base: "",
    url: url_DiagnosticsExecuteSiteAnalysis_568284, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDetectors_568298 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsListSiteDetectors_568300(protocol: Scheme; host: string;
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

proc validate_DiagnosticsListSiteDetectors_568299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Detectors
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568301 = path.getOrDefault("resourceGroupName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "resourceGroupName", valid_568301
  var valid_568302 = path.getOrDefault("siteName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "siteName", valid_568302
  var valid_568303 = path.getOrDefault("diagnosticCategory")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "diagnosticCategory", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568305 = query.getOrDefault("api-version")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "api-version", valid_568305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_DiagnosticsListSiteDetectors_568298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Detectors
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_DiagnosticsListSiteDetectors_568298;
          resourceGroupName: string; apiVersion: string; siteName: string;
          diagnosticCategory: string; subscriptionId: string): Recallable =
  ## diagnosticsListSiteDetectors
  ## Get Detectors
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  add(path_568308, "resourceGroupName", newJString(resourceGroupName))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "siteName", newJString(siteName))
  add(path_568308, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  result = call_568307.call(path_568308, query_568309, nil, nil, nil)

var diagnosticsListSiteDetectors* = Call_DiagnosticsListSiteDetectors_568298(
    name: "diagnosticsListSiteDetectors", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/detectors",
    validator: validate_DiagnosticsListSiteDetectors_568299, base: "",
    url: url_DiagnosticsListSiteDetectors_568300, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDetector_568310 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsGetSiteDetector_568312(protocol: Scheme; host: string;
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

proc validate_DiagnosticsGetSiteDetector_568311(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Detector
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   detectorName: JString (required)
  ##               : Detector Name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568313 = path.getOrDefault("resourceGroupName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "resourceGroupName", valid_568313
  var valid_568314 = path.getOrDefault("siteName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "siteName", valid_568314
  var valid_568315 = path.getOrDefault("diagnosticCategory")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "diagnosticCategory", valid_568315
  var valid_568316 = path.getOrDefault("subscriptionId")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "subscriptionId", valid_568316
  var valid_568317 = path.getOrDefault("detectorName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "detectorName", valid_568317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568318 = query.getOrDefault("api-version")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "api-version", valid_568318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568319: Call_DiagnosticsGetSiteDetector_568310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Detector
  ## 
  let valid = call_568319.validator(path, query, header, formData, body)
  let scheme = call_568319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568319.url(scheme.get, call_568319.host, call_568319.base,
                         call_568319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568319, url, valid)

proc call*(call_568320: Call_DiagnosticsGetSiteDetector_568310;
          resourceGroupName: string; apiVersion: string; siteName: string;
          diagnosticCategory: string; subscriptionId: string; detectorName: string): Recallable =
  ## diagnosticsGetSiteDetector
  ## Get Detector
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   detectorName: string (required)
  ##               : Detector Name
  var path_568321 = newJObject()
  var query_568322 = newJObject()
  add(path_568321, "resourceGroupName", newJString(resourceGroupName))
  add(query_568322, "api-version", newJString(apiVersion))
  add(path_568321, "siteName", newJString(siteName))
  add(path_568321, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568321, "subscriptionId", newJString(subscriptionId))
  add(path_568321, "detectorName", newJString(detectorName))
  result = call_568320.call(path_568321, query_568322, nil, nil, nil)

var diagnosticsGetSiteDetector* = Call_DiagnosticsGetSiteDetector_568310(
    name: "diagnosticsGetSiteDetector", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetSiteDetector_568311, base: "",
    url: url_DiagnosticsGetSiteDetector_568312, schemes: {Scheme.Https})
type
  Call_DiagnosticsExecuteSiteDetector_568323 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsExecuteSiteDetector_568325(protocol: Scheme; host: string;
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

proc validate_DiagnosticsExecuteSiteDetector_568324(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute Detector
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   diagnosticCategory: JString (required)
  ##                     : Category Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   detectorName: JString (required)
  ##               : Detector Resource Name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568326 = path.getOrDefault("resourceGroupName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "resourceGroupName", valid_568326
  var valid_568327 = path.getOrDefault("siteName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "siteName", valid_568327
  var valid_568328 = path.getOrDefault("diagnosticCategory")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "diagnosticCategory", valid_568328
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  var valid_568330 = path.getOrDefault("detectorName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "detectorName", valid_568330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   endTime: JString
  ##          : End Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   startTime: JString
  ##            : Start Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568331 = query.getOrDefault("api-version")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "api-version", valid_568331
  var valid_568332 = query.getOrDefault("endTime")
  valid_568332 = validateParameter(valid_568332, JString, required = false,
                                 default = nil)
  if valid_568332 != nil:
    section.add "endTime", valid_568332
  var valid_568333 = query.getOrDefault("timeGrain")
  valid_568333 = validateParameter(valid_568333, JString, required = false,
                                 default = nil)
  if valid_568333 != nil:
    section.add "timeGrain", valid_568333
  var valid_568334 = query.getOrDefault("startTime")
  valid_568334 = validateParameter(valid_568334, JString, required = false,
                                 default = nil)
  if valid_568334 != nil:
    section.add "startTime", valid_568334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568335: Call_DiagnosticsExecuteSiteDetector_568323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute Detector
  ## 
  let valid = call_568335.validator(path, query, header, formData, body)
  let scheme = call_568335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568335.url(scheme.get, call_568335.host, call_568335.base,
                         call_568335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568335, url, valid)

proc call*(call_568336: Call_DiagnosticsExecuteSiteDetector_568323;
          resourceGroupName: string; apiVersion: string; siteName: string;
          diagnosticCategory: string; subscriptionId: string; detectorName: string;
          endTime: string = ""; timeGrain: string = ""; startTime: string = ""): Recallable =
  ## diagnosticsExecuteSiteDetector
  ## Execute Detector
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   diagnosticCategory: string (required)
  ##                     : Category Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   endTime: string
  ##          : End Time
  ##   timeGrain: string
  ##            : Time Grain
  ##   detectorName: string (required)
  ##               : Detector Resource Name
  ##   startTime: string
  ##            : Start Time
  var path_568337 = newJObject()
  var query_568338 = newJObject()
  add(path_568337, "resourceGroupName", newJString(resourceGroupName))
  add(query_568338, "api-version", newJString(apiVersion))
  add(path_568337, "siteName", newJString(siteName))
  add(path_568337, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568337, "subscriptionId", newJString(subscriptionId))
  add(query_568338, "endTime", newJString(endTime))
  add(query_568338, "timeGrain", newJString(timeGrain))
  add(path_568337, "detectorName", newJString(detectorName))
  add(query_568338, "startTime", newJString(startTime))
  result = call_568336.call(path_568337, query_568338, nil, nil, nil)

var diagnosticsExecuteSiteDetector* = Call_DiagnosticsExecuteSiteDetector_568323(
    name: "diagnosticsExecuteSiteDetector", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/detectors/{detectorName}/execute",
    validator: validate_DiagnosticsExecuteSiteDetector_568324, base: "",
    url: url_DiagnosticsExecuteSiteDetector_568325, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDetectorResponsesSlot_568339 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsListSiteDetectorResponsesSlot_568341(protocol: Scheme;
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

proc validate_DiagnosticsListSiteDetectorResponsesSlot_568340(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Site Detector Responses
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568342 = path.getOrDefault("resourceGroupName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "resourceGroupName", valid_568342
  var valid_568343 = path.getOrDefault("siteName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "siteName", valid_568343
  var valid_568344 = path.getOrDefault("slot")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "slot", valid_568344
  var valid_568345 = path.getOrDefault("subscriptionId")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "subscriptionId", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568347: Call_DiagnosticsListSiteDetectorResponsesSlot_568339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Site Detector Responses
  ## 
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_DiagnosticsListSiteDetectorResponsesSlot_568339;
          resourceGroupName: string; apiVersion: string; siteName: string;
          slot: string; subscriptionId: string): Recallable =
  ## diagnosticsListSiteDetectorResponsesSlot
  ## List Site Detector Responses
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  add(path_568349, "resourceGroupName", newJString(resourceGroupName))
  add(query_568350, "api-version", newJString(apiVersion))
  add(path_568349, "siteName", newJString(siteName))
  add(path_568349, "slot", newJString(slot))
  add(path_568349, "subscriptionId", newJString(subscriptionId))
  result = call_568348.call(path_568349, query_568350, nil, nil, nil)

var diagnosticsListSiteDetectorResponsesSlot* = Call_DiagnosticsListSiteDetectorResponsesSlot_568339(
    name: "diagnosticsListSiteDetectorResponsesSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/detectors",
    validator: validate_DiagnosticsListSiteDetectorResponsesSlot_568340, base: "",
    url: url_DiagnosticsListSiteDetectorResponsesSlot_568341,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDetectorResponseSlot_568351 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsGetSiteDetectorResponseSlot_568353(protocol: Scheme;
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

proc validate_DiagnosticsGetSiteDetectorResponseSlot_568352(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get site detector response
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   detectorName: JString (required)
  ##               : Detector Resource Name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568354 = path.getOrDefault("resourceGroupName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "resourceGroupName", valid_568354
  var valid_568355 = path.getOrDefault("siteName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "siteName", valid_568355
  var valid_568356 = path.getOrDefault("slot")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "slot", valid_568356
  var valid_568357 = path.getOrDefault("subscriptionId")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "subscriptionId", valid_568357
  var valid_568358 = path.getOrDefault("detectorName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "detectorName", valid_568358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   endTime: JString
  ##          : End Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   startTime: JString
  ##            : Start Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568359 = query.getOrDefault("api-version")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "api-version", valid_568359
  var valid_568360 = query.getOrDefault("endTime")
  valid_568360 = validateParameter(valid_568360, JString, required = false,
                                 default = nil)
  if valid_568360 != nil:
    section.add "endTime", valid_568360
  var valid_568361 = query.getOrDefault("timeGrain")
  valid_568361 = validateParameter(valid_568361, JString, required = false,
                                 default = nil)
  if valid_568361 != nil:
    section.add "timeGrain", valid_568361
  var valid_568362 = query.getOrDefault("startTime")
  valid_568362 = validateParameter(valid_568362, JString, required = false,
                                 default = nil)
  if valid_568362 != nil:
    section.add "startTime", valid_568362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568363: Call_DiagnosticsGetSiteDetectorResponseSlot_568351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get site detector response
  ## 
  let valid = call_568363.validator(path, query, header, formData, body)
  let scheme = call_568363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568363.url(scheme.get, call_568363.host, call_568363.base,
                         call_568363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568363, url, valid)

proc call*(call_568364: Call_DiagnosticsGetSiteDetectorResponseSlot_568351;
          resourceGroupName: string; apiVersion: string; siteName: string;
          slot: string; subscriptionId: string; detectorName: string;
          endTime: string = ""; timeGrain: string = ""; startTime: string = ""): Recallable =
  ## diagnosticsGetSiteDetectorResponseSlot
  ## Get site detector response
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   endTime: string
  ##          : End Time
  ##   timeGrain: string
  ##            : Time Grain
  ##   detectorName: string (required)
  ##               : Detector Resource Name
  ##   startTime: string
  ##            : Start Time
  var path_568365 = newJObject()
  var query_568366 = newJObject()
  add(path_568365, "resourceGroupName", newJString(resourceGroupName))
  add(query_568366, "api-version", newJString(apiVersion))
  add(path_568365, "siteName", newJString(siteName))
  add(path_568365, "slot", newJString(slot))
  add(path_568365, "subscriptionId", newJString(subscriptionId))
  add(query_568366, "endTime", newJString(endTime))
  add(query_568366, "timeGrain", newJString(timeGrain))
  add(path_568365, "detectorName", newJString(detectorName))
  add(query_568366, "startTime", newJString(startTime))
  result = call_568364.call(path_568365, query_568366, nil, nil, nil)

var diagnosticsGetSiteDetectorResponseSlot* = Call_DiagnosticsGetSiteDetectorResponseSlot_568351(
    name: "diagnosticsGetSiteDetectorResponseSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetSiteDetectorResponseSlot_568352, base: "",
    url: url_DiagnosticsGetSiteDetectorResponseSlot_568353,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDiagnosticCategoriesSlot_568367 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsListSiteDiagnosticCategoriesSlot_568369(protocol: Scheme;
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

proc validate_DiagnosticsListSiteDiagnosticCategoriesSlot_568368(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Diagnostics Categories
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568370 = path.getOrDefault("resourceGroupName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "resourceGroupName", valid_568370
  var valid_568371 = path.getOrDefault("siteName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "siteName", valid_568371
  var valid_568372 = path.getOrDefault("slot")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "slot", valid_568372
  var valid_568373 = path.getOrDefault("subscriptionId")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "subscriptionId", valid_568373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568374 = query.getOrDefault("api-version")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "api-version", valid_568374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568375: Call_DiagnosticsListSiteDiagnosticCategoriesSlot_568367;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Diagnostics Categories
  ## 
  let valid = call_568375.validator(path, query, header, formData, body)
  let scheme = call_568375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568375.url(scheme.get, call_568375.host, call_568375.base,
                         call_568375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568375, url, valid)

proc call*(call_568376: Call_DiagnosticsListSiteDiagnosticCategoriesSlot_568367;
          resourceGroupName: string; apiVersion: string; siteName: string;
          slot: string; subscriptionId: string): Recallable =
  ## diagnosticsListSiteDiagnosticCategoriesSlot
  ## Get Diagnostics Categories
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568377 = newJObject()
  var query_568378 = newJObject()
  add(path_568377, "resourceGroupName", newJString(resourceGroupName))
  add(query_568378, "api-version", newJString(apiVersion))
  add(path_568377, "siteName", newJString(siteName))
  add(path_568377, "slot", newJString(slot))
  add(path_568377, "subscriptionId", newJString(subscriptionId))
  result = call_568376.call(path_568377, query_568378, nil, nil, nil)

var diagnosticsListSiteDiagnosticCategoriesSlot* = Call_DiagnosticsListSiteDiagnosticCategoriesSlot_568367(
    name: "diagnosticsListSiteDiagnosticCategoriesSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics",
    validator: validate_DiagnosticsListSiteDiagnosticCategoriesSlot_568368,
    base: "", url: url_DiagnosticsListSiteDiagnosticCategoriesSlot_568369,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDiagnosticCategorySlot_568379 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsGetSiteDiagnosticCategorySlot_568381(protocol: Scheme;
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

proc validate_DiagnosticsGetSiteDiagnosticCategorySlot_568380(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Diagnostics Category
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568382 = path.getOrDefault("resourceGroupName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "resourceGroupName", valid_568382
  var valid_568383 = path.getOrDefault("siteName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "siteName", valid_568383
  var valid_568384 = path.getOrDefault("slot")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "slot", valid_568384
  var valid_568385 = path.getOrDefault("diagnosticCategory")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "diagnosticCategory", valid_568385
  var valid_568386 = path.getOrDefault("subscriptionId")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "subscriptionId", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_DiagnosticsGetSiteDiagnosticCategorySlot_568379;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Diagnostics Category
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_DiagnosticsGetSiteDiagnosticCategorySlot_568379;
          resourceGroupName: string; apiVersion: string; siteName: string;
          slot: string; diagnosticCategory: string; subscriptionId: string): Recallable =
  ## diagnosticsGetSiteDiagnosticCategorySlot
  ## Get Diagnostics Category
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "siteName", newJString(siteName))
  add(path_568390, "slot", newJString(slot))
  add(path_568390, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var diagnosticsGetSiteDiagnosticCategorySlot* = Call_DiagnosticsGetSiteDiagnosticCategorySlot_568379(
    name: "diagnosticsGetSiteDiagnosticCategorySlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}",
    validator: validate_DiagnosticsGetSiteDiagnosticCategorySlot_568380, base: "",
    url: url_DiagnosticsGetSiteDiagnosticCategorySlot_568381,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteAnalysesSlot_568392 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsListSiteAnalysesSlot_568394(protocol: Scheme; host: string;
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

proc validate_DiagnosticsListSiteAnalysesSlot_568393(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Site Analyses
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568395 = path.getOrDefault("resourceGroupName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "resourceGroupName", valid_568395
  var valid_568396 = path.getOrDefault("siteName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "siteName", valid_568396
  var valid_568397 = path.getOrDefault("slot")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "slot", valid_568397
  var valid_568398 = path.getOrDefault("diagnosticCategory")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "diagnosticCategory", valid_568398
  var valid_568399 = path.getOrDefault("subscriptionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "subscriptionId", valid_568399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568400 = query.getOrDefault("api-version")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "api-version", valid_568400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568401: Call_DiagnosticsListSiteAnalysesSlot_568392;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Site Analyses
  ## 
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_DiagnosticsListSiteAnalysesSlot_568392;
          resourceGroupName: string; apiVersion: string; siteName: string;
          slot: string; diagnosticCategory: string; subscriptionId: string): Recallable =
  ## diagnosticsListSiteAnalysesSlot
  ## Get Site Analyses
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  add(path_568403, "resourceGroupName", newJString(resourceGroupName))
  add(query_568404, "api-version", newJString(apiVersion))
  add(path_568403, "siteName", newJString(siteName))
  add(path_568403, "slot", newJString(slot))
  add(path_568403, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568403, "subscriptionId", newJString(subscriptionId))
  result = call_568402.call(path_568403, query_568404, nil, nil, nil)

var diagnosticsListSiteAnalysesSlot* = Call_DiagnosticsListSiteAnalysesSlot_568392(
    name: "diagnosticsListSiteAnalysesSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/analyses",
    validator: validate_DiagnosticsListSiteAnalysesSlot_568393, base: "",
    url: url_DiagnosticsListSiteAnalysesSlot_568394, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteAnalysisSlot_568405 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsGetSiteAnalysisSlot_568407(protocol: Scheme; host: string;
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

proc validate_DiagnosticsGetSiteAnalysisSlot_568406(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Site Analysis
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
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
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568408 = path.getOrDefault("resourceGroupName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "resourceGroupName", valid_568408
  var valid_568409 = path.getOrDefault("siteName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "siteName", valid_568409
  var valid_568410 = path.getOrDefault("slot")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "slot", valid_568410
  var valid_568411 = path.getOrDefault("diagnosticCategory")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "diagnosticCategory", valid_568411
  var valid_568412 = path.getOrDefault("subscriptionId")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "subscriptionId", valid_568412
  var valid_568413 = path.getOrDefault("analysisName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "analysisName", valid_568413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "api-version", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568415: Call_DiagnosticsGetSiteAnalysisSlot_568405; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Site Analysis
  ## 
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_DiagnosticsGetSiteAnalysisSlot_568405;
          resourceGroupName: string; apiVersion: string; siteName: string;
          slot: string; diagnosticCategory: string; subscriptionId: string;
          analysisName: string): Recallable =
  ## diagnosticsGetSiteAnalysisSlot
  ## Get Site Analysis
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot - optional
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   analysisName: string (required)
  ##               : Analysis Name
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(path_568417, "resourceGroupName", newJString(resourceGroupName))
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "siteName", newJString(siteName))
  add(path_568417, "slot", newJString(slot))
  add(path_568417, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568417, "subscriptionId", newJString(subscriptionId))
  add(path_568417, "analysisName", newJString(analysisName))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var diagnosticsGetSiteAnalysisSlot* = Call_DiagnosticsGetSiteAnalysisSlot_568405(
    name: "diagnosticsGetSiteAnalysisSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/analyses/{analysisName}",
    validator: validate_DiagnosticsGetSiteAnalysisSlot_568406, base: "",
    url: url_DiagnosticsGetSiteAnalysisSlot_568407, schemes: {Scheme.Https})
type
  Call_DiagnosticsExecuteSiteAnalysisSlot_568419 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsExecuteSiteAnalysisSlot_568421(protocol: Scheme; host: string;
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

proc validate_DiagnosticsExecuteSiteAnalysisSlot_568420(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute Analysis
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
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
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568422 = path.getOrDefault("resourceGroupName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "resourceGroupName", valid_568422
  var valid_568423 = path.getOrDefault("siteName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "siteName", valid_568423
  var valid_568424 = path.getOrDefault("slot")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "slot", valid_568424
  var valid_568425 = path.getOrDefault("diagnosticCategory")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "diagnosticCategory", valid_568425
  var valid_568426 = path.getOrDefault("subscriptionId")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "subscriptionId", valid_568426
  var valid_568427 = path.getOrDefault("analysisName")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "analysisName", valid_568427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   endTime: JString
  ##          : End Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   startTime: JString
  ##            : Start Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568428 = query.getOrDefault("api-version")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "api-version", valid_568428
  var valid_568429 = query.getOrDefault("endTime")
  valid_568429 = validateParameter(valid_568429, JString, required = false,
                                 default = nil)
  if valid_568429 != nil:
    section.add "endTime", valid_568429
  var valid_568430 = query.getOrDefault("timeGrain")
  valid_568430 = validateParameter(valid_568430, JString, required = false,
                                 default = nil)
  if valid_568430 != nil:
    section.add "timeGrain", valid_568430
  var valid_568431 = query.getOrDefault("startTime")
  valid_568431 = validateParameter(valid_568431, JString, required = false,
                                 default = nil)
  if valid_568431 != nil:
    section.add "startTime", valid_568431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568432: Call_DiagnosticsExecuteSiteAnalysisSlot_568419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Execute Analysis
  ## 
  let valid = call_568432.validator(path, query, header, formData, body)
  let scheme = call_568432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568432.url(scheme.get, call_568432.host, call_568432.base,
                         call_568432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568432, url, valid)

proc call*(call_568433: Call_DiagnosticsExecuteSiteAnalysisSlot_568419;
          resourceGroupName: string; apiVersion: string; siteName: string;
          slot: string; diagnosticCategory: string; subscriptionId: string;
          analysisName: string; endTime: string = ""; timeGrain: string = "";
          startTime: string = ""): Recallable =
  ## diagnosticsExecuteSiteAnalysisSlot
  ## Execute Analysis
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   diagnosticCategory: string (required)
  ##                     : Category Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   endTime: string
  ##          : End Time
  ##   timeGrain: string
  ##            : Time Grain
  ##   analysisName: string (required)
  ##               : Analysis Resource Name
  ##   startTime: string
  ##            : Start Time
  var path_568434 = newJObject()
  var query_568435 = newJObject()
  add(path_568434, "resourceGroupName", newJString(resourceGroupName))
  add(query_568435, "api-version", newJString(apiVersion))
  add(path_568434, "siteName", newJString(siteName))
  add(path_568434, "slot", newJString(slot))
  add(path_568434, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568434, "subscriptionId", newJString(subscriptionId))
  add(query_568435, "endTime", newJString(endTime))
  add(query_568435, "timeGrain", newJString(timeGrain))
  add(path_568434, "analysisName", newJString(analysisName))
  add(query_568435, "startTime", newJString(startTime))
  result = call_568433.call(path_568434, query_568435, nil, nil, nil)

var diagnosticsExecuteSiteAnalysisSlot* = Call_DiagnosticsExecuteSiteAnalysisSlot_568419(
    name: "diagnosticsExecuteSiteAnalysisSlot", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/analyses/{analysisName}/execute",
    validator: validate_DiagnosticsExecuteSiteAnalysisSlot_568420, base: "",
    url: url_DiagnosticsExecuteSiteAnalysisSlot_568421, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDetectorsSlot_568436 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsListSiteDetectorsSlot_568438(protocol: Scheme; host: string;
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

proc validate_DiagnosticsListSiteDetectorsSlot_568437(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Detectors
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568439 = path.getOrDefault("resourceGroupName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "resourceGroupName", valid_568439
  var valid_568440 = path.getOrDefault("siteName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "siteName", valid_568440
  var valid_568441 = path.getOrDefault("slot")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "slot", valid_568441
  var valid_568442 = path.getOrDefault("diagnosticCategory")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "diagnosticCategory", valid_568442
  var valid_568443 = path.getOrDefault("subscriptionId")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "subscriptionId", valid_568443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568444 = query.getOrDefault("api-version")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "api-version", valid_568444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568445: Call_DiagnosticsListSiteDetectorsSlot_568436;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Detectors
  ## 
  let valid = call_568445.validator(path, query, header, formData, body)
  let scheme = call_568445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568445.url(scheme.get, call_568445.host, call_568445.base,
                         call_568445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568445, url, valid)

proc call*(call_568446: Call_DiagnosticsListSiteDetectorsSlot_568436;
          resourceGroupName: string; apiVersion: string; siteName: string;
          slot: string; diagnosticCategory: string; subscriptionId: string): Recallable =
  ## diagnosticsListSiteDetectorsSlot
  ## Get Detectors
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568447 = newJObject()
  var query_568448 = newJObject()
  add(path_568447, "resourceGroupName", newJString(resourceGroupName))
  add(query_568448, "api-version", newJString(apiVersion))
  add(path_568447, "siteName", newJString(siteName))
  add(path_568447, "slot", newJString(slot))
  add(path_568447, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568447, "subscriptionId", newJString(subscriptionId))
  result = call_568446.call(path_568447, query_568448, nil, nil, nil)

var diagnosticsListSiteDetectorsSlot* = Call_DiagnosticsListSiteDetectorsSlot_568436(
    name: "diagnosticsListSiteDetectorsSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/detectors",
    validator: validate_DiagnosticsListSiteDetectorsSlot_568437, base: "",
    url: url_DiagnosticsListSiteDetectorsSlot_568438, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDetectorSlot_568449 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsGetSiteDetectorSlot_568451(protocol: Scheme; host: string;
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

proc validate_DiagnosticsGetSiteDetectorSlot_568450(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Detector
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   diagnosticCategory: JString (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   detectorName: JString (required)
  ##               : Detector Name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568452 = path.getOrDefault("resourceGroupName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "resourceGroupName", valid_568452
  var valid_568453 = path.getOrDefault("siteName")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "siteName", valid_568453
  var valid_568454 = path.getOrDefault("slot")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "slot", valid_568454
  var valid_568455 = path.getOrDefault("diagnosticCategory")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "diagnosticCategory", valid_568455
  var valid_568456 = path.getOrDefault("subscriptionId")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "subscriptionId", valid_568456
  var valid_568457 = path.getOrDefault("detectorName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "detectorName", valid_568457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568458 = query.getOrDefault("api-version")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "api-version", valid_568458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568459: Call_DiagnosticsGetSiteDetectorSlot_568449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Detector
  ## 
  let valid = call_568459.validator(path, query, header, formData, body)
  let scheme = call_568459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568459.url(scheme.get, call_568459.host, call_568459.base,
                         call_568459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568459, url, valid)

proc call*(call_568460: Call_DiagnosticsGetSiteDetectorSlot_568449;
          resourceGroupName: string; apiVersion: string; siteName: string;
          slot: string; diagnosticCategory: string; subscriptionId: string;
          detectorName: string): Recallable =
  ## diagnosticsGetSiteDetectorSlot
  ## Get Detector
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   diagnosticCategory: string (required)
  ##                     : Diagnostic Category
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   detectorName: string (required)
  ##               : Detector Name
  var path_568461 = newJObject()
  var query_568462 = newJObject()
  add(path_568461, "resourceGroupName", newJString(resourceGroupName))
  add(query_568462, "api-version", newJString(apiVersion))
  add(path_568461, "siteName", newJString(siteName))
  add(path_568461, "slot", newJString(slot))
  add(path_568461, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568461, "subscriptionId", newJString(subscriptionId))
  add(path_568461, "detectorName", newJString(detectorName))
  result = call_568460.call(path_568461, query_568462, nil, nil, nil)

var diagnosticsGetSiteDetectorSlot* = Call_DiagnosticsGetSiteDetectorSlot_568449(
    name: "diagnosticsGetSiteDetectorSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetSiteDetectorSlot_568450, base: "",
    url: url_DiagnosticsGetSiteDetectorSlot_568451, schemes: {Scheme.Https})
type
  Call_DiagnosticsExecuteSiteDetectorSlot_568463 = ref object of OpenApiRestCall_567657
proc url_DiagnosticsExecuteSiteDetectorSlot_568465(protocol: Scheme; host: string;
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

proc validate_DiagnosticsExecuteSiteDetectorSlot_568464(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute Detector
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   siteName: JString (required)
  ##           : Site Name
  ##   slot: JString (required)
  ##       : Slot Name
  ##   diagnosticCategory: JString (required)
  ##                     : Category Name
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   detectorName: JString (required)
  ##               : Detector Resource Name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568466 = path.getOrDefault("resourceGroupName")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "resourceGroupName", valid_568466
  var valid_568467 = path.getOrDefault("siteName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "siteName", valid_568467
  var valid_568468 = path.getOrDefault("slot")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "slot", valid_568468
  var valid_568469 = path.getOrDefault("diagnosticCategory")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "diagnosticCategory", valid_568469
  var valid_568470 = path.getOrDefault("subscriptionId")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "subscriptionId", valid_568470
  var valid_568471 = path.getOrDefault("detectorName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "detectorName", valid_568471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   endTime: JString
  ##          : End Time
  ##   timeGrain: JString
  ##            : Time Grain
  ##   startTime: JString
  ##            : Start Time
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568472 = query.getOrDefault("api-version")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "api-version", valid_568472
  var valid_568473 = query.getOrDefault("endTime")
  valid_568473 = validateParameter(valid_568473, JString, required = false,
                                 default = nil)
  if valid_568473 != nil:
    section.add "endTime", valid_568473
  var valid_568474 = query.getOrDefault("timeGrain")
  valid_568474 = validateParameter(valid_568474, JString, required = false,
                                 default = nil)
  if valid_568474 != nil:
    section.add "timeGrain", valid_568474
  var valid_568475 = query.getOrDefault("startTime")
  valid_568475 = validateParameter(valid_568475, JString, required = false,
                                 default = nil)
  if valid_568475 != nil:
    section.add "startTime", valid_568475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568476: Call_DiagnosticsExecuteSiteDetectorSlot_568463;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Execute Detector
  ## 
  let valid = call_568476.validator(path, query, header, formData, body)
  let scheme = call_568476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568476.url(scheme.get, call_568476.host, call_568476.base,
                         call_568476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568476, url, valid)

proc call*(call_568477: Call_DiagnosticsExecuteSiteDetectorSlot_568463;
          resourceGroupName: string; apiVersion: string; siteName: string;
          slot: string; diagnosticCategory: string; subscriptionId: string;
          detectorName: string; endTime: string = ""; timeGrain: string = "";
          startTime: string = ""): Recallable =
  ## diagnosticsExecuteSiteDetectorSlot
  ## Execute Detector
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   siteName: string (required)
  ##           : Site Name
  ##   slot: string (required)
  ##       : Slot Name
  ##   diagnosticCategory: string (required)
  ##                     : Category Name
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   endTime: string
  ##          : End Time
  ##   timeGrain: string
  ##            : Time Grain
  ##   detectorName: string (required)
  ##               : Detector Resource Name
  ##   startTime: string
  ##            : Start Time
  var path_568478 = newJObject()
  var query_568479 = newJObject()
  add(path_568478, "resourceGroupName", newJString(resourceGroupName))
  add(query_568479, "api-version", newJString(apiVersion))
  add(path_568478, "siteName", newJString(siteName))
  add(path_568478, "slot", newJString(slot))
  add(path_568478, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_568478, "subscriptionId", newJString(subscriptionId))
  add(query_568479, "endTime", newJString(endTime))
  add(query_568479, "timeGrain", newJString(timeGrain))
  add(path_568478, "detectorName", newJString(detectorName))
  add(query_568479, "startTime", newJString(startTime))
  result = call_568477.call(path_568478, query_568479, nil, nil, nil)

var diagnosticsExecuteSiteDetectorSlot* = Call_DiagnosticsExecuteSiteDetectorSlot_568463(
    name: "diagnosticsExecuteSiteDetectorSlot", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/detectors/{detectorName}/execute",
    validator: validate_DiagnosticsExecuteSiteDetectorSlot_568464, base: "",
    url: url_DiagnosticsExecuteSiteDetectorSlot_568465, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
