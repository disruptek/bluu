
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: portal
## version: 2018-10-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Allows creation and deletion of Azure Shared Dashboards.
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "portal"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_573879 = ref object of OpenApiRestCall_573657
proc url_OperationsList_573881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The Microsoft Portal operations API.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574040 = query.getOrDefault("api-version")
  valid_574040 = validateParameter(valid_574040, JString, required = true,
                                 default = nil)
  if valid_574040 != nil:
    section.add "api-version", valid_574040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574063: Call_OperationsList_573879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Microsoft Portal operations API.
  ## 
  let valid = call_574063.validator(path, query, header, formData, body)
  let scheme = call_574063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574063.url(scheme.get, call_574063.host, call_574063.base,
                         call_574063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574063, url, valid)

proc call*(call_574134: Call_OperationsList_573879; apiVersion: string): Recallable =
  ## operationsList
  ## The Microsoft Portal operations API.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  var query_574135 = newJObject()
  add(query_574135, "api-version", newJString(apiVersion))
  result = call_574134.call(nil, query_574135, nil, nil, nil)

var operationsList* = Call_OperationsList_573879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Portal/operations",
    validator: validate_OperationsList_573880, base: "", url: url_OperationsList_573881,
    schemes: {Scheme.Https})
type
  Call_DashboardsListBySubscription_574175 = ref object of OpenApiRestCall_573657
