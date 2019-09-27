
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "storSimple1200Series-StorSimple"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AvailableProviderOperationsList_593660 = ref object of OpenApiRestCall_593438
proc url_AvailableProviderOperationsList_593662(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AvailableProviderOperationsList_593661(path: JsonNode;
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
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "api-version", valid_593821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_AvailableProviderOperationsList_593660;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List of AvailableProviderOperations
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_AvailableProviderOperationsList_593660;
          apiVersion: string): Recallable =
  ## availableProviderOperationsList
  ## List of AvailableProviderOperations
  ##   apiVersion: string (required)
  ##             : The api version
  var query_593916 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  result = call_593915.call(nil, query_593916, nil, nil, nil)

var availableProviderOperationsList* = Call_AvailableProviderOperationsList_593660(
    name: "availableProviderOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.StorSimple/operations",
    validator: validate_AvailableProviderOperationsList_593661, base: "",
    url: url_AvailableProviderOperationsList_593662, schemes: {Scheme.Https})
type
  Call_ManagersList_593956 = ref object of OpenApiRestCall_593438
proc url_ManagersList_593958(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersList_593957(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "api-version", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_ManagersList_593956; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the managers in a subscription.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_ManagersList_593956; apiVersion: string;
          subscriptionId: string): Recallable =
  ## managersList
  ## Retrieves all the managers in a subscription.
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var managersList* = Call_ManagersList_593956(name: "managersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StorSimple/managers",
    validator: validate_ManagersList_593957, base: "", url: url_ManagersList_593958,
    schemes: {Scheme.Https})
type
  Call_ManagersListByResourceGroup_593979 = ref object of OpenApiRestCall_593438
proc url_ManagersListByResourceGroup_593981(protocol: Scheme; host: string;
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

proc validate_ManagersListByResourceGroup_593980(path: JsonNode; query: JsonNode;
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
  var valid_593982 = path.getOrDefault("resourceGroupName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceGroupName", valid_593982
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_ManagersListByResourceGroup_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the managers in a resource group.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_ManagersListByResourceGroup_593979;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## managersListByResourceGroup
  ## Retrieves all the managers in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name
  ##   apiVersion: string (required)
  ##             : The api version
  ##   subscriptionId: string (required)
  ##                 : The subscription id
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(path_593987, "resourceGroupName", newJString(resourceGroupName))
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "subscriptionId", newJString(subscriptionId))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var managersListByResourceGroup* = Call_ManagersListByResourceGroup_593979(
    name: "managersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers",
    validator: validate_ManagersListByResourceGroup_593980, base: "",
    url: url_ManagersListByResourceGroup_593981, schemes: {Scheme.Https})
type
  Call_ManagersCreateOrUpdate_594000 = ref object of OpenApiRestCall_593438
proc url_ManagersCreateOrUpdate_594002(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersCreateOrUpdate_594001(path: JsonNode; query: JsonNode;
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
  var valid_594003 = path.getOrDefault("resourceGroupName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "resourceGroupName", valid_594003
  var valid_594004 = path.getOrDefault("managerName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "managerName", valid_594004
  var valid_594005 = path.getOrDefault("subscriptionId")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "subscriptionId", valid_594005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "api-version", valid_594006
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

proc call*(call_594008: Call_ManagersCreateOrUpdate_594000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the manager.
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_ManagersCreateOrUpdate_594000;
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
  var path_594010 = newJObject()
  var query_594011 = newJObject()
  var body_594012 = newJObject()
  add(path_594010, "resourceGroupName", newJString(resourceGroupName))
  add(query_594011, "api-version", newJString(apiVersion))
  add(path_594010, "managerName", newJString(managerName))
  add(path_594010, "subscriptionId", newJString(subscriptionId))
  if Manager != nil:
    body_594012 = Manager
  result = call_594009.call(path_594010, query_594011, nil, nil, body_594012)

var managersCreateOrUpdate* = Call_ManagersCreateOrUpdate_594000(
    name: "managersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}",
    validator: validate_ManagersCreateOrUpdate_594001, base: "",
    url: url_ManagersCreateOrUpdate_594002, schemes: {Scheme.Https})
type
  Call_ManagersGet_593989 = ref object of OpenApiRestCall_593438
proc url_ManagersGet_593991(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersGet_593990(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593992 = path.getOrDefault("resourceGroupName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "resourceGroupName", valid_593992
  var valid_593993 = path.getOrDefault("managerName")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "managerName", valid_593993
  var valid_593994 = path.getOrDefault("subscriptionId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "subscriptionId", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "api-version", valid_593995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593996: Call_ManagersGet_593989; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified manager name.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_ManagersGet_593989; resourceGroupName: string;
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
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  add(path_593998, "resourceGroupName", newJString(resourceGroupName))
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "managerName", newJString(managerName))
  add(path_593998, "subscriptionId", newJString(subscriptionId))
  result = call_593997.call(path_593998, query_593999, nil, nil, nil)

var managersGet* = Call_ManagersGet_593989(name: "managersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}",
                                        validator: validate_ManagersGet_593990,
                                        base: "", url: url_ManagersGet_593991,
                                        schemes: {Scheme.Https})
type
  Call_ManagersUpdate_594024 = ref object of OpenApiRestCall_593438
proc url_ManagersUpdate_594026(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersUpdate_594025(path: JsonNode; query: JsonNode;
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
  var valid_594027 = path.getOrDefault("resourceGroupName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "resourceGroupName", valid_594027
  var valid_594028 = path.getOrDefault("managerName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "managerName", valid_594028
  var valid_594029 = path.getOrDefault("subscriptionId")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "subscriptionId", valid_594029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594030 = query.getOrDefault("api-version")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "api-version", valid_594030
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

proc call*(call_594032: Call_ManagersUpdate_594024; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the StorSimple Manager.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_ManagersUpdate_594024; resourceGroupName: string;
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
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  var body_594036 = newJObject()
  add(path_594034, "resourceGroupName", newJString(resourceGroupName))
  add(query_594035, "api-version", newJString(apiVersion))
  add(path_594034, "managerName", newJString(managerName))
  add(path_594034, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594036 = parameters
  result = call_594033.call(path_594034, query_594035, nil, nil, body_594036)

var managersUpdate* = Call_ManagersUpdate_594024(name: "managersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}",
    validator: validate_ManagersUpdate_594025, base: "", url: url_ManagersUpdate_594026,
    schemes: {Scheme.Https})
type
  Call_ManagersDelete_594013 = ref object of OpenApiRestCall_593438
proc url_ManagersDelete_594015(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersDelete_594014(path: JsonNode; query: JsonNode;
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
  var valid_594016 = path.getOrDefault("resourceGroupName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "resourceGroupName", valid_594016
  var valid_594017 = path.getOrDefault("managerName")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "managerName", valid_594017
  var valid_594018 = path.getOrDefault("subscriptionId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "subscriptionId", valid_594018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
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

proc call*(call_594020: Call_ManagersDelete_594013; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the manager.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_ManagersDelete_594013; resourceGroupName: string;
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
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  add(path_594022, "resourceGroupName", newJString(resourceGroupName))
  add(query_594023, "api-version", newJString(apiVersion))
  add(path_594022, "managerName", newJString(managerName))
  add(path_594022, "subscriptionId", newJString(subscriptionId))
  result = call_594021.call(path_594022, query_594023, nil, nil, nil)

var managersDelete* = Call_ManagersDelete_594013(name: "managersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}",
    validator: validate_ManagersDelete_594014, base: "", url: url_ManagersDelete_594015,
    schemes: {Scheme.Https})
type
  Call_AccessControlRecordsListByManager_594037 = ref object of OpenApiRestCall_593438
proc url_AccessControlRecordsListByManager_594039(protocol: Scheme; host: string;
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

proc validate_AccessControlRecordsListByManager_594038(path: JsonNode;
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
  var valid_594040 = path.getOrDefault("resourceGroupName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "resourceGroupName", valid_594040
  var valid_594041 = path.getOrDefault("managerName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "managerName", valid_594041
  var valid_594042 = path.getOrDefault("subscriptionId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "subscriptionId", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594044: Call_AccessControlRecordsListByManager_594037;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the access control records in a manager.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_AccessControlRecordsListByManager_594037;
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
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  add(path_594046, "resourceGroupName", newJString(resourceGroupName))
  add(query_594047, "api-version", newJString(apiVersion))
  add(path_594046, "managerName", newJString(managerName))
  add(path_594046, "subscriptionId", newJString(subscriptionId))
  result = call_594045.call(path_594046, query_594047, nil, nil, nil)

var accessControlRecordsListByManager* = Call_AccessControlRecordsListByManager_594037(
    name: "accessControlRecordsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/accessControlRecords",
    validator: validate_AccessControlRecordsListByManager_594038, base: "",
    url: url_AccessControlRecordsListByManager_594039, schemes: {Scheme.Https})
type
  Call_AccessControlRecordsCreateOrUpdate_594060 = ref object of OpenApiRestCall_593438
proc url_AccessControlRecordsCreateOrUpdate_594062(protocol: Scheme; host: string;
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

proc validate_AccessControlRecordsCreateOrUpdate_594061(path: JsonNode;
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
  var valid_594063 = path.getOrDefault("resourceGroupName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "resourceGroupName", valid_594063
  var valid_594064 = path.getOrDefault("managerName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "managerName", valid_594064
  var valid_594065 = path.getOrDefault("subscriptionId")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "subscriptionId", valid_594065
  var valid_594066 = path.getOrDefault("accessControlRecordName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "accessControlRecordName", valid_594066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594067 = query.getOrDefault("api-version")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "api-version", valid_594067
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

proc call*(call_594069: Call_AccessControlRecordsCreateOrUpdate_594060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates an access control record.
  ## 
  let valid = call_594069.validator(path, query, header, formData, body)
  let scheme = call_594069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594069.url(scheme.get, call_594069.host, call_594069.base,
                         call_594069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594069, url, valid)

proc call*(call_594070: Call_AccessControlRecordsCreateOrUpdate_594060;
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
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  var body_594073 = newJObject()
  add(path_594071, "resourceGroupName", newJString(resourceGroupName))
  add(query_594072, "api-version", newJString(apiVersion))
  add(path_594071, "managerName", newJString(managerName))
  add(path_594071, "subscriptionId", newJString(subscriptionId))
  if accessControlRecord != nil:
    body_594073 = accessControlRecord
  add(path_594071, "accessControlRecordName", newJString(accessControlRecordName))
  result = call_594070.call(path_594071, query_594072, nil, nil, body_594073)

var accessControlRecordsCreateOrUpdate* = Call_AccessControlRecordsCreateOrUpdate_594060(
    name: "accessControlRecordsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/accessControlRecords/{accessControlRecordName}",
    validator: validate_AccessControlRecordsCreateOrUpdate_594061, base: "",
    url: url_AccessControlRecordsCreateOrUpdate_594062, schemes: {Scheme.Https})
type
  Call_AccessControlRecordsGet_594048 = ref object of OpenApiRestCall_593438
proc url_AccessControlRecordsGet_594050(protocol: Scheme; host: string; base: string;
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

proc validate_AccessControlRecordsGet_594049(path: JsonNode; query: JsonNode;
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
  var valid_594051 = path.getOrDefault("resourceGroupName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "resourceGroupName", valid_594051
  var valid_594052 = path.getOrDefault("managerName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "managerName", valid_594052
  var valid_594053 = path.getOrDefault("subscriptionId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "subscriptionId", valid_594053
  var valid_594054 = path.getOrDefault("accessControlRecordName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "accessControlRecordName", valid_594054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594055 = query.getOrDefault("api-version")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "api-version", valid_594055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594056: Call_AccessControlRecordsGet_594048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified access control record name.
  ## 
  let valid = call_594056.validator(path, query, header, formData, body)
  let scheme = call_594056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594056.url(scheme.get, call_594056.host, call_594056.base,
                         call_594056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594056, url, valid)

proc call*(call_594057: Call_AccessControlRecordsGet_594048;
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
  var path_594058 = newJObject()
  var query_594059 = newJObject()
  add(path_594058, "resourceGroupName", newJString(resourceGroupName))
  add(query_594059, "api-version", newJString(apiVersion))
  add(path_594058, "managerName", newJString(managerName))
  add(path_594058, "subscriptionId", newJString(subscriptionId))
  add(path_594058, "accessControlRecordName", newJString(accessControlRecordName))
  result = call_594057.call(path_594058, query_594059, nil, nil, nil)

var accessControlRecordsGet* = Call_AccessControlRecordsGet_594048(
    name: "accessControlRecordsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/accessControlRecords/{accessControlRecordName}",
    validator: validate_AccessControlRecordsGet_594049, base: "",
    url: url_AccessControlRecordsGet_594050, schemes: {Scheme.Https})
type
  Call_AccessControlRecordsDelete_594074 = ref object of OpenApiRestCall_593438
proc url_AccessControlRecordsDelete_594076(protocol: Scheme; host: string;
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

proc validate_AccessControlRecordsDelete_594075(path: JsonNode; query: JsonNode;
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
  var valid_594077 = path.getOrDefault("resourceGroupName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "resourceGroupName", valid_594077
  var valid_594078 = path.getOrDefault("managerName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "managerName", valid_594078
  var valid_594079 = path.getOrDefault("subscriptionId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "subscriptionId", valid_594079
  var valid_594080 = path.getOrDefault("accessControlRecordName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "accessControlRecordName", valid_594080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594081 = query.getOrDefault("api-version")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "api-version", valid_594081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594082: Call_AccessControlRecordsDelete_594074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the access control record.
  ## 
  let valid = call_594082.validator(path, query, header, formData, body)
  let scheme = call_594082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594082.url(scheme.get, call_594082.host, call_594082.base,
                         call_594082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594082, url, valid)

proc call*(call_594083: Call_AccessControlRecordsDelete_594074;
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
  var path_594084 = newJObject()
  var query_594085 = newJObject()
  add(path_594084, "resourceGroupName", newJString(resourceGroupName))
  add(query_594085, "api-version", newJString(apiVersion))
  add(path_594084, "managerName", newJString(managerName))
  add(path_594084, "subscriptionId", newJString(subscriptionId))
  add(path_594084, "accessControlRecordName", newJString(accessControlRecordName))
  result = call_594083.call(path_594084, query_594085, nil, nil, nil)

var accessControlRecordsDelete* = Call_AccessControlRecordsDelete_594074(
    name: "accessControlRecordsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/accessControlRecords/{accessControlRecordName}",
    validator: validate_AccessControlRecordsDelete_594075, base: "",
    url: url_AccessControlRecordsDelete_594076, schemes: {Scheme.Https})
type
  Call_AlertsListByManager_594086 = ref object of OpenApiRestCall_593438
proc url_AlertsListByManager_594088(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsListByManager_594087(path: JsonNode; query: JsonNode;
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
  var valid_594090 = path.getOrDefault("resourceGroupName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "resourceGroupName", valid_594090
  var valid_594091 = path.getOrDefault("managerName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "managerName", valid_594091
  var valid_594092 = path.getOrDefault("subscriptionId")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "subscriptionId", valid_594092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594093 = query.getOrDefault("api-version")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "api-version", valid_594093
  var valid_594094 = query.getOrDefault("$filter")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "$filter", valid_594094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594095: Call_AlertsListByManager_594086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the alerts in a manager.
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_AlertsListByManager_594086; resourceGroupName: string;
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
  var path_594097 = newJObject()
  var query_594098 = newJObject()
  add(path_594097, "resourceGroupName", newJString(resourceGroupName))
  add(query_594098, "api-version", newJString(apiVersion))
  add(path_594097, "managerName", newJString(managerName))
  add(path_594097, "subscriptionId", newJString(subscriptionId))
  add(query_594098, "$filter", newJString(Filter))
  result = call_594096.call(path_594097, query_594098, nil, nil, nil)

var alertsListByManager* = Call_AlertsListByManager_594086(
    name: "alertsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/alerts",
    validator: validate_AlertsListByManager_594087, base: "",
    url: url_AlertsListByManager_594088, schemes: {Scheme.Https})
type
  Call_BackupsListByManager_594099 = ref object of OpenApiRestCall_593438
proc url_BackupsListByManager_594101(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsListByManager_594100(path: JsonNode; query: JsonNode;
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
  var valid_594102 = path.getOrDefault("resourceGroupName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "resourceGroupName", valid_594102
  var valid_594103 = path.getOrDefault("managerName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "managerName", valid_594103
  var valid_594104 = path.getOrDefault("subscriptionId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "subscriptionId", valid_594104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594105 = query.getOrDefault("api-version")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "api-version", valid_594105
  var valid_594106 = query.getOrDefault("$filter")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "$filter", valid_594106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_BackupsListByManager_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the backups in a manager.
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_BackupsListByManager_594099;
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
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(path_594109, "resourceGroupName", newJString(resourceGroupName))
  add(query_594110, "api-version", newJString(apiVersion))
  add(path_594109, "managerName", newJString(managerName))
  add(path_594109, "subscriptionId", newJString(subscriptionId))
  add(query_594110, "$filter", newJString(Filter))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var backupsListByManager* = Call_BackupsListByManager_594099(
    name: "backupsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/backups",
    validator: validate_BackupsListByManager_594100, base: "",
    url: url_BackupsListByManager_594101, schemes: {Scheme.Https})
type
  Call_ManagersUploadRegistrationCertificate_594111 = ref object of OpenApiRestCall_593438
proc url_ManagersUploadRegistrationCertificate_594113(protocol: Scheme;
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

proc validate_ManagersUploadRegistrationCertificate_594112(path: JsonNode;
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
  var valid_594114 = path.getOrDefault("resourceGroupName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "resourceGroupName", valid_594114
  var valid_594115 = path.getOrDefault("managerName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "managerName", valid_594115
  var valid_594116 = path.getOrDefault("subscriptionId")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "subscriptionId", valid_594116
  var valid_594117 = path.getOrDefault("certificateName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "certificateName", valid_594117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594118 = query.getOrDefault("api-version")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "api-version", valid_594118
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

proc call*(call_594120: Call_ManagersUploadRegistrationCertificate_594111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload Vault Cred Certificate.
  ## Returns UploadCertificateResponse
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_ManagersUploadRegistrationCertificate_594111;
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
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  var body_594124 = newJObject()
  add(path_594122, "resourceGroupName", newJString(resourceGroupName))
  add(query_594123, "api-version", newJString(apiVersion))
  add(path_594122, "managerName", newJString(managerName))
  add(path_594122, "subscriptionId", newJString(subscriptionId))
  add(path_594122, "certificateName", newJString(certificateName))
  if uploadCertificateRequestrequest != nil:
    body_594124 = uploadCertificateRequestrequest
  result = call_594121.call(path_594122, query_594123, nil, nil, body_594124)

var managersUploadRegistrationCertificate* = Call_ManagersUploadRegistrationCertificate_594111(
    name: "managersUploadRegistrationCertificate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/certificates/{certificateName}",
    validator: validate_ManagersUploadRegistrationCertificate_594112, base: "",
    url: url_ManagersUploadRegistrationCertificate_594113, schemes: {Scheme.Https})
type
  Call_AlertsClear_594125 = ref object of OpenApiRestCall_593438
proc url_AlertsClear_594127(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsClear_594126(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594128 = path.getOrDefault("resourceGroupName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "resourceGroupName", valid_594128
  var valid_594129 = path.getOrDefault("managerName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "managerName", valid_594129
  var valid_594130 = path.getOrDefault("subscriptionId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "subscriptionId", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594131 = query.getOrDefault("api-version")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "api-version", valid_594131
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

proc call*(call_594133: Call_AlertsClear_594125; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clear the alerts.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_AlertsClear_594125; resourceGroupName: string;
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
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  var body_594137 = newJObject()
  add(path_594135, "resourceGroupName", newJString(resourceGroupName))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "managerName", newJString(managerName))
  add(path_594135, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_594137 = request
  result = call_594134.call(path_594135, query_594136, nil, nil, body_594137)

var alertsClear* = Call_AlertsClear_594125(name: "alertsClear",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/clearAlerts",
                                        validator: validate_AlertsClear_594126,
                                        base: "", url: url_AlertsClear_594127,
                                        schemes: {Scheme.Https})
type
  Call_DevicesListByManager_594138 = ref object of OpenApiRestCall_593438
proc url_DevicesListByManager_594140(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesListByManager_594139(path: JsonNode; query: JsonNode;
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
  var valid_594141 = path.getOrDefault("resourceGroupName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "resourceGroupName", valid_594141
  var valid_594142 = path.getOrDefault("managerName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "managerName", valid_594142
  var valid_594143 = path.getOrDefault("subscriptionId")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "subscriptionId", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594144 = query.getOrDefault("api-version")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "api-version", valid_594144
  var valid_594145 = query.getOrDefault("$expand")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "$expand", valid_594145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594146: Call_DevicesListByManager_594138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the devices in a manager.
  ## 
  let valid = call_594146.validator(path, query, header, formData, body)
  let scheme = call_594146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594146.url(scheme.get, call_594146.host, call_594146.base,
                         call_594146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594146, url, valid)

proc call*(call_594147: Call_DevicesListByManager_594138;
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
  var path_594148 = newJObject()
  var query_594149 = newJObject()
  add(path_594148, "resourceGroupName", newJString(resourceGroupName))
  add(query_594149, "api-version", newJString(apiVersion))
  add(query_594149, "$expand", newJString(Expand))
  add(path_594148, "managerName", newJString(managerName))
  add(path_594148, "subscriptionId", newJString(subscriptionId))
  result = call_594147.call(path_594148, query_594149, nil, nil, nil)

var devicesListByManager* = Call_DevicesListByManager_594138(
    name: "devicesListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices",
    validator: validate_DevicesListByManager_594139, base: "",
    url: url_DevicesListByManager_594140, schemes: {Scheme.Https})
type
  Call_DevicesGet_594150 = ref object of OpenApiRestCall_593438
proc url_DevicesGet_594152(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DevicesGet_594151(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594153 = path.getOrDefault("resourceGroupName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "resourceGroupName", valid_594153
  var valid_594154 = path.getOrDefault("managerName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "managerName", valid_594154
  var valid_594155 = path.getOrDefault("subscriptionId")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "subscriptionId", valid_594155
  var valid_594156 = path.getOrDefault("deviceName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "deviceName", valid_594156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594157 = query.getOrDefault("api-version")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "api-version", valid_594157
  var valid_594158 = query.getOrDefault("$expand")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "$expand", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_DevicesGet_594150; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified device name.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_DevicesGet_594150; resourceGroupName: string;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  add(path_594161, "resourceGroupName", newJString(resourceGroupName))
  add(query_594162, "api-version", newJString(apiVersion))
  add(query_594162, "$expand", newJString(Expand))
  add(path_594161, "managerName", newJString(managerName))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  add(path_594161, "deviceName", newJString(deviceName))
  result = call_594160.call(path_594161, query_594162, nil, nil, nil)

var devicesGet* = Call_DevicesGet_594150(name: "devicesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
                                      validator: validate_DevicesGet_594151,
                                      base: "", url: url_DevicesGet_594152,
                                      schemes: {Scheme.Https})
type
  Call_DevicesPatch_594175 = ref object of OpenApiRestCall_593438
proc url_DevicesPatch_594177(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesPatch_594176(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594178 = path.getOrDefault("resourceGroupName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "resourceGroupName", valid_594178
  var valid_594179 = path.getOrDefault("managerName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "managerName", valid_594179
  var valid_594180 = path.getOrDefault("subscriptionId")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "subscriptionId", valid_594180
  var valid_594181 = path.getOrDefault("deviceName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "deviceName", valid_594181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594182 = query.getOrDefault("api-version")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "api-version", valid_594182
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

proc call*(call_594184: Call_DevicesPatch_594175; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches the device.
  ## 
  let valid = call_594184.validator(path, query, header, formData, body)
  let scheme = call_594184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594184.url(scheme.get, call_594184.host, call_594184.base,
                         call_594184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594184, url, valid)

proc call*(call_594185: Call_DevicesPatch_594175; resourceGroupName: string;
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
  var path_594186 = newJObject()
  var query_594187 = newJObject()
  var body_594188 = newJObject()
  add(path_594186, "resourceGroupName", newJString(resourceGroupName))
  add(query_594187, "api-version", newJString(apiVersion))
  add(path_594186, "managerName", newJString(managerName))
  add(path_594186, "subscriptionId", newJString(subscriptionId))
  if devicePatch != nil:
    body_594188 = devicePatch
  add(path_594186, "deviceName", newJString(deviceName))
  result = call_594185.call(path_594186, query_594187, nil, nil, body_594188)

var devicesPatch* = Call_DevicesPatch_594175(name: "devicesPatch",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
    validator: validate_DevicesPatch_594176, base: "", url: url_DevicesPatch_594177,
    schemes: {Scheme.Https})
type
  Call_DevicesDelete_594163 = ref object of OpenApiRestCall_593438
proc url_DevicesDelete_594165(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDelete_594164(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594166 = path.getOrDefault("resourceGroupName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "resourceGroupName", valid_594166
  var valid_594167 = path.getOrDefault("managerName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "managerName", valid_594167
  var valid_594168 = path.getOrDefault("subscriptionId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "subscriptionId", valid_594168
  var valid_594169 = path.getOrDefault("deviceName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "deviceName", valid_594169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594170 = query.getOrDefault("api-version")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "api-version", valid_594170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594171: Call_DevicesDelete_594163; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the device.
  ## 
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_DevicesDelete_594163; resourceGroupName: string;
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
  var path_594173 = newJObject()
  var query_594174 = newJObject()
  add(path_594173, "resourceGroupName", newJString(resourceGroupName))
  add(query_594174, "api-version", newJString(apiVersion))
  add(path_594173, "managerName", newJString(managerName))
  add(path_594173, "subscriptionId", newJString(subscriptionId))
  add(path_594173, "deviceName", newJString(deviceName))
  result = call_594172.call(path_594173, query_594174, nil, nil, nil)

var devicesDelete* = Call_DevicesDelete_594163(name: "devicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
    validator: validate_DevicesDelete_594164, base: "", url: url_DevicesDelete_594165,
    schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdateAlertSettings_594201 = ref object of OpenApiRestCall_593438
proc url_DevicesCreateOrUpdateAlertSettings_594203(protocol: Scheme; host: string;
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

proc validate_DevicesCreateOrUpdateAlertSettings_594202(path: JsonNode;
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
  var valid_594204 = path.getOrDefault("resourceGroupName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "resourceGroupName", valid_594204
  var valid_594205 = path.getOrDefault("managerName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "managerName", valid_594205
  var valid_594206 = path.getOrDefault("subscriptionId")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "subscriptionId", valid_594206
  var valid_594207 = path.getOrDefault("deviceName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "deviceName", valid_594207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594208 = query.getOrDefault("api-version")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "api-version", valid_594208
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

proc call*(call_594210: Call_DevicesCreateOrUpdateAlertSettings_594201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the alert settings
  ## 
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_DevicesCreateOrUpdateAlertSettings_594201;
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
  var path_594212 = newJObject()
  var query_594213 = newJObject()
  var body_594214 = newJObject()
  if alertSettings != nil:
    body_594214 = alertSettings
  add(path_594212, "resourceGroupName", newJString(resourceGroupName))
  add(query_594213, "api-version", newJString(apiVersion))
  add(path_594212, "managerName", newJString(managerName))
  add(path_594212, "subscriptionId", newJString(subscriptionId))
  add(path_594212, "deviceName", newJString(deviceName))
  result = call_594211.call(path_594212, query_594213, nil, nil, body_594214)

var devicesCreateOrUpdateAlertSettings* = Call_DevicesCreateOrUpdateAlertSettings_594201(
    name: "devicesCreateOrUpdateAlertSettings", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/alertSettings/default",
    validator: validate_DevicesCreateOrUpdateAlertSettings_594202, base: "",
    url: url_DevicesCreateOrUpdateAlertSettings_594203, schemes: {Scheme.Https})
type
  Call_DevicesGetAlertSettings_594189 = ref object of OpenApiRestCall_593438
proc url_DevicesGetAlertSettings_594191(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetAlertSettings_594190(path: JsonNode; query: JsonNode;
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
  var valid_594192 = path.getOrDefault("resourceGroupName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "resourceGroupName", valid_594192
  var valid_594193 = path.getOrDefault("managerName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "managerName", valid_594193
  var valid_594194 = path.getOrDefault("subscriptionId")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "subscriptionId", valid_594194
  var valid_594195 = path.getOrDefault("deviceName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "deviceName", valid_594195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594196 = query.getOrDefault("api-version")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "api-version", valid_594196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594197: Call_DevicesGetAlertSettings_594189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the alert settings of the specified device name.
  ## 
  let valid = call_594197.validator(path, query, header, formData, body)
  let scheme = call_594197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594197.url(scheme.get, call_594197.host, call_594197.base,
                         call_594197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594197, url, valid)

proc call*(call_594198: Call_DevicesGetAlertSettings_594189;
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
  var path_594199 = newJObject()
  var query_594200 = newJObject()
  add(path_594199, "resourceGroupName", newJString(resourceGroupName))
  add(query_594200, "api-version", newJString(apiVersion))
  add(path_594199, "managerName", newJString(managerName))
  add(path_594199, "subscriptionId", newJString(subscriptionId))
  add(path_594199, "deviceName", newJString(deviceName))
  result = call_594198.call(path_594199, query_594200, nil, nil, nil)

var devicesGetAlertSettings* = Call_DevicesGetAlertSettings_594189(
    name: "devicesGetAlertSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/alertSettings/default",
    validator: validate_DevicesGetAlertSettings_594190, base: "",
    url: url_DevicesGetAlertSettings_594191, schemes: {Scheme.Https})
type
  Call_BackupScheduleGroupsListByDevice_594215 = ref object of OpenApiRestCall_593438
proc url_BackupScheduleGroupsListByDevice_594217(protocol: Scheme; host: string;
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

proc validate_BackupScheduleGroupsListByDevice_594216(path: JsonNode;
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
  var valid_594218 = path.getOrDefault("resourceGroupName")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "resourceGroupName", valid_594218
  var valid_594219 = path.getOrDefault("managerName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "managerName", valid_594219
  var valid_594220 = path.getOrDefault("subscriptionId")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "subscriptionId", valid_594220
  var valid_594221 = path.getOrDefault("deviceName")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "deviceName", valid_594221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594222 = query.getOrDefault("api-version")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "api-version", valid_594222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594223: Call_BackupScheduleGroupsListByDevice_594215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the backup schedule groups in a device.
  ## 
  let valid = call_594223.validator(path, query, header, formData, body)
  let scheme = call_594223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594223.url(scheme.get, call_594223.host, call_594223.base,
                         call_594223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594223, url, valid)

proc call*(call_594224: Call_BackupScheduleGroupsListByDevice_594215;
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
  var path_594225 = newJObject()
  var query_594226 = newJObject()
  add(path_594225, "resourceGroupName", newJString(resourceGroupName))
  add(query_594226, "api-version", newJString(apiVersion))
  add(path_594225, "managerName", newJString(managerName))
  add(path_594225, "subscriptionId", newJString(subscriptionId))
  add(path_594225, "deviceName", newJString(deviceName))
  result = call_594224.call(path_594225, query_594226, nil, nil, nil)

var backupScheduleGroupsListByDevice* = Call_BackupScheduleGroupsListByDevice_594215(
    name: "backupScheduleGroupsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupScheduleGroups",
    validator: validate_BackupScheduleGroupsListByDevice_594216, base: "",
    url: url_BackupScheduleGroupsListByDevice_594217, schemes: {Scheme.Https})
type
  Call_BackupScheduleGroupsCreateOrUpdate_594240 = ref object of OpenApiRestCall_593438
proc url_BackupScheduleGroupsCreateOrUpdate_594242(protocol: Scheme; host: string;
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

proc validate_BackupScheduleGroupsCreateOrUpdate_594241(path: JsonNode;
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
  var valid_594243 = path.getOrDefault("scheduleGroupName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "scheduleGroupName", valid_594243
  var valid_594244 = path.getOrDefault("resourceGroupName")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "resourceGroupName", valid_594244
  var valid_594245 = path.getOrDefault("managerName")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "managerName", valid_594245
  var valid_594246 = path.getOrDefault("subscriptionId")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "subscriptionId", valid_594246
  var valid_594247 = path.getOrDefault("deviceName")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "deviceName", valid_594247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594248 = query.getOrDefault("api-version")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "api-version", valid_594248
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

proc call*(call_594250: Call_BackupScheduleGroupsCreateOrUpdate_594240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates the backup schedule Group.
  ## 
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_BackupScheduleGroupsCreateOrUpdate_594240;
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
  var path_594252 = newJObject()
  var query_594253 = newJObject()
  var body_594254 = newJObject()
  add(path_594252, "scheduleGroupName", newJString(scheduleGroupName))
  add(path_594252, "resourceGroupName", newJString(resourceGroupName))
  add(query_594253, "api-version", newJString(apiVersion))
  add(path_594252, "managerName", newJString(managerName))
  add(path_594252, "subscriptionId", newJString(subscriptionId))
  add(path_594252, "deviceName", newJString(deviceName))
  if scheduleGroup != nil:
    body_594254 = scheduleGroup
  result = call_594251.call(path_594252, query_594253, nil, nil, body_594254)

var backupScheduleGroupsCreateOrUpdate* = Call_BackupScheduleGroupsCreateOrUpdate_594240(
    name: "backupScheduleGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupScheduleGroups/{scheduleGroupName}",
    validator: validate_BackupScheduleGroupsCreateOrUpdate_594241, base: "",
    url: url_BackupScheduleGroupsCreateOrUpdate_594242, schemes: {Scheme.Https})
type
  Call_BackupScheduleGroupsGet_594227 = ref object of OpenApiRestCall_593438
proc url_BackupScheduleGroupsGet_594229(protocol: Scheme; host: string; base: string;
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

proc validate_BackupScheduleGroupsGet_594228(path: JsonNode; query: JsonNode;
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
  var valid_594230 = path.getOrDefault("resourceGroupName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "resourceGroupName", valid_594230
  var valid_594231 = path.getOrDefault("managerName")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "managerName", valid_594231
  var valid_594232 = path.getOrDefault("subscriptionId")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "subscriptionId", valid_594232
  var valid_594233 = path.getOrDefault("deviceName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "deviceName", valid_594233
  var valid_594234 = path.getOrDefault("scheduleGroupName")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "scheduleGroupName", valid_594234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594235 = query.getOrDefault("api-version")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "api-version", valid_594235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594236: Call_BackupScheduleGroupsGet_594227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified backup schedule group name.
  ## 
  let valid = call_594236.validator(path, query, header, formData, body)
  let scheme = call_594236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594236.url(scheme.get, call_594236.host, call_594236.base,
                         call_594236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594236, url, valid)

proc call*(call_594237: Call_BackupScheduleGroupsGet_594227;
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
  var path_594238 = newJObject()
  var query_594239 = newJObject()
  add(path_594238, "resourceGroupName", newJString(resourceGroupName))
  add(query_594239, "api-version", newJString(apiVersion))
  add(path_594238, "managerName", newJString(managerName))
  add(path_594238, "subscriptionId", newJString(subscriptionId))
  add(path_594238, "deviceName", newJString(deviceName))
  add(path_594238, "scheduleGroupName", newJString(scheduleGroupName))
  result = call_594237.call(path_594238, query_594239, nil, nil, nil)

var backupScheduleGroupsGet* = Call_BackupScheduleGroupsGet_594227(
    name: "backupScheduleGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupScheduleGroups/{scheduleGroupName}",
    validator: validate_BackupScheduleGroupsGet_594228, base: "",
    url: url_BackupScheduleGroupsGet_594229, schemes: {Scheme.Https})
type
  Call_BackupScheduleGroupsDelete_594255 = ref object of OpenApiRestCall_593438
proc url_BackupScheduleGroupsDelete_594257(protocol: Scheme; host: string;
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

proc validate_BackupScheduleGroupsDelete_594256(path: JsonNode; query: JsonNode;
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
  var valid_594258 = path.getOrDefault("resourceGroupName")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "resourceGroupName", valid_594258
  var valid_594259 = path.getOrDefault("managerName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "managerName", valid_594259
  var valid_594260 = path.getOrDefault("subscriptionId")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "subscriptionId", valid_594260
  var valid_594261 = path.getOrDefault("deviceName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "deviceName", valid_594261
  var valid_594262 = path.getOrDefault("scheduleGroupName")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "scheduleGroupName", valid_594262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594263 = query.getOrDefault("api-version")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "api-version", valid_594263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594264: Call_BackupScheduleGroupsDelete_594255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup schedule group.
  ## 
  let valid = call_594264.validator(path, query, header, formData, body)
  let scheme = call_594264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594264.url(scheme.get, call_594264.host, call_594264.base,
                         call_594264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594264, url, valid)

proc call*(call_594265: Call_BackupScheduleGroupsDelete_594255;
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
  var path_594266 = newJObject()
  var query_594267 = newJObject()
  add(path_594266, "resourceGroupName", newJString(resourceGroupName))
  add(query_594267, "api-version", newJString(apiVersion))
  add(path_594266, "managerName", newJString(managerName))
  add(path_594266, "subscriptionId", newJString(subscriptionId))
  add(path_594266, "deviceName", newJString(deviceName))
  add(path_594266, "scheduleGroupName", newJString(scheduleGroupName))
  result = call_594265.call(path_594266, query_594267, nil, nil, nil)

var backupScheduleGroupsDelete* = Call_BackupScheduleGroupsDelete_594255(
    name: "backupScheduleGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupScheduleGroups/{scheduleGroupName}",
    validator: validate_BackupScheduleGroupsDelete_594256, base: "",
    url: url_BackupScheduleGroupsDelete_594257, schemes: {Scheme.Https})
type
  Call_BackupsListByDevice_594268 = ref object of OpenApiRestCall_593438
proc url_BackupsListByDevice_594270(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsListByDevice_594269(path: JsonNode; query: JsonNode;
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
  var valid_594271 = path.getOrDefault("resourceGroupName")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "resourceGroupName", valid_594271
  var valid_594272 = path.getOrDefault("managerName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "managerName", valid_594272
  var valid_594273 = path.getOrDefault("subscriptionId")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "subscriptionId", valid_594273
  var valid_594274 = path.getOrDefault("deviceName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "deviceName", valid_594274
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
  var valid_594275 = query.getOrDefault("api-version")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "api-version", valid_594275
  var valid_594276 = query.getOrDefault("forFailover")
  valid_594276 = validateParameter(valid_594276, JBool, required = false, default = nil)
  if valid_594276 != nil:
    section.add "forFailover", valid_594276
  var valid_594277 = query.getOrDefault("$filter")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "$filter", valid_594277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594278: Call_BackupsListByDevice_594268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the backups in a device. Can be used to get the backups for failover also.
  ## 
  let valid = call_594278.validator(path, query, header, formData, body)
  let scheme = call_594278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594278.url(scheme.get, call_594278.host, call_594278.base,
                         call_594278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594278, url, valid)

proc call*(call_594279: Call_BackupsListByDevice_594268; resourceGroupName: string;
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
  var path_594280 = newJObject()
  var query_594281 = newJObject()
  add(path_594280, "resourceGroupName", newJString(resourceGroupName))
  add(query_594281, "api-version", newJString(apiVersion))
  add(query_594281, "forFailover", newJBool(forFailover))
  add(path_594280, "managerName", newJString(managerName))
  add(path_594280, "subscriptionId", newJString(subscriptionId))
  add(query_594281, "$filter", newJString(Filter))
  add(path_594280, "deviceName", newJString(deviceName))
  result = call_594279.call(path_594280, query_594281, nil, nil, nil)

var backupsListByDevice* = Call_BackupsListByDevice_594268(
    name: "backupsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups",
    validator: validate_BackupsListByDevice_594269, base: "",
    url: url_BackupsListByDevice_594270, schemes: {Scheme.Https})
type
  Call_BackupsDelete_594282 = ref object of OpenApiRestCall_593438
proc url_BackupsDelete_594284(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsDelete_594283(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594285 = path.getOrDefault("resourceGroupName")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "resourceGroupName", valid_594285
  var valid_594286 = path.getOrDefault("managerName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "managerName", valid_594286
  var valid_594287 = path.getOrDefault("subscriptionId")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "subscriptionId", valid_594287
  var valid_594288 = path.getOrDefault("backupName")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "backupName", valid_594288
  var valid_594289 = path.getOrDefault("deviceName")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "deviceName", valid_594289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594290 = query.getOrDefault("api-version")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "api-version", valid_594290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594291: Call_BackupsDelete_594282; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup.
  ## 
  let valid = call_594291.validator(path, query, header, formData, body)
  let scheme = call_594291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594291.url(scheme.get, call_594291.host, call_594291.base,
                         call_594291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594291, url, valid)

proc call*(call_594292: Call_BackupsDelete_594282; resourceGroupName: string;
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
  var path_594293 = newJObject()
  var query_594294 = newJObject()
  add(path_594293, "resourceGroupName", newJString(resourceGroupName))
  add(query_594294, "api-version", newJString(apiVersion))
  add(path_594293, "managerName", newJString(managerName))
  add(path_594293, "subscriptionId", newJString(subscriptionId))
  add(path_594293, "backupName", newJString(backupName))
  add(path_594293, "deviceName", newJString(deviceName))
  result = call_594292.call(path_594293, query_594294, nil, nil, nil)

var backupsDelete* = Call_BackupsDelete_594282(name: "backupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}",
    validator: validate_BackupsDelete_594283, base: "", url: url_BackupsDelete_594284,
    schemes: {Scheme.Https})
type
  Call_BackupsClone_594295 = ref object of OpenApiRestCall_593438
proc url_BackupsClone_594297(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsClone_594296(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594298 = path.getOrDefault("resourceGroupName")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "resourceGroupName", valid_594298
  var valid_594299 = path.getOrDefault("managerName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "managerName", valid_594299
  var valid_594300 = path.getOrDefault("elementName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "elementName", valid_594300
  var valid_594301 = path.getOrDefault("subscriptionId")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "subscriptionId", valid_594301
  var valid_594302 = path.getOrDefault("backupName")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "backupName", valid_594302
  var valid_594303 = path.getOrDefault("deviceName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "deviceName", valid_594303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594304 = query.getOrDefault("api-version")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "api-version", valid_594304
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

proc call*(call_594306: Call_BackupsClone_594295; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clones the given backup element to a new disk or share with given details.
  ## 
  let valid = call_594306.validator(path, query, header, formData, body)
  let scheme = call_594306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594306.url(scheme.get, call_594306.host, call_594306.base,
                         call_594306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594306, url, valid)

proc call*(call_594307: Call_BackupsClone_594295; resourceGroupName: string;
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
  var path_594308 = newJObject()
  var query_594309 = newJObject()
  var body_594310 = newJObject()
  add(path_594308, "resourceGroupName", newJString(resourceGroupName))
  add(query_594309, "api-version", newJString(apiVersion))
  add(path_594308, "managerName", newJString(managerName))
  add(path_594308, "elementName", newJString(elementName))
  add(path_594308, "subscriptionId", newJString(subscriptionId))
  add(path_594308, "backupName", newJString(backupName))
  if cloneRequest != nil:
    body_594310 = cloneRequest
  add(path_594308, "deviceName", newJString(deviceName))
  result = call_594307.call(path_594308, query_594309, nil, nil, body_594310)

var backupsClone* = Call_BackupsClone_594295(name: "backupsClone",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}/elements/{elementName}/clone",
    validator: validate_BackupsClone_594296, base: "", url: url_BackupsClone_594297,
    schemes: {Scheme.Https})
type
  Call_ChapSettingsListByDevice_594311 = ref object of OpenApiRestCall_593438
proc url_ChapSettingsListByDevice_594313(protocol: Scheme; host: string;
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

proc validate_ChapSettingsListByDevice_594312(path: JsonNode; query: JsonNode;
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
  var valid_594314 = path.getOrDefault("resourceGroupName")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "resourceGroupName", valid_594314
  var valid_594315 = path.getOrDefault("managerName")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "managerName", valid_594315
  var valid_594316 = path.getOrDefault("subscriptionId")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "subscriptionId", valid_594316
  var valid_594317 = path.getOrDefault("deviceName")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "deviceName", valid_594317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594318 = query.getOrDefault("api-version")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "api-version", valid_594318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594319: Call_ChapSettingsListByDevice_594311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the chap settings in a device.
  ## 
  let valid = call_594319.validator(path, query, header, formData, body)
  let scheme = call_594319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594319.url(scheme.get, call_594319.host, call_594319.base,
                         call_594319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594319, url, valid)

proc call*(call_594320: Call_ChapSettingsListByDevice_594311;
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
  var path_594321 = newJObject()
  var query_594322 = newJObject()
  add(path_594321, "resourceGroupName", newJString(resourceGroupName))
  add(query_594322, "api-version", newJString(apiVersion))
  add(path_594321, "managerName", newJString(managerName))
  add(path_594321, "subscriptionId", newJString(subscriptionId))
  add(path_594321, "deviceName", newJString(deviceName))
  result = call_594320.call(path_594321, query_594322, nil, nil, nil)

var chapSettingsListByDevice* = Call_ChapSettingsListByDevice_594311(
    name: "chapSettingsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/chapSettings",
    validator: validate_ChapSettingsListByDevice_594312, base: "",
    url: url_ChapSettingsListByDevice_594313, schemes: {Scheme.Https})
type
  Call_ChapSettingsCreateOrUpdate_594336 = ref object of OpenApiRestCall_593438
proc url_ChapSettingsCreateOrUpdate_594338(protocol: Scheme; host: string;
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

proc validate_ChapSettingsCreateOrUpdate_594337(path: JsonNode; query: JsonNode;
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
  var valid_594339 = path.getOrDefault("resourceGroupName")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "resourceGroupName", valid_594339
  var valid_594340 = path.getOrDefault("managerName")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "managerName", valid_594340
  var valid_594341 = path.getOrDefault("subscriptionId")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "subscriptionId", valid_594341
  var valid_594342 = path.getOrDefault("chapUserName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "chapUserName", valid_594342
  var valid_594343 = path.getOrDefault("deviceName")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "deviceName", valid_594343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594344 = query.getOrDefault("api-version")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "api-version", valid_594344
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

proc call*(call_594346: Call_ChapSettingsCreateOrUpdate_594336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the chap setting.
  ## 
  let valid = call_594346.validator(path, query, header, formData, body)
  let scheme = call_594346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594346.url(scheme.get, call_594346.host, call_594346.base,
                         call_594346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594346, url, valid)

proc call*(call_594347: Call_ChapSettingsCreateOrUpdate_594336;
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
  var path_594348 = newJObject()
  var query_594349 = newJObject()
  var body_594350 = newJObject()
  add(path_594348, "resourceGroupName", newJString(resourceGroupName))
  add(query_594349, "api-version", newJString(apiVersion))
  add(path_594348, "managerName", newJString(managerName))
  if chapSetting != nil:
    body_594350 = chapSetting
  add(path_594348, "subscriptionId", newJString(subscriptionId))
  add(path_594348, "chapUserName", newJString(chapUserName))
  add(path_594348, "deviceName", newJString(deviceName))
  result = call_594347.call(path_594348, query_594349, nil, nil, body_594350)

var chapSettingsCreateOrUpdate* = Call_ChapSettingsCreateOrUpdate_594336(
    name: "chapSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/chapSettings/{chapUserName}",
    validator: validate_ChapSettingsCreateOrUpdate_594337, base: "",
    url: url_ChapSettingsCreateOrUpdate_594338, schemes: {Scheme.Https})
type
  Call_ChapSettingsGet_594323 = ref object of OpenApiRestCall_593438
proc url_ChapSettingsGet_594325(protocol: Scheme; host: string; base: string;
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

proc validate_ChapSettingsGet_594324(path: JsonNode; query: JsonNode;
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
  var valid_594326 = path.getOrDefault("resourceGroupName")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "resourceGroupName", valid_594326
  var valid_594327 = path.getOrDefault("managerName")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "managerName", valid_594327
  var valid_594328 = path.getOrDefault("subscriptionId")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "subscriptionId", valid_594328
  var valid_594329 = path.getOrDefault("chapUserName")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "chapUserName", valid_594329
  var valid_594330 = path.getOrDefault("deviceName")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "deviceName", valid_594330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594331 = query.getOrDefault("api-version")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "api-version", valid_594331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594332: Call_ChapSettingsGet_594323; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified chap setting name.
  ## 
  let valid = call_594332.validator(path, query, header, formData, body)
  let scheme = call_594332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594332.url(scheme.get, call_594332.host, call_594332.base,
                         call_594332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594332, url, valid)

proc call*(call_594333: Call_ChapSettingsGet_594323; resourceGroupName: string;
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
  var path_594334 = newJObject()
  var query_594335 = newJObject()
  add(path_594334, "resourceGroupName", newJString(resourceGroupName))
  add(query_594335, "api-version", newJString(apiVersion))
  add(path_594334, "managerName", newJString(managerName))
  add(path_594334, "subscriptionId", newJString(subscriptionId))
  add(path_594334, "chapUserName", newJString(chapUserName))
  add(path_594334, "deviceName", newJString(deviceName))
  result = call_594333.call(path_594334, query_594335, nil, nil, nil)

var chapSettingsGet* = Call_ChapSettingsGet_594323(name: "chapSettingsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/chapSettings/{chapUserName}",
    validator: validate_ChapSettingsGet_594324, base: "", url: url_ChapSettingsGet_594325,
    schemes: {Scheme.Https})
type
  Call_ChapSettingsDelete_594351 = ref object of OpenApiRestCall_593438
proc url_ChapSettingsDelete_594353(protocol: Scheme; host: string; base: string;
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

proc validate_ChapSettingsDelete_594352(path: JsonNode; query: JsonNode;
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
  var valid_594354 = path.getOrDefault("resourceGroupName")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "resourceGroupName", valid_594354
  var valid_594355 = path.getOrDefault("managerName")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "managerName", valid_594355
  var valid_594356 = path.getOrDefault("subscriptionId")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "subscriptionId", valid_594356
  var valid_594357 = path.getOrDefault("chapUserName")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "chapUserName", valid_594357
  var valid_594358 = path.getOrDefault("deviceName")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "deviceName", valid_594358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594359 = query.getOrDefault("api-version")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "api-version", valid_594359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594360: Call_ChapSettingsDelete_594351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the chap setting.
  ## 
  let valid = call_594360.validator(path, query, header, formData, body)
  let scheme = call_594360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594360.url(scheme.get, call_594360.host, call_594360.base,
                         call_594360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594360, url, valid)

proc call*(call_594361: Call_ChapSettingsDelete_594351; resourceGroupName: string;
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
  var path_594362 = newJObject()
  var query_594363 = newJObject()
  add(path_594362, "resourceGroupName", newJString(resourceGroupName))
  add(query_594363, "api-version", newJString(apiVersion))
  add(path_594362, "managerName", newJString(managerName))
  add(path_594362, "subscriptionId", newJString(subscriptionId))
  add(path_594362, "chapUserName", newJString(chapUserName))
  add(path_594362, "deviceName", newJString(deviceName))
  result = call_594361.call(path_594362, query_594363, nil, nil, nil)

var chapSettingsDelete* = Call_ChapSettingsDelete_594351(
    name: "chapSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/chapSettings/{chapUserName}",
    validator: validate_ChapSettingsDelete_594352, base: "",
    url: url_ChapSettingsDelete_594353, schemes: {Scheme.Https})
type
  Call_DevicesDeactivate_594364 = ref object of OpenApiRestCall_593438
proc url_DevicesDeactivate_594366(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDeactivate_594365(path: JsonNode; query: JsonNode;
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
  var valid_594367 = path.getOrDefault("resourceGroupName")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "resourceGroupName", valid_594367
  var valid_594368 = path.getOrDefault("managerName")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "managerName", valid_594368
  var valid_594369 = path.getOrDefault("subscriptionId")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "subscriptionId", valid_594369
  var valid_594370 = path.getOrDefault("deviceName")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "deviceName", valid_594370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594371 = query.getOrDefault("api-version")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "api-version", valid_594371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594372: Call_DevicesDeactivate_594364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deactivates the device.
  ## 
  let valid = call_594372.validator(path, query, header, formData, body)
  let scheme = call_594372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594372.url(scheme.get, call_594372.host, call_594372.base,
                         call_594372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594372, url, valid)

proc call*(call_594373: Call_DevicesDeactivate_594364; resourceGroupName: string;
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
  var path_594374 = newJObject()
  var query_594375 = newJObject()
  add(path_594374, "resourceGroupName", newJString(resourceGroupName))
  add(query_594375, "api-version", newJString(apiVersion))
  add(path_594374, "managerName", newJString(managerName))
  add(path_594374, "subscriptionId", newJString(subscriptionId))
  add(path_594374, "deviceName", newJString(deviceName))
  result = call_594373.call(path_594374, query_594375, nil, nil, nil)

var devicesDeactivate* = Call_DevicesDeactivate_594364(name: "devicesDeactivate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/deactivate",
    validator: validate_DevicesDeactivate_594365, base: "",
    url: url_DevicesDeactivate_594366, schemes: {Scheme.Https})
type
  Call_IscsiDisksListByDevice_594376 = ref object of OpenApiRestCall_593438
proc url_IscsiDisksListByDevice_594378(protocol: Scheme; host: string; base: string;
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

proc validate_IscsiDisksListByDevice_594377(path: JsonNode; query: JsonNode;
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
  var valid_594379 = path.getOrDefault("resourceGroupName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "resourceGroupName", valid_594379
  var valid_594380 = path.getOrDefault("managerName")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "managerName", valid_594380
  var valid_594381 = path.getOrDefault("subscriptionId")
  valid_594381 = validateParameter(valid_594381, JString, required = true,
                                 default = nil)
  if valid_594381 != nil:
    section.add "subscriptionId", valid_594381
  var valid_594382 = path.getOrDefault("deviceName")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "deviceName", valid_594382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594383 = query.getOrDefault("api-version")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "api-version", valid_594383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594384: Call_IscsiDisksListByDevice_594376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the iSCSI disks in a device.
  ## 
  let valid = call_594384.validator(path, query, header, formData, body)
  let scheme = call_594384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594384.url(scheme.get, call_594384.host, call_594384.base,
                         call_594384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594384, url, valid)

proc call*(call_594385: Call_IscsiDisksListByDevice_594376;
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
  var path_594386 = newJObject()
  var query_594387 = newJObject()
  add(path_594386, "resourceGroupName", newJString(resourceGroupName))
  add(query_594387, "api-version", newJString(apiVersion))
  add(path_594386, "managerName", newJString(managerName))
  add(path_594386, "subscriptionId", newJString(subscriptionId))
  add(path_594386, "deviceName", newJString(deviceName))
  result = call_594385.call(path_594386, query_594387, nil, nil, nil)

var iscsiDisksListByDevice* = Call_IscsiDisksListByDevice_594376(
    name: "iscsiDisksListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/disks",
    validator: validate_IscsiDisksListByDevice_594377, base: "",
    url: url_IscsiDisksListByDevice_594378, schemes: {Scheme.Https})
type
  Call_DevicesDownloadUpdates_594388 = ref object of OpenApiRestCall_593438
proc url_DevicesDownloadUpdates_594390(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDownloadUpdates_594389(path: JsonNode; query: JsonNode;
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
  var valid_594391 = path.getOrDefault("resourceGroupName")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "resourceGroupName", valid_594391
  var valid_594392 = path.getOrDefault("managerName")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "managerName", valid_594392
  var valid_594393 = path.getOrDefault("subscriptionId")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "subscriptionId", valid_594393
  var valid_594394 = path.getOrDefault("deviceName")
  valid_594394 = validateParameter(valid_594394, JString, required = true,
                                 default = nil)
  if valid_594394 != nil:
    section.add "deviceName", valid_594394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594395 = query.getOrDefault("api-version")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "api-version", valid_594395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594396: Call_DevicesDownloadUpdates_594388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads updates on the device.
  ## 
  let valid = call_594396.validator(path, query, header, formData, body)
  let scheme = call_594396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594396.url(scheme.get, call_594396.host, call_594396.base,
                         call_594396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594396, url, valid)

proc call*(call_594397: Call_DevicesDownloadUpdates_594388;
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
  var path_594398 = newJObject()
  var query_594399 = newJObject()
  add(path_594398, "resourceGroupName", newJString(resourceGroupName))
  add(query_594399, "api-version", newJString(apiVersion))
  add(path_594398, "managerName", newJString(managerName))
  add(path_594398, "subscriptionId", newJString(subscriptionId))
  add(path_594398, "deviceName", newJString(deviceName))
  result = call_594397.call(path_594398, query_594399, nil, nil, nil)

var devicesDownloadUpdates* = Call_DevicesDownloadUpdates_594388(
    name: "devicesDownloadUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/download",
    validator: validate_DevicesDownloadUpdates_594389, base: "",
    url: url_DevicesDownloadUpdates_594390, schemes: {Scheme.Https})
type
  Call_DevicesFailover_594400 = ref object of OpenApiRestCall_593438
proc url_DevicesFailover_594402(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesFailover_594401(path: JsonNode; query: JsonNode;
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
  var valid_594403 = path.getOrDefault("resourceGroupName")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "resourceGroupName", valid_594403
  var valid_594404 = path.getOrDefault("managerName")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "managerName", valid_594404
  var valid_594405 = path.getOrDefault("subscriptionId")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "subscriptionId", valid_594405
  var valid_594406 = path.getOrDefault("deviceName")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "deviceName", valid_594406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594407 = query.getOrDefault("api-version")
  valid_594407 = validateParameter(valid_594407, JString, required = true,
                                 default = nil)
  if valid_594407 != nil:
    section.add "api-version", valid_594407
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

proc call*(call_594409: Call_DevicesFailover_594400; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fails over the device to another device.
  ## 
  let valid = call_594409.validator(path, query, header, formData, body)
  let scheme = call_594409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594409.url(scheme.get, call_594409.host, call_594409.base,
                         call_594409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594409, url, valid)

proc call*(call_594410: Call_DevicesFailover_594400; resourceGroupName: string;
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
  var path_594411 = newJObject()
  var query_594412 = newJObject()
  var body_594413 = newJObject()
  add(path_594411, "resourceGroupName", newJString(resourceGroupName))
  add(query_594412, "api-version", newJString(apiVersion))
  add(path_594411, "managerName", newJString(managerName))
  if failoverRequest != nil:
    body_594413 = failoverRequest
  add(path_594411, "subscriptionId", newJString(subscriptionId))
  add(path_594411, "deviceName", newJString(deviceName))
  result = call_594410.call(path_594411, query_594412, nil, nil, body_594413)

var devicesFailover* = Call_DevicesFailover_594400(name: "devicesFailover",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/failover",
    validator: validate_DevicesFailover_594401, base: "", url: url_DevicesFailover_594402,
    schemes: {Scheme.Https})
type
  Call_DevicesListFailoverTarget_594414 = ref object of OpenApiRestCall_593438
proc url_DevicesListFailoverTarget_594416(protocol: Scheme; host: string;
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

proc validate_DevicesListFailoverTarget_594415(path: JsonNode; query: JsonNode;
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
  var valid_594417 = path.getOrDefault("resourceGroupName")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "resourceGroupName", valid_594417
  var valid_594418 = path.getOrDefault("managerName")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "managerName", valid_594418
  var valid_594419 = path.getOrDefault("subscriptionId")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "subscriptionId", valid_594419
  var valid_594420 = path.getOrDefault("deviceName")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = nil)
  if valid_594420 != nil:
    section.add "deviceName", valid_594420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594421 = query.getOrDefault("api-version")
  valid_594421 = validateParameter(valid_594421, JString, required = true,
                                 default = nil)
  if valid_594421 != nil:
    section.add "api-version", valid_594421
  var valid_594422 = query.getOrDefault("$expand")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "$expand", valid_594422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594423: Call_DevicesListFailoverTarget_594414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the devices which can be used as failover targets for the given device.
  ## 
  let valid = call_594423.validator(path, query, header, formData, body)
  let scheme = call_594423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594423.url(scheme.get, call_594423.host, call_594423.base,
                         call_594423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594423, url, valid)

proc call*(call_594424: Call_DevicesListFailoverTarget_594414;
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
  var path_594425 = newJObject()
  var query_594426 = newJObject()
  add(path_594425, "resourceGroupName", newJString(resourceGroupName))
  add(query_594426, "api-version", newJString(apiVersion))
  add(query_594426, "$expand", newJString(Expand))
  add(path_594425, "managerName", newJString(managerName))
  add(path_594425, "subscriptionId", newJString(subscriptionId))
  add(path_594425, "deviceName", newJString(deviceName))
  result = call_594424.call(path_594425, query_594426, nil, nil, nil)

var devicesListFailoverTarget* = Call_DevicesListFailoverTarget_594414(
    name: "devicesListFailoverTarget", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/failoverTargets",
    validator: validate_DevicesListFailoverTarget_594415, base: "",
    url: url_DevicesListFailoverTarget_594416, schemes: {Scheme.Https})
type
  Call_FileServersListByDevice_594427 = ref object of OpenApiRestCall_593438
proc url_FileServersListByDevice_594429(protocol: Scheme; host: string; base: string;
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

proc validate_FileServersListByDevice_594428(path: JsonNode; query: JsonNode;
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
  var valid_594430 = path.getOrDefault("resourceGroupName")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "resourceGroupName", valid_594430
  var valid_594431 = path.getOrDefault("managerName")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "managerName", valid_594431
  var valid_594432 = path.getOrDefault("subscriptionId")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "subscriptionId", valid_594432
  var valid_594433 = path.getOrDefault("deviceName")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "deviceName", valid_594433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594434 = query.getOrDefault("api-version")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "api-version", valid_594434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594435: Call_FileServersListByDevice_594427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the file servers in a device.
  ## 
  let valid = call_594435.validator(path, query, header, formData, body)
  let scheme = call_594435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594435.url(scheme.get, call_594435.host, call_594435.base,
                         call_594435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594435, url, valid)

proc call*(call_594436: Call_FileServersListByDevice_594427;
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
  var path_594437 = newJObject()
  var query_594438 = newJObject()
  add(path_594437, "resourceGroupName", newJString(resourceGroupName))
  add(query_594438, "api-version", newJString(apiVersion))
  add(path_594437, "managerName", newJString(managerName))
  add(path_594437, "subscriptionId", newJString(subscriptionId))
  add(path_594437, "deviceName", newJString(deviceName))
  result = call_594436.call(path_594437, query_594438, nil, nil, nil)

var fileServersListByDevice* = Call_FileServersListByDevice_594427(
    name: "fileServersListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers",
    validator: validate_FileServersListByDevice_594428, base: "",
    url: url_FileServersListByDevice_594429, schemes: {Scheme.Https})
type
  Call_FileServersCreateOrUpdate_594452 = ref object of OpenApiRestCall_593438
proc url_FileServersCreateOrUpdate_594454(protocol: Scheme; host: string;
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

proc validate_FileServersCreateOrUpdate_594453(path: JsonNode; query: JsonNode;
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
  var valid_594455 = path.getOrDefault("resourceGroupName")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "resourceGroupName", valid_594455
  var valid_594456 = path.getOrDefault("managerName")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "managerName", valid_594456
  var valid_594457 = path.getOrDefault("subscriptionId")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = nil)
  if valid_594457 != nil:
    section.add "subscriptionId", valid_594457
  var valid_594458 = path.getOrDefault("fileServerName")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "fileServerName", valid_594458
  var valid_594459 = path.getOrDefault("deviceName")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "deviceName", valid_594459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594460 = query.getOrDefault("api-version")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "api-version", valid_594460
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

proc call*(call_594462: Call_FileServersCreateOrUpdate_594452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the file server.
  ## 
  let valid = call_594462.validator(path, query, header, formData, body)
  let scheme = call_594462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594462.url(scheme.get, call_594462.host, call_594462.base,
                         call_594462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594462, url, valid)

proc call*(call_594463: Call_FileServersCreateOrUpdate_594452;
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
  var path_594464 = newJObject()
  var query_594465 = newJObject()
  var body_594466 = newJObject()
  add(path_594464, "resourceGroupName", newJString(resourceGroupName))
  add(query_594465, "api-version", newJString(apiVersion))
  add(path_594464, "managerName", newJString(managerName))
  add(path_594464, "subscriptionId", newJString(subscriptionId))
  add(path_594464, "fileServerName", newJString(fileServerName))
  if fileServer != nil:
    body_594466 = fileServer
  add(path_594464, "deviceName", newJString(deviceName))
  result = call_594463.call(path_594464, query_594465, nil, nil, body_594466)

var fileServersCreateOrUpdate* = Call_FileServersCreateOrUpdate_594452(
    name: "fileServersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}",
    validator: validate_FileServersCreateOrUpdate_594453, base: "",
    url: url_FileServersCreateOrUpdate_594454, schemes: {Scheme.Https})
type
  Call_FileServersGet_594439 = ref object of OpenApiRestCall_593438
proc url_FileServersGet_594441(protocol: Scheme; host: string; base: string;
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

proc validate_FileServersGet_594440(path: JsonNode; query: JsonNode;
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
  var valid_594442 = path.getOrDefault("resourceGroupName")
  valid_594442 = validateParameter(valid_594442, JString, required = true,
                                 default = nil)
  if valid_594442 != nil:
    section.add "resourceGroupName", valid_594442
  var valid_594443 = path.getOrDefault("managerName")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "managerName", valid_594443
  var valid_594444 = path.getOrDefault("subscriptionId")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "subscriptionId", valid_594444
  var valid_594445 = path.getOrDefault("fileServerName")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "fileServerName", valid_594445
  var valid_594446 = path.getOrDefault("deviceName")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "deviceName", valid_594446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594447 = query.getOrDefault("api-version")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "api-version", valid_594447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594448: Call_FileServersGet_594439; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified file server name.
  ## 
  let valid = call_594448.validator(path, query, header, formData, body)
  let scheme = call_594448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594448.url(scheme.get, call_594448.host, call_594448.base,
                         call_594448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594448, url, valid)

proc call*(call_594449: Call_FileServersGet_594439; resourceGroupName: string;
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
  var path_594450 = newJObject()
  var query_594451 = newJObject()
  add(path_594450, "resourceGroupName", newJString(resourceGroupName))
  add(query_594451, "api-version", newJString(apiVersion))
  add(path_594450, "managerName", newJString(managerName))
  add(path_594450, "subscriptionId", newJString(subscriptionId))
  add(path_594450, "fileServerName", newJString(fileServerName))
  add(path_594450, "deviceName", newJString(deviceName))
  result = call_594449.call(path_594450, query_594451, nil, nil, nil)

var fileServersGet* = Call_FileServersGet_594439(name: "fileServersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}",
    validator: validate_FileServersGet_594440, base: "", url: url_FileServersGet_594441,
    schemes: {Scheme.Https})
type
  Call_FileServersDelete_594467 = ref object of OpenApiRestCall_593438
proc url_FileServersDelete_594469(protocol: Scheme; host: string; base: string;
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

proc validate_FileServersDelete_594468(path: JsonNode; query: JsonNode;
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
  var valid_594470 = path.getOrDefault("resourceGroupName")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "resourceGroupName", valid_594470
  var valid_594471 = path.getOrDefault("managerName")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "managerName", valid_594471
  var valid_594472 = path.getOrDefault("subscriptionId")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "subscriptionId", valid_594472
  var valid_594473 = path.getOrDefault("fileServerName")
  valid_594473 = validateParameter(valid_594473, JString, required = true,
                                 default = nil)
  if valid_594473 != nil:
    section.add "fileServerName", valid_594473
  var valid_594474 = path.getOrDefault("deviceName")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "deviceName", valid_594474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594475 = query.getOrDefault("api-version")
  valid_594475 = validateParameter(valid_594475, JString, required = true,
                                 default = nil)
  if valid_594475 != nil:
    section.add "api-version", valid_594475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594476: Call_FileServersDelete_594467; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the file server.
  ## 
  let valid = call_594476.validator(path, query, header, formData, body)
  let scheme = call_594476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594476.url(scheme.get, call_594476.host, call_594476.base,
                         call_594476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594476, url, valid)

proc call*(call_594477: Call_FileServersDelete_594467; resourceGroupName: string;
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
  var path_594478 = newJObject()
  var query_594479 = newJObject()
  add(path_594478, "resourceGroupName", newJString(resourceGroupName))
  add(query_594479, "api-version", newJString(apiVersion))
  add(path_594478, "managerName", newJString(managerName))
  add(path_594478, "subscriptionId", newJString(subscriptionId))
  add(path_594478, "fileServerName", newJString(fileServerName))
  add(path_594478, "deviceName", newJString(deviceName))
  result = call_594477.call(path_594478, query_594479, nil, nil, nil)

var fileServersDelete* = Call_FileServersDelete_594467(name: "fileServersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}",
    validator: validate_FileServersDelete_594468, base: "",
    url: url_FileServersDelete_594469, schemes: {Scheme.Https})
type
  Call_FileServersBackupNow_594480 = ref object of OpenApiRestCall_593438
proc url_FileServersBackupNow_594482(protocol: Scheme; host: string; base: string;
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

proc validate_FileServersBackupNow_594481(path: JsonNode; query: JsonNode;
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
  var valid_594483 = path.getOrDefault("resourceGroupName")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "resourceGroupName", valid_594483
  var valid_594484 = path.getOrDefault("managerName")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = nil)
  if valid_594484 != nil:
    section.add "managerName", valid_594484
  var valid_594485 = path.getOrDefault("subscriptionId")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "subscriptionId", valid_594485
  var valid_594486 = path.getOrDefault("fileServerName")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "fileServerName", valid_594486
  var valid_594487 = path.getOrDefault("deviceName")
  valid_594487 = validateParameter(valid_594487, JString, required = true,
                                 default = nil)
  if valid_594487 != nil:
    section.add "deviceName", valid_594487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594488 = query.getOrDefault("api-version")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "api-version", valid_594488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594489: Call_FileServersBackupNow_594480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup the file server now.
  ## 
  let valid = call_594489.validator(path, query, header, formData, body)
  let scheme = call_594489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594489.url(scheme.get, call_594489.host, call_594489.base,
                         call_594489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594489, url, valid)

proc call*(call_594490: Call_FileServersBackupNow_594480;
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
  var path_594491 = newJObject()
  var query_594492 = newJObject()
  add(path_594491, "resourceGroupName", newJString(resourceGroupName))
  add(query_594492, "api-version", newJString(apiVersion))
  add(path_594491, "managerName", newJString(managerName))
  add(path_594491, "subscriptionId", newJString(subscriptionId))
  add(path_594491, "fileServerName", newJString(fileServerName))
  add(path_594491, "deviceName", newJString(deviceName))
  result = call_594490.call(path_594491, query_594492, nil, nil, nil)

var fileServersBackupNow* = Call_FileServersBackupNow_594480(
    name: "fileServersBackupNow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/backup",
    validator: validate_FileServersBackupNow_594481, base: "",
    url: url_FileServersBackupNow_594482, schemes: {Scheme.Https})
type
  Call_FileServersListMetrics_594493 = ref object of OpenApiRestCall_593438
proc url_FileServersListMetrics_594495(protocol: Scheme; host: string; base: string;
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

proc validate_FileServersListMetrics_594494(path: JsonNode; query: JsonNode;
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
  var valid_594496 = path.getOrDefault("resourceGroupName")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "resourceGroupName", valid_594496
  var valid_594497 = path.getOrDefault("managerName")
  valid_594497 = validateParameter(valid_594497, JString, required = true,
                                 default = nil)
  if valid_594497 != nil:
    section.add "managerName", valid_594497
  var valid_594498 = path.getOrDefault("subscriptionId")
  valid_594498 = validateParameter(valid_594498, JString, required = true,
                                 default = nil)
  if valid_594498 != nil:
    section.add "subscriptionId", valid_594498
  var valid_594499 = path.getOrDefault("fileServerName")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "fileServerName", valid_594499
  var valid_594500 = path.getOrDefault("deviceName")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "deviceName", valid_594500
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594501 = query.getOrDefault("api-version")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "api-version", valid_594501
  var valid_594502 = query.getOrDefault("$filter")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = nil)
  if valid_594502 != nil:
    section.add "$filter", valid_594502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594503: Call_FileServersListMetrics_594493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the file server metrics.
  ## 
  let valid = call_594503.validator(path, query, header, formData, body)
  let scheme = call_594503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594503.url(scheme.get, call_594503.host, call_594503.base,
                         call_594503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594503, url, valid)

proc call*(call_594504: Call_FileServersListMetrics_594493;
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
  var path_594505 = newJObject()
  var query_594506 = newJObject()
  add(path_594505, "resourceGroupName", newJString(resourceGroupName))
  add(query_594506, "api-version", newJString(apiVersion))
  add(path_594505, "managerName", newJString(managerName))
  add(path_594505, "subscriptionId", newJString(subscriptionId))
  add(path_594505, "fileServerName", newJString(fileServerName))
  add(query_594506, "$filter", newJString(Filter))
  add(path_594505, "deviceName", newJString(deviceName))
  result = call_594504.call(path_594505, query_594506, nil, nil, nil)

var fileServersListMetrics* = Call_FileServersListMetrics_594493(
    name: "fileServersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/metrics",
    validator: validate_FileServersListMetrics_594494, base: "",
    url: url_FileServersListMetrics_594495, schemes: {Scheme.Https})
type
  Call_FileServersListMetricDefinition_594507 = ref object of OpenApiRestCall_593438
proc url_FileServersListMetricDefinition_594509(protocol: Scheme; host: string;
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

proc validate_FileServersListMetricDefinition_594508(path: JsonNode;
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
  var valid_594510 = path.getOrDefault("resourceGroupName")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "resourceGroupName", valid_594510
  var valid_594511 = path.getOrDefault("managerName")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "managerName", valid_594511
  var valid_594512 = path.getOrDefault("subscriptionId")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "subscriptionId", valid_594512
  var valid_594513 = path.getOrDefault("fileServerName")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "fileServerName", valid_594513
  var valid_594514 = path.getOrDefault("deviceName")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "deviceName", valid_594514
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594515 = query.getOrDefault("api-version")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = nil)
  if valid_594515 != nil:
    section.add "api-version", valid_594515
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594516: Call_FileServersListMetricDefinition_594507;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions of all metrics aggregated at the file server.
  ## 
  let valid = call_594516.validator(path, query, header, formData, body)
  let scheme = call_594516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594516.url(scheme.get, call_594516.host, call_594516.base,
                         call_594516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594516, url, valid)

proc call*(call_594517: Call_FileServersListMetricDefinition_594507;
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
  var path_594518 = newJObject()
  var query_594519 = newJObject()
  add(path_594518, "resourceGroupName", newJString(resourceGroupName))
  add(query_594519, "api-version", newJString(apiVersion))
  add(path_594518, "managerName", newJString(managerName))
  add(path_594518, "subscriptionId", newJString(subscriptionId))
  add(path_594518, "fileServerName", newJString(fileServerName))
  add(path_594518, "deviceName", newJString(deviceName))
  result = call_594517.call(path_594518, query_594519, nil, nil, nil)

var fileServersListMetricDefinition* = Call_FileServersListMetricDefinition_594507(
    name: "fileServersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/metricsDefinitions",
    validator: validate_FileServersListMetricDefinition_594508, base: "",
    url: url_FileServersListMetricDefinition_594509, schemes: {Scheme.Https})
type
  Call_FileSharesListByFileServer_594520 = ref object of OpenApiRestCall_593438
proc url_FileSharesListByFileServer_594522(protocol: Scheme; host: string;
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

proc validate_FileSharesListByFileServer_594521(path: JsonNode; query: JsonNode;
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
  var valid_594523 = path.getOrDefault("resourceGroupName")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "resourceGroupName", valid_594523
  var valid_594524 = path.getOrDefault("managerName")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "managerName", valid_594524
  var valid_594525 = path.getOrDefault("subscriptionId")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "subscriptionId", valid_594525
  var valid_594526 = path.getOrDefault("fileServerName")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "fileServerName", valid_594526
  var valid_594527 = path.getOrDefault("deviceName")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "deviceName", valid_594527
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594528 = query.getOrDefault("api-version")
  valid_594528 = validateParameter(valid_594528, JString, required = true,
                                 default = nil)
  if valid_594528 != nil:
    section.add "api-version", valid_594528
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594529: Call_FileSharesListByFileServer_594520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the file shares in a file server.
  ## 
  let valid = call_594529.validator(path, query, header, formData, body)
  let scheme = call_594529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594529.url(scheme.get, call_594529.host, call_594529.base,
                         call_594529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594529, url, valid)

proc call*(call_594530: Call_FileSharesListByFileServer_594520;
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
  var path_594531 = newJObject()
  var query_594532 = newJObject()
  add(path_594531, "resourceGroupName", newJString(resourceGroupName))
  add(query_594532, "api-version", newJString(apiVersion))
  add(path_594531, "managerName", newJString(managerName))
  add(path_594531, "subscriptionId", newJString(subscriptionId))
  add(path_594531, "fileServerName", newJString(fileServerName))
  add(path_594531, "deviceName", newJString(deviceName))
  result = call_594530.call(path_594531, query_594532, nil, nil, nil)

var fileSharesListByFileServer* = Call_FileSharesListByFileServer_594520(
    name: "fileSharesListByFileServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares",
    validator: validate_FileSharesListByFileServer_594521, base: "",
    url: url_FileSharesListByFileServer_594522, schemes: {Scheme.Https})
type
  Call_FileSharesCreateOrUpdate_594547 = ref object of OpenApiRestCall_593438
proc url_FileSharesCreateOrUpdate_594549(protocol: Scheme; host: string;
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

proc validate_FileSharesCreateOrUpdate_594548(path: JsonNode; query: JsonNode;
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
  var valid_594550 = path.getOrDefault("resourceGroupName")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "resourceGroupName", valid_594550
  var valid_594551 = path.getOrDefault("managerName")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "managerName", valid_594551
  var valid_594552 = path.getOrDefault("subscriptionId")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "subscriptionId", valid_594552
  var valid_594553 = path.getOrDefault("shareName")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "shareName", valid_594553
  var valid_594554 = path.getOrDefault("fileServerName")
  valid_594554 = validateParameter(valid_594554, JString, required = true,
                                 default = nil)
  if valid_594554 != nil:
    section.add "fileServerName", valid_594554
  var valid_594555 = path.getOrDefault("deviceName")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = nil)
  if valid_594555 != nil:
    section.add "deviceName", valid_594555
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594556 = query.getOrDefault("api-version")
  valid_594556 = validateParameter(valid_594556, JString, required = true,
                                 default = nil)
  if valid_594556 != nil:
    section.add "api-version", valid_594556
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

proc call*(call_594558: Call_FileSharesCreateOrUpdate_594547; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the file share.
  ## 
  let valid = call_594558.validator(path, query, header, formData, body)
  let scheme = call_594558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594558.url(scheme.get, call_594558.host, call_594558.base,
                         call_594558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594558, url, valid)

proc call*(call_594559: Call_FileSharesCreateOrUpdate_594547;
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
  var path_594560 = newJObject()
  var query_594561 = newJObject()
  var body_594562 = newJObject()
  add(path_594560, "resourceGroupName", newJString(resourceGroupName))
  add(query_594561, "api-version", newJString(apiVersion))
  add(path_594560, "managerName", newJString(managerName))
  add(path_594560, "subscriptionId", newJString(subscriptionId))
  add(path_594560, "shareName", newJString(shareName))
  if fileShare != nil:
    body_594562 = fileShare
  add(path_594560, "fileServerName", newJString(fileServerName))
  add(path_594560, "deviceName", newJString(deviceName))
  result = call_594559.call(path_594560, query_594561, nil, nil, body_594562)

var fileSharesCreateOrUpdate* = Call_FileSharesCreateOrUpdate_594547(
    name: "fileSharesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}",
    validator: validate_FileSharesCreateOrUpdate_594548, base: "",
    url: url_FileSharesCreateOrUpdate_594549, schemes: {Scheme.Https})
type
  Call_FileSharesGet_594533 = ref object of OpenApiRestCall_593438
proc url_FileSharesGet_594535(protocol: Scheme; host: string; base: string;
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

proc validate_FileSharesGet_594534(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594536 = path.getOrDefault("resourceGroupName")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "resourceGroupName", valid_594536
  var valid_594537 = path.getOrDefault("managerName")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "managerName", valid_594537
  var valid_594538 = path.getOrDefault("subscriptionId")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "subscriptionId", valid_594538
  var valid_594539 = path.getOrDefault("shareName")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "shareName", valid_594539
  var valid_594540 = path.getOrDefault("fileServerName")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "fileServerName", valid_594540
  var valid_594541 = path.getOrDefault("deviceName")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "deviceName", valid_594541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594542 = query.getOrDefault("api-version")
  valid_594542 = validateParameter(valid_594542, JString, required = true,
                                 default = nil)
  if valid_594542 != nil:
    section.add "api-version", valid_594542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594543: Call_FileSharesGet_594533; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified file share name.
  ## 
  let valid = call_594543.validator(path, query, header, formData, body)
  let scheme = call_594543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594543.url(scheme.get, call_594543.host, call_594543.base,
                         call_594543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594543, url, valid)

proc call*(call_594544: Call_FileSharesGet_594533; resourceGroupName: string;
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
  var path_594545 = newJObject()
  var query_594546 = newJObject()
  add(path_594545, "resourceGroupName", newJString(resourceGroupName))
  add(query_594546, "api-version", newJString(apiVersion))
  add(path_594545, "managerName", newJString(managerName))
  add(path_594545, "subscriptionId", newJString(subscriptionId))
  add(path_594545, "shareName", newJString(shareName))
  add(path_594545, "fileServerName", newJString(fileServerName))
  add(path_594545, "deviceName", newJString(deviceName))
  result = call_594544.call(path_594545, query_594546, nil, nil, nil)

var fileSharesGet* = Call_FileSharesGet_594533(name: "fileSharesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}",
    validator: validate_FileSharesGet_594534, base: "", url: url_FileSharesGet_594535,
    schemes: {Scheme.Https})
type
  Call_FileSharesDelete_594563 = ref object of OpenApiRestCall_593438
proc url_FileSharesDelete_594565(protocol: Scheme; host: string; base: string;
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

proc validate_FileSharesDelete_594564(path: JsonNode; query: JsonNode;
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
  var valid_594566 = path.getOrDefault("resourceGroupName")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "resourceGroupName", valid_594566
  var valid_594567 = path.getOrDefault("managerName")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "managerName", valid_594567
  var valid_594568 = path.getOrDefault("subscriptionId")
  valid_594568 = validateParameter(valid_594568, JString, required = true,
                                 default = nil)
  if valid_594568 != nil:
    section.add "subscriptionId", valid_594568
  var valid_594569 = path.getOrDefault("shareName")
  valid_594569 = validateParameter(valid_594569, JString, required = true,
                                 default = nil)
  if valid_594569 != nil:
    section.add "shareName", valid_594569
  var valid_594570 = path.getOrDefault("fileServerName")
  valid_594570 = validateParameter(valid_594570, JString, required = true,
                                 default = nil)
  if valid_594570 != nil:
    section.add "fileServerName", valid_594570
  var valid_594571 = path.getOrDefault("deviceName")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "deviceName", valid_594571
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594572 = query.getOrDefault("api-version")
  valid_594572 = validateParameter(valid_594572, JString, required = true,
                                 default = nil)
  if valid_594572 != nil:
    section.add "api-version", valid_594572
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594573: Call_FileSharesDelete_594563; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the file share.
  ## 
  let valid = call_594573.validator(path, query, header, formData, body)
  let scheme = call_594573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594573.url(scheme.get, call_594573.host, call_594573.base,
                         call_594573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594573, url, valid)

proc call*(call_594574: Call_FileSharesDelete_594563; resourceGroupName: string;
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
  var path_594575 = newJObject()
  var query_594576 = newJObject()
  add(path_594575, "resourceGroupName", newJString(resourceGroupName))
  add(query_594576, "api-version", newJString(apiVersion))
  add(path_594575, "managerName", newJString(managerName))
  add(path_594575, "subscriptionId", newJString(subscriptionId))
  add(path_594575, "shareName", newJString(shareName))
  add(path_594575, "fileServerName", newJString(fileServerName))
  add(path_594575, "deviceName", newJString(deviceName))
  result = call_594574.call(path_594575, query_594576, nil, nil, nil)

var fileSharesDelete* = Call_FileSharesDelete_594563(name: "fileSharesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}",
    validator: validate_FileSharesDelete_594564, base: "",
    url: url_FileSharesDelete_594565, schemes: {Scheme.Https})
type
  Call_FileSharesListMetrics_594577 = ref object of OpenApiRestCall_593438
proc url_FileSharesListMetrics_594579(protocol: Scheme; host: string; base: string;
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

proc validate_FileSharesListMetrics_594578(path: JsonNode; query: JsonNode;
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
  var valid_594580 = path.getOrDefault("resourceGroupName")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "resourceGroupName", valid_594580
  var valid_594581 = path.getOrDefault("managerName")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "managerName", valid_594581
  var valid_594582 = path.getOrDefault("subscriptionId")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "subscriptionId", valid_594582
  var valid_594583 = path.getOrDefault("shareName")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "shareName", valid_594583
  var valid_594584 = path.getOrDefault("fileServerName")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "fileServerName", valid_594584
  var valid_594585 = path.getOrDefault("deviceName")
  valid_594585 = validateParameter(valid_594585, JString, required = true,
                                 default = nil)
  if valid_594585 != nil:
    section.add "deviceName", valid_594585
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594586 = query.getOrDefault("api-version")
  valid_594586 = validateParameter(valid_594586, JString, required = true,
                                 default = nil)
  if valid_594586 != nil:
    section.add "api-version", valid_594586
  var valid_594587 = query.getOrDefault("$filter")
  valid_594587 = validateParameter(valid_594587, JString, required = false,
                                 default = nil)
  if valid_594587 != nil:
    section.add "$filter", valid_594587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594588: Call_FileSharesListMetrics_594577; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the file share metrics
  ## 
  let valid = call_594588.validator(path, query, header, formData, body)
  let scheme = call_594588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594588.url(scheme.get, call_594588.host, call_594588.base,
                         call_594588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594588, url, valid)

proc call*(call_594589: Call_FileSharesListMetrics_594577;
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
  var path_594590 = newJObject()
  var query_594591 = newJObject()
  add(path_594590, "resourceGroupName", newJString(resourceGroupName))
  add(query_594591, "api-version", newJString(apiVersion))
  add(path_594590, "managerName", newJString(managerName))
  add(path_594590, "subscriptionId", newJString(subscriptionId))
  add(path_594590, "shareName", newJString(shareName))
  add(path_594590, "fileServerName", newJString(fileServerName))
  add(query_594591, "$filter", newJString(Filter))
  add(path_594590, "deviceName", newJString(deviceName))
  result = call_594589.call(path_594590, query_594591, nil, nil, nil)

var fileSharesListMetrics* = Call_FileSharesListMetrics_594577(
    name: "fileSharesListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}/metrics",
    validator: validate_FileSharesListMetrics_594578, base: "",
    url: url_FileSharesListMetrics_594579, schemes: {Scheme.Https})
type
  Call_FileSharesListMetricDefinition_594592 = ref object of OpenApiRestCall_593438
proc url_FileSharesListMetricDefinition_594594(protocol: Scheme; host: string;
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

proc validate_FileSharesListMetricDefinition_594593(path: JsonNode;
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
  var valid_594595 = path.getOrDefault("resourceGroupName")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "resourceGroupName", valid_594595
  var valid_594596 = path.getOrDefault("managerName")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "managerName", valid_594596
  var valid_594597 = path.getOrDefault("subscriptionId")
  valid_594597 = validateParameter(valid_594597, JString, required = true,
                                 default = nil)
  if valid_594597 != nil:
    section.add "subscriptionId", valid_594597
  var valid_594598 = path.getOrDefault("shareName")
  valid_594598 = validateParameter(valid_594598, JString, required = true,
                                 default = nil)
  if valid_594598 != nil:
    section.add "shareName", valid_594598
  var valid_594599 = path.getOrDefault("fileServerName")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = nil)
  if valid_594599 != nil:
    section.add "fileServerName", valid_594599
  var valid_594600 = path.getOrDefault("deviceName")
  valid_594600 = validateParameter(valid_594600, JString, required = true,
                                 default = nil)
  if valid_594600 != nil:
    section.add "deviceName", valid_594600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594601 = query.getOrDefault("api-version")
  valid_594601 = validateParameter(valid_594601, JString, required = true,
                                 default = nil)
  if valid_594601 != nil:
    section.add "api-version", valid_594601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594602: Call_FileSharesListMetricDefinition_594592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definitions of all metrics aggregated at the file share.
  ## 
  let valid = call_594602.validator(path, query, header, formData, body)
  let scheme = call_594602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594602.url(scheme.get, call_594602.host, call_594602.base,
                         call_594602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594602, url, valid)

proc call*(call_594603: Call_FileSharesListMetricDefinition_594592;
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
  var path_594604 = newJObject()
  var query_594605 = newJObject()
  add(path_594604, "resourceGroupName", newJString(resourceGroupName))
  add(query_594605, "api-version", newJString(apiVersion))
  add(path_594604, "managerName", newJString(managerName))
  add(path_594604, "subscriptionId", newJString(subscriptionId))
  add(path_594604, "shareName", newJString(shareName))
  add(path_594604, "fileServerName", newJString(fileServerName))
  add(path_594604, "deviceName", newJString(deviceName))
  result = call_594603.call(path_594604, query_594605, nil, nil, nil)

var fileSharesListMetricDefinition* = Call_FileSharesListMetricDefinition_594592(
    name: "fileSharesListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/fileservers/{fileServerName}/shares/{shareName}/metricsDefinitions",
    validator: validate_FileSharesListMetricDefinition_594593, base: "",
    url: url_FileSharesListMetricDefinition_594594, schemes: {Scheme.Https})
type
  Call_DevicesInstallUpdates_594606 = ref object of OpenApiRestCall_593438
proc url_DevicesInstallUpdates_594608(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesInstallUpdates_594607(path: JsonNode; query: JsonNode;
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
  var valid_594609 = path.getOrDefault("resourceGroupName")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "resourceGroupName", valid_594609
  var valid_594610 = path.getOrDefault("managerName")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "managerName", valid_594610
  var valid_594611 = path.getOrDefault("subscriptionId")
  valid_594611 = validateParameter(valid_594611, JString, required = true,
                                 default = nil)
  if valid_594611 != nil:
    section.add "subscriptionId", valid_594611
  var valid_594612 = path.getOrDefault("deviceName")
  valid_594612 = validateParameter(valid_594612, JString, required = true,
                                 default = nil)
  if valid_594612 != nil:
    section.add "deviceName", valid_594612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594613 = query.getOrDefault("api-version")
  valid_594613 = validateParameter(valid_594613, JString, required = true,
                                 default = nil)
  if valid_594613 != nil:
    section.add "api-version", valid_594613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594614: Call_DevicesInstallUpdates_594606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Installs the updates on the device.
  ## 
  let valid = call_594614.validator(path, query, header, formData, body)
  let scheme = call_594614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594614.url(scheme.get, call_594614.host, call_594614.base,
                         call_594614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594614, url, valid)

proc call*(call_594615: Call_DevicesInstallUpdates_594606;
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
  var path_594616 = newJObject()
  var query_594617 = newJObject()
  add(path_594616, "resourceGroupName", newJString(resourceGroupName))
  add(query_594617, "api-version", newJString(apiVersion))
  add(path_594616, "managerName", newJString(managerName))
  add(path_594616, "subscriptionId", newJString(subscriptionId))
  add(path_594616, "deviceName", newJString(deviceName))
  result = call_594615.call(path_594616, query_594617, nil, nil, nil)

var devicesInstallUpdates* = Call_DevicesInstallUpdates_594606(
    name: "devicesInstallUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/install",
    validator: validate_DevicesInstallUpdates_594607, base: "",
    url: url_DevicesInstallUpdates_594608, schemes: {Scheme.Https})
type
  Call_IscsiServersListByDevice_594618 = ref object of OpenApiRestCall_593438
proc url_IscsiServersListByDevice_594620(protocol: Scheme; host: string;
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

proc validate_IscsiServersListByDevice_594619(path: JsonNode; query: JsonNode;
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
  var valid_594621 = path.getOrDefault("resourceGroupName")
  valid_594621 = validateParameter(valid_594621, JString, required = true,
                                 default = nil)
  if valid_594621 != nil:
    section.add "resourceGroupName", valid_594621
  var valid_594622 = path.getOrDefault("managerName")
  valid_594622 = validateParameter(valid_594622, JString, required = true,
                                 default = nil)
  if valid_594622 != nil:
    section.add "managerName", valid_594622
  var valid_594623 = path.getOrDefault("subscriptionId")
  valid_594623 = validateParameter(valid_594623, JString, required = true,
                                 default = nil)
  if valid_594623 != nil:
    section.add "subscriptionId", valid_594623
  var valid_594624 = path.getOrDefault("deviceName")
  valid_594624 = validateParameter(valid_594624, JString, required = true,
                                 default = nil)
  if valid_594624 != nil:
    section.add "deviceName", valid_594624
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594625 = query.getOrDefault("api-version")
  valid_594625 = validateParameter(valid_594625, JString, required = true,
                                 default = nil)
  if valid_594625 != nil:
    section.add "api-version", valid_594625
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594626: Call_IscsiServersListByDevice_594618; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the iSCSI in a device.
  ## 
  let valid = call_594626.validator(path, query, header, formData, body)
  let scheme = call_594626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594626.url(scheme.get, call_594626.host, call_594626.base,
                         call_594626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594626, url, valid)

proc call*(call_594627: Call_IscsiServersListByDevice_594618;
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
  var path_594628 = newJObject()
  var query_594629 = newJObject()
  add(path_594628, "resourceGroupName", newJString(resourceGroupName))
  add(query_594629, "api-version", newJString(apiVersion))
  add(path_594628, "managerName", newJString(managerName))
  add(path_594628, "subscriptionId", newJString(subscriptionId))
  add(path_594628, "deviceName", newJString(deviceName))
  result = call_594627.call(path_594628, query_594629, nil, nil, nil)

var iscsiServersListByDevice* = Call_IscsiServersListByDevice_594618(
    name: "iscsiServersListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers",
    validator: validate_IscsiServersListByDevice_594619, base: "",
    url: url_IscsiServersListByDevice_594620, schemes: {Scheme.Https})
type
  Call_IscsiServersCreateOrUpdate_594643 = ref object of OpenApiRestCall_593438
proc url_IscsiServersCreateOrUpdate_594645(protocol: Scheme; host: string;
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

proc validate_IscsiServersCreateOrUpdate_594644(path: JsonNode; query: JsonNode;
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
  var valid_594646 = path.getOrDefault("resourceGroupName")
  valid_594646 = validateParameter(valid_594646, JString, required = true,
                                 default = nil)
  if valid_594646 != nil:
    section.add "resourceGroupName", valid_594646
  var valid_594647 = path.getOrDefault("managerName")
  valid_594647 = validateParameter(valid_594647, JString, required = true,
                                 default = nil)
  if valid_594647 != nil:
    section.add "managerName", valid_594647
  var valid_594648 = path.getOrDefault("subscriptionId")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "subscriptionId", valid_594648
  var valid_594649 = path.getOrDefault("iscsiServerName")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "iscsiServerName", valid_594649
  var valid_594650 = path.getOrDefault("deviceName")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "deviceName", valid_594650
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594651 = query.getOrDefault("api-version")
  valid_594651 = validateParameter(valid_594651, JString, required = true,
                                 default = nil)
  if valid_594651 != nil:
    section.add "api-version", valid_594651
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

proc call*(call_594653: Call_IscsiServersCreateOrUpdate_594643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the iSCSI server.
  ## 
  let valid = call_594653.validator(path, query, header, formData, body)
  let scheme = call_594653.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594653.url(scheme.get, call_594653.host, call_594653.base,
                         call_594653.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594653, url, valid)

proc call*(call_594654: Call_IscsiServersCreateOrUpdate_594643;
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
  var path_594655 = newJObject()
  var query_594656 = newJObject()
  var body_594657 = newJObject()
  add(path_594655, "resourceGroupName", newJString(resourceGroupName))
  add(query_594656, "api-version", newJString(apiVersion))
  add(path_594655, "managerName", newJString(managerName))
  if iscsiServer != nil:
    body_594657 = iscsiServer
  add(path_594655, "subscriptionId", newJString(subscriptionId))
  add(path_594655, "iscsiServerName", newJString(iscsiServerName))
  add(path_594655, "deviceName", newJString(deviceName))
  result = call_594654.call(path_594655, query_594656, nil, nil, body_594657)

var iscsiServersCreateOrUpdate* = Call_IscsiServersCreateOrUpdate_594643(
    name: "iscsiServersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}",
    validator: validate_IscsiServersCreateOrUpdate_594644, base: "",
    url: url_IscsiServersCreateOrUpdate_594645, schemes: {Scheme.Https})
type
  Call_IscsiServersGet_594630 = ref object of OpenApiRestCall_593438
proc url_IscsiServersGet_594632(protocol: Scheme; host: string; base: string;
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

proc validate_IscsiServersGet_594631(path: JsonNode; query: JsonNode;
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
  var valid_594633 = path.getOrDefault("resourceGroupName")
  valid_594633 = validateParameter(valid_594633, JString, required = true,
                                 default = nil)
  if valid_594633 != nil:
    section.add "resourceGroupName", valid_594633
  var valid_594634 = path.getOrDefault("managerName")
  valid_594634 = validateParameter(valid_594634, JString, required = true,
                                 default = nil)
  if valid_594634 != nil:
    section.add "managerName", valid_594634
  var valid_594635 = path.getOrDefault("subscriptionId")
  valid_594635 = validateParameter(valid_594635, JString, required = true,
                                 default = nil)
  if valid_594635 != nil:
    section.add "subscriptionId", valid_594635
  var valid_594636 = path.getOrDefault("iscsiServerName")
  valid_594636 = validateParameter(valid_594636, JString, required = true,
                                 default = nil)
  if valid_594636 != nil:
    section.add "iscsiServerName", valid_594636
  var valid_594637 = path.getOrDefault("deviceName")
  valid_594637 = validateParameter(valid_594637, JString, required = true,
                                 default = nil)
  if valid_594637 != nil:
    section.add "deviceName", valid_594637
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594638 = query.getOrDefault("api-version")
  valid_594638 = validateParameter(valid_594638, JString, required = true,
                                 default = nil)
  if valid_594638 != nil:
    section.add "api-version", valid_594638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594639: Call_IscsiServersGet_594630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified iSCSI server name.
  ## 
  let valid = call_594639.validator(path, query, header, formData, body)
  let scheme = call_594639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594639.url(scheme.get, call_594639.host, call_594639.base,
                         call_594639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594639, url, valid)

proc call*(call_594640: Call_IscsiServersGet_594630; resourceGroupName: string;
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
  var path_594641 = newJObject()
  var query_594642 = newJObject()
  add(path_594641, "resourceGroupName", newJString(resourceGroupName))
  add(query_594642, "api-version", newJString(apiVersion))
  add(path_594641, "managerName", newJString(managerName))
  add(path_594641, "subscriptionId", newJString(subscriptionId))
  add(path_594641, "iscsiServerName", newJString(iscsiServerName))
  add(path_594641, "deviceName", newJString(deviceName))
  result = call_594640.call(path_594641, query_594642, nil, nil, nil)

var iscsiServersGet* = Call_IscsiServersGet_594630(name: "iscsiServersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}",
    validator: validate_IscsiServersGet_594631, base: "", url: url_IscsiServersGet_594632,
    schemes: {Scheme.Https})
type
  Call_IscsiServersDelete_594658 = ref object of OpenApiRestCall_593438
proc url_IscsiServersDelete_594660(protocol: Scheme; host: string; base: string;
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

proc validate_IscsiServersDelete_594659(path: JsonNode; query: JsonNode;
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
  var valid_594661 = path.getOrDefault("resourceGroupName")
  valid_594661 = validateParameter(valid_594661, JString, required = true,
                                 default = nil)
  if valid_594661 != nil:
    section.add "resourceGroupName", valid_594661
  var valid_594662 = path.getOrDefault("managerName")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = nil)
  if valid_594662 != nil:
    section.add "managerName", valid_594662
  var valid_594663 = path.getOrDefault("subscriptionId")
  valid_594663 = validateParameter(valid_594663, JString, required = true,
                                 default = nil)
  if valid_594663 != nil:
    section.add "subscriptionId", valid_594663
  var valid_594664 = path.getOrDefault("iscsiServerName")
  valid_594664 = validateParameter(valid_594664, JString, required = true,
                                 default = nil)
  if valid_594664 != nil:
    section.add "iscsiServerName", valid_594664
  var valid_594665 = path.getOrDefault("deviceName")
  valid_594665 = validateParameter(valid_594665, JString, required = true,
                                 default = nil)
  if valid_594665 != nil:
    section.add "deviceName", valid_594665
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594666 = query.getOrDefault("api-version")
  valid_594666 = validateParameter(valid_594666, JString, required = true,
                                 default = nil)
  if valid_594666 != nil:
    section.add "api-version", valid_594666
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594667: Call_IscsiServersDelete_594658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the iSCSI server.
  ## 
  let valid = call_594667.validator(path, query, header, formData, body)
  let scheme = call_594667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594667.url(scheme.get, call_594667.host, call_594667.base,
                         call_594667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594667, url, valid)

proc call*(call_594668: Call_IscsiServersDelete_594658; resourceGroupName: string;
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
  var path_594669 = newJObject()
  var query_594670 = newJObject()
  add(path_594669, "resourceGroupName", newJString(resourceGroupName))
  add(query_594670, "api-version", newJString(apiVersion))
  add(path_594669, "managerName", newJString(managerName))
  add(path_594669, "subscriptionId", newJString(subscriptionId))
  add(path_594669, "iscsiServerName", newJString(iscsiServerName))
  add(path_594669, "deviceName", newJString(deviceName))
  result = call_594668.call(path_594669, query_594670, nil, nil, nil)

var iscsiServersDelete* = Call_IscsiServersDelete_594658(
    name: "iscsiServersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}",
    validator: validate_IscsiServersDelete_594659, base: "",
    url: url_IscsiServersDelete_594660, schemes: {Scheme.Https})
type
  Call_IscsiServersBackupNow_594671 = ref object of OpenApiRestCall_593438
proc url_IscsiServersBackupNow_594673(protocol: Scheme; host: string; base: string;
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

proc validate_IscsiServersBackupNow_594672(path: JsonNode; query: JsonNode;
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
  var valid_594674 = path.getOrDefault("resourceGroupName")
  valid_594674 = validateParameter(valid_594674, JString, required = true,
                                 default = nil)
  if valid_594674 != nil:
    section.add "resourceGroupName", valid_594674
  var valid_594675 = path.getOrDefault("managerName")
  valid_594675 = validateParameter(valid_594675, JString, required = true,
                                 default = nil)
  if valid_594675 != nil:
    section.add "managerName", valid_594675
  var valid_594676 = path.getOrDefault("subscriptionId")
  valid_594676 = validateParameter(valid_594676, JString, required = true,
                                 default = nil)
  if valid_594676 != nil:
    section.add "subscriptionId", valid_594676
  var valid_594677 = path.getOrDefault("iscsiServerName")
  valid_594677 = validateParameter(valid_594677, JString, required = true,
                                 default = nil)
  if valid_594677 != nil:
    section.add "iscsiServerName", valid_594677
  var valid_594678 = path.getOrDefault("deviceName")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "deviceName", valid_594678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594679 = query.getOrDefault("api-version")
  valid_594679 = validateParameter(valid_594679, JString, required = true,
                                 default = nil)
  if valid_594679 != nil:
    section.add "api-version", valid_594679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594680: Call_IscsiServersBackupNow_594671; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup the iSCSI server now.
  ## 
  let valid = call_594680.validator(path, query, header, formData, body)
  let scheme = call_594680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594680.url(scheme.get, call_594680.host, call_594680.base,
                         call_594680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594680, url, valid)

proc call*(call_594681: Call_IscsiServersBackupNow_594671;
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
  var path_594682 = newJObject()
  var query_594683 = newJObject()
  add(path_594682, "resourceGroupName", newJString(resourceGroupName))
  add(query_594683, "api-version", newJString(apiVersion))
  add(path_594682, "managerName", newJString(managerName))
  add(path_594682, "subscriptionId", newJString(subscriptionId))
  add(path_594682, "iscsiServerName", newJString(iscsiServerName))
  add(path_594682, "deviceName", newJString(deviceName))
  result = call_594681.call(path_594682, query_594683, nil, nil, nil)

var iscsiServersBackupNow* = Call_IscsiServersBackupNow_594671(
    name: "iscsiServersBackupNow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/backup",
    validator: validate_IscsiServersBackupNow_594672, base: "",
    url: url_IscsiServersBackupNow_594673, schemes: {Scheme.Https})
type
  Call_IscsiDisksListByIscsiServer_594684 = ref object of OpenApiRestCall_593438
proc url_IscsiDisksListByIscsiServer_594686(protocol: Scheme; host: string;
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

proc validate_IscsiDisksListByIscsiServer_594685(path: JsonNode; query: JsonNode;
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
  var valid_594687 = path.getOrDefault("resourceGroupName")
  valid_594687 = validateParameter(valid_594687, JString, required = true,
                                 default = nil)
  if valid_594687 != nil:
    section.add "resourceGroupName", valid_594687
  var valid_594688 = path.getOrDefault("managerName")
  valid_594688 = validateParameter(valid_594688, JString, required = true,
                                 default = nil)
  if valid_594688 != nil:
    section.add "managerName", valid_594688
  var valid_594689 = path.getOrDefault("subscriptionId")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = nil)
  if valid_594689 != nil:
    section.add "subscriptionId", valid_594689
  var valid_594690 = path.getOrDefault("iscsiServerName")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = nil)
  if valid_594690 != nil:
    section.add "iscsiServerName", valid_594690
  var valid_594691 = path.getOrDefault("deviceName")
  valid_594691 = validateParameter(valid_594691, JString, required = true,
                                 default = nil)
  if valid_594691 != nil:
    section.add "deviceName", valid_594691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594692 = query.getOrDefault("api-version")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = nil)
  if valid_594692 != nil:
    section.add "api-version", valid_594692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594693: Call_IscsiDisksListByIscsiServer_594684; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the disks in a iSCSI server.
  ## 
  let valid = call_594693.validator(path, query, header, formData, body)
  let scheme = call_594693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594693.url(scheme.get, call_594693.host, call_594693.base,
                         call_594693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594693, url, valid)

proc call*(call_594694: Call_IscsiDisksListByIscsiServer_594684;
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
  var path_594695 = newJObject()
  var query_594696 = newJObject()
  add(path_594695, "resourceGroupName", newJString(resourceGroupName))
  add(query_594696, "api-version", newJString(apiVersion))
  add(path_594695, "managerName", newJString(managerName))
  add(path_594695, "subscriptionId", newJString(subscriptionId))
  add(path_594695, "iscsiServerName", newJString(iscsiServerName))
  add(path_594695, "deviceName", newJString(deviceName))
  result = call_594694.call(path_594695, query_594696, nil, nil, nil)

var iscsiDisksListByIscsiServer* = Call_IscsiDisksListByIscsiServer_594684(
    name: "iscsiDisksListByIscsiServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks",
    validator: validate_IscsiDisksListByIscsiServer_594685, base: "",
    url: url_IscsiDisksListByIscsiServer_594686, schemes: {Scheme.Https})
type
  Call_IscsiDisksCreateOrUpdate_594711 = ref object of OpenApiRestCall_593438
proc url_IscsiDisksCreateOrUpdate_594713(protocol: Scheme; host: string;
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

proc validate_IscsiDisksCreateOrUpdate_594712(path: JsonNode; query: JsonNode;
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
  var valid_594714 = path.getOrDefault("resourceGroupName")
  valid_594714 = validateParameter(valid_594714, JString, required = true,
                                 default = nil)
  if valid_594714 != nil:
    section.add "resourceGroupName", valid_594714
  var valid_594715 = path.getOrDefault("managerName")
  valid_594715 = validateParameter(valid_594715, JString, required = true,
                                 default = nil)
  if valid_594715 != nil:
    section.add "managerName", valid_594715
  var valid_594716 = path.getOrDefault("subscriptionId")
  valid_594716 = validateParameter(valid_594716, JString, required = true,
                                 default = nil)
  if valid_594716 != nil:
    section.add "subscriptionId", valid_594716
  var valid_594717 = path.getOrDefault("iscsiServerName")
  valid_594717 = validateParameter(valid_594717, JString, required = true,
                                 default = nil)
  if valid_594717 != nil:
    section.add "iscsiServerName", valid_594717
  var valid_594718 = path.getOrDefault("diskName")
  valid_594718 = validateParameter(valid_594718, JString, required = true,
                                 default = nil)
  if valid_594718 != nil:
    section.add "diskName", valid_594718
  var valid_594719 = path.getOrDefault("deviceName")
  valid_594719 = validateParameter(valid_594719, JString, required = true,
                                 default = nil)
  if valid_594719 != nil:
    section.add "deviceName", valid_594719
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594720 = query.getOrDefault("api-version")
  valid_594720 = validateParameter(valid_594720, JString, required = true,
                                 default = nil)
  if valid_594720 != nil:
    section.add "api-version", valid_594720
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

proc call*(call_594722: Call_IscsiDisksCreateOrUpdate_594711; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the iSCSI disk.
  ## 
  let valid = call_594722.validator(path, query, header, formData, body)
  let scheme = call_594722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594722.url(scheme.get, call_594722.host, call_594722.base,
                         call_594722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594722, url, valid)

proc call*(call_594723: Call_IscsiDisksCreateOrUpdate_594711; iscsiDisk: JsonNode;
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
  var path_594724 = newJObject()
  var query_594725 = newJObject()
  var body_594726 = newJObject()
  if iscsiDisk != nil:
    body_594726 = iscsiDisk
  add(path_594724, "resourceGroupName", newJString(resourceGroupName))
  add(query_594725, "api-version", newJString(apiVersion))
  add(path_594724, "managerName", newJString(managerName))
  add(path_594724, "subscriptionId", newJString(subscriptionId))
  add(path_594724, "iscsiServerName", newJString(iscsiServerName))
  add(path_594724, "diskName", newJString(diskName))
  add(path_594724, "deviceName", newJString(deviceName))
  result = call_594723.call(path_594724, query_594725, nil, nil, body_594726)

var iscsiDisksCreateOrUpdate* = Call_IscsiDisksCreateOrUpdate_594711(
    name: "iscsiDisksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}",
    validator: validate_IscsiDisksCreateOrUpdate_594712, base: "",
    url: url_IscsiDisksCreateOrUpdate_594713, schemes: {Scheme.Https})
type
  Call_IscsiDisksGet_594697 = ref object of OpenApiRestCall_593438
proc url_IscsiDisksGet_594699(protocol: Scheme; host: string; base: string;
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

proc validate_IscsiDisksGet_594698(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594700 = path.getOrDefault("resourceGroupName")
  valid_594700 = validateParameter(valid_594700, JString, required = true,
                                 default = nil)
  if valid_594700 != nil:
    section.add "resourceGroupName", valid_594700
  var valid_594701 = path.getOrDefault("managerName")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = nil)
  if valid_594701 != nil:
    section.add "managerName", valid_594701
  var valid_594702 = path.getOrDefault("subscriptionId")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "subscriptionId", valid_594702
  var valid_594703 = path.getOrDefault("iscsiServerName")
  valid_594703 = validateParameter(valid_594703, JString, required = true,
                                 default = nil)
  if valid_594703 != nil:
    section.add "iscsiServerName", valid_594703
  var valid_594704 = path.getOrDefault("diskName")
  valid_594704 = validateParameter(valid_594704, JString, required = true,
                                 default = nil)
  if valid_594704 != nil:
    section.add "diskName", valid_594704
  var valid_594705 = path.getOrDefault("deviceName")
  valid_594705 = validateParameter(valid_594705, JString, required = true,
                                 default = nil)
  if valid_594705 != nil:
    section.add "deviceName", valid_594705
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594706 = query.getOrDefault("api-version")
  valid_594706 = validateParameter(valid_594706, JString, required = true,
                                 default = nil)
  if valid_594706 != nil:
    section.add "api-version", valid_594706
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594707: Call_IscsiDisksGet_594697; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified iSCSI disk name.
  ## 
  let valid = call_594707.validator(path, query, header, formData, body)
  let scheme = call_594707.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594707.url(scheme.get, call_594707.host, call_594707.base,
                         call_594707.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594707, url, valid)

proc call*(call_594708: Call_IscsiDisksGet_594697; resourceGroupName: string;
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
  var path_594709 = newJObject()
  var query_594710 = newJObject()
  add(path_594709, "resourceGroupName", newJString(resourceGroupName))
  add(query_594710, "api-version", newJString(apiVersion))
  add(path_594709, "managerName", newJString(managerName))
  add(path_594709, "subscriptionId", newJString(subscriptionId))
  add(path_594709, "iscsiServerName", newJString(iscsiServerName))
  add(path_594709, "diskName", newJString(diskName))
  add(path_594709, "deviceName", newJString(deviceName))
  result = call_594708.call(path_594709, query_594710, nil, nil, nil)

var iscsiDisksGet* = Call_IscsiDisksGet_594697(name: "iscsiDisksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}",
    validator: validate_IscsiDisksGet_594698, base: "", url: url_IscsiDisksGet_594699,
    schemes: {Scheme.Https})
type
  Call_IscsiDisksDelete_594727 = ref object of OpenApiRestCall_593438
proc url_IscsiDisksDelete_594729(protocol: Scheme; host: string; base: string;
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

proc validate_IscsiDisksDelete_594728(path: JsonNode; query: JsonNode;
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
  var valid_594730 = path.getOrDefault("resourceGroupName")
  valid_594730 = validateParameter(valid_594730, JString, required = true,
                                 default = nil)
  if valid_594730 != nil:
    section.add "resourceGroupName", valid_594730
  var valid_594731 = path.getOrDefault("managerName")
  valid_594731 = validateParameter(valid_594731, JString, required = true,
                                 default = nil)
  if valid_594731 != nil:
    section.add "managerName", valid_594731
  var valid_594732 = path.getOrDefault("subscriptionId")
  valid_594732 = validateParameter(valid_594732, JString, required = true,
                                 default = nil)
  if valid_594732 != nil:
    section.add "subscriptionId", valid_594732
  var valid_594733 = path.getOrDefault("iscsiServerName")
  valid_594733 = validateParameter(valid_594733, JString, required = true,
                                 default = nil)
  if valid_594733 != nil:
    section.add "iscsiServerName", valid_594733
  var valid_594734 = path.getOrDefault("diskName")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "diskName", valid_594734
  var valid_594735 = path.getOrDefault("deviceName")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "deviceName", valid_594735
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594736 = query.getOrDefault("api-version")
  valid_594736 = validateParameter(valid_594736, JString, required = true,
                                 default = nil)
  if valid_594736 != nil:
    section.add "api-version", valid_594736
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594737: Call_IscsiDisksDelete_594727; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the iSCSI disk.
  ## 
  let valid = call_594737.validator(path, query, header, formData, body)
  let scheme = call_594737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594737.url(scheme.get, call_594737.host, call_594737.base,
                         call_594737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594737, url, valid)

proc call*(call_594738: Call_IscsiDisksDelete_594727; resourceGroupName: string;
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
  var path_594739 = newJObject()
  var query_594740 = newJObject()
  add(path_594739, "resourceGroupName", newJString(resourceGroupName))
  add(query_594740, "api-version", newJString(apiVersion))
  add(path_594739, "managerName", newJString(managerName))
  add(path_594739, "subscriptionId", newJString(subscriptionId))
  add(path_594739, "iscsiServerName", newJString(iscsiServerName))
  add(path_594739, "diskName", newJString(diskName))
  add(path_594739, "deviceName", newJString(deviceName))
  result = call_594738.call(path_594739, query_594740, nil, nil, nil)

var iscsiDisksDelete* = Call_IscsiDisksDelete_594727(name: "iscsiDisksDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}",
    validator: validate_IscsiDisksDelete_594728, base: "",
    url: url_IscsiDisksDelete_594729, schemes: {Scheme.Https})
type
  Call_IscsiDisksListMetrics_594741 = ref object of OpenApiRestCall_593438
proc url_IscsiDisksListMetrics_594743(protocol: Scheme; host: string; base: string;
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

proc validate_IscsiDisksListMetrics_594742(path: JsonNode; query: JsonNode;
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
  var valid_594744 = path.getOrDefault("resourceGroupName")
  valid_594744 = validateParameter(valid_594744, JString, required = true,
                                 default = nil)
  if valid_594744 != nil:
    section.add "resourceGroupName", valid_594744
  var valid_594745 = path.getOrDefault("managerName")
  valid_594745 = validateParameter(valid_594745, JString, required = true,
                                 default = nil)
  if valid_594745 != nil:
    section.add "managerName", valid_594745
  var valid_594746 = path.getOrDefault("subscriptionId")
  valid_594746 = validateParameter(valid_594746, JString, required = true,
                                 default = nil)
  if valid_594746 != nil:
    section.add "subscriptionId", valid_594746
  var valid_594747 = path.getOrDefault("iscsiServerName")
  valid_594747 = validateParameter(valid_594747, JString, required = true,
                                 default = nil)
  if valid_594747 != nil:
    section.add "iscsiServerName", valid_594747
  var valid_594748 = path.getOrDefault("diskName")
  valid_594748 = validateParameter(valid_594748, JString, required = true,
                                 default = nil)
  if valid_594748 != nil:
    section.add "diskName", valid_594748
  var valid_594749 = path.getOrDefault("deviceName")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "deviceName", valid_594749
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594750 = query.getOrDefault("api-version")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "api-version", valid_594750
  var valid_594751 = query.getOrDefault("$filter")
  valid_594751 = validateParameter(valid_594751, JString, required = false,
                                 default = nil)
  if valid_594751 != nil:
    section.add "$filter", valid_594751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594752: Call_IscsiDisksListMetrics_594741; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the iSCSI disk metrics
  ## 
  let valid = call_594752.validator(path, query, header, formData, body)
  let scheme = call_594752.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594752.url(scheme.get, call_594752.host, call_594752.base,
                         call_594752.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594752, url, valid)

proc call*(call_594753: Call_IscsiDisksListMetrics_594741;
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
  var path_594754 = newJObject()
  var query_594755 = newJObject()
  add(path_594754, "resourceGroupName", newJString(resourceGroupName))
  add(query_594755, "api-version", newJString(apiVersion))
  add(path_594754, "managerName", newJString(managerName))
  add(path_594754, "subscriptionId", newJString(subscriptionId))
  add(path_594754, "iscsiServerName", newJString(iscsiServerName))
  add(path_594754, "diskName", newJString(diskName))
  add(query_594755, "$filter", newJString(Filter))
  add(path_594754, "deviceName", newJString(deviceName))
  result = call_594753.call(path_594754, query_594755, nil, nil, nil)

var iscsiDisksListMetrics* = Call_IscsiDisksListMetrics_594741(
    name: "iscsiDisksListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}/metrics",
    validator: validate_IscsiDisksListMetrics_594742, base: "",
    url: url_IscsiDisksListMetrics_594743, schemes: {Scheme.Https})
type
  Call_IscsiDisksListMetricDefinition_594756 = ref object of OpenApiRestCall_593438
proc url_IscsiDisksListMetricDefinition_594758(protocol: Scheme; host: string;
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

proc validate_IscsiDisksListMetricDefinition_594757(path: JsonNode;
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
  var valid_594759 = path.getOrDefault("resourceGroupName")
  valid_594759 = validateParameter(valid_594759, JString, required = true,
                                 default = nil)
  if valid_594759 != nil:
    section.add "resourceGroupName", valid_594759
  var valid_594760 = path.getOrDefault("managerName")
  valid_594760 = validateParameter(valid_594760, JString, required = true,
                                 default = nil)
  if valid_594760 != nil:
    section.add "managerName", valid_594760
  var valid_594761 = path.getOrDefault("subscriptionId")
  valid_594761 = validateParameter(valid_594761, JString, required = true,
                                 default = nil)
  if valid_594761 != nil:
    section.add "subscriptionId", valid_594761
  var valid_594762 = path.getOrDefault("iscsiServerName")
  valid_594762 = validateParameter(valid_594762, JString, required = true,
                                 default = nil)
  if valid_594762 != nil:
    section.add "iscsiServerName", valid_594762
  var valid_594763 = path.getOrDefault("diskName")
  valid_594763 = validateParameter(valid_594763, JString, required = true,
                                 default = nil)
  if valid_594763 != nil:
    section.add "diskName", valid_594763
  var valid_594764 = path.getOrDefault("deviceName")
  valid_594764 = validateParameter(valid_594764, JString, required = true,
                                 default = nil)
  if valid_594764 != nil:
    section.add "deviceName", valid_594764
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594765 = query.getOrDefault("api-version")
  valid_594765 = validateParameter(valid_594765, JString, required = true,
                                 default = nil)
  if valid_594765 != nil:
    section.add "api-version", valid_594765
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594766: Call_IscsiDisksListMetricDefinition_594756; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definitions for all metric aggregated at the iSCSI disk.
  ## 
  let valid = call_594766.validator(path, query, header, formData, body)
  let scheme = call_594766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594766.url(scheme.get, call_594766.host, call_594766.base,
                         call_594766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594766, url, valid)

proc call*(call_594767: Call_IscsiDisksListMetricDefinition_594756;
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
  var path_594768 = newJObject()
  var query_594769 = newJObject()
  add(path_594768, "resourceGroupName", newJString(resourceGroupName))
  add(query_594769, "api-version", newJString(apiVersion))
  add(path_594768, "managerName", newJString(managerName))
  add(path_594768, "subscriptionId", newJString(subscriptionId))
  add(path_594768, "iscsiServerName", newJString(iscsiServerName))
  add(path_594768, "diskName", newJString(diskName))
  add(path_594768, "deviceName", newJString(deviceName))
  result = call_594767.call(path_594768, query_594769, nil, nil, nil)

var iscsiDisksListMetricDefinition* = Call_IscsiDisksListMetricDefinition_594756(
    name: "iscsiDisksListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/disks/{diskName}/metricsDefinitions",
    validator: validate_IscsiDisksListMetricDefinition_594757, base: "",
    url: url_IscsiDisksListMetricDefinition_594758, schemes: {Scheme.Https})
type
  Call_IscsiServersListMetrics_594770 = ref object of OpenApiRestCall_593438
proc url_IscsiServersListMetrics_594772(protocol: Scheme; host: string; base: string;
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

proc validate_IscsiServersListMetrics_594771(path: JsonNode; query: JsonNode;
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
  var valid_594773 = path.getOrDefault("resourceGroupName")
  valid_594773 = validateParameter(valid_594773, JString, required = true,
                                 default = nil)
  if valid_594773 != nil:
    section.add "resourceGroupName", valid_594773
  var valid_594774 = path.getOrDefault("managerName")
  valid_594774 = validateParameter(valid_594774, JString, required = true,
                                 default = nil)
  if valid_594774 != nil:
    section.add "managerName", valid_594774
  var valid_594775 = path.getOrDefault("subscriptionId")
  valid_594775 = validateParameter(valid_594775, JString, required = true,
                                 default = nil)
  if valid_594775 != nil:
    section.add "subscriptionId", valid_594775
  var valid_594776 = path.getOrDefault("iscsiServerName")
  valid_594776 = validateParameter(valid_594776, JString, required = true,
                                 default = nil)
  if valid_594776 != nil:
    section.add "iscsiServerName", valid_594776
  var valid_594777 = path.getOrDefault("deviceName")
  valid_594777 = validateParameter(valid_594777, JString, required = true,
                                 default = nil)
  if valid_594777 != nil:
    section.add "deviceName", valid_594777
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594778 = query.getOrDefault("api-version")
  valid_594778 = validateParameter(valid_594778, JString, required = true,
                                 default = nil)
  if valid_594778 != nil:
    section.add "api-version", valid_594778
  var valid_594779 = query.getOrDefault("$filter")
  valid_594779 = validateParameter(valid_594779, JString, required = false,
                                 default = nil)
  if valid_594779 != nil:
    section.add "$filter", valid_594779
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594780: Call_IscsiServersListMetrics_594770; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the iSCSI server metrics
  ## 
  let valid = call_594780.validator(path, query, header, formData, body)
  let scheme = call_594780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594780.url(scheme.get, call_594780.host, call_594780.base,
                         call_594780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594780, url, valid)

proc call*(call_594781: Call_IscsiServersListMetrics_594770;
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
  var path_594782 = newJObject()
  var query_594783 = newJObject()
  add(path_594782, "resourceGroupName", newJString(resourceGroupName))
  add(query_594783, "api-version", newJString(apiVersion))
  add(path_594782, "managerName", newJString(managerName))
  add(path_594782, "subscriptionId", newJString(subscriptionId))
  add(path_594782, "iscsiServerName", newJString(iscsiServerName))
  add(query_594783, "$filter", newJString(Filter))
  add(path_594782, "deviceName", newJString(deviceName))
  result = call_594781.call(path_594782, query_594783, nil, nil, nil)

var iscsiServersListMetrics* = Call_IscsiServersListMetrics_594770(
    name: "iscsiServersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/metrics",
    validator: validate_IscsiServersListMetrics_594771, base: "",
    url: url_IscsiServersListMetrics_594772, schemes: {Scheme.Https})
type
  Call_IscsiServersListMetricDefinition_594784 = ref object of OpenApiRestCall_593438
proc url_IscsiServersListMetricDefinition_594786(protocol: Scheme; host: string;
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

proc validate_IscsiServersListMetricDefinition_594785(path: JsonNode;
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
  var valid_594787 = path.getOrDefault("resourceGroupName")
  valid_594787 = validateParameter(valid_594787, JString, required = true,
                                 default = nil)
  if valid_594787 != nil:
    section.add "resourceGroupName", valid_594787
  var valid_594788 = path.getOrDefault("managerName")
  valid_594788 = validateParameter(valid_594788, JString, required = true,
                                 default = nil)
  if valid_594788 != nil:
    section.add "managerName", valid_594788
  var valid_594789 = path.getOrDefault("subscriptionId")
  valid_594789 = validateParameter(valid_594789, JString, required = true,
                                 default = nil)
  if valid_594789 != nil:
    section.add "subscriptionId", valid_594789
  var valid_594790 = path.getOrDefault("iscsiServerName")
  valid_594790 = validateParameter(valid_594790, JString, required = true,
                                 default = nil)
  if valid_594790 != nil:
    section.add "iscsiServerName", valid_594790
  var valid_594791 = path.getOrDefault("deviceName")
  valid_594791 = validateParameter(valid_594791, JString, required = true,
                                 default = nil)
  if valid_594791 != nil:
    section.add "deviceName", valid_594791
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594792 = query.getOrDefault("api-version")
  valid_594792 = validateParameter(valid_594792, JString, required = true,
                                 default = nil)
  if valid_594792 != nil:
    section.add "api-version", valid_594792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594793: Call_IscsiServersListMetricDefinition_594784;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves metric definitions for all metrics aggregated at iSCSI server.
  ## 
  let valid = call_594793.validator(path, query, header, formData, body)
  let scheme = call_594793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594793.url(scheme.get, call_594793.host, call_594793.base,
                         call_594793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594793, url, valid)

proc call*(call_594794: Call_IscsiServersListMetricDefinition_594784;
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
  var path_594795 = newJObject()
  var query_594796 = newJObject()
  add(path_594795, "resourceGroupName", newJString(resourceGroupName))
  add(query_594796, "api-version", newJString(apiVersion))
  add(path_594795, "managerName", newJString(managerName))
  add(path_594795, "subscriptionId", newJString(subscriptionId))
  add(path_594795, "iscsiServerName", newJString(iscsiServerName))
  add(path_594795, "deviceName", newJString(deviceName))
  result = call_594794.call(path_594795, query_594796, nil, nil, nil)

var iscsiServersListMetricDefinition* = Call_IscsiServersListMetricDefinition_594784(
    name: "iscsiServersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/iscsiservers/{iscsiServerName}/metricsDefinitions",
    validator: validate_IscsiServersListMetricDefinition_594785, base: "",
    url: url_IscsiServersListMetricDefinition_594786, schemes: {Scheme.Https})
type
  Call_JobsListByDevice_594797 = ref object of OpenApiRestCall_593438
proc url_JobsListByDevice_594799(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByDevice_594798(path: JsonNode; query: JsonNode;
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
  var valid_594800 = path.getOrDefault("resourceGroupName")
  valid_594800 = validateParameter(valid_594800, JString, required = true,
                                 default = nil)
  if valid_594800 != nil:
    section.add "resourceGroupName", valid_594800
  var valid_594801 = path.getOrDefault("managerName")
  valid_594801 = validateParameter(valid_594801, JString, required = true,
                                 default = nil)
  if valid_594801 != nil:
    section.add "managerName", valid_594801
  var valid_594802 = path.getOrDefault("subscriptionId")
  valid_594802 = validateParameter(valid_594802, JString, required = true,
                                 default = nil)
  if valid_594802 != nil:
    section.add "subscriptionId", valid_594802
  var valid_594803 = path.getOrDefault("deviceName")
  valid_594803 = validateParameter(valid_594803, JString, required = true,
                                 default = nil)
  if valid_594803 != nil:
    section.add "deviceName", valid_594803
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594804 = query.getOrDefault("api-version")
  valid_594804 = validateParameter(valid_594804, JString, required = true,
                                 default = nil)
  if valid_594804 != nil:
    section.add "api-version", valid_594804
  var valid_594805 = query.getOrDefault("$filter")
  valid_594805 = validateParameter(valid_594805, JString, required = false,
                                 default = nil)
  if valid_594805 != nil:
    section.add "$filter", valid_594805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594806: Call_JobsListByDevice_594797; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the jobs in a device.
  ## 
  let valid = call_594806.validator(path, query, header, formData, body)
  let scheme = call_594806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594806.url(scheme.get, call_594806.host, call_594806.base,
                         call_594806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594806, url, valid)

proc call*(call_594807: Call_JobsListByDevice_594797; resourceGroupName: string;
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
  var path_594808 = newJObject()
  var query_594809 = newJObject()
  add(path_594808, "resourceGroupName", newJString(resourceGroupName))
  add(query_594809, "api-version", newJString(apiVersion))
  add(path_594808, "managerName", newJString(managerName))
  add(path_594808, "subscriptionId", newJString(subscriptionId))
  add(query_594809, "$filter", newJString(Filter))
  add(path_594808, "deviceName", newJString(deviceName))
  result = call_594807.call(path_594808, query_594809, nil, nil, nil)

var jobsListByDevice* = Call_JobsListByDevice_594797(name: "jobsListByDevice",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs",
    validator: validate_JobsListByDevice_594798, base: "",
    url: url_JobsListByDevice_594799, schemes: {Scheme.Https})
type
  Call_JobsGet_594810 = ref object of OpenApiRestCall_593438
proc url_JobsGet_594812(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_594811(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594813 = path.getOrDefault("resourceGroupName")
  valid_594813 = validateParameter(valid_594813, JString, required = true,
                                 default = nil)
  if valid_594813 != nil:
    section.add "resourceGroupName", valid_594813
  var valid_594814 = path.getOrDefault("managerName")
  valid_594814 = validateParameter(valid_594814, JString, required = true,
                                 default = nil)
  if valid_594814 != nil:
    section.add "managerName", valid_594814
  var valid_594815 = path.getOrDefault("subscriptionId")
  valid_594815 = validateParameter(valid_594815, JString, required = true,
                                 default = nil)
  if valid_594815 != nil:
    section.add "subscriptionId", valid_594815
  var valid_594816 = path.getOrDefault("jobName")
  valid_594816 = validateParameter(valid_594816, JString, required = true,
                                 default = nil)
  if valid_594816 != nil:
    section.add "jobName", valid_594816
  var valid_594817 = path.getOrDefault("deviceName")
  valid_594817 = validateParameter(valid_594817, JString, required = true,
                                 default = nil)
  if valid_594817 != nil:
    section.add "deviceName", valid_594817
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594818 = query.getOrDefault("api-version")
  valid_594818 = validateParameter(valid_594818, JString, required = true,
                                 default = nil)
  if valid_594818 != nil:
    section.add "api-version", valid_594818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594819: Call_JobsGet_594810; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified job name.
  ## 
  let valid = call_594819.validator(path, query, header, formData, body)
  let scheme = call_594819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594819.url(scheme.get, call_594819.host, call_594819.base,
                         call_594819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594819, url, valid)

proc call*(call_594820: Call_JobsGet_594810; resourceGroupName: string;
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
  var path_594821 = newJObject()
  var query_594822 = newJObject()
  add(path_594821, "resourceGroupName", newJString(resourceGroupName))
  add(query_594822, "api-version", newJString(apiVersion))
  add(path_594821, "managerName", newJString(managerName))
  add(path_594821, "subscriptionId", newJString(subscriptionId))
  add(path_594821, "jobName", newJString(jobName))
  add(path_594821, "deviceName", newJString(deviceName))
  result = call_594820.call(path_594821, query_594822, nil, nil, nil)

var jobsGet* = Call_JobsGet_594810(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs/{jobName}",
                                validator: validate_JobsGet_594811, base: "",
                                url: url_JobsGet_594812, schemes: {Scheme.Https})
type
  Call_DevicesListMetrics_594823 = ref object of OpenApiRestCall_593438
proc url_DevicesListMetrics_594825(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesListMetrics_594824(path: JsonNode; query: JsonNode;
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
  var valid_594826 = path.getOrDefault("resourceGroupName")
  valid_594826 = validateParameter(valid_594826, JString, required = true,
                                 default = nil)
  if valid_594826 != nil:
    section.add "resourceGroupName", valid_594826
  var valid_594827 = path.getOrDefault("managerName")
  valid_594827 = validateParameter(valid_594827, JString, required = true,
                                 default = nil)
  if valid_594827 != nil:
    section.add "managerName", valid_594827
  var valid_594828 = path.getOrDefault("subscriptionId")
  valid_594828 = validateParameter(valid_594828, JString, required = true,
                                 default = nil)
  if valid_594828 != nil:
    section.add "subscriptionId", valid_594828
  var valid_594829 = path.getOrDefault("deviceName")
  valid_594829 = validateParameter(valid_594829, JString, required = true,
                                 default = nil)
  if valid_594829 != nil:
    section.add "deviceName", valid_594829
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594830 = query.getOrDefault("api-version")
  valid_594830 = validateParameter(valid_594830, JString, required = true,
                                 default = nil)
  if valid_594830 != nil:
    section.add "api-version", valid_594830
  var valid_594831 = query.getOrDefault("$filter")
  valid_594831 = validateParameter(valid_594831, JString, required = false,
                                 default = nil)
  if valid_594831 != nil:
    section.add "$filter", valid_594831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594832: Call_DevicesListMetrics_594823; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the device metrics.
  ## 
  let valid = call_594832.validator(path, query, header, formData, body)
  let scheme = call_594832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594832.url(scheme.get, call_594832.host, call_594832.base,
                         call_594832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594832, url, valid)

proc call*(call_594833: Call_DevicesListMetrics_594823; resourceGroupName: string;
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
  var path_594834 = newJObject()
  var query_594835 = newJObject()
  add(path_594834, "resourceGroupName", newJString(resourceGroupName))
  add(query_594835, "api-version", newJString(apiVersion))
  add(path_594834, "managerName", newJString(managerName))
  add(path_594834, "subscriptionId", newJString(subscriptionId))
  add(query_594835, "$filter", newJString(Filter))
  add(path_594834, "deviceName", newJString(deviceName))
  result = call_594833.call(path_594834, query_594835, nil, nil, nil)

var devicesListMetrics* = Call_DevicesListMetrics_594823(
    name: "devicesListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/metrics",
    validator: validate_DevicesListMetrics_594824, base: "",
    url: url_DevicesListMetrics_594825, schemes: {Scheme.Https})
type
  Call_DevicesListMetricDefinition_594836 = ref object of OpenApiRestCall_593438
proc url_DevicesListMetricDefinition_594838(protocol: Scheme; host: string;
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

proc validate_DevicesListMetricDefinition_594837(path: JsonNode; query: JsonNode;
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
  var valid_594839 = path.getOrDefault("resourceGroupName")
  valid_594839 = validateParameter(valid_594839, JString, required = true,
                                 default = nil)
  if valid_594839 != nil:
    section.add "resourceGroupName", valid_594839
  var valid_594840 = path.getOrDefault("managerName")
  valid_594840 = validateParameter(valid_594840, JString, required = true,
                                 default = nil)
  if valid_594840 != nil:
    section.add "managerName", valid_594840
  var valid_594841 = path.getOrDefault("subscriptionId")
  valid_594841 = validateParameter(valid_594841, JString, required = true,
                                 default = nil)
  if valid_594841 != nil:
    section.add "subscriptionId", valid_594841
  var valid_594842 = path.getOrDefault("deviceName")
  valid_594842 = validateParameter(valid_594842, JString, required = true,
                                 default = nil)
  if valid_594842 != nil:
    section.add "deviceName", valid_594842
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594843 = query.getOrDefault("api-version")
  valid_594843 = validateParameter(valid_594843, JString, required = true,
                                 default = nil)
  if valid_594843 != nil:
    section.add "api-version", valid_594843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594844: Call_DevicesListMetricDefinition_594836; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definition of all metrics aggregated at device.
  ## 
  let valid = call_594844.validator(path, query, header, formData, body)
  let scheme = call_594844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594844.url(scheme.get, call_594844.host, call_594844.base,
                         call_594844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594844, url, valid)

proc call*(call_594845: Call_DevicesListMetricDefinition_594836;
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
  var path_594846 = newJObject()
  var query_594847 = newJObject()
  add(path_594846, "resourceGroupName", newJString(resourceGroupName))
  add(query_594847, "api-version", newJString(apiVersion))
  add(path_594846, "managerName", newJString(managerName))
  add(path_594846, "subscriptionId", newJString(subscriptionId))
  add(path_594846, "deviceName", newJString(deviceName))
  result = call_594845.call(path_594846, query_594847, nil, nil, nil)

var devicesListMetricDefinition* = Call_DevicesListMetricDefinition_594836(
    name: "devicesListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/metricsDefinitions",
    validator: validate_DevicesListMetricDefinition_594837, base: "",
    url: url_DevicesListMetricDefinition_594838, schemes: {Scheme.Https})
type
  Call_DevicesGetNetworkSettings_594848 = ref object of OpenApiRestCall_593438
proc url_DevicesGetNetworkSettings_594850(protocol: Scheme; host: string;
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

proc validate_DevicesGetNetworkSettings_594849(path: JsonNode; query: JsonNode;
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
  var valid_594851 = path.getOrDefault("resourceGroupName")
  valid_594851 = validateParameter(valid_594851, JString, required = true,
                                 default = nil)
  if valid_594851 != nil:
    section.add "resourceGroupName", valid_594851
  var valid_594852 = path.getOrDefault("managerName")
  valid_594852 = validateParameter(valid_594852, JString, required = true,
                                 default = nil)
  if valid_594852 != nil:
    section.add "managerName", valid_594852
  var valid_594853 = path.getOrDefault("subscriptionId")
  valid_594853 = validateParameter(valid_594853, JString, required = true,
                                 default = nil)
  if valid_594853 != nil:
    section.add "subscriptionId", valid_594853
  var valid_594854 = path.getOrDefault("deviceName")
  valid_594854 = validateParameter(valid_594854, JString, required = true,
                                 default = nil)
  if valid_594854 != nil:
    section.add "deviceName", valid_594854
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594855 = query.getOrDefault("api-version")
  valid_594855 = validateParameter(valid_594855, JString, required = true,
                                 default = nil)
  if valid_594855 != nil:
    section.add "api-version", valid_594855
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594856: Call_DevicesGetNetworkSettings_594848; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the network settings of the specified device name.
  ## 
  let valid = call_594856.validator(path, query, header, formData, body)
  let scheme = call_594856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594856.url(scheme.get, call_594856.host, call_594856.base,
                         call_594856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594856, url, valid)

proc call*(call_594857: Call_DevicesGetNetworkSettings_594848;
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
  var path_594858 = newJObject()
  var query_594859 = newJObject()
  add(path_594858, "resourceGroupName", newJString(resourceGroupName))
  add(query_594859, "api-version", newJString(apiVersion))
  add(path_594858, "managerName", newJString(managerName))
  add(path_594858, "subscriptionId", newJString(subscriptionId))
  add(path_594858, "deviceName", newJString(deviceName))
  result = call_594857.call(path_594858, query_594859, nil, nil, nil)

var devicesGetNetworkSettings* = Call_DevicesGetNetworkSettings_594848(
    name: "devicesGetNetworkSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/networkSettings/default",
    validator: validate_DevicesGetNetworkSettings_594849, base: "",
    url: url_DevicesGetNetworkSettings_594850, schemes: {Scheme.Https})
type
  Call_DevicesScanForUpdates_594860 = ref object of OpenApiRestCall_593438
proc url_DevicesScanForUpdates_594862(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesScanForUpdates_594861(path: JsonNode; query: JsonNode;
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
  var valid_594863 = path.getOrDefault("resourceGroupName")
  valid_594863 = validateParameter(valid_594863, JString, required = true,
                                 default = nil)
  if valid_594863 != nil:
    section.add "resourceGroupName", valid_594863
  var valid_594864 = path.getOrDefault("managerName")
  valid_594864 = validateParameter(valid_594864, JString, required = true,
                                 default = nil)
  if valid_594864 != nil:
    section.add "managerName", valid_594864
  var valid_594865 = path.getOrDefault("subscriptionId")
  valid_594865 = validateParameter(valid_594865, JString, required = true,
                                 default = nil)
  if valid_594865 != nil:
    section.add "subscriptionId", valid_594865
  var valid_594866 = path.getOrDefault("deviceName")
  valid_594866 = validateParameter(valid_594866, JString, required = true,
                                 default = nil)
  if valid_594866 != nil:
    section.add "deviceName", valid_594866
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594867 = query.getOrDefault("api-version")
  valid_594867 = validateParameter(valid_594867, JString, required = true,
                                 default = nil)
  if valid_594867 != nil:
    section.add "api-version", valid_594867
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594868: Call_DevicesScanForUpdates_594860; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scans for updates on the device.
  ## 
  let valid = call_594868.validator(path, query, header, formData, body)
  let scheme = call_594868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594868.url(scheme.get, call_594868.host, call_594868.base,
                         call_594868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594868, url, valid)

proc call*(call_594869: Call_DevicesScanForUpdates_594860;
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
  var path_594870 = newJObject()
  var query_594871 = newJObject()
  add(path_594870, "resourceGroupName", newJString(resourceGroupName))
  add(query_594871, "api-version", newJString(apiVersion))
  add(path_594870, "managerName", newJString(managerName))
  add(path_594870, "subscriptionId", newJString(subscriptionId))
  add(path_594870, "deviceName", newJString(deviceName))
  result = call_594869.call(path_594870, query_594871, nil, nil, nil)

var devicesScanForUpdates* = Call_DevicesScanForUpdates_594860(
    name: "devicesScanForUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/scanForUpdates",
    validator: validate_DevicesScanForUpdates_594861, base: "",
    url: url_DevicesScanForUpdates_594862, schemes: {Scheme.Https})
type
  Call_DevicesCreateOrUpdateSecuritySettings_594872 = ref object of OpenApiRestCall_593438
proc url_DevicesCreateOrUpdateSecuritySettings_594874(protocol: Scheme;
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

proc validate_DevicesCreateOrUpdateSecuritySettings_594873(path: JsonNode;
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
  var valid_594875 = path.getOrDefault("resourceGroupName")
  valid_594875 = validateParameter(valid_594875, JString, required = true,
                                 default = nil)
  if valid_594875 != nil:
    section.add "resourceGroupName", valid_594875
  var valid_594876 = path.getOrDefault("managerName")
  valid_594876 = validateParameter(valid_594876, JString, required = true,
                                 default = nil)
  if valid_594876 != nil:
    section.add "managerName", valid_594876
  var valid_594877 = path.getOrDefault("subscriptionId")
  valid_594877 = validateParameter(valid_594877, JString, required = true,
                                 default = nil)
  if valid_594877 != nil:
    section.add "subscriptionId", valid_594877
  var valid_594878 = path.getOrDefault("deviceName")
  valid_594878 = validateParameter(valid_594878, JString, required = true,
                                 default = nil)
  if valid_594878 != nil:
    section.add "deviceName", valid_594878
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594879 = query.getOrDefault("api-version")
  valid_594879 = validateParameter(valid_594879, JString, required = true,
                                 default = nil)
  if valid_594879 != nil:
    section.add "api-version", valid_594879
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

proc call*(call_594881: Call_DevicesCreateOrUpdateSecuritySettings_594872;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the security settings.
  ## 
  let valid = call_594881.validator(path, query, header, formData, body)
  let scheme = call_594881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594881.url(scheme.get, call_594881.host, call_594881.base,
                         call_594881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594881, url, valid)

proc call*(call_594882: Call_DevicesCreateOrUpdateSecuritySettings_594872;
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
  var path_594883 = newJObject()
  var query_594884 = newJObject()
  var body_594885 = newJObject()
  add(path_594883, "resourceGroupName", newJString(resourceGroupName))
  add(query_594884, "api-version", newJString(apiVersion))
  add(path_594883, "managerName", newJString(managerName))
  if securitySettings != nil:
    body_594885 = securitySettings
  add(path_594883, "subscriptionId", newJString(subscriptionId))
  add(path_594883, "deviceName", newJString(deviceName))
  result = call_594882.call(path_594883, query_594884, nil, nil, body_594885)

var devicesCreateOrUpdateSecuritySettings* = Call_DevicesCreateOrUpdateSecuritySettings_594872(
    name: "devicesCreateOrUpdateSecuritySettings", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/securitySettings/default/update",
    validator: validate_DevicesCreateOrUpdateSecuritySettings_594873, base: "",
    url: url_DevicesCreateOrUpdateSecuritySettings_594874, schemes: {Scheme.Https})
type
  Call_AlertsSendTestEmail_594886 = ref object of OpenApiRestCall_593438
proc url_AlertsSendTestEmail_594888(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsSendTestEmail_594887(path: JsonNode; query: JsonNode;
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
  var valid_594889 = path.getOrDefault("resourceGroupName")
  valid_594889 = validateParameter(valid_594889, JString, required = true,
                                 default = nil)
  if valid_594889 != nil:
    section.add "resourceGroupName", valid_594889
  var valid_594890 = path.getOrDefault("managerName")
  valid_594890 = validateParameter(valid_594890, JString, required = true,
                                 default = nil)
  if valid_594890 != nil:
    section.add "managerName", valid_594890
  var valid_594891 = path.getOrDefault("subscriptionId")
  valid_594891 = validateParameter(valid_594891, JString, required = true,
                                 default = nil)
  if valid_594891 != nil:
    section.add "subscriptionId", valid_594891
  var valid_594892 = path.getOrDefault("deviceName")
  valid_594892 = validateParameter(valid_594892, JString, required = true,
                                 default = nil)
  if valid_594892 != nil:
    section.add "deviceName", valid_594892
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594893 = query.getOrDefault("api-version")
  valid_594893 = validateParameter(valid_594893, JString, required = true,
                                 default = nil)
  if valid_594893 != nil:
    section.add "api-version", valid_594893
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

proc call*(call_594895: Call_AlertsSendTestEmail_594886; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a test alert email.
  ## 
  let valid = call_594895.validator(path, query, header, formData, body)
  let scheme = call_594895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594895.url(scheme.get, call_594895.host, call_594895.base,
                         call_594895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594895, url, valid)

proc call*(call_594896: Call_AlertsSendTestEmail_594886; resourceGroupName: string;
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
  var path_594897 = newJObject()
  var query_594898 = newJObject()
  var body_594899 = newJObject()
  add(path_594897, "resourceGroupName", newJString(resourceGroupName))
  add(query_594898, "api-version", newJString(apiVersion))
  add(path_594897, "managerName", newJString(managerName))
  add(path_594897, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_594899 = request
  add(path_594897, "deviceName", newJString(deviceName))
  result = call_594896.call(path_594897, query_594898, nil, nil, body_594899)

var alertsSendTestEmail* = Call_AlertsSendTestEmail_594886(
    name: "alertsSendTestEmail", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/sendTestAlertEmail",
    validator: validate_AlertsSendTestEmail_594887, base: "",
    url: url_AlertsSendTestEmail_594888, schemes: {Scheme.Https})
type
  Call_FileSharesListByDevice_594900 = ref object of OpenApiRestCall_593438
proc url_FileSharesListByDevice_594902(protocol: Scheme; host: string; base: string;
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

proc validate_FileSharesListByDevice_594901(path: JsonNode; query: JsonNode;
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
  var valid_594903 = path.getOrDefault("resourceGroupName")
  valid_594903 = validateParameter(valid_594903, JString, required = true,
                                 default = nil)
  if valid_594903 != nil:
    section.add "resourceGroupName", valid_594903
  var valid_594904 = path.getOrDefault("managerName")
  valid_594904 = validateParameter(valid_594904, JString, required = true,
                                 default = nil)
  if valid_594904 != nil:
    section.add "managerName", valid_594904
  var valid_594905 = path.getOrDefault("subscriptionId")
  valid_594905 = validateParameter(valid_594905, JString, required = true,
                                 default = nil)
  if valid_594905 != nil:
    section.add "subscriptionId", valid_594905
  var valid_594906 = path.getOrDefault("deviceName")
  valid_594906 = validateParameter(valid_594906, JString, required = true,
                                 default = nil)
  if valid_594906 != nil:
    section.add "deviceName", valid_594906
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594907 = query.getOrDefault("api-version")
  valid_594907 = validateParameter(valid_594907, JString, required = true,
                                 default = nil)
  if valid_594907 != nil:
    section.add "api-version", valid_594907
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594908: Call_FileSharesListByDevice_594900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the file shares in a device.
  ## 
  let valid = call_594908.validator(path, query, header, formData, body)
  let scheme = call_594908.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594908.url(scheme.get, call_594908.host, call_594908.base,
                         call_594908.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594908, url, valid)

proc call*(call_594909: Call_FileSharesListByDevice_594900;
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
  var path_594910 = newJObject()
  var query_594911 = newJObject()
  add(path_594910, "resourceGroupName", newJString(resourceGroupName))
  add(query_594911, "api-version", newJString(apiVersion))
  add(path_594910, "managerName", newJString(managerName))
  add(path_594910, "subscriptionId", newJString(subscriptionId))
  add(path_594910, "deviceName", newJString(deviceName))
  result = call_594909.call(path_594910, query_594911, nil, nil, nil)

var fileSharesListByDevice* = Call_FileSharesListByDevice_594900(
    name: "fileSharesListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/shares",
    validator: validate_FileSharesListByDevice_594901, base: "",
    url: url_FileSharesListByDevice_594902, schemes: {Scheme.Https})
type
  Call_DevicesGetTimeSettings_594912 = ref object of OpenApiRestCall_593438
proc url_DevicesGetTimeSettings_594914(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetTimeSettings_594913(path: JsonNode; query: JsonNode;
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
  var valid_594915 = path.getOrDefault("resourceGroupName")
  valid_594915 = validateParameter(valid_594915, JString, required = true,
                                 default = nil)
  if valid_594915 != nil:
    section.add "resourceGroupName", valid_594915
  var valid_594916 = path.getOrDefault("managerName")
  valid_594916 = validateParameter(valid_594916, JString, required = true,
                                 default = nil)
  if valid_594916 != nil:
    section.add "managerName", valid_594916
  var valid_594917 = path.getOrDefault("subscriptionId")
  valid_594917 = validateParameter(valid_594917, JString, required = true,
                                 default = nil)
  if valid_594917 != nil:
    section.add "subscriptionId", valid_594917
  var valid_594918 = path.getOrDefault("deviceName")
  valid_594918 = validateParameter(valid_594918, JString, required = true,
                                 default = nil)
  if valid_594918 != nil:
    section.add "deviceName", valid_594918
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594919 = query.getOrDefault("api-version")
  valid_594919 = validateParameter(valid_594919, JString, required = true,
                                 default = nil)
  if valid_594919 != nil:
    section.add "api-version", valid_594919
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594920: Call_DevicesGetTimeSettings_594912; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the time settings of the specified device name.
  ## 
  let valid = call_594920.validator(path, query, header, formData, body)
  let scheme = call_594920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594920.url(scheme.get, call_594920.host, call_594920.base,
                         call_594920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594920, url, valid)

proc call*(call_594921: Call_DevicesGetTimeSettings_594912;
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
  var path_594922 = newJObject()
  var query_594923 = newJObject()
  add(path_594922, "resourceGroupName", newJString(resourceGroupName))
  add(query_594923, "api-version", newJString(apiVersion))
  add(path_594922, "managerName", newJString(managerName))
  add(path_594922, "subscriptionId", newJString(subscriptionId))
  add(path_594922, "deviceName", newJString(deviceName))
  result = call_594921.call(path_594922, query_594923, nil, nil, nil)

var devicesGetTimeSettings* = Call_DevicesGetTimeSettings_594912(
    name: "devicesGetTimeSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/timeSettings/default",
    validator: validate_DevicesGetTimeSettings_594913, base: "",
    url: url_DevicesGetTimeSettings_594914, schemes: {Scheme.Https})
type
  Call_DevicesGetUpdateSummary_594924 = ref object of OpenApiRestCall_593438
proc url_DevicesGetUpdateSummary_594926(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetUpdateSummary_594925(path: JsonNode; query: JsonNode;
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
  var valid_594927 = path.getOrDefault("resourceGroupName")
  valid_594927 = validateParameter(valid_594927, JString, required = true,
                                 default = nil)
  if valid_594927 != nil:
    section.add "resourceGroupName", valid_594927
  var valid_594928 = path.getOrDefault("managerName")
  valid_594928 = validateParameter(valid_594928, JString, required = true,
                                 default = nil)
  if valid_594928 != nil:
    section.add "managerName", valid_594928
  var valid_594929 = path.getOrDefault("subscriptionId")
  valid_594929 = validateParameter(valid_594929, JString, required = true,
                                 default = nil)
  if valid_594929 != nil:
    section.add "subscriptionId", valid_594929
  var valid_594930 = path.getOrDefault("deviceName")
  valid_594930 = validateParameter(valid_594930, JString, required = true,
                                 default = nil)
  if valid_594930 != nil:
    section.add "deviceName", valid_594930
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594931 = query.getOrDefault("api-version")
  valid_594931 = validateParameter(valid_594931, JString, required = true,
                                 default = nil)
  if valid_594931 != nil:
    section.add "api-version", valid_594931
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594932: Call_DevicesGetUpdateSummary_594924; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the update summary of the specified device name.
  ## 
  let valid = call_594932.validator(path, query, header, formData, body)
  let scheme = call_594932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594932.url(scheme.get, call_594932.host, call_594932.base,
                         call_594932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594932, url, valid)

proc call*(call_594933: Call_DevicesGetUpdateSummary_594924;
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
  var path_594934 = newJObject()
  var query_594935 = newJObject()
  add(path_594934, "resourceGroupName", newJString(resourceGroupName))
  add(query_594935, "api-version", newJString(apiVersion))
  add(path_594934, "managerName", newJString(managerName))
  add(path_594934, "subscriptionId", newJString(subscriptionId))
  add(path_594934, "deviceName", newJString(deviceName))
  result = call_594933.call(path_594934, query_594935, nil, nil, nil)

var devicesGetUpdateSummary* = Call_DevicesGetUpdateSummary_594924(
    name: "devicesGetUpdateSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/updateSummary/default",
    validator: validate_DevicesGetUpdateSummary_594925, base: "",
    url: url_DevicesGetUpdateSummary_594926, schemes: {Scheme.Https})
type
  Call_ManagersGetEncryptionSettings_594936 = ref object of OpenApiRestCall_593438
proc url_ManagersGetEncryptionSettings_594938(protocol: Scheme; host: string;
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

proc validate_ManagersGetEncryptionSettings_594937(path: JsonNode; query: JsonNode;
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
  var valid_594939 = path.getOrDefault("resourceGroupName")
  valid_594939 = validateParameter(valid_594939, JString, required = true,
                                 default = nil)
  if valid_594939 != nil:
    section.add "resourceGroupName", valid_594939
  var valid_594940 = path.getOrDefault("managerName")
  valid_594940 = validateParameter(valid_594940, JString, required = true,
                                 default = nil)
  if valid_594940 != nil:
    section.add "managerName", valid_594940
  var valid_594941 = path.getOrDefault("subscriptionId")
  valid_594941 = validateParameter(valid_594941, JString, required = true,
                                 default = nil)
  if valid_594941 != nil:
    section.add "subscriptionId", valid_594941
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594942 = query.getOrDefault("api-version")
  valid_594942 = validateParameter(valid_594942, JString, required = true,
                                 default = nil)
  if valid_594942 != nil:
    section.add "api-version", valid_594942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594943: Call_ManagersGetEncryptionSettings_594936; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the encryption settings of the manager.
  ## 
  let valid = call_594943.validator(path, query, header, formData, body)
  let scheme = call_594943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594943.url(scheme.get, call_594943.host, call_594943.base,
                         call_594943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594943, url, valid)

proc call*(call_594944: Call_ManagersGetEncryptionSettings_594936;
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
  var path_594945 = newJObject()
  var query_594946 = newJObject()
  add(path_594945, "resourceGroupName", newJString(resourceGroupName))
  add(query_594946, "api-version", newJString(apiVersion))
  add(path_594945, "managerName", newJString(managerName))
  add(path_594945, "subscriptionId", newJString(subscriptionId))
  result = call_594944.call(path_594945, query_594946, nil, nil, nil)

var managersGetEncryptionSettings* = Call_ManagersGetEncryptionSettings_594936(
    name: "managersGetEncryptionSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/encryptionSettings/default",
    validator: validate_ManagersGetEncryptionSettings_594937, base: "",
    url: url_ManagersGetEncryptionSettings_594938, schemes: {Scheme.Https})
type
  Call_ManagersCreateExtendedInfo_594958 = ref object of OpenApiRestCall_593438
proc url_ManagersCreateExtendedInfo_594960(protocol: Scheme; host: string;
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

proc validate_ManagersCreateExtendedInfo_594959(path: JsonNode; query: JsonNode;
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
  var valid_594961 = path.getOrDefault("resourceGroupName")
  valid_594961 = validateParameter(valid_594961, JString, required = true,
                                 default = nil)
  if valid_594961 != nil:
    section.add "resourceGroupName", valid_594961
  var valid_594962 = path.getOrDefault("managerName")
  valid_594962 = validateParameter(valid_594962, JString, required = true,
                                 default = nil)
  if valid_594962 != nil:
    section.add "managerName", valid_594962
  var valid_594963 = path.getOrDefault("subscriptionId")
  valid_594963 = validateParameter(valid_594963, JString, required = true,
                                 default = nil)
  if valid_594963 != nil:
    section.add "subscriptionId", valid_594963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594964 = query.getOrDefault("api-version")
  valid_594964 = validateParameter(valid_594964, JString, required = true,
                                 default = nil)
  if valid_594964 != nil:
    section.add "api-version", valid_594964
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

proc call*(call_594966: Call_ManagersCreateExtendedInfo_594958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the extended info of the manager.
  ## 
  let valid = call_594966.validator(path, query, header, formData, body)
  let scheme = call_594966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594966.url(scheme.get, call_594966.host, call_594966.base,
                         call_594966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594966, url, valid)

proc call*(call_594967: Call_ManagersCreateExtendedInfo_594958;
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
  var path_594968 = newJObject()
  var query_594969 = newJObject()
  var body_594970 = newJObject()
  add(path_594968, "resourceGroupName", newJString(resourceGroupName))
  add(query_594969, "api-version", newJString(apiVersion))
  add(path_594968, "managerName", newJString(managerName))
  add(path_594968, "subscriptionId", newJString(subscriptionId))
  if ManagerExtendedInfo != nil:
    body_594970 = ManagerExtendedInfo
  result = call_594967.call(path_594968, query_594969, nil, nil, body_594970)

var managersCreateExtendedInfo* = Call_ManagersCreateExtendedInfo_594958(
    name: "managersCreateExtendedInfo", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersCreateExtendedInfo_594959, base: "",
    url: url_ManagersCreateExtendedInfo_594960, schemes: {Scheme.Https})
type
  Call_ManagersGetExtendedInfo_594947 = ref object of OpenApiRestCall_593438
proc url_ManagersGetExtendedInfo_594949(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersGetExtendedInfo_594948(path: JsonNode; query: JsonNode;
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
  var valid_594950 = path.getOrDefault("resourceGroupName")
  valid_594950 = validateParameter(valid_594950, JString, required = true,
                                 default = nil)
  if valid_594950 != nil:
    section.add "resourceGroupName", valid_594950
  var valid_594951 = path.getOrDefault("managerName")
  valid_594951 = validateParameter(valid_594951, JString, required = true,
                                 default = nil)
  if valid_594951 != nil:
    section.add "managerName", valid_594951
  var valid_594952 = path.getOrDefault("subscriptionId")
  valid_594952 = validateParameter(valid_594952, JString, required = true,
                                 default = nil)
  if valid_594952 != nil:
    section.add "subscriptionId", valid_594952
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594953 = query.getOrDefault("api-version")
  valid_594953 = validateParameter(valid_594953, JString, required = true,
                                 default = nil)
  if valid_594953 != nil:
    section.add "api-version", valid_594953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594954: Call_ManagersGetExtendedInfo_594947; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the extended information of the specified manager name.
  ## 
  let valid = call_594954.validator(path, query, header, formData, body)
  let scheme = call_594954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594954.url(scheme.get, call_594954.host, call_594954.base,
                         call_594954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594954, url, valid)

proc call*(call_594955: Call_ManagersGetExtendedInfo_594947;
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
  var path_594956 = newJObject()
  var query_594957 = newJObject()
  add(path_594956, "resourceGroupName", newJString(resourceGroupName))
  add(query_594957, "api-version", newJString(apiVersion))
  add(path_594956, "managerName", newJString(managerName))
  add(path_594956, "subscriptionId", newJString(subscriptionId))
  result = call_594955.call(path_594956, query_594957, nil, nil, nil)

var managersGetExtendedInfo* = Call_ManagersGetExtendedInfo_594947(
    name: "managersGetExtendedInfo", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersGetExtendedInfo_594948, base: "",
    url: url_ManagersGetExtendedInfo_594949, schemes: {Scheme.Https})
type
  Call_ManagersUpdateExtendedInfo_594982 = ref object of OpenApiRestCall_593438
proc url_ManagersUpdateExtendedInfo_594984(protocol: Scheme; host: string;
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

proc validate_ManagersUpdateExtendedInfo_594983(path: JsonNode; query: JsonNode;
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
  var valid_594985 = path.getOrDefault("resourceGroupName")
  valid_594985 = validateParameter(valid_594985, JString, required = true,
                                 default = nil)
  if valid_594985 != nil:
    section.add "resourceGroupName", valid_594985
  var valid_594986 = path.getOrDefault("managerName")
  valid_594986 = validateParameter(valid_594986, JString, required = true,
                                 default = nil)
  if valid_594986 != nil:
    section.add "managerName", valid_594986
  var valid_594987 = path.getOrDefault("subscriptionId")
  valid_594987 = validateParameter(valid_594987, JString, required = true,
                                 default = nil)
  if valid_594987 != nil:
    section.add "subscriptionId", valid_594987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594988 = query.getOrDefault("api-version")
  valid_594988 = validateParameter(valid_594988, JString, required = true,
                                 default = nil)
  if valid_594988 != nil:
    section.add "api-version", valid_594988
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : Pass the ETag of ExtendedInfo fetched from GET call
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594989 = header.getOrDefault("If-Match")
  valid_594989 = validateParameter(valid_594989, JString, required = true,
                                 default = nil)
  if valid_594989 != nil:
    section.add "If-Match", valid_594989
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

proc call*(call_594991: Call_ManagersUpdateExtendedInfo_594982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the extended info of the manager.
  ## 
  let valid = call_594991.validator(path, query, header, formData, body)
  let scheme = call_594991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594991.url(scheme.get, call_594991.host, call_594991.base,
                         call_594991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594991, url, valid)

proc call*(call_594992: Call_ManagersUpdateExtendedInfo_594982;
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
  var path_594993 = newJObject()
  var query_594994 = newJObject()
  var body_594995 = newJObject()
  add(path_594993, "resourceGroupName", newJString(resourceGroupName))
  add(query_594994, "api-version", newJString(apiVersion))
  add(path_594993, "managerName", newJString(managerName))
  add(path_594993, "subscriptionId", newJString(subscriptionId))
  if ManagerExtendedInfo != nil:
    body_594995 = ManagerExtendedInfo
  result = call_594992.call(path_594993, query_594994, nil, nil, body_594995)

var managersUpdateExtendedInfo* = Call_ManagersUpdateExtendedInfo_594982(
    name: "managersUpdateExtendedInfo", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersUpdateExtendedInfo_594983, base: "",
    url: url_ManagersUpdateExtendedInfo_594984, schemes: {Scheme.Https})
type
  Call_ManagersDeleteExtendedInfo_594971 = ref object of OpenApiRestCall_593438
proc url_ManagersDeleteExtendedInfo_594973(protocol: Scheme; host: string;
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

proc validate_ManagersDeleteExtendedInfo_594972(path: JsonNode; query: JsonNode;
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
  var valid_594974 = path.getOrDefault("resourceGroupName")
  valid_594974 = validateParameter(valid_594974, JString, required = true,
                                 default = nil)
  if valid_594974 != nil:
    section.add "resourceGroupName", valid_594974
  var valid_594975 = path.getOrDefault("managerName")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "managerName", valid_594975
  var valid_594976 = path.getOrDefault("subscriptionId")
  valid_594976 = validateParameter(valid_594976, JString, required = true,
                                 default = nil)
  if valid_594976 != nil:
    section.add "subscriptionId", valid_594976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594977 = query.getOrDefault("api-version")
  valid_594977 = validateParameter(valid_594977, JString, required = true,
                                 default = nil)
  if valid_594977 != nil:
    section.add "api-version", valid_594977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594978: Call_ManagersDeleteExtendedInfo_594971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the extended info of the manager.
  ## 
  let valid = call_594978.validator(path, query, header, formData, body)
  let scheme = call_594978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594978.url(scheme.get, call_594978.host, call_594978.base,
                         call_594978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594978, url, valid)

proc call*(call_594979: Call_ManagersDeleteExtendedInfo_594971;
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
  var path_594980 = newJObject()
  var query_594981 = newJObject()
  add(path_594980, "resourceGroupName", newJString(resourceGroupName))
  add(query_594981, "api-version", newJString(apiVersion))
  add(path_594980, "managerName", newJString(managerName))
  add(path_594980, "subscriptionId", newJString(subscriptionId))
  result = call_594979.call(path_594980, query_594981, nil, nil, nil)

var managersDeleteExtendedInfo* = Call_ManagersDeleteExtendedInfo_594971(
    name: "managersDeleteExtendedInfo", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersDeleteExtendedInfo_594972, base: "",
    url: url_ManagersDeleteExtendedInfo_594973, schemes: {Scheme.Https})
type
  Call_FileServersListByManager_594996 = ref object of OpenApiRestCall_593438
proc url_FileServersListByManager_594998(protocol: Scheme; host: string;
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

proc validate_FileServersListByManager_594997(path: JsonNode; query: JsonNode;
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
  var valid_594999 = path.getOrDefault("resourceGroupName")
  valid_594999 = validateParameter(valid_594999, JString, required = true,
                                 default = nil)
  if valid_594999 != nil:
    section.add "resourceGroupName", valid_594999
  var valid_595000 = path.getOrDefault("managerName")
  valid_595000 = validateParameter(valid_595000, JString, required = true,
                                 default = nil)
  if valid_595000 != nil:
    section.add "managerName", valid_595000
  var valid_595001 = path.getOrDefault("subscriptionId")
  valid_595001 = validateParameter(valid_595001, JString, required = true,
                                 default = nil)
  if valid_595001 != nil:
    section.add "subscriptionId", valid_595001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595002 = query.getOrDefault("api-version")
  valid_595002 = validateParameter(valid_595002, JString, required = true,
                                 default = nil)
  if valid_595002 != nil:
    section.add "api-version", valid_595002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595003: Call_FileServersListByManager_594996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the file servers in a manager.
  ## 
  let valid = call_595003.validator(path, query, header, formData, body)
  let scheme = call_595003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595003.url(scheme.get, call_595003.host, call_595003.base,
                         call_595003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595003, url, valid)

proc call*(call_595004: Call_FileServersListByManager_594996;
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
  var path_595005 = newJObject()
  var query_595006 = newJObject()
  add(path_595005, "resourceGroupName", newJString(resourceGroupName))
  add(query_595006, "api-version", newJString(apiVersion))
  add(path_595005, "managerName", newJString(managerName))
  add(path_595005, "subscriptionId", newJString(subscriptionId))
  result = call_595004.call(path_595005, query_595006, nil, nil, nil)

var fileServersListByManager* = Call_FileServersListByManager_594996(
    name: "fileServersListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/fileservers",
    validator: validate_FileServersListByManager_594997, base: "",
    url: url_FileServersListByManager_594998, schemes: {Scheme.Https})
type
  Call_ManagersGetEncryptionKey_595007 = ref object of OpenApiRestCall_593438
proc url_ManagersGetEncryptionKey_595009(protocol: Scheme; host: string;
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

proc validate_ManagersGetEncryptionKey_595008(path: JsonNode; query: JsonNode;
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
  var valid_595010 = path.getOrDefault("resourceGroupName")
  valid_595010 = validateParameter(valid_595010, JString, required = true,
                                 default = nil)
  if valid_595010 != nil:
    section.add "resourceGroupName", valid_595010
  var valid_595011 = path.getOrDefault("managerName")
  valid_595011 = validateParameter(valid_595011, JString, required = true,
                                 default = nil)
  if valid_595011 != nil:
    section.add "managerName", valid_595011
  var valid_595012 = path.getOrDefault("subscriptionId")
  valid_595012 = validateParameter(valid_595012, JString, required = true,
                                 default = nil)
  if valid_595012 != nil:
    section.add "subscriptionId", valid_595012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595013 = query.getOrDefault("api-version")
  valid_595013 = validateParameter(valid_595013, JString, required = true,
                                 default = nil)
  if valid_595013 != nil:
    section.add "api-version", valid_595013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595014: Call_ManagersGetEncryptionKey_595007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the symmetric encryption key of the manager.
  ## 
  let valid = call_595014.validator(path, query, header, formData, body)
  let scheme = call_595014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595014.url(scheme.get, call_595014.host, call_595014.base,
                         call_595014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595014, url, valid)

proc call*(call_595015: Call_ManagersGetEncryptionKey_595007;
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
  var path_595016 = newJObject()
  var query_595017 = newJObject()
  add(path_595016, "resourceGroupName", newJString(resourceGroupName))
  add(query_595017, "api-version", newJString(apiVersion))
  add(path_595016, "managerName", newJString(managerName))
  add(path_595016, "subscriptionId", newJString(subscriptionId))
  result = call_595015.call(path_595016, query_595017, nil, nil, nil)

var managersGetEncryptionKey* = Call_ManagersGetEncryptionKey_595007(
    name: "managersGetEncryptionKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/getEncryptionKey",
    validator: validate_ManagersGetEncryptionKey_595008, base: "",
    url: url_ManagersGetEncryptionKey_595009, schemes: {Scheme.Https})
type
  Call_IscsiServersListByManager_595018 = ref object of OpenApiRestCall_593438
proc url_IscsiServersListByManager_595020(protocol: Scheme; host: string;
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

proc validate_IscsiServersListByManager_595019(path: JsonNode; query: JsonNode;
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
  var valid_595021 = path.getOrDefault("resourceGroupName")
  valid_595021 = validateParameter(valid_595021, JString, required = true,
                                 default = nil)
  if valid_595021 != nil:
    section.add "resourceGroupName", valid_595021
  var valid_595022 = path.getOrDefault("managerName")
  valid_595022 = validateParameter(valid_595022, JString, required = true,
                                 default = nil)
  if valid_595022 != nil:
    section.add "managerName", valid_595022
  var valid_595023 = path.getOrDefault("subscriptionId")
  valid_595023 = validateParameter(valid_595023, JString, required = true,
                                 default = nil)
  if valid_595023 != nil:
    section.add "subscriptionId", valid_595023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595024 = query.getOrDefault("api-version")
  valid_595024 = validateParameter(valid_595024, JString, required = true,
                                 default = nil)
  if valid_595024 != nil:
    section.add "api-version", valid_595024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595025: Call_IscsiServersListByManager_595018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the iSCSI servers in a manager.
  ## 
  let valid = call_595025.validator(path, query, header, formData, body)
  let scheme = call_595025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595025.url(scheme.get, call_595025.host, call_595025.base,
                         call_595025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595025, url, valid)

proc call*(call_595026: Call_IscsiServersListByManager_595018;
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
  var path_595027 = newJObject()
  var query_595028 = newJObject()
  add(path_595027, "resourceGroupName", newJString(resourceGroupName))
  add(query_595028, "api-version", newJString(apiVersion))
  add(path_595027, "managerName", newJString(managerName))
  add(path_595027, "subscriptionId", newJString(subscriptionId))
  result = call_595026.call(path_595027, query_595028, nil, nil, nil)

var iscsiServersListByManager* = Call_IscsiServersListByManager_595018(
    name: "iscsiServersListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/iscsiservers",
    validator: validate_IscsiServersListByManager_595019, base: "",
    url: url_IscsiServersListByManager_595020, schemes: {Scheme.Https})
type
  Call_JobsListByManager_595029 = ref object of OpenApiRestCall_593438
proc url_JobsListByManager_595031(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByManager_595030(path: JsonNode; query: JsonNode;
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
  var valid_595032 = path.getOrDefault("resourceGroupName")
  valid_595032 = validateParameter(valid_595032, JString, required = true,
                                 default = nil)
  if valid_595032 != nil:
    section.add "resourceGroupName", valid_595032
  var valid_595033 = path.getOrDefault("managerName")
  valid_595033 = validateParameter(valid_595033, JString, required = true,
                                 default = nil)
  if valid_595033 != nil:
    section.add "managerName", valid_595033
  var valid_595034 = path.getOrDefault("subscriptionId")
  valid_595034 = validateParameter(valid_595034, JString, required = true,
                                 default = nil)
  if valid_595034 != nil:
    section.add "subscriptionId", valid_595034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595035 = query.getOrDefault("api-version")
  valid_595035 = validateParameter(valid_595035, JString, required = true,
                                 default = nil)
  if valid_595035 != nil:
    section.add "api-version", valid_595035
  var valid_595036 = query.getOrDefault("$filter")
  valid_595036 = validateParameter(valid_595036, JString, required = false,
                                 default = nil)
  if valid_595036 != nil:
    section.add "$filter", valid_595036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595037: Call_JobsListByManager_595029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the jobs in a manager.
  ## 
  let valid = call_595037.validator(path, query, header, formData, body)
  let scheme = call_595037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595037.url(scheme.get, call_595037.host, call_595037.base,
                         call_595037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595037, url, valid)

proc call*(call_595038: Call_JobsListByManager_595029; resourceGroupName: string;
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
  var path_595039 = newJObject()
  var query_595040 = newJObject()
  add(path_595039, "resourceGroupName", newJString(resourceGroupName))
  add(query_595040, "api-version", newJString(apiVersion))
  add(path_595039, "managerName", newJString(managerName))
  add(path_595039, "subscriptionId", newJString(subscriptionId))
  add(query_595040, "$filter", newJString(Filter))
  result = call_595038.call(path_595039, query_595040, nil, nil, nil)

var jobsListByManager* = Call_JobsListByManager_595029(name: "jobsListByManager",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/jobs",
    validator: validate_JobsListByManager_595030, base: "",
    url: url_JobsListByManager_595031, schemes: {Scheme.Https})
type
  Call_ManagersListMetrics_595041 = ref object of OpenApiRestCall_593438
proc url_ManagersListMetrics_595043(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersListMetrics_595042(path: JsonNode; query: JsonNode;
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
  var valid_595044 = path.getOrDefault("resourceGroupName")
  valid_595044 = validateParameter(valid_595044, JString, required = true,
                                 default = nil)
  if valid_595044 != nil:
    section.add "resourceGroupName", valid_595044
  var valid_595045 = path.getOrDefault("managerName")
  valid_595045 = validateParameter(valid_595045, JString, required = true,
                                 default = nil)
  if valid_595045 != nil:
    section.add "managerName", valid_595045
  var valid_595046 = path.getOrDefault("subscriptionId")
  valid_595046 = validateParameter(valid_595046, JString, required = true,
                                 default = nil)
  if valid_595046 != nil:
    section.add "subscriptionId", valid_595046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595047 = query.getOrDefault("api-version")
  valid_595047 = validateParameter(valid_595047, JString, required = true,
                                 default = nil)
  if valid_595047 != nil:
    section.add "api-version", valid_595047
  var valid_595048 = query.getOrDefault("$filter")
  valid_595048 = validateParameter(valid_595048, JString, required = false,
                                 default = nil)
  if valid_595048 != nil:
    section.add "$filter", valid_595048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595049: Call_ManagersListMetrics_595041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the  manager metrics
  ## 
  let valid = call_595049.validator(path, query, header, formData, body)
  let scheme = call_595049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595049.url(scheme.get, call_595049.host, call_595049.base,
                         call_595049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595049, url, valid)

proc call*(call_595050: Call_ManagersListMetrics_595041; resourceGroupName: string;
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
  var path_595051 = newJObject()
  var query_595052 = newJObject()
  add(path_595051, "resourceGroupName", newJString(resourceGroupName))
  add(query_595052, "api-version", newJString(apiVersion))
  add(path_595051, "managerName", newJString(managerName))
  add(path_595051, "subscriptionId", newJString(subscriptionId))
  add(query_595052, "$filter", newJString(Filter))
  result = call_595050.call(path_595051, query_595052, nil, nil, nil)

var managersListMetrics* = Call_ManagersListMetrics_595041(
    name: "managersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/metrics",
    validator: validate_ManagersListMetrics_595042, base: "",
    url: url_ManagersListMetrics_595043, schemes: {Scheme.Https})
type
  Call_ManagersListMetricDefinition_595053 = ref object of OpenApiRestCall_593438
proc url_ManagersListMetricDefinition_595055(protocol: Scheme; host: string;
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

proc validate_ManagersListMetricDefinition_595054(path: JsonNode; query: JsonNode;
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
  var valid_595056 = path.getOrDefault("resourceGroupName")
  valid_595056 = validateParameter(valid_595056, JString, required = true,
                                 default = nil)
  if valid_595056 != nil:
    section.add "resourceGroupName", valid_595056
  var valid_595057 = path.getOrDefault("managerName")
  valid_595057 = validateParameter(valid_595057, JString, required = true,
                                 default = nil)
  if valid_595057 != nil:
    section.add "managerName", valid_595057
  var valid_595058 = path.getOrDefault("subscriptionId")
  valid_595058 = validateParameter(valid_595058, JString, required = true,
                                 default = nil)
  if valid_595058 != nil:
    section.add "subscriptionId", valid_595058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595059 = query.getOrDefault("api-version")
  valid_595059 = validateParameter(valid_595059, JString, required = true,
                                 default = nil)
  if valid_595059 != nil:
    section.add "api-version", valid_595059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595060: Call_ManagersListMetricDefinition_595053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves metric definition of all metrics aggregated at manager.
  ## 
  let valid = call_595060.validator(path, query, header, formData, body)
  let scheme = call_595060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595060.url(scheme.get, call_595060.host, call_595060.base,
                         call_595060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595060, url, valid)

proc call*(call_595061: Call_ManagersListMetricDefinition_595053;
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
  var path_595062 = newJObject()
  var query_595063 = newJObject()
  add(path_595062, "resourceGroupName", newJString(resourceGroupName))
  add(query_595063, "api-version", newJString(apiVersion))
  add(path_595062, "managerName", newJString(managerName))
  add(path_595062, "subscriptionId", newJString(subscriptionId))
  result = call_595061.call(path_595062, query_595063, nil, nil, nil)

var managersListMetricDefinition* = Call_ManagersListMetricDefinition_595053(
    name: "managersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/metricsDefinitions",
    validator: validate_ManagersListMetricDefinition_595054, base: "",
    url: url_ManagersListMetricDefinition_595055, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsListByManager_595064 = ref object of OpenApiRestCall_593438
proc url_StorageAccountCredentialsListByManager_595066(protocol: Scheme;
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

proc validate_StorageAccountCredentialsListByManager_595065(path: JsonNode;
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
  var valid_595067 = path.getOrDefault("resourceGroupName")
  valid_595067 = validateParameter(valid_595067, JString, required = true,
                                 default = nil)
  if valid_595067 != nil:
    section.add "resourceGroupName", valid_595067
  var valid_595068 = path.getOrDefault("managerName")
  valid_595068 = validateParameter(valid_595068, JString, required = true,
                                 default = nil)
  if valid_595068 != nil:
    section.add "managerName", valid_595068
  var valid_595069 = path.getOrDefault("subscriptionId")
  valid_595069 = validateParameter(valid_595069, JString, required = true,
                                 default = nil)
  if valid_595069 != nil:
    section.add "subscriptionId", valid_595069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595070 = query.getOrDefault("api-version")
  valid_595070 = validateParameter(valid_595070, JString, required = true,
                                 default = nil)
  if valid_595070 != nil:
    section.add "api-version", valid_595070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595071: Call_StorageAccountCredentialsListByManager_595064;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the storage account credentials in a manager.
  ## 
  let valid = call_595071.validator(path, query, header, formData, body)
  let scheme = call_595071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595071.url(scheme.get, call_595071.host, call_595071.base,
                         call_595071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595071, url, valid)

proc call*(call_595072: Call_StorageAccountCredentialsListByManager_595064;
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
  var path_595073 = newJObject()
  var query_595074 = newJObject()
  add(path_595073, "resourceGroupName", newJString(resourceGroupName))
  add(query_595074, "api-version", newJString(apiVersion))
  add(path_595073, "managerName", newJString(managerName))
  add(path_595073, "subscriptionId", newJString(subscriptionId))
  result = call_595072.call(path_595073, query_595074, nil, nil, nil)

var storageAccountCredentialsListByManager* = Call_StorageAccountCredentialsListByManager_595064(
    name: "storageAccountCredentialsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials",
    validator: validate_StorageAccountCredentialsListByManager_595065, base: "",
    url: url_StorageAccountCredentialsListByManager_595066,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsCreateOrUpdate_595087 = ref object of OpenApiRestCall_593438
proc url_StorageAccountCredentialsCreateOrUpdate_595089(protocol: Scheme;
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

proc validate_StorageAccountCredentialsCreateOrUpdate_595088(path: JsonNode;
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
  var valid_595090 = path.getOrDefault("resourceGroupName")
  valid_595090 = validateParameter(valid_595090, JString, required = true,
                                 default = nil)
  if valid_595090 != nil:
    section.add "resourceGroupName", valid_595090
  var valid_595091 = path.getOrDefault("managerName")
  valid_595091 = validateParameter(valid_595091, JString, required = true,
                                 default = nil)
  if valid_595091 != nil:
    section.add "managerName", valid_595091
  var valid_595092 = path.getOrDefault("subscriptionId")
  valid_595092 = validateParameter(valid_595092, JString, required = true,
                                 default = nil)
  if valid_595092 != nil:
    section.add "subscriptionId", valid_595092
  var valid_595093 = path.getOrDefault("credentialName")
  valid_595093 = validateParameter(valid_595093, JString, required = true,
                                 default = nil)
  if valid_595093 != nil:
    section.add "credentialName", valid_595093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595094 = query.getOrDefault("api-version")
  valid_595094 = validateParameter(valid_595094, JString, required = true,
                                 default = nil)
  if valid_595094 != nil:
    section.add "api-version", valid_595094
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

proc call*(call_595096: Call_StorageAccountCredentialsCreateOrUpdate_595087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the storage account credential
  ## 
  let valid = call_595096.validator(path, query, header, formData, body)
  let scheme = call_595096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595096.url(scheme.get, call_595096.host, call_595096.base,
                         call_595096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595096, url, valid)

proc call*(call_595097: Call_StorageAccountCredentialsCreateOrUpdate_595087;
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
  var path_595098 = newJObject()
  var query_595099 = newJObject()
  var body_595100 = newJObject()
  add(path_595098, "resourceGroupName", newJString(resourceGroupName))
  add(query_595099, "api-version", newJString(apiVersion))
  add(path_595098, "managerName", newJString(managerName))
  if storageAccount != nil:
    body_595100 = storageAccount
  add(path_595098, "subscriptionId", newJString(subscriptionId))
  add(path_595098, "credentialName", newJString(credentialName))
  result = call_595097.call(path_595098, query_595099, nil, nil, body_595100)

var storageAccountCredentialsCreateOrUpdate* = Call_StorageAccountCredentialsCreateOrUpdate_595087(
    name: "storageAccountCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{credentialName}",
    validator: validate_StorageAccountCredentialsCreateOrUpdate_595088, base: "",
    url: url_StorageAccountCredentialsCreateOrUpdate_595089,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsGet_595075 = ref object of OpenApiRestCall_593438
proc url_StorageAccountCredentialsGet_595077(protocol: Scheme; host: string;
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

proc validate_StorageAccountCredentialsGet_595076(path: JsonNode; query: JsonNode;
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
  var valid_595078 = path.getOrDefault("resourceGroupName")
  valid_595078 = validateParameter(valid_595078, JString, required = true,
                                 default = nil)
  if valid_595078 != nil:
    section.add "resourceGroupName", valid_595078
  var valid_595079 = path.getOrDefault("managerName")
  valid_595079 = validateParameter(valid_595079, JString, required = true,
                                 default = nil)
  if valid_595079 != nil:
    section.add "managerName", valid_595079
  var valid_595080 = path.getOrDefault("subscriptionId")
  valid_595080 = validateParameter(valid_595080, JString, required = true,
                                 default = nil)
  if valid_595080 != nil:
    section.add "subscriptionId", valid_595080
  var valid_595081 = path.getOrDefault("credentialName")
  valid_595081 = validateParameter(valid_595081, JString, required = true,
                                 default = nil)
  if valid_595081 != nil:
    section.add "credentialName", valid_595081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595082 = query.getOrDefault("api-version")
  valid_595082 = validateParameter(valid_595082, JString, required = true,
                                 default = nil)
  if valid_595082 != nil:
    section.add "api-version", valid_595082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595083: Call_StorageAccountCredentialsGet_595075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified storage account credential name.
  ## 
  let valid = call_595083.validator(path, query, header, formData, body)
  let scheme = call_595083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595083.url(scheme.get, call_595083.host, call_595083.base,
                         call_595083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595083, url, valid)

proc call*(call_595084: Call_StorageAccountCredentialsGet_595075;
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
  var path_595085 = newJObject()
  var query_595086 = newJObject()
  add(path_595085, "resourceGroupName", newJString(resourceGroupName))
  add(query_595086, "api-version", newJString(apiVersion))
  add(path_595085, "managerName", newJString(managerName))
  add(path_595085, "subscriptionId", newJString(subscriptionId))
  add(path_595085, "credentialName", newJString(credentialName))
  result = call_595084.call(path_595085, query_595086, nil, nil, nil)

var storageAccountCredentialsGet* = Call_StorageAccountCredentialsGet_595075(
    name: "storageAccountCredentialsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{credentialName}",
    validator: validate_StorageAccountCredentialsGet_595076, base: "",
    url: url_StorageAccountCredentialsGet_595077, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsDelete_595101 = ref object of OpenApiRestCall_593438
proc url_StorageAccountCredentialsDelete_595103(protocol: Scheme; host: string;
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

proc validate_StorageAccountCredentialsDelete_595102(path: JsonNode;
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
  var valid_595104 = path.getOrDefault("resourceGroupName")
  valid_595104 = validateParameter(valid_595104, JString, required = true,
                                 default = nil)
  if valid_595104 != nil:
    section.add "resourceGroupName", valid_595104
  var valid_595105 = path.getOrDefault("managerName")
  valid_595105 = validateParameter(valid_595105, JString, required = true,
                                 default = nil)
  if valid_595105 != nil:
    section.add "managerName", valid_595105
  var valid_595106 = path.getOrDefault("subscriptionId")
  valid_595106 = validateParameter(valid_595106, JString, required = true,
                                 default = nil)
  if valid_595106 != nil:
    section.add "subscriptionId", valid_595106
  var valid_595107 = path.getOrDefault("credentialName")
  valid_595107 = validateParameter(valid_595107, JString, required = true,
                                 default = nil)
  if valid_595107 != nil:
    section.add "credentialName", valid_595107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595108 = query.getOrDefault("api-version")
  valid_595108 = validateParameter(valid_595108, JString, required = true,
                                 default = nil)
  if valid_595108 != nil:
    section.add "api-version", valid_595108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595109: Call_StorageAccountCredentialsDelete_595101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the storage account credential
  ## 
  let valid = call_595109.validator(path, query, header, formData, body)
  let scheme = call_595109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595109.url(scheme.get, call_595109.host, call_595109.base,
                         call_595109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595109, url, valid)

proc call*(call_595110: Call_StorageAccountCredentialsDelete_595101;
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
  var path_595111 = newJObject()
  var query_595112 = newJObject()
  add(path_595111, "resourceGroupName", newJString(resourceGroupName))
  add(query_595112, "api-version", newJString(apiVersion))
  add(path_595111, "managerName", newJString(managerName))
  add(path_595111, "subscriptionId", newJString(subscriptionId))
  add(path_595111, "credentialName", newJString(credentialName))
  result = call_595110.call(path_595111, query_595112, nil, nil, nil)

var storageAccountCredentialsDelete* = Call_StorageAccountCredentialsDelete_595101(
    name: "storageAccountCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{credentialName}",
    validator: validate_StorageAccountCredentialsDelete_595102, base: "",
    url: url_StorageAccountCredentialsDelete_595103, schemes: {Scheme.Https})
type
  Call_StorageDomainsListByManager_595113 = ref object of OpenApiRestCall_593438
proc url_StorageDomainsListByManager_595115(protocol: Scheme; host: string;
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

proc validate_StorageDomainsListByManager_595114(path: JsonNode; query: JsonNode;
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
  var valid_595116 = path.getOrDefault("resourceGroupName")
  valid_595116 = validateParameter(valid_595116, JString, required = true,
                                 default = nil)
  if valid_595116 != nil:
    section.add "resourceGroupName", valid_595116
  var valid_595117 = path.getOrDefault("managerName")
  valid_595117 = validateParameter(valid_595117, JString, required = true,
                                 default = nil)
  if valid_595117 != nil:
    section.add "managerName", valid_595117
  var valid_595118 = path.getOrDefault("subscriptionId")
  valid_595118 = validateParameter(valid_595118, JString, required = true,
                                 default = nil)
  if valid_595118 != nil:
    section.add "subscriptionId", valid_595118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595119 = query.getOrDefault("api-version")
  valid_595119 = validateParameter(valid_595119, JString, required = true,
                                 default = nil)
  if valid_595119 != nil:
    section.add "api-version", valid_595119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595120: Call_StorageDomainsListByManager_595113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the storage domains in a manager.
  ## 
  let valid = call_595120.validator(path, query, header, formData, body)
  let scheme = call_595120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595120.url(scheme.get, call_595120.host, call_595120.base,
                         call_595120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595120, url, valid)

proc call*(call_595121: Call_StorageDomainsListByManager_595113;
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
  var path_595122 = newJObject()
  var query_595123 = newJObject()
  add(path_595122, "resourceGroupName", newJString(resourceGroupName))
  add(query_595123, "api-version", newJString(apiVersion))
  add(path_595122, "managerName", newJString(managerName))
  add(path_595122, "subscriptionId", newJString(subscriptionId))
  result = call_595121.call(path_595122, query_595123, nil, nil, nil)

var storageDomainsListByManager* = Call_StorageDomainsListByManager_595113(
    name: "storageDomainsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageDomains",
    validator: validate_StorageDomainsListByManager_595114, base: "",
    url: url_StorageDomainsListByManager_595115, schemes: {Scheme.Https})
type
  Call_StorageDomainsCreateOrUpdate_595136 = ref object of OpenApiRestCall_593438
proc url_StorageDomainsCreateOrUpdate_595138(protocol: Scheme; host: string;
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

proc validate_StorageDomainsCreateOrUpdate_595137(path: JsonNode; query: JsonNode;
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
  var valid_595139 = path.getOrDefault("resourceGroupName")
  valid_595139 = validateParameter(valid_595139, JString, required = true,
                                 default = nil)
  if valid_595139 != nil:
    section.add "resourceGroupName", valid_595139
  var valid_595140 = path.getOrDefault("managerName")
  valid_595140 = validateParameter(valid_595140, JString, required = true,
                                 default = nil)
  if valid_595140 != nil:
    section.add "managerName", valid_595140
  var valid_595141 = path.getOrDefault("storageDomainName")
  valid_595141 = validateParameter(valid_595141, JString, required = true,
                                 default = nil)
  if valid_595141 != nil:
    section.add "storageDomainName", valid_595141
  var valid_595142 = path.getOrDefault("subscriptionId")
  valid_595142 = validateParameter(valid_595142, JString, required = true,
                                 default = nil)
  if valid_595142 != nil:
    section.add "subscriptionId", valid_595142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595143 = query.getOrDefault("api-version")
  valid_595143 = validateParameter(valid_595143, JString, required = true,
                                 default = nil)
  if valid_595143 != nil:
    section.add "api-version", valid_595143
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

proc call*(call_595145: Call_StorageDomainsCreateOrUpdate_595136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the storage domain.
  ## 
  let valid = call_595145.validator(path, query, header, formData, body)
  let scheme = call_595145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595145.url(scheme.get, call_595145.host, call_595145.base,
                         call_595145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595145, url, valid)

proc call*(call_595146: Call_StorageDomainsCreateOrUpdate_595136;
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
  var path_595147 = newJObject()
  var query_595148 = newJObject()
  var body_595149 = newJObject()
  add(path_595147, "resourceGroupName", newJString(resourceGroupName))
  add(query_595148, "api-version", newJString(apiVersion))
  add(path_595147, "managerName", newJString(managerName))
  add(path_595147, "storageDomainName", newJString(storageDomainName))
  add(path_595147, "subscriptionId", newJString(subscriptionId))
  if storageDomain != nil:
    body_595149 = storageDomain
  result = call_595146.call(path_595147, query_595148, nil, nil, body_595149)

var storageDomainsCreateOrUpdate* = Call_StorageDomainsCreateOrUpdate_595136(
    name: "storageDomainsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageDomains/{storageDomainName}",
    validator: validate_StorageDomainsCreateOrUpdate_595137, base: "",
    url: url_StorageDomainsCreateOrUpdate_595138, schemes: {Scheme.Https})
type
  Call_StorageDomainsGet_595124 = ref object of OpenApiRestCall_593438
proc url_StorageDomainsGet_595126(protocol: Scheme; host: string; base: string;
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

proc validate_StorageDomainsGet_595125(path: JsonNode; query: JsonNode;
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
  var valid_595127 = path.getOrDefault("resourceGroupName")
  valid_595127 = validateParameter(valid_595127, JString, required = true,
                                 default = nil)
  if valid_595127 != nil:
    section.add "resourceGroupName", valid_595127
  var valid_595128 = path.getOrDefault("managerName")
  valid_595128 = validateParameter(valid_595128, JString, required = true,
                                 default = nil)
  if valid_595128 != nil:
    section.add "managerName", valid_595128
  var valid_595129 = path.getOrDefault("storageDomainName")
  valid_595129 = validateParameter(valid_595129, JString, required = true,
                                 default = nil)
  if valid_595129 != nil:
    section.add "storageDomainName", valid_595129
  var valid_595130 = path.getOrDefault("subscriptionId")
  valid_595130 = validateParameter(valid_595130, JString, required = true,
                                 default = nil)
  if valid_595130 != nil:
    section.add "subscriptionId", valid_595130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595131 = query.getOrDefault("api-version")
  valid_595131 = validateParameter(valid_595131, JString, required = true,
                                 default = nil)
  if valid_595131 != nil:
    section.add "api-version", valid_595131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595132: Call_StorageDomainsGet_595124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified storage domain name.
  ## 
  let valid = call_595132.validator(path, query, header, formData, body)
  let scheme = call_595132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595132.url(scheme.get, call_595132.host, call_595132.base,
                         call_595132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595132, url, valid)

proc call*(call_595133: Call_StorageDomainsGet_595124; resourceGroupName: string;
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
  var path_595134 = newJObject()
  var query_595135 = newJObject()
  add(path_595134, "resourceGroupName", newJString(resourceGroupName))
  add(query_595135, "api-version", newJString(apiVersion))
  add(path_595134, "managerName", newJString(managerName))
  add(path_595134, "storageDomainName", newJString(storageDomainName))
  add(path_595134, "subscriptionId", newJString(subscriptionId))
  result = call_595133.call(path_595134, query_595135, nil, nil, nil)

var storageDomainsGet* = Call_StorageDomainsGet_595124(name: "storageDomainsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageDomains/{storageDomainName}",
    validator: validate_StorageDomainsGet_595125, base: "",
    url: url_StorageDomainsGet_595126, schemes: {Scheme.Https})
type
  Call_StorageDomainsDelete_595150 = ref object of OpenApiRestCall_593438
proc url_StorageDomainsDelete_595152(protocol: Scheme; host: string; base: string;
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

proc validate_StorageDomainsDelete_595151(path: JsonNode; query: JsonNode;
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
  var valid_595153 = path.getOrDefault("resourceGroupName")
  valid_595153 = validateParameter(valid_595153, JString, required = true,
                                 default = nil)
  if valid_595153 != nil:
    section.add "resourceGroupName", valid_595153
  var valid_595154 = path.getOrDefault("managerName")
  valid_595154 = validateParameter(valid_595154, JString, required = true,
                                 default = nil)
  if valid_595154 != nil:
    section.add "managerName", valid_595154
  var valid_595155 = path.getOrDefault("storageDomainName")
  valid_595155 = validateParameter(valid_595155, JString, required = true,
                                 default = nil)
  if valid_595155 != nil:
    section.add "storageDomainName", valid_595155
  var valid_595156 = path.getOrDefault("subscriptionId")
  valid_595156 = validateParameter(valid_595156, JString, required = true,
                                 default = nil)
  if valid_595156 != nil:
    section.add "subscriptionId", valid_595156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595157 = query.getOrDefault("api-version")
  valid_595157 = validateParameter(valid_595157, JString, required = true,
                                 default = nil)
  if valid_595157 != nil:
    section.add "api-version", valid_595157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595158: Call_StorageDomainsDelete_595150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the storage domain.
  ## 
  let valid = call_595158.validator(path, query, header, formData, body)
  let scheme = call_595158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595158.url(scheme.get, call_595158.host, call_595158.base,
                         call_595158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595158, url, valid)

proc call*(call_595159: Call_StorageDomainsDelete_595150;
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
  var path_595160 = newJObject()
  var query_595161 = newJObject()
  add(path_595160, "resourceGroupName", newJString(resourceGroupName))
  add(query_595161, "api-version", newJString(apiVersion))
  add(path_595160, "managerName", newJString(managerName))
  add(path_595160, "storageDomainName", newJString(storageDomainName))
  add(path_595160, "subscriptionId", newJString(subscriptionId))
  result = call_595159.call(path_595160, query_595161, nil, nil, nil)

var storageDomainsDelete* = Call_StorageDomainsDelete_595150(
    name: "storageDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageDomains/{storageDomainName}",
    validator: validate_StorageDomainsDelete_595151, base: "",
    url: url_StorageDomainsDelete_595152, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
