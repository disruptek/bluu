
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: StorSimpleManagementClient
## version: 2016-10-01
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
  macServiceName = "storSimple1200Series-StorSimple"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AvailableProviderOperationsList_567889 = ref object of OpenApiRestCall_567667
proc url_AvailableProviderOperationsList_567891(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AvailableProviderOperationsList_567890(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of AvailableProviderOperations
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

proc call*(call_568073: Call_AvailableProviderOperationsList_567889;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List of AvailableProviderOperations
  ## 
  let valid = call_568073.validator(path, query, header, formData, body)
  let scheme = call_568073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568073.url(scheme.get, call_568073.host, call_568073.base,
                         call_568073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568073, url, valid)

proc call*(call_568144: Call_AvailableProviderOperationsList_567889;
          apiVersion: string): Recallable =
  ## availableProviderOperationsList
  ## List of AvailableProviderOperations
  ##   apiVersion: string (required)
  ##             : The api version
  var query_568145 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  result = call_568144.call(nil, query_568145, nil, nil, nil)

var availableProviderOperationsList* = Call_AvailableProviderOperationsList_567889(
    name: "availableProviderOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.StorSimple/operations",
    validator: validate_AvailableProviderOperationsList_567890, base: "",
    url: url_AvailableProviderOperationsList_567891, schemes: {Scheme.Https})
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
  ##   Manager: JObject (required)
  ##          : The manager.
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
          subscriptionId: string; Manager: JsonNode): Recallable =
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
  ##   Manager: JObject (required)
  ##          : The manager.
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  var body_568241 = newJObject()
  add(path_568239, "resourceGroupName", newJString(resourceGroupName))
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "managerName", newJString(managerName))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  if Manager != nil:
    body_568241 = Manager
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
  ##   accessControlRecord: JObject (required)
  ##                      : The access control record to be added or updated.
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
          subscriptionId: string; accessControlRecord: JsonNode;
          accessControlRecordName: string): Recallable =
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
  ##   accessControlRecord: JObject (required)
  ##                      : The access control record to be added or updated.
  ##   accessControlRecordName: string (required)
  ##                          : The name of the access control record.
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  var body_568302 = newJObject()
  add(path_568300, "resourceGroupName", newJString(resourceGroupName))
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "managerName", newJString(managerName))
  add(path_568300, "subscriptionId", newJString(subscriptionId))
  if accessControlRecord != nil:
    body_568302 = accessControlRecord
  add(path_568300, "accessControlRecordName", newJString(accessControlRecordName))
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
  Call_BackupsListByManager_568328 = ref object of OpenApiRestCall_567667
