
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: StorSimple8000SeriesManagementClient
## version: 2017-06-01
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
  macServiceName = "storsimple8000series-storsimple"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567889 = ref object of OpenApiRestCall_567667
proc url_OperationsList_567891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567890(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available REST API operations of the Microsoft.StorSimple provider
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568050 = query.getOrDefault("api-version")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "api-version", valid_568050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568073: Call_OperationsList_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available REST API operations of the Microsoft.StorSimple provider
  ## 
  let valid = call_568073.validator(path, query, header, formData, body)
  let scheme = call_568073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568073.url(scheme.get, call_568073.host, call_568073.base,
                         call_568073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568073, url, valid)

proc call*(call_568144: Call_OperationsList_567889; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available REST API operations of the Microsoft.StorSimple provider
  ##   apiVersion: string (required)
  ##             : The api version
  var query_568145 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  result = call_568144.call(nil, query_568145, nil, nil, nil)

var operationsList* = Call_OperationsList_567889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.StorSimple/operations",
    validator: validate_OperationsList_567890, base: "", url: url_OperationsList_567891,
    schemes: {Scheme.Https})
type
  Call_ManagersList_568185 = ref object of OpenApiRestCall_567667
proc url_ManagersList_568187(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersList_568186(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the managers in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568202 = path.getOrDefault("subscriptionId")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "subscriptionId", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568203 = query.getOrDefault("api-version")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "api-version", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_ManagersList_568185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the managers in a subscription.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_ManagersList_568185; apiVersion: string;
          subscriptionId: string): Recallable =
  ## managersList
  ## Retrieves all the managers in a subscription.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var managersList* = Call_ManagersList_568185(name: "managersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorSimple/managers",
    validator: validate_ManagersList_568186, base: "", url: url_ManagersList_568187,
    schemes: {Scheme.Https})
type
  Call_ManagersListByResourceGroup_568208 = ref object of OpenApiRestCall_567667
proc url_ManagersListByResourceGroup_568210(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersListByResourceGroup_568209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the managers in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568211 = path.getOrDefault("resourceGroupName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "resourceGroupName", valid_568211
  var valid_568212 = path.getOrDefault("subscriptionId")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "subscriptionId", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_ManagersListByResourceGroup_568208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the managers in a resource group.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_ManagersListByResourceGroup_568208;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## managersListByResourceGroup
  ## Retrieves all the managers in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(path_568216, "resourceGroupName", newJString(resourceGroupName))
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "subscriptionId", newJString(subscriptionId))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var managersListByResourceGroup* = Call_ManagersListByResourceGroup_568208(
    name: "managersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers",
    validator: validate_ManagersListByResourceGroup_568209, base: "",
    url: url_ManagersListByResourceGroup_568210, schemes: {Scheme.Https})
type
  Call_ManagersCreateOrUpdate_568229 = ref object of OpenApiRestCall_567667
proc url_ManagersCreateOrUpdate_568231(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersCreateOrUpdate_568230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568232 = path.getOrDefault("resourceGroupName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "resourceGroupName", valid_568232
  var valid_568233 = path.getOrDefault("managerName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "managerName", valid_568233
  var valid_568234 = path.getOrDefault("subscriptionId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "subscriptionId", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "api-version", valid_568235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The manager.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_ManagersCreateOrUpdate_568229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the manager.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_ManagersCreateOrUpdate_568229;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## managersCreateOrUpdate
  ## Creates or updates the manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The manager.
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  var body_568241 = newJObject()
  add(path_568239, "resourceGroupName", newJString(resourceGroupName))
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "managerName", newJString(managerName))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568241 = parameters
  result = call_568238.call(path_568239, query_568240, nil, nil, body_568241)

var managersCreateOrUpdate* = Call_ManagersCreateOrUpdate_568229(
    name: "managersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}",
    validator: validate_ManagersCreateOrUpdate_568230, base: "",
    url: url_ManagersCreateOrUpdate_568231, schemes: {Scheme.Https})
type
  Call_ManagersGet_568218 = ref object of OpenApiRestCall_567667
proc url_ManagersGet_568220(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGet_568219(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified manager name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568221 = path.getOrDefault("resourceGroupName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "resourceGroupName", valid_568221
  var valid_568222 = path.getOrDefault("managerName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "managerName", valid_568222
  var valid_568223 = path.getOrDefault("subscriptionId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "subscriptionId", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_ManagersGet_568218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified manager name.
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_ManagersGet_568218; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string): Recallable =
  ## managersGet
  ## Returns the properties of the specified manager name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  add(path_568227, "resourceGroupName", newJString(resourceGroupName))
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "managerName", newJString(managerName))
  add(path_568227, "subscriptionId", newJString(subscriptionId))
  result = call_568226.call(path_568227, query_568228, nil, nil, nil)

var managersGet* = Call_ManagersGet_568218(name: "managersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}",
                                        validator: validate_ManagersGet_568219,
                                        base: "", url: url_ManagersGet_568220,
                                        schemes: {Scheme.Https})
type
  Call_ManagersUpdate_568253 = ref object of OpenApiRestCall_567667
proc url_ManagersUpdate_568255(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersUpdate_568254(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the StorSimple Manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568256 = path.getOrDefault("resourceGroupName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "resourceGroupName", valid_568256
  var valid_568257 = path.getOrDefault("managerName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "managerName", valid_568257
  var valid_568258 = path.getOrDefault("subscriptionId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "subscriptionId", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The manager update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_ManagersUpdate_568253; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the StorSimple Manager.
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_ManagersUpdate_568253; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## managersUpdate
  ## Updates the StorSimple Manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The manager update parameters.
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  var body_568265 = newJObject()
  add(path_568263, "resourceGroupName", newJString(resourceGroupName))
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "managerName", newJString(managerName))
  add(path_568263, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568265 = parameters
  result = call_568262.call(path_568263, query_568264, nil, nil, body_568265)

var managersUpdate* = Call_ManagersUpdate_568253(name: "managersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}",
    validator: validate_ManagersUpdate_568254, base: "", url: url_ManagersUpdate_568255,
    schemes: {Scheme.Https})
type
  Call_ManagersDelete_568242 = ref object of OpenApiRestCall_567667
proc url_ManagersDelete_568244(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersDelete_568243(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568245 = path.getOrDefault("resourceGroupName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "resourceGroupName", valid_568245
  var valid_568246 = path.getOrDefault("managerName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "managerName", valid_568246
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "api-version", valid_568248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_ManagersDelete_568242; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the manager.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_ManagersDelete_568242; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string): Recallable =
  ## managersDelete
  ## Deletes the manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  add(path_568251, "resourceGroupName", newJString(resourceGroupName))
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "managerName", newJString(managerName))
  add(path_568251, "subscriptionId", newJString(subscriptionId))
  result = call_568250.call(path_568251, query_568252, nil, nil, nil)

var managersDelete* = Call_ManagersDelete_568242(name: "managersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}",
    validator: validate_ManagersDelete_568243, base: "", url: url_ManagersDelete_568244,
    schemes: {Scheme.Https})
type
  Call_AccessControlRecordsListByManager_568266 = ref object of OpenApiRestCall_567667
proc url_AccessControlRecordsListByManager_568268(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/accessControlRecords")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessControlRecordsListByManager_568267(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the access control records in a manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568269 = path.getOrDefault("resourceGroupName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "resourceGroupName", valid_568269
  var valid_568270 = path.getOrDefault("managerName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "managerName", valid_568270
  var valid_568271 = path.getOrDefault("subscriptionId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "subscriptionId", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_AccessControlRecordsListByManager_568266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the access control records in a manager.
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_AccessControlRecordsListByManager_568266;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## accessControlRecordsListByManager
  ## Retrieves all the access control records in a manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  add(path_568275, "resourceGroupName", newJString(resourceGroupName))
  add(query_568276, "api-version", newJString(apiVersion))
  add(path_568275, "managerName", newJString(managerName))
  add(path_568275, "subscriptionId", newJString(subscriptionId))
  result = call_568274.call(path_568275, query_568276, nil, nil, nil)

var accessControlRecordsListByManager* = Call_AccessControlRecordsListByManager_568266(
    name: "accessControlRecordsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/accessControlRecords",
    validator: validate_AccessControlRecordsListByManager_568267, base: "",
    url: url_AccessControlRecordsListByManager_568268, schemes: {Scheme.Https})
type
  Call_AccessControlRecordsCreateOrUpdate_568289 = ref object of OpenApiRestCall_567667
proc url_AccessControlRecordsCreateOrUpdate_568291(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "accessControlRecordName" in path,
        "`accessControlRecordName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/accessControlRecords/"),
               (kind: VariableSegment, value: "accessControlRecordName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessControlRecordsCreateOrUpdate_568290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates an access control record.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   accessControlRecordName: JString (required)
  ##                          : The name of the access control record.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568292 = path.getOrDefault("resourceGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceGroupName", valid_568292
  var valid_568293 = path.getOrDefault("managerName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "managerName", valid_568293
  var valid_568294 = path.getOrDefault("subscriptionId")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "subscriptionId", valid_568294
  var valid_568295 = path.getOrDefault("accessControlRecordName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "accessControlRecordName", valid_568295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The access control record to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568298: Call_AccessControlRecordsCreateOrUpdate_568289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates an access control record.
  ## 
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_AccessControlRecordsCreateOrUpdate_568289;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; accessControlRecordName: string;
          parameters: JsonNode): Recallable =
  ## accessControlRecordsCreateOrUpdate
  ## Creates or Updates an access control record.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   accessControlRecordName: string (required)
  ##                          : The name of the access control record.
  ##   parameters: JObject (required)
  ##             : The access control record to be added or updated.
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  var body_568302 = newJObject()
  add(path_568300, "resourceGroupName", newJString(resourceGroupName))
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "managerName", newJString(managerName))
  add(path_568300, "subscriptionId", newJString(subscriptionId))
  add(path_568300, "accessControlRecordName", newJString(accessControlRecordName))
  if parameters != nil:
    body_568302 = parameters
  result = call_568299.call(path_568300, query_568301, nil, nil, body_568302)

var accessControlRecordsCreateOrUpdate* = Call_AccessControlRecordsCreateOrUpdate_568289(
    name: "accessControlRecordsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/accessControlRecords/{accessControlRecordName}",
    validator: validate_AccessControlRecordsCreateOrUpdate_568290, base: "",
    url: url_AccessControlRecordsCreateOrUpdate_568291, schemes: {Scheme.Https})
type
  Call_AccessControlRecordsGet_568277 = ref object of OpenApiRestCall_567667
proc url_AccessControlRecordsGet_568279(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "accessControlRecordName" in path,
        "`accessControlRecordName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/accessControlRecords/"),
               (kind: VariableSegment, value: "accessControlRecordName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessControlRecordsGet_568278(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified access control record name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   accessControlRecordName: JString (required)
  ##                          : Name of access control record to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568280 = path.getOrDefault("resourceGroupName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "resourceGroupName", valid_568280
  var valid_568281 = path.getOrDefault("managerName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "managerName", valid_568281
  var valid_568282 = path.getOrDefault("subscriptionId")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "subscriptionId", valid_568282
  var valid_568283 = path.getOrDefault("accessControlRecordName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "accessControlRecordName", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "api-version", valid_568284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568285: Call_AccessControlRecordsGet_568277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified access control record name.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_AccessControlRecordsGet_568277;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; accessControlRecordName: string): Recallable =
  ## accessControlRecordsGet
  ## Returns the properties of the specified access control record name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   accessControlRecordName: string (required)
  ##                          : Name of access control record to be fetched.
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  add(path_568287, "resourceGroupName", newJString(resourceGroupName))
  add(query_568288, "api-version", newJString(apiVersion))
  add(path_568287, "managerName", newJString(managerName))
  add(path_568287, "subscriptionId", newJString(subscriptionId))
  add(path_568287, "accessControlRecordName", newJString(accessControlRecordName))
  result = call_568286.call(path_568287, query_568288, nil, nil, nil)

var accessControlRecordsGet* = Call_AccessControlRecordsGet_568277(
    name: "accessControlRecordsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/accessControlRecords/{accessControlRecordName}",
    validator: validate_AccessControlRecordsGet_568278, base: "",
    url: url_AccessControlRecordsGet_568279, schemes: {Scheme.Https})
type
  Call_AccessControlRecordsDelete_568303 = ref object of OpenApiRestCall_567667
proc url_AccessControlRecordsDelete_568305(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "accessControlRecordName" in path,
        "`accessControlRecordName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/accessControlRecords/"),
               (kind: VariableSegment, value: "accessControlRecordName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessControlRecordsDelete_568304(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the access control record.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   accessControlRecordName: JString (required)
  ##                          : The name of the access control record to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568306 = path.getOrDefault("resourceGroupName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "resourceGroupName", valid_568306
  var valid_568307 = path.getOrDefault("managerName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "managerName", valid_568307
  var valid_568308 = path.getOrDefault("subscriptionId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "subscriptionId", valid_568308
  var valid_568309 = path.getOrDefault("accessControlRecordName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "accessControlRecordName", valid_568309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568310 = query.getOrDefault("api-version")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "api-version", valid_568310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568311: Call_AccessControlRecordsDelete_568303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the access control record.
  ## 
  let valid = call_568311.validator(path, query, header, formData, body)
  let scheme = call_568311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568311.url(scheme.get, call_568311.host, call_568311.base,
                         call_568311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568311, url, valid)

proc call*(call_568312: Call_AccessControlRecordsDelete_568303;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; accessControlRecordName: string): Recallable =
  ## accessControlRecordsDelete
  ## Deletes the access control record.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   accessControlRecordName: string (required)
  ##                          : The name of the access control record to delete.
  var path_568313 = newJObject()
  var query_568314 = newJObject()
  add(path_568313, "resourceGroupName", newJString(resourceGroupName))
  add(query_568314, "api-version", newJString(apiVersion))
  add(path_568313, "managerName", newJString(managerName))
  add(path_568313, "subscriptionId", newJString(subscriptionId))
  add(path_568313, "accessControlRecordName", newJString(accessControlRecordName))
  result = call_568312.call(path_568313, query_568314, nil, nil, nil)

var accessControlRecordsDelete* = Call_AccessControlRecordsDelete_568303(
    name: "accessControlRecordsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/accessControlRecords/{accessControlRecordName}",
    validator: validate_AccessControlRecordsDelete_568304, base: "",
    url: url_AccessControlRecordsDelete_568305, schemes: {Scheme.Https})
type
  Call_AlertsListByManager_568315 = ref object of OpenApiRestCall_567667
proc url_AlertsListByManager_568317(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListByManager_568316(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves all the alerts in a manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568319 = path.getOrDefault("resourceGroupName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "resourceGroupName", valid_568319
  var valid_568320 = path.getOrDefault("managerName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "managerName", valid_568320
  var valid_568321 = path.getOrDefault("subscriptionId")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "subscriptionId", valid_568321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568322 = query.getOrDefault("api-version")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "api-version", valid_568322
  var valid_568323 = query.getOrDefault("$filter")
  valid_568323 = validateParameter(valid_568323, JString, required = false,
                                 default = nil)
  if valid_568323 != nil:
    section.add "$filter", valid_568323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568324: Call_AlertsListByManager_568315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the alerts in a manager.
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_AlertsListByManager_568315; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## alertsListByManager
  ## Retrieves all the alerts in a manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   Filter: string
  ##         : OData Filter options
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  add(path_568326, "resourceGroupName", newJString(resourceGroupName))
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "managerName", newJString(managerName))
  add(path_568326, "subscriptionId", newJString(subscriptionId))
  add(query_568327, "$filter", newJString(Filter))
  result = call_568325.call(path_568326, query_568327, nil, nil, nil)

var alertsListByManager* = Call_AlertsListByManager_568315(
    name: "alertsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/alerts",
    validator: validate_AlertsListByManager_568316, base: "",
    url: url_AlertsListByManager_568317, schemes: {Scheme.Https})
type
  Call_BandwidthSettingsListByManager_568328 = ref object of OpenApiRestCall_567667
proc url_BandwidthSettingsListByManager_568330(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/bandwidthSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BandwidthSettingsListByManager_568329(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the bandwidth setting in a manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568331 = path.getOrDefault("resourceGroupName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceGroupName", valid_568331
  var valid_568332 = path.getOrDefault("managerName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "managerName", valid_568332
  var valid_568333 = path.getOrDefault("subscriptionId")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "subscriptionId", valid_568333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568334 = query.getOrDefault("api-version")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "api-version", valid_568334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568335: Call_BandwidthSettingsListByManager_568328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the bandwidth setting in a manager.
  ## 
  let valid = call_568335.validator(path, query, header, formData, body)
  let scheme = call_568335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568335.url(scheme.get, call_568335.host, call_568335.base,
                         call_568335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568335, url, valid)

proc call*(call_568336: Call_BandwidthSettingsListByManager_568328;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## bandwidthSettingsListByManager
  ## Retrieves all the bandwidth setting in a manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_568337 = newJObject()
  var query_568338 = newJObject()
  add(path_568337, "resourceGroupName", newJString(resourceGroupName))
  add(query_568338, "api-version", newJString(apiVersion))
  add(path_568337, "managerName", newJString(managerName))
  add(path_568337, "subscriptionId", newJString(subscriptionId))
  result = call_568336.call(path_568337, query_568338, nil, nil, nil)

var bandwidthSettingsListByManager* = Call_BandwidthSettingsListByManager_568328(
    name: "bandwidthSettingsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/bandwidthSettings",
    validator: validate_BandwidthSettingsListByManager_568329, base: "",
    url: url_BandwidthSettingsListByManager_568330, schemes: {Scheme.Https})
type
  Call_BandwidthSettingsCreateOrUpdate_568351 = ref object of OpenApiRestCall_567667
proc url_BandwidthSettingsCreateOrUpdate_568353(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "bandwidthSettingName" in path,
        "`bandwidthSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/bandwidthSettings/"),
               (kind: VariableSegment, value: "bandwidthSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BandwidthSettingsCreateOrUpdate_568352(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the bandwidth setting
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   bandwidthSettingName: JString (required)
  ##                       : The bandwidth setting name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568354 = path.getOrDefault("resourceGroupName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "resourceGroupName", valid_568354
  var valid_568355 = path.getOrDefault("managerName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "managerName", valid_568355
  var valid_568356 = path.getOrDefault("subscriptionId")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "subscriptionId", valid_568356
  var valid_568357 = path.getOrDefault("bandwidthSettingName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "bandwidthSettingName", valid_568357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568358 = query.getOrDefault("api-version")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "api-version", valid_568358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The bandwidth setting to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568360: Call_BandwidthSettingsCreateOrUpdate_568351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the bandwidth setting
  ## 
  let valid = call_568360.validator(path, query, header, formData, body)
  let scheme = call_568360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568360.url(scheme.get, call_568360.host, call_568360.base,
                         call_568360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568360, url, valid)

proc call*(call_568361: Call_BandwidthSettingsCreateOrUpdate_568351;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; bandwidthSettingName: string; parameters: JsonNode): Recallable =
  ## bandwidthSettingsCreateOrUpdate
  ## Creates or updates the bandwidth setting
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   bandwidthSettingName: string (required)
  ##                       : The bandwidth setting name.
  ##   parameters: JObject (required)
  ##             : The bandwidth setting to be added or updated.
  var path_568362 = newJObject()
  var query_568363 = newJObject()
  var body_568364 = newJObject()
  add(path_568362, "resourceGroupName", newJString(resourceGroupName))
  add(query_568363, "api-version", newJString(apiVersion))
  add(path_568362, "managerName", newJString(managerName))
  add(path_568362, "subscriptionId", newJString(subscriptionId))
  add(path_568362, "bandwidthSettingName", newJString(bandwidthSettingName))
  if parameters != nil:
    body_568364 = parameters
  result = call_568361.call(path_568362, query_568363, nil, nil, body_568364)

var bandwidthSettingsCreateOrUpdate* = Call_BandwidthSettingsCreateOrUpdate_568351(
    name: "bandwidthSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/bandwidthSettings/{bandwidthSettingName}",
    validator: validate_BandwidthSettingsCreateOrUpdate_568352, base: "",
    url: url_BandwidthSettingsCreateOrUpdate_568353, schemes: {Scheme.Https})
type
  Call_BandwidthSettingsGet_568339 = ref object of OpenApiRestCall_567667
proc url_BandwidthSettingsGet_568341(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "bandwidthSettingName" in path,
        "`bandwidthSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/bandwidthSettings/"),
               (kind: VariableSegment, value: "bandwidthSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BandwidthSettingsGet_568340(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified bandwidth setting name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   bandwidthSettingName: JString (required)
  ##                       : The name of bandwidth setting to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568342 = path.getOrDefault("resourceGroupName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "resourceGroupName", valid_568342
  var valid_568343 = path.getOrDefault("managerName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "managerName", valid_568343
  var valid_568344 = path.getOrDefault("subscriptionId")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "subscriptionId", valid_568344
  var valid_568345 = path.getOrDefault("bandwidthSettingName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "bandwidthSettingName", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
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

proc call*(call_568347: Call_BandwidthSettingsGet_568339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified bandwidth setting name.
  ## 
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_BandwidthSettingsGet_568339;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; bandwidthSettingName: string): Recallable =
  ## bandwidthSettingsGet
  ## Returns the properties of the specified bandwidth setting name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   bandwidthSettingName: string (required)
  ##                       : The name of bandwidth setting to be fetched.
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  add(path_568349, "resourceGroupName", newJString(resourceGroupName))
  add(query_568350, "api-version", newJString(apiVersion))
  add(path_568349, "managerName", newJString(managerName))
  add(path_568349, "subscriptionId", newJString(subscriptionId))
  add(path_568349, "bandwidthSettingName", newJString(bandwidthSettingName))
  result = call_568348.call(path_568349, query_568350, nil, nil, nil)

var bandwidthSettingsGet* = Call_BandwidthSettingsGet_568339(
    name: "bandwidthSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/bandwidthSettings/{bandwidthSettingName}",
    validator: validate_BandwidthSettingsGet_568340, base: "",
    url: url_BandwidthSettingsGet_568341, schemes: {Scheme.Https})
type
  Call_BandwidthSettingsDelete_568365 = ref object of OpenApiRestCall_567667
proc url_BandwidthSettingsDelete_568367(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "bandwidthSettingName" in path,
        "`bandwidthSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/bandwidthSettings/"),
               (kind: VariableSegment, value: "bandwidthSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BandwidthSettingsDelete_568366(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the bandwidth setting
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   bandwidthSettingName: JString (required)
  ##                       : The name of the bandwidth setting.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568368 = path.getOrDefault("resourceGroupName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "resourceGroupName", valid_568368
  var valid_568369 = path.getOrDefault("managerName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "managerName", valid_568369
  var valid_568370 = path.getOrDefault("subscriptionId")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "subscriptionId", valid_568370
  var valid_568371 = path.getOrDefault("bandwidthSettingName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "bandwidthSettingName", valid_568371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568372 = query.getOrDefault("api-version")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "api-version", valid_568372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568373: Call_BandwidthSettingsDelete_568365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the bandwidth setting
  ## 
  let valid = call_568373.validator(path, query, header, formData, body)
  let scheme = call_568373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568373.url(scheme.get, call_568373.host, call_568373.base,
                         call_568373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568373, url, valid)

proc call*(call_568374: Call_BandwidthSettingsDelete_568365;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; bandwidthSettingName: string): Recallable =
  ## bandwidthSettingsDelete
  ## Deletes the bandwidth setting
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   bandwidthSettingName: string (required)
  ##                       : The name of the bandwidth setting.
  var path_568375 = newJObject()
  var query_568376 = newJObject()
  add(path_568375, "resourceGroupName", newJString(resourceGroupName))
  add(query_568376, "api-version", newJString(apiVersion))
  add(path_568375, "managerName", newJString(managerName))
  add(path_568375, "subscriptionId", newJString(subscriptionId))
  add(path_568375, "bandwidthSettingName", newJString(bandwidthSettingName))
  result = call_568374.call(path_568375, query_568376, nil, nil, nil)

var bandwidthSettingsDelete* = Call_BandwidthSettingsDelete_568365(
    name: "bandwidthSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/bandwidthSettings/{bandwidthSettingName}",
    validator: validate_BandwidthSettingsDelete_568366, base: "",
    url: url_BandwidthSettingsDelete_568367, schemes: {Scheme.Https})
type
  Call_AlertsClear_568377 = ref object of OpenApiRestCall_567667
proc url_AlertsClear_568379(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/clearAlerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsClear_568378(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Clear the alerts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568380 = path.getOrDefault("resourceGroupName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "resourceGroupName", valid_568380
  var valid_568381 = path.getOrDefault("managerName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "managerName", valid_568381
  var valid_568382 = path.getOrDefault("subscriptionId")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "subscriptionId", valid_568382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568383 = query.getOrDefault("api-version")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "api-version", valid_568383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The clear alert request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568385: Call_AlertsClear_568377; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clear the alerts.
  ## 
  let valid = call_568385.validator(path, query, header, formData, body)
  let scheme = call_568385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568385.url(scheme.get, call_568385.host, call_568385.base,
                         call_568385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568385, url, valid)

proc call*(call_568386: Call_AlertsClear_568377; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## alertsClear
  ## Clear the alerts.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The clear alert request.
  var path_568387 = newJObject()
  var query_568388 = newJObject()
  var body_568389 = newJObject()
  add(path_568387, "resourceGroupName", newJString(resourceGroupName))
  add(query_568388, "api-version", newJString(apiVersion))
  add(path_568387, "managerName", newJString(managerName))
  add(path_568387, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568389 = parameters
  result = call_568386.call(path_568387, query_568388, nil, nil, body_568389)

var alertsClear* = Call_AlertsClear_568377(name: "alertsClear",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/clearAlerts",
                                        validator: validate_AlertsClear_568378,
                                        base: "", url: url_AlertsClear_568379,
                                        schemes: {Scheme.Https})
type
  Call_CloudAppliancesListSupportedConfigurations_568390 = ref object of OpenApiRestCall_567667
proc url_CloudAppliancesListSupportedConfigurations_568392(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/cloudApplianceConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudAppliancesListSupportedConfigurations_568391(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists supported cloud appliance models and supported configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568393 = path.getOrDefault("resourceGroupName")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "resourceGroupName", valid_568393
  var valid_568394 = path.getOrDefault("managerName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "managerName", valid_568394
  var valid_568395 = path.getOrDefault("subscriptionId")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "subscriptionId", valid_568395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568396 = query.getOrDefault("api-version")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "api-version", valid_568396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568397: Call_CloudAppliancesListSupportedConfigurations_568390;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists supported cloud appliance models and supported configurations.
  ## 
  let valid = call_568397.validator(path, query, header, formData, body)
  let scheme = call_568397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568397.url(scheme.get, call_568397.host, call_568397.base,
                         call_568397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568397, url, valid)

proc call*(call_568398: Call_CloudAppliancesListSupportedConfigurations_568390;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## cloudAppliancesListSupportedConfigurations
  ## Lists supported cloud appliance models and supported configurations.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_568399 = newJObject()
  var query_568400 = newJObject()
  add(path_568399, "resourceGroupName", newJString(resourceGroupName))
  add(query_568400, "api-version", newJString(apiVersion))
  add(path_568399, "managerName", newJString(managerName))
  add(path_568399, "subscriptionId", newJString(subscriptionId))
  result = call_568398.call(path_568399, query_568400, nil, nil, nil)

var cloudAppliancesListSupportedConfigurations* = Call_CloudAppliancesListSupportedConfigurations_568390(
    name: "cloudAppliancesListSupportedConfigurations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/cloudApplianceConfigurations",
    validator: validate_CloudAppliancesListSupportedConfigurations_568391,
    base: "", url: url_CloudAppliancesListSupportedConfigurations_568392,
    schemes: {Scheme.Https})
type
  Call_DevicesConfigure_568401 = ref object of OpenApiRestCall_567667
proc url_DevicesConfigure_568403(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/configureDevice")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesConfigure_568402(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Complete minimal setup before using the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568404 = path.getOrDefault("resourceGroupName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "resourceGroupName", valid_568404
  var valid_568405 = path.getOrDefault("managerName")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "managerName", valid_568405
  var valid_568406 = path.getOrDefault("subscriptionId")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "subscriptionId", valid_568406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568407 = query.getOrDefault("api-version")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "api-version", valid_568407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The minimal properties to configure a device.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568409: Call_DevicesConfigure_568401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Complete minimal setup before using the device.
  ## 
  let valid = call_568409.validator(path, query, header, formData, body)
  let scheme = call_568409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568409.url(scheme.get, call_568409.host, call_568409.base,
                         call_568409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568409, url, valid)

proc call*(call_568410: Call_DevicesConfigure_568401; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## devicesConfigure
  ## Complete minimal setup before using the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The minimal properties to configure a device.
  var path_568411 = newJObject()
  var query_568412 = newJObject()
  var body_568413 = newJObject()
  add(path_568411, "resourceGroupName", newJString(resourceGroupName))
  add(query_568412, "api-version", newJString(apiVersion))
  add(path_568411, "managerName", newJString(managerName))
  add(path_568411, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568413 = parameters
  result = call_568410.call(path_568411, query_568412, nil, nil, body_568413)

var devicesConfigure* = Call_DevicesConfigure_568401(name: "devicesConfigure",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/configureDevice",
    validator: validate_DevicesConfigure_568402, base: "",
    url: url_DevicesConfigure_568403, schemes: {Scheme.Https})
type
  Call_DevicesListByManager_568414 = ref object of OpenApiRestCall_567667
proc url_DevicesListByManager_568416(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListByManager_568415(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of devices for the specified manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568417 = path.getOrDefault("resourceGroupName")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "resourceGroupName", valid_568417
  var valid_568418 = path.getOrDefault("managerName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "managerName", valid_568418
  var valid_568419 = path.getOrDefault("subscriptionId")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "subscriptionId", valid_568419
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device or $expand=rolloverdetails to populate additional fields related to the service data encryption key rollover on device
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568420 = query.getOrDefault("api-version")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "api-version", valid_568420
  var valid_568421 = query.getOrDefault("$expand")
  valid_568421 = validateParameter(valid_568421, JString, required = false,
                                 default = nil)
  if valid_568421 != nil:
    section.add "$expand", valid_568421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568422: Call_DevicesListByManager_568414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of devices for the specified manager.
  ## 
  let valid = call_568422.validator(path, query, header, formData, body)
  let scheme = call_568422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568422.url(scheme.get, call_568422.host, call_568422.base,
                         call_568422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568422, url, valid)

proc call*(call_568423: Call_DevicesListByManager_568414;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; Expand: string = ""): Recallable =
  ## devicesListByManager
  ## Returns the list of devices for the specified manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the device or $expand=rolloverdetails to populate additional fields related to the service data encryption key rollover on device
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_568424 = newJObject()
  var query_568425 = newJObject()
  add(path_568424, "resourceGroupName", newJString(resourceGroupName))
  add(query_568425, "api-version", newJString(apiVersion))
  add(query_568425, "$expand", newJString(Expand))
  add(path_568424, "managerName", newJString(managerName))
  add(path_568424, "subscriptionId", newJString(subscriptionId))
  result = call_568423.call(path_568424, query_568425, nil, nil, nil)

var devicesListByManager* = Call_DevicesListByManager_568414(
    name: "devicesListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices",
    validator: validate_DevicesListByManager_568415, base: "",
    url: url_DevicesListByManager_568416, schemes: {Scheme.Https})
type
  Call_DevicesGet_568426 = ref object of OpenApiRestCall_567667
proc url_DevicesGet_568428(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGet_568427(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568429 = path.getOrDefault("resourceGroupName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "resourceGroupName", valid_568429
  var valid_568430 = path.getOrDefault("managerName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "managerName", valid_568430
  var valid_568431 = path.getOrDefault("subscriptionId")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "subscriptionId", valid_568431
  var valid_568432 = path.getOrDefault("deviceName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "deviceName", valid_568432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device or $expand=rolloverdetails to populate additional fields related to the service data encryption key rollover on device
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568433 = query.getOrDefault("api-version")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "api-version", valid_568433
  var valid_568434 = query.getOrDefault("$expand")
  valid_568434 = validateParameter(valid_568434, JString, required = false,
                                 default = nil)
  if valid_568434 != nil:
    section.add "$expand", valid_568434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568435: Call_DevicesGet_568426; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified device.
  ## 
  let valid = call_568435.validator(path, query, header, formData, body)
  let scheme = call_568435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568435.url(scheme.get, call_568435.host, call_568435.base,
                         call_568435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568435, url, valid)

proc call*(call_568436: Call_DevicesGet_568426; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          deviceName: string; Expand: string = ""): Recallable =
  ## devicesGet
  ## Returns the properties of the specified device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the device or $expand=rolloverdetails to populate additional fields related to the service data encryption key rollover on device
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568437 = newJObject()
  var query_568438 = newJObject()
  add(path_568437, "resourceGroupName", newJString(resourceGroupName))
  add(query_568438, "api-version", newJString(apiVersion))
  add(query_568438, "$expand", newJString(Expand))
  add(path_568437, "managerName", newJString(managerName))
  add(path_568437, "subscriptionId", newJString(subscriptionId))
  add(path_568437, "deviceName", newJString(deviceName))
  result = call_568436.call(path_568437, query_568438, nil, nil, nil)

var devicesGet* = Call_DevicesGet_568426(name: "devicesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
                                      validator: validate_DevicesGet_568427,
                                      base: "", url: url_DevicesGet_568428,
                                      schemes: {Scheme.Https})
type
  Call_DevicesUpdate_568451 = ref object of OpenApiRestCall_567667
proc url_DevicesUpdate_568453(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesUpdate_568452(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568454 = path.getOrDefault("resourceGroupName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "resourceGroupName", valid_568454
  var valid_568455 = path.getOrDefault("managerName")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "managerName", valid_568455
  var valid_568456 = path.getOrDefault("subscriptionId")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "subscriptionId", valid_568456
  var valid_568457 = path.getOrDefault("deviceName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "deviceName", valid_568457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Patch representation of the device.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568460: Call_DevicesUpdate_568451; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches the device.
  ## 
  let valid = call_568460.validator(path, query, header, formData, body)
  let scheme = call_568460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568460.url(scheme.get, call_568460.host, call_568460.base,
                         call_568460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568460, url, valid)

proc call*(call_568461: Call_DevicesUpdate_568451; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          parameters: JsonNode; deviceName: string): Recallable =
  ## devicesUpdate
  ## Patches the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : Patch representation of the device.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568462 = newJObject()
  var query_568463 = newJObject()
  var body_568464 = newJObject()
  add(path_568462, "resourceGroupName", newJString(resourceGroupName))
  add(query_568463, "api-version", newJString(apiVersion))
  add(path_568462, "managerName", newJString(managerName))
  add(path_568462, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568464 = parameters
  add(path_568462, "deviceName", newJString(deviceName))
  result = call_568461.call(path_568462, query_568463, nil, nil, body_568464)

var devicesUpdate* = Call_DevicesUpdate_568451(name: "devicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
    validator: validate_DevicesUpdate_568452, base: "", url: url_DevicesUpdate_568453,
    schemes: {Scheme.Https})
type
  Call_DevicesDelete_568439 = ref object of OpenApiRestCall_567667
proc url_DevicesDelete_568441(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesDelete_568440(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568442 = path.getOrDefault("resourceGroupName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "resourceGroupName", valid_568442
  var valid_568443 = path.getOrDefault("managerName")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "managerName", valid_568443
  var valid_568444 = path.getOrDefault("subscriptionId")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "subscriptionId", valid_568444
  var valid_568445 = path.getOrDefault("deviceName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "deviceName", valid_568445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568446 = query.getOrDefault("api-version")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "api-version", valid_568446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568447: Call_DevicesDelete_568439; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the device.
  ## 
  let valid = call_568447.validator(path, query, header, formData, body)
  let scheme = call_568447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568447.url(scheme.get, call_568447.host, call_568447.base,
                         call_568447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568447, url, valid)

proc call*(call_568448: Call_DevicesDelete_568439; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## devicesDelete
  ## Deletes the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568449 = newJObject()
  var query_568450 = newJObject()
  add(path_568449, "resourceGroupName", newJString(resourceGroupName))
  add(query_568450, "api-version", newJString(apiVersion))
  add(path_568449, "managerName", newJString(managerName))
  add(path_568449, "subscriptionId", newJString(subscriptionId))
  add(path_568449, "deviceName", newJString(deviceName))
  result = call_568448.call(path_568449, query_568450, nil, nil, nil)

var devicesDelete* = Call_DevicesDelete_568439(name: "devicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
    validator: validate_DevicesDelete_568440, base: "", url: url_DevicesDelete_568441,
    schemes: {Scheme.Https})
type
  Call_DeviceSettingsCreateOrUpdateAlertSettings_568477 = ref object of OpenApiRestCall_567667
proc url_DeviceSettingsCreateOrUpdateAlertSettings_568479(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/alertSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsCreateOrUpdateAlertSettings_568478(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the alert settings of the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568480 = path.getOrDefault("resourceGroupName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "resourceGroupName", valid_568480
  var valid_568481 = path.getOrDefault("managerName")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "managerName", valid_568481
  var valid_568482 = path.getOrDefault("subscriptionId")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "subscriptionId", valid_568482
  var valid_568483 = path.getOrDefault("deviceName")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "deviceName", valid_568483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568484 = query.getOrDefault("api-version")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "api-version", valid_568484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The alert settings to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568486: Call_DeviceSettingsCreateOrUpdateAlertSettings_568477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the alert settings of the specified device.
  ## 
  let valid = call_568486.validator(path, query, header, formData, body)
  let scheme = call_568486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568486.url(scheme.get, call_568486.host, call_568486.base,
                         call_568486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568486, url, valid)

proc call*(call_568487: Call_DeviceSettingsCreateOrUpdateAlertSettings_568477;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; parameters: JsonNode; deviceName: string): Recallable =
  ## deviceSettingsCreateOrUpdateAlertSettings
  ## Creates or updates the alert settings of the specified device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The alert settings to be added or updated.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568488 = newJObject()
  var query_568489 = newJObject()
  var body_568490 = newJObject()
  add(path_568488, "resourceGroupName", newJString(resourceGroupName))
  add(query_568489, "api-version", newJString(apiVersion))
  add(path_568488, "managerName", newJString(managerName))
  add(path_568488, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568490 = parameters
  add(path_568488, "deviceName", newJString(deviceName))
  result = call_568487.call(path_568488, query_568489, nil, nil, body_568490)

var deviceSettingsCreateOrUpdateAlertSettings* = Call_DeviceSettingsCreateOrUpdateAlertSettings_568477(
    name: "deviceSettingsCreateOrUpdateAlertSettings", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/alertSettings/default",
    validator: validate_DeviceSettingsCreateOrUpdateAlertSettings_568478,
    base: "", url: url_DeviceSettingsCreateOrUpdateAlertSettings_568479,
    schemes: {Scheme.Https})
type
  Call_DeviceSettingsGetAlertSettings_568465 = ref object of OpenApiRestCall_567667
proc url_DeviceSettingsGetAlertSettings_568467(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/alertSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsGetAlertSettings_568466(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert settings of the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568468 = path.getOrDefault("resourceGroupName")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "resourceGroupName", valid_568468
  var valid_568469 = path.getOrDefault("managerName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "managerName", valid_568469
  var valid_568470 = path.getOrDefault("subscriptionId")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "subscriptionId", valid_568470
  var valid_568471 = path.getOrDefault("deviceName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "deviceName", valid_568471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568472 = query.getOrDefault("api-version")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "api-version", valid_568472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568473: Call_DeviceSettingsGetAlertSettings_568465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert settings of the specified device.
  ## 
  let valid = call_568473.validator(path, query, header, formData, body)
  let scheme = call_568473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568473.url(scheme.get, call_568473.host, call_568473.base,
                         call_568473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568473, url, valid)

proc call*(call_568474: Call_DeviceSettingsGetAlertSettings_568465;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## deviceSettingsGetAlertSettings
  ## Gets the alert settings of the specified device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568475 = newJObject()
  var query_568476 = newJObject()
  add(path_568475, "resourceGroupName", newJString(resourceGroupName))
  add(query_568476, "api-version", newJString(apiVersion))
  add(path_568475, "managerName", newJString(managerName))
  add(path_568475, "subscriptionId", newJString(subscriptionId))
  add(path_568475, "deviceName", newJString(deviceName))
  result = call_568474.call(path_568475, query_568476, nil, nil, nil)

var deviceSettingsGetAlertSettings* = Call_DeviceSettingsGetAlertSettings_568465(
    name: "deviceSettingsGetAlertSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/alertSettings/default",
    validator: validate_DeviceSettingsGetAlertSettings_568466, base: "",
    url: url_DeviceSettingsGetAlertSettings_568467, schemes: {Scheme.Https})
type
  Call_DevicesAuthorizeForServiceEncryptionKeyRollover_568491 = ref object of OpenApiRestCall_567667
proc url_DevicesAuthorizeForServiceEncryptionKeyRollover_568493(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"), (kind: ConstantSegment,
        value: "/authorizeForServiceEncryptionKeyRollover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesAuthorizeForServiceEncryptionKeyRollover_568492(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Authorizes the specified device for service data encryption key rollover.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568494 = path.getOrDefault("resourceGroupName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "resourceGroupName", valid_568494
  var valid_568495 = path.getOrDefault("managerName")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "managerName", valid_568495
  var valid_568496 = path.getOrDefault("subscriptionId")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "subscriptionId", valid_568496
  var valid_568497 = path.getOrDefault("deviceName")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "deviceName", valid_568497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568498 = query.getOrDefault("api-version")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "api-version", valid_568498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568499: Call_DevicesAuthorizeForServiceEncryptionKeyRollover_568491;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorizes the specified device for service data encryption key rollover.
  ## 
  let valid = call_568499.validator(path, query, header, formData, body)
  let scheme = call_568499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568499.url(scheme.get, call_568499.host, call_568499.base,
                         call_568499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568499, url, valid)

proc call*(call_568500: Call_DevicesAuthorizeForServiceEncryptionKeyRollover_568491;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesAuthorizeForServiceEncryptionKeyRollover
  ## Authorizes the specified device for service data encryption key rollover.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568501 = newJObject()
  var query_568502 = newJObject()
  add(path_568501, "resourceGroupName", newJString(resourceGroupName))
  add(query_568502, "api-version", newJString(apiVersion))
  add(path_568501, "managerName", newJString(managerName))
  add(path_568501, "subscriptionId", newJString(subscriptionId))
  add(path_568501, "deviceName", newJString(deviceName))
  result = call_568500.call(path_568501, query_568502, nil, nil, nil)

var devicesAuthorizeForServiceEncryptionKeyRollover* = Call_DevicesAuthorizeForServiceEncryptionKeyRollover_568491(
    name: "devicesAuthorizeForServiceEncryptionKeyRollover",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/authorizeForServiceEncryptionKeyRollover",
    validator: validate_DevicesAuthorizeForServiceEncryptionKeyRollover_568492,
    base: "", url: url_DevicesAuthorizeForServiceEncryptionKeyRollover_568493,
    schemes: {Scheme.Https})
type
  Call_BackupPoliciesListByDevice_568503 = ref object of OpenApiRestCall_567667
proc url_BackupPoliciesListByDevice_568505(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupPoliciesListByDevice_568504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the backup policies in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568506 = path.getOrDefault("resourceGroupName")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "resourceGroupName", valid_568506
  var valid_568507 = path.getOrDefault("managerName")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "managerName", valid_568507
  var valid_568508 = path.getOrDefault("subscriptionId")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "subscriptionId", valid_568508
  var valid_568509 = path.getOrDefault("deviceName")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "deviceName", valid_568509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568510 = query.getOrDefault("api-version")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "api-version", valid_568510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568511: Call_BackupPoliciesListByDevice_568503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the backup policies in a device.
  ## 
  let valid = call_568511.validator(path, query, header, formData, body)
  let scheme = call_568511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568511.url(scheme.get, call_568511.host, call_568511.base,
                         call_568511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568511, url, valid)

proc call*(call_568512: Call_BackupPoliciesListByDevice_568503;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## backupPoliciesListByDevice
  ## Gets all the backup policies in a device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568513 = newJObject()
  var query_568514 = newJObject()
  add(path_568513, "resourceGroupName", newJString(resourceGroupName))
  add(query_568514, "api-version", newJString(apiVersion))
  add(path_568513, "managerName", newJString(managerName))
  add(path_568513, "subscriptionId", newJString(subscriptionId))
  add(path_568513, "deviceName", newJString(deviceName))
  result = call_568512.call(path_568513, query_568514, nil, nil, nil)

var backupPoliciesListByDevice* = Call_BackupPoliciesListByDevice_568503(
    name: "backupPoliciesListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies",
    validator: validate_BackupPoliciesListByDevice_568504, base: "",
    url: url_BackupPoliciesListByDevice_568505, schemes: {Scheme.Https})
type
  Call_BackupPoliciesCreateOrUpdate_568528 = ref object of OpenApiRestCall_567667
proc url_BackupPoliciesCreateOrUpdate_568530(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupPoliciesCreateOrUpdate_568529(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the backup policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   backupPolicyName: JString (required)
  ##                   : The name of the backup policy to be created/updated.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568531 = path.getOrDefault("resourceGroupName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "resourceGroupName", valid_568531
  var valid_568532 = path.getOrDefault("managerName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "managerName", valid_568532
  var valid_568533 = path.getOrDefault("subscriptionId")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "subscriptionId", valid_568533
  var valid_568534 = path.getOrDefault("backupPolicyName")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "backupPolicyName", valid_568534
  var valid_568535 = path.getOrDefault("deviceName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "deviceName", valid_568535
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568536 = query.getOrDefault("api-version")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "api-version", valid_568536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The backup policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568538: Call_BackupPoliciesCreateOrUpdate_568528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the backup policy.
  ## 
  let valid = call_568538.validator(path, query, header, formData, body)
  let scheme = call_568538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568538.url(scheme.get, call_568538.host, call_568538.base,
                         call_568538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568538, url, valid)

proc call*(call_568539: Call_BackupPoliciesCreateOrUpdate_568528;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; backupPolicyName: string; parameters: JsonNode;
          deviceName: string): Recallable =
  ## backupPoliciesCreateOrUpdate
  ## Creates or updates the backup policy.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupPolicyName: string (required)
  ##                   : The name of the backup policy to be created/updated.
  ##   parameters: JObject (required)
  ##             : The backup policy.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568540 = newJObject()
  var query_568541 = newJObject()
  var body_568542 = newJObject()
  add(path_568540, "resourceGroupName", newJString(resourceGroupName))
  add(query_568541, "api-version", newJString(apiVersion))
  add(path_568540, "managerName", newJString(managerName))
  add(path_568540, "subscriptionId", newJString(subscriptionId))
  add(path_568540, "backupPolicyName", newJString(backupPolicyName))
  if parameters != nil:
    body_568542 = parameters
  add(path_568540, "deviceName", newJString(deviceName))
  result = call_568539.call(path_568540, query_568541, nil, nil, body_568542)

var backupPoliciesCreateOrUpdate* = Call_BackupPoliciesCreateOrUpdate_568528(
    name: "backupPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}",
    validator: validate_BackupPoliciesCreateOrUpdate_568529, base: "",
    url: url_BackupPoliciesCreateOrUpdate_568530, schemes: {Scheme.Https})
type
  Call_BackupPoliciesGet_568515 = ref object of OpenApiRestCall_567667
proc url_BackupPoliciesGet_568517(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupPoliciesGet_568516(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the properties of the specified backup policy name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   backupPolicyName: JString (required)
  ##                   : The name of backup policy to be fetched.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568518 = path.getOrDefault("resourceGroupName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "resourceGroupName", valid_568518
  var valid_568519 = path.getOrDefault("managerName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "managerName", valid_568519
  var valid_568520 = path.getOrDefault("subscriptionId")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "subscriptionId", valid_568520
  var valid_568521 = path.getOrDefault("backupPolicyName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "backupPolicyName", valid_568521
  var valid_568522 = path.getOrDefault("deviceName")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "deviceName", valid_568522
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568523 = query.getOrDefault("api-version")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "api-version", valid_568523
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568524: Call_BackupPoliciesGet_568515; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified backup policy name.
  ## 
  let valid = call_568524.validator(path, query, header, formData, body)
  let scheme = call_568524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568524.url(scheme.get, call_568524.host, call_568524.base,
                         call_568524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568524, url, valid)

proc call*(call_568525: Call_BackupPoliciesGet_568515; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          backupPolicyName: string; deviceName: string): Recallable =
  ## backupPoliciesGet
  ## Gets the properties of the specified backup policy name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupPolicyName: string (required)
  ##                   : The name of backup policy to be fetched.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568526 = newJObject()
  var query_568527 = newJObject()
  add(path_568526, "resourceGroupName", newJString(resourceGroupName))
  add(query_568527, "api-version", newJString(apiVersion))
  add(path_568526, "managerName", newJString(managerName))
  add(path_568526, "subscriptionId", newJString(subscriptionId))
  add(path_568526, "backupPolicyName", newJString(backupPolicyName))
  add(path_568526, "deviceName", newJString(deviceName))
  result = call_568525.call(path_568526, query_568527, nil, nil, nil)

var backupPoliciesGet* = Call_BackupPoliciesGet_568515(name: "backupPoliciesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}",
    validator: validate_BackupPoliciesGet_568516, base: "",
    url: url_BackupPoliciesGet_568517, schemes: {Scheme.Https})
type
  Call_BackupPoliciesDelete_568543 = ref object of OpenApiRestCall_567667
proc url_BackupPoliciesDelete_568545(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupPoliciesDelete_568544(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the backup policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   backupPolicyName: JString (required)
  ##                   : The name of the backup policy.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568546 = path.getOrDefault("resourceGroupName")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "resourceGroupName", valid_568546
  var valid_568547 = path.getOrDefault("managerName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "managerName", valid_568547
  var valid_568548 = path.getOrDefault("subscriptionId")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "subscriptionId", valid_568548
  var valid_568549 = path.getOrDefault("backupPolicyName")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "backupPolicyName", valid_568549
  var valid_568550 = path.getOrDefault("deviceName")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "deviceName", valid_568550
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568551 = query.getOrDefault("api-version")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "api-version", valid_568551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568552: Call_BackupPoliciesDelete_568543; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup policy.
  ## 
  let valid = call_568552.validator(path, query, header, formData, body)
  let scheme = call_568552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568552.url(scheme.get, call_568552.host, call_568552.base,
                         call_568552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568552, url, valid)

proc call*(call_568553: Call_BackupPoliciesDelete_568543;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; backupPolicyName: string; deviceName: string): Recallable =
  ## backupPoliciesDelete
  ## Deletes the backup policy.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupPolicyName: string (required)
  ##                   : The name of the backup policy.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568554 = newJObject()
  var query_568555 = newJObject()
  add(path_568554, "resourceGroupName", newJString(resourceGroupName))
  add(query_568555, "api-version", newJString(apiVersion))
  add(path_568554, "managerName", newJString(managerName))
  add(path_568554, "subscriptionId", newJString(subscriptionId))
  add(path_568554, "backupPolicyName", newJString(backupPolicyName))
  add(path_568554, "deviceName", newJString(deviceName))
  result = call_568553.call(path_568554, query_568555, nil, nil, nil)

var backupPoliciesDelete* = Call_BackupPoliciesDelete_568543(
    name: "backupPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}",
    validator: validate_BackupPoliciesDelete_568544, base: "",
    url: url_BackupPoliciesDelete_568545, schemes: {Scheme.Https})
type
  Call_BackupPoliciesBackupNow_568556 = ref object of OpenApiRestCall_567667
proc url_BackupPoliciesBackupNow_568558(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName"),
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupPoliciesBackupNow_568557(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Backup the backup policy now.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   backupPolicyName: JString (required)
  ##                   : The backup policy name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568559 = path.getOrDefault("resourceGroupName")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "resourceGroupName", valid_568559
  var valid_568560 = path.getOrDefault("managerName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "managerName", valid_568560
  var valid_568561 = path.getOrDefault("subscriptionId")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "subscriptionId", valid_568561
  var valid_568562 = path.getOrDefault("backupPolicyName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "backupPolicyName", valid_568562
  var valid_568563 = path.getOrDefault("deviceName")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "deviceName", valid_568563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   backupType: JString (required)
  ##             : The backup Type. This can be cloudSnapshot or localSnapshot.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568564 = query.getOrDefault("api-version")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "api-version", valid_568564
  var valid_568565 = query.getOrDefault("backupType")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "backupType", valid_568565
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568566: Call_BackupPoliciesBackupNow_568556; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup the backup policy now.
  ## 
  let valid = call_568566.validator(path, query, header, formData, body)
  let scheme = call_568566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568566.url(scheme.get, call_568566.host, call_568566.base,
                         call_568566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568566, url, valid)

proc call*(call_568567: Call_BackupPoliciesBackupNow_568556;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; backupPolicyName: string; backupType: string;
          deviceName: string): Recallable =
  ## backupPoliciesBackupNow
  ## Backup the backup policy now.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupPolicyName: string (required)
  ##                   : The backup policy name.
  ##   backupType: string (required)
  ##             : The backup Type. This can be cloudSnapshot or localSnapshot.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568568 = newJObject()
  var query_568569 = newJObject()
  add(path_568568, "resourceGroupName", newJString(resourceGroupName))
  add(query_568569, "api-version", newJString(apiVersion))
  add(path_568568, "managerName", newJString(managerName))
  add(path_568568, "subscriptionId", newJString(subscriptionId))
  add(path_568568, "backupPolicyName", newJString(backupPolicyName))
  add(query_568569, "backupType", newJString(backupType))
  add(path_568568, "deviceName", newJString(deviceName))
  result = call_568567.call(path_568568, query_568569, nil, nil, nil)

var backupPoliciesBackupNow* = Call_BackupPoliciesBackupNow_568556(
    name: "backupPoliciesBackupNow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/backup",
    validator: validate_BackupPoliciesBackupNow_568557, base: "",
    url: url_BackupPoliciesBackupNow_568558, schemes: {Scheme.Https})
type
  Call_BackupSchedulesListByBackupPolicy_568570 = ref object of OpenApiRestCall_567667
proc url_BackupSchedulesListByBackupPolicy_568572(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName"),
               (kind: ConstantSegment, value: "/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupSchedulesListByBackupPolicy_568571(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the backup schedules in a backup policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   backupPolicyName: JString (required)
  ##                   : The backup policy name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568573 = path.getOrDefault("resourceGroupName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "resourceGroupName", valid_568573
  var valid_568574 = path.getOrDefault("managerName")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "managerName", valid_568574
  var valid_568575 = path.getOrDefault("subscriptionId")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "subscriptionId", valid_568575
  var valid_568576 = path.getOrDefault("backupPolicyName")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "backupPolicyName", valid_568576
  var valid_568577 = path.getOrDefault("deviceName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "deviceName", valid_568577
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568578 = query.getOrDefault("api-version")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "api-version", valid_568578
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568579: Call_BackupSchedulesListByBackupPolicy_568570;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the backup schedules in a backup policy.
  ## 
  let valid = call_568579.validator(path, query, header, formData, body)
  let scheme = call_568579.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568579.url(scheme.get, call_568579.host, call_568579.base,
                         call_568579.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568579, url, valid)

proc call*(call_568580: Call_BackupSchedulesListByBackupPolicy_568570;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; backupPolicyName: string; deviceName: string): Recallable =
  ## backupSchedulesListByBackupPolicy
  ## Gets all the backup schedules in a backup policy.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupPolicyName: string (required)
  ##                   : The backup policy name.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568581 = newJObject()
  var query_568582 = newJObject()
  add(path_568581, "resourceGroupName", newJString(resourceGroupName))
  add(query_568582, "api-version", newJString(apiVersion))
  add(path_568581, "managerName", newJString(managerName))
  add(path_568581, "subscriptionId", newJString(subscriptionId))
  add(path_568581, "backupPolicyName", newJString(backupPolicyName))
  add(path_568581, "deviceName", newJString(deviceName))
  result = call_568580.call(path_568581, query_568582, nil, nil, nil)

var backupSchedulesListByBackupPolicy* = Call_BackupSchedulesListByBackupPolicy_568570(
    name: "backupSchedulesListByBackupPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/schedules",
    validator: validate_BackupSchedulesListByBackupPolicy_568571, base: "",
    url: url_BackupSchedulesListByBackupPolicy_568572, schemes: {Scheme.Https})
type
  Call_BackupSchedulesCreateOrUpdate_568597 = ref object of OpenApiRestCall_567667
proc url_BackupSchedulesCreateOrUpdate_568599(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  assert "backupScheduleName" in path,
        "`backupScheduleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "backupScheduleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupSchedulesCreateOrUpdate_568598(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the backup schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   backupScheduleName: JString (required)
  ##                     : The backup schedule name.
  ##   backupPolicyName: JString (required)
  ##                   : The backup policy name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568600 = path.getOrDefault("resourceGroupName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "resourceGroupName", valid_568600
  var valid_568601 = path.getOrDefault("managerName")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "managerName", valid_568601
  var valid_568602 = path.getOrDefault("subscriptionId")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "subscriptionId", valid_568602
  var valid_568603 = path.getOrDefault("backupScheduleName")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "backupScheduleName", valid_568603
  var valid_568604 = path.getOrDefault("backupPolicyName")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "backupPolicyName", valid_568604
  var valid_568605 = path.getOrDefault("deviceName")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "deviceName", valid_568605
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568606 = query.getOrDefault("api-version")
  valid_568606 = validateParameter(valid_568606, JString, required = true,
                                 default = nil)
  if valid_568606 != nil:
    section.add "api-version", valid_568606
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The backup schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568608: Call_BackupSchedulesCreateOrUpdate_568597; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the backup schedule.
  ## 
  let valid = call_568608.validator(path, query, header, formData, body)
  let scheme = call_568608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568608.url(scheme.get, call_568608.host, call_568608.base,
                         call_568608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568608, url, valid)

proc call*(call_568609: Call_BackupSchedulesCreateOrUpdate_568597;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; backupScheduleName: string;
          backupPolicyName: string; parameters: JsonNode; deviceName: string): Recallable =
  ## backupSchedulesCreateOrUpdate
  ## Creates or updates the backup schedule.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupScheduleName: string (required)
  ##                     : The backup schedule name.
  ##   backupPolicyName: string (required)
  ##                   : The backup policy name.
  ##   parameters: JObject (required)
  ##             : The backup schedule.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568610 = newJObject()
  var query_568611 = newJObject()
  var body_568612 = newJObject()
  add(path_568610, "resourceGroupName", newJString(resourceGroupName))
  add(query_568611, "api-version", newJString(apiVersion))
  add(path_568610, "managerName", newJString(managerName))
  add(path_568610, "subscriptionId", newJString(subscriptionId))
  add(path_568610, "backupScheduleName", newJString(backupScheduleName))
  add(path_568610, "backupPolicyName", newJString(backupPolicyName))
  if parameters != nil:
    body_568612 = parameters
  add(path_568610, "deviceName", newJString(deviceName))
  result = call_568609.call(path_568610, query_568611, nil, nil, body_568612)

var backupSchedulesCreateOrUpdate* = Call_BackupSchedulesCreateOrUpdate_568597(
    name: "backupSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/schedules/{backupScheduleName}",
    validator: validate_BackupSchedulesCreateOrUpdate_568598, base: "",
    url: url_BackupSchedulesCreateOrUpdate_568599, schemes: {Scheme.Https})
type
  Call_BackupSchedulesGet_568583 = ref object of OpenApiRestCall_567667
proc url_BackupSchedulesGet_568585(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  assert "backupScheduleName" in path,
        "`backupScheduleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "backupScheduleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupSchedulesGet_568584(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the properties of the specified backup schedule name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   backupScheduleName: JString (required)
  ##                     : The name of the backup schedule to be fetched
  ##   backupPolicyName: JString (required)
  ##                   : The backup policy name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568586 = path.getOrDefault("resourceGroupName")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "resourceGroupName", valid_568586
  var valid_568587 = path.getOrDefault("managerName")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "managerName", valid_568587
  var valid_568588 = path.getOrDefault("subscriptionId")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "subscriptionId", valid_568588
  var valid_568589 = path.getOrDefault("backupScheduleName")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "backupScheduleName", valid_568589
  var valid_568590 = path.getOrDefault("backupPolicyName")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "backupPolicyName", valid_568590
  var valid_568591 = path.getOrDefault("deviceName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "deviceName", valid_568591
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568592 = query.getOrDefault("api-version")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "api-version", valid_568592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568593: Call_BackupSchedulesGet_568583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified backup schedule name.
  ## 
  let valid = call_568593.validator(path, query, header, formData, body)
  let scheme = call_568593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568593.url(scheme.get, call_568593.host, call_568593.base,
                         call_568593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568593, url, valid)

proc call*(call_568594: Call_BackupSchedulesGet_568583; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          backupScheduleName: string; backupPolicyName: string; deviceName: string): Recallable =
  ## backupSchedulesGet
  ## Gets the properties of the specified backup schedule name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupScheduleName: string (required)
  ##                     : The name of the backup schedule to be fetched
  ##   backupPolicyName: string (required)
  ##                   : The backup policy name.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568595 = newJObject()
  var query_568596 = newJObject()
  add(path_568595, "resourceGroupName", newJString(resourceGroupName))
  add(query_568596, "api-version", newJString(apiVersion))
  add(path_568595, "managerName", newJString(managerName))
  add(path_568595, "subscriptionId", newJString(subscriptionId))
  add(path_568595, "backupScheduleName", newJString(backupScheduleName))
  add(path_568595, "backupPolicyName", newJString(backupPolicyName))
  add(path_568595, "deviceName", newJString(deviceName))
  result = call_568594.call(path_568595, query_568596, nil, nil, nil)

var backupSchedulesGet* = Call_BackupSchedulesGet_568583(
    name: "backupSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/schedules/{backupScheduleName}",
    validator: validate_BackupSchedulesGet_568584, base: "",
    url: url_BackupSchedulesGet_568585, schemes: {Scheme.Https})
type
  Call_BackupSchedulesDelete_568613 = ref object of OpenApiRestCall_567667
proc url_BackupSchedulesDelete_568615(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupPolicyName" in path,
        "`backupPolicyName` is a required path parameter"
  assert "backupScheduleName" in path,
        "`backupScheduleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "backupPolicyName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "backupScheduleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupSchedulesDelete_568614(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the backup schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   backupScheduleName: JString (required)
  ##                     : The name the backup schedule.
  ##   backupPolicyName: JString (required)
  ##                   : The backup policy name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568616 = path.getOrDefault("resourceGroupName")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "resourceGroupName", valid_568616
  var valid_568617 = path.getOrDefault("managerName")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "managerName", valid_568617
  var valid_568618 = path.getOrDefault("subscriptionId")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "subscriptionId", valid_568618
  var valid_568619 = path.getOrDefault("backupScheduleName")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "backupScheduleName", valid_568619
  var valid_568620 = path.getOrDefault("backupPolicyName")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "backupPolicyName", valid_568620
  var valid_568621 = path.getOrDefault("deviceName")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "deviceName", valid_568621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568622 = query.getOrDefault("api-version")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "api-version", valid_568622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568623: Call_BackupSchedulesDelete_568613; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup schedule.
  ## 
  let valid = call_568623.validator(path, query, header, formData, body)
  let scheme = call_568623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568623.url(scheme.get, call_568623.host, call_568623.base,
                         call_568623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568623, url, valid)

proc call*(call_568624: Call_BackupSchedulesDelete_568613;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; backupScheduleName: string;
          backupPolicyName: string; deviceName: string): Recallable =
  ## backupSchedulesDelete
  ## Deletes the backup schedule.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupScheduleName: string (required)
  ##                     : The name the backup schedule.
  ##   backupPolicyName: string (required)
  ##                   : The backup policy name.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568625 = newJObject()
  var query_568626 = newJObject()
  add(path_568625, "resourceGroupName", newJString(resourceGroupName))
  add(query_568626, "api-version", newJString(apiVersion))
  add(path_568625, "managerName", newJString(managerName))
  add(path_568625, "subscriptionId", newJString(subscriptionId))
  add(path_568625, "backupScheduleName", newJString(backupScheduleName))
  add(path_568625, "backupPolicyName", newJString(backupPolicyName))
  add(path_568625, "deviceName", newJString(deviceName))
  result = call_568624.call(path_568625, query_568626, nil, nil, nil)

var backupSchedulesDelete* = Call_BackupSchedulesDelete_568613(
    name: "backupSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/schedules/{backupScheduleName}",
    validator: validate_BackupSchedulesDelete_568614, base: "",
    url: url_BackupSchedulesDelete_568615, schemes: {Scheme.Https})
type
  Call_BackupsListByDevice_568627 = ref object of OpenApiRestCall_567667
proc url_BackupsListByDevice_568629(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsListByDevice_568628(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves all the backups in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568630 = path.getOrDefault("resourceGroupName")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "resourceGroupName", valid_568630
  var valid_568631 = path.getOrDefault("managerName")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "managerName", valid_568631
  var valid_568632 = path.getOrDefault("subscriptionId")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "subscriptionId", valid_568632
  var valid_568633 = path.getOrDefault("deviceName")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "deviceName", valid_568633
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568634 = query.getOrDefault("api-version")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "api-version", valid_568634
  var valid_568635 = query.getOrDefault("$filter")
  valid_568635 = validateParameter(valid_568635, JString, required = false,
                                 default = nil)
  if valid_568635 != nil:
    section.add "$filter", valid_568635
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568636: Call_BackupsListByDevice_568627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the backups in a device.
  ## 
  let valid = call_568636.validator(path, query, header, formData, body)
  let scheme = call_568636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568636.url(scheme.get, call_568636.host, call_568636.base,
                         call_568636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568636, url, valid)

proc call*(call_568637: Call_BackupsListByDevice_568627; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          deviceName: string; Filter: string = ""): Recallable =
  ## backupsListByDevice
  ## Retrieves all the backups in a device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   Filter: string
  ##         : OData Filter options
  ##   deviceName: string (required)
  ##             : The device name
  var path_568638 = newJObject()
  var query_568639 = newJObject()
  add(path_568638, "resourceGroupName", newJString(resourceGroupName))
  add(query_568639, "api-version", newJString(apiVersion))
  add(path_568638, "managerName", newJString(managerName))
  add(path_568638, "subscriptionId", newJString(subscriptionId))
  add(query_568639, "$filter", newJString(Filter))
  add(path_568638, "deviceName", newJString(deviceName))
  result = call_568637.call(path_568638, query_568639, nil, nil, nil)

var backupsListByDevice* = Call_BackupsListByDevice_568627(
    name: "backupsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups",
    validator: validate_BackupsListByDevice_568628, base: "",
    url: url_BackupsListByDevice_568629, schemes: {Scheme.Https})
type
  Call_BackupsDelete_568640 = ref object of OpenApiRestCall_567667
proc url_BackupsDelete_568642(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupName" in path, "`backupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backups/"),
               (kind: VariableSegment, value: "backupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsDelete_568641(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the backup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   backupName: JString (required)
  ##             : The backup name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568643 = path.getOrDefault("resourceGroupName")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "resourceGroupName", valid_568643
  var valid_568644 = path.getOrDefault("managerName")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "managerName", valid_568644
  var valid_568645 = path.getOrDefault("subscriptionId")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "subscriptionId", valid_568645
  var valid_568646 = path.getOrDefault("backupName")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "backupName", valid_568646
  var valid_568647 = path.getOrDefault("deviceName")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "deviceName", valid_568647
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568648 = query.getOrDefault("api-version")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "api-version", valid_568648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568649: Call_BackupsDelete_568640; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup.
  ## 
  let valid = call_568649.validator(path, query, header, formData, body)
  let scheme = call_568649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568649.url(scheme.get, call_568649.host, call_568649.base,
                         call_568649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568649, url, valid)

proc call*(call_568650: Call_BackupsDelete_568640; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          backupName: string; deviceName: string): Recallable =
  ## backupsDelete
  ## Deletes the backup.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupName: string (required)
  ##             : The backup name.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568651 = newJObject()
  var query_568652 = newJObject()
  add(path_568651, "resourceGroupName", newJString(resourceGroupName))
  add(query_568652, "api-version", newJString(apiVersion))
  add(path_568651, "managerName", newJString(managerName))
  add(path_568651, "subscriptionId", newJString(subscriptionId))
  add(path_568651, "backupName", newJString(backupName))
  add(path_568651, "deviceName", newJString(deviceName))
  result = call_568650.call(path_568651, query_568652, nil, nil, nil)

var backupsDelete* = Call_BackupsDelete_568640(name: "backupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}",
    validator: validate_BackupsDelete_568641, base: "", url: url_BackupsDelete_568642,
    schemes: {Scheme.Https})
type
  Call_BackupsClone_568653 = ref object of OpenApiRestCall_567667
proc url_BackupsClone_568655(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupName" in path, "`backupName` is a required path parameter"
  assert "backupElementName" in path,
        "`backupElementName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backups/"),
               (kind: VariableSegment, value: "backupName"),
               (kind: ConstantSegment, value: "/elements/"),
               (kind: VariableSegment, value: "backupElementName"),
               (kind: ConstantSegment, value: "/clone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsClone_568654(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Clones the backup element as a new volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   backupElementName: JString (required)
  ##                    : The backup element name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   backupName: JString (required)
  ##             : The backup name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568656 = path.getOrDefault("resourceGroupName")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "resourceGroupName", valid_568656
  var valid_568657 = path.getOrDefault("managerName")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "managerName", valid_568657
  var valid_568658 = path.getOrDefault("backupElementName")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "backupElementName", valid_568658
  var valid_568659 = path.getOrDefault("subscriptionId")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "subscriptionId", valid_568659
  var valid_568660 = path.getOrDefault("backupName")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "backupName", valid_568660
  var valid_568661 = path.getOrDefault("deviceName")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "deviceName", valid_568661
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568662 = query.getOrDefault("api-version")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "api-version", valid_568662
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The clone request object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568664: Call_BackupsClone_568653; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clones the backup element as a new volume.
  ## 
  let valid = call_568664.validator(path, query, header, formData, body)
  let scheme = call_568664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568664.url(scheme.get, call_568664.host, call_568664.base,
                         call_568664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568664, url, valid)

proc call*(call_568665: Call_BackupsClone_568653; resourceGroupName: string;
          apiVersion: string; managerName: string; backupElementName: string;
          subscriptionId: string; backupName: string; parameters: JsonNode;
          deviceName: string): Recallable =
  ## backupsClone
  ## Clones the backup element as a new volume.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   backupElementName: string (required)
  ##                    : The backup element name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupName: string (required)
  ##             : The backup name.
  ##   parameters: JObject (required)
  ##             : The clone request object.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568666 = newJObject()
  var query_568667 = newJObject()
  var body_568668 = newJObject()
  add(path_568666, "resourceGroupName", newJString(resourceGroupName))
  add(query_568667, "api-version", newJString(apiVersion))
  add(path_568666, "managerName", newJString(managerName))
  add(path_568666, "backupElementName", newJString(backupElementName))
  add(path_568666, "subscriptionId", newJString(subscriptionId))
  add(path_568666, "backupName", newJString(backupName))
  if parameters != nil:
    body_568668 = parameters
  add(path_568666, "deviceName", newJString(deviceName))
  result = call_568665.call(path_568666, query_568667, nil, nil, body_568668)

var backupsClone* = Call_BackupsClone_568653(name: "backupsClone",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}/elements/{backupElementName}/clone",
    validator: validate_BackupsClone_568654, base: "", url: url_BackupsClone_568655,
    schemes: {Scheme.Https})
type
  Call_BackupsRestore_568669 = ref object of OpenApiRestCall_567667
proc url_BackupsRestore_568671(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "backupName" in path, "`backupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backups/"),
               (kind: VariableSegment, value: "backupName"),
               (kind: ConstantSegment, value: "/restore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsRestore_568670(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Restores the backup on the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   backupName: JString (required)
  ##             : The backupSet name
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568672 = path.getOrDefault("resourceGroupName")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "resourceGroupName", valid_568672
  var valid_568673 = path.getOrDefault("managerName")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "managerName", valid_568673
  var valid_568674 = path.getOrDefault("subscriptionId")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "subscriptionId", valid_568674
  var valid_568675 = path.getOrDefault("backupName")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "backupName", valid_568675
  var valid_568676 = path.getOrDefault("deviceName")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "deviceName", valid_568676
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568677 = query.getOrDefault("api-version")
  valid_568677 = validateParameter(valid_568677, JString, required = true,
                                 default = nil)
  if valid_568677 != nil:
    section.add "api-version", valid_568677
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568678: Call_BackupsRestore_568669; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the backup on the device.
  ## 
  let valid = call_568678.validator(path, query, header, formData, body)
  let scheme = call_568678.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568678.url(scheme.get, call_568678.host, call_568678.base,
                         call_568678.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568678, url, valid)

proc call*(call_568679: Call_BackupsRestore_568669; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          backupName: string; deviceName: string): Recallable =
  ## backupsRestore
  ## Restores the backup on the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupName: string (required)
  ##             : The backupSet name
  ##   deviceName: string (required)
  ##             : The device name
  var path_568680 = newJObject()
  var query_568681 = newJObject()
  add(path_568680, "resourceGroupName", newJString(resourceGroupName))
  add(query_568681, "api-version", newJString(apiVersion))
  add(path_568680, "managerName", newJString(managerName))
  add(path_568680, "subscriptionId", newJString(subscriptionId))
  add(path_568680, "backupName", newJString(backupName))
  add(path_568680, "deviceName", newJString(deviceName))
  result = call_568679.call(path_568680, query_568681, nil, nil, nil)

var backupsRestore* = Call_BackupsRestore_568669(name: "backupsRestore",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}/restore",
    validator: validate_BackupsRestore_568670, base: "", url: url_BackupsRestore_568671,
    schemes: {Scheme.Https})
type
  Call_DevicesDeactivate_568682 = ref object of OpenApiRestCall_567667
proc url_DevicesDeactivate_568684(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/deactivate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesDeactivate_568683(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deactivates the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568685 = path.getOrDefault("resourceGroupName")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "resourceGroupName", valid_568685
  var valid_568686 = path.getOrDefault("managerName")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "managerName", valid_568686
  var valid_568687 = path.getOrDefault("subscriptionId")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "subscriptionId", valid_568687
  var valid_568688 = path.getOrDefault("deviceName")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "deviceName", valid_568688
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568689 = query.getOrDefault("api-version")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "api-version", valid_568689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568690: Call_DevicesDeactivate_568682; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deactivates the device.
  ## 
  let valid = call_568690.validator(path, query, header, formData, body)
  let scheme = call_568690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568690.url(scheme.get, call_568690.host, call_568690.base,
                         call_568690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568690, url, valid)

proc call*(call_568691: Call_DevicesDeactivate_568682; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## devicesDeactivate
  ## Deactivates the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568692 = newJObject()
  var query_568693 = newJObject()
  add(path_568692, "resourceGroupName", newJString(resourceGroupName))
  add(query_568693, "api-version", newJString(apiVersion))
  add(path_568692, "managerName", newJString(managerName))
  add(path_568692, "subscriptionId", newJString(subscriptionId))
  add(path_568692, "deviceName", newJString(deviceName))
  result = call_568691.call(path_568692, query_568693, nil, nil, nil)

var devicesDeactivate* = Call_DevicesDeactivate_568682(name: "devicesDeactivate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/deactivate",
    validator: validate_DevicesDeactivate_568683, base: "",
    url: url_DevicesDeactivate_568684, schemes: {Scheme.Https})
type
  Call_HardwareComponentGroupsListByDevice_568694 = ref object of OpenApiRestCall_567667
proc url_HardwareComponentGroupsListByDevice_568696(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/hardwareComponentGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HardwareComponentGroupsListByDevice_568695(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the hardware component groups at device-level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568697 = path.getOrDefault("resourceGroupName")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = nil)
  if valid_568697 != nil:
    section.add "resourceGroupName", valid_568697
  var valid_568698 = path.getOrDefault("managerName")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "managerName", valid_568698
  var valid_568699 = path.getOrDefault("subscriptionId")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "subscriptionId", valid_568699
  var valid_568700 = path.getOrDefault("deviceName")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "deviceName", valid_568700
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568701 = query.getOrDefault("api-version")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "api-version", valid_568701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568702: Call_HardwareComponentGroupsListByDevice_568694;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the hardware component groups at device-level.
  ## 
  let valid = call_568702.validator(path, query, header, formData, body)
  let scheme = call_568702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568702.url(scheme.get, call_568702.host, call_568702.base,
                         call_568702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568702, url, valid)

proc call*(call_568703: Call_HardwareComponentGroupsListByDevice_568694;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## hardwareComponentGroupsListByDevice
  ## Lists the hardware component groups at device-level.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568704 = newJObject()
  var query_568705 = newJObject()
  add(path_568704, "resourceGroupName", newJString(resourceGroupName))
  add(query_568705, "api-version", newJString(apiVersion))
  add(path_568704, "managerName", newJString(managerName))
  add(path_568704, "subscriptionId", newJString(subscriptionId))
  add(path_568704, "deviceName", newJString(deviceName))
  result = call_568703.call(path_568704, query_568705, nil, nil, nil)

var hardwareComponentGroupsListByDevice* = Call_HardwareComponentGroupsListByDevice_568694(
    name: "hardwareComponentGroupsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/hardwareComponentGroups",
    validator: validate_HardwareComponentGroupsListByDevice_568695, base: "",
    url: url_HardwareComponentGroupsListByDevice_568696, schemes: {Scheme.Https})
type
  Call_HardwareComponentGroupsChangeControllerPowerState_568706 = ref object of OpenApiRestCall_567667
proc url_HardwareComponentGroupsChangeControllerPowerState_568708(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "hardwareComponentGroupName" in path,
        "`hardwareComponentGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/hardwareComponentGroups/"),
               (kind: VariableSegment, value: "hardwareComponentGroupName"),
               (kind: ConstantSegment, value: "/changeControllerPowerState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HardwareComponentGroupsChangeControllerPowerState_568707(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Changes the power state of the controller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   hardwareComponentGroupName: JString (required)
  ##                             : The hardware component group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568709 = path.getOrDefault("resourceGroupName")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "resourceGroupName", valid_568709
  var valid_568710 = path.getOrDefault("managerName")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "managerName", valid_568710
  var valid_568711 = path.getOrDefault("hardwareComponentGroupName")
  valid_568711 = validateParameter(valid_568711, JString, required = true,
                                 default = nil)
  if valid_568711 != nil:
    section.add "hardwareComponentGroupName", valid_568711
  var valid_568712 = path.getOrDefault("subscriptionId")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "subscriptionId", valid_568712
  var valid_568713 = path.getOrDefault("deviceName")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "deviceName", valid_568713
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568714 = query.getOrDefault("api-version")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "api-version", valid_568714
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The controller power state change request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568716: Call_HardwareComponentGroupsChangeControllerPowerState_568706;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the power state of the controller.
  ## 
  let valid = call_568716.validator(path, query, header, formData, body)
  let scheme = call_568716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568716.url(scheme.get, call_568716.host, call_568716.base,
                         call_568716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568716, url, valid)

proc call*(call_568717: Call_HardwareComponentGroupsChangeControllerPowerState_568706;
          resourceGroupName: string; apiVersion: string; managerName: string;
          hardwareComponentGroupName: string; subscriptionId: string;
          parameters: JsonNode; deviceName: string): Recallable =
  ## hardwareComponentGroupsChangeControllerPowerState
  ## Changes the power state of the controller.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   hardwareComponentGroupName: string (required)
  ##                             : The hardware component group name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The controller power state change request.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568718 = newJObject()
  var query_568719 = newJObject()
  var body_568720 = newJObject()
  add(path_568718, "resourceGroupName", newJString(resourceGroupName))
  add(query_568719, "api-version", newJString(apiVersion))
  add(path_568718, "managerName", newJString(managerName))
  add(path_568718, "hardwareComponentGroupName",
      newJString(hardwareComponentGroupName))
  add(path_568718, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568720 = parameters
  add(path_568718, "deviceName", newJString(deviceName))
  result = call_568717.call(path_568718, query_568719, nil, nil, body_568720)

var hardwareComponentGroupsChangeControllerPowerState* = Call_HardwareComponentGroupsChangeControllerPowerState_568706(
    name: "hardwareComponentGroupsChangeControllerPowerState",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/hardwareComponentGroups/{hardwareComponentGroupName}/changeControllerPowerState",
    validator: validate_HardwareComponentGroupsChangeControllerPowerState_568707,
    base: "", url: url_HardwareComponentGroupsChangeControllerPowerState_568708,
    schemes: {Scheme.Https})
type
  Call_DevicesInstallUpdates_568721 = ref object of OpenApiRestCall_567667
proc url_DevicesInstallUpdates_568723(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/installUpdates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesInstallUpdates_568722(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Downloads and installs the updates on the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568724 = path.getOrDefault("resourceGroupName")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "resourceGroupName", valid_568724
  var valid_568725 = path.getOrDefault("managerName")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "managerName", valid_568725
  var valid_568726 = path.getOrDefault("subscriptionId")
  valid_568726 = validateParameter(valid_568726, JString, required = true,
                                 default = nil)
  if valid_568726 != nil:
    section.add "subscriptionId", valid_568726
  var valid_568727 = path.getOrDefault("deviceName")
  valid_568727 = validateParameter(valid_568727, JString, required = true,
                                 default = nil)
  if valid_568727 != nil:
    section.add "deviceName", valid_568727
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568728 = query.getOrDefault("api-version")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "api-version", valid_568728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568729: Call_DevicesInstallUpdates_568721; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads and installs the updates on the device.
  ## 
  let valid = call_568729.validator(path, query, header, formData, body)
  let scheme = call_568729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568729.url(scheme.get, call_568729.host, call_568729.base,
                         call_568729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568729, url, valid)

proc call*(call_568730: Call_DevicesInstallUpdates_568721;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesInstallUpdates
  ## Downloads and installs the updates on the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568731 = newJObject()
  var query_568732 = newJObject()
  add(path_568731, "resourceGroupName", newJString(resourceGroupName))
  add(query_568732, "api-version", newJString(apiVersion))
  add(path_568731, "managerName", newJString(managerName))
  add(path_568731, "subscriptionId", newJString(subscriptionId))
  add(path_568731, "deviceName", newJString(deviceName))
  result = call_568730.call(path_568731, query_568732, nil, nil, nil)

var devicesInstallUpdates* = Call_DevicesInstallUpdates_568721(
    name: "devicesInstallUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/installUpdates",
    validator: validate_DevicesInstallUpdates_568722, base: "",
    url: url_DevicesInstallUpdates_568723, schemes: {Scheme.Https})
type
  Call_JobsListByDevice_568733 = ref object of OpenApiRestCall_567667
proc url_JobsListByDevice_568735(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListByDevice_568734(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets all the jobs for specified device. With optional OData query parameters, a filtered set of jobs is returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568736 = path.getOrDefault("resourceGroupName")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "resourceGroupName", valid_568736
  var valid_568737 = path.getOrDefault("managerName")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "managerName", valid_568737
  var valid_568738 = path.getOrDefault("subscriptionId")
  valid_568738 = validateParameter(valid_568738, JString, required = true,
                                 default = nil)
  if valid_568738 != nil:
    section.add "subscriptionId", valid_568738
  var valid_568739 = path.getOrDefault("deviceName")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "deviceName", valid_568739
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568740 = query.getOrDefault("api-version")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "api-version", valid_568740
  var valid_568741 = query.getOrDefault("$filter")
  valid_568741 = validateParameter(valid_568741, JString, required = false,
                                 default = nil)
  if valid_568741 != nil:
    section.add "$filter", valid_568741
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568742: Call_JobsListByDevice_568733; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the jobs for specified device. With optional OData query parameters, a filtered set of jobs is returned.
  ## 
  let valid = call_568742.validator(path, query, header, formData, body)
  let scheme = call_568742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568742.url(scheme.get, call_568742.host, call_568742.base,
                         call_568742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568742, url, valid)

proc call*(call_568743: Call_JobsListByDevice_568733; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          deviceName: string; Filter: string = ""): Recallable =
  ## jobsListByDevice
  ## Gets all the jobs for specified device. With optional OData query parameters, a filtered set of jobs is returned.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   Filter: string
  ##         : OData Filter options
  ##   deviceName: string (required)
  ##             : The device name
  var path_568744 = newJObject()
  var query_568745 = newJObject()
  add(path_568744, "resourceGroupName", newJString(resourceGroupName))
  add(query_568745, "api-version", newJString(apiVersion))
  add(path_568744, "managerName", newJString(managerName))
  add(path_568744, "subscriptionId", newJString(subscriptionId))
  add(query_568745, "$filter", newJString(Filter))
  add(path_568744, "deviceName", newJString(deviceName))
  result = call_568743.call(path_568744, query_568745, nil, nil, nil)

var jobsListByDevice* = Call_JobsListByDevice_568733(name: "jobsListByDevice",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs",
    validator: validate_JobsListByDevice_568734, base: "",
    url: url_JobsListByDevice_568735, schemes: {Scheme.Https})
type
  Call_JobsGet_568746 = ref object of OpenApiRestCall_567667
proc url_JobsGet_568748(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsGet_568747(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the specified job name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   jobName: JString (required)
  ##          : The job Name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568749 = path.getOrDefault("resourceGroupName")
  valid_568749 = validateParameter(valid_568749, JString, required = true,
                                 default = nil)
  if valid_568749 != nil:
    section.add "resourceGroupName", valid_568749
  var valid_568750 = path.getOrDefault("managerName")
  valid_568750 = validateParameter(valid_568750, JString, required = true,
                                 default = nil)
  if valid_568750 != nil:
    section.add "managerName", valid_568750
  var valid_568751 = path.getOrDefault("subscriptionId")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "subscriptionId", valid_568751
  var valid_568752 = path.getOrDefault("jobName")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "jobName", valid_568752
  var valid_568753 = path.getOrDefault("deviceName")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "deviceName", valid_568753
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568754 = query.getOrDefault("api-version")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "api-version", valid_568754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568755: Call_JobsGet_568746; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the specified job name.
  ## 
  let valid = call_568755.validator(path, query, header, formData, body)
  let scheme = call_568755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568755.url(scheme.get, call_568755.host, call_568755.base,
                         call_568755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568755, url, valid)

proc call*(call_568756: Call_JobsGet_568746; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          jobName: string; deviceName: string): Recallable =
  ## jobsGet
  ## Gets the details of the specified job name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   jobName: string (required)
  ##          : The job Name.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568757 = newJObject()
  var query_568758 = newJObject()
  add(path_568757, "resourceGroupName", newJString(resourceGroupName))
  add(query_568758, "api-version", newJString(apiVersion))
  add(path_568757, "managerName", newJString(managerName))
  add(path_568757, "subscriptionId", newJString(subscriptionId))
  add(path_568757, "jobName", newJString(jobName))
  add(path_568757, "deviceName", newJString(deviceName))
  result = call_568756.call(path_568757, query_568758, nil, nil, nil)

var jobsGet* = Call_JobsGet_568746(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs/{jobName}",
                                validator: validate_JobsGet_568747, base: "",
                                url: url_JobsGet_568748, schemes: {Scheme.Https})
type
  Call_JobsCancel_568759 = ref object of OpenApiRestCall_567667
proc url_JobsCancel_568761(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsCancel_568760(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a job on the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   jobName: JString (required)
  ##          : The jobName.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568762 = path.getOrDefault("resourceGroupName")
  valid_568762 = validateParameter(valid_568762, JString, required = true,
                                 default = nil)
  if valid_568762 != nil:
    section.add "resourceGroupName", valid_568762
  var valid_568763 = path.getOrDefault("managerName")
  valid_568763 = validateParameter(valid_568763, JString, required = true,
                                 default = nil)
  if valid_568763 != nil:
    section.add "managerName", valid_568763
  var valid_568764 = path.getOrDefault("subscriptionId")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "subscriptionId", valid_568764
  var valid_568765 = path.getOrDefault("jobName")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "jobName", valid_568765
  var valid_568766 = path.getOrDefault("deviceName")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "deviceName", valid_568766
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568767 = query.getOrDefault("api-version")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "api-version", valid_568767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568768: Call_JobsCancel_568759; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a job on the device.
  ## 
  let valid = call_568768.validator(path, query, header, formData, body)
  let scheme = call_568768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568768.url(scheme.get, call_568768.host, call_568768.base,
                         call_568768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568768, url, valid)

proc call*(call_568769: Call_JobsCancel_568759; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          jobName: string; deviceName: string): Recallable =
  ## jobsCancel
  ## Cancels a job on the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   jobName: string (required)
  ##          : The jobName.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568770 = newJObject()
  var query_568771 = newJObject()
  add(path_568770, "resourceGroupName", newJString(resourceGroupName))
  add(query_568771, "api-version", newJString(apiVersion))
  add(path_568770, "managerName", newJString(managerName))
  add(path_568770, "subscriptionId", newJString(subscriptionId))
  add(path_568770, "jobName", newJString(jobName))
  add(path_568770, "deviceName", newJString(deviceName))
  result = call_568769.call(path_568770, query_568771, nil, nil, nil)

var jobsCancel* = Call_JobsCancel_568759(name: "jobsCancel",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs/{jobName}/cancel",
                                      validator: validate_JobsCancel_568760,
                                      base: "", url: url_JobsCancel_568761,
                                      schemes: {Scheme.Https})
type
  Call_DevicesListFailoverSets_568772 = ref object of OpenApiRestCall_567667
proc url_DevicesListFailoverSets_568774(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/listFailoverSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListFailoverSets_568773(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all failover sets for a given device and their eligibility for participating in a failover. A failover set refers to a set of volume containers that need to be failed-over as a single unit to maintain data integrity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568775 = path.getOrDefault("resourceGroupName")
  valid_568775 = validateParameter(valid_568775, JString, required = true,
                                 default = nil)
  if valid_568775 != nil:
    section.add "resourceGroupName", valid_568775
  var valid_568776 = path.getOrDefault("managerName")
  valid_568776 = validateParameter(valid_568776, JString, required = true,
                                 default = nil)
  if valid_568776 != nil:
    section.add "managerName", valid_568776
  var valid_568777 = path.getOrDefault("subscriptionId")
  valid_568777 = validateParameter(valid_568777, JString, required = true,
                                 default = nil)
  if valid_568777 != nil:
    section.add "subscriptionId", valid_568777
  var valid_568778 = path.getOrDefault("deviceName")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "deviceName", valid_568778
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568779 = query.getOrDefault("api-version")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "api-version", valid_568779
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568780: Call_DevicesListFailoverSets_568772; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all failover sets for a given device and their eligibility for participating in a failover. A failover set refers to a set of volume containers that need to be failed-over as a single unit to maintain data integrity.
  ## 
  let valid = call_568780.validator(path, query, header, formData, body)
  let scheme = call_568780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568780.url(scheme.get, call_568780.host, call_568780.base,
                         call_568780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568780, url, valid)

proc call*(call_568781: Call_DevicesListFailoverSets_568772;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesListFailoverSets
  ## Returns all failover sets for a given device and their eligibility for participating in a failover. A failover set refers to a set of volume containers that need to be failed-over as a single unit to maintain data integrity.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568782 = newJObject()
  var query_568783 = newJObject()
  add(path_568782, "resourceGroupName", newJString(resourceGroupName))
  add(query_568783, "api-version", newJString(apiVersion))
  add(path_568782, "managerName", newJString(managerName))
  add(path_568782, "subscriptionId", newJString(subscriptionId))
  add(path_568782, "deviceName", newJString(deviceName))
  result = call_568781.call(path_568782, query_568783, nil, nil, nil)

var devicesListFailoverSets* = Call_DevicesListFailoverSets_568772(
    name: "devicesListFailoverSets", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/listFailoverSets",
    validator: validate_DevicesListFailoverSets_568773, base: "",
    url: url_DevicesListFailoverSets_568774, schemes: {Scheme.Https})
type
  Call_DevicesListMetrics_568784 = ref object of OpenApiRestCall_567667
proc url_DevicesListMetrics_568786(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListMetrics_568785(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the metrics for the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568787 = path.getOrDefault("resourceGroupName")
  valid_568787 = validateParameter(valid_568787, JString, required = true,
                                 default = nil)
  if valid_568787 != nil:
    section.add "resourceGroupName", valid_568787
  var valid_568788 = path.getOrDefault("managerName")
  valid_568788 = validateParameter(valid_568788, JString, required = true,
                                 default = nil)
  if valid_568788 != nil:
    section.add "managerName", valid_568788
  var valid_568789 = path.getOrDefault("subscriptionId")
  valid_568789 = validateParameter(valid_568789, JString, required = true,
                                 default = nil)
  if valid_568789 != nil:
    section.add "subscriptionId", valid_568789
  var valid_568790 = path.getOrDefault("deviceName")
  valid_568790 = validateParameter(valid_568790, JString, required = true,
                                 default = nil)
  if valid_568790 != nil:
    section.add "deviceName", valid_568790
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString (required)
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568791 = query.getOrDefault("api-version")
  valid_568791 = validateParameter(valid_568791, JString, required = true,
                                 default = nil)
  if valid_568791 != nil:
    section.add "api-version", valid_568791
  var valid_568792 = query.getOrDefault("$filter")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "$filter", valid_568792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568793: Call_DevicesListMetrics_568784; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metrics for the specified device.
  ## 
  let valid = call_568793.validator(path, query, header, formData, body)
  let scheme = call_568793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568793.url(scheme.get, call_568793.host, call_568793.base,
                         call_568793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568793, url, valid)

proc call*(call_568794: Call_DevicesListMetrics_568784; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          Filter: string; deviceName: string): Recallable =
  ## devicesListMetrics
  ## Gets the metrics for the specified device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   Filter: string (required)
  ##         : OData Filter options
  ##   deviceName: string (required)
  ##             : The device name
  var path_568795 = newJObject()
  var query_568796 = newJObject()
  add(path_568795, "resourceGroupName", newJString(resourceGroupName))
  add(query_568796, "api-version", newJString(apiVersion))
  add(path_568795, "managerName", newJString(managerName))
  add(path_568795, "subscriptionId", newJString(subscriptionId))
  add(query_568796, "$filter", newJString(Filter))
  add(path_568795, "deviceName", newJString(deviceName))
  result = call_568794.call(path_568795, query_568796, nil, nil, nil)

var devicesListMetrics* = Call_DevicesListMetrics_568784(
    name: "devicesListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/metrics",
    validator: validate_DevicesListMetrics_568785, base: "",
    url: url_DevicesListMetrics_568786, schemes: {Scheme.Https})
type
  Call_DevicesListMetricDefinition_568797 = ref object of OpenApiRestCall_567667
proc url_DevicesListMetricDefinition_568799(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListMetricDefinition_568798(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metric definitions for the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568800 = path.getOrDefault("resourceGroupName")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "resourceGroupName", valid_568800
  var valid_568801 = path.getOrDefault("managerName")
  valid_568801 = validateParameter(valid_568801, JString, required = true,
                                 default = nil)
  if valid_568801 != nil:
    section.add "managerName", valid_568801
  var valid_568802 = path.getOrDefault("subscriptionId")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = nil)
  if valid_568802 != nil:
    section.add "subscriptionId", valid_568802
  var valid_568803 = path.getOrDefault("deviceName")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "deviceName", valid_568803
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568804 = query.getOrDefault("api-version")
  valid_568804 = validateParameter(valid_568804, JString, required = true,
                                 default = nil)
  if valid_568804 != nil:
    section.add "api-version", valid_568804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568805: Call_DevicesListMetricDefinition_568797; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metric definitions for the specified device.
  ## 
  let valid = call_568805.validator(path, query, header, formData, body)
  let scheme = call_568805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568805.url(scheme.get, call_568805.host, call_568805.base,
                         call_568805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568805, url, valid)

proc call*(call_568806: Call_DevicesListMetricDefinition_568797;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesListMetricDefinition
  ## Gets the metric definitions for the specified device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568807 = newJObject()
  var query_568808 = newJObject()
  add(path_568807, "resourceGroupName", newJString(resourceGroupName))
  add(query_568808, "api-version", newJString(apiVersion))
  add(path_568807, "managerName", newJString(managerName))
  add(path_568807, "subscriptionId", newJString(subscriptionId))
  add(path_568807, "deviceName", newJString(deviceName))
  result = call_568806.call(path_568807, query_568808, nil, nil, nil)

var devicesListMetricDefinition* = Call_DevicesListMetricDefinition_568797(
    name: "devicesListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/metricsDefinitions",
    validator: validate_DevicesListMetricDefinition_568798, base: "",
    url: url_DevicesListMetricDefinition_568799, schemes: {Scheme.Https})
type
  Call_DeviceSettingsGetNetworkSettings_568809 = ref object of OpenApiRestCall_567667
proc url_DeviceSettingsGetNetworkSettings_568811(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/networkSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsGetNetworkSettings_568810(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the network settings of the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568812 = path.getOrDefault("resourceGroupName")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "resourceGroupName", valid_568812
  var valid_568813 = path.getOrDefault("managerName")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "managerName", valid_568813
  var valid_568814 = path.getOrDefault("subscriptionId")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "subscriptionId", valid_568814
  var valid_568815 = path.getOrDefault("deviceName")
  valid_568815 = validateParameter(valid_568815, JString, required = true,
                                 default = nil)
  if valid_568815 != nil:
    section.add "deviceName", valid_568815
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568816 = query.getOrDefault("api-version")
  valid_568816 = validateParameter(valid_568816, JString, required = true,
                                 default = nil)
  if valid_568816 != nil:
    section.add "api-version", valid_568816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568817: Call_DeviceSettingsGetNetworkSettings_568809;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the network settings of the specified device.
  ## 
  let valid = call_568817.validator(path, query, header, formData, body)
  let scheme = call_568817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568817.url(scheme.get, call_568817.host, call_568817.base,
                         call_568817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568817, url, valid)

proc call*(call_568818: Call_DeviceSettingsGetNetworkSettings_568809;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## deviceSettingsGetNetworkSettings
  ## Gets the network settings of the specified device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568819 = newJObject()
  var query_568820 = newJObject()
  add(path_568819, "resourceGroupName", newJString(resourceGroupName))
  add(query_568820, "api-version", newJString(apiVersion))
  add(path_568819, "managerName", newJString(managerName))
  add(path_568819, "subscriptionId", newJString(subscriptionId))
  add(path_568819, "deviceName", newJString(deviceName))
  result = call_568818.call(path_568819, query_568820, nil, nil, nil)

var deviceSettingsGetNetworkSettings* = Call_DeviceSettingsGetNetworkSettings_568809(
    name: "deviceSettingsGetNetworkSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/networkSettings/default",
    validator: validate_DeviceSettingsGetNetworkSettings_568810, base: "",
    url: url_DeviceSettingsGetNetworkSettings_568811, schemes: {Scheme.Https})
type
  Call_DeviceSettingsUpdateNetworkSettings_568821 = ref object of OpenApiRestCall_567667
proc url_DeviceSettingsUpdateNetworkSettings_568823(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/networkSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsUpdateNetworkSettings_568822(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the network settings on the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568824 = path.getOrDefault("resourceGroupName")
  valid_568824 = validateParameter(valid_568824, JString, required = true,
                                 default = nil)
  if valid_568824 != nil:
    section.add "resourceGroupName", valid_568824
  var valid_568825 = path.getOrDefault("managerName")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "managerName", valid_568825
  var valid_568826 = path.getOrDefault("subscriptionId")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "subscriptionId", valid_568826
  var valid_568827 = path.getOrDefault("deviceName")
  valid_568827 = validateParameter(valid_568827, JString, required = true,
                                 default = nil)
  if valid_568827 != nil:
    section.add "deviceName", valid_568827
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568828 = query.getOrDefault("api-version")
  valid_568828 = validateParameter(valid_568828, JString, required = true,
                                 default = nil)
  if valid_568828 != nil:
    section.add "api-version", valid_568828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The network settings to be updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568830: Call_DeviceSettingsUpdateNetworkSettings_568821;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the network settings on the specified device.
  ## 
  let valid = call_568830.validator(path, query, header, formData, body)
  let scheme = call_568830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568830.url(scheme.get, call_568830.host, call_568830.base,
                         call_568830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568830, url, valid)

proc call*(call_568831: Call_DeviceSettingsUpdateNetworkSettings_568821;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; parameters: JsonNode; deviceName: string): Recallable =
  ## deviceSettingsUpdateNetworkSettings
  ## Updates the network settings on the specified device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The network settings to be updated.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568832 = newJObject()
  var query_568833 = newJObject()
  var body_568834 = newJObject()
  add(path_568832, "resourceGroupName", newJString(resourceGroupName))
  add(query_568833, "api-version", newJString(apiVersion))
  add(path_568832, "managerName", newJString(managerName))
  add(path_568832, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568834 = parameters
  add(path_568832, "deviceName", newJString(deviceName))
  result = call_568831.call(path_568832, query_568833, nil, nil, body_568834)

var deviceSettingsUpdateNetworkSettings* = Call_DeviceSettingsUpdateNetworkSettings_568821(
    name: "deviceSettingsUpdateNetworkSettings", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/networkSettings/default",
    validator: validate_DeviceSettingsUpdateNetworkSettings_568822, base: "",
    url: url_DeviceSettingsUpdateNetworkSettings_568823, schemes: {Scheme.Https})
type
  Call_ManagersGetDevicePublicEncryptionKey_568835 = ref object of OpenApiRestCall_567667
proc url_ManagersGetDevicePublicEncryptionKey_568837(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/publicEncryptionKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGetDevicePublicEncryptionKey_568836(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the public encryption key of the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568838 = path.getOrDefault("resourceGroupName")
  valid_568838 = validateParameter(valid_568838, JString, required = true,
                                 default = nil)
  if valid_568838 != nil:
    section.add "resourceGroupName", valid_568838
  var valid_568839 = path.getOrDefault("managerName")
  valid_568839 = validateParameter(valid_568839, JString, required = true,
                                 default = nil)
  if valid_568839 != nil:
    section.add "managerName", valid_568839
  var valid_568840 = path.getOrDefault("subscriptionId")
  valid_568840 = validateParameter(valid_568840, JString, required = true,
                                 default = nil)
  if valid_568840 != nil:
    section.add "subscriptionId", valid_568840
  var valid_568841 = path.getOrDefault("deviceName")
  valid_568841 = validateParameter(valid_568841, JString, required = true,
                                 default = nil)
  if valid_568841 != nil:
    section.add "deviceName", valid_568841
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568842 = query.getOrDefault("api-version")
  valid_568842 = validateParameter(valid_568842, JString, required = true,
                                 default = nil)
  if valid_568842 != nil:
    section.add "api-version", valid_568842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568843: Call_ManagersGetDevicePublicEncryptionKey_568835;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the public encryption key of the device.
  ## 
  let valid = call_568843.validator(path, query, header, formData, body)
  let scheme = call_568843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568843.url(scheme.get, call_568843.host, call_568843.base,
                         call_568843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568843, url, valid)

proc call*(call_568844: Call_ManagersGetDevicePublicEncryptionKey_568835;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## managersGetDevicePublicEncryptionKey
  ## Returns the public encryption key of the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568845 = newJObject()
  var query_568846 = newJObject()
  add(path_568845, "resourceGroupName", newJString(resourceGroupName))
  add(query_568846, "api-version", newJString(apiVersion))
  add(path_568845, "managerName", newJString(managerName))
  add(path_568845, "subscriptionId", newJString(subscriptionId))
  add(path_568845, "deviceName", newJString(deviceName))
  result = call_568844.call(path_568845, query_568846, nil, nil, nil)

var managersGetDevicePublicEncryptionKey* = Call_ManagersGetDevicePublicEncryptionKey_568835(
    name: "managersGetDevicePublicEncryptionKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/publicEncryptionKey",
    validator: validate_ManagersGetDevicePublicEncryptionKey_568836, base: "",
    url: url_ManagersGetDevicePublicEncryptionKey_568837, schemes: {Scheme.Https})
type
  Call_DevicesScanForUpdates_568847 = ref object of OpenApiRestCall_567667
proc url_DevicesScanForUpdates_568849(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/scanForUpdates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesScanForUpdates_568848(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Scans for updates on the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568850 = path.getOrDefault("resourceGroupName")
  valid_568850 = validateParameter(valid_568850, JString, required = true,
                                 default = nil)
  if valid_568850 != nil:
    section.add "resourceGroupName", valid_568850
  var valid_568851 = path.getOrDefault("managerName")
  valid_568851 = validateParameter(valid_568851, JString, required = true,
                                 default = nil)
  if valid_568851 != nil:
    section.add "managerName", valid_568851
  var valid_568852 = path.getOrDefault("subscriptionId")
  valid_568852 = validateParameter(valid_568852, JString, required = true,
                                 default = nil)
  if valid_568852 != nil:
    section.add "subscriptionId", valid_568852
  var valid_568853 = path.getOrDefault("deviceName")
  valid_568853 = validateParameter(valid_568853, JString, required = true,
                                 default = nil)
  if valid_568853 != nil:
    section.add "deviceName", valid_568853
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568854 = query.getOrDefault("api-version")
  valid_568854 = validateParameter(valid_568854, JString, required = true,
                                 default = nil)
  if valid_568854 != nil:
    section.add "api-version", valid_568854
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568855: Call_DevicesScanForUpdates_568847; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scans for updates on the device.
  ## 
  let valid = call_568855.validator(path, query, header, formData, body)
  let scheme = call_568855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568855.url(scheme.get, call_568855.host, call_568855.base,
                         call_568855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568855, url, valid)

proc call*(call_568856: Call_DevicesScanForUpdates_568847;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesScanForUpdates
  ## Scans for updates on the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568857 = newJObject()
  var query_568858 = newJObject()
  add(path_568857, "resourceGroupName", newJString(resourceGroupName))
  add(query_568858, "api-version", newJString(apiVersion))
  add(path_568857, "managerName", newJString(managerName))
  add(path_568857, "subscriptionId", newJString(subscriptionId))
  add(path_568857, "deviceName", newJString(deviceName))
  result = call_568856.call(path_568857, query_568858, nil, nil, nil)

var devicesScanForUpdates* = Call_DevicesScanForUpdates_568847(
    name: "devicesScanForUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/scanForUpdates",
    validator: validate_DevicesScanForUpdates_568848, base: "",
    url: url_DevicesScanForUpdates_568849, schemes: {Scheme.Https})
type
  Call_DeviceSettingsGetSecuritySettings_568859 = ref object of OpenApiRestCall_567667
proc url_DeviceSettingsGetSecuritySettings_568861(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/securitySettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsGetSecuritySettings_568860(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the Security properties of the specified device name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568862 = path.getOrDefault("resourceGroupName")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "resourceGroupName", valid_568862
  var valid_568863 = path.getOrDefault("managerName")
  valid_568863 = validateParameter(valid_568863, JString, required = true,
                                 default = nil)
  if valid_568863 != nil:
    section.add "managerName", valid_568863
  var valid_568864 = path.getOrDefault("subscriptionId")
  valid_568864 = validateParameter(valid_568864, JString, required = true,
                                 default = nil)
  if valid_568864 != nil:
    section.add "subscriptionId", valid_568864
  var valid_568865 = path.getOrDefault("deviceName")
  valid_568865 = validateParameter(valid_568865, JString, required = true,
                                 default = nil)
  if valid_568865 != nil:
    section.add "deviceName", valid_568865
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568866 = query.getOrDefault("api-version")
  valid_568866 = validateParameter(valid_568866, JString, required = true,
                                 default = nil)
  if valid_568866 != nil:
    section.add "api-version", valid_568866
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568867: Call_DeviceSettingsGetSecuritySettings_568859;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the Security properties of the specified device name.
  ## 
  let valid = call_568867.validator(path, query, header, formData, body)
  let scheme = call_568867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568867.url(scheme.get, call_568867.host, call_568867.base,
                         call_568867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568867, url, valid)

proc call*(call_568868: Call_DeviceSettingsGetSecuritySettings_568859;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## deviceSettingsGetSecuritySettings
  ## Returns the Security properties of the specified device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568869 = newJObject()
  var query_568870 = newJObject()
  add(path_568869, "resourceGroupName", newJString(resourceGroupName))
  add(query_568870, "api-version", newJString(apiVersion))
  add(path_568869, "managerName", newJString(managerName))
  add(path_568869, "subscriptionId", newJString(subscriptionId))
  add(path_568869, "deviceName", newJString(deviceName))
  result = call_568868.call(path_568869, query_568870, nil, nil, nil)

var deviceSettingsGetSecuritySettings* = Call_DeviceSettingsGetSecuritySettings_568859(
    name: "deviceSettingsGetSecuritySettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/securitySettings/default",
    validator: validate_DeviceSettingsGetSecuritySettings_568860, base: "",
    url: url_DeviceSettingsGetSecuritySettings_568861, schemes: {Scheme.Https})
type
  Call_DeviceSettingsUpdateSecuritySettings_568871 = ref object of OpenApiRestCall_567667
proc url_DeviceSettingsUpdateSecuritySettings_568873(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/securitySettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsUpdateSecuritySettings_568872(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch Security properties of the specified device name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568874 = path.getOrDefault("resourceGroupName")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "resourceGroupName", valid_568874
  var valid_568875 = path.getOrDefault("managerName")
  valid_568875 = validateParameter(valid_568875, JString, required = true,
                                 default = nil)
  if valid_568875 != nil:
    section.add "managerName", valid_568875
  var valid_568876 = path.getOrDefault("subscriptionId")
  valid_568876 = validateParameter(valid_568876, JString, required = true,
                                 default = nil)
  if valid_568876 != nil:
    section.add "subscriptionId", valid_568876
  var valid_568877 = path.getOrDefault("deviceName")
  valid_568877 = validateParameter(valid_568877, JString, required = true,
                                 default = nil)
  if valid_568877 != nil:
    section.add "deviceName", valid_568877
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568878 = query.getOrDefault("api-version")
  valid_568878 = validateParameter(valid_568878, JString, required = true,
                                 default = nil)
  if valid_568878 != nil:
    section.add "api-version", valid_568878
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The security settings properties to be patched.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568880: Call_DeviceSettingsUpdateSecuritySettings_568871;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patch Security properties of the specified device name.
  ## 
  let valid = call_568880.validator(path, query, header, formData, body)
  let scheme = call_568880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568880.url(scheme.get, call_568880.host, call_568880.base,
                         call_568880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568880, url, valid)

proc call*(call_568881: Call_DeviceSettingsUpdateSecuritySettings_568871;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; parameters: JsonNode; deviceName: string): Recallable =
  ## deviceSettingsUpdateSecuritySettings
  ## Patch Security properties of the specified device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The security settings properties to be patched.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568882 = newJObject()
  var query_568883 = newJObject()
  var body_568884 = newJObject()
  add(path_568882, "resourceGroupName", newJString(resourceGroupName))
  add(query_568883, "api-version", newJString(apiVersion))
  add(path_568882, "managerName", newJString(managerName))
  add(path_568882, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568884 = parameters
  add(path_568882, "deviceName", newJString(deviceName))
  result = call_568881.call(path_568882, query_568883, nil, nil, body_568884)

var deviceSettingsUpdateSecuritySettings* = Call_DeviceSettingsUpdateSecuritySettings_568871(
    name: "deviceSettingsUpdateSecuritySettings", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/securitySettings/default",
    validator: validate_DeviceSettingsUpdateSecuritySettings_568872, base: "",
    url: url_DeviceSettingsUpdateSecuritySettings_568873, schemes: {Scheme.Https})
type
  Call_DeviceSettingsSyncRemotemanagementCertificate_568885 = ref object of OpenApiRestCall_567667
proc url_DeviceSettingsSyncRemotemanagementCertificate_568887(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"), (kind: ConstantSegment,
        value: "/securitySettings/default/syncRemoteManagementCertificate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsSyncRemotemanagementCertificate_568886(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## sync Remote management Certificate between appliance and Service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568888 = path.getOrDefault("resourceGroupName")
  valid_568888 = validateParameter(valid_568888, JString, required = true,
                                 default = nil)
  if valid_568888 != nil:
    section.add "resourceGroupName", valid_568888
  var valid_568889 = path.getOrDefault("managerName")
  valid_568889 = validateParameter(valid_568889, JString, required = true,
                                 default = nil)
  if valid_568889 != nil:
    section.add "managerName", valid_568889
  var valid_568890 = path.getOrDefault("subscriptionId")
  valid_568890 = validateParameter(valid_568890, JString, required = true,
                                 default = nil)
  if valid_568890 != nil:
    section.add "subscriptionId", valid_568890
  var valid_568891 = path.getOrDefault("deviceName")
  valid_568891 = validateParameter(valid_568891, JString, required = true,
                                 default = nil)
  if valid_568891 != nil:
    section.add "deviceName", valid_568891
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568892 = query.getOrDefault("api-version")
  valid_568892 = validateParameter(valid_568892, JString, required = true,
                                 default = nil)
  if valid_568892 != nil:
    section.add "api-version", valid_568892
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568893: Call_DeviceSettingsSyncRemotemanagementCertificate_568885;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## sync Remote management Certificate between appliance and Service
  ## 
  let valid = call_568893.validator(path, query, header, formData, body)
  let scheme = call_568893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568893.url(scheme.get, call_568893.host, call_568893.base,
                         call_568893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568893, url, valid)

proc call*(call_568894: Call_DeviceSettingsSyncRemotemanagementCertificate_568885;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## deviceSettingsSyncRemotemanagementCertificate
  ## sync Remote management Certificate between appliance and Service
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568895 = newJObject()
  var query_568896 = newJObject()
  add(path_568895, "resourceGroupName", newJString(resourceGroupName))
  add(query_568896, "api-version", newJString(apiVersion))
  add(path_568895, "managerName", newJString(managerName))
  add(path_568895, "subscriptionId", newJString(subscriptionId))
  add(path_568895, "deviceName", newJString(deviceName))
  result = call_568894.call(path_568895, query_568896, nil, nil, nil)

var deviceSettingsSyncRemotemanagementCertificate* = Call_DeviceSettingsSyncRemotemanagementCertificate_568885(
    name: "deviceSettingsSyncRemotemanagementCertificate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/securitySettings/default/syncRemoteManagementCertificate",
    validator: validate_DeviceSettingsSyncRemotemanagementCertificate_568886,
    base: "", url: url_DeviceSettingsSyncRemotemanagementCertificate_568887,
    schemes: {Scheme.Https})
type
  Call_AlertsSendTestEmail_568897 = ref object of OpenApiRestCall_567667
proc url_AlertsSendTestEmail_568899(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/sendTestAlertEmail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsSendTestEmail_568898(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Sends a test alert email.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568900 = path.getOrDefault("resourceGroupName")
  valid_568900 = validateParameter(valid_568900, JString, required = true,
                                 default = nil)
  if valid_568900 != nil:
    section.add "resourceGroupName", valid_568900
  var valid_568901 = path.getOrDefault("managerName")
  valid_568901 = validateParameter(valid_568901, JString, required = true,
                                 default = nil)
  if valid_568901 != nil:
    section.add "managerName", valid_568901
  var valid_568902 = path.getOrDefault("subscriptionId")
  valid_568902 = validateParameter(valid_568902, JString, required = true,
                                 default = nil)
  if valid_568902 != nil:
    section.add "subscriptionId", valid_568902
  var valid_568903 = path.getOrDefault("deviceName")
  valid_568903 = validateParameter(valid_568903, JString, required = true,
                                 default = nil)
  if valid_568903 != nil:
    section.add "deviceName", valid_568903
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568904 = query.getOrDefault("api-version")
  valid_568904 = validateParameter(valid_568904, JString, required = true,
                                 default = nil)
  if valid_568904 != nil:
    section.add "api-version", valid_568904
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The send test alert email request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568906: Call_AlertsSendTestEmail_568897; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a test alert email.
  ## 
  let valid = call_568906.validator(path, query, header, formData, body)
  let scheme = call_568906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568906.url(scheme.get, call_568906.host, call_568906.base,
                         call_568906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568906, url, valid)

proc call*(call_568907: Call_AlertsSendTestEmail_568897; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          parameters: JsonNode; deviceName: string): Recallable =
  ## alertsSendTestEmail
  ## Sends a test alert email.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The send test alert email request.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568908 = newJObject()
  var query_568909 = newJObject()
  var body_568910 = newJObject()
  add(path_568908, "resourceGroupName", newJString(resourceGroupName))
  add(query_568909, "api-version", newJString(apiVersion))
  add(path_568908, "managerName", newJString(managerName))
  add(path_568908, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568910 = parameters
  add(path_568908, "deviceName", newJString(deviceName))
  result = call_568907.call(path_568908, query_568909, nil, nil, body_568910)

var alertsSendTestEmail* = Call_AlertsSendTestEmail_568897(
    name: "alertsSendTestEmail", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/sendTestAlertEmail",
    validator: validate_AlertsSendTestEmail_568898, base: "",
    url: url_AlertsSendTestEmail_568899, schemes: {Scheme.Https})
type
  Call_DeviceSettingsCreateOrUpdateTimeSettings_568923 = ref object of OpenApiRestCall_567667
proc url_DeviceSettingsCreateOrUpdateTimeSettings_568925(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/timeSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsCreateOrUpdateTimeSettings_568924(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the time settings of the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568926 = path.getOrDefault("resourceGroupName")
  valid_568926 = validateParameter(valid_568926, JString, required = true,
                                 default = nil)
  if valid_568926 != nil:
    section.add "resourceGroupName", valid_568926
  var valid_568927 = path.getOrDefault("managerName")
  valid_568927 = validateParameter(valid_568927, JString, required = true,
                                 default = nil)
  if valid_568927 != nil:
    section.add "managerName", valid_568927
  var valid_568928 = path.getOrDefault("subscriptionId")
  valid_568928 = validateParameter(valid_568928, JString, required = true,
                                 default = nil)
  if valid_568928 != nil:
    section.add "subscriptionId", valid_568928
  var valid_568929 = path.getOrDefault("deviceName")
  valid_568929 = validateParameter(valid_568929, JString, required = true,
                                 default = nil)
  if valid_568929 != nil:
    section.add "deviceName", valid_568929
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568930 = query.getOrDefault("api-version")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = nil)
  if valid_568930 != nil:
    section.add "api-version", valid_568930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The time settings to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568932: Call_DeviceSettingsCreateOrUpdateTimeSettings_568923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the time settings of the specified device.
  ## 
  let valid = call_568932.validator(path, query, header, formData, body)
  let scheme = call_568932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568932.url(scheme.get, call_568932.host, call_568932.base,
                         call_568932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568932, url, valid)

proc call*(call_568933: Call_DeviceSettingsCreateOrUpdateTimeSettings_568923;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; parameters: JsonNode; deviceName: string): Recallable =
  ## deviceSettingsCreateOrUpdateTimeSettings
  ## Creates or updates the time settings of the specified device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The time settings to be added or updated.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568934 = newJObject()
  var query_568935 = newJObject()
  var body_568936 = newJObject()
  add(path_568934, "resourceGroupName", newJString(resourceGroupName))
  add(query_568935, "api-version", newJString(apiVersion))
  add(path_568934, "managerName", newJString(managerName))
  add(path_568934, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568936 = parameters
  add(path_568934, "deviceName", newJString(deviceName))
  result = call_568933.call(path_568934, query_568935, nil, nil, body_568936)

var deviceSettingsCreateOrUpdateTimeSettings* = Call_DeviceSettingsCreateOrUpdateTimeSettings_568923(
    name: "deviceSettingsCreateOrUpdateTimeSettings", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/timeSettings/default",
    validator: validate_DeviceSettingsCreateOrUpdateTimeSettings_568924, base: "",
    url: url_DeviceSettingsCreateOrUpdateTimeSettings_568925,
    schemes: {Scheme.Https})
type
  Call_DeviceSettingsGetTimeSettings_568911 = ref object of OpenApiRestCall_567667
proc url_DeviceSettingsGetTimeSettings_568913(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/timeSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSettingsGetTimeSettings_568912(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the time settings of the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568914 = path.getOrDefault("resourceGroupName")
  valid_568914 = validateParameter(valid_568914, JString, required = true,
                                 default = nil)
  if valid_568914 != nil:
    section.add "resourceGroupName", valid_568914
  var valid_568915 = path.getOrDefault("managerName")
  valid_568915 = validateParameter(valid_568915, JString, required = true,
                                 default = nil)
  if valid_568915 != nil:
    section.add "managerName", valid_568915
  var valid_568916 = path.getOrDefault("subscriptionId")
  valid_568916 = validateParameter(valid_568916, JString, required = true,
                                 default = nil)
  if valid_568916 != nil:
    section.add "subscriptionId", valid_568916
  var valid_568917 = path.getOrDefault("deviceName")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = nil)
  if valid_568917 != nil:
    section.add "deviceName", valid_568917
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568918 = query.getOrDefault("api-version")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "api-version", valid_568918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568919: Call_DeviceSettingsGetTimeSettings_568911; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the time settings of the specified device.
  ## 
  let valid = call_568919.validator(path, query, header, formData, body)
  let scheme = call_568919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568919.url(scheme.get, call_568919.host, call_568919.base,
                         call_568919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568919, url, valid)

proc call*(call_568920: Call_DeviceSettingsGetTimeSettings_568911;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## deviceSettingsGetTimeSettings
  ## Gets the time settings of the specified device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568921 = newJObject()
  var query_568922 = newJObject()
  add(path_568921, "resourceGroupName", newJString(resourceGroupName))
  add(query_568922, "api-version", newJString(apiVersion))
  add(path_568921, "managerName", newJString(managerName))
  add(path_568921, "subscriptionId", newJString(subscriptionId))
  add(path_568921, "deviceName", newJString(deviceName))
  result = call_568920.call(path_568921, query_568922, nil, nil, nil)

var deviceSettingsGetTimeSettings* = Call_DeviceSettingsGetTimeSettings_568911(
    name: "deviceSettingsGetTimeSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/timeSettings/default",
    validator: validate_DeviceSettingsGetTimeSettings_568912, base: "",
    url: url_DeviceSettingsGetTimeSettings_568913, schemes: {Scheme.Https})
type
  Call_DevicesGetUpdateSummary_568937 = ref object of OpenApiRestCall_567667
proc url_DevicesGetUpdateSummary_568939(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/updateSummary/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGetUpdateSummary_568938(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the update summary of the specified device name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568940 = path.getOrDefault("resourceGroupName")
  valid_568940 = validateParameter(valid_568940, JString, required = true,
                                 default = nil)
  if valid_568940 != nil:
    section.add "resourceGroupName", valid_568940
  var valid_568941 = path.getOrDefault("managerName")
  valid_568941 = validateParameter(valid_568941, JString, required = true,
                                 default = nil)
  if valid_568941 != nil:
    section.add "managerName", valid_568941
  var valid_568942 = path.getOrDefault("subscriptionId")
  valid_568942 = validateParameter(valid_568942, JString, required = true,
                                 default = nil)
  if valid_568942 != nil:
    section.add "subscriptionId", valid_568942
  var valid_568943 = path.getOrDefault("deviceName")
  valid_568943 = validateParameter(valid_568943, JString, required = true,
                                 default = nil)
  if valid_568943 != nil:
    section.add "deviceName", valid_568943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568944 = query.getOrDefault("api-version")
  valid_568944 = validateParameter(valid_568944, JString, required = true,
                                 default = nil)
  if valid_568944 != nil:
    section.add "api-version", valid_568944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568945: Call_DevicesGetUpdateSummary_568937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the update summary of the specified device name.
  ## 
  let valid = call_568945.validator(path, query, header, formData, body)
  let scheme = call_568945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568945.url(scheme.get, call_568945.host, call_568945.base,
                         call_568945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568945, url, valid)

proc call*(call_568946: Call_DevicesGetUpdateSummary_568937;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesGetUpdateSummary
  ## Returns the update summary of the specified device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568947 = newJObject()
  var query_568948 = newJObject()
  add(path_568947, "resourceGroupName", newJString(resourceGroupName))
  add(query_568948, "api-version", newJString(apiVersion))
  add(path_568947, "managerName", newJString(managerName))
  add(path_568947, "subscriptionId", newJString(subscriptionId))
  add(path_568947, "deviceName", newJString(deviceName))
  result = call_568946.call(path_568947, query_568948, nil, nil, nil)

var devicesGetUpdateSummary* = Call_DevicesGetUpdateSummary_568937(
    name: "devicesGetUpdateSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/updateSummary/default",
    validator: validate_DevicesGetUpdateSummary_568938, base: "",
    url: url_DevicesGetUpdateSummary_568939, schemes: {Scheme.Https})
type
  Call_VolumeContainersListByDevice_568949 = ref object of OpenApiRestCall_567667
proc url_VolumeContainersListByDevice_568951(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeContainersListByDevice_568950(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the volume containers in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568952 = path.getOrDefault("resourceGroupName")
  valid_568952 = validateParameter(valid_568952, JString, required = true,
                                 default = nil)
  if valid_568952 != nil:
    section.add "resourceGroupName", valid_568952
  var valid_568953 = path.getOrDefault("managerName")
  valid_568953 = validateParameter(valid_568953, JString, required = true,
                                 default = nil)
  if valid_568953 != nil:
    section.add "managerName", valid_568953
  var valid_568954 = path.getOrDefault("subscriptionId")
  valid_568954 = validateParameter(valid_568954, JString, required = true,
                                 default = nil)
  if valid_568954 != nil:
    section.add "subscriptionId", valid_568954
  var valid_568955 = path.getOrDefault("deviceName")
  valid_568955 = validateParameter(valid_568955, JString, required = true,
                                 default = nil)
  if valid_568955 != nil:
    section.add "deviceName", valid_568955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568956 = query.getOrDefault("api-version")
  valid_568956 = validateParameter(valid_568956, JString, required = true,
                                 default = nil)
  if valid_568956 != nil:
    section.add "api-version", valid_568956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568957: Call_VolumeContainersListByDevice_568949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the volume containers in a device.
  ## 
  let valid = call_568957.validator(path, query, header, formData, body)
  let scheme = call_568957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568957.url(scheme.get, call_568957.host, call_568957.base,
                         call_568957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568957, url, valid)

proc call*(call_568958: Call_VolumeContainersListByDevice_568949;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## volumeContainersListByDevice
  ## Gets all the volume containers in a device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568959 = newJObject()
  var query_568960 = newJObject()
  add(path_568959, "resourceGroupName", newJString(resourceGroupName))
  add(query_568960, "api-version", newJString(apiVersion))
  add(path_568959, "managerName", newJString(managerName))
  add(path_568959, "subscriptionId", newJString(subscriptionId))
  add(path_568959, "deviceName", newJString(deviceName))
  result = call_568958.call(path_568959, query_568960, nil, nil, nil)

var volumeContainersListByDevice* = Call_VolumeContainersListByDevice_568949(
    name: "volumeContainersListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers",
    validator: validate_VolumeContainersListByDevice_568950, base: "",
    url: url_VolumeContainersListByDevice_568951, schemes: {Scheme.Https})
type
  Call_VolumeContainersCreateOrUpdate_568974 = ref object of OpenApiRestCall_567667
proc url_VolumeContainersCreateOrUpdate_568976(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeContainersCreateOrUpdate_568975(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the volume container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   volumeContainerName: JString (required)
  ##                      : The name of the volume container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568977 = path.getOrDefault("resourceGroupName")
  valid_568977 = validateParameter(valid_568977, JString, required = true,
                                 default = nil)
  if valid_568977 != nil:
    section.add "resourceGroupName", valid_568977
  var valid_568978 = path.getOrDefault("managerName")
  valid_568978 = validateParameter(valid_568978, JString, required = true,
                                 default = nil)
  if valid_568978 != nil:
    section.add "managerName", valid_568978
  var valid_568979 = path.getOrDefault("volumeContainerName")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "volumeContainerName", valid_568979
  var valid_568980 = path.getOrDefault("subscriptionId")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "subscriptionId", valid_568980
  var valid_568981 = path.getOrDefault("deviceName")
  valid_568981 = validateParameter(valid_568981, JString, required = true,
                                 default = nil)
  if valid_568981 != nil:
    section.add "deviceName", valid_568981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568982 = query.getOrDefault("api-version")
  valid_568982 = validateParameter(valid_568982, JString, required = true,
                                 default = nil)
  if valid_568982 != nil:
    section.add "api-version", valid_568982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The volume container to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568984: Call_VolumeContainersCreateOrUpdate_568974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the volume container.
  ## 
  let valid = call_568984.validator(path, query, header, formData, body)
  let scheme = call_568984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568984.url(scheme.get, call_568984.host, call_568984.base,
                         call_568984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568984, url, valid)

proc call*(call_568985: Call_VolumeContainersCreateOrUpdate_568974;
          resourceGroupName: string; apiVersion: string; managerName: string;
          volumeContainerName: string; subscriptionId: string; parameters: JsonNode;
          deviceName: string): Recallable =
  ## volumeContainersCreateOrUpdate
  ## Creates or updates the volume container.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   volumeContainerName: string (required)
  ##                      : The name of the volume container.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The volume container to be added or updated.
  ##   deviceName: string (required)
  ##             : The device name
  var path_568986 = newJObject()
  var query_568987 = newJObject()
  var body_568988 = newJObject()
  add(path_568986, "resourceGroupName", newJString(resourceGroupName))
  add(query_568987, "api-version", newJString(apiVersion))
  add(path_568986, "managerName", newJString(managerName))
  add(path_568986, "volumeContainerName", newJString(volumeContainerName))
  add(path_568986, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568988 = parameters
  add(path_568986, "deviceName", newJString(deviceName))
  result = call_568985.call(path_568986, query_568987, nil, nil, body_568988)

var volumeContainersCreateOrUpdate* = Call_VolumeContainersCreateOrUpdate_568974(
    name: "volumeContainersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}",
    validator: validate_VolumeContainersCreateOrUpdate_568975, base: "",
    url: url_VolumeContainersCreateOrUpdate_568976, schemes: {Scheme.Https})
type
  Call_VolumeContainersGet_568961 = ref object of OpenApiRestCall_567667
proc url_VolumeContainersGet_568963(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeContainersGet_568962(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the properties of the specified volume container name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   volumeContainerName: JString (required)
  ##                      : The name of the volume container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568964 = path.getOrDefault("resourceGroupName")
  valid_568964 = validateParameter(valid_568964, JString, required = true,
                                 default = nil)
  if valid_568964 != nil:
    section.add "resourceGroupName", valid_568964
  var valid_568965 = path.getOrDefault("managerName")
  valid_568965 = validateParameter(valid_568965, JString, required = true,
                                 default = nil)
  if valid_568965 != nil:
    section.add "managerName", valid_568965
  var valid_568966 = path.getOrDefault("volumeContainerName")
  valid_568966 = validateParameter(valid_568966, JString, required = true,
                                 default = nil)
  if valid_568966 != nil:
    section.add "volumeContainerName", valid_568966
  var valid_568967 = path.getOrDefault("subscriptionId")
  valid_568967 = validateParameter(valid_568967, JString, required = true,
                                 default = nil)
  if valid_568967 != nil:
    section.add "subscriptionId", valid_568967
  var valid_568968 = path.getOrDefault("deviceName")
  valid_568968 = validateParameter(valid_568968, JString, required = true,
                                 default = nil)
  if valid_568968 != nil:
    section.add "deviceName", valid_568968
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568969 = query.getOrDefault("api-version")
  valid_568969 = validateParameter(valid_568969, JString, required = true,
                                 default = nil)
  if valid_568969 != nil:
    section.add "api-version", valid_568969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568970: Call_VolumeContainersGet_568961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified volume container name.
  ## 
  let valid = call_568970.validator(path, query, header, formData, body)
  let scheme = call_568970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568970.url(scheme.get, call_568970.host, call_568970.base,
                         call_568970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568970, url, valid)

proc call*(call_568971: Call_VolumeContainersGet_568961; resourceGroupName: string;
          apiVersion: string; managerName: string; volumeContainerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## volumeContainersGet
  ## Gets the properties of the specified volume container name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   volumeContainerName: string (required)
  ##                      : The name of the volume container.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_568972 = newJObject()
  var query_568973 = newJObject()
  add(path_568972, "resourceGroupName", newJString(resourceGroupName))
  add(query_568973, "api-version", newJString(apiVersion))
  add(path_568972, "managerName", newJString(managerName))
  add(path_568972, "volumeContainerName", newJString(volumeContainerName))
  add(path_568972, "subscriptionId", newJString(subscriptionId))
  add(path_568972, "deviceName", newJString(deviceName))
  result = call_568971.call(path_568972, query_568973, nil, nil, nil)

var volumeContainersGet* = Call_VolumeContainersGet_568961(
    name: "volumeContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}",
    validator: validate_VolumeContainersGet_568962, base: "",
    url: url_VolumeContainersGet_568963, schemes: {Scheme.Https})
type
  Call_VolumeContainersDelete_568989 = ref object of OpenApiRestCall_567667
proc url_VolumeContainersDelete_568991(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeContainersDelete_568990(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the volume container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   volumeContainerName: JString (required)
  ##                      : The name of the volume container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568992 = path.getOrDefault("resourceGroupName")
  valid_568992 = validateParameter(valid_568992, JString, required = true,
                                 default = nil)
  if valid_568992 != nil:
    section.add "resourceGroupName", valid_568992
  var valid_568993 = path.getOrDefault("managerName")
  valid_568993 = validateParameter(valid_568993, JString, required = true,
                                 default = nil)
  if valid_568993 != nil:
    section.add "managerName", valid_568993
  var valid_568994 = path.getOrDefault("volumeContainerName")
  valid_568994 = validateParameter(valid_568994, JString, required = true,
                                 default = nil)
  if valid_568994 != nil:
    section.add "volumeContainerName", valid_568994
  var valid_568995 = path.getOrDefault("subscriptionId")
  valid_568995 = validateParameter(valid_568995, JString, required = true,
                                 default = nil)
  if valid_568995 != nil:
    section.add "subscriptionId", valid_568995
  var valid_568996 = path.getOrDefault("deviceName")
  valid_568996 = validateParameter(valid_568996, JString, required = true,
                                 default = nil)
  if valid_568996 != nil:
    section.add "deviceName", valid_568996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568997 = query.getOrDefault("api-version")
  valid_568997 = validateParameter(valid_568997, JString, required = true,
                                 default = nil)
  if valid_568997 != nil:
    section.add "api-version", valid_568997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568998: Call_VolumeContainersDelete_568989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the volume container.
  ## 
  let valid = call_568998.validator(path, query, header, formData, body)
  let scheme = call_568998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568998.url(scheme.get, call_568998.host, call_568998.base,
                         call_568998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568998, url, valid)

proc call*(call_568999: Call_VolumeContainersDelete_568989;
          resourceGroupName: string; apiVersion: string; managerName: string;
          volumeContainerName: string; subscriptionId: string; deviceName: string): Recallable =
  ## volumeContainersDelete
  ## Deletes the volume container.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   volumeContainerName: string (required)
  ##                      : The name of the volume container.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_569000 = newJObject()
  var query_569001 = newJObject()
  add(path_569000, "resourceGroupName", newJString(resourceGroupName))
  add(query_569001, "api-version", newJString(apiVersion))
  add(path_569000, "managerName", newJString(managerName))
  add(path_569000, "volumeContainerName", newJString(volumeContainerName))
  add(path_569000, "subscriptionId", newJString(subscriptionId))
  add(path_569000, "deviceName", newJString(deviceName))
  result = call_568999.call(path_569000, query_569001, nil, nil, nil)

var volumeContainersDelete* = Call_VolumeContainersDelete_568989(
    name: "volumeContainersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}",
    validator: validate_VolumeContainersDelete_568990, base: "",
    url: url_VolumeContainersDelete_568991, schemes: {Scheme.Https})
type
  Call_VolumeContainersListMetrics_569002 = ref object of OpenApiRestCall_567667
proc url_VolumeContainersListMetrics_569004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeContainersListMetrics_569003(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metrics for the specified volume container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569005 = path.getOrDefault("resourceGroupName")
  valid_569005 = validateParameter(valid_569005, JString, required = true,
                                 default = nil)
  if valid_569005 != nil:
    section.add "resourceGroupName", valid_569005
  var valid_569006 = path.getOrDefault("managerName")
  valid_569006 = validateParameter(valid_569006, JString, required = true,
                                 default = nil)
  if valid_569006 != nil:
    section.add "managerName", valid_569006
  var valid_569007 = path.getOrDefault("volumeContainerName")
  valid_569007 = validateParameter(valid_569007, JString, required = true,
                                 default = nil)
  if valid_569007 != nil:
    section.add "volumeContainerName", valid_569007
  var valid_569008 = path.getOrDefault("subscriptionId")
  valid_569008 = validateParameter(valid_569008, JString, required = true,
                                 default = nil)
  if valid_569008 != nil:
    section.add "subscriptionId", valid_569008
  var valid_569009 = path.getOrDefault("deviceName")
  valid_569009 = validateParameter(valid_569009, JString, required = true,
                                 default = nil)
  if valid_569009 != nil:
    section.add "deviceName", valid_569009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString (required)
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569010 = query.getOrDefault("api-version")
  valid_569010 = validateParameter(valid_569010, JString, required = true,
                                 default = nil)
  if valid_569010 != nil:
    section.add "api-version", valid_569010
  var valid_569011 = query.getOrDefault("$filter")
  valid_569011 = validateParameter(valid_569011, JString, required = true,
                                 default = nil)
  if valid_569011 != nil:
    section.add "$filter", valid_569011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569012: Call_VolumeContainersListMetrics_569002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metrics for the specified volume container.
  ## 
  let valid = call_569012.validator(path, query, header, formData, body)
  let scheme = call_569012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569012.url(scheme.get, call_569012.host, call_569012.base,
                         call_569012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569012, url, valid)

proc call*(call_569013: Call_VolumeContainersListMetrics_569002;
          resourceGroupName: string; apiVersion: string; managerName: string;
          volumeContainerName: string; subscriptionId: string; Filter: string;
          deviceName: string): Recallable =
  ## volumeContainersListMetrics
  ## Gets the metrics for the specified volume container.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   Filter: string (required)
  ##         : OData Filter options
  ##   deviceName: string (required)
  ##             : The device name
  var path_569014 = newJObject()
  var query_569015 = newJObject()
  add(path_569014, "resourceGroupName", newJString(resourceGroupName))
  add(query_569015, "api-version", newJString(apiVersion))
  add(path_569014, "managerName", newJString(managerName))
  add(path_569014, "volumeContainerName", newJString(volumeContainerName))
  add(path_569014, "subscriptionId", newJString(subscriptionId))
  add(query_569015, "$filter", newJString(Filter))
  add(path_569014, "deviceName", newJString(deviceName))
  result = call_569013.call(path_569014, query_569015, nil, nil, nil)

var volumeContainersListMetrics* = Call_VolumeContainersListMetrics_569002(
    name: "volumeContainersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/metrics",
    validator: validate_VolumeContainersListMetrics_569003, base: "",
    url: url_VolumeContainersListMetrics_569004, schemes: {Scheme.Https})
type
  Call_VolumeContainersListMetricDefinition_569016 = ref object of OpenApiRestCall_567667
proc url_VolumeContainersListMetricDefinition_569018(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeContainersListMetricDefinition_569017(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metric definitions for the specified volume container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569019 = path.getOrDefault("resourceGroupName")
  valid_569019 = validateParameter(valid_569019, JString, required = true,
                                 default = nil)
  if valid_569019 != nil:
    section.add "resourceGroupName", valid_569019
  var valid_569020 = path.getOrDefault("managerName")
  valid_569020 = validateParameter(valid_569020, JString, required = true,
                                 default = nil)
  if valid_569020 != nil:
    section.add "managerName", valid_569020
  var valid_569021 = path.getOrDefault("volumeContainerName")
  valid_569021 = validateParameter(valid_569021, JString, required = true,
                                 default = nil)
  if valid_569021 != nil:
    section.add "volumeContainerName", valid_569021
  var valid_569022 = path.getOrDefault("subscriptionId")
  valid_569022 = validateParameter(valid_569022, JString, required = true,
                                 default = nil)
  if valid_569022 != nil:
    section.add "subscriptionId", valid_569022
  var valid_569023 = path.getOrDefault("deviceName")
  valid_569023 = validateParameter(valid_569023, JString, required = true,
                                 default = nil)
  if valid_569023 != nil:
    section.add "deviceName", valid_569023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569024 = query.getOrDefault("api-version")
  valid_569024 = validateParameter(valid_569024, JString, required = true,
                                 default = nil)
  if valid_569024 != nil:
    section.add "api-version", valid_569024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569025: Call_VolumeContainersListMetricDefinition_569016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the metric definitions for the specified volume container.
  ## 
  let valid = call_569025.validator(path, query, header, formData, body)
  let scheme = call_569025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569025.url(scheme.get, call_569025.host, call_569025.base,
                         call_569025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569025, url, valid)

proc call*(call_569026: Call_VolumeContainersListMetricDefinition_569016;
          resourceGroupName: string; apiVersion: string; managerName: string;
          volumeContainerName: string; subscriptionId: string; deviceName: string): Recallable =
  ## volumeContainersListMetricDefinition
  ## Gets the metric definitions for the specified volume container.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_569027 = newJObject()
  var query_569028 = newJObject()
  add(path_569027, "resourceGroupName", newJString(resourceGroupName))
  add(query_569028, "api-version", newJString(apiVersion))
  add(path_569027, "managerName", newJString(managerName))
  add(path_569027, "volumeContainerName", newJString(volumeContainerName))
  add(path_569027, "subscriptionId", newJString(subscriptionId))
  add(path_569027, "deviceName", newJString(deviceName))
  result = call_569026.call(path_569027, query_569028, nil, nil, nil)

var volumeContainersListMetricDefinition* = Call_VolumeContainersListMetricDefinition_569016(
    name: "volumeContainersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/metricsDefinitions",
    validator: validate_VolumeContainersListMetricDefinition_569017, base: "",
    url: url_VolumeContainersListMetricDefinition_569018, schemes: {Scheme.Https})
type
  Call_VolumesListByVolumeContainer_569029 = ref object of OpenApiRestCall_567667
proc url_VolumesListByVolumeContainer_569031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/volumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesListByVolumeContainer_569030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the volumes in a volume container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569032 = path.getOrDefault("resourceGroupName")
  valid_569032 = validateParameter(valid_569032, JString, required = true,
                                 default = nil)
  if valid_569032 != nil:
    section.add "resourceGroupName", valid_569032
  var valid_569033 = path.getOrDefault("managerName")
  valid_569033 = validateParameter(valid_569033, JString, required = true,
                                 default = nil)
  if valid_569033 != nil:
    section.add "managerName", valid_569033
  var valid_569034 = path.getOrDefault("volumeContainerName")
  valid_569034 = validateParameter(valid_569034, JString, required = true,
                                 default = nil)
  if valid_569034 != nil:
    section.add "volumeContainerName", valid_569034
  var valid_569035 = path.getOrDefault("subscriptionId")
  valid_569035 = validateParameter(valid_569035, JString, required = true,
                                 default = nil)
  if valid_569035 != nil:
    section.add "subscriptionId", valid_569035
  var valid_569036 = path.getOrDefault("deviceName")
  valid_569036 = validateParameter(valid_569036, JString, required = true,
                                 default = nil)
  if valid_569036 != nil:
    section.add "deviceName", valid_569036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569037 = query.getOrDefault("api-version")
  valid_569037 = validateParameter(valid_569037, JString, required = true,
                                 default = nil)
  if valid_569037 != nil:
    section.add "api-version", valid_569037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569038: Call_VolumesListByVolumeContainer_569029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the volumes in a volume container.
  ## 
  let valid = call_569038.validator(path, query, header, formData, body)
  let scheme = call_569038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569038.url(scheme.get, call_569038.host, call_569038.base,
                         call_569038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569038, url, valid)

proc call*(call_569039: Call_VolumesListByVolumeContainer_569029;
          resourceGroupName: string; apiVersion: string; managerName: string;
          volumeContainerName: string; subscriptionId: string; deviceName: string): Recallable =
  ## volumesListByVolumeContainer
  ## Retrieves all the volumes in a volume container.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_569040 = newJObject()
  var query_569041 = newJObject()
  add(path_569040, "resourceGroupName", newJString(resourceGroupName))
  add(query_569041, "api-version", newJString(apiVersion))
  add(path_569040, "managerName", newJString(managerName))
  add(path_569040, "volumeContainerName", newJString(volumeContainerName))
  add(path_569040, "subscriptionId", newJString(subscriptionId))
  add(path_569040, "deviceName", newJString(deviceName))
  result = call_569039.call(path_569040, query_569041, nil, nil, nil)

var volumesListByVolumeContainer* = Call_VolumesListByVolumeContainer_569029(
    name: "volumesListByVolumeContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes",
    validator: validate_VolumesListByVolumeContainer_569030, base: "",
    url: url_VolumesListByVolumeContainer_569031, schemes: {Scheme.Https})
type
  Call_VolumesCreateOrUpdate_569056 = ref object of OpenApiRestCall_567667
proc url_VolumesCreateOrUpdate_569058(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesCreateOrUpdate_569057(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   volumeName: JString (required)
  ##             : The volume name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569059 = path.getOrDefault("resourceGroupName")
  valid_569059 = validateParameter(valid_569059, JString, required = true,
                                 default = nil)
  if valid_569059 != nil:
    section.add "resourceGroupName", valid_569059
  var valid_569060 = path.getOrDefault("managerName")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "managerName", valid_569060
  var valid_569061 = path.getOrDefault("volumeContainerName")
  valid_569061 = validateParameter(valid_569061, JString, required = true,
                                 default = nil)
  if valid_569061 != nil:
    section.add "volumeContainerName", valid_569061
  var valid_569062 = path.getOrDefault("subscriptionId")
  valid_569062 = validateParameter(valid_569062, JString, required = true,
                                 default = nil)
  if valid_569062 != nil:
    section.add "subscriptionId", valid_569062
  var valid_569063 = path.getOrDefault("volumeName")
  valid_569063 = validateParameter(valid_569063, JString, required = true,
                                 default = nil)
  if valid_569063 != nil:
    section.add "volumeName", valid_569063
  var valid_569064 = path.getOrDefault("deviceName")
  valid_569064 = validateParameter(valid_569064, JString, required = true,
                                 default = nil)
  if valid_569064 != nil:
    section.add "deviceName", valid_569064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569065 = query.getOrDefault("api-version")
  valid_569065 = validateParameter(valid_569065, JString, required = true,
                                 default = nil)
  if valid_569065 != nil:
    section.add "api-version", valid_569065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Volume to be created or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569067: Call_VolumesCreateOrUpdate_569056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the volume.
  ## 
  let valid = call_569067.validator(path, query, header, formData, body)
  let scheme = call_569067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569067.url(scheme.get, call_569067.host, call_569067.base,
                         call_569067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569067, url, valid)

proc call*(call_569068: Call_VolumesCreateOrUpdate_569056;
          resourceGroupName: string; apiVersion: string; managerName: string;
          volumeContainerName: string; subscriptionId: string; parameters: JsonNode;
          volumeName: string; deviceName: string): Recallable =
  ## volumesCreateOrUpdate
  ## Creates or updates the volume.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : Volume to be created or updated.
  ##   volumeName: string (required)
  ##             : The volume name.
  ##   deviceName: string (required)
  ##             : The device name
  var path_569069 = newJObject()
  var query_569070 = newJObject()
  var body_569071 = newJObject()
  add(path_569069, "resourceGroupName", newJString(resourceGroupName))
  add(query_569070, "api-version", newJString(apiVersion))
  add(path_569069, "managerName", newJString(managerName))
  add(path_569069, "volumeContainerName", newJString(volumeContainerName))
  add(path_569069, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569071 = parameters
  add(path_569069, "volumeName", newJString(volumeName))
  add(path_569069, "deviceName", newJString(deviceName))
  result = call_569068.call(path_569069, query_569070, nil, nil, body_569071)

var volumesCreateOrUpdate* = Call_VolumesCreateOrUpdate_569056(
    name: "volumesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}",
    validator: validate_VolumesCreateOrUpdate_569057, base: "",
    url: url_VolumesCreateOrUpdate_569058, schemes: {Scheme.Https})
type
  Call_VolumesGet_569042 = ref object of OpenApiRestCall_567667
proc url_VolumesGet_569044(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesGet_569043(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified volume name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   volumeName: JString (required)
  ##             : The volume name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569045 = path.getOrDefault("resourceGroupName")
  valid_569045 = validateParameter(valid_569045, JString, required = true,
                                 default = nil)
  if valid_569045 != nil:
    section.add "resourceGroupName", valid_569045
  var valid_569046 = path.getOrDefault("managerName")
  valid_569046 = validateParameter(valid_569046, JString, required = true,
                                 default = nil)
  if valid_569046 != nil:
    section.add "managerName", valid_569046
  var valid_569047 = path.getOrDefault("volumeContainerName")
  valid_569047 = validateParameter(valid_569047, JString, required = true,
                                 default = nil)
  if valid_569047 != nil:
    section.add "volumeContainerName", valid_569047
  var valid_569048 = path.getOrDefault("subscriptionId")
  valid_569048 = validateParameter(valid_569048, JString, required = true,
                                 default = nil)
  if valid_569048 != nil:
    section.add "subscriptionId", valid_569048
  var valid_569049 = path.getOrDefault("volumeName")
  valid_569049 = validateParameter(valid_569049, JString, required = true,
                                 default = nil)
  if valid_569049 != nil:
    section.add "volumeName", valid_569049
  var valid_569050 = path.getOrDefault("deviceName")
  valid_569050 = validateParameter(valid_569050, JString, required = true,
                                 default = nil)
  if valid_569050 != nil:
    section.add "deviceName", valid_569050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569051 = query.getOrDefault("api-version")
  valid_569051 = validateParameter(valid_569051, JString, required = true,
                                 default = nil)
  if valid_569051 != nil:
    section.add "api-version", valid_569051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569052: Call_VolumesGet_569042; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified volume name.
  ## 
  let valid = call_569052.validator(path, query, header, formData, body)
  let scheme = call_569052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569052.url(scheme.get, call_569052.host, call_569052.base,
                         call_569052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569052, url, valid)

proc call*(call_569053: Call_VolumesGet_569042; resourceGroupName: string;
          apiVersion: string; managerName: string; volumeContainerName: string;
          subscriptionId: string; volumeName: string; deviceName: string): Recallable =
  ## volumesGet
  ## Returns the properties of the specified volume name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   volumeName: string (required)
  ##             : The volume name.
  ##   deviceName: string (required)
  ##             : The device name
  var path_569054 = newJObject()
  var query_569055 = newJObject()
  add(path_569054, "resourceGroupName", newJString(resourceGroupName))
  add(query_569055, "api-version", newJString(apiVersion))
  add(path_569054, "managerName", newJString(managerName))
  add(path_569054, "volumeContainerName", newJString(volumeContainerName))
  add(path_569054, "subscriptionId", newJString(subscriptionId))
  add(path_569054, "volumeName", newJString(volumeName))
  add(path_569054, "deviceName", newJString(deviceName))
  result = call_569053.call(path_569054, query_569055, nil, nil, nil)

var volumesGet* = Call_VolumesGet_569042(name: "volumesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}",
                                      validator: validate_VolumesGet_569043,
                                      base: "", url: url_VolumesGet_569044,
                                      schemes: {Scheme.Https})
type
  Call_VolumesDelete_569072 = ref object of OpenApiRestCall_567667
proc url_VolumesDelete_569074(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesDelete_569073(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   volumeName: JString (required)
  ##             : The volume name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569075 = path.getOrDefault("resourceGroupName")
  valid_569075 = validateParameter(valid_569075, JString, required = true,
                                 default = nil)
  if valid_569075 != nil:
    section.add "resourceGroupName", valid_569075
  var valid_569076 = path.getOrDefault("managerName")
  valid_569076 = validateParameter(valid_569076, JString, required = true,
                                 default = nil)
  if valid_569076 != nil:
    section.add "managerName", valid_569076
  var valid_569077 = path.getOrDefault("volumeContainerName")
  valid_569077 = validateParameter(valid_569077, JString, required = true,
                                 default = nil)
  if valid_569077 != nil:
    section.add "volumeContainerName", valid_569077
  var valid_569078 = path.getOrDefault("subscriptionId")
  valid_569078 = validateParameter(valid_569078, JString, required = true,
                                 default = nil)
  if valid_569078 != nil:
    section.add "subscriptionId", valid_569078
  var valid_569079 = path.getOrDefault("volumeName")
  valid_569079 = validateParameter(valid_569079, JString, required = true,
                                 default = nil)
  if valid_569079 != nil:
    section.add "volumeName", valid_569079
  var valid_569080 = path.getOrDefault("deviceName")
  valid_569080 = validateParameter(valid_569080, JString, required = true,
                                 default = nil)
  if valid_569080 != nil:
    section.add "deviceName", valid_569080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569081 = query.getOrDefault("api-version")
  valid_569081 = validateParameter(valid_569081, JString, required = true,
                                 default = nil)
  if valid_569081 != nil:
    section.add "api-version", valid_569081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569082: Call_VolumesDelete_569072; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the volume.
  ## 
  let valid = call_569082.validator(path, query, header, formData, body)
  let scheme = call_569082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569082.url(scheme.get, call_569082.host, call_569082.base,
                         call_569082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569082, url, valid)

proc call*(call_569083: Call_VolumesDelete_569072; resourceGroupName: string;
          apiVersion: string; managerName: string; volumeContainerName: string;
          subscriptionId: string; volumeName: string; deviceName: string): Recallable =
  ## volumesDelete
  ## Deletes the volume.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   volumeName: string (required)
  ##             : The volume name.
  ##   deviceName: string (required)
  ##             : The device name
  var path_569084 = newJObject()
  var query_569085 = newJObject()
  add(path_569084, "resourceGroupName", newJString(resourceGroupName))
  add(query_569085, "api-version", newJString(apiVersion))
  add(path_569084, "managerName", newJString(managerName))
  add(path_569084, "volumeContainerName", newJString(volumeContainerName))
  add(path_569084, "subscriptionId", newJString(subscriptionId))
  add(path_569084, "volumeName", newJString(volumeName))
  add(path_569084, "deviceName", newJString(deviceName))
  result = call_569083.call(path_569084, query_569085, nil, nil, nil)

var volumesDelete* = Call_VolumesDelete_569072(name: "volumesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}",
    validator: validate_VolumesDelete_569073, base: "", url: url_VolumesDelete_569074,
    schemes: {Scheme.Https})
type
  Call_VolumesListMetrics_569086 = ref object of OpenApiRestCall_567667
proc url_VolumesListMetrics_569088(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesListMetrics_569087(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the metrics for the specified volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   volumeName: JString (required)
  ##             : The volume name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569089 = path.getOrDefault("resourceGroupName")
  valid_569089 = validateParameter(valid_569089, JString, required = true,
                                 default = nil)
  if valid_569089 != nil:
    section.add "resourceGroupName", valid_569089
  var valid_569090 = path.getOrDefault("managerName")
  valid_569090 = validateParameter(valid_569090, JString, required = true,
                                 default = nil)
  if valid_569090 != nil:
    section.add "managerName", valid_569090
  var valid_569091 = path.getOrDefault("volumeContainerName")
  valid_569091 = validateParameter(valid_569091, JString, required = true,
                                 default = nil)
  if valid_569091 != nil:
    section.add "volumeContainerName", valid_569091
  var valid_569092 = path.getOrDefault("subscriptionId")
  valid_569092 = validateParameter(valid_569092, JString, required = true,
                                 default = nil)
  if valid_569092 != nil:
    section.add "subscriptionId", valid_569092
  var valid_569093 = path.getOrDefault("volumeName")
  valid_569093 = validateParameter(valid_569093, JString, required = true,
                                 default = nil)
  if valid_569093 != nil:
    section.add "volumeName", valid_569093
  var valid_569094 = path.getOrDefault("deviceName")
  valid_569094 = validateParameter(valid_569094, JString, required = true,
                                 default = nil)
  if valid_569094 != nil:
    section.add "deviceName", valid_569094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString (required)
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569095 = query.getOrDefault("api-version")
  valid_569095 = validateParameter(valid_569095, JString, required = true,
                                 default = nil)
  if valid_569095 != nil:
    section.add "api-version", valid_569095
  var valid_569096 = query.getOrDefault("$filter")
  valid_569096 = validateParameter(valid_569096, JString, required = true,
                                 default = nil)
  if valid_569096 != nil:
    section.add "$filter", valid_569096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569097: Call_VolumesListMetrics_569086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metrics for the specified volume.
  ## 
  let valid = call_569097.validator(path, query, header, formData, body)
  let scheme = call_569097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569097.url(scheme.get, call_569097.host, call_569097.base,
                         call_569097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569097, url, valid)

proc call*(call_569098: Call_VolumesListMetrics_569086; resourceGroupName: string;
          apiVersion: string; managerName: string; volumeContainerName: string;
          subscriptionId: string; volumeName: string; Filter: string;
          deviceName: string): Recallable =
  ## volumesListMetrics
  ## Gets the metrics for the specified volume.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   volumeName: string (required)
  ##             : The volume name.
  ##   Filter: string (required)
  ##         : OData Filter options
  ##   deviceName: string (required)
  ##             : The device name
  var path_569099 = newJObject()
  var query_569100 = newJObject()
  add(path_569099, "resourceGroupName", newJString(resourceGroupName))
  add(query_569100, "api-version", newJString(apiVersion))
  add(path_569099, "managerName", newJString(managerName))
  add(path_569099, "volumeContainerName", newJString(volumeContainerName))
  add(path_569099, "subscriptionId", newJString(subscriptionId))
  add(path_569099, "volumeName", newJString(volumeName))
  add(query_569100, "$filter", newJString(Filter))
  add(path_569099, "deviceName", newJString(deviceName))
  result = call_569098.call(path_569099, query_569100, nil, nil, nil)

var volumesListMetrics* = Call_VolumesListMetrics_569086(
    name: "volumesListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}/metrics",
    validator: validate_VolumesListMetrics_569087, base: "",
    url: url_VolumesListMetrics_569088, schemes: {Scheme.Https})
type
  Call_VolumesListMetricDefinition_569101 = ref object of OpenApiRestCall_567667
proc url_VolumesListMetricDefinition_569103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "volumeContainerName" in path,
        "`volumeContainerName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumeContainers/"),
               (kind: VariableSegment, value: "volumeContainerName"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volumeName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesListMetricDefinition_569102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metric definitions for the specified volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   volumeContainerName: JString (required)
  ##                      : The volume container name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   volumeName: JString (required)
  ##             : The volume name.
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569104 = path.getOrDefault("resourceGroupName")
  valid_569104 = validateParameter(valid_569104, JString, required = true,
                                 default = nil)
  if valid_569104 != nil:
    section.add "resourceGroupName", valid_569104
  var valid_569105 = path.getOrDefault("managerName")
  valid_569105 = validateParameter(valid_569105, JString, required = true,
                                 default = nil)
  if valid_569105 != nil:
    section.add "managerName", valid_569105
  var valid_569106 = path.getOrDefault("volumeContainerName")
  valid_569106 = validateParameter(valid_569106, JString, required = true,
                                 default = nil)
  if valid_569106 != nil:
    section.add "volumeContainerName", valid_569106
  var valid_569107 = path.getOrDefault("subscriptionId")
  valid_569107 = validateParameter(valid_569107, JString, required = true,
                                 default = nil)
  if valid_569107 != nil:
    section.add "subscriptionId", valid_569107
  var valid_569108 = path.getOrDefault("volumeName")
  valid_569108 = validateParameter(valid_569108, JString, required = true,
                                 default = nil)
  if valid_569108 != nil:
    section.add "volumeName", valid_569108
  var valid_569109 = path.getOrDefault("deviceName")
  valid_569109 = validateParameter(valid_569109, JString, required = true,
                                 default = nil)
  if valid_569109 != nil:
    section.add "deviceName", valid_569109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569110 = query.getOrDefault("api-version")
  valid_569110 = validateParameter(valid_569110, JString, required = true,
                                 default = nil)
  if valid_569110 != nil:
    section.add "api-version", valid_569110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569111: Call_VolumesListMetricDefinition_569101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metric definitions for the specified volume.
  ## 
  let valid = call_569111.validator(path, query, header, formData, body)
  let scheme = call_569111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569111.url(scheme.get, call_569111.host, call_569111.base,
                         call_569111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569111, url, valid)

proc call*(call_569112: Call_VolumesListMetricDefinition_569101;
          resourceGroupName: string; apiVersion: string; managerName: string;
          volumeContainerName: string; subscriptionId: string; volumeName: string;
          deviceName: string): Recallable =
  ## volumesListMetricDefinition
  ## Gets the metric definitions for the specified volume.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   volumeContainerName: string (required)
  ##                      : The volume container name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   volumeName: string (required)
  ##             : The volume name.
  ##   deviceName: string (required)
  ##             : The device name
  var path_569113 = newJObject()
  var query_569114 = newJObject()
  add(path_569113, "resourceGroupName", newJString(resourceGroupName))
  add(query_569114, "api-version", newJString(apiVersion))
  add(path_569113, "managerName", newJString(managerName))
  add(path_569113, "volumeContainerName", newJString(volumeContainerName))
  add(path_569113, "subscriptionId", newJString(subscriptionId))
  add(path_569113, "volumeName", newJString(volumeName))
  add(path_569113, "deviceName", newJString(deviceName))
  result = call_569112.call(path_569113, query_569114, nil, nil, nil)

var volumesListMetricDefinition* = Call_VolumesListMetricDefinition_569101(
    name: "volumesListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}/metricsDefinitions",
    validator: validate_VolumesListMetricDefinition_569102, base: "",
    url: url_VolumesListMetricDefinition_569103, schemes: {Scheme.Https})
type
  Call_VolumesListByDevice_569115 = ref object of OpenApiRestCall_567667
proc url_VolumesListByDevice_569117(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/volumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesListByDevice_569116(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves all the volumes in a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The device name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569118 = path.getOrDefault("resourceGroupName")
  valid_569118 = validateParameter(valid_569118, JString, required = true,
                                 default = nil)
  if valid_569118 != nil:
    section.add "resourceGroupName", valid_569118
  var valid_569119 = path.getOrDefault("managerName")
  valid_569119 = validateParameter(valid_569119, JString, required = true,
                                 default = nil)
  if valid_569119 != nil:
    section.add "managerName", valid_569119
  var valid_569120 = path.getOrDefault("subscriptionId")
  valid_569120 = validateParameter(valid_569120, JString, required = true,
                                 default = nil)
  if valid_569120 != nil:
    section.add "subscriptionId", valid_569120
  var valid_569121 = path.getOrDefault("deviceName")
  valid_569121 = validateParameter(valid_569121, JString, required = true,
                                 default = nil)
  if valid_569121 != nil:
    section.add "deviceName", valid_569121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569122 = query.getOrDefault("api-version")
  valid_569122 = validateParameter(valid_569122, JString, required = true,
                                 default = nil)
  if valid_569122 != nil:
    section.add "api-version", valid_569122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569123: Call_VolumesListByDevice_569115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the volumes in a device.
  ## 
  let valid = call_569123.validator(path, query, header, formData, body)
  let scheme = call_569123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569123.url(scheme.get, call_569123.host, call_569123.base,
                         call_569123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569123, url, valid)

proc call*(call_569124: Call_VolumesListByDevice_569115; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          deviceName: string): Recallable =
  ## volumesListByDevice
  ## Retrieves all the volumes in a device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name
  var path_569125 = newJObject()
  var query_569126 = newJObject()
  add(path_569125, "resourceGroupName", newJString(resourceGroupName))
  add(query_569126, "api-version", newJString(apiVersion))
  add(path_569125, "managerName", newJString(managerName))
  add(path_569125, "subscriptionId", newJString(subscriptionId))
  add(path_569125, "deviceName", newJString(deviceName))
  result = call_569124.call(path_569125, query_569126, nil, nil, nil)

var volumesListByDevice* = Call_VolumesListByDevice_569115(
    name: "volumesListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumes",
    validator: validate_VolumesListByDevice_569116, base: "",
    url: url_VolumesListByDevice_569117, schemes: {Scheme.Https})
type
  Call_DevicesFailover_569127 = ref object of OpenApiRestCall_567667
proc url_DevicesFailover_569129(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "sourceDeviceName" in path,
        "`sourceDeviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "sourceDeviceName"),
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesFailover_569128(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Failovers a set of volume containers from a specified source device to a target device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   sourceDeviceName: JString (required)
  ##                   : The source device name on which failover is performed.
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569130 = path.getOrDefault("resourceGroupName")
  valid_569130 = validateParameter(valid_569130, JString, required = true,
                                 default = nil)
  if valid_569130 != nil:
    section.add "resourceGroupName", valid_569130
  var valid_569131 = path.getOrDefault("sourceDeviceName")
  valid_569131 = validateParameter(valid_569131, JString, required = true,
                                 default = nil)
  if valid_569131 != nil:
    section.add "sourceDeviceName", valid_569131
  var valid_569132 = path.getOrDefault("managerName")
  valid_569132 = validateParameter(valid_569132, JString, required = true,
                                 default = nil)
  if valid_569132 != nil:
    section.add "managerName", valid_569132
  var valid_569133 = path.getOrDefault("subscriptionId")
  valid_569133 = validateParameter(valid_569133, JString, required = true,
                                 default = nil)
  if valid_569133 != nil:
    section.add "subscriptionId", valid_569133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569134 = query.getOrDefault("api-version")
  valid_569134 = validateParameter(valid_569134, JString, required = true,
                                 default = nil)
  if valid_569134 != nil:
    section.add "api-version", valid_569134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : FailoverRequest containing the source device and the list of volume containers to be failed over.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569136: Call_DevicesFailover_569127; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Failovers a set of volume containers from a specified source device to a target device.
  ## 
  let valid = call_569136.validator(path, query, header, formData, body)
  let scheme = call_569136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569136.url(scheme.get, call_569136.host, call_569136.base,
                         call_569136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569136, url, valid)

proc call*(call_569137: Call_DevicesFailover_569127; resourceGroupName: string;
          sourceDeviceName: string; apiVersion: string; managerName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## devicesFailover
  ## Failovers a set of volume containers from a specified source device to a target device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   sourceDeviceName: string (required)
  ##                   : The source device name on which failover is performed.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : FailoverRequest containing the source device and the list of volume containers to be failed over.
  var path_569138 = newJObject()
  var query_569139 = newJObject()
  var body_569140 = newJObject()
  add(path_569138, "resourceGroupName", newJString(resourceGroupName))
  add(path_569138, "sourceDeviceName", newJString(sourceDeviceName))
  add(query_569139, "api-version", newJString(apiVersion))
  add(path_569138, "managerName", newJString(managerName))
  add(path_569138, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569140 = parameters
  result = call_569137.call(path_569138, query_569139, nil, nil, body_569140)

var devicesFailover* = Call_DevicesFailover_569127(name: "devicesFailover",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{sourceDeviceName}/failover",
    validator: validate_DevicesFailover_569128, base: "", url: url_DevicesFailover_569129,
    schemes: {Scheme.Https})
type
  Call_DevicesListFailoverTargets_569141 = ref object of OpenApiRestCall_567667
proc url_DevicesListFailoverTargets_569143(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "sourceDeviceName" in path,
        "`sourceDeviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "sourceDeviceName"),
               (kind: ConstantSegment, value: "/listFailoverTargets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListFailoverTargets_569142(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Given a list of volume containers to be failed over from a source device, this method returns the eligibility result, as a failover target, for all devices under that resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   sourceDeviceName: JString (required)
  ##                   : The source device name on which failover is performed.
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569144 = path.getOrDefault("resourceGroupName")
  valid_569144 = validateParameter(valid_569144, JString, required = true,
                                 default = nil)
  if valid_569144 != nil:
    section.add "resourceGroupName", valid_569144
  var valid_569145 = path.getOrDefault("sourceDeviceName")
  valid_569145 = validateParameter(valid_569145, JString, required = true,
                                 default = nil)
  if valid_569145 != nil:
    section.add "sourceDeviceName", valid_569145
  var valid_569146 = path.getOrDefault("managerName")
  valid_569146 = validateParameter(valid_569146, JString, required = true,
                                 default = nil)
  if valid_569146 != nil:
    section.add "managerName", valid_569146
  var valid_569147 = path.getOrDefault("subscriptionId")
  valid_569147 = validateParameter(valid_569147, JString, required = true,
                                 default = nil)
  if valid_569147 != nil:
    section.add "subscriptionId", valid_569147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569148 = query.getOrDefault("api-version")
  valid_569148 = validateParameter(valid_569148, JString, required = true,
                                 default = nil)
  if valid_569148 != nil:
    section.add "api-version", valid_569148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : ListFailoverTargetsRequest containing the list of volume containers to be failed over.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569150: Call_DevicesListFailoverTargets_569141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Given a list of volume containers to be failed over from a source device, this method returns the eligibility result, as a failover target, for all devices under that resource.
  ## 
  let valid = call_569150.validator(path, query, header, formData, body)
  let scheme = call_569150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569150.url(scheme.get, call_569150.host, call_569150.base,
                         call_569150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569150, url, valid)

proc call*(call_569151: Call_DevicesListFailoverTargets_569141;
          resourceGroupName: string; sourceDeviceName: string; apiVersion: string;
          managerName: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## devicesListFailoverTargets
  ## Given a list of volume containers to be failed over from a source device, this method returns the eligibility result, as a failover target, for all devices under that resource.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   sourceDeviceName: string (required)
  ##                   : The source device name on which failover is performed.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : ListFailoverTargetsRequest containing the list of volume containers to be failed over.
  var path_569152 = newJObject()
  var query_569153 = newJObject()
  var body_569154 = newJObject()
  add(path_569152, "resourceGroupName", newJString(resourceGroupName))
  add(path_569152, "sourceDeviceName", newJString(sourceDeviceName))
  add(query_569153, "api-version", newJString(apiVersion))
  add(path_569152, "managerName", newJString(managerName))
  add(path_569152, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569154 = parameters
  result = call_569151.call(path_569152, query_569153, nil, nil, body_569154)

var devicesListFailoverTargets* = Call_DevicesListFailoverTargets_569141(
    name: "devicesListFailoverTargets", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{sourceDeviceName}/listFailoverTargets",
    validator: validate_DevicesListFailoverTargets_569142, base: "",
    url: url_DevicesListFailoverTargets_569143, schemes: {Scheme.Https})
type
  Call_ManagersGetEncryptionSettings_569155 = ref object of OpenApiRestCall_567667
proc url_ManagersGetEncryptionSettings_569157(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/encryptionSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGetEncryptionSettings_569156(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the encryption settings of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569158 = path.getOrDefault("resourceGroupName")
  valid_569158 = validateParameter(valid_569158, JString, required = true,
                                 default = nil)
  if valid_569158 != nil:
    section.add "resourceGroupName", valid_569158
  var valid_569159 = path.getOrDefault("managerName")
  valid_569159 = validateParameter(valid_569159, JString, required = true,
                                 default = nil)
  if valid_569159 != nil:
    section.add "managerName", valid_569159
  var valid_569160 = path.getOrDefault("subscriptionId")
  valid_569160 = validateParameter(valid_569160, JString, required = true,
                                 default = nil)
  if valid_569160 != nil:
    section.add "subscriptionId", valid_569160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569161 = query.getOrDefault("api-version")
  valid_569161 = validateParameter(valid_569161, JString, required = true,
                                 default = nil)
  if valid_569161 != nil:
    section.add "api-version", valid_569161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569162: Call_ManagersGetEncryptionSettings_569155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the encryption settings of the manager.
  ## 
  let valid = call_569162.validator(path, query, header, formData, body)
  let scheme = call_569162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569162.url(scheme.get, call_569162.host, call_569162.base,
                         call_569162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569162, url, valid)

proc call*(call_569163: Call_ManagersGetEncryptionSettings_569155;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## managersGetEncryptionSettings
  ## Returns the encryption settings of the manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569164 = newJObject()
  var query_569165 = newJObject()
  add(path_569164, "resourceGroupName", newJString(resourceGroupName))
  add(query_569165, "api-version", newJString(apiVersion))
  add(path_569164, "managerName", newJString(managerName))
  add(path_569164, "subscriptionId", newJString(subscriptionId))
  result = call_569163.call(path_569164, query_569165, nil, nil, nil)

var managersGetEncryptionSettings* = Call_ManagersGetEncryptionSettings_569155(
    name: "managersGetEncryptionSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/encryptionSettings/default",
    validator: validate_ManagersGetEncryptionSettings_569156, base: "",
    url: url_ManagersGetEncryptionSettings_569157, schemes: {Scheme.Https})
type
  Call_ManagersCreateExtendedInfo_569177 = ref object of OpenApiRestCall_567667
proc url_ManagersCreateExtendedInfo_569179(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"), (
        kind: ConstantSegment, value: "/extendedInformation/vaultExtendedInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersCreateExtendedInfo_569178(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the extended info of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569180 = path.getOrDefault("resourceGroupName")
  valid_569180 = validateParameter(valid_569180, JString, required = true,
                                 default = nil)
  if valid_569180 != nil:
    section.add "resourceGroupName", valid_569180
  var valid_569181 = path.getOrDefault("managerName")
  valid_569181 = validateParameter(valid_569181, JString, required = true,
                                 default = nil)
  if valid_569181 != nil:
    section.add "managerName", valid_569181
  var valid_569182 = path.getOrDefault("subscriptionId")
  valid_569182 = validateParameter(valid_569182, JString, required = true,
                                 default = nil)
  if valid_569182 != nil:
    section.add "subscriptionId", valid_569182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569183 = query.getOrDefault("api-version")
  valid_569183 = validateParameter(valid_569183, JString, required = true,
                                 default = nil)
  if valid_569183 != nil:
    section.add "api-version", valid_569183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The manager extended information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569185: Call_ManagersCreateExtendedInfo_569177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the extended info of the manager.
  ## 
  let valid = call_569185.validator(path, query, header, formData, body)
  let scheme = call_569185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569185.url(scheme.get, call_569185.host, call_569185.base,
                         call_569185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569185, url, valid)

proc call*(call_569186: Call_ManagersCreateExtendedInfo_569177;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## managersCreateExtendedInfo
  ## Creates the extended info of the manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The manager extended information.
  var path_569187 = newJObject()
  var query_569188 = newJObject()
  var body_569189 = newJObject()
  add(path_569187, "resourceGroupName", newJString(resourceGroupName))
  add(query_569188, "api-version", newJString(apiVersion))
  add(path_569187, "managerName", newJString(managerName))
  add(path_569187, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569189 = parameters
  result = call_569186.call(path_569187, query_569188, nil, nil, body_569189)

var managersCreateExtendedInfo* = Call_ManagersCreateExtendedInfo_569177(
    name: "managersCreateExtendedInfo", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersCreateExtendedInfo_569178, base: "",
    url: url_ManagersCreateExtendedInfo_569179, schemes: {Scheme.Https})
type
  Call_ManagersGetExtendedInfo_569166 = ref object of OpenApiRestCall_567667
proc url_ManagersGetExtendedInfo_569168(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"), (
        kind: ConstantSegment, value: "/extendedInformation/vaultExtendedInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGetExtendedInfo_569167(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the extended information of the specified manager name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569169 = path.getOrDefault("resourceGroupName")
  valid_569169 = validateParameter(valid_569169, JString, required = true,
                                 default = nil)
  if valid_569169 != nil:
    section.add "resourceGroupName", valid_569169
  var valid_569170 = path.getOrDefault("managerName")
  valid_569170 = validateParameter(valid_569170, JString, required = true,
                                 default = nil)
  if valid_569170 != nil:
    section.add "managerName", valid_569170
  var valid_569171 = path.getOrDefault("subscriptionId")
  valid_569171 = validateParameter(valid_569171, JString, required = true,
                                 default = nil)
  if valid_569171 != nil:
    section.add "subscriptionId", valid_569171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569172 = query.getOrDefault("api-version")
  valid_569172 = validateParameter(valid_569172, JString, required = true,
                                 default = nil)
  if valid_569172 != nil:
    section.add "api-version", valid_569172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569173: Call_ManagersGetExtendedInfo_569166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the extended information of the specified manager name.
  ## 
  let valid = call_569173.validator(path, query, header, formData, body)
  let scheme = call_569173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569173.url(scheme.get, call_569173.host, call_569173.base,
                         call_569173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569173, url, valid)

proc call*(call_569174: Call_ManagersGetExtendedInfo_569166;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## managersGetExtendedInfo
  ## Returns the extended information of the specified manager name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569175 = newJObject()
  var query_569176 = newJObject()
  add(path_569175, "resourceGroupName", newJString(resourceGroupName))
  add(query_569176, "api-version", newJString(apiVersion))
  add(path_569175, "managerName", newJString(managerName))
  add(path_569175, "subscriptionId", newJString(subscriptionId))
  result = call_569174.call(path_569175, query_569176, nil, nil, nil)

var managersGetExtendedInfo* = Call_ManagersGetExtendedInfo_569166(
    name: "managersGetExtendedInfo", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersGetExtendedInfo_569167, base: "",
    url: url_ManagersGetExtendedInfo_569168, schemes: {Scheme.Https})
type
  Call_ManagersUpdateExtendedInfo_569201 = ref object of OpenApiRestCall_567667
proc url_ManagersUpdateExtendedInfo_569203(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"), (
        kind: ConstantSegment, value: "/extendedInformation/vaultExtendedInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersUpdateExtendedInfo_569202(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the extended info of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569204 = path.getOrDefault("resourceGroupName")
  valid_569204 = validateParameter(valid_569204, JString, required = true,
                                 default = nil)
  if valid_569204 != nil:
    section.add "resourceGroupName", valid_569204
  var valid_569205 = path.getOrDefault("managerName")
  valid_569205 = validateParameter(valid_569205, JString, required = true,
                                 default = nil)
  if valid_569205 != nil:
    section.add "managerName", valid_569205
  var valid_569206 = path.getOrDefault("subscriptionId")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = nil)
  if valid_569206 != nil:
    section.add "subscriptionId", valid_569206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569207 = query.getOrDefault("api-version")
  valid_569207 = validateParameter(valid_569207, JString, required = true,
                                 default = nil)
  if valid_569207 != nil:
    section.add "api-version", valid_569207
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : Pass the ETag of ExtendedInfo fetched from GET call
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_569208 = header.getOrDefault("If-Match")
  valid_569208 = validateParameter(valid_569208, JString, required = true,
                                 default = nil)
  if valid_569208 != nil:
    section.add "If-Match", valid_569208
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The manager extended information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569210: Call_ManagersUpdateExtendedInfo_569201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the extended info of the manager.
  ## 
  let valid = call_569210.validator(path, query, header, formData, body)
  let scheme = call_569210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569210.url(scheme.get, call_569210.host, call_569210.base,
                         call_569210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569210, url, valid)

proc call*(call_569211: Call_ManagersUpdateExtendedInfo_569201;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## managersUpdateExtendedInfo
  ## Updates the extended info of the manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The manager extended information.
  var path_569212 = newJObject()
  var query_569213 = newJObject()
  var body_569214 = newJObject()
  add(path_569212, "resourceGroupName", newJString(resourceGroupName))
  add(query_569213, "api-version", newJString(apiVersion))
  add(path_569212, "managerName", newJString(managerName))
  add(path_569212, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569214 = parameters
  result = call_569211.call(path_569212, query_569213, nil, nil, body_569214)

var managersUpdateExtendedInfo* = Call_ManagersUpdateExtendedInfo_569201(
    name: "managersUpdateExtendedInfo", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersUpdateExtendedInfo_569202, base: "",
    url: url_ManagersUpdateExtendedInfo_569203, schemes: {Scheme.Https})
type
  Call_ManagersDeleteExtendedInfo_569190 = ref object of OpenApiRestCall_567667
proc url_ManagersDeleteExtendedInfo_569192(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"), (
        kind: ConstantSegment, value: "/extendedInformation/vaultExtendedInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersDeleteExtendedInfo_569191(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the extended info of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569193 = path.getOrDefault("resourceGroupName")
  valid_569193 = validateParameter(valid_569193, JString, required = true,
                                 default = nil)
  if valid_569193 != nil:
    section.add "resourceGroupName", valid_569193
  var valid_569194 = path.getOrDefault("managerName")
  valid_569194 = validateParameter(valid_569194, JString, required = true,
                                 default = nil)
  if valid_569194 != nil:
    section.add "managerName", valid_569194
  var valid_569195 = path.getOrDefault("subscriptionId")
  valid_569195 = validateParameter(valid_569195, JString, required = true,
                                 default = nil)
  if valid_569195 != nil:
    section.add "subscriptionId", valid_569195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569196 = query.getOrDefault("api-version")
  valid_569196 = validateParameter(valid_569196, JString, required = true,
                                 default = nil)
  if valid_569196 != nil:
    section.add "api-version", valid_569196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569197: Call_ManagersDeleteExtendedInfo_569190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the extended info of the manager.
  ## 
  let valid = call_569197.validator(path, query, header, formData, body)
  let scheme = call_569197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569197.url(scheme.get, call_569197.host, call_569197.base,
                         call_569197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569197, url, valid)

proc call*(call_569198: Call_ManagersDeleteExtendedInfo_569190;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## managersDeleteExtendedInfo
  ## Deletes the extended info of the manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569199 = newJObject()
  var query_569200 = newJObject()
  add(path_569199, "resourceGroupName", newJString(resourceGroupName))
  add(query_569200, "api-version", newJString(apiVersion))
  add(path_569199, "managerName", newJString(managerName))
  add(path_569199, "subscriptionId", newJString(subscriptionId))
  result = call_569198.call(path_569199, query_569200, nil, nil, nil)

var managersDeleteExtendedInfo* = Call_ManagersDeleteExtendedInfo_569190(
    name: "managersDeleteExtendedInfo", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersDeleteExtendedInfo_569191, base: "",
    url: url_ManagersDeleteExtendedInfo_569192, schemes: {Scheme.Https})
type
  Call_ManagersListFeatureSupportStatus_569215 = ref object of OpenApiRestCall_567667
proc url_ManagersListFeatureSupportStatus_569217(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/features")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersListFeatureSupportStatus_569216(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the features and their support status
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569218 = path.getOrDefault("resourceGroupName")
  valid_569218 = validateParameter(valid_569218, JString, required = true,
                                 default = nil)
  if valid_569218 != nil:
    section.add "resourceGroupName", valid_569218
  var valid_569219 = path.getOrDefault("managerName")
  valid_569219 = validateParameter(valid_569219, JString, required = true,
                                 default = nil)
  if valid_569219 != nil:
    section.add "managerName", valid_569219
  var valid_569220 = path.getOrDefault("subscriptionId")
  valid_569220 = validateParameter(valid_569220, JString, required = true,
                                 default = nil)
  if valid_569220 != nil:
    section.add "subscriptionId", valid_569220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569221 = query.getOrDefault("api-version")
  valid_569221 = validateParameter(valid_569221, JString, required = true,
                                 default = nil)
  if valid_569221 != nil:
    section.add "api-version", valid_569221
  var valid_569222 = query.getOrDefault("$filter")
  valid_569222 = validateParameter(valid_569222, JString, required = false,
                                 default = nil)
  if valid_569222 != nil:
    section.add "$filter", valid_569222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569223: Call_ManagersListFeatureSupportStatus_569215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the features and their support status
  ## 
  let valid = call_569223.validator(path, query, header, formData, body)
  let scheme = call_569223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569223.url(scheme.get, call_569223.host, call_569223.base,
                         call_569223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569223, url, valid)

proc call*(call_569224: Call_ManagersListFeatureSupportStatus_569215;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## managersListFeatureSupportStatus
  ## Lists the features and their support status
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   Filter: string
  ##         : OData Filter options
  var path_569225 = newJObject()
  var query_569226 = newJObject()
  add(path_569225, "resourceGroupName", newJString(resourceGroupName))
  add(query_569226, "api-version", newJString(apiVersion))
  add(path_569225, "managerName", newJString(managerName))
  add(path_569225, "subscriptionId", newJString(subscriptionId))
  add(query_569226, "$filter", newJString(Filter))
  result = call_569224.call(path_569225, query_569226, nil, nil, nil)

var managersListFeatureSupportStatus* = Call_ManagersListFeatureSupportStatus_569215(
    name: "managersListFeatureSupportStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/features",
    validator: validate_ManagersListFeatureSupportStatus_569216, base: "",
    url: url_ManagersListFeatureSupportStatus_569217, schemes: {Scheme.Https})
type
  Call_JobsListByManager_569227 = ref object of OpenApiRestCall_567667
proc url_JobsListByManager_569229(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsListByManager_569228(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all the jobs for the specified manager. With optional OData query parameters, a filtered set of jobs is returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569230 = path.getOrDefault("resourceGroupName")
  valid_569230 = validateParameter(valid_569230, JString, required = true,
                                 default = nil)
  if valid_569230 != nil:
    section.add "resourceGroupName", valid_569230
  var valid_569231 = path.getOrDefault("managerName")
  valid_569231 = validateParameter(valid_569231, JString, required = true,
                                 default = nil)
  if valid_569231 != nil:
    section.add "managerName", valid_569231
  var valid_569232 = path.getOrDefault("subscriptionId")
  valid_569232 = validateParameter(valid_569232, JString, required = true,
                                 default = nil)
  if valid_569232 != nil:
    section.add "subscriptionId", valid_569232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569233 = query.getOrDefault("api-version")
  valid_569233 = validateParameter(valid_569233, JString, required = true,
                                 default = nil)
  if valid_569233 != nil:
    section.add "api-version", valid_569233
  var valid_569234 = query.getOrDefault("$filter")
  valid_569234 = validateParameter(valid_569234, JString, required = false,
                                 default = nil)
  if valid_569234 != nil:
    section.add "$filter", valid_569234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569235: Call_JobsListByManager_569227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the jobs for the specified manager. With optional OData query parameters, a filtered set of jobs is returned.
  ## 
  let valid = call_569235.validator(path, query, header, formData, body)
  let scheme = call_569235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569235.url(scheme.get, call_569235.host, call_569235.base,
                         call_569235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569235, url, valid)

proc call*(call_569236: Call_JobsListByManager_569227; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## jobsListByManager
  ## Gets all the jobs for the specified manager. With optional OData query parameters, a filtered set of jobs is returned.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   Filter: string
  ##         : OData Filter options
  var path_569237 = newJObject()
  var query_569238 = newJObject()
  add(path_569237, "resourceGroupName", newJString(resourceGroupName))
  add(query_569238, "api-version", newJString(apiVersion))
  add(path_569237, "managerName", newJString(managerName))
  add(path_569237, "subscriptionId", newJString(subscriptionId))
  add(query_569238, "$filter", newJString(Filter))
  result = call_569236.call(path_569237, query_569238, nil, nil, nil)

var jobsListByManager* = Call_JobsListByManager_569227(name: "jobsListByManager",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/jobs",
    validator: validate_JobsListByManager_569228, base: "",
    url: url_JobsListByManager_569229, schemes: {Scheme.Https})
type
  Call_ManagersGetActivationKey_569239 = ref object of OpenApiRestCall_567667
proc url_ManagersGetActivationKey_569241(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/listActivationKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGetActivationKey_569240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the activation key of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569242 = path.getOrDefault("resourceGroupName")
  valid_569242 = validateParameter(valid_569242, JString, required = true,
                                 default = nil)
  if valid_569242 != nil:
    section.add "resourceGroupName", valid_569242
  var valid_569243 = path.getOrDefault("managerName")
  valid_569243 = validateParameter(valid_569243, JString, required = true,
                                 default = nil)
  if valid_569243 != nil:
    section.add "managerName", valid_569243
  var valid_569244 = path.getOrDefault("subscriptionId")
  valid_569244 = validateParameter(valid_569244, JString, required = true,
                                 default = nil)
  if valid_569244 != nil:
    section.add "subscriptionId", valid_569244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569245 = query.getOrDefault("api-version")
  valid_569245 = validateParameter(valid_569245, JString, required = true,
                                 default = nil)
  if valid_569245 != nil:
    section.add "api-version", valid_569245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569246: Call_ManagersGetActivationKey_569239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the activation key of the manager.
  ## 
  let valid = call_569246.validator(path, query, header, formData, body)
  let scheme = call_569246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569246.url(scheme.get, call_569246.host, call_569246.base,
                         call_569246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569246, url, valid)

proc call*(call_569247: Call_ManagersGetActivationKey_569239;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## managersGetActivationKey
  ## Returns the activation key of the manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569248 = newJObject()
  var query_569249 = newJObject()
  add(path_569248, "resourceGroupName", newJString(resourceGroupName))
  add(query_569249, "api-version", newJString(apiVersion))
  add(path_569248, "managerName", newJString(managerName))
  add(path_569248, "subscriptionId", newJString(subscriptionId))
  result = call_569247.call(path_569248, query_569249, nil, nil, nil)

var managersGetActivationKey* = Call_ManagersGetActivationKey_569239(
    name: "managersGetActivationKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/listActivationKey",
    validator: validate_ManagersGetActivationKey_569240, base: "",
    url: url_ManagersGetActivationKey_569241, schemes: {Scheme.Https})
type
  Call_ManagersGetPublicEncryptionKey_569250 = ref object of OpenApiRestCall_567667
proc url_ManagersGetPublicEncryptionKey_569252(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/listPublicEncryptionKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGetPublicEncryptionKey_569251(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the symmetric encrypted public encryption key of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569253 = path.getOrDefault("resourceGroupName")
  valid_569253 = validateParameter(valid_569253, JString, required = true,
                                 default = nil)
  if valid_569253 != nil:
    section.add "resourceGroupName", valid_569253
  var valid_569254 = path.getOrDefault("managerName")
  valid_569254 = validateParameter(valid_569254, JString, required = true,
                                 default = nil)
  if valid_569254 != nil:
    section.add "managerName", valid_569254
  var valid_569255 = path.getOrDefault("subscriptionId")
  valid_569255 = validateParameter(valid_569255, JString, required = true,
                                 default = nil)
  if valid_569255 != nil:
    section.add "subscriptionId", valid_569255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569256 = query.getOrDefault("api-version")
  valid_569256 = validateParameter(valid_569256, JString, required = true,
                                 default = nil)
  if valid_569256 != nil:
    section.add "api-version", valid_569256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569257: Call_ManagersGetPublicEncryptionKey_569250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the symmetric encrypted public encryption key of the manager.
  ## 
  let valid = call_569257.validator(path, query, header, formData, body)
  let scheme = call_569257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569257.url(scheme.get, call_569257.host, call_569257.base,
                         call_569257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569257, url, valid)

proc call*(call_569258: Call_ManagersGetPublicEncryptionKey_569250;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## managersGetPublicEncryptionKey
  ## Returns the symmetric encrypted public encryption key of the manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569259 = newJObject()
  var query_569260 = newJObject()
  add(path_569259, "resourceGroupName", newJString(resourceGroupName))
  add(query_569260, "api-version", newJString(apiVersion))
  add(path_569259, "managerName", newJString(managerName))
  add(path_569259, "subscriptionId", newJString(subscriptionId))
  result = call_569258.call(path_569259, query_569260, nil, nil, nil)

var managersGetPublicEncryptionKey* = Call_ManagersGetPublicEncryptionKey_569250(
    name: "managersGetPublicEncryptionKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/listPublicEncryptionKey",
    validator: validate_ManagersGetPublicEncryptionKey_569251, base: "",
    url: url_ManagersGetPublicEncryptionKey_569252, schemes: {Scheme.Https})
type
  Call_ManagersListMetrics_569261 = ref object of OpenApiRestCall_567667
proc url_ManagersListMetrics_569263(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersListMetrics_569262(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the metrics for the specified manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569264 = path.getOrDefault("resourceGroupName")
  valid_569264 = validateParameter(valid_569264, JString, required = true,
                                 default = nil)
  if valid_569264 != nil:
    section.add "resourceGroupName", valid_569264
  var valid_569265 = path.getOrDefault("managerName")
  valid_569265 = validateParameter(valid_569265, JString, required = true,
                                 default = nil)
  if valid_569265 != nil:
    section.add "managerName", valid_569265
  var valid_569266 = path.getOrDefault("subscriptionId")
  valid_569266 = validateParameter(valid_569266, JString, required = true,
                                 default = nil)
  if valid_569266 != nil:
    section.add "subscriptionId", valid_569266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString (required)
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569267 = query.getOrDefault("api-version")
  valid_569267 = validateParameter(valid_569267, JString, required = true,
                                 default = nil)
  if valid_569267 != nil:
    section.add "api-version", valid_569267
  var valid_569268 = query.getOrDefault("$filter")
  valid_569268 = validateParameter(valid_569268, JString, required = true,
                                 default = nil)
  if valid_569268 != nil:
    section.add "$filter", valid_569268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569269: Call_ManagersListMetrics_569261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metrics for the specified manager.
  ## 
  let valid = call_569269.validator(path, query, header, formData, body)
  let scheme = call_569269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569269.url(scheme.get, call_569269.host, call_569269.base,
                         call_569269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569269, url, valid)

proc call*(call_569270: Call_ManagersListMetrics_569261; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          Filter: string): Recallable =
  ## managersListMetrics
  ## Gets the metrics for the specified manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   Filter: string (required)
  ##         : OData Filter options
  var path_569271 = newJObject()
  var query_569272 = newJObject()
  add(path_569271, "resourceGroupName", newJString(resourceGroupName))
  add(query_569272, "api-version", newJString(apiVersion))
  add(path_569271, "managerName", newJString(managerName))
  add(path_569271, "subscriptionId", newJString(subscriptionId))
  add(query_569272, "$filter", newJString(Filter))
  result = call_569270.call(path_569271, query_569272, nil, nil, nil)

var managersListMetrics* = Call_ManagersListMetrics_569261(
    name: "managersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/metrics",
    validator: validate_ManagersListMetrics_569262, base: "",
    url: url_ManagersListMetrics_569263, schemes: {Scheme.Https})
type
  Call_ManagersListMetricDefinition_569273 = ref object of OpenApiRestCall_567667
proc url_ManagersListMetricDefinition_569275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersListMetricDefinition_569274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metric definitions for the specified manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569276 = path.getOrDefault("resourceGroupName")
  valid_569276 = validateParameter(valid_569276, JString, required = true,
                                 default = nil)
  if valid_569276 != nil:
    section.add "resourceGroupName", valid_569276
  var valid_569277 = path.getOrDefault("managerName")
  valid_569277 = validateParameter(valid_569277, JString, required = true,
                                 default = nil)
  if valid_569277 != nil:
    section.add "managerName", valid_569277
  var valid_569278 = path.getOrDefault("subscriptionId")
  valid_569278 = validateParameter(valid_569278, JString, required = true,
                                 default = nil)
  if valid_569278 != nil:
    section.add "subscriptionId", valid_569278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569279 = query.getOrDefault("api-version")
  valid_569279 = validateParameter(valid_569279, JString, required = true,
                                 default = nil)
  if valid_569279 != nil:
    section.add "api-version", valid_569279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569280: Call_ManagersListMetricDefinition_569273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metric definitions for the specified manager.
  ## 
  let valid = call_569280.validator(path, query, header, formData, body)
  let scheme = call_569280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569280.url(scheme.get, call_569280.host, call_569280.base,
                         call_569280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569280, url, valid)

proc call*(call_569281: Call_ManagersListMetricDefinition_569273;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## managersListMetricDefinition
  ## Gets the metric definitions for the specified manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569282 = newJObject()
  var query_569283 = newJObject()
  add(path_569282, "resourceGroupName", newJString(resourceGroupName))
  add(query_569283, "api-version", newJString(apiVersion))
  add(path_569282, "managerName", newJString(managerName))
  add(path_569282, "subscriptionId", newJString(subscriptionId))
  result = call_569281.call(path_569282, query_569283, nil, nil, nil)

var managersListMetricDefinition* = Call_ManagersListMetricDefinition_569273(
    name: "managersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/metricsDefinitions",
    validator: validate_ManagersListMetricDefinition_569274, base: "",
    url: url_ManagersListMetricDefinition_569275, schemes: {Scheme.Https})
type
  Call_CloudAppliancesProvision_569284 = ref object of OpenApiRestCall_567667
proc url_CloudAppliancesProvision_569286(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/provisionCloudAppliance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudAppliancesProvision_569285(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions cloud appliance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569287 = path.getOrDefault("resourceGroupName")
  valid_569287 = validateParameter(valid_569287, JString, required = true,
                                 default = nil)
  if valid_569287 != nil:
    section.add "resourceGroupName", valid_569287
  var valid_569288 = path.getOrDefault("managerName")
  valid_569288 = validateParameter(valid_569288, JString, required = true,
                                 default = nil)
  if valid_569288 != nil:
    section.add "managerName", valid_569288
  var valid_569289 = path.getOrDefault("subscriptionId")
  valid_569289 = validateParameter(valid_569289, JString, required = true,
                                 default = nil)
  if valid_569289 != nil:
    section.add "subscriptionId", valid_569289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569290 = query.getOrDefault("api-version")
  valid_569290 = validateParameter(valid_569290, JString, required = true,
                                 default = nil)
  if valid_569290 != nil:
    section.add "api-version", valid_569290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The cloud appliance
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569292: Call_CloudAppliancesProvision_569284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions cloud appliance.
  ## 
  let valid = call_569292.validator(path, query, header, formData, body)
  let scheme = call_569292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569292.url(scheme.get, call_569292.host, call_569292.base,
                         call_569292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569292, url, valid)

proc call*(call_569293: Call_CloudAppliancesProvision_569284;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## cloudAppliancesProvision
  ## Provisions cloud appliance.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   parameters: JObject (required)
  ##             : The cloud appliance
  var path_569294 = newJObject()
  var query_569295 = newJObject()
  var body_569296 = newJObject()
  add(path_569294, "resourceGroupName", newJString(resourceGroupName))
  add(query_569295, "api-version", newJString(apiVersion))
  add(path_569294, "managerName", newJString(managerName))
  add(path_569294, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_569296 = parameters
  result = call_569293.call(path_569294, query_569295, nil, nil, body_569296)

var cloudAppliancesProvision* = Call_CloudAppliancesProvision_569284(
    name: "cloudAppliancesProvision", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/provisionCloudAppliance",
    validator: validate_CloudAppliancesProvision_569285, base: "",
    url: url_CloudAppliancesProvision_569286, schemes: {Scheme.Https})
type
  Call_ManagersRegenerateActivationKey_569297 = ref object of OpenApiRestCall_567667
proc url_ManagersRegenerateActivationKey_569299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/regenerateActivationKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersRegenerateActivationKey_569298(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Re-generates and returns the activation key of the manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569300 = path.getOrDefault("resourceGroupName")
  valid_569300 = validateParameter(valid_569300, JString, required = true,
                                 default = nil)
  if valid_569300 != nil:
    section.add "resourceGroupName", valid_569300
  var valid_569301 = path.getOrDefault("managerName")
  valid_569301 = validateParameter(valid_569301, JString, required = true,
                                 default = nil)
  if valid_569301 != nil:
    section.add "managerName", valid_569301
  var valid_569302 = path.getOrDefault("subscriptionId")
  valid_569302 = validateParameter(valid_569302, JString, required = true,
                                 default = nil)
  if valid_569302 != nil:
    section.add "subscriptionId", valid_569302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569303 = query.getOrDefault("api-version")
  valid_569303 = validateParameter(valid_569303, JString, required = true,
                                 default = nil)
  if valid_569303 != nil:
    section.add "api-version", valid_569303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569304: Call_ManagersRegenerateActivationKey_569297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Re-generates and returns the activation key of the manager.
  ## 
  let valid = call_569304.validator(path, query, header, formData, body)
  let scheme = call_569304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569304.url(scheme.get, call_569304.host, call_569304.base,
                         call_569304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569304, url, valid)

proc call*(call_569305: Call_ManagersRegenerateActivationKey_569297;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## managersRegenerateActivationKey
  ## Re-generates and returns the activation key of the manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569306 = newJObject()
  var query_569307 = newJObject()
  add(path_569306, "resourceGroupName", newJString(resourceGroupName))
  add(query_569307, "api-version", newJString(apiVersion))
  add(path_569306, "managerName", newJString(managerName))
  add(path_569306, "subscriptionId", newJString(subscriptionId))
  result = call_569305.call(path_569306, query_569307, nil, nil, nil)

var managersRegenerateActivationKey* = Call_ManagersRegenerateActivationKey_569297(
    name: "managersRegenerateActivationKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/regenerateActivationKey",
    validator: validate_ManagersRegenerateActivationKey_569298, base: "",
    url: url_ManagersRegenerateActivationKey_569299, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsListByManager_569308 = ref object of OpenApiRestCall_567667
proc url_StorageAccountCredentialsListByManager_569310(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsListByManager_569309(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the storage account credentials in a manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569311 = path.getOrDefault("resourceGroupName")
  valid_569311 = validateParameter(valid_569311, JString, required = true,
                                 default = nil)
  if valid_569311 != nil:
    section.add "resourceGroupName", valid_569311
  var valid_569312 = path.getOrDefault("managerName")
  valid_569312 = validateParameter(valid_569312, JString, required = true,
                                 default = nil)
  if valid_569312 != nil:
    section.add "managerName", valid_569312
  var valid_569313 = path.getOrDefault("subscriptionId")
  valid_569313 = validateParameter(valid_569313, JString, required = true,
                                 default = nil)
  if valid_569313 != nil:
    section.add "subscriptionId", valid_569313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569314 = query.getOrDefault("api-version")
  valid_569314 = validateParameter(valid_569314, JString, required = true,
                                 default = nil)
  if valid_569314 != nil:
    section.add "api-version", valid_569314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569315: Call_StorageAccountCredentialsListByManager_569308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the storage account credentials in a manager.
  ## 
  let valid = call_569315.validator(path, query, header, formData, body)
  let scheme = call_569315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569315.url(scheme.get, call_569315.host, call_569315.base,
                         call_569315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569315, url, valid)

proc call*(call_569316: Call_StorageAccountCredentialsListByManager_569308;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## storageAccountCredentialsListByManager
  ## Gets all the storage account credentials in a manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569317 = newJObject()
  var query_569318 = newJObject()
  add(path_569317, "resourceGroupName", newJString(resourceGroupName))
  add(query_569318, "api-version", newJString(apiVersion))
  add(path_569317, "managerName", newJString(managerName))
  add(path_569317, "subscriptionId", newJString(subscriptionId))
  result = call_569316.call(path_569317, query_569318, nil, nil, nil)

var storageAccountCredentialsListByManager* = Call_StorageAccountCredentialsListByManager_569308(
    name: "storageAccountCredentialsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials",
    validator: validate_StorageAccountCredentialsListByManager_569309, base: "",
    url: url_StorageAccountCredentialsListByManager_569310,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsCreateOrUpdate_569331 = ref object of OpenApiRestCall_567667
proc url_StorageAccountCredentialsCreateOrUpdate_569333(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "storageAccountCredentialName" in path,
        "`storageAccountCredentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "storageAccountCredentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsCreateOrUpdate_569332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the storage account credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   storageAccountCredentialName: JString (required)
  ##                               : The storage account credential name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569334 = path.getOrDefault("resourceGroupName")
  valid_569334 = validateParameter(valid_569334, JString, required = true,
                                 default = nil)
  if valid_569334 != nil:
    section.add "resourceGroupName", valid_569334
  var valid_569335 = path.getOrDefault("managerName")
  valid_569335 = validateParameter(valid_569335, JString, required = true,
                                 default = nil)
  if valid_569335 != nil:
    section.add "managerName", valid_569335
  var valid_569336 = path.getOrDefault("subscriptionId")
  valid_569336 = validateParameter(valid_569336, JString, required = true,
                                 default = nil)
  if valid_569336 != nil:
    section.add "subscriptionId", valid_569336
  var valid_569337 = path.getOrDefault("storageAccountCredentialName")
  valid_569337 = validateParameter(valid_569337, JString, required = true,
                                 default = nil)
  if valid_569337 != nil:
    section.add "storageAccountCredentialName", valid_569337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569338 = query.getOrDefault("api-version")
  valid_569338 = validateParameter(valid_569338, JString, required = true,
                                 default = nil)
  if valid_569338 != nil:
    section.add "api-version", valid_569338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The storage account credential to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569340: Call_StorageAccountCredentialsCreateOrUpdate_569331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the storage account credential.
  ## 
  let valid = call_569340.validator(path, query, header, formData, body)
  let scheme = call_569340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569340.url(scheme.get, call_569340.host, call_569340.base,
                         call_569340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569340, url, valid)

proc call*(call_569341: Call_StorageAccountCredentialsCreateOrUpdate_569331;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; storageAccountCredentialName: string;
          parameters: JsonNode): Recallable =
  ## storageAccountCredentialsCreateOrUpdate
  ## Creates or updates the storage account credential.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   storageAccountCredentialName: string (required)
  ##                               : The storage account credential name.
  ##   parameters: JObject (required)
  ##             : The storage account credential to be added or updated.
  var path_569342 = newJObject()
  var query_569343 = newJObject()
  var body_569344 = newJObject()
  add(path_569342, "resourceGroupName", newJString(resourceGroupName))
  add(query_569343, "api-version", newJString(apiVersion))
  add(path_569342, "managerName", newJString(managerName))
  add(path_569342, "subscriptionId", newJString(subscriptionId))
  add(path_569342, "storageAccountCredentialName",
      newJString(storageAccountCredentialName))
  if parameters != nil:
    body_569344 = parameters
  result = call_569341.call(path_569342, query_569343, nil, nil, body_569344)

var storageAccountCredentialsCreateOrUpdate* = Call_StorageAccountCredentialsCreateOrUpdate_569331(
    name: "storageAccountCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{storageAccountCredentialName}",
    validator: validate_StorageAccountCredentialsCreateOrUpdate_569332, base: "",
    url: url_StorageAccountCredentialsCreateOrUpdate_569333,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsGet_569319 = ref object of OpenApiRestCall_567667
proc url_StorageAccountCredentialsGet_569321(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "storageAccountCredentialName" in path,
        "`storageAccountCredentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "storageAccountCredentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsGet_569320(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified storage account credential name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   storageAccountCredentialName: JString (required)
  ##                               : The name of storage account credential to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569322 = path.getOrDefault("resourceGroupName")
  valid_569322 = validateParameter(valid_569322, JString, required = true,
                                 default = nil)
  if valid_569322 != nil:
    section.add "resourceGroupName", valid_569322
  var valid_569323 = path.getOrDefault("managerName")
  valid_569323 = validateParameter(valid_569323, JString, required = true,
                                 default = nil)
  if valid_569323 != nil:
    section.add "managerName", valid_569323
  var valid_569324 = path.getOrDefault("subscriptionId")
  valid_569324 = validateParameter(valid_569324, JString, required = true,
                                 default = nil)
  if valid_569324 != nil:
    section.add "subscriptionId", valid_569324
  var valid_569325 = path.getOrDefault("storageAccountCredentialName")
  valid_569325 = validateParameter(valid_569325, JString, required = true,
                                 default = nil)
  if valid_569325 != nil:
    section.add "storageAccountCredentialName", valid_569325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569326 = query.getOrDefault("api-version")
  valid_569326 = validateParameter(valid_569326, JString, required = true,
                                 default = nil)
  if valid_569326 != nil:
    section.add "api-version", valid_569326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569327: Call_StorageAccountCredentialsGet_569319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified storage account credential name.
  ## 
  let valid = call_569327.validator(path, query, header, formData, body)
  let scheme = call_569327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569327.url(scheme.get, call_569327.host, call_569327.base,
                         call_569327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569327, url, valid)

proc call*(call_569328: Call_StorageAccountCredentialsGet_569319;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; storageAccountCredentialName: string): Recallable =
  ## storageAccountCredentialsGet
  ## Gets the properties of the specified storage account credential name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   storageAccountCredentialName: string (required)
  ##                               : The name of storage account credential to be fetched.
  var path_569329 = newJObject()
  var query_569330 = newJObject()
  add(path_569329, "resourceGroupName", newJString(resourceGroupName))
  add(query_569330, "api-version", newJString(apiVersion))
  add(path_569329, "managerName", newJString(managerName))
  add(path_569329, "subscriptionId", newJString(subscriptionId))
  add(path_569329, "storageAccountCredentialName",
      newJString(storageAccountCredentialName))
  result = call_569328.call(path_569329, query_569330, nil, nil, nil)

var storageAccountCredentialsGet* = Call_StorageAccountCredentialsGet_569319(
    name: "storageAccountCredentialsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{storageAccountCredentialName}",
    validator: validate_StorageAccountCredentialsGet_569320, base: "",
    url: url_StorageAccountCredentialsGet_569321, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsDelete_569345 = ref object of OpenApiRestCall_567667
proc url_StorageAccountCredentialsDelete_569347(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "storageAccountCredentialName" in path,
        "`storageAccountCredentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "storageAccountCredentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsDelete_569346(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the storage account credential.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   storageAccountCredentialName: JString (required)
  ##                               : The name of the storage account credential.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569348 = path.getOrDefault("resourceGroupName")
  valid_569348 = validateParameter(valid_569348, JString, required = true,
                                 default = nil)
  if valid_569348 != nil:
    section.add "resourceGroupName", valid_569348
  var valid_569349 = path.getOrDefault("managerName")
  valid_569349 = validateParameter(valid_569349, JString, required = true,
                                 default = nil)
  if valid_569349 != nil:
    section.add "managerName", valid_569349
  var valid_569350 = path.getOrDefault("subscriptionId")
  valid_569350 = validateParameter(valid_569350, JString, required = true,
                                 default = nil)
  if valid_569350 != nil:
    section.add "subscriptionId", valid_569350
  var valid_569351 = path.getOrDefault("storageAccountCredentialName")
  valid_569351 = validateParameter(valid_569351, JString, required = true,
                                 default = nil)
  if valid_569351 != nil:
    section.add "storageAccountCredentialName", valid_569351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569352 = query.getOrDefault("api-version")
  valid_569352 = validateParameter(valid_569352, JString, required = true,
                                 default = nil)
  if valid_569352 != nil:
    section.add "api-version", valid_569352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569353: Call_StorageAccountCredentialsDelete_569345;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the storage account credential.
  ## 
  let valid = call_569353.validator(path, query, header, formData, body)
  let scheme = call_569353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569353.url(scheme.get, call_569353.host, call_569353.base,
                         call_569353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569353, url, valid)

proc call*(call_569354: Call_StorageAccountCredentialsDelete_569345;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; storageAccountCredentialName: string): Recallable =
  ## storageAccountCredentialsDelete
  ## Deletes the storage account credential.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   storageAccountCredentialName: string (required)
  ##                               : The name of the storage account credential.
  var path_569355 = newJObject()
  var query_569356 = newJObject()
  add(path_569355, "resourceGroupName", newJString(resourceGroupName))
  add(query_569356, "api-version", newJString(apiVersion))
  add(path_569355, "managerName", newJString(managerName))
  add(path_569355, "subscriptionId", newJString(subscriptionId))
  add(path_569355, "storageAccountCredentialName",
      newJString(storageAccountCredentialName))
  result = call_569354.call(path_569355, query_569356, nil, nil, nil)

var storageAccountCredentialsDelete* = Call_StorageAccountCredentialsDelete_569345(
    name: "storageAccountCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{storageAccountCredentialName}",
    validator: validate_StorageAccountCredentialsDelete_569346, base: "",
    url: url_StorageAccountCredentialsDelete_569347, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