proc url_DashboardsListBySubscription_574177(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Portal/dashboards")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DashboardsListBySubscription_574176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the dashboards within a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574192 = path.getOrDefault("subscriptionId")
  valid_574192 = validateParameter(valid_574192, JString, required = true,
                                 default = nil)
  if valid_574192 != nil:
    section.add "subscriptionId", valid_574192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574193 = query.getOrDefault("api-version")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "api-version", valid_574193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574194: Call_DashboardsListBySubscription_574175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the dashboards within a subscription.
  ## 
  let valid = call_574194.validator(path, query, header, formData, body)
  let scheme = call_574194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574194.url(scheme.get, call_574194.host, call_574194.base,
                         call_574194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574194, url, valid)

proc call*(call_574195: Call_DashboardsListBySubscription_574175;
          apiVersion: string; subscriptionId: string): Recallable =
  ## dashboardsListBySubscription
  ## Gets all the dashboards within a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  var path_574196 = newJObject()
  var query_574197 = newJObject()
  add(query_574197, "api-version", newJString(apiVersion))
  add(path_574196, "subscriptionId", newJString(subscriptionId))
  result = call_574195.call(path_574196, query_574197, nil, nil, nil)

var dashboardsListBySubscription* = Call_DashboardsListBySubscription_574175(
    name: "dashboardsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Portal/dashboards",
    validator: validate_DashboardsListBySubscription_574176, base: "",
    url: url_DashboardsListBySubscription_574177, schemes: {Scheme.Https})
type
  Call_DashboardsListByResourceGroup_574198 = ref object of OpenApiRestCall_573657
proc url_DashboardsListByResourceGroup_574200(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Portal/dashboards")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DashboardsListByResourceGroup_574199(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the Dashboards within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574201 = path.getOrDefault("resourceGroupName")
  valid_574201 = validateParameter(valid_574201, JString, required = true,
                                 default = nil)
  if valid_574201 != nil:
    section.add "resourceGroupName", valid_574201
  var valid_574202 = path.getOrDefault("subscriptionId")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "subscriptionId", valid_574202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574203 = query.getOrDefault("api-version")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "api-version", valid_574203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574204: Call_DashboardsListByResourceGroup_574198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Dashboards within a resource group.
  ## 
  let valid = call_574204.validator(path, query, header, formData, body)
  let scheme = call_574204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574204.url(scheme.get, call_574204.host, call_574204.base,
                         call_574204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574204, url, valid)

proc call*(call_574205: Call_DashboardsListByResourceGroup_574198;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## dashboardsListByResourceGroup
  ## Gets all the Dashboards within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  var path_574206 = newJObject()
  var query_574207 = newJObject()
  add(path_574206, "resourceGroupName", newJString(resourceGroupName))
  add(query_574207, "api-version", newJString(apiVersion))
  add(path_574206, "subscriptionId", newJString(subscriptionId))
  result = call_574205.call(path_574206, query_574207, nil, nil, nil)

var dashboardsListByResourceGroup* = Call_DashboardsListByResourceGroup_574198(
    name: "dashboardsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Portal/dashboards",
    validator: validate_DashboardsListByResourceGroup_574199, base: "",
    url: url_DashboardsListByResourceGroup_574200, schemes: {Scheme.Https})
type
  Call_DashboardsCreateOrUpdate_574219 = ref object of OpenApiRestCall_573657
proc url_DashboardsCreateOrUpdate_574221(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dashboardName" in path, "`dashboardName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Portal/dashboards/"),
               (kind: VariableSegment, value: "dashboardName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DashboardsCreateOrUpdate_574220(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Dashboard.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   dashboardName: JString (required)
  ##                : The name of the dashboard.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574222 = path.getOrDefault("resourceGroupName")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "resourceGroupName", valid_574222
  var valid_574223 = path.getOrDefault("subscriptionId")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "subscriptionId", valid_574223
  var valid_574224 = path.getOrDefault("dashboardName")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "dashboardName", valid_574224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574225 = query.getOrDefault("api-version")
  valid_574225 = validateParameter(valid_574225, JString, required = true,
                                 default = nil)
  if valid_574225 != nil:
    section.add "api-version", valid_574225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dashboard: JObject (required)
  ##            : The parameters required to create or update a dashboard.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574227: Call_DashboardsCreateOrUpdate_574219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Dashboard.
  ## 
  let valid = call_574227.validator(path, query, header, formData, body)
  let scheme = call_574227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574227.url(scheme.get, call_574227.host, call_574227.base,
                         call_574227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574227, url, valid)

proc call*(call_574228: Call_DashboardsCreateOrUpdate_574219;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          dashboard: JsonNode; dashboardName: string): Recallable =
  ## dashboardsCreateOrUpdate
  ## Creates or updates a Dashboard.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   dashboard: JObject (required)
  ##            : The parameters required to create or update a dashboard.
  ##   dashboardName: string (required)
  ##                : The name of the dashboard.
  var path_574229 = newJObject()
  var query_574230 = newJObject()
  var body_574231 = newJObject()
  add(path_574229, "resourceGroupName", newJString(resourceGroupName))
  add(query_574230, "api-version", newJString(apiVersion))
  add(path_574229, "subscriptionId", newJString(subscriptionId))
  if dashboard != nil:
    body_574231 = dashboard
  add(path_574229, "dashboardName", newJString(dashboardName))
  result = call_574228.call(path_574229, query_574230, nil, nil, body_574231)

var dashboardsCreateOrUpdate* = Call_DashboardsCreateOrUpdate_574219(
    name: "dashboardsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Portal/dashboards/{dashboardName}",
    validator: validate_DashboardsCreateOrUpdate_574220, base: "",
    url: url_DashboardsCreateOrUpdate_574221, schemes: {Scheme.Https})
type
  Call_DashboardsGet_574208 = ref object of OpenApiRestCall_573657
proc url_DashboardsGet_574210(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dashboardName" in path, "`dashboardName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Portal/dashboards/"),
               (kind: VariableSegment, value: "dashboardName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DashboardsGet_574209(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Dashboard.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   dashboardName: JString (required)
  ##                : The name of the dashboard.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574211 = path.getOrDefault("resourceGroupName")
  valid_574211 = validateParameter(valid_574211, JString, required = true,
                                 default = nil)
  if valid_574211 != nil:
    section.add "resourceGroupName", valid_574211
  var valid_574212 = path.getOrDefault("subscriptionId")
  valid_574212 = validateParameter(valid_574212, JString, required = true,
                                 default = nil)
  if valid_574212 != nil:
    section.add "subscriptionId", valid_574212
  var valid_574213 = path.getOrDefault("dashboardName")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "dashboardName", valid_574213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574214 = query.getOrDefault("api-version")
  valid_574214 = validateParameter(valid_574214, JString, required = true,
                                 default = nil)
  if valid_574214 != nil:
    section.add "api-version", valid_574214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574215: Call_DashboardsGet_574208; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Dashboard.
  ## 
  let valid = call_574215.validator(path, query, header, formData, body)
  let scheme = call_574215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574215.url(scheme.get, call_574215.host, call_574215.base,
                         call_574215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574215, url, valid)

proc call*(call_574216: Call_DashboardsGet_574208; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dashboardName: string): Recallable =
  ## dashboardsGet
  ## Gets the Dashboard.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   dashboardName: string (required)
  ##                : The name of the dashboard.
  var path_574217 = newJObject()
  var query_574218 = newJObject()
  add(path_574217, "resourceGroupName", newJString(resourceGroupName))
  add(query_574218, "api-version", newJString(apiVersion))
  add(path_574217, "subscriptionId", newJString(subscriptionId))
  add(path_574217, "dashboardName", newJString(dashboardName))
  result = call_574216.call(path_574217, query_574218, nil, nil, nil)

var dashboardsGet* = Call_DashboardsGet_574208(name: "dashboardsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Portal/dashboards/{dashboardName}",
    validator: validate_DashboardsGet_574209, base: "", url: url_DashboardsGet_574210,
    schemes: {Scheme.Https})
type
  Call_DashboardsUpdate_574243 = ref object of OpenApiRestCall_573657
proc url_DashboardsUpdate_574245(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dashboardName" in path, "`dashboardName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Portal/dashboards/"),
               (kind: VariableSegment, value: "dashboardName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DashboardsUpdate_574244(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates an existing Dashboard.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   dashboardName: JString (required)
  ##                : The name of the dashboard.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574246 = path.getOrDefault("resourceGroupName")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "resourceGroupName", valid_574246
  var valid_574247 = path.getOrDefault("subscriptionId")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "subscriptionId", valid_574247
  var valid_574248 = path.getOrDefault("dashboardName")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "dashboardName", valid_574248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574249 = query.getOrDefault("api-version")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "api-version", valid_574249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dashboard: JObject (required)
  ##            : The updatable fields of a Dashboard.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574251: Call_DashboardsUpdate_574243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing Dashboard.
  ## 
  let valid = call_574251.validator(path, query, header, formData, body)
  let scheme = call_574251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574251.url(scheme.get, call_574251.host, call_574251.base,
                         call_574251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574251, url, valid)

proc call*(call_574252: Call_DashboardsUpdate_574243; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dashboard: JsonNode;
          dashboardName: string): Recallable =
  ## dashboardsUpdate
  ## Updates an existing Dashboard.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   dashboard: JObject (required)
  ##            : The updatable fields of a Dashboard.
  ##   dashboardName: string (required)
  ##                : The name of the dashboard.
  var path_574253 = newJObject()
  var query_574254 = newJObject()
  var body_574255 = newJObject()
  add(path_574253, "resourceGroupName", newJString(resourceGroupName))
  add(query_574254, "api-version", newJString(apiVersion))
  add(path_574253, "subscriptionId", newJString(subscriptionId))
  if dashboard != nil:
    body_574255 = dashboard
  add(path_574253, "dashboardName", newJString(dashboardName))
  result = call_574252.call(path_574253, query_574254, nil, nil, body_574255)

var dashboardsUpdate* = Call_DashboardsUpdate_574243(name: "dashboardsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Portal/dashboards/{dashboardName}",
    validator: validate_DashboardsUpdate_574244, base: "",
    url: url_DashboardsUpdate_574245, schemes: {Scheme.Https})
type
  Call_DashboardsDelete_574232 = ref object of OpenApiRestCall_573657
proc url_DashboardsDelete_574234(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "dashboardName" in path, "`dashboardName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Portal/dashboards/"),
               (kind: VariableSegment, value: "dashboardName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DashboardsDelete_574233(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the Dashboard.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   dashboardName: JString (required)
  ##                : The name of the dashboard.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574235 = path.getOrDefault("resourceGroupName")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "resourceGroupName", valid_574235
  var valid_574236 = path.getOrDefault("subscriptionId")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "subscriptionId", valid_574236
  var valid_574237 = path.getOrDefault("dashboardName")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "dashboardName", valid_574237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574238 = query.getOrDefault("api-version")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = nil)
  if valid_574238 != nil:
    section.add "api-version", valid_574238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574239: Call_DashboardsDelete_574232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the Dashboard.
  ## 
  let valid = call_574239.validator(path, query, header, formData, body)
  let scheme = call_574239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574239.url(scheme.get, call_574239.host, call_574239.base,
                         call_574239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574239, url, valid)

proc call*(call_574240: Call_DashboardsDelete_574232; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; dashboardName: string): Recallable =
  ## dashboardsDelete
  ## Deletes the Dashboard.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   dashboardName: string (required)
  ##                : The name of the dashboard.
  var path_574241 = newJObject()
  var query_574242 = newJObject()
  add(path_574241, "resourceGroupName", newJString(resourceGroupName))
  add(query_574242, "api-version", newJString(apiVersion))
  add(path_574241, "subscriptionId", newJString(subscriptionId))
  add(path_574241, "dashboardName", newJString(dashboardName))
  result = call_574240.call(path_574241, query_574242, nil, nil, nil)

var dashboardsDelete* = Call_DashboardsDelete_574232(name: "dashboardsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Portal/dashboards/{dashboardName}",
    validator: validate_DashboardsDelete_574233, base: "",
    url: url_DashboardsDelete_574234, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
