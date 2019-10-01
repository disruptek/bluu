
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Microsoft Insights
## version: 2018-04-16
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Monitor client to create/update/delete Scheduled Query Rules
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "monitor-scheduledQueryRule_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ScheduledQueryRulesListBySubscription_567880 = ref object of OpenApiRestCall_567658
proc url_ScheduledQueryRulesListBySubscription_567882(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/scheduledQueryRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduledQueryRulesListBySubscription_567881(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the Log Search rules within a subscription group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568056 = path.getOrDefault("subscriptionId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "subscriptionId", valid_568056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For more information please see https://msdn.microsoft.com/en-us/library/azure/dn931934.aspx
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568057 = query.getOrDefault("api-version")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "api-version", valid_568057
  var valid_568058 = query.getOrDefault("$filter")
  valid_568058 = validateParameter(valid_568058, JString, required = false,
                                 default = nil)
  if valid_568058 != nil:
    section.add "$filter", valid_568058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568081: Call_ScheduledQueryRulesListBySubscription_567880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the Log Search rules within a subscription group.
  ## 
  let valid = call_568081.validator(path, query, header, formData, body)
  let scheme = call_568081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568081.url(scheme.get, call_568081.host, call_568081.base,
                         call_568081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568081, url, valid)

proc call*(call_568152: Call_ScheduledQueryRulesListBySubscription_567880;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## scheduledQueryRulesListBySubscription
  ## List the Log Search rules within a subscription group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see https://msdn.microsoft.com/en-us/library/azure/dn931934.aspx
  var path_568153 = newJObject()
  var query_568155 = newJObject()
  add(query_568155, "api-version", newJString(apiVersion))
  add(path_568153, "subscriptionId", newJString(subscriptionId))
  add(query_568155, "$filter", newJString(Filter))
  result = call_568152.call(path_568153, query_568155, nil, nil, nil)

var scheduledQueryRulesListBySubscription* = Call_ScheduledQueryRulesListBySubscription_567880(
    name: "scheduledQueryRulesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.insights/scheduledQueryRules",
    validator: validate_ScheduledQueryRulesListBySubscription_567881, base: "",
    url: url_ScheduledQueryRulesListBySubscription_567882, schemes: {Scheme.Https})
type
  Call_ScheduledQueryRulesListByResourceGroup_568194 = ref object of OpenApiRestCall_567658
proc url_ScheduledQueryRulesListByResourceGroup_568196(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/scheduledQueryRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduledQueryRulesListByResourceGroup_568195(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the Log Search rules within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568197 = path.getOrDefault("resourceGroupName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "resourceGroupName", valid_568197
  var valid_568198 = path.getOrDefault("subscriptionId")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "subscriptionId", valid_568198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For more information please see https://msdn.microsoft.com/en-us/library/azure/dn931934.aspx
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568199 = query.getOrDefault("api-version")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "api-version", valid_568199
  var valid_568200 = query.getOrDefault("$filter")
  valid_568200 = validateParameter(valid_568200, JString, required = false,
                                 default = nil)
  if valid_568200 != nil:
    section.add "$filter", valid_568200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568201: Call_ScheduledQueryRulesListByResourceGroup_568194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the Log Search rules within a resource group.
  ## 
  let valid = call_568201.validator(path, query, header, formData, body)
  let scheme = call_568201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568201.url(scheme.get, call_568201.host, call_568201.base,
                         call_568201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568201, url, valid)

proc call*(call_568202: Call_ScheduledQueryRulesListByResourceGroup_568194;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## scheduledQueryRulesListByResourceGroup
  ## List the Log Search rules within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see https://msdn.microsoft.com/en-us/library/azure/dn931934.aspx
  var path_568203 = newJObject()
  var query_568204 = newJObject()
  add(path_568203, "resourceGroupName", newJString(resourceGroupName))
  add(query_568204, "api-version", newJString(apiVersion))
  add(path_568203, "subscriptionId", newJString(subscriptionId))
  add(query_568204, "$filter", newJString(Filter))
  result = call_568202.call(path_568203, query_568204, nil, nil, nil)

var scheduledQueryRulesListByResourceGroup* = Call_ScheduledQueryRulesListByResourceGroup_568194(
    name: "scheduledQueryRulesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.insights/scheduledQueryRules",
    validator: validate_ScheduledQueryRulesListByResourceGroup_568195, base: "",
    url: url_ScheduledQueryRulesListByResourceGroup_568196,
    schemes: {Scheme.Https})
type
  Call_ScheduledQueryRulesCreateOrUpdate_568216 = ref object of OpenApiRestCall_567658
proc url_ScheduledQueryRulesCreateOrUpdate_568218(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/scheduledQueryRules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduledQueryRulesCreateOrUpdate_568217(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an log search rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   ruleName: JString (required)
  ##           : The name of the rule.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568219 = path.getOrDefault("resourceGroupName")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "resourceGroupName", valid_568219
  var valid_568220 = path.getOrDefault("ruleName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "ruleName", valid_568220
  var valid_568221 = path.getOrDefault("subscriptionId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "subscriptionId", valid_568221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568222 = query.getOrDefault("api-version")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "api-version", valid_568222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters of the rule to create or update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_ScheduledQueryRulesCreateOrUpdate_568216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an log search rule.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_ScheduledQueryRulesCreateOrUpdate_568216;
          resourceGroupName: string; apiVersion: string; ruleName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## scheduledQueryRulesCreateOrUpdate
  ## Creates or updates an log search rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   ruleName: string (required)
  ##           : The name of the rule.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  ##   parameters: JObject (required)
  ##             : The parameters of the rule to create or update.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  var body_568228 = newJObject()
  add(path_568226, "resourceGroupName", newJString(resourceGroupName))
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "ruleName", newJString(ruleName))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568228 = parameters
  result = call_568225.call(path_568226, query_568227, nil, nil, body_568228)

var scheduledQueryRulesCreateOrUpdate* = Call_ScheduledQueryRulesCreateOrUpdate_568216(
    name: "scheduledQueryRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.insights/scheduledQueryRules/{ruleName}",
    validator: validate_ScheduledQueryRulesCreateOrUpdate_568217, base: "",
    url: url_ScheduledQueryRulesCreateOrUpdate_568218, schemes: {Scheme.Https})
type
  Call_ScheduledQueryRulesGet_568205 = ref object of OpenApiRestCall_567658
proc url_ScheduledQueryRulesGet_568207(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/scheduledQueryRules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduledQueryRulesGet_568206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an Log Search rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   ruleName: JString (required)
  ##           : The name of the rule.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568208 = path.getOrDefault("resourceGroupName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "resourceGroupName", valid_568208
  var valid_568209 = path.getOrDefault("ruleName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "ruleName", valid_568209
  var valid_568210 = path.getOrDefault("subscriptionId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "subscriptionId", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568212: Call_ScheduledQueryRulesGet_568205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an Log Search rule
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_ScheduledQueryRulesGet_568205;
          resourceGroupName: string; apiVersion: string; ruleName: string;
          subscriptionId: string): Recallable =
  ## scheduledQueryRulesGet
  ## Gets an Log Search rule
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   ruleName: string (required)
  ##           : The name of the rule.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  add(path_568214, "resourceGroupName", newJString(resourceGroupName))
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "ruleName", newJString(ruleName))
  add(path_568214, "subscriptionId", newJString(subscriptionId))
  result = call_568213.call(path_568214, query_568215, nil, nil, nil)

var scheduledQueryRulesGet* = Call_ScheduledQueryRulesGet_568205(
    name: "scheduledQueryRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.insights/scheduledQueryRules/{ruleName}",
    validator: validate_ScheduledQueryRulesGet_568206, base: "",
    url: url_ScheduledQueryRulesGet_568207, schemes: {Scheme.Https})
type
  Call_ScheduledQueryRulesUpdate_568240 = ref object of OpenApiRestCall_567658
proc url_ScheduledQueryRulesUpdate_568242(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/scheduledQueryRules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduledQueryRulesUpdate_568241(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update log search Rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   ruleName: JString (required)
  ##           : The name of the rule.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568260 = path.getOrDefault("resourceGroupName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "resourceGroupName", valid_568260
  var valid_568261 = path.getOrDefault("ruleName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "ruleName", valid_568261
  var valid_568262 = path.getOrDefault("subscriptionId")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "subscriptionId", valid_568262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568263 = query.getOrDefault("api-version")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "api-version", valid_568263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters of the rule to update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568265: Call_ScheduledQueryRulesUpdate_568240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update log search Rule.
  ## 
  let valid = call_568265.validator(path, query, header, formData, body)
  let scheme = call_568265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568265.url(scheme.get, call_568265.host, call_568265.base,
                         call_568265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568265, url, valid)

proc call*(call_568266: Call_ScheduledQueryRulesUpdate_568240;
          resourceGroupName: string; apiVersion: string; ruleName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## scheduledQueryRulesUpdate
  ## Update log search Rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   ruleName: string (required)
  ##           : The name of the rule.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  ##   parameters: JObject (required)
  ##             : The parameters of the rule to update.
  var path_568267 = newJObject()
  var query_568268 = newJObject()
  var body_568269 = newJObject()
  add(path_568267, "resourceGroupName", newJString(resourceGroupName))
  add(query_568268, "api-version", newJString(apiVersion))
  add(path_568267, "ruleName", newJString(ruleName))
  add(path_568267, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568269 = parameters
  result = call_568266.call(path_568267, query_568268, nil, nil, body_568269)

var scheduledQueryRulesUpdate* = Call_ScheduledQueryRulesUpdate_568240(
    name: "scheduledQueryRulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.insights/scheduledQueryRules/{ruleName}",
    validator: validate_ScheduledQueryRulesUpdate_568241, base: "",
    url: url_ScheduledQueryRulesUpdate_568242, schemes: {Scheme.Https})
type
  Call_ScheduledQueryRulesDelete_568229 = ref object of OpenApiRestCall_567658
proc url_ScheduledQueryRulesDelete_568231(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/scheduledQueryRules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduledQueryRulesDelete_568230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Log Search rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   ruleName: JString (required)
  ##           : The name of the rule.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568232 = path.getOrDefault("resourceGroupName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "resourceGroupName", valid_568232
  var valid_568233 = path.getOrDefault("ruleName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "ruleName", valid_568233
  var valid_568234 = path.getOrDefault("subscriptionId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "subscriptionId", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568236: Call_ScheduledQueryRulesDelete_568229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Log Search rule
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_ScheduledQueryRulesDelete_568229;
          resourceGroupName: string; apiVersion: string; ruleName: string;
          subscriptionId: string): Recallable =
  ## scheduledQueryRulesDelete
  ## Deletes a Log Search rule
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   ruleName: string (required)
  ##           : The name of the rule.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  add(path_568238, "resourceGroupName", newJString(resourceGroupName))
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "ruleName", newJString(ruleName))
  add(path_568238, "subscriptionId", newJString(subscriptionId))
  result = call_568237.call(path_568238, query_568239, nil, nil, nil)

var scheduledQueryRulesDelete* = Call_ScheduledQueryRulesDelete_568229(
    name: "scheduledQueryRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/microsoft.insights/scheduledQueryRules/{ruleName}",
    validator: validate_ScheduledQueryRulesDelete_568230, base: "",
    url: url_ScheduledQueryRulesDelete_568231, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
