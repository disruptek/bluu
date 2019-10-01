
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: StorageManagementClient
## version: 2015-12-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Storage Management Client.
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

  OpenApiRestCall_574459 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574459](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574459): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-shares"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SharesList_574681 = ref object of OpenApiRestCall_574459
proc url_SharesList_574683(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/shares")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesList_574682(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of storage shares.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574843 = path.getOrDefault("resourceGroupName")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "resourceGroupName", valid_574843
  var valid_574844 = path.getOrDefault("farmId")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "farmId", valid_574844
  var valid_574845 = path.getOrDefault("subscriptionId")
  valid_574845 = validateParameter(valid_574845, JString, required = true,
                                 default = nil)
  if valid_574845 != nil:
    section.add "subscriptionId", valid_574845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574846 = query.getOrDefault("api-version")
  valid_574846 = validateParameter(valid_574846, JString, required = true,
                                 default = nil)
  if valid_574846 != nil:
    section.add "api-version", valid_574846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574873: Call_SharesList_574681; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of storage shares.
  ## 
  let valid = call_574873.validator(path, query, header, formData, body)
  let scheme = call_574873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574873.url(scheme.get, call_574873.host, call_574873.base,
                         call_574873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574873, url, valid)

proc call*(call_574944: Call_SharesList_574681; resourceGroupName: string;
          apiVersion: string; farmId: string; subscriptionId: string): Recallable =
  ## sharesList
  ## Returns a list of storage shares.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  var path_574945 = newJObject()
  var query_574947 = newJObject()
  add(path_574945, "resourceGroupName", newJString(resourceGroupName))
  add(query_574947, "api-version", newJString(apiVersion))
  add(path_574945, "farmId", newJString(farmId))
  add(path_574945, "subscriptionId", newJString(subscriptionId))
  result = call_574944.call(path_574945, query_574947, nil, nil, nil)

var sharesList* = Call_SharesList_574681(name: "sharesList",
                                      meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/shares",
                                      validator: validate_SharesList_574682,
                                      base: "", url: url_SharesList_574683,
                                      schemes: {Scheme.Https})
type
  Call_SharesGet_574986 = ref object of OpenApiRestCall_574459
proc url_SharesGet_574988(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesGet_574987(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a storage share.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   shareName: JString (required)
  ##            : Share name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574989 = path.getOrDefault("resourceGroupName")
  valid_574989 = validateParameter(valid_574989, JString, required = true,
                                 default = nil)
  if valid_574989 != nil:
    section.add "resourceGroupName", valid_574989
  var valid_574990 = path.getOrDefault("farmId")
  valid_574990 = validateParameter(valid_574990, JString, required = true,
                                 default = nil)
  if valid_574990 != nil:
    section.add "farmId", valid_574990
  var valid_574991 = path.getOrDefault("subscriptionId")
  valid_574991 = validateParameter(valid_574991, JString, required = true,
                                 default = nil)
  if valid_574991 != nil:
    section.add "subscriptionId", valid_574991
  var valid_574992 = path.getOrDefault("shareName")
  valid_574992 = validateParameter(valid_574992, JString, required = true,
                                 default = nil)
  if valid_574992 != nil:
    section.add "shareName", valid_574992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574993 = query.getOrDefault("api-version")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "api-version", valid_574993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574994: Call_SharesGet_574986; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a storage share.
  ## 
  let valid = call_574994.validator(path, query, header, formData, body)
  let scheme = call_574994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574994.url(scheme.get, call_574994.host, call_574994.base,
                         call_574994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574994, url, valid)

proc call*(call_574995: Call_SharesGet_574986; resourceGroupName: string;
          apiVersion: string; farmId: string; subscriptionId: string;
          shareName: string): Recallable =
  ## sharesGet
  ## Returns a storage share.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   shareName: string (required)
  ##            : Share name.
  var path_574996 = newJObject()
  var query_574997 = newJObject()
  add(path_574996, "resourceGroupName", newJString(resourceGroupName))
  add(query_574997, "api-version", newJString(apiVersion))
  add(path_574996, "farmId", newJString(farmId))
  add(path_574996, "subscriptionId", newJString(subscriptionId))
  add(path_574996, "shareName", newJString(shareName))
  result = call_574995.call(path_574996, query_574997, nil, nil, nil)

var sharesGet* = Call_SharesGet_574986(name: "sharesGet", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/shares/{shareName}",
                                    validator: validate_SharesGet_574987,
                                    base: "", url: url_SharesGet_574988,
                                    schemes: {Scheme.Https})
type
  Call_SharesListMetricDefinitions_574998 = ref object of OpenApiRestCall_574459
proc url_SharesListMetricDefinitions_575000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesListMetricDefinitions_574999(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of metric definitions for a storage share.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   shareName: JString (required)
  ##            : Share name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575001 = path.getOrDefault("resourceGroupName")
  valid_575001 = validateParameter(valid_575001, JString, required = true,
                                 default = nil)
  if valid_575001 != nil:
    section.add "resourceGroupName", valid_575001
  var valid_575002 = path.getOrDefault("farmId")
  valid_575002 = validateParameter(valid_575002, JString, required = true,
                                 default = nil)
  if valid_575002 != nil:
    section.add "farmId", valid_575002
  var valid_575003 = path.getOrDefault("subscriptionId")
  valid_575003 = validateParameter(valid_575003, JString, required = true,
                                 default = nil)
  if valid_575003 != nil:
    section.add "subscriptionId", valid_575003
  var valid_575004 = path.getOrDefault("shareName")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "shareName", valid_575004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575005 = query.getOrDefault("api-version")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "api-version", valid_575005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575006: Call_SharesListMetricDefinitions_574998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of metric definitions for a storage share.
  ## 
  let valid = call_575006.validator(path, query, header, formData, body)
  let scheme = call_575006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575006.url(scheme.get, call_575006.host, call_575006.base,
                         call_575006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575006, url, valid)

proc call*(call_575007: Call_SharesListMetricDefinitions_574998;
          resourceGroupName: string; apiVersion: string; farmId: string;
          subscriptionId: string; shareName: string): Recallable =
  ## sharesListMetricDefinitions
  ## Returns a list of metric definitions for a storage share.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   shareName: string (required)
  ##            : Share name.
  var path_575008 = newJObject()
  var query_575009 = newJObject()
  add(path_575008, "resourceGroupName", newJString(resourceGroupName))
  add(query_575009, "api-version", newJString(apiVersion))
  add(path_575008, "farmId", newJString(farmId))
  add(path_575008, "subscriptionId", newJString(subscriptionId))
  add(path_575008, "shareName", newJString(shareName))
  result = call_575007.call(path_575008, query_575009, nil, nil, nil)

var sharesListMetricDefinitions* = Call_SharesListMetricDefinitions_574998(
    name: "sharesListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/shares/{shareName}/metricdefinitions",
    validator: validate_SharesListMetricDefinitions_574999, base: "",
    url: url_SharesListMetricDefinitions_575000, schemes: {Scheme.Https})
type
  Call_SharesListMetrics_575010 = ref object of OpenApiRestCall_574459
proc url_SharesListMetrics_575012(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SharesListMetrics_575011(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a list of metrics for a storage share.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   farmId: JString (required)
  ##         : Farm Id.
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  ##   shareName: JString (required)
  ##            : Share name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575013 = path.getOrDefault("resourceGroupName")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "resourceGroupName", valid_575013
  var valid_575014 = path.getOrDefault("farmId")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "farmId", valid_575014
  var valid_575015 = path.getOrDefault("subscriptionId")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = nil)
  if valid_575015 != nil:
    section.add "subscriptionId", valid_575015
  var valid_575016 = path.getOrDefault("shareName")
  valid_575016 = validateParameter(valid_575016, JString, required = true,
                                 default = nil)
  if valid_575016 != nil:
    section.add "shareName", valid_575016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575017 = query.getOrDefault("api-version")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "api-version", valid_575017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575018: Call_SharesListMetrics_575010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of metrics for a storage share.
  ## 
  let valid = call_575018.validator(path, query, header, formData, body)
  let scheme = call_575018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575018.url(scheme.get, call_575018.host, call_575018.base,
                         call_575018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575018, url, valid)

proc call*(call_575019: Call_SharesListMetrics_575010; resourceGroupName: string;
          apiVersion: string; farmId: string; subscriptionId: string;
          shareName: string): Recallable =
  ## sharesListMetrics
  ## Returns a list of metrics for a storage share.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   shareName: string (required)
  ##            : Share name.
  var path_575020 = newJObject()
  var query_575021 = newJObject()
  add(path_575020, "resourceGroupName", newJString(resourceGroupName))
  add(query_575021, "api-version", newJString(apiVersion))
  add(path_575020, "farmId", newJString(farmId))
  add(path_575020, "subscriptionId", newJString(subscriptionId))
  add(path_575020, "shareName", newJString(shareName))
  result = call_575019.call(path_575020, query_575021, nil, nil, nil)

var sharesListMetrics* = Call_SharesListMetrics_575010(name: "sharesListMetrics",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/shares/{shareName}/metrics",
    validator: validate_SharesListMetrics_575011, base: "",
    url: url_SharesListMetrics_575012, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