proc url_BackupsListByManager_568330(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/backups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsListByManager_568329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the backups in a manager.
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
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568334 = query.getOrDefault("api-version")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "api-version", valid_568334
  var valid_568335 = query.getOrDefault("$filter")
  valid_568335 = validateParameter(valid_568335, JString, required = false,
                                 default = nil)
  if valid_568335 != nil:
    section.add "$filter", valid_568335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568336: Call_BackupsListByManager_568328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the backups in a manager.
  ## 
  let valid = call_568336.validator(path, query, header, formData, body)
  let scheme = call_568336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568336.url(scheme.get, call_568336.host, call_568336.base,
                         call_568336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568336, url, valid)

proc call*(call_568337: Call_BackupsListByManager_568328;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## backupsListByManager
  ## Retrieves all the backups in a manager.
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
  var path_568338 = newJObject()
  var query_568339 = newJObject()
  add(path_568338, "resourceGroupName", newJString(resourceGroupName))
  add(query_568339, "api-version", newJString(apiVersion))
  add(path_568338, "managerName", newJString(managerName))
  add(path_568338, "subscriptionId", newJString(subscriptionId))
  add(query_568339, "$filter", newJString(Filter))
  result = call_568337.call(path_568338, query_568339, nil, nil, nil)

var backupsListByManager* = Call_BackupsListByManager_568328(
    name: "backupsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/backups",
    validator: validate_BackupsListByManager_568329, base: "",
    url: url_BackupsListByManager_568330, schemes: {Scheme.Https})
type
  Call_ManagersUploadRegistrationCertificate_568340 = ref object of OpenApiRestCall_567667
proc url_ManagersUploadRegistrationCertificate_568342(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "certificateName" in path, "`certificateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersUploadRegistrationCertificate_568341(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upload Vault Cred Certificate.
  ## Returns UploadCertificateResponse
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
  ##   certificateName: JString (required)
  ##                  : Certificate Name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568343 = path.getOrDefault("resourceGroupName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "resourceGroupName", valid_568343
  var valid_568344 = path.getOrDefault("managerName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "managerName", valid_568344
  var valid_568345 = path.getOrDefault("subscriptionId")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "subscriptionId", valid_568345
  var valid_568346 = path.getOrDefault("certificateName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "certificateName", valid_568346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568347 = query.getOrDefault("api-version")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "api-version", valid_568347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   uploadCertificateRequestrequest: JObject (required)
  ##                                  : UploadCertificateRequest Request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568349: Call_ManagersUploadRegistrationCertificate_568340;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload Vault Cred Certificate.
  ## Returns UploadCertificateResponse
  ## 
  let valid = call_568349.validator(path, query, header, formData, body)
  let scheme = call_568349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568349.url(scheme.get, call_568349.host, call_568349.base,
                         call_568349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568349, url, valid)

proc call*(call_568350: Call_ManagersUploadRegistrationCertificate_568340;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; certificateName: string;
          uploadCertificateRequestrequest: JsonNode): Recallable =
  ## managersUploadRegistrationCertificate
  ## Upload Vault Cred Certificate.
  ## Returns UploadCertificateResponse
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   certificateName: string (required)
  ##                  : Certificate Name
  ##   uploadCertificateRequestrequest: JObject (required)
  ##                                  : UploadCertificateRequest Request
  var path_568351 = newJObject()
  var query_568352 = newJObject()
  var body_568353 = newJObject()
  add(path_568351, "resourceGroupName", newJString(resourceGroupName))
  add(query_568352, "api-version", newJString(apiVersion))
  add(path_568351, "managerName", newJString(managerName))
  add(path_568351, "subscriptionId", newJString(subscriptionId))
  add(path_568351, "certificateName", newJString(certificateName))
  if uploadCertificateRequestrequest != nil:
    body_568353 = uploadCertificateRequestrequest
  result = call_568350.call(path_568351, query_568352, nil, nil, body_568353)

var managersUploadRegistrationCertificate* = Call_ManagersUploadRegistrationCertificate_568340(
    name: "managersUploadRegistrationCertificate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/certificates/{certificateName}",
    validator: validate_ManagersUploadRegistrationCertificate_568341, base: "",
    url: url_ManagersUploadRegistrationCertificate_568342, schemes: {Scheme.Https})
type
  Call_AlertsClear_568354 = ref object of OpenApiRestCall_567667
proc url_AlertsClear_568356(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsClear_568355(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568357 = path.getOrDefault("resourceGroupName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "resourceGroupName", valid_568357
  var valid_568358 = path.getOrDefault("managerName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "managerName", valid_568358
  var valid_568359 = path.getOrDefault("subscriptionId")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "subscriptionId", valid_568359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568360 = query.getOrDefault("api-version")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "api-version", valid_568360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : The clear alert request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568362: Call_AlertsClear_568354; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clear the alerts.
  ## 
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_AlertsClear_568354; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          request: JsonNode): Recallable =
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
  ##   request: JObject (required)
  ##          : The clear alert request.
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  var body_568366 = newJObject()
  add(path_568364, "resourceGroupName", newJString(resourceGroupName))
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "managerName", newJString(managerName))
  add(path_568364, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_568366 = request
  result = call_568363.call(path_568364, query_568365, nil, nil, body_568366)

var alertsClear* = Call_AlertsClear_568354(name: "alertsClear",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/clearAlerts",
                                        validator: validate_AlertsClear_568355,
                                        base: "", url: url_AlertsClear_568356,
                                        schemes: {Scheme.Https})
type
  Call_DevicesListByManager_568367 = ref object of OpenApiRestCall_567667
proc url_DevicesListByManager_568369(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesListByManager_568368(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the devices in a manager.
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
  var valid_568370 = path.getOrDefault("resourceGroupName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "resourceGroupName", valid_568370
  var valid_568371 = path.getOrDefault("managerName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "managerName", valid_568371
  var valid_568372 = path.getOrDefault("subscriptionId")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "subscriptionId", valid_568372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568373 = query.getOrDefault("api-version")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "api-version", valid_568373
  var valid_568374 = query.getOrDefault("$expand")
  valid_568374 = validateParameter(valid_568374, JString, required = false,
                                 default = nil)
  if valid_568374 != nil:
    section.add "$expand", valid_568374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568375: Call_DevicesListByManager_568367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the devices in a manager.
  ## 
  let valid = call_568375.validator(path, query, header, formData, body)
  let scheme = call_568375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568375.url(scheme.get, call_568375.host, call_568375.base,
                         call_568375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568375, url, valid)

proc call*(call_568376: Call_DevicesListByManager_568367;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; Expand: string = ""): Recallable =
  ## devicesListByManager
  ## Retrieves all the devices in a manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the device.
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_568377 = newJObject()
  var query_568378 = newJObject()
  add(path_568377, "resourceGroupName", newJString(resourceGroupName))
  add(query_568378, "api-version", newJString(apiVersion))
  add(query_568378, "$expand", newJString(Expand))
  add(path_568377, "managerName", newJString(managerName))
  add(path_568377, "subscriptionId", newJString(subscriptionId))
  result = call_568376.call(path_568377, query_568378, nil, nil, nil)

var devicesListByManager* = Call_DevicesListByManager_568367(
    name: "devicesListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices",
    validator: validate_DevicesListByManager_568368, base: "",
    url: url_DevicesListByManager_568369, schemes: {Scheme.Https})
type
  Call_DevicesGet_568379 = ref object of OpenApiRestCall_567667
proc url_DevicesGet_568381(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DevicesGet_568380(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified device name.
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568382 = path.getOrDefault("resourceGroupName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "resourceGroupName", valid_568382
  var valid_568383 = path.getOrDefault("managerName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "managerName", valid_568383
  var valid_568384 = path.getOrDefault("subscriptionId")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "subscriptionId", valid_568384
  var valid_568385 = path.getOrDefault("deviceName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "deviceName", valid_568385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568386 = query.getOrDefault("api-version")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "api-version", valid_568386
  var valid_568387 = query.getOrDefault("$expand")
  valid_568387 = validateParameter(valid_568387, JString, required = false,
                                 default = nil)
  if valid_568387 != nil:
    section.add "$expand", valid_568387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_DevicesGet_568379; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified device name.
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_DevicesGet_568379; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          deviceName: string; Expand: string = ""): Recallable =
  ## devicesGet
  ## Returns the properties of the specified device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the device.
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(query_568391, "$expand", newJString(Expand))
  add(path_568390, "managerName", newJString(managerName))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  add(path_568390, "deviceName", newJString(deviceName))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var devicesGet* = Call_DevicesGet_568379(name: "devicesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
                                      validator: validate_DevicesGet_568380,
                                      base: "", url: url_DevicesGet_568381,
                                      schemes: {Scheme.Https})
type
  Call_DevicesPatch_568404 = ref object of OpenApiRestCall_567667
proc url_DevicesPatch_568406(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesPatch_568405(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##             : The device Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568407 = path.getOrDefault("resourceGroupName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "resourceGroupName", valid_568407
  var valid_568408 = path.getOrDefault("managerName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "managerName", valid_568408
  var valid_568409 = path.getOrDefault("subscriptionId")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "subscriptionId", valid_568409
  var valid_568410 = path.getOrDefault("deviceName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "deviceName", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568411 = query.getOrDefault("api-version")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "api-version", valid_568411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   devicePatch: JObject (required)
  ##              : Patch representation of the device.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568413: Call_DevicesPatch_568404; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches the device.
  ## 
  let valid = call_568413.validator(path, query, header, formData, body)
  let scheme = call_568413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568413.url(scheme.get, call_568413.host, call_568413.base,
                         call_568413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568413, url, valid)

proc call*(call_568414: Call_DevicesPatch_568404; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          devicePatch: JsonNode; deviceName: string): Recallable =
  ## devicesPatch
  ## Patches the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   devicePatch: JObject (required)
  ##              : Patch representation of the device.
  ##   deviceName: string (required)
  ##             : The device Name.
  var path_568415 = newJObject()
  var query_568416 = newJObject()
  var body_568417 = newJObject()
  add(path_568415, "resourceGroupName", newJString(resourceGroupName))
  add(query_568416, "api-version", newJString(apiVersion))
  add(path_568415, "managerName", newJString(managerName))
  add(path_568415, "subscriptionId", newJString(subscriptionId))
  if devicePatch != nil:
    body_568417 = devicePatch
  add(path_568415, "deviceName", newJString(deviceName))
  result = call_568414.call(path_568415, query_568416, nil, nil, body_568417)

var devicesPatch* = Call_DevicesPatch_568404(name: "devicesPatch",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
    validator: validate_DevicesPatch_568405, base: "", url: url_DevicesPatch_568406,
    schemes: {Scheme.Https})
type
  Call_DevicesDelete_568392 = ref object of OpenApiRestCall_567667
proc url_DevicesDelete_568394(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDelete_568393(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568395 = path.getOrDefault("resourceGroupName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "resourceGroupName", valid_568395
  var valid_568396 = path.getOrDefault("managerName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "managerName", valid_568396
  var valid_568397 = path.getOrDefault("subscriptionId")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "subscriptionId", valid_568397
  var valid_568398 = path.getOrDefault("deviceName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "deviceName", valid_568398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568399 = query.getOrDefault("api-version")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "api-version", valid_568399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568400: Call_DevicesDelete_568392; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the device.
  ## 
  let valid = call_568400.validator(path, query, header, formData, body)
  let scheme = call_568400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568400.url(scheme.get, call_568400.host, call_568400.base,
                         call_568400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568400, url, valid)

proc call*(call_568401: Call_DevicesDelete_568392; resourceGroupName: string;
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
  ##             : The device name.
  var path_568402 = newJObject()
  var query_568403 = newJObject()
  add(path_568402, "resourceGroupName", newJString(resourceGroupName))
  add(query_568403, "api-version", newJString(apiVersion))
  add(path_568402, "managerName", newJString(managerName))
  add(path_568402, "subscriptionId", newJString(subscriptionId))
  add(path_568402, "deviceName", newJString(deviceName))
  result = call_568401.call(path_568402, query_568403, nil, nil, nil)

var devicesDelete* = Call_DevicesDelete_568392(name: "devicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
    validator: validate_DevicesDelete_568393, base: "", url: url_DevicesDelete_568394,
    schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdateAlertSettings_568430 = ref object of OpenApiRestCall_567667
proc url_DevicesCreateOrUpdateAlertSettings_568432(protocol: Scheme; host: string;
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

proc validate_DevicesCreateOrUpdateAlertSettings_568431(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the alert settings
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568433 = path.getOrDefault("resourceGroupName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "resourceGroupName", valid_568433
  var valid_568434 = path.getOrDefault("managerName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "managerName", valid_568434
  var valid_568435 = path.getOrDefault("subscriptionId")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "subscriptionId", valid_568435
  var valid_568436 = path.getOrDefault("deviceName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "deviceName", valid_568436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568437 = query.getOrDefault("api-version")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "api-version", valid_568437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   alertSettings: JObject (required)
  ##                : The alert settings.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568439: Call_DevicesCreateOrUpdateAlertSettings_568430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the alert settings
  ## 
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_DevicesCreateOrUpdateAlertSettings_568430;
          alertSettings: JsonNode; resourceGroupName: string; apiVersion: string;
          managerName: string; subscriptionId: string; deviceName: string): Recallable =
  ## devicesCreateOrUpdateAlertSettings
  ## Creates or updates the alert settings
  ##   alertSettings: JObject (required)
  ##                : The alert settings.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568441 = newJObject()
  var query_568442 = newJObject()
  var body_568443 = newJObject()
  if alertSettings != nil:
    body_568443 = alertSettings
  add(path_568441, "resourceGroupName", newJString(resourceGroupName))
  add(query_568442, "api-version", newJString(apiVersion))
  add(path_568441, "managerName", newJString(managerName))
  add(path_568441, "subscriptionId", newJString(subscriptionId))
  add(path_568441, "deviceName", newJString(deviceName))
  result = call_568440.call(path_568441, query_568442, nil, nil, body_568443)

var devicesCreateOrUpdateAlertSettings* = Call_DevicesCreateOrUpdateAlertSettings_568430(
    name: "devicesCreateOrUpdateAlertSettings", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/alertSettings/default",
    validator: validate_DevicesCreateOrUpdateAlertSettings_568431, base: "",
    url: url_DevicesCreateOrUpdateAlertSettings_568432, schemes: {Scheme.Https})
type
  Call_DevicesGetAlertSettings_568418 = ref object of OpenApiRestCall_567667
proc url_DevicesGetAlertSettings_568420(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/alertSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGetAlertSettings_568419(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the alert settings of the specified device name.
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568421 = path.getOrDefault("resourceGroupName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "resourceGroupName", valid_568421
  var valid_568422 = path.getOrDefault("managerName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "managerName", valid_568422
  var valid_568423 = path.getOrDefault("subscriptionId")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "subscriptionId", valid_568423
  var valid_568424 = path.getOrDefault("deviceName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "deviceName", valid_568424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568425 = query.getOrDefault("api-version")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "api-version", valid_568425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568426: Call_DevicesGetAlertSettings_568418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the alert settings of the specified device name.
  ## 
  let valid = call_568426.validator(path, query, header, formData, body)
  let scheme = call_568426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568426.url(scheme.get, call_568426.host, call_568426.base,
                         call_568426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568426, url, valid)

proc call*(call_568427: Call_DevicesGetAlertSettings_568418;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesGetAlertSettings
  ## Returns the alert settings of the specified device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568428 = newJObject()
  var query_568429 = newJObject()
  add(path_568428, "resourceGroupName", newJString(resourceGroupName))
  add(query_568429, "api-version", newJString(apiVersion))
  add(path_568428, "managerName", newJString(managerName))
  add(path_568428, "subscriptionId", newJString(subscriptionId))
  add(path_568428, "deviceName", newJString(deviceName))
  result = call_568427.call(path_568428, query_568429, nil, nil, nil)

var devicesGetAlertSettings* = Call_DevicesGetAlertSettings_568418(
    name: "devicesGetAlertSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/alertSettings/default",
    validator: validate_DevicesGetAlertSettings_568419, base: "",
    url: url_DevicesGetAlertSettings_568420, schemes: {Scheme.Https})
type
  Call_BackupScheduleGroupsListByDevice_568444 = ref object of OpenApiRestCall_567667
proc url_BackupScheduleGroupsListByDevice_568446(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/backupScheduleGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupScheduleGroupsListByDevice_568445(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the backup schedule groups in a device.
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
  ##             : The name of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568447 = path.getOrDefault("resourceGroupName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceGroupName", valid_568447
  var valid_568448 = path.getOrDefault("managerName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "managerName", valid_568448
  var valid_568449 = path.getOrDefault("subscriptionId")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "subscriptionId", valid_568449
  var valid_568450 = path.getOrDefault("deviceName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "deviceName", valid_568450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568451 = query.getOrDefault("api-version")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "api-version", valid_568451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568452: Call_BackupScheduleGroupsListByDevice_568444;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the backup schedule groups in a device.
  ## 
  let valid = call_568452.validator(path, query, header, formData, body)
  let scheme = call_568452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568452.url(scheme.get, call_568452.host, call_568452.base,
                         call_568452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568452, url, valid)

proc call*(call_568453: Call_BackupScheduleGroupsListByDevice_568444;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## backupScheduleGroupsListByDevice
  ## Retrieves all the backup schedule groups in a device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the device.
  var path_568454 = newJObject()
  var query_568455 = newJObject()
  add(path_568454, "resourceGroupName", newJString(resourceGroupName))
  add(query_568455, "api-version", newJString(apiVersion))
  add(path_568454, "managerName", newJString(managerName))
  add(path_568454, "subscriptionId", newJString(subscriptionId))
  add(path_568454, "deviceName", newJString(deviceName))
  result = call_568453.call(path_568454, query_568455, nil, nil, nil)

var backupScheduleGroupsListByDevice* = Call_BackupScheduleGroupsListByDevice_568444(
    name: "backupScheduleGroupsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupScheduleGroups",
    validator: validate_BackupScheduleGroupsListByDevice_568445, base: "",
    url: url_BackupScheduleGroupsListByDevice_568446, schemes: {Scheme.Https})
type
  Call_BackupScheduleGroupsCreateOrUpdate_568469 = ref object of OpenApiRestCall_567667
proc url_BackupScheduleGroupsCreateOrUpdate_568471(protocol: Scheme; host: string;
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
  assert "scheduleGroupName" in path,
        "`scheduleGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupScheduleGroups/"),
               (kind: VariableSegment, value: "scheduleGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupScheduleGroupsCreateOrUpdate_568470(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates the backup schedule Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scheduleGroupName: JString (required)
  ##                    : The name of the schedule group.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   deviceName: JString (required)
  ##             : The name of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `scheduleGroupName` field"
  var valid_568472 = path.getOrDefault("scheduleGroupName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "scheduleGroupName", valid_568472
  var valid_568473 = path.getOrDefault("resourceGroupName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "resourceGroupName", valid_568473
  var valid_568474 = path.getOrDefault("managerName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "managerName", valid_568474
  var valid_568475 = path.getOrDefault("subscriptionId")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "subscriptionId", valid_568475
  var valid_568476 = path.getOrDefault("deviceName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "deviceName", valid_568476
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568477 = query.getOrDefault("api-version")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "api-version", valid_568477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   scheduleGroup: JObject (required)
  ##                : The schedule group to be created
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568479: Call_BackupScheduleGroupsCreateOrUpdate_568469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates the backup schedule Group.
  ## 
  let valid = call_568479.validator(path, query, header, formData, body)
  let scheme = call_568479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568479.url(scheme.get, call_568479.host, call_568479.base,
                         call_568479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568479, url, valid)

proc call*(call_568480: Call_BackupScheduleGroupsCreateOrUpdate_568469;
          scheduleGroupName: string; resourceGroupName: string; apiVersion: string;
          managerName: string; subscriptionId: string; deviceName: string;
          scheduleGroup: JsonNode): Recallable =
  ## backupScheduleGroupsCreateOrUpdate
  ## Creates or Updates the backup schedule Group.
  ##   scheduleGroupName: string (required)
  ##                    : The name of the schedule group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the device.
  ##   scheduleGroup: JObject (required)
  ##                : The schedule group to be created
  var path_568481 = newJObject()
  var query_568482 = newJObject()
  var body_568483 = newJObject()
  add(path_568481, "scheduleGroupName", newJString(scheduleGroupName))
  add(path_568481, "resourceGroupName", newJString(resourceGroupName))
  add(query_568482, "api-version", newJString(apiVersion))
  add(path_568481, "managerName", newJString(managerName))
  add(path_568481, "subscriptionId", newJString(subscriptionId))
  add(path_568481, "deviceName", newJString(deviceName))
  if scheduleGroup != nil:
    body_568483 = scheduleGroup
  result = call_568480.call(path_568481, query_568482, nil, nil, body_568483)

var backupScheduleGroupsCreateOrUpdate* = Call_BackupScheduleGroupsCreateOrUpdate_568469(
    name: "backupScheduleGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupScheduleGroups/{scheduleGroupName}",
    validator: validate_BackupScheduleGroupsCreateOrUpdate_568470, base: "",
    url: url_BackupScheduleGroupsCreateOrUpdate_568471, schemes: {Scheme.Https})
type
  Call_BackupScheduleGroupsGet_568456 = ref object of OpenApiRestCall_567667
proc url_BackupScheduleGroupsGet_568458(protocol: Scheme; host: string; base: string;
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
  assert "scheduleGroupName" in path,
        "`scheduleGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupScheduleGroups/"),
               (kind: VariableSegment, value: "scheduleGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupScheduleGroupsGet_568457(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified backup schedule group name.
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
  ##             : The name of the device.
  ##   scheduleGroupName: JString (required)
  ##                    : The name of the schedule group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568459 = path.getOrDefault("resourceGroupName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "resourceGroupName", valid_568459
  var valid_568460 = path.getOrDefault("managerName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "managerName", valid_568460
  var valid_568461 = path.getOrDefault("subscriptionId")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "subscriptionId", valid_568461
  var valid_568462 = path.getOrDefault("deviceName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "deviceName", valid_568462
  var valid_568463 = path.getOrDefault("scheduleGroupName")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "scheduleGroupName", valid_568463
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568464 = query.getOrDefault("api-version")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "api-version", valid_568464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568465: Call_BackupScheduleGroupsGet_568456; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified backup schedule group name.
  ## 
  let valid = call_568465.validator(path, query, header, formData, body)
  let scheme = call_568465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568465.url(scheme.get, call_568465.host, call_568465.base,
                         call_568465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568465, url, valid)

proc call*(call_568466: Call_BackupScheduleGroupsGet_568456;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string; scheduleGroupName: string): Recallable =
  ## backupScheduleGroupsGet
  ## Returns the properties of the specified backup schedule group name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the device.
  ##   scheduleGroupName: string (required)
  ##                    : The name of the schedule group.
  var path_568467 = newJObject()
  var query_568468 = newJObject()
  add(path_568467, "resourceGroupName", newJString(resourceGroupName))
  add(query_568468, "api-version", newJString(apiVersion))
  add(path_568467, "managerName", newJString(managerName))
  add(path_568467, "subscriptionId", newJString(subscriptionId))
  add(path_568467, "deviceName", newJString(deviceName))
  add(path_568467, "scheduleGroupName", newJString(scheduleGroupName))
  result = call_568466.call(path_568467, query_568468, nil, nil, nil)

var backupScheduleGroupsGet* = Call_BackupScheduleGroupsGet_568456(
    name: "backupScheduleGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupScheduleGroups/{scheduleGroupName}",
    validator: validate_BackupScheduleGroupsGet_568457, base: "",
    url: url_BackupScheduleGroupsGet_568458, schemes: {Scheme.Https})
type
  Call_BackupScheduleGroupsDelete_568484 = ref object of OpenApiRestCall_567667
proc url_BackupScheduleGroupsDelete_568486(protocol: Scheme; host: string;
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
  assert "scheduleGroupName" in path,
        "`scheduleGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/backupScheduleGroups/"),
               (kind: VariableSegment, value: "scheduleGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupScheduleGroupsDelete_568485(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the backup schedule group.
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
  ##             : The name of the device.
  ##   scheduleGroupName: JString (required)
  ##                    : The name of the schedule group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568487 = path.getOrDefault("resourceGroupName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "resourceGroupName", valid_568487
  var valid_568488 = path.getOrDefault("managerName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "managerName", valid_568488
  var valid_568489 = path.getOrDefault("subscriptionId")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "subscriptionId", valid_568489
  var valid_568490 = path.getOrDefault("deviceName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "deviceName", valid_568490
  var valid_568491 = path.getOrDefault("scheduleGroupName")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "scheduleGroupName", valid_568491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568492 = query.getOrDefault("api-version")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "api-version", valid_568492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568493: Call_BackupScheduleGroupsDelete_568484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup schedule group.
  ## 
  let valid = call_568493.validator(path, query, header, formData, body)
  let scheme = call_568493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568493.url(scheme.get, call_568493.host, call_568493.base,
                         call_568493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568493, url, valid)

proc call*(call_568494: Call_BackupScheduleGroupsDelete_568484;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string; scheduleGroupName: string): Recallable =
  ## backupScheduleGroupsDelete
  ## Deletes the backup schedule group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the device.
  ##   scheduleGroupName: string (required)
  ##                    : The name of the schedule group.
  var path_568495 = newJObject()
  var query_568496 = newJObject()
  add(path_568495, "resourceGroupName", newJString(resourceGroupName))
  add(query_568496, "api-version", newJString(apiVersion))
  add(path_568495, "managerName", newJString(managerName))
  add(path_568495, "subscriptionId", newJString(subscriptionId))
  add(path_568495, "deviceName", newJString(deviceName))
  add(path_568495, "scheduleGroupName", newJString(scheduleGroupName))
  result = call_568494.call(path_568495, query_568496, nil, nil, nil)

var backupScheduleGroupsDelete* = Call_BackupScheduleGroupsDelete_568484(
    name: "backupScheduleGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupScheduleGroups/{scheduleGroupName}",
    validator: validate_BackupScheduleGroupsDelete_568485, base: "",
    url: url_BackupScheduleGroupsDelete_568486, schemes: {Scheme.Https})
type
  Call_BackupsListByDevice_568497 = ref object of OpenApiRestCall_567667
proc url_BackupsListByDevice_568499(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsListByDevice_568498(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves all the backups in a device. Can be used to get the backups for failover also.
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568500 = path.getOrDefault("resourceGroupName")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "resourceGroupName", valid_568500
  var valid_568501 = path.getOrDefault("managerName")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "managerName", valid_568501
  var valid_568502 = path.getOrDefault("subscriptionId")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "subscriptionId", valid_568502
  var valid_568503 = path.getOrDefault("deviceName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "deviceName", valid_568503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   forFailover: JBool
  ##              : Set to true if you need backups which can be used for failover.
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568504 = query.getOrDefault("api-version")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "api-version", valid_568504
  var valid_568505 = query.getOrDefault("forFailover")
  valid_568505 = validateParameter(valid_568505, JBool, required = false, default = nil)
  if valid_568505 != nil:
    section.add "forFailover", valid_568505
  var valid_568506 = query.getOrDefault("$filter")
  valid_568506 = validateParameter(valid_568506, JString, required = false,
                                 default = nil)
  if valid_568506 != nil:
    section.add "$filter", valid_568506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568507: Call_BackupsListByDevice_568497; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the backups in a device. Can be used to get the backups for failover also.
  ## 
  let valid = call_568507.validator(path, query, header, formData, body)
  let scheme = call_568507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568507.url(scheme.get, call_568507.host, call_568507.base,
                         call_568507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568507, url, valid)

proc call*(call_568508: Call_BackupsListByDevice_568497; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          deviceName: string; forFailover: bool = false; Filter: string = ""): Recallable =
  ## backupsListByDevice
  ## Retrieves all the backups in a device. Can be used to get the backups for failover also.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   forFailover: bool
  ##              : Set to true if you need backups which can be used for failover.
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   Filter: string
  ##         : OData Filter options
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568509 = newJObject()
  var query_568510 = newJObject()
  add(path_568509, "resourceGroupName", newJString(resourceGroupName))
  add(query_568510, "api-version", newJString(apiVersion))
  add(query_568510, "forFailover", newJBool(forFailover))
  add(path_568509, "managerName", newJString(managerName))
  add(path_568509, "subscriptionId", newJString(subscriptionId))
  add(query_568510, "$filter", newJString(Filter))
  add(path_568509, "deviceName", newJString(deviceName))
  result = call_568508.call(path_568509, query_568510, nil, nil, nil)

var backupsListByDevice* = Call_BackupsListByDevice_568497(
    name: "backupsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups",
    validator: validate_BackupsListByDevice_568498, base: "",
    url: url_BackupsListByDevice_568499, schemes: {Scheme.Https})
type
  Call_BackupsDelete_568511 = ref object of OpenApiRestCall_567667
proc url_BackupsDelete_568513(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsDelete_568512(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568514 = path.getOrDefault("resourceGroupName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "resourceGroupName", valid_568514
  var valid_568515 = path.getOrDefault("managerName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "managerName", valid_568515
  var valid_568516 = path.getOrDefault("subscriptionId")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "subscriptionId", valid_568516
  var valid_568517 = path.getOrDefault("backupName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "backupName", valid_568517
  var valid_568518 = path.getOrDefault("deviceName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "deviceName", valid_568518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568519 = query.getOrDefault("api-version")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "api-version", valid_568519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568520: Call_BackupsDelete_568511; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup.
  ## 
  let valid = call_568520.validator(path, query, header, formData, body)
  let scheme = call_568520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568520.url(scheme.get, call_568520.host, call_568520.base,
                         call_568520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568520, url, valid)

proc call*(call_568521: Call_BackupsDelete_568511; resourceGroupName: string;
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
  ##             : The device name.
  var path_568522 = newJObject()
  var query_568523 = newJObject()
  add(path_568522, "resourceGroupName", newJString(resourceGroupName))
  add(query_568523, "api-version", newJString(apiVersion))
  add(path_568522, "managerName", newJString(managerName))
  add(path_568522, "subscriptionId", newJString(subscriptionId))
  add(path_568522, "backupName", newJString(backupName))
  add(path_568522, "deviceName", newJString(deviceName))
  result = call_568521.call(path_568522, query_568523, nil, nil, nil)

var backupsDelete* = Call_BackupsDelete_568511(name: "backupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}",
    validator: validate_BackupsDelete_568512, base: "", url: url_BackupsDelete_568513,
    schemes: {Scheme.Https})
type
  Call_BackupsClone_568524 = ref object of OpenApiRestCall_567667
proc url_BackupsClone_568526(protocol: Scheme; host: string; base: string;
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
  assert "elementName" in path, "`elementName` is a required path parameter"
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
               (kind: VariableSegment, value: "elementName"),
               (kind: ConstantSegment, value: "/clone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsClone_568525(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Clones the given backup element to a new disk or share with given details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   elementName: JString (required)
  ##              : The backup element name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  ##   backupName: JString (required)
  ##             : The backup name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568527 = path.getOrDefault("resourceGroupName")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "resourceGroupName", valid_568527
  var valid_568528 = path.getOrDefault("managerName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "managerName", valid_568528
  var valid_568529 = path.getOrDefault("elementName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "elementName", valid_568529
  var valid_568530 = path.getOrDefault("subscriptionId")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "subscriptionId", valid_568530
  var valid_568531 = path.getOrDefault("backupName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "backupName", valid_568531
  var valid_568532 = path.getOrDefault("deviceName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "deviceName", valid_568532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568533 = query.getOrDefault("api-version")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "api-version", valid_568533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   cloneRequest: JObject (required)
  ##               : The clone request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568535: Call_BackupsClone_568524; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clones the given backup element to a new disk or share with given details.
  ## 
  let valid = call_568535.validator(path, query, header, formData, body)
  let scheme = call_568535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568535.url(scheme.get, call_568535.host, call_568535.base,
                         call_568535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568535, url, valid)

proc call*(call_568536: Call_BackupsClone_568524; resourceGroupName: string;
          apiVersion: string; managerName: string; elementName: string;
          subscriptionId: string; backupName: string; cloneRequest: JsonNode;
          deviceName: string): Recallable =
  ## backupsClone
  ## Clones the given backup element to a new disk or share with given details.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   elementName: string (required)
  ##              : The backup element name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   backupName: string (required)
  ##             : The backup name.
  ##   cloneRequest: JObject (required)
  ##               : The clone request.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568537 = newJObject()
  var query_568538 = newJObject()
  var body_568539 = newJObject()
  add(path_568537, "resourceGroupName", newJString(resourceGroupName))
  add(query_568538, "api-version", newJString(apiVersion))
  add(path_568537, "managerName", newJString(managerName))
  add(path_568537, "elementName", newJString(elementName))
  add(path_568537, "subscriptionId", newJString(subscriptionId))
  add(path_568537, "backupName", newJString(backupName))
  if cloneRequest != nil:
    body_568539 = cloneRequest
  add(path_568537, "deviceName", newJString(deviceName))
  result = call_568536.call(path_568537, query_568538, nil, nil, body_568539)

var backupsClone* = Call_BackupsClone_568524(name: "backupsClone",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}/elements/{elementName}/clone",
    validator: validate_BackupsClone_568525, base: "", url: url_BackupsClone_568526,
    schemes: {Scheme.Https})
type
  Call_ChapSettingsListByDevice_568540 = ref object of OpenApiRestCall_567667
proc url_ChapSettingsListByDevice_568542(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/chapSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChapSettingsListByDevice_568541(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the chap settings in a device.
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
  ##             : The name of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568543 = path.getOrDefault("resourceGroupName")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "resourceGroupName", valid_568543
  var valid_568544 = path.getOrDefault("managerName")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "managerName", valid_568544
  var valid_568545 = path.getOrDefault("subscriptionId")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "subscriptionId", valid_568545
  var valid_568546 = path.getOrDefault("deviceName")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "deviceName", valid_568546
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568547 = query.getOrDefault("api-version")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "api-version", valid_568547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568548: Call_ChapSettingsListByDevice_568540; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the chap settings in a device.
  ## 
  let valid = call_568548.validator(path, query, header, formData, body)
  let scheme = call_568548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568548.url(scheme.get, call_568548.host, call_568548.base,
                         call_568548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568548, url, valid)

proc call*(call_568549: Call_ChapSettingsListByDevice_568540;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## chapSettingsListByDevice
  ## Retrieves all the chap settings in a device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the device.
  var path_568550 = newJObject()
  var query_568551 = newJObject()
  add(path_568550, "resourceGroupName", newJString(resourceGroupName))
  add(query_568551, "api-version", newJString(apiVersion))
  add(path_568550, "managerName", newJString(managerName))
  add(path_568550, "subscriptionId", newJString(subscriptionId))
  add(path_568550, "deviceName", newJString(deviceName))
  result = call_568549.call(path_568550, query_568551, nil, nil, nil)

var chapSettingsListByDevice* = Call_ChapSettingsListByDevice_568540(
    name: "chapSettingsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/chapSettings",
    validator: validate_ChapSettingsListByDevice_568541, base: "",
    url: url_ChapSettingsListByDevice_568542, schemes: {Scheme.Https})
type
  Call_ChapSettingsCreateOrUpdate_568565 = ref object of OpenApiRestCall_567667
proc url_ChapSettingsCreateOrUpdate_568567(protocol: Scheme; host: string;
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
  assert "chapUserName" in path, "`chapUserName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/chapSettings/"),
               (kind: VariableSegment, value: "chapUserName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChapSettingsCreateOrUpdate_568566(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the chap setting.
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
  ##   chapUserName: JString (required)
  ##               : The chap user name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568568 = path.getOrDefault("resourceGroupName")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "resourceGroupName", valid_568568
  var valid_568569 = path.getOrDefault("managerName")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "managerName", valid_568569
  var valid_568570 = path.getOrDefault("subscriptionId")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "subscriptionId", valid_568570
  var valid_568571 = path.getOrDefault("chapUserName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "chapUserName", valid_568571
  var valid_568572 = path.getOrDefault("deviceName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "deviceName", valid_568572
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568573 = query.getOrDefault("api-version")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "api-version", valid_568573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   chapSetting: JObject (required)
  ##              : The chap setting to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568575: Call_ChapSettingsCreateOrUpdate_568565; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the chap setting.
  ## 
  let valid = call_568575.validator(path, query, header, formData, body)
  let scheme = call_568575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568575.url(scheme.get, call_568575.host, call_568575.base,
                         call_568575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568575, url, valid)

proc call*(call_568576: Call_ChapSettingsCreateOrUpdate_568565;
          resourceGroupName: string; apiVersion: string; managerName: string;
          chapSetting: JsonNode; subscriptionId: string; chapUserName: string;
          deviceName: string): Recallable =
  ## chapSettingsCreateOrUpdate
  ## Creates or updates the chap setting.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   chapSetting: JObject (required)
  ##              : The chap setting to be added or updated.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   chapUserName: string (required)
  ##               : The chap user name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568577 = newJObject()
  var query_568578 = newJObject()
  var body_568579 = newJObject()
  add(path_568577, "resourceGroupName", newJString(resourceGroupName))
  add(query_568578, "api-version", newJString(apiVersion))
  add(path_568577, "managerName", newJString(managerName))
  if chapSetting != nil:
    body_568579 = chapSetting
  add(path_568577, "subscriptionId", newJString(subscriptionId))
  add(path_568577, "chapUserName", newJString(chapUserName))
  add(path_568577, "deviceName", newJString(deviceName))
  result = call_568576.call(path_568577, query_568578, nil, nil, body_568579)

var chapSettingsCreateOrUpdate* = Call_ChapSettingsCreateOrUpdate_568565(
    name: "chapSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/chapSettings/{chapUserName}",
    validator: validate_ChapSettingsCreateOrUpdate_568566, base: "",
    url: url_ChapSettingsCreateOrUpdate_568567, schemes: {Scheme.Https})
type
  Call_ChapSettingsGet_568552 = ref object of OpenApiRestCall_567667
proc url_ChapSettingsGet_568554(protocol: Scheme; host: string; base: string;
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
  assert "chapUserName" in path, "`chapUserName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/chapSettings/"),
               (kind: VariableSegment, value: "chapUserName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChapSettingsGet_568553(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns the properties of the specified chap setting name.
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
  ##   chapUserName: JString (required)
  ##               : The user name of chap to be fetched.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568555 = path.getOrDefault("resourceGroupName")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "resourceGroupName", valid_568555
  var valid_568556 = path.getOrDefault("managerName")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "managerName", valid_568556
  var valid_568557 = path.getOrDefault("subscriptionId")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "subscriptionId", valid_568557
  var valid_568558 = path.getOrDefault("chapUserName")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "chapUserName", valid_568558
  var valid_568559 = path.getOrDefault("deviceName")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "deviceName", valid_568559
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568560 = query.getOrDefault("api-version")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "api-version", valid_568560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568561: Call_ChapSettingsGet_568552; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified chap setting name.
  ## 
  let valid = call_568561.validator(path, query, header, formData, body)
  let scheme = call_568561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568561.url(scheme.get, call_568561.host, call_568561.base,
                         call_568561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568561, url, valid)

proc call*(call_568562: Call_ChapSettingsGet_568552; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          chapUserName: string; deviceName: string): Recallable =
  ## chapSettingsGet
  ## Returns the properties of the specified chap setting name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   chapUserName: string (required)
  ##               : The user name of chap to be fetched.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568563 = newJObject()
  var query_568564 = newJObject()
  add(path_568563, "resourceGroupName", newJString(resourceGroupName))
  add(query_568564, "api-version", newJString(apiVersion))
  add(path_568563, "managerName", newJString(managerName))
  add(path_568563, "subscriptionId", newJString(subscriptionId))
  add(path_568563, "chapUserName", newJString(chapUserName))
  add(path_568563, "deviceName", newJString(deviceName))
  result = call_568562.call(path_568563, query_568564, nil, nil, nil)

var chapSettingsGet* = Call_ChapSettingsGet_568552(name: "chapSettingsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/chapSettings/{chapUserName}",
    validator: validate_ChapSettingsGet_568553, base: "", url: url_ChapSettingsGet_568554,
    schemes: {Scheme.Https})
type
  Call_ChapSettingsDelete_568580 = ref object of OpenApiRestCall_567667
proc url_ChapSettingsDelete_568582(protocol: Scheme; host: string; base: string;
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
  assert "chapUserName" in path, "`chapUserName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/chapSettings/"),
               (kind: VariableSegment, value: "chapUserName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChapSettingsDelete_568581(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the chap setting.
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
  ##   chapUserName: JString (required)
  ##               : The chap user name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568583 = path.getOrDefault("resourceGroupName")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "resourceGroupName", valid_568583
  var valid_568584 = path.getOrDefault("managerName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "managerName", valid_568584
  var valid_568585 = path.getOrDefault("subscriptionId")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "subscriptionId", valid_568585
  var valid_568586 = path.getOrDefault("chapUserName")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "chapUserName", valid_568586
  var valid_568587 = path.getOrDefault("deviceName")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "deviceName", valid_568587
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568588 = query.getOrDefault("api-version")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "api-version", valid_568588
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568589: Call_ChapSettingsDelete_568580; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the chap setting.
  ## 
  let valid = call_568589.validator(path, query, header, formData, body)
  let scheme = call_568589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568589.url(scheme.get, call_568589.host, call_568589.base,
                         call_568589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568589, url, valid)

proc call*(call_568590: Call_ChapSettingsDelete_568580; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          chapUserName: string; deviceName: string): Recallable =
  ## chapSettingsDelete
  ## Deletes the chap setting.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   chapUserName: string (required)
  ##               : The chap user name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568591 = newJObject()
  var query_568592 = newJObject()
  add(path_568591, "resourceGroupName", newJString(resourceGroupName))
  add(query_568592, "api-version", newJString(apiVersion))
  add(path_568591, "managerName", newJString(managerName))
  add(path_568591, "subscriptionId", newJString(subscriptionId))
  add(path_568591, "chapUserName", newJString(chapUserName))
  add(path_568591, "deviceName", newJString(deviceName))
  result = call_568590.call(path_568591, query_568592, nil, nil, nil)

var chapSettingsDelete* = Call_ChapSettingsDelete_568580(
    name: "chapSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/chapSettings/{chapUserName}",
    validator: validate_ChapSettingsDelete_568581, base: "",
    url: url_ChapSettingsDelete_568582, schemes: {Scheme.Https})
type
  Call_DevicesDeactivate_568593 = ref object of OpenApiRestCall_567667
proc url_DevicesDeactivate_568595(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDeactivate_568594(path: JsonNode; query: JsonNode;
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568596 = path.getOrDefault("resourceGroupName")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "resourceGroupName", valid_568596
  var valid_568597 = path.getOrDefault("managerName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "managerName", valid_568597
  var valid_568598 = path.getOrDefault("subscriptionId")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "subscriptionId", valid_568598
  var valid_568599 = path.getOrDefault("deviceName")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "deviceName", valid_568599
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568600 = query.getOrDefault("api-version")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "api-version", valid_568600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568601: Call_DevicesDeactivate_568593; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deactivates the device.
  ## 
  let valid = call_568601.validator(path, query, header, formData, body)
  let scheme = call_568601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568601.url(scheme.get, call_568601.host, call_568601.base,
                         call_568601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568601, url, valid)

proc call*(call_568602: Call_DevicesDeactivate_568593; resourceGroupName: string;
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
  ##             : The device name.
  var path_568603 = newJObject()
  var query_568604 = newJObject()
  add(path_568603, "resourceGroupName", newJString(resourceGroupName))
  add(query_568604, "api-version", newJString(apiVersion))
  add(path_568603, "managerName", newJString(managerName))
  add(path_568603, "subscriptionId", newJString(subscriptionId))
  add(path_568603, "deviceName", newJString(deviceName))
  result = call_568602.call(path_568603, query_568604, nil, nil, nil)

var devicesDeactivate* = Call_DevicesDeactivate_568593(name: "devicesDeactivate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/deactivate",
    validator: validate_DevicesDeactivate_568594, base: "",
    url: url_DevicesDeactivate_568595, schemes: {Scheme.Https})
type
  Call_IscsiDisksListByDevice_568605 = ref object of OpenApiRestCall_567667
proc url_IscsiDisksListByDevice_568607(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/disks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksListByDevice_568606(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the iSCSI disks in a device.
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568608 = path.getOrDefault("resourceGroupName")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "resourceGroupName", valid_568608
  var valid_568609 = path.getOrDefault("managerName")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "managerName", valid_568609
  var valid_568610 = path.getOrDefault("subscriptionId")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "subscriptionId", valid_568610
  var valid_568611 = path.getOrDefault("deviceName")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "deviceName", valid_568611
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568612 = query.getOrDefault("api-version")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "api-version", valid_568612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568613: Call_IscsiDisksListByDevice_568605; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the iSCSI disks in a device.
  ## 
  let valid = call_568613.validator(path, query, header, formData, body)
  let scheme = call_568613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568613.url(scheme.get, call_568613.host, call_568613.base,
                         call_568613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568613, url, valid)

proc call*(call_568614: Call_IscsiDisksListByDevice_568605;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## iscsiDisksListByDevice
  ## Retrieves all the iSCSI disks in a device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568615 = newJObject()
  var query_568616 = newJObject()
  add(path_568615, "resourceGroupName", newJString(resourceGroupName))
  add(query_568616, "api-version", newJString(apiVersion))
  add(path_568615, "managerName", newJString(managerName))
  add(path_568615, "subscriptionId", newJString(subscriptionId))
  add(path_568615, "deviceName", newJString(deviceName))
  result = call_568614.call(path_568615, query_568616, nil, nil, nil)

var iscsiDisksListByDevice* = Call_IscsiDisksListByDevice_568605(
    name: "iscsiDisksListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/disks",
    validator: validate_IscsiDisksListByDevice_568606, base: "",
    url: url_IscsiDisksListByDevice_568607, schemes: {Scheme.Https})
type
  Call_DevicesDownloadUpdates_568617 = ref object of OpenApiRestCall_567667
proc url_DevicesDownloadUpdates_568619(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/download")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesDownloadUpdates_568618(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Downloads updates on the device.
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568620 = path.getOrDefault("resourceGroupName")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "resourceGroupName", valid_568620
  var valid_568621 = path.getOrDefault("managerName")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "managerName", valid_568621
  var valid_568622 = path.getOrDefault("subscriptionId")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "subscriptionId", valid_568622
  var valid_568623 = path.getOrDefault("deviceName")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "deviceName", valid_568623
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568624 = query.getOrDefault("api-version")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "api-version", valid_568624
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568625: Call_DevicesDownloadUpdates_568617; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads updates on the device.
  ## 
  let valid = call_568625.validator(path, query, header, formData, body)
  let scheme = call_568625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568625.url(scheme.get, call_568625.host, call_568625.base,
                         call_568625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568625, url, valid)

proc call*(call_568626: Call_DevicesDownloadUpdates_568617;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesDownloadUpdates
  ## Downloads updates on the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568627 = newJObject()
  var query_568628 = newJObject()
  add(path_568627, "resourceGroupName", newJString(resourceGroupName))
  add(query_568628, "api-version", newJString(apiVersion))
  add(path_568627, "managerName", newJString(managerName))
  add(path_568627, "subscriptionId", newJString(subscriptionId))
  add(path_568627, "deviceName", newJString(deviceName))
  result = call_568626.call(path_568627, query_568628, nil, nil, nil)

var devicesDownloadUpdates* = Call_DevicesDownloadUpdates_568617(
    name: "devicesDownloadUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/download",
    validator: validate_DevicesDownloadUpdates_568618, base: "",
    url: url_DevicesDownloadUpdates_568619, schemes: {Scheme.Https})
type
  Call_DevicesFailover_568629 = ref object of OpenApiRestCall_567667
proc url_DevicesFailover_568631(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesFailover_568630(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Fails over the device to another device.
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568632 = path.getOrDefault("resourceGroupName")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "resourceGroupName", valid_568632
  var valid_568633 = path.getOrDefault("managerName")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "managerName", valid_568633
  var valid_568634 = path.getOrDefault("subscriptionId")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "subscriptionId", valid_568634
  var valid_568635 = path.getOrDefault("deviceName")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "deviceName", valid_568635
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568636 = query.getOrDefault("api-version")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "api-version", valid_568636
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   failoverRequest: JObject (required)
  ##                  : The failover request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568638: Call_DevicesFailover_568629; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fails over the device to another device.
  ## 
  let valid = call_568638.validator(path, query, header, formData, body)
  let scheme = call_568638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568638.url(scheme.get, call_568638.host, call_568638.base,
                         call_568638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568638, url, valid)

proc call*(call_568639: Call_DevicesFailover_568629; resourceGroupName: string;
          apiVersion: string; managerName: string; failoverRequest: JsonNode;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesFailover
  ## Fails over the device to another device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   failoverRequest: JObject (required)
  ##                  : The failover request.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568640 = newJObject()
  var query_568641 = newJObject()
  var body_568642 = newJObject()
  add(path_568640, "resourceGroupName", newJString(resourceGroupName))
  add(query_568641, "api-version", newJString(apiVersion))
  add(path_568640, "managerName", newJString(managerName))
  if failoverRequest != nil:
    body_568642 = failoverRequest
  add(path_568640, "subscriptionId", newJString(subscriptionId))
  add(path_568640, "deviceName", newJString(deviceName))
  result = call_568639.call(path_568640, query_568641, nil, nil, body_568642)

var devicesFailover* = Call_DevicesFailover_568629(name: "devicesFailover",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/failover",
    validator: validate_DevicesFailover_568630, base: "", url: url_DevicesFailover_568631,
    schemes: {Scheme.Https})
type
  Call_DevicesListFailoverTarget_568643 = ref object of OpenApiRestCall_567667
proc url_DevicesListFailoverTarget_568645(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/failoverTargets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesListFailoverTarget_568644(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the devices which can be used as failover targets for the given device.
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568646 = path.getOrDefault("resourceGroupName")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "resourceGroupName", valid_568646
  var valid_568647 = path.getOrDefault("managerName")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "managerName", valid_568647
  var valid_568648 = path.getOrDefault("subscriptionId")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "subscriptionId", valid_568648
  var valid_568649 = path.getOrDefault("deviceName")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "deviceName", valid_568649
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568650 = query.getOrDefault("api-version")
  valid_568650 = validateParameter(valid_568650, JString, required = true,
                                 default = nil)
  if valid_568650 != nil:
    section.add "api-version", valid_568650
  var valid_568651 = query.getOrDefault("$expand")
  valid_568651 = validateParameter(valid_568651, JString, required = false,
                                 default = nil)
  if valid_568651 != nil:
    section.add "$expand", valid_568651
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568652: Call_DevicesListFailoverTarget_568643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the devices which can be used as failover targets for the given device.
  ## 
  let valid = call_568652.validator(path, query, header, formData, body)
  let scheme = call_568652.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568652.url(scheme.get, call_568652.host, call_568652.base,
                         call_568652.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568652, url, valid)

proc call*(call_568653: Call_DevicesListFailoverTarget_568643;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string; Expand: string = ""): Recallable =
  ## devicesListFailoverTarget
  ## Retrieves all the devices which can be used as failover targets for the given device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   Expand: string
  ##         : Specify $expand=details to populate additional fields related to the device.
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568654 = newJObject()
  var query_568655 = newJObject()
  add(path_568654, "resourceGroupName", newJString(resourceGroupName))
  add(query_568655, "api-version", newJString(apiVersion))
  add(query_568655, "$expand", newJString(Expand))
  add(path_568654, "managerName", newJString(managerName))
  add(path_568654, "subscriptionId", newJString(subscriptionId))
  add(path_568654, "deviceName", newJString(deviceName))
  result = call_568653.call(path_568654, query_568655, nil, nil, nil)

var devicesListFailoverTarget* = Call_DevicesListFailoverTarget_568643(
    name: "devicesListFailoverTarget", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/failoverTargets",
    validator: validate_DevicesListFailoverTarget_568644, base: "",
    url: url_DevicesListFailoverTarget_568645, schemes: {Scheme.Https})
type
  Call_FileServersListByDevice_568656 = ref object of OpenApiRestCall_567667
proc url_FileServersListByDevice_568658(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/fileservers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersListByDevice_568657(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the file servers in a device.
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568659 = path.getOrDefault("resourceGroupName")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "resourceGroupName", valid_568659
  var valid_568660 = path.getOrDefault("managerName")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "managerName", valid_568660
  var valid_568661 = path.getOrDefault("subscriptionId")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "subscriptionId", valid_568661
  var valid_568662 = path.getOrDefault("deviceName")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "deviceName", valid_568662
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568663 = query.getOrDefault("api-version")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "api-version", valid_568663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568664: Call_FileServersListByDevice_568656; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the file servers in a device.
  ## 
  let valid = call_568664.validator(path, query, header, formData, body)
  let scheme = call_568664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568664.url(scheme.get, call_568664.host, call_568664.base,
                         call_568664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568664, url, valid)

proc call*(call_568665: Call_FileServersListByDevice_568656;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## fileServersListByDevice
  ## Retrieves all the file servers in a device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568666 = newJObject()
  var query_568667 = newJObject()
  add(path_568666, "resourceGroupName", newJString(resourceGroupName))
  add(query_568667, "api-version", newJString(apiVersion))
  add(path_568666, "managerName", newJString(managerName))
  add(path_568666, "subscriptionId", newJString(subscriptionId))
  add(path_568666, "deviceName", newJString(deviceName))
  result = call_568665.call(path_568666, query_568667, nil, nil, nil)

var fileServersListByDevice* = Call_FileServersListByDevice_568656(
    name: "fileServersListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers",
    validator: validate_FileServersListByDevice_568657, base: "",
    url: url_FileServersListByDevice_568658, schemes: {Scheme.Https})
type
  Call_FileServersCreateOrUpdate_568681 = ref object of OpenApiRestCall_567667
proc url_FileServersCreateOrUpdate_568683(protocol: Scheme; host: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersCreateOrUpdate_568682(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the file server.
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
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568684 = path.getOrDefault("resourceGroupName")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "resourceGroupName", valid_568684
  var valid_568685 = path.getOrDefault("managerName")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "managerName", valid_568685
  var valid_568686 = path.getOrDefault("subscriptionId")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "subscriptionId", valid_568686
  var valid_568687 = path.getOrDefault("fileServerName")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "fileServerName", valid_568687
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
  ## parameters in `body` object:
  ##   fileServer: JObject (required)
  ##             : The file server.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568691: Call_FileServersCreateOrUpdate_568681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the file server.
  ## 
  let valid = call_568691.validator(path, query, header, formData, body)
  let scheme = call_568691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568691.url(scheme.get, call_568691.host, call_568691.base,
                         call_568691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568691, url, valid)

proc call*(call_568692: Call_FileServersCreateOrUpdate_568681;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; fileServerName: string; fileServer: JsonNode;
          deviceName: string): Recallable =
  ## fileServersCreateOrUpdate
  ## Creates or updates the file server.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   fileServer: JObject (required)
  ##             : The file server.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568693 = newJObject()
  var query_568694 = newJObject()
  var body_568695 = newJObject()
  add(path_568693, "resourceGroupName", newJString(resourceGroupName))
  add(query_568694, "api-version", newJString(apiVersion))
  add(path_568693, "managerName", newJString(managerName))
  add(path_568693, "subscriptionId", newJString(subscriptionId))
  add(path_568693, "fileServerName", newJString(fileServerName))
  if fileServer != nil:
    body_568695 = fileServer
  add(path_568693, "deviceName", newJString(deviceName))
  result = call_568692.call(path_568693, query_568694, nil, nil, body_568695)

var fileServersCreateOrUpdate* = Call_FileServersCreateOrUpdate_568681(
    name: "fileServersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}",
    validator: validate_FileServersCreateOrUpdate_568682, base: "",
    url: url_FileServersCreateOrUpdate_568683, schemes: {Scheme.Https})
type
  Call_FileServersGet_568668 = ref object of OpenApiRestCall_567667
proc url_FileServersGet_568670(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersGet_568669(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns the properties of the specified file server name.
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
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568671 = path.getOrDefault("resourceGroupName")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "resourceGroupName", valid_568671
  var valid_568672 = path.getOrDefault("managerName")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "managerName", valid_568672
  var valid_568673 = path.getOrDefault("subscriptionId")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "subscriptionId", valid_568673
  var valid_568674 = path.getOrDefault("fileServerName")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "fileServerName", valid_568674
  var valid_568675 = path.getOrDefault("deviceName")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "deviceName", valid_568675
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568676 = query.getOrDefault("api-version")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "api-version", valid_568676
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568677: Call_FileServersGet_568668; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified file server name.
  ## 
  let valid = call_568677.validator(path, query, header, formData, body)
  let scheme = call_568677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568677.url(scheme.get, call_568677.host, call_568677.base,
                         call_568677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568677, url, valid)

proc call*(call_568678: Call_FileServersGet_568668; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          fileServerName: string; deviceName: string): Recallable =
  ## fileServersGet
  ## Returns the properties of the specified file server name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568679 = newJObject()
  var query_568680 = newJObject()
  add(path_568679, "resourceGroupName", newJString(resourceGroupName))
  add(query_568680, "api-version", newJString(apiVersion))
  add(path_568679, "managerName", newJString(managerName))
  add(path_568679, "subscriptionId", newJString(subscriptionId))
  add(path_568679, "fileServerName", newJString(fileServerName))
  add(path_568679, "deviceName", newJString(deviceName))
  result = call_568678.call(path_568679, query_568680, nil, nil, nil)

var fileServersGet* = Call_FileServersGet_568668(name: "fileServersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}",
    validator: validate_FileServersGet_568669, base: "", url: url_FileServersGet_568670,
    schemes: {Scheme.Https})
type
  Call_FileServersDelete_568696 = ref object of OpenApiRestCall_567667
proc url_FileServersDelete_568698(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersDelete_568697(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the file server.
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
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568699 = path.getOrDefault("resourceGroupName")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "resourceGroupName", valid_568699
  var valid_568700 = path.getOrDefault("managerName")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "managerName", valid_568700
  var valid_568701 = path.getOrDefault("subscriptionId")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "subscriptionId", valid_568701
  var valid_568702 = path.getOrDefault("fileServerName")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "fileServerName", valid_568702
  var valid_568703 = path.getOrDefault("deviceName")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "deviceName", valid_568703
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568704 = query.getOrDefault("api-version")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "api-version", valid_568704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568705: Call_FileServersDelete_568696; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the file server.
  ## 
  let valid = call_568705.validator(path, query, header, formData, body)
  let scheme = call_568705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568705.url(scheme.get, call_568705.host, call_568705.base,
                         call_568705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568705, url, valid)

proc call*(call_568706: Call_FileServersDelete_568696; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          fileServerName: string; deviceName: string): Recallable =
  ## fileServersDelete
  ## Deletes the file server.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568707 = newJObject()
  var query_568708 = newJObject()
  add(path_568707, "resourceGroupName", newJString(resourceGroupName))
  add(query_568708, "api-version", newJString(apiVersion))
  add(path_568707, "managerName", newJString(managerName))
  add(path_568707, "subscriptionId", newJString(subscriptionId))
  add(path_568707, "fileServerName", newJString(fileServerName))
  add(path_568707, "deviceName", newJString(deviceName))
  result = call_568706.call(path_568707, query_568708, nil, nil, nil)

var fileServersDelete* = Call_FileServersDelete_568696(name: "fileServersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}",
    validator: validate_FileServersDelete_568697, base: "",
    url: url_FileServersDelete_568698, schemes: {Scheme.Https})
type
  Call_FileServersBackupNow_568709 = ref object of OpenApiRestCall_567667
proc url_FileServersBackupNow_568711(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersBackupNow_568710(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Backup the file server now.
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
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568712 = path.getOrDefault("resourceGroupName")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "resourceGroupName", valid_568712
  var valid_568713 = path.getOrDefault("managerName")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "managerName", valid_568713
  var valid_568714 = path.getOrDefault("subscriptionId")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "subscriptionId", valid_568714
  var valid_568715 = path.getOrDefault("fileServerName")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "fileServerName", valid_568715
  var valid_568716 = path.getOrDefault("deviceName")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "deviceName", valid_568716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568717 = query.getOrDefault("api-version")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "api-version", valid_568717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568718: Call_FileServersBackupNow_568709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup the file server now.
  ## 
  let valid = call_568718.validator(path, query, header, formData, body)
  let scheme = call_568718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568718.url(scheme.get, call_568718.host, call_568718.base,
                         call_568718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568718, url, valid)

proc call*(call_568719: Call_FileServersBackupNow_568709;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; fileServerName: string; deviceName: string): Recallable =
  ## fileServersBackupNow
  ## Backup the file server now.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568720 = newJObject()
  var query_568721 = newJObject()
  add(path_568720, "resourceGroupName", newJString(resourceGroupName))
  add(query_568721, "api-version", newJString(apiVersion))
  add(path_568720, "managerName", newJString(managerName))
  add(path_568720, "subscriptionId", newJString(subscriptionId))
  add(path_568720, "fileServerName", newJString(fileServerName))
  add(path_568720, "deviceName", newJString(deviceName))
  result = call_568719.call(path_568720, query_568721, nil, nil, nil)

var fileServersBackupNow* = Call_FileServersBackupNow_568709(
    name: "fileServersBackupNow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/backup",
    validator: validate_FileServersBackupNow_568710, base: "",
    url: url_FileServersBackupNow_568711, schemes: {Scheme.Https})
type
  Call_FileServersListMetrics_568722 = ref object of OpenApiRestCall_567667
proc url_FileServersListMetrics_568724(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersListMetrics_568723(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the file server metrics.
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
  ##   fileServerName: JString (required)
  ##                 : The name of the file server name.
  ##   deviceName: JString (required)
  ##             : The name of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568725 = path.getOrDefault("resourceGroupName")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "resourceGroupName", valid_568725
  var valid_568726 = path.getOrDefault("managerName")
  valid_568726 = validateParameter(valid_568726, JString, required = true,
                                 default = nil)
  if valid_568726 != nil:
    section.add "managerName", valid_568726
  var valid_568727 = path.getOrDefault("subscriptionId")
  valid_568727 = validateParameter(valid_568727, JString, required = true,
                                 default = nil)
  if valid_568727 != nil:
    section.add "subscriptionId", valid_568727
  var valid_568728 = path.getOrDefault("fileServerName")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "fileServerName", valid_568728
  var valid_568729 = path.getOrDefault("deviceName")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "deviceName", valid_568729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568730 = query.getOrDefault("api-version")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "api-version", valid_568730
  var valid_568731 = query.getOrDefault("$filter")
  valid_568731 = validateParameter(valid_568731, JString, required = false,
                                 default = nil)
  if valid_568731 != nil:
    section.add "$filter", valid_568731
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568732: Call_FileServersListMetrics_568722; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the file server metrics.
  ## 
  let valid = call_568732.validator(path, query, header, formData, body)
  let scheme = call_568732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568732.url(scheme.get, call_568732.host, call_568732.base,
                         call_568732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568732, url, valid)

proc call*(call_568733: Call_FileServersListMetrics_568722;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; fileServerName: string; deviceName: string;
          Filter: string = ""): Recallable =
  ## fileServersListMetrics
  ## Gets the file server metrics.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The name of the file server name.
  ##   Filter: string
  ##         : OData Filter options
  ##   deviceName: string (required)
  ##             : The name of the device.
  var path_568734 = newJObject()
  var query_568735 = newJObject()
  add(path_568734, "resourceGroupName", newJString(resourceGroupName))
  add(query_568735, "api-version", newJString(apiVersion))
  add(path_568734, "managerName", newJString(managerName))
  add(path_568734, "subscriptionId", newJString(subscriptionId))
  add(path_568734, "fileServerName", newJString(fileServerName))
  add(query_568735, "$filter", newJString(Filter))
  add(path_568734, "deviceName", newJString(deviceName))
  result = call_568733.call(path_568734, query_568735, nil, nil, nil)

var fileServersListMetrics* = Call_FileServersListMetrics_568722(
    name: "fileServersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/metrics",
    validator: validate_FileServersListMetrics_568723, base: "",
    url: url_FileServersListMetrics_568724, schemes: {Scheme.Https})
type
  Call_FileServersListMetricDefinition_568736 = ref object of OpenApiRestCall_567667
proc url_FileServersListMetricDefinition_568738(protocol: Scheme; host: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersListMetricDefinition_568737(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions of all metrics aggregated at the file server.
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
  ##   fileServerName: JString (required)
  ##                 : The name of the file server.
  ##   deviceName: JString (required)
  ##             : The name of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568739 = path.getOrDefault("resourceGroupName")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "resourceGroupName", valid_568739
  var valid_568740 = path.getOrDefault("managerName")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "managerName", valid_568740
  var valid_568741 = path.getOrDefault("subscriptionId")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "subscriptionId", valid_568741
  var valid_568742 = path.getOrDefault("fileServerName")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "fileServerName", valid_568742
  var valid_568743 = path.getOrDefault("deviceName")
  valid_568743 = validateParameter(valid_568743, JString, required = true,
                                 default = nil)
  if valid_568743 != nil:
    section.add "deviceName", valid_568743
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568744 = query.getOrDefault("api-version")
  valid_568744 = validateParameter(valid_568744, JString, required = true,
                                 default = nil)
  if valid_568744 != nil:
    section.add "api-version", valid_568744
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568745: Call_FileServersListMetricDefinition_568736;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions of all metrics aggregated at the file server.
  ## 
  let valid = call_568745.validator(path, query, header, formData, body)
  let scheme = call_568745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568745.url(scheme.get, call_568745.host, call_568745.base,
                         call_568745.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568745, url, valid)

proc call*(call_568746: Call_FileServersListMetricDefinition_568736;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; fileServerName: string; deviceName: string): Recallable =
  ## fileServersListMetricDefinition
  ## Retrieves metric definitions of all metrics aggregated at the file server.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The name of the file server.
  ##   deviceName: string (required)
  ##             : The name of the device.
  var path_568747 = newJObject()
  var query_568748 = newJObject()
  add(path_568747, "resourceGroupName", newJString(resourceGroupName))
  add(query_568748, "api-version", newJString(apiVersion))
  add(path_568747, "managerName", newJString(managerName))
  add(path_568747, "subscriptionId", newJString(subscriptionId))
  add(path_568747, "fileServerName", newJString(fileServerName))
  add(path_568747, "deviceName", newJString(deviceName))
  result = call_568746.call(path_568747, query_568748, nil, nil, nil)

var fileServersListMetricDefinition* = Call_FileServersListMetricDefinition_568736(
    name: "fileServersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/metricsDefinitions",
    validator: validate_FileServersListMetricDefinition_568737, base: "",
    url: url_FileServersListMetricDefinition_568738, schemes: {Scheme.Https})
type
  Call_FileSharesListByFileServer_568749 = ref object of OpenApiRestCall_567667
proc url_FileSharesListByFileServer_568751(protocol: Scheme; host: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/shares")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesListByFileServer_568750(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the file shares in a file server.
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
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568752 = path.getOrDefault("resourceGroupName")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "resourceGroupName", valid_568752
  var valid_568753 = path.getOrDefault("managerName")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "managerName", valid_568753
  var valid_568754 = path.getOrDefault("subscriptionId")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "subscriptionId", valid_568754
  var valid_568755 = path.getOrDefault("fileServerName")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "fileServerName", valid_568755
  var valid_568756 = path.getOrDefault("deviceName")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "deviceName", valid_568756
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568757 = query.getOrDefault("api-version")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = nil)
  if valid_568757 != nil:
    section.add "api-version", valid_568757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568758: Call_FileSharesListByFileServer_568749; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the file shares in a file server.
  ## 
  let valid = call_568758.validator(path, query, header, formData, body)
  let scheme = call_568758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568758.url(scheme.get, call_568758.host, call_568758.base,
                         call_568758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568758, url, valid)

proc call*(call_568759: Call_FileSharesListByFileServer_568749;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; fileServerName: string; deviceName: string): Recallable =
  ## fileSharesListByFileServer
  ## Retrieves all the file shares in a file server.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568760 = newJObject()
  var query_568761 = newJObject()
  add(path_568760, "resourceGroupName", newJString(resourceGroupName))
  add(query_568761, "api-version", newJString(apiVersion))
  add(path_568760, "managerName", newJString(managerName))
  add(path_568760, "subscriptionId", newJString(subscriptionId))
  add(path_568760, "fileServerName", newJString(fileServerName))
  add(path_568760, "deviceName", newJString(deviceName))
  result = call_568759.call(path_568760, query_568761, nil, nil, nil)

var fileSharesListByFileServer* = Call_FileSharesListByFileServer_568749(
    name: "fileSharesListByFileServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares",
    validator: validate_FileSharesListByFileServer_568750, base: "",
    url: url_FileSharesListByFileServer_568751, schemes: {Scheme.Https})
type
  Call_FileSharesCreateOrUpdate_568776 = ref object of OpenApiRestCall_567667
proc url_FileSharesCreateOrUpdate_568778(protocol: Scheme; host: string;
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
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesCreateOrUpdate_568777(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the file share.
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
  ##   shareName: JString (required)
  ##            : The file share name.
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568779 = path.getOrDefault("resourceGroupName")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "resourceGroupName", valid_568779
  var valid_568780 = path.getOrDefault("managerName")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "managerName", valid_568780
  var valid_568781 = path.getOrDefault("subscriptionId")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "subscriptionId", valid_568781
  var valid_568782 = path.getOrDefault("shareName")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "shareName", valid_568782
  var valid_568783 = path.getOrDefault("fileServerName")
  valid_568783 = validateParameter(valid_568783, JString, required = true,
                                 default = nil)
  if valid_568783 != nil:
    section.add "fileServerName", valid_568783
  var valid_568784 = path.getOrDefault("deviceName")
  valid_568784 = validateParameter(valid_568784, JString, required = true,
                                 default = nil)
  if valid_568784 != nil:
    section.add "deviceName", valid_568784
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568785 = query.getOrDefault("api-version")
  valid_568785 = validateParameter(valid_568785, JString, required = true,
                                 default = nil)
  if valid_568785 != nil:
    section.add "api-version", valid_568785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   fileShare: JObject (required)
  ##            : The file share.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568787: Call_FileSharesCreateOrUpdate_568776; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the file share.
  ## 
  let valid = call_568787.validator(path, query, header, formData, body)
  let scheme = call_568787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568787.url(scheme.get, call_568787.host, call_568787.base,
                         call_568787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568787, url, valid)

proc call*(call_568788: Call_FileSharesCreateOrUpdate_568776;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; shareName: string; fileShare: JsonNode;
          fileServerName: string; deviceName: string): Recallable =
  ## fileSharesCreateOrUpdate
  ## Creates or updates the file share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   shareName: string (required)
  ##            : The file share name.
  ##   fileShare: JObject (required)
  ##            : The file share.
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568789 = newJObject()
  var query_568790 = newJObject()
  var body_568791 = newJObject()
  add(path_568789, "resourceGroupName", newJString(resourceGroupName))
  add(query_568790, "api-version", newJString(apiVersion))
  add(path_568789, "managerName", newJString(managerName))
  add(path_568789, "subscriptionId", newJString(subscriptionId))
  add(path_568789, "shareName", newJString(shareName))
  if fileShare != nil:
    body_568791 = fileShare
  add(path_568789, "fileServerName", newJString(fileServerName))
  add(path_568789, "deviceName", newJString(deviceName))
  result = call_568788.call(path_568789, query_568790, nil, nil, body_568791)

var fileSharesCreateOrUpdate* = Call_FileSharesCreateOrUpdate_568776(
    name: "fileSharesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}",
    validator: validate_FileSharesCreateOrUpdate_568777, base: "",
    url: url_FileSharesCreateOrUpdate_568778, schemes: {Scheme.Https})
type
  Call_FileSharesGet_568762 = ref object of OpenApiRestCall_567667
proc url_FileSharesGet_568764(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesGet_568763(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified file share name.
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
  ##   shareName: JString (required)
  ##            : The file share name.
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568765 = path.getOrDefault("resourceGroupName")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "resourceGroupName", valid_568765
  var valid_568766 = path.getOrDefault("managerName")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "managerName", valid_568766
  var valid_568767 = path.getOrDefault("subscriptionId")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "subscriptionId", valid_568767
  var valid_568768 = path.getOrDefault("shareName")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "shareName", valid_568768
  var valid_568769 = path.getOrDefault("fileServerName")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "fileServerName", valid_568769
  var valid_568770 = path.getOrDefault("deviceName")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "deviceName", valid_568770
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568771 = query.getOrDefault("api-version")
  valid_568771 = validateParameter(valid_568771, JString, required = true,
                                 default = nil)
  if valid_568771 != nil:
    section.add "api-version", valid_568771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568772: Call_FileSharesGet_568762; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified file share name.
  ## 
  let valid = call_568772.validator(path, query, header, formData, body)
  let scheme = call_568772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568772.url(scheme.get, call_568772.host, call_568772.base,
                         call_568772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568772, url, valid)

proc call*(call_568773: Call_FileSharesGet_568762; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          shareName: string; fileServerName: string; deviceName: string): Recallable =
  ## fileSharesGet
  ## Returns the properties of the specified file share name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   shareName: string (required)
  ##            : The file share name.
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568774 = newJObject()
  var query_568775 = newJObject()
  add(path_568774, "resourceGroupName", newJString(resourceGroupName))
  add(query_568775, "api-version", newJString(apiVersion))
  add(path_568774, "managerName", newJString(managerName))
  add(path_568774, "subscriptionId", newJString(subscriptionId))
  add(path_568774, "shareName", newJString(shareName))
  add(path_568774, "fileServerName", newJString(fileServerName))
  add(path_568774, "deviceName", newJString(deviceName))
  result = call_568773.call(path_568774, query_568775, nil, nil, nil)

var fileSharesGet* = Call_FileSharesGet_568762(name: "fileSharesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}",
    validator: validate_FileSharesGet_568763, base: "", url: url_FileSharesGet_568764,
    schemes: {Scheme.Https})
type
  Call_FileSharesDelete_568792 = ref object of OpenApiRestCall_567667
proc url_FileSharesDelete_568794(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesDelete_568793(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the file share.
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
  ##   shareName: JString (required)
  ##            : The file share Name
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568795 = path.getOrDefault("resourceGroupName")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = nil)
  if valid_568795 != nil:
    section.add "resourceGroupName", valid_568795
  var valid_568796 = path.getOrDefault("managerName")
  valid_568796 = validateParameter(valid_568796, JString, required = true,
                                 default = nil)
  if valid_568796 != nil:
    section.add "managerName", valid_568796
  var valid_568797 = path.getOrDefault("subscriptionId")
  valid_568797 = validateParameter(valid_568797, JString, required = true,
                                 default = nil)
  if valid_568797 != nil:
    section.add "subscriptionId", valid_568797
  var valid_568798 = path.getOrDefault("shareName")
  valid_568798 = validateParameter(valid_568798, JString, required = true,
                                 default = nil)
  if valid_568798 != nil:
    section.add "shareName", valid_568798
  var valid_568799 = path.getOrDefault("fileServerName")
  valid_568799 = validateParameter(valid_568799, JString, required = true,
                                 default = nil)
  if valid_568799 != nil:
    section.add "fileServerName", valid_568799
  var valid_568800 = path.getOrDefault("deviceName")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "deviceName", valid_568800
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568801 = query.getOrDefault("api-version")
  valid_568801 = validateParameter(valid_568801, JString, required = true,
                                 default = nil)
  if valid_568801 != nil:
    section.add "api-version", valid_568801
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568802: Call_FileSharesDelete_568792; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the file share.
  ## 
  let valid = call_568802.validator(path, query, header, formData, body)
  let scheme = call_568802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568802.url(scheme.get, call_568802.host, call_568802.base,
                         call_568802.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568802, url, valid)

proc call*(call_568803: Call_FileSharesDelete_568792; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          shareName: string; fileServerName: string; deviceName: string): Recallable =
  ## fileSharesDelete
  ## Deletes the file share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   shareName: string (required)
  ##            : The file share Name
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568804 = newJObject()
  var query_568805 = newJObject()
  add(path_568804, "resourceGroupName", newJString(resourceGroupName))
  add(query_568805, "api-version", newJString(apiVersion))
  add(path_568804, "managerName", newJString(managerName))
  add(path_568804, "subscriptionId", newJString(subscriptionId))
  add(path_568804, "shareName", newJString(shareName))
  add(path_568804, "fileServerName", newJString(fileServerName))
  add(path_568804, "deviceName", newJString(deviceName))
  result = call_568803.call(path_568804, query_568805, nil, nil, nil)

var fileSharesDelete* = Call_FileSharesDelete_568792(name: "fileSharesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}",
    validator: validate_FileSharesDelete_568793, base: "",
    url: url_FileSharesDelete_568794, schemes: {Scheme.Https})
type
  Call_FileSharesListMetrics_568806 = ref object of OpenApiRestCall_567667
proc url_FileSharesListMetrics_568808(protocol: Scheme; host: string; base: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesListMetrics_568807(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the file share metrics
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
  ##   shareName: JString (required)
  ##            : The file share name.
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568809 = path.getOrDefault("resourceGroupName")
  valid_568809 = validateParameter(valid_568809, JString, required = true,
                                 default = nil)
  if valid_568809 != nil:
    section.add "resourceGroupName", valid_568809
  var valid_568810 = path.getOrDefault("managerName")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "managerName", valid_568810
  var valid_568811 = path.getOrDefault("subscriptionId")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "subscriptionId", valid_568811
  var valid_568812 = path.getOrDefault("shareName")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "shareName", valid_568812
  var valid_568813 = path.getOrDefault("fileServerName")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "fileServerName", valid_568813
  var valid_568814 = path.getOrDefault("deviceName")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "deviceName", valid_568814
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568815 = query.getOrDefault("api-version")
  valid_568815 = validateParameter(valid_568815, JString, required = true,
                                 default = nil)
  if valid_568815 != nil:
    section.add "api-version", valid_568815
  var valid_568816 = query.getOrDefault("$filter")
  valid_568816 = validateParameter(valid_568816, JString, required = false,
                                 default = nil)
  if valid_568816 != nil:
    section.add "$filter", valid_568816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568817: Call_FileSharesListMetrics_568806; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the file share metrics
  ## 
  let valid = call_568817.validator(path, query, header, formData, body)
  let scheme = call_568817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568817.url(scheme.get, call_568817.host, call_568817.base,
                         call_568817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568817, url, valid)

proc call*(call_568818: Call_FileSharesListMetrics_568806;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; shareName: string; fileServerName: string;
          deviceName: string; Filter: string = ""): Recallable =
  ## fileSharesListMetrics
  ## Gets the file share metrics
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   shareName: string (required)
  ##            : The file share name.
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   Filter: string
  ##         : OData Filter options
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568819 = newJObject()
  var query_568820 = newJObject()
  add(path_568819, "resourceGroupName", newJString(resourceGroupName))
  add(query_568820, "api-version", newJString(apiVersion))
  add(path_568819, "managerName", newJString(managerName))
  add(path_568819, "subscriptionId", newJString(subscriptionId))
  add(path_568819, "shareName", newJString(shareName))
  add(path_568819, "fileServerName", newJString(fileServerName))
  add(query_568820, "$filter", newJString(Filter))
  add(path_568819, "deviceName", newJString(deviceName))
  result = call_568818.call(path_568819, query_568820, nil, nil, nil)

var fileSharesListMetrics* = Call_FileSharesListMetrics_568806(
    name: "fileSharesListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}/metrics",
    validator: validate_FileSharesListMetrics_568807, base: "",
    url: url_FileSharesListMetrics_568808, schemes: {Scheme.Https})
type
  Call_FileSharesListMetricDefinition_568821 = ref object of OpenApiRestCall_567667
proc url_FileSharesListMetricDefinition_568823(protocol: Scheme; host: string;
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
  assert "fileServerName" in path, "`fileServerName` is a required path parameter"
  assert "shareName" in path, "`shareName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/fileservers/"),
               (kind: VariableSegment, value: "fileServerName"),
               (kind: ConstantSegment, value: "/shares/"),
               (kind: VariableSegment, value: "shareName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesListMetricDefinition_568822(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions of all metrics aggregated at the file share.
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
  ##   shareName: JString (required)
  ##            : The file share name.
  ##   fileServerName: JString (required)
  ##                 : The file server name.
  ##   deviceName: JString (required)
  ##             : The device name.
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
  var valid_568827 = path.getOrDefault("shareName")
  valid_568827 = validateParameter(valid_568827, JString, required = true,
                                 default = nil)
  if valid_568827 != nil:
    section.add "shareName", valid_568827
  var valid_568828 = path.getOrDefault("fileServerName")
  valid_568828 = validateParameter(valid_568828, JString, required = true,
                                 default = nil)
  if valid_568828 != nil:
    section.add "fileServerName", valid_568828
  var valid_568829 = path.getOrDefault("deviceName")
  valid_568829 = validateParameter(valid_568829, JString, required = true,
                                 default = nil)
  if valid_568829 != nil:
    section.add "deviceName", valid_568829
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568830 = query.getOrDefault("api-version")
  valid_568830 = validateParameter(valid_568830, JString, required = true,
                                 default = nil)
  if valid_568830 != nil:
    section.add "api-version", valid_568830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568831: Call_FileSharesListMetricDefinition_568821; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definitions of all metrics aggregated at the file share.
  ## 
  let valid = call_568831.validator(path, query, header, formData, body)
  let scheme = call_568831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568831.url(scheme.get, call_568831.host, call_568831.base,
                         call_568831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568831, url, valid)

proc call*(call_568832: Call_FileSharesListMetricDefinition_568821;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; shareName: string; fileServerName: string;
          deviceName: string): Recallable =
  ## fileSharesListMetricDefinition
  ## Retrieves metric definitions of all metrics aggregated at the file share.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   shareName: string (required)
  ##            : The file share name.
  ##   fileServerName: string (required)
  ##                 : The file server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568833 = newJObject()
  var query_568834 = newJObject()
  add(path_568833, "resourceGroupName", newJString(resourceGroupName))
  add(query_568834, "api-version", newJString(apiVersion))
  add(path_568833, "managerName", newJString(managerName))
  add(path_568833, "subscriptionId", newJString(subscriptionId))
  add(path_568833, "shareName", newJString(shareName))
  add(path_568833, "fileServerName", newJString(fileServerName))
  add(path_568833, "deviceName", newJString(deviceName))
  result = call_568832.call(path_568833, query_568834, nil, nil, nil)

var fileSharesListMetricDefinition* = Call_FileSharesListMetricDefinition_568821(
    name: "fileSharesListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}/metricsDefinitions",
    validator: validate_FileSharesListMetricDefinition_568822, base: "",
    url: url_FileSharesListMetricDefinition_568823, schemes: {Scheme.Https})
type
  Call_DevicesInstallUpdates_568835 = ref object of OpenApiRestCall_567667
proc url_DevicesInstallUpdates_568837(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/install")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesInstallUpdates_568836(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Installs the updates on the device.
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
  ##             : The device name.
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

proc call*(call_568843: Call_DevicesInstallUpdates_568835; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Installs the updates on the device.
  ## 
  let valid = call_568843.validator(path, query, header, formData, body)
  let scheme = call_568843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568843.url(scheme.get, call_568843.host, call_568843.base,
                         call_568843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568843, url, valid)

proc call*(call_568844: Call_DevicesInstallUpdates_568835;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesInstallUpdates
  ## Installs the updates on the device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568845 = newJObject()
  var query_568846 = newJObject()
  add(path_568845, "resourceGroupName", newJString(resourceGroupName))
  add(query_568846, "api-version", newJString(apiVersion))
  add(path_568845, "managerName", newJString(managerName))
  add(path_568845, "subscriptionId", newJString(subscriptionId))
  add(path_568845, "deviceName", newJString(deviceName))
  result = call_568844.call(path_568845, query_568846, nil, nil, nil)

var devicesInstallUpdates* = Call_DevicesInstallUpdates_568835(
    name: "devicesInstallUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/install",
    validator: validate_DevicesInstallUpdates_568836, base: "",
    url: url_DevicesInstallUpdates_568837, schemes: {Scheme.Https})
type
  Call_IscsiServersListByDevice_568847 = ref object of OpenApiRestCall_567667
proc url_IscsiServersListByDevice_568849(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iscsiservers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersListByDevice_568848(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the iSCSI in a device.
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
  ##             : The device name.
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

proc call*(call_568855: Call_IscsiServersListByDevice_568847; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the iSCSI in a device.
  ## 
  let valid = call_568855.validator(path, query, header, formData, body)
  let scheme = call_568855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568855.url(scheme.get, call_568855.host, call_568855.base,
                         call_568855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568855, url, valid)

proc call*(call_568856: Call_IscsiServersListByDevice_568847;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## iscsiServersListByDevice
  ## Retrieves all the iSCSI in a device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568857 = newJObject()
  var query_568858 = newJObject()
  add(path_568857, "resourceGroupName", newJString(resourceGroupName))
  add(query_568858, "api-version", newJString(apiVersion))
  add(path_568857, "managerName", newJString(managerName))
  add(path_568857, "subscriptionId", newJString(subscriptionId))
  add(path_568857, "deviceName", newJString(deviceName))
  result = call_568856.call(path_568857, query_568858, nil, nil, nil)

var iscsiServersListByDevice* = Call_IscsiServersListByDevice_568847(
    name: "iscsiServersListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers",
    validator: validate_IscsiServersListByDevice_568848, base: "",
    url: url_IscsiServersListByDevice_568849, schemes: {Scheme.Https})
type
  Call_IscsiServersCreateOrUpdate_568872 = ref object of OpenApiRestCall_567667
proc url_IscsiServersCreateOrUpdate_568874(protocol: Scheme; host: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersCreateOrUpdate_568873(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the iSCSI server.
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
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568875 = path.getOrDefault("resourceGroupName")
  valid_568875 = validateParameter(valid_568875, JString, required = true,
                                 default = nil)
  if valid_568875 != nil:
    section.add "resourceGroupName", valid_568875
  var valid_568876 = path.getOrDefault("managerName")
  valid_568876 = validateParameter(valid_568876, JString, required = true,
                                 default = nil)
  if valid_568876 != nil:
    section.add "managerName", valid_568876
  var valid_568877 = path.getOrDefault("subscriptionId")
  valid_568877 = validateParameter(valid_568877, JString, required = true,
                                 default = nil)
  if valid_568877 != nil:
    section.add "subscriptionId", valid_568877
  var valid_568878 = path.getOrDefault("iscsiServerName")
  valid_568878 = validateParameter(valid_568878, JString, required = true,
                                 default = nil)
  if valid_568878 != nil:
    section.add "iscsiServerName", valid_568878
  var valid_568879 = path.getOrDefault("deviceName")
  valid_568879 = validateParameter(valid_568879, JString, required = true,
                                 default = nil)
  if valid_568879 != nil:
    section.add "deviceName", valid_568879
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568880 = query.getOrDefault("api-version")
  valid_568880 = validateParameter(valid_568880, JString, required = true,
                                 default = nil)
  if valid_568880 != nil:
    section.add "api-version", valid_568880
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   iscsiServer: JObject (required)
  ##              : The iSCSI server.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568882: Call_IscsiServersCreateOrUpdate_568872; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the iSCSI server.
  ## 
  let valid = call_568882.validator(path, query, header, formData, body)
  let scheme = call_568882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568882.url(scheme.get, call_568882.host, call_568882.base,
                         call_568882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568882, url, valid)

proc call*(call_568883: Call_IscsiServersCreateOrUpdate_568872;
          resourceGroupName: string; apiVersion: string; managerName: string;
          iscsiServer: JsonNode; subscriptionId: string; iscsiServerName: string;
          deviceName: string): Recallable =
  ## iscsiServersCreateOrUpdate
  ## Creates or updates the iSCSI server.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   iscsiServer: JObject (required)
  ##              : The iSCSI server.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568884 = newJObject()
  var query_568885 = newJObject()
  var body_568886 = newJObject()
  add(path_568884, "resourceGroupName", newJString(resourceGroupName))
  add(query_568885, "api-version", newJString(apiVersion))
  add(path_568884, "managerName", newJString(managerName))
  if iscsiServer != nil:
    body_568886 = iscsiServer
  add(path_568884, "subscriptionId", newJString(subscriptionId))
  add(path_568884, "iscsiServerName", newJString(iscsiServerName))
  add(path_568884, "deviceName", newJString(deviceName))
  result = call_568883.call(path_568884, query_568885, nil, nil, body_568886)

var iscsiServersCreateOrUpdate* = Call_IscsiServersCreateOrUpdate_568872(
    name: "iscsiServersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}",
    validator: validate_IscsiServersCreateOrUpdate_568873, base: "",
    url: url_IscsiServersCreateOrUpdate_568874, schemes: {Scheme.Https})
type
  Call_IscsiServersGet_568859 = ref object of OpenApiRestCall_567667
proc url_IscsiServersGet_568861(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersGet_568860(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns the properties of the specified iSCSI server name.
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
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
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
  var valid_568865 = path.getOrDefault("iscsiServerName")
  valid_568865 = validateParameter(valid_568865, JString, required = true,
                                 default = nil)
  if valid_568865 != nil:
    section.add "iscsiServerName", valid_568865
  var valid_568866 = path.getOrDefault("deviceName")
  valid_568866 = validateParameter(valid_568866, JString, required = true,
                                 default = nil)
  if valid_568866 != nil:
    section.add "deviceName", valid_568866
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568867 = query.getOrDefault("api-version")
  valid_568867 = validateParameter(valid_568867, JString, required = true,
                                 default = nil)
  if valid_568867 != nil:
    section.add "api-version", valid_568867
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568868: Call_IscsiServersGet_568859; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified iSCSI server name.
  ## 
  let valid = call_568868.validator(path, query, header, formData, body)
  let scheme = call_568868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568868.url(scheme.get, call_568868.host, call_568868.base,
                         call_568868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568868, url, valid)

proc call*(call_568869: Call_IscsiServersGet_568859; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          iscsiServerName: string; deviceName: string): Recallable =
  ## iscsiServersGet
  ## Returns the properties of the specified iSCSI server name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568870 = newJObject()
  var query_568871 = newJObject()
  add(path_568870, "resourceGroupName", newJString(resourceGroupName))
  add(query_568871, "api-version", newJString(apiVersion))
  add(path_568870, "managerName", newJString(managerName))
  add(path_568870, "subscriptionId", newJString(subscriptionId))
  add(path_568870, "iscsiServerName", newJString(iscsiServerName))
  add(path_568870, "deviceName", newJString(deviceName))
  result = call_568869.call(path_568870, query_568871, nil, nil, nil)

var iscsiServersGet* = Call_IscsiServersGet_568859(name: "iscsiServersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}",
    validator: validate_IscsiServersGet_568860, base: "", url: url_IscsiServersGet_568861,
    schemes: {Scheme.Https})
type
  Call_IscsiServersDelete_568887 = ref object of OpenApiRestCall_567667
proc url_IscsiServersDelete_568889(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersDelete_568888(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the iSCSI server.
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
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568890 = path.getOrDefault("resourceGroupName")
  valid_568890 = validateParameter(valid_568890, JString, required = true,
                                 default = nil)
  if valid_568890 != nil:
    section.add "resourceGroupName", valid_568890
  var valid_568891 = path.getOrDefault("managerName")
  valid_568891 = validateParameter(valid_568891, JString, required = true,
                                 default = nil)
  if valid_568891 != nil:
    section.add "managerName", valid_568891
  var valid_568892 = path.getOrDefault("subscriptionId")
  valid_568892 = validateParameter(valid_568892, JString, required = true,
                                 default = nil)
  if valid_568892 != nil:
    section.add "subscriptionId", valid_568892
  var valid_568893 = path.getOrDefault("iscsiServerName")
  valid_568893 = validateParameter(valid_568893, JString, required = true,
                                 default = nil)
  if valid_568893 != nil:
    section.add "iscsiServerName", valid_568893
  var valid_568894 = path.getOrDefault("deviceName")
  valid_568894 = validateParameter(valid_568894, JString, required = true,
                                 default = nil)
  if valid_568894 != nil:
    section.add "deviceName", valid_568894
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568895 = query.getOrDefault("api-version")
  valid_568895 = validateParameter(valid_568895, JString, required = true,
                                 default = nil)
  if valid_568895 != nil:
    section.add "api-version", valid_568895
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568896: Call_IscsiServersDelete_568887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the iSCSI server.
  ## 
  let valid = call_568896.validator(path, query, header, formData, body)
  let scheme = call_568896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568896.url(scheme.get, call_568896.host, call_568896.base,
                         call_568896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568896, url, valid)

proc call*(call_568897: Call_IscsiServersDelete_568887; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          iscsiServerName: string; deviceName: string): Recallable =
  ## iscsiServersDelete
  ## Deletes the iSCSI server.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568898 = newJObject()
  var query_568899 = newJObject()
  add(path_568898, "resourceGroupName", newJString(resourceGroupName))
  add(query_568899, "api-version", newJString(apiVersion))
  add(path_568898, "managerName", newJString(managerName))
  add(path_568898, "subscriptionId", newJString(subscriptionId))
  add(path_568898, "iscsiServerName", newJString(iscsiServerName))
  add(path_568898, "deviceName", newJString(deviceName))
  result = call_568897.call(path_568898, query_568899, nil, nil, nil)

var iscsiServersDelete* = Call_IscsiServersDelete_568887(
    name: "iscsiServersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}",
    validator: validate_IscsiServersDelete_568888, base: "",
    url: url_IscsiServersDelete_568889, schemes: {Scheme.Https})
type
  Call_IscsiServersBackupNow_568900 = ref object of OpenApiRestCall_567667
proc url_IscsiServersBackupNow_568902(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersBackupNow_568901(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Backup the iSCSI server now.
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
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568903 = path.getOrDefault("resourceGroupName")
  valid_568903 = validateParameter(valid_568903, JString, required = true,
                                 default = nil)
  if valid_568903 != nil:
    section.add "resourceGroupName", valid_568903
  var valid_568904 = path.getOrDefault("managerName")
  valid_568904 = validateParameter(valid_568904, JString, required = true,
                                 default = nil)
  if valid_568904 != nil:
    section.add "managerName", valid_568904
  var valid_568905 = path.getOrDefault("subscriptionId")
  valid_568905 = validateParameter(valid_568905, JString, required = true,
                                 default = nil)
  if valid_568905 != nil:
    section.add "subscriptionId", valid_568905
  var valid_568906 = path.getOrDefault("iscsiServerName")
  valid_568906 = validateParameter(valid_568906, JString, required = true,
                                 default = nil)
  if valid_568906 != nil:
    section.add "iscsiServerName", valid_568906
  var valid_568907 = path.getOrDefault("deviceName")
  valid_568907 = validateParameter(valid_568907, JString, required = true,
                                 default = nil)
  if valid_568907 != nil:
    section.add "deviceName", valid_568907
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568908 = query.getOrDefault("api-version")
  valid_568908 = validateParameter(valid_568908, JString, required = true,
                                 default = nil)
  if valid_568908 != nil:
    section.add "api-version", valid_568908
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568909: Call_IscsiServersBackupNow_568900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup the iSCSI server now.
  ## 
  let valid = call_568909.validator(path, query, header, formData, body)
  let scheme = call_568909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568909.url(scheme.get, call_568909.host, call_568909.base,
                         call_568909.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568909, url, valid)

proc call*(call_568910: Call_IscsiServersBackupNow_568900;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; iscsiServerName: string; deviceName: string): Recallable =
  ## iscsiServersBackupNow
  ## Backup the iSCSI server now.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568911 = newJObject()
  var query_568912 = newJObject()
  add(path_568911, "resourceGroupName", newJString(resourceGroupName))
  add(query_568912, "api-version", newJString(apiVersion))
  add(path_568911, "managerName", newJString(managerName))
  add(path_568911, "subscriptionId", newJString(subscriptionId))
  add(path_568911, "iscsiServerName", newJString(iscsiServerName))
  add(path_568911, "deviceName", newJString(deviceName))
  result = call_568910.call(path_568911, query_568912, nil, nil, nil)

var iscsiServersBackupNow* = Call_IscsiServersBackupNow_568900(
    name: "iscsiServersBackupNow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/backup",
    validator: validate_IscsiServersBackupNow_568901, base: "",
    url: url_IscsiServersBackupNow_568902, schemes: {Scheme.Https})
type
  Call_IscsiDisksListByIscsiServer_568913 = ref object of OpenApiRestCall_567667
proc url_IscsiDisksListByIscsiServer_568915(protocol: Scheme; host: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/disks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksListByIscsiServer_568914(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the disks in a iSCSI server.
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
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568916 = path.getOrDefault("resourceGroupName")
  valid_568916 = validateParameter(valid_568916, JString, required = true,
                                 default = nil)
  if valid_568916 != nil:
    section.add "resourceGroupName", valid_568916
  var valid_568917 = path.getOrDefault("managerName")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = nil)
  if valid_568917 != nil:
    section.add "managerName", valid_568917
  var valid_568918 = path.getOrDefault("subscriptionId")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "subscriptionId", valid_568918
  var valid_568919 = path.getOrDefault("iscsiServerName")
  valid_568919 = validateParameter(valid_568919, JString, required = true,
                                 default = nil)
  if valid_568919 != nil:
    section.add "iscsiServerName", valid_568919
  var valid_568920 = path.getOrDefault("deviceName")
  valid_568920 = validateParameter(valid_568920, JString, required = true,
                                 default = nil)
  if valid_568920 != nil:
    section.add "deviceName", valid_568920
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568921 = query.getOrDefault("api-version")
  valid_568921 = validateParameter(valid_568921, JString, required = true,
                                 default = nil)
  if valid_568921 != nil:
    section.add "api-version", valid_568921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568922: Call_IscsiDisksListByIscsiServer_568913; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the disks in a iSCSI server.
  ## 
  let valid = call_568922.validator(path, query, header, formData, body)
  let scheme = call_568922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568922.url(scheme.get, call_568922.host, call_568922.base,
                         call_568922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568922, url, valid)

proc call*(call_568923: Call_IscsiDisksListByIscsiServer_568913;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; iscsiServerName: string; deviceName: string): Recallable =
  ## iscsiDisksListByIscsiServer
  ## Retrieves all the disks in a iSCSI server.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568924 = newJObject()
  var query_568925 = newJObject()
  add(path_568924, "resourceGroupName", newJString(resourceGroupName))
  add(query_568925, "api-version", newJString(apiVersion))
  add(path_568924, "managerName", newJString(managerName))
  add(path_568924, "subscriptionId", newJString(subscriptionId))
  add(path_568924, "iscsiServerName", newJString(iscsiServerName))
  add(path_568924, "deviceName", newJString(deviceName))
  result = call_568923.call(path_568924, query_568925, nil, nil, nil)

var iscsiDisksListByIscsiServer* = Call_IscsiDisksListByIscsiServer_568913(
    name: "iscsiDisksListByIscsiServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks",
    validator: validate_IscsiDisksListByIscsiServer_568914, base: "",
    url: url_IscsiDisksListByIscsiServer_568915, schemes: {Scheme.Https})
type
  Call_IscsiDisksCreateOrUpdate_568940 = ref object of OpenApiRestCall_567667
proc url_IscsiDisksCreateOrUpdate_568942(protocol: Scheme; host: string;
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
  assert "deviceName" in path, "`deviceName` is a required path parameter"
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  assert "diskName" in path, "`diskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "diskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksCreateOrUpdate_568941(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the iSCSI disk.
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
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   diskName: JString (required)
  ##           : The disk name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568943 = path.getOrDefault("resourceGroupName")
  valid_568943 = validateParameter(valid_568943, JString, required = true,
                                 default = nil)
  if valid_568943 != nil:
    section.add "resourceGroupName", valid_568943
  var valid_568944 = path.getOrDefault("managerName")
  valid_568944 = validateParameter(valid_568944, JString, required = true,
                                 default = nil)
  if valid_568944 != nil:
    section.add "managerName", valid_568944
  var valid_568945 = path.getOrDefault("subscriptionId")
  valid_568945 = validateParameter(valid_568945, JString, required = true,
                                 default = nil)
  if valid_568945 != nil:
    section.add "subscriptionId", valid_568945
  var valid_568946 = path.getOrDefault("iscsiServerName")
  valid_568946 = validateParameter(valid_568946, JString, required = true,
                                 default = nil)
  if valid_568946 != nil:
    section.add "iscsiServerName", valid_568946
  var valid_568947 = path.getOrDefault("diskName")
  valid_568947 = validateParameter(valid_568947, JString, required = true,
                                 default = nil)
  if valid_568947 != nil:
    section.add "diskName", valid_568947
  var valid_568948 = path.getOrDefault("deviceName")
  valid_568948 = validateParameter(valid_568948, JString, required = true,
                                 default = nil)
  if valid_568948 != nil:
    section.add "deviceName", valid_568948
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568949 = query.getOrDefault("api-version")
  valid_568949 = validateParameter(valid_568949, JString, required = true,
                                 default = nil)
  if valid_568949 != nil:
    section.add "api-version", valid_568949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   iscsiDisk: JObject (required)
  ##            : The iSCSI disk.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568951: Call_IscsiDisksCreateOrUpdate_568940; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the iSCSI disk.
  ## 
  let valid = call_568951.validator(path, query, header, formData, body)
  let scheme = call_568951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568951.url(scheme.get, call_568951.host, call_568951.base,
                         call_568951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568951, url, valid)

proc call*(call_568952: Call_IscsiDisksCreateOrUpdate_568940; iscsiDisk: JsonNode;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; iscsiServerName: string; diskName: string;
          deviceName: string): Recallable =
  ## iscsiDisksCreateOrUpdate
  ## Creates or updates the iSCSI disk.
  ##   iscsiDisk: JObject (required)
  ##            : The iSCSI disk.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   diskName: string (required)
  ##           : The disk name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568953 = newJObject()
  var query_568954 = newJObject()
  var body_568955 = newJObject()
  if iscsiDisk != nil:
    body_568955 = iscsiDisk
  add(path_568953, "resourceGroupName", newJString(resourceGroupName))
  add(query_568954, "api-version", newJString(apiVersion))
  add(path_568953, "managerName", newJString(managerName))
  add(path_568953, "subscriptionId", newJString(subscriptionId))
  add(path_568953, "iscsiServerName", newJString(iscsiServerName))
  add(path_568953, "diskName", newJString(diskName))
  add(path_568953, "deviceName", newJString(deviceName))
  result = call_568952.call(path_568953, query_568954, nil, nil, body_568955)

var iscsiDisksCreateOrUpdate* = Call_IscsiDisksCreateOrUpdate_568940(
    name: "iscsiDisksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}",
    validator: validate_IscsiDisksCreateOrUpdate_568941, base: "",
    url: url_IscsiDisksCreateOrUpdate_568942, schemes: {Scheme.Https})
type
  Call_IscsiDisksGet_568926 = ref object of OpenApiRestCall_567667
proc url_IscsiDisksGet_568928(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  assert "diskName" in path, "`diskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "diskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksGet_568927(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified iSCSI disk name.
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
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   diskName: JString (required)
  ##           : The disk name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568929 = path.getOrDefault("resourceGroupName")
  valid_568929 = validateParameter(valid_568929, JString, required = true,
                                 default = nil)
  if valid_568929 != nil:
    section.add "resourceGroupName", valid_568929
  var valid_568930 = path.getOrDefault("managerName")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = nil)
  if valid_568930 != nil:
    section.add "managerName", valid_568930
  var valid_568931 = path.getOrDefault("subscriptionId")
  valid_568931 = validateParameter(valid_568931, JString, required = true,
                                 default = nil)
  if valid_568931 != nil:
    section.add "subscriptionId", valid_568931
  var valid_568932 = path.getOrDefault("iscsiServerName")
  valid_568932 = validateParameter(valid_568932, JString, required = true,
                                 default = nil)
  if valid_568932 != nil:
    section.add "iscsiServerName", valid_568932
  var valid_568933 = path.getOrDefault("diskName")
  valid_568933 = validateParameter(valid_568933, JString, required = true,
                                 default = nil)
  if valid_568933 != nil:
    section.add "diskName", valid_568933
  var valid_568934 = path.getOrDefault("deviceName")
  valid_568934 = validateParameter(valid_568934, JString, required = true,
                                 default = nil)
  if valid_568934 != nil:
    section.add "deviceName", valid_568934
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568935 = query.getOrDefault("api-version")
  valid_568935 = validateParameter(valid_568935, JString, required = true,
                                 default = nil)
  if valid_568935 != nil:
    section.add "api-version", valid_568935
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568936: Call_IscsiDisksGet_568926; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified iSCSI disk name.
  ## 
  let valid = call_568936.validator(path, query, header, formData, body)
  let scheme = call_568936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568936.url(scheme.get, call_568936.host, call_568936.base,
                         call_568936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568936, url, valid)

proc call*(call_568937: Call_IscsiDisksGet_568926; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          iscsiServerName: string; diskName: string; deviceName: string): Recallable =
  ## iscsiDisksGet
  ## Returns the properties of the specified iSCSI disk name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   diskName: string (required)
  ##           : The disk name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568938 = newJObject()
  var query_568939 = newJObject()
  add(path_568938, "resourceGroupName", newJString(resourceGroupName))
  add(query_568939, "api-version", newJString(apiVersion))
  add(path_568938, "managerName", newJString(managerName))
  add(path_568938, "subscriptionId", newJString(subscriptionId))
  add(path_568938, "iscsiServerName", newJString(iscsiServerName))
  add(path_568938, "diskName", newJString(diskName))
  add(path_568938, "deviceName", newJString(deviceName))
  result = call_568937.call(path_568938, query_568939, nil, nil, nil)

var iscsiDisksGet* = Call_IscsiDisksGet_568926(name: "iscsiDisksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}",
    validator: validate_IscsiDisksGet_568927, base: "", url: url_IscsiDisksGet_568928,
    schemes: {Scheme.Https})
type
  Call_IscsiDisksDelete_568956 = ref object of OpenApiRestCall_567667
proc url_IscsiDisksDelete_568958(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  assert "diskName" in path, "`diskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "diskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksDelete_568957(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the iSCSI disk.
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
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   diskName: JString (required)
  ##           : The disk name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568959 = path.getOrDefault("resourceGroupName")
  valid_568959 = validateParameter(valid_568959, JString, required = true,
                                 default = nil)
  if valid_568959 != nil:
    section.add "resourceGroupName", valid_568959
  var valid_568960 = path.getOrDefault("managerName")
  valid_568960 = validateParameter(valid_568960, JString, required = true,
                                 default = nil)
  if valid_568960 != nil:
    section.add "managerName", valid_568960
  var valid_568961 = path.getOrDefault("subscriptionId")
  valid_568961 = validateParameter(valid_568961, JString, required = true,
                                 default = nil)
  if valid_568961 != nil:
    section.add "subscriptionId", valid_568961
  var valid_568962 = path.getOrDefault("iscsiServerName")
  valid_568962 = validateParameter(valid_568962, JString, required = true,
                                 default = nil)
  if valid_568962 != nil:
    section.add "iscsiServerName", valid_568962
  var valid_568963 = path.getOrDefault("diskName")
  valid_568963 = validateParameter(valid_568963, JString, required = true,
                                 default = nil)
  if valid_568963 != nil:
    section.add "diskName", valid_568963
  var valid_568964 = path.getOrDefault("deviceName")
  valid_568964 = validateParameter(valid_568964, JString, required = true,
                                 default = nil)
  if valid_568964 != nil:
    section.add "deviceName", valid_568964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568965 = query.getOrDefault("api-version")
  valid_568965 = validateParameter(valid_568965, JString, required = true,
                                 default = nil)
  if valid_568965 != nil:
    section.add "api-version", valid_568965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568966: Call_IscsiDisksDelete_568956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the iSCSI disk.
  ## 
  let valid = call_568966.validator(path, query, header, formData, body)
  let scheme = call_568966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568966.url(scheme.get, call_568966.host, call_568966.base,
                         call_568966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568966, url, valid)

proc call*(call_568967: Call_IscsiDisksDelete_568956; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          iscsiServerName: string; diskName: string; deviceName: string): Recallable =
  ## iscsiDisksDelete
  ## Deletes the iSCSI disk.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   diskName: string (required)
  ##           : The disk name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568968 = newJObject()
  var query_568969 = newJObject()
  add(path_568968, "resourceGroupName", newJString(resourceGroupName))
  add(query_568969, "api-version", newJString(apiVersion))
  add(path_568968, "managerName", newJString(managerName))
  add(path_568968, "subscriptionId", newJString(subscriptionId))
  add(path_568968, "iscsiServerName", newJString(iscsiServerName))
  add(path_568968, "diskName", newJString(diskName))
  add(path_568968, "deviceName", newJString(deviceName))
  result = call_568967.call(path_568968, query_568969, nil, nil, nil)

var iscsiDisksDelete* = Call_IscsiDisksDelete_568956(name: "iscsiDisksDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}",
    validator: validate_IscsiDisksDelete_568957, base: "",
    url: url_IscsiDisksDelete_568958, schemes: {Scheme.Https})
type
  Call_IscsiDisksListMetrics_568970 = ref object of OpenApiRestCall_567667
proc url_IscsiDisksListMetrics_568972(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  assert "diskName" in path, "`diskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "diskName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksListMetrics_568971(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the iSCSI disk metrics
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
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   diskName: JString (required)
  ##           : The iSCSI disk name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568973 = path.getOrDefault("resourceGroupName")
  valid_568973 = validateParameter(valid_568973, JString, required = true,
                                 default = nil)
  if valid_568973 != nil:
    section.add "resourceGroupName", valid_568973
  var valid_568974 = path.getOrDefault("managerName")
  valid_568974 = validateParameter(valid_568974, JString, required = true,
                                 default = nil)
  if valid_568974 != nil:
    section.add "managerName", valid_568974
  var valid_568975 = path.getOrDefault("subscriptionId")
  valid_568975 = validateParameter(valid_568975, JString, required = true,
                                 default = nil)
  if valid_568975 != nil:
    section.add "subscriptionId", valid_568975
  var valid_568976 = path.getOrDefault("iscsiServerName")
  valid_568976 = validateParameter(valid_568976, JString, required = true,
                                 default = nil)
  if valid_568976 != nil:
    section.add "iscsiServerName", valid_568976
  var valid_568977 = path.getOrDefault("diskName")
  valid_568977 = validateParameter(valid_568977, JString, required = true,
                                 default = nil)
  if valid_568977 != nil:
    section.add "diskName", valid_568977
  var valid_568978 = path.getOrDefault("deviceName")
  valid_568978 = validateParameter(valid_568978, JString, required = true,
                                 default = nil)
  if valid_568978 != nil:
    section.add "deviceName", valid_568978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568979 = query.getOrDefault("api-version")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "api-version", valid_568979
  var valid_568980 = query.getOrDefault("$filter")
  valid_568980 = validateParameter(valid_568980, JString, required = false,
                                 default = nil)
  if valid_568980 != nil:
    section.add "$filter", valid_568980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568981: Call_IscsiDisksListMetrics_568970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the iSCSI disk metrics
  ## 
  let valid = call_568981.validator(path, query, header, formData, body)
  let scheme = call_568981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568981.url(scheme.get, call_568981.host, call_568981.base,
                         call_568981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568981, url, valid)

proc call*(call_568982: Call_IscsiDisksListMetrics_568970;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; iscsiServerName: string; diskName: string;
          deviceName: string; Filter: string = ""): Recallable =
  ## iscsiDisksListMetrics
  ## Gets the iSCSI disk metrics
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   diskName: string (required)
  ##           : The iSCSI disk name.
  ##   Filter: string
  ##         : OData Filter options
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568983 = newJObject()
  var query_568984 = newJObject()
  add(path_568983, "resourceGroupName", newJString(resourceGroupName))
  add(query_568984, "api-version", newJString(apiVersion))
  add(path_568983, "managerName", newJString(managerName))
  add(path_568983, "subscriptionId", newJString(subscriptionId))
  add(path_568983, "iscsiServerName", newJString(iscsiServerName))
  add(path_568983, "diskName", newJString(diskName))
  add(query_568984, "$filter", newJString(Filter))
  add(path_568983, "deviceName", newJString(deviceName))
  result = call_568982.call(path_568983, query_568984, nil, nil, nil)

var iscsiDisksListMetrics* = Call_IscsiDisksListMetrics_568970(
    name: "iscsiDisksListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}/metrics",
    validator: validate_IscsiDisksListMetrics_568971, base: "",
    url: url_IscsiDisksListMetrics_568972, schemes: {Scheme.Https})
type
  Call_IscsiDisksListMetricDefinition_568985 = ref object of OpenApiRestCall_567667
proc url_IscsiDisksListMetricDefinition_568987(protocol: Scheme; host: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  assert "diskName" in path, "`diskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "diskName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiDisksListMetricDefinition_568986(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions for all metric aggregated at the iSCSI disk.
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
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   diskName: JString (required)
  ##           : The iSCSI disk name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568988 = path.getOrDefault("resourceGroupName")
  valid_568988 = validateParameter(valid_568988, JString, required = true,
                                 default = nil)
  if valid_568988 != nil:
    section.add "resourceGroupName", valid_568988
  var valid_568989 = path.getOrDefault("managerName")
  valid_568989 = validateParameter(valid_568989, JString, required = true,
                                 default = nil)
  if valid_568989 != nil:
    section.add "managerName", valid_568989
  var valid_568990 = path.getOrDefault("subscriptionId")
  valid_568990 = validateParameter(valid_568990, JString, required = true,
                                 default = nil)
  if valid_568990 != nil:
    section.add "subscriptionId", valid_568990
  var valid_568991 = path.getOrDefault("iscsiServerName")
  valid_568991 = validateParameter(valid_568991, JString, required = true,
                                 default = nil)
  if valid_568991 != nil:
    section.add "iscsiServerName", valid_568991
  var valid_568992 = path.getOrDefault("diskName")
  valid_568992 = validateParameter(valid_568992, JString, required = true,
                                 default = nil)
  if valid_568992 != nil:
    section.add "diskName", valid_568992
  var valid_568993 = path.getOrDefault("deviceName")
  valid_568993 = validateParameter(valid_568993, JString, required = true,
                                 default = nil)
  if valid_568993 != nil:
    section.add "deviceName", valid_568993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568994 = query.getOrDefault("api-version")
  valid_568994 = validateParameter(valid_568994, JString, required = true,
                                 default = nil)
  if valid_568994 != nil:
    section.add "api-version", valid_568994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568995: Call_IscsiDisksListMetricDefinition_568985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definitions for all metric aggregated at the iSCSI disk.
  ## 
  let valid = call_568995.validator(path, query, header, formData, body)
  let scheme = call_568995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568995.url(scheme.get, call_568995.host, call_568995.base,
                         call_568995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568995, url, valid)

proc call*(call_568996: Call_IscsiDisksListMetricDefinition_568985;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; iscsiServerName: string; diskName: string;
          deviceName: string): Recallable =
  ## iscsiDisksListMetricDefinition
  ## Retrieves metric definitions for all metric aggregated at the iSCSI disk.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   diskName: string (required)
  ##           : The iSCSI disk name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_568997 = newJObject()
  var query_568998 = newJObject()
  add(path_568997, "resourceGroupName", newJString(resourceGroupName))
  add(query_568998, "api-version", newJString(apiVersion))
  add(path_568997, "managerName", newJString(managerName))
  add(path_568997, "subscriptionId", newJString(subscriptionId))
  add(path_568997, "iscsiServerName", newJString(iscsiServerName))
  add(path_568997, "diskName", newJString(diskName))
  add(path_568997, "deviceName", newJString(deviceName))
  result = call_568996.call(path_568997, query_568998, nil, nil, nil)

var iscsiDisksListMetricDefinition* = Call_IscsiDisksListMetricDefinition_568985(
    name: "iscsiDisksListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}/metricsDefinitions",
    validator: validate_IscsiDisksListMetricDefinition_568986, base: "",
    url: url_IscsiDisksListMetricDefinition_568987, schemes: {Scheme.Https})
type
  Call_IscsiServersListMetrics_568999 = ref object of OpenApiRestCall_567667
proc url_IscsiServersListMetrics_569001(protocol: Scheme; host: string; base: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersListMetrics_569000(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the iSCSI server metrics
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
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569002 = path.getOrDefault("resourceGroupName")
  valid_569002 = validateParameter(valid_569002, JString, required = true,
                                 default = nil)
  if valid_569002 != nil:
    section.add "resourceGroupName", valid_569002
  var valid_569003 = path.getOrDefault("managerName")
  valid_569003 = validateParameter(valid_569003, JString, required = true,
                                 default = nil)
  if valid_569003 != nil:
    section.add "managerName", valid_569003
  var valid_569004 = path.getOrDefault("subscriptionId")
  valid_569004 = validateParameter(valid_569004, JString, required = true,
                                 default = nil)
  if valid_569004 != nil:
    section.add "subscriptionId", valid_569004
  var valid_569005 = path.getOrDefault("iscsiServerName")
  valid_569005 = validateParameter(valid_569005, JString, required = true,
                                 default = nil)
  if valid_569005 != nil:
    section.add "iscsiServerName", valid_569005
  var valid_569006 = path.getOrDefault("deviceName")
  valid_569006 = validateParameter(valid_569006, JString, required = true,
                                 default = nil)
  if valid_569006 != nil:
    section.add "deviceName", valid_569006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569007 = query.getOrDefault("api-version")
  valid_569007 = validateParameter(valid_569007, JString, required = true,
                                 default = nil)
  if valid_569007 != nil:
    section.add "api-version", valid_569007
  var valid_569008 = query.getOrDefault("$filter")
  valid_569008 = validateParameter(valid_569008, JString, required = false,
                                 default = nil)
  if valid_569008 != nil:
    section.add "$filter", valid_569008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569009: Call_IscsiServersListMetrics_568999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the iSCSI server metrics
  ## 
  let valid = call_569009.validator(path, query, header, formData, body)
  let scheme = call_569009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569009.url(scheme.get, call_569009.host, call_569009.base,
                         call_569009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569009, url, valid)

proc call*(call_569010: Call_IscsiServersListMetrics_568999;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; iscsiServerName: string; deviceName: string;
          Filter: string = ""): Recallable =
  ## iscsiServersListMetrics
  ## Gets the iSCSI server metrics
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   Filter: string
  ##         : OData Filter options
  ##   deviceName: string (required)
  ##             : The device name.
  var path_569011 = newJObject()
  var query_569012 = newJObject()
  add(path_569011, "resourceGroupName", newJString(resourceGroupName))
  add(query_569012, "api-version", newJString(apiVersion))
  add(path_569011, "managerName", newJString(managerName))
  add(path_569011, "subscriptionId", newJString(subscriptionId))
  add(path_569011, "iscsiServerName", newJString(iscsiServerName))
  add(query_569012, "$filter", newJString(Filter))
  add(path_569011, "deviceName", newJString(deviceName))
  result = call_569010.call(path_569011, query_569012, nil, nil, nil)

var iscsiServersListMetrics* = Call_IscsiServersListMetrics_568999(
    name: "iscsiServersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/metrics",
    validator: validate_IscsiServersListMetrics_569000, base: "",
    url: url_IscsiServersListMetrics_569001, schemes: {Scheme.Https})
type
  Call_IscsiServersListMetricDefinition_569013 = ref object of OpenApiRestCall_567667
proc url_IscsiServersListMetricDefinition_569015(protocol: Scheme; host: string;
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
  assert "iscsiServerName" in path, "`iscsiServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceName"),
               (kind: ConstantSegment, value: "/iscsiservers/"),
               (kind: VariableSegment, value: "iscsiServerName"),
               (kind: ConstantSegment, value: "/metricsDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersListMetricDefinition_569014(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definitions for all metrics aggregated at iSCSI server.
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
  ##   iscsiServerName: JString (required)
  ##                  : The iSCSI server name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569016 = path.getOrDefault("resourceGroupName")
  valid_569016 = validateParameter(valid_569016, JString, required = true,
                                 default = nil)
  if valid_569016 != nil:
    section.add "resourceGroupName", valid_569016
  var valid_569017 = path.getOrDefault("managerName")
  valid_569017 = validateParameter(valid_569017, JString, required = true,
                                 default = nil)
  if valid_569017 != nil:
    section.add "managerName", valid_569017
  var valid_569018 = path.getOrDefault("subscriptionId")
  valid_569018 = validateParameter(valid_569018, JString, required = true,
                                 default = nil)
  if valid_569018 != nil:
    section.add "subscriptionId", valid_569018
  var valid_569019 = path.getOrDefault("iscsiServerName")
  valid_569019 = validateParameter(valid_569019, JString, required = true,
                                 default = nil)
  if valid_569019 != nil:
    section.add "iscsiServerName", valid_569019
  var valid_569020 = path.getOrDefault("deviceName")
  valid_569020 = validateParameter(valid_569020, JString, required = true,
                                 default = nil)
  if valid_569020 != nil:
    section.add "deviceName", valid_569020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569021 = query.getOrDefault("api-version")
  valid_569021 = validateParameter(valid_569021, JString, required = true,
                                 default = nil)
  if valid_569021 != nil:
    section.add "api-version", valid_569021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569022: Call_IscsiServersListMetricDefinition_569013;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for all metrics aggregated at iSCSI server.
  ## 
  let valid = call_569022.validator(path, query, header, formData, body)
  let scheme = call_569022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569022.url(scheme.get, call_569022.host, call_569022.base,
                         call_569022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569022, url, valid)

proc call*(call_569023: Call_IscsiServersListMetricDefinition_569013;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; iscsiServerName: string; deviceName: string): Recallable =
  ## iscsiServersListMetricDefinition
  ## Retrieves metric definitions for all metrics aggregated at iSCSI server.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   iscsiServerName: string (required)
  ##                  : The iSCSI server name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_569024 = newJObject()
  var query_569025 = newJObject()
  add(path_569024, "resourceGroupName", newJString(resourceGroupName))
  add(query_569025, "api-version", newJString(apiVersion))
  add(path_569024, "managerName", newJString(managerName))
  add(path_569024, "subscriptionId", newJString(subscriptionId))
  add(path_569024, "iscsiServerName", newJString(iscsiServerName))
  add(path_569024, "deviceName", newJString(deviceName))
  result = call_569023.call(path_569024, query_569025, nil, nil, nil)

var iscsiServersListMetricDefinition* = Call_IscsiServersListMetricDefinition_569013(
    name: "iscsiServersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/metricsDefinitions",
    validator: validate_IscsiServersListMetricDefinition_569014, base: "",
    url: url_IscsiServersListMetricDefinition_569015, schemes: {Scheme.Https})
type
  Call_JobsListByDevice_569026 = ref object of OpenApiRestCall_567667
proc url_JobsListByDevice_569028(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByDevice_569027(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves all the jobs in a device.
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569029 = path.getOrDefault("resourceGroupName")
  valid_569029 = validateParameter(valid_569029, JString, required = true,
                                 default = nil)
  if valid_569029 != nil:
    section.add "resourceGroupName", valid_569029
  var valid_569030 = path.getOrDefault("managerName")
  valid_569030 = validateParameter(valid_569030, JString, required = true,
                                 default = nil)
  if valid_569030 != nil:
    section.add "managerName", valid_569030
  var valid_569031 = path.getOrDefault("subscriptionId")
  valid_569031 = validateParameter(valid_569031, JString, required = true,
                                 default = nil)
  if valid_569031 != nil:
    section.add "subscriptionId", valid_569031
  var valid_569032 = path.getOrDefault("deviceName")
  valid_569032 = validateParameter(valid_569032, JString, required = true,
                                 default = nil)
  if valid_569032 != nil:
    section.add "deviceName", valid_569032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569033 = query.getOrDefault("api-version")
  valid_569033 = validateParameter(valid_569033, JString, required = true,
                                 default = nil)
  if valid_569033 != nil:
    section.add "api-version", valid_569033
  var valid_569034 = query.getOrDefault("$filter")
  valid_569034 = validateParameter(valid_569034, JString, required = false,
                                 default = nil)
  if valid_569034 != nil:
    section.add "$filter", valid_569034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569035: Call_JobsListByDevice_569026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the jobs in a device.
  ## 
  let valid = call_569035.validator(path, query, header, formData, body)
  let scheme = call_569035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569035.url(scheme.get, call_569035.host, call_569035.base,
                         call_569035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569035, url, valid)

proc call*(call_569036: Call_JobsListByDevice_569026; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          deviceName: string; Filter: string = ""): Recallable =
  ## jobsListByDevice
  ## Retrieves all the jobs in a device.
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
  ##             : The device name.
  var path_569037 = newJObject()
  var query_569038 = newJObject()
  add(path_569037, "resourceGroupName", newJString(resourceGroupName))
  add(query_569038, "api-version", newJString(apiVersion))
  add(path_569037, "managerName", newJString(managerName))
  add(path_569037, "subscriptionId", newJString(subscriptionId))
  add(query_569038, "$filter", newJString(Filter))
  add(path_569037, "deviceName", newJString(deviceName))
  result = call_569036.call(path_569037, query_569038, nil, nil, nil)

var jobsListByDevice* = Call_JobsListByDevice_569026(name: "jobsListByDevice",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs",
    validator: validate_JobsListByDevice_569027, base: "",
    url: url_JobsListByDevice_569028, schemes: {Scheme.Https})
type
  Call_JobsGet_569039 = ref object of OpenApiRestCall_567667
proc url_JobsGet_569041(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_569040(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified job name.
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
  ##          : The job name.
  ##   deviceName: JString (required)
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569042 = path.getOrDefault("resourceGroupName")
  valid_569042 = validateParameter(valid_569042, JString, required = true,
                                 default = nil)
  if valid_569042 != nil:
    section.add "resourceGroupName", valid_569042
  var valid_569043 = path.getOrDefault("managerName")
  valid_569043 = validateParameter(valid_569043, JString, required = true,
                                 default = nil)
  if valid_569043 != nil:
    section.add "managerName", valid_569043
  var valid_569044 = path.getOrDefault("subscriptionId")
  valid_569044 = validateParameter(valid_569044, JString, required = true,
                                 default = nil)
  if valid_569044 != nil:
    section.add "subscriptionId", valid_569044
  var valid_569045 = path.getOrDefault("jobName")
  valid_569045 = validateParameter(valid_569045, JString, required = true,
                                 default = nil)
  if valid_569045 != nil:
    section.add "jobName", valid_569045
  var valid_569046 = path.getOrDefault("deviceName")
  valid_569046 = validateParameter(valid_569046, JString, required = true,
                                 default = nil)
  if valid_569046 != nil:
    section.add "deviceName", valid_569046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569047 = query.getOrDefault("api-version")
  valid_569047 = validateParameter(valid_569047, JString, required = true,
                                 default = nil)
  if valid_569047 != nil:
    section.add "api-version", valid_569047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569048: Call_JobsGet_569039; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified job name.
  ## 
  let valid = call_569048.validator(path, query, header, formData, body)
  let scheme = call_569048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569048.url(scheme.get, call_569048.host, call_569048.base,
                         call_569048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569048, url, valid)

proc call*(call_569049: Call_JobsGet_569039; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          jobName: string; deviceName: string): Recallable =
  ## jobsGet
  ## Returns the properties of the specified job name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   jobName: string (required)
  ##          : The job name.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_569050 = newJObject()
  var query_569051 = newJObject()
  add(path_569050, "resourceGroupName", newJString(resourceGroupName))
  add(query_569051, "api-version", newJString(apiVersion))
  add(path_569050, "managerName", newJString(managerName))
  add(path_569050, "subscriptionId", newJString(subscriptionId))
  add(path_569050, "jobName", newJString(jobName))
  add(path_569050, "deviceName", newJString(deviceName))
  result = call_569049.call(path_569050, query_569051, nil, nil, nil)

var jobsGet* = Call_JobsGet_569039(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs/{jobName}",
                                validator: validate_JobsGet_569040, base: "",
                                url: url_JobsGet_569041, schemes: {Scheme.Https})
type
  Call_DevicesListMetrics_569052 = ref object of OpenApiRestCall_567667
proc url_DevicesListMetrics_569054(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesListMetrics_569053(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves the device metrics.
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
  ##             : The name of the appliance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569055 = path.getOrDefault("resourceGroupName")
  valid_569055 = validateParameter(valid_569055, JString, required = true,
                                 default = nil)
  if valid_569055 != nil:
    section.add "resourceGroupName", valid_569055
  var valid_569056 = path.getOrDefault("managerName")
  valid_569056 = validateParameter(valid_569056, JString, required = true,
                                 default = nil)
  if valid_569056 != nil:
    section.add "managerName", valid_569056
  var valid_569057 = path.getOrDefault("subscriptionId")
  valid_569057 = validateParameter(valid_569057, JString, required = true,
                                 default = nil)
  if valid_569057 != nil:
    section.add "subscriptionId", valid_569057
  var valid_569058 = path.getOrDefault("deviceName")
  valid_569058 = validateParameter(valid_569058, JString, required = true,
                                 default = nil)
  if valid_569058 != nil:
    section.add "deviceName", valid_569058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569059 = query.getOrDefault("api-version")
  valid_569059 = validateParameter(valid_569059, JString, required = true,
                                 default = nil)
  if valid_569059 != nil:
    section.add "api-version", valid_569059
  var valid_569060 = query.getOrDefault("$filter")
  valid_569060 = validateParameter(valid_569060, JString, required = false,
                                 default = nil)
  if valid_569060 != nil:
    section.add "$filter", valid_569060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569061: Call_DevicesListMetrics_569052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the device metrics.
  ## 
  let valid = call_569061.validator(path, query, header, formData, body)
  let scheme = call_569061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569061.url(scheme.get, call_569061.host, call_569061.base,
                         call_569061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569061, url, valid)

proc call*(call_569062: Call_DevicesListMetrics_569052; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          deviceName: string; Filter: string = ""): Recallable =
  ## devicesListMetrics
  ## Retrieves the device metrics.
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
  ##             : The name of the appliance.
  var path_569063 = newJObject()
  var query_569064 = newJObject()
  add(path_569063, "resourceGroupName", newJString(resourceGroupName))
  add(query_569064, "api-version", newJString(apiVersion))
  add(path_569063, "managerName", newJString(managerName))
  add(path_569063, "subscriptionId", newJString(subscriptionId))
  add(query_569064, "$filter", newJString(Filter))
  add(path_569063, "deviceName", newJString(deviceName))
  result = call_569062.call(path_569063, query_569064, nil, nil, nil)

var devicesListMetrics* = Call_DevicesListMetrics_569052(
    name: "devicesListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/metrics",
    validator: validate_DevicesListMetrics_569053, base: "",
    url: url_DevicesListMetrics_569054, schemes: {Scheme.Https})
type
  Call_DevicesListMetricDefinition_569065 = ref object of OpenApiRestCall_567667
proc url_DevicesListMetricDefinition_569067(protocol: Scheme; host: string;
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

proc validate_DevicesListMetricDefinition_569066(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definition of all metrics aggregated at device.
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
  ##             : The name of the appliance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569068 = path.getOrDefault("resourceGroupName")
  valid_569068 = validateParameter(valid_569068, JString, required = true,
                                 default = nil)
  if valid_569068 != nil:
    section.add "resourceGroupName", valid_569068
  var valid_569069 = path.getOrDefault("managerName")
  valid_569069 = validateParameter(valid_569069, JString, required = true,
                                 default = nil)
  if valid_569069 != nil:
    section.add "managerName", valid_569069
  var valid_569070 = path.getOrDefault("subscriptionId")
  valid_569070 = validateParameter(valid_569070, JString, required = true,
                                 default = nil)
  if valid_569070 != nil:
    section.add "subscriptionId", valid_569070
  var valid_569071 = path.getOrDefault("deviceName")
  valid_569071 = validateParameter(valid_569071, JString, required = true,
                                 default = nil)
  if valid_569071 != nil:
    section.add "deviceName", valid_569071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569072 = query.getOrDefault("api-version")
  valid_569072 = validateParameter(valid_569072, JString, required = true,
                                 default = nil)
  if valid_569072 != nil:
    section.add "api-version", valid_569072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569073: Call_DevicesListMetricDefinition_569065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definition of all metrics aggregated at device.
  ## 
  let valid = call_569073.validator(path, query, header, formData, body)
  let scheme = call_569073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569073.url(scheme.get, call_569073.host, call_569073.base,
                         call_569073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569073, url, valid)

proc call*(call_569074: Call_DevicesListMetricDefinition_569065;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesListMetricDefinition
  ## Retrieves metric definition of all metrics aggregated at device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The name of the appliance.
  var path_569075 = newJObject()
  var query_569076 = newJObject()
  add(path_569075, "resourceGroupName", newJString(resourceGroupName))
  add(query_569076, "api-version", newJString(apiVersion))
  add(path_569075, "managerName", newJString(managerName))
  add(path_569075, "subscriptionId", newJString(subscriptionId))
  add(path_569075, "deviceName", newJString(deviceName))
  result = call_569074.call(path_569075, query_569076, nil, nil, nil)

var devicesListMetricDefinition* = Call_DevicesListMetricDefinition_569065(
    name: "devicesListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/metricsDefinitions",
    validator: validate_DevicesListMetricDefinition_569066, base: "",
    url: url_DevicesListMetricDefinition_569067, schemes: {Scheme.Https})
type
  Call_DevicesGetNetworkSettings_569077 = ref object of OpenApiRestCall_567667
proc url_DevicesGetNetworkSettings_569079(protocol: Scheme; host: string;
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

proc validate_DevicesGetNetworkSettings_569078(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the network settings of the specified device name.
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569080 = path.getOrDefault("resourceGroupName")
  valid_569080 = validateParameter(valid_569080, JString, required = true,
                                 default = nil)
  if valid_569080 != nil:
    section.add "resourceGroupName", valid_569080
  var valid_569081 = path.getOrDefault("managerName")
  valid_569081 = validateParameter(valid_569081, JString, required = true,
                                 default = nil)
  if valid_569081 != nil:
    section.add "managerName", valid_569081
  var valid_569082 = path.getOrDefault("subscriptionId")
  valid_569082 = validateParameter(valid_569082, JString, required = true,
                                 default = nil)
  if valid_569082 != nil:
    section.add "subscriptionId", valid_569082
  var valid_569083 = path.getOrDefault("deviceName")
  valid_569083 = validateParameter(valid_569083, JString, required = true,
                                 default = nil)
  if valid_569083 != nil:
    section.add "deviceName", valid_569083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569084 = query.getOrDefault("api-version")
  valid_569084 = validateParameter(valid_569084, JString, required = true,
                                 default = nil)
  if valid_569084 != nil:
    section.add "api-version", valid_569084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569085: Call_DevicesGetNetworkSettings_569077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the network settings of the specified device name.
  ## 
  let valid = call_569085.validator(path, query, header, formData, body)
  let scheme = call_569085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569085.url(scheme.get, call_569085.host, call_569085.base,
                         call_569085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569085, url, valid)

proc call*(call_569086: Call_DevicesGetNetworkSettings_569077;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesGetNetworkSettings
  ## Returns the network settings of the specified device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_569087 = newJObject()
  var query_569088 = newJObject()
  add(path_569087, "resourceGroupName", newJString(resourceGroupName))
  add(query_569088, "api-version", newJString(apiVersion))
  add(path_569087, "managerName", newJString(managerName))
  add(path_569087, "subscriptionId", newJString(subscriptionId))
  add(path_569087, "deviceName", newJString(deviceName))
  result = call_569086.call(path_569087, query_569088, nil, nil, nil)

var devicesGetNetworkSettings* = Call_DevicesGetNetworkSettings_569077(
    name: "devicesGetNetworkSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/networkSettings/default",
    validator: validate_DevicesGetNetworkSettings_569078, base: "",
    url: url_DevicesGetNetworkSettings_569079, schemes: {Scheme.Https})
type
  Call_DevicesScanForUpdates_569089 = ref object of OpenApiRestCall_567667
proc url_DevicesScanForUpdates_569091(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesScanForUpdates_569090(path: JsonNode; query: JsonNode;
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569092 = path.getOrDefault("resourceGroupName")
  valid_569092 = validateParameter(valid_569092, JString, required = true,
                                 default = nil)
  if valid_569092 != nil:
    section.add "resourceGroupName", valid_569092
  var valid_569093 = path.getOrDefault("managerName")
  valid_569093 = validateParameter(valid_569093, JString, required = true,
                                 default = nil)
  if valid_569093 != nil:
    section.add "managerName", valid_569093
  var valid_569094 = path.getOrDefault("subscriptionId")
  valid_569094 = validateParameter(valid_569094, JString, required = true,
                                 default = nil)
  if valid_569094 != nil:
    section.add "subscriptionId", valid_569094
  var valid_569095 = path.getOrDefault("deviceName")
  valid_569095 = validateParameter(valid_569095, JString, required = true,
                                 default = nil)
  if valid_569095 != nil:
    section.add "deviceName", valid_569095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569096 = query.getOrDefault("api-version")
  valid_569096 = validateParameter(valid_569096, JString, required = true,
                                 default = nil)
  if valid_569096 != nil:
    section.add "api-version", valid_569096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569097: Call_DevicesScanForUpdates_569089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scans for updates on the device.
  ## 
  let valid = call_569097.validator(path, query, header, formData, body)
  let scheme = call_569097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569097.url(scheme.get, call_569097.host, call_569097.base,
                         call_569097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569097, url, valid)

proc call*(call_569098: Call_DevicesScanForUpdates_569089;
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
  ##             : The device name.
  var path_569099 = newJObject()
  var query_569100 = newJObject()
  add(path_569099, "resourceGroupName", newJString(resourceGroupName))
  add(query_569100, "api-version", newJString(apiVersion))
  add(path_569099, "managerName", newJString(managerName))
  add(path_569099, "subscriptionId", newJString(subscriptionId))
  add(path_569099, "deviceName", newJString(deviceName))
  result = call_569098.call(path_569099, query_569100, nil, nil, nil)

var devicesScanForUpdates* = Call_DevicesScanForUpdates_569089(
    name: "devicesScanForUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/scanForUpdates",
    validator: validate_DevicesScanForUpdates_569090, base: "",
    url: url_DevicesScanForUpdates_569091, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdateSecuritySettings_569101 = ref object of OpenApiRestCall_567667
proc url_DevicesCreateOrUpdateSecuritySettings_569103(protocol: Scheme;
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
        value: "/securitySettings/default/update")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesCreateOrUpdateSecuritySettings_569102(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the security settings.
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
  ##             : The device name.
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
  var valid_569106 = path.getOrDefault("subscriptionId")
  valid_569106 = validateParameter(valid_569106, JString, required = true,
                                 default = nil)
  if valid_569106 != nil:
    section.add "subscriptionId", valid_569106
  var valid_569107 = path.getOrDefault("deviceName")
  valid_569107 = validateParameter(valid_569107, JString, required = true,
                                 default = nil)
  if valid_569107 != nil:
    section.add "deviceName", valid_569107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569108 = query.getOrDefault("api-version")
  valid_569108 = validateParameter(valid_569108, JString, required = true,
                                 default = nil)
  if valid_569108 != nil:
    section.add "api-version", valid_569108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   securitySettings: JObject (required)
  ##                   : The security settings.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569110: Call_DevicesCreateOrUpdateSecuritySettings_569101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the security settings.
  ## 
  let valid = call_569110.validator(path, query, header, formData, body)
  let scheme = call_569110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569110.url(scheme.get, call_569110.host, call_569110.base,
                         call_569110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569110, url, valid)

proc call*(call_569111: Call_DevicesCreateOrUpdateSecuritySettings_569101;
          resourceGroupName: string; apiVersion: string; managerName: string;
          securitySettings: JsonNode; subscriptionId: string; deviceName: string): Recallable =
  ## devicesCreateOrUpdateSecuritySettings
  ## Creates or updates the security settings.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   securitySettings: JObject (required)
  ##                   : The security settings.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_569112 = newJObject()
  var query_569113 = newJObject()
  var body_569114 = newJObject()
  add(path_569112, "resourceGroupName", newJString(resourceGroupName))
  add(query_569113, "api-version", newJString(apiVersion))
  add(path_569112, "managerName", newJString(managerName))
  if securitySettings != nil:
    body_569114 = securitySettings
  add(path_569112, "subscriptionId", newJString(subscriptionId))
  add(path_569112, "deviceName", newJString(deviceName))
  result = call_569111.call(path_569112, query_569113, nil, nil, body_569114)

var devicesCreateOrUpdateSecuritySettings* = Call_DevicesCreateOrUpdateSecuritySettings_569101(
    name: "devicesCreateOrUpdateSecuritySettings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/securitySettings/default/update",
    validator: validate_DevicesCreateOrUpdateSecuritySettings_569102, base: "",
    url: url_DevicesCreateOrUpdateSecuritySettings_569103, schemes: {Scheme.Https})
type
  Call_AlertsSendTestEmail_569115 = ref object of OpenApiRestCall_567667
proc url_AlertsSendTestEmail_569117(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsSendTestEmail_569116(path: JsonNode; query: JsonNode;
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
  ##             : The device name.
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
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : The send test alert email request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569124: Call_AlertsSendTestEmail_569115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a test alert email.
  ## 
  let valid = call_569124.validator(path, query, header, formData, body)
  let scheme = call_569124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569124.url(scheme.get, call_569124.host, call_569124.base,
                         call_569124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569124, url, valid)

proc call*(call_569125: Call_AlertsSendTestEmail_569115; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          request: JsonNode; deviceName: string): Recallable =
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
  ##   request: JObject (required)
  ##          : The send test alert email request.
  ##   deviceName: string (required)
  ##             : The device name.
  var path_569126 = newJObject()
  var query_569127 = newJObject()
  var body_569128 = newJObject()
  add(path_569126, "resourceGroupName", newJString(resourceGroupName))
  add(query_569127, "api-version", newJString(apiVersion))
  add(path_569126, "managerName", newJString(managerName))
  add(path_569126, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_569128 = request
  add(path_569126, "deviceName", newJString(deviceName))
  result = call_569125.call(path_569126, query_569127, nil, nil, body_569128)

var alertsSendTestEmail* = Call_AlertsSendTestEmail_569115(
    name: "alertsSendTestEmail", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/sendTestAlertEmail",
    validator: validate_AlertsSendTestEmail_569116, base: "",
    url: url_AlertsSendTestEmail_569117, schemes: {Scheme.Https})
type
  Call_FileSharesListByDevice_569129 = ref object of OpenApiRestCall_567667
proc url_FileSharesListByDevice_569131(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/shares")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesListByDevice_569130(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the file shares in a device.
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569132 = path.getOrDefault("resourceGroupName")
  valid_569132 = validateParameter(valid_569132, JString, required = true,
                                 default = nil)
  if valid_569132 != nil:
    section.add "resourceGroupName", valid_569132
  var valid_569133 = path.getOrDefault("managerName")
  valid_569133 = validateParameter(valid_569133, JString, required = true,
                                 default = nil)
  if valid_569133 != nil:
    section.add "managerName", valid_569133
  var valid_569134 = path.getOrDefault("subscriptionId")
  valid_569134 = validateParameter(valid_569134, JString, required = true,
                                 default = nil)
  if valid_569134 != nil:
    section.add "subscriptionId", valid_569134
  var valid_569135 = path.getOrDefault("deviceName")
  valid_569135 = validateParameter(valid_569135, JString, required = true,
                                 default = nil)
  if valid_569135 != nil:
    section.add "deviceName", valid_569135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569136 = query.getOrDefault("api-version")
  valid_569136 = validateParameter(valid_569136, JString, required = true,
                                 default = nil)
  if valid_569136 != nil:
    section.add "api-version", valid_569136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569137: Call_FileSharesListByDevice_569129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the file shares in a device.
  ## 
  let valid = call_569137.validator(path, query, header, formData, body)
  let scheme = call_569137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569137.url(scheme.get, call_569137.host, call_569137.base,
                         call_569137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569137, url, valid)

proc call*(call_569138: Call_FileSharesListByDevice_569129;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## fileSharesListByDevice
  ## Retrieves all the file shares in a device.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_569139 = newJObject()
  var query_569140 = newJObject()
  add(path_569139, "resourceGroupName", newJString(resourceGroupName))
  add(query_569140, "api-version", newJString(apiVersion))
  add(path_569139, "managerName", newJString(managerName))
  add(path_569139, "subscriptionId", newJString(subscriptionId))
  add(path_569139, "deviceName", newJString(deviceName))
  result = call_569138.call(path_569139, query_569140, nil, nil, nil)

var fileSharesListByDevice* = Call_FileSharesListByDevice_569129(
    name: "fileSharesListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/shares",
    validator: validate_FileSharesListByDevice_569130, base: "",
    url: url_FileSharesListByDevice_569131, schemes: {Scheme.Https})
type
  Call_DevicesGetTimeSettings_569141 = ref object of OpenApiRestCall_567667
proc url_DevicesGetTimeSettings_569143(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/timeSettings/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGetTimeSettings_569142(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the time settings of the specified device name.
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569144 = path.getOrDefault("resourceGroupName")
  valid_569144 = validateParameter(valid_569144, JString, required = true,
                                 default = nil)
  if valid_569144 != nil:
    section.add "resourceGroupName", valid_569144
  var valid_569145 = path.getOrDefault("managerName")
  valid_569145 = validateParameter(valid_569145, JString, required = true,
                                 default = nil)
  if valid_569145 != nil:
    section.add "managerName", valid_569145
  var valid_569146 = path.getOrDefault("subscriptionId")
  valid_569146 = validateParameter(valid_569146, JString, required = true,
                                 default = nil)
  if valid_569146 != nil:
    section.add "subscriptionId", valid_569146
  var valid_569147 = path.getOrDefault("deviceName")
  valid_569147 = validateParameter(valid_569147, JString, required = true,
                                 default = nil)
  if valid_569147 != nil:
    section.add "deviceName", valid_569147
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
  if body != nil:
    result.add "body", body

proc call*(call_569149: Call_DevicesGetTimeSettings_569141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the time settings of the specified device name.
  ## 
  let valid = call_569149.validator(path, query, header, formData, body)
  let scheme = call_569149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569149.url(scheme.get, call_569149.host, call_569149.base,
                         call_569149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569149, url, valid)

proc call*(call_569150: Call_DevicesGetTimeSettings_569141;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; deviceName: string): Recallable =
  ## devicesGetTimeSettings
  ## Returns the time settings of the specified device name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   deviceName: string (required)
  ##             : The device name.
  var path_569151 = newJObject()
  var query_569152 = newJObject()
  add(path_569151, "resourceGroupName", newJString(resourceGroupName))
  add(query_569152, "api-version", newJString(apiVersion))
  add(path_569151, "managerName", newJString(managerName))
  add(path_569151, "subscriptionId", newJString(subscriptionId))
  add(path_569151, "deviceName", newJString(deviceName))
  result = call_569150.call(path_569151, query_569152, nil, nil, nil)

var devicesGetTimeSettings* = Call_DevicesGetTimeSettings_569141(
    name: "devicesGetTimeSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/timeSettings/default",
    validator: validate_DevicesGetTimeSettings_569142, base: "",
    url: url_DevicesGetTimeSettings_569143, schemes: {Scheme.Https})
type
  Call_DevicesGetUpdateSummary_569153 = ref object of OpenApiRestCall_567667
proc url_DevicesGetUpdateSummary_569155(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetUpdateSummary_569154(path: JsonNode; query: JsonNode;
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
  ##             : The device name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569156 = path.getOrDefault("resourceGroupName")
  valid_569156 = validateParameter(valid_569156, JString, required = true,
                                 default = nil)
  if valid_569156 != nil:
    section.add "resourceGroupName", valid_569156
  var valid_569157 = path.getOrDefault("managerName")
  valid_569157 = validateParameter(valid_569157, JString, required = true,
                                 default = nil)
  if valid_569157 != nil:
    section.add "managerName", valid_569157
  var valid_569158 = path.getOrDefault("subscriptionId")
  valid_569158 = validateParameter(valid_569158, JString, required = true,
                                 default = nil)
  if valid_569158 != nil:
    section.add "subscriptionId", valid_569158
  var valid_569159 = path.getOrDefault("deviceName")
  valid_569159 = validateParameter(valid_569159, JString, required = true,
                                 default = nil)
  if valid_569159 != nil:
    section.add "deviceName", valid_569159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569160 = query.getOrDefault("api-version")
  valid_569160 = validateParameter(valid_569160, JString, required = true,
                                 default = nil)
  if valid_569160 != nil:
    section.add "api-version", valid_569160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569161: Call_DevicesGetUpdateSummary_569153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the update summary of the specified device name.
  ## 
  let valid = call_569161.validator(path, query, header, formData, body)
  let scheme = call_569161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569161.url(scheme.get, call_569161.host, call_569161.base,
                         call_569161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569161, url, valid)

proc call*(call_569162: Call_DevicesGetUpdateSummary_569153;
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
  ##             : The device name.
  var path_569163 = newJObject()
  var query_569164 = newJObject()
  add(path_569163, "resourceGroupName", newJString(resourceGroupName))
  add(query_569164, "api-version", newJString(apiVersion))
  add(path_569163, "managerName", newJString(managerName))
  add(path_569163, "subscriptionId", newJString(subscriptionId))
  add(path_569163, "deviceName", newJString(deviceName))
  result = call_569162.call(path_569163, query_569164, nil, nil, nil)

var devicesGetUpdateSummary* = Call_DevicesGetUpdateSummary_569153(
    name: "devicesGetUpdateSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/updateSummary/default",
    validator: validate_DevicesGetUpdateSummary_569154, base: "",
    url: url_DevicesGetUpdateSummary_569155, schemes: {Scheme.Https})
type
  Call_ManagersGetEncryptionSettings_569165 = ref object of OpenApiRestCall_567667
proc url_ManagersGetEncryptionSettings_569167(protocol: Scheme; host: string;
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

proc validate_ManagersGetEncryptionSettings_569166(path: JsonNode; query: JsonNode;
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
  var valid_569168 = path.getOrDefault("resourceGroupName")
  valid_569168 = validateParameter(valid_569168, JString, required = true,
                                 default = nil)
  if valid_569168 != nil:
    section.add "resourceGroupName", valid_569168
  var valid_569169 = path.getOrDefault("managerName")
  valid_569169 = validateParameter(valid_569169, JString, required = true,
                                 default = nil)
  if valid_569169 != nil:
    section.add "managerName", valid_569169
  var valid_569170 = path.getOrDefault("subscriptionId")
  valid_569170 = validateParameter(valid_569170, JString, required = true,
                                 default = nil)
  if valid_569170 != nil:
    section.add "subscriptionId", valid_569170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569171 = query.getOrDefault("api-version")
  valid_569171 = validateParameter(valid_569171, JString, required = true,
                                 default = nil)
  if valid_569171 != nil:
    section.add "api-version", valid_569171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569172: Call_ManagersGetEncryptionSettings_569165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the encryption settings of the manager.
  ## 
  let valid = call_569172.validator(path, query, header, formData, body)
  let scheme = call_569172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569172.url(scheme.get, call_569172.host, call_569172.base,
                         call_569172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569172, url, valid)

proc call*(call_569173: Call_ManagersGetEncryptionSettings_569165;
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
  var path_569174 = newJObject()
  var query_569175 = newJObject()
  add(path_569174, "resourceGroupName", newJString(resourceGroupName))
  add(query_569175, "api-version", newJString(apiVersion))
  add(path_569174, "managerName", newJString(managerName))
  add(path_569174, "subscriptionId", newJString(subscriptionId))
  result = call_569173.call(path_569174, query_569175, nil, nil, nil)

var managersGetEncryptionSettings* = Call_ManagersGetEncryptionSettings_569165(
    name: "managersGetEncryptionSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/encryptionSettings/default",
    validator: validate_ManagersGetEncryptionSettings_569166, base: "",
    url: url_ManagersGetEncryptionSettings_569167, schemes: {Scheme.Https})
type
  Call_ManagersCreateExtendedInfo_569187 = ref object of OpenApiRestCall_567667
proc url_ManagersCreateExtendedInfo_569189(protocol: Scheme; host: string;
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

proc validate_ManagersCreateExtendedInfo_569188(path: JsonNode; query: JsonNode;
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
  var valid_569190 = path.getOrDefault("resourceGroupName")
  valid_569190 = validateParameter(valid_569190, JString, required = true,
                                 default = nil)
  if valid_569190 != nil:
    section.add "resourceGroupName", valid_569190
  var valid_569191 = path.getOrDefault("managerName")
  valid_569191 = validateParameter(valid_569191, JString, required = true,
                                 default = nil)
  if valid_569191 != nil:
    section.add "managerName", valid_569191
  var valid_569192 = path.getOrDefault("subscriptionId")
  valid_569192 = validateParameter(valid_569192, JString, required = true,
                                 default = nil)
  if valid_569192 != nil:
    section.add "subscriptionId", valid_569192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569193 = query.getOrDefault("api-version")
  valid_569193 = validateParameter(valid_569193, JString, required = true,
                                 default = nil)
  if valid_569193 != nil:
    section.add "api-version", valid_569193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ManagerExtendedInfo: JObject (required)
  ##                      : The manager extended information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569195: Call_ManagersCreateExtendedInfo_569187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the extended info of the manager.
  ## 
  let valid = call_569195.validator(path, query, header, formData, body)
  let scheme = call_569195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569195.url(scheme.get, call_569195.host, call_569195.base,
                         call_569195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569195, url, valid)

proc call*(call_569196: Call_ManagersCreateExtendedInfo_569187;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; ManagerExtendedInfo: JsonNode): Recallable =
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
  ##   ManagerExtendedInfo: JObject (required)
  ##                      : The manager extended information.
  var path_569197 = newJObject()
  var query_569198 = newJObject()
  var body_569199 = newJObject()
  add(path_569197, "resourceGroupName", newJString(resourceGroupName))
  add(query_569198, "api-version", newJString(apiVersion))
  add(path_569197, "managerName", newJString(managerName))
  add(path_569197, "subscriptionId", newJString(subscriptionId))
  if ManagerExtendedInfo != nil:
    body_569199 = ManagerExtendedInfo
  result = call_569196.call(path_569197, query_569198, nil, nil, body_569199)

var managersCreateExtendedInfo* = Call_ManagersCreateExtendedInfo_569187(
    name: "managersCreateExtendedInfo", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersCreateExtendedInfo_569188, base: "",
    url: url_ManagersCreateExtendedInfo_569189, schemes: {Scheme.Https})
type
  Call_ManagersGetExtendedInfo_569176 = ref object of OpenApiRestCall_567667
proc url_ManagersGetExtendedInfo_569178(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersGetExtendedInfo_569177(path: JsonNode; query: JsonNode;
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
  var valid_569179 = path.getOrDefault("resourceGroupName")
  valid_569179 = validateParameter(valid_569179, JString, required = true,
                                 default = nil)
  if valid_569179 != nil:
    section.add "resourceGroupName", valid_569179
  var valid_569180 = path.getOrDefault("managerName")
  valid_569180 = validateParameter(valid_569180, JString, required = true,
                                 default = nil)
  if valid_569180 != nil:
    section.add "managerName", valid_569180
  var valid_569181 = path.getOrDefault("subscriptionId")
  valid_569181 = validateParameter(valid_569181, JString, required = true,
                                 default = nil)
  if valid_569181 != nil:
    section.add "subscriptionId", valid_569181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569182 = query.getOrDefault("api-version")
  valid_569182 = validateParameter(valid_569182, JString, required = true,
                                 default = nil)
  if valid_569182 != nil:
    section.add "api-version", valid_569182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569183: Call_ManagersGetExtendedInfo_569176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the extended information of the specified manager name.
  ## 
  let valid = call_569183.validator(path, query, header, formData, body)
  let scheme = call_569183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569183.url(scheme.get, call_569183.host, call_569183.base,
                         call_569183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569183, url, valid)

proc call*(call_569184: Call_ManagersGetExtendedInfo_569176;
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
  var path_569185 = newJObject()
  var query_569186 = newJObject()
  add(path_569185, "resourceGroupName", newJString(resourceGroupName))
  add(query_569186, "api-version", newJString(apiVersion))
  add(path_569185, "managerName", newJString(managerName))
  add(path_569185, "subscriptionId", newJString(subscriptionId))
  result = call_569184.call(path_569185, query_569186, nil, nil, nil)

var managersGetExtendedInfo* = Call_ManagersGetExtendedInfo_569176(
    name: "managersGetExtendedInfo", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersGetExtendedInfo_569177, base: "",
    url: url_ManagersGetExtendedInfo_569178, schemes: {Scheme.Https})
type
  Call_ManagersUpdateExtendedInfo_569211 = ref object of OpenApiRestCall_567667
proc url_ManagersUpdateExtendedInfo_569213(protocol: Scheme; host: string;
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

proc validate_ManagersUpdateExtendedInfo_569212(path: JsonNode; query: JsonNode;
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
  var valid_569214 = path.getOrDefault("resourceGroupName")
  valid_569214 = validateParameter(valid_569214, JString, required = true,
                                 default = nil)
  if valid_569214 != nil:
    section.add "resourceGroupName", valid_569214
  var valid_569215 = path.getOrDefault("managerName")
  valid_569215 = validateParameter(valid_569215, JString, required = true,
                                 default = nil)
  if valid_569215 != nil:
    section.add "managerName", valid_569215
  var valid_569216 = path.getOrDefault("subscriptionId")
  valid_569216 = validateParameter(valid_569216, JString, required = true,
                                 default = nil)
  if valid_569216 != nil:
    section.add "subscriptionId", valid_569216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569217 = query.getOrDefault("api-version")
  valid_569217 = validateParameter(valid_569217, JString, required = true,
                                 default = nil)
  if valid_569217 != nil:
    section.add "api-version", valid_569217
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : Pass the ETag of ExtendedInfo fetched from GET call
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_569218 = header.getOrDefault("If-Match")
  valid_569218 = validateParameter(valid_569218, JString, required = true,
                                 default = nil)
  if valid_569218 != nil:
    section.add "If-Match", valid_569218
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ManagerExtendedInfo: JObject (required)
  ##                      : The manager extended information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569220: Call_ManagersUpdateExtendedInfo_569211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the extended info of the manager.
  ## 
  let valid = call_569220.validator(path, query, header, formData, body)
  let scheme = call_569220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569220.url(scheme.get, call_569220.host, call_569220.base,
                         call_569220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569220, url, valid)

proc call*(call_569221: Call_ManagersUpdateExtendedInfo_569211;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; ManagerExtendedInfo: JsonNode): Recallable =
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
  ##   ManagerExtendedInfo: JObject (required)
  ##                      : The manager extended information.
  var path_569222 = newJObject()
  var query_569223 = newJObject()
  var body_569224 = newJObject()
  add(path_569222, "resourceGroupName", newJString(resourceGroupName))
  add(query_569223, "api-version", newJString(apiVersion))
  add(path_569222, "managerName", newJString(managerName))
  add(path_569222, "subscriptionId", newJString(subscriptionId))
  if ManagerExtendedInfo != nil:
    body_569224 = ManagerExtendedInfo
  result = call_569221.call(path_569222, query_569223, nil, nil, body_569224)

var managersUpdateExtendedInfo* = Call_ManagersUpdateExtendedInfo_569211(
    name: "managersUpdateExtendedInfo", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersUpdateExtendedInfo_569212, base: "",
    url: url_ManagersUpdateExtendedInfo_569213, schemes: {Scheme.Https})
type
  Call_ManagersDeleteExtendedInfo_569200 = ref object of OpenApiRestCall_567667
proc url_ManagersDeleteExtendedInfo_569202(protocol: Scheme; host: string;
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

proc validate_ManagersDeleteExtendedInfo_569201(path: JsonNode; query: JsonNode;
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
  var valid_569203 = path.getOrDefault("resourceGroupName")
  valid_569203 = validateParameter(valid_569203, JString, required = true,
                                 default = nil)
  if valid_569203 != nil:
    section.add "resourceGroupName", valid_569203
  var valid_569204 = path.getOrDefault("managerName")
  valid_569204 = validateParameter(valid_569204, JString, required = true,
                                 default = nil)
  if valid_569204 != nil:
    section.add "managerName", valid_569204
  var valid_569205 = path.getOrDefault("subscriptionId")
  valid_569205 = validateParameter(valid_569205, JString, required = true,
                                 default = nil)
  if valid_569205 != nil:
    section.add "subscriptionId", valid_569205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569206 = query.getOrDefault("api-version")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = nil)
  if valid_569206 != nil:
    section.add "api-version", valid_569206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569207: Call_ManagersDeleteExtendedInfo_569200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the extended info of the manager.
  ## 
  let valid = call_569207.validator(path, query, header, formData, body)
  let scheme = call_569207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569207.url(scheme.get, call_569207.host, call_569207.base,
                         call_569207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569207, url, valid)

proc call*(call_569208: Call_ManagersDeleteExtendedInfo_569200;
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
  var path_569209 = newJObject()
  var query_569210 = newJObject()
  add(path_569209, "resourceGroupName", newJString(resourceGroupName))
  add(query_569210, "api-version", newJString(apiVersion))
  add(path_569209, "managerName", newJString(managerName))
  add(path_569209, "subscriptionId", newJString(subscriptionId))
  result = call_569208.call(path_569209, query_569210, nil, nil, nil)

var managersDeleteExtendedInfo* = Call_ManagersDeleteExtendedInfo_569200(
    name: "managersDeleteExtendedInfo", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersDeleteExtendedInfo_569201, base: "",
    url: url_ManagersDeleteExtendedInfo_569202, schemes: {Scheme.Https})
type
  Call_FileServersListByManager_569225 = ref object of OpenApiRestCall_567667
proc url_FileServersListByManager_569227(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/fileservers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileServersListByManager_569226(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the file servers in a manager.
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
  var valid_569228 = path.getOrDefault("resourceGroupName")
  valid_569228 = validateParameter(valid_569228, JString, required = true,
                                 default = nil)
  if valid_569228 != nil:
    section.add "resourceGroupName", valid_569228
  var valid_569229 = path.getOrDefault("managerName")
  valid_569229 = validateParameter(valid_569229, JString, required = true,
                                 default = nil)
  if valid_569229 != nil:
    section.add "managerName", valid_569229
  var valid_569230 = path.getOrDefault("subscriptionId")
  valid_569230 = validateParameter(valid_569230, JString, required = true,
                                 default = nil)
  if valid_569230 != nil:
    section.add "subscriptionId", valid_569230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569231 = query.getOrDefault("api-version")
  valid_569231 = validateParameter(valid_569231, JString, required = true,
                                 default = nil)
  if valid_569231 != nil:
    section.add "api-version", valid_569231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569232: Call_FileServersListByManager_569225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the file servers in a manager.
  ## 
  let valid = call_569232.validator(path, query, header, formData, body)
  let scheme = call_569232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569232.url(scheme.get, call_569232.host, call_569232.base,
                         call_569232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569232, url, valid)

proc call*(call_569233: Call_FileServersListByManager_569225;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## fileServersListByManager
  ## Retrieves all the file servers in a manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569234 = newJObject()
  var query_569235 = newJObject()
  add(path_569234, "resourceGroupName", newJString(resourceGroupName))
  add(query_569235, "api-version", newJString(apiVersion))
  add(path_569234, "managerName", newJString(managerName))
  add(path_569234, "subscriptionId", newJString(subscriptionId))
  result = call_569233.call(path_569234, query_569235, nil, nil, nil)

var fileServersListByManager* = Call_FileServersListByManager_569225(
    name: "fileServersListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/fileservers",
    validator: validate_FileServersListByManager_569226, base: "",
    url: url_FileServersListByManager_569227, schemes: {Scheme.Https})
type
  Call_ManagersGetEncryptionKey_569236 = ref object of OpenApiRestCall_567667
proc url_ManagersGetEncryptionKey_569238(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/getEncryptionKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagersGetEncryptionKey_569237(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the symmetric encryption key of the manager.
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
  var valid_569239 = path.getOrDefault("resourceGroupName")
  valid_569239 = validateParameter(valid_569239, JString, required = true,
                                 default = nil)
  if valid_569239 != nil:
    section.add "resourceGroupName", valid_569239
  var valid_569240 = path.getOrDefault("managerName")
  valid_569240 = validateParameter(valid_569240, JString, required = true,
                                 default = nil)
  if valid_569240 != nil:
    section.add "managerName", valid_569240
  var valid_569241 = path.getOrDefault("subscriptionId")
  valid_569241 = validateParameter(valid_569241, JString, required = true,
                                 default = nil)
  if valid_569241 != nil:
    section.add "subscriptionId", valid_569241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569242 = query.getOrDefault("api-version")
  valid_569242 = validateParameter(valid_569242, JString, required = true,
                                 default = nil)
  if valid_569242 != nil:
    section.add "api-version", valid_569242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569243: Call_ManagersGetEncryptionKey_569236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the symmetric encryption key of the manager.
  ## 
  let valid = call_569243.validator(path, query, header, formData, body)
  let scheme = call_569243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569243.url(scheme.get, call_569243.host, call_569243.base,
                         call_569243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569243, url, valid)

proc call*(call_569244: Call_ManagersGetEncryptionKey_569236;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## managersGetEncryptionKey
  ## Returns the symmetric encryption key of the manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569245 = newJObject()
  var query_569246 = newJObject()
  add(path_569245, "resourceGroupName", newJString(resourceGroupName))
  add(query_569246, "api-version", newJString(apiVersion))
  add(path_569245, "managerName", newJString(managerName))
  add(path_569245, "subscriptionId", newJString(subscriptionId))
  result = call_569244.call(path_569245, query_569246, nil, nil, nil)

var managersGetEncryptionKey* = Call_ManagersGetEncryptionKey_569236(
    name: "managersGetEncryptionKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/getEncryptionKey",
    validator: validate_ManagersGetEncryptionKey_569237, base: "",
    url: url_ManagersGetEncryptionKey_569238, schemes: {Scheme.Https})
type
  Call_IscsiServersListByManager_569247 = ref object of OpenApiRestCall_567667
proc url_IscsiServersListByManager_569249(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iscsiservers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IscsiServersListByManager_569248(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the iSCSI servers in a manager.
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
  var valid_569250 = path.getOrDefault("resourceGroupName")
  valid_569250 = validateParameter(valid_569250, JString, required = true,
                                 default = nil)
  if valid_569250 != nil:
    section.add "resourceGroupName", valid_569250
  var valid_569251 = path.getOrDefault("managerName")
  valid_569251 = validateParameter(valid_569251, JString, required = true,
                                 default = nil)
  if valid_569251 != nil:
    section.add "managerName", valid_569251
  var valid_569252 = path.getOrDefault("subscriptionId")
  valid_569252 = validateParameter(valid_569252, JString, required = true,
                                 default = nil)
  if valid_569252 != nil:
    section.add "subscriptionId", valid_569252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569253 = query.getOrDefault("api-version")
  valid_569253 = validateParameter(valid_569253, JString, required = true,
                                 default = nil)
  if valid_569253 != nil:
    section.add "api-version", valid_569253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569254: Call_IscsiServersListByManager_569247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the iSCSI servers in a manager.
  ## 
  let valid = call_569254.validator(path, query, header, formData, body)
  let scheme = call_569254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569254.url(scheme.get, call_569254.host, call_569254.base,
                         call_569254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569254, url, valid)

proc call*(call_569255: Call_IscsiServersListByManager_569247;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## iscsiServersListByManager
  ## Retrieves all the iSCSI servers in a manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569256 = newJObject()
  var query_569257 = newJObject()
  add(path_569256, "resourceGroupName", newJString(resourceGroupName))
  add(query_569257, "api-version", newJString(apiVersion))
  add(path_569256, "managerName", newJString(managerName))
  add(path_569256, "subscriptionId", newJString(subscriptionId))
  result = call_569255.call(path_569256, query_569257, nil, nil, nil)

var iscsiServersListByManager* = Call_IscsiServersListByManager_569247(
    name: "iscsiServersListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/iscsiservers",
    validator: validate_IscsiServersListByManager_569248, base: "",
    url: url_IscsiServersListByManager_569249, schemes: {Scheme.Https})
type
  Call_JobsListByManager_569258 = ref object of OpenApiRestCall_567667
proc url_JobsListByManager_569260(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByManager_569259(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves all the jobs in a manager.
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
  var valid_569261 = path.getOrDefault("resourceGroupName")
  valid_569261 = validateParameter(valid_569261, JString, required = true,
                                 default = nil)
  if valid_569261 != nil:
    section.add "resourceGroupName", valid_569261
  var valid_569262 = path.getOrDefault("managerName")
  valid_569262 = validateParameter(valid_569262, JString, required = true,
                                 default = nil)
  if valid_569262 != nil:
    section.add "managerName", valid_569262
  var valid_569263 = path.getOrDefault("subscriptionId")
  valid_569263 = validateParameter(valid_569263, JString, required = true,
                                 default = nil)
  if valid_569263 != nil:
    section.add "subscriptionId", valid_569263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569264 = query.getOrDefault("api-version")
  valid_569264 = validateParameter(valid_569264, JString, required = true,
                                 default = nil)
  if valid_569264 != nil:
    section.add "api-version", valid_569264
  var valid_569265 = query.getOrDefault("$filter")
  valid_569265 = validateParameter(valid_569265, JString, required = false,
                                 default = nil)
  if valid_569265 != nil:
    section.add "$filter", valid_569265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569266: Call_JobsListByManager_569258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the jobs in a manager.
  ## 
  let valid = call_569266.validator(path, query, header, formData, body)
  let scheme = call_569266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569266.url(scheme.get, call_569266.host, call_569266.base,
                         call_569266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569266, url, valid)

proc call*(call_569267: Call_JobsListByManager_569258; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## jobsListByManager
  ## Retrieves all the jobs in a manager.
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
  var path_569268 = newJObject()
  var query_569269 = newJObject()
  add(path_569268, "resourceGroupName", newJString(resourceGroupName))
  add(query_569269, "api-version", newJString(apiVersion))
  add(path_569268, "managerName", newJString(managerName))
  add(path_569268, "subscriptionId", newJString(subscriptionId))
  add(query_569269, "$filter", newJString(Filter))
  result = call_569267.call(path_569268, query_569269, nil, nil, nil)

var jobsListByManager* = Call_JobsListByManager_569258(name: "jobsListByManager",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/jobs",
    validator: validate_JobsListByManager_569259, base: "",
    url: url_JobsListByManager_569260, schemes: {Scheme.Https})
type
  Call_ManagersListMetrics_569270 = ref object of OpenApiRestCall_567667
proc url_ManagersListMetrics_569272(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersListMetrics_569271(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the  manager metrics
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
  var valid_569273 = path.getOrDefault("resourceGroupName")
  valid_569273 = validateParameter(valid_569273, JString, required = true,
                                 default = nil)
  if valid_569273 != nil:
    section.add "resourceGroupName", valid_569273
  var valid_569274 = path.getOrDefault("managerName")
  valid_569274 = validateParameter(valid_569274, JString, required = true,
                                 default = nil)
  if valid_569274 != nil:
    section.add "managerName", valid_569274
  var valid_569275 = path.getOrDefault("subscriptionId")
  valid_569275 = validateParameter(valid_569275, JString, required = true,
                                 default = nil)
  if valid_569275 != nil:
    section.add "subscriptionId", valid_569275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569276 = query.getOrDefault("api-version")
  valid_569276 = validateParameter(valid_569276, JString, required = true,
                                 default = nil)
  if valid_569276 != nil:
    section.add "api-version", valid_569276
  var valid_569277 = query.getOrDefault("$filter")
  valid_569277 = validateParameter(valid_569277, JString, required = false,
                                 default = nil)
  if valid_569277 != nil:
    section.add "$filter", valid_569277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569278: Call_ManagersListMetrics_569270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the  manager metrics
  ## 
  let valid = call_569278.validator(path, query, header, formData, body)
  let scheme = call_569278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569278.url(scheme.get, call_569278.host, call_569278.base,
                         call_569278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569278, url, valid)

proc call*(call_569279: Call_ManagersListMetrics_569270; resourceGroupName: string;
          apiVersion: string; managerName: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## managersListMetrics
  ## Gets the  manager metrics
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
  var path_569280 = newJObject()
  var query_569281 = newJObject()
  add(path_569280, "resourceGroupName", newJString(resourceGroupName))
  add(query_569281, "api-version", newJString(apiVersion))
  add(path_569280, "managerName", newJString(managerName))
  add(path_569280, "subscriptionId", newJString(subscriptionId))
  add(query_569281, "$filter", newJString(Filter))
  result = call_569279.call(path_569280, query_569281, nil, nil, nil)

var managersListMetrics* = Call_ManagersListMetrics_569270(
    name: "managersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/metrics",
    validator: validate_ManagersListMetrics_569271, base: "",
    url: url_ManagersListMetrics_569272, schemes: {Scheme.Https})
type
  Call_ManagersListMetricDefinition_569282 = ref object of OpenApiRestCall_567667
proc url_ManagersListMetricDefinition_569284(protocol: Scheme; host: string;
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

proc validate_ManagersListMetricDefinition_569283(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves metric definition of all metrics aggregated at manager.
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
  var valid_569285 = path.getOrDefault("resourceGroupName")
  valid_569285 = validateParameter(valid_569285, JString, required = true,
                                 default = nil)
  if valid_569285 != nil:
    section.add "resourceGroupName", valid_569285
  var valid_569286 = path.getOrDefault("managerName")
  valid_569286 = validateParameter(valid_569286, JString, required = true,
                                 default = nil)
  if valid_569286 != nil:
    section.add "managerName", valid_569286
  var valid_569287 = path.getOrDefault("subscriptionId")
  valid_569287 = validateParameter(valid_569287, JString, required = true,
                                 default = nil)
  if valid_569287 != nil:
    section.add "subscriptionId", valid_569287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569288 = query.getOrDefault("api-version")
  valid_569288 = validateParameter(valid_569288, JString, required = true,
                                 default = nil)
  if valid_569288 != nil:
    section.add "api-version", valid_569288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569289: Call_ManagersListMetricDefinition_569282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definition of all metrics aggregated at manager.
  ## 
  let valid = call_569289.validator(path, query, header, formData, body)
  let scheme = call_569289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569289.url(scheme.get, call_569289.host, call_569289.base,
                         call_569289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569289, url, valid)

proc call*(call_569290: Call_ManagersListMetricDefinition_569282;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## managersListMetricDefinition
  ## Retrieves metric definition of all metrics aggregated at manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569291 = newJObject()
  var query_569292 = newJObject()
  add(path_569291, "resourceGroupName", newJString(resourceGroupName))
  add(query_569292, "api-version", newJString(apiVersion))
  add(path_569291, "managerName", newJString(managerName))
  add(path_569291, "subscriptionId", newJString(subscriptionId))
  result = call_569290.call(path_569291, query_569292, nil, nil, nil)

var managersListMetricDefinition* = Call_ManagersListMetricDefinition_569282(
    name: "managersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/metricsDefinitions",
    validator: validate_ManagersListMetricDefinition_569283, base: "",
    url: url_ManagersListMetricDefinition_569284, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsListByManager_569293 = ref object of OpenApiRestCall_567667
proc url_StorageAccountCredentialsListByManager_569295(protocol: Scheme;
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

proc validate_StorageAccountCredentialsListByManager_569294(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the storage account credentials in a manager.
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
  var valid_569296 = path.getOrDefault("resourceGroupName")
  valid_569296 = validateParameter(valid_569296, JString, required = true,
                                 default = nil)
  if valid_569296 != nil:
    section.add "resourceGroupName", valid_569296
  var valid_569297 = path.getOrDefault("managerName")
  valid_569297 = validateParameter(valid_569297, JString, required = true,
                                 default = nil)
  if valid_569297 != nil:
    section.add "managerName", valid_569297
  var valid_569298 = path.getOrDefault("subscriptionId")
  valid_569298 = validateParameter(valid_569298, JString, required = true,
                                 default = nil)
  if valid_569298 != nil:
    section.add "subscriptionId", valid_569298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569299 = query.getOrDefault("api-version")
  valid_569299 = validateParameter(valid_569299, JString, required = true,
                                 default = nil)
  if valid_569299 != nil:
    section.add "api-version", valid_569299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569300: Call_StorageAccountCredentialsListByManager_569293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the storage account credentials in a manager.
  ## 
  let valid = call_569300.validator(path, query, header, formData, body)
  let scheme = call_569300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569300.url(scheme.get, call_569300.host, call_569300.base,
                         call_569300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569300, url, valid)

proc call*(call_569301: Call_StorageAccountCredentialsListByManager_569293;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## storageAccountCredentialsListByManager
  ## Retrieves all the storage account credentials in a manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569302 = newJObject()
  var query_569303 = newJObject()
  add(path_569302, "resourceGroupName", newJString(resourceGroupName))
  add(query_569303, "api-version", newJString(apiVersion))
  add(path_569302, "managerName", newJString(managerName))
  add(path_569302, "subscriptionId", newJString(subscriptionId))
  result = call_569301.call(path_569302, query_569303, nil, nil, nil)

var storageAccountCredentialsListByManager* = Call_StorageAccountCredentialsListByManager_569293(
    name: "storageAccountCredentialsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials",
    validator: validate_StorageAccountCredentialsListByManager_569294, base: "",
    url: url_StorageAccountCredentialsListByManager_569295,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsCreateOrUpdate_569316 = ref object of OpenApiRestCall_567667
proc url_StorageAccountCredentialsCreateOrUpdate_569318(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsCreateOrUpdate_569317(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the storage account credential
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
  ##   credentialName: JString (required)
  ##                 : The credential name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569319 = path.getOrDefault("resourceGroupName")
  valid_569319 = validateParameter(valid_569319, JString, required = true,
                                 default = nil)
  if valid_569319 != nil:
    section.add "resourceGroupName", valid_569319
  var valid_569320 = path.getOrDefault("managerName")
  valid_569320 = validateParameter(valid_569320, JString, required = true,
                                 default = nil)
  if valid_569320 != nil:
    section.add "managerName", valid_569320
  var valid_569321 = path.getOrDefault("subscriptionId")
  valid_569321 = validateParameter(valid_569321, JString, required = true,
                                 default = nil)
  if valid_569321 != nil:
    section.add "subscriptionId", valid_569321
  var valid_569322 = path.getOrDefault("credentialName")
  valid_569322 = validateParameter(valid_569322, JString, required = true,
                                 default = nil)
  if valid_569322 != nil:
    section.add "credentialName", valid_569322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569323 = query.getOrDefault("api-version")
  valid_569323 = validateParameter(valid_569323, JString, required = true,
                                 default = nil)
  if valid_569323 != nil:
    section.add "api-version", valid_569323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   storageAccount: JObject (required)
  ##                 : The storage account credential to be added or updated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569325: Call_StorageAccountCredentialsCreateOrUpdate_569316;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the storage account credential
  ## 
  let valid = call_569325.validator(path, query, header, formData, body)
  let scheme = call_569325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569325.url(scheme.get, call_569325.host, call_569325.base,
                         call_569325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569325, url, valid)

proc call*(call_569326: Call_StorageAccountCredentialsCreateOrUpdate_569316;
          resourceGroupName: string; apiVersion: string; managerName: string;
          storageAccount: JsonNode; subscriptionId: string; credentialName: string): Recallable =
  ## storageAccountCredentialsCreateOrUpdate
  ## Creates or updates the storage account credential
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   storageAccount: JObject (required)
  ##                 : The storage account credential to be added or updated.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   credentialName: string (required)
  ##                 : The credential name.
  var path_569327 = newJObject()
  var query_569328 = newJObject()
  var body_569329 = newJObject()
  add(path_569327, "resourceGroupName", newJString(resourceGroupName))
  add(query_569328, "api-version", newJString(apiVersion))
  add(path_569327, "managerName", newJString(managerName))
  if storageAccount != nil:
    body_569329 = storageAccount
  add(path_569327, "subscriptionId", newJString(subscriptionId))
  add(path_569327, "credentialName", newJString(credentialName))
  result = call_569326.call(path_569327, query_569328, nil, nil, body_569329)

var storageAccountCredentialsCreateOrUpdate* = Call_StorageAccountCredentialsCreateOrUpdate_569316(
    name: "storageAccountCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{credentialName}",
    validator: validate_StorageAccountCredentialsCreateOrUpdate_569317, base: "",
    url: url_StorageAccountCredentialsCreateOrUpdate_569318,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsGet_569304 = ref object of OpenApiRestCall_567667
proc url_StorageAccountCredentialsGet_569306(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsGet_569305(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties of the specified storage account credential name.
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
  ##   credentialName: JString (required)
  ##                 : The name of storage account credential to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569307 = path.getOrDefault("resourceGroupName")
  valid_569307 = validateParameter(valid_569307, JString, required = true,
                                 default = nil)
  if valid_569307 != nil:
    section.add "resourceGroupName", valid_569307
  var valid_569308 = path.getOrDefault("managerName")
  valid_569308 = validateParameter(valid_569308, JString, required = true,
                                 default = nil)
  if valid_569308 != nil:
    section.add "managerName", valid_569308
  var valid_569309 = path.getOrDefault("subscriptionId")
  valid_569309 = validateParameter(valid_569309, JString, required = true,
                                 default = nil)
  if valid_569309 != nil:
    section.add "subscriptionId", valid_569309
  var valid_569310 = path.getOrDefault("credentialName")
  valid_569310 = validateParameter(valid_569310, JString, required = true,
                                 default = nil)
  if valid_569310 != nil:
    section.add "credentialName", valid_569310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569311 = query.getOrDefault("api-version")
  valid_569311 = validateParameter(valid_569311, JString, required = true,
                                 default = nil)
  if valid_569311 != nil:
    section.add "api-version", valid_569311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569312: Call_StorageAccountCredentialsGet_569304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified storage account credential name.
  ## 
  let valid = call_569312.validator(path, query, header, formData, body)
  let scheme = call_569312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569312.url(scheme.get, call_569312.host, call_569312.base,
                         call_569312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569312, url, valid)

proc call*(call_569313: Call_StorageAccountCredentialsGet_569304;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; credentialName: string): Recallable =
  ## storageAccountCredentialsGet
  ## Returns the properties of the specified storage account credential name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   credentialName: string (required)
  ##                 : The name of storage account credential to be fetched.
  var path_569314 = newJObject()
  var query_569315 = newJObject()
  add(path_569314, "resourceGroupName", newJString(resourceGroupName))
  add(query_569315, "api-version", newJString(apiVersion))
  add(path_569314, "managerName", newJString(managerName))
  add(path_569314, "subscriptionId", newJString(subscriptionId))
  add(path_569314, "credentialName", newJString(credentialName))
  result = call_569313.call(path_569314, query_569315, nil, nil, nil)

var storageAccountCredentialsGet* = Call_StorageAccountCredentialsGet_569304(
    name: "storageAccountCredentialsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{credentialName}",
    validator: validate_StorageAccountCredentialsGet_569305, base: "",
    url: url_StorageAccountCredentialsGet_569306, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsDelete_569330 = ref object of OpenApiRestCall_567667
proc url_StorageAccountCredentialsDelete_569332(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "credentialName" in path, "`credentialName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageAccountCredentials/"),
               (kind: VariableSegment, value: "credentialName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountCredentialsDelete_569331(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the storage account credential
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
  ##   credentialName: JString (required)
  ##                 : The name of the storage account credential.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569333 = path.getOrDefault("resourceGroupName")
  valid_569333 = validateParameter(valid_569333, JString, required = true,
                                 default = nil)
  if valid_569333 != nil:
    section.add "resourceGroupName", valid_569333
  var valid_569334 = path.getOrDefault("managerName")
  valid_569334 = validateParameter(valid_569334, JString, required = true,
                                 default = nil)
  if valid_569334 != nil:
    section.add "managerName", valid_569334
  var valid_569335 = path.getOrDefault("subscriptionId")
  valid_569335 = validateParameter(valid_569335, JString, required = true,
                                 default = nil)
  if valid_569335 != nil:
    section.add "subscriptionId", valid_569335
  var valid_569336 = path.getOrDefault("credentialName")
  valid_569336 = validateParameter(valid_569336, JString, required = true,
                                 default = nil)
  if valid_569336 != nil:
    section.add "credentialName", valid_569336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569337 = query.getOrDefault("api-version")
  valid_569337 = validateParameter(valid_569337, JString, required = true,
                                 default = nil)
  if valid_569337 != nil:
    section.add "api-version", valid_569337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569338: Call_StorageAccountCredentialsDelete_569330;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the storage account credential
  ## 
  let valid = call_569338.validator(path, query, header, formData, body)
  let scheme = call_569338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569338.url(scheme.get, call_569338.host, call_569338.base,
                         call_569338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569338, url, valid)

proc call*(call_569339: Call_StorageAccountCredentialsDelete_569330;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string; credentialName: string): Recallable =
  ## storageAccountCredentialsDelete
  ## Deletes the storage account credential
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   credentialName: string (required)
  ##                 : The name of the storage account credential.
  var path_569340 = newJObject()
  var query_569341 = newJObject()
  add(path_569340, "resourceGroupName", newJString(resourceGroupName))
  add(query_569341, "api-version", newJString(apiVersion))
  add(path_569340, "managerName", newJString(managerName))
  add(path_569340, "subscriptionId", newJString(subscriptionId))
  add(path_569340, "credentialName", newJString(credentialName))
  result = call_569339.call(path_569340, query_569341, nil, nil, nil)

var storageAccountCredentialsDelete* = Call_StorageAccountCredentialsDelete_569330(
    name: "storageAccountCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{credentialName}",
    validator: validate_StorageAccountCredentialsDelete_569331, base: "",
    url: url_StorageAccountCredentialsDelete_569332, schemes: {Scheme.Https})
type
  Call_StorageDomainsListByManager_569342 = ref object of OpenApiRestCall_567667
proc url_StorageDomainsListByManager_569344(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/storageDomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDomainsListByManager_569343(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all the storage domains in a manager.
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
  var valid_569345 = path.getOrDefault("resourceGroupName")
  valid_569345 = validateParameter(valid_569345, JString, required = true,
                                 default = nil)
  if valid_569345 != nil:
    section.add "resourceGroupName", valid_569345
  var valid_569346 = path.getOrDefault("managerName")
  valid_569346 = validateParameter(valid_569346, JString, required = true,
                                 default = nil)
  if valid_569346 != nil:
    section.add "managerName", valid_569346
  var valid_569347 = path.getOrDefault("subscriptionId")
  valid_569347 = validateParameter(valid_569347, JString, required = true,
                                 default = nil)
  if valid_569347 != nil:
    section.add "subscriptionId", valid_569347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569348 = query.getOrDefault("api-version")
  valid_569348 = validateParameter(valid_569348, JString, required = true,
                                 default = nil)
  if valid_569348 != nil:
    section.add "api-version", valid_569348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569349: Call_StorageDomainsListByManager_569342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the storage domains in a manager.
  ## 
  let valid = call_569349.validator(path, query, header, formData, body)
  let scheme = call_569349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569349.url(scheme.get, call_569349.host, call_569349.base,
                         call_569349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569349, url, valid)

proc call*(call_569350: Call_StorageDomainsListByManager_569342;
          resourceGroupName: string; apiVersion: string; managerName: string;
          subscriptionId: string): Recallable =
  ## storageDomainsListByManager
  ## Retrieves all the storage domains in a manager.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569351 = newJObject()
  var query_569352 = newJObject()
  add(path_569351, "resourceGroupName", newJString(resourceGroupName))
  add(query_569352, "api-version", newJString(apiVersion))
  add(path_569351, "managerName", newJString(managerName))
  add(path_569351, "subscriptionId", newJString(subscriptionId))
  result = call_569350.call(path_569351, query_569352, nil, nil, nil)

var storageDomainsListByManager* = Call_StorageDomainsListByManager_569342(
    name: "storageDomainsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageDomains",
    validator: validate_StorageDomainsListByManager_569343, base: "",
    url: url_StorageDomainsListByManager_569344, schemes: {Scheme.Https})
type
  Call_StorageDomainsCreateOrUpdate_569365 = ref object of OpenApiRestCall_567667
proc url_StorageDomainsCreateOrUpdate_569367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "storageDomainName" in path,
        "`storageDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageDomains/"),
               (kind: VariableSegment, value: "storageDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDomainsCreateOrUpdate_569366(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the storage domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   storageDomainName: JString (required)
  ##                    : The storage domain name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569368 = path.getOrDefault("resourceGroupName")
  valid_569368 = validateParameter(valid_569368, JString, required = true,
                                 default = nil)
  if valid_569368 != nil:
    section.add "resourceGroupName", valid_569368
  var valid_569369 = path.getOrDefault("managerName")
  valid_569369 = validateParameter(valid_569369, JString, required = true,
                                 default = nil)
  if valid_569369 != nil:
    section.add "managerName", valid_569369
  var valid_569370 = path.getOrDefault("storageDomainName")
  valid_569370 = validateParameter(valid_569370, JString, required = true,
                                 default = nil)
  if valid_569370 != nil:
    section.add "storageDomainName", valid_569370
  var valid_569371 = path.getOrDefault("subscriptionId")
  valid_569371 = validateParameter(valid_569371, JString, required = true,
                                 default = nil)
  if valid_569371 != nil:
    section.add "subscriptionId", valid_569371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569372 = query.getOrDefault("api-version")
  valid_569372 = validateParameter(valid_569372, JString, required = true,
                                 default = nil)
  if valid_569372 != nil:
    section.add "api-version", valid_569372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   storageDomain: JObject (required)
  ##                : The storageDomain.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569374: Call_StorageDomainsCreateOrUpdate_569365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the storage domain.
  ## 
  let valid = call_569374.validator(path, query, header, formData, body)
  let scheme = call_569374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569374.url(scheme.get, call_569374.host, call_569374.base,
                         call_569374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569374, url, valid)

proc call*(call_569375: Call_StorageDomainsCreateOrUpdate_569365;
          resourceGroupName: string; apiVersion: string; managerName: string;
          storageDomainName: string; subscriptionId: string; storageDomain: JsonNode): Recallable =
  ## storageDomainsCreateOrUpdate
  ## Creates or updates the storage domain.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   storageDomainName: string (required)
  ##                    : The storage domain name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  ##   storageDomain: JObject (required)
  ##                : The storageDomain.
  var path_569376 = newJObject()
  var query_569377 = newJObject()
  var body_569378 = newJObject()
  add(path_569376, "resourceGroupName", newJString(resourceGroupName))
  add(query_569377, "api-version", newJString(apiVersion))
  add(path_569376, "managerName", newJString(managerName))
  add(path_569376, "storageDomainName", newJString(storageDomainName))
  add(path_569376, "subscriptionId", newJString(subscriptionId))
  if storageDomain != nil:
    body_569378 = storageDomain
  result = call_569375.call(path_569376, query_569377, nil, nil, body_569378)

var storageDomainsCreateOrUpdate* = Call_StorageDomainsCreateOrUpdate_569365(
    name: "storageDomainsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageDomains/{storageDomainName}",
    validator: validate_StorageDomainsCreateOrUpdate_569366, base: "",
    url: url_StorageDomainsCreateOrUpdate_569367, schemes: {Scheme.Https})
type
  Call_StorageDomainsGet_569353 = ref object of OpenApiRestCall_567667
proc url_StorageDomainsGet_569355(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "storageDomainName" in path,
        "`storageDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageDomains/"),
               (kind: VariableSegment, value: "storageDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDomainsGet_569354(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the properties of the specified storage domain name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   storageDomainName: JString (required)
  ##                    : The storage domain name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569356 = path.getOrDefault("resourceGroupName")
  valid_569356 = validateParameter(valid_569356, JString, required = true,
                                 default = nil)
  if valid_569356 != nil:
    section.add "resourceGroupName", valid_569356
  var valid_569357 = path.getOrDefault("managerName")
  valid_569357 = validateParameter(valid_569357, JString, required = true,
                                 default = nil)
  if valid_569357 != nil:
    section.add "managerName", valid_569357
  var valid_569358 = path.getOrDefault("storageDomainName")
  valid_569358 = validateParameter(valid_569358, JString, required = true,
                                 default = nil)
  if valid_569358 != nil:
    section.add "storageDomainName", valid_569358
  var valid_569359 = path.getOrDefault("subscriptionId")
  valid_569359 = validateParameter(valid_569359, JString, required = true,
                                 default = nil)
  if valid_569359 != nil:
    section.add "subscriptionId", valid_569359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569360 = query.getOrDefault("api-version")
  valid_569360 = validateParameter(valid_569360, JString, required = true,
                                 default = nil)
  if valid_569360 != nil:
    section.add "api-version", valid_569360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569361: Call_StorageDomainsGet_569353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified storage domain name.
  ## 
  let valid = call_569361.validator(path, query, header, formData, body)
  let scheme = call_569361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569361.url(scheme.get, call_569361.host, call_569361.base,
                         call_569361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569361, url, valid)

proc call*(call_569362: Call_StorageDomainsGet_569353; resourceGroupName: string;
          apiVersion: string; managerName: string; storageDomainName: string;
          subscriptionId: string): Recallable =
  ## storageDomainsGet
  ## Returns the properties of the specified storage domain name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   storageDomainName: string (required)
  ##                    : The storage domain name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569363 = newJObject()
  var query_569364 = newJObject()
  add(path_569363, "resourceGroupName", newJString(resourceGroupName))
  add(query_569364, "api-version", newJString(apiVersion))
  add(path_569363, "managerName", newJString(managerName))
  add(path_569363, "storageDomainName", newJString(storageDomainName))
  add(path_569363, "subscriptionId", newJString(subscriptionId))
  result = call_569362.call(path_569363, query_569364, nil, nil, nil)

var storageDomainsGet* = Call_StorageDomainsGet_569353(name: "storageDomainsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageDomains/{storageDomainName}",
    validator: validate_StorageDomainsGet_569354, base: "",
    url: url_StorageDomainsGet_569355, schemes: {Scheme.Https})
type
  Call_StorageDomainsDelete_569379 = ref object of OpenApiRestCall_567667
proc url_StorageDomainsDelete_569381(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managerName" in path, "`managerName` is a required path parameter"
  assert "storageDomainName" in path,
        "`storageDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.StorSimple/managers/"),
               (kind: VariableSegment, value: "managerName"),
               (kind: ConstantSegment, value: "/storageDomains/"),
               (kind: VariableSegment, value: "storageDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDomainsDelete_569380(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the storage domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name
  ##   managerName: JString (required)
  ##              : The manager name
  ##   storageDomainName: JString (required)
  ##                    : The storage domain name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569382 = path.getOrDefault("resourceGroupName")
  valid_569382 = validateParameter(valid_569382, JString, required = true,
                                 default = nil)
  if valid_569382 != nil:
    section.add "resourceGroupName", valid_569382
  var valid_569383 = path.getOrDefault("managerName")
  valid_569383 = validateParameter(valid_569383, JString, required = true,
                                 default = nil)
  if valid_569383 != nil:
    section.add "managerName", valid_569383
  var valid_569384 = path.getOrDefault("storageDomainName")
  valid_569384 = validateParameter(valid_569384, JString, required = true,
                                 default = nil)
  if valid_569384 != nil:
    section.add "storageDomainName", valid_569384
  var valid_569385 = path.getOrDefault("subscriptionId")
  valid_569385 = validateParameter(valid_569385, JString, required = true,
                                 default = nil)
  if valid_569385 != nil:
    section.add "subscriptionId", valid_569385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569386 = query.getOrDefault("api-version")
  valid_569386 = validateParameter(valid_569386, JString, required = true,
                                 default = nil)
  if valid_569386 != nil:
    section.add "api-version", valid_569386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569387: Call_StorageDomainsDelete_569379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the storage domain.
  ## 
  let valid = call_569387.validator(path, query, header, formData, body)
  let scheme = call_569387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569387.url(scheme.get, call_569387.host, call_569387.base,
                         call_569387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569387, url, valid)

proc call*(call_569388: Call_StorageDomainsDelete_569379;
          resourceGroupName: string; apiVersion: string; managerName: string;
          storageDomainName: string; subscriptionId: string): Recallable =
  ## storageDomainsDelete
  ## Deletes the storage domain.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   managerName: string (required)
  ##              : The manager name
  ##   storageDomainName: string (required)
  ##                    : The storage domain name.
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_569389 = newJObject()
  var query_569390 = newJObject()
  add(path_569389, "resourceGroupName", newJString(resourceGroupName))
  add(query_569390, "api-version", newJString(apiVersion))
  add(path_569389, "managerName", newJString(managerName))
  add(path_569389, "storageDomainName", newJString(storageDomainName))
  add(path_569389, "subscriptionId", newJString(subscriptionId))
  result = call_569388.call(path_569389, query_569390, nil, nil, nil)

var storageDomainsDelete* = Call_StorageDomainsDelete_569379(
    name: "storageDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageDomains/{storageDomainName}",
    validator: validate_StorageDomainsDelete_569380, base: "",
    url: url_StorageDomainsDelete_569381, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
