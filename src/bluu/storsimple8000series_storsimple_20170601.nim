
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "storsimple8000series-storsimple"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593660 = ref object of OpenApiRestCall_593438
proc url_OperationsList_593662(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593661(path: JsonNode; query: JsonNode;
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

proc call*(call_593844: Call_OperationsList_593660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available REST API operations of the Microsoft.StorSimple provider
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_OperationsList_593660; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available REST API operations of the Microsoft.StorSimple provider
  ##   apiVersion: string (required)
  ##             : The api version
  var query_593916 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  result = call_593915.call(nil, query_593916, nil, nil, nil)

var operationsList* = Call_OperationsList_593660(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.StorSimple/operations",
    validator: validate_OperationsList_593661, base: "", url: url_OperationsList_593662,
    schemes: {Scheme.Https})
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
  ##   parameters: JObject (required)
  ##             : The manager.
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
  var path_594010 = newJObject()
  var query_594011 = newJObject()
  var body_594012 = newJObject()
  add(path_594010, "resourceGroupName", newJString(resourceGroupName))
  add(query_594011, "api-version", newJString(apiVersion))
  add(path_594010, "managerName", newJString(managerName))
  add(path_594010, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594012 = parameters
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
  ##   parameters: JObject (required)
  ##             : The access control record to be added or updated.
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
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  var body_594073 = newJObject()
  add(path_594071, "resourceGroupName", newJString(resourceGroupName))
  add(query_594072, "api-version", newJString(apiVersion))
  add(path_594071, "managerName", newJString(managerName))
  add(path_594071, "subscriptionId", newJString(subscriptionId))
  add(path_594071, "accessControlRecordName", newJString(accessControlRecordName))
  if parameters != nil:
    body_594073 = parameters
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
  Call_BandwidthSettingsListByManager_594099 = ref object of OpenApiRestCall_593438
proc url_BandwidthSettingsListByManager_594101(protocol: Scheme; host: string;
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

proc validate_BandwidthSettingsListByManager_594100(path: JsonNode;
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594105 = query.getOrDefault("api-version")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "api-version", valid_594105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594106: Call_BandwidthSettingsListByManager_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the bandwidth setting in a manager.
  ## 
  let valid = call_594106.validator(path, query, header, formData, body)
  let scheme = call_594106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594106.url(scheme.get, call_594106.host, call_594106.base,
                         call_594106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594106, url, valid)

proc call*(call_594107: Call_BandwidthSettingsListByManager_594099;
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
  var path_594108 = newJObject()
  var query_594109 = newJObject()
  add(path_594108, "resourceGroupName", newJString(resourceGroupName))
  add(query_594109, "api-version", newJString(apiVersion))
  add(path_594108, "managerName", newJString(managerName))
  add(path_594108, "subscriptionId", newJString(subscriptionId))
  result = call_594107.call(path_594108, query_594109, nil, nil, nil)

var bandwidthSettingsListByManager* = Call_BandwidthSettingsListByManager_594099(
    name: "bandwidthSettingsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/bandwidthSettings",
    validator: validate_BandwidthSettingsListByManager_594100, base: "",
    url: url_BandwidthSettingsListByManager_594101, schemes: {Scheme.Https})
type
  Call_BandwidthSettingsCreateOrUpdate_594122 = ref object of OpenApiRestCall_593438
proc url_BandwidthSettingsCreateOrUpdate_594124(protocol: Scheme; host: string;
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

proc validate_BandwidthSettingsCreateOrUpdate_594123(path: JsonNode;
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
  var valid_594125 = path.getOrDefault("resourceGroupName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "resourceGroupName", valid_594125
  var valid_594126 = path.getOrDefault("managerName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "managerName", valid_594126
  var valid_594127 = path.getOrDefault("subscriptionId")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "subscriptionId", valid_594127
  var valid_594128 = path.getOrDefault("bandwidthSettingName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "bandwidthSettingName", valid_594128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594129 = query.getOrDefault("api-version")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "api-version", valid_594129
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

proc call*(call_594131: Call_BandwidthSettingsCreateOrUpdate_594122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the bandwidth setting
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_BandwidthSettingsCreateOrUpdate_594122;
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
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  var body_594135 = newJObject()
  add(path_594133, "resourceGroupName", newJString(resourceGroupName))
  add(query_594134, "api-version", newJString(apiVersion))
  add(path_594133, "managerName", newJString(managerName))
  add(path_594133, "subscriptionId", newJString(subscriptionId))
  add(path_594133, "bandwidthSettingName", newJString(bandwidthSettingName))
  if parameters != nil:
    body_594135 = parameters
  result = call_594132.call(path_594133, query_594134, nil, nil, body_594135)

var bandwidthSettingsCreateOrUpdate* = Call_BandwidthSettingsCreateOrUpdate_594122(
    name: "bandwidthSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/bandwidthSettings/{bandwidthSettingName}",
    validator: validate_BandwidthSettingsCreateOrUpdate_594123, base: "",
    url: url_BandwidthSettingsCreateOrUpdate_594124, schemes: {Scheme.Https})
type
  Call_BandwidthSettingsGet_594110 = ref object of OpenApiRestCall_593438
proc url_BandwidthSettingsGet_594112(protocol: Scheme; host: string; base: string;
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

proc validate_BandwidthSettingsGet_594111(path: JsonNode; query: JsonNode;
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
  var valid_594113 = path.getOrDefault("resourceGroupName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "resourceGroupName", valid_594113
  var valid_594114 = path.getOrDefault("managerName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "managerName", valid_594114
  var valid_594115 = path.getOrDefault("subscriptionId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "subscriptionId", valid_594115
  var valid_594116 = path.getOrDefault("bandwidthSettingName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "bandwidthSettingName", valid_594116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594117 = query.getOrDefault("api-version")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "api-version", valid_594117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594118: Call_BandwidthSettingsGet_594110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified bandwidth setting name.
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_BandwidthSettingsGet_594110;
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
  var path_594120 = newJObject()
  var query_594121 = newJObject()
  add(path_594120, "resourceGroupName", newJString(resourceGroupName))
  add(query_594121, "api-version", newJString(apiVersion))
  add(path_594120, "managerName", newJString(managerName))
  add(path_594120, "subscriptionId", newJString(subscriptionId))
  add(path_594120, "bandwidthSettingName", newJString(bandwidthSettingName))
  result = call_594119.call(path_594120, query_594121, nil, nil, nil)

var bandwidthSettingsGet* = Call_BandwidthSettingsGet_594110(
    name: "bandwidthSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/bandwidthSettings/{bandwidthSettingName}",
    validator: validate_BandwidthSettingsGet_594111, base: "",
    url: url_BandwidthSettingsGet_594112, schemes: {Scheme.Https})
type
  Call_BandwidthSettingsDelete_594136 = ref object of OpenApiRestCall_593438
proc url_BandwidthSettingsDelete_594138(protocol: Scheme; host: string; base: string;
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

proc validate_BandwidthSettingsDelete_594137(path: JsonNode; query: JsonNode;
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
  var valid_594139 = path.getOrDefault("resourceGroupName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "resourceGroupName", valid_594139
  var valid_594140 = path.getOrDefault("managerName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "managerName", valid_594140
  var valid_594141 = path.getOrDefault("subscriptionId")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "subscriptionId", valid_594141
  var valid_594142 = path.getOrDefault("bandwidthSettingName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "bandwidthSettingName", valid_594142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594143 = query.getOrDefault("api-version")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "api-version", valid_594143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594144: Call_BandwidthSettingsDelete_594136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the bandwidth setting
  ## 
  let valid = call_594144.validator(path, query, header, formData, body)
  let scheme = call_594144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594144.url(scheme.get, call_594144.host, call_594144.base,
                         call_594144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594144, url, valid)

proc call*(call_594145: Call_BandwidthSettingsDelete_594136;
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
  var path_594146 = newJObject()
  var query_594147 = newJObject()
  add(path_594146, "resourceGroupName", newJString(resourceGroupName))
  add(query_594147, "api-version", newJString(apiVersion))
  add(path_594146, "managerName", newJString(managerName))
  add(path_594146, "subscriptionId", newJString(subscriptionId))
  add(path_594146, "bandwidthSettingName", newJString(bandwidthSettingName))
  result = call_594145.call(path_594146, query_594147, nil, nil, nil)

var bandwidthSettingsDelete* = Call_BandwidthSettingsDelete_594136(
    name: "bandwidthSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/bandwidthSettings/{bandwidthSettingName}",
    validator: validate_BandwidthSettingsDelete_594137, base: "",
    url: url_BandwidthSettingsDelete_594138, schemes: {Scheme.Https})
type
  Call_AlertsClear_594148 = ref object of OpenApiRestCall_593438
proc url_AlertsClear_594150(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsClear_594149(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594151 = path.getOrDefault("resourceGroupName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "resourceGroupName", valid_594151
  var valid_594152 = path.getOrDefault("managerName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "managerName", valid_594152
  var valid_594153 = path.getOrDefault("subscriptionId")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "subscriptionId", valid_594153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The clear alert request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594156: Call_AlertsClear_594148; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clear the alerts.
  ## 
  let valid = call_594156.validator(path, query, header, formData, body)
  let scheme = call_594156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594156.url(scheme.get, call_594156.host, call_594156.base,
                         call_594156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594156, url, valid)

proc call*(call_594157: Call_AlertsClear_594148; resourceGroupName: string;
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
  var path_594158 = newJObject()
  var query_594159 = newJObject()
  var body_594160 = newJObject()
  add(path_594158, "resourceGroupName", newJString(resourceGroupName))
  add(query_594159, "api-version", newJString(apiVersion))
  add(path_594158, "managerName", newJString(managerName))
  add(path_594158, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594160 = parameters
  result = call_594157.call(path_594158, query_594159, nil, nil, body_594160)

var alertsClear* = Call_AlertsClear_594148(name: "alertsClear",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/clearAlerts",
                                        validator: validate_AlertsClear_594149,
                                        base: "", url: url_AlertsClear_594150,
                                        schemes: {Scheme.Https})
type
  Call_CloudAppliancesListSupportedConfigurations_594161 = ref object of OpenApiRestCall_593438
proc url_CloudAppliancesListSupportedConfigurations_594163(protocol: Scheme;
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

proc validate_CloudAppliancesListSupportedConfigurations_594162(path: JsonNode;
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
  var valid_594164 = path.getOrDefault("resourceGroupName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "resourceGroupName", valid_594164
  var valid_594165 = path.getOrDefault("managerName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "managerName", valid_594165
  var valid_594166 = path.getOrDefault("subscriptionId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "subscriptionId", valid_594166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
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

proc call*(call_594168: Call_CloudAppliancesListSupportedConfigurations_594161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists supported cloud appliance models and supported configurations.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_CloudAppliancesListSupportedConfigurations_594161;
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
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  add(path_594170, "resourceGroupName", newJString(resourceGroupName))
  add(query_594171, "api-version", newJString(apiVersion))
  add(path_594170, "managerName", newJString(managerName))
  add(path_594170, "subscriptionId", newJString(subscriptionId))
  result = call_594169.call(path_594170, query_594171, nil, nil, nil)

var cloudAppliancesListSupportedConfigurations* = Call_CloudAppliancesListSupportedConfigurations_594161(
    name: "cloudAppliancesListSupportedConfigurations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/cloudApplianceConfigurations",
    validator: validate_CloudAppliancesListSupportedConfigurations_594162,
    base: "", url: url_CloudAppliancesListSupportedConfigurations_594163,
    schemes: {Scheme.Https})
type
  Call_DevicesConfigure_594172 = ref object of OpenApiRestCall_593438
proc url_DevicesConfigure_594174(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesConfigure_594173(path: JsonNode; query: JsonNode;
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
  var valid_594175 = path.getOrDefault("resourceGroupName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "resourceGroupName", valid_594175
  var valid_594176 = path.getOrDefault("managerName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "managerName", valid_594176
  var valid_594177 = path.getOrDefault("subscriptionId")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "subscriptionId", valid_594177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594178 = query.getOrDefault("api-version")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "api-version", valid_594178
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

proc call*(call_594180: Call_DevicesConfigure_594172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Complete minimal setup before using the device.
  ## 
  let valid = call_594180.validator(path, query, header, formData, body)
  let scheme = call_594180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594180.url(scheme.get, call_594180.host, call_594180.base,
                         call_594180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594180, url, valid)

proc call*(call_594181: Call_DevicesConfigure_594172; resourceGroupName: string;
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
  var path_594182 = newJObject()
  var query_594183 = newJObject()
  var body_594184 = newJObject()
  add(path_594182, "resourceGroupName", newJString(resourceGroupName))
  add(query_594183, "api-version", newJString(apiVersion))
  add(path_594182, "managerName", newJString(managerName))
  add(path_594182, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594184 = parameters
  result = call_594181.call(path_594182, query_594183, nil, nil, body_594184)

var devicesConfigure* = Call_DevicesConfigure_594172(name: "devicesConfigure",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/configureDevice",
    validator: validate_DevicesConfigure_594173, base: "",
    url: url_DevicesConfigure_594174, schemes: {Scheme.Https})
type
  Call_DevicesListByManager_594185 = ref object of OpenApiRestCall_593438
proc url_DevicesListByManager_594187(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesListByManager_594186(path: JsonNode; query: JsonNode;
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
  var valid_594188 = path.getOrDefault("resourceGroupName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "resourceGroupName", valid_594188
  var valid_594189 = path.getOrDefault("managerName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "managerName", valid_594189
  var valid_594190 = path.getOrDefault("subscriptionId")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "subscriptionId", valid_594190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device or $expand=rolloverdetails to populate additional fields related to the service data encryption key rollover on device
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594191 = query.getOrDefault("api-version")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "api-version", valid_594191
  var valid_594192 = query.getOrDefault("$expand")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "$expand", valid_594192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594193: Call_DevicesListByManager_594185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of devices for the specified manager.
  ## 
  let valid = call_594193.validator(path, query, header, formData, body)
  let scheme = call_594193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594193.url(scheme.get, call_594193.host, call_594193.base,
                         call_594193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594193, url, valid)

proc call*(call_594194: Call_DevicesListByManager_594185;
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
  var path_594195 = newJObject()
  var query_594196 = newJObject()
  add(path_594195, "resourceGroupName", newJString(resourceGroupName))
  add(query_594196, "api-version", newJString(apiVersion))
  add(query_594196, "$expand", newJString(Expand))
  add(path_594195, "managerName", newJString(managerName))
  add(path_594195, "subscriptionId", newJString(subscriptionId))
  result = call_594194.call(path_594195, query_594196, nil, nil, nil)

var devicesListByManager* = Call_DevicesListByManager_594185(
    name: "devicesListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices",
    validator: validate_DevicesListByManager_594186, base: "",
    url: url_DevicesListByManager_594187, schemes: {Scheme.Https})
type
  Call_DevicesGet_594197 = ref object of OpenApiRestCall_593438
proc url_DevicesGet_594199(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DevicesGet_594198(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594200 = path.getOrDefault("resourceGroupName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "resourceGroupName", valid_594200
  var valid_594201 = path.getOrDefault("managerName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "managerName", valid_594201
  var valid_594202 = path.getOrDefault("subscriptionId")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "subscriptionId", valid_594202
  var valid_594203 = path.getOrDefault("deviceName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "deviceName", valid_594203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $expand: JString
  ##          : Specify $expand=details to populate additional fields related to the device or $expand=rolloverdetails to populate additional fields related to the service data encryption key rollover on device
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594204 = query.getOrDefault("api-version")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "api-version", valid_594204
  var valid_594205 = query.getOrDefault("$expand")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "$expand", valid_594205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594206: Call_DevicesGet_594197; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified device.
  ## 
  let valid = call_594206.validator(path, query, header, formData, body)
  let scheme = call_594206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594206.url(scheme.get, call_594206.host, call_594206.base,
                         call_594206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594206, url, valid)

proc call*(call_594207: Call_DevicesGet_594197; resourceGroupName: string;
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
  var path_594208 = newJObject()
  var query_594209 = newJObject()
  add(path_594208, "resourceGroupName", newJString(resourceGroupName))
  add(query_594209, "api-version", newJString(apiVersion))
  add(query_594209, "$expand", newJString(Expand))
  add(path_594208, "managerName", newJString(managerName))
  add(path_594208, "subscriptionId", newJString(subscriptionId))
  add(path_594208, "deviceName", newJString(deviceName))
  result = call_594207.call(path_594208, query_594209, nil, nil, nil)

var devicesGet* = Call_DevicesGet_594197(name: "devicesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
                                      validator: validate_DevicesGet_594198,
                                      base: "", url: url_DevicesGet_594199,
                                      schemes: {Scheme.Https})
type
  Call_DevicesUpdate_594222 = ref object of OpenApiRestCall_593438
proc url_DevicesUpdate_594224(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesUpdate_594223(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594225 = path.getOrDefault("resourceGroupName")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "resourceGroupName", valid_594225
  var valid_594226 = path.getOrDefault("managerName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "managerName", valid_594226
  var valid_594227 = path.getOrDefault("subscriptionId")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "subscriptionId", valid_594227
  var valid_594228 = path.getOrDefault("deviceName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "deviceName", valid_594228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594229 = query.getOrDefault("api-version")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "api-version", valid_594229
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

proc call*(call_594231: Call_DevicesUpdate_594222; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches the device.
  ## 
  let valid = call_594231.validator(path, query, header, formData, body)
  let scheme = call_594231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594231.url(scheme.get, call_594231.host, call_594231.base,
                         call_594231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594231, url, valid)

proc call*(call_594232: Call_DevicesUpdate_594222; resourceGroupName: string;
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
  var path_594233 = newJObject()
  var query_594234 = newJObject()
  var body_594235 = newJObject()
  add(path_594233, "resourceGroupName", newJString(resourceGroupName))
  add(query_594234, "api-version", newJString(apiVersion))
  add(path_594233, "managerName", newJString(managerName))
  add(path_594233, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594235 = parameters
  add(path_594233, "deviceName", newJString(deviceName))
  result = call_594232.call(path_594233, query_594234, nil, nil, body_594235)

var devicesUpdate* = Call_DevicesUpdate_594222(name: "devicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
    validator: validate_DevicesUpdate_594223, base: "", url: url_DevicesUpdate_594224,
    schemes: {Scheme.Https})
type
  Call_DevicesDelete_594210 = ref object of OpenApiRestCall_593438
proc url_DevicesDelete_594212(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDelete_594211(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594213 = path.getOrDefault("resourceGroupName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "resourceGroupName", valid_594213
  var valid_594214 = path.getOrDefault("managerName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "managerName", valid_594214
  var valid_594215 = path.getOrDefault("subscriptionId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "subscriptionId", valid_594215
  var valid_594216 = path.getOrDefault("deviceName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "deviceName", valid_594216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594217 = query.getOrDefault("api-version")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "api-version", valid_594217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594218: Call_DevicesDelete_594210; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the device.
  ## 
  let valid = call_594218.validator(path, query, header, formData, body)
  let scheme = call_594218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594218.url(scheme.get, call_594218.host, call_594218.base,
                         call_594218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594218, url, valid)

proc call*(call_594219: Call_DevicesDelete_594210; resourceGroupName: string;
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
  var path_594220 = newJObject()
  var query_594221 = newJObject()
  add(path_594220, "resourceGroupName", newJString(resourceGroupName))
  add(query_594221, "api-version", newJString(apiVersion))
  add(path_594220, "managerName", newJString(managerName))
  add(path_594220, "subscriptionId", newJString(subscriptionId))
  add(path_594220, "deviceName", newJString(deviceName))
  result = call_594219.call(path_594220, query_594221, nil, nil, nil)

var devicesDelete* = Call_DevicesDelete_594210(name: "devicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}",
    validator: validate_DevicesDelete_594211, base: "", url: url_DevicesDelete_594212,
    schemes: {Scheme.Https})
type
  Call_DeviceSettingsCreateOrUpdateAlertSettings_594248 = ref object of OpenApiRestCall_593438
proc url_DeviceSettingsCreateOrUpdateAlertSettings_594250(protocol: Scheme;
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

proc validate_DeviceSettingsCreateOrUpdateAlertSettings_594249(path: JsonNode;
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
  var valid_594251 = path.getOrDefault("resourceGroupName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "resourceGroupName", valid_594251
  var valid_594252 = path.getOrDefault("managerName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "managerName", valid_594252
  var valid_594253 = path.getOrDefault("subscriptionId")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "subscriptionId", valid_594253
  var valid_594254 = path.getOrDefault("deviceName")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "deviceName", valid_594254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594255 = query.getOrDefault("api-version")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "api-version", valid_594255
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

proc call*(call_594257: Call_DeviceSettingsCreateOrUpdateAlertSettings_594248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the alert settings of the specified device.
  ## 
  let valid = call_594257.validator(path, query, header, formData, body)
  let scheme = call_594257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594257.url(scheme.get, call_594257.host, call_594257.base,
                         call_594257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594257, url, valid)

proc call*(call_594258: Call_DeviceSettingsCreateOrUpdateAlertSettings_594248;
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
  var path_594259 = newJObject()
  var query_594260 = newJObject()
  var body_594261 = newJObject()
  add(path_594259, "resourceGroupName", newJString(resourceGroupName))
  add(query_594260, "api-version", newJString(apiVersion))
  add(path_594259, "managerName", newJString(managerName))
  add(path_594259, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594261 = parameters
  add(path_594259, "deviceName", newJString(deviceName))
  result = call_594258.call(path_594259, query_594260, nil, nil, body_594261)

var deviceSettingsCreateOrUpdateAlertSettings* = Call_DeviceSettingsCreateOrUpdateAlertSettings_594248(
    name: "deviceSettingsCreateOrUpdateAlertSettings", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/alertSettings/default",
    validator: validate_DeviceSettingsCreateOrUpdateAlertSettings_594249,
    base: "", url: url_DeviceSettingsCreateOrUpdateAlertSettings_594250,
    schemes: {Scheme.Https})
type
  Call_DeviceSettingsGetAlertSettings_594236 = ref object of OpenApiRestCall_593438
proc url_DeviceSettingsGetAlertSettings_594238(protocol: Scheme; host: string;
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

proc validate_DeviceSettingsGetAlertSettings_594237(path: JsonNode;
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
  var valid_594239 = path.getOrDefault("resourceGroupName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "resourceGroupName", valid_594239
  var valid_594240 = path.getOrDefault("managerName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "managerName", valid_594240
  var valid_594241 = path.getOrDefault("subscriptionId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "subscriptionId", valid_594241
  var valid_594242 = path.getOrDefault("deviceName")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "deviceName", valid_594242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594243 = query.getOrDefault("api-version")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "api-version", valid_594243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594244: Call_DeviceSettingsGetAlertSettings_594236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert settings of the specified device.
  ## 
  let valid = call_594244.validator(path, query, header, formData, body)
  let scheme = call_594244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594244.url(scheme.get, call_594244.host, call_594244.base,
                         call_594244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594244, url, valid)

proc call*(call_594245: Call_DeviceSettingsGetAlertSettings_594236;
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
  var path_594246 = newJObject()
  var query_594247 = newJObject()
  add(path_594246, "resourceGroupName", newJString(resourceGroupName))
  add(query_594247, "api-version", newJString(apiVersion))
  add(path_594246, "managerName", newJString(managerName))
  add(path_594246, "subscriptionId", newJString(subscriptionId))
  add(path_594246, "deviceName", newJString(deviceName))
  result = call_594245.call(path_594246, query_594247, nil, nil, nil)

var deviceSettingsGetAlertSettings* = Call_DeviceSettingsGetAlertSettings_594236(
    name: "deviceSettingsGetAlertSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/alertSettings/default",
    validator: validate_DeviceSettingsGetAlertSettings_594237, base: "",
    url: url_DeviceSettingsGetAlertSettings_594238, schemes: {Scheme.Https})
type
  Call_DevicesAuthorizeForServiceEncryptionKeyRollover_594262 = ref object of OpenApiRestCall_593438
proc url_DevicesAuthorizeForServiceEncryptionKeyRollover_594264(protocol: Scheme;
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

proc validate_DevicesAuthorizeForServiceEncryptionKeyRollover_594263(
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
  var valid_594265 = path.getOrDefault("resourceGroupName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "resourceGroupName", valid_594265
  var valid_594266 = path.getOrDefault("managerName")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "managerName", valid_594266
  var valid_594267 = path.getOrDefault("subscriptionId")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "subscriptionId", valid_594267
  var valid_594268 = path.getOrDefault("deviceName")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "deviceName", valid_594268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594269 = query.getOrDefault("api-version")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "api-version", valid_594269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594270: Call_DevicesAuthorizeForServiceEncryptionKeyRollover_594262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Authorizes the specified device for service data encryption key rollover.
  ## 
  let valid = call_594270.validator(path, query, header, formData, body)
  let scheme = call_594270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594270.url(scheme.get, call_594270.host, call_594270.base,
                         call_594270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594270, url, valid)

proc call*(call_594271: Call_DevicesAuthorizeForServiceEncryptionKeyRollover_594262;
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
  var path_594272 = newJObject()
  var query_594273 = newJObject()
  add(path_594272, "resourceGroupName", newJString(resourceGroupName))
  add(query_594273, "api-version", newJString(apiVersion))
  add(path_594272, "managerName", newJString(managerName))
  add(path_594272, "subscriptionId", newJString(subscriptionId))
  add(path_594272, "deviceName", newJString(deviceName))
  result = call_594271.call(path_594272, query_594273, nil, nil, nil)

var devicesAuthorizeForServiceEncryptionKeyRollover* = Call_DevicesAuthorizeForServiceEncryptionKeyRollover_594262(
    name: "devicesAuthorizeForServiceEncryptionKeyRollover",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/authorizeForServiceEncryptionKeyRollover",
    validator: validate_DevicesAuthorizeForServiceEncryptionKeyRollover_594263,
    base: "", url: url_DevicesAuthorizeForServiceEncryptionKeyRollover_594264,
    schemes: {Scheme.Https})
type
  Call_BackupPoliciesListByDevice_594274 = ref object of OpenApiRestCall_593438
proc url_BackupPoliciesListByDevice_594276(protocol: Scheme; host: string;
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

proc validate_BackupPoliciesListByDevice_594275(path: JsonNode; query: JsonNode;
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
  var valid_594277 = path.getOrDefault("resourceGroupName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "resourceGroupName", valid_594277
  var valid_594278 = path.getOrDefault("managerName")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "managerName", valid_594278
  var valid_594279 = path.getOrDefault("subscriptionId")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "subscriptionId", valid_594279
  var valid_594280 = path.getOrDefault("deviceName")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "deviceName", valid_594280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594281 = query.getOrDefault("api-version")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "api-version", valid_594281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594282: Call_BackupPoliciesListByDevice_594274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the backup policies in a device.
  ## 
  let valid = call_594282.validator(path, query, header, formData, body)
  let scheme = call_594282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594282.url(scheme.get, call_594282.host, call_594282.base,
                         call_594282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594282, url, valid)

proc call*(call_594283: Call_BackupPoliciesListByDevice_594274;
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
  var path_594284 = newJObject()
  var query_594285 = newJObject()
  add(path_594284, "resourceGroupName", newJString(resourceGroupName))
  add(query_594285, "api-version", newJString(apiVersion))
  add(path_594284, "managerName", newJString(managerName))
  add(path_594284, "subscriptionId", newJString(subscriptionId))
  add(path_594284, "deviceName", newJString(deviceName))
  result = call_594283.call(path_594284, query_594285, nil, nil, nil)

var backupPoliciesListByDevice* = Call_BackupPoliciesListByDevice_594274(
    name: "backupPoliciesListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies",
    validator: validate_BackupPoliciesListByDevice_594275, base: "",
    url: url_BackupPoliciesListByDevice_594276, schemes: {Scheme.Https})
type
  Call_BackupPoliciesCreateOrUpdate_594299 = ref object of OpenApiRestCall_593438
proc url_BackupPoliciesCreateOrUpdate_594301(protocol: Scheme; host: string;
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

proc validate_BackupPoliciesCreateOrUpdate_594300(path: JsonNode; query: JsonNode;
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
  var valid_594302 = path.getOrDefault("resourceGroupName")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "resourceGroupName", valid_594302
  var valid_594303 = path.getOrDefault("managerName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "managerName", valid_594303
  var valid_594304 = path.getOrDefault("subscriptionId")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "subscriptionId", valid_594304
  var valid_594305 = path.getOrDefault("backupPolicyName")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "backupPolicyName", valid_594305
  var valid_594306 = path.getOrDefault("deviceName")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "deviceName", valid_594306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594307 = query.getOrDefault("api-version")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "api-version", valid_594307
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

proc call*(call_594309: Call_BackupPoliciesCreateOrUpdate_594299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the backup policy.
  ## 
  let valid = call_594309.validator(path, query, header, formData, body)
  let scheme = call_594309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594309.url(scheme.get, call_594309.host, call_594309.base,
                         call_594309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594309, url, valid)

proc call*(call_594310: Call_BackupPoliciesCreateOrUpdate_594299;
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
  var path_594311 = newJObject()
  var query_594312 = newJObject()
  var body_594313 = newJObject()
  add(path_594311, "resourceGroupName", newJString(resourceGroupName))
  add(query_594312, "api-version", newJString(apiVersion))
  add(path_594311, "managerName", newJString(managerName))
  add(path_594311, "subscriptionId", newJString(subscriptionId))
  add(path_594311, "backupPolicyName", newJString(backupPolicyName))
  if parameters != nil:
    body_594313 = parameters
  add(path_594311, "deviceName", newJString(deviceName))
  result = call_594310.call(path_594311, query_594312, nil, nil, body_594313)

var backupPoliciesCreateOrUpdate* = Call_BackupPoliciesCreateOrUpdate_594299(
    name: "backupPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}",
    validator: validate_BackupPoliciesCreateOrUpdate_594300, base: "",
    url: url_BackupPoliciesCreateOrUpdate_594301, schemes: {Scheme.Https})
type
  Call_BackupPoliciesGet_594286 = ref object of OpenApiRestCall_593438
proc url_BackupPoliciesGet_594288(protocol: Scheme; host: string; base: string;
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

proc validate_BackupPoliciesGet_594287(path: JsonNode; query: JsonNode;
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
  var valid_594289 = path.getOrDefault("resourceGroupName")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "resourceGroupName", valid_594289
  var valid_594290 = path.getOrDefault("managerName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "managerName", valid_594290
  var valid_594291 = path.getOrDefault("subscriptionId")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "subscriptionId", valid_594291
  var valid_594292 = path.getOrDefault("backupPolicyName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "backupPolicyName", valid_594292
  var valid_594293 = path.getOrDefault("deviceName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "deviceName", valid_594293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594294 = query.getOrDefault("api-version")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "api-version", valid_594294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594295: Call_BackupPoliciesGet_594286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified backup policy name.
  ## 
  let valid = call_594295.validator(path, query, header, formData, body)
  let scheme = call_594295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594295.url(scheme.get, call_594295.host, call_594295.base,
                         call_594295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594295, url, valid)

proc call*(call_594296: Call_BackupPoliciesGet_594286; resourceGroupName: string;
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
  var path_594297 = newJObject()
  var query_594298 = newJObject()
  add(path_594297, "resourceGroupName", newJString(resourceGroupName))
  add(query_594298, "api-version", newJString(apiVersion))
  add(path_594297, "managerName", newJString(managerName))
  add(path_594297, "subscriptionId", newJString(subscriptionId))
  add(path_594297, "backupPolicyName", newJString(backupPolicyName))
  add(path_594297, "deviceName", newJString(deviceName))
  result = call_594296.call(path_594297, query_594298, nil, nil, nil)

var backupPoliciesGet* = Call_BackupPoliciesGet_594286(name: "backupPoliciesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}",
    validator: validate_BackupPoliciesGet_594287, base: "",
    url: url_BackupPoliciesGet_594288, schemes: {Scheme.Https})
type
  Call_BackupPoliciesDelete_594314 = ref object of OpenApiRestCall_593438
proc url_BackupPoliciesDelete_594316(protocol: Scheme; host: string; base: string;
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

proc validate_BackupPoliciesDelete_594315(path: JsonNode; query: JsonNode;
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
  var valid_594317 = path.getOrDefault("resourceGroupName")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "resourceGroupName", valid_594317
  var valid_594318 = path.getOrDefault("managerName")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "managerName", valid_594318
  var valid_594319 = path.getOrDefault("subscriptionId")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "subscriptionId", valid_594319
  var valid_594320 = path.getOrDefault("backupPolicyName")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "backupPolicyName", valid_594320
  var valid_594321 = path.getOrDefault("deviceName")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "deviceName", valid_594321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594322 = query.getOrDefault("api-version")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "api-version", valid_594322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594323: Call_BackupPoliciesDelete_594314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup policy.
  ## 
  let valid = call_594323.validator(path, query, header, formData, body)
  let scheme = call_594323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594323.url(scheme.get, call_594323.host, call_594323.base,
                         call_594323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594323, url, valid)

proc call*(call_594324: Call_BackupPoliciesDelete_594314;
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
  var path_594325 = newJObject()
  var query_594326 = newJObject()
  add(path_594325, "resourceGroupName", newJString(resourceGroupName))
  add(query_594326, "api-version", newJString(apiVersion))
  add(path_594325, "managerName", newJString(managerName))
  add(path_594325, "subscriptionId", newJString(subscriptionId))
  add(path_594325, "backupPolicyName", newJString(backupPolicyName))
  add(path_594325, "deviceName", newJString(deviceName))
  result = call_594324.call(path_594325, query_594326, nil, nil, nil)

var backupPoliciesDelete* = Call_BackupPoliciesDelete_594314(
    name: "backupPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}",
    validator: validate_BackupPoliciesDelete_594315, base: "",
    url: url_BackupPoliciesDelete_594316, schemes: {Scheme.Https})
type
  Call_BackupPoliciesBackupNow_594327 = ref object of OpenApiRestCall_593438
proc url_BackupPoliciesBackupNow_594329(protocol: Scheme; host: string; base: string;
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

proc validate_BackupPoliciesBackupNow_594328(path: JsonNode; query: JsonNode;
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
  var valid_594330 = path.getOrDefault("resourceGroupName")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "resourceGroupName", valid_594330
  var valid_594331 = path.getOrDefault("managerName")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "managerName", valid_594331
  var valid_594332 = path.getOrDefault("subscriptionId")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "subscriptionId", valid_594332
  var valid_594333 = path.getOrDefault("backupPolicyName")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "backupPolicyName", valid_594333
  var valid_594334 = path.getOrDefault("deviceName")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "deviceName", valid_594334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   backupType: JString (required)
  ##             : The backup Type. This can be cloudSnapshot or localSnapshot.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594335 = query.getOrDefault("api-version")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "api-version", valid_594335
  var valid_594336 = query.getOrDefault("backupType")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "backupType", valid_594336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594337: Call_BackupPoliciesBackupNow_594327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup the backup policy now.
  ## 
  let valid = call_594337.validator(path, query, header, formData, body)
  let scheme = call_594337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594337.url(scheme.get, call_594337.host, call_594337.base,
                         call_594337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594337, url, valid)

proc call*(call_594338: Call_BackupPoliciesBackupNow_594327;
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
  var path_594339 = newJObject()
  var query_594340 = newJObject()
  add(path_594339, "resourceGroupName", newJString(resourceGroupName))
  add(query_594340, "api-version", newJString(apiVersion))
  add(path_594339, "managerName", newJString(managerName))
  add(path_594339, "subscriptionId", newJString(subscriptionId))
  add(path_594339, "backupPolicyName", newJString(backupPolicyName))
  add(query_594340, "backupType", newJString(backupType))
  add(path_594339, "deviceName", newJString(deviceName))
  result = call_594338.call(path_594339, query_594340, nil, nil, nil)

var backupPoliciesBackupNow* = Call_BackupPoliciesBackupNow_594327(
    name: "backupPoliciesBackupNow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/backup",
    validator: validate_BackupPoliciesBackupNow_594328, base: "",
    url: url_BackupPoliciesBackupNow_594329, schemes: {Scheme.Https})
type
  Call_BackupSchedulesListByBackupPolicy_594341 = ref object of OpenApiRestCall_593438
proc url_BackupSchedulesListByBackupPolicy_594343(protocol: Scheme; host: string;
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

proc validate_BackupSchedulesListByBackupPolicy_594342(path: JsonNode;
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
  var valid_594344 = path.getOrDefault("resourceGroupName")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "resourceGroupName", valid_594344
  var valid_594345 = path.getOrDefault("managerName")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "managerName", valid_594345
  var valid_594346 = path.getOrDefault("subscriptionId")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "subscriptionId", valid_594346
  var valid_594347 = path.getOrDefault("backupPolicyName")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "backupPolicyName", valid_594347
  var valid_594348 = path.getOrDefault("deviceName")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "deviceName", valid_594348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594349 = query.getOrDefault("api-version")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "api-version", valid_594349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594350: Call_BackupSchedulesListByBackupPolicy_594341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the backup schedules in a backup policy.
  ## 
  let valid = call_594350.validator(path, query, header, formData, body)
  let scheme = call_594350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594350.url(scheme.get, call_594350.host, call_594350.base,
                         call_594350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594350, url, valid)

proc call*(call_594351: Call_BackupSchedulesListByBackupPolicy_594341;
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
  var path_594352 = newJObject()
  var query_594353 = newJObject()
  add(path_594352, "resourceGroupName", newJString(resourceGroupName))
  add(query_594353, "api-version", newJString(apiVersion))
  add(path_594352, "managerName", newJString(managerName))
  add(path_594352, "subscriptionId", newJString(subscriptionId))
  add(path_594352, "backupPolicyName", newJString(backupPolicyName))
  add(path_594352, "deviceName", newJString(deviceName))
  result = call_594351.call(path_594352, query_594353, nil, nil, nil)

var backupSchedulesListByBackupPolicy* = Call_BackupSchedulesListByBackupPolicy_594341(
    name: "backupSchedulesListByBackupPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/schedules",
    validator: validate_BackupSchedulesListByBackupPolicy_594342, base: "",
    url: url_BackupSchedulesListByBackupPolicy_594343, schemes: {Scheme.Https})
type
  Call_BackupSchedulesCreateOrUpdate_594368 = ref object of OpenApiRestCall_593438
proc url_BackupSchedulesCreateOrUpdate_594370(protocol: Scheme; host: string;
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

proc validate_BackupSchedulesCreateOrUpdate_594369(path: JsonNode; query: JsonNode;
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
  var valid_594371 = path.getOrDefault("resourceGroupName")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "resourceGroupName", valid_594371
  var valid_594372 = path.getOrDefault("managerName")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "managerName", valid_594372
  var valid_594373 = path.getOrDefault("subscriptionId")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "subscriptionId", valid_594373
  var valid_594374 = path.getOrDefault("backupScheduleName")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "backupScheduleName", valid_594374
  var valid_594375 = path.getOrDefault("backupPolicyName")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "backupPolicyName", valid_594375
  var valid_594376 = path.getOrDefault("deviceName")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "deviceName", valid_594376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594377 = query.getOrDefault("api-version")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "api-version", valid_594377
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

proc call*(call_594379: Call_BackupSchedulesCreateOrUpdate_594368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the backup schedule.
  ## 
  let valid = call_594379.validator(path, query, header, formData, body)
  let scheme = call_594379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594379.url(scheme.get, call_594379.host, call_594379.base,
                         call_594379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594379, url, valid)

proc call*(call_594380: Call_BackupSchedulesCreateOrUpdate_594368;
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
  var path_594381 = newJObject()
  var query_594382 = newJObject()
  var body_594383 = newJObject()
  add(path_594381, "resourceGroupName", newJString(resourceGroupName))
  add(query_594382, "api-version", newJString(apiVersion))
  add(path_594381, "managerName", newJString(managerName))
  add(path_594381, "subscriptionId", newJString(subscriptionId))
  add(path_594381, "backupScheduleName", newJString(backupScheduleName))
  add(path_594381, "backupPolicyName", newJString(backupPolicyName))
  if parameters != nil:
    body_594383 = parameters
  add(path_594381, "deviceName", newJString(deviceName))
  result = call_594380.call(path_594381, query_594382, nil, nil, body_594383)

var backupSchedulesCreateOrUpdate* = Call_BackupSchedulesCreateOrUpdate_594368(
    name: "backupSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/schedules/{backupScheduleName}",
    validator: validate_BackupSchedulesCreateOrUpdate_594369, base: "",
    url: url_BackupSchedulesCreateOrUpdate_594370, schemes: {Scheme.Https})
type
  Call_BackupSchedulesGet_594354 = ref object of OpenApiRestCall_593438
proc url_BackupSchedulesGet_594356(protocol: Scheme; host: string; base: string;
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

proc validate_BackupSchedulesGet_594355(path: JsonNode; query: JsonNode;
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
  var valid_594357 = path.getOrDefault("resourceGroupName")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "resourceGroupName", valid_594357
  var valid_594358 = path.getOrDefault("managerName")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "managerName", valid_594358
  var valid_594359 = path.getOrDefault("subscriptionId")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "subscriptionId", valid_594359
  var valid_594360 = path.getOrDefault("backupScheduleName")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "backupScheduleName", valid_594360
  var valid_594361 = path.getOrDefault("backupPolicyName")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "backupPolicyName", valid_594361
  var valid_594362 = path.getOrDefault("deviceName")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "deviceName", valid_594362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594363 = query.getOrDefault("api-version")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "api-version", valid_594363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594364: Call_BackupSchedulesGet_594354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified backup schedule name.
  ## 
  let valid = call_594364.validator(path, query, header, formData, body)
  let scheme = call_594364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594364.url(scheme.get, call_594364.host, call_594364.base,
                         call_594364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594364, url, valid)

proc call*(call_594365: Call_BackupSchedulesGet_594354; resourceGroupName: string;
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
  var path_594366 = newJObject()
  var query_594367 = newJObject()
  add(path_594366, "resourceGroupName", newJString(resourceGroupName))
  add(query_594367, "api-version", newJString(apiVersion))
  add(path_594366, "managerName", newJString(managerName))
  add(path_594366, "subscriptionId", newJString(subscriptionId))
  add(path_594366, "backupScheduleName", newJString(backupScheduleName))
  add(path_594366, "backupPolicyName", newJString(backupPolicyName))
  add(path_594366, "deviceName", newJString(deviceName))
  result = call_594365.call(path_594366, query_594367, nil, nil, nil)

var backupSchedulesGet* = Call_BackupSchedulesGet_594354(
    name: "backupSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/schedules/{backupScheduleName}",
    validator: validate_BackupSchedulesGet_594355, base: "",
    url: url_BackupSchedulesGet_594356, schemes: {Scheme.Https})
type
  Call_BackupSchedulesDelete_594384 = ref object of OpenApiRestCall_593438
proc url_BackupSchedulesDelete_594386(protocol: Scheme; host: string; base: string;
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

proc validate_BackupSchedulesDelete_594385(path: JsonNode; query: JsonNode;
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
  var valid_594387 = path.getOrDefault("resourceGroupName")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "resourceGroupName", valid_594387
  var valid_594388 = path.getOrDefault("managerName")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "managerName", valid_594388
  var valid_594389 = path.getOrDefault("subscriptionId")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "subscriptionId", valid_594389
  var valid_594390 = path.getOrDefault("backupScheduleName")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "backupScheduleName", valid_594390
  var valid_594391 = path.getOrDefault("backupPolicyName")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "backupPolicyName", valid_594391
  var valid_594392 = path.getOrDefault("deviceName")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "deviceName", valid_594392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594393 = query.getOrDefault("api-version")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "api-version", valid_594393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594394: Call_BackupSchedulesDelete_594384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup schedule.
  ## 
  let valid = call_594394.validator(path, query, header, formData, body)
  let scheme = call_594394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594394.url(scheme.get, call_594394.host, call_594394.base,
                         call_594394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594394, url, valid)

proc call*(call_594395: Call_BackupSchedulesDelete_594384;
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
  var path_594396 = newJObject()
  var query_594397 = newJObject()
  add(path_594396, "resourceGroupName", newJString(resourceGroupName))
  add(query_594397, "api-version", newJString(apiVersion))
  add(path_594396, "managerName", newJString(managerName))
  add(path_594396, "subscriptionId", newJString(subscriptionId))
  add(path_594396, "backupScheduleName", newJString(backupScheduleName))
  add(path_594396, "backupPolicyName", newJString(backupPolicyName))
  add(path_594396, "deviceName", newJString(deviceName))
  result = call_594395.call(path_594396, query_594397, nil, nil, nil)

var backupSchedulesDelete* = Call_BackupSchedulesDelete_594384(
    name: "backupSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backupPolicies/{backupPolicyName}/schedules/{backupScheduleName}",
    validator: validate_BackupSchedulesDelete_594385, base: "",
    url: url_BackupSchedulesDelete_594386, schemes: {Scheme.Https})
type
  Call_BackupsListByDevice_594398 = ref object of OpenApiRestCall_593438
proc url_BackupsListByDevice_594400(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsListByDevice_594399(path: JsonNode; query: JsonNode;
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
  var valid_594401 = path.getOrDefault("resourceGroupName")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "resourceGroupName", valid_594401
  var valid_594402 = path.getOrDefault("managerName")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "managerName", valid_594402
  var valid_594403 = path.getOrDefault("subscriptionId")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "subscriptionId", valid_594403
  var valid_594404 = path.getOrDefault("deviceName")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "deviceName", valid_594404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594405 = query.getOrDefault("api-version")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "api-version", valid_594405
  var valid_594406 = query.getOrDefault("$filter")
  valid_594406 = validateParameter(valid_594406, JString, required = false,
                                 default = nil)
  if valid_594406 != nil:
    section.add "$filter", valid_594406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594407: Call_BackupsListByDevice_594398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the backups in a device.
  ## 
  let valid = call_594407.validator(path, query, header, formData, body)
  let scheme = call_594407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594407.url(scheme.get, call_594407.host, call_594407.base,
                         call_594407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594407, url, valid)

proc call*(call_594408: Call_BackupsListByDevice_594398; resourceGroupName: string;
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
  var path_594409 = newJObject()
  var query_594410 = newJObject()
  add(path_594409, "resourceGroupName", newJString(resourceGroupName))
  add(query_594410, "api-version", newJString(apiVersion))
  add(path_594409, "managerName", newJString(managerName))
  add(path_594409, "subscriptionId", newJString(subscriptionId))
  add(query_594410, "$filter", newJString(Filter))
  add(path_594409, "deviceName", newJString(deviceName))
  result = call_594408.call(path_594409, query_594410, nil, nil, nil)

var backupsListByDevice* = Call_BackupsListByDevice_594398(
    name: "backupsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups",
    validator: validate_BackupsListByDevice_594399, base: "",
    url: url_BackupsListByDevice_594400, schemes: {Scheme.Https})
type
  Call_BackupsDelete_594411 = ref object of OpenApiRestCall_593438
proc url_BackupsDelete_594413(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsDelete_594412(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594414 = path.getOrDefault("resourceGroupName")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "resourceGroupName", valid_594414
  var valid_594415 = path.getOrDefault("managerName")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "managerName", valid_594415
  var valid_594416 = path.getOrDefault("subscriptionId")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "subscriptionId", valid_594416
  var valid_594417 = path.getOrDefault("backupName")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "backupName", valid_594417
  var valid_594418 = path.getOrDefault("deviceName")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "deviceName", valid_594418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594419 = query.getOrDefault("api-version")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "api-version", valid_594419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594420: Call_BackupsDelete_594411; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup.
  ## 
  let valid = call_594420.validator(path, query, header, formData, body)
  let scheme = call_594420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594420.url(scheme.get, call_594420.host, call_594420.base,
                         call_594420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594420, url, valid)

proc call*(call_594421: Call_BackupsDelete_594411; resourceGroupName: string;
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
  var path_594422 = newJObject()
  var query_594423 = newJObject()
  add(path_594422, "resourceGroupName", newJString(resourceGroupName))
  add(query_594423, "api-version", newJString(apiVersion))
  add(path_594422, "managerName", newJString(managerName))
  add(path_594422, "subscriptionId", newJString(subscriptionId))
  add(path_594422, "backupName", newJString(backupName))
  add(path_594422, "deviceName", newJString(deviceName))
  result = call_594421.call(path_594422, query_594423, nil, nil, nil)

var backupsDelete* = Call_BackupsDelete_594411(name: "backupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}",
    validator: validate_BackupsDelete_594412, base: "", url: url_BackupsDelete_594413,
    schemes: {Scheme.Https})
type
  Call_BackupsClone_594424 = ref object of OpenApiRestCall_593438
proc url_BackupsClone_594426(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsClone_594425(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594427 = path.getOrDefault("resourceGroupName")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "resourceGroupName", valid_594427
  var valid_594428 = path.getOrDefault("managerName")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "managerName", valid_594428
  var valid_594429 = path.getOrDefault("backupElementName")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "backupElementName", valid_594429
  var valid_594430 = path.getOrDefault("subscriptionId")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "subscriptionId", valid_594430
  var valid_594431 = path.getOrDefault("backupName")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "backupName", valid_594431
  var valid_594432 = path.getOrDefault("deviceName")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "deviceName", valid_594432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594433 = query.getOrDefault("api-version")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "api-version", valid_594433
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

proc call*(call_594435: Call_BackupsClone_594424; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clones the backup element as a new volume.
  ## 
  let valid = call_594435.validator(path, query, header, formData, body)
  let scheme = call_594435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594435.url(scheme.get, call_594435.host, call_594435.base,
                         call_594435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594435, url, valid)

proc call*(call_594436: Call_BackupsClone_594424; resourceGroupName: string;
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
  var path_594437 = newJObject()
  var query_594438 = newJObject()
  var body_594439 = newJObject()
  add(path_594437, "resourceGroupName", newJString(resourceGroupName))
  add(query_594438, "api-version", newJString(apiVersion))
  add(path_594437, "managerName", newJString(managerName))
  add(path_594437, "backupElementName", newJString(backupElementName))
  add(path_594437, "subscriptionId", newJString(subscriptionId))
  add(path_594437, "backupName", newJString(backupName))
  if parameters != nil:
    body_594439 = parameters
  add(path_594437, "deviceName", newJString(deviceName))
  result = call_594436.call(path_594437, query_594438, nil, nil, body_594439)

var backupsClone* = Call_BackupsClone_594424(name: "backupsClone",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}/elements/{backupElementName}/clone",
    validator: validate_BackupsClone_594425, base: "", url: url_BackupsClone_594426,
    schemes: {Scheme.Https})
type
  Call_BackupsRestore_594440 = ref object of OpenApiRestCall_593438
proc url_BackupsRestore_594442(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsRestore_594441(path: JsonNode; query: JsonNode;
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
  var valid_594443 = path.getOrDefault("resourceGroupName")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "resourceGroupName", valid_594443
  var valid_594444 = path.getOrDefault("managerName")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "managerName", valid_594444
  var valid_594445 = path.getOrDefault("subscriptionId")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "subscriptionId", valid_594445
  var valid_594446 = path.getOrDefault("backupName")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "backupName", valid_594446
  var valid_594447 = path.getOrDefault("deviceName")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "deviceName", valid_594447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594448 = query.getOrDefault("api-version")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = nil)
  if valid_594448 != nil:
    section.add "api-version", valid_594448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594449: Call_BackupsRestore_594440; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the backup on the device.
  ## 
  let valid = call_594449.validator(path, query, header, formData, body)
  let scheme = call_594449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594449.url(scheme.get, call_594449.host, call_594449.base,
                         call_594449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594449, url, valid)

proc call*(call_594450: Call_BackupsRestore_594440; resourceGroupName: string;
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
  var path_594451 = newJObject()
  var query_594452 = newJObject()
  add(path_594451, "resourceGroupName", newJString(resourceGroupName))
  add(query_594452, "api-version", newJString(apiVersion))
  add(path_594451, "managerName", newJString(managerName))
  add(path_594451, "subscriptionId", newJString(subscriptionId))
  add(path_594451, "backupName", newJString(backupName))
  add(path_594451, "deviceName", newJString(deviceName))
  result = call_594450.call(path_594451, query_594452, nil, nil, nil)

var backupsRestore* = Call_BackupsRestore_594440(name: "backupsRestore",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/backups/{backupName}/restore",
    validator: validate_BackupsRestore_594441, base: "", url: url_BackupsRestore_594442,
    schemes: {Scheme.Https})
type
  Call_DevicesDeactivate_594453 = ref object of OpenApiRestCall_593438
proc url_DevicesDeactivate_594455(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesDeactivate_594454(path: JsonNode; query: JsonNode;
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
  var valid_594456 = path.getOrDefault("resourceGroupName")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "resourceGroupName", valid_594456
  var valid_594457 = path.getOrDefault("managerName")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = nil)
  if valid_594457 != nil:
    section.add "managerName", valid_594457
  var valid_594458 = path.getOrDefault("subscriptionId")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "subscriptionId", valid_594458
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
  if body != nil:
    result.add "body", body

proc call*(call_594461: Call_DevicesDeactivate_594453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deactivates the device.
  ## 
  let valid = call_594461.validator(path, query, header, formData, body)
  let scheme = call_594461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594461.url(scheme.get, call_594461.host, call_594461.base,
                         call_594461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594461, url, valid)

proc call*(call_594462: Call_DevicesDeactivate_594453; resourceGroupName: string;
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
  var path_594463 = newJObject()
  var query_594464 = newJObject()
  add(path_594463, "resourceGroupName", newJString(resourceGroupName))
  add(query_594464, "api-version", newJString(apiVersion))
  add(path_594463, "managerName", newJString(managerName))
  add(path_594463, "subscriptionId", newJString(subscriptionId))
  add(path_594463, "deviceName", newJString(deviceName))
  result = call_594462.call(path_594463, query_594464, nil, nil, nil)

var devicesDeactivate* = Call_DevicesDeactivate_594453(name: "devicesDeactivate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/deactivate",
    validator: validate_DevicesDeactivate_594454, base: "",
    url: url_DevicesDeactivate_594455, schemes: {Scheme.Https})
type
  Call_HardwareComponentGroupsListByDevice_594465 = ref object of OpenApiRestCall_593438
proc url_HardwareComponentGroupsListByDevice_594467(protocol: Scheme; host: string;
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

proc validate_HardwareComponentGroupsListByDevice_594466(path: JsonNode;
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
  var valid_594468 = path.getOrDefault("resourceGroupName")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "resourceGroupName", valid_594468
  var valid_594469 = path.getOrDefault("managerName")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "managerName", valid_594469
  var valid_594470 = path.getOrDefault("subscriptionId")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "subscriptionId", valid_594470
  var valid_594471 = path.getOrDefault("deviceName")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "deviceName", valid_594471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594472 = query.getOrDefault("api-version")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "api-version", valid_594472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594473: Call_HardwareComponentGroupsListByDevice_594465;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the hardware component groups at device-level.
  ## 
  let valid = call_594473.validator(path, query, header, formData, body)
  let scheme = call_594473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594473.url(scheme.get, call_594473.host, call_594473.base,
                         call_594473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594473, url, valid)

proc call*(call_594474: Call_HardwareComponentGroupsListByDevice_594465;
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
  var path_594475 = newJObject()
  var query_594476 = newJObject()
  add(path_594475, "resourceGroupName", newJString(resourceGroupName))
  add(query_594476, "api-version", newJString(apiVersion))
  add(path_594475, "managerName", newJString(managerName))
  add(path_594475, "subscriptionId", newJString(subscriptionId))
  add(path_594475, "deviceName", newJString(deviceName))
  result = call_594474.call(path_594475, query_594476, nil, nil, nil)

var hardwareComponentGroupsListByDevice* = Call_HardwareComponentGroupsListByDevice_594465(
    name: "hardwareComponentGroupsListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/hardwareComponentGroups",
    validator: validate_HardwareComponentGroupsListByDevice_594466, base: "",
    url: url_HardwareComponentGroupsListByDevice_594467, schemes: {Scheme.Https})
type
  Call_HardwareComponentGroupsChangeControllerPowerState_594477 = ref object of OpenApiRestCall_593438
proc url_HardwareComponentGroupsChangeControllerPowerState_594479(
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

proc validate_HardwareComponentGroupsChangeControllerPowerState_594478(
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
  var valid_594480 = path.getOrDefault("resourceGroupName")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "resourceGroupName", valid_594480
  var valid_594481 = path.getOrDefault("managerName")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "managerName", valid_594481
  var valid_594482 = path.getOrDefault("hardwareComponentGroupName")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "hardwareComponentGroupName", valid_594482
  var valid_594483 = path.getOrDefault("subscriptionId")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "subscriptionId", valid_594483
  var valid_594484 = path.getOrDefault("deviceName")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = nil)
  if valid_594484 != nil:
    section.add "deviceName", valid_594484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594485 = query.getOrDefault("api-version")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "api-version", valid_594485
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

proc call*(call_594487: Call_HardwareComponentGroupsChangeControllerPowerState_594477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the power state of the controller.
  ## 
  let valid = call_594487.validator(path, query, header, formData, body)
  let scheme = call_594487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594487.url(scheme.get, call_594487.host, call_594487.base,
                         call_594487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594487, url, valid)

proc call*(call_594488: Call_HardwareComponentGroupsChangeControllerPowerState_594477;
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
  var path_594489 = newJObject()
  var query_594490 = newJObject()
  var body_594491 = newJObject()
  add(path_594489, "resourceGroupName", newJString(resourceGroupName))
  add(query_594490, "api-version", newJString(apiVersion))
  add(path_594489, "managerName", newJString(managerName))
  add(path_594489, "hardwareComponentGroupName",
      newJString(hardwareComponentGroupName))
  add(path_594489, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594491 = parameters
  add(path_594489, "deviceName", newJString(deviceName))
  result = call_594488.call(path_594489, query_594490, nil, nil, body_594491)

var hardwareComponentGroupsChangeControllerPowerState* = Call_HardwareComponentGroupsChangeControllerPowerState_594477(
    name: "hardwareComponentGroupsChangeControllerPowerState",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/hardwareComponentGroups/{hardwareComponentGroupName}/changeControllerPowerState",
    validator: validate_HardwareComponentGroupsChangeControllerPowerState_594478,
    base: "", url: url_HardwareComponentGroupsChangeControllerPowerState_594479,
    schemes: {Scheme.Https})
type
  Call_DevicesInstallUpdates_594492 = ref object of OpenApiRestCall_593438
proc url_DevicesInstallUpdates_594494(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesInstallUpdates_594493(path: JsonNode; query: JsonNode;
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
  var valid_594495 = path.getOrDefault("resourceGroupName")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "resourceGroupName", valid_594495
  var valid_594496 = path.getOrDefault("managerName")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "managerName", valid_594496
  var valid_594497 = path.getOrDefault("subscriptionId")
  valid_594497 = validateParameter(valid_594497, JString, required = true,
                                 default = nil)
  if valid_594497 != nil:
    section.add "subscriptionId", valid_594497
  var valid_594498 = path.getOrDefault("deviceName")
  valid_594498 = validateParameter(valid_594498, JString, required = true,
                                 default = nil)
  if valid_594498 != nil:
    section.add "deviceName", valid_594498
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594499 = query.getOrDefault("api-version")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "api-version", valid_594499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594500: Call_DevicesInstallUpdates_594492; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads and installs the updates on the device.
  ## 
  let valid = call_594500.validator(path, query, header, formData, body)
  let scheme = call_594500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594500.url(scheme.get, call_594500.host, call_594500.base,
                         call_594500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594500, url, valid)

proc call*(call_594501: Call_DevicesInstallUpdates_594492;
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
  var path_594502 = newJObject()
  var query_594503 = newJObject()
  add(path_594502, "resourceGroupName", newJString(resourceGroupName))
  add(query_594503, "api-version", newJString(apiVersion))
  add(path_594502, "managerName", newJString(managerName))
  add(path_594502, "subscriptionId", newJString(subscriptionId))
  add(path_594502, "deviceName", newJString(deviceName))
  result = call_594501.call(path_594502, query_594503, nil, nil, nil)

var devicesInstallUpdates* = Call_DevicesInstallUpdates_594492(
    name: "devicesInstallUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/installUpdates",
    validator: validate_DevicesInstallUpdates_594493, base: "",
    url: url_DevicesInstallUpdates_594494, schemes: {Scheme.Https})
type
  Call_JobsListByDevice_594504 = ref object of OpenApiRestCall_593438
proc url_JobsListByDevice_594506(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByDevice_594505(path: JsonNode; query: JsonNode;
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
  var valid_594507 = path.getOrDefault("resourceGroupName")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "resourceGroupName", valid_594507
  var valid_594508 = path.getOrDefault("managerName")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "managerName", valid_594508
  var valid_594509 = path.getOrDefault("subscriptionId")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "subscriptionId", valid_594509
  var valid_594510 = path.getOrDefault("deviceName")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "deviceName", valid_594510
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594511 = query.getOrDefault("api-version")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "api-version", valid_594511
  var valid_594512 = query.getOrDefault("$filter")
  valid_594512 = validateParameter(valid_594512, JString, required = false,
                                 default = nil)
  if valid_594512 != nil:
    section.add "$filter", valid_594512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594513: Call_JobsListByDevice_594504; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the jobs for specified device. With optional OData query parameters, a filtered set of jobs is returned.
  ## 
  let valid = call_594513.validator(path, query, header, formData, body)
  let scheme = call_594513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594513.url(scheme.get, call_594513.host, call_594513.base,
                         call_594513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594513, url, valid)

proc call*(call_594514: Call_JobsListByDevice_594504; resourceGroupName: string;
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
  var path_594515 = newJObject()
  var query_594516 = newJObject()
  add(path_594515, "resourceGroupName", newJString(resourceGroupName))
  add(query_594516, "api-version", newJString(apiVersion))
  add(path_594515, "managerName", newJString(managerName))
  add(path_594515, "subscriptionId", newJString(subscriptionId))
  add(query_594516, "$filter", newJString(Filter))
  add(path_594515, "deviceName", newJString(deviceName))
  result = call_594514.call(path_594515, query_594516, nil, nil, nil)

var jobsListByDevice* = Call_JobsListByDevice_594504(name: "jobsListByDevice",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs",
    validator: validate_JobsListByDevice_594505, base: "",
    url: url_JobsListByDevice_594506, schemes: {Scheme.Https})
type
  Call_JobsGet_594517 = ref object of OpenApiRestCall_593438
proc url_JobsGet_594519(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsGet_594518(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594520 = path.getOrDefault("resourceGroupName")
  valid_594520 = validateParameter(valid_594520, JString, required = true,
                                 default = nil)
  if valid_594520 != nil:
    section.add "resourceGroupName", valid_594520
  var valid_594521 = path.getOrDefault("managerName")
  valid_594521 = validateParameter(valid_594521, JString, required = true,
                                 default = nil)
  if valid_594521 != nil:
    section.add "managerName", valid_594521
  var valid_594522 = path.getOrDefault("subscriptionId")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "subscriptionId", valid_594522
  var valid_594523 = path.getOrDefault("jobName")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "jobName", valid_594523
  var valid_594524 = path.getOrDefault("deviceName")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "deviceName", valid_594524
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594525 = query.getOrDefault("api-version")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "api-version", valid_594525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594526: Call_JobsGet_594517; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the specified job name.
  ## 
  let valid = call_594526.validator(path, query, header, formData, body)
  let scheme = call_594526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594526.url(scheme.get, call_594526.host, call_594526.base,
                         call_594526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594526, url, valid)

proc call*(call_594527: Call_JobsGet_594517; resourceGroupName: string;
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
  var path_594528 = newJObject()
  var query_594529 = newJObject()
  add(path_594528, "resourceGroupName", newJString(resourceGroupName))
  add(query_594529, "api-version", newJString(apiVersion))
  add(path_594528, "managerName", newJString(managerName))
  add(path_594528, "subscriptionId", newJString(subscriptionId))
  add(path_594528, "jobName", newJString(jobName))
  add(path_594528, "deviceName", newJString(deviceName))
  result = call_594527.call(path_594528, query_594529, nil, nil, nil)

var jobsGet* = Call_JobsGet_594517(name: "jobsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs/{jobName}",
                                validator: validate_JobsGet_594518, base: "",
                                url: url_JobsGet_594519, schemes: {Scheme.Https})
type
  Call_JobsCancel_594530 = ref object of OpenApiRestCall_593438
proc url_JobsCancel_594532(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsCancel_594531(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594533 = path.getOrDefault("resourceGroupName")
  valid_594533 = validateParameter(valid_594533, JString, required = true,
                                 default = nil)
  if valid_594533 != nil:
    section.add "resourceGroupName", valid_594533
  var valid_594534 = path.getOrDefault("managerName")
  valid_594534 = validateParameter(valid_594534, JString, required = true,
                                 default = nil)
  if valid_594534 != nil:
    section.add "managerName", valid_594534
  var valid_594535 = path.getOrDefault("subscriptionId")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "subscriptionId", valid_594535
  var valid_594536 = path.getOrDefault("jobName")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "jobName", valid_594536
  var valid_594537 = path.getOrDefault("deviceName")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "deviceName", valid_594537
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594538 = query.getOrDefault("api-version")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "api-version", valid_594538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594539: Call_JobsCancel_594530; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a job on the device.
  ## 
  let valid = call_594539.validator(path, query, header, formData, body)
  let scheme = call_594539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594539.url(scheme.get, call_594539.host, call_594539.base,
                         call_594539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594539, url, valid)

proc call*(call_594540: Call_JobsCancel_594530; resourceGroupName: string;
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
  var path_594541 = newJObject()
  var query_594542 = newJObject()
  add(path_594541, "resourceGroupName", newJString(resourceGroupName))
  add(query_594542, "api-version", newJString(apiVersion))
  add(path_594541, "managerName", newJString(managerName))
  add(path_594541, "subscriptionId", newJString(subscriptionId))
  add(path_594541, "jobName", newJString(jobName))
  add(path_594541, "deviceName", newJString(deviceName))
  result = call_594540.call(path_594541, query_594542, nil, nil, nil)

var jobsCancel* = Call_JobsCancel_594530(name: "jobsCancel",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/jobs/{jobName}/cancel",
                                      validator: validate_JobsCancel_594531,
                                      base: "", url: url_JobsCancel_594532,
                                      schemes: {Scheme.Https})
type
  Call_DevicesListFailoverSets_594543 = ref object of OpenApiRestCall_593438
proc url_DevicesListFailoverSets_594545(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesListFailoverSets_594544(path: JsonNode; query: JsonNode;
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
  var valid_594546 = path.getOrDefault("resourceGroupName")
  valid_594546 = validateParameter(valid_594546, JString, required = true,
                                 default = nil)
  if valid_594546 != nil:
    section.add "resourceGroupName", valid_594546
  var valid_594547 = path.getOrDefault("managerName")
  valid_594547 = validateParameter(valid_594547, JString, required = true,
                                 default = nil)
  if valid_594547 != nil:
    section.add "managerName", valid_594547
  var valid_594548 = path.getOrDefault("subscriptionId")
  valid_594548 = validateParameter(valid_594548, JString, required = true,
                                 default = nil)
  if valid_594548 != nil:
    section.add "subscriptionId", valid_594548
  var valid_594549 = path.getOrDefault("deviceName")
  valid_594549 = validateParameter(valid_594549, JString, required = true,
                                 default = nil)
  if valid_594549 != nil:
    section.add "deviceName", valid_594549
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594550 = query.getOrDefault("api-version")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "api-version", valid_594550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594551: Call_DevicesListFailoverSets_594543; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all failover sets for a given device and their eligibility for participating in a failover. A failover set refers to a set of volume containers that need to be failed-over as a single unit to maintain data integrity.
  ## 
  let valid = call_594551.validator(path, query, header, formData, body)
  let scheme = call_594551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594551.url(scheme.get, call_594551.host, call_594551.base,
                         call_594551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594551, url, valid)

proc call*(call_594552: Call_DevicesListFailoverSets_594543;
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
  var path_594553 = newJObject()
  var query_594554 = newJObject()
  add(path_594553, "resourceGroupName", newJString(resourceGroupName))
  add(query_594554, "api-version", newJString(apiVersion))
  add(path_594553, "managerName", newJString(managerName))
  add(path_594553, "subscriptionId", newJString(subscriptionId))
  add(path_594553, "deviceName", newJString(deviceName))
  result = call_594552.call(path_594553, query_594554, nil, nil, nil)

var devicesListFailoverSets* = Call_DevicesListFailoverSets_594543(
    name: "devicesListFailoverSets", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/listFailoverSets",
    validator: validate_DevicesListFailoverSets_594544, base: "",
    url: url_DevicesListFailoverSets_594545, schemes: {Scheme.Https})
type
  Call_DevicesListMetrics_594555 = ref object of OpenApiRestCall_593438
proc url_DevicesListMetrics_594557(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesListMetrics_594556(path: JsonNode; query: JsonNode;
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
  var valid_594558 = path.getOrDefault("resourceGroupName")
  valid_594558 = validateParameter(valid_594558, JString, required = true,
                                 default = nil)
  if valid_594558 != nil:
    section.add "resourceGroupName", valid_594558
  var valid_594559 = path.getOrDefault("managerName")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = nil)
  if valid_594559 != nil:
    section.add "managerName", valid_594559
  var valid_594560 = path.getOrDefault("subscriptionId")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "subscriptionId", valid_594560
  var valid_594561 = path.getOrDefault("deviceName")
  valid_594561 = validateParameter(valid_594561, JString, required = true,
                                 default = nil)
  if valid_594561 != nil:
    section.add "deviceName", valid_594561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString (required)
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594562 = query.getOrDefault("api-version")
  valid_594562 = validateParameter(valid_594562, JString, required = true,
                                 default = nil)
  if valid_594562 != nil:
    section.add "api-version", valid_594562
  var valid_594563 = query.getOrDefault("$filter")
  valid_594563 = validateParameter(valid_594563, JString, required = true,
                                 default = nil)
  if valid_594563 != nil:
    section.add "$filter", valid_594563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594564: Call_DevicesListMetrics_594555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metrics for the specified device.
  ## 
  let valid = call_594564.validator(path, query, header, formData, body)
  let scheme = call_594564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594564.url(scheme.get, call_594564.host, call_594564.base,
                         call_594564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594564, url, valid)

proc call*(call_594565: Call_DevicesListMetrics_594555; resourceGroupName: string;
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
  var path_594566 = newJObject()
  var query_594567 = newJObject()
  add(path_594566, "resourceGroupName", newJString(resourceGroupName))
  add(query_594567, "api-version", newJString(apiVersion))
  add(path_594566, "managerName", newJString(managerName))
  add(path_594566, "subscriptionId", newJString(subscriptionId))
  add(query_594567, "$filter", newJString(Filter))
  add(path_594566, "deviceName", newJString(deviceName))
  result = call_594565.call(path_594566, query_594567, nil, nil, nil)

var devicesListMetrics* = Call_DevicesListMetrics_594555(
    name: "devicesListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/metrics",
    validator: validate_DevicesListMetrics_594556, base: "",
    url: url_DevicesListMetrics_594557, schemes: {Scheme.Https})
type
  Call_DevicesListMetricDefinition_594568 = ref object of OpenApiRestCall_593438
proc url_DevicesListMetricDefinition_594570(protocol: Scheme; host: string;
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

proc validate_DevicesListMetricDefinition_594569(path: JsonNode; query: JsonNode;
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
  var valid_594571 = path.getOrDefault("resourceGroupName")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "resourceGroupName", valid_594571
  var valid_594572 = path.getOrDefault("managerName")
  valid_594572 = validateParameter(valid_594572, JString, required = true,
                                 default = nil)
  if valid_594572 != nil:
    section.add "managerName", valid_594572
  var valid_594573 = path.getOrDefault("subscriptionId")
  valid_594573 = validateParameter(valid_594573, JString, required = true,
                                 default = nil)
  if valid_594573 != nil:
    section.add "subscriptionId", valid_594573
  var valid_594574 = path.getOrDefault("deviceName")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "deviceName", valid_594574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594575 = query.getOrDefault("api-version")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "api-version", valid_594575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594576: Call_DevicesListMetricDefinition_594568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metric definitions for the specified device.
  ## 
  let valid = call_594576.validator(path, query, header, formData, body)
  let scheme = call_594576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594576.url(scheme.get, call_594576.host, call_594576.base,
                         call_594576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594576, url, valid)

proc call*(call_594577: Call_DevicesListMetricDefinition_594568;
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
  var path_594578 = newJObject()
  var query_594579 = newJObject()
  add(path_594578, "resourceGroupName", newJString(resourceGroupName))
  add(query_594579, "api-version", newJString(apiVersion))
  add(path_594578, "managerName", newJString(managerName))
  add(path_594578, "subscriptionId", newJString(subscriptionId))
  add(path_594578, "deviceName", newJString(deviceName))
  result = call_594577.call(path_594578, query_594579, nil, nil, nil)

var devicesListMetricDefinition* = Call_DevicesListMetricDefinition_594568(
    name: "devicesListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/metricsDefinitions",
    validator: validate_DevicesListMetricDefinition_594569, base: "",
    url: url_DevicesListMetricDefinition_594570, schemes: {Scheme.Https})
type
  Call_DeviceSettingsGetNetworkSettings_594580 = ref object of OpenApiRestCall_593438
proc url_DeviceSettingsGetNetworkSettings_594582(protocol: Scheme; host: string;
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

proc validate_DeviceSettingsGetNetworkSettings_594581(path: JsonNode;
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
  var valid_594583 = path.getOrDefault("resourceGroupName")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "resourceGroupName", valid_594583
  var valid_594584 = path.getOrDefault("managerName")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "managerName", valid_594584
  var valid_594585 = path.getOrDefault("subscriptionId")
  valid_594585 = validateParameter(valid_594585, JString, required = true,
                                 default = nil)
  if valid_594585 != nil:
    section.add "subscriptionId", valid_594585
  var valid_594586 = path.getOrDefault("deviceName")
  valid_594586 = validateParameter(valid_594586, JString, required = true,
                                 default = nil)
  if valid_594586 != nil:
    section.add "deviceName", valid_594586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594587 = query.getOrDefault("api-version")
  valid_594587 = validateParameter(valid_594587, JString, required = true,
                                 default = nil)
  if valid_594587 != nil:
    section.add "api-version", valid_594587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594588: Call_DeviceSettingsGetNetworkSettings_594580;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the network settings of the specified device.
  ## 
  let valid = call_594588.validator(path, query, header, formData, body)
  let scheme = call_594588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594588.url(scheme.get, call_594588.host, call_594588.base,
                         call_594588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594588, url, valid)

proc call*(call_594589: Call_DeviceSettingsGetNetworkSettings_594580;
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
  var path_594590 = newJObject()
  var query_594591 = newJObject()
  add(path_594590, "resourceGroupName", newJString(resourceGroupName))
  add(query_594591, "api-version", newJString(apiVersion))
  add(path_594590, "managerName", newJString(managerName))
  add(path_594590, "subscriptionId", newJString(subscriptionId))
  add(path_594590, "deviceName", newJString(deviceName))
  result = call_594589.call(path_594590, query_594591, nil, nil, nil)

var deviceSettingsGetNetworkSettings* = Call_DeviceSettingsGetNetworkSettings_594580(
    name: "deviceSettingsGetNetworkSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/networkSettings/default",
    validator: validate_DeviceSettingsGetNetworkSettings_594581, base: "",
    url: url_DeviceSettingsGetNetworkSettings_594582, schemes: {Scheme.Https})
type
  Call_DeviceSettingsUpdateNetworkSettings_594592 = ref object of OpenApiRestCall_593438
proc url_DeviceSettingsUpdateNetworkSettings_594594(protocol: Scheme; host: string;
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

proc validate_DeviceSettingsUpdateNetworkSettings_594593(path: JsonNode;
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
  var valid_594598 = path.getOrDefault("deviceName")
  valid_594598 = validateParameter(valid_594598, JString, required = true,
                                 default = nil)
  if valid_594598 != nil:
    section.add "deviceName", valid_594598
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594599 = query.getOrDefault("api-version")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = nil)
  if valid_594599 != nil:
    section.add "api-version", valid_594599
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

proc call*(call_594601: Call_DeviceSettingsUpdateNetworkSettings_594592;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the network settings on the specified device.
  ## 
  let valid = call_594601.validator(path, query, header, formData, body)
  let scheme = call_594601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594601.url(scheme.get, call_594601.host, call_594601.base,
                         call_594601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594601, url, valid)

proc call*(call_594602: Call_DeviceSettingsUpdateNetworkSettings_594592;
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
  var path_594603 = newJObject()
  var query_594604 = newJObject()
  var body_594605 = newJObject()
  add(path_594603, "resourceGroupName", newJString(resourceGroupName))
  add(query_594604, "api-version", newJString(apiVersion))
  add(path_594603, "managerName", newJString(managerName))
  add(path_594603, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594605 = parameters
  add(path_594603, "deviceName", newJString(deviceName))
  result = call_594602.call(path_594603, query_594604, nil, nil, body_594605)

var deviceSettingsUpdateNetworkSettings* = Call_DeviceSettingsUpdateNetworkSettings_594592(
    name: "deviceSettingsUpdateNetworkSettings", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/networkSettings/default",
    validator: validate_DeviceSettingsUpdateNetworkSettings_594593, base: "",
    url: url_DeviceSettingsUpdateNetworkSettings_594594, schemes: {Scheme.Https})
type
  Call_ManagersGetDevicePublicEncryptionKey_594606 = ref object of OpenApiRestCall_593438
proc url_ManagersGetDevicePublicEncryptionKey_594608(protocol: Scheme;
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

proc validate_ManagersGetDevicePublicEncryptionKey_594607(path: JsonNode;
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

proc call*(call_594614: Call_ManagersGetDevicePublicEncryptionKey_594606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the public encryption key of the device.
  ## 
  let valid = call_594614.validator(path, query, header, formData, body)
  let scheme = call_594614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594614.url(scheme.get, call_594614.host, call_594614.base,
                         call_594614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594614, url, valid)

proc call*(call_594615: Call_ManagersGetDevicePublicEncryptionKey_594606;
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
  var path_594616 = newJObject()
  var query_594617 = newJObject()
  add(path_594616, "resourceGroupName", newJString(resourceGroupName))
  add(query_594617, "api-version", newJString(apiVersion))
  add(path_594616, "managerName", newJString(managerName))
  add(path_594616, "subscriptionId", newJString(subscriptionId))
  add(path_594616, "deviceName", newJString(deviceName))
  result = call_594615.call(path_594616, query_594617, nil, nil, nil)

var managersGetDevicePublicEncryptionKey* = Call_ManagersGetDevicePublicEncryptionKey_594606(
    name: "managersGetDevicePublicEncryptionKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/publicEncryptionKey",
    validator: validate_ManagersGetDevicePublicEncryptionKey_594607, base: "",
    url: url_ManagersGetDevicePublicEncryptionKey_594608, schemes: {Scheme.Https})
type
  Call_DevicesScanForUpdates_594618 = ref object of OpenApiRestCall_593438
proc url_DevicesScanForUpdates_594620(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesScanForUpdates_594619(path: JsonNode; query: JsonNode;
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

proc call*(call_594626: Call_DevicesScanForUpdates_594618; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Scans for updates on the device.
  ## 
  let valid = call_594626.validator(path, query, header, formData, body)
  let scheme = call_594626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594626.url(scheme.get, call_594626.host, call_594626.base,
                         call_594626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594626, url, valid)

proc call*(call_594627: Call_DevicesScanForUpdates_594618;
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
  var path_594628 = newJObject()
  var query_594629 = newJObject()
  add(path_594628, "resourceGroupName", newJString(resourceGroupName))
  add(query_594629, "api-version", newJString(apiVersion))
  add(path_594628, "managerName", newJString(managerName))
  add(path_594628, "subscriptionId", newJString(subscriptionId))
  add(path_594628, "deviceName", newJString(deviceName))
  result = call_594627.call(path_594628, query_594629, nil, nil, nil)

var devicesScanForUpdates* = Call_DevicesScanForUpdates_594618(
    name: "devicesScanForUpdates", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/scanForUpdates",
    validator: validate_DevicesScanForUpdates_594619, base: "",
    url: url_DevicesScanForUpdates_594620, schemes: {Scheme.Https})
type
  Call_DeviceSettingsGetSecuritySettings_594630 = ref object of OpenApiRestCall_593438
proc url_DeviceSettingsGetSecuritySettings_594632(protocol: Scheme; host: string;
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

proc validate_DeviceSettingsGetSecuritySettings_594631(path: JsonNode;
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
  var valid_594636 = path.getOrDefault("deviceName")
  valid_594636 = validateParameter(valid_594636, JString, required = true,
                                 default = nil)
  if valid_594636 != nil:
    section.add "deviceName", valid_594636
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594637 = query.getOrDefault("api-version")
  valid_594637 = validateParameter(valid_594637, JString, required = true,
                                 default = nil)
  if valid_594637 != nil:
    section.add "api-version", valid_594637
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594638: Call_DeviceSettingsGetSecuritySettings_594630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the Security properties of the specified device name.
  ## 
  let valid = call_594638.validator(path, query, header, formData, body)
  let scheme = call_594638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594638.url(scheme.get, call_594638.host, call_594638.base,
                         call_594638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594638, url, valid)

proc call*(call_594639: Call_DeviceSettingsGetSecuritySettings_594630;
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
  var path_594640 = newJObject()
  var query_594641 = newJObject()
  add(path_594640, "resourceGroupName", newJString(resourceGroupName))
  add(query_594641, "api-version", newJString(apiVersion))
  add(path_594640, "managerName", newJString(managerName))
  add(path_594640, "subscriptionId", newJString(subscriptionId))
  add(path_594640, "deviceName", newJString(deviceName))
  result = call_594639.call(path_594640, query_594641, nil, nil, nil)

var deviceSettingsGetSecuritySettings* = Call_DeviceSettingsGetSecuritySettings_594630(
    name: "deviceSettingsGetSecuritySettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/securitySettings/default",
    validator: validate_DeviceSettingsGetSecuritySettings_594631, base: "",
    url: url_DeviceSettingsGetSecuritySettings_594632, schemes: {Scheme.Https})
type
  Call_DeviceSettingsUpdateSecuritySettings_594642 = ref object of OpenApiRestCall_593438
proc url_DeviceSettingsUpdateSecuritySettings_594644(protocol: Scheme;
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

proc validate_DeviceSettingsUpdateSecuritySettings_594643(path: JsonNode;
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
  var valid_594645 = path.getOrDefault("resourceGroupName")
  valid_594645 = validateParameter(valid_594645, JString, required = true,
                                 default = nil)
  if valid_594645 != nil:
    section.add "resourceGroupName", valid_594645
  var valid_594646 = path.getOrDefault("managerName")
  valid_594646 = validateParameter(valid_594646, JString, required = true,
                                 default = nil)
  if valid_594646 != nil:
    section.add "managerName", valid_594646
  var valid_594647 = path.getOrDefault("subscriptionId")
  valid_594647 = validateParameter(valid_594647, JString, required = true,
                                 default = nil)
  if valid_594647 != nil:
    section.add "subscriptionId", valid_594647
  var valid_594648 = path.getOrDefault("deviceName")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "deviceName", valid_594648
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594649 = query.getOrDefault("api-version")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "api-version", valid_594649
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

proc call*(call_594651: Call_DeviceSettingsUpdateSecuritySettings_594642;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patch Security properties of the specified device name.
  ## 
  let valid = call_594651.validator(path, query, header, formData, body)
  let scheme = call_594651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594651.url(scheme.get, call_594651.host, call_594651.base,
                         call_594651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594651, url, valid)

proc call*(call_594652: Call_DeviceSettingsUpdateSecuritySettings_594642;
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
  var path_594653 = newJObject()
  var query_594654 = newJObject()
  var body_594655 = newJObject()
  add(path_594653, "resourceGroupName", newJString(resourceGroupName))
  add(query_594654, "api-version", newJString(apiVersion))
  add(path_594653, "managerName", newJString(managerName))
  add(path_594653, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594655 = parameters
  add(path_594653, "deviceName", newJString(deviceName))
  result = call_594652.call(path_594653, query_594654, nil, nil, body_594655)

var deviceSettingsUpdateSecuritySettings* = Call_DeviceSettingsUpdateSecuritySettings_594642(
    name: "deviceSettingsUpdateSecuritySettings", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/securitySettings/default",
    validator: validate_DeviceSettingsUpdateSecuritySettings_594643, base: "",
    url: url_DeviceSettingsUpdateSecuritySettings_594644, schemes: {Scheme.Https})
type
  Call_DeviceSettingsSyncRemotemanagementCertificate_594656 = ref object of OpenApiRestCall_593438
proc url_DeviceSettingsSyncRemotemanagementCertificate_594658(protocol: Scheme;
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

proc validate_DeviceSettingsSyncRemotemanagementCertificate_594657(
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
  var valid_594659 = path.getOrDefault("resourceGroupName")
  valid_594659 = validateParameter(valid_594659, JString, required = true,
                                 default = nil)
  if valid_594659 != nil:
    section.add "resourceGroupName", valid_594659
  var valid_594660 = path.getOrDefault("managerName")
  valid_594660 = validateParameter(valid_594660, JString, required = true,
                                 default = nil)
  if valid_594660 != nil:
    section.add "managerName", valid_594660
  var valid_594661 = path.getOrDefault("subscriptionId")
  valid_594661 = validateParameter(valid_594661, JString, required = true,
                                 default = nil)
  if valid_594661 != nil:
    section.add "subscriptionId", valid_594661
  var valid_594662 = path.getOrDefault("deviceName")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = nil)
  if valid_594662 != nil:
    section.add "deviceName", valid_594662
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594663 = query.getOrDefault("api-version")
  valid_594663 = validateParameter(valid_594663, JString, required = true,
                                 default = nil)
  if valid_594663 != nil:
    section.add "api-version", valid_594663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594664: Call_DeviceSettingsSyncRemotemanagementCertificate_594656;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## sync Remote management Certificate between appliance and Service
  ## 
  let valid = call_594664.validator(path, query, header, formData, body)
  let scheme = call_594664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594664.url(scheme.get, call_594664.host, call_594664.base,
                         call_594664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594664, url, valid)

proc call*(call_594665: Call_DeviceSettingsSyncRemotemanagementCertificate_594656;
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
  var path_594666 = newJObject()
  var query_594667 = newJObject()
  add(path_594666, "resourceGroupName", newJString(resourceGroupName))
  add(query_594667, "api-version", newJString(apiVersion))
  add(path_594666, "managerName", newJString(managerName))
  add(path_594666, "subscriptionId", newJString(subscriptionId))
  add(path_594666, "deviceName", newJString(deviceName))
  result = call_594665.call(path_594666, query_594667, nil, nil, nil)

var deviceSettingsSyncRemotemanagementCertificate* = Call_DeviceSettingsSyncRemotemanagementCertificate_594656(
    name: "deviceSettingsSyncRemotemanagementCertificate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/securitySettings/default/syncRemoteManagementCertificate",
    validator: validate_DeviceSettingsSyncRemotemanagementCertificate_594657,
    base: "", url: url_DeviceSettingsSyncRemotemanagementCertificate_594658,
    schemes: {Scheme.Https})
type
  Call_AlertsSendTestEmail_594668 = ref object of OpenApiRestCall_593438
proc url_AlertsSendTestEmail_594670(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsSendTestEmail_594669(path: JsonNode; query: JsonNode;
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
  var valid_594671 = path.getOrDefault("resourceGroupName")
  valid_594671 = validateParameter(valid_594671, JString, required = true,
                                 default = nil)
  if valid_594671 != nil:
    section.add "resourceGroupName", valid_594671
  var valid_594672 = path.getOrDefault("managerName")
  valid_594672 = validateParameter(valid_594672, JString, required = true,
                                 default = nil)
  if valid_594672 != nil:
    section.add "managerName", valid_594672
  var valid_594673 = path.getOrDefault("subscriptionId")
  valid_594673 = validateParameter(valid_594673, JString, required = true,
                                 default = nil)
  if valid_594673 != nil:
    section.add "subscriptionId", valid_594673
  var valid_594674 = path.getOrDefault("deviceName")
  valid_594674 = validateParameter(valid_594674, JString, required = true,
                                 default = nil)
  if valid_594674 != nil:
    section.add "deviceName", valid_594674
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594675 = query.getOrDefault("api-version")
  valid_594675 = validateParameter(valid_594675, JString, required = true,
                                 default = nil)
  if valid_594675 != nil:
    section.add "api-version", valid_594675
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

proc call*(call_594677: Call_AlertsSendTestEmail_594668; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a test alert email.
  ## 
  let valid = call_594677.validator(path, query, header, formData, body)
  let scheme = call_594677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594677.url(scheme.get, call_594677.host, call_594677.base,
                         call_594677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594677, url, valid)

proc call*(call_594678: Call_AlertsSendTestEmail_594668; resourceGroupName: string;
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
  var path_594679 = newJObject()
  var query_594680 = newJObject()
  var body_594681 = newJObject()
  add(path_594679, "resourceGroupName", newJString(resourceGroupName))
  add(query_594680, "api-version", newJString(apiVersion))
  add(path_594679, "managerName", newJString(managerName))
  add(path_594679, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594681 = parameters
  add(path_594679, "deviceName", newJString(deviceName))
  result = call_594678.call(path_594679, query_594680, nil, nil, body_594681)

var alertsSendTestEmail* = Call_AlertsSendTestEmail_594668(
    name: "alertsSendTestEmail", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/sendTestAlertEmail",
    validator: validate_AlertsSendTestEmail_594669, base: "",
    url: url_AlertsSendTestEmail_594670, schemes: {Scheme.Https})
type
  Call_DeviceSettingsCreateOrUpdateTimeSettings_594694 = ref object of OpenApiRestCall_593438
proc url_DeviceSettingsCreateOrUpdateTimeSettings_594696(protocol: Scheme;
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

proc validate_DeviceSettingsCreateOrUpdateTimeSettings_594695(path: JsonNode;
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
  var valid_594697 = path.getOrDefault("resourceGroupName")
  valid_594697 = validateParameter(valid_594697, JString, required = true,
                                 default = nil)
  if valid_594697 != nil:
    section.add "resourceGroupName", valid_594697
  var valid_594698 = path.getOrDefault("managerName")
  valid_594698 = validateParameter(valid_594698, JString, required = true,
                                 default = nil)
  if valid_594698 != nil:
    section.add "managerName", valid_594698
  var valid_594699 = path.getOrDefault("subscriptionId")
  valid_594699 = validateParameter(valid_594699, JString, required = true,
                                 default = nil)
  if valid_594699 != nil:
    section.add "subscriptionId", valid_594699
  var valid_594700 = path.getOrDefault("deviceName")
  valid_594700 = validateParameter(valid_594700, JString, required = true,
                                 default = nil)
  if valid_594700 != nil:
    section.add "deviceName", valid_594700
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594701 = query.getOrDefault("api-version")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = nil)
  if valid_594701 != nil:
    section.add "api-version", valid_594701
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

proc call*(call_594703: Call_DeviceSettingsCreateOrUpdateTimeSettings_594694;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the time settings of the specified device.
  ## 
  let valid = call_594703.validator(path, query, header, formData, body)
  let scheme = call_594703.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594703.url(scheme.get, call_594703.host, call_594703.base,
                         call_594703.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594703, url, valid)

proc call*(call_594704: Call_DeviceSettingsCreateOrUpdateTimeSettings_594694;
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
  var path_594705 = newJObject()
  var query_594706 = newJObject()
  var body_594707 = newJObject()
  add(path_594705, "resourceGroupName", newJString(resourceGroupName))
  add(query_594706, "api-version", newJString(apiVersion))
  add(path_594705, "managerName", newJString(managerName))
  add(path_594705, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594707 = parameters
  add(path_594705, "deviceName", newJString(deviceName))
  result = call_594704.call(path_594705, query_594706, nil, nil, body_594707)

var deviceSettingsCreateOrUpdateTimeSettings* = Call_DeviceSettingsCreateOrUpdateTimeSettings_594694(
    name: "deviceSettingsCreateOrUpdateTimeSettings", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/timeSettings/default",
    validator: validate_DeviceSettingsCreateOrUpdateTimeSettings_594695, base: "",
    url: url_DeviceSettingsCreateOrUpdateTimeSettings_594696,
    schemes: {Scheme.Https})
type
  Call_DeviceSettingsGetTimeSettings_594682 = ref object of OpenApiRestCall_593438
proc url_DeviceSettingsGetTimeSettings_594684(protocol: Scheme; host: string;
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

proc validate_DeviceSettingsGetTimeSettings_594683(path: JsonNode; query: JsonNode;
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
  var valid_594685 = path.getOrDefault("resourceGroupName")
  valid_594685 = validateParameter(valid_594685, JString, required = true,
                                 default = nil)
  if valid_594685 != nil:
    section.add "resourceGroupName", valid_594685
  var valid_594686 = path.getOrDefault("managerName")
  valid_594686 = validateParameter(valid_594686, JString, required = true,
                                 default = nil)
  if valid_594686 != nil:
    section.add "managerName", valid_594686
  var valid_594687 = path.getOrDefault("subscriptionId")
  valid_594687 = validateParameter(valid_594687, JString, required = true,
                                 default = nil)
  if valid_594687 != nil:
    section.add "subscriptionId", valid_594687
  var valid_594688 = path.getOrDefault("deviceName")
  valid_594688 = validateParameter(valid_594688, JString, required = true,
                                 default = nil)
  if valid_594688 != nil:
    section.add "deviceName", valid_594688
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594689 = query.getOrDefault("api-version")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = nil)
  if valid_594689 != nil:
    section.add "api-version", valid_594689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594690: Call_DeviceSettingsGetTimeSettings_594682; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the time settings of the specified device.
  ## 
  let valid = call_594690.validator(path, query, header, formData, body)
  let scheme = call_594690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594690.url(scheme.get, call_594690.host, call_594690.base,
                         call_594690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594690, url, valid)

proc call*(call_594691: Call_DeviceSettingsGetTimeSettings_594682;
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
  var path_594692 = newJObject()
  var query_594693 = newJObject()
  add(path_594692, "resourceGroupName", newJString(resourceGroupName))
  add(query_594693, "api-version", newJString(apiVersion))
  add(path_594692, "managerName", newJString(managerName))
  add(path_594692, "subscriptionId", newJString(subscriptionId))
  add(path_594692, "deviceName", newJString(deviceName))
  result = call_594691.call(path_594692, query_594693, nil, nil, nil)

var deviceSettingsGetTimeSettings* = Call_DeviceSettingsGetTimeSettings_594682(
    name: "deviceSettingsGetTimeSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/timeSettings/default",
    validator: validate_DeviceSettingsGetTimeSettings_594683, base: "",
    url: url_DeviceSettingsGetTimeSettings_594684, schemes: {Scheme.Https})
type
  Call_DevicesGetUpdateSummary_594708 = ref object of OpenApiRestCall_593438
proc url_DevicesGetUpdateSummary_594710(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetUpdateSummary_594709(path: JsonNode; query: JsonNode;
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
  var valid_594711 = path.getOrDefault("resourceGroupName")
  valid_594711 = validateParameter(valid_594711, JString, required = true,
                                 default = nil)
  if valid_594711 != nil:
    section.add "resourceGroupName", valid_594711
  var valid_594712 = path.getOrDefault("managerName")
  valid_594712 = validateParameter(valid_594712, JString, required = true,
                                 default = nil)
  if valid_594712 != nil:
    section.add "managerName", valid_594712
  var valid_594713 = path.getOrDefault("subscriptionId")
  valid_594713 = validateParameter(valid_594713, JString, required = true,
                                 default = nil)
  if valid_594713 != nil:
    section.add "subscriptionId", valid_594713
  var valid_594714 = path.getOrDefault("deviceName")
  valid_594714 = validateParameter(valid_594714, JString, required = true,
                                 default = nil)
  if valid_594714 != nil:
    section.add "deviceName", valid_594714
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594715 = query.getOrDefault("api-version")
  valid_594715 = validateParameter(valid_594715, JString, required = true,
                                 default = nil)
  if valid_594715 != nil:
    section.add "api-version", valid_594715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594716: Call_DevicesGetUpdateSummary_594708; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the update summary of the specified device name.
  ## 
  let valid = call_594716.validator(path, query, header, formData, body)
  let scheme = call_594716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594716.url(scheme.get, call_594716.host, call_594716.base,
                         call_594716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594716, url, valid)

proc call*(call_594717: Call_DevicesGetUpdateSummary_594708;
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
  var path_594718 = newJObject()
  var query_594719 = newJObject()
  add(path_594718, "resourceGroupName", newJString(resourceGroupName))
  add(query_594719, "api-version", newJString(apiVersion))
  add(path_594718, "managerName", newJString(managerName))
  add(path_594718, "subscriptionId", newJString(subscriptionId))
  add(path_594718, "deviceName", newJString(deviceName))
  result = call_594717.call(path_594718, query_594719, nil, nil, nil)

var devicesGetUpdateSummary* = Call_DevicesGetUpdateSummary_594708(
    name: "devicesGetUpdateSummary", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/updateSummary/default",
    validator: validate_DevicesGetUpdateSummary_594709, base: "",
    url: url_DevicesGetUpdateSummary_594710, schemes: {Scheme.Https})
type
  Call_VolumeContainersListByDevice_594720 = ref object of OpenApiRestCall_593438
proc url_VolumeContainersListByDevice_594722(protocol: Scheme; host: string;
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

proc validate_VolumeContainersListByDevice_594721(path: JsonNode; query: JsonNode;
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
  var valid_594723 = path.getOrDefault("resourceGroupName")
  valid_594723 = validateParameter(valid_594723, JString, required = true,
                                 default = nil)
  if valid_594723 != nil:
    section.add "resourceGroupName", valid_594723
  var valid_594724 = path.getOrDefault("managerName")
  valid_594724 = validateParameter(valid_594724, JString, required = true,
                                 default = nil)
  if valid_594724 != nil:
    section.add "managerName", valid_594724
  var valid_594725 = path.getOrDefault("subscriptionId")
  valid_594725 = validateParameter(valid_594725, JString, required = true,
                                 default = nil)
  if valid_594725 != nil:
    section.add "subscriptionId", valid_594725
  var valid_594726 = path.getOrDefault("deviceName")
  valid_594726 = validateParameter(valid_594726, JString, required = true,
                                 default = nil)
  if valid_594726 != nil:
    section.add "deviceName", valid_594726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594727 = query.getOrDefault("api-version")
  valid_594727 = validateParameter(valid_594727, JString, required = true,
                                 default = nil)
  if valid_594727 != nil:
    section.add "api-version", valid_594727
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594728: Call_VolumeContainersListByDevice_594720; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the volume containers in a device.
  ## 
  let valid = call_594728.validator(path, query, header, formData, body)
  let scheme = call_594728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594728.url(scheme.get, call_594728.host, call_594728.base,
                         call_594728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594728, url, valid)

proc call*(call_594729: Call_VolumeContainersListByDevice_594720;
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
  var path_594730 = newJObject()
  var query_594731 = newJObject()
  add(path_594730, "resourceGroupName", newJString(resourceGroupName))
  add(query_594731, "api-version", newJString(apiVersion))
  add(path_594730, "managerName", newJString(managerName))
  add(path_594730, "subscriptionId", newJString(subscriptionId))
  add(path_594730, "deviceName", newJString(deviceName))
  result = call_594729.call(path_594730, query_594731, nil, nil, nil)

var volumeContainersListByDevice* = Call_VolumeContainersListByDevice_594720(
    name: "volumeContainersListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers",
    validator: validate_VolumeContainersListByDevice_594721, base: "",
    url: url_VolumeContainersListByDevice_594722, schemes: {Scheme.Https})
type
  Call_VolumeContainersCreateOrUpdate_594745 = ref object of OpenApiRestCall_593438
proc url_VolumeContainersCreateOrUpdate_594747(protocol: Scheme; host: string;
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

proc validate_VolumeContainersCreateOrUpdate_594746(path: JsonNode;
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
  var valid_594748 = path.getOrDefault("resourceGroupName")
  valid_594748 = validateParameter(valid_594748, JString, required = true,
                                 default = nil)
  if valid_594748 != nil:
    section.add "resourceGroupName", valid_594748
  var valid_594749 = path.getOrDefault("managerName")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "managerName", valid_594749
  var valid_594750 = path.getOrDefault("volumeContainerName")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "volumeContainerName", valid_594750
  var valid_594751 = path.getOrDefault("subscriptionId")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "subscriptionId", valid_594751
  var valid_594752 = path.getOrDefault("deviceName")
  valid_594752 = validateParameter(valid_594752, JString, required = true,
                                 default = nil)
  if valid_594752 != nil:
    section.add "deviceName", valid_594752
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594753 = query.getOrDefault("api-version")
  valid_594753 = validateParameter(valid_594753, JString, required = true,
                                 default = nil)
  if valid_594753 != nil:
    section.add "api-version", valid_594753
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

proc call*(call_594755: Call_VolumeContainersCreateOrUpdate_594745; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the volume container.
  ## 
  let valid = call_594755.validator(path, query, header, formData, body)
  let scheme = call_594755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594755.url(scheme.get, call_594755.host, call_594755.base,
                         call_594755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594755, url, valid)

proc call*(call_594756: Call_VolumeContainersCreateOrUpdate_594745;
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
  var path_594757 = newJObject()
  var query_594758 = newJObject()
  var body_594759 = newJObject()
  add(path_594757, "resourceGroupName", newJString(resourceGroupName))
  add(query_594758, "api-version", newJString(apiVersion))
  add(path_594757, "managerName", newJString(managerName))
  add(path_594757, "volumeContainerName", newJString(volumeContainerName))
  add(path_594757, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594759 = parameters
  add(path_594757, "deviceName", newJString(deviceName))
  result = call_594756.call(path_594757, query_594758, nil, nil, body_594759)

var volumeContainersCreateOrUpdate* = Call_VolumeContainersCreateOrUpdate_594745(
    name: "volumeContainersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}",
    validator: validate_VolumeContainersCreateOrUpdate_594746, base: "",
    url: url_VolumeContainersCreateOrUpdate_594747, schemes: {Scheme.Https})
type
  Call_VolumeContainersGet_594732 = ref object of OpenApiRestCall_593438
proc url_VolumeContainersGet_594734(protocol: Scheme; host: string; base: string;
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

proc validate_VolumeContainersGet_594733(path: JsonNode; query: JsonNode;
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
  var valid_594735 = path.getOrDefault("resourceGroupName")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "resourceGroupName", valid_594735
  var valid_594736 = path.getOrDefault("managerName")
  valid_594736 = validateParameter(valid_594736, JString, required = true,
                                 default = nil)
  if valid_594736 != nil:
    section.add "managerName", valid_594736
  var valid_594737 = path.getOrDefault("volumeContainerName")
  valid_594737 = validateParameter(valid_594737, JString, required = true,
                                 default = nil)
  if valid_594737 != nil:
    section.add "volumeContainerName", valid_594737
  var valid_594738 = path.getOrDefault("subscriptionId")
  valid_594738 = validateParameter(valid_594738, JString, required = true,
                                 default = nil)
  if valid_594738 != nil:
    section.add "subscriptionId", valid_594738
  var valid_594739 = path.getOrDefault("deviceName")
  valid_594739 = validateParameter(valid_594739, JString, required = true,
                                 default = nil)
  if valid_594739 != nil:
    section.add "deviceName", valid_594739
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594740 = query.getOrDefault("api-version")
  valid_594740 = validateParameter(valid_594740, JString, required = true,
                                 default = nil)
  if valid_594740 != nil:
    section.add "api-version", valid_594740
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594741: Call_VolumeContainersGet_594732; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified volume container name.
  ## 
  let valid = call_594741.validator(path, query, header, formData, body)
  let scheme = call_594741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594741.url(scheme.get, call_594741.host, call_594741.base,
                         call_594741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594741, url, valid)

proc call*(call_594742: Call_VolumeContainersGet_594732; resourceGroupName: string;
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
  var path_594743 = newJObject()
  var query_594744 = newJObject()
  add(path_594743, "resourceGroupName", newJString(resourceGroupName))
  add(query_594744, "api-version", newJString(apiVersion))
  add(path_594743, "managerName", newJString(managerName))
  add(path_594743, "volumeContainerName", newJString(volumeContainerName))
  add(path_594743, "subscriptionId", newJString(subscriptionId))
  add(path_594743, "deviceName", newJString(deviceName))
  result = call_594742.call(path_594743, query_594744, nil, nil, nil)

var volumeContainersGet* = Call_VolumeContainersGet_594732(
    name: "volumeContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}",
    validator: validate_VolumeContainersGet_594733, base: "",
    url: url_VolumeContainersGet_594734, schemes: {Scheme.Https})
type
  Call_VolumeContainersDelete_594760 = ref object of OpenApiRestCall_593438
proc url_VolumeContainersDelete_594762(protocol: Scheme; host: string; base: string;
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

proc validate_VolumeContainersDelete_594761(path: JsonNode; query: JsonNode;
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
  var valid_594763 = path.getOrDefault("resourceGroupName")
  valid_594763 = validateParameter(valid_594763, JString, required = true,
                                 default = nil)
  if valid_594763 != nil:
    section.add "resourceGroupName", valid_594763
  var valid_594764 = path.getOrDefault("managerName")
  valid_594764 = validateParameter(valid_594764, JString, required = true,
                                 default = nil)
  if valid_594764 != nil:
    section.add "managerName", valid_594764
  var valid_594765 = path.getOrDefault("volumeContainerName")
  valid_594765 = validateParameter(valid_594765, JString, required = true,
                                 default = nil)
  if valid_594765 != nil:
    section.add "volumeContainerName", valid_594765
  var valid_594766 = path.getOrDefault("subscriptionId")
  valid_594766 = validateParameter(valid_594766, JString, required = true,
                                 default = nil)
  if valid_594766 != nil:
    section.add "subscriptionId", valid_594766
  var valid_594767 = path.getOrDefault("deviceName")
  valid_594767 = validateParameter(valid_594767, JString, required = true,
                                 default = nil)
  if valid_594767 != nil:
    section.add "deviceName", valid_594767
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594768 = query.getOrDefault("api-version")
  valid_594768 = validateParameter(valid_594768, JString, required = true,
                                 default = nil)
  if valid_594768 != nil:
    section.add "api-version", valid_594768
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594769: Call_VolumeContainersDelete_594760; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the volume container.
  ## 
  let valid = call_594769.validator(path, query, header, formData, body)
  let scheme = call_594769.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594769.url(scheme.get, call_594769.host, call_594769.base,
                         call_594769.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594769, url, valid)

proc call*(call_594770: Call_VolumeContainersDelete_594760;
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
  var path_594771 = newJObject()
  var query_594772 = newJObject()
  add(path_594771, "resourceGroupName", newJString(resourceGroupName))
  add(query_594772, "api-version", newJString(apiVersion))
  add(path_594771, "managerName", newJString(managerName))
  add(path_594771, "volumeContainerName", newJString(volumeContainerName))
  add(path_594771, "subscriptionId", newJString(subscriptionId))
  add(path_594771, "deviceName", newJString(deviceName))
  result = call_594770.call(path_594771, query_594772, nil, nil, nil)

var volumeContainersDelete* = Call_VolumeContainersDelete_594760(
    name: "volumeContainersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}",
    validator: validate_VolumeContainersDelete_594761, base: "",
    url: url_VolumeContainersDelete_594762, schemes: {Scheme.Https})
type
  Call_VolumeContainersListMetrics_594773 = ref object of OpenApiRestCall_593438
proc url_VolumeContainersListMetrics_594775(protocol: Scheme; host: string;
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

proc validate_VolumeContainersListMetrics_594774(path: JsonNode; query: JsonNode;
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
  var valid_594776 = path.getOrDefault("resourceGroupName")
  valid_594776 = validateParameter(valid_594776, JString, required = true,
                                 default = nil)
  if valid_594776 != nil:
    section.add "resourceGroupName", valid_594776
  var valid_594777 = path.getOrDefault("managerName")
  valid_594777 = validateParameter(valid_594777, JString, required = true,
                                 default = nil)
  if valid_594777 != nil:
    section.add "managerName", valid_594777
  var valid_594778 = path.getOrDefault("volumeContainerName")
  valid_594778 = validateParameter(valid_594778, JString, required = true,
                                 default = nil)
  if valid_594778 != nil:
    section.add "volumeContainerName", valid_594778
  var valid_594779 = path.getOrDefault("subscriptionId")
  valid_594779 = validateParameter(valid_594779, JString, required = true,
                                 default = nil)
  if valid_594779 != nil:
    section.add "subscriptionId", valid_594779
  var valid_594780 = path.getOrDefault("deviceName")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "deviceName", valid_594780
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString (required)
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594781 = query.getOrDefault("api-version")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "api-version", valid_594781
  var valid_594782 = query.getOrDefault("$filter")
  valid_594782 = validateParameter(valid_594782, JString, required = true,
                                 default = nil)
  if valid_594782 != nil:
    section.add "$filter", valid_594782
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594783: Call_VolumeContainersListMetrics_594773; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metrics for the specified volume container.
  ## 
  let valid = call_594783.validator(path, query, header, formData, body)
  let scheme = call_594783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594783.url(scheme.get, call_594783.host, call_594783.base,
                         call_594783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594783, url, valid)

proc call*(call_594784: Call_VolumeContainersListMetrics_594773;
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
  var path_594785 = newJObject()
  var query_594786 = newJObject()
  add(path_594785, "resourceGroupName", newJString(resourceGroupName))
  add(query_594786, "api-version", newJString(apiVersion))
  add(path_594785, "managerName", newJString(managerName))
  add(path_594785, "volumeContainerName", newJString(volumeContainerName))
  add(path_594785, "subscriptionId", newJString(subscriptionId))
  add(query_594786, "$filter", newJString(Filter))
  add(path_594785, "deviceName", newJString(deviceName))
  result = call_594784.call(path_594785, query_594786, nil, nil, nil)

var volumeContainersListMetrics* = Call_VolumeContainersListMetrics_594773(
    name: "volumeContainersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/metrics",
    validator: validate_VolumeContainersListMetrics_594774, base: "",
    url: url_VolumeContainersListMetrics_594775, schemes: {Scheme.Https})
type
  Call_VolumeContainersListMetricDefinition_594787 = ref object of OpenApiRestCall_593438
proc url_VolumeContainersListMetricDefinition_594789(protocol: Scheme;
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

proc validate_VolumeContainersListMetricDefinition_594788(path: JsonNode;
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
  var valid_594790 = path.getOrDefault("resourceGroupName")
  valid_594790 = validateParameter(valid_594790, JString, required = true,
                                 default = nil)
  if valid_594790 != nil:
    section.add "resourceGroupName", valid_594790
  var valid_594791 = path.getOrDefault("managerName")
  valid_594791 = validateParameter(valid_594791, JString, required = true,
                                 default = nil)
  if valid_594791 != nil:
    section.add "managerName", valid_594791
  var valid_594792 = path.getOrDefault("volumeContainerName")
  valid_594792 = validateParameter(valid_594792, JString, required = true,
                                 default = nil)
  if valid_594792 != nil:
    section.add "volumeContainerName", valid_594792
  var valid_594793 = path.getOrDefault("subscriptionId")
  valid_594793 = validateParameter(valid_594793, JString, required = true,
                                 default = nil)
  if valid_594793 != nil:
    section.add "subscriptionId", valid_594793
  var valid_594794 = path.getOrDefault("deviceName")
  valid_594794 = validateParameter(valid_594794, JString, required = true,
                                 default = nil)
  if valid_594794 != nil:
    section.add "deviceName", valid_594794
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594795 = query.getOrDefault("api-version")
  valid_594795 = validateParameter(valid_594795, JString, required = true,
                                 default = nil)
  if valid_594795 != nil:
    section.add "api-version", valid_594795
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594796: Call_VolumeContainersListMetricDefinition_594787;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the metric definitions for the specified volume container.
  ## 
  let valid = call_594796.validator(path, query, header, formData, body)
  let scheme = call_594796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594796.url(scheme.get, call_594796.host, call_594796.base,
                         call_594796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594796, url, valid)

proc call*(call_594797: Call_VolumeContainersListMetricDefinition_594787;
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
  var path_594798 = newJObject()
  var query_594799 = newJObject()
  add(path_594798, "resourceGroupName", newJString(resourceGroupName))
  add(query_594799, "api-version", newJString(apiVersion))
  add(path_594798, "managerName", newJString(managerName))
  add(path_594798, "volumeContainerName", newJString(volumeContainerName))
  add(path_594798, "subscriptionId", newJString(subscriptionId))
  add(path_594798, "deviceName", newJString(deviceName))
  result = call_594797.call(path_594798, query_594799, nil, nil, nil)

var volumeContainersListMetricDefinition* = Call_VolumeContainersListMetricDefinition_594787(
    name: "volumeContainersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/metricsDefinitions",
    validator: validate_VolumeContainersListMetricDefinition_594788, base: "",
    url: url_VolumeContainersListMetricDefinition_594789, schemes: {Scheme.Https})
type
  Call_VolumesListByVolumeContainer_594800 = ref object of OpenApiRestCall_593438
proc url_VolumesListByVolumeContainer_594802(protocol: Scheme; host: string;
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

proc validate_VolumesListByVolumeContainer_594801(path: JsonNode; query: JsonNode;
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
  var valid_594803 = path.getOrDefault("resourceGroupName")
  valid_594803 = validateParameter(valid_594803, JString, required = true,
                                 default = nil)
  if valid_594803 != nil:
    section.add "resourceGroupName", valid_594803
  var valid_594804 = path.getOrDefault("managerName")
  valid_594804 = validateParameter(valid_594804, JString, required = true,
                                 default = nil)
  if valid_594804 != nil:
    section.add "managerName", valid_594804
  var valid_594805 = path.getOrDefault("volumeContainerName")
  valid_594805 = validateParameter(valid_594805, JString, required = true,
                                 default = nil)
  if valid_594805 != nil:
    section.add "volumeContainerName", valid_594805
  var valid_594806 = path.getOrDefault("subscriptionId")
  valid_594806 = validateParameter(valid_594806, JString, required = true,
                                 default = nil)
  if valid_594806 != nil:
    section.add "subscriptionId", valid_594806
  var valid_594807 = path.getOrDefault("deviceName")
  valid_594807 = validateParameter(valid_594807, JString, required = true,
                                 default = nil)
  if valid_594807 != nil:
    section.add "deviceName", valid_594807
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594808 = query.getOrDefault("api-version")
  valid_594808 = validateParameter(valid_594808, JString, required = true,
                                 default = nil)
  if valid_594808 != nil:
    section.add "api-version", valid_594808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594809: Call_VolumesListByVolumeContainer_594800; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the volumes in a volume container.
  ## 
  let valid = call_594809.validator(path, query, header, formData, body)
  let scheme = call_594809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594809.url(scheme.get, call_594809.host, call_594809.base,
                         call_594809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594809, url, valid)

proc call*(call_594810: Call_VolumesListByVolumeContainer_594800;
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
  var path_594811 = newJObject()
  var query_594812 = newJObject()
  add(path_594811, "resourceGroupName", newJString(resourceGroupName))
  add(query_594812, "api-version", newJString(apiVersion))
  add(path_594811, "managerName", newJString(managerName))
  add(path_594811, "volumeContainerName", newJString(volumeContainerName))
  add(path_594811, "subscriptionId", newJString(subscriptionId))
  add(path_594811, "deviceName", newJString(deviceName))
  result = call_594810.call(path_594811, query_594812, nil, nil, nil)

var volumesListByVolumeContainer* = Call_VolumesListByVolumeContainer_594800(
    name: "volumesListByVolumeContainer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes",
    validator: validate_VolumesListByVolumeContainer_594801, base: "",
    url: url_VolumesListByVolumeContainer_594802, schemes: {Scheme.Https})
type
  Call_VolumesCreateOrUpdate_594827 = ref object of OpenApiRestCall_593438
proc url_VolumesCreateOrUpdate_594829(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesCreateOrUpdate_594828(path: JsonNode; query: JsonNode;
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
  var valid_594830 = path.getOrDefault("resourceGroupName")
  valid_594830 = validateParameter(valid_594830, JString, required = true,
                                 default = nil)
  if valid_594830 != nil:
    section.add "resourceGroupName", valid_594830
  var valid_594831 = path.getOrDefault("managerName")
  valid_594831 = validateParameter(valid_594831, JString, required = true,
                                 default = nil)
  if valid_594831 != nil:
    section.add "managerName", valid_594831
  var valid_594832 = path.getOrDefault("volumeContainerName")
  valid_594832 = validateParameter(valid_594832, JString, required = true,
                                 default = nil)
  if valid_594832 != nil:
    section.add "volumeContainerName", valid_594832
  var valid_594833 = path.getOrDefault("subscriptionId")
  valid_594833 = validateParameter(valid_594833, JString, required = true,
                                 default = nil)
  if valid_594833 != nil:
    section.add "subscriptionId", valid_594833
  var valid_594834 = path.getOrDefault("volumeName")
  valid_594834 = validateParameter(valid_594834, JString, required = true,
                                 default = nil)
  if valid_594834 != nil:
    section.add "volumeName", valid_594834
  var valid_594835 = path.getOrDefault("deviceName")
  valid_594835 = validateParameter(valid_594835, JString, required = true,
                                 default = nil)
  if valid_594835 != nil:
    section.add "deviceName", valid_594835
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594836 = query.getOrDefault("api-version")
  valid_594836 = validateParameter(valid_594836, JString, required = true,
                                 default = nil)
  if valid_594836 != nil:
    section.add "api-version", valid_594836
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

proc call*(call_594838: Call_VolumesCreateOrUpdate_594827; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the volume.
  ## 
  let valid = call_594838.validator(path, query, header, formData, body)
  let scheme = call_594838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594838.url(scheme.get, call_594838.host, call_594838.base,
                         call_594838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594838, url, valid)

proc call*(call_594839: Call_VolumesCreateOrUpdate_594827;
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
  var path_594840 = newJObject()
  var query_594841 = newJObject()
  var body_594842 = newJObject()
  add(path_594840, "resourceGroupName", newJString(resourceGroupName))
  add(query_594841, "api-version", newJString(apiVersion))
  add(path_594840, "managerName", newJString(managerName))
  add(path_594840, "volumeContainerName", newJString(volumeContainerName))
  add(path_594840, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594842 = parameters
  add(path_594840, "volumeName", newJString(volumeName))
  add(path_594840, "deviceName", newJString(deviceName))
  result = call_594839.call(path_594840, query_594841, nil, nil, body_594842)

var volumesCreateOrUpdate* = Call_VolumesCreateOrUpdate_594827(
    name: "volumesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}",
    validator: validate_VolumesCreateOrUpdate_594828, base: "",
    url: url_VolumesCreateOrUpdate_594829, schemes: {Scheme.Https})
type
  Call_VolumesGet_594813 = ref object of OpenApiRestCall_593438
proc url_VolumesGet_594815(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_VolumesGet_594814(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594816 = path.getOrDefault("resourceGroupName")
  valid_594816 = validateParameter(valid_594816, JString, required = true,
                                 default = nil)
  if valid_594816 != nil:
    section.add "resourceGroupName", valid_594816
  var valid_594817 = path.getOrDefault("managerName")
  valid_594817 = validateParameter(valid_594817, JString, required = true,
                                 default = nil)
  if valid_594817 != nil:
    section.add "managerName", valid_594817
  var valid_594818 = path.getOrDefault("volumeContainerName")
  valid_594818 = validateParameter(valid_594818, JString, required = true,
                                 default = nil)
  if valid_594818 != nil:
    section.add "volumeContainerName", valid_594818
  var valid_594819 = path.getOrDefault("subscriptionId")
  valid_594819 = validateParameter(valid_594819, JString, required = true,
                                 default = nil)
  if valid_594819 != nil:
    section.add "subscriptionId", valid_594819
  var valid_594820 = path.getOrDefault("volumeName")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "volumeName", valid_594820
  var valid_594821 = path.getOrDefault("deviceName")
  valid_594821 = validateParameter(valid_594821, JString, required = true,
                                 default = nil)
  if valid_594821 != nil:
    section.add "deviceName", valid_594821
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594822 = query.getOrDefault("api-version")
  valid_594822 = validateParameter(valid_594822, JString, required = true,
                                 default = nil)
  if valid_594822 != nil:
    section.add "api-version", valid_594822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594823: Call_VolumesGet_594813; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of the specified volume name.
  ## 
  let valid = call_594823.validator(path, query, header, formData, body)
  let scheme = call_594823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594823.url(scheme.get, call_594823.host, call_594823.base,
                         call_594823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594823, url, valid)

proc call*(call_594824: Call_VolumesGet_594813; resourceGroupName: string;
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
  var path_594825 = newJObject()
  var query_594826 = newJObject()
  add(path_594825, "resourceGroupName", newJString(resourceGroupName))
  add(query_594826, "api-version", newJString(apiVersion))
  add(path_594825, "managerName", newJString(managerName))
  add(path_594825, "volumeContainerName", newJString(volumeContainerName))
  add(path_594825, "subscriptionId", newJString(subscriptionId))
  add(path_594825, "volumeName", newJString(volumeName))
  add(path_594825, "deviceName", newJString(deviceName))
  result = call_594824.call(path_594825, query_594826, nil, nil, nil)

var volumesGet* = Call_VolumesGet_594813(name: "volumesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}",
                                      validator: validate_VolumesGet_594814,
                                      base: "", url: url_VolumesGet_594815,
                                      schemes: {Scheme.Https})
type
  Call_VolumesDelete_594843 = ref object of OpenApiRestCall_593438
proc url_VolumesDelete_594845(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesDelete_594844(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594846 = path.getOrDefault("resourceGroupName")
  valid_594846 = validateParameter(valid_594846, JString, required = true,
                                 default = nil)
  if valid_594846 != nil:
    section.add "resourceGroupName", valid_594846
  var valid_594847 = path.getOrDefault("managerName")
  valid_594847 = validateParameter(valid_594847, JString, required = true,
                                 default = nil)
  if valid_594847 != nil:
    section.add "managerName", valid_594847
  var valid_594848 = path.getOrDefault("volumeContainerName")
  valid_594848 = validateParameter(valid_594848, JString, required = true,
                                 default = nil)
  if valid_594848 != nil:
    section.add "volumeContainerName", valid_594848
  var valid_594849 = path.getOrDefault("subscriptionId")
  valid_594849 = validateParameter(valid_594849, JString, required = true,
                                 default = nil)
  if valid_594849 != nil:
    section.add "subscriptionId", valid_594849
  var valid_594850 = path.getOrDefault("volumeName")
  valid_594850 = validateParameter(valid_594850, JString, required = true,
                                 default = nil)
  if valid_594850 != nil:
    section.add "volumeName", valid_594850
  var valid_594851 = path.getOrDefault("deviceName")
  valid_594851 = validateParameter(valid_594851, JString, required = true,
                                 default = nil)
  if valid_594851 != nil:
    section.add "deviceName", valid_594851
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594852 = query.getOrDefault("api-version")
  valid_594852 = validateParameter(valid_594852, JString, required = true,
                                 default = nil)
  if valid_594852 != nil:
    section.add "api-version", valid_594852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594853: Call_VolumesDelete_594843; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the volume.
  ## 
  let valid = call_594853.validator(path, query, header, formData, body)
  let scheme = call_594853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594853.url(scheme.get, call_594853.host, call_594853.base,
                         call_594853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594853, url, valid)

proc call*(call_594854: Call_VolumesDelete_594843; resourceGroupName: string;
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
  var path_594855 = newJObject()
  var query_594856 = newJObject()
  add(path_594855, "resourceGroupName", newJString(resourceGroupName))
  add(query_594856, "api-version", newJString(apiVersion))
  add(path_594855, "managerName", newJString(managerName))
  add(path_594855, "volumeContainerName", newJString(volumeContainerName))
  add(path_594855, "subscriptionId", newJString(subscriptionId))
  add(path_594855, "volumeName", newJString(volumeName))
  add(path_594855, "deviceName", newJString(deviceName))
  result = call_594854.call(path_594855, query_594856, nil, nil, nil)

var volumesDelete* = Call_VolumesDelete_594843(name: "volumesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}",
    validator: validate_VolumesDelete_594844, base: "", url: url_VolumesDelete_594845,
    schemes: {Scheme.Https})
type
  Call_VolumesListMetrics_594857 = ref object of OpenApiRestCall_593438
proc url_VolumesListMetrics_594859(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesListMetrics_594858(path: JsonNode; query: JsonNode;
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
  var valid_594860 = path.getOrDefault("resourceGroupName")
  valid_594860 = validateParameter(valid_594860, JString, required = true,
                                 default = nil)
  if valid_594860 != nil:
    section.add "resourceGroupName", valid_594860
  var valid_594861 = path.getOrDefault("managerName")
  valid_594861 = validateParameter(valid_594861, JString, required = true,
                                 default = nil)
  if valid_594861 != nil:
    section.add "managerName", valid_594861
  var valid_594862 = path.getOrDefault("volumeContainerName")
  valid_594862 = validateParameter(valid_594862, JString, required = true,
                                 default = nil)
  if valid_594862 != nil:
    section.add "volumeContainerName", valid_594862
  var valid_594863 = path.getOrDefault("subscriptionId")
  valid_594863 = validateParameter(valid_594863, JString, required = true,
                                 default = nil)
  if valid_594863 != nil:
    section.add "subscriptionId", valid_594863
  var valid_594864 = path.getOrDefault("volumeName")
  valid_594864 = validateParameter(valid_594864, JString, required = true,
                                 default = nil)
  if valid_594864 != nil:
    section.add "volumeName", valid_594864
  var valid_594865 = path.getOrDefault("deviceName")
  valid_594865 = validateParameter(valid_594865, JString, required = true,
                                 default = nil)
  if valid_594865 != nil:
    section.add "deviceName", valid_594865
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString (required)
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594866 = query.getOrDefault("api-version")
  valid_594866 = validateParameter(valid_594866, JString, required = true,
                                 default = nil)
  if valid_594866 != nil:
    section.add "api-version", valid_594866
  var valid_594867 = query.getOrDefault("$filter")
  valid_594867 = validateParameter(valid_594867, JString, required = true,
                                 default = nil)
  if valid_594867 != nil:
    section.add "$filter", valid_594867
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594868: Call_VolumesListMetrics_594857; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metrics for the specified volume.
  ## 
  let valid = call_594868.validator(path, query, header, formData, body)
  let scheme = call_594868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594868.url(scheme.get, call_594868.host, call_594868.base,
                         call_594868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594868, url, valid)

proc call*(call_594869: Call_VolumesListMetrics_594857; resourceGroupName: string;
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
  var path_594870 = newJObject()
  var query_594871 = newJObject()
  add(path_594870, "resourceGroupName", newJString(resourceGroupName))
  add(query_594871, "api-version", newJString(apiVersion))
  add(path_594870, "managerName", newJString(managerName))
  add(path_594870, "volumeContainerName", newJString(volumeContainerName))
  add(path_594870, "subscriptionId", newJString(subscriptionId))
  add(path_594870, "volumeName", newJString(volumeName))
  add(query_594871, "$filter", newJString(Filter))
  add(path_594870, "deviceName", newJString(deviceName))
  result = call_594869.call(path_594870, query_594871, nil, nil, nil)

var volumesListMetrics* = Call_VolumesListMetrics_594857(
    name: "volumesListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}/metrics",
    validator: validate_VolumesListMetrics_594858, base: "",
    url: url_VolumesListMetrics_594859, schemes: {Scheme.Https})
type
  Call_VolumesListMetricDefinition_594872 = ref object of OpenApiRestCall_593438
proc url_VolumesListMetricDefinition_594874(protocol: Scheme; host: string;
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

proc validate_VolumesListMetricDefinition_594873(path: JsonNode; query: JsonNode;
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
  var valid_594877 = path.getOrDefault("volumeContainerName")
  valid_594877 = validateParameter(valid_594877, JString, required = true,
                                 default = nil)
  if valid_594877 != nil:
    section.add "volumeContainerName", valid_594877
  var valid_594878 = path.getOrDefault("subscriptionId")
  valid_594878 = validateParameter(valid_594878, JString, required = true,
                                 default = nil)
  if valid_594878 != nil:
    section.add "subscriptionId", valid_594878
  var valid_594879 = path.getOrDefault("volumeName")
  valid_594879 = validateParameter(valid_594879, JString, required = true,
                                 default = nil)
  if valid_594879 != nil:
    section.add "volumeName", valid_594879
  var valid_594880 = path.getOrDefault("deviceName")
  valid_594880 = validateParameter(valid_594880, JString, required = true,
                                 default = nil)
  if valid_594880 != nil:
    section.add "deviceName", valid_594880
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594881 = query.getOrDefault("api-version")
  valid_594881 = validateParameter(valid_594881, JString, required = true,
                                 default = nil)
  if valid_594881 != nil:
    section.add "api-version", valid_594881
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594882: Call_VolumesListMetricDefinition_594872; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metric definitions for the specified volume.
  ## 
  let valid = call_594882.validator(path, query, header, formData, body)
  let scheme = call_594882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594882.url(scheme.get, call_594882.host, call_594882.base,
                         call_594882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594882, url, valid)

proc call*(call_594883: Call_VolumesListMetricDefinition_594872;
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
  var path_594884 = newJObject()
  var query_594885 = newJObject()
  add(path_594884, "resourceGroupName", newJString(resourceGroupName))
  add(query_594885, "api-version", newJString(apiVersion))
  add(path_594884, "managerName", newJString(managerName))
  add(path_594884, "volumeContainerName", newJString(volumeContainerName))
  add(path_594884, "subscriptionId", newJString(subscriptionId))
  add(path_594884, "volumeName", newJString(volumeName))
  add(path_594884, "deviceName", newJString(deviceName))
  result = call_594883.call(path_594884, query_594885, nil, nil, nil)

var volumesListMetricDefinition* = Call_VolumesListMetricDefinition_594872(
    name: "volumesListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumeContainers/{volumeContainerName}/volumes/{volumeName}/metricsDefinitions",
    validator: validate_VolumesListMetricDefinition_594873, base: "",
    url: url_VolumesListMetricDefinition_594874, schemes: {Scheme.Https})
type
  Call_VolumesListByDevice_594886 = ref object of OpenApiRestCall_593438
proc url_VolumesListByDevice_594888(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesListByDevice_594887(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_594894: Call_VolumesListByDevice_594886; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all the volumes in a device.
  ## 
  let valid = call_594894.validator(path, query, header, formData, body)
  let scheme = call_594894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594894.url(scheme.get, call_594894.host, call_594894.base,
                         call_594894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594894, url, valid)

proc call*(call_594895: Call_VolumesListByDevice_594886; resourceGroupName: string;
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
  var path_594896 = newJObject()
  var query_594897 = newJObject()
  add(path_594896, "resourceGroupName", newJString(resourceGroupName))
  add(query_594897, "api-version", newJString(apiVersion))
  add(path_594896, "managerName", newJString(managerName))
  add(path_594896, "subscriptionId", newJString(subscriptionId))
  add(path_594896, "deviceName", newJString(deviceName))
  result = call_594895.call(path_594896, query_594897, nil, nil, nil)

var volumesListByDevice* = Call_VolumesListByDevice_594886(
    name: "volumesListByDevice", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{deviceName}/volumes",
    validator: validate_VolumesListByDevice_594887, base: "",
    url: url_VolumesListByDevice_594888, schemes: {Scheme.Https})
type
  Call_DevicesFailover_594898 = ref object of OpenApiRestCall_593438
proc url_DevicesFailover_594900(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesFailover_594899(path: JsonNode; query: JsonNode;
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
  var valid_594901 = path.getOrDefault("resourceGroupName")
  valid_594901 = validateParameter(valid_594901, JString, required = true,
                                 default = nil)
  if valid_594901 != nil:
    section.add "resourceGroupName", valid_594901
  var valid_594902 = path.getOrDefault("sourceDeviceName")
  valid_594902 = validateParameter(valid_594902, JString, required = true,
                                 default = nil)
  if valid_594902 != nil:
    section.add "sourceDeviceName", valid_594902
  var valid_594903 = path.getOrDefault("managerName")
  valid_594903 = validateParameter(valid_594903, JString, required = true,
                                 default = nil)
  if valid_594903 != nil:
    section.add "managerName", valid_594903
  var valid_594904 = path.getOrDefault("subscriptionId")
  valid_594904 = validateParameter(valid_594904, JString, required = true,
                                 default = nil)
  if valid_594904 != nil:
    section.add "subscriptionId", valid_594904
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594905 = query.getOrDefault("api-version")
  valid_594905 = validateParameter(valid_594905, JString, required = true,
                                 default = nil)
  if valid_594905 != nil:
    section.add "api-version", valid_594905
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

proc call*(call_594907: Call_DevicesFailover_594898; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Failovers a set of volume containers from a specified source device to a target device.
  ## 
  let valid = call_594907.validator(path, query, header, formData, body)
  let scheme = call_594907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594907.url(scheme.get, call_594907.host, call_594907.base,
                         call_594907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594907, url, valid)

proc call*(call_594908: Call_DevicesFailover_594898; resourceGroupName: string;
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
  var path_594909 = newJObject()
  var query_594910 = newJObject()
  var body_594911 = newJObject()
  add(path_594909, "resourceGroupName", newJString(resourceGroupName))
  add(path_594909, "sourceDeviceName", newJString(sourceDeviceName))
  add(query_594910, "api-version", newJString(apiVersion))
  add(path_594909, "managerName", newJString(managerName))
  add(path_594909, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594911 = parameters
  result = call_594908.call(path_594909, query_594910, nil, nil, body_594911)

var devicesFailover* = Call_DevicesFailover_594898(name: "devicesFailover",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{sourceDeviceName}/failover",
    validator: validate_DevicesFailover_594899, base: "", url: url_DevicesFailover_594900,
    schemes: {Scheme.Https})
type
  Call_DevicesListFailoverTargets_594912 = ref object of OpenApiRestCall_593438
proc url_DevicesListFailoverTargets_594914(protocol: Scheme; host: string;
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

proc validate_DevicesListFailoverTargets_594913(path: JsonNode; query: JsonNode;
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
  var valid_594915 = path.getOrDefault("resourceGroupName")
  valid_594915 = validateParameter(valid_594915, JString, required = true,
                                 default = nil)
  if valid_594915 != nil:
    section.add "resourceGroupName", valid_594915
  var valid_594916 = path.getOrDefault("sourceDeviceName")
  valid_594916 = validateParameter(valid_594916, JString, required = true,
                                 default = nil)
  if valid_594916 != nil:
    section.add "sourceDeviceName", valid_594916
  var valid_594917 = path.getOrDefault("managerName")
  valid_594917 = validateParameter(valid_594917, JString, required = true,
                                 default = nil)
  if valid_594917 != nil:
    section.add "managerName", valid_594917
  var valid_594918 = path.getOrDefault("subscriptionId")
  valid_594918 = validateParameter(valid_594918, JString, required = true,
                                 default = nil)
  if valid_594918 != nil:
    section.add "subscriptionId", valid_594918
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : ListFailoverTargetsRequest containing the list of volume containers to be failed over.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594921: Call_DevicesListFailoverTargets_594912; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Given a list of volume containers to be failed over from a source device, this method returns the eligibility result, as a failover target, for all devices under that resource.
  ## 
  let valid = call_594921.validator(path, query, header, formData, body)
  let scheme = call_594921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594921.url(scheme.get, call_594921.host, call_594921.base,
                         call_594921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594921, url, valid)

proc call*(call_594922: Call_DevicesListFailoverTargets_594912;
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
  var path_594923 = newJObject()
  var query_594924 = newJObject()
  var body_594925 = newJObject()
  add(path_594923, "resourceGroupName", newJString(resourceGroupName))
  add(path_594923, "sourceDeviceName", newJString(sourceDeviceName))
  add(query_594924, "api-version", newJString(apiVersion))
  add(path_594923, "managerName", newJString(managerName))
  add(path_594923, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594925 = parameters
  result = call_594922.call(path_594923, query_594924, nil, nil, body_594925)

var devicesListFailoverTargets* = Call_DevicesListFailoverTargets_594912(
    name: "devicesListFailoverTargets", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/devices/{sourceDeviceName}/listFailoverTargets",
    validator: validate_DevicesListFailoverTargets_594913, base: "",
    url: url_DevicesListFailoverTargets_594914, schemes: {Scheme.Https})
type
  Call_ManagersGetEncryptionSettings_594926 = ref object of OpenApiRestCall_593438
proc url_ManagersGetEncryptionSettings_594928(protocol: Scheme; host: string;
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

proc validate_ManagersGetEncryptionSettings_594927(path: JsonNode; query: JsonNode;
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
  var valid_594929 = path.getOrDefault("resourceGroupName")
  valid_594929 = validateParameter(valid_594929, JString, required = true,
                                 default = nil)
  if valid_594929 != nil:
    section.add "resourceGroupName", valid_594929
  var valid_594930 = path.getOrDefault("managerName")
  valid_594930 = validateParameter(valid_594930, JString, required = true,
                                 default = nil)
  if valid_594930 != nil:
    section.add "managerName", valid_594930
  var valid_594931 = path.getOrDefault("subscriptionId")
  valid_594931 = validateParameter(valid_594931, JString, required = true,
                                 default = nil)
  if valid_594931 != nil:
    section.add "subscriptionId", valid_594931
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594932 = query.getOrDefault("api-version")
  valid_594932 = validateParameter(valid_594932, JString, required = true,
                                 default = nil)
  if valid_594932 != nil:
    section.add "api-version", valid_594932
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594933: Call_ManagersGetEncryptionSettings_594926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the encryption settings of the manager.
  ## 
  let valid = call_594933.validator(path, query, header, formData, body)
  let scheme = call_594933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594933.url(scheme.get, call_594933.host, call_594933.base,
                         call_594933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594933, url, valid)

proc call*(call_594934: Call_ManagersGetEncryptionSettings_594926;
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
  var path_594935 = newJObject()
  var query_594936 = newJObject()
  add(path_594935, "resourceGroupName", newJString(resourceGroupName))
  add(query_594936, "api-version", newJString(apiVersion))
  add(path_594935, "managerName", newJString(managerName))
  add(path_594935, "subscriptionId", newJString(subscriptionId))
  result = call_594934.call(path_594935, query_594936, nil, nil, nil)

var managersGetEncryptionSettings* = Call_ManagersGetEncryptionSettings_594926(
    name: "managersGetEncryptionSettings", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/encryptionSettings/default",
    validator: validate_ManagersGetEncryptionSettings_594927, base: "",
    url: url_ManagersGetEncryptionSettings_594928, schemes: {Scheme.Https})
type
  Call_ManagersCreateExtendedInfo_594948 = ref object of OpenApiRestCall_593438
proc url_ManagersCreateExtendedInfo_594950(protocol: Scheme; host: string;
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

proc validate_ManagersCreateExtendedInfo_594949(path: JsonNode; query: JsonNode;
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
  var valid_594951 = path.getOrDefault("resourceGroupName")
  valid_594951 = validateParameter(valid_594951, JString, required = true,
                                 default = nil)
  if valid_594951 != nil:
    section.add "resourceGroupName", valid_594951
  var valid_594952 = path.getOrDefault("managerName")
  valid_594952 = validateParameter(valid_594952, JString, required = true,
                                 default = nil)
  if valid_594952 != nil:
    section.add "managerName", valid_594952
  var valid_594953 = path.getOrDefault("subscriptionId")
  valid_594953 = validateParameter(valid_594953, JString, required = true,
                                 default = nil)
  if valid_594953 != nil:
    section.add "subscriptionId", valid_594953
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594954 = query.getOrDefault("api-version")
  valid_594954 = validateParameter(valid_594954, JString, required = true,
                                 default = nil)
  if valid_594954 != nil:
    section.add "api-version", valid_594954
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

proc call*(call_594956: Call_ManagersCreateExtendedInfo_594948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the extended info of the manager.
  ## 
  let valid = call_594956.validator(path, query, header, formData, body)
  let scheme = call_594956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594956.url(scheme.get, call_594956.host, call_594956.base,
                         call_594956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594956, url, valid)

proc call*(call_594957: Call_ManagersCreateExtendedInfo_594948;
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
  var path_594958 = newJObject()
  var query_594959 = newJObject()
  var body_594960 = newJObject()
  add(path_594958, "resourceGroupName", newJString(resourceGroupName))
  add(query_594959, "api-version", newJString(apiVersion))
  add(path_594958, "managerName", newJString(managerName))
  add(path_594958, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594960 = parameters
  result = call_594957.call(path_594958, query_594959, nil, nil, body_594960)

var managersCreateExtendedInfo* = Call_ManagersCreateExtendedInfo_594948(
    name: "managersCreateExtendedInfo", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersCreateExtendedInfo_594949, base: "",
    url: url_ManagersCreateExtendedInfo_594950, schemes: {Scheme.Https})
type
  Call_ManagersGetExtendedInfo_594937 = ref object of OpenApiRestCall_593438
proc url_ManagersGetExtendedInfo_594939(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersGetExtendedInfo_594938(path: JsonNode; query: JsonNode;
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
  var valid_594940 = path.getOrDefault("resourceGroupName")
  valid_594940 = validateParameter(valid_594940, JString, required = true,
                                 default = nil)
  if valid_594940 != nil:
    section.add "resourceGroupName", valid_594940
  var valid_594941 = path.getOrDefault("managerName")
  valid_594941 = validateParameter(valid_594941, JString, required = true,
                                 default = nil)
  if valid_594941 != nil:
    section.add "managerName", valid_594941
  var valid_594942 = path.getOrDefault("subscriptionId")
  valid_594942 = validateParameter(valid_594942, JString, required = true,
                                 default = nil)
  if valid_594942 != nil:
    section.add "subscriptionId", valid_594942
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594943 = query.getOrDefault("api-version")
  valid_594943 = validateParameter(valid_594943, JString, required = true,
                                 default = nil)
  if valid_594943 != nil:
    section.add "api-version", valid_594943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594944: Call_ManagersGetExtendedInfo_594937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the extended information of the specified manager name.
  ## 
  let valid = call_594944.validator(path, query, header, formData, body)
  let scheme = call_594944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594944.url(scheme.get, call_594944.host, call_594944.base,
                         call_594944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594944, url, valid)

proc call*(call_594945: Call_ManagersGetExtendedInfo_594937;
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
  var path_594946 = newJObject()
  var query_594947 = newJObject()
  add(path_594946, "resourceGroupName", newJString(resourceGroupName))
  add(query_594947, "api-version", newJString(apiVersion))
  add(path_594946, "managerName", newJString(managerName))
  add(path_594946, "subscriptionId", newJString(subscriptionId))
  result = call_594945.call(path_594946, query_594947, nil, nil, nil)

var managersGetExtendedInfo* = Call_ManagersGetExtendedInfo_594937(
    name: "managersGetExtendedInfo", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersGetExtendedInfo_594938, base: "",
    url: url_ManagersGetExtendedInfo_594939, schemes: {Scheme.Https})
type
  Call_ManagersUpdateExtendedInfo_594972 = ref object of OpenApiRestCall_593438
proc url_ManagersUpdateExtendedInfo_594974(protocol: Scheme; host: string;
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

proc validate_ManagersUpdateExtendedInfo_594973(path: JsonNode; query: JsonNode;
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
  var valid_594975 = path.getOrDefault("resourceGroupName")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "resourceGroupName", valid_594975
  var valid_594976 = path.getOrDefault("managerName")
  valid_594976 = validateParameter(valid_594976, JString, required = true,
                                 default = nil)
  if valid_594976 != nil:
    section.add "managerName", valid_594976
  var valid_594977 = path.getOrDefault("subscriptionId")
  valid_594977 = validateParameter(valid_594977, JString, required = true,
                                 default = nil)
  if valid_594977 != nil:
    section.add "subscriptionId", valid_594977
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594978 = query.getOrDefault("api-version")
  valid_594978 = validateParameter(valid_594978, JString, required = true,
                                 default = nil)
  if valid_594978 != nil:
    section.add "api-version", valid_594978
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : Pass the ETag of ExtendedInfo fetched from GET call
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594979 = header.getOrDefault("If-Match")
  valid_594979 = validateParameter(valid_594979, JString, required = true,
                                 default = nil)
  if valid_594979 != nil:
    section.add "If-Match", valid_594979
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

proc call*(call_594981: Call_ManagersUpdateExtendedInfo_594972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the extended info of the manager.
  ## 
  let valid = call_594981.validator(path, query, header, formData, body)
  let scheme = call_594981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594981.url(scheme.get, call_594981.host, call_594981.base,
                         call_594981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594981, url, valid)

proc call*(call_594982: Call_ManagersUpdateExtendedInfo_594972;
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
  var path_594983 = newJObject()
  var query_594984 = newJObject()
  var body_594985 = newJObject()
  add(path_594983, "resourceGroupName", newJString(resourceGroupName))
  add(query_594984, "api-version", newJString(apiVersion))
  add(path_594983, "managerName", newJString(managerName))
  add(path_594983, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594985 = parameters
  result = call_594982.call(path_594983, query_594984, nil, nil, body_594985)

var managersUpdateExtendedInfo* = Call_ManagersUpdateExtendedInfo_594972(
    name: "managersUpdateExtendedInfo", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersUpdateExtendedInfo_594973, base: "",
    url: url_ManagersUpdateExtendedInfo_594974, schemes: {Scheme.Https})
type
  Call_ManagersDeleteExtendedInfo_594961 = ref object of OpenApiRestCall_593438
proc url_ManagersDeleteExtendedInfo_594963(protocol: Scheme; host: string;
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

proc validate_ManagersDeleteExtendedInfo_594962(path: JsonNode; query: JsonNode;
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
  var valid_594964 = path.getOrDefault("resourceGroupName")
  valid_594964 = validateParameter(valid_594964, JString, required = true,
                                 default = nil)
  if valid_594964 != nil:
    section.add "resourceGroupName", valid_594964
  var valid_594965 = path.getOrDefault("managerName")
  valid_594965 = validateParameter(valid_594965, JString, required = true,
                                 default = nil)
  if valid_594965 != nil:
    section.add "managerName", valid_594965
  var valid_594966 = path.getOrDefault("subscriptionId")
  valid_594966 = validateParameter(valid_594966, JString, required = true,
                                 default = nil)
  if valid_594966 != nil:
    section.add "subscriptionId", valid_594966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594967 = query.getOrDefault("api-version")
  valid_594967 = validateParameter(valid_594967, JString, required = true,
                                 default = nil)
  if valid_594967 != nil:
    section.add "api-version", valid_594967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594968: Call_ManagersDeleteExtendedInfo_594961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the extended info of the manager.
  ## 
  let valid = call_594968.validator(path, query, header, formData, body)
  let scheme = call_594968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594968.url(scheme.get, call_594968.host, call_594968.base,
                         call_594968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594968, url, valid)

proc call*(call_594969: Call_ManagersDeleteExtendedInfo_594961;
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
  var path_594970 = newJObject()
  var query_594971 = newJObject()
  add(path_594970, "resourceGroupName", newJString(resourceGroupName))
  add(query_594971, "api-version", newJString(apiVersion))
  add(path_594970, "managerName", newJString(managerName))
  add(path_594970, "subscriptionId", newJString(subscriptionId))
  result = call_594969.call(path_594970, query_594971, nil, nil, nil)

var managersDeleteExtendedInfo* = Call_ManagersDeleteExtendedInfo_594961(
    name: "managersDeleteExtendedInfo", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/extendedInformation/vaultExtendedInfo",
    validator: validate_ManagersDeleteExtendedInfo_594962, base: "",
    url: url_ManagersDeleteExtendedInfo_594963, schemes: {Scheme.Https})
type
  Call_ManagersListFeatureSupportStatus_594986 = ref object of OpenApiRestCall_593438
proc url_ManagersListFeatureSupportStatus_594988(protocol: Scheme; host: string;
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

proc validate_ManagersListFeatureSupportStatus_594987(path: JsonNode;
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
  var valid_594989 = path.getOrDefault("resourceGroupName")
  valid_594989 = validateParameter(valid_594989, JString, required = true,
                                 default = nil)
  if valid_594989 != nil:
    section.add "resourceGroupName", valid_594989
  var valid_594990 = path.getOrDefault("managerName")
  valid_594990 = validateParameter(valid_594990, JString, required = true,
                                 default = nil)
  if valid_594990 != nil:
    section.add "managerName", valid_594990
  var valid_594991 = path.getOrDefault("subscriptionId")
  valid_594991 = validateParameter(valid_594991, JString, required = true,
                                 default = nil)
  if valid_594991 != nil:
    section.add "subscriptionId", valid_594991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594992 = query.getOrDefault("api-version")
  valid_594992 = validateParameter(valid_594992, JString, required = true,
                                 default = nil)
  if valid_594992 != nil:
    section.add "api-version", valid_594992
  var valid_594993 = query.getOrDefault("$filter")
  valid_594993 = validateParameter(valid_594993, JString, required = false,
                                 default = nil)
  if valid_594993 != nil:
    section.add "$filter", valid_594993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594994: Call_ManagersListFeatureSupportStatus_594986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the features and their support status
  ## 
  let valid = call_594994.validator(path, query, header, formData, body)
  let scheme = call_594994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594994.url(scheme.get, call_594994.host, call_594994.base,
                         call_594994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594994, url, valid)

proc call*(call_594995: Call_ManagersListFeatureSupportStatus_594986;
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
  var path_594996 = newJObject()
  var query_594997 = newJObject()
  add(path_594996, "resourceGroupName", newJString(resourceGroupName))
  add(query_594997, "api-version", newJString(apiVersion))
  add(path_594996, "managerName", newJString(managerName))
  add(path_594996, "subscriptionId", newJString(subscriptionId))
  add(query_594997, "$filter", newJString(Filter))
  result = call_594995.call(path_594996, query_594997, nil, nil, nil)

var managersListFeatureSupportStatus* = Call_ManagersListFeatureSupportStatus_594986(
    name: "managersListFeatureSupportStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/features",
    validator: validate_ManagersListFeatureSupportStatus_594987, base: "",
    url: url_ManagersListFeatureSupportStatus_594988, schemes: {Scheme.Https})
type
  Call_JobsListByManager_594998 = ref object of OpenApiRestCall_593438
proc url_JobsListByManager_595000(protocol: Scheme; host: string; base: string;
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

proc validate_JobsListByManager_594999(path: JsonNode; query: JsonNode;
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
  var valid_595001 = path.getOrDefault("resourceGroupName")
  valid_595001 = validateParameter(valid_595001, JString, required = true,
                                 default = nil)
  if valid_595001 != nil:
    section.add "resourceGroupName", valid_595001
  var valid_595002 = path.getOrDefault("managerName")
  valid_595002 = validateParameter(valid_595002, JString, required = true,
                                 default = nil)
  if valid_595002 != nil:
    section.add "managerName", valid_595002
  var valid_595003 = path.getOrDefault("subscriptionId")
  valid_595003 = validateParameter(valid_595003, JString, required = true,
                                 default = nil)
  if valid_595003 != nil:
    section.add "subscriptionId", valid_595003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595004 = query.getOrDefault("api-version")
  valid_595004 = validateParameter(valid_595004, JString, required = true,
                                 default = nil)
  if valid_595004 != nil:
    section.add "api-version", valid_595004
  var valid_595005 = query.getOrDefault("$filter")
  valid_595005 = validateParameter(valid_595005, JString, required = false,
                                 default = nil)
  if valid_595005 != nil:
    section.add "$filter", valid_595005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595006: Call_JobsListByManager_594998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the jobs for the specified manager. With optional OData query parameters, a filtered set of jobs is returned.
  ## 
  let valid = call_595006.validator(path, query, header, formData, body)
  let scheme = call_595006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595006.url(scheme.get, call_595006.host, call_595006.base,
                         call_595006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595006, url, valid)

proc call*(call_595007: Call_JobsListByManager_594998; resourceGroupName: string;
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
  var path_595008 = newJObject()
  var query_595009 = newJObject()
  add(path_595008, "resourceGroupName", newJString(resourceGroupName))
  add(query_595009, "api-version", newJString(apiVersion))
  add(path_595008, "managerName", newJString(managerName))
  add(path_595008, "subscriptionId", newJString(subscriptionId))
  add(query_595009, "$filter", newJString(Filter))
  result = call_595007.call(path_595008, query_595009, nil, nil, nil)

var jobsListByManager* = Call_JobsListByManager_594998(name: "jobsListByManager",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/jobs",
    validator: validate_JobsListByManager_594999, base: "",
    url: url_JobsListByManager_595000, schemes: {Scheme.Https})
type
  Call_ManagersGetActivationKey_595010 = ref object of OpenApiRestCall_593438
proc url_ManagersGetActivationKey_595012(protocol: Scheme; host: string;
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

proc validate_ManagersGetActivationKey_595011(path: JsonNode; query: JsonNode;
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
  var valid_595013 = path.getOrDefault("resourceGroupName")
  valid_595013 = validateParameter(valid_595013, JString, required = true,
                                 default = nil)
  if valid_595013 != nil:
    section.add "resourceGroupName", valid_595013
  var valid_595014 = path.getOrDefault("managerName")
  valid_595014 = validateParameter(valid_595014, JString, required = true,
                                 default = nil)
  if valid_595014 != nil:
    section.add "managerName", valid_595014
  var valid_595015 = path.getOrDefault("subscriptionId")
  valid_595015 = validateParameter(valid_595015, JString, required = true,
                                 default = nil)
  if valid_595015 != nil:
    section.add "subscriptionId", valid_595015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595016 = query.getOrDefault("api-version")
  valid_595016 = validateParameter(valid_595016, JString, required = true,
                                 default = nil)
  if valid_595016 != nil:
    section.add "api-version", valid_595016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595017: Call_ManagersGetActivationKey_595010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the activation key of the manager.
  ## 
  let valid = call_595017.validator(path, query, header, formData, body)
  let scheme = call_595017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595017.url(scheme.get, call_595017.host, call_595017.base,
                         call_595017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595017, url, valid)

proc call*(call_595018: Call_ManagersGetActivationKey_595010;
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
  var path_595019 = newJObject()
  var query_595020 = newJObject()
  add(path_595019, "resourceGroupName", newJString(resourceGroupName))
  add(query_595020, "api-version", newJString(apiVersion))
  add(path_595019, "managerName", newJString(managerName))
  add(path_595019, "subscriptionId", newJString(subscriptionId))
  result = call_595018.call(path_595019, query_595020, nil, nil, nil)

var managersGetActivationKey* = Call_ManagersGetActivationKey_595010(
    name: "managersGetActivationKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/listActivationKey",
    validator: validate_ManagersGetActivationKey_595011, base: "",
    url: url_ManagersGetActivationKey_595012, schemes: {Scheme.Https})
type
  Call_ManagersGetPublicEncryptionKey_595021 = ref object of OpenApiRestCall_593438
proc url_ManagersGetPublicEncryptionKey_595023(protocol: Scheme; host: string;
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

proc validate_ManagersGetPublicEncryptionKey_595022(path: JsonNode;
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
  var valid_595024 = path.getOrDefault("resourceGroupName")
  valid_595024 = validateParameter(valid_595024, JString, required = true,
                                 default = nil)
  if valid_595024 != nil:
    section.add "resourceGroupName", valid_595024
  var valid_595025 = path.getOrDefault("managerName")
  valid_595025 = validateParameter(valid_595025, JString, required = true,
                                 default = nil)
  if valid_595025 != nil:
    section.add "managerName", valid_595025
  var valid_595026 = path.getOrDefault("subscriptionId")
  valid_595026 = validateParameter(valid_595026, JString, required = true,
                                 default = nil)
  if valid_595026 != nil:
    section.add "subscriptionId", valid_595026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595027 = query.getOrDefault("api-version")
  valid_595027 = validateParameter(valid_595027, JString, required = true,
                                 default = nil)
  if valid_595027 != nil:
    section.add "api-version", valid_595027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595028: Call_ManagersGetPublicEncryptionKey_595021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the symmetric encrypted public encryption key of the manager.
  ## 
  let valid = call_595028.validator(path, query, header, formData, body)
  let scheme = call_595028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595028.url(scheme.get, call_595028.host, call_595028.base,
                         call_595028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595028, url, valid)

proc call*(call_595029: Call_ManagersGetPublicEncryptionKey_595021;
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
  var path_595030 = newJObject()
  var query_595031 = newJObject()
  add(path_595030, "resourceGroupName", newJString(resourceGroupName))
  add(query_595031, "api-version", newJString(apiVersion))
  add(path_595030, "managerName", newJString(managerName))
  add(path_595030, "subscriptionId", newJString(subscriptionId))
  result = call_595029.call(path_595030, query_595031, nil, nil, nil)

var managersGetPublicEncryptionKey* = Call_ManagersGetPublicEncryptionKey_595021(
    name: "managersGetPublicEncryptionKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/listPublicEncryptionKey",
    validator: validate_ManagersGetPublicEncryptionKey_595022, base: "",
    url: url_ManagersGetPublicEncryptionKey_595023, schemes: {Scheme.Https})
type
  Call_ManagersListMetrics_595032 = ref object of OpenApiRestCall_593438
proc url_ManagersListMetrics_595034(protocol: Scheme; host: string; base: string;
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

proc validate_ManagersListMetrics_595033(path: JsonNode; query: JsonNode;
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
  var valid_595035 = path.getOrDefault("resourceGroupName")
  valid_595035 = validateParameter(valid_595035, JString, required = true,
                                 default = nil)
  if valid_595035 != nil:
    section.add "resourceGroupName", valid_595035
  var valid_595036 = path.getOrDefault("managerName")
  valid_595036 = validateParameter(valid_595036, JString, required = true,
                                 default = nil)
  if valid_595036 != nil:
    section.add "managerName", valid_595036
  var valid_595037 = path.getOrDefault("subscriptionId")
  valid_595037 = validateParameter(valid_595037, JString, required = true,
                                 default = nil)
  if valid_595037 != nil:
    section.add "subscriptionId", valid_595037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  ##   $filter: JString (required)
  ##          : OData Filter options
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595038 = query.getOrDefault("api-version")
  valid_595038 = validateParameter(valid_595038, JString, required = true,
                                 default = nil)
  if valid_595038 != nil:
    section.add "api-version", valid_595038
  var valid_595039 = query.getOrDefault("$filter")
  valid_595039 = validateParameter(valid_595039, JString, required = true,
                                 default = nil)
  if valid_595039 != nil:
    section.add "$filter", valid_595039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595040: Call_ManagersListMetrics_595032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metrics for the specified manager.
  ## 
  let valid = call_595040.validator(path, query, header, formData, body)
  let scheme = call_595040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595040.url(scheme.get, call_595040.host, call_595040.base,
                         call_595040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595040, url, valid)

proc call*(call_595041: Call_ManagersListMetrics_595032; resourceGroupName: string;
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
  var path_595042 = newJObject()
  var query_595043 = newJObject()
  add(path_595042, "resourceGroupName", newJString(resourceGroupName))
  add(query_595043, "api-version", newJString(apiVersion))
  add(path_595042, "managerName", newJString(managerName))
  add(path_595042, "subscriptionId", newJString(subscriptionId))
  add(query_595043, "$filter", newJString(Filter))
  result = call_595041.call(path_595042, query_595043, nil, nil, nil)

var managersListMetrics* = Call_ManagersListMetrics_595032(
    name: "managersListMetrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/metrics",
    validator: validate_ManagersListMetrics_595033, base: "",
    url: url_ManagersListMetrics_595034, schemes: {Scheme.Https})
type
  Call_ManagersListMetricDefinition_595044 = ref object of OpenApiRestCall_593438
proc url_ManagersListMetricDefinition_595046(protocol: Scheme; host: string;
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

proc validate_ManagersListMetricDefinition_595045(path: JsonNode; query: JsonNode;
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
  var valid_595047 = path.getOrDefault("resourceGroupName")
  valid_595047 = validateParameter(valid_595047, JString, required = true,
                                 default = nil)
  if valid_595047 != nil:
    section.add "resourceGroupName", valid_595047
  var valid_595048 = path.getOrDefault("managerName")
  valid_595048 = validateParameter(valid_595048, JString, required = true,
                                 default = nil)
  if valid_595048 != nil:
    section.add "managerName", valid_595048
  var valid_595049 = path.getOrDefault("subscriptionId")
  valid_595049 = validateParameter(valid_595049, JString, required = true,
                                 default = nil)
  if valid_595049 != nil:
    section.add "subscriptionId", valid_595049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595050 = query.getOrDefault("api-version")
  valid_595050 = validateParameter(valid_595050, JString, required = true,
                                 default = nil)
  if valid_595050 != nil:
    section.add "api-version", valid_595050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595051: Call_ManagersListMetricDefinition_595044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metric definitions for the specified manager.
  ## 
  let valid = call_595051.validator(path, query, header, formData, body)
  let scheme = call_595051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595051.url(scheme.get, call_595051.host, call_595051.base,
                         call_595051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595051, url, valid)

proc call*(call_595052: Call_ManagersListMetricDefinition_595044;
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
  var path_595053 = newJObject()
  var query_595054 = newJObject()
  add(path_595053, "resourceGroupName", newJString(resourceGroupName))
  add(query_595054, "api-version", newJString(apiVersion))
  add(path_595053, "managerName", newJString(managerName))
  add(path_595053, "subscriptionId", newJString(subscriptionId))
  result = call_595052.call(path_595053, query_595054, nil, nil, nil)

var managersListMetricDefinition* = Call_ManagersListMetricDefinition_595044(
    name: "managersListMetricDefinition", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/metricsDefinitions",
    validator: validate_ManagersListMetricDefinition_595045, base: "",
    url: url_ManagersListMetricDefinition_595046, schemes: {Scheme.Https})
type
  Call_CloudAppliancesProvision_595055 = ref object of OpenApiRestCall_593438
proc url_CloudAppliancesProvision_595057(protocol: Scheme; host: string;
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

proc validate_CloudAppliancesProvision_595056(path: JsonNode; query: JsonNode;
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
  var valid_595058 = path.getOrDefault("resourceGroupName")
  valid_595058 = validateParameter(valid_595058, JString, required = true,
                                 default = nil)
  if valid_595058 != nil:
    section.add "resourceGroupName", valid_595058
  var valid_595059 = path.getOrDefault("managerName")
  valid_595059 = validateParameter(valid_595059, JString, required = true,
                                 default = nil)
  if valid_595059 != nil:
    section.add "managerName", valid_595059
  var valid_595060 = path.getOrDefault("subscriptionId")
  valid_595060 = validateParameter(valid_595060, JString, required = true,
                                 default = nil)
  if valid_595060 != nil:
    section.add "subscriptionId", valid_595060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595061 = query.getOrDefault("api-version")
  valid_595061 = validateParameter(valid_595061, JString, required = true,
                                 default = nil)
  if valid_595061 != nil:
    section.add "api-version", valid_595061
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

proc call*(call_595063: Call_CloudAppliancesProvision_595055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions cloud appliance.
  ## 
  let valid = call_595063.validator(path, query, header, formData, body)
  let scheme = call_595063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595063.url(scheme.get, call_595063.host, call_595063.base,
                         call_595063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595063, url, valid)

proc call*(call_595064: Call_CloudAppliancesProvision_595055;
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
  var path_595065 = newJObject()
  var query_595066 = newJObject()
  var body_595067 = newJObject()
  add(path_595065, "resourceGroupName", newJString(resourceGroupName))
  add(query_595066, "api-version", newJString(apiVersion))
  add(path_595065, "managerName", newJString(managerName))
  add(path_595065, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_595067 = parameters
  result = call_595064.call(path_595065, query_595066, nil, nil, body_595067)

var cloudAppliancesProvision* = Call_CloudAppliancesProvision_595055(
    name: "cloudAppliancesProvision", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/provisionCloudAppliance",
    validator: validate_CloudAppliancesProvision_595056, base: "",
    url: url_CloudAppliancesProvision_595057, schemes: {Scheme.Https})
type
  Call_ManagersRegenerateActivationKey_595068 = ref object of OpenApiRestCall_593438
proc url_ManagersRegenerateActivationKey_595070(protocol: Scheme; host: string;
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

proc validate_ManagersRegenerateActivationKey_595069(path: JsonNode;
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
  var valid_595071 = path.getOrDefault("resourceGroupName")
  valid_595071 = validateParameter(valid_595071, JString, required = true,
                                 default = nil)
  if valid_595071 != nil:
    section.add "resourceGroupName", valid_595071
  var valid_595072 = path.getOrDefault("managerName")
  valid_595072 = validateParameter(valid_595072, JString, required = true,
                                 default = nil)
  if valid_595072 != nil:
    section.add "managerName", valid_595072
  var valid_595073 = path.getOrDefault("subscriptionId")
  valid_595073 = validateParameter(valid_595073, JString, required = true,
                                 default = nil)
  if valid_595073 != nil:
    section.add "subscriptionId", valid_595073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595074 = query.getOrDefault("api-version")
  valid_595074 = validateParameter(valid_595074, JString, required = true,
                                 default = nil)
  if valid_595074 != nil:
    section.add "api-version", valid_595074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595075: Call_ManagersRegenerateActivationKey_595068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Re-generates and returns the activation key of the manager.
  ## 
  let valid = call_595075.validator(path, query, header, formData, body)
  let scheme = call_595075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595075.url(scheme.get, call_595075.host, call_595075.base,
                         call_595075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595075, url, valid)

proc call*(call_595076: Call_ManagersRegenerateActivationKey_595068;
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
  var path_595077 = newJObject()
  var query_595078 = newJObject()
  add(path_595077, "resourceGroupName", newJString(resourceGroupName))
  add(query_595078, "api-version", newJString(apiVersion))
  add(path_595077, "managerName", newJString(managerName))
  add(path_595077, "subscriptionId", newJString(subscriptionId))
  result = call_595076.call(path_595077, query_595078, nil, nil, nil)

var managersRegenerateActivationKey* = Call_ManagersRegenerateActivationKey_595068(
    name: "managersRegenerateActivationKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/regenerateActivationKey",
    validator: validate_ManagersRegenerateActivationKey_595069, base: "",
    url: url_ManagersRegenerateActivationKey_595070, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsListByManager_595079 = ref object of OpenApiRestCall_593438
proc url_StorageAccountCredentialsListByManager_595081(protocol: Scheme;
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

proc validate_StorageAccountCredentialsListByManager_595080(path: JsonNode;
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
  var valid_595082 = path.getOrDefault("resourceGroupName")
  valid_595082 = validateParameter(valid_595082, JString, required = true,
                                 default = nil)
  if valid_595082 != nil:
    section.add "resourceGroupName", valid_595082
  var valid_595083 = path.getOrDefault("managerName")
  valid_595083 = validateParameter(valid_595083, JString, required = true,
                                 default = nil)
  if valid_595083 != nil:
    section.add "managerName", valid_595083
  var valid_595084 = path.getOrDefault("subscriptionId")
  valid_595084 = validateParameter(valid_595084, JString, required = true,
                                 default = nil)
  if valid_595084 != nil:
    section.add "subscriptionId", valid_595084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595085 = query.getOrDefault("api-version")
  valid_595085 = validateParameter(valid_595085, JString, required = true,
                                 default = nil)
  if valid_595085 != nil:
    section.add "api-version", valid_595085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595086: Call_StorageAccountCredentialsListByManager_595079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the storage account credentials in a manager.
  ## 
  let valid = call_595086.validator(path, query, header, formData, body)
  let scheme = call_595086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595086.url(scheme.get, call_595086.host, call_595086.base,
                         call_595086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595086, url, valid)

proc call*(call_595087: Call_StorageAccountCredentialsListByManager_595079;
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
  var path_595088 = newJObject()
  var query_595089 = newJObject()
  add(path_595088, "resourceGroupName", newJString(resourceGroupName))
  add(query_595089, "api-version", newJString(apiVersion))
  add(path_595088, "managerName", newJString(managerName))
  add(path_595088, "subscriptionId", newJString(subscriptionId))
  result = call_595087.call(path_595088, query_595089, nil, nil, nil)

var storageAccountCredentialsListByManager* = Call_StorageAccountCredentialsListByManager_595079(
    name: "storageAccountCredentialsListByManager", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials",
    validator: validate_StorageAccountCredentialsListByManager_595080, base: "",
    url: url_StorageAccountCredentialsListByManager_595081,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsCreateOrUpdate_595102 = ref object of OpenApiRestCall_593438
proc url_StorageAccountCredentialsCreateOrUpdate_595104(protocol: Scheme;
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

proc validate_StorageAccountCredentialsCreateOrUpdate_595103(path: JsonNode;
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
  var valid_595105 = path.getOrDefault("resourceGroupName")
  valid_595105 = validateParameter(valid_595105, JString, required = true,
                                 default = nil)
  if valid_595105 != nil:
    section.add "resourceGroupName", valid_595105
  var valid_595106 = path.getOrDefault("managerName")
  valid_595106 = validateParameter(valid_595106, JString, required = true,
                                 default = nil)
  if valid_595106 != nil:
    section.add "managerName", valid_595106
  var valid_595107 = path.getOrDefault("subscriptionId")
  valid_595107 = validateParameter(valid_595107, JString, required = true,
                                 default = nil)
  if valid_595107 != nil:
    section.add "subscriptionId", valid_595107
  var valid_595108 = path.getOrDefault("storageAccountCredentialName")
  valid_595108 = validateParameter(valid_595108, JString, required = true,
                                 default = nil)
  if valid_595108 != nil:
    section.add "storageAccountCredentialName", valid_595108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595109 = query.getOrDefault("api-version")
  valid_595109 = validateParameter(valid_595109, JString, required = true,
                                 default = nil)
  if valid_595109 != nil:
    section.add "api-version", valid_595109
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

proc call*(call_595111: Call_StorageAccountCredentialsCreateOrUpdate_595102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the storage account credential.
  ## 
  let valid = call_595111.validator(path, query, header, formData, body)
  let scheme = call_595111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595111.url(scheme.get, call_595111.host, call_595111.base,
                         call_595111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595111, url, valid)

proc call*(call_595112: Call_StorageAccountCredentialsCreateOrUpdate_595102;
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
  var path_595113 = newJObject()
  var query_595114 = newJObject()
  var body_595115 = newJObject()
  add(path_595113, "resourceGroupName", newJString(resourceGroupName))
  add(query_595114, "api-version", newJString(apiVersion))
  add(path_595113, "managerName", newJString(managerName))
  add(path_595113, "subscriptionId", newJString(subscriptionId))
  add(path_595113, "storageAccountCredentialName",
      newJString(storageAccountCredentialName))
  if parameters != nil:
    body_595115 = parameters
  result = call_595112.call(path_595113, query_595114, nil, nil, body_595115)

var storageAccountCredentialsCreateOrUpdate* = Call_StorageAccountCredentialsCreateOrUpdate_595102(
    name: "storageAccountCredentialsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{storageAccountCredentialName}",
    validator: validate_StorageAccountCredentialsCreateOrUpdate_595103, base: "",
    url: url_StorageAccountCredentialsCreateOrUpdate_595104,
    schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsGet_595090 = ref object of OpenApiRestCall_593438
proc url_StorageAccountCredentialsGet_595092(protocol: Scheme; host: string;
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

proc validate_StorageAccountCredentialsGet_595091(path: JsonNode; query: JsonNode;
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
  var valid_595093 = path.getOrDefault("resourceGroupName")
  valid_595093 = validateParameter(valid_595093, JString, required = true,
                                 default = nil)
  if valid_595093 != nil:
    section.add "resourceGroupName", valid_595093
  var valid_595094 = path.getOrDefault("managerName")
  valid_595094 = validateParameter(valid_595094, JString, required = true,
                                 default = nil)
  if valid_595094 != nil:
    section.add "managerName", valid_595094
  var valid_595095 = path.getOrDefault("subscriptionId")
  valid_595095 = validateParameter(valid_595095, JString, required = true,
                                 default = nil)
  if valid_595095 != nil:
    section.add "subscriptionId", valid_595095
  var valid_595096 = path.getOrDefault("storageAccountCredentialName")
  valid_595096 = validateParameter(valid_595096, JString, required = true,
                                 default = nil)
  if valid_595096 != nil:
    section.add "storageAccountCredentialName", valid_595096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595097 = query.getOrDefault("api-version")
  valid_595097 = validateParameter(valid_595097, JString, required = true,
                                 default = nil)
  if valid_595097 != nil:
    section.add "api-version", valid_595097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595098: Call_StorageAccountCredentialsGet_595090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified storage account credential name.
  ## 
  let valid = call_595098.validator(path, query, header, formData, body)
  let scheme = call_595098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595098.url(scheme.get, call_595098.host, call_595098.base,
                         call_595098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595098, url, valid)

proc call*(call_595099: Call_StorageAccountCredentialsGet_595090;
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
  var path_595100 = newJObject()
  var query_595101 = newJObject()
  add(path_595100, "resourceGroupName", newJString(resourceGroupName))
  add(query_595101, "api-version", newJString(apiVersion))
  add(path_595100, "managerName", newJString(managerName))
  add(path_595100, "subscriptionId", newJString(subscriptionId))
  add(path_595100, "storageAccountCredentialName",
      newJString(storageAccountCredentialName))
  result = call_595099.call(path_595100, query_595101, nil, nil, nil)

var storageAccountCredentialsGet* = Call_StorageAccountCredentialsGet_595090(
    name: "storageAccountCredentialsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{storageAccountCredentialName}",
    validator: validate_StorageAccountCredentialsGet_595091, base: "",
    url: url_StorageAccountCredentialsGet_595092, schemes: {Scheme.Https})
type
  Call_StorageAccountCredentialsDelete_595116 = ref object of OpenApiRestCall_593438
proc url_StorageAccountCredentialsDelete_595118(protocol: Scheme; host: string;
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

proc validate_StorageAccountCredentialsDelete_595117(path: JsonNode;
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
  var valid_595119 = path.getOrDefault("resourceGroupName")
  valid_595119 = validateParameter(valid_595119, JString, required = true,
                                 default = nil)
  if valid_595119 != nil:
    section.add "resourceGroupName", valid_595119
  var valid_595120 = path.getOrDefault("managerName")
  valid_595120 = validateParameter(valid_595120, JString, required = true,
                                 default = nil)
  if valid_595120 != nil:
    section.add "managerName", valid_595120
  var valid_595121 = path.getOrDefault("subscriptionId")
  valid_595121 = validateParameter(valid_595121, JString, required = true,
                                 default = nil)
  if valid_595121 != nil:
    section.add "subscriptionId", valid_595121
  var valid_595122 = path.getOrDefault("storageAccountCredentialName")
  valid_595122 = validateParameter(valid_595122, JString, required = true,
                                 default = nil)
  if valid_595122 != nil:
    section.add "storageAccountCredentialName", valid_595122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The api version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595123 = query.getOrDefault("api-version")
  valid_595123 = validateParameter(valid_595123, JString, required = true,
                                 default = nil)
  if valid_595123 != nil:
    section.add "api-version", valid_595123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595124: Call_StorageAccountCredentialsDelete_595116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the storage account credential.
  ## 
  let valid = call_595124.validator(path, query, header, formData, body)
  let scheme = call_595124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595124.url(scheme.get, call_595124.host, call_595124.base,
                         call_595124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595124, url, valid)

proc call*(call_595125: Call_StorageAccountCredentialsDelete_595116;
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
  var path_595126 = newJObject()
  var query_595127 = newJObject()
  add(path_595126, "resourceGroupName", newJString(resourceGroupName))
  add(query_595127, "api-version", newJString(apiVersion))
  add(path_595126, "managerName", newJString(managerName))
  add(path_595126, "subscriptionId", newJString(subscriptionId))
  add(path_595126, "storageAccountCredentialName",
      newJString(storageAccountCredentialName))
  result = call_595125.call(path_595126, query_595127, nil, nil, nil)

var storageAccountCredentialsDelete* = Call_StorageAccountCredentialsDelete_595116(
    name: "storageAccountCredentialsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.StorSimple/managers/{managerName}/storageAccountCredentials/{storageAccountCredentialName}",
    validator: validate_StorageAccountCredentialsDelete_595117, base: "",
    url: url_StorageAccountCredentialsDelete_595118, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
