
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563564 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563564](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563564): Option[Scheme] {.used.} =
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
  macServiceName = "resources"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeploymentsCalculateTemplateHash_563786 = ref object of OpenApiRestCall_563564
proc url_DeploymentsCalculateTemplateHash_563788(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeploymentsCalculateTemplateHash_563787(path: JsonNode;
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
  var valid_563949 = query.getOrDefault("api-version")
  valid_563949 = validateParameter(valid_563949, JString, required = true,
                                 default = nil)
  if valid_563949 != nil:
    section.add "api-version", valid_563949
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

proc call*(call_563973: Call_DeploymentsCalculateTemplateHash_563786;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Calculate the hash of the given template.
  ## 
  let valid = call_563973.validator(path, query, header, formData, body)
  let scheme = call_563973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563973.url(scheme.get, call_563973.host, call_563973.base,
                         call_563973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563973, url, valid)

proc call*(call_564044: Call_DeploymentsCalculateTemplateHash_563786;
          apiVersion: string; `template`: JsonNode): Recallable =
  ## deploymentsCalculateTemplateHash
  ## Calculate the hash of the given template.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  var query_564045 = newJObject()
  var body_564047 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  if `template` != nil:
    body_564047 = `template`
  result = call_564044.call(nil, query_564045, nil, nil, body_564047)

var deploymentsCalculateTemplateHash* = Call_DeploymentsCalculateTemplateHash_563786(
    name: "deploymentsCalculateTemplateHash", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/calculateTemplateHash",
    validator: validate_DeploymentsCalculateTemplateHash_563787, base: "",
    url: url_DeploymentsCalculateTemplateHash_563788, schemes: {Scheme.Https})
type
  Call_ResourceProviderOperationDetailsList_564086 = ref object of OpenApiRestCall_563564
proc url_ResourceProviderOperationDetailsList_564088(protocol: Scheme;
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

proc validate_ResourceProviderOperationDetailsList_564087(path: JsonNode;
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
  var valid_564103 = path.getOrDefault("resourceProviderNamespace")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "resourceProviderNamespace", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564105: Call_ResourceProviderOperationDetailsList_564086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of resource providers.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_ResourceProviderOperationDetailsList_564086;
          apiVersion: string; resourceProviderNamespace: string): Recallable =
  ## resourceProviderOperationDetailsList
  ## Gets a list of resource providers.
  ##   apiVersion: string (required)
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  add(query_564108, "api-version", newJString(apiVersion))
  add(path_564107, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_564106.call(path_564107, query_564108, nil, nil, nil)

var resourceProviderOperationDetailsList* = Call_ResourceProviderOperationDetailsList_564086(
    name: "resourceProviderOperationDetailsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/{resourceProviderNamespace}/operations",
    validator: validate_ResourceProviderOperationDetailsList_564087, base: "",
    url: url_ResourceProviderOperationDetailsList_564088, schemes: {Scheme.Https})
type
  Call_ProvidersList_564109 = ref object of OpenApiRestCall_563564
proc url_ProvidersList_564111(protocol: Scheme; host: string; base: string;
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

proc validate_ProvidersList_564110(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Query parameters. If null is passed returns all deployments.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564114 = query.getOrDefault("$top")
  valid_564114 = validateParameter(valid_564114, JInt, required = false, default = nil)
  if valid_564114 != nil:
    section.add "$top", valid_564114
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_ProvidersList_564109; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of resource providers.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_ProvidersList_564109; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## providersList
  ## Gets a list of resource providers.
  ##   Top: int
  ##      : Query parameters. If null is passed returns all deployments.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "$top", newJInt(Top))
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var providersList* = Call_ProvidersList_564109(name: "providersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers",
    validator: validate_ProvidersList_564110, base: "", url: url_ProvidersList_564111,
    schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsList_564120 = ref object of OpenApiRestCall_563564
proc url_PolicyAssignmentsList_564122(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyAssignmentsList_564121(path: JsonNode; query: JsonNode;
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
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564124 = query.getOrDefault("api-version")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "api-version", valid_564124
  var valid_564125 = query.getOrDefault("$filter")
  valid_564125 = validateParameter(valid_564125, JString, required = false,
                                 default = nil)
  if valid_564125 != nil:
    section.add "$filter", valid_564125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564126: Call_PolicyAssignmentsList_564120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets policy assignments of the subscription.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_PolicyAssignmentsList_564120; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## policyAssignmentsList
  ## Gets policy assignments of the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  add(query_564129, "api-version", newJString(apiVersion))
  add(path_564128, "subscriptionId", newJString(subscriptionId))
  add(query_564129, "$filter", newJString(Filter))
  result = call_564127.call(path_564128, query_564129, nil, nil, nil)

var policyAssignmentsList* = Call_PolicyAssignmentsList_564120(
    name: "policyAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsList_564121, base: "",
    url: url_PolicyAssignmentsList_564122, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsCreateOrUpdate_564140 = ref object of OpenApiRestCall_563564
proc url_PolicyDefinitionsCreateOrUpdate_564142(protocol: Scheme; host: string;
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

proc validate_PolicyDefinitionsCreateOrUpdate_564141(path: JsonNode;
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
  var valid_564160 = path.getOrDefault("subscriptionId")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "subscriptionId", valid_564160
  var valid_564161 = path.getOrDefault("policyDefinitionName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "policyDefinitionName", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
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

proc call*(call_564164: Call_PolicyDefinitionsCreateOrUpdate_564140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update policy definition.
  ## 
  let valid = call_564164.validator(path, query, header, formData, body)
  let scheme = call_564164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564164.url(scheme.get, call_564164.host, call_564164.base,
                         call_564164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564164, url, valid)

proc call*(call_564165: Call_PolicyDefinitionsCreateOrUpdate_564140;
          apiVersion: string; subscriptionId: string; policyDefinitionName: string;
          parameters: JsonNode): Recallable =
  ## policyDefinitionsCreateOrUpdate
  ## Create or update policy definition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyDefinitionName: string (required)
  ##                       : The policy definition name.
  ##   parameters: JObject (required)
  ##             : The policy definition properties
  var path_564166 = newJObject()
  var query_564167 = newJObject()
  var body_564168 = newJObject()
  add(query_564167, "api-version", newJString(apiVersion))
  add(path_564166, "subscriptionId", newJString(subscriptionId))
  add(path_564166, "policyDefinitionName", newJString(policyDefinitionName))
  if parameters != nil:
    body_564168 = parameters
  result = call_564165.call(path_564166, query_564167, nil, nil, body_564168)

var policyDefinitionsCreateOrUpdate* = Call_PolicyDefinitionsCreateOrUpdate_564140(
    name: "policyDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsCreateOrUpdate_564141, base: "",
    url: url_PolicyDefinitionsCreateOrUpdate_564142, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGet_564130 = ref object of OpenApiRestCall_563564
proc url_PolicyDefinitionsGet_564132(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyDefinitionsGet_564131(path: JsonNode; query: JsonNode;
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
  var valid_564133 = path.getOrDefault("subscriptionId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "subscriptionId", valid_564133
  var valid_564134 = path.getOrDefault("policyDefinitionName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "policyDefinitionName", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564136: Call_PolicyDefinitionsGet_564130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets policy definition.
  ## 
  let valid = call_564136.validator(path, query, header, formData, body)
  let scheme = call_564136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564136.url(scheme.get, call_564136.host, call_564136.base,
                         call_564136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564136, url, valid)

proc call*(call_564137: Call_PolicyDefinitionsGet_564130; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsGet
  ## Gets policy definition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyDefinitionName: string (required)
  ##                       : The policy definition name.
  var path_564138 = newJObject()
  var query_564139 = newJObject()
  add(query_564139, "api-version", newJString(apiVersion))
  add(path_564138, "subscriptionId", newJString(subscriptionId))
  add(path_564138, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_564137.call(path_564138, query_564139, nil, nil, nil)

var policyDefinitionsGet* = Call_PolicyDefinitionsGet_564130(
    name: "policyDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGet_564131, base: "",
    url: url_PolicyDefinitionsGet_564132, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsDelete_564169 = ref object of OpenApiRestCall_563564
proc url_PolicyDefinitionsDelete_564171(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyDefinitionsDelete_564170(path: JsonNode; query: JsonNode;
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
  var valid_564172 = path.getOrDefault("subscriptionId")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "subscriptionId", valid_564172
  var valid_564173 = path.getOrDefault("policyDefinitionName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "policyDefinitionName", valid_564173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564174 = query.getOrDefault("api-version")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "api-version", valid_564174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564175: Call_PolicyDefinitionsDelete_564169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes policy definition.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_PolicyDefinitionsDelete_564169; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsDelete
  ## Deletes policy definition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyDefinitionName: string (required)
  ##                       : The policy definition name.
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  add(query_564178, "api-version", newJString(apiVersion))
  add(path_564177, "subscriptionId", newJString(subscriptionId))
  add(path_564177, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_564176.call(path_564177, query_564178, nil, nil, nil)

var policyDefinitionsDelete* = Call_PolicyDefinitionsDelete_564169(
    name: "policyDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsDelete_564170, base: "",
    url: url_PolicyDefinitionsDelete_564171, schemes: {Scheme.Https})
type
  Call_ProvidersGet_564179 = ref object of OpenApiRestCall_563564
proc url_ProvidersGet_564181(protocol: Scheme; host: string; base: string;
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

proc validate_ProvidersGet_564180(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceProviderNamespace: JString (required)
  ##                            : Namespace of the resource provider.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resourceProviderNamespace` field"
  var valid_564182 = path.getOrDefault("resourceProviderNamespace")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "resourceProviderNamespace", valid_564182
  var valid_564183 = path.getOrDefault("subscriptionId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "subscriptionId", valid_564183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564184 = query.getOrDefault("api-version")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "api-version", valid_564184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564185: Call_ProvidersGet_564179; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource provider.
  ## 
  let valid = call_564185.validator(path, query, header, formData, body)
  let scheme = call_564185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564185.url(scheme.get, call_564185.host, call_564185.base,
                         call_564185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564185, url, valid)

proc call*(call_564186: Call_ProvidersGet_564179; apiVersion: string;
          resourceProviderNamespace: string; subscriptionId: string): Recallable =
  ## providersGet
  ## Gets a resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceProviderNamespace: string (required)
  ##                            : Namespace of the resource provider.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564187 = newJObject()
  var query_564188 = newJObject()
  add(query_564188, "api-version", newJString(apiVersion))
  add(path_564187, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564187, "subscriptionId", newJString(subscriptionId))
  result = call_564186.call(path_564187, query_564188, nil, nil, nil)

var providersGet* = Call_ProvidersGet_564179(name: "providersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}",
    validator: validate_ProvidersGet_564180, base: "", url: url_ProvidersGet_564181,
    schemes: {Scheme.Https})
type
  Call_ProvidersRegister_564189 = ref object of OpenApiRestCall_563564
proc url_ProvidersRegister_564191(protocol: Scheme; host: string; base: string;
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

proc validate_ProvidersRegister_564190(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Registers provider to be used with a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceProviderNamespace: JString (required)
  ##                            : Namespace of the resource provider.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resourceProviderNamespace` field"
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564194 = query.getOrDefault("api-version")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "api-version", valid_564194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564195: Call_ProvidersRegister_564189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers provider to be used with a subscription.
  ## 
  let valid = call_564195.validator(path, query, header, formData, body)
  let scheme = call_564195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564195.url(scheme.get, call_564195.host, call_564195.base,
                         call_564195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564195, url, valid)

proc call*(call_564196: Call_ProvidersRegister_564189; apiVersion: string;
          resourceProviderNamespace: string; subscriptionId: string): Recallable =
  ## providersRegister
  ## Registers provider to be used with a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceProviderNamespace: string (required)
  ##                            : Namespace of the resource provider.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564197 = newJObject()
  var query_564198 = newJObject()
  add(query_564198, "api-version", newJString(apiVersion))
  add(path_564197, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564197, "subscriptionId", newJString(subscriptionId))
  result = call_564196.call(path_564197, query_564198, nil, nil, nil)

var providersRegister* = Call_ProvidersRegister_564189(name: "providersRegister",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/register",
    validator: validate_ProvidersRegister_564190, base: "",
    url: url_ProvidersRegister_564191, schemes: {Scheme.Https})
type
  Call_ProvidersUnregister_564199 = ref object of OpenApiRestCall_563564
proc url_ProvidersUnregister_564201(protocol: Scheme; host: string; base: string;
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

proc validate_ProvidersUnregister_564200(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Unregisters provider from a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceProviderNamespace: JString (required)
  ##                            : Namespace of the resource provider.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resourceProviderNamespace` field"
  var valid_564202 = path.getOrDefault("resourceProviderNamespace")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "resourceProviderNamespace", valid_564202
  var valid_564203 = path.getOrDefault("subscriptionId")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "subscriptionId", valid_564203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564204 = query.getOrDefault("api-version")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "api-version", valid_564204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564205: Call_ProvidersUnregister_564199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregisters provider from a subscription.
  ## 
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_ProvidersUnregister_564199; apiVersion: string;
          resourceProviderNamespace: string; subscriptionId: string): Recallable =
  ## providersUnregister
  ## Unregisters provider from a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceProviderNamespace: string (required)
  ##                            : Namespace of the resource provider.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  add(query_564208, "api-version", newJString(apiVersion))
  add(path_564207, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  result = call_564206.call(path_564207, query_564208, nil, nil, nil)

var providersUnregister* = Call_ProvidersUnregister_564199(
    name: "providersUnregister", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/unregister",
    validator: validate_ProvidersUnregister_564200, base: "",
    url: url_ProvidersUnregister_564201, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForResourceGroup_564209 = ref object of OpenApiRestCall_563564
proc url_PolicyAssignmentsListForResourceGroup_564211(protocol: Scheme;
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

proc validate_PolicyAssignmentsListForResourceGroup_564210(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets policy assignments of the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564212 = path.getOrDefault("subscriptionId")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "subscriptionId", valid_564212
  var valid_564213 = path.getOrDefault("resourceGroupName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "resourceGroupName", valid_564213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "api-version", valid_564214
  var valid_564215 = query.getOrDefault("$filter")
  valid_564215 = validateParameter(valid_564215, JString, required = false,
                                 default = nil)
  if valid_564215 != nil:
    section.add "$filter", valid_564215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564216: Call_PolicyAssignmentsListForResourceGroup_564209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets policy assignments of the resource group.
  ## 
  let valid = call_564216.validator(path, query, header, formData, body)
  let scheme = call_564216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564216.url(scheme.get, call_564216.host, call_564216.base,
                         call_564216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564216, url, valid)

proc call*(call_564217: Call_PolicyAssignmentsListForResourceGroup_564209;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Filter: string = ""): Recallable =
  ## policyAssignmentsListForResourceGroup
  ## Gets policy assignments of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_564218 = newJObject()
  var query_564219 = newJObject()
  add(query_564219, "api-version", newJString(apiVersion))
  add(path_564218, "subscriptionId", newJString(subscriptionId))
  add(path_564218, "resourceGroupName", newJString(resourceGroupName))
  add(query_564219, "$filter", newJString(Filter))
  result = call_564217.call(path_564218, query_564219, nil, nil, nil)

var policyAssignmentsListForResourceGroup* = Call_PolicyAssignmentsListForResourceGroup_564209(
    name: "policyAssignmentsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForResourceGroup_564210, base: "",
    url: url_PolicyAssignmentsListForResourceGroup_564211, schemes: {Scheme.Https})
type
  Call_ResourceGroupsListResources_564220 = ref object of OpenApiRestCall_563564
proc url_ResourceGroupsListResources_564222(protocol: Scheme; host: string;
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

proc validate_ResourceGroupsListResources_564221(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all of the resources under a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Query parameters. If null is passed returns all resource groups.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564223 = path.getOrDefault("subscriptionId")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "subscriptionId", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroupName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroupName", valid_564224
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Query parameters. If null is passed returns all resource groups.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_564225 = query.getOrDefault("$top")
  valid_564225 = validateParameter(valid_564225, JInt, required = false, default = nil)
  if valid_564225 != nil:
    section.add "$top", valid_564225
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  var valid_564227 = query.getOrDefault("$filter")
  valid_564227 = validateParameter(valid_564227, JString, required = false,
                                 default = nil)
  if valid_564227 != nil:
    section.add "$filter", valid_564227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564228: Call_ResourceGroupsListResources_564220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all of the resources under a subscription.
  ## 
  let valid = call_564228.validator(path, query, header, formData, body)
  let scheme = call_564228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564228.url(scheme.get, call_564228.host, call_564228.base,
                         call_564228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564228, url, valid)

proc call*(call_564229: Call_ResourceGroupsListResources_564220;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## resourceGroupsListResources
  ## Get all of the resources under a subscription.
  ##   Top: int
  ##      : Query parameters. If null is passed returns all resource groups.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Query parameters. If null is passed returns all resource groups.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_564230 = newJObject()
  var query_564231 = newJObject()
  add(query_564231, "$top", newJInt(Top))
  add(query_564231, "api-version", newJString(apiVersion))
  add(path_564230, "subscriptionId", newJString(subscriptionId))
  add(path_564230, "resourceGroupName", newJString(resourceGroupName))
  add(query_564231, "$filter", newJString(Filter))
  result = call_564229.call(path_564230, query_564231, nil, nil, nil)

var resourceGroupsListResources* = Call_ResourceGroupsListResources_564220(
    name: "resourceGroupsListResources", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/resources",
    validator: validate_ResourceGroupsListResources_564221, base: "",
    url: url_ResourceGroupsListResources_564222, schemes: {Scheme.Https})
type
  Call_ResourcesMoveResources_564232 = ref object of OpenApiRestCall_563564
proc url_ResourcesMoveResources_564234(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesMoveResources_564233(path: JsonNode; query: JsonNode;
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
  var valid_564235 = path.getOrDefault("sourceResourceGroupName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "sourceResourceGroupName", valid_564235
  var valid_564236 = path.getOrDefault("subscriptionId")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "subscriptionId", valid_564236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564237 = query.getOrDefault("api-version")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "api-version", valid_564237
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

proc call*(call_564239: Call_ResourcesMoveResources_564232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begin moving resources.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  let valid = call_564239.validator(path, query, header, formData, body)
  let scheme = call_564239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564239.url(scheme.get, call_564239.host, call_564239.base,
                         call_564239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564239, url, valid)

proc call*(call_564240: Call_ResourcesMoveResources_564232; apiVersion: string;
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
  var path_564241 = newJObject()
  var query_564242 = newJObject()
  var body_564243 = newJObject()
  add(query_564242, "api-version", newJString(apiVersion))
  add(path_564241, "sourceResourceGroupName", newJString(sourceResourceGroupName))
  add(path_564241, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564243 = parameters
  result = call_564240.call(path_564241, query_564242, nil, nil, body_564243)

var resourcesMoveResources* = Call_ResourcesMoveResources_564232(
    name: "resourcesMoveResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{sourceResourceGroupName}/moveResources",
    validator: validate_ResourcesMoveResources_564233, base: "",
    url: url_ResourcesMoveResources_564234, schemes: {Scheme.Https})
type
  Call_ResourceGroupsList_564244 = ref object of OpenApiRestCall_563564
proc url_ResourceGroupsList_564246(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceGroupsList_564245(path: JsonNode; query: JsonNode;
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
  var valid_564247 = path.getOrDefault("subscriptionId")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "subscriptionId", valid_564247
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Query parameters. If null is passed returns all resource groups.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_564248 = query.getOrDefault("$top")
  valid_564248 = validateParameter(valid_564248, JInt, required = false, default = nil)
  if valid_564248 != nil:
    section.add "$top", valid_564248
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564249 = query.getOrDefault("api-version")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "api-version", valid_564249
  var valid_564250 = query.getOrDefault("$filter")
  valid_564250 = validateParameter(valid_564250, JString, required = false,
                                 default = nil)
  if valid_564250 != nil:
    section.add "$filter", valid_564250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564251: Call_ResourceGroupsList_564244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a collection of resource groups.
  ## 
  let valid = call_564251.validator(path, query, header, formData, body)
  let scheme = call_564251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564251.url(scheme.get, call_564251.host, call_564251.base,
                         call_564251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564251, url, valid)

proc call*(call_564252: Call_ResourceGroupsList_564244; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## resourceGroupsList
  ## Gets a collection of resource groups.
  ##   Top: int
  ##      : Query parameters. If null is passed returns all resource groups.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_564253 = newJObject()
  var query_564254 = newJObject()
  add(query_564254, "$top", newJInt(Top))
  add(query_564254, "api-version", newJString(apiVersion))
  add(path_564253, "subscriptionId", newJString(subscriptionId))
  add(query_564254, "$filter", newJString(Filter))
  result = call_564252.call(path_564253, query_564254, nil, nil, nil)

var resourceGroupsList* = Call_ResourceGroupsList_564244(
    name: "resourceGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resourcegroups",
    validator: validate_ResourceGroupsList_564245, base: "",
    url: url_ResourceGroupsList_564246, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCreateOrUpdate_564265 = ref object of OpenApiRestCall_563564
proc url_ResourceGroupsCreateOrUpdate_564267(protocol: Scheme; host: string;
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

proc validate_ResourceGroupsCreateOrUpdate_564266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to be created or updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564268 = path.getOrDefault("subscriptionId")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "subscriptionId", valid_564268
  var valid_564269 = path.getOrDefault("resourceGroupName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "resourceGroupName", valid_564269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564270 = query.getOrDefault("api-version")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "api-version", valid_564270
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

proc call*(call_564272: Call_ResourceGroupsCreateOrUpdate_564265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource group.
  ## 
  let valid = call_564272.validator(path, query, header, formData, body)
  let scheme = call_564272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564272.url(scheme.get, call_564272.host, call_564272.base,
                         call_564272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564272, url, valid)

proc call*(call_564273: Call_ResourceGroupsCreateOrUpdate_564265;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsCreateOrUpdate
  ## Create a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to be created or updated.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update resource group service operation.
  var path_564274 = newJObject()
  var query_564275 = newJObject()
  var body_564276 = newJObject()
  add(query_564275, "api-version", newJString(apiVersion))
  add(path_564274, "subscriptionId", newJString(subscriptionId))
  add(path_564274, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564276 = parameters
  result = call_564273.call(path_564274, query_564275, nil, nil, body_564276)

var resourceGroupsCreateOrUpdate* = Call_ResourceGroupsCreateOrUpdate_564265(
    name: "resourceGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCreateOrUpdate_564266, base: "",
    url: url_ResourceGroupsCreateOrUpdate_564267, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCheckExistence_564287 = ref object of OpenApiRestCall_563564
proc url_ResourceGroupsCheckExistence_564289(protocol: Scheme; host: string;
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

proc validate_ResourceGroupsCheckExistence_564288(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether resource group exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564290 = path.getOrDefault("subscriptionId")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "subscriptionId", valid_564290
  var valid_564291 = path.getOrDefault("resourceGroupName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "resourceGroupName", valid_564291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564292 = query.getOrDefault("api-version")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "api-version", valid_564292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_ResourceGroupsCheckExistence_564287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether resource group exists.
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_ResourceGroupsCheckExistence_564287;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## resourceGroupsCheckExistence
  ## Checks whether resource group exists.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  add(query_564296, "api-version", newJString(apiVersion))
  add(path_564295, "subscriptionId", newJString(subscriptionId))
  add(path_564295, "resourceGroupName", newJString(resourceGroupName))
  result = call_564294.call(path_564295, query_564296, nil, nil, nil)

var resourceGroupsCheckExistence* = Call_ResourceGroupsCheckExistence_564287(
    name: "resourceGroupsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCheckExistence_564288, base: "",
    url: url_ResourceGroupsCheckExistence_564289, schemes: {Scheme.Https})
type
  Call_ResourceGroupsGet_564255 = ref object of OpenApiRestCall_563564
proc url_ResourceGroupsGet_564257(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceGroupsGet_564256(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  var valid_564259 = path.getOrDefault("resourceGroupName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "resourceGroupName", valid_564259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564260 = query.getOrDefault("api-version")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "api-version", valid_564260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564261: Call_ResourceGroupsGet_564255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a resource group.
  ## 
  let valid = call_564261.validator(path, query, header, formData, body)
  let scheme = call_564261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564261.url(scheme.get, call_564261.host, call_564261.base,
                         call_564261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564261, url, valid)

proc call*(call_564262: Call_ResourceGroupsGet_564255; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## resourceGroupsGet
  ## Get a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  var path_564263 = newJObject()
  var query_564264 = newJObject()
  add(query_564264, "api-version", newJString(apiVersion))
  add(path_564263, "subscriptionId", newJString(subscriptionId))
  add(path_564263, "resourceGroupName", newJString(resourceGroupName))
  result = call_564262.call(path_564263, query_564264, nil, nil, nil)

var resourceGroupsGet* = Call_ResourceGroupsGet_564255(name: "resourceGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsGet_564256, base: "",
    url: url_ResourceGroupsGet_564257, schemes: {Scheme.Https})
type
  Call_ResourceGroupsPatch_564297 = ref object of OpenApiRestCall_563564
proc url_ResourceGroupsPatch_564299(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceGroupsPatch_564298(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource groups, though if a field is unspecified current value will be carried over. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to be created or updated. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564300 = path.getOrDefault("subscriptionId")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "subscriptionId", valid_564300
  var valid_564301 = path.getOrDefault("resourceGroupName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "resourceGroupName", valid_564301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564302 = query.getOrDefault("api-version")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "api-version", valid_564302
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

proc call*(call_564304: Call_ResourceGroupsPatch_564297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource groups, though if a field is unspecified current value will be carried over. 
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_ResourceGroupsPatch_564297; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## resourceGroupsPatch
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource groups, though if a field is unspecified current value will be carried over. 
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to be created or updated. The name is case insensitive.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update state resource group service operation.
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  var body_564308 = newJObject()
  add(query_564307, "api-version", newJString(apiVersion))
  add(path_564306, "subscriptionId", newJString(subscriptionId))
  add(path_564306, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564308 = parameters
  result = call_564305.call(path_564306, query_564307, nil, nil, body_564308)

var resourceGroupsPatch* = Call_ResourceGroupsPatch_564297(
    name: "resourceGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsPatch_564298, base: "",
    url: url_ResourceGroupsPatch_564299, schemes: {Scheme.Https})
type
  Call_ResourceGroupsDelete_564277 = ref object of OpenApiRestCall_563564
proc url_ResourceGroupsDelete_564279(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceGroupsDelete_564278(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Begin deleting resource group.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to be deleted. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564280 = path.getOrDefault("subscriptionId")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "subscriptionId", valid_564280
  var valid_564281 = path.getOrDefault("resourceGroupName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "resourceGroupName", valid_564281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564282 = query.getOrDefault("api-version")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "api-version", valid_564282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564283: Call_ResourceGroupsDelete_564277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begin deleting resource group.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  let valid = call_564283.validator(path, query, header, formData, body)
  let scheme = call_564283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564283.url(scheme.get, call_564283.host, call_564283.base,
                         call_564283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564283, url, valid)

proc call*(call_564284: Call_ResourceGroupsDelete_564277; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## resourceGroupsDelete
  ## Begin deleting resource group.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to be deleted. The name is case insensitive.
  var path_564285 = newJObject()
  var query_564286 = newJObject()
  add(query_564286, "api-version", newJString(apiVersion))
  add(path_564285, "subscriptionId", newJString(subscriptionId))
  add(path_564285, "resourceGroupName", newJString(resourceGroupName))
  result = call_564284.call(path_564285, query_564286, nil, nil, nil)

var resourceGroupsDelete* = Call_ResourceGroupsDelete_564277(
    name: "resourceGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsDelete_564278, base: "",
    url: url_ResourceGroupsDelete_564279, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsList_564309 = ref object of OpenApiRestCall_563564
proc url_DeploymentOperationsList_564311(protocol: Scheme; host: string;
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

proc validate_DeploymentOperationsList_564310(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of deployments operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_564312 = path.getOrDefault("deploymentName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "deploymentName", valid_564312
  var valid_564313 = path.getOrDefault("subscriptionId")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "subscriptionId", valid_564313
  var valid_564314 = path.getOrDefault("resourceGroupName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "resourceGroupName", valid_564314
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Query parameters.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564315 = query.getOrDefault("$top")
  valid_564315 = validateParameter(valid_564315, JInt, required = false, default = nil)
  if valid_564315 != nil:
    section.add "$top", valid_564315
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564316 = query.getOrDefault("api-version")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "api-version", valid_564316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564317: Call_DeploymentOperationsList_564309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of deployments operations.
  ## 
  let valid = call_564317.validator(path, query, header, formData, body)
  let scheme = call_564317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564317.url(scheme.get, call_564317.host, call_564317.base,
                         call_564317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564317, url, valid)

proc call*(call_564318: Call_DeploymentOperationsList_564309; apiVersion: string;
          deploymentName: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0): Recallable =
  ## deploymentOperationsList
  ## Gets a list of deployments operations.
  ##   Top: int
  ##      : Query parameters.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564319 = newJObject()
  var query_564320 = newJObject()
  add(query_564320, "$top", newJInt(Top))
  add(query_564320, "api-version", newJString(apiVersion))
  add(path_564319, "deploymentName", newJString(deploymentName))
  add(path_564319, "subscriptionId", newJString(subscriptionId))
  add(path_564319, "resourceGroupName", newJString(resourceGroupName))
  result = call_564318.call(path_564319, query_564320, nil, nil, nil)

var deploymentOperationsList* = Call_DeploymentOperationsList_564309(
    name: "deploymentOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsList_564310, base: "",
    url: url_DeploymentOperationsList_564311, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGet_564321 = ref object of OpenApiRestCall_563564
proc url_DeploymentOperationsGet_564323(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentOperationsGet_564322(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of deployments operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   operationId: JString (required)
  ##              : Operation Id.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_564324 = path.getOrDefault("deploymentName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "deploymentName", valid_564324
  var valid_564325 = path.getOrDefault("operationId")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "operationId", valid_564325
  var valid_564326 = path.getOrDefault("subscriptionId")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "subscriptionId", valid_564326
  var valid_564327 = path.getOrDefault("resourceGroupName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "resourceGroupName", valid_564327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564328 = query.getOrDefault("api-version")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "api-version", valid_564328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564329: Call_DeploymentOperationsGet_564321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of deployments operations.
  ## 
  let valid = call_564329.validator(path, query, header, formData, body)
  let scheme = call_564329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564329.url(scheme.get, call_564329.host, call_564329.base,
                         call_564329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564329, url, valid)

proc call*(call_564330: Call_DeploymentOperationsGet_564321; apiVersion: string;
          deploymentName: string; operationId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## deploymentOperationsGet
  ## Get a list of deployments operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   operationId: string (required)
  ##              : Operation Id.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564331 = newJObject()
  var query_564332 = newJObject()
  add(query_564332, "api-version", newJString(apiVersion))
  add(path_564331, "deploymentName", newJString(deploymentName))
  add(path_564331, "operationId", newJString(operationId))
  add(path_564331, "subscriptionId", newJString(subscriptionId))
  add(path_564331, "resourceGroupName", newJString(resourceGroupName))
  result = call_564330.call(path_564331, query_564332, nil, nil, nil)

var deploymentOperationsGet* = Call_DeploymentOperationsGet_564321(
    name: "deploymentOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGet_564322, base: "",
    url: url_DeploymentOperationsGet_564323, schemes: {Scheme.Https})
type
  Call_DeploymentsList_564333 = ref object of OpenApiRestCall_563564
proc url_DeploymentsList_564335(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsList_564334(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get a list of deployments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to filter by. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564336 = path.getOrDefault("subscriptionId")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "subscriptionId", valid_564336
  var valid_564337 = path.getOrDefault("resourceGroupName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "resourceGroupName", valid_564337
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Query parameters. If null is passed returns all deployments.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_564338 = query.getOrDefault("$top")
  valid_564338 = validateParameter(valid_564338, JInt, required = false, default = nil)
  if valid_564338 != nil:
    section.add "$top", valid_564338
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564339 = query.getOrDefault("api-version")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "api-version", valid_564339
  var valid_564340 = query.getOrDefault("$filter")
  valid_564340 = validateParameter(valid_564340, JString, required = false,
                                 default = nil)
  if valid_564340 != nil:
    section.add "$filter", valid_564340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564341: Call_DeploymentsList_564333; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of deployments.
  ## 
  let valid = call_564341.validator(path, query, header, formData, body)
  let scheme = call_564341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564341.url(scheme.get, call_564341.host, call_564341.base,
                         call_564341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564341, url, valid)

proc call*(call_564342: Call_DeploymentsList_564333; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          Filter: string = ""): Recallable =
  ## deploymentsList
  ## Get a list of deployments.
  ##   Top: int
  ##      : Query parameters. If null is passed returns all deployments.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to filter by. The name is case insensitive.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_564343 = newJObject()
  var query_564344 = newJObject()
  add(query_564344, "$top", newJInt(Top))
  add(query_564344, "api-version", newJString(apiVersion))
  add(path_564343, "subscriptionId", newJString(subscriptionId))
  add(path_564343, "resourceGroupName", newJString(resourceGroupName))
  add(query_564344, "$filter", newJString(Filter))
  result = call_564342.call(path_564343, query_564344, nil, nil, nil)

var deploymentsList* = Call_DeploymentsList_564333(name: "deploymentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsList_564334, base: "", url: url_DeploymentsList_564335,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdate_564356 = ref object of OpenApiRestCall_563564
proc url_DeploymentsCreateOrUpdate_564358(protocol: Scheme; host: string;
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

proc validate_DeploymentsCreateOrUpdate_564357(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a named template deployment using a template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_564359 = path.getOrDefault("deploymentName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "deploymentName", valid_564359
  var valid_564360 = path.getOrDefault("subscriptionId")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "subscriptionId", valid_564360
  var valid_564361 = path.getOrDefault("resourceGroupName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "resourceGroupName", valid_564361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564362 = query.getOrDefault("api-version")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "api-version", valid_564362
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

proc call*(call_564364: Call_DeploymentsCreateOrUpdate_564356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a named template deployment using a template.
  ## 
  let valid = call_564364.validator(path, query, header, formData, body)
  let scheme = call_564364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564364.url(scheme.get, call_564364.host, call_564364.base,
                         call_564364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564364, url, valid)

proc call*(call_564365: Call_DeploymentsCreateOrUpdate_564356; apiVersion: string;
          deploymentName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## deploymentsCreateOrUpdate
  ## Create a named template deployment using a template.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  var path_564366 = newJObject()
  var query_564367 = newJObject()
  var body_564368 = newJObject()
  add(query_564367, "api-version", newJString(apiVersion))
  add(path_564366, "deploymentName", newJString(deploymentName))
  add(path_564366, "subscriptionId", newJString(subscriptionId))
  add(path_564366, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564368 = parameters
  result = call_564365.call(path_564366, query_564367, nil, nil, body_564368)

var deploymentsCreateOrUpdate* = Call_DeploymentsCreateOrUpdate_564356(
    name: "deploymentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdate_564357, base: "",
    url: url_DeploymentsCreateOrUpdate_564358, schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistence_564380 = ref object of OpenApiRestCall_563564
proc url_DeploymentsCheckExistence_564382(protocol: Scheme; host: string;
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

proc validate_DeploymentsCheckExistence_564381(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_564383 = path.getOrDefault("deploymentName")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "deploymentName", valid_564383
  var valid_564384 = path.getOrDefault("subscriptionId")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "subscriptionId", valid_564384
  var valid_564385 = path.getOrDefault("resourceGroupName")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "resourceGroupName", valid_564385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564386 = query.getOrDefault("api-version")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "api-version", valid_564386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564387: Call_DeploymentsCheckExistence_564380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether deployment exists.
  ## 
  let valid = call_564387.validator(path, query, header, formData, body)
  let scheme = call_564387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564387.url(scheme.get, call_564387.host, call_564387.base,
                         call_564387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564387, url, valid)

proc call*(call_564388: Call_DeploymentsCheckExistence_564380; apiVersion: string;
          deploymentName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## deploymentsCheckExistence
  ## Checks whether deployment exists.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  var path_564389 = newJObject()
  var query_564390 = newJObject()
  add(query_564390, "api-version", newJString(apiVersion))
  add(path_564389, "deploymentName", newJString(deploymentName))
  add(path_564389, "subscriptionId", newJString(subscriptionId))
  add(path_564389, "resourceGroupName", newJString(resourceGroupName))
  result = call_564388.call(path_564389, query_564390, nil, nil, nil)

var deploymentsCheckExistence* = Call_DeploymentsCheckExistence_564380(
    name: "deploymentsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistence_564381, base: "",
    url: url_DeploymentsCheckExistence_564382, schemes: {Scheme.Https})
type
  Call_DeploymentsGet_564345 = ref object of OpenApiRestCall_563564
proc url_DeploymentsGet_564347(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsGet_564346(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_564348 = path.getOrDefault("deploymentName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "deploymentName", valid_564348
  var valid_564349 = path.getOrDefault("subscriptionId")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "subscriptionId", valid_564349
  var valid_564350 = path.getOrDefault("resourceGroupName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "resourceGroupName", valid_564350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564351 = query.getOrDefault("api-version")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "api-version", valid_564351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564352: Call_DeploymentsGet_564345; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a deployment.
  ## 
  let valid = call_564352.validator(path, query, header, formData, body)
  let scheme = call_564352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564352.url(scheme.get, call_564352.host, call_564352.base,
                         call_564352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564352, url, valid)

proc call*(call_564353: Call_DeploymentsGet_564345; apiVersion: string;
          deploymentName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## deploymentsGet
  ## Get a deployment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  var path_564354 = newJObject()
  var query_564355 = newJObject()
  add(query_564355, "api-version", newJString(apiVersion))
  add(path_564354, "deploymentName", newJString(deploymentName))
  add(path_564354, "subscriptionId", newJString(subscriptionId))
  add(path_564354, "resourceGroupName", newJString(resourceGroupName))
  result = call_564353.call(path_564354, query_564355, nil, nil, nil)

var deploymentsGet* = Call_DeploymentsGet_564345(name: "deploymentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGet_564346, base: "", url: url_DeploymentsGet_564347,
    schemes: {Scheme.Https})
type
  Call_DeploymentsDelete_564369 = ref object of OpenApiRestCall_563564
proc url_DeploymentsDelete_564371(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsDelete_564370(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Begin deleting deployment.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_564372 = path.getOrDefault("deploymentName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "deploymentName", valid_564372
  var valid_564373 = path.getOrDefault("subscriptionId")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "subscriptionId", valid_564373
  var valid_564374 = path.getOrDefault("resourceGroupName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "resourceGroupName", valid_564374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564375 = query.getOrDefault("api-version")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "api-version", valid_564375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564376: Call_DeploymentsDelete_564369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begin deleting deployment.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  let valid = call_564376.validator(path, query, header, formData, body)
  let scheme = call_564376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564376.url(scheme.get, call_564376.host, call_564376.base,
                         call_564376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564376, url, valid)

proc call*(call_564377: Call_DeploymentsDelete_564369; apiVersion: string;
          deploymentName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## deploymentsDelete
  ## Begin deleting deployment.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to be deleted.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564378 = newJObject()
  var query_564379 = newJObject()
  add(query_564379, "api-version", newJString(apiVersion))
  add(path_564378, "deploymentName", newJString(deploymentName))
  add(path_564378, "subscriptionId", newJString(subscriptionId))
  add(path_564378, "resourceGroupName", newJString(resourceGroupName))
  result = call_564377.call(path_564378, query_564379, nil, nil, nil)

var deploymentsDelete* = Call_DeploymentsDelete_564369(name: "deploymentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDelete_564370, base: "",
    url: url_DeploymentsDelete_564371, schemes: {Scheme.Https})
type
  Call_DeploymentsCancel_564391 = ref object of OpenApiRestCall_563564
proc url_DeploymentsCancel_564393(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsCancel_564392(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Cancel a currently running template deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_564394 = path.getOrDefault("deploymentName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "deploymentName", valid_564394
  var valid_564395 = path.getOrDefault("subscriptionId")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "subscriptionId", valid_564395
  var valid_564396 = path.getOrDefault("resourceGroupName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "resourceGroupName", valid_564396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564397 = query.getOrDefault("api-version")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "api-version", valid_564397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564398: Call_DeploymentsCancel_564391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a currently running template deployment.
  ## 
  let valid = call_564398.validator(path, query, header, formData, body)
  let scheme = call_564398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564398.url(scheme.get, call_564398.host, call_564398.base,
                         call_564398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564398, url, valid)

proc call*(call_564399: Call_DeploymentsCancel_564391; apiVersion: string;
          deploymentName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## deploymentsCancel
  ## Cancel a currently running template deployment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564400 = newJObject()
  var query_564401 = newJObject()
  add(query_564401, "api-version", newJString(apiVersion))
  add(path_564400, "deploymentName", newJString(deploymentName))
  add(path_564400, "subscriptionId", newJString(subscriptionId))
  add(path_564400, "resourceGroupName", newJString(resourceGroupName))
  result = call_564399.call(path_564400, query_564401, nil, nil, nil)

var deploymentsCancel* = Call_DeploymentsCancel_564391(name: "deploymentsCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancel_564392, base: "",
    url: url_DeploymentsCancel_564393, schemes: {Scheme.Https})
type
  Call_DeploymentsValidate_564402 = ref object of OpenApiRestCall_563564
proc url_DeploymentsValidate_564404(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsValidate_564403(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Validate a deployment template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_564405 = path.getOrDefault("deploymentName")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "deploymentName", valid_564405
  var valid_564406 = path.getOrDefault("subscriptionId")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "subscriptionId", valid_564406
  var valid_564407 = path.getOrDefault("resourceGroupName")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "resourceGroupName", valid_564407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564408 = query.getOrDefault("api-version")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "api-version", valid_564408
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

proc call*(call_564410: Call_DeploymentsValidate_564402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validate a deployment template.
  ## 
  let valid = call_564410.validator(path, query, header, formData, body)
  let scheme = call_564410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564410.url(scheme.get, call_564410.host, call_564410.base,
                         call_564410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564410, url, valid)

proc call*(call_564411: Call_DeploymentsValidate_564402; apiVersion: string;
          deploymentName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## deploymentsValidate
  ## Validate a deployment template.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   parameters: JObject (required)
  ##             : Deployment to validate.
  var path_564412 = newJObject()
  var query_564413 = newJObject()
  var body_564414 = newJObject()
  add(query_564413, "api-version", newJString(apiVersion))
  add(path_564412, "deploymentName", newJString(deploymentName))
  add(path_564412, "subscriptionId", newJString(subscriptionId))
  add(path_564412, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564414 = parameters
  result = call_564411.call(path_564412, query_564413, nil, nil, body_564414)

var deploymentsValidate* = Call_DeploymentsValidate_564402(
    name: "deploymentsValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidate_564403, base: "",
    url: url_DeploymentsValidate_564404, schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdate_564429 = ref object of OpenApiRestCall_563564
proc url_ResourcesCreateOrUpdate_564431(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesCreateOrUpdate_564430(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Resource identity.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parentResourcePath: JString (required)
  ##                     : Resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564432 = path.getOrDefault("resourceType")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "resourceType", valid_564432
  var valid_564433 = path.getOrDefault("resourceProviderNamespace")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "resourceProviderNamespace", valid_564433
  var valid_564434 = path.getOrDefault("subscriptionId")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "subscriptionId", valid_564434
  var valid_564435 = path.getOrDefault("parentResourcePath")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "parentResourcePath", valid_564435
  var valid_564436 = path.getOrDefault("resourceGroupName")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "resourceGroupName", valid_564436
  var valid_564437 = path.getOrDefault("resourceName")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "resourceName", valid_564437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564438 = query.getOrDefault("api-version")
  valid_564438 = validateParameter(valid_564438, JString, required = true,
                                 default = nil)
  if valid_564438 != nil:
    section.add "api-version", valid_564438
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

proc call*(call_564440: Call_ResourcesCreateOrUpdate_564429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource.
  ## 
  let valid = call_564440.validator(path, query, header, formData, body)
  let scheme = call_564440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564440.url(scheme.get, call_564440.host, call_564440.base,
                         call_564440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564440, url, valid)

proc call*(call_564441: Call_ResourcesCreateOrUpdate_564429; apiVersion: string;
          resourceType: string; resourceProviderNamespace: string;
          subscriptionId: string; parentResourcePath: string;
          resourceGroupName: string; resourceName: string; parameters: JsonNode): Recallable =
  ## resourcesCreateOrUpdate
  ## Create a resource.
  ##   apiVersion: string (required)
  ##   resourceType: string (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parentResourcePath: string (required)
  ##                     : Resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : Resource identity.
  ##   parameters: JObject (required)
  ##             : Create or update resource parameters.
  var path_564442 = newJObject()
  var query_564443 = newJObject()
  var body_564444 = newJObject()
  add(query_564443, "api-version", newJString(apiVersion))
  add(path_564442, "resourceType", newJString(resourceType))
  add(path_564442, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564442, "subscriptionId", newJString(subscriptionId))
  add(path_564442, "parentResourcePath", newJString(parentResourcePath))
  add(path_564442, "resourceGroupName", newJString(resourceGroupName))
  add(path_564442, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_564444 = parameters
  result = call_564441.call(path_564442, query_564443, nil, nil, body_564444)

var resourcesCreateOrUpdate* = Call_ResourcesCreateOrUpdate_564429(
    name: "resourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCreateOrUpdate_564430, base: "",
    url: url_ResourcesCreateOrUpdate_564431, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistence_564459 = ref object of OpenApiRestCall_563564
proc url_ResourcesCheckExistence_564461(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesCheckExistence_564460(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Resource identity.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parentResourcePath: JString (required)
  ##                     : Resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564462 = path.getOrDefault("resourceType")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "resourceType", valid_564462
  var valid_564463 = path.getOrDefault("resourceProviderNamespace")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "resourceProviderNamespace", valid_564463
  var valid_564464 = path.getOrDefault("subscriptionId")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "subscriptionId", valid_564464
  var valid_564465 = path.getOrDefault("parentResourcePath")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "parentResourcePath", valid_564465
  var valid_564466 = path.getOrDefault("resourceGroupName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "resourceGroupName", valid_564466
  var valid_564467 = path.getOrDefault("resourceName")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "resourceName", valid_564467
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564468 = query.getOrDefault("api-version")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "api-version", valid_564468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564469: Call_ResourcesCheckExistence_564459; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether resource exists.
  ## 
  let valid = call_564469.validator(path, query, header, formData, body)
  let scheme = call_564469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564469.url(scheme.get, call_564469.host, call_564469.base,
                         call_564469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564469, url, valid)

proc call*(call_564470: Call_ResourcesCheckExistence_564459; apiVersion: string;
          resourceType: string; resourceProviderNamespace: string;
          subscriptionId: string; parentResourcePath: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## resourcesCheckExistence
  ## Checks whether resource exists.
  ##   apiVersion: string (required)
  ##   resourceType: string (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parentResourcePath: string (required)
  ##                     : Resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : Resource identity.
  var path_564471 = newJObject()
  var query_564472 = newJObject()
  add(query_564472, "api-version", newJString(apiVersion))
  add(path_564471, "resourceType", newJString(resourceType))
  add(path_564471, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564471, "subscriptionId", newJString(subscriptionId))
  add(path_564471, "parentResourcePath", newJString(parentResourcePath))
  add(path_564471, "resourceGroupName", newJString(resourceGroupName))
  add(path_564471, "resourceName", newJString(resourceName))
  result = call_564470.call(path_564471, query_564472, nil, nil, nil)

var resourcesCheckExistence* = Call_ResourcesCheckExistence_564459(
    name: "resourcesCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCheckExistence_564460, base: "",
    url: url_ResourcesCheckExistence_564461, schemes: {Scheme.Https})
type
  Call_ResourcesGet_564415 = ref object of OpenApiRestCall_563564
proc url_ResourcesGet_564417(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesGet_564416(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a resource belonging to a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Resource identity.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parentResourcePath: JString (required)
  ##                     : Resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564418 = path.getOrDefault("resourceType")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "resourceType", valid_564418
  var valid_564419 = path.getOrDefault("resourceProviderNamespace")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "resourceProviderNamespace", valid_564419
  var valid_564420 = path.getOrDefault("subscriptionId")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "subscriptionId", valid_564420
  var valid_564421 = path.getOrDefault("parentResourcePath")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "parentResourcePath", valid_564421
  var valid_564422 = path.getOrDefault("resourceGroupName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "resourceGroupName", valid_564422
  var valid_564423 = path.getOrDefault("resourceName")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "resourceName", valid_564423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564424 = query.getOrDefault("api-version")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "api-version", valid_564424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564425: Call_ResourcesGet_564415; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a resource belonging to a resource group.
  ## 
  let valid = call_564425.validator(path, query, header, formData, body)
  let scheme = call_564425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564425.url(scheme.get, call_564425.host, call_564425.base,
                         call_564425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564425, url, valid)

proc call*(call_564426: Call_ResourcesGet_564415; apiVersion: string;
          resourceType: string; resourceProviderNamespace: string;
          subscriptionId: string; parentResourcePath: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## resourcesGet
  ## Returns a resource belonging to a resource group.
  ##   apiVersion: string (required)
  ##   resourceType: string (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parentResourcePath: string (required)
  ##                     : Resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : Resource identity.
  var path_564427 = newJObject()
  var query_564428 = newJObject()
  add(query_564428, "api-version", newJString(apiVersion))
  add(path_564427, "resourceType", newJString(resourceType))
  add(path_564427, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564427, "subscriptionId", newJString(subscriptionId))
  add(path_564427, "parentResourcePath", newJString(parentResourcePath))
  add(path_564427, "resourceGroupName", newJString(resourceGroupName))
  add(path_564427, "resourceName", newJString(resourceName))
  result = call_564426.call(path_564427, query_564428, nil, nil, nil)

var resourcesGet* = Call_ResourcesGet_564415(name: "resourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesGet_564416, base: "", url: url_ResourcesGet_564417,
    schemes: {Scheme.Https})
type
  Call_ResourcesUpdate_564473 = ref object of OpenApiRestCall_563564
proc url_ResourcesUpdate_564475(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesUpdate_564474(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource to update.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : The name of the resource to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564476 = path.getOrDefault("resourceType")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "resourceType", valid_564476
  var valid_564477 = path.getOrDefault("resourceProviderNamespace")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "resourceProviderNamespace", valid_564477
  var valid_564478 = path.getOrDefault("subscriptionId")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "subscriptionId", valid_564478
  var valid_564479 = path.getOrDefault("parentResourcePath")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "parentResourcePath", valid_564479
  var valid_564480 = path.getOrDefault("resourceGroupName")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "resourceGroupName", valid_564480
  var valid_564481 = path.getOrDefault("resourceName")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "resourceName", valid_564481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564482 = query.getOrDefault("api-version")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "api-version", valid_564482
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

proc call*(call_564484: Call_ResourcesUpdate_564473; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource.
  ## 
  let valid = call_564484.validator(path, query, header, formData, body)
  let scheme = call_564484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564484.url(scheme.get, call_564484.host, call_564484.base,
                         call_564484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564484, url, valid)

proc call*(call_564485: Call_ResourcesUpdate_564473; apiVersion: string;
          resourceType: string; resourceProviderNamespace: string;
          subscriptionId: string; parentResourcePath: string;
          resourceGroupName: string; resourceName: string; parameters: JsonNode): Recallable =
  ## resourcesUpdate
  ## Updates a resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceType: string (required)
  ##               : The resource type of the resource to update.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : The name of the resource to update.
  ##   parameters: JObject (required)
  ##             : Parameters for updating the resource.
  var path_564486 = newJObject()
  var query_564487 = newJObject()
  var body_564488 = newJObject()
  add(query_564487, "api-version", newJString(apiVersion))
  add(path_564486, "resourceType", newJString(resourceType))
  add(path_564486, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564486, "subscriptionId", newJString(subscriptionId))
  add(path_564486, "parentResourcePath", newJString(parentResourcePath))
  add(path_564486, "resourceGroupName", newJString(resourceGroupName))
  add(path_564486, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_564488 = parameters
  result = call_564485.call(path_564486, query_564487, nil, nil, body_564488)

var resourcesUpdate* = Call_ResourcesUpdate_564473(name: "resourcesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesUpdate_564474, base: "", url: url_ResourcesUpdate_564475,
    schemes: {Scheme.Https})
type
  Call_ResourcesDelete_564445 = ref object of OpenApiRestCall_563564
proc url_ResourcesDelete_564447(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesDelete_564446(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete resource and all of its resources. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: JString (required)
  ##                            : Resource identity.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parentResourcePath: JString (required)
  ##                     : Resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564448 = path.getOrDefault("resourceType")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "resourceType", valid_564448
  var valid_564449 = path.getOrDefault("resourceProviderNamespace")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "resourceProviderNamespace", valid_564449
  var valid_564450 = path.getOrDefault("subscriptionId")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "subscriptionId", valid_564450
  var valid_564451 = path.getOrDefault("parentResourcePath")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "parentResourcePath", valid_564451
  var valid_564452 = path.getOrDefault("resourceGroupName")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "resourceGroupName", valid_564452
  var valid_564453 = path.getOrDefault("resourceName")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "resourceName", valid_564453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564454 = query.getOrDefault("api-version")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "api-version", valid_564454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564455: Call_ResourcesDelete_564445; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete resource and all of its resources. 
  ## 
  let valid = call_564455.validator(path, query, header, formData, body)
  let scheme = call_564455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564455.url(scheme.get, call_564455.host, call_564455.base,
                         call_564455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564455, url, valid)

proc call*(call_564456: Call_ResourcesDelete_564445; apiVersion: string;
          resourceType: string; resourceProviderNamespace: string;
          subscriptionId: string; parentResourcePath: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## resourcesDelete
  ## Delete resource and all of its resources. 
  ##   apiVersion: string (required)
  ##   resourceType: string (required)
  ##               : Resource identity.
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parentResourcePath: string (required)
  ##                     : Resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : Resource identity.
  var path_564457 = newJObject()
  var query_564458 = newJObject()
  add(query_564458, "api-version", newJString(apiVersion))
  add(path_564457, "resourceType", newJString(resourceType))
  add(path_564457, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564457, "subscriptionId", newJString(subscriptionId))
  add(path_564457, "parentResourcePath", newJString(parentResourcePath))
  add(path_564457, "resourceGroupName", newJString(resourceGroupName))
  add(path_564457, "resourceName", newJString(resourceName))
  result = call_564456.call(path_564457, query_564458, nil, nil, nil)

var resourcesDelete* = Call_ResourcesDelete_564445(name: "resourcesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesDelete_564446, base: "", url: url_ResourcesDelete_564447,
    schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForResource_564489 = ref object of OpenApiRestCall_563564
proc url_PolicyAssignmentsListForResource_564491(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsListForResource_564490(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets policy assignments of the resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The name of the resource provider.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource path.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceName: JString (required)
  ##               : The resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564492 = path.getOrDefault("resourceType")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "resourceType", valid_564492
  var valid_564493 = path.getOrDefault("resourceProviderNamespace")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "resourceProviderNamespace", valid_564493
  var valid_564494 = path.getOrDefault("subscriptionId")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "subscriptionId", valid_564494
  var valid_564495 = path.getOrDefault("parentResourcePath")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "parentResourcePath", valid_564495
  var valid_564496 = path.getOrDefault("resourceGroupName")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "resourceGroupName", valid_564496
  var valid_564497 = path.getOrDefault("resourceName")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "resourceName", valid_564497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564498 = query.getOrDefault("api-version")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "api-version", valid_564498
  var valid_564499 = query.getOrDefault("$filter")
  valid_564499 = validateParameter(valid_564499, JString, required = false,
                                 default = nil)
  if valid_564499 != nil:
    section.add "$filter", valid_564499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564500: Call_PolicyAssignmentsListForResource_564489;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets policy assignments of the resource.
  ## 
  let valid = call_564500.validator(path, query, header, formData, body)
  let scheme = call_564500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564500.url(scheme.get, call_564500.host, call_564500.base,
                         call_564500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564500, url, valid)

proc call*(call_564501: Call_PolicyAssignmentsListForResource_564489;
          apiVersion: string; resourceType: string;
          resourceProviderNamespace: string; subscriptionId: string;
          parentResourcePath: string; resourceGroupName: string;
          resourceName: string; Filter: string = ""): Recallable =
  ## policyAssignmentsListForResource
  ## Gets policy assignments of the resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceType: string (required)
  ##               : The resource type.
  ##   resourceProviderNamespace: string (required)
  ##                            : The name of the resource provider.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource path.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   resourceName: string (required)
  ##               : The resource name.
  var path_564502 = newJObject()
  var query_564503 = newJObject()
  add(query_564503, "api-version", newJString(apiVersion))
  add(path_564502, "resourceType", newJString(resourceType))
  add(path_564502, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564502, "subscriptionId", newJString(subscriptionId))
  add(path_564502, "parentResourcePath", newJString(parentResourcePath))
  add(path_564502, "resourceGroupName", newJString(resourceGroupName))
  add(query_564503, "$filter", newJString(Filter))
  add(path_564502, "resourceName", newJString(resourceName))
  result = call_564501.call(path_564502, query_564503, nil, nil, nil)

var policyAssignmentsListForResource* = Call_PolicyAssignmentsListForResource_564489(
    name: "policyAssignmentsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForResource_564490, base: "",
    url: url_PolicyAssignmentsListForResource_564491, schemes: {Scheme.Https})
type
  Call_ResourcesList_564504 = ref object of OpenApiRestCall_563564
proc url_ResourcesList_564506(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesList_564505(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564507 = path.getOrDefault("subscriptionId")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "subscriptionId", valid_564507
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Query parameters. If null is passed returns all resource groups.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_564508 = query.getOrDefault("$top")
  valid_564508 = validateParameter(valid_564508, JInt, required = false, default = nil)
  if valid_564508 != nil:
    section.add "$top", valid_564508
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564509 = query.getOrDefault("api-version")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "api-version", valid_564509
  var valid_564510 = query.getOrDefault("$filter")
  valid_564510 = validateParameter(valid_564510, JString, required = false,
                                 default = nil)
  if valid_564510 != nil:
    section.add "$filter", valid_564510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564511: Call_ResourcesList_564504; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all of the resources under a subscription.
  ## 
  let valid = call_564511.validator(path, query, header, formData, body)
  let scheme = call_564511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564511.url(scheme.get, call_564511.host, call_564511.base,
                         call_564511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564511, url, valid)

proc call*(call_564512: Call_ResourcesList_564504; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## resourcesList
  ## Get all of the resources under a subscription.
  ##   Top: int
  ##      : Query parameters. If null is passed returns all resource groups.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_564513 = newJObject()
  var query_564514 = newJObject()
  add(query_564514, "$top", newJInt(Top))
  add(query_564514, "api-version", newJString(apiVersion))
  add(path_564513, "subscriptionId", newJString(subscriptionId))
  add(query_564514, "$filter", newJString(Filter))
  result = call_564512.call(path_564513, query_564514, nil, nil, nil)

var resourcesList* = Call_ResourcesList_564504(name: "resourcesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resources",
    validator: validate_ResourcesList_564505, base: "", url: url_ResourcesList_564506,
    schemes: {Scheme.Https})
type
  Call_TagsList_564515 = ref object of OpenApiRestCall_563564
proc url_TagsList_564517(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TagsList_564516(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564518 = path.getOrDefault("subscriptionId")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "subscriptionId", valid_564518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564519 = query.getOrDefault("api-version")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "api-version", valid_564519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564520: Call_TagsList_564515; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of subscription resource tags.
  ## 
  let valid = call_564520.validator(path, query, header, formData, body)
  let scheme = call_564520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564520.url(scheme.get, call_564520.host, call_564520.base,
                         call_564520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564520, url, valid)

proc call*(call_564521: Call_TagsList_564515; apiVersion: string;
          subscriptionId: string): Recallable =
  ## tagsList
  ## Get a list of subscription resource tags.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564522 = newJObject()
  var query_564523 = newJObject()
  add(query_564523, "api-version", newJString(apiVersion))
  add(path_564522, "subscriptionId", newJString(subscriptionId))
  result = call_564521.call(path_564522, query_564523, nil, nil, nil)

var tagsList* = Call_TagsList_564515(name: "tagsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames",
                                  validator: validate_TagsList_564516, base: "",
                                  url: url_TagsList_564517,
                                  schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdate_564524 = ref object of OpenApiRestCall_563564
proc url_TagsCreateOrUpdate_564526(protocol: Scheme; host: string; base: string;
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

proc validate_TagsCreateOrUpdate_564525(path: JsonNode; query: JsonNode;
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
  var valid_564527 = path.getOrDefault("tagName")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "tagName", valid_564527
  var valid_564528 = path.getOrDefault("subscriptionId")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "subscriptionId", valid_564528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564529 = query.getOrDefault("api-version")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "api-version", valid_564529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564530: Call_TagsCreateOrUpdate_564524; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a subscription resource tag.
  ## 
  let valid = call_564530.validator(path, query, header, formData, body)
  let scheme = call_564530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564530.url(scheme.get, call_564530.host, call_564530.base,
                         call_564530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564530, url, valid)

proc call*(call_564531: Call_TagsCreateOrUpdate_564524; apiVersion: string;
          tagName: string; subscriptionId: string): Recallable =
  ## tagsCreateOrUpdate
  ## Create a subscription resource tag.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564532 = newJObject()
  var query_564533 = newJObject()
  add(query_564533, "api-version", newJString(apiVersion))
  add(path_564532, "tagName", newJString(tagName))
  add(path_564532, "subscriptionId", newJString(subscriptionId))
  result = call_564531.call(path_564532, query_564533, nil, nil, nil)

var tagsCreateOrUpdate* = Call_TagsCreateOrUpdate_564524(
    name: "tagsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
    validator: validate_TagsCreateOrUpdate_564525, base: "",
    url: url_TagsCreateOrUpdate_564526, schemes: {Scheme.Https})
type
  Call_TagsDelete_564534 = ref object of OpenApiRestCall_563564
proc url_TagsDelete_564536(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TagsDelete_564535(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564537 = path.getOrDefault("tagName")
  valid_564537 = validateParameter(valid_564537, JString, required = true,
                                 default = nil)
  if valid_564537 != nil:
    section.add "tagName", valid_564537
  var valid_564538 = path.getOrDefault("subscriptionId")
  valid_564538 = validateParameter(valid_564538, JString, required = true,
                                 default = nil)
  if valid_564538 != nil:
    section.add "subscriptionId", valid_564538
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564539 = query.getOrDefault("api-version")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "api-version", valid_564539
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564540: Call_TagsDelete_564534; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a subscription resource tag.
  ## 
  let valid = call_564540.validator(path, query, header, formData, body)
  let scheme = call_564540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564540.url(scheme.get, call_564540.host, call_564540.base,
                         call_564540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564540, url, valid)

proc call*(call_564541: Call_TagsDelete_564534; apiVersion: string; tagName: string;
          subscriptionId: string): Recallable =
  ## tagsDelete
  ## Delete a subscription resource tag.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564542 = newJObject()
  var query_564543 = newJObject()
  add(query_564543, "api-version", newJString(apiVersion))
  add(path_564542, "tagName", newJString(tagName))
  add(path_564542, "subscriptionId", newJString(subscriptionId))
  result = call_564541.call(path_564542, query_564543, nil, nil, nil)

var tagsDelete* = Call_TagsDelete_564534(name: "tagsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
                                      validator: validate_TagsDelete_564535,
                                      base: "", url: url_TagsDelete_564536,
                                      schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdateValue_564544 = ref object of OpenApiRestCall_563564
proc url_TagsCreateOrUpdateValue_564546(protocol: Scheme; host: string; base: string;
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

proc validate_TagsCreateOrUpdateValue_564545(path: JsonNode; query: JsonNode;
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
  var valid_564547 = path.getOrDefault("tagName")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "tagName", valid_564547
  var valid_564548 = path.getOrDefault("subscriptionId")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "subscriptionId", valid_564548
  var valid_564549 = path.getOrDefault("tagValue")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = nil)
  if valid_564549 != nil:
    section.add "tagValue", valid_564549
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564550 = query.getOrDefault("api-version")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "api-version", valid_564550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564551: Call_TagsCreateOrUpdateValue_564544; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a subscription resource tag value.
  ## 
  let valid = call_564551.validator(path, query, header, formData, body)
  let scheme = call_564551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564551.url(scheme.get, call_564551.host, call_564551.base,
                         call_564551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564551, url, valid)

proc call*(call_564552: Call_TagsCreateOrUpdateValue_564544; apiVersion: string;
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
  var path_564553 = newJObject()
  var query_564554 = newJObject()
  add(query_564554, "api-version", newJString(apiVersion))
  add(path_564553, "tagName", newJString(tagName))
  add(path_564553, "subscriptionId", newJString(subscriptionId))
  add(path_564553, "tagValue", newJString(tagValue))
  result = call_564552.call(path_564553, query_564554, nil, nil, nil)

var tagsCreateOrUpdateValue* = Call_TagsCreateOrUpdateValue_564544(
    name: "tagsCreateOrUpdateValue", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsCreateOrUpdateValue_564545, base: "",
    url: url_TagsCreateOrUpdateValue_564546, schemes: {Scheme.Https})
type
  Call_TagsDeleteValue_564555 = ref object of OpenApiRestCall_563564
proc url_TagsDeleteValue_564557(protocol: Scheme; host: string; base: string;
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

proc validate_TagsDeleteValue_564556(path: JsonNode; query: JsonNode;
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
  var valid_564558 = path.getOrDefault("tagName")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "tagName", valid_564558
  var valid_564559 = path.getOrDefault("subscriptionId")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "subscriptionId", valid_564559
  var valid_564560 = path.getOrDefault("tagValue")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "tagValue", valid_564560
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564561 = query.getOrDefault("api-version")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "api-version", valid_564561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564562: Call_TagsDeleteValue_564555; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a subscription resource tag value.
  ## 
  let valid = call_564562.validator(path, query, header, formData, body)
  let scheme = call_564562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564562.url(scheme.get, call_564562.host, call_564562.base,
                         call_564562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564562, url, valid)

proc call*(call_564563: Call_TagsDeleteValue_564555; apiVersion: string;
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
  var path_564564 = newJObject()
  var query_564565 = newJObject()
  add(query_564565, "api-version", newJString(apiVersion))
  add(path_564564, "tagName", newJString(tagName))
  add(path_564564, "subscriptionId", newJString(subscriptionId))
  add(path_564564, "tagValue", newJString(tagValue))
  result = call_564563.call(path_564564, query_564565, nil, nil, nil)

var tagsDeleteValue* = Call_TagsDeleteValue_564555(name: "tagsDeleteValue",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsDeleteValue_564556, base: "", url: url_TagsDeleteValue_564557,
    schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsCreateById_564575 = ref object of OpenApiRestCall_563564
proc url_PolicyAssignmentsCreateById_564577(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsCreateById_564576(path: JsonNode; query: JsonNode;
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
  var valid_564578 = path.getOrDefault("policyAssignmentId")
  valid_564578 = validateParameter(valid_564578, JString, required = true,
                                 default = nil)
  if valid_564578 != nil:
    section.add "policyAssignmentId", valid_564578
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564579 = query.getOrDefault("api-version")
  valid_564579 = validateParameter(valid_564579, JString, required = true,
                                 default = nil)
  if valid_564579 != nil:
    section.add "api-version", valid_564579
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

proc call*(call_564581: Call_PolicyAssignmentsCreateById_564575; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create policy assignment by Id.
  ## 
  let valid = call_564581.validator(path, query, header, formData, body)
  let scheme = call_564581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564581.url(scheme.get, call_564581.host, call_564581.base,
                         call_564581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564581, url, valid)

proc call*(call_564582: Call_PolicyAssignmentsCreateById_564575;
          apiVersion: string; parameters: JsonNode; policyAssignmentId: string): Recallable =
  ## policyAssignmentsCreateById
  ## Create policy assignment by Id.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : Policy assignment.
  ##   policyAssignmentId: string (required)
  ##                     : Policy assignment Id
  var path_564583 = newJObject()
  var query_564584 = newJObject()
  var body_564585 = newJObject()
  add(query_564584, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564585 = parameters
  add(path_564583, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_564582.call(path_564583, query_564584, nil, nil, body_564585)

var policyAssignmentsCreateById* = Call_PolicyAssignmentsCreateById_564575(
    name: "policyAssignmentsCreateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsCreateById_564576, base: "",
    url: url_PolicyAssignmentsCreateById_564577, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsGetById_564566 = ref object of OpenApiRestCall_563564
proc url_PolicyAssignmentsGetById_564568(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsGetById_564567(path: JsonNode; query: JsonNode;
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
  var valid_564569 = path.getOrDefault("policyAssignmentId")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "policyAssignmentId", valid_564569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564570 = query.getOrDefault("api-version")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "api-version", valid_564570
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564571: Call_PolicyAssignmentsGetById_564566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get single policy assignment.
  ## 
  let valid = call_564571.validator(path, query, header, formData, body)
  let scheme = call_564571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564571.url(scheme.get, call_564571.host, call_564571.base,
                         call_564571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564571, url, valid)

proc call*(call_564572: Call_PolicyAssignmentsGetById_564566; apiVersion: string;
          policyAssignmentId: string): Recallable =
  ## policyAssignmentsGetById
  ## Get single policy assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   policyAssignmentId: string (required)
  ##                     : Policy assignment Id
  var path_564573 = newJObject()
  var query_564574 = newJObject()
  add(query_564574, "api-version", newJString(apiVersion))
  add(path_564573, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_564572.call(path_564573, query_564574, nil, nil, nil)

var policyAssignmentsGetById* = Call_PolicyAssignmentsGetById_564566(
    name: "policyAssignmentsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsGetById_564567, base: "",
    url: url_PolicyAssignmentsGetById_564568, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsDeleteById_564586 = ref object of OpenApiRestCall_563564
proc url_PolicyAssignmentsDeleteById_564588(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsDeleteById_564587(path: JsonNode; query: JsonNode;
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
  var valid_564589 = path.getOrDefault("policyAssignmentId")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "policyAssignmentId", valid_564589
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564590 = query.getOrDefault("api-version")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "api-version", valid_564590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564591: Call_PolicyAssignmentsDeleteById_564586; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy assignment.
  ## 
  let valid = call_564591.validator(path, query, header, formData, body)
  let scheme = call_564591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564591.url(scheme.get, call_564591.host, call_564591.base,
                         call_564591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564591, url, valid)

proc call*(call_564592: Call_PolicyAssignmentsDeleteById_564586;
          apiVersion: string; policyAssignmentId: string): Recallable =
  ## policyAssignmentsDeleteById
  ## Delete policy assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   policyAssignmentId: string (required)
  ##                     : Policy assignment Id
  var path_564593 = newJObject()
  var query_564594 = newJObject()
  add(query_564594, "api-version", newJString(apiVersion))
  add(path_564593, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_564592.call(path_564593, query_564594, nil, nil, nil)

var policyAssignmentsDeleteById* = Call_PolicyAssignmentsDeleteById_564586(
    name: "policyAssignmentsDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsDeleteById_564587, base: "",
    url: url_PolicyAssignmentsDeleteById_564588, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForScope_564595 = ref object of OpenApiRestCall_563564
proc url_PolicyAssignmentsListForScope_564597(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsListForScope_564596(path: JsonNode; query: JsonNode;
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
  var valid_564598 = path.getOrDefault("scope")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "scope", valid_564598
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564599 = query.getOrDefault("api-version")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "api-version", valid_564599
  var valid_564600 = query.getOrDefault("$filter")
  valid_564600 = validateParameter(valid_564600, JString, required = false,
                                 default = nil)
  if valid_564600 != nil:
    section.add "$filter", valid_564600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564601: Call_PolicyAssignmentsListForScope_564595; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets policy assignments of the scope.
  ## 
  let valid = call_564601.validator(path, query, header, formData, body)
  let scheme = call_564601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564601.url(scheme.get, call_564601.host, call_564601.base,
                         call_564601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564601, url, valid)

proc call*(call_564602: Call_PolicyAssignmentsListForScope_564595;
          apiVersion: string; scope: string; Filter: string = ""): Recallable =
  ## policyAssignmentsListForScope
  ## Gets policy assignments of the scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   scope: string (required)
  ##        : Scope.
  var path_564603 = newJObject()
  var query_564604 = newJObject()
  add(query_564604, "api-version", newJString(apiVersion))
  add(query_564604, "$filter", newJString(Filter))
  add(path_564603, "scope", newJString(scope))
  result = call_564602.call(path_564603, query_564604, nil, nil, nil)

var policyAssignmentsListForScope* = Call_PolicyAssignmentsListForScope_564595(
    name: "policyAssignmentsListForScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForScope_564596, base: "",
    url: url_PolicyAssignmentsListForScope_564597, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsCreate_564615 = ref object of OpenApiRestCall_563564
proc url_PolicyAssignmentsCreate_564617(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyAssignmentsCreate_564616(path: JsonNode; query: JsonNode;
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
  var valid_564618 = path.getOrDefault("policyAssignmentName")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = nil)
  if valid_564618 != nil:
    section.add "policyAssignmentName", valid_564618
  var valid_564619 = path.getOrDefault("scope")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "scope", valid_564619
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564620 = query.getOrDefault("api-version")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "api-version", valid_564620
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

proc call*(call_564622: Call_PolicyAssignmentsCreate_564615; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create policy assignment.
  ## 
  let valid = call_564622.validator(path, query, header, formData, body)
  let scheme = call_564622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564622.url(scheme.get, call_564622.host, call_564622.base,
                         call_564622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564622, url, valid)

proc call*(call_564623: Call_PolicyAssignmentsCreate_564615; apiVersion: string;
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
  var path_564624 = newJObject()
  var query_564625 = newJObject()
  var body_564626 = newJObject()
  add(query_564625, "api-version", newJString(apiVersion))
  add(path_564624, "policyAssignmentName", newJString(policyAssignmentName))
  if parameters != nil:
    body_564626 = parameters
  add(path_564624, "scope", newJString(scope))
  result = call_564623.call(path_564624, query_564625, nil, nil, body_564626)

var policyAssignmentsCreate* = Call_PolicyAssignmentsCreate_564615(
    name: "policyAssignmentsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsCreate_564616, base: "",
    url: url_PolicyAssignmentsCreate_564617, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsGet_564605 = ref object of OpenApiRestCall_563564
proc url_PolicyAssignmentsGet_564607(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyAssignmentsGet_564606(path: JsonNode; query: JsonNode;
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
  var valid_564608 = path.getOrDefault("policyAssignmentName")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "policyAssignmentName", valid_564608
  var valid_564609 = path.getOrDefault("scope")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "scope", valid_564609
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564610 = query.getOrDefault("api-version")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "api-version", valid_564610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564611: Call_PolicyAssignmentsGet_564605; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get single policy assignment.
  ## 
  let valid = call_564611.validator(path, query, header, formData, body)
  let scheme = call_564611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564611.url(scheme.get, call_564611.host, call_564611.base,
                         call_564611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564611, url, valid)

proc call*(call_564612: Call_PolicyAssignmentsGet_564605; apiVersion: string;
          policyAssignmentName: string; scope: string): Recallable =
  ## policyAssignmentsGet
  ## Get single policy assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   scope: string (required)
  ##        : Scope.
  var path_564613 = newJObject()
  var query_564614 = newJObject()
  add(query_564614, "api-version", newJString(apiVersion))
  add(path_564613, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_564613, "scope", newJString(scope))
  result = call_564612.call(path_564613, query_564614, nil, nil, nil)

var policyAssignmentsGet* = Call_PolicyAssignmentsGet_564605(
    name: "policyAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsGet_564606, base: "",
    url: url_PolicyAssignmentsGet_564607, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsDelete_564627 = ref object of OpenApiRestCall_563564
proc url_PolicyAssignmentsDelete_564629(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyAssignmentsDelete_564628(path: JsonNode; query: JsonNode;
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
  var valid_564630 = path.getOrDefault("policyAssignmentName")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "policyAssignmentName", valid_564630
  var valid_564631 = path.getOrDefault("scope")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "scope", valid_564631
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564632: Call_PolicyAssignmentsDelete_564627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy assignment.
  ## 
  let valid = call_564632.validator(path, query, header, formData, body)
  let scheme = call_564632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564632.url(scheme.get, call_564632.host, call_564632.base,
                         call_564632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564632, url, valid)

proc call*(call_564633: Call_PolicyAssignmentsDelete_564627;
          policyAssignmentName: string; scope: string): Recallable =
  ## policyAssignmentsDelete
  ## Delete policy assignment.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   scope: string (required)
  ##        : Scope.
  var path_564634 = newJObject()
  add(path_564634, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_564634, "scope", newJString(scope))
  result = call_564633.call(path_564634, nil, nil, nil, nil)

var policyAssignmentsDelete* = Call_PolicyAssignmentsDelete_564627(
    name: "policyAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsDelete_564628, base: "",
    url: url_PolicyAssignmentsDelete_564629, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
