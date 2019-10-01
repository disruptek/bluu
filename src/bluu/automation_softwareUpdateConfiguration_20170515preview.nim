
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Update Management
## version: 2017-05-15-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## APIs for managing software update configurations.
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

  OpenApiRestCall_596458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596458): Option[Scheme] {.used.} =
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
  macServiceName = "automation-softwareUpdateConfiguration"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SoftwareUpdateConfigurationsList_596680 = ref object of OpenApiRestCall_596458
proc url_SoftwareUpdateConfigurationsList_596682(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/softwareUpdateConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwareUpdateConfigurationsList_596681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all software update configurations for the account.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_596843 = path.getOrDefault("automationAccountName")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "automationAccountName", valid_596843
  var valid_596844 = path.getOrDefault("resourceGroupName")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "resourceGroupName", valid_596844
  var valid_596845 = path.getOrDefault("subscriptionId")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "subscriptionId", valid_596845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596846 = query.getOrDefault("api-version")
  valid_596846 = validateParameter(valid_596846, JString, required = true,
                                 default = nil)
  if valid_596846 != nil:
    section.add "api-version", valid_596846
  var valid_596847 = query.getOrDefault("$filter")
  valid_596847 = validateParameter(valid_596847, JString, required = false,
                                 default = nil)
  if valid_596847 != nil:
    section.add "$filter", valid_596847
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_596848 = header.getOrDefault("clientRequestId")
  valid_596848 = validateParameter(valid_596848, JString, required = false,
                                 default = nil)
  if valid_596848 != nil:
    section.add "clientRequestId", valid_596848
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596875: Call_SoftwareUpdateConfigurationsList_596680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all software update configurations for the account.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_596875.validator(path, query, header, formData, body)
  let scheme = call_596875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596875.url(scheme.get, call_596875.host, call_596875.base,
                         call_596875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596875, url, valid)

proc call*(call_596946: Call_SoftwareUpdateConfigurationsList_596680;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## softwareUpdateConfigurationsList
  ## Get all software update configurations for the account.
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_596947 = newJObject()
  var query_596949 = newJObject()
  add(path_596947, "automationAccountName", newJString(automationAccountName))
  add(path_596947, "resourceGroupName", newJString(resourceGroupName))
  add(query_596949, "api-version", newJString(apiVersion))
  add(path_596947, "subscriptionId", newJString(subscriptionId))
  add(query_596949, "$filter", newJString(Filter))
  result = call_596946.call(path_596947, query_596949, nil, nil, nil)

var softwareUpdateConfigurationsList* = Call_SoftwareUpdateConfigurationsList_596680(
    name: "softwareUpdateConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurations",
    validator: validate_SoftwareUpdateConfigurationsList_596681, base: "/",
    url: url_SoftwareUpdateConfigurationsList_596682, schemes: {Scheme.Https})
type
  Call_SoftwareUpdateConfigurationsCreate_597001 = ref object of OpenApiRestCall_596458
proc url_SoftwareUpdateConfigurationsCreate_597003(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "softwareUpdateConfigurationName" in path,
        "`softwareUpdateConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"), (
        kind: ConstantSegment, value: "/softwareUpdateConfigurations/"), (
        kind: VariableSegment, value: "softwareUpdateConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwareUpdateConfigurationsCreate_597002(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new software update configuration with the name given in the URI.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   softwareUpdateConfigurationName: JString (required)
  ##                                  : The name of the software update configuration to be created.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597013 = path.getOrDefault("automationAccountName")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "automationAccountName", valid_597013
  var valid_597014 = path.getOrDefault("resourceGroupName")
  valid_597014 = validateParameter(valid_597014, JString, required = true,
                                 default = nil)
  if valid_597014 != nil:
    section.add "resourceGroupName", valid_597014
  var valid_597015 = path.getOrDefault("softwareUpdateConfigurationName")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "softwareUpdateConfigurationName", valid_597015
  var valid_597016 = path.getOrDefault("subscriptionId")
  valid_597016 = validateParameter(valid_597016, JString, required = true,
                                 default = nil)
  if valid_597016 != nil:
    section.add "subscriptionId", valid_597016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597017 = query.getOrDefault("api-version")
  valid_597017 = validateParameter(valid_597017, JString, required = true,
                                 default = nil)
  if valid_597017 != nil:
    section.add "api-version", valid_597017
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_597018 = header.getOrDefault("clientRequestId")
  valid_597018 = validateParameter(valid_597018, JString, required = false,
                                 default = nil)
  if valid_597018 != nil:
    section.add "clientRequestId", valid_597018
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597020: Call_SoftwareUpdateConfigurationsCreate_597001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new software update configuration with the name given in the URI.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_597020.validator(path, query, header, formData, body)
  let scheme = call_597020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597020.url(scheme.get, call_597020.host, call_597020.base,
                         call_597020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597020, url, valid)

proc call*(call_597021: Call_SoftwareUpdateConfigurationsCreate_597001;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; softwareUpdateConfigurationName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## softwareUpdateConfigurationsCreate
  ## Create a new software update configuration with the name given in the URI.
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   softwareUpdateConfigurationName: string (required)
  ##                                  : The name of the software update configuration to be created.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Request body.
  var path_597022 = newJObject()
  var query_597023 = newJObject()
  var body_597024 = newJObject()
  add(path_597022, "automationAccountName", newJString(automationAccountName))
  add(path_597022, "resourceGroupName", newJString(resourceGroupName))
  add(query_597023, "api-version", newJString(apiVersion))
  add(path_597022, "softwareUpdateConfigurationName",
      newJString(softwareUpdateConfigurationName))
  add(path_597022, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597024 = parameters
  result = call_597021.call(path_597022, query_597023, nil, nil, body_597024)

var softwareUpdateConfigurationsCreate* = Call_SoftwareUpdateConfigurationsCreate_597001(
    name: "softwareUpdateConfigurationsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurations/{softwareUpdateConfigurationName}",
    validator: validate_SoftwareUpdateConfigurationsCreate_597002, base: "/",
    url: url_SoftwareUpdateConfigurationsCreate_597003, schemes: {Scheme.Https})
type
  Call_SoftwareUpdateConfigurationsGetByName_596988 = ref object of OpenApiRestCall_596458
proc url_SoftwareUpdateConfigurationsGetByName_596990(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "softwareUpdateConfigurationName" in path,
        "`softwareUpdateConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"), (
        kind: ConstantSegment, value: "/softwareUpdateConfigurations/"), (
        kind: VariableSegment, value: "softwareUpdateConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwareUpdateConfigurationsGetByName_596989(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single software update configuration by name.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   softwareUpdateConfigurationName: JString (required)
  ##                                  : The name of the software update configuration to be created.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_596991 = path.getOrDefault("automationAccountName")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "automationAccountName", valid_596991
  var valid_596992 = path.getOrDefault("resourceGroupName")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "resourceGroupName", valid_596992
  var valid_596993 = path.getOrDefault("softwareUpdateConfigurationName")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "softwareUpdateConfigurationName", valid_596993
  var valid_596994 = path.getOrDefault("subscriptionId")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "subscriptionId", valid_596994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596995 = query.getOrDefault("api-version")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "api-version", valid_596995
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_596996 = header.getOrDefault("clientRequestId")
  valid_596996 = validateParameter(valid_596996, JString, required = false,
                                 default = nil)
  if valid_596996 != nil:
    section.add "clientRequestId", valid_596996
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596997: Call_SoftwareUpdateConfigurationsGetByName_596988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a single software update configuration by name.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_596997.validator(path, query, header, formData, body)
  let scheme = call_596997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596997.url(scheme.get, call_596997.host, call_596997.base,
                         call_596997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596997, url, valid)

proc call*(call_596998: Call_SoftwareUpdateConfigurationsGetByName_596988;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; softwareUpdateConfigurationName: string;
          subscriptionId: string): Recallable =
  ## softwareUpdateConfigurationsGetByName
  ## Get a single software update configuration by name.
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   softwareUpdateConfigurationName: string (required)
  ##                                  : The name of the software update configuration to be created.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_596999 = newJObject()
  var query_597000 = newJObject()
  add(path_596999, "automationAccountName", newJString(automationAccountName))
  add(path_596999, "resourceGroupName", newJString(resourceGroupName))
  add(query_597000, "api-version", newJString(apiVersion))
  add(path_596999, "softwareUpdateConfigurationName",
      newJString(softwareUpdateConfigurationName))
  add(path_596999, "subscriptionId", newJString(subscriptionId))
  result = call_596998.call(path_596999, query_597000, nil, nil, nil)

var softwareUpdateConfigurationsGetByName* = Call_SoftwareUpdateConfigurationsGetByName_596988(
    name: "softwareUpdateConfigurationsGetByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurations/{softwareUpdateConfigurationName}",
    validator: validate_SoftwareUpdateConfigurationsGetByName_596989, base: "/",
    url: url_SoftwareUpdateConfigurationsGetByName_596990, schemes: {Scheme.Https})
type
  Call_SoftwareUpdateConfigurationsDelete_597025 = ref object of OpenApiRestCall_596458
proc url_SoftwareUpdateConfigurationsDelete_597027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "softwareUpdateConfigurationName" in path,
        "`softwareUpdateConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"), (
        kind: ConstantSegment, value: "/softwareUpdateConfigurations/"), (
        kind: VariableSegment, value: "softwareUpdateConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwareUpdateConfigurationsDelete_597026(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## delete a specific software update configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   softwareUpdateConfigurationName: JString (required)
  ##                                  : The name of the software update configuration to be created.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_597028 = path.getOrDefault("automationAccountName")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "automationAccountName", valid_597028
  var valid_597029 = path.getOrDefault("resourceGroupName")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "resourceGroupName", valid_597029
  var valid_597030 = path.getOrDefault("softwareUpdateConfigurationName")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "softwareUpdateConfigurationName", valid_597030
  var valid_597031 = path.getOrDefault("subscriptionId")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "subscriptionId", valid_597031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597032 = query.getOrDefault("api-version")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "api-version", valid_597032
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_597033 = header.getOrDefault("clientRequestId")
  valid_597033 = validateParameter(valid_597033, JString, required = false,
                                 default = nil)
  if valid_597033 != nil:
    section.add "clientRequestId", valid_597033
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597034: Call_SoftwareUpdateConfigurationsDelete_597025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## delete a specific software update configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_597034.validator(path, query, header, formData, body)
  let scheme = call_597034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597034.url(scheme.get, call_597034.host, call_597034.base,
                         call_597034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597034, url, valid)

proc call*(call_597035: Call_SoftwareUpdateConfigurationsDelete_597025;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; softwareUpdateConfigurationName: string;
          subscriptionId: string): Recallable =
  ## softwareUpdateConfigurationsDelete
  ## delete a specific software update configuration.
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   softwareUpdateConfigurationName: string (required)
  ##                                  : The name of the software update configuration to be created.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_597036 = newJObject()
  var query_597037 = newJObject()
  add(path_597036, "automationAccountName", newJString(automationAccountName))
  add(path_597036, "resourceGroupName", newJString(resourceGroupName))
  add(query_597037, "api-version", newJString(apiVersion))
  add(path_597036, "softwareUpdateConfigurationName",
      newJString(softwareUpdateConfigurationName))
  add(path_597036, "subscriptionId", newJString(subscriptionId))
  result = call_597035.call(path_597036, query_597037, nil, nil, nil)

var softwareUpdateConfigurationsDelete* = Call_SoftwareUpdateConfigurationsDelete_597025(
    name: "softwareUpdateConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurations/{softwareUpdateConfigurationName}",
    validator: validate_SoftwareUpdateConfigurationsDelete_597026, base: "/",
    url: url_SoftwareUpdateConfigurationsDelete_597027, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
