
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
  macServiceName = "resources"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeploymentsCalculateTemplateHash_593659 = ref object of OpenApiRestCall_593437
proc url_DeploymentsCalculateTemplateHash_593661(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeploymentsCalculateTemplateHash_593660(path: JsonNode;
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
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "api-version", valid_593820
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

proc call*(call_593844: Call_DeploymentsCalculateTemplateHash_593659;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Calculate the hash of the given template.
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_DeploymentsCalculateTemplateHash_593659;
          apiVersion: string; `template`: JsonNode): Recallable =
  ## deploymentsCalculateTemplateHash
  ## Calculate the hash of the given template.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  var query_593916 = newJObject()
  var body_593918 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  if `template` != nil:
    body_593918 = `template`
  result = call_593915.call(nil, query_593916, nil, nil, body_593918)

var deploymentsCalculateTemplateHash* = Call_DeploymentsCalculateTemplateHash_593659(
    name: "deploymentsCalculateTemplateHash", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/calculateTemplateHash",
    validator: validate_DeploymentsCalculateTemplateHash_593660, base: "",
    url: url_DeploymentsCalculateTemplateHash_593661, schemes: {Scheme.Https})
type
  Call_ResourceProviderOperationDetailsList_593957 = ref object of OpenApiRestCall_593437
proc url_ResourceProviderOperationDetailsList_593959(protocol: Scheme;
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

proc validate_ResourceProviderOperationDetailsList_593958(path: JsonNode;
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
  var valid_593974 = path.getOrDefault("resourceProviderNamespace")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "resourceProviderNamespace", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_ResourceProviderOperationDetailsList_593957;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of resource providers.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_ResourceProviderOperationDetailsList_593957;
          apiVersion: string; resourceProviderNamespace: string): Recallable =
  ## resourceProviderOperationDetailsList
  ## Gets a list of resource providers.
  ##   apiVersion: string (required)
  ##   resourceProviderNamespace: string (required)
  ##                            : Resource identity.
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  add(query_593979, "api-version", newJString(apiVersion))
  add(path_593978, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_593977.call(path_593978, query_593979, nil, nil, nil)

var resourceProviderOperationDetailsList* = Call_ResourceProviderOperationDetailsList_593957(
    name: "resourceProviderOperationDetailsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/{resourceProviderNamespace}/operations",
    validator: validate_ResourceProviderOperationDetailsList_593958, base: "",
    url: url_ResourceProviderOperationDetailsList_593959, schemes: {Scheme.Https})
type
  Call_ProvidersList_593980 = ref object of OpenApiRestCall_593437
proc url_ProvidersList_593982(protocol: Scheme; host: string; base: string;
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

proc validate_ProvidersList_593981(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593984 = path.getOrDefault("subscriptionId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "subscriptionId", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Query parameters. If null is passed returns all deployments.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  var valid_593986 = query.getOrDefault("$top")
  valid_593986 = validateParameter(valid_593986, JInt, required = false, default = nil)
  if valid_593986 != nil:
    section.add "$top", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_ProvidersList_593980; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of resource providers.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_ProvidersList_593980; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## providersList
  ## Gets a list of resource providers.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Query parameters. If null is passed returns all deployments.
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  add(query_593990, "$top", newJInt(Top))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var providersList* = Call_ProvidersList_593980(name: "providersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers",
    validator: validate_ProvidersList_593981, base: "", url: url_ProvidersList_593982,
    schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsList_593991 = ref object of OpenApiRestCall_593437
proc url_PolicyAssignmentsList_593993(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyAssignmentsList_593992(path: JsonNode; query: JsonNode;
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
  var valid_593994 = path.getOrDefault("subscriptionId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "subscriptionId", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "api-version", valid_593995
  var valid_593996 = query.getOrDefault("$filter")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "$filter", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_PolicyAssignmentsList_593991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets policy assignments of the subscription.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_PolicyAssignmentsList_593991; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## policyAssignmentsList
  ## Gets policy assignments of the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "subscriptionId", newJString(subscriptionId))
  add(query_594000, "$filter", newJString(Filter))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var policyAssignmentsList* = Call_PolicyAssignmentsList_593991(
    name: "policyAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsList_593992, base: "",
    url: url_PolicyAssignmentsList_593993, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsCreateOrUpdate_594011 = ref object of OpenApiRestCall_593437
proc url_PolicyDefinitionsCreateOrUpdate_594013(protocol: Scheme; host: string;
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

proc validate_PolicyDefinitionsCreateOrUpdate_594012(path: JsonNode;
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
  var valid_594031 = path.getOrDefault("subscriptionId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "subscriptionId", valid_594031
  var valid_594032 = path.getOrDefault("policyDefinitionName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "policyDefinitionName", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
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

proc call*(call_594035: Call_PolicyDefinitionsCreateOrUpdate_594011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update policy definition.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_PolicyDefinitionsCreateOrUpdate_594011;
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
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  var body_594039 = newJObject()
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594039 = parameters
  add(path_594037, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_594036.call(path_594037, query_594038, nil, nil, body_594039)

var policyDefinitionsCreateOrUpdate* = Call_PolicyDefinitionsCreateOrUpdate_594011(
    name: "policyDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsCreateOrUpdate_594012, base: "",
    url: url_PolicyDefinitionsCreateOrUpdate_594013, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsGet_594001 = ref object of OpenApiRestCall_593437
proc url_PolicyDefinitionsGet_594003(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyDefinitionsGet_594002(path: JsonNode; query: JsonNode;
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
  var valid_594004 = path.getOrDefault("subscriptionId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "subscriptionId", valid_594004
  var valid_594005 = path.getOrDefault("policyDefinitionName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "policyDefinitionName", valid_594005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_PolicyDefinitionsGet_594001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets policy definition.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_PolicyDefinitionsGet_594001; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsGet
  ## Gets policy definition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyDefinitionName: string (required)
  ##                       : The policy definition name.
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  add(path_594009, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var policyDefinitionsGet* = Call_PolicyDefinitionsGet_594001(
    name: "policyDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsGet_594002, base: "",
    url: url_PolicyDefinitionsGet_594003, schemes: {Scheme.Https})
type
  Call_PolicyDefinitionsDelete_594040 = ref object of OpenApiRestCall_593437
proc url_PolicyDefinitionsDelete_594042(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyDefinitionsDelete_594041(path: JsonNode; query: JsonNode;
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
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  var valid_594044 = path.getOrDefault("policyDefinitionName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "policyDefinitionName", valid_594044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594045 = query.getOrDefault("api-version")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "api-version", valid_594045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_PolicyDefinitionsDelete_594040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes policy definition.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_PolicyDefinitionsDelete_594040; apiVersion: string;
          subscriptionId: string; policyDefinitionName: string): Recallable =
  ## policyDefinitionsDelete
  ## Deletes policy definition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyDefinitionName: string (required)
  ##                       : The policy definition name.
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  add(query_594049, "api-version", newJString(apiVersion))
  add(path_594048, "subscriptionId", newJString(subscriptionId))
  add(path_594048, "policyDefinitionName", newJString(policyDefinitionName))
  result = call_594047.call(path_594048, query_594049, nil, nil, nil)

var policyDefinitionsDelete* = Call_PolicyDefinitionsDelete_594040(
    name: "policyDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policydefinitions/{policyDefinitionName}",
    validator: validate_PolicyDefinitionsDelete_594041, base: "",
    url: url_PolicyDefinitionsDelete_594042, schemes: {Scheme.Https})
type
  Call_ProvidersGet_594050 = ref object of OpenApiRestCall_593437
proc url_ProvidersGet_594052(protocol: Scheme; host: string; base: string;
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

proc validate_ProvidersGet_594051(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594053 = path.getOrDefault("subscriptionId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "subscriptionId", valid_594053
  var valid_594054 = path.getOrDefault("resourceProviderNamespace")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "resourceProviderNamespace", valid_594054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_594056: Call_ProvidersGet_594050; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource provider.
  ## 
  let valid = call_594056.validator(path, query, header, formData, body)
  let scheme = call_594056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594056.url(scheme.get, call_594056.host, call_594056.base,
                         call_594056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594056, url, valid)

proc call*(call_594057: Call_ProvidersGet_594050; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersGet
  ## Gets a resource provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceProviderNamespace: string (required)
  ##                            : Namespace of the resource provider.
  var path_594058 = newJObject()
  var query_594059 = newJObject()
  add(query_594059, "api-version", newJString(apiVersion))
  add(path_594058, "subscriptionId", newJString(subscriptionId))
  add(path_594058, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_594057.call(path_594058, query_594059, nil, nil, nil)

var providersGet* = Call_ProvidersGet_594050(name: "providersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}",
    validator: validate_ProvidersGet_594051, base: "", url: url_ProvidersGet_594052,
    schemes: {Scheme.Https})
type
  Call_ProvidersRegister_594060 = ref object of OpenApiRestCall_593437
proc url_ProvidersRegister_594062(protocol: Scheme; host: string; base: string;
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

proc validate_ProvidersRegister_594061(path: JsonNode; query: JsonNode;
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
  var valid_594063 = path.getOrDefault("subscriptionId")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "subscriptionId", valid_594063
  var valid_594064 = path.getOrDefault("resourceProviderNamespace")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "resourceProviderNamespace", valid_594064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594065 = query.getOrDefault("api-version")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "api-version", valid_594065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_ProvidersRegister_594060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers provider to be used with a subscription.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_ProvidersRegister_594060; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersRegister
  ## Registers provider to be used with a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceProviderNamespace: string (required)
  ##                            : Namespace of the resource provider.
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(query_594069, "api-version", newJString(apiVersion))
  add(path_594068, "subscriptionId", newJString(subscriptionId))
  add(path_594068, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var providersRegister* = Call_ProvidersRegister_594060(name: "providersRegister",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/register",
    validator: validate_ProvidersRegister_594061, base: "",
    url: url_ProvidersRegister_594062, schemes: {Scheme.Https})
type
  Call_ProvidersUnregister_594070 = ref object of OpenApiRestCall_593437
proc url_ProvidersUnregister_594072(protocol: Scheme; host: string; base: string;
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

proc validate_ProvidersUnregister_594071(path: JsonNode; query: JsonNode;
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
  var valid_594073 = path.getOrDefault("subscriptionId")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "subscriptionId", valid_594073
  var valid_594074 = path.getOrDefault("resourceProviderNamespace")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "resourceProviderNamespace", valid_594074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594075 = query.getOrDefault("api-version")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "api-version", valid_594075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594076: Call_ProvidersUnregister_594070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregisters provider from a subscription.
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_ProvidersUnregister_594070; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersUnregister
  ## Unregisters provider from a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceProviderNamespace: string (required)
  ##                            : Namespace of the resource provider.
  var path_594078 = newJObject()
  var query_594079 = newJObject()
  add(query_594079, "api-version", newJString(apiVersion))
  add(path_594078, "subscriptionId", newJString(subscriptionId))
  add(path_594078, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_594077.call(path_594078, query_594079, nil, nil, nil)

var providersUnregister* = Call_ProvidersUnregister_594070(
    name: "providersUnregister", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/unregister",
    validator: validate_ProvidersUnregister_594071, base: "",
    url: url_ProvidersUnregister_594072, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForResourceGroup_594080 = ref object of OpenApiRestCall_593437
proc url_PolicyAssignmentsListForResourceGroup_594082(protocol: Scheme;
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

proc validate_PolicyAssignmentsListForResourceGroup_594081(path: JsonNode;
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
  var valid_594083 = path.getOrDefault("resourceGroupName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "resourceGroupName", valid_594083
  var valid_594084 = path.getOrDefault("subscriptionId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "subscriptionId", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "api-version", valid_594085
  var valid_594086 = query.getOrDefault("$filter")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "$filter", valid_594086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_PolicyAssignmentsListForResourceGroup_594080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets policy assignments of the resource group.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_PolicyAssignmentsListForResourceGroup_594080;
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
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  add(path_594089, "resourceGroupName", newJString(resourceGroupName))
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "subscriptionId", newJString(subscriptionId))
  add(query_594090, "$filter", newJString(Filter))
  result = call_594088.call(path_594089, query_594090, nil, nil, nil)

var policyAssignmentsListForResourceGroup* = Call_PolicyAssignmentsListForResourceGroup_594080(
    name: "policyAssignmentsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForResourceGroup_594081, base: "",
    url: url_PolicyAssignmentsListForResourceGroup_594082, schemes: {Scheme.Https})
type
  Call_ResourceGroupsListResources_594091 = ref object of OpenApiRestCall_593437
proc url_ResourceGroupsListResources_594093(protocol: Scheme; host: string;
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

proc validate_ResourceGroupsListResources_594092(path: JsonNode; query: JsonNode;
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
  var valid_594094 = path.getOrDefault("resourceGroupName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "resourceGroupName", valid_594094
  var valid_594095 = path.getOrDefault("subscriptionId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "subscriptionId", valid_594095
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
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  var valid_594097 = query.getOrDefault("$top")
  valid_594097 = validateParameter(valid_594097, JInt, required = false, default = nil)
  if valid_594097 != nil:
    section.add "$top", valid_594097
  var valid_594098 = query.getOrDefault("$filter")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "$filter", valid_594098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594099: Call_ResourceGroupsListResources_594091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all of the resources under a subscription.
  ## 
  let valid = call_594099.validator(path, query, header, formData, body)
  let scheme = call_594099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594099.url(scheme.get, call_594099.host, call_594099.base,
                         call_594099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594099, url, valid)

proc call*(call_594100: Call_ResourceGroupsListResources_594091;
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
  var path_594101 = newJObject()
  var query_594102 = newJObject()
  add(path_594101, "resourceGroupName", newJString(resourceGroupName))
  add(query_594102, "api-version", newJString(apiVersion))
  add(path_594101, "subscriptionId", newJString(subscriptionId))
  add(query_594102, "$top", newJInt(Top))
  add(query_594102, "$filter", newJString(Filter))
  result = call_594100.call(path_594101, query_594102, nil, nil, nil)

var resourceGroupsListResources* = Call_ResourceGroupsListResources_594091(
    name: "resourceGroupsListResources", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/resources",
    validator: validate_ResourceGroupsListResources_594092, base: "",
    url: url_ResourceGroupsListResources_594093, schemes: {Scheme.Https})
type
  Call_ResourcesMoveResources_594103 = ref object of OpenApiRestCall_593437
proc url_ResourcesMoveResources_594105(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesMoveResources_594104(path: JsonNode; query: JsonNode;
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
  var valid_594106 = path.getOrDefault("sourceResourceGroupName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "sourceResourceGroupName", valid_594106
  var valid_594107 = path.getOrDefault("subscriptionId")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "subscriptionId", valid_594107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594108 = query.getOrDefault("api-version")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "api-version", valid_594108
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

proc call*(call_594110: Call_ResourcesMoveResources_594103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begin moving resources.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  let valid = call_594110.validator(path, query, header, formData, body)
  let scheme = call_594110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594110.url(scheme.get, call_594110.host, call_594110.base,
                         call_594110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594110, url, valid)

proc call*(call_594111: Call_ResourcesMoveResources_594103; apiVersion: string;
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
  var path_594112 = newJObject()
  var query_594113 = newJObject()
  var body_594114 = newJObject()
  add(query_594113, "api-version", newJString(apiVersion))
  add(path_594112, "sourceResourceGroupName", newJString(sourceResourceGroupName))
  add(path_594112, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594114 = parameters
  result = call_594111.call(path_594112, query_594113, nil, nil, body_594114)

var resourcesMoveResources* = Call_ResourcesMoveResources_594103(
    name: "resourcesMoveResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{sourceResourceGroupName}/moveResources",
    validator: validate_ResourcesMoveResources_594104, base: "",
    url: url_ResourcesMoveResources_594105, schemes: {Scheme.Https})
type
  Call_ResourceGroupsList_594115 = ref object of OpenApiRestCall_593437
proc url_ResourceGroupsList_594117(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceGroupsList_594116(path: JsonNode; query: JsonNode;
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
  var valid_594118 = path.getOrDefault("subscriptionId")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "subscriptionId", valid_594118
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
  var valid_594119 = query.getOrDefault("api-version")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "api-version", valid_594119
  var valid_594120 = query.getOrDefault("$top")
  valid_594120 = validateParameter(valid_594120, JInt, required = false, default = nil)
  if valid_594120 != nil:
    section.add "$top", valid_594120
  var valid_594121 = query.getOrDefault("$filter")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "$filter", valid_594121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594122: Call_ResourceGroupsList_594115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a collection of resource groups.
  ## 
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_ResourceGroupsList_594115; apiVersion: string;
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
  var path_594124 = newJObject()
  var query_594125 = newJObject()
  add(query_594125, "api-version", newJString(apiVersion))
  add(path_594124, "subscriptionId", newJString(subscriptionId))
  add(query_594125, "$top", newJInt(Top))
  add(query_594125, "$filter", newJString(Filter))
  result = call_594123.call(path_594124, query_594125, nil, nil, nil)

var resourceGroupsList* = Call_ResourceGroupsList_594115(
    name: "resourceGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resourcegroups",
    validator: validate_ResourceGroupsList_594116, base: "",
    url: url_ResourceGroupsList_594117, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCreateOrUpdate_594136 = ref object of OpenApiRestCall_593437
proc url_ResourceGroupsCreateOrUpdate_594138(protocol: Scheme; host: string;
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

proc validate_ResourceGroupsCreateOrUpdate_594137(path: JsonNode; query: JsonNode;
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
  var valid_594139 = path.getOrDefault("resourceGroupName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "resourceGroupName", valid_594139
  var valid_594140 = path.getOrDefault("subscriptionId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "subscriptionId", valid_594140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594141 = query.getOrDefault("api-version")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "api-version", valid_594141
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

proc call*(call_594143: Call_ResourceGroupsCreateOrUpdate_594136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource group.
  ## 
  let valid = call_594143.validator(path, query, header, formData, body)
  let scheme = call_594143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594143.url(scheme.get, call_594143.host, call_594143.base,
                         call_594143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594143, url, valid)

proc call*(call_594144: Call_ResourceGroupsCreateOrUpdate_594136;
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
  var path_594145 = newJObject()
  var query_594146 = newJObject()
  var body_594147 = newJObject()
  add(path_594145, "resourceGroupName", newJString(resourceGroupName))
  add(query_594146, "api-version", newJString(apiVersion))
  add(path_594145, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594147 = parameters
  result = call_594144.call(path_594145, query_594146, nil, nil, body_594147)

var resourceGroupsCreateOrUpdate* = Call_ResourceGroupsCreateOrUpdate_594136(
    name: "resourceGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCreateOrUpdate_594137, base: "",
    url: url_ResourceGroupsCreateOrUpdate_594138, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCheckExistence_594158 = ref object of OpenApiRestCall_593437
proc url_ResourceGroupsCheckExistence_594160(protocol: Scheme; host: string;
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

proc validate_ResourceGroupsCheckExistence_594159(path: JsonNode; query: JsonNode;
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
  var valid_594161 = path.getOrDefault("resourceGroupName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "resourceGroupName", valid_594161
  var valid_594162 = path.getOrDefault("subscriptionId")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "subscriptionId", valid_594162
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594163 = query.getOrDefault("api-version")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "api-version", valid_594163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594164: Call_ResourceGroupsCheckExistence_594158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether resource group exists.
  ## 
  let valid = call_594164.validator(path, query, header, formData, body)
  let scheme = call_594164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594164.url(scheme.get, call_594164.host, call_594164.base,
                         call_594164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594164, url, valid)

proc call*(call_594165: Call_ResourceGroupsCheckExistence_594158;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsCheckExistence
  ## Checks whether resource group exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594166 = newJObject()
  var query_594167 = newJObject()
  add(path_594166, "resourceGroupName", newJString(resourceGroupName))
  add(query_594167, "api-version", newJString(apiVersion))
  add(path_594166, "subscriptionId", newJString(subscriptionId))
  result = call_594165.call(path_594166, query_594167, nil, nil, nil)

var resourceGroupsCheckExistence* = Call_ResourceGroupsCheckExistence_594158(
    name: "resourceGroupsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCheckExistence_594159, base: "",
    url: url_ResourceGroupsCheckExistence_594160, schemes: {Scheme.Https})
type
  Call_ResourceGroupsGet_594126 = ref object of OpenApiRestCall_593437
proc url_ResourceGroupsGet_594128(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceGroupsGet_594127(path: JsonNode; query: JsonNode;
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
  var valid_594129 = path.getOrDefault("resourceGroupName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "resourceGroupName", valid_594129
  var valid_594130 = path.getOrDefault("subscriptionId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "subscriptionId", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_594132: Call_ResourceGroupsGet_594126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a resource group.
  ## 
  let valid = call_594132.validator(path, query, header, formData, body)
  let scheme = call_594132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594132.url(scheme.get, call_594132.host, call_594132.base,
                         call_594132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594132, url, valid)

proc call*(call_594133: Call_ResourceGroupsGet_594126; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsGet
  ## Get a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594134 = newJObject()
  var query_594135 = newJObject()
  add(path_594134, "resourceGroupName", newJString(resourceGroupName))
  add(query_594135, "api-version", newJString(apiVersion))
  add(path_594134, "subscriptionId", newJString(subscriptionId))
  result = call_594133.call(path_594134, query_594135, nil, nil, nil)

var resourceGroupsGet* = Call_ResourceGroupsGet_594126(name: "resourceGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsGet_594127, base: "",
    url: url_ResourceGroupsGet_594128, schemes: {Scheme.Https})
type
  Call_ResourceGroupsPatch_594168 = ref object of OpenApiRestCall_593437
proc url_ResourceGroupsPatch_594170(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceGroupsPatch_594169(path: JsonNode; query: JsonNode;
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
  var valid_594171 = path.getOrDefault("resourceGroupName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "resourceGroupName", valid_594171
  var valid_594172 = path.getOrDefault("subscriptionId")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "subscriptionId", valid_594172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594173 = query.getOrDefault("api-version")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "api-version", valid_594173
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

proc call*(call_594175: Call_ResourceGroupsPatch_594168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource groups, though if a field is unspecified current value will be carried over. 
  ## 
  let valid = call_594175.validator(path, query, header, formData, body)
  let scheme = call_594175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594175.url(scheme.get, call_594175.host, call_594175.base,
                         call_594175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594175, url, valid)

proc call*(call_594176: Call_ResourceGroupsPatch_594168; resourceGroupName: string;
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
  var path_594177 = newJObject()
  var query_594178 = newJObject()
  var body_594179 = newJObject()
  add(path_594177, "resourceGroupName", newJString(resourceGroupName))
  add(query_594178, "api-version", newJString(apiVersion))
  add(path_594177, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594179 = parameters
  result = call_594176.call(path_594177, query_594178, nil, nil, body_594179)

var resourceGroupsPatch* = Call_ResourceGroupsPatch_594168(
    name: "resourceGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsPatch_594169, base: "",
    url: url_ResourceGroupsPatch_594170, schemes: {Scheme.Https})
type
  Call_ResourceGroupsDelete_594148 = ref object of OpenApiRestCall_593437
proc url_ResourceGroupsDelete_594150(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceGroupsDelete_594149(path: JsonNode; query: JsonNode;
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
  var valid_594151 = path.getOrDefault("resourceGroupName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "resourceGroupName", valid_594151
  var valid_594152 = path.getOrDefault("subscriptionId")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "subscriptionId", valid_594152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594153 = query.getOrDefault("api-version")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "api-version", valid_594153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594154: Call_ResourceGroupsDelete_594148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begin deleting resource group.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  let valid = call_594154.validator(path, query, header, formData, body)
  let scheme = call_594154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594154.url(scheme.get, call_594154.host, call_594154.base,
                         call_594154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594154, url, valid)

proc call*(call_594155: Call_ResourceGroupsDelete_594148;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsDelete
  ## Begin deleting resource group.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to be deleted. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594156 = newJObject()
  var query_594157 = newJObject()
  add(path_594156, "resourceGroupName", newJString(resourceGroupName))
  add(query_594157, "api-version", newJString(apiVersion))
  add(path_594156, "subscriptionId", newJString(subscriptionId))
  result = call_594155.call(path_594156, query_594157, nil, nil, nil)

var resourceGroupsDelete* = Call_ResourceGroupsDelete_594148(
    name: "resourceGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsDelete_594149, base: "",
    url: url_ResourceGroupsDelete_594150, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsList_594180 = ref object of OpenApiRestCall_593437
proc url_DeploymentOperationsList_594182(protocol: Scheme; host: string;
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

proc validate_DeploymentOperationsList_594181(path: JsonNode; query: JsonNode;
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
  var valid_594183 = path.getOrDefault("resourceGroupName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "resourceGroupName", valid_594183
  var valid_594184 = path.getOrDefault("deploymentName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "deploymentName", valid_594184
  var valid_594185 = path.getOrDefault("subscriptionId")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "subscriptionId", valid_594185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Query parameters.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594186 = query.getOrDefault("api-version")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "api-version", valid_594186
  var valid_594187 = query.getOrDefault("$top")
  valid_594187 = validateParameter(valid_594187, JInt, required = false, default = nil)
  if valid_594187 != nil:
    section.add "$top", valid_594187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594188: Call_DeploymentOperationsList_594180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of deployments operations.
  ## 
  let valid = call_594188.validator(path, query, header, formData, body)
  let scheme = call_594188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594188.url(scheme.get, call_594188.host, call_594188.base,
                         call_594188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594188, url, valid)

proc call*(call_594189: Call_DeploymentOperationsList_594180;
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
  var path_594190 = newJObject()
  var query_594191 = newJObject()
  add(path_594190, "resourceGroupName", newJString(resourceGroupName))
  add(query_594191, "api-version", newJString(apiVersion))
  add(path_594190, "deploymentName", newJString(deploymentName))
  add(path_594190, "subscriptionId", newJString(subscriptionId))
  add(query_594191, "$top", newJInt(Top))
  result = call_594189.call(path_594190, query_594191, nil, nil, nil)

var deploymentOperationsList* = Call_DeploymentOperationsList_594180(
    name: "deploymentOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsList_594181, base: "",
    url: url_DeploymentOperationsList_594182, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGet_594192 = ref object of OpenApiRestCall_593437
proc url_DeploymentOperationsGet_594194(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentOperationsGet_594193(path: JsonNode; query: JsonNode;
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
  var valid_594195 = path.getOrDefault("resourceGroupName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "resourceGroupName", valid_594195
  var valid_594196 = path.getOrDefault("deploymentName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "deploymentName", valid_594196
  var valid_594197 = path.getOrDefault("subscriptionId")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "subscriptionId", valid_594197
  var valid_594198 = path.getOrDefault("operationId")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "operationId", valid_594198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594199 = query.getOrDefault("api-version")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "api-version", valid_594199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594200: Call_DeploymentOperationsGet_594192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of deployments operations.
  ## 
  let valid = call_594200.validator(path, query, header, formData, body)
  let scheme = call_594200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594200.url(scheme.get, call_594200.host, call_594200.base,
                         call_594200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594200, url, valid)

proc call*(call_594201: Call_DeploymentOperationsGet_594192;
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
  var path_594202 = newJObject()
  var query_594203 = newJObject()
  add(path_594202, "resourceGroupName", newJString(resourceGroupName))
  add(query_594203, "api-version", newJString(apiVersion))
  add(path_594202, "deploymentName", newJString(deploymentName))
  add(path_594202, "subscriptionId", newJString(subscriptionId))
  add(path_594202, "operationId", newJString(operationId))
  result = call_594201.call(path_594202, query_594203, nil, nil, nil)

var deploymentOperationsGet* = Call_DeploymentOperationsGet_594192(
    name: "deploymentOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGet_594193, base: "",
    url: url_DeploymentOperationsGet_594194, schemes: {Scheme.Https})
type
  Call_DeploymentsList_594204 = ref object of OpenApiRestCall_593437
proc url_DeploymentsList_594206(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsList_594205(path: JsonNode; query: JsonNode;
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
  var valid_594207 = path.getOrDefault("resourceGroupName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "resourceGroupName", valid_594207
  var valid_594208 = path.getOrDefault("subscriptionId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "subscriptionId", valid_594208
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
  var valid_594209 = query.getOrDefault("api-version")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "api-version", valid_594209
  var valid_594210 = query.getOrDefault("$top")
  valid_594210 = validateParameter(valid_594210, JInt, required = false, default = nil)
  if valid_594210 != nil:
    section.add "$top", valid_594210
  var valid_594211 = query.getOrDefault("$filter")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "$filter", valid_594211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594212: Call_DeploymentsList_594204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of deployments.
  ## 
  let valid = call_594212.validator(path, query, header, formData, body)
  let scheme = call_594212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594212.url(scheme.get, call_594212.host, call_594212.base,
                         call_594212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594212, url, valid)

proc call*(call_594213: Call_DeploymentsList_594204; resourceGroupName: string;
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
  var path_594214 = newJObject()
  var query_594215 = newJObject()
  add(path_594214, "resourceGroupName", newJString(resourceGroupName))
  add(query_594215, "api-version", newJString(apiVersion))
  add(path_594214, "subscriptionId", newJString(subscriptionId))
  add(query_594215, "$top", newJInt(Top))
  add(query_594215, "$filter", newJString(Filter))
  result = call_594213.call(path_594214, query_594215, nil, nil, nil)

var deploymentsList* = Call_DeploymentsList_594204(name: "deploymentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsList_594205, base: "", url: url_DeploymentsList_594206,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdate_594227 = ref object of OpenApiRestCall_593437
proc url_DeploymentsCreateOrUpdate_594229(protocol: Scheme; host: string;
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

proc validate_DeploymentsCreateOrUpdate_594228(path: JsonNode; query: JsonNode;
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
  var valid_594230 = path.getOrDefault("resourceGroupName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "resourceGroupName", valid_594230
  var valid_594231 = path.getOrDefault("deploymentName")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "deploymentName", valid_594231
  var valid_594232 = path.getOrDefault("subscriptionId")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "subscriptionId", valid_594232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594233 = query.getOrDefault("api-version")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "api-version", valid_594233
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

proc call*(call_594235: Call_DeploymentsCreateOrUpdate_594227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a named template deployment using a template.
  ## 
  let valid = call_594235.validator(path, query, header, formData, body)
  let scheme = call_594235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594235.url(scheme.get, call_594235.host, call_594235.base,
                         call_594235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594235, url, valid)

proc call*(call_594236: Call_DeploymentsCreateOrUpdate_594227;
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
  var path_594237 = newJObject()
  var query_594238 = newJObject()
  var body_594239 = newJObject()
  add(path_594237, "resourceGroupName", newJString(resourceGroupName))
  add(query_594238, "api-version", newJString(apiVersion))
  add(path_594237, "deploymentName", newJString(deploymentName))
  add(path_594237, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594239 = parameters
  result = call_594236.call(path_594237, query_594238, nil, nil, body_594239)

var deploymentsCreateOrUpdate* = Call_DeploymentsCreateOrUpdate_594227(
    name: "deploymentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdate_594228, base: "",
    url: url_DeploymentsCreateOrUpdate_594229, schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistence_594251 = ref object of OpenApiRestCall_593437
proc url_DeploymentsCheckExistence_594253(protocol: Scheme; host: string;
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

proc validate_DeploymentsCheckExistence_594252(path: JsonNode; query: JsonNode;
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
  var valid_594254 = path.getOrDefault("resourceGroupName")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "resourceGroupName", valid_594254
  var valid_594255 = path.getOrDefault("deploymentName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "deploymentName", valid_594255
  var valid_594256 = path.getOrDefault("subscriptionId")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "subscriptionId", valid_594256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594257 = query.getOrDefault("api-version")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "api-version", valid_594257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594258: Call_DeploymentsCheckExistence_594251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether deployment exists.
  ## 
  let valid = call_594258.validator(path, query, header, formData, body)
  let scheme = call_594258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594258.url(scheme.get, call_594258.host, call_594258.base,
                         call_594258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594258, url, valid)

proc call*(call_594259: Call_DeploymentsCheckExistence_594251;
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
  var path_594260 = newJObject()
  var query_594261 = newJObject()
  add(path_594260, "resourceGroupName", newJString(resourceGroupName))
  add(query_594261, "api-version", newJString(apiVersion))
  add(path_594260, "deploymentName", newJString(deploymentName))
  add(path_594260, "subscriptionId", newJString(subscriptionId))
  result = call_594259.call(path_594260, query_594261, nil, nil, nil)

var deploymentsCheckExistence* = Call_DeploymentsCheckExistence_594251(
    name: "deploymentsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistence_594252, base: "",
    url: url_DeploymentsCheckExistence_594253, schemes: {Scheme.Https})
type
  Call_DeploymentsGet_594216 = ref object of OpenApiRestCall_593437
proc url_DeploymentsGet_594218(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsGet_594217(path: JsonNode; query: JsonNode;
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
  var valid_594219 = path.getOrDefault("resourceGroupName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "resourceGroupName", valid_594219
  var valid_594220 = path.getOrDefault("deploymentName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "deploymentName", valid_594220
  var valid_594221 = path.getOrDefault("subscriptionId")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "subscriptionId", valid_594221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_594223: Call_DeploymentsGet_594216; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a deployment.
  ## 
  let valid = call_594223.validator(path, query, header, formData, body)
  let scheme = call_594223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594223.url(scheme.get, call_594223.host, call_594223.base,
                         call_594223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594223, url, valid)

proc call*(call_594224: Call_DeploymentsGet_594216; resourceGroupName: string;
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
  var path_594225 = newJObject()
  var query_594226 = newJObject()
  add(path_594225, "resourceGroupName", newJString(resourceGroupName))
  add(query_594226, "api-version", newJString(apiVersion))
  add(path_594225, "deploymentName", newJString(deploymentName))
  add(path_594225, "subscriptionId", newJString(subscriptionId))
  result = call_594224.call(path_594225, query_594226, nil, nil, nil)

var deploymentsGet* = Call_DeploymentsGet_594216(name: "deploymentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGet_594217, base: "", url: url_DeploymentsGet_594218,
    schemes: {Scheme.Https})
type
  Call_DeploymentsDelete_594240 = ref object of OpenApiRestCall_593437
proc url_DeploymentsDelete_594242(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsDelete_594241(path: JsonNode; query: JsonNode;
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
  var valid_594243 = path.getOrDefault("resourceGroupName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "resourceGroupName", valid_594243
  var valid_594244 = path.getOrDefault("deploymentName")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "deploymentName", valid_594244
  var valid_594245 = path.getOrDefault("subscriptionId")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "subscriptionId", valid_594245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594246 = query.getOrDefault("api-version")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "api-version", valid_594246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594247: Call_DeploymentsDelete_594240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begin deleting deployment.To determine whether the operation has finished processing the request, call GetLongRunningOperationStatus.
  ## 
  let valid = call_594247.validator(path, query, header, formData, body)
  let scheme = call_594247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594247.url(scheme.get, call_594247.host, call_594247.base,
                         call_594247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594247, url, valid)

proc call*(call_594248: Call_DeploymentsDelete_594240; resourceGroupName: string;
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
  var path_594249 = newJObject()
  var query_594250 = newJObject()
  add(path_594249, "resourceGroupName", newJString(resourceGroupName))
  add(query_594250, "api-version", newJString(apiVersion))
  add(path_594249, "deploymentName", newJString(deploymentName))
  add(path_594249, "subscriptionId", newJString(subscriptionId))
  result = call_594248.call(path_594249, query_594250, nil, nil, nil)

var deploymentsDelete* = Call_DeploymentsDelete_594240(name: "deploymentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDelete_594241, base: "",
    url: url_DeploymentsDelete_594242, schemes: {Scheme.Https})
type
  Call_DeploymentsCancel_594262 = ref object of OpenApiRestCall_593437
proc url_DeploymentsCancel_594264(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsCancel_594263(path: JsonNode; query: JsonNode;
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
  var valid_594265 = path.getOrDefault("resourceGroupName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "resourceGroupName", valid_594265
  var valid_594266 = path.getOrDefault("deploymentName")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "deploymentName", valid_594266
  var valid_594267 = path.getOrDefault("subscriptionId")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "subscriptionId", valid_594267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594268 = query.getOrDefault("api-version")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "api-version", valid_594268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594269: Call_DeploymentsCancel_594262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a currently running template deployment.
  ## 
  let valid = call_594269.validator(path, query, header, formData, body)
  let scheme = call_594269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594269.url(scheme.get, call_594269.host, call_594269.base,
                         call_594269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594269, url, valid)

proc call*(call_594270: Call_DeploymentsCancel_594262; resourceGroupName: string;
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
  var path_594271 = newJObject()
  var query_594272 = newJObject()
  add(path_594271, "resourceGroupName", newJString(resourceGroupName))
  add(query_594272, "api-version", newJString(apiVersion))
  add(path_594271, "deploymentName", newJString(deploymentName))
  add(path_594271, "subscriptionId", newJString(subscriptionId))
  result = call_594270.call(path_594271, query_594272, nil, nil, nil)

var deploymentsCancel* = Call_DeploymentsCancel_594262(name: "deploymentsCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancel_594263, base: "",
    url: url_DeploymentsCancel_594264, schemes: {Scheme.Https})
type
  Call_DeploymentsValidate_594273 = ref object of OpenApiRestCall_593437
proc url_DeploymentsValidate_594275(protocol: Scheme; host: string; base: string;
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

proc validate_DeploymentsValidate_594274(path: JsonNode; query: JsonNode;
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
  var valid_594276 = path.getOrDefault("resourceGroupName")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "resourceGroupName", valid_594276
  var valid_594277 = path.getOrDefault("deploymentName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "deploymentName", valid_594277
  var valid_594278 = path.getOrDefault("subscriptionId")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "subscriptionId", valid_594278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594279 = query.getOrDefault("api-version")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "api-version", valid_594279
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

proc call*(call_594281: Call_DeploymentsValidate_594273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validate a deployment template.
  ## 
  let valid = call_594281.validator(path, query, header, formData, body)
  let scheme = call_594281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594281.url(scheme.get, call_594281.host, call_594281.base,
                         call_594281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594281, url, valid)

proc call*(call_594282: Call_DeploymentsValidate_594273; resourceGroupName: string;
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
  var path_594283 = newJObject()
  var query_594284 = newJObject()
  var body_594285 = newJObject()
  add(path_594283, "resourceGroupName", newJString(resourceGroupName))
  add(query_594284, "api-version", newJString(apiVersion))
  add(path_594283, "deploymentName", newJString(deploymentName))
  add(path_594283, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594285 = parameters
  result = call_594282.call(path_594283, query_594284, nil, nil, body_594285)

var deploymentsValidate* = Call_DeploymentsValidate_594273(
    name: "deploymentsValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidate_594274, base: "",
    url: url_DeploymentsValidate_594275, schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdate_594300 = ref object of OpenApiRestCall_593437
proc url_ResourcesCreateOrUpdate_594302(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesCreateOrUpdate_594301(path: JsonNode; query: JsonNode;
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
  var valid_594303 = path.getOrDefault("resourceType")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "resourceType", valid_594303
  var valid_594304 = path.getOrDefault("resourceGroupName")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "resourceGroupName", valid_594304
  var valid_594305 = path.getOrDefault("subscriptionId")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "subscriptionId", valid_594305
  var valid_594306 = path.getOrDefault("resourceName")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "resourceName", valid_594306
  var valid_594307 = path.getOrDefault("resourceProviderNamespace")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "resourceProviderNamespace", valid_594307
  var valid_594308 = path.getOrDefault("parentResourcePath")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "parentResourcePath", valid_594308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594309 = query.getOrDefault("api-version")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "api-version", valid_594309
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

proc call*(call_594311: Call_ResourcesCreateOrUpdate_594300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource.
  ## 
  let valid = call_594311.validator(path, query, header, formData, body)
  let scheme = call_594311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594311.url(scheme.get, call_594311.host, call_594311.base,
                         call_594311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594311, url, valid)

proc call*(call_594312: Call_ResourcesCreateOrUpdate_594300; resourceType: string;
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
  var path_594313 = newJObject()
  var query_594314 = newJObject()
  var body_594315 = newJObject()
  add(path_594313, "resourceType", newJString(resourceType))
  add(path_594313, "resourceGroupName", newJString(resourceGroupName))
  add(query_594314, "api-version", newJString(apiVersion))
  add(path_594313, "subscriptionId", newJString(subscriptionId))
  add(path_594313, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_594315 = parameters
  add(path_594313, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_594313, "parentResourcePath", newJString(parentResourcePath))
  result = call_594312.call(path_594313, query_594314, nil, nil, body_594315)

var resourcesCreateOrUpdate* = Call_ResourcesCreateOrUpdate_594300(
    name: "resourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCreateOrUpdate_594301, base: "",
    url: url_ResourcesCreateOrUpdate_594302, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistence_594330 = ref object of OpenApiRestCall_593437
proc url_ResourcesCheckExistence_594332(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesCheckExistence_594331(path: JsonNode; query: JsonNode;
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
  var valid_594333 = path.getOrDefault("resourceType")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "resourceType", valid_594333
  var valid_594334 = path.getOrDefault("resourceGroupName")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "resourceGroupName", valid_594334
  var valid_594335 = path.getOrDefault("subscriptionId")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "subscriptionId", valid_594335
  var valid_594336 = path.getOrDefault("resourceName")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "resourceName", valid_594336
  var valid_594337 = path.getOrDefault("resourceProviderNamespace")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "resourceProviderNamespace", valid_594337
  var valid_594338 = path.getOrDefault("parentResourcePath")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "parentResourcePath", valid_594338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594339 = query.getOrDefault("api-version")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "api-version", valid_594339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594340: Call_ResourcesCheckExistence_594330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether resource exists.
  ## 
  let valid = call_594340.validator(path, query, header, formData, body)
  let scheme = call_594340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594340.url(scheme.get, call_594340.host, call_594340.base,
                         call_594340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594340, url, valid)

proc call*(call_594341: Call_ResourcesCheckExistence_594330; resourceType: string;
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
  var path_594342 = newJObject()
  var query_594343 = newJObject()
  add(path_594342, "resourceType", newJString(resourceType))
  add(path_594342, "resourceGroupName", newJString(resourceGroupName))
  add(query_594343, "api-version", newJString(apiVersion))
  add(path_594342, "subscriptionId", newJString(subscriptionId))
  add(path_594342, "resourceName", newJString(resourceName))
  add(path_594342, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_594342, "parentResourcePath", newJString(parentResourcePath))
  result = call_594341.call(path_594342, query_594343, nil, nil, nil)

var resourcesCheckExistence* = Call_ResourcesCheckExistence_594330(
    name: "resourcesCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCheckExistence_594331, base: "",
    url: url_ResourcesCheckExistence_594332, schemes: {Scheme.Https})
type
  Call_ResourcesGet_594286 = ref object of OpenApiRestCall_593437
proc url_ResourcesGet_594288(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesGet_594287(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594289 = path.getOrDefault("resourceType")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "resourceType", valid_594289
  var valid_594290 = path.getOrDefault("resourceGroupName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "resourceGroupName", valid_594290
  var valid_594291 = path.getOrDefault("subscriptionId")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "subscriptionId", valid_594291
  var valid_594292 = path.getOrDefault("resourceName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "resourceName", valid_594292
  var valid_594293 = path.getOrDefault("resourceProviderNamespace")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "resourceProviderNamespace", valid_594293
  var valid_594294 = path.getOrDefault("parentResourcePath")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "parentResourcePath", valid_594294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594295 = query.getOrDefault("api-version")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "api-version", valid_594295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594296: Call_ResourcesGet_594286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a resource belonging to a resource group.
  ## 
  let valid = call_594296.validator(path, query, header, formData, body)
  let scheme = call_594296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594296.url(scheme.get, call_594296.host, call_594296.base,
                         call_594296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594296, url, valid)

proc call*(call_594297: Call_ResourcesGet_594286; resourceType: string;
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
  var path_594298 = newJObject()
  var query_594299 = newJObject()
  add(path_594298, "resourceType", newJString(resourceType))
  add(path_594298, "resourceGroupName", newJString(resourceGroupName))
  add(query_594299, "api-version", newJString(apiVersion))
  add(path_594298, "subscriptionId", newJString(subscriptionId))
  add(path_594298, "resourceName", newJString(resourceName))
  add(path_594298, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_594298, "parentResourcePath", newJString(parentResourcePath))
  result = call_594297.call(path_594298, query_594299, nil, nil, nil)

var resourcesGet* = Call_ResourcesGet_594286(name: "resourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesGet_594287, base: "", url: url_ResourcesGet_594288,
    schemes: {Scheme.Https})
type
  Call_ResourcesUpdate_594344 = ref object of OpenApiRestCall_593437
proc url_ResourcesUpdate_594346(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesUpdate_594345(path: JsonNode; query: JsonNode;
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
  var valid_594347 = path.getOrDefault("resourceType")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "resourceType", valid_594347
  var valid_594348 = path.getOrDefault("resourceGroupName")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "resourceGroupName", valid_594348
  var valid_594349 = path.getOrDefault("subscriptionId")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "subscriptionId", valid_594349
  var valid_594350 = path.getOrDefault("resourceName")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "resourceName", valid_594350
  var valid_594351 = path.getOrDefault("resourceProviderNamespace")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "resourceProviderNamespace", valid_594351
  var valid_594352 = path.getOrDefault("parentResourcePath")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "parentResourcePath", valid_594352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594353 = query.getOrDefault("api-version")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "api-version", valid_594353
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

proc call*(call_594355: Call_ResourcesUpdate_594344; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource.
  ## 
  let valid = call_594355.validator(path, query, header, formData, body)
  let scheme = call_594355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594355.url(scheme.get, call_594355.host, call_594355.base,
                         call_594355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594355, url, valid)

proc call*(call_594356: Call_ResourcesUpdate_594344; resourceType: string;
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
  var path_594357 = newJObject()
  var query_594358 = newJObject()
  var body_594359 = newJObject()
  add(path_594357, "resourceType", newJString(resourceType))
  add(path_594357, "resourceGroupName", newJString(resourceGroupName))
  add(query_594358, "api-version", newJString(apiVersion))
  add(path_594357, "subscriptionId", newJString(subscriptionId))
  add(path_594357, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_594359 = parameters
  add(path_594357, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_594357, "parentResourcePath", newJString(parentResourcePath))
  result = call_594356.call(path_594357, query_594358, nil, nil, body_594359)

var resourcesUpdate* = Call_ResourcesUpdate_594344(name: "resourcesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesUpdate_594345, base: "", url: url_ResourcesUpdate_594346,
    schemes: {Scheme.Https})
type
  Call_ResourcesDelete_594316 = ref object of OpenApiRestCall_593437
proc url_ResourcesDelete_594318(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesDelete_594317(path: JsonNode; query: JsonNode;
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
  var valid_594319 = path.getOrDefault("resourceType")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "resourceType", valid_594319
  var valid_594320 = path.getOrDefault("resourceGroupName")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "resourceGroupName", valid_594320
  var valid_594321 = path.getOrDefault("subscriptionId")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "subscriptionId", valid_594321
  var valid_594322 = path.getOrDefault("resourceName")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "resourceName", valid_594322
  var valid_594323 = path.getOrDefault("resourceProviderNamespace")
  valid_594323 = validateParameter(valid_594323, JString, required = true,
                                 default = nil)
  if valid_594323 != nil:
    section.add "resourceProviderNamespace", valid_594323
  var valid_594324 = path.getOrDefault("parentResourcePath")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "parentResourcePath", valid_594324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594325 = query.getOrDefault("api-version")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "api-version", valid_594325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594326: Call_ResourcesDelete_594316; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete resource and all of its resources. 
  ## 
  let valid = call_594326.validator(path, query, header, formData, body)
  let scheme = call_594326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594326.url(scheme.get, call_594326.host, call_594326.base,
                         call_594326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594326, url, valid)

proc call*(call_594327: Call_ResourcesDelete_594316; resourceType: string;
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
  var path_594328 = newJObject()
  var query_594329 = newJObject()
  add(path_594328, "resourceType", newJString(resourceType))
  add(path_594328, "resourceGroupName", newJString(resourceGroupName))
  add(query_594329, "api-version", newJString(apiVersion))
  add(path_594328, "subscriptionId", newJString(subscriptionId))
  add(path_594328, "resourceName", newJString(resourceName))
  add(path_594328, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_594328, "parentResourcePath", newJString(parentResourcePath))
  result = call_594327.call(path_594328, query_594329, nil, nil, nil)

var resourcesDelete* = Call_ResourcesDelete_594316(name: "resourcesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesDelete_594317, base: "", url: url_ResourcesDelete_594318,
    schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForResource_594360 = ref object of OpenApiRestCall_593437
proc url_PolicyAssignmentsListForResource_594362(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsListForResource_594361(path: JsonNode;
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
  var valid_594363 = path.getOrDefault("resourceType")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "resourceType", valid_594363
  var valid_594364 = path.getOrDefault("resourceGroupName")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "resourceGroupName", valid_594364
  var valid_594365 = path.getOrDefault("subscriptionId")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "subscriptionId", valid_594365
  var valid_594366 = path.getOrDefault("resourceName")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "resourceName", valid_594366
  var valid_594367 = path.getOrDefault("resourceProviderNamespace")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "resourceProviderNamespace", valid_594367
  var valid_594368 = path.getOrDefault("parentResourcePath")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "parentResourcePath", valid_594368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594369 = query.getOrDefault("api-version")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "api-version", valid_594369
  var valid_594370 = query.getOrDefault("$filter")
  valid_594370 = validateParameter(valid_594370, JString, required = false,
                                 default = nil)
  if valid_594370 != nil:
    section.add "$filter", valid_594370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594371: Call_PolicyAssignmentsListForResource_594360;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets policy assignments of the resource.
  ## 
  let valid = call_594371.validator(path, query, header, formData, body)
  let scheme = call_594371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594371.url(scheme.get, call_594371.host, call_594371.base,
                         call_594371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594371, url, valid)

proc call*(call_594372: Call_PolicyAssignmentsListForResource_594360;
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
  var path_594373 = newJObject()
  var query_594374 = newJObject()
  add(path_594373, "resourceType", newJString(resourceType))
  add(path_594373, "resourceGroupName", newJString(resourceGroupName))
  add(query_594374, "api-version", newJString(apiVersion))
  add(path_594373, "subscriptionId", newJString(subscriptionId))
  add(path_594373, "resourceName", newJString(resourceName))
  add(path_594373, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_594373, "parentResourcePath", newJString(parentResourcePath))
  add(query_594374, "$filter", newJString(Filter))
  result = call_594372.call(path_594373, query_594374, nil, nil, nil)

var policyAssignmentsListForResource* = Call_PolicyAssignmentsListForResource_594360(
    name: "policyAssignmentsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForResource_594361, base: "",
    url: url_PolicyAssignmentsListForResource_594362, schemes: {Scheme.Https})
type
  Call_ResourcesList_594375 = ref object of OpenApiRestCall_593437
proc url_ResourcesList_594377(protocol: Scheme; host: string; base: string;
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

proc validate_ResourcesList_594376(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594378 = path.getOrDefault("subscriptionId")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "subscriptionId", valid_594378
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
  var valid_594379 = query.getOrDefault("api-version")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "api-version", valid_594379
  var valid_594380 = query.getOrDefault("$top")
  valid_594380 = validateParameter(valid_594380, JInt, required = false, default = nil)
  if valid_594380 != nil:
    section.add "$top", valid_594380
  var valid_594381 = query.getOrDefault("$filter")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "$filter", valid_594381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594382: Call_ResourcesList_594375; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all of the resources under a subscription.
  ## 
  let valid = call_594382.validator(path, query, header, formData, body)
  let scheme = call_594382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594382.url(scheme.get, call_594382.host, call_594382.base,
                         call_594382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594382, url, valid)

proc call*(call_594383: Call_ResourcesList_594375; apiVersion: string;
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
  var path_594384 = newJObject()
  var query_594385 = newJObject()
  add(query_594385, "api-version", newJString(apiVersion))
  add(path_594384, "subscriptionId", newJString(subscriptionId))
  add(query_594385, "$top", newJInt(Top))
  add(query_594385, "$filter", newJString(Filter))
  result = call_594383.call(path_594384, query_594385, nil, nil, nil)

var resourcesList* = Call_ResourcesList_594375(name: "resourcesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resources",
    validator: validate_ResourcesList_594376, base: "", url: url_ResourcesList_594377,
    schemes: {Scheme.Https})
type
  Call_TagsList_594386 = ref object of OpenApiRestCall_593437
proc url_TagsList_594388(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TagsList_594387(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594389 = path.getOrDefault("subscriptionId")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "subscriptionId", valid_594389
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594390 = query.getOrDefault("api-version")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "api-version", valid_594390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594391: Call_TagsList_594386; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of subscription resource tags.
  ## 
  let valid = call_594391.validator(path, query, header, formData, body)
  let scheme = call_594391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594391.url(scheme.get, call_594391.host, call_594391.base,
                         call_594391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594391, url, valid)

proc call*(call_594392: Call_TagsList_594386; apiVersion: string;
          subscriptionId: string): Recallable =
  ## tagsList
  ## Get a list of subscription resource tags.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594393 = newJObject()
  var query_594394 = newJObject()
  add(query_594394, "api-version", newJString(apiVersion))
  add(path_594393, "subscriptionId", newJString(subscriptionId))
  result = call_594392.call(path_594393, query_594394, nil, nil, nil)

var tagsList* = Call_TagsList_594386(name: "tagsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames",
                                  validator: validate_TagsList_594387, base: "",
                                  url: url_TagsList_594388,
                                  schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdate_594395 = ref object of OpenApiRestCall_593437
proc url_TagsCreateOrUpdate_594397(protocol: Scheme; host: string; base: string;
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

proc validate_TagsCreateOrUpdate_594396(path: JsonNode; query: JsonNode;
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
  var valid_594398 = path.getOrDefault("tagName")
  valid_594398 = validateParameter(valid_594398, JString, required = true,
                                 default = nil)
  if valid_594398 != nil:
    section.add "tagName", valid_594398
  var valid_594399 = path.getOrDefault("subscriptionId")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "subscriptionId", valid_594399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594400 = query.getOrDefault("api-version")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "api-version", valid_594400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594401: Call_TagsCreateOrUpdate_594395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a subscription resource tag.
  ## 
  let valid = call_594401.validator(path, query, header, formData, body)
  let scheme = call_594401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594401.url(scheme.get, call_594401.host, call_594401.base,
                         call_594401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594401, url, valid)

proc call*(call_594402: Call_TagsCreateOrUpdate_594395; apiVersion: string;
          tagName: string; subscriptionId: string): Recallable =
  ## tagsCreateOrUpdate
  ## Create a subscription resource tag.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594403 = newJObject()
  var query_594404 = newJObject()
  add(query_594404, "api-version", newJString(apiVersion))
  add(path_594403, "tagName", newJString(tagName))
  add(path_594403, "subscriptionId", newJString(subscriptionId))
  result = call_594402.call(path_594403, query_594404, nil, nil, nil)

var tagsCreateOrUpdate* = Call_TagsCreateOrUpdate_594395(
    name: "tagsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
    validator: validate_TagsCreateOrUpdate_594396, base: "",
    url: url_TagsCreateOrUpdate_594397, schemes: {Scheme.Https})
type
  Call_TagsDelete_594405 = ref object of OpenApiRestCall_593437
proc url_TagsDelete_594407(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TagsDelete_594406(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594408 = path.getOrDefault("tagName")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "tagName", valid_594408
  var valid_594409 = path.getOrDefault("subscriptionId")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "subscriptionId", valid_594409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594410 = query.getOrDefault("api-version")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "api-version", valid_594410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594411: Call_TagsDelete_594405; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a subscription resource tag.
  ## 
  let valid = call_594411.validator(path, query, header, formData, body)
  let scheme = call_594411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594411.url(scheme.get, call_594411.host, call_594411.base,
                         call_594411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594411, url, valid)

proc call*(call_594412: Call_TagsDelete_594405; apiVersion: string; tagName: string;
          subscriptionId: string): Recallable =
  ## tagsDelete
  ## Delete a subscription resource tag.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594413 = newJObject()
  var query_594414 = newJObject()
  add(query_594414, "api-version", newJString(apiVersion))
  add(path_594413, "tagName", newJString(tagName))
  add(path_594413, "subscriptionId", newJString(subscriptionId))
  result = call_594412.call(path_594413, query_594414, nil, nil, nil)

var tagsDelete* = Call_TagsDelete_594405(name: "tagsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
                                      validator: validate_TagsDelete_594406,
                                      base: "", url: url_TagsDelete_594407,
                                      schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdateValue_594415 = ref object of OpenApiRestCall_593437
proc url_TagsCreateOrUpdateValue_594417(protocol: Scheme; host: string; base: string;
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

proc validate_TagsCreateOrUpdateValue_594416(path: JsonNode; query: JsonNode;
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
  var valid_594418 = path.getOrDefault("tagName")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "tagName", valid_594418
  var valid_594419 = path.getOrDefault("subscriptionId")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "subscriptionId", valid_594419
  var valid_594420 = path.getOrDefault("tagValue")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = nil)
  if valid_594420 != nil:
    section.add "tagValue", valid_594420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594421 = query.getOrDefault("api-version")
  valid_594421 = validateParameter(valid_594421, JString, required = true,
                                 default = nil)
  if valid_594421 != nil:
    section.add "api-version", valid_594421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594422: Call_TagsCreateOrUpdateValue_594415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a subscription resource tag value.
  ## 
  let valid = call_594422.validator(path, query, header, formData, body)
  let scheme = call_594422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594422.url(scheme.get, call_594422.host, call_594422.base,
                         call_594422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594422, url, valid)

proc call*(call_594423: Call_TagsCreateOrUpdateValue_594415; apiVersion: string;
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
  var path_594424 = newJObject()
  var query_594425 = newJObject()
  add(query_594425, "api-version", newJString(apiVersion))
  add(path_594424, "tagName", newJString(tagName))
  add(path_594424, "subscriptionId", newJString(subscriptionId))
  add(path_594424, "tagValue", newJString(tagValue))
  result = call_594423.call(path_594424, query_594425, nil, nil, nil)

var tagsCreateOrUpdateValue* = Call_TagsCreateOrUpdateValue_594415(
    name: "tagsCreateOrUpdateValue", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsCreateOrUpdateValue_594416, base: "",
    url: url_TagsCreateOrUpdateValue_594417, schemes: {Scheme.Https})
type
  Call_TagsDeleteValue_594426 = ref object of OpenApiRestCall_593437
proc url_TagsDeleteValue_594428(protocol: Scheme; host: string; base: string;
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

proc validate_TagsDeleteValue_594427(path: JsonNode; query: JsonNode;
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
  var valid_594429 = path.getOrDefault("tagName")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "tagName", valid_594429
  var valid_594430 = path.getOrDefault("subscriptionId")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "subscriptionId", valid_594430
  var valid_594431 = path.getOrDefault("tagValue")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "tagValue", valid_594431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594432 = query.getOrDefault("api-version")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "api-version", valid_594432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594433: Call_TagsDeleteValue_594426; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a subscription resource tag value.
  ## 
  let valid = call_594433.validator(path, query, header, formData, body)
  let scheme = call_594433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594433.url(scheme.get, call_594433.host, call_594433.base,
                         call_594433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594433, url, valid)

proc call*(call_594434: Call_TagsDeleteValue_594426; apiVersion: string;
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
  var path_594435 = newJObject()
  var query_594436 = newJObject()
  add(query_594436, "api-version", newJString(apiVersion))
  add(path_594435, "tagName", newJString(tagName))
  add(path_594435, "subscriptionId", newJString(subscriptionId))
  add(path_594435, "tagValue", newJString(tagValue))
  result = call_594434.call(path_594435, query_594436, nil, nil, nil)

var tagsDeleteValue* = Call_TagsDeleteValue_594426(name: "tagsDeleteValue",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsDeleteValue_594427, base: "", url: url_TagsDeleteValue_594428,
    schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsCreateById_594446 = ref object of OpenApiRestCall_593437
proc url_PolicyAssignmentsCreateById_594448(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsCreateById_594447(path: JsonNode; query: JsonNode;
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
  var valid_594449 = path.getOrDefault("policyAssignmentId")
  valid_594449 = validateParameter(valid_594449, JString, required = true,
                                 default = nil)
  if valid_594449 != nil:
    section.add "policyAssignmentId", valid_594449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594450 = query.getOrDefault("api-version")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "api-version", valid_594450
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

proc call*(call_594452: Call_PolicyAssignmentsCreateById_594446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create policy assignment by Id.
  ## 
  let valid = call_594452.validator(path, query, header, formData, body)
  let scheme = call_594452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594452.url(scheme.get, call_594452.host, call_594452.base,
                         call_594452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594452, url, valid)

proc call*(call_594453: Call_PolicyAssignmentsCreateById_594446;
          apiVersion: string; parameters: JsonNode; policyAssignmentId: string): Recallable =
  ## policyAssignmentsCreateById
  ## Create policy assignment by Id.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : Policy assignment.
  ##   policyAssignmentId: string (required)
  ##                     : Policy assignment Id
  var path_594454 = newJObject()
  var query_594455 = newJObject()
  var body_594456 = newJObject()
  add(query_594455, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594456 = parameters
  add(path_594454, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_594453.call(path_594454, query_594455, nil, nil, body_594456)

var policyAssignmentsCreateById* = Call_PolicyAssignmentsCreateById_594446(
    name: "policyAssignmentsCreateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsCreateById_594447, base: "",
    url: url_PolicyAssignmentsCreateById_594448, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsGetById_594437 = ref object of OpenApiRestCall_593437
proc url_PolicyAssignmentsGetById_594439(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsGetById_594438(path: JsonNode; query: JsonNode;
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
  var valid_594440 = path.getOrDefault("policyAssignmentId")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "policyAssignmentId", valid_594440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594441 = query.getOrDefault("api-version")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "api-version", valid_594441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594442: Call_PolicyAssignmentsGetById_594437; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get single policy assignment.
  ## 
  let valid = call_594442.validator(path, query, header, formData, body)
  let scheme = call_594442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594442.url(scheme.get, call_594442.host, call_594442.base,
                         call_594442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594442, url, valid)

proc call*(call_594443: Call_PolicyAssignmentsGetById_594437; apiVersion: string;
          policyAssignmentId: string): Recallable =
  ## policyAssignmentsGetById
  ## Get single policy assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   policyAssignmentId: string (required)
  ##                     : Policy assignment Id
  var path_594444 = newJObject()
  var query_594445 = newJObject()
  add(query_594445, "api-version", newJString(apiVersion))
  add(path_594444, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_594443.call(path_594444, query_594445, nil, nil, nil)

var policyAssignmentsGetById* = Call_PolicyAssignmentsGetById_594437(
    name: "policyAssignmentsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsGetById_594438, base: "",
    url: url_PolicyAssignmentsGetById_594439, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsDeleteById_594457 = ref object of OpenApiRestCall_593437
proc url_PolicyAssignmentsDeleteById_594459(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsDeleteById_594458(path: JsonNode; query: JsonNode;
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
  var valid_594460 = path.getOrDefault("policyAssignmentId")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "policyAssignmentId", valid_594460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594461 = query.getOrDefault("api-version")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "api-version", valid_594461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594462: Call_PolicyAssignmentsDeleteById_594457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy assignment.
  ## 
  let valid = call_594462.validator(path, query, header, formData, body)
  let scheme = call_594462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594462.url(scheme.get, call_594462.host, call_594462.base,
                         call_594462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594462, url, valid)

proc call*(call_594463: Call_PolicyAssignmentsDeleteById_594457;
          apiVersion: string; policyAssignmentId: string): Recallable =
  ## policyAssignmentsDeleteById
  ## Delete policy assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   policyAssignmentId: string (required)
  ##                     : Policy assignment Id
  var path_594464 = newJObject()
  var query_594465 = newJObject()
  add(query_594465, "api-version", newJString(apiVersion))
  add(path_594464, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_594463.call(path_594464, query_594465, nil, nil, nil)

var policyAssignmentsDeleteById* = Call_PolicyAssignmentsDeleteById_594457(
    name: "policyAssignmentsDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsDeleteById_594458, base: "",
    url: url_PolicyAssignmentsDeleteById_594459, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForScope_594466 = ref object of OpenApiRestCall_593437
proc url_PolicyAssignmentsListForScope_594468(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsListForScope_594467(path: JsonNode; query: JsonNode;
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
  var valid_594469 = path.getOrDefault("scope")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "scope", valid_594469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594470 = query.getOrDefault("api-version")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "api-version", valid_594470
  var valid_594471 = query.getOrDefault("$filter")
  valid_594471 = validateParameter(valid_594471, JString, required = false,
                                 default = nil)
  if valid_594471 != nil:
    section.add "$filter", valid_594471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594472: Call_PolicyAssignmentsListForScope_594466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets policy assignments of the scope.
  ## 
  let valid = call_594472.validator(path, query, header, formData, body)
  let scheme = call_594472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594472.url(scheme.get, call_594472.host, call_594472.base,
                         call_594472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594472, url, valid)

proc call*(call_594473: Call_PolicyAssignmentsListForScope_594466;
          apiVersion: string; scope: string; Filter: string = ""): Recallable =
  ## policyAssignmentsListForScope
  ## Gets policy assignments of the scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   scope: string (required)
  ##        : Scope.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594474 = newJObject()
  var query_594475 = newJObject()
  add(query_594475, "api-version", newJString(apiVersion))
  add(path_594474, "scope", newJString(scope))
  add(query_594475, "$filter", newJString(Filter))
  result = call_594473.call(path_594474, query_594475, nil, nil, nil)

var policyAssignmentsListForScope* = Call_PolicyAssignmentsListForScope_594466(
    name: "policyAssignmentsListForScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForScope_594467, base: "",
    url: url_PolicyAssignmentsListForScope_594468, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsCreate_594486 = ref object of OpenApiRestCall_593437
proc url_PolicyAssignmentsCreate_594488(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyAssignmentsCreate_594487(path: JsonNode; query: JsonNode;
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
  var valid_594489 = path.getOrDefault("policyAssignmentName")
  valid_594489 = validateParameter(valid_594489, JString, required = true,
                                 default = nil)
  if valid_594489 != nil:
    section.add "policyAssignmentName", valid_594489
  var valid_594490 = path.getOrDefault("scope")
  valid_594490 = validateParameter(valid_594490, JString, required = true,
                                 default = nil)
  if valid_594490 != nil:
    section.add "scope", valid_594490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594491 = query.getOrDefault("api-version")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "api-version", valid_594491
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

proc call*(call_594493: Call_PolicyAssignmentsCreate_594486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create policy assignment.
  ## 
  let valid = call_594493.validator(path, query, header, formData, body)
  let scheme = call_594493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594493.url(scheme.get, call_594493.host, call_594493.base,
                         call_594493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594493, url, valid)

proc call*(call_594494: Call_PolicyAssignmentsCreate_594486; apiVersion: string;
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
  var path_594495 = newJObject()
  var query_594496 = newJObject()
  var body_594497 = newJObject()
  add(query_594496, "api-version", newJString(apiVersion))
  add(path_594495, "policyAssignmentName", newJString(policyAssignmentName))
  if parameters != nil:
    body_594497 = parameters
  add(path_594495, "scope", newJString(scope))
  result = call_594494.call(path_594495, query_594496, nil, nil, body_594497)

var policyAssignmentsCreate* = Call_PolicyAssignmentsCreate_594486(
    name: "policyAssignmentsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsCreate_594487, base: "",
    url: url_PolicyAssignmentsCreate_594488, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsGet_594476 = ref object of OpenApiRestCall_593437
proc url_PolicyAssignmentsGet_594478(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyAssignmentsGet_594477(path: JsonNode; query: JsonNode;
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
  var valid_594479 = path.getOrDefault("policyAssignmentName")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "policyAssignmentName", valid_594479
  var valid_594480 = path.getOrDefault("scope")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "scope", valid_594480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594481 = query.getOrDefault("api-version")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "api-version", valid_594481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594482: Call_PolicyAssignmentsGet_594476; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get single policy assignment.
  ## 
  let valid = call_594482.validator(path, query, header, formData, body)
  let scheme = call_594482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594482.url(scheme.get, call_594482.host, call_594482.base,
                         call_594482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594482, url, valid)

proc call*(call_594483: Call_PolicyAssignmentsGet_594476; apiVersion: string;
          policyAssignmentName: string; scope: string): Recallable =
  ## policyAssignmentsGet
  ## Get single policy assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   scope: string (required)
  ##        : Scope.
  var path_594484 = newJObject()
  var query_594485 = newJObject()
  add(query_594485, "api-version", newJString(apiVersion))
  add(path_594484, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_594484, "scope", newJString(scope))
  result = call_594483.call(path_594484, query_594485, nil, nil, nil)

var policyAssignmentsGet* = Call_PolicyAssignmentsGet_594476(
    name: "policyAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsGet_594477, base: "",
    url: url_PolicyAssignmentsGet_594478, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsDelete_594498 = ref object of OpenApiRestCall_593437
proc url_PolicyAssignmentsDelete_594500(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyAssignmentsDelete_594499(path: JsonNode; query: JsonNode;
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
  var valid_594501 = path.getOrDefault("policyAssignmentName")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "policyAssignmentName", valid_594501
  var valid_594502 = path.getOrDefault("scope")
  valid_594502 = validateParameter(valid_594502, JString, required = true,
                                 default = nil)
  if valid_594502 != nil:
    section.add "scope", valid_594502
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594503: Call_PolicyAssignmentsDelete_594498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy assignment.
  ## 
  let valid = call_594503.validator(path, query, header, formData, body)
  let scheme = call_594503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594503.url(scheme.get, call_594503.host, call_594503.base,
                         call_594503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594503, url, valid)

proc call*(call_594504: Call_PolicyAssignmentsDelete_594498;
          policyAssignmentName: string; scope: string): Recallable =
  ## policyAssignmentsDelete
  ## Delete policy assignment.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   scope: string (required)
  ##        : Scope.
  var path_594505 = newJObject()
  add(path_594505, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_594505, "scope", newJString(scope))
  result = call_594504.call(path_594505, nil, nil, nil, nil)

var policyAssignmentsDelete* = Call_PolicyAssignmentsDelete_594498(
    name: "policyAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsDelete_594499, base: "",
    url: url_PolicyAssignmentsDelete_594500, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
