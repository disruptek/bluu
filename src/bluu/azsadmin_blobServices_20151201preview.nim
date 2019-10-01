
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

  OpenApiRestCall_574458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574458): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-blobServices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BlobServicesGet_574680 = ref object of OpenApiRestCall_574458
proc url_BlobServicesGet_574682(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "serviceType" in path, "`serviceType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/blobservices/"),
               (kind: VariableSegment, value: "serviceType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobServicesGet_574681(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns the BLOB service.
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
  ##   serviceType: JString (required)
  ##              : The service type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574842 = path.getOrDefault("resourceGroupName")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "resourceGroupName", valid_574842
  var valid_574843 = path.getOrDefault("farmId")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "farmId", valid_574843
  var valid_574844 = path.getOrDefault("subscriptionId")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "subscriptionId", valid_574844
  var valid_574858 = path.getOrDefault("serviceType")
  valid_574858 = validateParameter(valid_574858, JString, required = true,
                                 default = newJString("default"))
  if valid_574858 != nil:
    section.add "serviceType", valid_574858
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574859 = query.getOrDefault("api-version")
  valid_574859 = validateParameter(valid_574859, JString, required = true,
                                 default = nil)
  if valid_574859 != nil:
    section.add "api-version", valid_574859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574886: Call_BlobServicesGet_574680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the BLOB service.
  ## 
  let valid = call_574886.validator(path, query, header, formData, body)
  let scheme = call_574886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574886.url(scheme.get, call_574886.host, call_574886.base,
                         call_574886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574886, url, valid)

proc call*(call_574957: Call_BlobServicesGet_574680; resourceGroupName: string;
          apiVersion: string; farmId: string; subscriptionId: string;
          serviceType: string = "default"): Recallable =
  ## blobServicesGet
  ## Returns the BLOB service.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   serviceType: string (required)
  ##              : The service type.
  var path_574958 = newJObject()
  var query_574960 = newJObject()
  add(path_574958, "resourceGroupName", newJString(resourceGroupName))
  add(query_574960, "api-version", newJString(apiVersion))
  add(path_574958, "farmId", newJString(farmId))
  add(path_574958, "subscriptionId", newJString(subscriptionId))
  add(path_574958, "serviceType", newJString(serviceType))
  result = call_574957.call(path_574958, query_574960, nil, nil, nil)

var blobServicesGet* = Call_BlobServicesGet_574680(name: "blobServicesGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/blobservices/{serviceType}",
    validator: validate_BlobServicesGet_574681, base: "", url: url_BlobServicesGet_574682,
    schemes: {Scheme.Https})
type
  Call_BlobServicesListMetricDefinitions_574999 = ref object of OpenApiRestCall_574458
proc url_BlobServicesListMetricDefinitions_575001(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "serviceType" in path, "`serviceType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/blobservices/"),
               (kind: VariableSegment, value: "serviceType"),
               (kind: ConstantSegment, value: "/metricdefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobServicesListMetricDefinitions_575000(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of metric definitions for BLOB service.
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
  ##   serviceType: JString (required)
  ##              : The service type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575002 = path.getOrDefault("resourceGroupName")
  valid_575002 = validateParameter(valid_575002, JString, required = true,
                                 default = nil)
  if valid_575002 != nil:
    section.add "resourceGroupName", valid_575002
  var valid_575003 = path.getOrDefault("farmId")
  valid_575003 = validateParameter(valid_575003, JString, required = true,
                                 default = nil)
  if valid_575003 != nil:
    section.add "farmId", valid_575003
  var valid_575004 = path.getOrDefault("subscriptionId")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "subscriptionId", valid_575004
  var valid_575005 = path.getOrDefault("serviceType")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = newJString("default"))
  if valid_575005 != nil:
    section.add "serviceType", valid_575005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575006 = query.getOrDefault("api-version")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "api-version", valid_575006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575007: Call_BlobServicesListMetricDefinitions_574999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of metric definitions for BLOB service.
  ## 
  let valid = call_575007.validator(path, query, header, formData, body)
  let scheme = call_575007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575007.url(scheme.get, call_575007.host, call_575007.base,
                         call_575007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575007, url, valid)

proc call*(call_575008: Call_BlobServicesListMetricDefinitions_574999;
          resourceGroupName: string; apiVersion: string; farmId: string;
          subscriptionId: string; serviceType: string = "default"): Recallable =
  ## blobServicesListMetricDefinitions
  ## Returns the list of metric definitions for BLOB service.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   serviceType: string (required)
  ##              : The service type.
  var path_575009 = newJObject()
  var query_575010 = newJObject()
  add(path_575009, "resourceGroupName", newJString(resourceGroupName))
  add(query_575010, "api-version", newJString(apiVersion))
  add(path_575009, "farmId", newJString(farmId))
  add(path_575009, "subscriptionId", newJString(subscriptionId))
  add(path_575009, "serviceType", newJString(serviceType))
  result = call_575008.call(path_575009, query_575010, nil, nil, nil)

var blobServicesListMetricDefinitions* = Call_BlobServicesListMetricDefinitions_574999(
    name: "blobServicesListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/blobservices/{serviceType}/metricdefinitions",
    validator: validate_BlobServicesListMetricDefinitions_575000, base: "",
    url: url_BlobServicesListMetricDefinitions_575001, schemes: {Scheme.Https})
type
  Call_BlobServicesListMetrics_575011 = ref object of OpenApiRestCall_574458
proc url_BlobServicesListMetrics_575013(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "farmId" in path, "`farmId` is a required path parameter"
  assert "serviceType" in path, "`serviceType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage.Admin/farms/"),
               (kind: VariableSegment, value: "farmId"),
               (kind: ConstantSegment, value: "/blobservices/"),
               (kind: VariableSegment, value: "serviceType"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobServicesListMetrics_575012(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of metrics for BLOB service.
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
  ##   serviceType: JString (required)
  ##              : The service type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575014 = path.getOrDefault("resourceGroupName")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "resourceGroupName", valid_575014
  var valid_575015 = path.getOrDefault("farmId")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = nil)
  if valid_575015 != nil:
    section.add "farmId", valid_575015
  var valid_575016 = path.getOrDefault("subscriptionId")
  valid_575016 = validateParameter(valid_575016, JString, required = true,
                                 default = nil)
  if valid_575016 != nil:
    section.add "subscriptionId", valid_575016
  var valid_575017 = path.getOrDefault("serviceType")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = newJString("default"))
  if valid_575017 != nil:
    section.add "serviceType", valid_575017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : REST Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575018 = query.getOrDefault("api-version")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "api-version", valid_575018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575019: Call_BlobServicesListMetrics_575011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of metrics for BLOB service.
  ## 
  let valid = call_575019.validator(path, query, header, formData, body)
  let scheme = call_575019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575019.url(scheme.get, call_575019.host, call_575019.base,
                         call_575019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575019, url, valid)

proc call*(call_575020: Call_BlobServicesListMetrics_575011;
          resourceGroupName: string; apiVersion: string; farmId: string;
          subscriptionId: string; serviceType: string = "default"): Recallable =
  ## blobServicesListMetrics
  ## Returns a list of metrics for BLOB service.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : REST Api Version.
  ##   farmId: string (required)
  ##         : Farm Id.
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   serviceType: string (required)
  ##              : The service type.
  var path_575021 = newJObject()
  var query_575022 = newJObject()
  add(path_575021, "resourceGroupName", newJString(resourceGroupName))
  add(query_575022, "api-version", newJString(apiVersion))
  add(path_575021, "farmId", newJString(farmId))
  add(path_575021, "subscriptionId", newJString(subscriptionId))
  add(path_575021, "serviceType", newJString(serviceType))
  result = call_575020.call(path_575021, query_575022, nil, nil, nil)

var blobServicesListMetrics* = Call_BlobServicesListMetrics_575011(
    name: "blobServicesListMetrics", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage.Admin/farms/{farmId}/blobservices/{serviceType}/metrics",
    validator: validate_BlobServicesListMetrics_575012, base: "",
    url: url_BlobServicesListMetrics_575013, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
