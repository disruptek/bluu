
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ResourceManagementClient
## version: 2015-11-01
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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  macServiceName = "resources"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeploymentsCalculateTemplateHash_567888 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCalculateTemplateHash_567890(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeploymentsCalculateTemplateHash_567889(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Calculate the hash of the given template.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568049 = query.getOrDefault("api-version")
  valid_568049 = validateParameter(valid_568049, JString, required = true,
                                 default = nil)
  if valid_568049 != nil:
    section.add "api-version", valid_568049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568073: Call_DeploymentsCalculateTemplateHash_567888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Calculate the hash of the given template.
  ## 
  let valid = call_568073.validator(path, query, header, formData, body)
  let scheme = call_568073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568073.url(scheme.get, call_568073.host, call_568073.base,
                         call_568073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568073, url, valid)

proc call*(call_568144: Call_DeploymentsCalculateTemplateHash_567888;
          apiVersion: string; `template`: JsonNode): Recallable =
  ## deploymentsCalculateTemplateHash
  ## Calculate the hash of the given template.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  var query_568145 = newJObject()
  var body_568147 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  if `template` != nil:
    body_568147 = `template`
  result = call_568144.call(nil, query_568145, nil, nil, body_568147)

var deploymentsCalculateTemplateHash* = Call_DeploymentsCalculateTemplateHash_567888(
    name: "deploymentsCalculateTemplateHash", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/calculateTemplateHash",
    validator: validate_DeploymentsCalculateTemplateHash_567889, base: "",
    url: url_DeploymentsCalculateTemplateHash_567890, schemes: {Scheme.Https})
type
  Call_ResourceProviderOperationDetailsList_568186 = ref object of OpenApiRestCall_567666
proc url_ResourceProviderOperationDetailsList_568188(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceProviderOperationDetailsList_568187(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of resource providers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceProviderNamespace: JString (required)
  ##                            : Resource identity.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resourceProviderNamespace` field"
  var valid_568203 = path.getOrDefault("resourceProviderNamespace")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "resourceProviderNamespace", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_ResourceProviderOperationDetailsList_568186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of resource providers.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_ResourceProviderOperationDetailsList_568186;
          apiVersion: string; resourceProviderNamespace: string): Recallable =
  ## resourceProviderOperationDetailsList
  ## Gets a list of resource providers.
  ##   apiVersion: string (required)
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  var path_568207 = newJObject()
  var query_568208 = newJObject()
  add(query_568208, "api-version", newJString(apiVersion))
  add(path_568207, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568206.call(path_568207, query_568208, nil, nil, nil)

var resourceProviderOperationDetailsList* = Call_ResourceProviderOperationDetailsList_568186(
    name: "resourceProviderOperationDetailsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/{resourceProviderNamespace}/operations",
    validator: validate_ResourceProviderOperationDetailsList_568187, base: "",
    url: url_ResourceProviderOperationDetailsList_568188, schemes: {Scheme.Https})
type
  Call_ProvidersList_568209 = ref object of OpenApiRestCall_567666
proc url_ProvidersList_568211(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersList_568210(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of resource providers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Query parameters. If null is passed returns all deployments.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  var valid_568215 = query.getOrDefault("$top")
  valid_568215 = validateParameter(valid_568215, JInt, required = false, default = nil)
  if valid_568215 != nil:
    section.add "$top", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_ProvidersList_568209; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of resource providers.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_ProvidersList_568209; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## providersList
  ## Gets a list of resource providers.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Query parameters. If null is passed returns all deployments.
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  add(query_568219, "$top", newJInt(Top))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var providersList* = Call_ProvidersList_568209(name: "providersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers",
    validator: validate_ProvidersList_568210, base: "", url: url_ProvidersList_568211,
    schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsList_568220 = ref object of OpenApiRestCall_567666
proc url_PolicyAssignmentsList_568222(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Authorization/policyAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsList_568221(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets policy assignments of the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568223 = path.getOrDefault("subscriptionId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "subscriptionId", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  var valid_568225 = query.getOrDefault("$filter")
  valid_568225 = validateParameter(valid_568225, JString, required = false,
                                 default = nil)
  if valid_568225 != nil:
    section.add "$filter", valid_568225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_PolicyAssignmentsList_568220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets policy assignments of the subscription.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_PolicyAssignmentsList_568220; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## policyAssignmentsList
  ## Gets policy assignments of the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  add(query_568229, "api-version", newJString(apiVersion))
  add(path_568228, "subscriptionId", newJString(subscriptionId))
  add(query_568229, "$filter", newJString(Filter))
  result = call_568227.call(path_568228, query_568229, nil, nil, nil)

var policyAssignmentsList* = Call_PolicyAssignmentsList_568220(
    name: "policyAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsList_568221, base: "",
    url: url_PolicyAssignmentsList_568222, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsCreateOrUpdate_568240 = ref object of OpenApiRestCall_567666
proc url_PolicyDefinitionsCreateOrUpdate_568242(protocol: Scheme; host: string;
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

proc validate_PolicyDefinitionsCreateOrUpdate_568241(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update policy definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyDefinitionName: JString (required)
  ##                       : The policy definition name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568260 = path.getOrDefault("subscriptionId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "subscriptionId", valid_568260
  var valid_568261 = path.getOrDefault("policyDefinitionName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "policyDefinitionName", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "api-version", valid_568262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy definition properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568264: Call_PolicyDefinitionsCreateOrUpdate_568240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update policy definition.
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_PolicyDefinitionsCreateOrUpdate_568240;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          policyDefinitionName: string): Recallable =
  ## policyDefinitionsCreateOrUpdate
  ## Create or update policy definition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The policy definition properties
  ##   policyDefinitionName: string (required)
  ##                       : The policy definition name.
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  var body_568268 = newJObject()
  add(query_568267, "api-version", newJString(apiVersion))
  add(path_568266, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568268 = parameters
  add(path_568266, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568265.call(path_568266, query_568267, nil, nil, body_568268)

var policyDefinitionsCreateOrUpdate* = Call_PolicyDefinitionsCreateOrUpdate_568240(
    name: "policyDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsCreateOrUpdate_568241, base: "",
    url: url_PolicyDefinitionsCreateOrUpdate_568242, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGet_568230 = ref object of OpenApiRestCall_567666
proc url_PolicyDefinitionsGet_568232(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyDefinitionsGet_568231(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets policy definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyDefinitionName: JString (required)
  ##                       : The policy definition name.
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

proc call*(call_568236: Call_PolicyDefinitionsGet_568230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets policy definition.
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_PolicyDefinitionsGet_568230; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsGet
  ## Gets policy definition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyDefinitionName: string (required)
  ##                       : The policy definition name.
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "subscriptionId", newJString(subscriptionId))
  add(path_568238, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568237.call(path_568238, query_568239, nil, nil, nil)

var policyDefinitionsGet* = Call_PolicyDefinitionsGet_568230(
    name: "policyDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGet_568231, base: "",
    url: url_PolicyDefinitionsGet_568232, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsDelete_568269 = ref object of OpenApiRestCall_567666
proc url_PolicyDefinitionsDelete_568271(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyDefinitionsDelete_568270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes policy definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyDefinitionName: JString (required)
  ##                       : The policy definition name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568272 = path.getOrDefault("subscriptionId")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "subscriptionId", valid_568272
  var valid_568273 = path.getOrDefault("policyDefinitionName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "policyDefinitionName", valid_568273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "api-version", valid_568274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568275: Call_PolicyDefinitionsDelete_568269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes policy definition.
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_PolicyDefinitionsDelete_568269; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsDelete
  ## Deletes policy definition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyDefinitionName: string (required)
  ##                       : The policy definition name.
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "subscriptionId", newJString(subscriptionId))
  add(path_568277, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_568276.call(path_568277, query_568278, nil, nil, nil)

var policyDefinitionsDelete* = Call_PolicyDefinitionsDelete_568269(
    name: "policyDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsDelete_568270, base: "",
    url: url_PolicyDefinitionsDelete_568271, schemes: {Scheme.Https})
type
  Call_ProvidersGet_568279 = ref object of OpenApiRestCall_567666
proc url_ProvidersGet_568281(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersGet_568280(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Namespace of the resource provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568282 = path.getOrDefault("subscriptionId")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "subscriptionId", valid_568282
  var valid_568283 = path.getOrDefault("resourceProviderNamespace")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "resourceProviderNamespace", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568285: Call_ProvidersGet_568279; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource provider.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_ProvidersGet_568279; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersGet
  ## Gets a resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceProviderNamespace: string (required)
  ##                            : Namespace of the resource provider.
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  add(query_568288, "api-version", newJString(apiVersion))
  add(path_568287, "subscriptionId", newJString(subscriptionId))
  add(path_568287, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568286.call(path_568287, query_568288, nil, nil, nil)

var providersGet* = Call_ProvidersGet_568279(name: "providersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}",
    validator: validate_ProvidersGet_568280, base: "", url: url_ProvidersGet_568281,
    schemes: {Scheme.Https})
type
  Call_ProvidersRegister_568289 = ref object of OpenApiRestCall_567666
proc url_ProvidersRegister_568291(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/register")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersRegister_568290(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Registers provider to be used with a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Namespace of the resource provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568292 = path.getOrDefault("subscriptionId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "subscriptionId", valid_568292
  var valid_568293 = path.getOrDefault("resourceProviderNamespace")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "resourceProviderNamespace", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_ProvidersRegister_568289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers provider to be used with a subscription.
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_ProvidersRegister_568289; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersRegister
  ## Registers provider to be used with a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceProviderNamespace: string (required)
  ##                            : Namespace of the resource provider.
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  add(path_568297, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568296.call(path_568297, query_568298, nil, nil, nil)

var providersRegister* = Call_ProvidersRegister_568289(name: "providersRegister",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/register",
    validator: validate_ProvidersRegister_568290, base: "",
    url: url_ProvidersRegister_568291, schemes: {Scheme.Https})
type
  Call_ProvidersUnregister_568299 = ref object of OpenApiRestCall_567666
proc url_ProvidersUnregister_568301(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/unregister")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersUnregister_568300(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Unregisters provider from a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Namespace of the resource provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568302 = path.getOrDefault("subscriptionId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "subscriptionId", valid_568302
  var valid_568303 = path.getOrDefault("resourceProviderNamespace")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "resourceProviderNamespace", valid_568303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "api-version", valid_568304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_ProvidersUnregister_568299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregisters provider from a subscription.
  ## 
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_ProvidersUnregister_568299; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersUnregister
  ## Unregisters provider from a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceProviderNamespace: string (required)
  ##                            : Namespace of the resource provider.
  var path_568307 = newJObject()
  var query_568308 = newJObject()
  add(query_568308, "api-version", newJString(apiVersion))
  add(path_568307, "subscriptionId", newJString(subscriptionId))
  add(path_568307, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568306.call(path_568307, query_568308, nil, nil, nil)

var providersUnregister* = Call_ProvidersUnregister_568299(
    name: "providersUnregister", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/unregister",
    validator: validate_ProvidersUnregister_568300, base: "",
    url: url_ProvidersUnregister_568301, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForResourceGroup_568309 = ref object of OpenApiRestCall_567666
proc url_PolicyAssignmentsListForResourceGroup_568311(protocol: Scheme;
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

proc validate_PolicyAssignmentsListForResourceGroup_568310(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets policy assignments of the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568312 = path.getOrDefault("resourceGroupName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "resourceGroupName", valid_568312
  var valid_568313 = path.getOrDefault("subscriptionId")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "subscriptionId", valid_568313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568314 = query.getOrDefault("api-version")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "api-version", valid_568314
  var valid_568315 = query.getOrDefault("$filter")
  valid_568315 = validateParameter(valid_568315, JString, required = false,
                                 default = nil)
  if valid_568315 != nil:
    section.add "$filter", valid_568315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568316: Call_PolicyAssignmentsListForResourceGroup_568309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets policy assignments of the resource group.
  ## 
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_PolicyAssignmentsListForResourceGroup_568309;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## policyAssignmentsListForResourceGroup
  ## Gets policy assignments of the resource group.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  add(path_568318, "resourceGroupName", newJString(resourceGroupName))
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "subscriptionId", newJString(subscriptionId))
  add(query_568319, "$filter", newJString(Filter))
  result = call_568317.call(path_568318, query_568319, nil, nil, nil)

var policyAssignmentsListForResourceGroup* = Call_PolicyAssignmentsListForResourceGroup_568309(
    name: "policyAssignmentsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForResourceGroup_568310, base: "",
    url: url_PolicyAssignmentsListForResourceGroup_568311, schemes: {Scheme.Https})
type
  Call_ResourceGroupsListResources_568320 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsListResources_568322(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsListResources_568321(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all of the resources under a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Query parameters. If null is passed returns all resource groups.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568323 = path.getOrDefault("resourceGroupName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "resourceGroupName", valid_568323
  var valid_568324 = path.getOrDefault("subscriptionId")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "subscriptionId", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Query parameters. If null is passed returns all resource groups.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  var valid_568326 = query.getOrDefault("$top")
  valid_568326 = validateParameter(valid_568326, JInt, required = false, default = nil)
  if valid_568326 != nil:
    section.add "$top", valid_568326
  var valid_568327 = query.getOrDefault("$filter")
  valid_568327 = validateParameter(valid_568327, JString, required = false,
                                 default = nil)
  if valid_568327 != nil:
    section.add "$filter", valid_568327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568328: Call_ResourceGroupsListResources_568320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all of the resources under a subscription.
  ## 
  let valid = call_568328.validator(path, query, header, formData, body)
  let scheme = call_568328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568328.url(scheme.get, call_568328.host, call_568328.base,
                         call_568328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568328, url, valid)

proc call*(call_568329: Call_ResourceGroupsListResources_568320;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## resourceGroupsListResources
  ## Get all of the resources under a subscription.
  ##   resourceGroupName: string (required)
  ##                    : Query parameters. If null is passed returns all resource groups.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Query parameters. If null is passed returns all resource groups.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568330 = newJObject()
  var query_568331 = newJObject()
  add(path_568330, "resourceGroupName", newJString(resourceGroupName))
  add(query_568331, "api-version", newJString(apiVersion))
  add(path_568330, "subscriptionId", newJString(subscriptionId))
  add(query_568331, "$top", newJInt(Top))
  add(query_568331, "$filter", newJString(Filter))
  result = call_568329.call(path_568330, query_568331, nil, nil, nil)

var resourceGroupsListResources* = Call_ResourceGroupsListResources_568320(
    name: "resourceGroupsListResources", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/resources",
    validator: validate_ResourceGroupsListResources_568321, base: "",
    url: url_ResourceGroupsListResources_568322, schemes: {Scheme.Https})
type
  Call_ResourcesMoveResources_568332 = ref object of OpenApiRestCall_567666
proc url_ResourcesMoveResources_568334(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "sourceResourceGroupName" in path,
        "`sourceResourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "sourceResourceGroupName"),
               (kind: ConstantSegment, value: "/moveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesMoveResources_568333(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Begin moving resources.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceResourceGroupName: JString (required)
  ##                          : Source resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sourceResourceGroupName` field"
  var valid_568335 = path.getOrDefault("sourceResourceGroupName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "sourceResourceGroupName", valid_568335
  var valid_568336 = path.getOrDefault("subscriptionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "subscriptionId", valid_568336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568337 = query.getOrDefault("api-version")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "api-version", valid_568337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : move resources' parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568339: Call_ResourcesMoveResources_568332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begin moving resources.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  let valid = call_568339.validator(path, query, header, formData, body)
  let scheme = call_568339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568339.url(scheme.get, call_568339.host, call_568339.base,
                         call_568339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568339, url, valid)

proc call*(call_568340: Call_ResourcesMoveResources_568332; apiVersion: string;
          sourceResourceGroupName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourcesMoveResources
  ## Begin moving resources.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   sourceResourceGroupName: string (required)
  ##                          : Source resource group name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : move resources' parameters.
  var path_568341 = newJObject()
  var query_568342 = newJObject()
  var body_568343 = newJObject()
  add(query_568342, "api-version", newJString(apiVersion))
  add(path_568341, "sourceResourceGroupName", newJString(sourceResourceGroupName))
  add(path_568341, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568343 = parameters
  result = call_568340.call(path_568341, query_568342, nil, nil, body_568343)

var resourcesMoveResources* = Call_ResourcesMoveResources_568332(
    name: "resourcesMoveResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{sourceResourceGroupName}/moveResources",
    validator: validate_ResourcesMoveResources_568333, base: "",
    url: url_ResourcesMoveResources_568334, schemes: {Scheme.Https})
type
  Call_ResourceGroupsList_568344 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsList_568346(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsList_568345(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a collection of resource groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568347 = path.getOrDefault("subscriptionId")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "subscriptionId", valid_568347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Query parameters. If null is passed returns all resource groups.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568348 = query.getOrDefault("api-version")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "api-version", valid_568348
  var valid_568349 = query.getOrDefault("$top")
  valid_568349 = validateParameter(valid_568349, JInt, required = false, default = nil)
  if valid_568349 != nil:
    section.add "$top", valid_568349
  var valid_568350 = query.getOrDefault("$filter")
  valid_568350 = validateParameter(valid_568350, JString, required = false,
                                 default = nil)
  if valid_568350 != nil:
    section.add "$filter", valid_568350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568351: Call_ResourceGroupsList_568344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a collection of resource groups.
  ## 
  let valid = call_568351.validator(path, query, header, formData, body)
  let scheme = call_568351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568351.url(scheme.get, call_568351.host, call_568351.base,
                         call_568351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568351, url, valid)

proc call*(call_568352: Call_ResourceGroupsList_568344; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## resourceGroupsList
  ## Gets a collection of resource groups.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Query parameters. If null is passed returns all resource groups.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568353 = newJObject()
  var query_568354 = newJObject()
  add(query_568354, "api-version", newJString(apiVersion))
  add(path_568353, "subscriptionId", newJString(subscriptionId))
  add(query_568354, "$top", newJInt(Top))
  add(query_568354, "$filter", newJString(Filter))
  result = call_568352.call(path_568353, query_568354, nil, nil, nil)

var resourceGroupsList* = Call_ResourceGroupsList_568344(
    name: "resourceGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resourcegroups",
    validator: validate_ResourceGroupsList_568345, base: "",
    url: url_ResourceGroupsList_568346, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCreateOrUpdate_568365 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsCreateOrUpdate_568367(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsCreateOrUpdate_568366(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to be created or updated.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568368 = path.getOrDefault("resourceGroupName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "resourceGroupName", valid_568368
  var valid_568369 = path.getOrDefault("subscriptionId")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "subscriptionId", valid_568369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568370 = query.getOrDefault("api-version")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "api-version", valid_568370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update resource group service operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568372: Call_ResourceGroupsCreateOrUpdate_568365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource group.
  ## 
  let valid = call_568372.validator(path, query, header, formData, body)
  let scheme = call_568372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568372.url(scheme.get, call_568372.host, call_568372.base,
                         call_568372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568372, url, valid)

proc call*(call_568373: Call_ResourceGroupsCreateOrUpdate_568365;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsCreateOrUpdate
  ## Create a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to be created or updated.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update resource group service operation.
  var path_568374 = newJObject()
  var query_568375 = newJObject()
  var body_568376 = newJObject()
  add(path_568374, "resourceGroupName", newJString(resourceGroupName))
  add(query_568375, "api-version", newJString(apiVersion))
  add(path_568374, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568376 = parameters
  result = call_568373.call(path_568374, query_568375, nil, nil, body_568376)

var resourceGroupsCreateOrUpdate* = Call_ResourceGroupsCreateOrUpdate_568365(
    name: "resourceGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCreateOrUpdate_568366, base: "",
    url: url_ResourceGroupsCreateOrUpdate_568367, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCheckExistence_568387 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsCheckExistence_568389(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsCheckExistence_568388(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether resource group exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568390 = path.getOrDefault("resourceGroupName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "resourceGroupName", valid_568390
  var valid_568391 = path.getOrDefault("subscriptionId")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "subscriptionId", valid_568391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568392 = query.getOrDefault("api-version")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "api-version", valid_568392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_ResourceGroupsCheckExistence_568387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether resource group exists.
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_ResourceGroupsCheckExistence_568387;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsCheckExistence
  ## Checks whether resource group exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  add(path_568395, "resourceGroupName", newJString(resourceGroupName))
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "subscriptionId", newJString(subscriptionId))
  result = call_568394.call(path_568395, query_568396, nil, nil, nil)

var resourceGroupsCheckExistence* = Call_ResourceGroupsCheckExistence_568387(
    name: "resourceGroupsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCheckExistence_568388, base: "",
    url: url_ResourceGroupsCheckExistence_568389, schemes: {Scheme.Https})
type
  Call_ResourceGroupsGet_568355 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsGet_568357(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsGet_568356(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568358 = path.getOrDefault("resourceGroupName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "resourceGroupName", valid_568358
  var valid_568359 = path.getOrDefault("subscriptionId")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "subscriptionId", valid_568359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568361: Call_ResourceGroupsGet_568355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a resource group.
  ## 
  let valid = call_568361.validator(path, query, header, formData, body)
  let scheme = call_568361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568361.url(scheme.get, call_568361.host, call_568361.base,
                         call_568361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568361, url, valid)

proc call*(call_568362: Call_ResourceGroupsGet_568355; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsGet
  ## Get a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568363 = newJObject()
  var query_568364 = newJObject()
  add(path_568363, "resourceGroupName", newJString(resourceGroupName))
  add(query_568364, "api-version", newJString(apiVersion))
  add(path_568363, "subscriptionId", newJString(subscriptionId))
  result = call_568362.call(path_568363, query_568364, nil, nil, nil)

var resourceGroupsGet* = Call_ResourceGroupsGet_568355(name: "resourceGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsGet_568356, base: "",
    url: url_ResourceGroupsGet_568357, schemes: {Scheme.Https})
type
  Call_ResourceGroupsPatch_568397 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsPatch_568399(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsPatch_568398(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource groups, though if a field is unspecified current value will be carried over. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to be created or updated. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568400 = path.getOrDefault("resourceGroupName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "resourceGroupName", valid_568400
  var valid_568401 = path.getOrDefault("subscriptionId")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "subscriptionId", valid_568401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568402 = query.getOrDefault("api-version")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "api-version", valid_568402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update state resource group service operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568404: Call_ResourceGroupsPatch_568397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource groups, though if a field is unspecified current value will be carried over. 
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_ResourceGroupsPatch_568397; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## resourceGroupsPatch
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource groups, though if a field is unspecified current value will be carried over. 
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to be created or updated. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update state resource group service operation.
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  var body_568408 = newJObject()
  add(path_568406, "resourceGroupName", newJString(resourceGroupName))
  add(query_568407, "api-version", newJString(apiVersion))
  add(path_568406, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568408 = parameters
  result = call_568405.call(path_568406, query_568407, nil, nil, body_568408)

var resourceGroupsPatch* = Call_ResourceGroupsPatch_568397(
    name: "resourceGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsPatch_568398, base: "",
    url: url_ResourceGroupsPatch_568399, schemes: {Scheme.Https})
type
  Call_ResourceGroupsDelete_568377 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsDelete_568379(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsDelete_568378(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Begin deleting resource group.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to be deleted. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568380 = path.getOrDefault("resourceGroupName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "resourceGroupName", valid_568380
  var valid_568381 = path.getOrDefault("subscriptionId")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "subscriptionId", valid_568381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568383: Call_ResourceGroupsDelete_568377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begin deleting resource group.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  let valid = call_568383.validator(path, query, header, formData, body)
  let scheme = call_568383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568383.url(scheme.get, call_568383.host, call_568383.base,
                         call_568383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568383, url, valid)

proc call*(call_568384: Call_ResourceGroupsDelete_568377;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsDelete
  ## Begin deleting resource group.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to be deleted. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568385 = newJObject()
  var query_568386 = newJObject()
  add(path_568385, "resourceGroupName", newJString(resourceGroupName))
  add(query_568386, "api-version", newJString(apiVersion))
  add(path_568385, "subscriptionId", newJString(subscriptionId))
  result = call_568384.call(path_568385, query_568386, nil, nil, nil)

var resourceGroupsDelete* = Call_ResourceGroupsDelete_568377(
    name: "resourceGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsDelete_568378, base: "",
    url: url_ResourceGroupsDelete_568379, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsList_568409 = ref object of OpenApiRestCall_567666
proc url_DeploymentOperationsList_568411(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsList_568410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of deployments operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568412 = path.getOrDefault("resourceGroupName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "resourceGroupName", valid_568412
  var valid_568413 = path.getOrDefault("deploymentName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "deploymentName", valid_568413
  var valid_568414 = path.getOrDefault("subscriptionId")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "subscriptionId", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Query parameters.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568415 = query.getOrDefault("api-version")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "api-version", valid_568415
  var valid_568416 = query.getOrDefault("$top")
  valid_568416 = validateParameter(valid_568416, JInt, required = false, default = nil)
  if valid_568416 != nil:
    section.add "$top", valid_568416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568417: Call_DeploymentOperationsList_568409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of deployments operations.
  ## 
  let valid = call_568417.validator(path, query, header, formData, body)
  let scheme = call_568417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568417.url(scheme.get, call_568417.host, call_568417.base,
                         call_568417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568417, url, valid)

proc call*(call_568418: Call_DeploymentOperationsList_568409;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## deploymentOperationsList
  ## Gets a list of deployments operations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Query parameters.
  var path_568419 = newJObject()
  var query_568420 = newJObject()
  add(path_568419, "resourceGroupName", newJString(resourceGroupName))
  add(query_568420, "api-version", newJString(apiVersion))
  add(path_568419, "deploymentName", newJString(deploymentName))
  add(path_568419, "subscriptionId", newJString(subscriptionId))
  add(query_568420, "$top", newJInt(Top))
  result = call_568418.call(path_568419, query_568420, nil, nil, nil)

var deploymentOperationsList* = Call_DeploymentOperationsList_568409(
    name: "deploymentOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsList_568410, base: "",
    url: url_DeploymentOperationsList_568411, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGet_568421 = ref object of OpenApiRestCall_567666
proc url_DeploymentOperationsGet_568423(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsGet_568422(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of deployments operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   operationId: JString (required)
  ##              : Operation Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568424 = path.getOrDefault("resourceGroupName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "resourceGroupName", valid_568424
  var valid_568425 = path.getOrDefault("deploymentName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "deploymentName", valid_568425
  var valid_568426 = path.getOrDefault("subscriptionId")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "subscriptionId", valid_568426
  var valid_568427 = path.getOrDefault("operationId")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "operationId", valid_568427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568428 = query.getOrDefault("api-version")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "api-version", valid_568428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568429: Call_DeploymentOperationsGet_568421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of deployments operations.
  ## 
  let valid = call_568429.validator(path, query, header, formData, body)
  let scheme = call_568429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568429.url(scheme.get, call_568429.host, call_568429.base,
                         call_568429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568429, url, valid)

proc call*(call_568430: Call_DeploymentOperationsGet_568421;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; operationId: string): Recallable =
  ## deploymentOperationsGet
  ## Get a list of deployments operations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   operationId: string (required)
  ##              : Operation Id.
  var path_568431 = newJObject()
  var query_568432 = newJObject()
  add(path_568431, "resourceGroupName", newJString(resourceGroupName))
  add(query_568432, "api-version", newJString(apiVersion))
  add(path_568431, "deploymentName", newJString(deploymentName))
  add(path_568431, "subscriptionId", newJString(subscriptionId))
  add(path_568431, "operationId", newJString(operationId))
  result = call_568430.call(path_568431, query_568432, nil, nil, nil)

var deploymentOperationsGet* = Call_DeploymentOperationsGet_568421(
    name: "deploymentOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGet_568422, base: "",
    url: url_DeploymentOperationsGet_568423, schemes: {Scheme.Https})
type
  Call_DeploymentsList_568433 = ref object of OpenApiRestCall_567666
proc url_DeploymentsList_568435(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Resources/deployments/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsList_568434(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get a list of deployments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to filter by. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568436 = path.getOrDefault("resourceGroupName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "resourceGroupName", valid_568436
  var valid_568437 = path.getOrDefault("subscriptionId")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "subscriptionId", valid_568437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Query parameters. If null is passed returns all deployments.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568438 = query.getOrDefault("api-version")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "api-version", valid_568438
  var valid_568439 = query.getOrDefault("$top")
  valid_568439 = validateParameter(valid_568439, JInt, required = false, default = nil)
  if valid_568439 != nil:
    section.add "$top", valid_568439
  var valid_568440 = query.getOrDefault("$filter")
  valid_568440 = validateParameter(valid_568440, JString, required = false,
                                 default = nil)
  if valid_568440 != nil:
    section.add "$filter", valid_568440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568441: Call_DeploymentsList_568433; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of deployments.
  ## 
  let valid = call_568441.validator(path, query, header, formData, body)
  let scheme = call_568441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568441.url(scheme.get, call_568441.host, call_568441.base,
                         call_568441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568441, url, valid)

proc call*(call_568442: Call_DeploymentsList_568433; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## deploymentsList
  ## Get a list of deployments.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to filter by. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Query parameters. If null is passed returns all deployments.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568443 = newJObject()
  var query_568444 = newJObject()
  add(path_568443, "resourceGroupName", newJString(resourceGroupName))
  add(query_568444, "api-version", newJString(apiVersion))
  add(path_568443, "subscriptionId", newJString(subscriptionId))
  add(query_568444, "$top", newJInt(Top))
  add(query_568444, "$filter", newJString(Filter))
  result = call_568442.call(path_568443, query_568444, nil, nil, nil)

var deploymentsList* = Call_DeploymentsList_568433(name: "deploymentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsList_568434, base: "", url: url_DeploymentsList_568435,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdate_568456 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCreateOrUpdate_568458(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCreateOrUpdate_568457(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a named template deployment using a template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568459 = path.getOrDefault("resourceGroupName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "resourceGroupName", valid_568459
  var valid_568460 = path.getOrDefault("deploymentName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "deploymentName", valid_568460
  var valid_568461 = path.getOrDefault("subscriptionId")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "subscriptionId", valid_568461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568462 = query.getOrDefault("api-version")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "api-version", valid_568462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568464: Call_DeploymentsCreateOrUpdate_568456; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a named template deployment using a template.
  ## 
  let valid = call_568464.validator(path, query, header, formData, body)
  let scheme = call_568464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568464.url(scheme.get, call_568464.host, call_568464.base,
                         call_568464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568464, url, valid)

proc call*(call_568465: Call_DeploymentsCreateOrUpdate_568456;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## deploymentsCreateOrUpdate
  ## Create a named template deployment using a template.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  var path_568466 = newJObject()
  var query_568467 = newJObject()
  var body_568468 = newJObject()
  add(path_568466, "resourceGroupName", newJString(resourceGroupName))
  add(query_568467, "api-version", newJString(apiVersion))
  add(path_568466, "deploymentName", newJString(deploymentName))
  add(path_568466, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568468 = parameters
  result = call_568465.call(path_568466, query_568467, nil, nil, body_568468)

var deploymentsCreateOrUpdate* = Call_DeploymentsCreateOrUpdate_568456(
    name: "deploymentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdate_568457, base: "",
    url: url_DeploymentsCreateOrUpdate_568458, schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistence_568480 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCheckExistence_568482(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCheckExistence_568481(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568483 = path.getOrDefault("resourceGroupName")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "resourceGroupName", valid_568483
  var valid_568484 = path.getOrDefault("deploymentName")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "deploymentName", valid_568484
  var valid_568485 = path.getOrDefault("subscriptionId")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "subscriptionId", valid_568485
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568486 = query.getOrDefault("api-version")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "api-version", valid_568486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568487: Call_DeploymentsCheckExistence_568480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether deployment exists.
  ## 
  let valid = call_568487.validator(path, query, header, formData, body)
  let scheme = call_568487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568487.url(scheme.get, call_568487.host, call_568487.base,
                         call_568487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568487, url, valid)

proc call*(call_568488: Call_DeploymentsCheckExistence_568480;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string): Recallable =
  ## deploymentsCheckExistence
  ## Checks whether deployment exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568489 = newJObject()
  var query_568490 = newJObject()
  add(path_568489, "resourceGroupName", newJString(resourceGroupName))
  add(query_568490, "api-version", newJString(apiVersion))
  add(path_568489, "deploymentName", newJString(deploymentName))
  add(path_568489, "subscriptionId", newJString(subscriptionId))
  result = call_568488.call(path_568489, query_568490, nil, nil, nil)

var deploymentsCheckExistence* = Call_DeploymentsCheckExistence_568480(
    name: "deploymentsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistence_568481, base: "",
    url: url_DeploymentsCheckExistence_568482, schemes: {Scheme.Https})
type
  Call_DeploymentsGet_568445 = ref object of OpenApiRestCall_567666
proc url_DeploymentsGet_568447(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsGet_568446(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568448 = path.getOrDefault("resourceGroupName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "resourceGroupName", valid_568448
  var valid_568449 = path.getOrDefault("deploymentName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "deploymentName", valid_568449
  var valid_568450 = path.getOrDefault("subscriptionId")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "subscriptionId", valid_568450
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_568452: Call_DeploymentsGet_568445; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a deployment.
  ## 
  let valid = call_568452.validator(path, query, header, formData, body)
  let scheme = call_568452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568452.url(scheme.get, call_568452.host, call_568452.base,
                         call_568452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568452, url, valid)

proc call*(call_568453: Call_DeploymentsGet_568445; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsGet
  ## Get a deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568454 = newJObject()
  var query_568455 = newJObject()
  add(path_568454, "resourceGroupName", newJString(resourceGroupName))
  add(query_568455, "api-version", newJString(apiVersion))
  add(path_568454, "deploymentName", newJString(deploymentName))
  add(path_568454, "subscriptionId", newJString(subscriptionId))
  result = call_568453.call(path_568454, query_568455, nil, nil, nil)

var deploymentsGet* = Call_DeploymentsGet_568445(name: "deploymentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGet_568446, base: "", url: url_DeploymentsGet_568447,
    schemes: {Scheme.Https})
type
  Call_DeploymentsDelete_568469 = ref object of OpenApiRestCall_567666
proc url_DeploymentsDelete_568471(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsDelete_568470(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Begin deleting deployment.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568472 = path.getOrDefault("resourceGroupName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "resourceGroupName", valid_568472
  var valid_568473 = path.getOrDefault("deploymentName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "deploymentName", valid_568473
  var valid_568474 = path.getOrDefault("subscriptionId")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "subscriptionId", valid_568474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568475 = query.getOrDefault("api-version")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "api-version", valid_568475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568476: Call_DeploymentsDelete_568469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begin deleting deployment.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  let valid = call_568476.validator(path, query, header, formData, body)
  let scheme = call_568476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568476.url(scheme.get, call_568476.host, call_568476.base,
                         call_568476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568476, url, valid)

proc call*(call_568477: Call_DeploymentsDelete_568469; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsDelete
  ## Begin deleting deployment.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to be deleted.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568478 = newJObject()
  var query_568479 = newJObject()
  add(path_568478, "resourceGroupName", newJString(resourceGroupName))
  add(query_568479, "api-version", newJString(apiVersion))
  add(path_568478, "deploymentName", newJString(deploymentName))
  add(path_568478, "subscriptionId", newJString(subscriptionId))
  result = call_568477.call(path_568478, query_568479, nil, nil, nil)

var deploymentsDelete* = Call_DeploymentsDelete_568469(name: "deploymentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDelete_568470, base: "",
    url: url_DeploymentsDelete_568471, schemes: {Scheme.Https})
type
  Call_DeploymentsCancel_568491 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCancel_568493(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCancel_568492(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Cancel a currently running template deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568494 = path.getOrDefault("resourceGroupName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "resourceGroupName", valid_568494
  var valid_568495 = path.getOrDefault("deploymentName")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "deploymentName", valid_568495
  var valid_568496 = path.getOrDefault("subscriptionId")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "subscriptionId", valid_568496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568497 = query.getOrDefault("api-version")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "api-version", valid_568497
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568498: Call_DeploymentsCancel_568491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a currently running template deployment.
  ## 
  let valid = call_568498.validator(path, query, header, formData, body)
  let scheme = call_568498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568498.url(scheme.get, call_568498.host, call_568498.base,
                         call_568498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568498, url, valid)

proc call*(call_568499: Call_DeploymentsCancel_568491; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCancel
  ## Cancel a currently running template deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568500 = newJObject()
  var query_568501 = newJObject()
  add(path_568500, "resourceGroupName", newJString(resourceGroupName))
  add(query_568501, "api-version", newJString(apiVersion))
  add(path_568500, "deploymentName", newJString(deploymentName))
  add(path_568500, "subscriptionId", newJString(subscriptionId))
  result = call_568499.call(path_568500, query_568501, nil, nil, nil)

var deploymentsCancel* = Call_DeploymentsCancel_568491(name: "deploymentsCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancel_568492, base: "",
    url: url_DeploymentsCancel_568493, schemes: {Scheme.Https})
type
  Call_DeploymentsValidate_568502 = ref object of OpenApiRestCall_567666
proc url_DeploymentsValidate_568504(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsValidate_568503(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Validate a deployment template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568505 = path.getOrDefault("resourceGroupName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "resourceGroupName", valid_568505
  var valid_568506 = path.getOrDefault("deploymentName")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "deploymentName", valid_568506
  var valid_568507 = path.getOrDefault("subscriptionId")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "subscriptionId", valid_568507
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568508 = query.getOrDefault("api-version")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "api-version", valid_568508
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Deployment to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568510: Call_DeploymentsValidate_568502; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validate a deployment template.
  ## 
  let valid = call_568510.validator(path, query, header, formData, body)
  let scheme = call_568510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568510.url(scheme.get, call_568510.host, call_568510.base,
                         call_568510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568510, url, valid)

proc call*(call_568511: Call_DeploymentsValidate_568502; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsValidate
  ## Validate a deployment template.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Deployment to validate.
  var path_568512 = newJObject()
  var query_568513 = newJObject()
  var body_568514 = newJObject()
  add(path_568512, "resourceGroupName", newJString(resourceGroupName))
  add(query_568513, "api-version", newJString(apiVersion))
  add(path_568512, "deploymentName", newJString(deploymentName))
  add(path_568512, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568514 = parameters
  result = call_568511.call(path_568512, query_568513, nil, nil, body_568514)

var deploymentsValidate* = Call_DeploymentsValidate_568502(
    name: "deploymentsValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidate_568503, base: "",
    url: url_DeploymentsValidate_568504, schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdate_568529 = ref object of OpenApiRestCall_567666
proc url_ResourcesCreateOrUpdate_568531(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCreateOrUpdate_568530(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Resource identity.
  ##   parentResourcePath: JString (required)
  ##                     : Resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568532 = path.getOrDefault("resourceType")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "resourceType", valid_568532
  var valid_568533 = path.getOrDefault("resourceGroupName")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "resourceGroupName", valid_568533
  var valid_568534 = path.getOrDefault("subscriptionId")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "subscriptionId", valid_568534
  var valid_568535 = path.getOrDefault("resourceName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "resourceName", valid_568535
  var valid_568536 = path.getOrDefault("resourceProviderNamespace")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "resourceProviderNamespace", valid_568536
  var valid_568537 = path.getOrDefault("parentResourcePath")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "parentResourcePath", valid_568537
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568538 = query.getOrDefault("api-version")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "api-version", valid_568538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update resource parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568540: Call_ResourcesCreateOrUpdate_568529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource.
  ## 
  let valid = call_568540.validator(path, query, header, formData, body)
  let scheme = call_568540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568540.url(scheme.get, call_568540.host, call_568540.base,
                         call_568540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568540, url, valid)

proc call*(call_568541: Call_ResourcesCreateOrUpdate_568529; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## resourcesCreateOrUpdate
  ## Create a resource.
  ##   resourceType: string (required)
  ##               : Resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identity.
  ##   parameters: JObject (required)
  ##             : Create or update resource parameters.
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  ##   parentResourcePath: string (required)
  ##                     : Resource identity.
  var path_568542 = newJObject()
  var query_568543 = newJObject()
  var body_568544 = newJObject()
  add(path_568542, "resourceType", newJString(resourceType))
  add(path_568542, "resourceGroupName", newJString(resourceGroupName))
  add(query_568543, "api-version", newJString(apiVersion))
  add(path_568542, "subscriptionId", newJString(subscriptionId))
  add(path_568542, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568544 = parameters
  add(path_568542, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568542, "parentResourcePath", newJString(parentResourcePath))
  result = call_568541.call(path_568542, query_568543, nil, nil, body_568544)

var resourcesCreateOrUpdate* = Call_ResourcesCreateOrUpdate_568529(
    name: "resourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCreateOrUpdate_568530, base: "",
    url: url_ResourcesCreateOrUpdate_568531, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistence_568559 = ref object of OpenApiRestCall_567666
proc url_ResourcesCheckExistence_568561(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCheckExistence_568560(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Resource identity.
  ##   parentResourcePath: JString (required)
  ##                     : Resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568562 = path.getOrDefault("resourceType")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "resourceType", valid_568562
  var valid_568563 = path.getOrDefault("resourceGroupName")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "resourceGroupName", valid_568563
  var valid_568564 = path.getOrDefault("subscriptionId")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "subscriptionId", valid_568564
  var valid_568565 = path.getOrDefault("resourceName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "resourceName", valid_568565
  var valid_568566 = path.getOrDefault("resourceProviderNamespace")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "resourceProviderNamespace", valid_568566
  var valid_568567 = path.getOrDefault("parentResourcePath")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "parentResourcePath", valid_568567
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568568 = query.getOrDefault("api-version")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "api-version", valid_568568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568569: Call_ResourcesCheckExistence_568559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether resource exists.
  ## 
  let valid = call_568569.validator(path, query, header, formData, body)
  let scheme = call_568569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568569.url(scheme.get, call_568569.host, call_568569.base,
                         call_568569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568569, url, valid)

proc call*(call_568570: Call_ResourcesCheckExistence_568559; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesCheckExistence
  ## Checks whether resource exists.
  ##   resourceType: string (required)
  ##               : Resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  ##   parentResourcePath: string (required)
  ##                     : Resource identity.
  var path_568571 = newJObject()
  var query_568572 = newJObject()
  add(path_568571, "resourceType", newJString(resourceType))
  add(path_568571, "resourceGroupName", newJString(resourceGroupName))
  add(query_568572, "api-version", newJString(apiVersion))
  add(path_568571, "subscriptionId", newJString(subscriptionId))
  add(path_568571, "resourceName", newJString(resourceName))
  add(path_568571, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568571, "parentResourcePath", newJString(parentResourcePath))
  result = call_568570.call(path_568571, query_568572, nil, nil, nil)

var resourcesCheckExistence* = Call_ResourcesCheckExistence_568559(
    name: "resourcesCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCheckExistence_568560, base: "",
    url: url_ResourcesCheckExistence_568561, schemes: {Scheme.Https})
type
  Call_ResourcesGet_568515 = ref object of OpenApiRestCall_567666
proc url_ResourcesGet_568517(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesGet_568516(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a resource belonging to a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Resource identity.
  ##   parentResourcePath: JString (required)
  ##                     : Resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568518 = path.getOrDefault("resourceType")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "resourceType", valid_568518
  var valid_568519 = path.getOrDefault("resourceGroupName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "resourceGroupName", valid_568519
  var valid_568520 = path.getOrDefault("subscriptionId")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "subscriptionId", valid_568520
  var valid_568521 = path.getOrDefault("resourceName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "resourceName", valid_568521
  var valid_568522 = path.getOrDefault("resourceProviderNamespace")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "resourceProviderNamespace", valid_568522
  var valid_568523 = path.getOrDefault("parentResourcePath")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "parentResourcePath", valid_568523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568524 = query.getOrDefault("api-version")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "api-version", valid_568524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568525: Call_ResourcesGet_568515; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a resource belonging to a resource group.
  ## 
  let valid = call_568525.validator(path, query, header, formData, body)
  let scheme = call_568525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568525.url(scheme.get, call_568525.host, call_568525.base,
                         call_568525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568525, url, valid)

proc call*(call_568526: Call_ResourcesGet_568515; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesGet
  ## Returns a resource belonging to a resource group.
  ##   resourceType: string (required)
  ##               : Resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  ##   parentResourcePath: string (required)
  ##                     : Resource identity.
  var path_568527 = newJObject()
  var query_568528 = newJObject()
  add(path_568527, "resourceType", newJString(resourceType))
  add(path_568527, "resourceGroupName", newJString(resourceGroupName))
  add(query_568528, "api-version", newJString(apiVersion))
  add(path_568527, "subscriptionId", newJString(subscriptionId))
  add(path_568527, "resourceName", newJString(resourceName))
  add(path_568527, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568527, "parentResourcePath", newJString(parentResourcePath))
  result = call_568526.call(path_568527, query_568528, nil, nil, nil)

var resourcesGet* = Call_ResourcesGet_568515(name: "resourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesGet_568516, base: "", url: url_ResourcesGet_568517,
    schemes: {Scheme.Https})
type
  Call_ResourcesUpdate_568573 = ref object of OpenApiRestCall_567666
proc url_ResourcesUpdate_568575(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesUpdate_568574(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource to update.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The name of the resource to update.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568576 = path.getOrDefault("resourceType")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "resourceType", valid_568576
  var valid_568577 = path.getOrDefault("resourceGroupName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "resourceGroupName", valid_568577
  var valid_568578 = path.getOrDefault("subscriptionId")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "subscriptionId", valid_568578
  var valid_568579 = path.getOrDefault("resourceName")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "resourceName", valid_568579
  var valid_568580 = path.getOrDefault("resourceProviderNamespace")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "resourceProviderNamespace", valid_568580
  var valid_568581 = path.getOrDefault("parentResourcePath")
  valid_568581 = validateParameter(valid_568581, JString, required = true,
                                 default = nil)
  if valid_568581 != nil:
    section.add "parentResourcePath", valid_568581
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568582 = query.getOrDefault("api-version")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "api-version", valid_568582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for updating the resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568584: Call_ResourcesUpdate_568573; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource.
  ## 
  let valid = call_568584.validator(path, query, header, formData, body)
  let scheme = call_568584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568584.url(scheme.get, call_568584.host, call_568584.base,
                         call_568584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568584, url, valid)

proc call*(call_568585: Call_ResourcesUpdate_568573; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## resourcesUpdate
  ## Updates a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource to update.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The name of the resource to update.
  ##   parameters: JObject (required)
  ##             : Parameters for updating the resource.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568586 = newJObject()
  var query_568587 = newJObject()
  var body_568588 = newJObject()
  add(path_568586, "resourceType", newJString(resourceType))
  add(path_568586, "resourceGroupName", newJString(resourceGroupName))
  add(query_568587, "api-version", newJString(apiVersion))
  add(path_568586, "subscriptionId", newJString(subscriptionId))
  add(path_568586, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568588 = parameters
  add(path_568586, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568586, "parentResourcePath", newJString(parentResourcePath))
  result = call_568585.call(path_568586, query_568587, nil, nil, body_568588)

var resourcesUpdate* = Call_ResourcesUpdate_568573(name: "resourcesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesUpdate_568574, base: "", url: url_ResourcesUpdate_568575,
    schemes: {Scheme.Https})
type
  Call_ResourcesDelete_568545 = ref object of OpenApiRestCall_567666
proc url_ResourcesDelete_568547(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesDelete_568546(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete resource and all of its resources. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Resource identity.
  ##   parentResourcePath: JString (required)
  ##                     : Resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568548 = path.getOrDefault("resourceType")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "resourceType", valid_568548
  var valid_568549 = path.getOrDefault("resourceGroupName")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "resourceGroupName", valid_568549
  var valid_568550 = path.getOrDefault("subscriptionId")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "subscriptionId", valid_568550
  var valid_568551 = path.getOrDefault("resourceName")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "resourceName", valid_568551
  var valid_568552 = path.getOrDefault("resourceProviderNamespace")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "resourceProviderNamespace", valid_568552
  var valid_568553 = path.getOrDefault("parentResourcePath")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "parentResourcePath", valid_568553
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568554 = query.getOrDefault("api-version")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "api-version", valid_568554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568555: Call_ResourcesDelete_568545; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete resource and all of its resources. 
  ## 
  let valid = call_568555.validator(path, query, header, formData, body)
  let scheme = call_568555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568555.url(scheme.get, call_568555.host, call_568555.base,
                         call_568555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568555, url, valid)

proc call*(call_568556: Call_ResourcesDelete_568545; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesDelete
  ## Delete resource and all of its resources. 
  ##   resourceType: string (required)
  ##               : Resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  ##   parentResourcePath: string (required)
  ##                     : Resource identity.
  var path_568557 = newJObject()
  var query_568558 = newJObject()
  add(path_568557, "resourceType", newJString(resourceType))
  add(path_568557, "resourceGroupName", newJString(resourceGroupName))
  add(query_568558, "api-version", newJString(apiVersion))
  add(path_568557, "subscriptionId", newJString(subscriptionId))
  add(path_568557, "resourceName", newJString(resourceName))
  add(path_568557, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568557, "parentResourcePath", newJString(parentResourcePath))
  result = call_568556.call(path_568557, query_568558, nil, nil, nil)

var resourcesDelete* = Call_ResourcesDelete_568545(name: "resourcesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesDelete_568546, base: "", url: url_ResourcesDelete_568547,
    schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForResource_568589 = ref object of OpenApiRestCall_567666
proc url_PolicyAssignmentsListForResource_568591(protocol: Scheme; host: string;
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
        value: "providers/Microsoft.Authorization/policyAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsListForResource_568590(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets policy assignments of the resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : The resource name.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The name of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource path.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568592 = path.getOrDefault("resourceType")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "resourceType", valid_568592
  var valid_568593 = path.getOrDefault("resourceGroupName")
  valid_568593 = validateParameter(valid_568593, JString, required = true,
                                 default = nil)
  if valid_568593 != nil:
    section.add "resourceGroupName", valid_568593
  var valid_568594 = path.getOrDefault("subscriptionId")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "subscriptionId", valid_568594
  var valid_568595 = path.getOrDefault("resourceName")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "resourceName", valid_568595
  var valid_568596 = path.getOrDefault("resourceProviderNamespace")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "resourceProviderNamespace", valid_568596
  var valid_568597 = path.getOrDefault("parentResourcePath")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "parentResourcePath", valid_568597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568598 = query.getOrDefault("api-version")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "api-version", valid_568598
  var valid_568599 = query.getOrDefault("$filter")
  valid_568599 = validateParameter(valid_568599, JString, required = false,
                                 default = nil)
  if valid_568599 != nil:
    section.add "$filter", valid_568599
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568600: Call_PolicyAssignmentsListForResource_568589;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets policy assignments of the resource.
  ## 
  let valid = call_568600.validator(path, query, header, formData, body)
  let scheme = call_568600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568600.url(scheme.get, call_568600.host, call_568600.base,
                         call_568600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568600, url, valid)

proc call*(call_568601: Call_PolicyAssignmentsListForResource_568589;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          resourceProviderNamespace: string; parentResourcePath: string;
          Filter: string = ""): Recallable =
  ## policyAssignmentsListForResource
  ## Gets policy assignments of the resource.
  ##   resourceType: string (required)
  ##               : The resource type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : The resource name.
  ##   resourceProviderNamespace: string (required)
  ##                            : The name of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource path.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568602 = newJObject()
  var query_568603 = newJObject()
  add(path_568602, "resourceType", newJString(resourceType))
  add(path_568602, "resourceGroupName", newJString(resourceGroupName))
  add(query_568603, "api-version", newJString(apiVersion))
  add(path_568602, "subscriptionId", newJString(subscriptionId))
  add(path_568602, "resourceName", newJString(resourceName))
  add(path_568602, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568602, "parentResourcePath", newJString(parentResourcePath))
  add(query_568603, "$filter", newJString(Filter))
  result = call_568601.call(path_568602, query_568603, nil, nil, nil)

var policyAssignmentsListForResource* = Call_PolicyAssignmentsListForResource_568589(
    name: "policyAssignmentsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForResource_568590, base: "",
    url: url_PolicyAssignmentsListForResource_568591, schemes: {Scheme.Https})
type
  Call_ResourcesList_568604 = ref object of OpenApiRestCall_567666
proc url_ResourcesList_568606(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesList_568605(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all of the resources under a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568607 = path.getOrDefault("subscriptionId")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = nil)
  if valid_568607 != nil:
    section.add "subscriptionId", valid_568607
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Query parameters. If null is passed returns all resource groups.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568608 = query.getOrDefault("api-version")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "api-version", valid_568608
  var valid_568609 = query.getOrDefault("$top")
  valid_568609 = validateParameter(valid_568609, JInt, required = false, default = nil)
  if valid_568609 != nil:
    section.add "$top", valid_568609
  var valid_568610 = query.getOrDefault("$filter")
  valid_568610 = validateParameter(valid_568610, JString, required = false,
                                 default = nil)
  if valid_568610 != nil:
    section.add "$filter", valid_568610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568611: Call_ResourcesList_568604; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all of the resources under a subscription.
  ## 
  let valid = call_568611.validator(path, query, header, formData, body)
  let scheme = call_568611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568611.url(scheme.get, call_568611.host, call_568611.base,
                         call_568611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568611, url, valid)

proc call*(call_568612: Call_ResourcesList_568604; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## resourcesList
  ## Get all of the resources under a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Query parameters. If null is passed returns all resource groups.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568613 = newJObject()
  var query_568614 = newJObject()
  add(query_568614, "api-version", newJString(apiVersion))
  add(path_568613, "subscriptionId", newJString(subscriptionId))
  add(query_568614, "$top", newJInt(Top))
  add(query_568614, "$filter", newJString(Filter))
  result = call_568612.call(path_568613, query_568614, nil, nil, nil)

var resourcesList* = Call_ResourcesList_568604(name: "resourcesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resources",
    validator: validate_ResourcesList_568605, base: "", url: url_ResourcesList_568606,
    schemes: {Scheme.Https})
type
  Call_TagsList_568615 = ref object of OpenApiRestCall_567666
proc url_TagsList_568617(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsList_568616(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of subscription resource tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568618 = path.getOrDefault("subscriptionId")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "subscriptionId", valid_568618
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568619 = query.getOrDefault("api-version")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "api-version", valid_568619
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568620: Call_TagsList_568615; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of subscription resource tags.
  ## 
  let valid = call_568620.validator(path, query, header, formData, body)
  let scheme = call_568620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568620.url(scheme.get, call_568620.host, call_568620.base,
                         call_568620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568620, url, valid)

proc call*(call_568621: Call_TagsList_568615; apiVersion: string;
          subscriptionId: string): Recallable =
  ## tagsList
  ## Get a list of subscription resource tags.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568622 = newJObject()
  var query_568623 = newJObject()
  add(query_568623, "api-version", newJString(apiVersion))
  add(path_568622, "subscriptionId", newJString(subscriptionId))
  result = call_568621.call(path_568622, query_568623, nil, nil, nil)

var tagsList* = Call_TagsList_568615(name: "tagsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames",
                                  validator: validate_TagsList_568616, base: "",
                                  url: url_TagsList_568617,
                                  schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdate_568624 = ref object of OpenApiRestCall_567666
proc url_TagsCreateOrUpdate_568626(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsCreateOrUpdate_568625(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Create a subscription resource tag.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568627 = path.getOrDefault("tagName")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "tagName", valid_568627
  var valid_568628 = path.getOrDefault("subscriptionId")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "subscriptionId", valid_568628
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568629 = query.getOrDefault("api-version")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "api-version", valid_568629
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568630: Call_TagsCreateOrUpdate_568624; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a subscription resource tag.
  ## 
  let valid = call_568630.validator(path, query, header, formData, body)
  let scheme = call_568630.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568630.url(scheme.get, call_568630.host, call_568630.base,
                         call_568630.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568630, url, valid)

proc call*(call_568631: Call_TagsCreateOrUpdate_568624; apiVersion: string;
          tagName: string; subscriptionId: string): Recallable =
  ## tagsCreateOrUpdate
  ## Create a subscription resource tag.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568632 = newJObject()
  var query_568633 = newJObject()
  add(query_568633, "api-version", newJString(apiVersion))
  add(path_568632, "tagName", newJString(tagName))
  add(path_568632, "subscriptionId", newJString(subscriptionId))
  result = call_568631.call(path_568632, query_568633, nil, nil, nil)

var tagsCreateOrUpdate* = Call_TagsCreateOrUpdate_568624(
    name: "tagsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
    validator: validate_TagsCreateOrUpdate_568625, base: "",
    url: url_TagsCreateOrUpdate_568626, schemes: {Scheme.Https})
type
  Call_TagsDelete_568634 = ref object of OpenApiRestCall_567666
proc url_TagsDelete_568636(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsDelete_568635(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a subscription resource tag.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568637 = path.getOrDefault("tagName")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "tagName", valid_568637
  var valid_568638 = path.getOrDefault("subscriptionId")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "subscriptionId", valid_568638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568639 = query.getOrDefault("api-version")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "api-version", valid_568639
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568640: Call_TagsDelete_568634; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a subscription resource tag.
  ## 
  let valid = call_568640.validator(path, query, header, formData, body)
  let scheme = call_568640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568640.url(scheme.get, call_568640.host, call_568640.base,
                         call_568640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568640, url, valid)

proc call*(call_568641: Call_TagsDelete_568634; apiVersion: string; tagName: string;
          subscriptionId: string): Recallable =
  ## tagsDelete
  ## Delete a subscription resource tag.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568642 = newJObject()
  var query_568643 = newJObject()
  add(query_568643, "api-version", newJString(apiVersion))
  add(path_568642, "tagName", newJString(tagName))
  add(path_568642, "subscriptionId", newJString(subscriptionId))
  result = call_568641.call(path_568642, query_568643, nil, nil, nil)

var tagsDelete* = Call_TagsDelete_568634(name: "tagsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
                                      validator: validate_TagsDelete_568635,
                                      base: "", url: url_TagsDelete_568636,
                                      schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdateValue_568644 = ref object of OpenApiRestCall_567666
proc url_TagsCreateOrUpdateValue_568646(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  assert "tagValue" in path, "`tagValue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName"),
               (kind: ConstantSegment, value: "/tagValues/"),
               (kind: VariableSegment, value: "tagValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsCreateOrUpdateValue_568645(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a subscription resource tag value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   tagValue: JString (required)
  ##           : The value of the tag.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568647 = path.getOrDefault("tagName")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "tagName", valid_568647
  var valid_568648 = path.getOrDefault("subscriptionId")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "subscriptionId", valid_568648
  var valid_568649 = path.getOrDefault("tagValue")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "tagValue", valid_568649
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568650 = query.getOrDefault("api-version")
  valid_568650 = validateParameter(valid_568650, JString, required = true,
                                 default = nil)
  if valid_568650 != nil:
    section.add "api-version", valid_568650
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568651: Call_TagsCreateOrUpdateValue_568644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a subscription resource tag value.
  ## 
  let valid = call_568651.validator(path, query, header, formData, body)
  let scheme = call_568651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568651.url(scheme.get, call_568651.host, call_568651.base,
                         call_568651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568651, url, valid)

proc call*(call_568652: Call_TagsCreateOrUpdateValue_568644; apiVersion: string;
          tagName: string; subscriptionId: string; tagValue: string): Recallable =
  ## tagsCreateOrUpdateValue
  ## Create a subscription resource tag value.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   tagValue: string (required)
  ##           : The value of the tag.
  var path_568653 = newJObject()
  var query_568654 = newJObject()
  add(query_568654, "api-version", newJString(apiVersion))
  add(path_568653, "tagName", newJString(tagName))
  add(path_568653, "subscriptionId", newJString(subscriptionId))
  add(path_568653, "tagValue", newJString(tagValue))
  result = call_568652.call(path_568653, query_568654, nil, nil, nil)

var tagsCreateOrUpdateValue* = Call_TagsCreateOrUpdateValue_568644(
    name: "tagsCreateOrUpdateValue", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsCreateOrUpdateValue_568645, base: "",
    url: url_TagsCreateOrUpdateValue_568646, schemes: {Scheme.Https})
type
  Call_TagsDeleteValue_568655 = ref object of OpenApiRestCall_567666
proc url_TagsDeleteValue_568657(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  assert "tagValue" in path, "`tagValue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName"),
               (kind: ConstantSegment, value: "/tagValues/"),
               (kind: VariableSegment, value: "tagValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsDeleteValue_568656(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete a subscription resource tag value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   tagValue: JString (required)
  ##           : The value of the tag.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568658 = path.getOrDefault("tagName")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "tagName", valid_568658
  var valid_568659 = path.getOrDefault("subscriptionId")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "subscriptionId", valid_568659
  var valid_568660 = path.getOrDefault("tagValue")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "tagValue", valid_568660
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568661 = query.getOrDefault("api-version")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "api-version", valid_568661
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568662: Call_TagsDeleteValue_568655; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a subscription resource tag value.
  ## 
  let valid = call_568662.validator(path, query, header, formData, body)
  let scheme = call_568662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568662.url(scheme.get, call_568662.host, call_568662.base,
                         call_568662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568662, url, valid)

proc call*(call_568663: Call_TagsDeleteValue_568655; apiVersion: string;
          tagName: string; subscriptionId: string; tagValue: string): Recallable =
  ## tagsDeleteValue
  ## Delete a subscription resource tag value.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   tagValue: string (required)
  ##           : The value of the tag.
  var path_568664 = newJObject()
  var query_568665 = newJObject()
  add(query_568665, "api-version", newJString(apiVersion))
  add(path_568664, "tagName", newJString(tagName))
  add(path_568664, "subscriptionId", newJString(subscriptionId))
  add(path_568664, "tagValue", newJString(tagValue))
  result = call_568663.call(path_568664, query_568665, nil, nil, nil)

var tagsDeleteValue* = Call_TagsDeleteValue_568655(name: "tagsDeleteValue",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsDeleteValue_568656, base: "", url: url_TagsDeleteValue_568657,
    schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsCreateById_568675 = ref object of OpenApiRestCall_567666
proc url_PolicyAssignmentsCreateById_568677(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsCreateById_568676(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create policy assignment by Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentId: JString (required)
  ##                     : Policy assignment Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyAssignmentId` field"
  var valid_568678 = path.getOrDefault("policyAssignmentId")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = nil)
  if valid_568678 != nil:
    section.add "policyAssignmentId", valid_568678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568679 = query.getOrDefault("api-version")
  valid_568679 = validateParameter(valid_568679, JString, required = true,
                                 default = nil)
  if valid_568679 != nil:
    section.add "api-version", valid_568679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Policy assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568681: Call_PolicyAssignmentsCreateById_568675; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create policy assignment by Id.
  ## 
  let valid = call_568681.validator(path, query, header, formData, body)
  let scheme = call_568681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568681.url(scheme.get, call_568681.host, call_568681.base,
                         call_568681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568681, url, valid)

proc call*(call_568682: Call_PolicyAssignmentsCreateById_568675;
          apiVersion: string; parameters: JsonNode; policyAssignmentId: string): Recallable =
  ## policyAssignmentsCreateById
  ## Create policy assignment by Id.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : Policy assignment.
  ##   policyAssignmentId: string (required)
  ##                     : Policy assignment Id
  var path_568683 = newJObject()
  var query_568684 = newJObject()
  var body_568685 = newJObject()
  add(query_568684, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568685 = parameters
  add(path_568683, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_568682.call(path_568683, query_568684, nil, nil, body_568685)

var policyAssignmentsCreateById* = Call_PolicyAssignmentsCreateById_568675(
    name: "policyAssignmentsCreateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsCreateById_568676, base: "",
    url: url_PolicyAssignmentsCreateById_568677, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsGetById_568666 = ref object of OpenApiRestCall_567666
proc url_PolicyAssignmentsGetById_568668(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsGetById_568667(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get single policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentId: JString (required)
  ##                     : Policy assignment Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyAssignmentId` field"
  var valid_568669 = path.getOrDefault("policyAssignmentId")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "policyAssignmentId", valid_568669
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568670 = query.getOrDefault("api-version")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "api-version", valid_568670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568671: Call_PolicyAssignmentsGetById_568666; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get single policy assignment.
  ## 
  let valid = call_568671.validator(path, query, header, formData, body)
  let scheme = call_568671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568671.url(scheme.get, call_568671.host, call_568671.base,
                         call_568671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568671, url, valid)

proc call*(call_568672: Call_PolicyAssignmentsGetById_568666; apiVersion: string;
          policyAssignmentId: string): Recallable =
  ## policyAssignmentsGetById
  ## Get single policy assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   policyAssignmentId: string (required)
  ##                     : Policy assignment Id
  var path_568673 = newJObject()
  var query_568674 = newJObject()
  add(query_568674, "api-version", newJString(apiVersion))
  add(path_568673, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_568672.call(path_568673, query_568674, nil, nil, nil)

var policyAssignmentsGetById* = Call_PolicyAssignmentsGetById_568666(
    name: "policyAssignmentsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsGetById_568667, base: "",
    url: url_PolicyAssignmentsGetById_568668, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsDeleteById_568686 = ref object of OpenApiRestCall_567666
proc url_PolicyAssignmentsDeleteById_568688(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsDeleteById_568687(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentId: JString (required)
  ##                     : Policy assignment Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyAssignmentId` field"
  var valid_568689 = path.getOrDefault("policyAssignmentId")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "policyAssignmentId", valid_568689
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568690 = query.getOrDefault("api-version")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "api-version", valid_568690
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568691: Call_PolicyAssignmentsDeleteById_568686; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy assignment.
  ## 
  let valid = call_568691.validator(path, query, header, formData, body)
  let scheme = call_568691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568691.url(scheme.get, call_568691.host, call_568691.base,
                         call_568691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568691, url, valid)

proc call*(call_568692: Call_PolicyAssignmentsDeleteById_568686;
          apiVersion: string; policyAssignmentId: string): Recallable =
  ## policyAssignmentsDeleteById
  ## Delete policy assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   policyAssignmentId: string (required)
  ##                     : Policy assignment Id
  var path_568693 = newJObject()
  var query_568694 = newJObject()
  add(query_568694, "api-version", newJString(apiVersion))
  add(path_568693, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_568692.call(path_568693, query_568694, nil, nil, nil)

var policyAssignmentsDeleteById* = Call_PolicyAssignmentsDeleteById_568686(
    name: "policyAssignmentsDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsDeleteById_568687, base: "",
    url: url_PolicyAssignmentsDeleteById_568688, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForScope_568695 = ref object of OpenApiRestCall_567666
proc url_PolicyAssignmentsListForScope_568697(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsListForScope_568696(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets policy assignments of the scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : Scope.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568698 = path.getOrDefault("scope")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "scope", valid_568698
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568699 = query.getOrDefault("api-version")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "api-version", valid_568699
  var valid_568700 = query.getOrDefault("$filter")
  valid_568700 = validateParameter(valid_568700, JString, required = false,
                                 default = nil)
  if valid_568700 != nil:
    section.add "$filter", valid_568700
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568701: Call_PolicyAssignmentsListForScope_568695; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets policy assignments of the scope.
  ## 
  let valid = call_568701.validator(path, query, header, formData, body)
  let scheme = call_568701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568701.url(scheme.get, call_568701.host, call_568701.base,
                         call_568701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568701, url, valid)

proc call*(call_568702: Call_PolicyAssignmentsListForScope_568695;
          apiVersion: string; scope: string; Filter: string = ""): Recallable =
  ## policyAssignmentsListForScope
  ## Gets policy assignments of the scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   scope: string (required)
  ##        : Scope.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568703 = newJObject()
  var query_568704 = newJObject()
  add(query_568704, "api-version", newJString(apiVersion))
  add(path_568703, "scope", newJString(scope))
  add(query_568704, "$filter", newJString(Filter))
  result = call_568702.call(path_568703, query_568704, nil, nil, nil)

var policyAssignmentsListForScope* = Call_PolicyAssignmentsListForScope_568695(
    name: "policyAssignmentsListForScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForScope_568696, base: "",
    url: url_PolicyAssignmentsListForScope_568697, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsCreate_568715 = ref object of OpenApiRestCall_567666
proc url_PolicyAssignmentsCreate_568717(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Authorization/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsCreate_568716(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  ##   scope: JString (required)
  ##        : Scope.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyAssignmentName` field"
  var valid_568718 = path.getOrDefault("policyAssignmentName")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "policyAssignmentName", valid_568718
  var valid_568719 = path.getOrDefault("scope")
  valid_568719 = validateParameter(valid_568719, JString, required = true,
                                 default = nil)
  if valid_568719 != nil:
    section.add "scope", valid_568719
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568720 = query.getOrDefault("api-version")
  valid_568720 = validateParameter(valid_568720, JString, required = true,
                                 default = nil)
  if valid_568720 != nil:
    section.add "api-version", valid_568720
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Policy assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568722: Call_PolicyAssignmentsCreate_568715; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create policy assignment.
  ## 
  let valid = call_568722.validator(path, query, header, formData, body)
  let scheme = call_568722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568722.url(scheme.get, call_568722.host, call_568722.base,
                         call_568722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568722, url, valid)

proc call*(call_568723: Call_PolicyAssignmentsCreate_568715; apiVersion: string;
          policyAssignmentName: string; parameters: JsonNode; scope: string): Recallable =
  ## policyAssignmentsCreate
  ## Create policy assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   parameters: JObject (required)
  ##             : Policy assignment.
  ##   scope: string (required)
  ##        : Scope.
  var path_568724 = newJObject()
  var query_568725 = newJObject()
  var body_568726 = newJObject()
  add(query_568725, "api-version", newJString(apiVersion))
  add(path_568724, "policyAssignmentName", newJString(policyAssignmentName))
  if parameters != nil:
    body_568726 = parameters
  add(path_568724, "scope", newJString(scope))
  result = call_568723.call(path_568724, query_568725, nil, nil, body_568726)

var policyAssignmentsCreate* = Call_PolicyAssignmentsCreate_568715(
    name: "policyAssignmentsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsCreate_568716, base: "",
    url: url_PolicyAssignmentsCreate_568717, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsGet_568705 = ref object of OpenApiRestCall_567666
proc url_PolicyAssignmentsGet_568707(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Authorization/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsGet_568706(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get single policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  ##   scope: JString (required)
  ##        : Scope.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyAssignmentName` field"
  var valid_568708 = path.getOrDefault("policyAssignmentName")
  valid_568708 = validateParameter(valid_568708, JString, required = true,
                                 default = nil)
  if valid_568708 != nil:
    section.add "policyAssignmentName", valid_568708
  var valid_568709 = path.getOrDefault("scope")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "scope", valid_568709
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568710 = query.getOrDefault("api-version")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "api-version", valid_568710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568711: Call_PolicyAssignmentsGet_568705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get single policy assignment.
  ## 
  let valid = call_568711.validator(path, query, header, formData, body)
  let scheme = call_568711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568711.url(scheme.get, call_568711.host, call_568711.base,
                         call_568711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568711, url, valid)

proc call*(call_568712: Call_PolicyAssignmentsGet_568705; apiVersion: string;
          policyAssignmentName: string; scope: string): Recallable =
  ## policyAssignmentsGet
  ## Get single policy assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   scope: string (required)
  ##        : Scope.
  var path_568713 = newJObject()
  var query_568714 = newJObject()
  add(query_568714, "api-version", newJString(apiVersion))
  add(path_568713, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_568713, "scope", newJString(scope))
  result = call_568712.call(path_568713, query_568714, nil, nil, nil)

var policyAssignmentsGet* = Call_PolicyAssignmentsGet_568705(
    name: "policyAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsGet_568706, base: "",
    url: url_PolicyAssignmentsGet_568707, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsDelete_568727 = ref object of OpenApiRestCall_567666
proc url_PolicyAssignmentsDelete_568729(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Authorization/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsDelete_568728(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  ##   scope: JString (required)
  ##        : Scope.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyAssignmentName` field"
  var valid_568730 = path.getOrDefault("policyAssignmentName")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "policyAssignmentName", valid_568730
  var valid_568731 = path.getOrDefault("scope")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "scope", valid_568731
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568732: Call_PolicyAssignmentsDelete_568727; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy assignment.
  ## 
  let valid = call_568732.validator(path, query, header, formData, body)
  let scheme = call_568732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568732.url(scheme.get, call_568732.host, call_568732.base,
                         call_568732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568732, url, valid)

proc call*(call_568733: Call_PolicyAssignmentsDelete_568727;
          policyAssignmentName: string; scope: string): Recallable =
  ## policyAssignmentsDelete
  ## Delete policy assignment.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   scope: string (required)
  ##        : Scope.
  var path_568734 = newJObject()
  add(path_568734, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_568734, "scope", newJString(scope))
  result = call_568733.call(path_568734, nil, nil, nil, nil)

var policyAssignmentsDelete* = Call_PolicyAssignmentsDelete_568727(
    name: "policyAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsDelete_568728, base: "",
    url: url_PolicyAssignmentsDelete_568729, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
