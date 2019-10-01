
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ManagementLockClient
## version: 2016-09-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure resources can be locked to prevent other users in your organization from deleting or modifying resources.
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
  macServiceName = "resources-locks"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AuthorizationOperationsList_567879 = ref object of OpenApiRestCall_567657
proc url_AuthorizationOperationsList_567881(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AuthorizationOperationsList_567880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.Authorization REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_AuthorizationOperationsList_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Authorization REST API operations.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_AuthorizationOperationsList_567879; apiVersion: string): Recallable =
  ## authorizationOperationsList
  ## Lists all of the available Microsoft.Authorization REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var authorizationOperationsList* = Call_AuthorizationOperationsList_567879(
    name: "authorizationOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Authorization/operations",
    validator: validate_AuthorizationOperationsList_567880, base: "",
    url: url_AuthorizationOperationsList_567881, schemes: {Scheme.Https})
type
  Call_ManagementLocksListAtSubscriptionLevel_568175 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksListAtSubscriptionLevel_568177(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Authorization/locks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksListAtSubscriptionLevel_568176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the management locks for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568193 = path.getOrDefault("subscriptionId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "subscriptionId", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568194 = query.getOrDefault("api-version")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "api-version", valid_568194
  var valid_568195 = query.getOrDefault("$filter")
  valid_568195 = validateParameter(valid_568195, JString, required = false,
                                 default = nil)
  if valid_568195 != nil:
    section.add "$filter", valid_568195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568196: Call_ManagementLocksListAtSubscriptionLevel_568175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the management locks for a subscription.
  ## 
  let valid = call_568196.validator(path, query, header, formData, body)
  let scheme = call_568196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568196.url(scheme.get, call_568196.host, call_568196.base,
                         call_568196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568196, url, valid)

proc call*(call_568197: Call_ManagementLocksListAtSubscriptionLevel_568175;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## managementLocksListAtSubscriptionLevel
  ## Gets all the management locks for a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568198 = newJObject()
  var query_568199 = newJObject()
  add(query_568199, "api-version", newJString(apiVersion))
  add(path_568198, "subscriptionId", newJString(subscriptionId))
  add(query_568199, "$filter", newJString(Filter))
  result = call_568197.call(path_568198, query_568199, nil, nil, nil)

var managementLocksListAtSubscriptionLevel* = Call_ManagementLocksListAtSubscriptionLevel_568175(
    name: "managementLocksListAtSubscriptionLevel", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/locks",
    validator: validate_ManagementLocksListAtSubscriptionLevel_568176, base: "",
    url: url_ManagementLocksListAtSubscriptionLevel_568177,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksCreateOrUpdateAtSubscriptionLevel_568210 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksCreateOrUpdateAtSubscriptionLevel_568212(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "lockName" in path, "`lockName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Authorization/locks/"),
               (kind: VariableSegment, value: "lockName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksCreateOrUpdateAtSubscriptionLevel_568211(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## When you apply a lock at a parent scope, all child resources inherit the same lock. To create management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   lockName: JString (required)
  ##           : The name of lock. The lock name can be a maximum of 260 characters. It cannot contain <, > %, &, :, \, ?, /, or any control characters.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  var valid_568231 = path.getOrDefault("lockName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "lockName", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The management lock parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568234: Call_ManagementLocksCreateOrUpdateAtSubscriptionLevel_568210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## When you apply a lock at a parent scope, all child resources inherit the same lock. To create management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ## 
  let valid = call_568234.validator(path, query, header, formData, body)
  let scheme = call_568234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568234.url(scheme.get, call_568234.host, call_568234.base,
                         call_568234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568234, url, valid)

proc call*(call_568235: Call_ManagementLocksCreateOrUpdateAtSubscriptionLevel_568210;
          apiVersion: string; subscriptionId: string; lockName: string;
          parameters: JsonNode): Recallable =
  ## managementLocksCreateOrUpdateAtSubscriptionLevel
  ## When you apply a lock at a parent scope, all child resources inherit the same lock. To create management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   lockName: string (required)
  ##           : The name of lock. The lock name can be a maximum of 260 characters. It cannot contain <, > %, &, :, \, ?, /, or any control characters.
  ##   parameters: JObject (required)
  ##             : The management lock parameters.
  var path_568236 = newJObject()
  var query_568237 = newJObject()
  var body_568238 = newJObject()
  add(query_568237, "api-version", newJString(apiVersion))
  add(path_568236, "subscriptionId", newJString(subscriptionId))
  add(path_568236, "lockName", newJString(lockName))
  if parameters != nil:
    body_568238 = parameters
  result = call_568235.call(path_568236, query_568237, nil, nil, body_568238)

var managementLocksCreateOrUpdateAtSubscriptionLevel* = Call_ManagementLocksCreateOrUpdateAtSubscriptionLevel_568210(
    name: "managementLocksCreateOrUpdateAtSubscriptionLevel",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksCreateOrUpdateAtSubscriptionLevel_568211,
    base: "", url: url_ManagementLocksCreateOrUpdateAtSubscriptionLevel_568212,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksGetAtSubscriptionLevel_568200 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksGetAtSubscriptionLevel_568202(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "lockName" in path, "`lockName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Authorization/locks/"),
               (kind: VariableSegment, value: "lockName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksGetAtSubscriptionLevel_568201(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a management lock at the subscription level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   lockName: JString (required)
  ##           : The name of the lock to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  var valid_568204 = path.getOrDefault("lockName")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "lockName", valid_568204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568205 = query.getOrDefault("api-version")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "api-version", valid_568205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568206: Call_ManagementLocksGetAtSubscriptionLevel_568200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a management lock at the subscription level.
  ## 
  let valid = call_568206.validator(path, query, header, formData, body)
  let scheme = call_568206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568206.url(scheme.get, call_568206.host, call_568206.base,
                         call_568206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568206, url, valid)

proc call*(call_568207: Call_ManagementLocksGetAtSubscriptionLevel_568200;
          apiVersion: string; subscriptionId: string; lockName: string): Recallable =
  ## managementLocksGetAtSubscriptionLevel
  ## Gets a management lock at the subscription level.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   lockName: string (required)
  ##           : The name of the lock to get.
  var path_568208 = newJObject()
  var query_568209 = newJObject()
  add(query_568209, "api-version", newJString(apiVersion))
  add(path_568208, "subscriptionId", newJString(subscriptionId))
  add(path_568208, "lockName", newJString(lockName))
  result = call_568207.call(path_568208, query_568209, nil, nil, nil)

var managementLocksGetAtSubscriptionLevel* = Call_ManagementLocksGetAtSubscriptionLevel_568200(
    name: "managementLocksGetAtSubscriptionLevel", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksGetAtSubscriptionLevel_568201, base: "",
    url: url_ManagementLocksGetAtSubscriptionLevel_568202, schemes: {Scheme.Https})
type
  Call_ManagementLocksDeleteAtSubscriptionLevel_568239 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksDeleteAtSubscriptionLevel_568241(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "lockName" in path, "`lockName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Authorization/locks/"),
               (kind: VariableSegment, value: "lockName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksDeleteAtSubscriptionLevel_568240(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## To delete management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   lockName: JString (required)
  ##           : The name of lock to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  var valid_568243 = path.getOrDefault("lockName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "lockName", valid_568243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568244 = query.getOrDefault("api-version")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "api-version", valid_568244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_ManagementLocksDeleteAtSubscriptionLevel_568239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## To delete management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_ManagementLocksDeleteAtSubscriptionLevel_568239;
          apiVersion: string; subscriptionId: string; lockName: string): Recallable =
  ## managementLocksDeleteAtSubscriptionLevel
  ## To delete management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   lockName: string (required)
  ##           : The name of lock to delete.
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  add(path_568247, "lockName", newJString(lockName))
  result = call_568246.call(path_568247, query_568248, nil, nil, nil)

var managementLocksDeleteAtSubscriptionLevel* = Call_ManagementLocksDeleteAtSubscriptionLevel_568239(
    name: "managementLocksDeleteAtSubscriptionLevel", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksDeleteAtSubscriptionLevel_568240, base: "",
    url: url_ManagementLocksDeleteAtSubscriptionLevel_568241,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksListAtResourceGroupLevel_568249 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksListAtResourceGroupLevel_568251(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Authorization/locks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksListAtResourceGroupLevel_568250(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the management locks for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the locks to get.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568252 = path.getOrDefault("resourceGroupName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "resourceGroupName", valid_568252
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  var valid_568255 = query.getOrDefault("$filter")
  valid_568255 = validateParameter(valid_568255, JString, required = false,
                                 default = nil)
  if valid_568255 != nil:
    section.add "$filter", valid_568255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_ManagementLocksListAtResourceGroupLevel_568249;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the management locks for a resource group.
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_ManagementLocksListAtResourceGroupLevel_568249;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## managementLocksListAtResourceGroupLevel
  ## Gets all the management locks for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the locks to get.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  add(path_568258, "resourceGroupName", newJString(resourceGroupName))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  add(query_568259, "$filter", newJString(Filter))
  result = call_568257.call(path_568258, query_568259, nil, nil, nil)

var managementLocksListAtResourceGroupLevel* = Call_ManagementLocksListAtResourceGroupLevel_568249(
    name: "managementLocksListAtResourceGroupLevel", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/locks",
    validator: validate_ManagementLocksListAtResourceGroupLevel_568250, base: "",
    url: url_ManagementLocksListAtResourceGroupLevel_568251,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksCreateOrUpdateAtResourceGroupLevel_568271 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksCreateOrUpdateAtResourceGroupLevel_568273(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "lockName" in path, "`lockName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Authorization/locks/"),
               (kind: VariableSegment, value: "lockName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksCreateOrUpdateAtResourceGroupLevel_568272(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## When you apply a lock at a parent scope, all child resources inherit the same lock. To create management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to lock.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   lockName: JString (required)
  ##           : The lock name. The lock name can be a maximum of 260 characters. It cannot contain <, > %, &, :, \, ?, /, or any control characters.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568274 = path.getOrDefault("resourceGroupName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "resourceGroupName", valid_568274
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
  var valid_568276 = path.getOrDefault("lockName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "lockName", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The management lock parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568279: Call_ManagementLocksCreateOrUpdateAtResourceGroupLevel_568271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## When you apply a lock at a parent scope, all child resources inherit the same lock. To create management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_ManagementLocksCreateOrUpdateAtResourceGroupLevel_568271;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          lockName: string; parameters: JsonNode): Recallable =
  ## managementLocksCreateOrUpdateAtResourceGroupLevel
  ## When you apply a lock at a parent scope, all child resources inherit the same lock. To create management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to lock.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   lockName: string (required)
  ##           : The lock name. The lock name can be a maximum of 260 characters. It cannot contain <, > %, &, :, \, ?, /, or any control characters.
  ##   parameters: JObject (required)
  ##             : The management lock parameters.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  var body_568283 = newJObject()
  add(path_568281, "resourceGroupName", newJString(resourceGroupName))
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "subscriptionId", newJString(subscriptionId))
  add(path_568281, "lockName", newJString(lockName))
  if parameters != nil:
    body_568283 = parameters
  result = call_568280.call(path_568281, query_568282, nil, nil, body_568283)

var managementLocksCreateOrUpdateAtResourceGroupLevel* = Call_ManagementLocksCreateOrUpdateAtResourceGroupLevel_568271(
    name: "managementLocksCreateOrUpdateAtResourceGroupLevel",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksCreateOrUpdateAtResourceGroupLevel_568272,
    base: "", url: url_ManagementLocksCreateOrUpdateAtResourceGroupLevel_568273,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksGetAtResourceGroupLevel_568260 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksGetAtResourceGroupLevel_568262(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "lockName" in path, "`lockName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Authorization/locks/"),
               (kind: VariableSegment, value: "lockName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksGetAtResourceGroupLevel_568261(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a management lock at the resource group level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the locked resource group.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   lockName: JString (required)
  ##           : The name of the lock to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568263 = path.getOrDefault("resourceGroupName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "resourceGroupName", valid_568263
  var valid_568264 = path.getOrDefault("subscriptionId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "subscriptionId", valid_568264
  var valid_568265 = path.getOrDefault("lockName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "lockName", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568267: Call_ManagementLocksGetAtResourceGroupLevel_568260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a management lock at the resource group level.
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_ManagementLocksGetAtResourceGroupLevel_568260;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          lockName: string): Recallable =
  ## managementLocksGetAtResourceGroupLevel
  ## Gets a management lock at the resource group level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the locked resource group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   lockName: string (required)
  ##           : The name of the lock to get.
  var path_568269 = newJObject()
  var query_568270 = newJObject()
  add(path_568269, "resourceGroupName", newJString(resourceGroupName))
  add(query_568270, "api-version", newJString(apiVersion))
  add(path_568269, "subscriptionId", newJString(subscriptionId))
  add(path_568269, "lockName", newJString(lockName))
  result = call_568268.call(path_568269, query_568270, nil, nil, nil)

var managementLocksGetAtResourceGroupLevel* = Call_ManagementLocksGetAtResourceGroupLevel_568260(
    name: "managementLocksGetAtResourceGroupLevel", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksGetAtResourceGroupLevel_568261, base: "",
    url: url_ManagementLocksGetAtResourceGroupLevel_568262,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksDeleteAtResourceGroupLevel_568284 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksDeleteAtResourceGroupLevel_568286(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "lockName" in path, "`lockName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Authorization/locks/"),
               (kind: VariableSegment, value: "lockName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksDeleteAtResourceGroupLevel_568285(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## To delete management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the lock.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   lockName: JString (required)
  ##           : The name of lock to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568287 = path.getOrDefault("resourceGroupName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "resourceGroupName", valid_568287
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  var valid_568289 = path.getOrDefault("lockName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "lockName", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "api-version", valid_568290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_ManagementLocksDeleteAtResourceGroupLevel_568284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## To delete management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_ManagementLocksDeleteAtResourceGroupLevel_568284;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          lockName: string): Recallable =
  ## managementLocksDeleteAtResourceGroupLevel
  ## To delete management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the lock.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   lockName: string (required)
  ##           : The name of lock to delete.
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  add(path_568293, "lockName", newJString(lockName))
  result = call_568292.call(path_568293, query_568294, nil, nil, nil)

var managementLocksDeleteAtResourceGroupLevel* = Call_ManagementLocksDeleteAtResourceGroupLevel_568284(
    name: "managementLocksDeleteAtResourceGroupLevel",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksDeleteAtResourceGroupLevel_568285,
    base: "", url: url_ManagementLocksDeleteAtResourceGroupLevel_568286,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksListAtResourceLevel_568295 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksListAtResourceLevel_568297(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Authorization/locks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksListAtResourceLevel_568296(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the management locks for a resource or any level below resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the locked resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the locked resource. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the locked resource.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568298 = path.getOrDefault("resourceType")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "resourceType", valid_568298
  var valid_568299 = path.getOrDefault("resourceGroupName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "resourceGroupName", valid_568299
  var valid_568300 = path.getOrDefault("subscriptionId")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "subscriptionId", valid_568300
  var valid_568301 = path.getOrDefault("resourceName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "resourceName", valid_568301
  var valid_568302 = path.getOrDefault("resourceProviderNamespace")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "resourceProviderNamespace", valid_568302
  var valid_568303 = path.getOrDefault("parentResourcePath")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "parentResourcePath", valid_568303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "api-version", valid_568304
  var valid_568305 = query.getOrDefault("$filter")
  valid_568305 = validateParameter(valid_568305, JString, required = false,
                                 default = nil)
  if valid_568305 != nil:
    section.add "$filter", valid_568305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_ManagementLocksListAtResourceLevel_568295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the management locks for a resource or any level below resource.
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_ManagementLocksListAtResourceLevel_568295;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          resourceProviderNamespace: string; parentResourcePath: string;
          Filter: string = ""): Recallable =
  ## managementLocksListAtResourceLevel
  ## Gets all the management locks for a resource or any level below resource.
  ##   resourceType: string (required)
  ##               : The resource type of the locked resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the locked resource. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the locked resource.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  add(path_568308, "resourceType", newJString(resourceType))
  add(path_568308, "resourceGroupName", newJString(resourceGroupName))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  add(path_568308, "resourceName", newJString(resourceName))
  add(path_568308, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568308, "parentResourcePath", newJString(parentResourcePath))
  add(query_568309, "$filter", newJString(Filter))
  result = call_568307.call(path_568308, query_568309, nil, nil, nil)

var managementLocksListAtResourceLevel* = Call_ManagementLocksListAtResourceLevel_568295(
    name: "managementLocksListAtResourceLevel", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/locks",
    validator: validate_ManagementLocksListAtResourceLevel_568296, base: "",
    url: url_ManagementLocksListAtResourceLevel_568297, schemes: {Scheme.Https})
type
  Call_ManagementLocksCreateOrUpdateAtResourceLevel_568325 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksCreateOrUpdateAtResourceLevel_568327(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "lockName" in path, "`lockName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Authorization/locks/"),
               (kind: VariableSegment, value: "lockName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksCreateOrUpdateAtResourceLevel_568326(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## When you apply a lock at a parent scope, all child resources inherit the same lock. To create management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource to lock.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource to lock. 
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to lock.
  ##   lockName: JString (required)
  ##           : The name of lock. The lock name can be a maximum of 260 characters. It cannot contain <, > %, &, :, \, ?, /, or any control characters.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The resource provider namespace of the resource to lock.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568328 = path.getOrDefault("resourceType")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "resourceType", valid_568328
  var valid_568329 = path.getOrDefault("resourceGroupName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "resourceGroupName", valid_568329
  var valid_568330 = path.getOrDefault("subscriptionId")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "subscriptionId", valid_568330
  var valid_568331 = path.getOrDefault("resourceName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceName", valid_568331
  var valid_568332 = path.getOrDefault("lockName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "lockName", valid_568332
  var valid_568333 = path.getOrDefault("resourceProviderNamespace")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "resourceProviderNamespace", valid_568333
  var valid_568334 = path.getOrDefault("parentResourcePath")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "parentResourcePath", valid_568334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568335 = query.getOrDefault("api-version")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "api-version", valid_568335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating a  management lock.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_ManagementLocksCreateOrUpdateAtResourceLevel_568325;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## When you apply a lock at a parent scope, all child resources inherit the same lock. To create management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ## 
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_ManagementLocksCreateOrUpdateAtResourceLevel_568325;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; lockName: string;
          parameters: JsonNode; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## managementLocksCreateOrUpdateAtResourceLevel
  ## When you apply a lock at a parent scope, all child resources inherit the same lock. To create management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ##   resourceType: string (required)
  ##               : The resource type of the resource to lock.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource to lock. 
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to lock.
  ##   lockName: string (required)
  ##           : The name of lock. The lock name can be a maximum of 260 characters. It cannot contain <, > %, &, :, \, ?, /, or any control characters.
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating a  management lock.
  ##   resourceProviderNamespace: string (required)
  ##                            : The resource provider namespace of the resource to lock.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  var body_568341 = newJObject()
  add(path_568339, "resourceType", newJString(resourceType))
  add(path_568339, "resourceGroupName", newJString(resourceGroupName))
  add(query_568340, "api-version", newJString(apiVersion))
  add(path_568339, "subscriptionId", newJString(subscriptionId))
  add(path_568339, "resourceName", newJString(resourceName))
  add(path_568339, "lockName", newJString(lockName))
  if parameters != nil:
    body_568341 = parameters
  add(path_568339, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568339, "parentResourcePath", newJString(parentResourcePath))
  result = call_568338.call(path_568339, query_568340, nil, nil, body_568341)

var managementLocksCreateOrUpdateAtResourceLevel* = Call_ManagementLocksCreateOrUpdateAtResourceLevel_568325(
    name: "managementLocksCreateOrUpdateAtResourceLevel",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksCreateOrUpdateAtResourceLevel_568326,
    base: "", url: url_ManagementLocksCreateOrUpdateAtResourceLevel_568327,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksGetAtResourceLevel_568310 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksGetAtResourceLevel_568312(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "lockName" in path, "`lockName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Authorization/locks/"),
               (kind: VariableSegment, value: "lockName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksGetAtResourceLevel_568311(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the management lock of a resource or any level below resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. 
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource.
  ##   lockName: JString (required)
  ##           : The name of lock.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : An extra path parameter needed in some services, like SQL Databases.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568313 = path.getOrDefault("resourceType")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "resourceType", valid_568313
  var valid_568314 = path.getOrDefault("resourceGroupName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "resourceGroupName", valid_568314
  var valid_568315 = path.getOrDefault("subscriptionId")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "subscriptionId", valid_568315
  var valid_568316 = path.getOrDefault("resourceName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "resourceName", valid_568316
  var valid_568317 = path.getOrDefault("lockName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "lockName", valid_568317
  var valid_568318 = path.getOrDefault("resourceProviderNamespace")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "resourceProviderNamespace", valid_568318
  var valid_568319 = path.getOrDefault("parentResourcePath")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "parentResourcePath", valid_568319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568320 = query.getOrDefault("api-version")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "api-version", valid_568320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568321: Call_ManagementLocksGetAtResourceLevel_568310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the management lock of a resource or any level below resource.
  ## 
  let valid = call_568321.validator(path, query, header, formData, body)
  let scheme = call_568321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568321.url(scheme.get, call_568321.host, call_568321.base,
                         call_568321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568321, url, valid)

proc call*(call_568322: Call_ManagementLocksGetAtResourceLevel_568310;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; lockName: string;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## managementLocksGetAtResourceLevel
  ## Get the management lock of a resource or any level below resource.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. 
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource.
  ##   lockName: string (required)
  ##           : The name of lock.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : An extra path parameter needed in some services, like SQL Databases.
  var path_568323 = newJObject()
  var query_568324 = newJObject()
  add(path_568323, "resourceType", newJString(resourceType))
  add(path_568323, "resourceGroupName", newJString(resourceGroupName))
  add(query_568324, "api-version", newJString(apiVersion))
  add(path_568323, "subscriptionId", newJString(subscriptionId))
  add(path_568323, "resourceName", newJString(resourceName))
  add(path_568323, "lockName", newJString(lockName))
  add(path_568323, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568323, "parentResourcePath", newJString(parentResourcePath))
  result = call_568322.call(path_568323, query_568324, nil, nil, nil)

var managementLocksGetAtResourceLevel* = Call_ManagementLocksGetAtResourceLevel_568310(
    name: "managementLocksGetAtResourceLevel", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksGetAtResourceLevel_568311, base: "",
    url: url_ManagementLocksGetAtResourceLevel_568312, schemes: {Scheme.Https})
type
  Call_ManagementLocksDeleteAtResourceLevel_568342 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksDeleteAtResourceLevel_568344(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "lockName" in path, "`lockName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Authorization/locks/"),
               (kind: VariableSegment, value: "lockName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksDeleteAtResourceLevel_568343(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## To delete management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource with the lock to delete.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource with the lock to delete. 
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource with the lock to delete.
  ##   lockName: JString (required)
  ##           : The name of the lock to delete.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The resource provider namespace of the resource with the lock to delete.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568345 = path.getOrDefault("resourceType")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "resourceType", valid_568345
  var valid_568346 = path.getOrDefault("resourceGroupName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "resourceGroupName", valid_568346
  var valid_568347 = path.getOrDefault("subscriptionId")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "subscriptionId", valid_568347
  var valid_568348 = path.getOrDefault("resourceName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "resourceName", valid_568348
  var valid_568349 = path.getOrDefault("lockName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "lockName", valid_568349
  var valid_568350 = path.getOrDefault("resourceProviderNamespace")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "resourceProviderNamespace", valid_568350
  var valid_568351 = path.getOrDefault("parentResourcePath")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "parentResourcePath", valid_568351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568352 = query.getOrDefault("api-version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "api-version", valid_568352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_ManagementLocksDeleteAtResourceLevel_568342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## To delete management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_ManagementLocksDeleteAtResourceLevel_568342;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; lockName: string;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## managementLocksDeleteAtResourceLevel
  ## To delete management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions. Of the built-in roles, only Owner and User Access Administrator are granted those actions.
  ##   resourceType: string (required)
  ##               : The resource type of the resource with the lock to delete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource with the lock to delete. 
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource with the lock to delete.
  ##   lockName: string (required)
  ##           : The name of the lock to delete.
  ##   resourceProviderNamespace: string (required)
  ##                            : The resource provider namespace of the resource with the lock to delete.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  add(path_568355, "resourceType", newJString(resourceType))
  add(path_568355, "resourceGroupName", newJString(resourceGroupName))
  add(query_568356, "api-version", newJString(apiVersion))
  add(path_568355, "subscriptionId", newJString(subscriptionId))
  add(path_568355, "resourceName", newJString(resourceName))
  add(path_568355, "lockName", newJString(lockName))
  add(path_568355, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568355, "parentResourcePath", newJString(parentResourcePath))
  result = call_568354.call(path_568355, query_568356, nil, nil, nil)

var managementLocksDeleteAtResourceLevel* = Call_ManagementLocksDeleteAtResourceLevel_568342(
    name: "managementLocksDeleteAtResourceLevel", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksDeleteAtResourceLevel_568343, base: "",
    url: url_ManagementLocksDeleteAtResourceLevel_568344, schemes: {Scheme.Https})
type
  Call_ManagementLocksListByScope_568357 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksListByScope_568359(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/locks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksListByScope_568358(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the management locks for a scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope for the lock. When providing a scope for the assignment, use '/subscriptions/{subscriptionId}' for subscriptions, '/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}' for resource groups, and 
  ## '/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePathIfPresent}/{resourceType}/{resourceName}' for resources.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568360 = path.getOrDefault("scope")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "scope", valid_568360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568361 = query.getOrDefault("api-version")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "api-version", valid_568361
  var valid_568362 = query.getOrDefault("$filter")
  valid_568362 = validateParameter(valid_568362, JString, required = false,
                                 default = nil)
  if valid_568362 != nil:
    section.add "$filter", valid_568362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568363: Call_ManagementLocksListByScope_568357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the management locks for a scope.
  ## 
  let valid = call_568363.validator(path, query, header, formData, body)
  let scheme = call_568363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568363.url(scheme.get, call_568363.host, call_568363.base,
                         call_568363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568363, url, valid)

proc call*(call_568364: Call_ManagementLocksListByScope_568357; apiVersion: string;
          scope: string; Filter: string = ""): Recallable =
  ## managementLocksListByScope
  ## Gets all the management locks for a scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   scope: string (required)
  ##        : The scope for the lock. When providing a scope for the assignment, use '/subscriptions/{subscriptionId}' for subscriptions, '/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}' for resource groups, and 
  ## '/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePathIfPresent}/{resourceType}/{resourceName}' for resources.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568365 = newJObject()
  var query_568366 = newJObject()
  add(query_568366, "api-version", newJString(apiVersion))
  add(path_568365, "scope", newJString(scope))
  add(query_568366, "$filter", newJString(Filter))
  result = call_568364.call(path_568365, query_568366, nil, nil, nil)

var managementLocksListByScope* = Call_ManagementLocksListByScope_568357(
    name: "managementLocksListByScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/locks",
    validator: validate_ManagementLocksListByScope_568358, base: "",
    url: url_ManagementLocksListByScope_568359, schemes: {Scheme.Https})
type
  Call_ManagementLocksCreateOrUpdateByScope_568377 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksCreateOrUpdateByScope_568379(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "lockName" in path, "`lockName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/locks/"),
               (kind: VariableSegment, value: "lockName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksCreateOrUpdateByScope_568378(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a management lock by scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   lockName: JString (required)
  ##           : The name of lock.
  ##   scope: JString (required)
  ##        : The scope for the lock. When providing a scope for the assignment, use '/subscriptions/{subscriptionId}' for subscriptions, '/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}' for resource groups, and 
  ## '/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePathIfPresent}/{resourceType}/{resourceName}' for resources.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `lockName` field"
  var valid_568380 = path.getOrDefault("lockName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "lockName", valid_568380
  var valid_568381 = path.getOrDefault("scope")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "scope", valid_568381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568382 = query.getOrDefault("api-version")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "api-version", valid_568382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update management lock parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568384: Call_ManagementLocksCreateOrUpdateByScope_568377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a management lock by scope.
  ## 
  let valid = call_568384.validator(path, query, header, formData, body)
  let scheme = call_568384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568384.url(scheme.get, call_568384.host, call_568384.base,
                         call_568384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568384, url, valid)

proc call*(call_568385: Call_ManagementLocksCreateOrUpdateByScope_568377;
          apiVersion: string; lockName: string; parameters: JsonNode; scope: string): Recallable =
  ## managementLocksCreateOrUpdateByScope
  ## Create or update a management lock by scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   lockName: string (required)
  ##           : The name of lock.
  ##   parameters: JObject (required)
  ##             : Create or update management lock parameters.
  ##   scope: string (required)
  ##        : The scope for the lock. When providing a scope for the assignment, use '/subscriptions/{subscriptionId}' for subscriptions, '/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}' for resource groups, and 
  ## '/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePathIfPresent}/{resourceType}/{resourceName}' for resources.
  var path_568386 = newJObject()
  var query_568387 = newJObject()
  var body_568388 = newJObject()
  add(query_568387, "api-version", newJString(apiVersion))
  add(path_568386, "lockName", newJString(lockName))
  if parameters != nil:
    body_568388 = parameters
  add(path_568386, "scope", newJString(scope))
  result = call_568385.call(path_568386, query_568387, nil, nil, body_568388)

var managementLocksCreateOrUpdateByScope* = Call_ManagementLocksCreateOrUpdateByScope_568377(
    name: "managementLocksCreateOrUpdateByScope", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksCreateOrUpdateByScope_568378, base: "",
    url: url_ManagementLocksCreateOrUpdateByScope_568379, schemes: {Scheme.Https})
type
  Call_ManagementLocksGetByScope_568367 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksGetByScope_568369(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "lockName" in path, "`lockName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/locks/"),
               (kind: VariableSegment, value: "lockName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksGetByScope_568368(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a management lock by scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   lockName: JString (required)
  ##           : The name of lock.
  ##   scope: JString (required)
  ##        : The scope for the lock. 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `lockName` field"
  var valid_568370 = path.getOrDefault("lockName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "lockName", valid_568370
  var valid_568371 = path.getOrDefault("scope")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "scope", valid_568371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
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

proc call*(call_568373: Call_ManagementLocksGetByScope_568367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a management lock by scope.
  ## 
  let valid = call_568373.validator(path, query, header, formData, body)
  let scheme = call_568373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568373.url(scheme.get, call_568373.host, call_568373.base,
                         call_568373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568373, url, valid)

proc call*(call_568374: Call_ManagementLocksGetByScope_568367; apiVersion: string;
          lockName: string; scope: string): Recallable =
  ## managementLocksGetByScope
  ## Get a management lock by scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   lockName: string (required)
  ##           : The name of lock.
  ##   scope: string (required)
  ##        : The scope for the lock. 
  var path_568375 = newJObject()
  var query_568376 = newJObject()
  add(query_568376, "api-version", newJString(apiVersion))
  add(path_568375, "lockName", newJString(lockName))
  add(path_568375, "scope", newJString(scope))
  result = call_568374.call(path_568375, query_568376, nil, nil, nil)

var managementLocksGetByScope* = Call_ManagementLocksGetByScope_568367(
    name: "managementLocksGetByScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksGetByScope_568368, base: "",
    url: url_ManagementLocksGetByScope_568369, schemes: {Scheme.Https})
type
  Call_ManagementLocksDeleteByScope_568389 = ref object of OpenApiRestCall_567657
proc url_ManagementLocksDeleteByScope_568391(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "lockName" in path, "`lockName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/locks/"),
               (kind: VariableSegment, value: "lockName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementLocksDeleteByScope_568390(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a management lock by scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   lockName: JString (required)
  ##           : The name of lock.
  ##   scope: JString (required)
  ##        : The scope for the lock. 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `lockName` field"
  var valid_568392 = path.getOrDefault("lockName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "lockName", valid_568392
  var valid_568393 = path.getOrDefault("scope")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "scope", valid_568393
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568394 = query.getOrDefault("api-version")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "api-version", valid_568394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568395: Call_ManagementLocksDeleteByScope_568389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a management lock by scope.
  ## 
  let valid = call_568395.validator(path, query, header, formData, body)
  let scheme = call_568395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568395.url(scheme.get, call_568395.host, call_568395.base,
                         call_568395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568395, url, valid)

proc call*(call_568396: Call_ManagementLocksDeleteByScope_568389;
          apiVersion: string; lockName: string; scope: string): Recallable =
  ## managementLocksDeleteByScope
  ## Delete a management lock by scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   lockName: string (required)
  ##           : The name of lock.
  ##   scope: string (required)
  ##        : The scope for the lock. 
  var path_568397 = newJObject()
  var query_568398 = newJObject()
  add(query_568398, "api-version", newJString(apiVersion))
  add(path_568397, "lockName", newJString(lockName))
  add(path_568397, "scope", newJString(scope))
  result = call_568396.call(path_568397, query_568398, nil, nil, nil)

var managementLocksDeleteByScope* = Call_ManagementLocksDeleteByScope_568389(
    name: "managementLocksDeleteByScope", meth: HttpMethod.HttpDelete,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksDeleteByScope_568390, base: "",
    url: url_ManagementLocksDeleteByScope_568391, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
