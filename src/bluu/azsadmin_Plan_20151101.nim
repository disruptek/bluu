
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SubscriptionsManagementClient
## version: 2015-11-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Subscriptions Management Client.
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
  macServiceName = "azsadmin-Plan"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlansListAll_574680 = ref object of OpenApiRestCall_574458
proc url_PlansListAll_574682(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/plans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlansListAll_574681(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List all plans across all subscriptions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574842 = path.getOrDefault("subscriptionId")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "subscriptionId", valid_574842
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574856 = query.getOrDefault("api-version")
  valid_574856 = validateParameter(valid_574856, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574856 != nil:
    section.add "api-version", valid_574856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574883: Call_PlansListAll_574680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all plans across all subscriptions.
  ## 
  let valid = call_574883.validator(path, query, header, formData, body)
  let scheme = call_574883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574883.url(scheme.get, call_574883.host, call_574883.base,
                         call_574883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574883, url, valid)

proc call*(call_574954: Call_PlansListAll_574680; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## plansListAll
  ## List all plans across all subscriptions.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_574955 = newJObject()
  var query_574957 = newJObject()
  add(query_574957, "api-version", newJString(apiVersion))
  add(path_574955, "subscriptionId", newJString(subscriptionId))
  result = call_574954.call(path_574955, query_574957, nil, nil, nil)

var plansListAll* = Call_PlansListAll_574680(name: "plansListAll",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/plans",
    validator: validate_PlansListAll_574681, base: "", url: url_PlansListAll_574682,
    schemes: {Scheme.Https})
type
  Call_PlansList_574996 = ref object of OpenApiRestCall_574458
proc url_PlansList_574998(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Subscriptions.Admin/plans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlansList_574997(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of plans under a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574999 = path.getOrDefault("resourceGroupName")
  valid_574999 = validateParameter(valid_574999, JString, required = true,
                                 default = nil)
  if valid_574999 != nil:
    section.add "resourceGroupName", valid_574999
  var valid_575000 = path.getOrDefault("subscriptionId")
  valid_575000 = validateParameter(valid_575000, JString, required = true,
                                 default = nil)
  if valid_575000 != nil:
    section.add "subscriptionId", valid_575000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575001 = query.getOrDefault("api-version")
  valid_575001 = validateParameter(valid_575001, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575001 != nil:
    section.add "api-version", valid_575001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575002: Call_PlansList_574996; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of plans under a resource group.
  ## 
  let valid = call_575002.validator(path, query, header, formData, body)
  let scheme = call_575002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575002.url(scheme.get, call_575002.host, call_575002.base,
                         call_575002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575002, url, valid)

proc call*(call_575003: Call_PlansList_574996; resourceGroupName: string;
          subscriptionId: string; apiVersion: string = "2015-11-01"): Recallable =
  ## plansList
  ## Get the list of plans under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_575004 = newJObject()
  var query_575005 = newJObject()
  add(path_575004, "resourceGroupName", newJString(resourceGroupName))
  add(query_575005, "api-version", newJString(apiVersion))
  add(path_575004, "subscriptionId", newJString(subscriptionId))
  result = call_575003.call(path_575004, query_575005, nil, nil, nil)

var plansList* = Call_PlansList_574996(name: "plansList", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/plans",
                                    validator: validate_PlansList_574997,
                                    base: "", url: url_PlansList_574998,
                                    schemes: {Scheme.Https})
type
  Call_PlansCreateOrUpdate_575017 = ref object of OpenApiRestCall_574458
proc url_PlansCreateOrUpdate_575019(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "plan" in path, "`plan` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/plans/"),
               (kind: VariableSegment, value: "plan")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlansCreateOrUpdate_575018(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or update the plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   plan: JString (required)
  ##       : Name of the plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575029 = path.getOrDefault("resourceGroupName")
  valid_575029 = validateParameter(valid_575029, JString, required = true,
                                 default = nil)
  if valid_575029 != nil:
    section.add "resourceGroupName", valid_575029
  var valid_575030 = path.getOrDefault("subscriptionId")
  valid_575030 = validateParameter(valid_575030, JString, required = true,
                                 default = nil)
  if valid_575030 != nil:
    section.add "subscriptionId", valid_575030
  var valid_575031 = path.getOrDefault("plan")
  valid_575031 = validateParameter(valid_575031, JString, required = true,
                                 default = nil)
  if valid_575031 != nil:
    section.add "plan", valid_575031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575032 = query.getOrDefault("api-version")
  valid_575032 = validateParameter(valid_575032, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575032 != nil:
    section.add "api-version", valid_575032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   newPlan: JObject (required)
  ##          : New plan.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575034: Call_PlansCreateOrUpdate_575017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the plan.
  ## 
  let valid = call_575034.validator(path, query, header, formData, body)
  let scheme = call_575034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575034.url(scheme.get, call_575034.host, call_575034.base,
                         call_575034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575034, url, valid)

proc call*(call_575035: Call_PlansCreateOrUpdate_575017; resourceGroupName: string;
          subscriptionId: string; plan: string; newPlan: JsonNode;
          apiVersion: string = "2015-11-01"): Recallable =
  ## plansCreateOrUpdate
  ## Create or update the plan.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   plan: string (required)
  ##       : Name of the plan.
  ##   newPlan: JObject (required)
  ##          : New plan.
  var path_575036 = newJObject()
  var query_575037 = newJObject()
  var body_575038 = newJObject()
  add(path_575036, "resourceGroupName", newJString(resourceGroupName))
  add(query_575037, "api-version", newJString(apiVersion))
  add(path_575036, "subscriptionId", newJString(subscriptionId))
  add(path_575036, "plan", newJString(plan))
  if newPlan != nil:
    body_575038 = newPlan
  result = call_575035.call(path_575036, query_575037, nil, nil, body_575038)

var plansCreateOrUpdate* = Call_PlansCreateOrUpdate_575017(
    name: "plansCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/plans/{plan}",
    validator: validate_PlansCreateOrUpdate_575018, base: "",
    url: url_PlansCreateOrUpdate_575019, schemes: {Scheme.Https})
type
  Call_PlansGet_575006 = ref object of OpenApiRestCall_574458
proc url_PlansGet_575008(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "plan" in path, "`plan` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/plans/"),
               (kind: VariableSegment, value: "plan")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlansGet_575007(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   plan: JString (required)
  ##       : Name of the plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575009 = path.getOrDefault("resourceGroupName")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = nil)
  if valid_575009 != nil:
    section.add "resourceGroupName", valid_575009
  var valid_575010 = path.getOrDefault("subscriptionId")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "subscriptionId", valid_575010
  var valid_575011 = path.getOrDefault("plan")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "plan", valid_575011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575012 = query.getOrDefault("api-version")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575012 != nil:
    section.add "api-version", valid_575012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575013: Call_PlansGet_575006; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified plan.
  ## 
  let valid = call_575013.validator(path, query, header, formData, body)
  let scheme = call_575013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575013.url(scheme.get, call_575013.host, call_575013.base,
                         call_575013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575013, url, valid)

proc call*(call_575014: Call_PlansGet_575006; resourceGroupName: string;
          subscriptionId: string; plan: string; apiVersion: string = "2015-11-01"): Recallable =
  ## plansGet
  ## Get the specified plan.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   plan: string (required)
  ##       : Name of the plan.
  var path_575015 = newJObject()
  var query_575016 = newJObject()
  add(path_575015, "resourceGroupName", newJString(resourceGroupName))
  add(query_575016, "api-version", newJString(apiVersion))
  add(path_575015, "subscriptionId", newJString(subscriptionId))
  add(path_575015, "plan", newJString(plan))
  result = call_575014.call(path_575015, query_575016, nil, nil, nil)

var plansGet* = Call_PlansGet_575006(name: "plansGet", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/plans/{plan}",
                                  validator: validate_PlansGet_575007, base: "",
                                  url: url_PlansGet_575008,
                                  schemes: {Scheme.Https})
type
  Call_PlansDelete_575039 = ref object of OpenApiRestCall_574458
proc url_PlansDelete_575041(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "plan" in path, "`plan` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/plans/"),
               (kind: VariableSegment, value: "plan")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlansDelete_575040(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   plan: JString (required)
  ##       : Name of the plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575042 = path.getOrDefault("resourceGroupName")
  valid_575042 = validateParameter(valid_575042, JString, required = true,
                                 default = nil)
  if valid_575042 != nil:
    section.add "resourceGroupName", valid_575042
  var valid_575043 = path.getOrDefault("subscriptionId")
  valid_575043 = validateParameter(valid_575043, JString, required = true,
                                 default = nil)
  if valid_575043 != nil:
    section.add "subscriptionId", valid_575043
  var valid_575044 = path.getOrDefault("plan")
  valid_575044 = validateParameter(valid_575044, JString, required = true,
                                 default = nil)
  if valid_575044 != nil:
    section.add "plan", valid_575044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575045 = query.getOrDefault("api-version")
  valid_575045 = validateParameter(valid_575045, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575045 != nil:
    section.add "api-version", valid_575045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575046: Call_PlansDelete_575039; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified plan.
  ## 
  let valid = call_575046.validator(path, query, header, formData, body)
  let scheme = call_575046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575046.url(scheme.get, call_575046.host, call_575046.base,
                         call_575046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575046, url, valid)

proc call*(call_575047: Call_PlansDelete_575039; resourceGroupName: string;
          subscriptionId: string; plan: string; apiVersion: string = "2015-11-01"): Recallable =
  ## plansDelete
  ## Delete the specified plan.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   plan: string (required)
  ##       : Name of the plan.
  var path_575048 = newJObject()
  var query_575049 = newJObject()
  add(path_575048, "resourceGroupName", newJString(resourceGroupName))
  add(query_575049, "api-version", newJString(apiVersion))
  add(path_575048, "subscriptionId", newJString(subscriptionId))
  add(path_575048, "plan", newJString(plan))
  result = call_575047.call(path_575048, query_575049, nil, nil, nil)

var plansDelete* = Call_PlansDelete_575039(name: "plansDelete",
                                        meth: HttpMethod.HttpDelete, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/plans/{plan}",
                                        validator: validate_PlansDelete_575040,
                                        base: "", url: url_PlansDelete_575041,
                                        schemes: {Scheme.Https})
type
  Call_PlansListMetricDefinitions_575050 = ref object of OpenApiRestCall_574458
proc url_PlansListMetricDefinitions_575052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "plan" in path, "`plan` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/plans/"),
               (kind: VariableSegment, value: "plan"),
               (kind: ConstantSegment, value: "/metricDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlansListMetricDefinitions_575051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the metric definitions of the specified plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   plan: JString (required)
  ##       : Name of the plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575053 = path.getOrDefault("resourceGroupName")
  valid_575053 = validateParameter(valid_575053, JString, required = true,
                                 default = nil)
  if valid_575053 != nil:
    section.add "resourceGroupName", valid_575053
  var valid_575054 = path.getOrDefault("subscriptionId")
  valid_575054 = validateParameter(valid_575054, JString, required = true,
                                 default = nil)
  if valid_575054 != nil:
    section.add "subscriptionId", valid_575054
  var valid_575055 = path.getOrDefault("plan")
  valid_575055 = validateParameter(valid_575055, JString, required = true,
                                 default = nil)
  if valid_575055 != nil:
    section.add "plan", valid_575055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575056 = query.getOrDefault("api-version")
  valid_575056 = validateParameter(valid_575056, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575056 != nil:
    section.add "api-version", valid_575056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575057: Call_PlansListMetricDefinitions_575050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the metric definitions of the specified plan.
  ## 
  let valid = call_575057.validator(path, query, header, formData, body)
  let scheme = call_575057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575057.url(scheme.get, call_575057.host, call_575057.base,
                         call_575057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575057, url, valid)

proc call*(call_575058: Call_PlansListMetricDefinitions_575050;
          resourceGroupName: string; subscriptionId: string; plan: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## plansListMetricDefinitions
  ## Get the metric definitions of the specified plan.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   plan: string (required)
  ##       : Name of the plan.
  var path_575059 = newJObject()
  var query_575060 = newJObject()
  add(path_575059, "resourceGroupName", newJString(resourceGroupName))
  add(query_575060, "api-version", newJString(apiVersion))
  add(path_575059, "subscriptionId", newJString(subscriptionId))
  add(path_575059, "plan", newJString(plan))
  result = call_575058.call(path_575059, query_575060, nil, nil, nil)

var plansListMetricDefinitions* = Call_PlansListMetricDefinitions_575050(
    name: "plansListMetricDefinitions", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/plans/{plan}/metricDefinitions",
    validator: validate_PlansListMetricDefinitions_575051, base: "",
    url: url_PlansListMetricDefinitions_575052, schemes: {Scheme.Https})
type
  Call_PlansListMetrics_575061 = ref object of OpenApiRestCall_574458
proc url_PlansListMetrics_575063(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "plan" in path, "`plan` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/plans/"),
               (kind: VariableSegment, value: "plan"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlansListMetrics_575062(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the metrics of the specified plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   plan: JString (required)
  ##       : Name of the plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575064 = path.getOrDefault("resourceGroupName")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "resourceGroupName", valid_575064
  var valid_575065 = path.getOrDefault("subscriptionId")
  valid_575065 = validateParameter(valid_575065, JString, required = true,
                                 default = nil)
  if valid_575065 != nil:
    section.add "subscriptionId", valid_575065
  var valid_575066 = path.getOrDefault("plan")
  valid_575066 = validateParameter(valid_575066, JString, required = true,
                                 default = nil)
  if valid_575066 != nil:
    section.add "plan", valid_575066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575067 = query.getOrDefault("api-version")
  valid_575067 = validateParameter(valid_575067, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575067 != nil:
    section.add "api-version", valid_575067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575068: Call_PlansListMetrics_575061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the metrics of the specified plan.
  ## 
  let valid = call_575068.validator(path, query, header, formData, body)
  let scheme = call_575068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575068.url(scheme.get, call_575068.host, call_575068.base,
                         call_575068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575068, url, valid)

proc call*(call_575069: Call_PlansListMetrics_575061; resourceGroupName: string;
          subscriptionId: string; plan: string; apiVersion: string = "2015-11-01"): Recallable =
  ## plansListMetrics
  ## Get the metrics of the specified plan.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   plan: string (required)
  ##       : Name of the plan.
  var path_575070 = newJObject()
  var query_575071 = newJObject()
  add(path_575070, "resourceGroupName", newJString(resourceGroupName))
  add(query_575071, "api-version", newJString(apiVersion))
  add(path_575070, "subscriptionId", newJString(subscriptionId))
  add(path_575070, "plan", newJString(plan))
  result = call_575069.call(path_575070, query_575071, nil, nil, nil)

var plansListMetrics* = Call_PlansListMetrics_575061(name: "plansListMetrics",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/plans/{plan}/metrics",
    validator: validate_PlansListMetrics_575062, base: "",
    url: url_PlansListMetrics_575063, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
