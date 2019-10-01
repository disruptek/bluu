
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PolicyClient
## version: 2016-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## To manage and control access to your resources, you can define customized policies and assign them at a scope.
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
  macServiceName = "resources-policy"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyAssignmentsList_567879 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsList_567881(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Authorization/policyassignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsList_567880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the policy assignments for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568056 = query.getOrDefault("api-version")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "api-version", valid_568056
  var valid_568057 = query.getOrDefault("$filter")
  valid_568057 = validateParameter(valid_568057, JString, required = false,
                                 default = nil)
  if valid_568057 != nil:
    section.add "$filter", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_PolicyAssignmentsList_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the policy assignments for a subscription.
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_PolicyAssignmentsList_567879; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## policyAssignmentsList
  ## Gets all the policy assignments for a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  add(query_568154, "$filter", newJString(Filter))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var policyAssignmentsList* = Call_PolicyAssignmentsList_567879(
    name: "policyAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyassignments",
    validator: validate_PolicyAssignmentsList_567880, base: "",
    url: url_PolicyAssignmentsList_567881, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsList_568193 = ref object of OpenApiRestCall_567657
proc url_PolicyDefinitionsList_568195(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Authorization/policydefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsList_568194(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the policy definitions for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568196 = path.getOrDefault("subscriptionId")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "subscriptionId", valid_568196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568197 = query.getOrDefault("api-version")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "api-version", valid_568197
  var valid_568198 = query.getOrDefault("$filter")
  valid_568198 = validateParameter(valid_568198, JString, required = false,
                                 default = nil)
  if valid_568198 != nil:
    section.add "$filter", valid_568198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_PolicyDefinitionsList_568193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the policy definitions for a subscription.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_PolicyDefinitionsList_568193; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## policyDefinitionsList
  ## Gets all the policy definitions for a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  add(query_568202, "$filter", newJString(Filter))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var policyDefinitionsList* = Call_PolicyDefinitionsList_568193(
    name: "policyDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions",
    validator: validate_PolicyDefinitionsList_568194, base: "",
    url: url_PolicyDefinitionsList_568195, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsCreateOrUpdate_568213 = ref object of OpenApiRestCall_567657
proc url_PolicyDefinitionsCreateOrUpdate_568215(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policydefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsCreateOrUpdate_568214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a policy definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to create.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568233 = path.getOrDefault("subscriptionId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "subscriptionId", valid_568233
  var valid_568234 = path.getOrDefault("policyDefinitionName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "policyDefinitionName", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
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
  ##             : The policy definition properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_PolicyDefinitionsCreateOrUpdate_568213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a policy definition.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_PolicyDefinitionsCreateOrUpdate_568213;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          policyDefinitionName: string): Recallable =
  ## policyDefinitionsCreateOrUpdate
  ## Creates or updates a policy definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : The policy definition properties.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to create.
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  var body_568241 = newJObject()
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568241 = parameters
  add(path_568239, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568238.call(path_568239, query_568240, nil, nil, body_568241)

var policyDefinitionsCreateOrUpdate* = Call_PolicyDefinitionsCreateOrUpdate_568213(
    name: "policyDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsCreateOrUpdate_568214, base: "",
    url: url_PolicyDefinitionsCreateOrUpdate_568215, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGet_568203 = ref object of OpenApiRestCall_567657
proc url_PolicyDefinitionsGet_568205(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policydefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsGet_568204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the policy definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568206 = path.getOrDefault("subscriptionId")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "subscriptionId", valid_568206
  var valid_568207 = path.getOrDefault("policyDefinitionName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "policyDefinitionName", valid_568207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568208 = query.getOrDefault("api-version")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "api-version", valid_568208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568209: Call_PolicyDefinitionsGet_568203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the policy definition.
  ## 
  let valid = call_568209.validator(path, query, header, formData, body)
  let scheme = call_568209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568209.url(scheme.get, call_568209.host, call_568209.base,
                         call_568209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568209, url, valid)

proc call*(call_568210: Call_PolicyDefinitionsGet_568203; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsGet
  ## Gets the policy definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to get.
  var path_568211 = newJObject()
  var query_568212 = newJObject()
  add(query_568212, "api-version", newJString(apiVersion))
  add(path_568211, "subscriptionId", newJString(subscriptionId))
  add(path_568211, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568210.call(path_568211, query_568212, nil, nil, nil)

var policyDefinitionsGet* = Call_PolicyDefinitionsGet_568203(
    name: "policyDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGet_568204, base: "",
    url: url_PolicyDefinitionsGet_568205, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsDelete_568242 = ref object of OpenApiRestCall_567657
proc url_PolicyDefinitionsDelete_568244(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policydefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDefinitionsDelete_568243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a policy definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: JString (required)
  ##                       : The name of the policy definition to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568245 = path.getOrDefault("subscriptionId")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "subscriptionId", valid_568245
  var valid_568246 = path.getOrDefault("policyDefinitionName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "policyDefinitionName", valid_568246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568247 = query.getOrDefault("api-version")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "api-version", valid_568247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568248: Call_PolicyDefinitionsDelete_568242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a policy definition.
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_PolicyDefinitionsDelete_568242; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsDelete
  ## Deletes a policy definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   policyDefinitionName: string (required)
  ##                       : The name of the policy definition to delete.
  var path_568250 = newJObject()
  var query_568251 = newJObject()
  add(query_568251, "api-version", newJString(apiVersion))
  add(path_568250, "subscriptionId", newJString(subscriptionId))
  add(path_568250, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568249.call(path_568250, query_568251, nil, nil, nil)

var policyDefinitionsDelete* = Call_PolicyDefinitionsDelete_568242(
    name: "policyDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsDelete_568243, base: "",
    url: url_PolicyDefinitionsDelete_568244, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForResourceGroup_568252 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsListForResourceGroup_568254(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsListForResourceGroup_568253(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets policy assignments for the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains policy assignments.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568257 = query.getOrDefault("api-version")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "api-version", valid_568257
  var valid_568258 = query.getOrDefault("$filter")
  valid_568258 = validateParameter(valid_568258, JString, required = false,
                                 default = nil)
  if valid_568258 != nil:
    section.add "$filter", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568259: Call_PolicyAssignmentsListForResourceGroup_568252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets policy assignments for the resource group.
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_PolicyAssignmentsListForResourceGroup_568252;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## policyAssignmentsListForResourceGroup
  ## Gets policy assignments for the resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains policy assignments.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(path_568261, "resourceGroupName", newJString(resourceGroupName))
  add(query_568262, "api-version", newJString(apiVersion))
  add(path_568261, "subscriptionId", newJString(subscriptionId))
  add(query_568262, "$filter", newJString(Filter))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var policyAssignmentsListForResourceGroup* = Call_PolicyAssignmentsListForResourceGroup_568252(
    name: "policyAssignmentsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForResourceGroup_568253, base: "",
    url: url_PolicyAssignmentsListForResourceGroup_568254, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForResource_568263 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsListForResource_568265(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyassignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsListForResource_568264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets policy assignments for a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource with policy assignments.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource path.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568266 = path.getOrDefault("resourceType")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "resourceType", valid_568266
  var valid_568267 = path.getOrDefault("resourceGroupName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "resourceGroupName", valid_568267
  var valid_568268 = path.getOrDefault("subscriptionId")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "subscriptionId", valid_568268
  var valid_568269 = path.getOrDefault("resourceName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "resourceName", valid_568269
  var valid_568270 = path.getOrDefault("resourceProviderNamespace")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "resourceProviderNamespace", valid_568270
  var valid_568271 = path.getOrDefault("parentResourcePath")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "parentResourcePath", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  var valid_568273 = query.getOrDefault("$filter")
  valid_568273 = validateParameter(valid_568273, JString, required = false,
                                 default = nil)
  if valid_568273 != nil:
    section.add "$filter", valid_568273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_PolicyAssignmentsListForResource_568263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets policy assignments for a resource.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_PolicyAssignmentsListForResource_568263;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          resourceProviderNamespace: string; parentResourcePath: string;
          Filter: string = ""): Recallable =
  ## policyAssignmentsListForResource
  ## Gets policy assignments for a resource.
  ##   resourceType: string (required)
  ##               : The resource type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource with policy assignments.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource path.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(path_568276, "resourceType", newJString(resourceType))
  add(path_568276, "resourceGroupName", newJString(resourceGroupName))
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "subscriptionId", newJString(subscriptionId))
  add(path_568276, "resourceName", newJString(resourceName))
  add(path_568276, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568276, "parentResourcePath", newJString(parentResourcePath))
  add(query_568277, "$filter", newJString(Filter))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var policyAssignmentsListForResource* = Call_PolicyAssignmentsListForResource_568263(
    name: "policyAssignmentsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/policyassignments",
    validator: validate_PolicyAssignmentsListForResource_568264, base: "",
    url: url_PolicyAssignmentsListForResource_568265, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsCreateById_568287 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsCreateById_568289(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "policyAssignmentId" in path,
        "`policyAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "policyAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsCreateById_568288(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Policy assignments are inherited by child resources. For example, when you apply a policy to a resource group that policy is assigned to all resources in the group. When providing a scope for the assignment, use '/subscriptions/{subscription-id}/' for subscriptions, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for resource groups, and '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider-namespace}/{resource-type}/{resource-name}' for resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentId: JString (required)
  ##                     : The ID of the policy assignment to create. Use the format 
  ## '/{scope}/providers/Microsoft.Authorization/policyAssignments/{policy-assignment-name}'.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyAssignmentId` field"
  var valid_568290 = path.getOrDefault("policyAssignmentId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "policyAssignmentId", valid_568290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568291 = query.getOrDefault("api-version")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "api-version", valid_568291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for policy assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568293: Call_PolicyAssignmentsCreateById_568287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Policy assignments are inherited by child resources. For example, when you apply a policy to a resource group that policy is assigned to all resources in the group. When providing a scope for the assignment, use '/subscriptions/{subscription-id}/' for subscriptions, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for resource groups, and '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider-namespace}/{resource-type}/{resource-name}' for resources.
  ## 
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_PolicyAssignmentsCreateById_568287;
          apiVersion: string; parameters: JsonNode; policyAssignmentId: string): Recallable =
  ## policyAssignmentsCreateById
  ## Policy assignments are inherited by child resources. For example, when you apply a policy to a resource group that policy is assigned to all resources in the group. When providing a scope for the assignment, use '/subscriptions/{subscription-id}/' for subscriptions, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for resource groups, and '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider-namespace}/{resource-type}/{resource-name}' for resources.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   parameters: JObject (required)
  ##             : Parameters for policy assignment.
  ##   policyAssignmentId: string (required)
  ##                     : The ID of the policy assignment to create. Use the format 
  ## '/{scope}/providers/Microsoft.Authorization/policyAssignments/{policy-assignment-name}'.
  var path_568295 = newJObject()
  var query_568296 = newJObject()
  var body_568297 = newJObject()
  add(query_568296, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568297 = parameters
  add(path_568295, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_568294.call(path_568295, query_568296, nil, nil, body_568297)

var policyAssignmentsCreateById* = Call_PolicyAssignmentsCreateById_568287(
    name: "policyAssignmentsCreateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsCreateById_568288, base: "",
    url: url_PolicyAssignmentsCreateById_568289, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsGetById_568278 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsGetById_568280(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "policyAssignmentId" in path,
        "`policyAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "policyAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsGetById_568279(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## When providing a scope for the assignment, use '/subscriptions/{subscription-id}/' for subscriptions, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for resource groups, and '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider-namespace}/{resource-type}/{resource-name}' for resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentId: JString (required)
  ##                     : The ID of the policy assignment to get. Use the format 
  ## '/{scope}/providers/Microsoft.Authorization/policyAssignments/{policy-assignment-name}'.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyAssignmentId` field"
  var valid_568281 = path.getOrDefault("policyAssignmentId")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "policyAssignmentId", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_PolicyAssignmentsGetById_568278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When providing a scope for the assignment, use '/subscriptions/{subscription-id}/' for subscriptions, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for resource groups, and '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider-namespace}/{resource-type}/{resource-name}' for resources.
  ## 
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_PolicyAssignmentsGetById_568278; apiVersion: string;
          policyAssignmentId: string): Recallable =
  ## policyAssignmentsGetById
  ## When providing a scope for the assignment, use '/subscriptions/{subscription-id}/' for subscriptions, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for resource groups, and '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider-namespace}/{resource-type}/{resource-name}' for resources.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyAssignmentId: string (required)
  ##                     : The ID of the policy assignment to get. Use the format 
  ## '/{scope}/providers/Microsoft.Authorization/policyAssignments/{policy-assignment-name}'.
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_568284.call(path_568285, query_568286, nil, nil, nil)

var policyAssignmentsGetById* = Call_PolicyAssignmentsGetById_568278(
    name: "policyAssignmentsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsGetById_568279, base: "",
    url: url_PolicyAssignmentsGetById_568280, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsDeleteById_568298 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsDeleteById_568300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "policyAssignmentId" in path,
        "`policyAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "policyAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsDeleteById_568299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## When providing a scope for the assignment, use '/subscriptions/{subscription-id}/' for subscriptions, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for resource groups, and '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider-namespace}/{resource-type}/{resource-name}' for resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentId: JString (required)
  ##                     : The ID of the policy assignment to delete. Use the format 
  ## '/{scope}/providers/Microsoft.Authorization/policyAssignments/{policy-assignment-name}'.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyAssignmentId` field"
  var valid_568301 = path.getOrDefault("policyAssignmentId")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "policyAssignmentId", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568302 = query.getOrDefault("api-version")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "api-version", valid_568302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568303: Call_PolicyAssignmentsDeleteById_568298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When providing a scope for the assignment, use '/subscriptions/{subscription-id}/' for subscriptions, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for resource groups, and '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider-namespace}/{resource-type}/{resource-name}' for resources.
  ## 
  let valid = call_568303.validator(path, query, header, formData, body)
  let scheme = call_568303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568303.url(scheme.get, call_568303.host, call_568303.base,
                         call_568303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568303, url, valid)

proc call*(call_568304: Call_PolicyAssignmentsDeleteById_568298;
          apiVersion: string; policyAssignmentId: string): Recallable =
  ## policyAssignmentsDeleteById
  ## When providing a scope for the assignment, use '/subscriptions/{subscription-id}/' for subscriptions, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for resource groups, and '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider-namespace}/{resource-type}/{resource-name}' for resources.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyAssignmentId: string (required)
  ##                     : The ID of the policy assignment to delete. Use the format 
  ## '/{scope}/providers/Microsoft.Authorization/policyAssignments/{policy-assignment-name}'.
  var path_568305 = newJObject()
  var query_568306 = newJObject()
  add(query_568306, "api-version", newJString(apiVersion))
  add(path_568305, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_568304.call(path_568305, query_568306, nil, nil, nil)

var policyAssignmentsDeleteById* = Call_PolicyAssignmentsDeleteById_568298(
    name: "policyAssignmentsDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsDeleteById_568299, base: "",
    url: url_PolicyAssignmentsDeleteById_568300, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsCreate_568317 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsCreate_568319(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "policyAssignmentName" in path,
        "`policyAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyassignments/"),
               (kind: VariableSegment, value: "policyAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsCreate_568318(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Policy assignments are inherited by child resources. For example, when you apply a policy to a resource group that policy is assigned to all resources in the group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentName: JString (required)
  ##                       : The name of the policy assignment.
  ##   scope: JString (required)
  ##        : The scope of the policy assignment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyAssignmentName` field"
  var valid_568320 = path.getOrDefault("policyAssignmentName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "policyAssignmentName", valid_568320
  var valid_568321 = path.getOrDefault("scope")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "scope", valid_568321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568322 = query.getOrDefault("api-version")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "api-version", valid_568322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for the policy assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568324: Call_PolicyAssignmentsCreate_568317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Policy assignments are inherited by child resources. For example, when you apply a policy to a resource group that policy is assigned to all resources in the group.
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_PolicyAssignmentsCreate_568317; apiVersion: string;
          policyAssignmentName: string; parameters: JsonNode; scope: string): Recallable =
  ## policyAssignmentsCreate
  ## Policy assignments are inherited by child resources. For example, when you apply a policy to a resource group that policy is assigned to all resources in the group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyAssignmentName: string (required)
  ##                       : The name of the policy assignment.
  ##   parameters: JObject (required)
  ##             : Parameters for the policy assignment.
  ##   scope: string (required)
  ##        : The scope of the policy assignment.
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  var body_568328 = newJObject()
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "policyAssignmentName", newJString(policyAssignmentName))
  if parameters != nil:
    body_568328 = parameters
  add(path_568326, "scope", newJString(scope))
  result = call_568325.call(path_568326, query_568327, nil, nil, body_568328)

var policyAssignmentsCreate* = Call_PolicyAssignmentsCreate_568317(
    name: "policyAssignmentsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyassignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsCreate_568318, base: "",
    url: url_PolicyAssignmentsCreate_568319, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsGet_568307 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsGet_568309(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "policyAssignmentName" in path,
        "`policyAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyassignments/"),
               (kind: VariableSegment, value: "policyAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsGet_568308(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentName: JString (required)
  ##                       : The name of the policy assignment to get.
  ##   scope: JString (required)
  ##        : The scope of the policy assignment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyAssignmentName` field"
  var valid_568310 = path.getOrDefault("policyAssignmentName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "policyAssignmentName", valid_568310
  var valid_568311 = path.getOrDefault("scope")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "scope", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568313: Call_PolicyAssignmentsGet_568307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a policy assignment.
  ## 
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_PolicyAssignmentsGet_568307; apiVersion: string;
          policyAssignmentName: string; scope: string): Recallable =
  ## policyAssignmentsGet
  ## Gets a policy assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyAssignmentName: string (required)
  ##                       : The name of the policy assignment to get.
  ##   scope: string (required)
  ##        : The scope of the policy assignment.
  var path_568315 = newJObject()
  var query_568316 = newJObject()
  add(query_568316, "api-version", newJString(apiVersion))
  add(path_568315, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_568315, "scope", newJString(scope))
  result = call_568314.call(path_568315, query_568316, nil, nil, nil)

var policyAssignmentsGet* = Call_PolicyAssignmentsGet_568307(
    name: "policyAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyassignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsGet_568308, base: "",
    url: url_PolicyAssignmentsGet_568309, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsDelete_568329 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsDelete_568331(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "policyAssignmentName" in path,
        "`policyAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyassignments/"),
               (kind: VariableSegment, value: "policyAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsDelete_568330(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentName: JString (required)
  ##                       : The name of the policy assignment to delete.
  ##   scope: JString (required)
  ##        : The scope of the policy assignment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyAssignmentName` field"
  var valid_568332 = path.getOrDefault("policyAssignmentName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "policyAssignmentName", valid_568332
  var valid_568333 = path.getOrDefault("scope")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "scope", valid_568333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
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

proc call*(call_568335: Call_PolicyAssignmentsDelete_568329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a policy assignment.
  ## 
  let valid = call_568335.validator(path, query, header, formData, body)
  let scheme = call_568335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568335.url(scheme.get, call_568335.host, call_568335.base,
                         call_568335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568335, url, valid)

proc call*(call_568336: Call_PolicyAssignmentsDelete_568329; apiVersion: string;
          policyAssignmentName: string; scope: string): Recallable =
  ## policyAssignmentsDelete
  ## Deletes a policy assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyAssignmentName: string (required)
  ##                       : The name of the policy assignment to delete.
  ##   scope: string (required)
  ##        : The scope of the policy assignment.
  var path_568337 = newJObject()
  var query_568338 = newJObject()
  add(query_568338, "api-version", newJString(apiVersion))
  add(path_568337, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_568337, "scope", newJString(scope))
  result = call_568336.call(path_568337, query_568338, nil, nil, nil)

var policyAssignmentsDelete* = Call_PolicyAssignmentsDelete_568329(
    name: "policyAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyassignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsDelete_568330, base: "",
    url: url_PolicyAssignmentsDelete_568331, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
