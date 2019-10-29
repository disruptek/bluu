
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ManagementLockClient
## version: 2015-01-01
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "resources-locks"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManagementLocksListAtSubscriptionLevel_563777 = ref object of OpenApiRestCall_563555
proc url_ManagementLocksListAtSubscriptionLevel_563779(protocol: Scheme;
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

proc validate_ManagementLocksListAtSubscriptionLevel_563778(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the management locks of a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563956 = query.getOrDefault("api-version")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "api-version", valid_563956
  var valid_563957 = query.getOrDefault("$filter")
  valid_563957 = validateParameter(valid_563957, JString, required = false,
                                 default = nil)
  if valid_563957 != nil:
    section.add "$filter", valid_563957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563980: Call_ManagementLocksListAtSubscriptionLevel_563777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the management locks of a subscription.
  ## 
  let valid = call_563980.validator(path, query, header, formData, body)
  let scheme = call_563980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563980.url(scheme.get, call_563980.host, call_563980.base,
                         call_563980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563980, url, valid)

proc call*(call_564051: Call_ManagementLocksListAtSubscriptionLevel_563777;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## managementLocksListAtSubscriptionLevel
  ## Gets all the management locks of a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_564052 = newJObject()
  var query_564054 = newJObject()
  add(query_564054, "api-version", newJString(apiVersion))
  add(path_564052, "subscriptionId", newJString(subscriptionId))
  add(query_564054, "$filter", newJString(Filter))
  result = call_564051.call(path_564052, query_564054, nil, nil, nil)

var managementLocksListAtSubscriptionLevel* = Call_ManagementLocksListAtSubscriptionLevel_563777(
    name: "managementLocksListAtSubscriptionLevel", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/locks",
    validator: validate_ManagementLocksListAtSubscriptionLevel_563778, base: "",
    url: url_ManagementLocksListAtSubscriptionLevel_563779,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksCreateOrUpdateAtSubscriptionLevel_564103 = ref object of OpenApiRestCall_563555
proc url_ManagementLocksCreateOrUpdateAtSubscriptionLevel_564105(
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

proc validate_ManagementLocksCreateOrUpdateAtSubscriptionLevel_564104(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update a management lock at the subscription level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   lockName: JString (required)
  ##           : The name of lock.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  var valid_564124 = path.getOrDefault("lockName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "lockName", valid_564124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564125 = query.getOrDefault("api-version")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "api-version", valid_564125
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

proc call*(call_564127: Call_ManagementLocksCreateOrUpdateAtSubscriptionLevel_564103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a management lock at the subscription level.
  ## 
  let valid = call_564127.validator(path, query, header, formData, body)
  let scheme = call_564127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564127.url(scheme.get, call_564127.host, call_564127.base,
                         call_564127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564127, url, valid)

proc call*(call_564128: Call_ManagementLocksCreateOrUpdateAtSubscriptionLevel_564103;
          apiVersion: string; subscriptionId: string; lockName: string;
          parameters: JsonNode): Recallable =
  ## managementLocksCreateOrUpdateAtSubscriptionLevel
  ## Create or update a management lock at the subscription level.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   lockName: string (required)
  ##           : The name of lock.
  ##   parameters: JObject (required)
  ##             : The management lock parameters.
  var path_564129 = newJObject()
  var query_564130 = newJObject()
  var body_564131 = newJObject()
  add(query_564130, "api-version", newJString(apiVersion))
  add(path_564129, "subscriptionId", newJString(subscriptionId))
  add(path_564129, "lockName", newJString(lockName))
  if parameters != nil:
    body_564131 = parameters
  result = call_564128.call(path_564129, query_564130, nil, nil, body_564131)

var managementLocksCreateOrUpdateAtSubscriptionLevel* = Call_ManagementLocksCreateOrUpdateAtSubscriptionLevel_564103(
    name: "managementLocksCreateOrUpdateAtSubscriptionLevel",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksCreateOrUpdateAtSubscriptionLevel_564104,
    base: "", url: url_ManagementLocksCreateOrUpdateAtSubscriptionLevel_564105,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksGet_564093 = ref object of OpenApiRestCall_563555
proc url_ManagementLocksGet_564095(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ManagementLocksGet_564094(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the management lock of a scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   lockName: JString (required)
  ##           : Name of the management lock.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564096 = path.getOrDefault("subscriptionId")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "subscriptionId", valid_564096
  var valid_564097 = path.getOrDefault("lockName")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "lockName", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_ManagementLocksGet_564093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the management lock of a scope.
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_ManagementLocksGet_564093; apiVersion: string;
          subscriptionId: string; lockName: string): Recallable =
  ## managementLocksGet
  ## Gets the management lock of a scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   lockName: string (required)
  ##           : Name of the management lock.
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "subscriptionId", newJString(subscriptionId))
  add(path_564101, "lockName", newJString(lockName))
  result = call_564100.call(path_564101, query_564102, nil, nil, nil)

var managementLocksGet* = Call_ManagementLocksGet_564093(
    name: "managementLocksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksGet_564094, base: "",
    url: url_ManagementLocksGet_564095, schemes: {Scheme.Https})
type
  Call_ManagementLocksDeleteAtSubscriptionLevel_564132 = ref object of OpenApiRestCall_563555
proc url_ManagementLocksDeleteAtSubscriptionLevel_564134(protocol: Scheme;
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

proc validate_ManagementLocksDeleteAtSubscriptionLevel_564133(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the management lock of a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   lockName: JString (required)
  ##           : The name of lock.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564135 = path.getOrDefault("subscriptionId")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "subscriptionId", valid_564135
  var valid_564136 = path.getOrDefault("lockName")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "lockName", valid_564136
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564137 = query.getOrDefault("api-version")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "api-version", valid_564137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564138: Call_ManagementLocksDeleteAtSubscriptionLevel_564132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the management lock of a subscription.
  ## 
  let valid = call_564138.validator(path, query, header, formData, body)
  let scheme = call_564138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564138.url(scheme.get, call_564138.host, call_564138.base,
                         call_564138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564138, url, valid)

proc call*(call_564139: Call_ManagementLocksDeleteAtSubscriptionLevel_564132;
          apiVersion: string; subscriptionId: string; lockName: string): Recallable =
  ## managementLocksDeleteAtSubscriptionLevel
  ## Deletes the management lock of a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   lockName: string (required)
  ##           : The name of lock.
  var path_564140 = newJObject()
  var query_564141 = newJObject()
  add(query_564141, "api-version", newJString(apiVersion))
  add(path_564140, "subscriptionId", newJString(subscriptionId))
  add(path_564140, "lockName", newJString(lockName))
  result = call_564139.call(path_564140, query_564141, nil, nil, nil)

var managementLocksDeleteAtSubscriptionLevel* = Call_ManagementLocksDeleteAtSubscriptionLevel_564132(
    name: "managementLocksDeleteAtSubscriptionLevel", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksDeleteAtSubscriptionLevel_564133, base: "",
    url: url_ManagementLocksDeleteAtSubscriptionLevel_564134,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksListAtResourceGroupLevel_564142 = ref object of OpenApiRestCall_563555
proc url_ManagementLocksListAtResourceGroupLevel_564144(protocol: Scheme;
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

proc validate_ManagementLocksListAtResourceGroupLevel_564143(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the management locks of a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564145 = path.getOrDefault("subscriptionId")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "subscriptionId", valid_564145
  var valid_564146 = path.getOrDefault("resourceGroupName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "resourceGroupName", valid_564146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564147 = query.getOrDefault("api-version")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "api-version", valid_564147
  var valid_564148 = query.getOrDefault("$filter")
  valid_564148 = validateParameter(valid_564148, JString, required = false,
                                 default = nil)
  if valid_564148 != nil:
    section.add "$filter", valid_564148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564149: Call_ManagementLocksListAtResourceGroupLevel_564142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the management locks of a resource group.
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_ManagementLocksListAtResourceGroupLevel_564142;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Filter: string = ""): Recallable =
  ## managementLocksListAtResourceGroupLevel
  ## Gets all the management locks of a resource group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_564151 = newJObject()
  var query_564152 = newJObject()
  add(query_564152, "api-version", newJString(apiVersion))
  add(path_564151, "subscriptionId", newJString(subscriptionId))
  add(path_564151, "resourceGroupName", newJString(resourceGroupName))
  add(query_564152, "$filter", newJString(Filter))
  result = call_564150.call(path_564151, query_564152, nil, nil, nil)

var managementLocksListAtResourceGroupLevel* = Call_ManagementLocksListAtResourceGroupLevel_564142(
    name: "managementLocksListAtResourceGroupLevel", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/locks",
    validator: validate_ManagementLocksListAtResourceGroupLevel_564143, base: "",
    url: url_ManagementLocksListAtResourceGroupLevel_564144,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksCreateOrUpdateAtResourceGroupLevel_564164 = ref object of OpenApiRestCall_563555
proc url_ManagementLocksCreateOrUpdateAtResourceGroupLevel_564166(
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

proc validate_ManagementLocksCreateOrUpdateAtResourceGroupLevel_564165(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create or update a management lock at the resource group level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   lockName: JString (required)
  ##           : The lock name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564167 = path.getOrDefault("subscriptionId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subscriptionId", valid_564167
  var valid_564168 = path.getOrDefault("resourceGroupName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "resourceGroupName", valid_564168
  var valid_564169 = path.getOrDefault("lockName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "lockName", valid_564169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564170 = query.getOrDefault("api-version")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "api-version", valid_564170
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

proc call*(call_564172: Call_ManagementLocksCreateOrUpdateAtResourceGroupLevel_564164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a management lock at the resource group level.
  ## 
  let valid = call_564172.validator(path, query, header, formData, body)
  let scheme = call_564172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564172.url(scheme.get, call_564172.host, call_564172.base,
                         call_564172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564172, url, valid)

proc call*(call_564173: Call_ManagementLocksCreateOrUpdateAtResourceGroupLevel_564164;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          lockName: string; parameters: JsonNode): Recallable =
  ## managementLocksCreateOrUpdateAtResourceGroupLevel
  ## Create or update a management lock at the resource group level.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   lockName: string (required)
  ##           : The lock name.
  ##   parameters: JObject (required)
  ##             : The management lock parameters.
  var path_564174 = newJObject()
  var query_564175 = newJObject()
  var body_564176 = newJObject()
  add(query_564175, "api-version", newJString(apiVersion))
  add(path_564174, "subscriptionId", newJString(subscriptionId))
  add(path_564174, "resourceGroupName", newJString(resourceGroupName))
  add(path_564174, "lockName", newJString(lockName))
  if parameters != nil:
    body_564176 = parameters
  result = call_564173.call(path_564174, query_564175, nil, nil, body_564176)

var managementLocksCreateOrUpdateAtResourceGroupLevel* = Call_ManagementLocksCreateOrUpdateAtResourceGroupLevel_564164(
    name: "managementLocksCreateOrUpdateAtResourceGroupLevel",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksCreateOrUpdateAtResourceGroupLevel_564165,
    base: "", url: url_ManagementLocksCreateOrUpdateAtResourceGroupLevel_564166,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksGetAtResourceGroupLevel_564153 = ref object of OpenApiRestCall_563555
proc url_ManagementLocksGetAtResourceGroupLevel_564155(protocol: Scheme;
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

proc validate_ManagementLocksGetAtResourceGroupLevel_564154(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a management lock at the resource group level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   lockName: JString (required)
  ##           : The lock name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564156 = path.getOrDefault("subscriptionId")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "subscriptionId", valid_564156
  var valid_564157 = path.getOrDefault("resourceGroupName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "resourceGroupName", valid_564157
  var valid_564158 = path.getOrDefault("lockName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "lockName", valid_564158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564159 = query.getOrDefault("api-version")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "api-version", valid_564159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564160: Call_ManagementLocksGetAtResourceGroupLevel_564153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a management lock at the resource group level.
  ## 
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_ManagementLocksGetAtResourceGroupLevel_564153;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          lockName: string): Recallable =
  ## managementLocksGetAtResourceGroupLevel
  ## Gets a management lock at the resource group level.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   lockName: string (required)
  ##           : The lock name.
  var path_564162 = newJObject()
  var query_564163 = newJObject()
  add(query_564163, "api-version", newJString(apiVersion))
  add(path_564162, "subscriptionId", newJString(subscriptionId))
  add(path_564162, "resourceGroupName", newJString(resourceGroupName))
  add(path_564162, "lockName", newJString(lockName))
  result = call_564161.call(path_564162, query_564163, nil, nil, nil)

var managementLocksGetAtResourceGroupLevel* = Call_ManagementLocksGetAtResourceGroupLevel_564153(
    name: "managementLocksGetAtResourceGroupLevel", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksGetAtResourceGroupLevel_564154, base: "",
    url: url_ManagementLocksGetAtResourceGroupLevel_564155,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksDeleteAtResourceGroupLevel_564177 = ref object of OpenApiRestCall_563555
proc url_ManagementLocksDeleteAtResourceGroupLevel_564179(protocol: Scheme;
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

proc validate_ManagementLocksDeleteAtResourceGroupLevel_564178(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the management lock of a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   lockName: JString (required)
  ##           : The name of lock.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564180 = path.getOrDefault("subscriptionId")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "subscriptionId", valid_564180
  var valid_564181 = path.getOrDefault("resourceGroupName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "resourceGroupName", valid_564181
  var valid_564182 = path.getOrDefault("lockName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "lockName", valid_564182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564183 = query.getOrDefault("api-version")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "api-version", valid_564183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_ManagementLocksDeleteAtResourceGroupLevel_564177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the management lock of a resource group.
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_ManagementLocksDeleteAtResourceGroupLevel_564177;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          lockName: string): Recallable =
  ## managementLocksDeleteAtResourceGroupLevel
  ## Deletes the management lock of a resource group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   lockName: string (required)
  ##           : The name of lock.
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  add(query_564187, "api-version", newJString(apiVersion))
  add(path_564186, "subscriptionId", newJString(subscriptionId))
  add(path_564186, "resourceGroupName", newJString(resourceGroupName))
  add(path_564186, "lockName", newJString(lockName))
  result = call_564185.call(path_564186, query_564187, nil, nil, nil)

var managementLocksDeleteAtResourceGroupLevel* = Call_ManagementLocksDeleteAtResourceGroupLevel_564177(
    name: "managementLocksDeleteAtResourceGroupLevel",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksDeleteAtResourceGroupLevel_564178,
    base: "", url: url_ManagementLocksDeleteAtResourceGroupLevel_564179,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksListAtResourceLevel_564188 = ref object of OpenApiRestCall_563555
proc url_ManagementLocksListAtResourceLevel_564190(protocol: Scheme; host: string;
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

proc validate_ManagementLocksListAtResourceLevel_564189(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the management locks of a resource or any level below resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Resource identity.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   parentResourcePath: JString (required)
  ##                     : Resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564191 = path.getOrDefault("resourceType")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "resourceType", valid_564191
  var valid_564192 = path.getOrDefault("resourceProviderNamespace")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "resourceProviderNamespace", valid_564192
  var valid_564193 = path.getOrDefault("subscriptionId")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "subscriptionId", valid_564193
  var valid_564194 = path.getOrDefault("parentResourcePath")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "parentResourcePath", valid_564194
  var valid_564195 = path.getOrDefault("resourceGroupName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "resourceGroupName", valid_564195
  var valid_564196 = path.getOrDefault("resourceName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "resourceName", valid_564196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564197 = query.getOrDefault("api-version")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "api-version", valid_564197
  var valid_564198 = query.getOrDefault("$filter")
  valid_564198 = validateParameter(valid_564198, JString, required = false,
                                 default = nil)
  if valid_564198 != nil:
    section.add "$filter", valid_564198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564199: Call_ManagementLocksListAtResourceLevel_564188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the management locks of a resource or any level below resource.
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_ManagementLocksListAtResourceLevel_564188;
          apiVersion: string; resourceType: string;
          resourceProviderNamespace: string; subscriptionId: string;
          parentResourcePath: string; resourceGroupName: string;
          resourceName: string; Filter: string = ""): Recallable =
  ## managementLocksListAtResourceLevel
  ## Gets all the management locks of a resource or any level below resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceType: string (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parentResourcePath: string (required)
  ##                     : Resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   resourceName: string (required)
  ##               : Resource identity.
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  add(query_564202, "api-version", newJString(apiVersion))
  add(path_564201, "resourceType", newJString(resourceType))
  add(path_564201, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564201, "subscriptionId", newJString(subscriptionId))
  add(path_564201, "parentResourcePath", newJString(parentResourcePath))
  add(path_564201, "resourceGroupName", newJString(resourceGroupName))
  add(query_564202, "$filter", newJString(Filter))
  add(path_564201, "resourceName", newJString(resourceName))
  result = call_564200.call(path_564201, query_564202, nil, nil, nil)

var managementLocksListAtResourceLevel* = Call_ManagementLocksListAtResourceLevel_564188(
    name: "managementLocksListAtResourceLevel", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/locks",
    validator: validate_ManagementLocksListAtResourceLevel_564189, base: "",
    url: url_ManagementLocksListAtResourceLevel_564190, schemes: {Scheme.Https})
type
  Call_ManagementLocksCreateOrUpdateAtResourceLevel_564203 = ref object of OpenApiRestCall_563555
proc url_ManagementLocksCreateOrUpdateAtResourceLevel_564205(protocol: Scheme;
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

proc validate_ManagementLocksCreateOrUpdateAtResourceLevel_564204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a management lock at the resource level or any level below resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Resource identity.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   parentResourcePath: JString (required)
  ##                     : Resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. 
  ##   resourceName: JString (required)
  ##               : Resource identity.
  ##   lockName: JString (required)
  ##           : The name of lock.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564206 = path.getOrDefault("resourceType")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "resourceType", valid_564206
  var valid_564207 = path.getOrDefault("resourceProviderNamespace")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "resourceProviderNamespace", valid_564207
  var valid_564208 = path.getOrDefault("subscriptionId")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "subscriptionId", valid_564208
  var valid_564209 = path.getOrDefault("parentResourcePath")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "parentResourcePath", valid_564209
  var valid_564210 = path.getOrDefault("resourceGroupName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "resourceGroupName", valid_564210
  var valid_564211 = path.getOrDefault("resourceName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "resourceName", valid_564211
  var valid_564212 = path.getOrDefault("lockName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "lockName", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "api-version", valid_564213
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

proc call*(call_564215: Call_ManagementLocksCreateOrUpdateAtResourceLevel_564203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a management lock at the resource level or any level below resource.
  ## 
  let valid = call_564215.validator(path, query, header, formData, body)
  let scheme = call_564215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564215.url(scheme.get, call_564215.host, call_564215.base,
                         call_564215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564215, url, valid)

proc call*(call_564216: Call_ManagementLocksCreateOrUpdateAtResourceLevel_564203;
          apiVersion: string; resourceType: string;
          resourceProviderNamespace: string; subscriptionId: string;
          parentResourcePath: string; resourceGroupName: string;
          resourceName: string; lockName: string; parameters: JsonNode): Recallable =
  ## managementLocksCreateOrUpdateAtResourceLevel
  ## Create or update a management lock at the resource level or any level below resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceType: string (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parentResourcePath: string (required)
  ##                     : Resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. 
  ##   resourceName: string (required)
  ##               : Resource identity.
  ##   lockName: string (required)
  ##           : The name of lock.
  ##   parameters: JObject (required)
  ##             : Create or update management lock parameters.
  var path_564217 = newJObject()
  var query_564218 = newJObject()
  var body_564219 = newJObject()
  add(query_564218, "api-version", newJString(apiVersion))
  add(path_564217, "resourceType", newJString(resourceType))
  add(path_564217, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564217, "subscriptionId", newJString(subscriptionId))
  add(path_564217, "parentResourcePath", newJString(parentResourcePath))
  add(path_564217, "resourceGroupName", newJString(resourceGroupName))
  add(path_564217, "resourceName", newJString(resourceName))
  add(path_564217, "lockName", newJString(lockName))
  if parameters != nil:
    body_564219 = parameters
  result = call_564216.call(path_564217, query_564218, nil, nil, body_564219)

var managementLocksCreateOrUpdateAtResourceLevel* = Call_ManagementLocksCreateOrUpdateAtResourceLevel_564203(
    name: "managementLocksCreateOrUpdateAtResourceLevel",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksCreateOrUpdateAtResourceLevel_564204,
    base: "", url: url_ManagementLocksCreateOrUpdateAtResourceLevel_564205,
    schemes: {Scheme.Https})
type
  Call_ManagementLocksDeleteAtResourceLevel_564220 = ref object of OpenApiRestCall_563555
proc url_ManagementLocksDeleteAtResourceLevel_564222(protocol: Scheme;
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

proc validate_ManagementLocksDeleteAtResourceLevel_564221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the management lock of a resource or any level below resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Resource identity.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   parentResourcePath: JString (required)
  ##                     : Resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. 
  ##   resourceName: JString (required)
  ##               : Resource identity.
  ##   lockName: JString (required)
  ##           : The name of lock.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564223 = path.getOrDefault("resourceType")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "resourceType", valid_564223
  var valid_564224 = path.getOrDefault("resourceProviderNamespace")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceProviderNamespace", valid_564224
  var valid_564225 = path.getOrDefault("subscriptionId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "subscriptionId", valid_564225
  var valid_564226 = path.getOrDefault("parentResourcePath")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "parentResourcePath", valid_564226
  var valid_564227 = path.getOrDefault("resourceGroupName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "resourceGroupName", valid_564227
  var valid_564228 = path.getOrDefault("resourceName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "resourceName", valid_564228
  var valid_564229 = path.getOrDefault("lockName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "lockName", valid_564229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564230 = query.getOrDefault("api-version")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "api-version", valid_564230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564231: Call_ManagementLocksDeleteAtResourceLevel_564220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the management lock of a resource or any level below resource.
  ## 
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_ManagementLocksDeleteAtResourceLevel_564220;
          apiVersion: string; resourceType: string;
          resourceProviderNamespace: string; subscriptionId: string;
          parentResourcePath: string; resourceGroupName: string;
          resourceName: string; lockName: string): Recallable =
  ## managementLocksDeleteAtResourceLevel
  ## Deletes the management lock of a resource or any level below resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceType: string (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parentResourcePath: string (required)
  ##                     : Resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. 
  ##   resourceName: string (required)
  ##               : Resource identity.
  ##   lockName: string (required)
  ##           : The name of lock.
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  add(query_564234, "api-version", newJString(apiVersion))
  add(path_564233, "resourceType", newJString(resourceType))
  add(path_564233, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564233, "subscriptionId", newJString(subscriptionId))
  add(path_564233, "parentResourcePath", newJString(parentResourcePath))
  add(path_564233, "resourceGroupName", newJString(resourceGroupName))
  add(path_564233, "resourceName", newJString(resourceName))
  add(path_564233, "lockName", newJString(lockName))
  result = call_564232.call(path_564233, query_564234, nil, nil, nil)

var managementLocksDeleteAtResourceLevel* = Call_ManagementLocksDeleteAtResourceLevel_564220(
    name: "managementLocksDeleteAtResourceLevel", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/locks/{lockName}",
    validator: validate_ManagementLocksDeleteAtResourceLevel_564221, base: "",
    url: url_ManagementLocksDeleteAtResourceLevel_564222, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
