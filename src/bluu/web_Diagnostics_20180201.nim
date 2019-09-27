
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "web-Diagnostics"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DiagnosticsListHostingEnvironmentDetectorResponses_593646 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsListHostingEnvironmentDetectorResponses_593648(
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

proc validate_DiagnosticsListHostingEnvironmentDetectorResponses_593647(
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
  var valid_593821 = path.getOrDefault("resourceGroupName")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "resourceGroupName", valid_593821
  var valid_593822 = path.getOrDefault("name")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "name", valid_593822
  var valid_593823 = path.getOrDefault("subscriptionId")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "subscriptionId", valid_593823
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "api-version", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593847: Call_DiagnosticsListHostingEnvironmentDetectorResponses_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Hosting Environment Detector Responses
  ## 
  let valid = call_593847.validator(path, query, header, formData, body)
  let scheme = call_593847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593847.url(scheme.get, call_593847.host, call_593847.base,
                         call_593847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593847, url, valid)

proc call*(call_593918: Call_DiagnosticsListHostingEnvironmentDetectorResponses_593646;
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
  var path_593919 = newJObject()
  var query_593921 = newJObject()
  add(path_593919, "resourceGroupName", newJString(resourceGroupName))
  add(query_593921, "api-version", newJString(apiVersion))
  add(path_593919, "name", newJString(name))
  add(path_593919, "subscriptionId", newJString(subscriptionId))
  result = call_593918.call(path_593919, query_593921, nil, nil, nil)

var diagnosticsListHostingEnvironmentDetectorResponses* = Call_DiagnosticsListHostingEnvironmentDetectorResponses_593646(
    name: "diagnosticsListHostingEnvironmentDetectorResponses",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/detectors",
    validator: validate_DiagnosticsListHostingEnvironmentDetectorResponses_593647,
    base: "", url: url_DiagnosticsListHostingEnvironmentDetectorResponses_593648,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsGetHostingEnvironmentDetectorResponse_593960 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsGetHostingEnvironmentDetectorResponse_593962(
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

proc validate_DiagnosticsGetHostingEnvironmentDetectorResponse_593961(
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
  var valid_593963 = path.getOrDefault("resourceGroupName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "resourceGroupName", valid_593963
  var valid_593964 = path.getOrDefault("name")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "name", valid_593964
  var valid_593965 = path.getOrDefault("subscriptionId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "subscriptionId", valid_593965
  var valid_593966 = path.getOrDefault("detectorName")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "detectorName", valid_593966
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
  var valid_593967 = query.getOrDefault("api-version")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "api-version", valid_593967
  var valid_593968 = query.getOrDefault("endTime")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "endTime", valid_593968
  var valid_593969 = query.getOrDefault("timeGrain")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "timeGrain", valid_593969
  var valid_593970 = query.getOrDefault("startTime")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "startTime", valid_593970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593971: Call_DiagnosticsGetHostingEnvironmentDetectorResponse_593960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Hosting Environment Detector Response
  ## 
  let valid = call_593971.validator(path, query, header, formData, body)
  let scheme = call_593971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593971.url(scheme.get, call_593971.host, call_593971.base,
                         call_593971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593971, url, valid)

proc call*(call_593972: Call_DiagnosticsGetHostingEnvironmentDetectorResponse_593960;
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
  var path_593973 = newJObject()
  var query_593974 = newJObject()
  add(path_593973, "resourceGroupName", newJString(resourceGroupName))
  add(query_593974, "api-version", newJString(apiVersion))
  add(path_593973, "name", newJString(name))
  add(path_593973, "subscriptionId", newJString(subscriptionId))
  add(query_593974, "endTime", newJString(endTime))
  add(query_593974, "timeGrain", newJString(timeGrain))
  add(path_593973, "detectorName", newJString(detectorName))
  add(query_593974, "startTime", newJString(startTime))
  result = call_593972.call(path_593973, query_593974, nil, nil, nil)

var diagnosticsGetHostingEnvironmentDetectorResponse* = Call_DiagnosticsGetHostingEnvironmentDetectorResponse_593960(
    name: "diagnosticsGetHostingEnvironmentDetectorResponse",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/hostingEnvironments/{name}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetHostingEnvironmentDetectorResponse_593961,
    base: "", url: url_DiagnosticsGetHostingEnvironmentDetectorResponse_593962,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDetectorResponses_593975 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsListSiteDetectorResponses_593977(protocol: Scheme;
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

proc validate_DiagnosticsListSiteDetectorResponses_593976(path: JsonNode;
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
  var valid_593978 = path.getOrDefault("resourceGroupName")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "resourceGroupName", valid_593978
  var valid_593979 = path.getOrDefault("siteName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "siteName", valid_593979
  var valid_593980 = path.getOrDefault("subscriptionId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "subscriptionId", valid_593980
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593981 = query.getOrDefault("api-version")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "api-version", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_DiagnosticsListSiteDetectorResponses_593975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Site Detector Responses
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_DiagnosticsListSiteDetectorResponses_593975;
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
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  add(path_593984, "resourceGroupName", newJString(resourceGroupName))
  add(query_593985, "api-version", newJString(apiVersion))
  add(path_593984, "siteName", newJString(siteName))
  add(path_593984, "subscriptionId", newJString(subscriptionId))
  result = call_593983.call(path_593984, query_593985, nil, nil, nil)

var diagnosticsListSiteDetectorResponses* = Call_DiagnosticsListSiteDetectorResponses_593975(
    name: "diagnosticsListSiteDetectorResponses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/detectors",
    validator: validate_DiagnosticsListSiteDetectorResponses_593976, base: "",
    url: url_DiagnosticsListSiteDetectorResponses_593977, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDetectorResponse_593986 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsGetSiteDetectorResponse_593988(protocol: Scheme; host: string;
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

proc validate_DiagnosticsGetSiteDetectorResponse_593987(path: JsonNode;
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
  var valid_593989 = path.getOrDefault("resourceGroupName")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "resourceGroupName", valid_593989
  var valid_593990 = path.getOrDefault("siteName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "siteName", valid_593990
  var valid_593991 = path.getOrDefault("subscriptionId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "subscriptionId", valid_593991
  var valid_593992 = path.getOrDefault("detectorName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "detectorName", valid_593992
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
  var valid_593993 = query.getOrDefault("api-version")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "api-version", valid_593993
  var valid_593994 = query.getOrDefault("endTime")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "endTime", valid_593994
  var valid_593995 = query.getOrDefault("timeGrain")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "timeGrain", valid_593995
  var valid_593996 = query.getOrDefault("startTime")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "startTime", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_DiagnosticsGetSiteDetectorResponse_593986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get site detector response
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_DiagnosticsGetSiteDetectorResponse_593986;
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
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(path_593999, "resourceGroupName", newJString(resourceGroupName))
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "siteName", newJString(siteName))
  add(path_593999, "subscriptionId", newJString(subscriptionId))
  add(query_594000, "endTime", newJString(endTime))
  add(query_594000, "timeGrain", newJString(timeGrain))
  add(path_593999, "detectorName", newJString(detectorName))
  add(query_594000, "startTime", newJString(startTime))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var diagnosticsGetSiteDetectorResponse* = Call_DiagnosticsGetSiteDetectorResponse_593986(
    name: "diagnosticsGetSiteDetectorResponse", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetSiteDetectorResponse_593987, base: "",
    url: url_DiagnosticsGetSiteDetectorResponse_593988, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDiagnosticCategories_594001 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsListSiteDiagnosticCategories_594003(protocol: Scheme;
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

proc validate_DiagnosticsListSiteDiagnosticCategories_594002(path: JsonNode;
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
  var valid_594004 = path.getOrDefault("resourceGroupName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "resourceGroupName", valid_594004
  var valid_594005 = path.getOrDefault("siteName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "siteName", valid_594005
  var valid_594006 = path.getOrDefault("subscriptionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "subscriptionId", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594008: Call_DiagnosticsListSiteDiagnosticCategories_594001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Diagnostics Categories
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_DiagnosticsListSiteDiagnosticCategories_594001;
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
  var path_594010 = newJObject()
  var query_594011 = newJObject()
  add(path_594010, "resourceGroupName", newJString(resourceGroupName))
  add(query_594011, "api-version", newJString(apiVersion))
  add(path_594010, "siteName", newJString(siteName))
  add(path_594010, "subscriptionId", newJString(subscriptionId))
  result = call_594009.call(path_594010, query_594011, nil, nil, nil)

var diagnosticsListSiteDiagnosticCategories* = Call_DiagnosticsListSiteDiagnosticCategories_594001(
    name: "diagnosticsListSiteDiagnosticCategories", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics",
    validator: validate_DiagnosticsListSiteDiagnosticCategories_594002, base: "",
    url: url_DiagnosticsListSiteDiagnosticCategories_594003,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDiagnosticCategory_594012 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsGetSiteDiagnosticCategory_594014(protocol: Scheme;
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

proc validate_DiagnosticsGetSiteDiagnosticCategory_594013(path: JsonNode;
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
  var valid_594015 = path.getOrDefault("resourceGroupName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "resourceGroupName", valid_594015
  var valid_594016 = path.getOrDefault("siteName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "siteName", valid_594016
  var valid_594017 = path.getOrDefault("diagnosticCategory")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "diagnosticCategory", valid_594017
  var valid_594018 = path.getOrDefault("subscriptionId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "subscriptionId", valid_594018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594019 = query.getOrDefault("api-version")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "api-version", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_DiagnosticsGetSiteDiagnosticCategory_594012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Diagnostics Category
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_DiagnosticsGetSiteDiagnosticCategory_594012;
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
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  add(path_594022, "resourceGroupName", newJString(resourceGroupName))
  add(query_594023, "api-version", newJString(apiVersion))
  add(path_594022, "siteName", newJString(siteName))
  add(path_594022, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594022, "subscriptionId", newJString(subscriptionId))
  result = call_594021.call(path_594022, query_594023, nil, nil, nil)

var diagnosticsGetSiteDiagnosticCategory* = Call_DiagnosticsGetSiteDiagnosticCategory_594012(
    name: "diagnosticsGetSiteDiagnosticCategory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}",
    validator: validate_DiagnosticsGetSiteDiagnosticCategory_594013, base: "",
    url: url_DiagnosticsGetSiteDiagnosticCategory_594014, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteAnalyses_594024 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsListSiteAnalyses_594026(protocol: Scheme; host: string;
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

proc validate_DiagnosticsListSiteAnalyses_594025(path: JsonNode; query: JsonNode;
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
  var valid_594027 = path.getOrDefault("resourceGroupName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "resourceGroupName", valid_594027
  var valid_594028 = path.getOrDefault("siteName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "siteName", valid_594028
  var valid_594029 = path.getOrDefault("diagnosticCategory")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "diagnosticCategory", valid_594029
  var valid_594030 = path.getOrDefault("subscriptionId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "subscriptionId", valid_594030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594031 = query.getOrDefault("api-version")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "api-version", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_DiagnosticsListSiteAnalyses_594024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Site Analyses
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_DiagnosticsListSiteAnalyses_594024;
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
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(path_594034, "resourceGroupName", newJString(resourceGroupName))
  add(query_594035, "api-version", newJString(apiVersion))
  add(path_594034, "siteName", newJString(siteName))
  add(path_594034, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594034, "subscriptionId", newJString(subscriptionId))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var diagnosticsListSiteAnalyses* = Call_DiagnosticsListSiteAnalyses_594024(
    name: "diagnosticsListSiteAnalyses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/analyses",
    validator: validate_DiagnosticsListSiteAnalyses_594025, base: "",
    url: url_DiagnosticsListSiteAnalyses_594026, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteAnalysis_594036 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsGetSiteAnalysis_594038(protocol: Scheme; host: string;
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

proc validate_DiagnosticsGetSiteAnalysis_594037(path: JsonNode; query: JsonNode;
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
  var valid_594039 = path.getOrDefault("resourceGroupName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceGroupName", valid_594039
  var valid_594040 = path.getOrDefault("siteName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "siteName", valid_594040
  var valid_594041 = path.getOrDefault("diagnosticCategory")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "diagnosticCategory", valid_594041
  var valid_594042 = path.getOrDefault("subscriptionId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "subscriptionId", valid_594042
  var valid_594043 = path.getOrDefault("analysisName")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "analysisName", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
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

proc call*(call_594045: Call_DiagnosticsGetSiteAnalysis_594036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Site Analysis
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_DiagnosticsGetSiteAnalysis_594036;
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
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(path_594047, "resourceGroupName", newJString(resourceGroupName))
  add(query_594048, "api-version", newJString(apiVersion))
  add(path_594047, "siteName", newJString(siteName))
  add(path_594047, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594047, "subscriptionId", newJString(subscriptionId))
  add(path_594047, "analysisName", newJString(analysisName))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var diagnosticsGetSiteAnalysis* = Call_DiagnosticsGetSiteAnalysis_594036(
    name: "diagnosticsGetSiteAnalysis", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/analyses/{analysisName}",
    validator: validate_DiagnosticsGetSiteAnalysis_594037, base: "",
    url: url_DiagnosticsGetSiteAnalysis_594038, schemes: {Scheme.Https})
type
  Call_DiagnosticsExecuteSiteAnalysis_594049 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsExecuteSiteAnalysis_594051(protocol: Scheme; host: string;
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

proc validate_DiagnosticsExecuteSiteAnalysis_594050(path: JsonNode;
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
  var valid_594052 = path.getOrDefault("resourceGroupName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "resourceGroupName", valid_594052
  var valid_594053 = path.getOrDefault("siteName")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "siteName", valid_594053
  var valid_594054 = path.getOrDefault("diagnosticCategory")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "diagnosticCategory", valid_594054
  var valid_594055 = path.getOrDefault("subscriptionId")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "subscriptionId", valid_594055
  var valid_594056 = path.getOrDefault("analysisName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "analysisName", valid_594056
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
  var valid_594057 = query.getOrDefault("api-version")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "api-version", valid_594057
  var valid_594058 = query.getOrDefault("endTime")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "endTime", valid_594058
  var valid_594059 = query.getOrDefault("timeGrain")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "timeGrain", valid_594059
  var valid_594060 = query.getOrDefault("startTime")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "startTime", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_DiagnosticsExecuteSiteAnalysis_594049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute Analysis
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_DiagnosticsExecuteSiteAnalysis_594049;
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
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(path_594063, "resourceGroupName", newJString(resourceGroupName))
  add(query_594064, "api-version", newJString(apiVersion))
  add(path_594063, "siteName", newJString(siteName))
  add(path_594063, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594063, "subscriptionId", newJString(subscriptionId))
  add(query_594064, "endTime", newJString(endTime))
  add(query_594064, "timeGrain", newJString(timeGrain))
  add(path_594063, "analysisName", newJString(analysisName))
  add(query_594064, "startTime", newJString(startTime))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var diagnosticsExecuteSiteAnalysis* = Call_DiagnosticsExecuteSiteAnalysis_594049(
    name: "diagnosticsExecuteSiteAnalysis", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/analyses/{analysisName}/execute",
    validator: validate_DiagnosticsExecuteSiteAnalysis_594050, base: "",
    url: url_DiagnosticsExecuteSiteAnalysis_594051, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDetectors_594065 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsListSiteDetectors_594067(protocol: Scheme; host: string;
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

proc validate_DiagnosticsListSiteDetectors_594066(path: JsonNode; query: JsonNode;
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
  var valid_594068 = path.getOrDefault("resourceGroupName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "resourceGroupName", valid_594068
  var valid_594069 = path.getOrDefault("siteName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "siteName", valid_594069
  var valid_594070 = path.getOrDefault("diagnosticCategory")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "diagnosticCategory", valid_594070
  var valid_594071 = path.getOrDefault("subscriptionId")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "subscriptionId", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "api-version", valid_594072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_DiagnosticsListSiteDetectors_594065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Detectors
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_DiagnosticsListSiteDetectors_594065;
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
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "siteName", newJString(siteName))
  add(path_594075, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  result = call_594074.call(path_594075, query_594076, nil, nil, nil)

var diagnosticsListSiteDetectors* = Call_DiagnosticsListSiteDetectors_594065(
    name: "diagnosticsListSiteDetectors", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/detectors",
    validator: validate_DiagnosticsListSiteDetectors_594066, base: "",
    url: url_DiagnosticsListSiteDetectors_594067, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDetector_594077 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsGetSiteDetector_594079(protocol: Scheme; host: string;
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

proc validate_DiagnosticsGetSiteDetector_594078(path: JsonNode; query: JsonNode;
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
  var valid_594080 = path.getOrDefault("resourceGroupName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "resourceGroupName", valid_594080
  var valid_594081 = path.getOrDefault("siteName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "siteName", valid_594081
  var valid_594082 = path.getOrDefault("diagnosticCategory")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "diagnosticCategory", valid_594082
  var valid_594083 = path.getOrDefault("subscriptionId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "subscriptionId", valid_594083
  var valid_594084 = path.getOrDefault("detectorName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "detectorName", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "api-version", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_DiagnosticsGetSiteDetector_594077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Detector
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_DiagnosticsGetSiteDetector_594077;
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
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(path_594088, "resourceGroupName", newJString(resourceGroupName))
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "siteName", newJString(siteName))
  add(path_594088, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594088, "subscriptionId", newJString(subscriptionId))
  add(path_594088, "detectorName", newJString(detectorName))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var diagnosticsGetSiteDetector* = Call_DiagnosticsGetSiteDetector_594077(
    name: "diagnosticsGetSiteDetector", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetSiteDetector_594078, base: "",
    url: url_DiagnosticsGetSiteDetector_594079, schemes: {Scheme.Https})
type
  Call_DiagnosticsExecuteSiteDetector_594090 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsExecuteSiteDetector_594092(protocol: Scheme; host: string;
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

proc validate_DiagnosticsExecuteSiteDetector_594091(path: JsonNode;
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
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("siteName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "siteName", valid_594094
  var valid_594095 = path.getOrDefault("diagnosticCategory")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "diagnosticCategory", valid_594095
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  var valid_594097 = path.getOrDefault("detectorName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "detectorName", valid_594097
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
  var valid_594098 = query.getOrDefault("api-version")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "api-version", valid_594098
  var valid_594099 = query.getOrDefault("endTime")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "endTime", valid_594099
  var valid_594100 = query.getOrDefault("timeGrain")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "timeGrain", valid_594100
  var valid_594101 = query.getOrDefault("startTime")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "startTime", valid_594101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_DiagnosticsExecuteSiteDetector_594090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute Detector
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_DiagnosticsExecuteSiteDetector_594090;
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
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  add(path_594104, "resourceGroupName", newJString(resourceGroupName))
  add(query_594105, "api-version", newJString(apiVersion))
  add(path_594104, "siteName", newJString(siteName))
  add(path_594104, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594104, "subscriptionId", newJString(subscriptionId))
  add(query_594105, "endTime", newJString(endTime))
  add(query_594105, "timeGrain", newJString(timeGrain))
  add(path_594104, "detectorName", newJString(detectorName))
  add(query_594105, "startTime", newJString(startTime))
  result = call_594103.call(path_594104, query_594105, nil, nil, nil)

var diagnosticsExecuteSiteDetector* = Call_DiagnosticsExecuteSiteDetector_594090(
    name: "diagnosticsExecuteSiteDetector", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/diagnostics/{diagnosticCategory}/detectors/{detectorName}/execute",
    validator: validate_DiagnosticsExecuteSiteDetector_594091, base: "",
    url: url_DiagnosticsExecuteSiteDetector_594092, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDetectorResponsesSlot_594106 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsListSiteDetectorResponsesSlot_594108(protocol: Scheme;
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

proc validate_DiagnosticsListSiteDetectorResponsesSlot_594107(path: JsonNode;
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
  var valid_594109 = path.getOrDefault("resourceGroupName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "resourceGroupName", valid_594109
  var valid_594110 = path.getOrDefault("siteName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "siteName", valid_594110
  var valid_594111 = path.getOrDefault("slot")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "slot", valid_594111
  var valid_594112 = path.getOrDefault("subscriptionId")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "subscriptionId", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
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

proc call*(call_594114: Call_DiagnosticsListSiteDetectorResponsesSlot_594106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Site Detector Responses
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_DiagnosticsListSiteDetectorResponsesSlot_594106;
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
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  add(path_594116, "resourceGroupName", newJString(resourceGroupName))
  add(query_594117, "api-version", newJString(apiVersion))
  add(path_594116, "siteName", newJString(siteName))
  add(path_594116, "slot", newJString(slot))
  add(path_594116, "subscriptionId", newJString(subscriptionId))
  result = call_594115.call(path_594116, query_594117, nil, nil, nil)

var diagnosticsListSiteDetectorResponsesSlot* = Call_DiagnosticsListSiteDetectorResponsesSlot_594106(
    name: "diagnosticsListSiteDetectorResponsesSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/detectors",
    validator: validate_DiagnosticsListSiteDetectorResponsesSlot_594107, base: "",
    url: url_DiagnosticsListSiteDetectorResponsesSlot_594108,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDetectorResponseSlot_594118 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsGetSiteDetectorResponseSlot_594120(protocol: Scheme;
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

proc validate_DiagnosticsGetSiteDetectorResponseSlot_594119(path: JsonNode;
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
  var valid_594121 = path.getOrDefault("resourceGroupName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "resourceGroupName", valid_594121
  var valid_594122 = path.getOrDefault("siteName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "siteName", valid_594122
  var valid_594123 = path.getOrDefault("slot")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "slot", valid_594123
  var valid_594124 = path.getOrDefault("subscriptionId")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "subscriptionId", valid_594124
  var valid_594125 = path.getOrDefault("detectorName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "detectorName", valid_594125
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
  var valid_594126 = query.getOrDefault("api-version")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "api-version", valid_594126
  var valid_594127 = query.getOrDefault("endTime")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "endTime", valid_594127
  var valid_594128 = query.getOrDefault("timeGrain")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "timeGrain", valid_594128
  var valid_594129 = query.getOrDefault("startTime")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "startTime", valid_594129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594130: Call_DiagnosticsGetSiteDetectorResponseSlot_594118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get site detector response
  ## 
  let valid = call_594130.validator(path, query, header, formData, body)
  let scheme = call_594130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594130.url(scheme.get, call_594130.host, call_594130.base,
                         call_594130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594130, url, valid)

proc call*(call_594131: Call_DiagnosticsGetSiteDetectorResponseSlot_594118;
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
  var path_594132 = newJObject()
  var query_594133 = newJObject()
  add(path_594132, "resourceGroupName", newJString(resourceGroupName))
  add(query_594133, "api-version", newJString(apiVersion))
  add(path_594132, "siteName", newJString(siteName))
  add(path_594132, "slot", newJString(slot))
  add(path_594132, "subscriptionId", newJString(subscriptionId))
  add(query_594133, "endTime", newJString(endTime))
  add(query_594133, "timeGrain", newJString(timeGrain))
  add(path_594132, "detectorName", newJString(detectorName))
  add(query_594133, "startTime", newJString(startTime))
  result = call_594131.call(path_594132, query_594133, nil, nil, nil)

var diagnosticsGetSiteDetectorResponseSlot* = Call_DiagnosticsGetSiteDetectorResponseSlot_594118(
    name: "diagnosticsGetSiteDetectorResponseSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetSiteDetectorResponseSlot_594119, base: "",
    url: url_DiagnosticsGetSiteDetectorResponseSlot_594120,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDiagnosticCategoriesSlot_594134 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsListSiteDiagnosticCategoriesSlot_594136(protocol: Scheme;
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

proc validate_DiagnosticsListSiteDiagnosticCategoriesSlot_594135(path: JsonNode;
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
  var valid_594137 = path.getOrDefault("resourceGroupName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "resourceGroupName", valid_594137
  var valid_594138 = path.getOrDefault("siteName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "siteName", valid_594138
  var valid_594139 = path.getOrDefault("slot")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "slot", valid_594139
  var valid_594140 = path.getOrDefault("subscriptionId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "subscriptionId", valid_594140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594141 = query.getOrDefault("api-version")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "api-version", valid_594141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594142: Call_DiagnosticsListSiteDiagnosticCategoriesSlot_594134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Diagnostics Categories
  ## 
  let valid = call_594142.validator(path, query, header, formData, body)
  let scheme = call_594142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594142.url(scheme.get, call_594142.host, call_594142.base,
                         call_594142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594142, url, valid)

proc call*(call_594143: Call_DiagnosticsListSiteDiagnosticCategoriesSlot_594134;
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
  var path_594144 = newJObject()
  var query_594145 = newJObject()
  add(path_594144, "resourceGroupName", newJString(resourceGroupName))
  add(query_594145, "api-version", newJString(apiVersion))
  add(path_594144, "siteName", newJString(siteName))
  add(path_594144, "slot", newJString(slot))
  add(path_594144, "subscriptionId", newJString(subscriptionId))
  result = call_594143.call(path_594144, query_594145, nil, nil, nil)

var diagnosticsListSiteDiagnosticCategoriesSlot* = Call_DiagnosticsListSiteDiagnosticCategoriesSlot_594134(
    name: "diagnosticsListSiteDiagnosticCategoriesSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics",
    validator: validate_DiagnosticsListSiteDiagnosticCategoriesSlot_594135,
    base: "", url: url_DiagnosticsListSiteDiagnosticCategoriesSlot_594136,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDiagnosticCategorySlot_594146 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsGetSiteDiagnosticCategorySlot_594148(protocol: Scheme;
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

proc validate_DiagnosticsGetSiteDiagnosticCategorySlot_594147(path: JsonNode;
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
  var valid_594149 = path.getOrDefault("resourceGroupName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "resourceGroupName", valid_594149
  var valid_594150 = path.getOrDefault("siteName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "siteName", valid_594150
  var valid_594151 = path.getOrDefault("slot")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "slot", valid_594151
  var valid_594152 = path.getOrDefault("diagnosticCategory")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "diagnosticCategory", valid_594152
  var valid_594153 = path.getOrDefault("subscriptionId")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "subscriptionId", valid_594153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594154 = query.getOrDefault("api-version")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "api-version", valid_594154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594155: Call_DiagnosticsGetSiteDiagnosticCategorySlot_594146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Diagnostics Category
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_DiagnosticsGetSiteDiagnosticCategorySlot_594146;
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
  var path_594157 = newJObject()
  var query_594158 = newJObject()
  add(path_594157, "resourceGroupName", newJString(resourceGroupName))
  add(query_594158, "api-version", newJString(apiVersion))
  add(path_594157, "siteName", newJString(siteName))
  add(path_594157, "slot", newJString(slot))
  add(path_594157, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594157, "subscriptionId", newJString(subscriptionId))
  result = call_594156.call(path_594157, query_594158, nil, nil, nil)

var diagnosticsGetSiteDiagnosticCategorySlot* = Call_DiagnosticsGetSiteDiagnosticCategorySlot_594146(
    name: "diagnosticsGetSiteDiagnosticCategorySlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}",
    validator: validate_DiagnosticsGetSiteDiagnosticCategorySlot_594147, base: "",
    url: url_DiagnosticsGetSiteDiagnosticCategorySlot_594148,
    schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteAnalysesSlot_594159 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsListSiteAnalysesSlot_594161(protocol: Scheme; host: string;
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

proc validate_DiagnosticsListSiteAnalysesSlot_594160(path: JsonNode;
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
  var valid_594162 = path.getOrDefault("resourceGroupName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "resourceGroupName", valid_594162
  var valid_594163 = path.getOrDefault("siteName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "siteName", valid_594163
  var valid_594164 = path.getOrDefault("slot")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "slot", valid_594164
  var valid_594165 = path.getOrDefault("diagnosticCategory")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "diagnosticCategory", valid_594165
  var valid_594166 = path.getOrDefault("subscriptionId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "subscriptionId", valid_594166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594167 = query.getOrDefault("api-version")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "api-version", valid_594167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594168: Call_DiagnosticsListSiteAnalysesSlot_594159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Site Analyses
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_DiagnosticsListSiteAnalysesSlot_594159;
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
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  add(path_594170, "resourceGroupName", newJString(resourceGroupName))
  add(query_594171, "api-version", newJString(apiVersion))
  add(path_594170, "siteName", newJString(siteName))
  add(path_594170, "slot", newJString(slot))
  add(path_594170, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594170, "subscriptionId", newJString(subscriptionId))
  result = call_594169.call(path_594170, query_594171, nil, nil, nil)

var diagnosticsListSiteAnalysesSlot* = Call_DiagnosticsListSiteAnalysesSlot_594159(
    name: "diagnosticsListSiteAnalysesSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/analyses",
    validator: validate_DiagnosticsListSiteAnalysesSlot_594160, base: "",
    url: url_DiagnosticsListSiteAnalysesSlot_594161, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteAnalysisSlot_594172 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsGetSiteAnalysisSlot_594174(protocol: Scheme; host: string;
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

proc validate_DiagnosticsGetSiteAnalysisSlot_594173(path: JsonNode;
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
  var valid_594175 = path.getOrDefault("resourceGroupName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "resourceGroupName", valid_594175
  var valid_594176 = path.getOrDefault("siteName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "siteName", valid_594176
  var valid_594177 = path.getOrDefault("slot")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "slot", valid_594177
  var valid_594178 = path.getOrDefault("diagnosticCategory")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "diagnosticCategory", valid_594178
  var valid_594179 = path.getOrDefault("subscriptionId")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "subscriptionId", valid_594179
  var valid_594180 = path.getOrDefault("analysisName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "analysisName", valid_594180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594181 = query.getOrDefault("api-version")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "api-version", valid_594181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594182: Call_DiagnosticsGetSiteAnalysisSlot_594172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Site Analysis
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_DiagnosticsGetSiteAnalysisSlot_594172;
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
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  add(path_594184, "resourceGroupName", newJString(resourceGroupName))
  add(query_594185, "api-version", newJString(apiVersion))
  add(path_594184, "siteName", newJString(siteName))
  add(path_594184, "slot", newJString(slot))
  add(path_594184, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594184, "subscriptionId", newJString(subscriptionId))
  add(path_594184, "analysisName", newJString(analysisName))
  result = call_594183.call(path_594184, query_594185, nil, nil, nil)

var diagnosticsGetSiteAnalysisSlot* = Call_DiagnosticsGetSiteAnalysisSlot_594172(
    name: "diagnosticsGetSiteAnalysisSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/analyses/{analysisName}",
    validator: validate_DiagnosticsGetSiteAnalysisSlot_594173, base: "",
    url: url_DiagnosticsGetSiteAnalysisSlot_594174, schemes: {Scheme.Https})
type
  Call_DiagnosticsExecuteSiteAnalysisSlot_594186 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsExecuteSiteAnalysisSlot_594188(protocol: Scheme; host: string;
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

proc validate_DiagnosticsExecuteSiteAnalysisSlot_594187(path: JsonNode;
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
  var valid_594189 = path.getOrDefault("resourceGroupName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "resourceGroupName", valid_594189
  var valid_594190 = path.getOrDefault("siteName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "siteName", valid_594190
  var valid_594191 = path.getOrDefault("slot")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "slot", valid_594191
  var valid_594192 = path.getOrDefault("diagnosticCategory")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "diagnosticCategory", valid_594192
  var valid_594193 = path.getOrDefault("subscriptionId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "subscriptionId", valid_594193
  var valid_594194 = path.getOrDefault("analysisName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "analysisName", valid_594194
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
  var valid_594195 = query.getOrDefault("api-version")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "api-version", valid_594195
  var valid_594196 = query.getOrDefault("endTime")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "endTime", valid_594196
  var valid_594197 = query.getOrDefault("timeGrain")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "timeGrain", valid_594197
  var valid_594198 = query.getOrDefault("startTime")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "startTime", valid_594198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594199: Call_DiagnosticsExecuteSiteAnalysisSlot_594186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Execute Analysis
  ## 
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_DiagnosticsExecuteSiteAnalysisSlot_594186;
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
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  add(path_594201, "resourceGroupName", newJString(resourceGroupName))
  add(query_594202, "api-version", newJString(apiVersion))
  add(path_594201, "siteName", newJString(siteName))
  add(path_594201, "slot", newJString(slot))
  add(path_594201, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594201, "subscriptionId", newJString(subscriptionId))
  add(query_594202, "endTime", newJString(endTime))
  add(query_594202, "timeGrain", newJString(timeGrain))
  add(path_594201, "analysisName", newJString(analysisName))
  add(query_594202, "startTime", newJString(startTime))
  result = call_594200.call(path_594201, query_594202, nil, nil, nil)

var diagnosticsExecuteSiteAnalysisSlot* = Call_DiagnosticsExecuteSiteAnalysisSlot_594186(
    name: "diagnosticsExecuteSiteAnalysisSlot", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/analyses/{analysisName}/execute",
    validator: validate_DiagnosticsExecuteSiteAnalysisSlot_594187, base: "",
    url: url_DiagnosticsExecuteSiteAnalysisSlot_594188, schemes: {Scheme.Https})
type
  Call_DiagnosticsListSiteDetectorsSlot_594203 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsListSiteDetectorsSlot_594205(protocol: Scheme; host: string;
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

proc validate_DiagnosticsListSiteDetectorsSlot_594204(path: JsonNode;
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
  var valid_594206 = path.getOrDefault("resourceGroupName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "resourceGroupName", valid_594206
  var valid_594207 = path.getOrDefault("siteName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "siteName", valid_594207
  var valid_594208 = path.getOrDefault("slot")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "slot", valid_594208
  var valid_594209 = path.getOrDefault("diagnosticCategory")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "diagnosticCategory", valid_594209
  var valid_594210 = path.getOrDefault("subscriptionId")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "subscriptionId", valid_594210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594211 = query.getOrDefault("api-version")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "api-version", valid_594211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594212: Call_DiagnosticsListSiteDetectorsSlot_594203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Detectors
  ## 
  let valid = call_594212.validator(path, query, header, formData, body)
  let scheme = call_594212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594212.url(scheme.get, call_594212.host, call_594212.base,
                         call_594212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594212, url, valid)

proc call*(call_594213: Call_DiagnosticsListSiteDetectorsSlot_594203;
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
  var path_594214 = newJObject()
  var query_594215 = newJObject()
  add(path_594214, "resourceGroupName", newJString(resourceGroupName))
  add(query_594215, "api-version", newJString(apiVersion))
  add(path_594214, "siteName", newJString(siteName))
  add(path_594214, "slot", newJString(slot))
  add(path_594214, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594214, "subscriptionId", newJString(subscriptionId))
  result = call_594213.call(path_594214, query_594215, nil, nil, nil)

var diagnosticsListSiteDetectorsSlot* = Call_DiagnosticsListSiteDetectorsSlot_594203(
    name: "diagnosticsListSiteDetectorsSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/detectors",
    validator: validate_DiagnosticsListSiteDetectorsSlot_594204, base: "",
    url: url_DiagnosticsListSiteDetectorsSlot_594205, schemes: {Scheme.Https})
type
  Call_DiagnosticsGetSiteDetectorSlot_594216 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsGetSiteDetectorSlot_594218(protocol: Scheme; host: string;
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

proc validate_DiagnosticsGetSiteDetectorSlot_594217(path: JsonNode;
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
  var valid_594219 = path.getOrDefault("resourceGroupName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "resourceGroupName", valid_594219
  var valid_594220 = path.getOrDefault("siteName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "siteName", valid_594220
  var valid_594221 = path.getOrDefault("slot")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "slot", valid_594221
  var valid_594222 = path.getOrDefault("diagnosticCategory")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "diagnosticCategory", valid_594222
  var valid_594223 = path.getOrDefault("subscriptionId")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "subscriptionId", valid_594223
  var valid_594224 = path.getOrDefault("detectorName")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "detectorName", valid_594224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594225 = query.getOrDefault("api-version")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "api-version", valid_594225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594226: Call_DiagnosticsGetSiteDetectorSlot_594216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Detector
  ## 
  let valid = call_594226.validator(path, query, header, formData, body)
  let scheme = call_594226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594226.url(scheme.get, call_594226.host, call_594226.base,
                         call_594226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594226, url, valid)

proc call*(call_594227: Call_DiagnosticsGetSiteDetectorSlot_594216;
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
  var path_594228 = newJObject()
  var query_594229 = newJObject()
  add(path_594228, "resourceGroupName", newJString(resourceGroupName))
  add(query_594229, "api-version", newJString(apiVersion))
  add(path_594228, "siteName", newJString(siteName))
  add(path_594228, "slot", newJString(slot))
  add(path_594228, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594228, "subscriptionId", newJString(subscriptionId))
  add(path_594228, "detectorName", newJString(detectorName))
  result = call_594227.call(path_594228, query_594229, nil, nil, nil)

var diagnosticsGetSiteDetectorSlot* = Call_DiagnosticsGetSiteDetectorSlot_594216(
    name: "diagnosticsGetSiteDetectorSlot", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/detectors/{detectorName}",
    validator: validate_DiagnosticsGetSiteDetectorSlot_594217, base: "",
    url: url_DiagnosticsGetSiteDetectorSlot_594218, schemes: {Scheme.Https})
type
  Call_DiagnosticsExecuteSiteDetectorSlot_594230 = ref object of OpenApiRestCall_593424
proc url_DiagnosticsExecuteSiteDetectorSlot_594232(protocol: Scheme; host: string;
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

proc validate_DiagnosticsExecuteSiteDetectorSlot_594231(path: JsonNode;
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
  var valid_594233 = path.getOrDefault("resourceGroupName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "resourceGroupName", valid_594233
  var valid_594234 = path.getOrDefault("siteName")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "siteName", valid_594234
  var valid_594235 = path.getOrDefault("slot")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "slot", valid_594235
  var valid_594236 = path.getOrDefault("diagnosticCategory")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "diagnosticCategory", valid_594236
  var valid_594237 = path.getOrDefault("subscriptionId")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "subscriptionId", valid_594237
  var valid_594238 = path.getOrDefault("detectorName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "detectorName", valid_594238
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
  var valid_594239 = query.getOrDefault("api-version")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "api-version", valid_594239
  var valid_594240 = query.getOrDefault("endTime")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "endTime", valid_594240
  var valid_594241 = query.getOrDefault("timeGrain")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "timeGrain", valid_594241
  var valid_594242 = query.getOrDefault("startTime")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "startTime", valid_594242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594243: Call_DiagnosticsExecuteSiteDetectorSlot_594230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Execute Detector
  ## 
  let valid = call_594243.validator(path, query, header, formData, body)
  let scheme = call_594243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594243.url(scheme.get, call_594243.host, call_594243.base,
                         call_594243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594243, url, valid)

proc call*(call_594244: Call_DiagnosticsExecuteSiteDetectorSlot_594230;
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
  var path_594245 = newJObject()
  var query_594246 = newJObject()
  add(path_594245, "resourceGroupName", newJString(resourceGroupName))
  add(query_594246, "api-version", newJString(apiVersion))
  add(path_594245, "siteName", newJString(siteName))
  add(path_594245, "slot", newJString(slot))
  add(path_594245, "diagnosticCategory", newJString(diagnosticCategory))
  add(path_594245, "subscriptionId", newJString(subscriptionId))
  add(query_594246, "endTime", newJString(endTime))
  add(query_594246, "timeGrain", newJString(timeGrain))
  add(path_594245, "detectorName", newJString(detectorName))
  add(query_594246, "startTime", newJString(startTime))
  result = call_594244.call(path_594245, query_594246, nil, nil, nil)

var diagnosticsExecuteSiteDetectorSlot* = Call_DiagnosticsExecuteSiteDetectorSlot_594230(
    name: "diagnosticsExecuteSiteDetectorSlot", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slot}/diagnostics/{diagnosticCategory}/detectors/{detectorName}/execute",
    validator: validate_DiagnosticsExecuteSiteDetectorSlot_594231, base: "",
    url: url_DiagnosticsExecuteSiteDetectorSlot_594232, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
